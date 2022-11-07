codeunit 98005 "Payroll Functions"
{
    // version PY1.0,EDM.HRPY1
    // PY5.0 : put sickness and maternity in payslips
    // PY4.2 : fix calculate of Female with not secured spouse
    // MB.01 : Fix PaySlips Transportation Parts
    // MB.1605A : Add new Functionality of Linked Pay Element On Slip

    trigger OnRun();
    begin
    end;

    var
        PayParam: Record "Payroll Parameter";
        Loop: Integer;
        Paystatus: Record "Payroll Status";
        Window: Dialog;
        HRSetup: Record "Human Resources Setup";
        MyPayElement: Record "Pay Element";
        MyPayrollGroup: Record "HR Payroll Group";
        MyUpdatedReportID: Integer;
        EDMUtility: Codeunit "EDM Utility";
        GLEntry: Record "G/L Entry";
        DimensionSetEntry: Record "Dimension Set Entry";
        PayLedgEntryNo: Integer;
        PayLedgEntry: Record "Payroll Ledger Entry";
        PayDetailLine2: Record "Pay Detail Line";
        LineNo: Integer;
        HumanResSetup: Record "Human Resources Setup";
        GLSetup: Record "General Ledger Setup";
        WorkflowManagement: Codeunit "Workflow Management";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        PayParameter: Record "Payroll Parameter";
        BasicPrevious: Decimal;
        CostofLivingPrevious: Decimal;
        PhoneAllPrevous: Decimal;
        CarAllPrevious: Decimal;
        HouseAllPrevious: Decimal;
        FoodAllPrevious: Decimal;
        TicketAllPrevious: Decimal;
        OtherAllPrevious: Decimal;
        InsurencePrevious: Decimal;
        TotalPrevious: Decimal;
        ExtraSalaryPrevious: Decimal;
        EmpAddInfo: Record "Employee Additional Info";

    procedure CalculateTaxCode(PayEmp: Record Employee; P_ApplySpeCases: Boolean; var P_SpouseExemptTax: Boolean; ToTaxCode: Date): Decimal;
    var
        EligibleTaxRebate: Decimal;
        NoOfEligibleChilds: Integer;
        SpouseWorking: Boolean;
        RecordFound: Boolean;
        PayParam: Record "Payroll Parameter";
        TaxAmount: Decimal;
        Employee: Record Employee;
    begin
        // P_ApplySpeCases used for the future when need to compute based on amendments in middle of the month.
        P_SpouseExemptTax := false;
        if PayEmp."No." = '' then
            exit(0);
        if PayEmp.Gender = PayEmp.Gender::" " then
            exit(0);
        if (PayEmp.Declared = PayEmp.Declared::"Non-Declared") or (PayEmp.Declared = PayEmp.Declared::Contractual) then
            exit(0);

        PayParam.GET;
        CASE PayParam."Payroll Labor Law" OF
            PayParam."Payroll Labor Law"::Nigeria:
                BEGIN
                    //FORMULA = (200000 / 12) + (Total TAXABLE * 28%) + (Life Insurance Premium / 12)
                    TaxAmount := (PayParam."Tax Exempt P/Y Single" / 12);
                    TaxAmount += (GetTaxableSalary(PayEmp."No.", ToTaxCode, ToTaxCode) * (PayParam."Exemption % from Taxable" / 100));
                    IF EmpAddInfo.GET(PayEmp."No.") THEN
                        TaxAmount += (EmpAddInfo."Life Insurance Premium" / 12);

                    TaxAmount := TaxAmount * 12 // Multiplied by 12 to be for 12 Months
                END;
            PayParam."Payroll Labor Law"::Egypt:
                BEGIN
                    //FORMULA = (14,200 / 12) + NSSF Fixed of EMPLOYEE + NSSF VARIABLE of EMPLOYEE
                    TaxAmount := (PayParam."Tax Exempt P/Y Single" / 12);
                    TaxAmount += (GetNSSFAmountOfTypeClassification(PayEmp."No.", ToTaxCode, ToTaxCode, 1) *  // 1 => FIXED
                                 (GetNSSFPercentOfTypeClassification(PayEmp."No.", 1) / 100));                // 1 => FIXED
                    TaxAmount += (GetNSSFAmountOfTypeClassification(PayEmp."No.", ToTaxCode, ToTaxCode, 2) *  // 2 => VARIABLE
                                 (GetNSSFPercentOfTypeClassification(PayEmp."No.", 2) / 100));                // 2 => VARIABLE
                    TaxAmount := TaxAmount * 12 // Multiplied by 12 to be for 12 Months
                END;
            PayParam."Payroll Labor Law"::Iraq:
                BEGIN
                    //FORMULA = (12,000 000 / 12) 
                    TaxAmount := PayParam."Tax Exempt P/Y Single";
                END;
            PayParam."Payroll Labor Law"::Lebanon:
                BEGIN
                    EligibleTaxRebate := PayParam."Tax Exempt P/Y Single";
                    IF (PayEmp."Social Status" <> PayEmp."Social Status"::Single) AND
                       (PayEmp."Social Status" <> PayEmp."Social Status"::Divorced) AND
                       (PayEmp."Social Status" <> PayEmp."Social Status"::Widow) THEN BEGIN
                        IF ((PayEmp.Gender = PayEmp.Gender::Male) AND (NOT PayEmp."Spouse Secured")) OR
                           ((PayEmp.Gender = PayEmp.Gender::Female) AND ((PayEmp."Husband Paralyzed"))) THEN BEGIN
                            EligibleTaxRebate := EligibleTaxRebate + PayParam."Tax Exempt P/Y NonWork Spouse";
                            P_SpouseExemptTax := TRUE;
                            IF (PayEmp.Foreigner = PayEmp.Foreigner::"End of Service") AND (PayEmp.Declared = PayEmp.Declared::Declared) THEN BEGIN
                                EligibleTaxRebate := PayParam."Tax Exempt P/Y Single";
                                P_SpouseExemptTax := FALSE;
                            END;
                        END; //spouseExemptTax
                    END; // <> singlen   ,

                    NoOfEligibleChilds := GetNoOfEligibleChildsExemptTax(PayEmp, 1, ToTaxCode);
                    IF PayEmp."Social Status" <> PayEmp."Social Status"::Divorced THEN BEGIN
                        if (PayEmp."Spouse Secured") then //PY4.2 
                            EligibleTaxRebate := EligibleTaxRebate + (PayParam."Tax Exempt P/Y Per Child" / 2 * NoOfEligibleChilds)
                        else
                            EligibleTaxRebate := EligibleTaxRebate + (PayParam."Tax Exempt P/Y Per Child" * NoOfEligibleChilds);
                    end else
                        if not PayEmp."Divorced Spouse Child. Resp." then
                            EligibleTaxRebate := EligibleTaxRebate + (PayParam."Tax Exempt P/Y Per Child" * NoOfEligibleChilds);

                    TaxAmount := EligibleTaxRebate;
                END;
        END;

        EXIT(TaxAmount);
    end;

    procedure GetNoOfEligibleChilds(Employee: Record Employee; TaxType: Option NSSF,TAX,EST,FA; TaxToDate: Date): Integer;
    var
        NoOfEligibleChilds: Integer;
        EmpRelative: Record "Employee Relative";
        AgeLimit: Text[30];
        ChildBirthDate: Date;
        MINDATE: Date;
        MAXDATE: Date;
        Sex: Option Male,Female;
    begin
        PayParam.GET;
        NoOfEligibleChilds := 0;
        CLEAR(EmpRelative);
        EmpRelative.SETRANGE(EmpRelative."Employee No.", Employee."No.");
        EmpRelative.SETRANGE("Eligible Child", true);
        //AIM +
        EmpRelative.SETRANGE(Type, EmpRelative.Type::Child);
        //AIM -
        if (TaxType = TaxType::NSSF) or (TaxType = TaxType::TAX) then begin
            EmpRelative.SETFILTER("Registeration Start Date", '=%1|<=%2', 0D, TaxToDate);
            EmpRelative.SETFILTER("Registeration End Date", '=%1|>=%2', 0D, TaxToDate);
        end;
        while EmpRelative.NEXT <> 0 do begin
            ChildBirthDate := 0D;

            if EmpRelative."Birth Date" <> 0D then begin

                if (EmpRelative.Sex = EmpRelative.Sex::Female) or (EmpRelative.Student = EmpRelative.Student::Yes) then begin
                    AgeLimit := FORMAT(PayParam."Max. Pension Age") + 'Y';
                    ChildBirthDate := CALCDATE(AgeLimit, EmpRelative."Birth Date");
                end
                else begin
                    AgeLimit := FORMAT(PayParam."Max. Pension Age") + 'Y';
                    ChildBirthDate := CALCDATE(AgeLimit, EmpRelative."Birth Date");
                end;

            end;

            if not EmpRelative.Working then begin
                NoOfEligibleChilds := NoOfEligibleChilds + 1;
                //EDM+
                if TaxToDate = 0D then begin
                    MAXDATE := DMY2DATE(15, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
                    MINDATE := DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
                end
                else begin
                    MAXDATE := TaxToDate;
                    MINDATE := CALCDATE('-1M', MAXDATE);
                end;
                //Modified in order to calculate the Child Birth Date according to Payroll Date and not system date - 27.07.2016 : AIM +
                if (ChildBirthDate < MINDATE)
                //Modified in order to calculate the Child Birth Date according to Payroll Date and not system date - 27.07.2016 : AIM -
                and (ChildBirthDate <> 0D) and (EmpRelative."Permenant Disability" = EmpRelative."Permenant Disability"::No) then begin
                    case EmpRelative.Sex of
                        EmpRelative.Sex::Male:
                            begin
                                NoOfEligibleChilds := NoOfEligibleChilds - 1;
                            end;
                        EmpRelative.Sex::Female:
                            begin
                                if ((EmpRelative."Social Status" = EmpRelative."Social Status"::Married) and (TaxType = TaxType::TAX))
                                    or (TaxType <> TaxType::TAX) then
                                    NoOfEligibleChilds := NoOfEligibleChilds - 1;
                            end;
                    end;
                end;
                // Get Gender of Child since two fields for gender exists - 13.02.2016 : AIM+
                Sex := Sex::Male;
                if (EmpRelative.Sex = EmpRelative.Sex::Male) or (EmpRelative.Sex = EmpRelative.Sex::Female) then begin
                    Sex := EmpRelative.Sex;
                end
                else begin
                    IF EmpRelative."Arabic Gender" <> EmpRelative."Arabic Gender"::"ذكر" THEN
                        Sex := Sex::Female
                    else
                        Sex := Sex::Male;
                end;
                // Get Gender of Child since two fields for gender exists - 13.02.2016 : AIM-
                if (Sex = Sex::Female) and
                  (EmpRelative."Social Status" = EmpRelative."Social Status"::Married) then
                    NoOfEligibleChilds := NoOfEligibleChilds - 1;
                //EDM-
                //EDM+ 14-05-2019
                IF (DATE2DMY(Employee.Period, 3) = DATE2DMY(EmpRelative."Birth Date", 3)) AND (DATE2DMY(Employee.Period, 2) = DATE2DMY(EmpRelative."Birth Date", 2)) then BEGIN
                    IF DATE2DMY(EmpRelative."Birth Date", 1) > 15 THEN
                        NoOfEligibleChilds := NoOfEligibleChilds - 1;
                END;
                //EDM- 14-05-2019
            end;
        end;  // relatives
        if NoOfEligibleChilds > PayParam."Max. Pension Eligible Child" then
            NoOfEligibleChilds := PayParam."Max. Pension Eligible Child";

        exit(NoOfEligibleChilds);
    end;

    procedure CalculateFamilyAllowance(Emp: Record Employee; P_ApplySpeCases: Boolean; TaxToDate: Date): Decimal;
    var
        FamilyAllowAmt: Decimal;
        EmpRelative: Record "Employee Relative";
        WifeEntitlement: Decimal;
        ChildEntitlement: Decimal;
        SpouseWorking: Boolean;
        NoOfEligibleChilds: Integer;
        ChildDateIf25: Date;
        SpecPayElement: Record "Specific Pay Element";
        PayElement: Record "Pay Element";
        WifeEntitle: Decimal;
        ChildEntitle: Decimal;
        EligibleCountries: Record "Eligible Countries";
        Sex: Option Male,Female;
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        // P_ApplySpeCases used for the future when need to compute based on amendments in middle of the month.
        if (Emp.Gender = Emp.Gender::" ") or (Emp.Declared = Emp.Declared::"Non-NSSF") or (Emp.Declared = Emp.Declared::"Non-Declared") or
           (Emp.Declared = Emp.Declared::Contractual) then
            exit(0);

        PayParam.GET;
        //if foreigner,single no family allowance + SPE computation
        if ((Emp.Foreigner <> 0) and (not EligibleCountries.GET(PayParam."Family Allowance Code", Emp."First Nationality Code"))
               and (not EligibleCountries.GET(PayParam."Family Allowance Code", Emp."Second Nationality Code"))) or
           (Emp."Social Status" = Emp."Social Status"::Single) or
           ((Emp."Social Status" = Emp."Social Status"::Divorced) and (Emp."Divorced Spouse Child. Resp.")) then begin
            FamilyAllowAmt := 0;
            exit(FamilyAllowAmt);
        end;

        CLEAR(SpecPayElement);
        SpecPayElement.SETRANGE("Internal Pay Element ID", PayParam."Family Allowance Code");
        SpecPayElement.SETRANGE("Employee Category Code", '');
        if SpecPayElement.FIND('-') then begin
            WifeEntitle := SpecPayElement."Wife Entitlement";
            ChildEntitle := SpecPayElement."Per Children Entitlement";
        end else begin
            SpecPayElement.SETRANGE("Employee Category Code", Emp."Employee Category Code");
            if SpecPayElement.FIND('-') then begin
                WifeEntitle := SpecPayElement."Wife Entitlement";
                ChildEntitle := SpecPayElement."Per Children Entitlement";
            end;
        end; // find.lvl code

        NoOfEligibleChilds := GetNoOfEligibleChilds(Emp, 0, TaxToDate);

        if Emp."Social Status" <> Emp."Social Status"::Divorced then begin
            if (Emp.Gender = Emp.Gender::Male) and (not Emp."Spouse Secured") and
            ((Emp."Social Status" = Emp."Social Status"::Married) or (Emp."Social Status" = Emp."Social Status"::Separated)) then
                FamilyAllowAmt := WifeEntitle;

            if (Emp.Gender = Emp.Gender::Male) or
             ((Emp.Gender = Emp.Gender::Female)) then
                FamilyAllowAmt := FamilyAllowAmt + (ChildEntitle * NoOfEligibleChilds);
        end else
            FamilyAllowAmt := FamilyAllowAmt + (ChildEntitle * NoOfEligibleChilds);
        exit(FamilyAllowAmt);
    end;

    procedure GetSpePayAmount(P_PayECode: Code[10]; P_Emp: Record Employee; var PayDetailLine: Record "Pay Detail Line");
    var
        SpecPayElement: Record "Specific Pay Element";
        Amount: Decimal;
        PayStatus: Record "Payroll Status";
        PayElement: Record "Pay Element";
        PAmount: Decimal;
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        // Specific elmt
        Amount := 0;
        PayParam.GET;
        CLEAR(SpecPayElement);
        SpecPayElement.SETRANGE("Internal Pay Element ID", P_PayECode);
        if SpecPayElement.FIND('-') then begin
            if SpecPayElement."Internal Pay Element ID" = PayParam."Family Allowance Code" then begin
                //PY3.0+
                if not PayStatus.GET then;
                //PY3.0-
                PayDetailLine.Amount := CalculateFamilyAllowance(P_Emp, false, PayStatus."Period End Date"); //PY3.0+-
            end
            else begin
                SpecPayElement.SETRANGE("Employee Category Code", '');
                if SpecPayElement.FIND('-') then begin
                    //EDM.IT+
                    PAmount := 0;
                    if (SpecPayElement."Water Compensation" = true) and (SpecPayElement."Cost of Living" = true) then
                        PAmount := P_Emp."Water Compensation" + P_Emp."Basic Pay" + P_Emp."Cost of Living Amount"
                    else
                        if (SpecPayElement."Water Compensation" = true) and (SpecPayElement."Cost of Living" = false) then
                            PAmount := P_Emp."Water Compensation" + P_Emp."Basic Pay"
                        else
                            if (SpecPayElement."Water Compensation" = false) and (SpecPayElement."Cost of Living" = true) then
                                PAmount := P_Emp."Cost of Living Amount" + P_Emp."Basic Pay"
                            else
                                PAmount := P_Emp."Basic Pay";
                    //EDM.IT-
                    if SpecPayElement.Amount <> 0 then begin

                        PayDetailLine.Amount := SpecPayElement.Amount;
                    end
                    else
                        if SpecPayElement."% Basic Pay" <> 0 then begin
                            PayDetailLine.Amount := PAmount * SpecPayElement."% Basic Pay" / 100;

                        end;
                end  // w/o levels
                else begin
                    SpecPayElement.SETRANGE("Employee Category Code", P_Emp."Employee Category Code");
                    if SpecPayElement.FIND('-') then begin
                        //PY4.0+
                        if SpecPayElement."Pay Unit" = SpecPayElement."Pay Unit"::Daily then begin
                            if PayElement.GET(P_PayECode) then
                                if PayElement."Days in  Month" > 0 then begin
                                    PayDetailLine.Amount := SpecPayElement.Amount * PayElement."Days in  Month";
                                end else begin
                                    PayDetailLine.Amount := SpecPayElement.Amount;
                                end;
                        end else begin
                            //PY4.0-
                            if SpecPayElement.Amount <> 0 then begin
                                PayDetailLine.Amount := SpecPayElement.Amount;
                            end
                            else
                                if SpecPayElement."% Basic Pay" <> 0 then begin
                                    //EDM.IT+
                                    PAmount := 0;
                                    if (SpecPayElement."Water Compensation" = true) and (SpecPayElement."Cost of Living" = true) then
                                        PAmount := P_Emp."Water Compensation" + P_Emp."Basic Pay" + P_Emp."Cost of Living Amount"
                                    else
                                        if (SpecPayElement."Water Compensation" = true) and (SpecPayElement."Cost of Living" = false) then
                                            PAmount := P_Emp."Water Compensation" + P_Emp."Basic Pay"
                                        else
                                            if (SpecPayElement."Water Compensation" = false) and (SpecPayElement."Cost of Living" = true) then
                                                PAmount := P_Emp."Cost of Living Amount" + P_Emp."Basic Pay"
                                            else
                                                PAmount := P_Emp."Basic Pay";
                                    //EDM.IT-
                                    PayDetailLine.Amount := PAmount * SpecPayElement."% Basic Pay" / 100;
                                end;
                        end;
                    end else begin
                        PayDetailLine.Amount := 0;
                        PayDetailLine."Amount (ACY)" := 0;
                    end;
                end; // by level
            end;
        end; //spe
    end;

    procedure GetNextPayrollDate(P_PayG: Code[10]; P_PayFreq: Option Monthly,Weekly): Date;
    var
        PayStat: Record "Payroll Status";
        DateExpr: Text[30];
    begin
        if not PayStat.GET(P_PayG, P_PayFreq) then
            exit(TODAY)
        else begin
            if PayStat."Finalized Payroll Date" = 0D then begin
                if PayStat."Calculated Payroll Date" <> 0D then
                    exit(PayStat."Calculated Payroll Date")
                else
                    exit(WORKDATE);
            end else begin
                if P_PayFreq = P_PayFreq::Monthly then begin
                    if DATE2DMY(PayStat."Finalized Payroll Date", 1) = 30 then
                        DateExpr := '+1M+1D' else
                        if DATE2DMY(PayStat."Finalized Payroll Date", 1) = 28 then
                            DateExpr := '+1M+3D'
                        else
                            if DATE2DMY(PayStat."Finalized Payroll Date", 1) = 29 then
                                DateExpr := '+1M+2D'
                            else
                                DateExpr := '+1M';

                    exit(CALCDATE(DateExpr, PayStat."Finalized Payroll Date"));
                    //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
                end
                else begin
                    if (PayStat."Days Interval" > 0) then begin
                        if (PayStat."Week Start Day" = 1) and (PayStat."Days Interval" = 15) then begin
                            if DATE2DMY(PayStat."Finalized Payroll Date", 1) <= 15 then
                                exit(DMY2DATE(GetLastDayinMonth(PayStat."Finalized Payroll Date"), DATE2DMY(PayStat."Finalized Payroll Date", 2), DATE2DMY(PayStat."Finalized Payroll Date", 3)))
                            else begin
                                if DATE2DMY(PayStat."Finalized Payroll Date", 2) < 12 then
                                    exit(DMY2DATE(15, DATE2DMY(PayStat."Finalized Payroll Date", 2) + 1, DATE2DMY(PayStat."Finalized Payroll Date", 3)))
                                else
                                    exit(DMY2DATE(15, 1, DATE2DMY(PayStat."Finalized Payroll Date", 3) + 1))
                            end;
                        end
                        else
                            exit(PayStat."Finalized Payroll Date" + PayStat."Days Interval");
                    end
                    //Modified in order to consider the case where payroll is generated on 15 and end of each month - 27.02.2017 : AIM -
                    else
                        exit(PayStat."Finalized Payroll Date" + 1);
                    //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -
                end;
            end;
        end; //paystat.found
    end;

    procedure CalcEmpAge(P_Emp: Record Employee): Integer;
    var
        EmpAge: Integer;
    begin
        if P_Emp."Birth Date" = 0D then
            exit;
        EmpAge := DATE2DMY(TODAY, 3) - DATE2DMY(P_Emp."Birth Date", 3);
        if DATE2DMY(TODAY, 2) < DATE2DMY(P_Emp."Birth Date", 2) then
            EmpAge := EmpAge - 1;
        if (DATE2DMY(TODAY, 2) = DATE2DMY(P_Emp."Birth Date", 2)) and (DATE2DMY(TODAY, 1) < DATE2DMY(P_Emp."Birth Date", 1)) then
            EmpAge := EmpAge - 1;

        exit(EmpAge);
    end;

    procedure PensionApplicable(P_TaxSalary: Decimal; P_Employee: Record Employee; P_PensionScheme: Record "Pension Scheme"): Boolean;
    var
        VApplicable: Boolean;
    begin
        VApplicable := false;

        if (P_TaxSalary <> 0) and (P_Employee.Declared <> P_Employee.Declared::"Non-NSSF") and
           (P_Employee.Declared <> P_Employee.Declared::Contractual) and
           (P_Employee.Declared <> P_Employee.Declared::"Non-Declared") then begin
            //Added in order to consider the option NO EOS in Employee Card - 14.08.2017 : AIM +
            if ((P_PensionScheme.Type <> P_PensionScheme.Type::EOSIND) and (not P_PensionScheme."Foreigners Ineligible")) or
               ((P_PensionScheme."Foreigners Ineligible") and (not P_Employee.IsForeigner)) or
               ((P_PensionScheme.Type = P_PensionScheme.Type::EOSIND) and (not P_PensionScheme."Foreigners Ineligible") and (P_Employee.IsForeigner) and (P_Employee.Foreigner <> P_Employee.Foreigner::"Not End of Service")) then begin
                if (P_PensionScheme."Maximum Applicable Age" = 0) or
                 ((P_PensionScheme."Maximum Applicable Age" <> 0) and (CalcEmpAge(P_Employee) <= P_PensionScheme."Maximum Applicable Age")) then
                    VApplicable := true;
            end;
            //Added in order to consider the option NO EOS in Employee Card - 14.08.2017 : AIM -
        end;

        exit(VApplicable);

    end;

    procedure RoundingAmt(P_Ramount: Decimal; P_InAdditionalccy: Boolean): Decimal;
    begin
        PayParam.GET;
        if not P_InAdditionalccy then begin
            //EDM+
            if PayParam."Rounding Precision (LCY)" = 0 then
                exit(P_Ramount);
            //EDM-
            case PayParam."Rounding Type (LCY)" of
                PayParam."Rounding Type (LCY)"::Nearest:
                    P_Ramount := ROUND(P_Ramount, PayParam."Rounding Precision (LCY)", '=');
                PayParam."Rounding Type (LCY)"::Up:
                    P_Ramount := ROUND(P_Ramount, PayParam."Rounding Precision (LCY)", '>');
                PayParam."Rounding Type (LCY)"::Down:
                    P_Ramount := ROUND(P_Ramount, PayParam."Rounding Precision (LCY)", '<');
            end; //case.lcy
        end else begin
            //EDM+
            if PayParam."Rounding Precision (ACY)" = 0 then
                exit(P_Ramount);
            //EDM-

            case PayParam."Rounding Type (ACY)" of
                PayParam."Rounding Type (ACY)"::Nearest:
                    P_Ramount := ROUND(P_Ramount, PayParam."Rounding Precision (ACY)", '=');
                PayParam."Rounding Type (ACY)"::Up:
                    P_Ramount := ROUND(P_Ramount, PayParam."Rounding Precision (ACY)", '>');
                PayParam."Rounding Type (ACY)"::Down:
                    P_Ramount := ROUND(P_Ramount, PayParam."Rounding Precision (ACY)", '<');
            end; //case.additional
        end;
        exit(P_Ramount);
    end;

    procedure GetWorkingDay(DateFrom: Date; DateTo: Date; Employee: Record Employee): Decimal;
    var
        HRFunctions: Codeunit "Human Resource Functions";
        WrkDays: Decimal;
        NoofNonWD: Decimal;
        EmploymentType: Record "Employment Type";
    begin
        WrkDays := DateTo - DateFrom + 1;
        EmploymentType.GET(Employee."Employment Type Code");
        NoofNonWD := HRFunctions.GetNonWD(EmploymentType."Base Calendar Code", DateFrom, DateTo);
        WrkDays := WrkDays - NoofNonWD;
        exit(WrkDays);
    end;

    procedure AutoGenerateSchedule(EmpNo: Code[20]; FromPeriod: Date; TillPeriod: Date; ResetExisting: Boolean; IgnoreValidations: Boolean) NoError: Boolean;
    var
        Calendar: Record Date;
        Temp: Record "Import Schedule from Excel";
        EmpTypeSchedule: Record "Employment Type Schedule";
        EmploymentTypeCode: Code[20];
        EmployeeTable: Record Employee;
        ScheduleDates: array[31] of Date;
        i: Integer;
        M: Integer;
        Y: Integer;
        D: Integer;
        NbofDays: Integer;
    begin
        // Global Function - Added for Attendance on 30.12.2015  : AIM

        if FromPeriod = 0D then
            if IgnoreValidations = true then
                exit(true);

        if (CanModifyAttendancePeriod(EmpNo, FromPeriod, true, false, false, false) = false) then begin
            if (IgnoreValidations = false) then begin
                MESSAGE('Modify not allowed. Payroll Period is Closed.');
            end;
            exit(false);
        end;

        if TillPeriod = 0D then
            TillPeriod := FromPeriod;

        // Fix Period +
        if TillPeriod <= FromPeriod then begin
            Y := DATE2DMY(FromPeriod, 3);
            M := DATE2DMY(FromPeriod, 2);
            FromPeriod := DMY2DATE(1, M, Y);

            Y := DATE2DMY(TillPeriod, 3);
            M := DATE2DMY(TillPeriod, 2);
            case M of
                //M::1,M::3,M::5,M::7,M::8,M::10,M::12 :
                1, 3, 5, 7, 8, 10, 12:
                    D := 31;
                4, 6, 9, 11:
                    D := 30;
                2:
                    begin
                        if (Y mod 4 = 0) then
                            D := 29
                        else
                            D := 28
                    end;
            end;
            TillPeriod := DMY2DATE(D, M, Y);
        end;
        // Fix Period -

        NbofDays := (TillPeriod - FromPeriod) + 1;

        //Empty existing Temporary Schedule +
        /*Temp.SETRANGE("Employee No.", EmpNo);
        if Temp.FINDFIRST then begin
            if ResetExisting = false then begin
                exit(true)
            end
            else begin
                repeat
                    Temp.DELETE;
                until Temp.NEXT = 0;
            end;
        end;*/
        //Empty existing Temporary Schedule -
        if not Temp.FINDFIRST then begin
            //Get Employment Type Code +
            EmployeeTable.SETRANGE(EmployeeTable."No.", EmpNo);
            if EmployeeTable.FINDFIRST then
                //Modified in order to discard employees that have no Attendance No. - 24.03.2016 : AIM +
                if EmployeeTable."Attendance No." > 0 then
                    EmploymentTypeCode := EmployeeTable."Employment Type Code"
                else
                    EmploymentTypeCode := '';
            //Modified in order to discard employees that have no Attendance No. - 24.03.2016 : AIM -
            //Modified in order to discard employees that are not active - 29.03.2016 : AIM +
            if EmployeeTable.Status <> EmployeeTable.Status::Active then
                EmploymentTypeCode := '';
            //Modified in order to discard employees that are not active - 29.03.2016 : AIM -
            // Get Employment Type Code -

            // Initialize  Schedule Dates +
            i := 0;
            Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
            Calendar.SETRANGE("Period Start", FromPeriod, TillPeriod);
            if Calendar.FINDSET then
                while i < NbofDays do begin // 31 DO BEGIN //Fixed in order not to take always 31 days
                    repeat
                        i += 1;
                        ScheduleDates[i] := Calendar."Period Start";
                    until Calendar.NEXT = 0;
                end;
            // Initialize  Schedule Dates -


            if EmploymentTypeCode <> '' then begin
                Temp.INIT;
                Temp."Employee No." := EmpNo;
                Temp."Employee Name" := EmployeeTable."Full Name";
                Temp."Day 1" := GetDayShiftSchedule(ScheduleDates[1], EmploymentTypeCode);
                Temp."Day 2" := GetDayShiftSchedule(ScheduleDates[2], EmploymentTypeCode);
                Temp."Day 3" := GetDayShiftSchedule(ScheduleDates[3], EmploymentTypeCode);
                Temp."Day 4" := GetDayShiftSchedule(ScheduleDates[4], EmploymentTypeCode);
                Temp."Day 5" := GetDayShiftSchedule(ScheduleDates[5], EmploymentTypeCode);
                Temp."Day 6" := GetDayShiftSchedule(ScheduleDates[6], EmploymentTypeCode);
                Temp."Day 7" := GetDayShiftSchedule(ScheduleDates[7], EmploymentTypeCode);
                Temp."Day 8" := GetDayShiftSchedule(ScheduleDates[8], EmploymentTypeCode);
                Temp."Day 9" := GetDayShiftSchedule(ScheduleDates[9], EmploymentTypeCode);
                Temp."Day 10" := GetDayShiftSchedule(ScheduleDates[10], EmploymentTypeCode);
                Temp."Day 11" := GetDayShiftSchedule(ScheduleDates[11], EmploymentTypeCode);
                Temp."Day 12" := GetDayShiftSchedule(ScheduleDates[12], EmploymentTypeCode);
                Temp."Day 13" := GetDayShiftSchedule(ScheduleDates[13], EmploymentTypeCode);
                Temp."Day 14" := GetDayShiftSchedule(ScheduleDates[14], EmploymentTypeCode);
                Temp."Day 15" := GetDayShiftSchedule(ScheduleDates[15], EmploymentTypeCode);
                Temp."Day 16" := GetDayShiftSchedule(ScheduleDates[16], EmploymentTypeCode);
                Temp."Day 17" := GetDayShiftSchedule(ScheduleDates[17], EmploymentTypeCode);
                Temp."Day 18" := GetDayShiftSchedule(ScheduleDates[18], EmploymentTypeCode);
                Temp."Day 19" := GetDayShiftSchedule(ScheduleDates[19], EmploymentTypeCode);
                Temp."Day 20" := GetDayShiftSchedule(ScheduleDates[20], EmploymentTypeCode);
                Temp."Day 21" := GetDayShiftSchedule(ScheduleDates[21], EmploymentTypeCode);
                Temp."Day 22" := GetDayShiftSchedule(ScheduleDates[22], EmploymentTypeCode);
                Temp."Day 23" := GetDayShiftSchedule(ScheduleDates[23], EmploymentTypeCode);
                Temp."Day 24" := GetDayShiftSchedule(ScheduleDates[24], EmploymentTypeCode);
                Temp."Day 25" := GetDayShiftSchedule(ScheduleDates[25], EmploymentTypeCode);
                Temp."Day 26" := GetDayShiftSchedule(ScheduleDates[26], EmploymentTypeCode);
                Temp."Day 27" := GetDayShiftSchedule(ScheduleDates[27], EmploymentTypeCode);
                Temp."Day 28" := GetDayShiftSchedule(ScheduleDates[28], EmploymentTypeCode);
                Temp."Day 29" := GetDayShiftSchedule(ScheduleDates[29], EmploymentTypeCode);
                Temp."Day 30" := GetDayShiftSchedule(ScheduleDates[30], EmploymentTypeCode);
                Temp."Day 31" := GetDayShiftSchedule(ScheduleDates[31], EmploymentTypeCode);
                Temp.INSERT;
            end;
        end;

        exit(true);
    end;

    procedure GetDayShiftSchedule(DayDate: Date; ScheduleType: Code[20]) ShiftCode: Code[10];
    var
        EmpTypeSchedule: Record "Employment Type Schedule";
        DayofTheWeek: Option Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday;
    begin
        // Global Function - Added for Attendance on 30.12.2015  : AIM

        //Added in order to handle the case where DayDate = 0D - 17.03.2016 : AIM +
        if DayDate = 0D then
            exit('');
        //Added in order to handle the case where DayDate = 0D - 17.03.2016 : AIM -

        CASE EDMUtility.GetDayDate(DayDate) OF
            'Monday':
                DayofTheWeek := 1;
            'Tuesday':
                DayofTheWeek := 2;
            'Wednesday':
                DayofTheWeek := 3;
            'Thursday':
                DayofTheWeek := 4;
            'Friday':
                DayofTheWeek := 5;
            'Saturday':
                DayofTheWeek := 6;
            'Sunday':
                DayofTheWeek := 0;
        end;

        EmpTypeSchedule.SETRANGE("Employment Type Code", ScheduleType);
        EmpTypeSchedule.SETRANGE(EmpTypeSchedule."Day of the Week", DayofTheWeek);

        if EmpTypeSchedule.FINDFIRST then
            exit(EmpTypeSchedule."Shift Code");
    end;

    procedure AutoGenerateAttendance(EmpNo: Code[20]; Period: Date; AutoUpdate: Boolean; ResetExisting: Boolean; IgnoreMessages: Boolean) NoError: Boolean;
    var
        EmployeeAbsence: Record "Employee Absence";
        HandPunch: Record "Hand Punch";
    begin
        // Global Function - Added for Attendance on 30.12.2015  : AIM

        if Period = 0D then
            if IgnoreMessages = true then
                exit(true);

        if (CanModifyAttendancePeriod(EmpNo, Period, true, false, false, false) = false) then begin
            if (IgnoreMessages = false) then begin
                MESSAGE('Modify not allowed. Payroll Period is Closed.');
            end;
            exit(false);
        end;

        EmployeeAbsence.SETRANGE(EmployeeAbsence."Employee No.", EmpNo);
        EmployeeAbsence.SETRANGE(Period, Period);

        if EmployeeAbsence.FIND('-') then
            repeat
                HandPunch.SETRANGE("Attendnace No.", EmployeeAbsence."Attendance No.");
                HandPunch.SETRANGE("Scheduled Date", EmployeeAbsence."From Date");

                //Empty existing Hand Punch +
                if HandPunch.FIND('-') then begin
                    if ResetExisting = true then begin
                        repeat
                            HandPunch.DELETE;
                        until HandPunch.NEXT = 0;
                    end;
                end;
                //Empty existing Hand Punch -

                if HandPunch.FINDFIRST then begin
                end
                else
                    if (EmployeeAbsence."Required Hrs" > 0) and (EmployeeAbsence."Attend Hrs." = 0) and (EmployeeAbsence.Type = EmployeeAbsence.Type::"Working Day") then
                        if CanModifyEmployeeAttendance(EmpNo, EmployeeAbsence."From Date", EmployeeAbsence."From Date", true) = true then begin
                            HandPunch.INIT;
                            HandPunch.VALIDATE("Attendnace No.", EmployeeAbsence."Attendance No.");
                            HandPunch."Date Time" := CREATEDATETIME(EmployeeAbsence."From Date", EmployeeAbsence."From Time");
                            HandPunch."Real Date" := EmployeeAbsence."From Date";
                            HandPunch."Real Time" := EmployeeAbsence."From Time";
                            HandPunch."Action Type" := 'IN';
                            HandPunch."Scheduled Date" := EmployeeAbsence."From Date";
                            HandPunch.INSERT;
                            HandPunch.INIT;
                            HandPunch.VALIDATE("Attendnace No.", EmployeeAbsence."Attendance No.");
                            HandPunch."Date Time" := CREATEDATETIME(EmployeeAbsence."To Date", EmployeeAbsence."To Time");
                            HandPunch."Real Date" := EmployeeAbsence."To Date";
                            HandPunch."Real Time" := EmployeeAbsence."To Time";
                            HandPunch."Action Type" := 'OUT';
                            HandPunch."Scheduled Date" := EmployeeAbsence."From Date";
                            HandPunch.INSERT;
                        end;

            until EmployeeAbsence.NEXT = 0;

        if AutoUpdate = true then begin
            if CheckEmployeeAttendance(EmpNo, Period) = false then
                exit(false);
            //Added in order to update Attend Hours of new records - 22.04.2016 : AIM +
            FixEmployeeDailyAttendanceHours(EmpNo, Period, 0D, true, 'A0-LA-EL-EA_LL');
            //Added in order to update Attend Hours of new records - 22.04.2016 : AIM -
        end;

        exit(true);

    end;

    procedure CheckEmployeeAttendance(EmpNo: Code[20]; Period: Date) NoError: Boolean;
    var
        EmpAbs: Record "Employee Absence";
        HandPunch: Record "Hand Punch";
        Emp: Record Employee;
        HandPunchRec: Record "Hand Punch";
    begin
        // Global Function - Added for Attendance on 30.12.2015  : AIM

        Emp.SETRANGE("No.", EmpNo);
        if not Emp.FINDFIRST then
            exit(false);


        if (CanModifyAttendancePeriod(EmpNo, Period, true, false, false, false) = false) then begin
            exit(false);
        end;



        EmpAbs.SETRANGE("Employee No.", EmpNo);
        EmpAbs.SETRANGE(Period, Period);
        if EmpAbs.FIND('-') then //FINDFIRST
            repeat
                // In case a new record or not yet modified
                if CanModifyEmployeeAttendance(EmpNo, EmpAbs."From Date", EmpAbs."From Date", false) = true then begin
                    EmpAbs.VALIDATE("Employee No.", EmpAbs."Employee No.");
                    EmpAbs.MODIFY;
                    HandPunch.SETRANGE("Attendnace No.", Emp."Attendance No.");
                    HandPunch.SETRANGE("Real Date", EmpAbs."From Date");
                    HandPunch.SETRANGE("Action Type", 'IN');
                    if HandPunch.FINDFIRST then begin
                        HandPunch."Scheduled Date" := EmpAbs."From Date";
                        HandPunch.MODIFY;
                    end
                    else begin
                        EmpAbs."Invalid Log" := true;
                        EmpAbs.MODIFY;
                    end;

                    HandPunch.SETCURRENTKEY("Attendnace No.", "Action Type", "Real Time", "Real Date");
                    HandPunch.SETRANGE("Attendnace No.", Emp."Attendance No.");
                    HandPunch.SETRANGE("Real Date", EmpAbs."From Date");
                    HandPunch.SETRANGE("Action Type", 'OUT');
                    if HandPunch.FINDLAST then begin
                        if FORMAT(HandPunch."Scheduled Date") = '' then begin
                            HandPunch."Scheduled Date" := EmpAbs."From Date";
                            HandPunch.MODIFY;
                        end;
                    end
                    else begin
                        HandPunch.SETRANGE("Attendnace No.", Emp."Attendance No.");
                        HandPunch.SETRANGE("Real Date", CALCDATE('+1D', EmpAbs."From Date"));
                        HandPunch.SETRANGE("Action Type", 'OUT');
                        if HandPunch.FINDFIRST then begin
                            HandPunchRec.SETCURRENTKEY("Attendnace No.", "Action Type", "Real Time", "Real Date");
                            HandPunchRec.SETRANGE("Attendnace No.", Emp."Attendance No.");
                            HandPunchRec.SETRANGE("Real Date", CALCDATE('+1D', EmpAbs."From Date"));
                            HandPunchRec.SETRANGE("Action Type", 'IN');
                            if HandPunchRec.FINDFIRST then begin
                                if HandPunchRec."Real Time" > HandPunch."Real Time" then begin
                                    HandPunch."Scheduled Date" := EmpAbs."From Date";
                                    HandPunch.MODIFY;
                                end;
                            end
                            else begin
                                EmpAbs."Invalid Log" := true;
                                EmpAbs.MODIFY;
                            end;
                        end;
                    end;

                    EmpAbs.MODIFY;
                end;

            until EmpAbs.NEXT = 0;

        exit(true);
    end;

    procedure UpdateEmployeeAttendance(EmpNo: Code[20]; Period: Date) NoError: Boolean;
    var
        EmpAbs: Record "Employee Absence";
        VarStartTime: Time;
        VarEndTime: Time;
        VarExpectedFrom: Time;
        VarExpectedTo: Time;
        HandPunch: Record "Hand Punch";
        Emp: Record Employee;
        DiffTime: Decimal;
    begin
        // Global Function - Added for Attendance on 30.12.2015  : AIM

        Emp.SETRANGE("No.", EmpNo);
        if not Emp.FINDFIRST then
            exit(false);

        //{
        if (CanModifyAttendancePeriod(EmpNo, Period, true, false, false, false) = false) then begin
            exit(false);
        end;
        //}
        if Period > Emp.Period then begin
            exit(false);
        end;


        EmpAbs.SETRANGE("Employee No.", EmpNo);
        EmpAbs.SETRANGE(Period, Period);
        if EmpAbs.FIND('-') then // FINDFIRST
            repeat
                // In case a new record or not yet modified
                if CanModifyEmployeeAttendance(EmpNo, EmpAbs."From Date", EmpAbs."From Date", false) = true then begin

                    EmpAbs.VALIDATE("Employee No.", EmpAbs."Employee No.");
                    EmpAbs.MODIFY;
                    CLEAR(VarStartTime);
                    CLEAR(VarEndTime);
                    CLEAR(VarExpectedTo);
                    CLEAR(VarExpectedFrom);

                    HandPunch.SETRANGE("Attendnace No.", Emp."Attendance No.");
                    HandPunch.SETRANGE("Scheduled Date", EmpAbs."From Date");
                    HandPunch.SETRANGE("Action Type", 'IN');
                    if HandPunch.FINDFIRST then begin
                        VarStartTime := HandPunch."Real Time";
                    end;

                    DiffTime := 0;
                    HandPunch.SETRANGE("Attendnace No.", Emp."Attendance No.");
                    HandPunch.SETRANGE("Scheduled Date", EmpAbs."From Date");
                    HandPunch.SETRANGE("Action Type", 'OUT');
                    if HandPunch.FINDLAST then begin
                        VarEndTime := HandPunch."Real Time";
                    end;
                    //+Attend Hour
                    IF (VarStartTime <> 0T) AND (VarEndTime <> 0T) THEN
                        EmpAbs.VALIDATE("Attend Hrs.", EmpAbs.CalcTime(VarStartTime, VarEndTime));
                    //-
                    EmpAbs."Late Arrive" := 0;
                    EmpAbs."Early Leave" := 0;
                    EmpAbs."Early Arrive" := 0;
                    EmpAbs."Late Leave" := 0;
                    EmpAbs.MODIFY;
                    VarExpectedFrom := EmpAbs."From Time";
                    VarExpectedTo := EmpAbs."To Time";

                    if (FORMAT(VarExpectedFrom) <> '') and (FORMAT(VarExpectedTo) <> '') and (FORMAT(VarStartTime) <> '')
                    and (FORMAT(VarEndTime) <> '') then begin
                        if VarExpectedFrom > VarStartTime then begin
                            EmpAbs.VALIDATE("Early Arrive", EmpAbs.CalcTime(VarStartTime, VarExpectedFrom) * 60);
                        end
                        else begin
                            EmpAbs.VALIDATE("Late Arrive", EmpAbs.CalcTime(VarExpectedFrom, VarStartTime) * 60);
                        end;

                        if VarExpectedTo < VarEndTime then begin
                            EmpAbs.VALIDATE("Late Leave", (EmpAbs.CalcTime(VarExpectedTo, VarEndTime)) * 60);
                        end
                        else begin
                            EmpAbs.VALIDATE("Early Leave", EmpAbs.CalcTime(VarEndTime, VarExpectedTo) * 60);
                        end;
                    end;
                    EmpAbs.MODIFY;
                end;

            until EmpAbs.NEXT = 0;
        HandPunch.SETRANGE("Attendnace No.", Emp."Attendance No.");
        if HandPunch.FINDFIRST then
            repeat
                HandPunch.checked := false;
                HandPunch.MODIFY;
            until HandPunch.NEXT = 0;
    end;

    procedure ValidateEmployeeAttendanceHolidays(EmpNo: Code[20]; Period: Date) NoError: Boolean;
    var
        EmployeeAbsence: Record "Employee Absence";
        EmploymentType: Record "Employment Type";
        BaseCalendarChange: Record "Base Calendar Change N";
    begin

        if (CanModifyAttendancePeriod(EmpNo, Period, true, false, false, false) = false) then begin
            exit(false);
        end;


        EmployeeAbsence.SETRANGE("Employee No.", EmpNo);
        EmployeeAbsence.SETRANGE(Period, Period);
        if EmployeeAbsence.FINDFIRST then
            repeat
                EmployeeAbsence.CALCFIELDS("Employment Type Code");
                EmploymentType.SETRANGE(Code, EmployeeAbsence."Employment Type Code");
                if EmploymentType.FINDFIRST then begin
                    BaseCalendarChange.SETRANGE("Base Calendar Code", EmploymentType."Base Calendar Code");
                    BaseCalendarChange.SETRANGE(Date, EmployeeAbsence."From Date");
                    if BaseCalendarChange.FINDFIRST then begin
                        if BaseCalendarChange.Nonworking then begin
                            // In case a new record or not yet modified
                            if CanModifyEmployeeAttendance(EmpNo, EmployeeAbsence."From Date", EmployeeAbsence."From Date", true) = true then begin

                                //Added in order not to replace assigned shift code - 21.04.2016 : AIM +
                                if EmployeeAbsence."Attend Hrs." = 0 then begin
                                    //Added in order not to replace assigned shift code - 21.04.2016 : AIM -
                                    EmployeeAbsence.VALIDATE("Shift Code", 'HOLIDAY');
                                    EmployeeAbsence.MODIFY;
                                    //Added in order not to replace assigned shift code - 21.04.2016 : AIM +
                                end;
                                //Added in order not to replace assigned shift code - 21.04.2016 : AIM -
                            end;
                        end;
                    end;
                end;
            until EmployeeAbsence.NEXT = 0;

        exit(true);
    end;

    procedure CanModifyEmployeeAttendance(EmpNo: Code[20]; FromDate: Date; TillDate: Date; CheckPunch: Boolean) AllowModify: Boolean;
    var
        EmpAbs: Record "Employee Absence";
        Allow: Boolean;
        HandPunch: Record "Hand Punch";
    begin
        //Allow := false;//20180921:A2+-
        Allow := true;//20180921:A2+-
        EmpAbs.SETRANGE("Employee No.", EmpNo);
        EmpAbs.SETRANGE("From Date", FromDate);
        EmpAbs.SETRANGE("To Date", TillDate);
        if EmpAbs.FindFirst then begin
            repeat
                //Added in order to consider payroll intervals that do not start from begining of months - 17.06.2016 : AIM +
                if not CanModifyAttendancePeriod(EmpNo, EmpAbs.Period, true, false, false, false) then
                    exit(false);
                //Added in order to consider payroll intervals that do not start from begining of months - 17.06.2016 : AIM -
                if (EmpAbs."Required Hrs" = EmpAbs."Attend Hrs.") then
                    if CheckPunch then begin // This condition is needed in case of (Weekly Schedule - Validate Holidays) in order not to affect existing Attendance
                        HandPunch.SETRANGE("Attendnace No.", EmpAbs."Attendance No.");
                        HandPunch.SETRANGE("Scheduled Date", EmpAbs."From Date");
                        if not HandPunch.FINDFIRST then
                            Allow := true
                        else
                            exit(Allow)
                    end else
                        Allow := true
                else begin
                    if (EmpAbs."Attend Hrs." = 0) and (EmpAbs."Late Arrive" = 0) and (EmpAbs."Early Leave" = 0) and (EmpAbs."Early Arrive" = 0) and (EmpAbs."Late Leave" = 0) then
                        Allow := true
                    else begin
                        Allow := false;
                        exit(Allow);
                    end;
                end;
            until EmpAbs.NEXT = 0;
        end else
            Allow := true;

        exit(Allow);
    end;

    procedure CanModifyAttendancePeriod(EmpNo: Code[20]; Period: Date; CheckAttendancePeriod: Boolean; CheckPayDetails: Boolean; CheckExistingAttendance: Boolean; CheckAttendanceJournal: Boolean) AllowModify: Boolean;
    var
        PeriodOpened: Boolean;
        PayDetailLine: Record "Pay Detail Line";
        M: Integer;
        Y: Integer;
        EmpAbs: Record "Employee Absence";
        FDate: Date;
        TDate: Date;
        D: Integer;
        EMP: Record Employee;
        EmpJournal: Record "Employee Journal Line";
        IsPayrollSpecialInterval: Boolean;
        HRSetup: Record "Human Resources Setup";
        PayrollStatus: Record "Payroll Status";
        L_EmpTbt: Record Employee;
        L_IsSeparateAttendanceInterval: Boolean;
    begin

        //If PeriodOpened = False then the user cannot modify Attendance Data
        PeriodOpened := false;

        if Period = 0D then
            exit(false);

        M := DATE2DMY(Period, 2);
        Y := DATE2DMY(Period, 3);

        //Added in order to consider payroll intervals that do not start from begining of months - 17.06.2016 : AIM +
        if DATE2DMY(Period, 1) = 1 then
            IsPayrollSpecialInterval := false
        else
            IsPayrollSpecialInterval := true;
        //Added in order to consider payroll intervals that do not start from begining of months - 17.06.2016 : AIM -

        //Added in order to consider Attendance Interval - 18.09.2017 : A2+
        HRSetup.GET;
        IF HRSetup."Seperate Attend From Payroll" THEN begin
            L_EmpTbt.SETRANGE("No.", EmpNo);
            if L_EmpTbt.FINDFIRST then begin
                L_IsSeparateAttendanceInterval := IsSeparateAttendanceInterval(L_EmpTbt."Payroll Group Code");
                if L_IsSeparateAttendanceInterval then begin
                    PayrollStatus.SETRANGE("Payroll Group Code", L_EmpTbt."Payroll Group Code");
                    if PayrollStatus.FINDFIRST then begin
                        if (PayrollStatus."Separate Attendance Interval")
                        and (PayrollStatus."Attendance Start Date" <> 0D)
                        and (PayrollStatus."Attendance End Date" <> 0D) then begin
                            IsPayrollSpecialInterval := true;
                            FDate := PayrollStatus."Attendance Start Date";
                            Period := PayrollStatus."Attendance Period";
                            TDate := PayrollStatus."Attendance End Date";
                        end;
                    end;
                end;
            end;
        end
        ELSE BEGIN
            L_EmpTbt.SETRANGE("No.", EmpNo);
            if L_EmpTbt.FINDFIRST then begin
                L_IsSeparateAttendanceInterval := IsSeparateAttendanceInterval(L_EmpTbt."Payroll Group Code");
                if L_IsSeparateAttendanceInterval then begin
                    PayrollStatus.SETRANGE("Payroll Group Code", L_EmpTbt."Payroll Group Code");
                    if PayrollStatus.FINDFIRST then begin
                        if (PayrollStatus."Separate Attendance Interval")
                        and (PayrollStatus."Attendance Start Date" <> 0D)
                        and (PayrollStatus."Attendance End Date" <> 0D)
                        and (DATE2DMY(PayrollStatus."Payroll Date", 2) = DATE2DMY(PayrollStatus."Attendance End Date", 2)) then begin
                            //and (DATE2DMY(L_PayrollStatus."Payroll Date",3) = DATE2DMY(L_PayrollStatus."Attendance End Date",3)) then begin //20180919:A2+-
                            IsPayrollSpecialInterval := true;
                            FDate := PayrollStatus."Attendance Start Date";
                            Period := PayrollStatus."Attendance End Date";
                            TDate := PayrollStatus."Attendance End Date";
                        end;
                    end;
                end;
            end;
        END;
        //Added in order to consider Attendance Interval - 18.09.2017 : A2-


        //Added in order to consider payroll intervals that do not start from begining of months - 07.06.2016 : AIM +
        if IsPayrollSpecialInterval = false then begin
            //Added in order to consider payroll intervals that do not start from begining of months - 07.06.2016 : AIM -
            FDate := DMY2DATE(1, M, Y);

            case M of
                1, 3, 5, 7, 8, 10, 12:
                    D := 31;
                4, 6, 9, 11:
                    D := 30;
                2:
                    begin
                        if (Y mod 4 = 0) then
                            D := 29
                        else
                            D := 28
                    end;
            end;
            TDate := DMY2DATE(D, M, Y);
            //Added in order to consider payroll intervals that do not start from begining of months - 07.06.2016 : AIM +
        end
        else
            //Added in order to consider Attendance Interval - 18.09.2017 : A2+
            if L_IsSeparateAttendanceInterval then begin
                D := DATE2DMY(TDate, 1);
                M := DATE2DMY(TDate, 2);
                Y := DATE2DMY(TDate, 3);
            end
            else
            //Added in order to consider Attendance Interval - 18.09.2017 : A2-
            begin
                FDate := Period;
                D := DATE2DMY(Period, 1);
                M := M + 1;
                if M > 12 then begin
                    M := 1;
                    Y := Y + 1;
                end;
                TDate := DMY2DATE(D, M, Y);
            end;
        //Added in order to consider payroll intervals that do not start from begining of months - 07.06.2016 : AIM -
        HRSetup.GET;
        if CheckAttendancePeriod = true then begin
            IF HRSetup."Seperate Attend From Payroll" then begin
                L_EmpTbt.SETRANGE("No.", EmpNo);
                if L_EmpTbt.FINDFIRST then begin
                    L_IsSeparateAttendanceInterval := IsSeparateAttendanceInterval(L_EmpTbt."Payroll Group Code");
                    if L_IsSeparateAttendanceInterval then begin
                        PayrollStatus.SETRANGE("Payroll Group Code", L_EmpTbt."Payroll Group Code");
                        if PayrollStatus.FINDFIRST then begin
                            if PayrollStatus."Finalized Payroll Date" > Period then
                                PeriodOpened := false
                            else
                                PeriodOpened := true
                        end;
                    end;
                end;
            END
            ELSE BEGIN
                EMP.SETRANGE(EMP."No.", EmpNo);
                if EMP.FINDFIRST then begin
                    if EMP.Period > Period then
                        PeriodOpened := false
                    else
                        PeriodOpened := true
                end
                else begin
                    PeriodOpened := false;
                end;
            END;
        end;

        if CheckPayDetails = true then
            if PeriodOpened = true then begin
                begin
                    PayDetailLine.SETRANGE("Employee No.", EmpNo);
                    PayDetailLine.SETRANGE(Period, M);
                    PayDetailLine.SETRANGE("Tax Year", Y);
                    PayDetailLine.SETRANGE(Open, false);
                    //Added to prevent conflict with subpayroll - 23.03.2018 : AIM+
                    PayDetailLine.SETFILTER(PayDetailLine."Sub Payroll Code", '= %1', '');
                    //Added to prevent conflict with subpayroll - 23.03.2018 : AIM-
                    if PayDetailLine.FINDFIRST then
                        PeriodOpened := false
                    else
                        PeriodOpened := true;
                end;
            end;

        if CheckExistingAttendance = true then begin
            if PeriodOpened = true then // If Pay Details generated but without attendance That is Attendance is needed just as report
              begin
                EmpAbs.SETRANGE("From Date", FDate, TDate);
                EmpAbs.SETRANGE("Employee No.", EmpNo);
                if EmpAbs.FINDFIRST then
                    PeriodOpened := false
                else
                    PeriodOpened := true;
            end;


            if PeriodOpened = true then // If Pay Details generated but without attendance That is Attendance is needed just as report
              begin
                EmpAbs.SETRANGE("To Date", FDate, TDate);
                EmpAbs.SETRANGE("Employee No.", EmpNo);
                if EmpAbs.FINDFIRST then
                    PeriodOpened := false
                else
                    PeriodOpened := true;
            end;
        end;

        if CheckAttendanceJournal = true then  // Check if 'Generate Journal' is performed for the current period
          begin
            if PeriodOpened = true then begin
                EmpJournal.SETRANGE("Employee No.", EmpNo);
                EmpJournal.SETRANGE("Transaction Type", 'ABS');
                EmpJournal.SETRANGE("Starting Date", FDate);
                EmpJournal.SETRANGE("Ending Date", TDate);
                EmpJournal.SETRANGE("Document Status", EmpJournal."Document Status"::Approved);
                EmpJournal.SETRANGE(Type, 'ABSENCE');
                if EmpJournal.FINDFIRST then
                    PeriodOpened := false
                else
                    PeriodOpened := true;

            end
        end;


        exit(PeriodOpened);
    end;

    procedure GenerateAttendance(EmployeeNo: Code[20]; Period: Date);
    var
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        EntryNumber: Integer;
        HRSetup: Record "Human Resources Setup";
        LateArrive: Decimal;
        EarlyLeave: Decimal;
        EarlyArrive: Decimal;
        LateLeave: Decimal;
        ExpectedHours: Decimal;
        ActualHours: Decimal;
        EmpJournal: Record "Employee Journal Line";
        UnitMeasure: Code[10];
        OAPeriodType: Option Daily,Monthly;
        OACalcType: Integer;
        MonthlyNetHrs: Decimal;
        HrsDiff: Decimal;
        VMHrs: Decimal;
        JnlCauseofAbsence: Code[10];
        JnlValue: Decimal;
        JnlCalcValue: Decimal;
        JnlAttendHrs: Decimal;
        JnlReqHrs: Decimal;
        JnlSpecialHrs: Decimal;
        JnlSpecialRec: Boolean;
        JnlLoopCnt: Integer;
        JnlAbsType: Option "Unpaid Vacation","Paid Vacation","Sick Day","No Duty","Signal Absence",Holiday,"Working Day","Working Holiday",Subtraction,"Work Accident","Paid Day",AL;
        JnlAttType: Option Overtime,Absence,WorkingDay;
        L_MaxLineNo: Integer;
        L_EmpJnlTbt: Record "Employee Journal Line";
        EmployeeRec: Record "Employee";
        EmploymentTypeRec: Record "Employment Type";
        SundayHolidayValue: Decimal;
    begin
        HRSetup.GET;
        FixEmployeeDailyAttendanceHours(EmployeeNo, Period, 0D, true, 'ACT');
        OACalcType := GetEmployeeOvertimeAbsenceCalculationType(EmployeeNo);

        if OACalcType = 2 then
            OAPeriodType := OAPeriodType::Monthly
        else
            OAPeriodType := OAPeriodType::Daily;

        if not HRSetup."Reset Attendance Jnls Manual" then
            DeleteEmpAttendanceJournals(EmployeeNo, Period);

        ExpectedHours := 0;
        ActualHours := 0;
        EmployeeABS.SETRANGE("Employee No.", EmployeeNo);
        EmployeeABS.SETRANGE(Period, Period);
        if EmployeeABS.FINDFIRST then
            repeat
                if (not IsAttendanceRecordProcessed(EmployeeABS."Employee No.", EmployeeABS."From Date")) and
                   (not IsAttendanceJournalExists(EmployeeABS."Employee No.", EmployeeABS."From Date")) then begin
                    JnlCauseofAbsence := '';
                    JnlAttendHrs := 0;
                    JnlCalcValue := 0;
                    JnlLoopCnt := 0;
                    JnlReqHrs := 0;
                    JnlSpecialHrs := 0;
                    JnlSpecialRec := false;
                    JnlValue := 0;
                    HrsDiff := 0;
                    while (JnlLoopCnt <= 1) do begin
                        EmployeeJournal.SETRANGE("Employee No.", EmployeeNo);
                        if EmployeeJournal.FINDLAST then
                            EntryNumber := EmployeeJournal."Entry No."
                        else
                            EntryNumber := 0;

                        EmployeeJournal.INIT;
                        EmployeeJournal.VALIDATE("Employee No.", EmployeeNo);
                        EmployeeJournal."Transaction Type" := 'ABS';

                        JnlAttendHrs := EmployeeABS."Attend Hrs.";
                        JnlReqHrs := EmployeeABS."Required Hrs";
                        JnlAbsType := EmployeeABS.Type;
                        if (JnlLoopCnt = 0) then begin
                            if (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('AL')) > 0) then // Annual Leave (AL,0.5AL,0.25AL,0.75AL)
                                JnlCauseofAbsence := 'AL'
                            else
                                if STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('CL')) > 0 then // Casual Leave (CL,0.5CL,0.25CL,0.75CL)
                                    JnlCauseofAbsence := 'CL'
                                else
                                    if STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('SKD')) > 0 then // Sick Leave (SKD,0.5SKD,0.25SKD,0.75SKD)
                                        JnlCauseofAbsence := 'SKD'
                                    else
                                        if STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('SKL')) > 0 then // Sick Leave (SKL,0.5SKL,0.25SKL,0.75SKL)
                                            JnlCauseofAbsence := 'SKL'
                                        else
                                            if STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('ULT')) > 0 then // Unpaid Leave Taxable (ULT,0.5ULT,0.25ULT,0.75ULT)
                                                JnlCauseofAbsence := 'ULT'
                                            else
                                                if STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('UL')) > 0 then // Unpaid Leave (UL,0.5UL,0.25UL,0.75UL)
                                                    JnlCauseofAbsence := 'UL'
                                                else
                                                    if (OAPeriodType = OAPeriodType::Monthly) and
                             (EmployeeABS."Cause of Absence Code" = 'HOLIDAY') and
                             (EmployeeABS."Required Hrs" = 0) and
                             (EmployeeABS."Attend Hrs." > 0) and
                             (EmployeeABS."Unit of Measure Code" = 'DAY') and
                             (HRSetup."Accumulate Overtime To AL") and
                             (HRSetup."Overtime To AL Code" <> '') and
                             (HRSetup."Annual Leave Code" <> '') then
                                                        JnlCauseofAbsence := HRSetup."Overtime To AL Code"
                                                    //EDM+  14-10-2020                         
                                                    else
                                                        if (OAPeriodType = OAPeriodType::Monthly) and
                            (EmployeeABS."Cause of Absence Code" = 'WEEKEND') and
                            (EmployeeABS."Required Hrs" = 0) and
                            (EmployeeABS."Attend Hrs." > 0) and
                            (EmployeeABS."Unit of Measure Code" = 'DAY') and
                            (HRSetup."Accumulate Weekend Overtime To Sunday") and
                            (HRSetup."Sunday Leave Code" <> '') then
                                                            JnlCauseofAbsence := 'WEEKEND'
                                                        else
                                                            if (OAPeriodType = OAPeriodType::Monthly) and
                            (EmployeeABS."Cause of Absence Code" = 'HOLIDAY') and
                            (EmployeeABS."Required Hrs" = 0) and
                            (EmployeeABS."Attend Hrs." > 0) and
                            (EmployeeABS."Unit of Measure Code" = 'DAY') and
                            (HRSetup."Accumulate Holiday Overtime To HolidayVac") and
                            (HRSetup."Holiday Leave Code" <> '') then
                                                                JnlCauseofAbsence := 'HOLIDAY'
                                                            //EDM-  14-10-2020                                                        
                                                            else
                                                                JnlCauseofAbsence := EmployeeABS."Cause of Absence Code";

                            JnlCauseofAbsence := FixCauseCodeforGenerateAttendance(JnlCauseofAbsence, EmployeeABS);

                            EmployeeJournal.VALIDATE("Cause of Absence Code", JnlCauseofAbsence);
                            EmployeeJournal.VALIDATE("Starting Date", EmployeeABS."From Date");
                            EmployeeJournal.VALIDATE("Ending Date", EmployeeABS."From Date");

                            if (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('AL')) = 0) and
                             (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('CL')) = 0) and
                             (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('SKD')) = 0) and
                             (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('SKL')) = 0) and
                             (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('ULT')) = 0) and
                             (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('UL')) = 0) then
                                UnitMeasure := GetCauseOfAttendanceUnitMeasure(EmployeeJournal."Cause of Absence Code")
                            else
                                UnitMeasure := UPPERCASE('DAY');

                            if UPPERCASE(UnitMeasure) = UPPERCASE('HOUR') then begin
                                EmployeeJournal."From Time" := EmployeeABS."From Time";
                                EmployeeJournal."To Time" := EmployeeABS."To Time";
                            end;

                            if (EmployeeJournal."From Time" = EmployeeJournal."To Time") then begin
                                EmployeeJournal."From Time" := 0T;
                                EmployeeJournal."To Time" := 0T;
                            end;

                            EmployeeJournal.Type := 'ABSENCE';
                            EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
                            if (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('AL')) = 0) and
                               (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('CL')) = 0) and
                               (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('SKD')) = 0) and
                               (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('SKL')) = 0) and
                               (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('ULT')) = 0) and
                               (STRPOS(UPPERCASE(EmployeeABS."Cause of Absence Code"), UPPERCASE('UL')) = 0) then begin
                                if UPPERCASE(UnitMeasure) <> UPPERCASE('HOUR') then begin
                                    //EDM+ 14-10-2020
                                    IF ((JnlCauseofAbsence = 'WEEKEND') OR (JnlCauseofAbsence = HRSetup."Sunday Leave Code")) and (HRSetup."Accumulate Weekend Overtime To Sunday")
                                        and (JnlAttendHrs > 0) then begin
                                        EmployeeABS.CALCFIELDS("Employment Type Code");
                                        EmploymentTypeRec.SETRANGE(Code, EmployeeABS."Employment Type Code");
                                        IF EmploymentTypeRec.FINDFIRST then begin
                                            SundayHolidayValue := ROUND((EmployeeABS."Attend Hrs." / EmploymentTypeRec."Working Hours Per Day"), 0.01, '=');
                                            JnlValue := SundayHolidayValue;
                                        end;
                                        EmployeeJournal.Value := JnlValue;
                                        EmployeeJournal."Calculated Value" := JnlValue;
                                    end
                                    ELSE
                                        IF ((JnlCauseofAbsence = 'HOLIDAY') or (JnlCauseofAbsence = HRSetup."Holiday Leave Code")) and (HRSetup."Accumulate Holiday Overtime To HolidayVac")
                                       and (JnlAttendHrs > 0) then begin
                                            EmployeeABS.CALCFIELDS("Employment Type Code");
                                            EmploymentTypeRec.SETRANGE(Code, EmployeeABS."Employment Type Code");
                                            IF EmploymentTypeRec.FINDFIRST then begin
                                                SundayHolidayValue := ROUND((EmployeeABS."Attend Hrs." / EmploymentTypeRec."Working Hours Per Day"), 0.01, '=');
                                                JnlValue := SundayHolidayValue;
                                            end;
                                            EmployeeJournal.Value := JnlValue;
                                            EmployeeJournal."Calculated Value" := JnlValue;
                                        end
                                        //EDM- 14-10-2020                                 
                                        ELSE begin
                                            JnlValue := EmployeeABS.Quantity;
                                            EmployeeJournal.VALIDATE(Value, JnlValue);
                                            EmployeeJournal.VALIDATE("Calculated Value", JnlValue);
                                        end;
                                end else begin
                                    if EmployeeABS."Required Hrs" > 0 then
                                        JnlValue := EmployeeABS."Required Hrs"
                                    else
                                        JnlValue := EmployeeABS."Attend Hrs.";
                                end;
                                EmployeeJournal.VALIDATE(Value, JnlValue);
                                EmployeeJournal.VALIDATE("Calculated Value", JnlValue);
                            end else begin
                                JnlValue := GetCauseofAbsenceValue(EmployeeABS."Cause of Absence Code", EmployeeABS.Quantity);
                                JnlCalcValue := GetCauseofAbsenceValue(EmployeeABS."Cause of Absence Code", EmployeeABS.Quantity);
                                EmployeeJournal.VALIDATE(Value, JnlValue);
                                EmployeeJournal.VALIDATE("Calculated Value", JnlCalcValue);
                                if JnlValue < 1 then
                                    //A2+ 05.10.2018
                                    //IF (JnlAttendHrs <> JnlReqHrs ) AND (HRSetup."Working Day Code" <> '') THEN
                                    IF ((JnlReqHrs > 0) AND (JnlAttendHrs = JnlReqHrs) AND (HRSetup."Working Day Code" <> '')) OR
                            ((JnlAttendHrs <> JnlReqHrs) AND (HRSetup."Working Day Code" <> '')) THEN
                                        //A2- 05.10.2018
                                        JnlSpecialRec := true;
                                JnlSpecialHrs := JnlValue;
                            end;
                        end else begin
                            JnlCauseofAbsence := GetAttendanceCauseOfAbsenceCode(JnlAttType::WorkingDay);
                            UnitMeasure := GetCauseOfAttendanceUnitMeasure(JnlCauseofAbsence);
                            JnlValue := 1 - JnlSpecialHrs;

                            EmployeeJournal.VALIDATE("Cause of Absence Code", JnlCauseofAbsence);
                            EmployeeJournal.VALIDATE("Starting Date", EmployeeABS."From Date");
                            EmployeeJournal.VALIDATE("Ending Date", EmployeeABS."From Date");
                            EmployeeJournal.Type := 'ABSENCE';
                            EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
                            //EDM+ 14-10-2020
                            IF ((JnlCauseofAbsence = 'WEEKEND') OR (JnlCauseofAbsence = HRSetup."Sunday Leave Code")) and (HRSetup."Accumulate Weekend Overtime To Sunday")
                                and (JnlAttendHrs > 0) then begin
                                EmployeeABS.CALCFIELDS("Employment Type Code");
                                EmploymentTypeRec.SETRANGE(Code, EmployeeABS."Employment Type Code");
                                IF EmploymentTypeRec.FINDFIRST then begin
                                    SundayHolidayValue := ROUND((EmployeeABS."Attend Hrs." / EmploymentTypeRec."Working Hours Per Day"), 0.01, '=');
                                    EmployeeJournal.Value := SundayHolidayValue;
                                    EmployeeJournal."Calculated Value" := SundayHolidayValue;
                                end;
                            end
                            ELSE
                                IF ((JnlCauseofAbsence = 'HOLIDAY') or (JnlCauseofAbsence = HRSetup."Holiday Leave Code")) and (HRSetup."Accumulate Holiday Overtime To HolidayVac")
                               and (JnlAttendHrs > 0) then begin
                                    EmployeeABS.CALCFIELDS("Employment Type Code");
                                    EmploymentTypeRec.SETRANGE(Code, EmployeeABS."Employment Type Code");
                                    IF EmploymentTypeRec.FINDFIRST then begin
                                        SundayHolidayValue := ROUND((EmployeeABS."Attend Hrs." / EmploymentTypeRec."Working Hours Per Day"), 0.01, '=');
                                        EmployeeJournal.Value := SundayHolidayValue;
                                        EmployeeJournal."Calculated Value" := SundayHolidayValue;
                                    end;
                                end
                                ELSE BEGIN
                                    //EDM- 14-10-2020                             
                                    EmployeeJournal.VALIDATE(Value, 1);
                                    EmployeeJournal.VALIDATE("Calculated Value", 1);
                                END;
                        end;

                        EmployeeJournal."Opened By" := USERID;
                        EmployeeJournal."Opened Date" := WORKDATE;
                        EmployeeJournal."Released By" := USERID;
                        EmployeeJournal."Released Date" := WORKDATE;
                        EmployeeJournal."Approved By" := USERID;
                        EmployeeJournal."Approved Date" := WORKDATE;
                        EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;

                        L_EmpJnlTbt.RESET;
                        CLEAR(L_EmpJnlTbt);
                        L_MaxLineNo := 0;

                        L_EmpJnlTbt.SETRANGE("Employee No.", EmployeeNo);
                        if L_EmpJnlTbt.FindLast then
                            L_MaxLineNo := L_EmpJnlTbt."Entry No." + 1
                        else
                            L_MaxLineNo := 1;

                        EmployeeJournal."Entry No." := L_MaxLineNo;
                        L_MaxLineNo := L_MaxLineNo + 1;
                        EmployeeJournal."Rounding of Calculated Value" := ROUND(EmployeeJournal."Calculated Value", 1, '<');
                        EmployeeJournal.INSERT(true);

                        EmployeeJournal.RESET;
                        CLEAR(EmployeeJournal);

                        if JnlLoopCnt = 0 then begin
                            if OAPeriodType = OAPeriodType::Daily then begin
                                PostAttendanceOvertimeToJournal(EmployeeNo, EmployeeABS."From Date", true);
                                PostAttendanceDeductionToJournal(EmployeeNo, EmployeeABS."From Date", true);
                            end else
                                PostMonthlyAttendanceLateArriveToJournal(EmployeeNo, EmployeeABS."From Date", true);

                            //EDM+ 14-10-2020
                            if JnlAbsType = JnlAbsType::"Working Day" then begin
                                HrsDiff := JnlAttendHrs - JnlReqHrs;
                                if HrsDiff > 0 then
                                    HrsDiff := FixEmployeeDailyOvertimeValue(EmployeeABS."Employee No.", EmployeeABS."From Date", HrsDiff);
                            end
                            ELSE BEGIN
                                IF JnlAttendHrs > 0 then begin
                                    IF (JnlAbsType = JnlAbsType::Holiday) and (HRSetup."Accumulate Weekend Overtime To Sunday")
                                    and (HRSetup."Accumulate Holiday Overtime To HolidayVac") Then
                                        HrsDiff := 0
                                    ELSE begin
                                        HrsDiff := JnlAttendHrs - JnlReqHrs;
                                        if HrsDiff > 0 then
                                            HrsDiff := FixEmployeeDailyOvertimeValue(EmployeeABS."Employee No.", EmployeeABS."From Date", HrsDiff);
                                    end;
                                end;
                            END;
                            //EDM- 14-10-2020
                        end;

                        MonthlyNetHrs := MonthlyNetHrs + HrsDiff;
                        if JnlSpecialRec then
                            JnlLoopCnt := JnlLoopCnt + 1
                        else
                            JnlLoopCnt := 100;
                    end;
                end;
            until EmployeeABS.NEXT = 0;

        if IsLateArriveDayPenalty(EmployeeABS."Employee No.") = true then
            PostLateArriveDayCountPolicyDeductionToJournal(EmployeeABS."Employee No.", Period);

        if MonthlyNetHrs < 0 then begin
            VMHrs := -1 * MonthlyNetHrs;
            //08.11.2018 EDM.JA+
            if not IsLateArriveDayPenalty(EmployeeABS."Employee No.") then
                VMHrs := VMHrs - GetEmployeeLateArriveHrs(EmployeeABS."Employee No.", EmployeeABS.Period);
            //08.11.2018 EDM.JA-
            VMHrs := VMHrs - GetAttendanceAbsenceToleranceBySchedule(EmployeeABS."Employee No.", '');
            VMHrs := VMHrs * GetAttendanceAbsenceRateBySchedule(EmployeeABS."Employee No.", '');
            MonthlyNetHrs := 0;
            if VMHrs > 0 then
                MonthlyNetHrs := -1 * VMHrs;
        end else begin
            VMHrs := MonthlyNetHrs;
            VMHrs := VMHrs - GetAttendanceOvertimeToleranceBySchedule(EmployeeABS."Employee No.", '');
            VMHrs := VMHrs * GetAttendanceOvertimeRateBySchedule(EmployeeABS."Employee No.", '');

            MonthlyNetHrs := 0;
            if VMHrs > 0 then
                MonthlyNetHrs := VMHrs;
        end;

        if (OAPeriodType = OAPeriodType::Monthly) and (MonthlyNetHrs <> 0) then begin
            PostEmployeeAttendanceOnMonthlyBasis(EmployeeNo, Period, MonthlyNetHrs);
        end;

        UpdateEmpEntitlementTotals(Period, EmployeeNo);
    end;

    local procedure PostAttendanceOvertimeToJournal(EmpNo: Code[20]; AttendDate: Date; UseEmployType: Boolean);
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        OvertimeCode: Code[10];
        OVPayElem: Code[10];
    begin

        if UseEmployType = true then begin
            PostAttendanceOvertimeToJournalByEmployType(EmpNo, AttendDate);
            exit;
        end;

        OVPayElem := '';
        //Get Overtime Code + that have restriction on Unpaid Hours
        CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
        CauseofAbsence.SETRANGE("Unit of Measure Code", 'HOUR');
        CauseofAbsence.SETRANGE("Associated Pay Element", '<>%1', OVPayElem);
        CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::Overtime);
        CauseofAbsence.SETRANGE(Entitled, false);
        CauseofAbsence.SETRANGE("Unpaid Hours", 1, 24); // Check first if there is restriction to number of hours of Overtime

        if CauseofAbsence.FINDFIRST then
            OvertimeCode := CauseofAbsence.Code;

        if OvertimeCode = '' then begin
            CLEAR(CauseofAbsence);
            CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
            CauseofAbsence.SETRANGE("Unit of Measure Code", 'HOUR');
            CauseofAbsence.SETRANGE("Associated Pay Element", OVPayElem);
            CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::Overtime);
            CauseofAbsence.SETRANGE(Entitled, false);
            CauseofAbsence.SETRANGE("Unpaid Hours", 0);
            if CauseofAbsence.FINDFIRST then
                OvertimeCode := CauseofAbsence.Code;
        end;
        //Get Overtime Code -

        if OvertimeCode = '' then
            exit;


        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETRANGE("From Date", AttendDate);
        if EmployeeABS.FINDFIRST = false then
            exit;

        if ((EmployeeABS.Type = EmployeeABS.Type::"Paid Vacation") or (EmployeeABS.Type = EmployeeABS.Type::"Paid Day") or (EmployeeABS.Type = EmployeeABS.Type::"Working Day")) and (EmployeeABS."Attend Hrs." > EmployeeABS."Required Hrs")
            and (EmployeeABS."Attend Hrs." > 0)
            then
          //Overtime
          begin
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.", EmpNo);
            EmployeeJournal."Transaction Type" := 'ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code", OvertimeCode);
            EmployeeJournal.VALIDATE("Starting Date", EmployeeABS."From Date");
            EmployeeJournal.VALIDATE("Ending Date", EmployeeABS."From Date");
            EmployeeJournal.Type := 'ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
            EmployeeJournal.VALIDATE(EmployeeJournal.Value, EmployeeABS."Attend Hrs." - EmployeeABS."Required Hrs");
            EmployeeJournal."Opened By" := USERID;
            EmployeeJournal."Opened Date" := WORKDATE;
            EmployeeJournal."Released By" := USERID;
            EmployeeJournal."Released Date" := WORKDATE;
            EmployeeJournal."Approved By" := USERID;
            EmployeeJournal."Approved Date" := WORKDATE;
            EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
            EmployeeJournal.INSERT(true);
        end;
    end;

    procedure PostAttendanceDeductionToJournal(EmpNo: Code[20]; AttendDate: Date; MergeLateAttend: Boolean);
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        DeductionCode: Code[10];
        DedPayElem: Code[10];
        LateArriveMin: Decimal;
        AbsentHrs: Decimal;
        PolicyType: Option LateArrive,LateLeave,EarlyArrive,EarlyLeave;
        AttType: Option Overtime,Absence;
        ALBalance: Decimal;
        ALAbsHrs: Decimal;
        L_MaxLineNo: Integer;
    begin
        DedPayElem := '';
        //Get Deduction Code +
        //Replaced by a function - 01.08.2016 : AIM +        
        DeductionCode := GetAttendanceCauseOfAbsenceCode(AttType::Absence);
        CauseofAbsence.SETRANGE(CauseofAbsence.Code, DeductionCode);
        if CauseofAbsence.FINDFIRST then begin
        end
        else
            exit;
        //Replaced by a function - 01.08.2016 : AIM -

        if DeductionCode = '' then
            exit;


        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETRANGE("From Date", AttendDate);
        if EmployeeABS.FINDFIRST = false then
            exit;

        if ((EmployeeABS.Type = EmployeeABS.Type::"Paid Day") or (EmployeeABS.Type = EmployeeABS.Type::"Paid Vacation") or (EmployeeABS.Type = EmployeeABS.Type::"Working Day"))
                and (EmployeeABS."Attend Hrs." >= 0) and (EmployeeABS."Required Hrs" > 0) then
        //Deduction
        begin
            //Modified in order to check if Penalty on Late Arrival is allowed or not - 23.08.2016 : AIM +
            if IsPenalizeLateArrive(EmployeeABS."Employee No.") = true then
                LateArriveMin := EmployeeABS."Late Arrive"
            else
                LateArriveMin := 0;
            AbsentHrs := 0;
            if EmployeeABS."Required Hrs" - EmployeeABS."Attend Hrs." > 0 then begin
                AbsentHrs := EmployeeABS."Required Hrs" - EmployeeABS."Attend Hrs.";
                //Modified because break is in Minutes - 22.07.2016 : AIM +                
                AbsentHrs := AbsentHrs - ROUND(GetDailyShiftAssignedBreakMinute(EmployeeABS."Shift Code") / 60, 0.01);
                //Modified because break is in Minutes - 22.07.2016 : AIM -
                AbsentHrs := AbsentHrs - GetAttendanceAbsenceToleranceBySchedule(EmpNo, EmployeeABS."Shift Code");
            end;
            //Modified in order to deduct Late Arrival even if Absent Hrs is 0 - 20.04.2016 : AIM -

            if AbsentHrs > (LateArriveMin / 60) then begin
                AbsentHrs := ROUND(AbsentHrs - (LateArriveMin / 60), 0.01);
            end
            else
                if AbsentHrs = (LateArriveMin / 60) then begin
                    AbsentHrs := 0;
                end
                else begin
                    AbsentHrs := 0;
                end;
            //end;
            //Modified in order to get Absence rate as per Daily Shift - 01.08.2016 : AIM +
            AbsentHrs := AbsentHrs * GetAttendanceAbsenceRateBySchedule(EmpNo, EmployeeABS."Shift Code");
            //Modified in order to get Absence rate as per Daily Shift - 01.08.2016 : AIM -

            if AbsentHrs <= 0 then
                AbsentHrs := 0;

            //Modified in order to add validation - 18.06.2016 : AIM +
            if (MergeLateAttend = true) and (LateArriveMin > 0) then
              //Modified in order to add validation - 18.06.2016 : AIM -
              begin

                //******Add Late Arrive Penalty and convert it to the proper unit********
                LateArriveMin := CalculateLateArrivePenalty(GetAttendancePolicyCauseCodes(PolicyType::LateArrive), LateArriveMin, CauseofAbsence."Unit of Measure Code", EmpNo);
                AbsentHrs := AbsentHrs + LateArriveMin;
                LateArriveMin := 0;
            end;
            //Added in order to deduct Absent Hrs from AL - 15.09.2016 : AIM +
            ALAbsHrs := 0;
            HRSetup.GET;
            if (HRSetup."Deduct Absence From AL") and (HRSetup."Deduct Absence From AL Code" <> '') then begin
                ALBalance := GetEmpAbsenceEntitlementCurrentBalance(EmpNo, HRSetup."Annual Leave Code", 0D);
                ALBalance := ROUND(ALBalance * GetEmployeeDailyHours(EmpNo, ''));
                if (ALBalance > 0) and (AbsentHrs > 0) then begin
                    if (AbsentHrs >= ALBalance) then begin
                        ALAbsHrs := ALAbsHrs + ALBalance;
                        AbsentHrs := ROUND(AbsentHrs - ALBalance, 0.01);
                        ALBalance := 0;
                    end
                    else begin
                        ALBalance := ALBalance - AbsentHrs;
                        ALAbsHrs := ALAbsHrs + AbsentHrs;
                        AbsentHrs := 0;
                    end;
                end;
                if (ALBalance > 0) and (LateArriveMin > 0) then begin
                    if (LateArriveMin >= ALBalance) then begin
                        ALAbsHrs := ALAbsHrs + ALBalance;
                        LateArriveMin := ROUND(LateArriveMin - ALBalance, 0.01);
                        ALBalance := 0;
                    end
                    else begin
                        ALBalance := ALBalance - LateArriveMin;
                        ALAbsHrs := ALAbsHrs + LateArriveMin;
                        LateArriveMin := 0;
                    end;
                end;
                //07.03.2018 +
                EmployeeJournal.RESET;
                CLEAR(EmployeeJournal);
                L_MaxLineNo := 0;

                EmployeeJournal.SETRANGE("Employee No.", EmpNo);
                if EmployeeJournal.FIND('+') then
                    L_MaxLineNo := EmployeeJournal."Entry No.";

                L_MaxLineNo := L_MaxLineNo + 1;
                CLEAR(EmployeeJournal);
                EmployeeJournal.RESET;
                //07.03.2018 -
                if ALAbsHrs > 0 then begin
                    EmployeeJournal.INIT;
                    EmployeeJournal.VALIDATE("Employee No.", EmpNo);
                    EmployeeJournal."Transaction Type" := 'ABS';
                    EmployeeJournal.VALIDATE("Cause of Absence Code", HRSetup."Deduct Absence From AL Code");
                    EmployeeJournal.VALIDATE("Starting Date", EmployeeABS."From Date");
                    EmployeeJournal.VALIDATE("Ending Date", EmployeeABS."From Date");
                    EmployeeJournal.Type := 'ABSENCE';
                    EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
                    EmployeeJournal.VALIDATE(EmployeeJournal.Value, ALAbsHrs);
                    EmployeeJournal."Opened By" := USERID;
                    EmployeeJournal."Opened Date" := WORKDATE;
                    EmployeeJournal."Released By" := USERID;
                    EmployeeJournal."Released Date" := WORKDATE;
                    EmployeeJournal."Approved By" := USERID;
                    EmployeeJournal."Approved Date" := WORKDATE;
                    EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
                    //07.03.2018 +
                    EmployeeJournal."Entry No." := L_MaxLineNo;
                    EmployeeJournal.INSERT(true);
                    EmployeeJournal.RESET;
                    CLEAR(EmployeeJournal);
                    L_MaxLineNo := L_MaxLineNo + 1;
                    //07.03.2018 -
                end;
            end;
            //Added in order to deduct Absent Hrs from AL - 15.09.2016 : AIM -
            //07.03.2018 +
            EmployeeJournal.RESET;
            CLEAR(EmployeeJournal);
            //07.03.2018 -
            if AbsentHrs > 0 then begin
                EmployeeJournal.INIT;
                EmployeeJournal.VALIDATE("Employee No.", EmpNo);
                EmployeeJournal."Transaction Type" := 'ABS';
                EmployeeJournal.VALIDATE("Cause of Absence Code", DeductionCode);
                EmployeeJournal.VALIDATE("Starting Date", EmployeeABS."From Date");
                EmployeeJournal.VALIDATE("Ending Date", EmployeeABS."From Date");
                EmployeeJournal.Type := 'ABSENCE';
                EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
                EmployeeJournal.VALIDATE(EmployeeJournal.Value, AbsentHrs);
                EmployeeJournal."Opened By" := USERID;
                EmployeeJournal."Opened Date" := WORKDATE;
                EmployeeJournal."Released By" := USERID;
                EmployeeJournal."Released Date" := WORKDATE;
                EmployeeJournal."Approved By" := USERID;
                EmployeeJournal."Approved Date" := WORKDATE;
                EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
                //07.03.2018 +
                EmployeeJournal."Entry No." := L_MaxLineNo;
                EmployeeJournal.INSERT(true);
                EmployeeJournal.RESET;
                CLEAR(EmployeeJournal);
                //07.03.2018 -
            end;

            if LateArriveMin > 0 then begin
                PostAttendanceLatenessToJournal(EmpNo, EmployeeABS.Period, EmployeeABS."From Date", LateArriveMin, DeductionCode, MergeLateAttend);
            end;

        end;
        //Added in order to update entitle balance on each insert - 08.03.2018 : AIM +
        UpdateEmpEntitlementTotals(EmployeeABS.Period, EmpNo);
        //Added in order to update entitle balance on each insert - 08.03.2018 : AIM -


    end;

    local procedure PostMonthlyAttendanceOvertimeToJournal(EmpNo: Code[20]; AttendDate: Date);
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        OvertimeCode: Code[10];
        OVPayElem: Code[10];
        PayrollParameter: Record "Payroll Parameter";
        OvertimeVar: Decimal;
        AttendHrVar: Decimal;
        RequiredHrVar: Decimal;
        LateLeaveVar: Decimal;
        EarlyArriveVar: Decimal;
        EmploymentTypeRec: Record "Employment Type";
        EmployeeRec: Record "Employee";
    begin
        AttendHrVar := 0;
        RequiredHrVar := 0;
        OvertimeVar := 0;
        LateLeaveVar := 0;

        PayrollParameter.Get;
        //Get Overtime Code + that have restriction on Unpaid Hours
        CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
        CauseofAbsence.SETRANGE("Unit of Measure Code", 'HOUR');
        CauseofAbsence.SETRANGE("Associated Pay Element", PayrollParameter.OverTime);
        CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::Overtime);
        CauseofAbsence.SETRANGE(Entitled, false);
        CauseofAbsence.SETRANGE("Unpaid Hours", 1, 24); // Check first if there is restriction to number of hours of Overtime
        if CauseofAbsence.FINDFIRST then
            OvertimeCode := CauseofAbsence.Code;

        if OvertimeCode = '' then begin
            CLEAR(CauseofAbsence);
            CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
            CauseofAbsence.SETRANGE("Unit of Measure Code", 'HOUR');
            CauseofAbsence.SETRANGE("Associated Pay Element", PayrollParameter.OverTime);
            CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::Overtime);
            CauseofAbsence.SETRANGE(Entitled, false);
            CauseofAbsence.SETRANGE("Unpaid Hours", 0);
            if CauseofAbsence.FINDFIRST then
                OvertimeCode := CauseofAbsence.Code;
        end;
        //Get Overtime Code -

        if OvertimeCode = '' then
            exit;

        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETRANGE("From Date", AttendDate);
        if EmployeeABS.FINDFIRST = false then
            exit;

        EmployeeABS.RESET;
        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETFILTER(Period, '%1', AttendDate);
        EmployeeABS.SETFILTER(Type, '%1|%2|%3', EmployeeABS.Type::"Paid Vacation", EmployeeABS.Type::"Paid Day", EmployeeABS.Type::"Working Day");
        EmployeeABS.SETFILTER("Attend Hrs.", '>%1', 0);
        IF EmployeeABS.FindFirst Then
            repeat
                IF EmployeeABS."Attend Hrs." > EmployeeABS."Required Hrs" then BEGIN
                    AttendHrVar := AttendHrVar + EmployeeABS."Attend Hrs.";
                    RequiredHrVar := RequiredHrVar + EmployeeABS."Required Hrs";
                    LateLeaveVar := LateLeaveVar + EmployeeABS."Late Leave";
                    EarlyArriveVar := EarlyArriveVar + EmployeeABS."Early Arrive";
                END;
            UNTIL EmployeeABS.NEXT = 0;
        //18-01-2021
        EmployeeRec.SETRANGE("No.", EmpNo);
        if EmployeeRec.FINDFIRST then begin
            if EmployeeRec."Employment Type Code" <> '' then begin
                EmploymentTypeRec.SETRANGE(EmploymentTypeRec.Code, EmployeeRec."Employment Type Code");
                if EmploymentTypeRec.FINDFIRST then begin
                    if EmploymentTypeRec."Early Arrive Not Allowed" then
                        EarlyArriveVar := 0;
                end;
            end;
        end;
        //18-01-2021
        OvertimeVar := (OvertimeVar + (LateLeaveVar / 60) + (EarlyArriveVar / 60)) * GetAttendanceOvertimeRateBySchedule(EmpNo, EmployeeABS."Shift Code");

        IF OvertimeVar > 0 THEN BEGIN
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.", EmpNo);
            EmployeeJournal."Transaction Type" := 'ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code", OvertimeCode);
            EmployeeJournal.VALIDATE("Starting Date", EmployeeABS.Period);
            EmployeeJournal.VALIDATE("Ending Date", EmployeeABS.Period);
            EmployeeJournal.Type := 'ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
            EmployeeJournal.VALIDATE(EmployeeJournal.Value, OvertimeVar);
            EmployeeJournal."Opened By" := USERID;
            EmployeeJournal."Opened Date" := WORKDATE;
            EmployeeJournal."Released By" := USERID;
            EmployeeJournal."Released Date" := WORKDATE;
            EmployeeJournal."Approved By" := USERID;
            EmployeeJournal."Approved Date" := WORKDATE;
            EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
            EmployeeJournal.INSERT(true);
        END;
    end;

    procedure PostMonthlyAttendanceDeductionToJournal(EmpNo: Code[20]; AttendDate: Date);
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        DeductionCode: Code[10];
        DedPayElem: Code[10];
        LateArriveMin: Decimal;
        AbsentHrs: Decimal;
        PolicyType: Option LateArrive,LateLeave,EarlyArrive,EarlyLeave;
        AttType: Option Overtime,Absence;
        ALBalance: Decimal;
        ALAbsHrs: Decimal;
        AttendHrVar: Decimal;
        RequiredHrVar: Decimal;
        LateArriveVarMins: Decimal;
        EarlyLeaveVarMins: Decimal;
        LateArriveVarHrs: Decimal;
        EarlyLeaveVarHrs: Decimal;
        AbsentHoursVar: Decimal;
        L_MaxLineNo: Integer;
        PayrollParameter: Record "Payroll Parameter";
        EmploymentType: Record "Employment Type";
    begin
        AbsentHrs := 0;
        AttendHrVar := 0;
        RequiredHrVar := 0;
        LateArriveMin := 0;
        LateArriveVarMins := 0;
        EarlyLeaveVarMins := 0;
        LateArriveVarHrs := 0;
        EarlyLeaveVarHrs := 0;
        AbsentHoursVar := 0;

        DeductionCode := GetAttendanceCauseOfAbsenceCode(AttType::Absence);

        if DeductionCode = '' then
            exit;

        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETRANGE("From Date", AttendDate);
        if EmployeeABS.FINDFIRST = false then
            exit;

        EmployeeABS.RESET;
        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETFILTER(Period, '%1', AttendDate);
        EmployeeABS.SETFILTER(Type, '%1|%2', EmployeeABS.Type::"Paid Day", EmployeeABS.Type::"Working Day");
        EmployeeABS.SETFILTER("Attend Hrs.", '>=%1', 0);
        EmployeeABS.SETFILTER("Required Hrs", '>%1', 0);
        IF EmployeeABS.FindFirst Then
            repeat
                LateArriveVarMins := LateArriveVarMins + EmployeeABS."Late Arrive";// in minutes
                EarlyLeaveVarMins := EarlyLeaveVarMins + EmployeeABS."Early Leave";// in minutes
            UNTIL EmployeeABS.NEXT = 0;
        //
        EmployeeABS.RESET;
        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETFILTER(Period, '%1', AttendDate);
        EmployeeABS.SETFILTER(Type, '%1|%2', EmployeeABS.Type::"Paid Day", EmployeeABS.Type::"Working Day");
        EmployeeABS.SETFILTER("Attend Hrs.", '=%1', 0);
        EmployeeABS.SETFILTER("Required Hrs", '>%1', 0);
        IF EmployeeABS.FindFirst Then
            repeat
                AbsentHoursVar := AbsentHoursVar + EmployeeABS."Required Hrs";
            UNTIL EmployeeABS.NEXT = 0;
        //
        EarlyLeaveVarHrs := ROUND(EarlyLeaveVarMins / 60);
        LateArriveVarHrs := ROUND(LateArriveVarMins / 60);

        EmployeeABS.CALCFIELDS("Employment Type");
        EmploymentType.SETRANGE(Code, EmployeeABS."Employment Type");
        IF EmploymentType.FINDFIRST THEN BEGIN
            IF EmploymentType."Absence Tolerance Hours" <> 0 then begin
                IF LateArriveVarHrs > EmploymentType."Absence Tolerance Hours" then
                    LateArriveVarHrs := ((LateArriveVarHrs - EmploymentType."Absence Tolerance Hours") * EmploymentType."Absence Deduction Rate")
                ELSE
                    LateArriveVarHrs := 0;
            end;
        END;

        AbsentHrs := ROUND(EarlyLeaveVarHrs + LateArriveVarHrs + AbsentHoursVar);

        if AbsentHrs > 0 then begin
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.", EmpNo);
            EmployeeJournal."Transaction Type" := 'ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code", DeductionCode);
            EmployeeJournal.VALIDATE("Starting Date", EmployeeABS.Period);
            EmployeeJournal.VALIDATE("Ending Date", EmployeeABS.Period);
            EmployeeJournal.Type := 'ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
            EmployeeJournal.VALIDATE(EmployeeJournal.Value, AbsentHrs);
            EmployeeJournal."Opened By" := USERID;
            EmployeeJournal."Opened Date" := WORKDATE;
            EmployeeJournal."Released By" := USERID;
            EmployeeJournal."Released Date" := WORKDATE;
            EmployeeJournal."Approved By" := USERID;
            EmployeeJournal."Approved Date" := WORKDATE;
            EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
            EmployeeJournal.INSERT(true);
        end;
    end;

    procedure GetDailyAttendanceInOutTime(EmpNo: Code[20]; AttendDate: Date; GetIn: Boolean; UseDefTime: Boolean) InOutTime: Time;
    var
        HandPunch: Record "Hand Punch";
        PunchTime: Time;
        Employee: Record Employee;
        EmpAttendNo: Integer;
        EmpAbs: Record "Employee Absence";
    begin
        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then
            EmpAttendNo := Employee."Attendance No.";

        if EmpAttendNo = 0 then
            exit(PunchTime);


        HandPunch.SETRANGE(HandPunch."Scheduled Date", AttendDate);
        HandPunch.SETRANGE("Attendnace No.", EmpAttendNo);
        if GetIn = true then
            HandPunch.SETRANGE("Action Type", 'IN')
        else
            HandPunch.SETRANGE("Action Type", 'OUT');

        if HandPunch.FINDFIRST then
            PunchTime := HandPunch."Real Time";
        repeat
            if GetIn = true then begin
                if HandPunch."Real Time" < PunchTime then
                    PunchTime := HandPunch."Real Time";
            end
            else begin
                if HandPunch."Real Time" > PunchTime then
                    PunchTime := HandPunch."Real Time";
            end;

        until HandPunch.NEXT = 0;

        IF (PunchTime = 0T) AND (UseDefTime = TRUE) THEN begin
            EmpAbs.SETRANGE("Employee No.", EmpNo);
            EmpAbs.SETRANGE("From Date", AttendDate);
            if EmpAbs.FINDFIRST then begin
                if GetIn = true then
                    PunchTime := EmpAbs."From Time"
                else
                    PunchTime := EmpAbs."To Time";
            end;
        end;

        exit(PunchTime);
    end;

    procedure DeleteEmpAttendanceJournals(EmployeeNo: Code[20]; Period: Date);
    var
        EmpJournalRec: Record "Employee Journal Line";
        AllowDelete: Boolean;
    begin
        AllowDelete := false;
        if CanModifyAttendancePeriod(EmployeeNo, Period, true, true, false, false) = true then
            AllowDelete := true;

        if AllowDelete = true then begin
            EmpJournalRec.SETCURRENTKEY("Employee No.", "Transaction Type", Type, "Transaction Date");
            EmpJournalRec.SETRANGE("Employee No.", EmployeeNo);
            EmpJournalRec.SETRANGE("Transaction Type", 'ABS');
            EmpJournalRec.SETRANGE(Type, 'ABSENCE');
            EmpJournalRec.SETRANGE("Transaction Date", Period);
            if EmpJournalRec.FIND('-') then
                repeat
                    //Added in order not to delete the records that were processed - 07.12.2016 : AIM +
                    if EmpJournalRec.Processed = false then
                        //Added in order not to delete the records that were processed - 07.12.2016 : AIM -
                        EmpJournalRec.DELETE;
                until EmpJournalRec.NEXT = 0;
            //Added in order to update totals in Employee Absence Entitlements - 06.04.2016 : AIM +
            UpdateEmpEntitlementTotals(Period, EmployeeNo);
            //Added in order to update totals in Employee Absence Entitlements - 06.04.2016 : AIM -
        end;
    end;

    procedure GetNoOfEligibleChildsExemptTax(Employee: Record Employee; TaxType: Option NSSF,TAX,EST,FA; TaxToDate: Date): Integer;
    var
        NoOfEligibleChilds: Integer;
        EmpRelative: Record "Employee Relative";
        AgeLimit: Text[30];
        ChildBirthDate: Date;
        MINDATE: Date;
        MAXDATE: Date;
        Sex: Option Male,Female;
    begin
        PayParam.GET;
        NoOfEligibleChilds := 0;
        CLEAR(EmpRelative);
        EmpRelative.SETRANGE(EmpRelative."Employee No.", Employee."No.");
        EmpRelative.SETRANGE("Eligible Exempt Tax", true);
        //AIM +
        EmpRelative.SETRANGE(Type, EmpRelative.Type::Child);
        //AIM -
        if (TaxType = TaxType::NSSF) or (TaxType = TaxType::TAX) then begin
            EmpRelative.SETFILTER("Registeration Start Date", '=%1|<=%2', 0D, TaxToDate);
            EmpRelative.SETFILTER("Registeration End Date", '=%1|>=%2', 0D, TaxToDate);
        end;
        while EmpRelative.NEXT <> 0 do begin
            ChildBirthDate := 0D;

            if EmpRelative."Birth Date" <> 0D then begin

                if (EmpRelative.Sex = EmpRelative.Sex::Female) or (EmpRelative.Student = EmpRelative.Student::Yes) then begin
                    AgeLimit := FORMAT(PayParam."Max. Pension Age") + 'Y';
                    ChildBirthDate := CALCDATE(AgeLimit, EmpRelative."Birth Date");
                end
                else begin
                    if PayParam."Max. Pension Not Student Age" <= 0 then
                        PayParam."Max. Pension Not Student Age" := 18;

                    AgeLimit := FORMAT(PayParam."Max. Pension Age") + 'Y';
                    ChildBirthDate := CALCDATE(AgeLimit, EmpRelative."Birth Date");
                end;

            end;

            if not EmpRelative.Working then begin
                NoOfEligibleChilds := NoOfEligibleChilds + 1;
                //EDM+
                if TaxToDate = 0D then begin
                    MAXDATE := DMY2DATE(15, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
                    MINDATE := DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
                end
                else begin
                    MAXDATE := TaxToDate;
                    MINDATE := CALCDATE('-1M', MAXDATE);
                end;
                //Modified in order to calculate the Child Birth Date according to Payroll Date and not system date - 27.07.2016 : AIM -

                //Modified in order to calculate the Child Birth Date according to Payroll Date and not system date - 27.07.2016 : AIM +
                if (ChildBirthDate < MINDATE)
                 and
                  (ChildBirthDate <> 0D) and (EmpRelative."Permenant Disability" = EmpRelative."Permenant Disability"::No) then begin
                    // Get Gender of Child since two fields for gender exists - 13.02.2016 : AIM+
                    Sex := Sex::Male;
                    if (EmpRelative.Sex = EmpRelative.Sex::Male) or (EmpRelative.Sex = EmpRelative.Sex::Female) then begin
                        Sex := EmpRelative.Sex;
                    end
                    else begin
                        IF EmpRelative."Arabic Gender" <> EmpRelative."Arabic Gender"::"ذكر" THEN
                            Sex := Sex::Female
                        else
                            Sex := Sex::Male;
                    end;
                    // Get Gender of Child since two fields for gender exists - 13.02.2016 : AIM-
                    case Sex of
                        Sex::Female:
                            begin
                                if ((EmpRelative."Social Status" = EmpRelative."Social Status"::Married) and (TaxType = TaxType::TAX))
                                   or (TaxType <> TaxType::TAX) then
                                    NoOfEligibleChilds := NoOfEligibleChilds - 1;
                            end;
                    end;
                end;

                if (Sex = Sex::Female) and
                  (EmpRelative."Social Status" = EmpRelative."Social Status"::Married) then
                    NoOfEligibleChilds := NoOfEligibleChilds - 1;
                //EDM-
                //EDM+ 14-05-2019
                IF (DATE2DMY(Employee.Period, 3) = DATE2DMY(EmpRelative."Birth Date", 3)) AND (DATE2DMY(Employee.Period, 2) = DATE2DMY(EmpRelative."Birth Date", 2)) then BEGIN
                    IF DATE2DMY(EmpRelative."Birth Date", 1) > 15 THEN
                        NoOfEligibleChilds := NoOfEligibleChilds - 1;
                END;
                //EDM- 14-05-2019
            end;
        end;  // relatives
        if NoOfEligibleChilds > PayParam."Max. Pension Eligible Child" then
            NoOfEligibleChilds := PayParam."Max. Pension Eligible Child";

        exit(NoOfEligibleChilds);
    end;

    procedure FixEmployeeDailyAttendanceHours(EmpNo: Code[20]; AttendPeriod: Date; AttendDate: Date; UpdateAttendRecord: Boolean; KeyString: Text);
    var
        EmpAbs: Record "Employee Absence";
        HandPunch: Record "Hand Punch";
        EmploymentTypeRec: Record "Employment Type";
        Emp: Record Employee;
        LateArriveMin: Decimal;
        LateDepartureMin: Decimal;
        EarlyArriveMin: Decimal;
        EarlyDepartureMin: Decimal;
        ReqMin: Decimal;
        AttendMin: Decimal;
        Overtime: Decimal;
        Absence: Decimal;
        EmpAttendNo: Integer;
        MinTime: DateTime;
        MaxTime: DateTime;
        i: Integer;
        FTime: DateTime;
        TTime: DateTime;
        AddMin: Decimal;
        DedMin: Decimal;
        ActualEarlyArriveMin: Decimal;
        ActualLateDepartureMin: Decimal;
        ActualLateArriveMin: Decimal;
        LABaseTime: Time;
        EmployeeRec: Record "Employee";
    begin
        EmpAbs.SETCURRENTKEY("Employee No.", "From Date", Period);
        if EmpNo <> '' then
            EmpAbs.SETRANGE("Employee No.", EmpNo);
        if AttendPeriod <> 0D then
            EmpAbs.SETRANGE(Period, AttendPeriod);
        if AttendDate <> 0D then
            EmpAbs.SETRANGE("From Date", AttendDate);
        if EmpAbs.FINDFIRST then
            repeat
                Emp.SETRANGE("No.", EmpNo);
                if Emp.FINDFIRST then begin
                    EmpAttendNo := Emp."Attendance No.";
                    IF Emp."Employment Type Code" <> '' THEN begin
                        EmploymentTypeRec.SETRANGE(Code, Emp."Employment Type Code");
                        IF EmploymentTypeRec.FINDFIRST then begin
                            LABaseTime := EmploymentTypeRec."Late Arrive Base Time";
                        end;
                    end;
                end;
                MinTime := 0DT;
                MaxTime := 0DT;

                IF (EmpAttendNo > 0) AND (EmpAbs."From Time" <> 0T) AND (EmpAbs."To Time" <> 0T) THEN begin
                    HandPunch.SETCURRENTKEY("Attendnace No.", "Real Date", "Real Time");
                    HandPunch.SETRANGE("Attendnace No.", EmpAttendNo);
                    HandPunch.SETRANGE("Scheduled Date", EmpAbs."From Date");
                    HandPunch.SETFILTER("Real Time", '<>%1', 0T);
                    if HandPunch.FINDFIRST then begin
                        MinTime := CREATEDATETIME(HandPunch."Real Date", HandPunch."Real Time");
                        MaxTime := CREATEDATETIME(HandPunch."Real Date", HandPunch."Real Time");

                        HandPunch.SETCURRENTKEY("Attendnace No.", "Real Date", "Real Time");
                        HandPunch.SETRANGE("Attendnace No.", EmpAttendNo);
                        HandPunch.SETRANGE("Scheduled Date", EmpAbs."From Date");
                        HandPunch.SETFILTER("Real Time", '<>%1', 0T);
                        HandPunch.FINDLAST;
                        MaxTime := CREATEDATETIME(HandPunch."Real Date", HandPunch."Real Time");

                        EarlyArriveMin := 0;
                        LateArriveMin := 0;
                        if MinTime = CREATEDATETIME(EmpAbs."From Date", EmpAbs."From Time") then begin
                            EarlyArriveMin := 0;
                            LateArriveMin := 0;
                        end else
                            if MinTime > CREATEDATETIME(EmpAbs."From Date", EmpAbs."From Time") then begin
                                EarlyArriveMin := 0;
                                LateArriveMin := (MinTime - CREATEDATETIME(EmpAbs."From Date", EmpAbs."From Time")) / 60000;
                            end else begin
                                EarlyArriveMin := ABS((CREATEDATETIME(EmpAbs."From Date", EmpAbs."From Time") - MinTime) / 60000);
                                LateArriveMin := 0;
                            end;

                        ActualLateArriveMin := LateArriveMin;

                        IF LABaseTime <> 0T then begin
                            if MinTime = CREATEDATETIME(EmpAbs."From Date", LABaseTime) then begin
                                LateArriveMin := 0;
                            end
                            else
                                if MinTime > CREATEDATETIME(EmpAbs."From Date", LABaseTime) then begin
                                    LateArriveMin := (MinTime - CREATEDATETIME(EmpAbs."From Date", LABaseTime)) / 60000;
                                end
                                else begin
                                    LateArriveMin := 0;
                                end;
                        end;

                        EarlyDepartureMin := 0;
                        LateDepartureMin := 0;
                        if MaxTime = CREATEDATETIME(EmpAbs."From Date", EmpAbs."To Time") then begin
                            EarlyDepartureMin := 0;
                            LateDepartureMin := 0;
                        end else
                            if MaxTime > CREATEDATETIME(EmpAbs."From Date", EmpAbs."To Time") then begin
                                EarlyDepartureMin := 0;
                                LateDepartureMin := (MaxTime - CREATEDATETIME(EmpAbs."From Date", EmpAbs."To Time")) / 60000;
                            end else begin
                                EarlyDepartureMin := ABS((CREATEDATETIME(EmpAbs."From Date", EmpAbs."To Time") - MaxTime) / 60000);
                                LateDepartureMin := 0;
                            end;

                        FTime := 0DT;
                        TTime := 0DT;
                        AttendMin := 0;
                        //Added in order to have the option of considering only the first and last punch - 03.03.2017 : AIM +
                        if not IsConsiderFirstandLastPunchOnly(EmpNo) then begin
                            //Added in order to have the option of considering only the first and last punch - 03.03.2017 : AIM -
                            HandPunch.SETCURRENTKEY("Attendnace No.", "Real Date", "Real Time"); // Keep the current order in order to sort by time
                            HandPunch.SETRANGE("Attendnace No.", EmpAttendNo);
                            //Modified in order to consider Scheduled Date - 02.08.2016 : AIM +
                            HandPunch.SETRANGE("Scheduled Date", EmpAbs."From Date");
                            //Modified in order to consider Scheduled Date - 02.08.2016 : AIM -
                            HandPunch.SETFILTER("Real Time", '<>%1', 0T);
                            HandPunch.FIND('-');
                            repeat
                                if (FTime = 0DT) and (TTime = 0DT) then begin
                                    FTime := CREATEDATETIME(HandPunch."Real Date", HandPunch."Real Time");
                                end else
                                    if (FTime <> 0DT) and (TTime = 0DT) then begin
                                        TTime := CREATEDATETIME(HandPunch."Real Date", HandPunch."Real Time");
                                    end;
                                // 21.02.2018 : EDM.Tarek
                                FixLunchBreakTime(EmpAbs."Shift Code", FTime, TTime, HandPunch."Attendnace No.");
                                // 21.02.2018 : EDM.Tarek
                                if (FTime <> 0DT) and (TTime <> 0DT) then begin
                                    AttendMin := AttendMin + (TTime - FTime) / 60000;
                                    FTime := 0DT;
                                    TTime := 0DT;
                                end;
                            until HandPunch.NEXT = 0;
                            //Added in order to have the option of considering only the first and last punch - 03.03.2017 : AIM +
                        end else begin
                            AttendMin := (MaxTime - MinTime) / 60000;
                        end;
                        //Added in order to have the option of considering only the first and last punch - 03.03.2017 : AIM -

                        ReqMin := 0;
                        IF (EmpAbs."From Time" <> 0T) AND (EmpAbs."To Time" <> 0T) THEN
                            ReqMin := (EmpAbs."To Time" - EmpAbs."From Time") / 60000;

                        AddMin := 0;
                        DedMin := 0;
                        if ReqMin > AttendMin then begin
                            AddMin := 0;
                            DedMin := (ReqMin - AttendMin);
                        end else begin
                            AddMin := (ReqMin - AttendMin);
                            DedMin := 0;
                        end;
                        //**************

                        //Added in order to fix the attended hrs in case the hours of Early leave and Late Leave are not considered as Attended Hrs - 16.06.2016 : AIM +
                        ActualLateDepartureMin := LateDepartureMin;
                        ActualEarlyArriveMin := EarlyArriveMin;
                        LateDepartureMin := FixEmployeeDailyLateLeaveValue(EmpAbs."Employee No.", EmpAbs."From Date", LateDepartureMin);
                        EarlyArriveMin := FixEmployeeDailyEarlyArriveValue(EmpAbs."Employee No.", EmpAbs."From Date", EarlyArriveMin);
                        if LateDepartureMin <> ActualLateDepartureMin then
                            AttendMin := AttendMin - ActualLateDepartureMin;
                        if EarlyArriveMin <> ActualEarlyArriveMin then
                            AttendMin := AttendMin - ActualEarlyArriveMin;

                        //Added in order to fix the attended hrs in case the hours of Early leave and Late Leave are not considered as Attended Hrs - 16.06.2016 : AIM -
                        // Added in order to consider one punch - 02.01.2018 : A2+
                        IF AttendMin <= 0 THEN BEGIN
                            AttendMin := 0;
                            EarlyDepartureMin := 0;
                            LateArriveMin := 0;
                            ActualLateDepartureMin := 0;
                            EarlyArriveMin := 0;
                            ActualEarlyArriveMin := 0;
                            LateDepartureMin := 0;
                            ActualLateArriveMin := 0;
                        END;
                        // Added in order to consider one punch - 02.01.2018 : A2-
                        if UpdateAttendRecord = true then begin
                            //Added in order to auto insert the dimensions as per employee file - 07.11.2016 : AIM +
                            if ((STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0)) or ((EmpAbs."Required Hrs" > 0) and (EmpAbs."Attend Hrs." = 0)
                                  and (EmpAbs."Actual Attend Hrs" = 0) and (EmpAbs."Actual Late Arrive" = 0)
                                  and (EmpAbs."Actual Early Leave" = 0) and (EmpAbs."Actual Early Arrive" = 0) and (EmpAbs."Actual Late Leave" = 0)) then begin
                                if Emp."Global Dimension 1 Code" <> '' then
                                    EmpAbs."Global Dimension 1 Code" := Emp."Global Dimension 1 Code";
                                if Emp."Global Dimension 2 Code" <> '' then
                                    EmpAbs."Global Dimension 2 Code" := Emp."Global Dimension 2 Code";
                            end;
                            //Added in order to auto insert the dimensions as per employee file - 07.11.2016 : AIM -

                            //Code Re-Modified for more validations - 27.09.2016 : AIM +
                            if (STRPOS(UPPERCASE(KeyString), UPPERCASE('LA')) > 0) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0) then begin
                                //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM +
                                if ((EmpAbs."Attend Hrs." = 0) and (EmpAbs."Late Arrive" = 0) and (EmpAbs."Actual Late Arrive" = 0)) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0) then begin
                                    IF LABaseTime <> 0T then
                                        EmpAbs."Late Arrive" := ROUND(LateArriveMin, 0.01)
                                    else
                                        EmpAbs."Late Arrive" := ROUND(ActualLateArriveMin, 0.01);
                                end;
                                EmpAbs."Actual Late Arrive" := ROUND(ActualLateArriveMin, 0.01);
                            end;
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM -

                            if (STRPOS(UPPERCASE(KeyString), UPPERCASE('EL')) > 0) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0) then
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM +
                            begin
                                if ((EmpAbs."Attend Hrs." = 0) and (EmpAbs."Early Leave" = 0) and (EmpAbs."Actual Early Leave" = 0)) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0) then
                                    EmpAbs."Early Leave" := ROUND(EarlyDepartureMin, 0.01);
                                EmpAbs."Actual Early Leave" := ROUND(EarlyDepartureMin, 0.01);
                            end;
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM -

                            if ((STRPOS(UPPERCASE(KeyString), UPPERCASE('EA')) > 0) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0)) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0) then
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM +
                            begin
                                if (EmpAbs."Attend Hrs." = 0) and (EmpAbs."Early Arrive" = 0) and (EmpAbs."Actual Early Arrive" = 0) then
                                    EmpAbs."Early Arrive" := ROUND(EarlyArriveMin, 0.01);
                                EmpAbs."Actual Early Arrive" := ROUND(ActualEarlyArriveMin, 0.01);
                            end;
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM -

                            if ((STRPOS(UPPERCASE(KeyString), UPPERCASE('LL')) > 0) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0)) then
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM +
                            begin
                                if (EmpAbs."Attend Hrs." = 0) and (EmpAbs."Late Leave" = 0) and (EmpAbs."Actual Late Leave" = 0) then
                                    EmpAbs."Late Leave" := ROUND(LateDepartureMin, 0.01);
                                EmpAbs."Actual Late Leave" := ROUND(ActualLateDepartureMin, 0.01);
                            end;
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM -
                            if (STRPOS(UPPERCASE(KeyString), UPPERCASE('AH')) > 0) or (STRPOS(UPPERCASE(KeyString), UPPERCASE('ALL')) > 0) then
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM +
                            begin
                                EmpAbs."Attend Hrs." := ROUND(AttendMin / 60, 0.01);
                                EmpAbs."Actual Attend Hrs" := ROUND(AttendMin / 60, 0.01);
                            end;
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM -

                            if (STRPOS(UPPERCASE(KeyString), UPPERCASE('A0')) > 0) and (EmpAbs."Attend Hrs." = 0) then
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM +
                            begin
                                EmpAbs."Attend Hrs." := ROUND(AttendMin / 60, 0.01);
                                EmpAbs."Actual Attend Hrs" := ROUND(AttendMin / 60, 0.01);
                            end;
                            //Modified in order to save the actual value as per hand punch - 16.06.2016 : AIM -

                            //Code Re-Modified for more validations - 27.09.2016 : AIM -

                            //Added in order to update the actual values of (Attend,LA,EL,EA and LA) as per hand punch - 16.06.2016 : AIM -
                            if (STRPOS(UPPERCASE(KeyString), UPPERCASE('ACT')) > 0) then begin
                                EmpAbs."Actual Attend Hrs" := ROUND(AttendMin / 60, 0.01);
                                if LABaseTime <> 0T then
                                    EmpAbs."Actual Late Arrive" := ROUND(ActualLateArriveMin, 0.01)
                                else
                                    EmpAbs."Actual Late Arrive" := ROUND(LateArriveMin, 0.01);
                                EmpAbs."Actual Early Leave" := ROUND(EarlyDepartureMin, 0.01);
                                EmpAbs."Actual Early Arrive" := ROUND(ActualEarlyArriveMin, 0.01);
                                EmpAbs."Actual Late Leave" := ROUND(ActualLateDepartureMin, 0.01);
                            end;
                            //Added in order to update the actual values of (Attend,LA,EL,EA and LA) as per hand punch - 16.06.2016 : AIM +
                            //18-01-2021
                            IF (EmpAbs."Shift Code" = 'WEEKEND') OR (EmpAbs."Shift Code" = 'WEEKEND*') OR (EmpAbs."Shift Code" = 'LOCKDOWN') then begin
                                EmpAbs."Late Arrive" := 0;
                                EmpAbs."Actual Late Arrive" := 0;
                                EmpAbs."Early Leave" := 0;
                                EmpAbs."Actual Early Leave" := 0;
                                Emp.SETRANGE("No.", EmpNo);
                                if Emp.FINDFIRST then begin
                                    if Emp."Employment Type Code" <> '' then begin
                                        EmploymentTypeRec.SETRANGE(EmploymentTypeRec.Code, Emp."Employment Type Code");
                                        if EmploymentTypeRec.FINDFIRST then begin
                                            if EmploymentTypeRec."Early Arrive Not Allowed" then begin
                                                EmpAbs."Early Arrive" := 0;
                                                EmpAbs."Actual Early Arrive" := 0;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                            IF (EmpAbs."Shift Code" = '0.25AL') OR (EmpAbs."Shift Code" = '0.5AL') OR (EmpAbs."Shift Code" = '0.75AL') OR
                            (EmpAbs."Shift Code" = '0.25AL*') OR (EmpAbs."Shift Code" = '0.5AL*') OR (EmpAbs."Shift Code" = '0.75AL*') OR
                            (EmpAbs."Shift Code" = '0.25SKD') OR (EmpAbs."Shift Code" = '0.5SKD') OR (EmpAbs."Shift Code" = '0.75SKD') OR
                            (EmpAbs."Shift Code" = '0.25SKD*') OR (EmpAbs."Shift Code" = '0.5SKD*') OR (EmpAbs."Shift Code" = '0.75SKD*') OR
                            (EmpAbs."Shift Code" = '0.25SKL') OR (EmpAbs."Shift Code" = '0.5SKL') OR (EmpAbs."Shift Code" = '0.75SKL') OR
                            (EmpAbs."Shift Code" = '0.25SKL*') OR (EmpAbs."Shift Code" = '0.5SKL*') OR (EmpAbs."Shift Code" = '0.75SKL*') then begin
                                EmpAbs."Attend Hrs." := EmpAbs."Required Hrs";
                                EmpAbs."Late Arrive" := 0;
                                EmpAbs."Actual Late Arrive" := 0;
                                EmpAbs."Early Leave" := 0;
                                EmpAbs."Actual Early Leave" := 0;
                                Emp.SETRANGE("No.", EmpNo);
                                if Emp.FINDFIRST then begin
                                    if Emp."Employment Type Code" <> '' then begin
                                        EmploymentTypeRec.SETRANGE(EmploymentTypeRec.Code, Emp."Employment Type Code");
                                        if EmploymentTypeRec.FINDFIRST then begin
                                            if EmploymentTypeRec."Early Arrive Not Allowed" then begin
                                                EmpAbs."Early Arrive" := 0;
                                                EmpAbs."Actual Early Arrive" := 0;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                            IF EmpAbs."Shift Code" = 'HOLIDAY' then begin
                                EmpAbs."Late Arrive" := 0;
                                EmpAbs."Actual Late Arrive" := 0;
                                EmpAbs."Early Leave" := 0;
                                EmpAbs."Actual Early Leave" := 0;
                                EmpAbs."Late Leave" := EmpAbs."Attend Hrs." * 60;
                                Emp.SETRANGE("No.", EmpNo);
                                if Emp.FINDFIRST then begin
                                    if Emp."Employment Type Code" <> '' then begin
                                        EmploymentTypeRec.SETRANGE(EmploymentTypeRec.Code, Emp."Employment Type Code");
                                        if EmploymentTypeRec.FINDFIRST then begin
                                            if EmploymentTypeRec."Early Arrive Not Allowed" then begin
                                                EmpAbs."Early Arrive" := 0;
                                                EmpAbs."Actual Early Arrive" := 0;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                            HRSetup.Get;
                            IF EmpAbs."Shift Code" = HRSetup.Deduction then begin
                                EmpAbs."Late Arrive" := 0;
                                EmpAbs."Actual Late Arrive" := 0;
                                EmpAbs."Early Leave" := 0;
                                EmpAbs."Actual Early Leave" := 0;
                                EmpAbs."Late Leave" := 0;
                                EmpAbs."Early Arrive" := 0;
                                EmpAbs."Actual Early Arrive" := 0;
                                EmpAbs."Attend Hrs." := 0;
                            end;
                            IF EmpAbs."Attend Hrs." = EmpAbs."Required Hrs" then begin
                                EmpAbs."Late Arrive" := 0;
                                EmpAbs."Actual Late Arrive" := 0;
                                EmpAbs."Early Leave" := 0;
                                EmpAbs."Actual Early Leave" := 0;
                                EmpAbs."Early Arrive" := 0;
                                EmpAbs."Actual Early Arrive" := 0;
                                EmpAbs."Late Leave" := 0;
                                EmpAbs."Actual Late Leave" := 0;
                            end;
                            //18-01-2021 
                            EmpAbs.MODIFY;
                        end;
                    end;
                end;
                IF EmpAbs."Attend Hrs." > EmpAbs."Required Hrs" then begin
                    EmpAbs."Late Leave" := (EmpAbs."Attend Hrs." - EmpAbs."Required Hrs") * 60;
                    EmpAbs.Modify;
                end;
            until EmpAbs.NEXT = 0;
    end;

    local procedure GetCauseofAbsenceValue(CauseofAbsenceCode: Code[10]; CauseofAbsenceVal: Decimal) Val: Decimal;
    begin
        if (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('AL')) = 0) and (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('CL')) = 0) and (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('SKD')) = 0)
        and (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('SKL')) = 0) then
            exit(CauseofAbsenceVal)
        else begin
            case UPPERCASE(CauseofAbsenceCode) of
                '0.25AL':
                    exit(0.25);
                '0.5AL':
                    exit(0.5);
                '0.75AL':
                    exit(0.75);
                '0.25CL':
                    exit(0.25);
                '0.5CL':
                    exit(0.5);
                '0.75CL':
                    exit(0.75);
                '0.25SKD':
                    exit(0.25);
                '0.5SKD':
                    exit(0.5);
                '0.75SKD':
                    exit(0.75);
                '0.25SKL':
                    exit(0.25);
                '0.5SKL':
                    exit(0.5);
                '0.75SKL':
                    exit(0.75);
                '0.25ULT':
                    exit(0.25);
                '0.5ULT':
                    exit(0.5);
                '0.75ULT':
                    exit(0.75);
                '0.25UL':
                    exit(0.25);
                '0.5UL':
                    exit(0.5);
                '0.75UL':
                    exit(0.75);
                else
                    exit(CauseofAbsenceVal);

            end;
        end;
    end;

    procedure PostAttendanceLatenessToJournal(EmpNo: Code[20]; AttendPeriod: Date; AttendDate: Date; LateArriveMin: Decimal; CauseOfAbsenceCode: Code[20]; CheckPenalty: Boolean);
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        DeductionCode: Code[10];
        DedPayElem: Code[10];
        AbsentHrs: Decimal;
        DedUnitMeasure: Code[10];
        CauseofAbsence_U: Record "Cause of Absence";
    begin
        if CauseOfAbsenceCode = '' then begin
            DedPayElem := '';

            CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
            CauseofAbsence.SETRANGE("Unit of Measure Code", 'MINUTE');
            CauseofAbsence.SETRANGE("Affect Work Days", true);
            CauseofAbsence.SETFILTER("Associated Pay Element", '=%1', DedPayElem);
            CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::Starters);

            if CauseofAbsence.FINDFIRST then
                DeductionCode := CauseofAbsence.Code;
        end
        else begin
            DeductionCode := CauseOfAbsenceCode;
        end;


        if DeductionCode = '' then
            exit;


        CauseofAbsence_U.SETRANGE(Code, DeductionCode);
        if CauseofAbsence_U.FINDFIRST() then
            DedUnitMeasure := CauseofAbsence_U."Unit of Measure Code";

        if CheckPenalty = true then
            LateArriveMin := CalculateLateArrivePenalty(DeductionCode, LateArriveMin, DedUnitMeasure, EmpNo);


        if LateArriveMin > 0 then begin
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.", EmpNo);
            EmployeeJournal."Transaction Type" := 'ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code", DeductionCode);
            EmployeeJournal.VALIDATE("Starting Date", AttendDate);
            EmployeeJournal.VALIDATE("Ending Date", AttendDate);
            EmployeeJournal.Type := 'ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date", AttendPeriod);
            EmployeeJournal.VALIDATE(EmployeeJournal.Value, LateArriveMin);
            EmployeeJournal."Opened By" := USERID;
            EmployeeJournal."Opened Date" := WORKDATE;
            EmployeeJournal."Released By" := USERID;
            EmployeeJournal."Released Date" := WORKDATE;
            EmployeeJournal."Approved By" := USERID;
            EmployeeJournal."Approved Date" := WORKDATE;
            EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
            EmployeeJournal.INSERT(true);
        end;
    end;

    procedure CalculateLateArrivePenalty(LACode: Code[10]; LAMinutes: Decimal; ConvertUnit: Code[10]; EmpNo: Code[20]) Val: Decimal;
    var
        AbsEnt: Record "Absence Entitlement";
        RemMin: Decimal;
        CauseofAbsence: Record "Cause of Absence";
        LAUnitMeasure: Code[10];
        EmpCategory: Code[10];
        EmpTbt: Record Employee;
        EmploymentTypeRec: Record "Employment Type";
    begin
        if IsLateArriveDayPenalty(EmpNo) = true then
            exit(0);
        AbsEnt.SETCURRENTKEY("Cause of Absence Code", "From Unit", "To Unit");
        AbsEnt.SETRANGE("Cause of Absence Code", LACode);
        if EmpNo <> '' then begin
            EmpTbt.SETRANGE("No.", EmpNo);
            if EmpTbt.FINDFIRST then
                EmpCategory := EmpTbt."Employee Category Code";
            AbsEnt.SETRANGE("Employee Category", EmpCategory);
        end;

        //Added in order to consider records with no EmpCategory - 05.08.2016 : AIM +
        if AbsEnt.FINDFIRST = false then begin
            CLEAR(AbsEnt);
            AbsEnt.SETFILTER("Employee Category", '=%1', '');
            AbsEnt.SETRANGE("Cause of Absence Code", LACode);
        end;
        //Added in order to consider records with no EmpCategory - 05.08.2016 : AIM -

        if AbsEnt.FINDFIRST = false then begin
            Val := LAMinutes;
            LAUnitMeasure := 'MINUTE';
        end
        else begin
            //**Get Deduction Code Unit of Measure******
            CauseofAbsence.SETRANGE(Code, LACode);
            if CauseofAbsence.FINDFIRST() then
                LAUnitMeasure := CauseofAbsence."Unit of Measure Code";
            //******************************************

            RemMin := LAMinutes;

            if AbsEnt.Type = AbsEnt.Type::Cumulative then begin
                repeat
                    if (RemMin > 0) then begin
                        if (RemMin >= AbsEnt."To Unit") then begin
                            //Modified in order to consider the equivalent deducted value either as fixed Value or as a rate - 08.04.2016 : AIM +
                            if AbsEnt."Calculation Type" = AbsEnt."Calculation Type"::Rate then
                                Val := Val + ROUND(((AbsEnt."To Unit" - AbsEnt."From Unit") + 1) * AbsEnt.Entitlement, 0.01)
                            else
                                Val := Val + AbsEnt.Entitlement;
                            //Modified in order to consider the equivalent deducted value either as fixed Value or as a rate - 08.04.2016 : AIM -
                            RemMin := RemMin - AbsEnt."To Unit";
                        end
                        else begin
                            //Modified in order to consider the equivalent deducted value either as fixed Value or as a rate - 08.04.2016 : AIM +
                            if AbsEnt."Calculation Type" = AbsEnt."Calculation Type"::Rate then
                                Val := Val + ROUND(RemMin * AbsEnt.Entitlement, 0.01)
                            else
                                Val := Val + AbsEnt.Entitlement;
                            //Modified in order to consider the equivalent deducted value either as fixed Value or as a rate - 08.04.2016 : AIM -
                            RemMin := 0;
                        end;
                    end;
                until AbsEnt.NEXT = 0;
            end
            else begin
                //Added in order to keep LAMinutes in case no interval exists for them - 22.08.2016 : AIM +
                Val := LAMinutes;
                LAUnitMeasure := 'MINUTE';
                //Added in order to keep LAMinutes in case no interval exists for them - 22.08.2016 : AIM -

                repeat

                    if (LAMinutes >= AbsEnt."From Unit") and (LAMinutes <= AbsEnt."To Unit") then
                        //Modified in order to consider the equivalent deducted value either as fixed Value or as a rate - 08.04.2016 : AIM +
                        if AbsEnt."Calculation Type" = AbsEnt."Calculation Type"::Fixed then
                            Val := AbsEnt.Entitlement
                        else
                            if AbsEnt."Calculation Type" = AbsEnt."Calculation Type"::Rate then
                                Val := ROUND(LAMinutes * (AbsEnt.Entitlement), 0.01)
                            else
                                Val := LAMinutes;
                //Modified in order to consider the equivalent deducted value either as fixed Value or as a rate - 08.04.2016 : AIM -
                until AbsEnt.NEXT = 0;
            end;
        end;

        if (ConvertUnit <> '') and (LAUnitMeasure <> '') and (ConvertUnit <> LAUnitMeasure) then begin
            if (ConvertUnit = 'HOUR') and (LAUnitMeasure = 'MINUTE') then
                Val := Val / 60
            else
                if (ConvertUnit = 'MINUTE') and (LAUnitMeasure = 'HOUR') then
                    Val := Val * 60
                else
                    Val := Val * 1;
        end;

        exit(Val);
    end;

    procedure AutoGenerateEmpAbsenceEntitlementRecord(EmpNo: Code[20]; AbsEntitleCode: Code[10]; FDate: Date; TDate: Date);
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        AbsEntitleBandsTBT: Record "Absence Entitlement";
        EmpTBT: Record Employee;
        AllowGenerate: Boolean;
        DefEntitleValue: Decimal;
        PeriodType: DateFormula;
        FUnitD: Decimal;
        TUnitD: Decimal;
        YearsOfService: Decimal;
        DaysPerMonth: Decimal;
        FilterNbOfDays: Decimal;
        AbsEntitleAllowedToTransfer: Decimal;
        V: Decimal;
        L_EmployDate: Date;
        AbsEntitleBandsTBTRec: Record "Absence Entitlement";
        AbsEntitleBandsRec: Record "Absence Entitlement";
    begin
        AllowGenerate := true;

        EmpTBT.SETRANGE("No.", EmpNo);
        if EmpTBT.FINDFIRST then begin
            if (UPPERCASE(AbsEntitleCode) = UPPERCASE('AL')) then begin
                //Added in order to handle existing data prior to modification - 28.07.2016 : AIM +
                if EmpTBT."AL Starting Date" = 0D then
                    EmpTBT."AL Starting Date" := EmpTBT."Employment Date";
                //Added in order to handle existing data prior to modification - 28.07.2016 : AIM -
                if (EmpTBT."AL Starting Date" = 0D) or (EmpTBT."AL Starting Date" > TDate) then begin
                    AllowGenerate := false;
                end
                else begin
                    if EmpTBT."AL Starting Date" > FDate then
                        FDate := EmpTBT."AL Starting Date";
                end;
            end;

            if (EmpTBT.Status <> EmpTBT.Status::Active) or (EmpTBT."Employment Date" = 0D) or (EmpTBT."End of Service Date" = 0D) then
                AllowGenerate := false;


        end
        else begin
            AllowGenerate := false;
        end;
        // 02.06.2017 : A2+
        if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then
            L_EmployDate := EmpTBT."AL Starting Date"
        else
            L_EmployDate := EmpTBT."Employment Date";
        // 02.06.2017 : A2-
        if (EmpTBT."Employment Date" = 0D) then
            exit;

        //Modified in order to consider termination date that falls within the interval - 12.09.2017 : AIM +
        if EmpTBT."Termination Date" <> 0D then begin
            if EmpTBT."Termination Date" <= FDate then
                exit
            else
                if EmpTBT."Termination Date" < TDate then
                    TDate := EmpTBT."Termination Date";
        end
        else
            if EmpTBT."Inactive Date" <> 0D then begin
                if EmpTBT."Inactive Date" <= FDate then
                    exit
                else
                    if EmpTBT."Inactive Date" < TDate then
                        TDate := EmpTBT."Inactive Date";
            end;
        //Modified in order to consider termination date that falls within the interval - 12.09.2017 : AIM +

        DaysPerMonth := 365 / 12;
        // Modified - 02.06.2017 : A2
        //EDM+ 08-12-2020
        HRSetup.GET;
        IF HRSetup."Generate Monthly Entitlement" then
            YearsOfService := ROUND((FDate - EmpTBT."Employment Date") / 365, 0.01)
        else begin
            //EDM- 08-12-2020
            if DATE2DMY(L_EmployDate, 3) = DATE2DMY(FDate, 3) then
                YearsOfService := ABS((FDate - L_EmployDate) / 365)
            else
                YearsOfService := (FDate - L_EmployDate) / 365;
            // Modified - 02.06.2017 : A2-
        end;
        //Added in order to discard -ve value - 28.07.2016 : AIM +
        if YearsOfService <= 0 then
            YearsOfService := 0;
        //Added in order to discard -ve value - 28.07.2016 : AIM -

        FilterNbOfDays := TDate - FDate;
        //EDM+ 08-12-2020
        HRSetup.GET;
        IF HRSetup."Generate Monthly Entitlement" then begin
            FilterNbOfDays := FilterNbOfDays + 1;
            IF FilterNbOfDays > 365 THEN
                FilterNbOfDays := 365;
        end;
        //EDM- 08-12-2020
        //EDM+ 08-12-2020
        HRSetup.GET;
        IF HRSetup."Generate Monthly Entitlement" then begin
            CLEAR(EmpAbsEntitleTBT);
            EmpAbsEntitleTBT.RESET();
        end;
        //EDM- 08-12-2020               
        EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
        EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
        if EmpAbsEntitleTBT.FINDFIRST = true then
            repeat
                if AllowGenerate = true then begin

                    if (EmpAbsEntitleTBT."From Date" >= FDate) and (EmpAbsEntitleTBT."From Date" <= TDate) then
                        AllowGenerate := false;

                    if (EmpAbsEntitleTBT."Till Date" >= FDate) and (EmpAbsEntitleTBT."Till Date" <= TDate) then
                        AllowGenerate := false;

                end;
            until EmpAbsEntitleTBT.NEXT = 0;

        if AllowGenerate = true then begin
            AbsEntitleBandsTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
            //Added in order to check entitlements by employee category - 06.04.2016 : AIM +
            AbsEntitleBandsTBT.SETRANGE("Employee Category", GetEntitlementEmpCategoryFilter(AbsEntitleCode, EmpNo, true));
            //Added in order to check entitlements by employee category - 06.04.2016 : AIM -

            //Note: When assigning bands for AL or SKD kindly take into consideration the following:
            //      1. The entitlement assigned is for the period (From Unit - To Unit)
            //      2. It means that if the value falls within the interval,then it take the related entitlement
            //      3. The below two examples give the same result. They mean that if the value falls within the interval of 5 years then give 15 days
            //          Period     |   From Unit    |  To Unit  |  Entitlement
            //            Y        |      0         |     5     |   15
            //            M        |      0         |     60    |   15

            if AbsEntitleBandsTBT.FINDFIRST = true then
                repeat
                    FUnitD := 0;
                    TUnitD := 0;

                    DefEntitleValue := AbsEntitleBandsTBT.Entitlement;

                    EVALUATE(PeriodType, '1Y');
                    if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a year
                      begin
                        FUnitD := AbsEntitleBandsTBT."From Unit" * 365;
                        TUnitD := AbsEntitleBandsTBT."To Unit" * 365;
                        //12.09.2017 +
                        DefEntitleValue := ROUND(FilterNbOfDays / 365, 0.01, '='); // get nb of years
                        DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01, '=');
                        //12.09.2017 -
                    end;

                    EVALUATE(PeriodType, '1M');
                    if PeriodType = AbsEntitleBandsTBT.Period then// the entitlement assigned is for a month
                    begin
                        //EDM+ 08-12-2020
                        HRSetup.GET;
                        IF HRSetup."Generate Monthly Entitlement" then begin
                            AbsEntitleBandsTBTRec.RESET;
                            AbsEntitleBandsTBTRec.COPY(AbsEntitleBandsTBT);

                            AbsEntitleBandsTBTRec.SETFILTER("From Unit", '<=%1', ROUND(YearsOfService, 1));
                            AbsEntitleBandsTBTRec.SETFILTER("To Unit", '>=%1', ROUND(YearsOfService, 1));

                            IF AbsEntitleBandsTBTRec.FINDFIRST THEN BEGIN
                                FUnitD := AbsEntitleBandsTBTRec."From Unit" * DaysPerMonth;
                                TUnitD := AbsEntitleBandsTBTRec."To Unit" * DaysPerMonth;
                                DefEntitleValue := ROUND(FilterNbOfDays / DaysPerMonth, 1, '='); // get nb of months
                                DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBTRec.Entitlement, 0.01);
                            END;
                        end
                        else begin
                            //EDM- 08-12-2020
                            FUnitD := AbsEntitleBandsTBT."From Unit" * DaysPerMonth;
                            TUnitD := AbsEntitleBandsTBT."To Unit" * DaysPerMonth;
                            DefEntitleValue := ROUND(FilterNbOfDays / DaysPerMonth, 1, '='); // get nb of months
                            DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                        end;
                    end;

                    EVALUATE(PeriodType, '1W');
                    if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a week
                     begin
                        FUnitD := AbsEntitleBandsTBT."From Unit" * 7;
                        TUnitD := AbsEntitleBandsTBT."To Unit" * 7;
                        DefEntitleValue := ROUND(FilterNbOfDays / 7, 1, '='); // get nb of weeks
                        DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                    end;

                    if (FUnitD = 0) and (TUnitD = 0) then // the entitlement assigned is for a day
                      begin
                        FUnitD := AbsEntitleBandsTBT."From Unit";
                        TUnitD := AbsEntitleBandsTBT."To Unit";
                        DefEntitleValue := ROUND(FilterNbOfDays * AbsEntitleBandsTBT.Entitlement, 0.01);
                    end;

                    //Added as a preventive action in case any of the above validations is removed upon customer's request. This prevents assigning AL entitlements for those whose AL Starting Date is out of range. - 09.04.2016 : AIM +
                    if (UPPERCASE(AbsEntitleCode) = UPPERCASE('AL')) then begin
                        if (EmpTBT."AL Starting Date" = 0D) or (EmpTBT."AL Starting Date" > TDate) then begin
                            DefEntitleValue := 0;
                            if FDate > TDate then
                                FDate := TDate;
                            InsertEmpAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, DefEntitleValue, 0);
                            exit;
                        end;
                    end;
                    //Added as a preventive action in case any of the above validations is removed upon customer's request. This prevents assigning AL entitlements for those whose AL Starting Date is out of range. - 09.04.2016 : AIM -
                    //EDM+ 08-12-2020
                    HRSetup.GET;
                    IF HRSetup."Generate Monthly Entitlement" then begin
                        IF AbsEntitleBandsTBT.Type = AbsEntitleBandsTBT.Type::"Non-Cumulative" THEN BEGIN
                            InsertEmpAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, DefEntitleValue, 0);
                            exit;
                        END
                        ELSE BEGIN
                            AbsEntitleBandsRec.RESET;
                            AbsEntitleBandsRec.COPY(AbsEntitleBandsTBT);
                            AbsEntitleBandsRec.SETFILTER("From Unit", '<=%1', ROUND(YearsOfService, 1));
                            AbsEntitleBandsRec.SETFILTER("To Unit", '>=%1', ROUND(YearsOfService, 1));
                            IF AbsEntitleBandsRec.FINDFIRST THEN
                                AbsEntitleAllowedToTransfer := AbsEntitleBandsRec."Allowed Days To Transfer";
                            InsertEmpAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, DefEntitleValue, AbsEntitleAllowedToTransfer);
                            EXIT;
                        end;
                    end
                    else begin
                        if (YearsOfService * 365 >= FUnitD) and (YearsOfService * 365 <= TUnitD) then begin
                            if AbsEntitleBandsTBT.Type = AbsEntitleBandsTBT.Type::"Non-Cumulative" then begin
                                InsertEmpAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, DefEntitleValue, 0);
                                //Added in order to prevent duplicate records in case the YearsofService falls at the boundary of 2 entitlements - 01.06.2016 : AIM +
                                exit;
                                //Added in order to prevent duplicate records in case the YearsofService falls at the boundary of 2 entitlements - 01.06.2016 : AIM -
                            end
                            else begin
                                //Modified in order to reset balance after X Years - 17.01.2017 : AIM +
                                AbsEntitleAllowedToTransfer := AbsEntitleBandsTBT."Allowed Days To Transfer";
                                if AbsEntitleBandsTBT."Balance Cummulative Years" > 0 then begin
                                    if IsEntitlementCummulativeYear(FDate, EmpTBT."Employment Date", AbsEntitleBandsTBT."Balance Cummulative Years") = false then
                                        AbsEntitleAllowedToTransfer := 0;
                                end
                                else
                                    AbsEntitleAllowedToTransfer := 0;
                                InsertEmpAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, DefEntitleValue, AbsEntitleAllowedToTransfer);
                                //Modified in order to reset balance after X Years - 17.01.2017 : AIM -
                                //Added in order to prevent duplicate records in case the YearsofService falls at the boundary of 2 entitlements - 01.06.2016 : AIM +
                                exit;
                                //Added in order to prevent duplicate records in case the YearsofService falls at the boundary of 2 entitlements - 01.06.2016 : AIM -
                            end;
                        end;
                    end;
                until AbsEntitleBandsTBT.NEXT = 0;
        end;
    end;

    procedure GetSundaysToALEntitlement(EmpNo: Code[20]; AbsEntCode: Code[10]; FDate: Date; TDate: Date) Val: Decimal;
    var
        EmpAbsEntitleRec: Record "Employee Absence Entitlement";
        EmpJnlLineRec: Record "Employee Journal Line";
        AssignedDays: Decimal;
        HRSetupRec: Record "Human Resources Setup";
        AbsCode: Code[10];
    begin

        if EmpNo = '' then
            exit(0);

        if (FDate = 0D) or (TDate = 0D) then
            exit(0);

        Val := 0;

        HRSetupRec.GET();

        if (NOT HRSetupRec."Accumulate Weekend Overtime To Sunday") and (HRSetupRec."Sunday Leave Code" = '') then
            exit(0);

        EmpJnlLineRec.RESET;
        CLEAR(EmpJnlLineRec);

        EmpJnlLineRec.SETRANGE("Employee No.", EmpNo);
        EmpJnlLineRec.SETRANGE("Cause of Absence Code", 'WEEKEND');
        EmpJnlLineRec.SETRANGE("Transaction Type", 'ABS');
        EmpJnlLineRec.SETRANGE(Type, 'ABSENCE');
        EmpJnlLineRec.SETRANGE("Document Status", EmpJnlLineRec."Document Status"::Approved);
        EmpJnlLineRec.SETFILTER("Starting Date", '%1..%2', FDate, TDate);
        EmpJnlLineRec.SETFILTER("Ending Date", '%1..%2', FDate, TDate);
        EmpJnlLineRec.CALCFIELDS("Attendance Hours");
        EmpJnlLineRec.SETFILTER("Attendance Hours", '>%1', 0);
        if EmpJnlLineRec.FINDFIRST then
            repeat
                if UPPERCASE(EmpJnlLineRec."Unit of Measure Code") = UPPERCASE('DAY') then
                    Val := Val + EmpJnlLineRec."Calculated Value"
            until EmpJnlLineRec.NEXT = 0;
        exit(Val);
    end;

    procedure GetHolidaysToALEntitlement(EmpNo: Code[20]; AbsEntCode: Code[10]; FDate: Date; TDate: Date) Val: Decimal;
    var
        EmpAbsEntitleRec: Record "Employee Absence Entitlement";
        EmpJnlLineRec: Record "Employee Journal Line";
        AssignedDays: Decimal;
        HRSetupRec: Record "Human Resources Setup";
        AbsCode: Code[10];
    begin

        if EmpNo = '' then
            exit(0);

        if (FDate = 0D) or (TDate = 0D) then
            exit(0);

        Val := 0;

        HRSetupRec.GET();

        if (NOT HRSetupRec."Accumulate Holiday Overtime To HolidayVac") and (HRSetupRec."Holiday Leave Code" = '') then
            exit(0);

        EmpJnlLineRec.RESET;
        CLEAR(EmpJnlLineRec);

        EmpJnlLineRec.SETRANGE("Employee No.", EmpNo);
        EmpJnlLineRec.SETRANGE("Cause of Absence Code", 'HOLIDAY');
        EmpJnlLineRec.SETRANGE("Transaction Type", 'ABS');
        EmpJnlLineRec.SETRANGE(Type, 'ABSENCE');
        EmpJnlLineRec.SETRANGE("Document Status", EmpJnlLineRec."Document Status"::Approved);
        EmpJnlLineRec.SETFILTER("Starting Date", '%1..%2', FDate, TDate);
        EmpJnlLineRec.SETFILTER("Ending Date", '%1..%2', FDate, TDate);
        EmpJnlLineRec.CALCFIELDS("Attendance Hours");
        EmpJnlLineRec.SETFILTER("Attendance Hours", '>%1', 0);
        repeat
            if UPPERCASE(EmpJnlLineRec."Unit of Measure Code") = UPPERCASE('DAY') then
                Val := Val + EmpJnlLineRec."Calculated Value"
        until EmpJnlLineRec.NEXT = 0;
        exit(Val);
    end;

    procedure InsertEmpAbsenceEntitlement(EmpNo: Code[20]; AbsEntitleCode: Code[10]; FDate: Date; TDate: Date; Entitlement: Decimal; PrevYearAllowedDays: Decimal);
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        RemDaysPrevYear: Decimal;
        HRSetup: Record "Human Resources Setup";
    begin
        // 06.06.2017 : A2+
        HRSetup.GET;
        // 06.06.2017 : A2-

        EmpAbsEntitleTBT.INIT;
        EmpAbsEntitleTBT."Employee No." := EmpNo;
        EmpAbsEntitleTBT."Cause of Absence Code" := AbsEntitleCode;
        EmpAbsEntitleTBT.Entitlement := Entitlement;
        EmpAbsEntitleTBT."From Date" := FDate;
        EmpAbsEntitleTBT."Till Date" := TDate;
        EmpAbsEntitleTBT.Taken := GetEmpTakenAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, false);
        // 06.06.2017 : A2+
        EmpAbsEntitleTBT."Auto Calculate Entitlement" := HRSetup."Auto Calculate Entitlement";
        // 06.06.2017 : A2-
        if PrevYearAllowedDays > 0 then begin
            RemDaysPrevYear := GetEmpTakenAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, true);
            if RemDaysPrevYear > 0 then begin
                if RemDaysPrevYear < PrevYearAllowedDays then
                    EmpAbsEntitleTBT."Transfer from Previous Year" := RemDaysPrevYear
                else
                    EmpAbsEntitleTBT."Transfer from Previous Year" := PrevYearAllowedDays;
            end;

            HRSetup.Get;
            IF NOT HRSetup."Transfer Negative AL from Previous Year" THEN BEGIN
                if EmpAbsEntitleTBT."Transfer from Previous Year" < 0 then
                    EmpAbsEntitleTBT."Transfer from Previous Year" := 0;
            end;
        end;

        EmpAbsEntitleTBT.INSERT(true);
    end;

    procedure GetEmpTakenAbsenceEntitlement(EmpNo: Code[20]; AbsCode: Code[10]; FDate: Date; TDate: Date; CheckPrevYear: Boolean) Val: Decimal;
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        EmpJnlLine: Record "Employee Journal Line";
        TakenDays: Decimal;
        PrevFDate: Date;
        PrevTDate: Date;
    begin

        Val := 0;
        if CheckPrevYear = true then begin
            EmpAbsEntitleTBT.SETCURRENTKEY("Employee No.", "Cause of Absence Code", "From Date");
            EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
            EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsCode);
            if EmpAbsEntitleTBT.FINDLAST() then begin
                if (EmpAbsEntitleTBT."From Date" <> 0D) and (EmpAbsEntitleTBT."Till Date" <> 0D) then begin
                    PrevFDate := EmpAbsEntitleTBT."From Date";
                    PrevTDate := EmpAbsEntitleTBT."Till Date";
                    //Balance without taken days of previous year
                    // Modified By Alaa El Chami on 05.2016 for Overtime Addition / Absence Deduction from AL - 04.06.2016 : AIM +
                    Val := (EmpAbsEntitleTBT.Entitlement + EmpAbsEntitleTBT."Manual Additions" + EmpAbsEntitleTBT."Transfer from Previous Year" + EmpAbsEntitleTBT."Attendance Additions") - (EmpAbsEntitleTBT."Manual Deductions");
                    Val := Val - EmpAbsEntitleTBT."Attendance Deductions";
                    // Added By Alaa El Chami on 05.2016 for Overtime Addition / Absence Deduction from AL - 04.06.2016 : AIM -
                end
                else begin
                    PrevFDate := CALCDATE('<-1Y>', FDate);
                    PrevTDate := CALCDATE('<-1Y>', TDate);
                end;

            end
            else begin
                PrevFDate := CALCDATE('<-1Y>', FDate);
                PrevTDate := CALCDATE('<-1Y>', TDate);
            end;

            FDate := PrevFDate;
            TDate := PrevTDate;

        end;


        EmpJnlLine.SETRANGE("Employee No.", EmpNo);
        IF AbsCode = HRSetup."Annual Leave Code" then
            EmpJnlLine.SETFILTER("Cause of Absence Code", '%1|%2|%3', AbsCode, '0.5AL', '0.5AL*')
        else
            IF AbsCode = HRSetup."Sick Leave Code" then
                EmpJnlLine.SETFILTER("Cause of Absence Code", '%1|%2|%3|%4|%5', AbsCode, '0.5SKD', '0.5SKD*', '0.5SKL', '0.5SKL*')
            else
                EmpJnlLine.SETRANGE("Cause of Absence Code", AbsCode);
        EmpJnlLine.SETRANGE("Transaction Type", 'ABS');
        EmpJnlLine.SETRANGE(Type, 'ABSENCE');
        EmpJnlLine.SETRANGE("Document Status", EmpJnlLine."Document Status"::Approved);
        EmpJnlLine.SETFILTER("Starting Date", '%1..%2', FDate, TDate);
        EmpJnlLine.SETFILTER("Ending Date", '%1..%2', FDate, TDate);

        if EmpJnlLine.FINDFIRST then
            repeat
                if CheckPrevYear = false then
                    Val := Val + EmpJnlLine."Calculated Value"
                else
                    // Deduct taken from balance of previous year
                    Val := Val - EmpJnlLine."Calculated Value";
            until EmpJnlLine.NEXT = 0;


        exit(Val);
    end;

    procedure GetEmpAbsenceEntitlementCurrentBalance(EmpNo: Code[20]; AbsCode: Code[10]; DateV: Date) RemBalance: Decimal;
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        FDate: Date;
        TDate: Date;
    begin
        EmpAbsEntitleTBT.SETCURRENTKEY("Employee No.", "Cause of Absence Code", "From Date", "Till Date");
        EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
        EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsCode);
        if DateV = 0D then begin
            if EmpAbsEntitleTBT.FINDLAST() then begin
                FDate := EmpAbsEntitleTBT."From Date";
                TDate := EmpAbsEntitleTBT."Till Date";
                // Modified By Alaa El Chami on 05.2016 for Overtime Addition / Absence Deduction from AL - 04.06.2016 : AIM +
                RemBalance := (EmpAbsEntitleTBT.Entitlement + EmpAbsEntitleTBT."Manual Additions" + EmpAbsEntitleTBT."Transfer from Previous Year" + EmpAbsEntitleTBT."Attendance Additions") - (EmpAbsEntitleTBT."Manual Deductions");
                RemBalance := RemBalance - EmpAbsEntitleTBT."Attendance Deductions";
                // Modified By Alaa El Chami on 05.2016 for Overtime Addition / Absence Deduction from AL - 04.06.2016 : AIM -
            end;
        end
        else begin
            if EmpAbsEntitleTBT.FINDFIRST() then
                repeat
                    if (DateV >= EmpAbsEntitleTBT."From Date") and (DateV <= EmpAbsEntitleTBT."Till Date") then begin
                        FDate := EmpAbsEntitleTBT."From Date";
                        TDate := EmpAbsEntitleTBT."Till Date";
                        // Modified By Alaa El Chami on 05.2016 for Overtime Addition / Absence Deduction from AL - 04.06.2016 : AIM +
                        RemBalance := (EmpAbsEntitleTBT.Entitlement + EmpAbsEntitleTBT."Manual Additions" + EmpAbsEntitleTBT."Transfer from Previous Year" + EmpAbsEntitleTBT."Attendance Additions") - (EmpAbsEntitleTBT."Manual Deductions");
                        RemBalance := RemBalance - EmpAbsEntitleTBT."Attendance Deductions";
                        // Modified By Alaa El Chami on 05.2016 for Overtime Addition / Absence Deduction from AL - 04.06.2016 : AIM -
                    end;
                until EmpAbsEntitleTBT.NEXT = 0;
        end;

        RemBalance := RemBalance - GetEmpTakenAbsenceEntitlement(EmpNo, AbsCode, FDate, TDate, false);

        exit(RemBalance);
    end;

    procedure GetEmployeeBasicHourlyRate(EmpNo: Code[20]; CauseofAbsCode: Code[10]; BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount; FixedAmount: Decimal) RatePerHour: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        PayElement: Record "Pay Element";
        HRSetup: Record "Human Resources Setup";
        EmployTypeCode: Code[20];
        PayElemCode: Code[10];
        Amount: Decimal;
        MonthlyHours: Decimal;
        CauseofAbsence: Record "Cause of Absence";
        EmpAddInfo: Record "Employee Additional Info";
        ExtraSalary: Decimal;
        PayrollFunctions: Codeunit "Payroll Functions";
    begin
        RatePerHour := 0;

        if EmpNo = '' then
            exit(0);

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin

            MonthlyHours := 0;

            MonthlyHours := GetEmployeeMonthlyHours(EmpNo, CauseofAbsCode);

            if MonthlyHours = 0 then // If monthly hours is zero,then rate will be zero
                exit(0);

            Amount := 0;
            // Added in order to consider includ Extra Salary in calculation of Hourly Rate - 24.07.2017 : A2+
            EmpAddInfo.SETRANGE("Employee No.", EmpNo);
            if EmpAddInfo.FINDFIRST then
                ExtraSalary := EmpAddInfo."Extra Salary";
            // Added in order to consider includ Extra Salary in calculation of Hourly Rate - 24.07.2017 : A2-

            if BasicType = BasicType::BasicPay then begin
                // Added in order to consider includ Extra Salary in calculation of Hourly Rate - 24.07.2017 : A2+
                //Amount := Employee."Basic Pay" + ExtraSalary
                Amount := PayrollFunctions.CaluclateTotalAllowances(Employee, ExtraSalary);
            end
            // Added in order to consider includ Extra Salary in calculation of Hourly Rate - 24.07.2017 : A2-
            else
                if BasicType = BasicType::SalaryACY then
                    Amount := Employee."Salary (ACY)"
                else
                    if BasicType = BasicType::FixedAmount then begin
                        Amount := FixedAmount;
                    end;

            if (BasicType = BasicType::BasicPay) or (BasicType = BasicType::SalaryACY) or (BasicType = BasicType::FixedAmount) then begin
                //Modified to consider case when employee's salary is based on worked hours - 21.03.2018 : AIM +
                if BasicType = BasicType::FixedAmount then begin
                    if Employee."Hourly Basis" = true then
                        RatePerHour := Employee."Hourly Rate"
                    else
                        RatePerHour := Amount / MonthlyHours;
                end
                else
                    RatePerHour := Amount / MonthlyHours;
                //Modified to consider case when employee's salary is based on worked hours - 21.03.2018 : AIM -
            end
            else
                if BasicType = BasicType::HourlyRate then begin
                    if Employee."Hourly Rate" > 0 then
                        RatePerHour := Employee."Hourly Rate"
                    else
                        RatePerHour := Employee."Basic Pay" / MonthlyHours;
                end;

        end;

        exit(RatePerHour);
    end;

    procedure GetEmployeeMonthlyHours(EmpNo: Code[20]; CauseofAbsCode: Code[10]) MonthlyHours: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        PayElement: Record "Pay Element";
        HRSetup: Record "Human Resources Setup";
        EmployTypeCode: Code[20];
        PayElemCode: Code[10];
        CauseofAbsence: Record "Cause of Absence";
    begin

        HRSetup.GET();

        MonthlyHours := 0;

        if EmpNo = '' then
            exit(0);

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin

            if Employee."Employment Type Code" <> '' then // Check at the level of Employment Type
              begin
                EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
                if EmploymentType.FINDFIRST then begin
                    MonthlyHours := EmploymentType."Working Hours Per Day" * EmploymentType."Working Days Per Month";
                end;
            end;


            if MonthlyHours = 0 then // Check at the level of Pay Element that is associated to the Cause OF Absence
              begin


                if CauseofAbsCode <> '' then // Check if the Cuase of Attendance is associated with a pay element
                  begin
                    CauseofAbsence.SETRANGE(Code, CauseofAbsCode);
                    if CauseofAbsence.FINDFIRST then begin
                        if CauseofAbsence."Associated Pay Element" <> '' then begin
                            PayElemCode := CauseofAbsence."Associated Pay Element";
                            PayElement.SETRANGE(Code, PayElemCode);
                            if PayElement.FINDFIRST then begin
                                MonthlyHours := PayElement."Days in  Month" * PayElement."Hours in  Day";
                            end;
                        end;
                    end;
                end;


            end;

            if MonthlyHours = 0 then //Check at the level of Pay Element Basic Pay
              begin
                PayElemCode := '01'; // Default value is Basic Salary
                PayElement.SETRANGE(Code, PayElemCode);
                if PayElement.FINDFIRST then begin
                    MonthlyHours := PayElement."Days in  Month" * PayElement."Hours in  Day";
                end;
            end;

            if MonthlyHours = 0 then // Check at the level of HR Setup
              begin
                MonthlyHours := HRSetup."Monthly Hours";
            end;
        end;


        exit(MonthlyHours);
    end;

    procedure GetEmployeeDailyHours(EmpNo: Code[20]; CauseofAbsCode: Code[10]) DailyHours: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        PayElement: Record "Pay Element";
        HRSetup: Record "Human Resources Setup";
        EmployTypeCode: Code[20];
        PayElemCode: Code[10];
        CauseofAbsence: Record "Cause of Absence";
    begin

        HRSetup.GET();

        DailyHours := 0;

        if EmpNo = '' then
            exit(0);

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin

            if Employee."Employment Type Code" <> '' then // Check at the level of Employment Type
              begin
                EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
                if EmploymentType.FINDFIRST then begin
                    DailyHours := EmploymentType."Working Hours Per Day";
                end;
            end;


            if DailyHours = 0 then // Check at the level of Pay Element that is associated to the Cause OF Absence
              begin


                if CauseofAbsCode <> '' then // Check if the Cuase of Attendance is associated with a pay element
                  begin
                    CauseofAbsence.SETRANGE(Code, CauseofAbsCode);
                    if CauseofAbsence.FINDFIRST then begin
                        if CauseofAbsence."Associated Pay Element" <> '' then begin
                            PayElemCode := CauseofAbsence."Associated Pay Element";
                            PayElement.SETRANGE(Code, PayElemCode);
                            if PayElement.FINDFIRST then begin
                                DailyHours := PayElement."Hours in  Day";
                            end;
                        end;
                    end;
                end;


            end;

            if DailyHours = 0 then //Check at the level of Pay Element Basic Pay
              begin
                PayElemCode := '01'; // Default value is Basic Salary
                PayElement.SETRANGE(Code, PayElemCode);
                if PayElement.FINDFIRST then begin
                    DailyHours := PayElement."Hours in  Day";
                end;
            end;

            if DailyHours = 0 then // Check at the level of HR Setup
              begin
                if HRSetup."Hours To Days Month Period" > 0 then
                    DailyHours := HRSetup."Hours To Days Month Period"
                else
                    DailyHours := HRSetup."Hours in the Day";
            end;
        end;


        exit(DailyHours);
    end;

    procedure GetSalaryAbsenceDeductionCode(EmployeeNo: Code[20]) Val: Code[10];
    var
        PayrollParameter: Record "Payroll Parameter";
        EmployeeAdditionalInfo: Record "Employee Additional Info";
    begin
        PayrollParameter.GET();
        if PayrollParameter."Absence Deduction" <> '' then begin
            if EmployeeAdditionalInfo.GET(EmployeeNo) then begin
                if not EmployeeAdditionalInfo."Deduct Absence From Salary" then
                    Val := PayrollParameter."Absence Deduction";
            end else//20190126:A2+-
                Val := PayrollParameter."Absence Deduction"; //20190126:A2+-
        end;
        exit(Val);
    end;

    procedure GetSalaryLateArriveDeductionCode() Val: Code[10];
    var
        PayrollParameter: Record "Payroll Parameter";
    begin
        PayrollParameter.GET();
        exit(PayrollParameter."Late Arrive Deduction");

    end;

    procedure ResetEmployeePayDetailsInfo(EmpNo: Code[20]; FullReset: Boolean);
    var
        PayDetailHead: Record "Pay Detail Header";
        PayDetailLine: Record "Pay Detail Line";
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        SpouseExemptTax: Boolean;
    begin
        if FullReset = true then begin
            PayDetailHead.RESET;
            PayDetailHead.SETRANGE(PayDetailHead."Employee No.", EmpNo);
            if PayDetailHead.FINDFIRST then
                repeat
                    PayDetailHead.DELETE
              until PayDetailHead.NEXT = 0;
        end;

        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.SETRANGE(PayDetailLine."Employee No.", EmpNo);
        if PayDetailLine.FINDFIRST then
            repeat
                PayDetailLine.DELETE
          until PayDetailLine.NEXT = 0;


        HumanResSetup.GET;
        Employee.SETRANGE(Status, Employee.Status::Active);
        if HumanResSetup."Payroll in Use" then begin
            if Employee.FIND('-') then
                repeat
                    PayDetailLine.SETRANGE("Employee No.", Employee."No.");
                    PayDetailLine.SETRANGE(Open, true);
                    if not PayDetailLine.FIND('-') then begin
                        Employee."Exempt Tax" := CalculateTaxCode(Employee, false, SpouseExemptTax, WORKDATE);
                        CreatePayDetail(Employee);
                    end;
                until Employee.NEXT = 0;
        end;
    end;

    procedure GetDefaultEntitlementTillDate(EmpNo: Code[20]; EntitleCode: Code[10]; FDate: Date; TDate: Date; IntervalType: Option Month,Day; CheckEmpCategory: Boolean) Val: Decimal;
    var
        AbsEntitle: Record "Absence Entitlement";
        EmpTbt: Record Employee;
        NbofDays: Integer;
        EmpCategory: Code[20];
        DaysPerMonth: Decimal;
        DaysOfService: Decimal;
        PeriodType: DateFormula;
        FUnitD: Decimal;
        TUnitD: Decimal;
        L_EmployDate: Date;
    begin

        if EmpNo = '' then
            exit(0);

        if (FDate = 0D) or (TDate = 0D) then
            exit(0);

        if FDate >= TDate then
            exit(0);

        Val := 0;
        DaysPerMonth := 365 / 12;

        NbofDays := TDate - FDate;
        //***************************

        EmpCategory := '';

        if CheckEmpCategory = true then
            EmpCategory := GetEntitlementEmpCategoryFilter(EntitleCode, EmpNo, true);
        //***************************

        DaysOfService := 0;
        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then
            if EmpTbt."Employment Date" <> 0D then begin
                // 02.06.2017 : A2+
                if (EmpTbt."AL Starting Date" <> 0D) and (EntitleCode = 'AL') then begin
                    DaysOfService := WORKDATE - EmpTbt."AL Starting Date";
                    L_EmployDate := EmpTbt."AL Starting Date";
                end
                else begin
                    DaysOfService := WORKDATE - EmpTbt."Employment Date";
                    L_EmployDate := EmpTbt."Employment Date";
                end;
                if FDate < DMY2DATE(DATE2DMY(L_EmployDate, 1), DATE2DMY(L_EmployDate, 2), DATE2DMY(FDate, 3)) then
                    FDate := DMY2DATE(DATE2DMY(L_EmployDate, 1), DATE2DMY(L_EmployDate, 2), DATE2DMY(FDate, 3));
                if FDate > TDate then
                    exit(0);
                NbofDays := TDate - FDate;
                // 02.06.2017 : A2-
            end;

        //Note: When assigning bands for AL or SKD kindly take into consideration the following:
        //      1. The entitlement assigned is for the period (From Unit - To Unit)
        //      2. The below two examples give the same result. They mean that if the value falls within the interval of 5 years then give 15 days
        //          Period     |   From Unit    |  To Unit  |  Entitlement
        //            Y        |      0         |     5     |   15
        //            M        |      0         |     60    |   15
        //Get the allowed Days to take for the specified period
        AbsEntitle.SETRANGE("Cause of Absence Code", EntitleCode);
        AbsEntitle.SETRANGE("Employee Category", EmpCategory);
        if AbsEntitle.FINDFIRST = false then
            exit(0)
        else
            repeat
                FUnitD := 0;
                TUnitD := 0;


                EVALUATE(PeriodType, '1Y');
                if PeriodType = AbsEntitle.Period then begin
                    FUnitD := AbsEntitle."From Unit" * 365;
                    TUnitD := AbsEntitle."To Unit" * 365;
                end;

                EVALUATE(PeriodType, '1M');
                if PeriodType = AbsEntitle.Period then begin
                    FUnitD := AbsEntitle."From Unit" * DaysPerMonth;
                    TUnitD := AbsEntitle."To Unit" * DaysPerMonth;
                end;

                EVALUATE(PeriodType, '1W');
                if PeriodType = AbsEntitle.Period then begin
                    FUnitD := AbsEntitle."From Unit" * 7;
                    TUnitD := AbsEntitle."To Unit" * 7;
                end;

                if (FUnitD = 0) and (TUnitD = 0) then begin
                    FUnitD := AbsEntitle."From Unit";
                    TUnitD := AbsEntitle."To Unit";
                end;

                if (DaysOfService >= FUnitD) and (DaysOfService <= TUnitD) then begin
                    if AbsEntitle.Entitlement = 0 then
                        exit(0);

                    Val := 0;
                    EVALUATE(PeriodType, '1Y');
                    if PeriodType = AbsEntitle.Period then
                        if IntervalType = IntervalType::Day then begin
                            Val := ROUND((NbofDays * AbsEntitle.Entitlement) / 365, 0.01);
                        end
                        else
                            if IntervalType = IntervalType::Month then begin
                                Val := ROUND((NbofDays / DaysPerMonth), 1, '=');
                                Val := ROUND(Val * (AbsEntitle.Entitlement / 12), 0.01);
                            end;
                    EVALUATE(PeriodType, '1M');
                    if PeriodType = AbsEntitle.Period then
                        if IntervalType = IntervalType::Day then begin
                            Val := ROUND((NbofDays * AbsEntitle.Entitlement) / DaysPerMonth, 0.01);
                        end
                        else
                            if IntervalType = IntervalType::Month then begin
                                Val := ROUND((NbofDays / DaysPerMonth), 1, '='); // get nb of months
                                Val := ROUND(Val * AbsEntitle.Entitlement, 0.01);
                            end;

                    EVALUATE(PeriodType, '1W');
                    if PeriodType = AbsEntitle.Period then
                        if IntervalType = IntervalType::Day then begin
                            Val := ROUND((NbofDays * AbsEntitle.Entitlement) / 7, 0.01);
                        end
                        else
                            if IntervalType = IntervalType::Month then begin
                                Val := ROUND((NbofDays / DaysPerMonth), 1, '='); // get nb of months
                                Val := ROUND(Val * ((AbsEntitle.Entitlement / 7) * DaysPerMonth), 0.01);// ( Nb of months * ((Entitle Per Day ) * Days per month))
                            end;
                    if (AbsEntitle.Entitlement > 0) and (Val = 0) then
                        if IntervalType = IntervalType::Day then begin
                            Val := ROUND(NbofDays * AbsEntitle.Entitlement, 0.01);
                        end
                        else
                            if IntervalType = IntervalType::Month then begin
                                Val := ROUND((NbofDays / DaysPerMonth), 1, '='); // get nb of months
                                Val := ROUND(Val * ((AbsEntitle.Entitlement) * DaysPerMonth), 0.01);// ( Nb of months * ((Entitle Per Day ) * Days per month))
                            end;
                end;

            until AbsEntitle.NEXT = 0;
        exit(Val);
    end;

    local procedure GetAttendancePolicyCauseCodes(PolicyType: Option LateArrive,LateLeave,EarlyArrive,EarlyLeave) CodeVal: Code[10];
    begin

        case PolicyType of
            PolicyType::LateArrive:
                CodeVal := 'LATEARRIVE';
            PolicyType::LateLeave:
                CodeVal := 'LATELEAVE';
            PolicyType::EarlyArrive:
                CodeVal := 'EARLYARRIVE';
            PolicyType::EarlyLeave:
                CodeVal := 'EARLYLEAVE';
        end;
    end;

    procedure GetDailyShiftAssignedBreakMinute(ShiftCode: Code[10]) BreakVal: Decimal;
    var
        DailyShiftTbt: Record "Daily Shifts";
    begin
        if ShiftCode = '' then
            exit(0);

        BreakVal := 0;

        DailyShiftTbt.SETRANGE("Shift Code", ShiftCode);
        if DailyShiftTbt.FINDFIRST then begin
            BreakVal := DailyShiftTbt."Allowed Break Minute";
        end;


        exit(BreakVal);
    end;

    local procedure GetAttendanceAbsenceToleranceBySchedule(EmpNo: Code[20]; DailyShiftCode: Code[20]) Val: Decimal;
    var
        EmployTypeTbt: Record "Employment Type";
        ETyp: Code[20];
        EmpTbt: Record Employee;
        L_PeriodType: DateFormula;
    begin
        if EmpNo = '' then
            exit(0);

        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then
            ETyp := EmpTbt."Employment Type Code";

        if ETyp = '' then
            exit(0);

        EmployTypeTbt.SETRANGE(Code, ETyp);
        if EmployTypeTbt.FINDFIRST then
            // 20.09.2017 : A2+
            if not EmployTypeTbt."Use Daily Shift Tolerance" then
                Val := EmployTypeTbt."Absence Tolerance Hours"
            else begin
                EVALUATE(L_PeriodType, '1D');
                if (L_PeriodType = EmployTypeTbt."Period Type") and (EmployTypeTbt."Use Daily Shift Tolerance") then
                    Val := GetEmployeeToleranceABSHrsByDailyShift(EmpNo, DailyShiftCode);

                EVALUATE(L_PeriodType, '1M');
                if (L_PeriodType = EmployTypeTbt."Period Type") and (EmployTypeTbt."Use Daily Shift Tolerance") then
                    Val := GetEmployeeMonthlyEmploymentToleranceABSHrs(EmpNo, EmpTbt.Period);

            end;
        // 20.09.2017 : A2-
        exit(Val);
    end;

    local procedure GetAttendanceAbsenceRateBySchedule(EmpNo: Code[20]; DailyShiftCode: Code[10]) Val: Decimal;
    var
        EmployTypeTbt: Record "Employment Type";
        ETyp: Code[20];
        EmpTbt: Record Employee;
        DailyShiftTBT: Record "Daily Shifts";
    begin
        if EmpNo = '' then
            exit(1);

        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then
            ETyp := EmpTbt."Employment Type Code";

        if ETyp = '' then
            exit(1);

        EmployTypeTbt.SETRANGE(Code, ETyp);
        if EmployTypeTbt.FINDFIRST then
            //Modified in order to get Absence rate as per Daily Shift - 01.08.2016 : AIM +
            if (EmployTypeTbt."Use Daily Shift Rates" = false) or (DailyShiftCode = '') then
                Val := EmployTypeTbt."Absence Deduction Rate"
            else begin
                DailyShiftTBT.SETRANGE(DailyShiftTBT."Shift Code", DailyShiftCode);
                if DailyShiftTBT.FINDFIRST then
                    Val := DailyShiftTBT."Absence Deduction Rate"
                else
                    Val := EmployTypeTbt."Absence Deduction Rate";
            end;
        //Modified in order to get Absence rate as per Daily Shift - 01.08.2016 : AIM -
        if Val <= 0 then
            Val := 0;

        exit(Val);
    end;

    local procedure PostAttendanceOvertimeToJournalByEmployType(EmpNo: Code[20]; AttendDate: Date);
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        OvertimeCode: Code[10];
        OVPayElem: Code[10];
        OvrHrs: Decimal;
        AttType: Option Overtime,Absence;
        HasALRec: Boolean;
        EmployeeJournalTbt: Record "Employee Journal Line";
        L_MaxLineNo: Integer;
    begin
        OVPayElem := '';
        //Get Overtime Code +
        // Added By Alaa El Chami on 05.2016 for Overtime Addition to AL - 04.06.2016 : AIM +
        HRSetup.GET;
        // Added By Alaa El Chami on 05.2016 for Overtime Addition to AL - 04.06.2016 : AIM -
        CLEAR(CauseofAbsence);
        OvertimeCode := GetAttendanceCauseOfAbsenceCode(AttType::Overtime);
        CauseofAbsence.SETRANGE(CauseofAbsence.Code, OvertimeCode);
        if CauseofAbsence.FINDFIRST then begin
        end
        else
            exit;
        //Get Overtime Code -

        if OvertimeCode = '' then
            exit;



        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETRANGE("From Date", AttendDate);
        if EmployeeABS.FINDFIRST = false then
            exit;
        //Code Fixed - 23.03.2017 : AIM +
        HasALRec := EmpHasAbsenceEntitlementRecord(EmpNo, HRSetup."Annual Leave Code", EmployeeABS."From Date");
        if (HRSetup."Accumulate Overtime To AL") and (HRSetup."Overtime To AL Code" <> '') then begin
            if HasALRec = true then
                OvertimeCode := HRSetup."Overtime To AL Code";
        end;
        //This code is fixed because it is not working properly - 29.01.2018 : AIM -

        if ((EmployeeABS.Type = EmployeeABS.Type::"Paid Vacation") or (EmployeeABS.Type = EmployeeABS.Type::"Paid Day") or (EmployeeABS.Type = EmployeeABS.Type::"Working Day")) and (EmployeeABS."Attend Hrs." > EmployeeABS."Required Hrs")
            and (EmployeeABS."Attend Hrs." > 0) and (EmployeeABS."Required Hrs" > 0) then begin
            OvrHrs := EmployeeABS."Attend Hrs." - EmployeeABS."Required Hrs";
            OvrHrs := FixEmployeeDailyOvertimeValue(EmployeeABS."Employee No.", EmployeeABS."From Date", OvrHrs);
            // 20.09.2017 : A2+
            HRSetup.GET;
            IF NOT HRSetup."Use OverTime Unpaid Hours" then
                OvrHrs := OvrHrs - GetAttendanceOvertimeToleranceBySchedule(EmpNo, EmployeeABS."Shift Code")
            ELSE begin
                IF OvrHrs < GetAttendanceOvertimeToleranceBySchedule(EmpNo, EmployeeABS."Shift Code") then
                    OvrHrs := OvrHrs - GetAttendanceOvertimeToleranceBySchedule(EmpNo, EmployeeABS."Shift Code")
            end;
            // 20.09.2017 : A2-
        end
        else begin
            if (EmployeeABS.Type = EmployeeABS.Type::Holiday) or (EmployeeABS.Type = EmployeeABS.Type::"Working Holiday") and (EmployeeABS."Attend Hrs." > 0) and (EmployeeABS."Required Hrs" = 0) then
                // 20.09.2017 : A2+
                OvrHrs := EmployeeABS."Attend Hrs." - GetAttendanceOvertimeToleranceBySchedule(EmpNo, EmployeeABS."Shift Code");
            // 20.09.2017 : A2-
        end;
        OvrHrs := OvrHrs * GetAttendanceOvertimeRateBySchedule(EmpNo, EmployeeABS."Shift Code");
        if OvrHrs <= 0 then
            exit;

        //07.03.2018 +
        EmployeeJournalTbt.RESET;
        CLEAR(EmployeeJournalTbt);
        L_MaxLineNo := 0;

        EmployeeJournalTbt.SETRANGE("Employee No.", EmpNo);
        if EmployeeJournalTbt.FIND('+') then
            L_MaxLineNo := EmployeeJournalTbt."Entry No.";
        L_MaxLineNo := L_MaxLineNo + 1;
        //07.03.2018 -

        EmployeeJournalTbt.RESET;
        CLEAR(EmployeeJournalTbt);
        //07.03.2018 +
        if OvrHrs > 0 then begin
            //07.03.2018 -
            EmployeeJournalTbt.INIT;
            EmployeeJournalTbt.VALIDATE("Employee No.", EmpNo);
            EmployeeJournalTbt."Transaction Type" := 'ABS';
            EmployeeJournalTbt.VALIDATE("Cause of Absence Code", OvertimeCode);
            EmployeeJournalTbt.VALIDATE("Starting Date", EmployeeABS."From Date");
            EmployeeJournalTbt.VALIDATE("Ending Date", EmployeeABS."From Date");
            EmployeeJournalTbt.Type := 'ABSENCE';
            EmployeeJournalTbt.VALIDATE("Transaction Date", EmployeeABS.Period);
            EmployeeJournalTbt.VALIDATE(Value, OvrHrs);
            EmployeeJournalTbt."Opened By" := USERID;
            EmployeeJournalTbt."Opened Date" := WORKDATE;
            EmployeeJournalTbt."Released By" := USERID;
            EmployeeJournalTbt."Released Date" := WORKDATE;
            EmployeeJournalTbt."Approved By" := USERID;
            EmployeeJournalTbt."Approved Date" := WORKDATE;
            EmployeeJournalTbt."Document Status" := EmployeeJournalTbt."Document Status"::Approved;
            //07.03.2018 +
            EmployeeJournalTbt."Entry No." := L_MaxLineNo;
            EmployeeJournalTbt.INSERT(true);
            CLEAR(EmployeeJournalTbt);
            EmployeeJournalTbt.RESET;
        end;
        //07.03.2018 -
        EmployeeJournalTbt.RESET;
        CLEAR(EmployeeJournalTbt);
        //Code Fixed - 23.03.2017 : AIM -

    end;

    local procedure GetAttendanceOvertimeToleranceBySchedule(EmpNo: Code[20]; DailyShiftCode: Code[20]) Val: Decimal;
    var
        EmployTypeTbt: Record "Employment Type";
        ETyp: Code[20];
        EmpTbt: Record Employee;
        L_PeriodType: DateFormula;
        L_EmpAbs: Record "Employee Absence";
    begin
        if EmpNo = '' then
            exit(0);

        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then
            ETyp := EmpTbt."Employment Type Code";

        if ETyp = '' then
            exit(0);

        EmployTypeTbt.SETRANGE(Code, ETyp);
        if EmployTypeTbt.FINDFIRST then begin
            if not EmployTypeTbt."Use Daily Shift Tolerance" then
                Val := EmployTypeTbt."Overtime Unpaid Hours"
            else begin
                EVALUATE(L_PeriodType, '1D');
                if (L_PeriodType = EmployTypeTbt."Period Type") and (EmployTypeTbt."Use Daily Shift Tolerance") then
                    Val := GetEmployeeUnpaidOVRHrsByDailyShift(EmpNo, DailyShiftCode);

                EVALUATE(L_PeriodType, '1M');
                if (L_PeriodType = EmployTypeTbt."Period Type") and (EmployTypeTbt."Use Daily Shift Tolerance") then
                    Val := GetEmployeeMonthlyEmploymentUnpaidOvertimeHrs(EmpNo, EmpTbt.Period);

            end;
        end;
        exit(Val);
    end;

    local procedure GetAttendanceOvertimeRateBySchedule(EmpNo: Code[20]; DailyShiftCode: Code[10]) Val: Decimal;
    var
        EmployTypeTbt: Record "Employment Type";
        ETyp: Code[20];
        EmpTbt: Record Employee;
        DailyShiftTBT: Record "Daily Shifts";
    begin
        if EmpNo = '' then
            exit(1);

        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then
            ETyp := EmpTbt."Employment Type Code";

        if ETyp = '' then
            exit(1);

        EmployTypeTbt.SETRANGE(Code, ETyp);
        if EmployTypeTbt.FINDFIRST then
            //Modified in order to consider the Rate at Daily Shift - 01.08.2016 : AIM +
            if (EmployTypeTbt."Use Daily Shift Rates" = false) or (DailyShiftCode = '') then
                Val := EmployTypeTbt."Overtime Rate"
            else begin
                DailyShiftTBT.SETRANGE(DailyShiftTBT."Shift Code", DailyShiftCode);
                if DailyShiftTBT.FINDFIRST() then
                    Val := DailyShiftTBT."Overtime Rate"
                else
                    Val := EmployTypeTbt."Overtime Rate";
            end;
        //Modified in order to consider the Rate at Daily Shift - 01.08.2016 : AIM -

        if Val <= 0 then
            Val := 0;

        exit(Val);
    end;

    local procedure GetEntitlementEmpCategoryFilter(EntitleCode: Code[20]; EmpNo: Code[20]; UseDefault: Boolean) EmpCategory: Code[20];
    var
        EmpTBT: Record Employee;
        AbsEntitle: Record "Absence Entitlement";
    begin
        if EmpNo = '' then
            exit('');

        EmpTBT.SETRANGE("No.", EmpNo);
        if EmpTBT.FINDFIRST then
            EmpCategory := EmpTBT."Employee Category Code";

        AbsEntitle.SETRANGE("Cause of Absence Code", EntitleCode);
        AbsEntitle.SETRANGE("Employee Category", EmpCategory);
        if AbsEntitle.FINDFIRST then
            exit(AbsEntitle."Employee Category")
        else begin
            if UseDefault = true then
                exit('')
            else
                exit(EmpCategory);
        end;
    end;

    procedure ChangeMinutes2TimeFormat(Minutes: Decimal) Val: Text;
    var
        DiffMinutes: Decimal;
        M: Integer;
        H: Integer;
    begin
        if (Minutes = 0) then
            exit('00:00');

        H := 0;
        M := 0;

        DiffMinutes := ABS(ROUND(Minutes, 1, '='));

        H := DiffMinutes div 60;

        DiffMinutes := DiffMinutes - (H * 60);


        if DiffMinutes > 0 then
            M := DiffMinutes;

        if H <= 9 then
            Val := '0' + FORMAT(H)
        else
            Val := FORMAT(H);

        if M <= 9 then
            Val := Val + ':' + '0' + FORMAT(M)
        else
            Val := Val + ':' + FORMAT(M);

        exit(Val);
    end;

    procedure DeleteCalculatedPayrollPeriod(PayrollDate: Date; PayrollGroup: Code[10]; EmpNo: Code[20]; ResetPayDetails: Boolean) IsDeleted: Boolean;
    var
        PayLedgerEntry: Record "Payroll Ledger Entry";
        PayStatus: Record "Payroll Status";
        EmpTbt: Record Employee;
        PayDetailLine: Record "Pay Detail Line";
    begin
        if PayrollDate = 0D then
            exit(false);

        if PayrollGroup = '' then
            exit(false);

        //***** check if payroll date is valid and not closed**********//
        PayStatus.SETRANGE(PayStatus."Payroll Group Code", PayrollGroup);
        if PayStatus.FINDFIRST = false then
            exit(false)
        else begin
            if PayrollDate <= PayStatus."Finalized Payroll Date" then
                exit(false);
        end;

        EmpTbt.SETRANGE(EmpTbt."Payroll Group Code", PayrollGroup);
        if EmpNo <> '' then
            EmpTbt.SETRANGE(EmpTbt."No.", EmpNo);

        if EmpTbt.FINDFIRST then
            repeat
                PayLedgerEntry.SETRANGE(PayLedgerEntry."Payroll Date", PayrollDate);
                PayLedgerEntry.SETRANGE(PayLedgerEntry."Employee No.", EmpTbt."No.");
                PayLedgerEntry.SETFILTER(PayLedgerEntry."Posting Date", '=%1', 0D);
                if PayLedgerEntry.FINDFIRST then
                    repeat
                        PayLedgerEntry.DELETE;
                    until PayLedgerEntry.NEXT = 0;

                if ResetPayDetails = true then begin
                    PayDetailLine.SETRANGE(Open, true);
                    PayDetailLine.SETRANGE(PayDetailLine."Employee No.", EmpTbt."No.");
                    if PayDetailLine.FINDFIRST then
                        repeat
                            PayDetailLine.DELETE
                          until PayDetailLine.NEXT = 0;
                end;

            until EmpTbt.NEXT = 0;





        exit(true);
    end;

    procedure GetDaysInMonth(MonthV: Integer; YearV: Integer) D: Integer;
    var
        M: Integer;
        Y: Integer;
    begin
        HRSetup.GET;
        if HRSetup."Average Days Per Month" > 0 then BEGIN
            IF MonthV = 2 THEN BEGIN
                IF (YearV MOD 4 = 0) THEN BEGIN
                    IF HRSetup."Average Days Per Month" > 29 THEN
                        D := 29
                    ELSE
                        D := HRSetup."Average Days Per Month";
                END
                ELSE BEGIN
                    IF HRSetup."Average Days Per Month" > 28 THEN
                        D := 28
                    ELSE
                        D := HRSetup."Average Days Per Month";
                END;
            END
            ELSE
                D := HRSetup."Average Days Per Month";
        END
        else begin
            if (YearV = 0) or (MonthV = 0) then
                D := 30;
            Y := YearV;
            M := MonthV;
            case M of
                1, 3, 5, 7, 8, 10, 12:
                    D := 31;
                4, 6, 9, 11:
                    D := 30;
                2:
                    begin
                        if (Y mod 4 = 0) then
                            D := 29
                        else
                            D := 28
                    end;
            end;
        end;
        exit(D);
    end;

    procedure IgnoreEmploymentTerminationDatesinTaxCalc() IsIgnore: Boolean;
    var
        PerformTaxDaysCheckup: Boolean;
        PayrollParameter: Record "Payroll Parameter";
    begin
        PayrollParameter.GET();

        IsIgnore := not (PayrollParameter."Employ-Termination Affect Tax");
        exit(IsIgnore);
    end;

    procedure GetEmployeeTaxDays(EmpNo: Code[20]; FiscYear: Integer; FMonth: Integer; TMonth: Integer) DaysNb: Integer;
    var
        EmpTBT: Record Employee;
        i: Integer;
        PerformTaxDaysCheckup: Boolean;
        EmployDate: Date;
        TermDate: Date;
        V: Integer;
        Y: Integer;
        M: Integer;
        D: Integer;
    begin
        if FMonth = 0 then
            FMonth := 1;
        if TMonth < FMonth then
            TMonth := FMonth;


        if IgnoreEmploymentTerminationDatesinTaxCalc() = true then
            exit(GetDaysInMonth(TMonth, FiscYear));

        if (EmpNo <> '') and (FiscYear > 0) then begin
            EmpTBT.SETRANGE("No.", EmpNo);
            if EmpTBT.FINDFIRST then begin
                // Modified in order to consider declaration date - 28.09.2017 : A2+
                if EmpTBT."Declaration Date" <> 0D then
                    EmployDate := EmpTBT."Declaration Date"
                else
                    EmployDate := EmpTBT."Employment Date";
                // Modified in order to consider declaration date - 28.09.2017 : A2-

                if EmpTBT."Termination Date" <> 0D then
                    TermDate := EmpTBT."Termination Date";

                if (TermDate = 0D) and (EmpTBT."Inactive Date" <> 0D) then
                    TermDate := EmpTBT."Inactive Date";

                i := FMonth;
                while i <= TMonth do begin
                    V := 0;
                    //***********************************************
                    // Added in order to consider average days per monthe as per HRSetup - 01.06.2017 : A2+
                    HRSetup.GET;
                    if HRSetup."Average Days Per Month" > 0 then BEGIN
                        IF FMonth = 2 THEN BEGIN
                            IF (FiscYear MOD 4 = 0) THEN BEGIN
                                IF HRSetup."Average Days Per Month" > 29 THEN
                                    D := 29
                                ELSE
                                    D := HRSetup."Average Days Per Month";
                            END
                            ELSE BEGIN
                                IF HRSetup."Average Days Per Month" > 28 THEN
                                    D := 28
                                ELSE
                                    D := HRSetup."Average Days Per Month";
                            END
                        END
                        ELSE
                            D := HRSetup."Average Days Per Month"
                    END
                    else begin
                        Y := FiscYear;
                        M := i;
                        case M of
                            1, 3, 5, 7, 8, 10, 12:
                                D := 31;
                            4, 6, 9, 11:
                                D := 30;
                            2:
                                begin
                                    if (Y mod 4 = 0) then
                                        D := 29
                                    else
                                        D := 28
                                end;
                        end;
                    end;
                    if EmployDate <> 0D then begin
                        if DATE2DMY(EmployDate, 3) < FiscYear then begin
                            V := 0;
                        end
                        else
                            if DATE2DMY(EmployDate, 3) = FiscYear then begin
                                if DATE2DMY(EmployDate, 2) = i then begin
                                    if (DATE2DMY(EmployDate, 1) > 1) and (DATE2DMY(EmployDate, 1) < D) then begin
                                        V := DATE2DMY(EmployDate, 1) - 1;
                                    end;
                                end;
                            end
                            else
                                V := 0;
                    end;
                    //***********************************************
                    if TermDate <> 0D then begin
                        if DATE2DMY(TermDate, 3) < FiscYear then begin
                            V := V + 0;
                        end
                        else
                            if DATE2DMY(TermDate, 3) = FiscYear then begin
                                if DATE2DMY(TermDate, 2) = i then begin
                                    if DATE2DMY(TermDate, 1) <> D then begin
                                        V := V + ((D - DATE2DMY(TermDate, 1)));
                                    end;
                                end;
                            end
                            else
                                V := V + 0;
                    end;
                    //***********************************************

                    DaysNb := DaysNb + (D - V);
                    i := i + 1;
                end;
            end;
        end
        else
            DaysNb := 30;

        // Added in order to consider average days per monthe as per HRSetup - 01.06.2017 : A2+
        if (DaysNb > HRSetup."Average Days Per Month") and (HRSetup."Average Days Per Month" > 0) and (FMonth = TMonth) then
            DaysNb := HRSetup."Average Days Per Month";

        // Added in order to consider average days per monthe as per HRSetup - 01.06.2017 : A2-
        exit(DaysNb);
    end;

    procedure UseEmployeeInPayrollCalculation(EmpNo: Code[20]; PayDate: Date; PayFDate: Date; PayTDate: Date) AllowUse: Boolean;
    var
        EmpTBT: Record Employee;
    begin

        if EmpNo = '' then
            exit(false);

        if (PayDate = 0D) or (PayFDate = 0D) or (PayTDate = 0D) then
            exit(false);

        EmpTBT.SETRANGE("No.", EmpNo);
        if not EmpTBT.FINDFIRST then
            exit(false);

        EmpTBT.CALCFIELDS("Include in Pay Cycle");
        if EmpTBT."Include in Pay Cycle" = false then
            exit(false);

        if EmpTBT.Status = EmpTBT.Status::Active then begin
            if EmpTBT."Employment Date" = 0D then
                exit(false);

            if not ((EmpTBT."Employment Date" <= PayDate) or (EmpTBT."Employment Date" <= PayTDate)) then
                exit(false);

        end
        else
            if EmpTBT.Status = EmpTBT.Status::Terminated then begin
                if EmpTBT."Termination Date" <> 0D then begin
                    if EmpTBT."Termination Date" >= PayDate then
                        exit(true)
                    else begin
                        if not ((EmpTBT."Termination Date" >= PayFDate) and (EmpTBT."Termination Date" <= PayTDate)) then
                            exit(false);
                    end;
                end
                else begin
                    if EmpTBT."Employment Date" = 0D then
                        exit(false);

                    if not ((EmpTBT."Employment Date" <= PayDate) or (EmpTBT."Employment Date" <= PayTDate)) then
                        exit(false);
                end;
            end
            else
                if EmpTBT.Status = EmpTBT.Status::Inactive then begin
                    if EmpTBT."Inactive Date" <> 0D then begin
                        if EmpTBT."Inactive Date" >= PayDate then
                            exit(true)
                        else begin
                            if not ((EmpTBT."Inactive Date" >= PayFDate) and (EmpTBT."Inactive Date" <= PayTDate)) then
                                exit(false);
                        end;
                    end
                    else begin
                        if EmpTBT."Employment Date" = 0D then
                            exit(false);

                        if not ((EmpTBT."Employment Date" <= PayDate) or (EmpTBT."Employment Date" <= PayTDate)) then
                            exit(false);
                    end;

                end
                else begin
                    exit(false);
                end;

        exit(true);
    end;

    procedure GetEmployeeOvertimeAbsenceCalculationType(EmpNo: Code[20]) CalcType: Integer;
    var
        EmpTypeTbt: Record "Employment Type";
        EmpTbt: Record Employee;
        OACalcType: Option Daily,Monthly;
        PeriodType: DateFormula;
    begin
        OACalcType := OACalcType::Daily;

        if EmpNo <> '' then begin
            EmpTbt.SETRANGE("No.", EmpNo);
            if EmpTbt.FINDFIRST then begin
                EmpTypeTbt.SETRANGE(EmpTypeTbt.Code, EmpTbt."Employment Type Code");
                if EmpTypeTbt.FINDFIRST then begin
                    EVALUATE(PeriodType, '1M');
                    if PeriodType = EmpTypeTbt."Period Type" then
                        OACalcType := OACalcType::Monthly;

                    EVALUATE(PeriodType, '1D');
                    if PeriodType = EmpTypeTbt."Period Type" then
                        OACalcType := OACalcType::Daily;

                end;
            end
        end;



        if OACalcType = OACalcType::Monthly then
            CalcType := 2
        else
            if OACalcType = OACalcType::Daily then
                CalcType := 1
            else
                CalcType := 0;

        exit(CalcType);
    end;

    local procedure PostEmployeeAttendanceOnMonthlyBasis(EmpNo: Code[20]; Period: Date; NetHours: Decimal);
    var
        AbsCode: Code[20];
        AttType: Option Overtime,Absence;
        EmployeeJournal: Record "Employee Journal Line";
        ALAbsCode: Code[20];
        ALAbsHrs: Decimal;
        EmployeeRec: Record "Employee";
        EmploymentTypeRec: Record "Employment Type";
    begin
        HRSetup.GET;
        if NetHours = 0 then
            exit;

        if NetHours > 0 then begin
            AbsCode := GetAttendanceCauseOfAbsenceCode(AttType::Overtime);//EDM+- 02032020

            if (HRSetup."Accumulate Overtime To AL") and (HRSetup."Overtime To AL Code" <> '') then begin//20190204:A2+-
                AbsCode := HRSetup."Overtime To AL Code";//20190204:A2+-
            end;
        end else
            if NetHours < 0 then begin
                AbsCode := GetAttendanceCauseOfAbsenceCode(AttType::Absence);//EDM+- 02032020
                if (HRSetup."Deduct Absence From AL") and (HRSetup."Deduct Absence From AL Code" <> '') then begin
                    ALAbsCode := HRSetup."Deduct Absence From AL Code";
                    ALAbsHrs := GetEmpAbsenceEntitlementCurrentBalance(EmpNo, HRSetup."Annual Leave Code", 0D);
                    ALAbsHrs := ROUND(ALAbsHrs * GetEmployeeDailyHours(EmpNo, ''));
                    if ALAbsHrs < 0 then
                        ALAbsHrs := 0;

                    NetHours := ABS(NetHours);
                    if NetHours > ALAbsHrs then begin
                        NetHours := NetHours - ALAbsHrs;
                    end else begin
                        ALAbsHrs := NetHours;
                        NetHours := 0;
                    end;
                end else begin
                    AbsCode := GetAttendanceCauseOfAbsenceCode(AttType::Absence);
                end;
            end;

        NetHours := ABS(NetHours);
        if (AbsCode <> '') and (NetHours <> 0) then begin
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.", EmpNo);
            EmployeeJournal."Transaction Type" := 'ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code", AbsCode);
            EmployeeJournal.VALIDATE("Starting Date", Period);
            EmployeeJournal.VALIDATE("Ending Date", Period);
            EmployeeJournal.Type := 'ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date", Period);
            EmployeeJournal.VALIDATE(EmployeeJournal.Value, NetHours);
            EmployeeJournal."Opened By" := USERID;
            EmployeeJournal."Opened Date" := WORKDATE;
            EmployeeJournal."Released By" := USERID;
            EmployeeJournal."Released Date" := WORKDATE;
            EmployeeJournal."Approved By" := USERID;
            EmployeeJournal."Approved Date" := WORKDATE;
            EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
            EmployeeJournal.INSERT(true);
        end;

        if (ALAbsCode <> '') and (ALAbsHrs > 0) then begin
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.", EmpNo);
            EmployeeJournal."Transaction Type" := 'ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code", ALAbsCode);
            EmployeeJournal.VALIDATE("Starting Date", Period);
            EmployeeJournal.VALIDATE("Ending Date", Period);
            EmployeeJournal.Type := 'ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date", Period);
            EmployeeJournal.VALIDATE(EmployeeJournal.Value, ALAbsHrs);
            EmployeeJournal."Opened By" := USERID;
            EmployeeJournal."Opened Date" := WORKDATE;
            EmployeeJournal."Released By" := USERID;
            EmployeeJournal."Released Date" := WORKDATE;
            EmployeeJournal."Approved By" := USERID;
            EmployeeJournal."Approved Date" := WORKDATE;
            EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
            EmployeeJournal.INSERT(true);
        end;
    end;

    procedure GetAttendanceCauseOfAbsenceCode(AttType: Option Overtime,Absence,WorkingDay,LateArrive) Val: Code[10];
    var
        CauseofAbsence: Record "Cause of Absence";
        OVPayElem: Code[20];
        DedPayElem: Code[20];
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.Get();
        if AttType = AttType::Overtime then begin
            if HRSetup.Overtime <> '' then begin
                CauseofAbsence.SETRANGE(CauseofAbsence.Code, HRSetup.Overtime);
                if CauseofAbsence.FINDFIRST then begin
                    if (CauseofAbsence."Unit of Measure Code" = 'HOUR') and
                     (CauseofAbsence."Associated Pay Element" <> '') and
                     (CauseofAbsence."Transaction Type" = CauseofAbsence."Transaction Type"::Overtime) and
                     (not CauseofAbsence.Entitled) and
                     (CauseofAbsence."Unpaid Hours" = 0) then
                        exit(HRSetup.Overtime);
                end;
            end;
        end else
            if AttType = AttType::Absence then begin
                if (HRSetup."Absence Code" <> '') then
                    CauseofAbsence.SETRANGE(CauseofAbsence.Code, HRSetup."Absence Code");

                if CauseofAbsence.FINDFIRST then begin
                    if (CauseofAbsence."Unit of Measure Code" = 'HOUR') and
                     (CauseofAbsence."Affect Work Days") and
                     (CauseofAbsence."Associated Pay Element" = '') and
                     (CauseofAbsence."Transaction Type" = CauseofAbsence."Transaction Type"::Lateness) and
                     (not CauseofAbsence.Entitled) then
                        exit(HRSetup."Absence Code");
                end;
            end else
                if AttType = AttType::LateArrive then begin
                    if (HRSetup."Late Arrive Code" <> '') then
                        CauseofAbsence.SETRANGE(CauseofAbsence.Code, HRSetup."Late Arrive Code");

                    if CauseofAbsence.FINDFIRST then begin
                        if (CauseofAbsence."Unit of Measure Code" = 'HOUR') and
                         (CauseofAbsence."Affect Work Days") and
                         (CauseofAbsence."Associated Pay Element" = '') and
                         (CauseofAbsence."Transaction Type" = CauseofAbsence."Transaction Type"::"Late-Arrive") and
                         (not CauseofAbsence.Entitled) then
                            exit(HRSetup."Late Arrive Code");
                    end;
                end else
                    if AttType = AttType::WorkingDay then begin
                        if (HRSetup."Working Day Code" <> '') then
                            CauseofAbsence.SETRANGE(CauseofAbsence.Code, HRSetup."Working Day Code");

                        if CauseofAbsence.FINDFIRST then begin
                            if (CauseofAbsence."Unit of Measure Code" = 'DAY') and
                              (CauseofAbsence."Associated Pay Element" = '') and
                              (CauseofAbsence."Transaction Type" = CauseofAbsence."Transaction Type"::" ") and
                              (not CauseofAbsence.Entitled) and
                              (CauseofAbsence."Working Day Multiplier" = 1) then
                                exit(HRSetup."Working Day Code");
                        end;
                    end;

        CLEAR(CauseofAbsence);
        case AttType of
            AttType::Overtime:
                begin
                    OVPayElem := '';
                    CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
                    CauseofAbsence.SETRANGE("Unit of Measure Code", 'HOUR');
                    CauseofAbsence.SETRANGE("Associated Pay Element", OVPayElem);
                    CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::Overtime);
                    CauseofAbsence.SETRANGE(Entitled, false);
                    CauseofAbsence.SETRANGE("Unpaid Hours", 0);
                    if CauseofAbsence.FINDFIRST then
                        Val := CauseofAbsence.Code;
                end;

            AttType::Absence:
                begin
                    DedPayElem := '';
                    CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
                    CauseofAbsence.SETRANGE("Unit of Measure Code", 'HOUR');
                    CauseofAbsence.SETRANGE("Affect Work Days", true);
                    CauseofAbsence.SETRANGE("Associated Pay Element", DedPayElem);
                    CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::Lateness);
                    CauseofAbsence.SETRANGE(Entitled, false);
                    if CauseofAbsence.FINDFIRST then
                        Val := CauseofAbsence.Code;
                end;

            AttType::WorkingDay:
                begin
                    CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled);
                    CauseofAbsence.SETRANGE("Unit of Measure Code", 'DAY');
                    CauseofAbsence.SETFILTER("Associated Pay Element", '= %1', '');
                    CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::" ");
                    CauseofAbsence.SETRANGE(Entitled, false);
                    CauseofAbsence.SETFILTER(CauseofAbsence."Working Day Multiplier", ' = %1', 1);
                    if CauseofAbsence.FINDFIRST then
                        Val := CauseofAbsence.Code;
                end;

            AttType::LateArrive:
                begin
                    DedPayElem := '';
                    CauseofAbsence.SETCURRENTKEY("Unit of Measure Code", "Associated Pay Element", "Transaction Type", Entitled, "Unpaid Hours");
                    CauseofAbsence.SETRANGE("Unit of Measure Code", 'HOUR');
                    CauseofAbsence.SETRANGE("Affect Work Days", true);
                    CauseofAbsence.SETRANGE("Associated Pay Element", DedPayElem);
                    CauseofAbsence.SETRANGE("Transaction Type", CauseofAbsence."Transaction Type"::"Late-Arrive");
                    CauseofAbsence.SETRANGE(Entitled, false);
                    if CauseofAbsence.FINDFIRST then
                        Val := CauseofAbsence.Code;
                end;
        end;
        exit(Val);
    end;

    procedure HideSalaryFields() IsHide: Boolean;
    var
        HRPermissionTbt: Record "HR Permissions";
    begin
        HRPermissionTbt.SETRANGE(HRPermissionTbt."User ID", USERID);
        if HRPermissionTbt.FINDFIRST then
            exit(HRPermissionTbt."Hide Salaries")
        else
            // 07.07.2017 : A2+
            exit(true);
        // 07.07.2017 : A2-
    end;

    procedure GetEmployeeDailyHours2(EmpNo: Code[20]) DailyHours: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
    begin

        HRSetup.GET();

        DailyHours := 0;

        if EmpNo = '' then
            exit(0);

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin

            if Employee."Employment Type Code" <> '' then // Check at the level of Employment Type
              begin
                EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
                if EmploymentType.FINDFIRST then begin
                    if EmploymentType."Working Days" > 0 then
                        DailyHours := EmploymentType."Working Hours" / EmploymentType."Working Days";
                end
            end;

            if DailyHours = 0 then // Check at the level of HR Setup
              begin
                if HRSetup."Hours To Days Month Period" > 0 then
                    DailyHours := HRSetup."Hours To Days Month Period"
                else
                    DailyHours := HRSetup."Hours in the Day";
            end;

            if DailyHours = 0 then
                DailyHours := 9;
        end;


        exit(DailyHours);
    end;


    local procedure GetCauseOfAttendanceUnitMeasure(CauseofAttendanceCode: Code[11]) V: Code[10];
    var
        CauseofAttTBT: Record "Cause of Absence";
    begin
        if CauseofAttendanceCode = '' then
            exit('');

        CauseofAttTBT.SETRANGE(Code, CauseofAttendanceCode);
        if CauseofAttTBT.FINDFIRST() then
            V := CauseofAttTBT."Unit of Measure Code";


        exit(V);
    end;

    procedure GetEmpAssignedAbsenceToALEntitlement(EmpNo: Code[20]; AbsEntCode: Code[10]; FDate: Date; TDate: Date) Val: Decimal;
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        EmpJnlLine: Record "Employee Journal Line";
        AssignedDays: Decimal;
        AbsCode: Code[10];
        HRSetupTbt: Record "Human Resources Setup";
        HrsPerDay: Decimal;
    begin
        if EmpNo = '' then
            exit(0);

        if (FDate = 0D) or (TDate = 0D) then
            exit(0);

        Val := 0;

        HRSetupTbt.GET();

        if not ((HRSetupTbt."Annual Leave Code" <> '') and (HRSetupTbt."Annual Leave Code" = AbsEntCode)) then
            exit(0);

        AbsCode := HRSetupTbt."Deduct Absence From AL Code";

        if AbsCode = '' then
            exit(0);

        EmpJnlLine.SETRANGE("Employee No.", EmpNo);
        EmpJnlLine.SETRANGE("Cause of Absence Code", AbsCode);
        EmpJnlLine.SETRANGE("Transaction Type", 'ABS');
        EmpJnlLine.SETRANGE(Type, 'ABSENCE');
        EmpJnlLine.SETRANGE("Document Status", EmpJnlLine."Document Status"::Approved);
        EmpJnlLine.SETFILTER("Starting Date", '%1..%2', FDate, TDate);
        EmpJnlLine.SETFILTER("Ending Date", '%1..%2', FDate, TDate);

        if EmpJnlLine.FIND('-') then
            repeat
                if UPPERCASE(EmpJnlLine."Unit of Measure Code") = UPPERCASE('DAY') then
                    Val := Val + EmpJnlLine."Calculated Value"
                else
                    if UPPERCASE(EmpJnlLine."Unit of Measure Code") = UPPERCASE('HOUR') then begin
                        HrsPerDay := GetEmployeeDailyHours(EmpNo, '');
                        if HrsPerDay > 0 then
                            Val := Val + ROUND(EmpJnlLine."Calculated Value" / HrsPerDay, 0.01)
                    end;
            until EmpJnlLine.NEXT = 0;


        exit(Val);
    end;

    procedure GetEmpAssignedOvertimeToALEntitlement(EmpNo: Code[20]; AbsEntCode: Code[10]; FDate: Date; TDate: Date) Val: Decimal;
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        EmpJnlLine: Record "Employee Journal Line";
        AssignedDays: Decimal;
        HRSetupTbt: Record "Human Resources Setup";
        AbsCode: Code[10];
        HrsPerDay: Decimal;
    begin

        if EmpNo = '' then
            exit(0);

        if (FDate = 0D) or (TDate = 0D) then
            exit(0);

        Val := 0;

        HRSetupTbt.GET();

        if not ((HRSetupTbt."Annual Leave Code" <> '') and (HRSetupTbt."Annual Leave Code" = AbsEntCode)) then
            exit(0);

        AbsCode := HRSetupTbt."Overtime To AL Code";

        if AbsCode = '' then
            exit(0);

        EmpJnlLine.RESET;
        CLEAR(EmpJnlLine);

        EmpJnlLine.SETRANGE("Employee No.", EmpNo);
        EmpJnlLine.SETRANGE("Cause of Absence Code", AbsCode);
        EmpJnlLine.SETRANGE("Transaction Type", 'ABS');
        EmpJnlLine.SETRANGE(Type, 'ABSENCE');
        EmpJnlLine.SETRANGE("Document Status", EmpJnlLine."Document Status"::Approved);
        EmpJnlLine.SETFILTER("Starting Date", '%1..%2', FDate, TDate);
        EmpJnlLine.SETFILTER("Ending Date", '%1..%2', FDate, TDate);

        if EmpJnlLine.FINDFIRST then
            repeat
                if UPPERCASE(EmpJnlLine."Unit of Measure Code") = UPPERCASE('DAY') then
                    Val := Val + EmpJnlLine."Calculated Value"
                else
                    if UPPERCASE(EmpJnlLine."Unit of Measure Code") = UPPERCASE('HOUR') then begin
                        HrsPerDay := GetEmployeeDailyHours(EmpNo, '');
                        if HrsPerDay > 0 then
                            Val := Val + ROUND(EmpJnlLine."Calculated Value" / HrsPerDay, 0.01)
                    end;
            until EmpJnlLine.NEXT = 0;


        exit(Val);
    end;

    procedure UpdateEmpEntitlementTotals(PeriodDate: Date; EmpNo: Code[20]);
    var
        EmpEntitleTBT: Record "Employee Absence Entitlement";
        HRSetupRec: Record "Human Resources Setup";
    begin
        if EmpNo <> '' then
            EmpEntitleTBT.SETRANGE("Employee No.", EmpNo);

        EmpEntitleTBT.SETFILTER("Till Date", '>%1', PeriodDate);
        if EmpEntitleTBT.FindFirst then
            repeat
                EmpEntitleTBT."Attendance Additions" := GetEmpAssignedOvertimeToALEntitlement(EmpEntitleTBT."Employee No.", EmpEntitleTBT."Cause of Absence Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date");
                EmpEntitleTBT."Attendance Deductions" := GetEmpAssignedAbsenceToALEntitlement(EmpEntitleTBT."Employee No.", EmpEntitleTBT."Cause of Absence Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date");
                EmpEntitleTBT.Taken := GetEmpTakenAbsenceEntitlement(EmpEntitleTBT."Employee No.", EmpEntitleTBT."Cause of Absence Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date", false);
                EmpEntitleTBT.MODIFY;
            until EmpEntitleTBT.NEXT = 0;
        ///EDM+ 14-10-2020
        HRSetupRec.GET;
        EmpEntitleTBT.SETFILTER("Till Date", '>=%1', PeriodDate);
        EmpEntitleTBT.SETRANGE("Cause of Absence Code", HRSetupRec."Sunday Leave Code");
        if EmpEntitleTBT.FindFirst then
            repeat
                EmpEntitleTBT."Attendance Additions" := GetSundaysToALEntitlement(EmpEntitleTBT."Employee No.", HRSetupRec."Sunday Leave Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date");
                //EmpEntitleTBT."Attendance Deductions" := GetSundaysAbsenceToALEntitlement(EmpEntitleTBT."Employee No.",HRSetupRec."Sunday Leave Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date");   
                EmpEntitleTBT.Taken := GetEmpTakenAbsenceEntitlement(EmpEntitleTBT."Employee No.", HRSetupRec."Sunday Leave Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date", false);
                EmpEntitleTBT.MODIFY;
            until EmpEntitleTBT.NEXT = 0;
        //
        HRSetupRec.GET;
        EmpEntitleTBT.SETFILTER("Till Date", '>=%1', PeriodDate);
        EmpEntitleTBT.SETRANGE("Cause of Absence Code", HRSetupRec."Holiday Leave Code");
        if EmpEntitleTBT.FindFirst then
            repeat
                EmpEntitleTBT."Attendance Additions" := GetHolidaysToALEntitlement(EmpEntitleTBT."Employee No.", HRSetupRec."Holiday Leave Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date");
                //EmpEntitleTBT."Attendance Deductions" := GetHolidayssAbsenceToALEntitlement(EmpEntitleTBT."Employee No.",HRSetupRec."Holiday Leave Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date");   
                EmpEntitleTBT.Taken := GetEmpTakenAbsenceEntitlement(EmpEntitleTBT."Employee No.", HRSetupRec."Holiday Leave Code", EmpEntitleTBT."From Date", EmpEntitleTBT."Till Date", false);
                EmpEntitleTBT.MODIFY;
            until EmpEntitleTBT.NEXT = 0;
        //EDM- 14-10-2020
    end;

    procedure CheckIfAttendanceNoExists(AttendanceNo: Integer) EmpNo: Code[20];
    var
        EmpTBT: Record Employee;
    begin
        if AttendanceNo = 0 then
            exit('');

        EmpTBT.SETRANGE("Attendance No.", AttendanceNo);
        if EmpTBT.FINDFIRST then
            exit(EmpTBT."No.");

        exit('');
    end;

    local procedure FixEmployeeDailyLateLeaveValue(EmpNo: Code[20]; AttendDate: Date; LateLeaveMinutes: Decimal) V: Decimal;
    var
        EmploymentTypeTbt: Record "Employment Type";
        EmployeeTbt: Record Employee;
        EmpAbsTbt: Record "Employee Absence";
    begin
        if (EmpNo = '') or (AttendDate = 0D) then
            exit(LateLeaveMinutes);

        V := LateLeaveMinutes;
        EmpAbsTbt.SETRANGE(EmpAbsTbt."Employee No.", EmpNo);
        EmpAbsTbt.SETRANGE(EmpAbsTbt."From Date", AttendDate);
        if EmpAbsTbt.FINDFIRST then begin

            EmployeeTbt.SETRANGE(EmployeeTbt."No.", EmpAbsTbt."Employee No.");
            if EmployeeTbt.FINDFIRST then begin
                if EmployeeTbt."Employment Type Code" <> '' then begin
                    EmploymentTypeTbt.SETRANGE(EmploymentTypeTbt.Code, EmployeeTbt."Employment Type Code");
                    if EmploymentTypeTbt.FINDFIRST then begin
                        if (EmploymentTypeTbt."Late Leave Not Allowed" = true) then
                            V := 0;

                    end;
                end;
            end;
        end;

        exit(V);
    end;

    local procedure FixEmployeeDailyEarlyArriveValue(EmpNo: Code[20]; AttendDate: Date; EarlyArriveMinutes: Decimal) V: Decimal;
    var
        EmploymentTypeTbt: Record "Employment Type";
        EmployeeTbt: Record Employee;
        EmpAbsTbt: Record "Employee Absence";
    begin

        if (EmpNo = '') or (AttendDate = 0D) then
            exit(EarlyArriveMinutes);

        V := EarlyArriveMinutes;

        EmpAbsTbt.SETRANGE(EmpAbsTbt."Employee No.", EmpNo);
        EmpAbsTbt.SETRANGE(EmpAbsTbt."From Date", AttendDate);
        if EmpAbsTbt.FINDFIRST then begin

            EmployeeTbt.SETRANGE(EmployeeTbt."No.", EmpAbsTbt."Employee No.");
            if EmployeeTbt.FINDFIRST then begin
                if EmployeeTbt."Employment Type Code" <> '' then begin
                    EmploymentTypeTbt.SETRANGE(EmploymentTypeTbt.Code, EmployeeTbt."Employment Type Code");
                    if EmploymentTypeTbt.FINDFIRST then begin
                        if (EmploymentTypeTbt."Early Arrive Not Allowed" = true) then
                            V := 0;

                    end;
                end;
            end;
        end;

        exit(V);
    end;

    local procedure FixEmployeeDailyOvertimeValue(EmpNo: Code[20]; AttendDate: Date; OvertimeHrs: Decimal) V: Decimal;
    var
        EmploymentTypeTbt: Record "Employment Type";
        EmployeeTbt: Record Employee;
        EmpAbsTbt: Record "Employee Absence";
    begin

        if (EmpNo = '') or (AttendDate = 0D) then
            exit(OvertimeHrs);

        if OvertimeHrs <= 0 then
            exit(0);

        V := OvertimeHrs;

        EmpAbsTbt.SETRANGE(EmpAbsTbt."Employee No.", EmpNo);
        EmpAbsTbt.SETRANGE(EmpAbsTbt."From Date", AttendDate);
        if EmpAbsTbt.FINDFIRST then begin

            EmployeeTbt.SETRANGE(EmployeeTbt."No.", EmpAbsTbt."Employee No.");
            if EmployeeTbt.FINDFIRST then begin
                if EmployeeTbt."Employment Type Code" <> '' then begin
                    EmploymentTypeTbt.SETRANGE(EmploymentTypeTbt.Code, EmployeeTbt."Employment Type Code");
                    if EmploymentTypeTbt.FINDFIRST then begin
                        if (EmploymentTypeTbt."Max Allowed Overtime Per Day" > 0) then begin
                            if (OvertimeHrs > (EmpAbsTbt."Attend Hrs." - (EmpAbsTbt."Required Hrs" + EmploymentTypeTbt."Max Allowed Overtime Per Day")))
                                    and (EmpAbsTbt."Attend Hrs." - (EmpAbsTbt."Required Hrs" + EmploymentTypeTbt."Max Allowed Overtime Per Day") > 0) then
                                V := EmploymentTypeTbt."Max Allowed Overtime Per Day";
                        end;

                    end;
                end;
            end;
        end;

        exit(V);
    end;

    procedure GetPeriodEndDate(gPayStatusRec: Record "Payroll Status") PerioEndDate: Date;
    var
        lFinalizedPeriodDate: Date;
        lDateExpr: Text[30];
        lMonth: Integer;
        lDay: Integer;
        lYear: Integer;
        lNoOfDays: Integer;
        lPEndDate: Date;
    begin

        lFinalizedPeriodDate := gPayStatusRec."Finalized Payroll Date";

        lMonth := DATE2DMY(lFinalizedPeriodDate, 2);
        lDay := DATE2DMY(lFinalizedPeriodDate, 1);
        lYear := DATE2DMY(lFinalizedPeriodDate, 3);

        lNoOfDays := DMY2DATE(31, 12, lYear) - DMY2DATE(31, 12, lYear - 1);

        if gPayStatusRec."Pay Frequency" = gPayStatusRec."Pay Frequency"::Monthly then begin
            case lMonth of
                1:
                    begin
                        if lNoOfDays = 366 then
                            lDateExpr := '+29D'
                        else
                            lDateExpr := '+28D';
                    end;
                2:
                    lDateExpr := '+31D';
                3, 5, 8, 10:
                    lDateExpr := '+30D';
                4, 6, 7, 9, 11:
                    lDateExpr := '+31D';
                12:
                    lDateExpr := '+31D'
            end;
        end
        else begin
            lDateExpr := '+1W';
        end;

        lPEndDate := CALCDATE(lDateExpr, lFinalizedPeriodDate);
        PerioEndDate := lPEndDate;
        exit(PerioEndDate);
    end;

    procedure ImportRecurringPayrollJournalsFromPreviousPeriod(PayrollGroupCode: Code[20]; EmpNo: Code[20]; HRTransType: Code[20]; CheckRecurringInJournals: Boolean; ImportFromDate: Date; ImportTillDate: Date; NewJournalsDate: Date; UpdateExisiting: Boolean; AutoApprove: Boolean);
    var
        L_Employee: Record Employee;
        L_EmpJnlLine: Record "Employee Journal Line";
        L_EmpJnlLine2: Record "Employee Journal Line";
        L_HRTransTypes: Record "HR Transaction Types";
        L_HRTransTypesTbt: Record "HR Transaction Types";
        L_MaxLineNo: Integer;
        L_PayrollLedEntryTbt: Record "Payroll Ledger Entry";
    begin
        if (ImportFromDate = 0D) or (ImportTillDate = 0D) or (NewJournalsDate = 0D) then
            exit;

        IF NOT CheckRecurringInJournals THEN begin
            if HRTransType = '' then
                exit;

            L_HRTransTypesTbt.SETRANGE(L_HRTransTypesTbt.Code, HRTransType);
            L_HRTransTypesTbt.SETRANGE(Recurring, TRUE);
            IF NOT L_HRTransTypesTbt.FINDFIRST THEN
                EXIT
        end;

        L_Employee.RESET;
        if EmpNo <> '' then
            L_Employee.SETRANGE("No.", EmpNo);

        if PayrollGroupCode <> '' then
            L_Employee.SETRANGE(L_Employee."Payroll Group Code", PayrollGroupCode);

        L_Employee.SETRANGE(Status, L_Employee.Status::Active);

        IF L_Employee.FINDFIRST THEN
            REPEAT
                Paystatus.GET(L_Employee."Payroll Group Code");
                IF (L_Employee."Payroll Group Code" <> '') THEN BEGIN
                    //****************************************
                    L_PayrollLedEntryTbt.SETRANGE(L_PayrollLedEntryTbt."Employee No.", EmpNo);
                    IF L_PayrollLedEntryTbt.FINDFIRST THEN
                        REPEAT
                            IF L_PayrollLedEntryTbt."Payroll Date" >= NewJournalsDate THEN
                                IF L_PayrollLedEntryTbt."Posting Date" <> 0D THEN
                                    EXIT;
                        UNTIL L_PayrollLedEntryTbt.NEXT = 0;
                    //****************************************

                    //****************************************
                    Paystatus.GET(L_Employee."Payroll Group Code");
                    IF NewJournalsDate < Paystatus."Period Start Date" THEN
                        EXIT;
                    IF NewJournalsDate < Paystatus."Payroll Date" THEN
                        EXIT;
                    //****************************************

                    IF (L_Employee."Termination Date" = 0D) AND (L_Employee."Inactive Date" = 0D) THEN BEGIN
                        L_MaxLineNo := 0;
                        CLEAR(L_EmpJnlLine);
                        L_EmpJnlLine.RESET;
                        L_EmpJnlLine.SETRANGE("Employee No.", EmpNo);
                        IF L_EmpJnlLine.FINDLAST THEN
                            L_MaxLineNo := L_EmpJnlLine."Entry No.";

                        CLEAR(L_EmpJnlLine);
                        L_EmpJnlLine.RESET;
                        CLEAR(L_EmpJnlLine2);
                        L_EmpJnlLine2.RESET;

                        L_EmpJnlLine.SETRANGE("Employee No.", L_Employee."No.");
                        L_EmpJnlLine.SETRANGE(L_EmpJnlLine."Document Status", L_EmpJnlLine."Document Status"::Approved);
                        L_EmpJnlLine.SETRANGE(L_EmpJnlLine.Processed, TRUE);
                        L_EmpJnlLine.SETFILTER("Transaction Date", '%1..%2', ImportFromDate, ImportTillDate);
                        L_EmpJnlLine.SETRANGE(L_EmpJnlLine."Transaction Type", L_HRTransTypesTbt.Code);
                        L_EmpJnlLine.SETFILTER(L_EmpJnlLine.Value, '<>%1', 0);

                        IF CheckRecurringInJournals THEN BEGIN
                            L_EmpJnlLine.SETRANGE(Recurring, TRUE);
                            L_EmpJnlLine.SETRANGE(L_EmpJnlLine."Recurring Copied", FALSE);
                        END;

                        IF L_EmpJnlLine.FINDFIRST THEN
                            REPEAT
                                CLEAR(L_EmpJnlLine2);
                                L_EmpJnlLine2.RESET;
                                L_EmpJnlLine2.SETRANGE("Transaction Type", L_HRTransTypesTbt.Code);
                                L_EmpJnlLine2.SETRANGE("Transaction Date", NewJournalsDate);
                                //Added in order to filter by employee - 07.04.2017 : AIM +
                                L_EmpJnlLine2.SETRANGE("Employee No.", L_Employee."No.");
                                //Added in order to filter by employee - 07.04.2017 : AIM -
                                IF L_EmpJnlLine2.FINDFIRST THEN BEGIN
                                    IF UpdateExisiting THEN BEGIN
                                        IF (L_EmpJnlLine2."Document Status" <> L_EmpJnlLine2."Document Status"::Released) AND (L_EmpJnlLine2."Document Status" <> L_EmpJnlLine2."Document Status"::Approved) THEN BEGIN
                                            L_EmpJnlLine2.Description := L_EmpJnlLine.Description;
                                            L_EmpJnlLine2."More Information" := L_EmpJnlLine."More Information";
                                            L_EmpJnlLine2.VALIDATE(Value, L_EmpJnlLine.Value);
                                            L_EmpJnlLine2."Opened By" := USERID;
                                            L_EmpJnlLine2."Opened Date" := WORKDATE;
                                            L_EmpJnlLine2.Processed := FALSE;
                                            L_EmpJnlLine2."Processed Date" := 0D;
                                            // Modified in order to auto approve journals and to consider transaction type - 09.02.2018 : A2+
                                            L_EmpJnlLine2.Type := L_HRTransTypesTbt.Type;
                                            IF NOT AutoApprove THEN BEGIN
                                                L_EmpJnlLine2."Released By" := '';
                                                L_EmpJnlLine2."Released Date" := 0D;
                                                L_EmpJnlLine2."Approved By" := '';
                                                L_EmpJnlLine2."Approved Date" := 0D;
                                                L_EmpJnlLine2."Document Status" := L_EmpJnlLine2."Document Status"::Opened;
                                            END ELSE BEGIN
                                                L_EmpJnlLine2."Released By" := USERID;
                                                L_EmpJnlLine2."Released Date" := WORKDATE;
                                                L_EmpJnlLine2."Approved By" := USERID;
                                                L_EmpJnlLine2."Approved Date" := WORKDATE;
                                                L_EmpJnlLine2."Document Status" := L_EmpJnlLine2."Document Status"::Approved;
                                            END;
                                            // Modified in order to auto approve journals and to consider transaction type - 09.02.2018 : A2-
                                            L_EmpJnlLine2.MODIFY;
                                        END;
                                    END;
                                END ELSE BEGIN
                                    CLEAR(L_EmpJnlLine2);
                                    L_EmpJnlLine2.RESET;
                                    L_EmpJnlLine2.INIT;
                                    L_EmpJnlLine2.COPY(L_EmpJnlLine);
                                    L_EmpJnlLine2."Entry No." := L_MaxLineNo + 1;
                                    L_EmpJnlLine2.VALIDATE("Transaction Date", NewJournalsDate);
                                    L_EmpJnlLine2.VALIDATE(Value, L_EmpJnlLine.Value);
                                    L_EmpJnlLine2."Opened By" := USERID;
                                    L_EmpJnlLine2."Opened Date" := WORKDATE;
                                    // Modified in order to auto approve journals and to consider transaction type - 09.02.2018 : A2+
                                    L_EmpJnlLine2.Type := L_HRTransTypesTbt.Type;
                                    IF NOT AutoApprove THEN BEGIN
                                        L_EmpJnlLine2."Released By" := '';
                                        L_EmpJnlLine2."Released Date" := 0D;
                                        L_EmpJnlLine2."Approved By" := '';
                                        L_EmpJnlLine2."Approved Date" := 0D;
                                        L_EmpJnlLine2."Document Status" := L_EmpJnlLine2."Document Status"::Opened;
                                    END ELSE BEGIN
                                        L_EmpJnlLine2."Released By" := USERID;
                                        L_EmpJnlLine2."Released Date" := WORKDATE;
                                        L_EmpJnlLine2."Approved By" := USERID;
                                        L_EmpJnlLine2."Approved Date" := WORKDATE;
                                        L_EmpJnlLine2."Document Status" := L_EmpJnlLine2."Document Status"::Approved;
                                    END;
                                    // Modified in order to auto approve journals and to consider transaction type - 09.02.2018 : A2-
                                    L_EmpJnlLine2.Processed := FALSE;
                                    L_EmpJnlLine2."Processed Date" := 0D;
                                    L_EmpJnlLine2.INSERT(TRUE);
                                END;
                                L_EmpJnlLine."Recurring Copied" := TRUE;
                                L_EmpJnlLine.Recurring := L_HRTransTypesTbt.Recurring;
                                L_EmpJnlLine.MODIFY;
                            UNTIL L_EmpJnlLine.NEXT = 0
                    END;
                END;
            UNTIL L_Employee.NEXT = 0;
    end;

    procedure AssignScheduledLeavesonAttendance(EmpNo: Code[20]; ResetAttendHrs: Boolean);
    var
        LeaveReqTbt: Record "Leave Request";
        EmpAbsTbt: Record "Employee Absence";
        i: Integer;
        LeaveDate: Date;
        DailyShiftsTBT: Record "Daily Shifts";
        ShiftCode: Code[20];
        Period: Date;
        EmpTBT: Record Employee;
        LeaveFTime: Time;
        LeaveTTime: Time;
        LeaveHours: Decimal;
        RequiredHours: Decimal;
        V: Decimal;
        CauseOfAbsence: Record "Cause of Absence";
        DaysDiff: Integer;
        EmployeeAbsc: Record "Employee Absence";
        IsHalfLast: Boolean;
        IsHalfDayLeave: Boolean;
        L_IsSeperateAttendanceInterval: Boolean;
        L_PayStatus: Record "Payroll Status";
    begin
        LeaveReqTbt.SETRANGE(LeaveReqTbt.Status, LeaveReqTbt.Status::Open);

        IF EmpNo <> '' THEN
            LeaveReqTbt.SETRANGE(LeaveReqTbt."Employee No.", EmpNo);


        IF LeaveReqTbt.FINDFIRST() THEN
            REPEAT //1+
            BEGIN //2+
                Period := 0D;
                EmpNo := LeaveReqTbt."Employee No.";
                EmpTBT.SETRANGE(EmpTBT."No.", EmpNo);
                IF EmpTBT.FINDFIRST THEN
                    Period := EmpTBT.Period;

                //Added to consider the case of seperate attendance interval - 24.07.2018 : AIM +
                L_IsSeperateAttendanceInterval := IsSeparateAttendanceInterval(EmpTBT."Payroll Group Code");
                IF L_IsSeperateAttendanceInterval = TRUE THEN BEGIN
                    L_PayStatus.SETRANGE(L_PayStatus."Payroll Group Code", EmpTBT."Payroll Group Code");
                    ;
                    IF L_PayStatus.FINDFIRST THEN BEGIN
                        IF (L_PayStatus."Attendance Start Date" <> 0D) AND (L_PayStatus."Attendance End Date" <> 0D) THEN BEGIN
                            IF (L_PayStatus."Attendance Start Date" <= Period) AND (Period <= L_PayStatus."Attendance End Date") THEN
                                Period := L_PayStatus."Attendance Start Date";
                        END;
                    END;
                END;
                //Added to consider the case of seperate attendance interval - 24.07.2018 : AIM -

                // 31.05.2017 : A2+
                CauseOfAbsence.SETRANGE(Code, LeaveReqTbt."Leave Type");
                IF CauseOfAbsence.FINDFIRST THEN BEGIN
                    // 31.05.2017 : A2-
                    IF (Period <> 0D) AND (EmpTBT.Status = EmpTBT.Status::Active) AND (LeaveReqTbt."From Date" <> 0D) AND (LeaveReqTbt."To Date" <> 0D) THEN //21.02.2017 : AIM +-

                      BEGIN //3+
                        IF CanModifyAttendancePeriod(EmpNo, Period, TRUE, FALSE, FALSE, FALSE) = TRUE THEN BEGIN //4+
                                                                                                                 // 31.05.2017 : A2+
                            IF CauseOfAbsence."Request Category Type" = CauseOfAbsence."Request Category Type"::"General Leave Request" THEN BEGIN
                                // 31.05.2017 : A2-
                                WHILE (LeaveDate <= LeaveReqTbt."To Date") DO BEGIN //5+
                                    IF LeaveDate = 0D THEN
                                        LeaveDate := LeaveReqTbt."From Date";
                                    //21.02.2017 : AIM+
                                    IF LeaveDate >= Period THEN //6+
                                       BEGIN
                                        DailyShiftsTBT.RESET;
                                        CLEAR(DailyShiftsTBT);
                                        //21.02.2017 : AIM-
                                        DailyShiftsTBT.SETRANGE(DailyShiftsTBT."Cause Code", LeaveReqTbt."Leave Type");
                                        IF DailyShiftsTBT.FINDFIRST() THEN BEGIN
                                            ShiftCode := DailyShiftsTBT."Shift Code";


                                            LeaveHours := 0;
                                            RequiredHours := 0;



                                            EmpAbsTbt.SETRANGE(EmpAbsTbt."Employee No.", LeaveReqTbt."Employee No.");
                                            EmpAbsTbt.SETRANGE(EmpAbsTbt."From Date", LeaveDate);
                                            IF EmpAbsTbt.FINDFIRST THEN BEGIN
                                                IF LeaveReqTbt."From Date" = LeaveReqTbt."To Date" THEN //Leave scheduled for one day only
                                                   BEGIN

                                                    IF LeaveReqTbt."From Time" <> 0T THEN
                                                        LeaveFTime := LeaveReqTbt."From Time"
                                                    ELSE
                                                        LeaveFTime := EmpAbsTbt."From Time";  // DailyShiftsTBT."From Time";

                                                    IF LeaveReqTbt."To Time" <> 0T THEN
                                                        LeaveTTime := LeaveReqTbt."To Time"
                                                    ELSE
                                                        LeaveTTime := EmpAbsTbt."To Time";  //DailyShiftsTBT."To Time";

                                                END
                                                ELSE BEGIN
                                                    IF LeaveDate = LeaveReqTbt."From Date" THEN BEGIN
                                                        IF LeaveReqTbt."From Time" <> 0T THEN
                                                            LeaveFTime := LeaveReqTbt."From Time"
                                                        ELSE
                                                            LeaveFTime := EmpAbsTbt."From Time"; // DailyShiftsTBT."From Time";

                                                        LeaveTTime := EmpAbsTbt."To Time"; //  DailyShiftsTBT."To Time";

                                                    END
                                                    ELSE
                                                        IF LeaveDate = LeaveReqTbt."To Date" THEN BEGIN
                                                            LeaveFTime := EmpAbsTbt."From Time"; //DailyShiftsTBT."From Time";

                                                            IF LeaveReqTbt."To Time" <> 0T THEN
                                                                LeaveTTime := LeaveReqTbt."To Time"
                                                            ELSE
                                                                LeaveTTime := EmpAbsTbt."To Time";//DailyShiftsTBT."To Time";
                                                        END
                                                        ELSE BEGIN
                                                            LeaveFTime := EmpAbsTbt."From Time"; //DailyShiftsTBT."From Time";
                                                            LeaveTTime := EmpAbsTbt."To Time";//DailyShiftsTBT."To Time";
                                                        END;
                                                END;
                                                IF LeaveReqTbt."Days Value" > 0 THEN
                                                    LeaveTTime := LeaveFTime;

                                                IF (LeaveTTime <> 0T) AND (LeaveFTime <> 0T) THEN BEGIN
                                                    LeaveHours := ROUND(((LeaveTTime - LeaveFTime) / 60000) / 60, 0.01);
                                                END;

                                                IF ResetAttendHrs = TRUE THEN BEGIN
                                                    EmpAbsTbt."Attend Hrs." := 0;
                                                    EmpAbsTbt."Early Arrive" := 0;
                                                    EmpAbsTbt."Early Leave" := 0;
                                                    EmpAbsTbt."Late Arrive" := 0;
                                                    EmpAbsTbt."Late Leave" := 0;
                                                END;



                                                RequiredHours := ROUND(((EmpAbsTbt."To Time" - EmpAbsTbt."From Time") / 60000) / 60, 0.01);

                                                IF (LeaveReqTbt."Days Value" > 0) AND (LeaveReqTbt."Days Value" < 1) THEN
                                                    LeaveHours := ROUND(RequiredHours * LeaveReqTbt."Days Value", 0.01)
                                                ELSE
                                                    IF (LeaveReqTbt."Days Value" >= 1) THEN
                                                        LeaveHours := RequiredHours
                                                    ELSE BEGIN

                                                    END;
                                                V := 0;
                                                IF RequiredHours > 0 THEN
                                                    V := ROUND(LeaveHours / RequiredHours, 0.01)
                                                ELSE
                                                    V := 0;

                                                ShiftCode := FixCauseofAbsenceCode(ShiftCode, V);

                                                IF (STRPOS(UPPERCASE(ShiftCode), UPPERCASE('AL')) > 0) OR (STRPOS(UPPERCASE(ShiftCode), UPPERCASE('CL')) > 0) OR (STRPOS(UPPERCASE(ShiftCode), UPPERCASE('SKD')) > 0)
                                                            //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM +
                                                            OR (STRPOS(UPPERCASE(ShiftCode), UPPERCASE(GetCustomizedLeaveCode())) > 0)
                                                            //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM -
                                                            OR (STRPOS(UPPERCASE(ShiftCode), UPPERCASE('UL')) > 0) THEN BEGIN
                                                    IF (UPPERCASE(ShiftCode) = UPPERCASE('0.25AL')) OR (UPPERCASE(ShiftCode) = UPPERCASE('0.25CL')) OR (UPPERCASE(ShiftCode) = UPPERCASE('0.25SKD'))
                                                              //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM +
                                                              OR (UPPERCASE(ShiftCode) = UPPERCASE('0.25' + GetCustomizedLeaveCode()))
                                                              //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM -
                                                              OR (UPPERCASE(ShiftCode) = UPPERCASE('0.25UL')) THEN
                                                        RequiredHours := RequiredHours - ROUND(RequiredHours * 0.25, 0.01)
                                                    ELSE
                                                        IF (UPPERCASE(ShiftCode) = UPPERCASE('0.5AL')) OR (UPPERCASE(ShiftCode) = UPPERCASE('0.5CL')) OR (UPPERCASE(ShiftCode) = UPPERCASE('0.5SKD'))
                                                             //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM +
                                                             OR (UPPERCASE(ShiftCode) = UPPERCASE('0.5' + GetCustomizedLeaveCode()))
                                                             //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM -
                                                             OR (UPPERCASE(ShiftCode) = UPPERCASE('0.5UL')) THEN
                                                            RequiredHours := RequiredHours - ROUND(RequiredHours * 0.5, 0.01)
                                                        ELSE
                                                            IF (UPPERCASE(ShiftCode) = UPPERCASE('0.75AL')) OR (UPPERCASE(ShiftCode) = UPPERCASE('0.75CL')) OR (UPPERCASE(ShiftCode) = UPPERCASE('0.75SKD'))
                                                             //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM +
                                                             OR (UPPERCASE(ShiftCode) = UPPERCASE('0.75' + GetCustomizedLeaveCode()))
                                                             //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM -
                                                             OR (UPPERCASE(ShiftCode) = UPPERCASE('0.75UL')) THEN
                                                                RequiredHours := RequiredHours - ROUND(RequiredHours * 0.75, 0.01)

                                                            ELSE
                                                                RequiredHours := 0;

                                                    LeaveHours := RequiredHours;

                                                END
                                                ELSE BEGIN
                                                    RequiredHours := RequiredHours - LeaveHours;
                                                END;

                                                IF RequiredHours <= 0 THEN
                                                    RequiredHours := 0;
                                                IF LeaveHours <= 0 THEN
                                                    LeaveHours := 0;



                                                DailyShiftsTBT.RESET();
                                                CLEAR(DailyShiftsTBT);
                                                DailyShiftsTBT.SETRANGE(DailyShiftsTBT."Shift Code", ShiftCode);
                                                IF DailyShiftsTBT.FINDFIRST() THEN BEGIN
                                                    //EmpAbsTbt."Shift Code" := ShiftCode; //20180925:A2+-
                                                    IF EmpAbsTbt."Shift Code" <> 'WEEKEND' THEN BEGIN //20180926:A2+-
                                                        EmpAbsTbt.VALIDATE("Shift Code", ShiftCode);
                                                        EmpAbsTbt."Break" := DailyShiftsTBT."Break";
                                                        EmpAbsTbt.Tolerance := DailyShiftsTBT.Tolerance;
                                                        //A2+
                                                        //EmpAbsTbt.VALIDATE("Cause of Absence Code",DailyShiftsTBT."Cause Code");
                                                        EmpAbsTbt."Cause of Absence Code" := DailyShiftsTBT."Cause Code";
                                                        EmpAbsTbt.Type := DailyShiftsTBT.Type;
                                                        EmpAbsTbt.Quantity := 1;
                                                        //A2-

                                                        //EmpAbsTbt.VALIDATE(Type,DailyShiftsTBT.Type); //A2+-
                                                    END;
                                                END;
                                                //
                                                IF (DailyShiftsTBT.Type = DailyShiftsTBT.Type::"Paid Day") OR (DailyShiftsTBT.Type = DailyShiftsTBT.Type::"Paid Vacation")
                                                   OR (DailyShiftsTBT.Type = DailyShiftsTBT.Type::"Sick Day") OR (DailyShiftsTBT.Type = DailyShiftsTBT.Type::AL)
                                                   THEN BEGIN
                                                    EmpAbsTbt."Required Hrs" := RequiredHours;
                                                    //A2+ 05.10.2018
                                                    IF LeaveHours > 0 THEN BEGIN
                                                        //   EmpAbsTbt.Type := EmpAbsTbt.Type::"Working Holiday";
                                                        EmpAbsTbt."Attend Hrs." := LeaveHours;
                                                        EmpAbsTbt.Quantity := LeaveHours;

                                                    END;
                                                    //A2- 05.10.2018
                                                END
                                                ELSE
                                                    IF (DailyShiftsTBT.Type = DailyShiftsTBT.Type::Holiday) THEN
                                                        EmpAbsTbt."Required Hrs" := 0;

                                                IF (EmpAbsTbt."Attend Hrs." <= 0) AND ((DailyShiftsTBT.Type = DailyShiftsTBT.Type::"Working Holiday")) THEN // The working hours are considered as overtime
                                                  BEGIN
                                                    //Modified - If leaveHours = 0 then set attended hours as Required Hours - 23.03.2017 : AIM +
                                                    //EmpAbsTbt."Attend Hrs." := LeaveHours;
                                                    IF LeaveHours > 0 THEN
                                                        EmpAbsTbt."Attend Hrs." := LeaveHours
                                                    ELSE BEGIN

                                                        IF ROUND(((DailyShiftsTBT."To Time" - DailyShiftsTBT."From Time") / 60000) / 60, 0.01) > 0 THEN
                                                            EmpAbsTbt."Attend Hrs." := ROUND(((DailyShiftsTBT."To Time" - DailyShiftsTBT."From Time") / 60000) / 60, 0.01)
                                                        ELSE
                                                            EmpAbsTbt."Attend Hrs." := GetEmployeeDailyHours(EmpAbsTbt."Employee No.", '');
                                                    END;
                                                    //Modified - If leaveHours = 0 then set attended hours as Required Hours - 23.03.2017 : AIM -
                                                    EmpAbsTbt."Early Arrive" := 0;
                                                    EmpAbsTbt."Early Leave" := 0;
                                                    EmpAbsTbt."Late Arrive" := 0;
                                                    EmpAbsTbt."Late Leave" := 0;
                                                END;

                                                IF (STRPOS(UPPERCASE(ShiftCode), UPPERCASE('AL')) > 0) OR (STRPOS(UPPERCASE(ShiftCode), UPPERCASE('CL')) > 0) OR (STRPOS(UPPERCASE(ShiftCode), UPPERCASE('SKD')) > 0)
                                                     //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM +
                                                     OR (STRPOS(UPPERCASE(ShiftCode), UPPERCASE(GetCustomizedLeaveCode())) > 0)
                                                   //Added for a Custom Leave Code defined by customer - 24.07.2018: AIM -
                                                   THEN BEGIN
                                                    IF EmpAbsTbt."Attend Hrs." > EmpAbsTbt."Required Hrs" THEN
                                                        EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Required Hrs";
                                                END;

                                                IF (LeaveReqTbt."From Time" <> LeaveReqTbt."To Time") THEN BEGIN
                                                    EmpAbsTbt.Remarks := 'Imported>> ' + FORMAT(LeaveReqTbt."From Date") + ' ' + FORMAT(LeaveReqTbt."From Time") + ' TILL ' + FORMAT(LeaveReqTbt."To Date") + ' ' + FORMAT(LeaveReqTbt."To Time"
)
                                                END
                                                ELSE BEGIN
                                                    EmpAbsTbt.Remarks := 'Imported';
                                                END;



                                                EmpAbsTbt.MODIFY;
                                                LeaveReqTbt.Status := LeaveReqTbt.Status::Generated;
                                            END;
                                        END;
                                    END; //6-
                                    LeaveDate := CALCDATE('+1D', LeaveDate);
                                END; //5-
                                     // 31.05.2017 : A2+
                            END
                            ELSE BEGIN
                                DailyShiftsTBT.RESET();
                                CLEAR(DailyShiftsTBT);
                                DailyShiftsTBT.SETRANGE(DailyShiftsTBT."Cause Code", LeaveReqTbt."Leave Type");
                                IF DailyShiftsTBT.FINDFIRST() THEN BEGIN
                                    //EmpAbsTbt."Shift Code" := LeaveReqTbt."Leave Type";
                                    EmpAbsTbt."Break" := DailyShiftsTBT."Break";
                                    EmpAbsTbt.Tolerance := DailyShiftsTBT.Tolerance;
                                    EmpAbsTbt.VALIDATE("Cause of Absence Code", DailyShiftsTBT."Cause Code");
                                    EmpAbsTbt.VALIDATE(Type, DailyShiftsTBT.Type);
                                END;

                                EmpAbsTbt.RESET;
                                CLEAR(EmpAbsTbt);
                                IF CauseOfAbsence."Request Category Type" = CauseOfAbsence."Request Category Type"::"Overtime Request" THEN BEGIN
                                    EmpAbsTbt.SETRANGE("Employee No.", LeaveReqTbt."Employee No.");
                                    EmpAbsTbt.SETRANGE("From Date", LeaveReqTbt."From Date");
                                    IF EmpAbsTbt.FINDFIRST THEN BEGIN
                                        EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Required Hrs" + LeaveReqTbt."Hours Value";
                                        EmpAbsTbt.Remarks := 'Web: ' + COPYSTR(LeaveReqTbt.Remark, 1, 95);
                                        EmpAbsTbt."Shift Code" := LeaveReqTbt."Leave Type";
                                        LeaveReqTbt.Status := LeaveReqTbt.Status::Generated;
                                    END;
                                END
                                ELSE
                                    IF CauseOfAbsence."Request Category Type" = CauseOfAbsence."Request Category Type"::"Late Arrive Request" THEN BEGIN
                                        EmpAbsTbt.SETRANGE("Employee No.", LeaveReqTbt."Employee No.");
                                        EmpAbsTbt.SETRANGE("From Date", LeaveReqTbt."From Date");
                                        IF EmpAbsTbt.FINDFIRST THEN BEGIN
                                            EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Actual Attend Hrs" + EmpAbsTbt."Actual Late Arrive" / 60;
                                            EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Attend Hrs." - LeaveReqTbt."Hours Value" / 60;
                                            EmpAbsTbt."Late Arrive" := LeaveReqTbt."Hours Value" / 60;
                                            EmpAbsTbt.Remarks := 'Web: ' + COPYSTR(LeaveReqTbt.Remark, 1, 95);
                                            EmpAbsTbt."Shift Code" := LeaveReqTbt."Leave Type";
                                            LeaveReqTbt.Status := LeaveReqTbt.Status::Generated;
                                        END;
                                    END
                                    ELSE
                                        IF CauseOfAbsence."Request Category Type" = CauseOfAbsence."Request Category Type"::"Early Arrive Request" THEN BEGIN
                                            EmpAbsTbt.SETRANGE("Employee No.", LeaveReqTbt."Employee No.");
                                            EmpAbsTbt.SETRANGE("From Date", LeaveReqTbt."From Date");
                                            IF EmpAbsTbt.FINDFIRST THEN BEGIN
                                                EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Actual Attend Hrs" + EmpAbsTbt."Actual Early Arrive" / 60;
                                                EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Attend Hrs." - LeaveReqTbt."Hours Value" / 60;
                                                EmpAbsTbt."Early Arrive" := LeaveReqTbt."Hours Value" / 60;
                                                EmpAbsTbt.Remarks := 'Web: ' + COPYSTR(LeaveReqTbt.Remark, 1, 95);
                                                EmpAbsTbt."Shift Code" := LeaveReqTbt."Leave Type";
                                                LeaveReqTbt.Status := LeaveReqTbt.Status::Generated;
                                            END;
                                        END
                                        ELSE
                                            IF CauseOfAbsence."Request Category Type" = CauseOfAbsence."Request Category Type"::"Early Leave Request" THEN BEGIN
                                                EmpAbsTbt.SETRANGE("Employee No.", LeaveReqTbt."Employee No.");
                                                EmpAbsTbt.SETRANGE("From Date", LeaveReqTbt."From Date");
                                                IF EmpAbsTbt.FINDFIRST THEN BEGIN
                                                    EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Actual Attend Hrs" + EmpAbsTbt."Actual Early Leave" / 60;
                                                    EmpAbsTbt."Attend Hrs." := EmpAbsTbt."Attend Hrs." - LeaveReqTbt."Hours Value" / 60;
                                                    EmpAbsTbt."Early Leave" := LeaveReqTbt."Hours Value" / 60;
                                                    EmpAbsTbt.Remarks := 'Web: ' + COPYSTR(LeaveReqTbt.Remark, 1, 95);
                                                    EmpAbsTbt."Shift Code" := LeaveReqTbt."Leave Type";
                                                    LeaveReqTbt.Status := LeaveReqTbt.Status::Generated;
                                                END;
                                            END;
                                EmpAbsTbt.MODIFY(TRUE);
                            END;
                            // 31.05.2017 : A2-
                        END;//4-
                    END; //3-
                    LeaveDate := 0D;
                    // 31.05.2017 : A2+
                END;
                // 31.05.2017 : A2-
            END; //2-
                 //LeaveReqTbt.Status := LeaveReqTbt.Status::Generated;
            LeaveReqTbt.MODIFY;
            UNTIL LeaveReqTbt.NEXT = 0; //1-

    End;

    procedure GetCustomizedLeaveCode() LeaveCode: Text;
    var
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.GET;
        LeaveCode := HRSetup."Customized Leave Code";
    end;

    procedure IsScheduleUseEmployeeCardHourlyRate(EmpNo: Code[20]) UseRate: Boolean;
    var
        EmployTypeTBT: Record "Employment Type";
        EmpTBT: Record Employee;
    begin
        UseRate := false;
        if EmpNo <> '' then begin
            EmpTBT.SETRANGE(EmpTBT."No.", EmpNo);
            if EmpTBT.FINDFIRST then begin
                if EmpTBT."Employment Type Code" <> '' then begin
                    EmployTypeTBT.SETRANGE(EmployTypeTBT.Code, EmpTBT."Employment Type Code");
                    if EmployTypeTBT.FINDFIRST then begin
                        if EmployTypeTBT."Use Hourly Rate" = true then
                            UseRate := true;
                    end;
                end;
            end;
        end;

        exit(UseRate);
    end;

    local procedure IsPenalizeLateArrive(EmpNo: Code[20]) IsPenalize: Boolean;
    var
        EmployTypeTBT: Record "Employment Type";
        EmpTbt: Record Employee;
    begin
        if EmpNo = '' then
            exit(false);

        IsPenalize := false;
        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then begin
            if EmpTbt."Employment Type Code" <> '' then begin
                EmployTypeTBT.SETRANGE(EmployTypeTBT.Code, EmpTbt."Employment Type Code");
                if EmployTypeTBT.FINDFIRST then begin
                    IsPenalize := EmployTypeTBT."Penalize Late Arrive";
                end;
            end;
        end;

        exit(IsPenalize);
    end;

    procedure CanUserAccessEmployeeCard(PayUserID: Code[50]; EmpNo: Code[20]) IsAllow: Boolean;
    var
        EmpTBT: Record Employee;
        HRPayUserTbt: Record "HR Payroll User";
    begin
        IsAllow := true;

        if PayUserID = '' then
            PayUserID := USERID;

        if EmpNo <> '' then begin
            EmpTBT.SETRANGE(EmpTBT."No.", EmpNo);
            if EmpTBT.FINDFIRST then
                if EmpTBT."Payroll Group Code" <> '' then begin
                    HRPayUserTbt.SETRANGE(HRPayUserTbt."Payroll Group Code", EmpTBT."Payroll Group Code");
                    HRPayUserTbt.SETRANGE(HRPayUserTbt."User Id", PayUserID);
                    if HRPayUserTbt.FINDFIRST then
                        IsAllow := true
                    else
                        IsAllow := false;
                end;
        end;
        exit(IsAllow);
    end;

    procedure CanUserAccessEmployeeSalary(PayUserID: Code[50]; EmpNo: Code[20]) IsAllow: Boolean;
    var
        EmpTBT: Record Employee;
        HRPayUserTbt: Record "HR Payroll User";
        UserSetupTbt: Record "User Setup";
    begin
        // 07.07.2017 : A2+
        if PayUserID = '' then
            PayUserID := USERID;

        if HideSalaryFields() then
            exit(false)
        else
            IsAllow := true;

        if EmpNo <> '' then begin
            EmpTBT.SETRANGE(EmpTBT."No.", EmpNo);
            if EmpTBT.FINDFIRST then
                if EmpTBT."Payroll Group Code" <> '' then begin
                    HRPayUserTbt.SETRANGE(HRPayUserTbt."Payroll Group Code", EmpTBT."Payroll Group Code");
                    HRPayUserTbt.SETRANGE(HRPayUserTbt."User Id", PayUserID);
                    if HRPayUserTbt.FINDFIRST then
                        IsAllow := not HRPayUserTbt."Hide Salary"
                    else
                        IsAllow := false;
                end;
        end;
        exit(IsAllow);
        // 07.07.2017 : A2-
    end;

    procedure GetUserPayDetailDefPayrollGroup(PayUserID: Code[50]) DefPayGrp: Code[20];
    var
        HRPayUserTBT: Record "HR Payroll User";
        L_HRPermission: Record "HR Permissions";
    begin
        // 25.05.2017 : A2+
        L_HRPermission.SETRANGE("User ID", USERID);
        IF NOT L_HRPermission.FINDFIRST THEN
            EXIT('');
        // 25.05.2017 : A2-

        if PayUserID = '' then
            PayUserID := USERID;

        DefPayGrp := '';

        HRPayUserTBT.SETRANGE(HRPayUserTBT."User Id", USERID);
        HRPayUserTBT.SETRANGE(HRPayUserTBT."Hide Salary", false);
        if HRPayUserTBT.FINDFIRST() then
            DefPayGrp := HRPayUserTBT."Payroll Group Code";

        exit(DefPayGrp);
    end;

    procedure CanUserAccessSalaryofPayrollGroup(PayUserID: Code[50]; PayGroup: Code[20]) CanAccess: Boolean;
    var
        HRPayUserTBT: Record "HR Payroll User";
    begin

        if HideSalaryFields = false then
            exit(true);

        CanAccess := false;

        if PayUserID = '' then
            PayUserID := USERID;

        HRPayUserTBT.SETRANGE(HRPayUserTBT."User Id", USERID);
        HRPayUserTBT.SETRANGE(HRPayUserTBT."Payroll Group Code", PayGroup);
        if HRPayUserTBT.FINDFIRST() then begin
            if HRPayUserTBT."Hide Salary" = true then
                CanAccess := false
            else
                CanAccess := true;
        end
        else begin
            CanAccess := false
        end;

        exit(CanAccess);
    end;

    procedure AutoGenerateEmpAbsenceEntitlementRecordAdvanced(EmpNo: Code[20]; AbsEntitleCode: Code[10]; EntitleYear: Integer; EntitleType: Option YearlyBasis,EmploymentBasis; ClonePrevDateInterval: Boolean);
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        AbsEntitleBandsTBT: Record "Absence Entitlement";
        EmpTBT: Record Employee;
        AllowGenerate: Boolean;
        DefEntitleValue: Decimal;
        PeriodType: DateFormula;
        FUnitD: Decimal;
        TUnitD: Decimal;
        DaysPerMonth: Decimal;
        FilterNbOfDays: Decimal;
        FDate: Date;
        TDate: Date;
        HRSetupTbt: Record "Human Resources Setup";
        EmptyDateFormula: DateFormula;
        AbsEntitleVal: Decimal;
        AbsEntitleAllowedToTransfer: Decimal;
        YearsofService: Decimal;
        EntitleBandExist: Boolean;
        DayDiff: Integer;
        L_EmployDate: Date;
        L_DefFDate: Date;
        L_DefTDate: Date;
        Y: Integer;
        M: Integer;
        D: Integer;
    begin
        HRSetupTbt.GET();

        if EmpNo = '' then
            exit;

        if AbsEntitleCode = '' then
            exit;

        if ClonePrevDateInterval = true then begin
            EmpAbsEntitleTBT.RESET();
            EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
            EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
            if EmpAbsEntitleTBT.FINDFIRST = true then begin
                repeat // Get the last entitlement year which is generated for the employee
                    if FDate < EmpAbsEntitleTBT."From Date" then
                        FDate := EmpAbsEntitleTBT."From Date";
                    if TDate < EmpAbsEntitleTBT."Till Date" then
                        TDate := EmpAbsEntitleTBT."Till Date";
                until EmpAbsEntitleTBT.NEXT = 0;
                if TDate <> 0D then // if there are entitlement generated for the previous years,then the new entitlement record will be for the interval [To date of the Last record + 1D] .. [[To date of the Last record + 1D] + 1Y]
                  begin
                    FDate := CALCDATE('1D', TDate);
                    TDate := CALCDATE('1Y', FDate);
                    TDate := CALCDATE('-1D', TDate);
                    DayDiff := TDate - FDate;
                    if EntitleYear > 0 then begin
                        //Modified in order to handle Day 29 in FEB - 26.09.2017 : AIM +
                        Y := EntitleYear;
                        M := DATE2DMY(FDate, 2);
                        case M of
                            1, 3, 5, 7, 8, 10, 12:
                                D := DATE2DMY(FDate, 1);
                            4, 6, 9, 11:
                                D := DATE2DMY(FDate, 1);
                            2:
                                begin
                                    D := DATE2DMY(FDate, 1);
                                    if D = 29 then begin
                                        if (Y mod 4 = 0) then
                                            D := 29
                                        else
                                            D := 28;
                                    end;
                                end;
                        end;
                        FDate := DMY2DATE(D, M, Y);
                        //Modified in order to handle Day 29 in FEB - 26.09.2017 : AIM -
                        TDate := FDate + DayDiff;
                    end;
                end;
            end;
        end;

        if (FDate = 0D) or (TDate = 0D) then // if no entitlement record exists then
          begin
            if EntitleType = EntitleType::YearlyBasis then // Yearly basis means that the entitlement is given from 1/1/YYYY till 31/12/YYYY
                begin
                FDate := DMY2DATE(1, 1, EntitleYear);
                TDate := DMY2DATE(31, 12, EntitleYear);
            end
            else
                if EntitleType = EntitleType::EmploymentBasis then // Employment basis means that the first entitlement year will be [Employment Date] .. [Employment Date + 1Y]
               begin
                    CLEAR(EmpTBT);
                    EmpTBT.RESET;
                    EmpTBT.SETRANGE("No.", EmpNo);
                    if EmpTBT.FINDFIRST then begin
                        if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then
                          // If it is for Annual Leave and "Annual Leave Starting Date" is mentioned in the employee card then 'From Date of Entitlement' = 'Annual Leave Starting Date'
                          begin
                            FDate := EmpTBT."AL Starting Date";
                        end
                        else
                            if (EmpTBT."Employment Date" <> 0D) then begin
                                FDate := EmpTBT."Employment Date";
                                if HRSetupTbt."Trial Period" <> EmptyDateFormula then
                                    FDate := CALCDATE(HRSetupTbt."Trial Period", FDate);
                            end
                            else begin
                                exit;
                            end;
                        TDate := CALCDATE('1Y', FDate) - 1;
                    end;
                    DayDiff := TDate - FDate;
                    if DayDiff > 364 then
                        DayDiff := 364;
                    if (EntitleYear > 0) and (FDate <> 0D) and (TDate <> 0D) then begin
                        //Modified in order to handle Day 29 in FEB - 26.09.2017 : AIM +
                        Y := EntitleYear;
                        M := DATE2DMY(FDate, 2);
                        case M of
                            1, 3, 5, 7, 8, 10, 12:
                                D := DATE2DMY(FDate, 1);
                            4, 6, 9, 11:
                                D := DATE2DMY(FDate, 1);
                            2:
                                begin
                                    D := DATE2DMY(FDate, 1);
                                    if D = 29 then begin
                                        if (Y mod 4 = 0) then
                                            D := 29
                                        else
                                            D := 28;
                                    end;
                                end;
                        end;
                        FDate := DMY2DATE(D, M, Y);
                        //Modified in order to handle Day 29 in FEB - 26.09.2017 : AIM -
                        TDate := FDate + DayDiff;
                    end;
                end;
        end
        else begin

        end;


        if (FDate = 0D) or (TDate = 0D) then
            exit;

        //Added in order to save the Default date Interval - 12.09.2017 : AIM +
        L_DefFDate := FDate;
        L_DefTDate := TDate;
        //Added in order to save the Default date Interval - 12.09.2017 : AIM -


        CLEAR(EmpTBT);
        EmpTBT.RESET;
        EmpTBT.SETRANGE("No.", EmpNo);
        if EmpTBT.FINDFIRST then begin
            if (EmpTBT.Status <> EmpTBT.Status::Active) or (EmpTBT."Employment Date" = 0D) or (EmpTBT."End of Service Date" = 0D) then
                exit;
        end
        else begin
            exit;
        end;

        // 02.06.2017 : A2+
        if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then
            L_EmployDate := EmpTBT."AL Starting Date"
        else
            L_EmployDate := EmpTBT."Employment Date";
        // 02.06.2017 : A2-

        if (EmpTBT."Employment Date" = 0D) then
            exit;

        //Modified in order to consider termination date that falls within the interval - 12.09.2017 : AIM +
        if EmpTBT."Termination Date" <> 0D then begin
            if EmpTBT."Termination Date" <= FDate then
                exit
            else
                if EmpTBT."Termination Date" < TDate then begin
                    TDate := EmpTBT."Termination Date";
                end;
        end
        else
            if EmpTBT."Inactive Date" <> 0D then begin
                if EmpTBT."Inactive Date" <= FDate then
                    exit
                else
                    if EmpTBT."Inactive Date" < TDate then begin
                        TDate := EmpTBT."Inactive Date";
                    end;
            end;
        //Modified in order to consider termination date that falls within the interval - 12.09.2017 : AIM -

        DaysPerMonth := 365 / 12;
        if DATE2DMY(L_EmployDate, 3) = DATE2DMY(FDate, 3) then
            YearsofService := ABS((FDate - L_EmployDate) / 365)
        else
            // 26.09.2017 : AIM+
            if (DATE2DMY(EmpTBT."Employment Date", 1) = 29) and (DATE2DMY(EmpTBT."Employment Date", 2) = 2) then
                YearsofService := ABS((FDate - DMY2DATE(28, DATE2DMY(EmpTBT."Employment Date", 2), DATE2DMY(EmpTBT."Employment Date", 3))) / 365)
            else
                YearsofService := (FDate - EmpTBT."Employment Date") / 365;

        YearsofService := YearsofService + (1 / 365);
        // 26.09.2017 : AIM-
        //Modified

        if YearsofService <= 0 then
            YearsofService := 0;

        if (EntitleType = EntitleType::YearlyBasis) then begin
            if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then begin
                if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."AL Starting Date", 3) then
                    FilterNbOfDays := TDate - EmpTBT."AL Starting Date"
                else
                    FilterNbOfDays := TDate - FDate;
            end
            else
                if (EmpTBT."Employment Date" <> 0D) then begin
                    if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."Employment Date", 3) then
                        FilterNbOfDays := TDate - EmpTBT."Employment Date"
                    else
                        FilterNbOfDays := TDate - FDate;

                    if HRSetupTbt."Trial Period" <> EmptyDateFormula then begin
                        if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."Employment Date", 3) then
                            FilterNbOfDays := TDate - CALCDATE(HRSetupTbt."Trial Period", EmpTBT."Employment Date")
                        else
                            FilterNbOfDays := TDate - FDate;
                    end;
                end
                else begin
                    FilterNbOfDays := TDate - FDate;
                end;
        end
        else
            FilterNbOfDays := TDate - FDate;


        FilterNbOfDays := FilterNbOfDays + 1;
        if FilterNbOfDays > 365 then
            FilterNbOfDays := 365;

        if DATE2DMY(TDate, 3) < DATE2DMY(EmpTBT."Employment Date", 3) then
            exit;

        CLEAR(EmpAbsEntitleTBT);
        EmpAbsEntitleTBT.RESET();
        EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
        EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
        if EmpAbsEntitleTBT.FINDFIRST = true then // Check if the date interval of the new entitlement falls within any of the previously created entitlements
            repeat
                if (EmpAbsEntitleTBT."From Date" >= FDate) and (EmpAbsEntitleTBT."From Date" <= TDate) then
                    exit;

                if (EmpAbsEntitleTBT."Till Date" >= FDate) and (EmpAbsEntitleTBT."Till Date" <= TDate) then
                    exit;

            until EmpAbsEntitleTBT.NEXT = 0;


        DefEntitleValue := 0;
        AbsEntitleVal := 0;
        AbsEntitleAllowedToTransfer := 0;
        EntitleBandExist := false;

        AbsEntitleBandsTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
        AbsEntitleBandsTBT.SETRANGE("Employee Category", GetEntitlementEmpCategoryFilter(AbsEntitleCode, EmpNo, true));

        //Note: When assigning bands for AL or SKD kindly take into consideration the following:
        //      1. The entitlement assigned is for the period (From Unit - To Unit)
        //      2. It means that if the value falls within the interval,then it take the related entitlement
        //      3. The below two examples give the same result. They mean that if the value falls within the interval of 5 years then give 15 days
        //          Period     |   From Unit    |  To Unit  |  Entitlement
        //            Y        |      0         |     5     |   15
        //            M        |      0         |     60    |   15
        if AbsEntitleBandsTBT.FINDFIRST = true then
            repeat
                FUnitD := 0;
                TUnitD := 0;

                DefEntitleValue := AbsEntitleBandsTBT.Entitlement;

                EVALUATE(PeriodType, '1Y');
                if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a year
begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * 365;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * 365;
                    DefEntitleValue := ROUND(FilterNbOfDays / 365, 0.01); // get nb of years
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                EVALUATE(PeriodType, '1M');
                if PeriodType = AbsEntitleBandsTBT.Period then// the entitlement assigned is for a month
                  begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * DaysPerMonth;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * DaysPerMonth;
                    DefEntitleValue := ROUND(FilterNbOfDays / DaysPerMonth, 1, '='); // get nb of months
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                EVALUATE(PeriodType, '1W');
                if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a week
                begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * 7;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * 7;
                    DefEntitleValue := ROUND(FilterNbOfDays / 7, 1, '='); // get nb of weeks
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                if (FUnitD = 0) and (TUnitD = 0) then // the entitlement assigned is for a day
                  begin
                    FUnitD := AbsEntitleBandsTBT."From Unit";
                    TUnitD := AbsEntitleBandsTBT."To Unit";
                    DefEntitleValue := ROUND(FilterNbOfDays * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;


                if (YearsofService * 365 >= FUnitD) and (YearsofService * 365 <= TUnitD) and (EntitleBandExist = false) then begin
                    if AbsEntitleBandsTBT.Type = AbsEntitleBandsTBT.Type::"Non-Cumulative" then begin
                        AbsEntitleVal := DefEntitleValue;
                        AbsEntitleAllowedToTransfer := 0;
                    end
                    else begin
                        AbsEntitleVal := DefEntitleValue;
                        AbsEntitleAllowedToTransfer := AbsEntitleBandsTBT."Allowed Days To Transfer";
                        if AbsEntitleBandsTBT."Balance Cummulative Years" > 0 then begin
                            if IsEntitlementCummulativeYear(FDate, EmpTBT."Employment Date", AbsEntitleBandsTBT."Balance Cummulative Years") = false then
                                AbsEntitleAllowedToTransfer := 0;
                        end;
                    end;
                    EntitleBandExist := true;
                    if AbsEntitleBandsTBT."First Year Entitlement" > 0 then begin
                        // 06.06.2017 : A2+
                        if (AbsEntitleBandsTBT."From Unit" >= 0) then
                            // 06.06.2017 : A2-
                            begin
                            if (ROUND((FDate - EmpTBT."Employment Date") / 365, 0.01) >= 1) and (ROUND((FDate - EmpTBT."Employment Date") / 365, 0.01) < 2) then // if the employee has been employed in the company since 1 year then
                                AbsEntitleVal := AbsEntitleVal + AbsEntitleBandsTBT."First Year Entitlement";
                        end;
                    end;
                end;

            until AbsEntitleBandsTBT.NEXT = 0;
        //Modified in order to use the Default date Interval for Yearly Basis- 12.09.2017 : AIM +
        if EntitleType = EntitleType::YearlyBasis then
            InsertEmpAbsenceEntitlement(EmpNo, AbsEntitleCode, L_DefFDate, L_DefTDate, AbsEntitleVal, AbsEntitleAllowedToTransfer)
        else
            InsertEmpAbsenceEntitlement(EmpNo, AbsEntitleCode, FDate, TDate, AbsEntitleVal, AbsEntitleAllowedToTransfer);
        //Modified in order to use the Default date Interval for Yearly Basis- 12.09.2017 : AIM -

    end;

    procedure GetEmployeeShortcutDimensionValue(EmployeeNo: Code[20]; DimNo: Integer) DimVal: Code[20];
    var
        GenLedgerTbt: Record "General Ledger Setup";
        EmpCardDimensionTbt: Record "Default Dimension";
        DimensionN: Code[20];
    begin
        GenLedgerTbt.GET();
        case DimNo of
            1:
                DimensionN := GenLedgerTbt."Global Dimension 1 Code";
            2:
                DimensionN := GenLedgerTbt."Global Dimension 2 Code";
            3:
                DimensionN := GenLedgerTbt."Shortcut Dimension 3 Code";
            4:
                DimensionN := GenLedgerTbt."Shortcut Dimension 4 Code";
            5:
                DimensionN := GenLedgerTbt."Shortcut Dimension 5 Code";
            6:
                DimensionN := GenLedgerTbt."Shortcut Dimension 6 Code";
            7:
                DimensionN := GenLedgerTbt."Shortcut Dimension 7 Code";
            8:
                DimensionN := GenLedgerTbt."Shortcut Dimension 8 Code";
        //Added in order to consider dimensions 7 & 8 - 22.03.2017 : AIM -
        end;
        if DimensionN = '' then
            exit('');

        EmpCardDimensionTbt.SETRANGE(EmpCardDimensionTbt."Dimension Code", DimensionN);
        EmpCardDimensionTbt.SETRANGE(EmpCardDimensionTbt."No.", EmployeeNo);
        if EmpCardDimensionTbt.FINDFIRST = false then
            exit('');

        DimVal := EmpCardDimensionTbt."Dimension Value Code";

        exit(DimVal);
    end;

    procedure CauseofAttendanceHasEntitlementRule(AbsCode: Code[10]) RuleExist: Boolean;
    var
        AbsEntitleTbt: Record "Absence Entitlement";
    begin
        AbsEntitleTbt.SETRANGE(AbsEntitleTbt."Cause of Absence Code", AbsCode);
        if AbsEntitleTbt.FINDFIRST = true then
            exit(true)
        else
            exit(false);
    end;

    procedure EmployeeHasCauseofAbsenceBalance(EmpNo: Code[20]; AbsCode: Code[10]; Val: Decimal; TillDate: Date) HasBal: Boolean;
    var
        CurBal: Decimal;
    begin
        CurBal := GetEmpAbsenceEntitlementCurrentBalance(EmpNo, AbsCode, TillDate);
        if CurBal > 0 then begin
            if CurBal - Val >= 0 then
                exit(true);
        end
        else
            if CauseofAttendanceHasEntitlementRule(AbsCode) = true then
                exit(false)
            else
                exit(true);

        exit(true);
    end;

    procedure ExchangeLCYAmountToACY(L_AmountInLCY: Decimal) L_AmountInACY: Decimal;
    begin
        PayParam.GET();
        if PayParam."ACY Currency Rate" <= 0 then begin
            L_AmountInACY := 0;
            exit;
        end;

        if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Division then
            L_AmountInACY := L_AmountInLCY / PayParam."ACY Currency Rate"
        else
            if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Multiplication then
                L_AmountInACY := L_AmountInLCY * PayParam."ACY Currency Rate"
            else
                L_AmountInACY := 0;

        exit(L_AmountInACY);
    end;

    procedure GetCurrencyCode(CurrencyCategory: Option LCY,ACY) CurCode: Code[10];
    var
        GenLedgerSetupTBT: Record "General Ledger Setup";
    begin
        GenLedgerSetupTBT.GET;
        if CurrencyCategory = CurrencyCategory::ACY then
            CurCode := GenLedgerSetupTBT."Additional Reporting Currency"
        else
            if CurrencyCategory = CurrencyCategory::LCY then
                CurCode := GenLedgerSetupTBT."LCY Code"
            else
                CurCode := '';
        exit(CurCode);
    end;

    procedure GetEmployeeNoFromName(FirstName: Text; LastName: Text) NewCode: Code[20];
    var
        EmployeeRec: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        TxtToSearch: Text;
        SequentialNb: Integer;
        FirstNameSplitForEmpNo: Text;
        LastNameSplitForEmpNo: Text;
        NbCharFromFirstName: Integer;
        NbCharFromLastName: Integer;
        SeqLoopTxt: Text;
        SeqMax: Integer;
        SeqLoop: Integer;
    begin
        HumanResSetup.GET;

        NbCharFromFirstName := HumanResSetup."Nb Char From Emp First Name";
        NbCharFromLastName := HumanResSetup."Nb Char From Emp Last Name";

        if NbCharFromFirstName <= 0 then
            NbCharFromFirstName := 8;

        if NbCharFromLastName <= 0 then
            NbCharFromLastName := 8;

        FirstNameSplitForEmpNo := COPYSTR(FirstName, 1, NbCharFromFirstName);
        LastNameSplitForEmpNo := COPYSTR(LastName, 1, NbCharFromLastName);

        TxtToSearch := '@' + FirstNameSplitForEmpNo + ' ' + LastNameSplitForEmpNo + '*';

        SeqLoop := 0;
        SeqMax := 0;
        SequentialNb := 0;

        EmployeeRec.SETFILTER("No.", TxtToSearch);
        if EmployeeRec.FINDFIRST then
            repeat
                SeqLoopTxt := COPYSTR(EmployeeRec."No.", STRLEN(FirstNameSplitForEmpNo + ' ' + LastNameSplitForEmpNo) + 1, 100);
                if EVALUATE(SeqLoop, SeqLoopTxt) then begin
                    if SeqLoop > SeqMax then
                        SeqMax := SeqLoop;
                end;

            until EmployeeRec.NEXT = 0;

        SequentialNb := SeqMax + 1;

        NewCode := UPPERCASE(FirstNameSplitForEmpNo) + ' ' + UPPERCASE(LastNameSplitForEmpNo) + ' ' + FORMAT(SequentialNb);
        exit(NewCode);
    end;

    procedure FixPunchScheduledDate(EmpNo: Code[20]; PunchDate: Date; PunchTime: Time) SchedDate: Date;
    var
        EmpAbsTbt: Record "Employee Absence";
    begin

        SchedDate := PunchDate;

        if EmpNo = '' then
            exit(SchedDate);

        if PunchDate = 0D then
            exit(SchedDate);


        IF PunchTime = 0T THEN
            exit(SchedDate);

        EmpAbsTbt.SETRANGE(EmpAbsTbt."Employee No.", EmpNo);
        EmpAbsTbt.SETRANGE(EmpAbsTbt."From Date", PunchDate);
        if EmpAbsTbt.FINDFIRST() then begin
            if ((STRPOS(FORMAT(EmpAbsTbt."From Time"), 'PM') > 0) or (STRPOS(FORMAT(EmpAbsTbt."From Time"), '12:00') > 0)) and (STRPOS(FORMAT(PunchTime), 'AM') > 0) then
                SchedDate := CALCDATE('-1D', PunchDate);
        end;

        exit(SchedDate);
    end;

    procedure InsertDefaultEmployeeAdditionalInfoRecord(EmpNo: Code[20]);
    var
        EmpAddinfo: Record "Employee Additional Info";
    begin
        //Since Employee Table cannot accept any additional column,a new table is created '80233 - Employee Additional Info'
        //All new needed fields will be added to this table. Therefore it is needed to insert a record to this table in order to link it with the employee table
        //Created on 18.11.2016 : AIM +-

        if (EmpNo = '') or (EmpNo = '0') then
            exit;

        if not EmpAddinfo.GET(EmpNo) then begin
            EmpAddinfo.INIT;
            EmpAddinfo."Employee No." := EmpNo;
            EmpAddinfo.INSERT;
        end;
    end;

    procedure FixMissingPunchAsPerAttendancePolicy(AttendancePeriod: Date; EmpNo: Code[20]);
    var
        EmpAbsTbt: Record "Employee Absence";
        HandPunchTbt: Record "Hand Punch";
        EmpTbt: Record Employee;
        EmployTypeTbt: Record "Employment Type";
        PunchCnt: Integer;
        PunchTime: Time;
        PunchType: Text;
    begin
        if AttendancePeriod = 0D then
            exit;


        EmpAbsTbt.SETRANGE(EmpAbsTbt.Period, AttendancePeriod);
        if EmpNo <> '' then
            EmpAbsTbt.SETRANGE(EmpAbsTbt."Employee No.", EmpNo);

        if EmpAbsTbt.FINDFIRST = true then
            repeat
                EmpTbt.SETRANGE(EmpTbt."No.", EmpAbsTbt."Employee No.");
                if EmpTbt.FINDFIRST = true then begin
                    if EmpTbt."Employment Type Code" <> '' then begin
                        EmployTypeTbt.SETRANGE(EmployTypeTbt.Code, EmpTbt."Employment Type Code");
                        if EmployTypeTbt.FINDFIRST = true then begin
                            IF (EmployTypeTbt."Auto fix missing punch" = TRUE) AND (EmployTypeTbt."Punch In Time Ceil" <> 0T) THEN begin
                                if CanModifyAttendancePeriod(EmpAbsTbt."Employee No.", EmpTbt.Period, true, false, false, false) = true then begin
                                    PunchCnt := 0;
                                    HandPunchTbt.SETRANGE(HandPunchTbt."Scheduled Date", EmpAbsTbt."From Date");
                                    HandPunchTbt.SETRANGE(HandPunchTbt."Attendnace No.", EmpAbsTbt."Attendance No.");
                                    if HandPunchTbt.FINDFIRST then
                                        repeat
                                            PunchTime := HandPunchTbt."Real Time";
                                            PunchCnt := PunchCnt + 1;
                                        until HandPunchTbt.NEXT = 0;
                                    if (PunchCnt = 1) then begin
                                        if PunchTime <= EmployTypeTbt."Punch In Time Ceil" then begin
                                            PunchTime := EmpAbsTbt."To Time" - (EmployTypeTbt."Missing Punch Out Penalty Hrs" * 3600000);
                                            PunchType := 'OUT';
                                        end
                                        else begin
                                            PunchTime := EmpAbsTbt."From Time" + (EmployTypeTbt."Missing Punch In Penalty Hrs" * 3600000);
                                            PunchType := 'IN'
                                        end;


                                        HandPunchTbt.INIT;
                                        HandPunchTbt."Attendnace No." := EmpAbsTbt."Attendance No.";
                                        HandPunchTbt.VALIDATE("Date Time", CREATEDATETIME(EmpAbsTbt."From Date", PunchTime));

                                        HandPunchTbt."Employee Name" := EmpTbt."Full Name";
                                        HandPunchTbt."Action Type" := PunchType;
                                        HandPunchTbt."Scheduled Date" := FixPunchScheduledDate(EmpAbsTbt."Employee No.", HandPunchTbt."Real Date", HandPunchTbt."Real Time");
                                        if HandPunchTbt."Scheduled Date" = 0D then
                                            HandPunchTbt."Scheduled Date" := HandPunchTbt."Real Date";

                                        if HandPunchTbt."Action Type" = '' then
                                            HandPunchTbt."Action Type" := 'IN';

                                        HandPunchTbt."Modified By" := COPYSTR(USERID, 1, 49);
                                        HandPunchTbt."Modification Date" := WORKDATE;

                                        HandPunchTbt.INSERT;

                                        EmpAbsTbt.Remarks := 'Missing Punch ' + PunchType;
                                        EmpAbsTbt.MODIFY;
                                        FixEmployeeDailyAttendanceHours(EmpAbsTbt."Employee No.", EmpAbsTbt.Period, EmpAbsTbt."From Date", true, 'ALL');
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            until EmpAbsTbt.NEXT = 0;
    end;

    procedure GetUserRelatedEmployeeNo(L_UserId: Code[50]) EmpNo: Code[20];
    var
        HRPermissionTbt: Record "HR Permissions";
    begin
        if L_UserId = '' then
            exit('');

        HRPermissionTbt.SETRANGE(HRPermissionTbt."User ID", L_UserId);
        if HRPermissionTbt.FINDFIRST then
            EmpNo := HRPermissionTbt."Assigned Employee Code";

        exit(EmpNo);
    end;

    procedure ExchangeACYAmountToLCY(L_AmountInACY: Decimal) L_AmountInLCY: Decimal;
    begin
        PayParam.GET();
        if PayParam."ACY Currency Rate" <= 0 then begin
            L_AmountInLCY := 0;
            exit;
        end;

        if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Division then
            L_AmountInLCY := L_AmountInACY * PayParam."ACY Currency Rate"
        else
            if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Multiplication then
                L_AmountInLCY := L_AmountInACY / PayParam."ACY Currency Rate"
            else
                L_AmountInLCY := 0;

        exit(L_AmountInLCY);
    end;

    procedure IsAttendanceRecordProcessed(EmpNo: Code[20]; TrxDate: Date) IsProcessed: Boolean;
    var
        EmpJournalRec: Record "Employee Journal Line";
    begin
        //a2+ 16.02.2018
        EmpJournalRec.RESET;
        EmpJournalRec.SETRANGE("Employee No.", EmpNo);
        EmpJournalRec.SETRANGE("Transaction Type", 'ABS');
        EmpJournalRec.SETRANGE(Type, 'ABSENCE');
        EmpJournalRec.SETRANGE("Starting Date", TrxDate);
        EmpJournalRec.SETRANGE(EmpJournalRec.Processed, true);
        if EmpJournalRec.FINDSET then
            exit(true)
        else
            exit(false);
        //a2- 16.02.2018

    end;

    procedure IsAttendanceJournalExists(EmpNo: Code[20]; TrxDate: Date) RecExist: Boolean;
    var
        EmpJournalRec: Record "Employee Journal Line";
    begin
        EmpJournalRec.SETCURRENTKEY("Employee No.", "Transaction Type", Type, "Starting Date");
        EmpJournalRec.SETRANGE("Employee No.", EmpNo);
        EmpJournalRec.SETRANGE("Transaction Type", 'ABS');
        EmpJournalRec.SETRANGE(Type, 'ABSENCE');
        EmpJournalRec.SETRANGE("Starting Date", TrxDate);
        if EmpJournalRec.FINDFIRST then
            exit(true)
        else
            exit(false);
    end;

    procedure IsWeeklyPayrollGroup(PayGrp: Code[20]) IsWeekly: Boolean;
    var
        PayStatusTbt: Record "Payroll Status";
    begin
        PayStatusTbt.SETRANGE("Payroll Group Code", PayGrp);
        if PayStatusTbt.FINDFIRST() then begin
            if PayStatusTbt."Pay Frequency" = PayStatusTbt."Pay Frequency"::Weekly then
                exit(true)
            else
                exit(false);
        end;

        exit(false);
    end;

    procedure IsValidPayrollDate(PayGrp: Code[20]; PayDate: Date) IsValidDate: Boolean;
    var
        PayStatusTbt: Record "Payroll Status";
        PayLedgEntryTbt: Record "Payroll Ledger Entry";
    begin
        if (PayGrp = '') or (PayDate = 0D) then
            exit(false);

        PayLedgEntryTbt.SETRANGE(PayLedgEntryTbt."Payroll Group Code", PayGrp);
        PayLedgEntryTbt.SETFILTER(PayLedgEntryTbt."Posting Date", '>=%1', PayDate);
        if PayLedgEntryTbt.FINDFIRST then
            exit(false)
        else
            exit(true);
    end;

    procedure AutoFinalizeEmployeeAttendancePeriod(PayGrp: Code[10]; EmpNo: Code[20]);
    var
        EmpTbt: Record Employee;
        PayStatusTbt: Record "Payroll Status";
    begin
        if PayGrp = '' then
            exit;

        PayStatusTbt.SETRANGE(PayStatusTbt."Payroll Group Code", PayGrp);
        if PayStatusTbt.FINDFIRST = false then
            exit;
        if (PayStatusTbt."Calculated Payroll Date" = 0D) or (PayStatusTbt."Period End Date" = 0D) or (PayStatusTbt."Period Start Date" = 0D) then
            exit;

        EmpTbt.SETRANGE(EmpTbt."Payroll Group Code", PayGrp);
        if EmpNo <> '' then
            EmpTbt.SETRANGE(EmpTbt."No.", EmpNo);

        if EmpTbt.FINDFIRST then
            repeat
                if EmpTbt.Status = EmpTbt.Status::Active then begin
                    EmpTbt.Period := PayStatusTbt."Period End Date" + 1;
                    EmpTbt.MODIFY;
                end;
            until EmpTbt.NEXT = 0;
    end;

    procedure GetEmployeeAge(EmpNo: Code[20]; ReferanceDate: Date) Val: Decimal;
    var
        EmpTbt: Record Employee;
    begin
        Val := 0;
        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then begin
            if EmpTbt."Birth Date" <> 0D then begin
                if ReferanceDate = 0D then
                    Val := ROUND((WORKDATE - EmpTbt."Birth Date") / 365, 0.01)
                else
                    Val := ROUND((ReferanceDate - EmpTbt."Birth Date") / 365, 0.01);
            end;
        end;
        exit(Val);
    end;

    procedure IsValidEmployeePayrollDimension(EmpNo: Code[20]; PayDate: Date; ShowWarningMsg: Boolean) IsValid: Boolean;
    var
        PayEmpDimensionTbt: Record "Employee Dimensions";
        Perc: Decimal;
        PayParamTbt: Record "Payroll Parameter";
        EmpTbt: Record Employee;
    begin
        if (EmpNo = '') or (PayDate = 0D) then begin
            if ShowWarningMsg = true then
                MESSAGE('Invalid Period for employee %1', EmpNo);
            exit(false);
        end;

        PayParamTbt.GET();
        if PayParamTbt."AutoCheck Dimension Allocation" = false then
            exit(true);

        EmpTbt.SETRANGE(EmpTbt."No.", EmpNo);
        if EmpTbt.FINDFIRST = false then
            exit(false);

        if EmpTbt.Status <> EmpTbt.Status::Active then
            exit(true);

        PayEmpDimensionTbt.SETRANGE(PayEmpDimensionTbt."Employee No.", EmpNo);
        PayEmpDimensionTbt.SETRANGE(PayEmpDimensionTbt."Payroll Date", PayDate);
        if PayEmpDimensionTbt.FINDFIRST() = false then begin
            if PayParamTbt."Dimension Allocation Needed" = true then
                if ShowWarningMsg = true then
                    MESSAGE('The employee %1 does not have allocation by dimension for the period %2', EmpNo, FORMAT(PayDate));
            exit(false);
        end
        else begin
            Perc := 0;
            repeat
                Perc := Perc + PayEmpDimensionTbt.Percentage;
            until PayEmpDimensionTbt.NEXT = 0;
            if Perc <> 100 then begin
                if ShowWarningMsg = true then
                    MESSAGE('The allocation of dimension for employee %1 is not properly distributed (%2 Percent Allocated)', EmpNo, FORMAT(Perc));
                exit(false);
            end;
        end;


        exit(true);
    end;

    procedure SaveEmployeeDimensionValue(EmpNo: Code[20]; DimCode: Code[20]; DimValue: Code[20]);
    var
        DefaultDimension: Record "Default Dimension";
    begin
        DimCode := UPPERCASE(DimCode);
        if DimCode = '' then
            exit;

        if EmpNo = '' then
            exit;

        DefaultDimension.SETRANGE("No.", EmpNo);
        DefaultDimension.SETFILTER("Table ID", '=%1', 5200);
        DefaultDimension.SETFILTER("Dimension Code", '=%1', DimCode);
        DefaultDimension.SETFILTER("Table Caption", '=%1', 'Employee');
        if DefaultDimension.FINDFIRST = false then begin
            DefaultDimension.INIT;
            DefaultDimension."No." := EmpNo;
            DefaultDimension."Table ID" := 5200;
            DefaultDimension."Dimension Code" := DimCode;
            DefaultDimension."Dimension Value Code" := DimValue;
            DefaultDimension."Table Caption" := 'Employee';
            DefaultDimension.INSERT;
        end
        else begin
            DefaultDimension."Dimension Value Code" := DimValue;
            DefaultDimension.MODIFY;
        end;
    end;

    procedure GetEmployeeDimensionValue(EmpNo: Code[20]; DimCode: Code[20]) DimValue: Code[20];
    var
        DefaultDimension: Record "Default Dimension";
    begin
        DimCode := UPPERCASE(DimCode);
        if DimCode = '' then
            exit('');

        if EmpNo = '' then
            exit('');

        DefaultDimension.SETRANGE("No.", EmpNo);
        DefaultDimension.SETFILTER("Table ID", '=%1', 5200);
        DefaultDimension.SETFILTER("Dimension Code", '=%1', DimCode);
        DefaultDimension.SETFILTER("Table Caption", '=%1', 'Employee');
        if DefaultDimension.FINDFIRST = false then begin
            exit('');
        end
        else begin
            exit(DefaultDimension."Dimension Value Code");
        end;
    end;

    procedure GetNewAttendanceNo() AttendNo: Integer;
    var
        EmpTbt: Record Employee;
    begin
        AttendNo := 0;

        EmpTbt.SETCURRENTKEY("Attendance No.");
        EmpTbt.SETFILTER("Attendance No.", '>%1', 0);
        if EmpTbt.FINDLAST then
            AttendNo := EmpTbt."Attendance No.";

        AttendNo := AttendNo + 1;
        exit(AttendNo);
    end;

    local procedure IsEntitlementCummulativeYear(EntitlementDate: Date; ReferenceDate: Date; CummulativeYears: Decimal) IsCummulative: Boolean;
    var
        V: Decimal;
    begin
        if (EntitlementDate = 0D) or (ReferenceDate = 0D) or (CummulativeYears <= 0) then
            exit(false);

        if CALCDATE('-1D', EntitlementDate) - ReferenceDate >= 364 then
            V := (ROUND((CALCDATE('-1D', EntitlementDate) - ReferenceDate) / 365, 1, '<') mod CummulativeYears)
        else
            V := 1;

        if V = 0 then
            IsCummulative := false
        else
            IsCummulative := true;

        exit(IsCummulative);
    end;

    procedure InsertEmployeeCodeToDimensionsTable(EmpNo: Code[20]);
    var
        EmpTBT: Record Employee;
        DimensionsTbt: Record Dimension;
        DimValuesTbt: Record "Dimension Value";
        EmployeeDimensionCode: Text;
        EmpDimCode: Code[20];
    begin
        if EmpNo = '' then
            exit;

        EmpTBT.SETRANGE(EmpTBT."No.", EmpNo);
        if EmpTBT.FINDFIRST = false then
            exit;

        if (EmpTBT."Related to" = '') or (EmpTBT."No." = EmpTBT."Related to") then
            EmpDimCode := EmpNo
        else
            EmpDimCode := EmpTBT."Related to";

        EmployeeDimensionCode := 'EMPLOYEE';

        DimensionsTbt.SETRANGE(DimensionsTbt.Code, EmployeeDimensionCode);
        if DimensionsTbt.FINDFIRST = false then begin
            DimensionsTbt.INIT;
            DimensionsTbt.VALIDATE(Code, EmployeeDimensionCode);
            DimensionsTbt.INSERT;
        end;

        DimValuesTbt.SETRANGE(DimValuesTbt."Dimension Code", EmployeeDimensionCode);
        DimValuesTbt.SETRANGE(DimValuesTbt.Code, EmpDimCode);
        if DimValuesTbt.FINDFIRST = false then begin
            DimValuesTbt.INIT;
            DimValuesTbt."Dimension Code" := EmployeeDimensionCode;
            DimValuesTbt.VALIDATE(Code, EmpDimCode);
            DimValuesTbt."Global Dimension No." := GetShortcutDimensionNoFromName(EmployeeDimensionCode);
            if EmpTBT."Full Name" <> '' then
                DimValuesTbt.Name := COPYSTR(EmpTBT."Full Name", 1, 50)
            else
                DimValuesTbt.Name := EmpTBT."First Name";

            DimValuesTbt.INSERT;
        end
        else begin
            if EmpTBT."Full Name" <> '' then
                DimValuesTbt.Name := COPYSTR(EmpTBT."Full Name", 1, 50)
            else
                DimValuesTbt.Name := EmpTBT."First Name";
            DimValuesTbt.MODIFY;
        end;
    end;

    procedure GetShortcutDimensionNoFromName(DimName: Text) DimNo: Integer;
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.GET();


        if UPPERCASE(GLSetup."Global Dimension 1 Code") = UPPERCASE(DimName) then
            exit(1)
        else
            if UPPERCASE(GLSetup."Global Dimension 2 Code") = UPPERCASE(DimName) then
                exit(2)
            else
                if UPPERCASE(GLSetup."Shortcut Dimension 3 Code") = UPPERCASE(DimName) then
                    exit(3)
                else
                    if UPPERCASE(GLSetup."Shortcut Dimension 4 Code") = UPPERCASE(DimName) then
                        exit(4)
                    else
                        if UPPERCASE(GLSetup."Shortcut Dimension 5 Code") = UPPERCASE(DimName) then
                            exit(5)
                        else
                            if UPPERCASE(GLSetup."Shortcut Dimension 6 Code") = UPPERCASE(DimName) then
                                exit(6)
                            else
                                if UPPERCASE(GLSetup."Shortcut Dimension 7 Code") = UPPERCASE(DimName) then
                                    exit(7)
                                else
                                    if UPPERCASE(GLSetup."Shortcut Dimension 8 Code") = UPPERCASE(DimName) then
                                        exit(8)
                                    else
                                        exit(0);
    end;

    local procedure FixCauseofAbsenceCode(CauseofAbsenceCode: Code[10]; CauseofAbsenceVal: Decimal) NewCode: Code[10];
    var
        TxtV: Text;
    begin
        if CauseofAbsenceVal <= 0 then
            TxtV := ''
        else
            if CauseofAbsenceVal <= 0.25 then
                TxtV := '0.25'
            else
                if CauseofAbsenceVal <= 0.5 then
                    TxtV := '0.5'
                else
                    if CauseofAbsenceVal <= 0.75 then
                        TxtV := '0.75'
                    else
                        TxtV := '';

        if (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('AL')) > 0) then
            NewCode := TxtV + 'AL'
        else
            if (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('CL')) > 0) then
                NewCode := TxtV + 'CL'
            else
                if (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('SKD')) > 0) then
                    NewCode := TxtV + 'SKD'
                else
                    if (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('SKL')) > 0) then
                        NewCode := TxtV + 'SKL'
                    else
                        if (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('ULT')) > 0) then
                            NewCode := TxtV + 'ULT'
                        else
                            if (STRPOS(UPPERCASE(CauseofAbsenceCode), UPPERCASE('UL')) > 0) then
                                NewCode := TxtV + 'UL'
                            else
                                NewCode := CauseofAbsenceCode;

        exit(NewCode);
    end;

    procedure GetLastDayinMonth(DateV: Date) D: Integer;
    var
        Y: Integer;
        M: Integer;
    begin
        if DateV = 0D then
            exit(0);

        Y := DATE2DMY(DateV, 3);
        M := DATE2DMY(DateV, 2);
        case M of
            1, 3, 5, 7, 8, 10, 12:
                D := 31;
            4, 6, 9, 11:
                D := 30;
            2:
                begin
                    if (Y mod 4 = 0) then
                        D := 29
                    else
                        D := 28
                end;
        end;
        exit(D);
    end;

    procedure CancelSalaryRaiseRequest(RecordID: RecordID) IsCanceled: Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        if ApprovalEntry.FINDFIRST then begin

            if (ApprovalEntry.Status = ApprovalEntry.Status::Open) then begin
                ApprovalEntry.DELETE(true);
                IsCanceled := true;
            end
            else
                IsCanceled := false;

        end
        else
            IsCanceled := true;

        exit(IsCanceled);
    end;

    procedure IsSalaryRaiseRequestApproved(RecordID: RecordID) IsApproved: Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        if ApprovalEntry.FINDFIRST then begin
            if (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then begin
                IsApproved := true;
            end
            else
                IsApproved := false;

        end
        else
            IsApproved := false;

        exit(IsApproved);
    end;

    procedure IsSalaryRaiseRequestRejected(RecordID: RecordID) IsRejected: Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        if ApprovalEntry.FINDFIRST then begin

            if (ApprovalEntry.Status = ApprovalEntry.Status::Rejected) then begin
                IsRejected := true;
            end
            else
                IsRejected := false;

        end
        else
            IsRejected := false;

        exit(IsRejected);
    end;

    procedure IsConsiderFirstandLastPunchOnly(EmpNo: Code[20]) FLOnly: Boolean;
    var
        EmployTypTbt: Record "Employment Type";
        EmpTbt: Record Employee;
    begin
        if EmpNo = '' then
            exit(false);

        FLOnly := false;

        EmpTbt.SETRANGE(EmpTbt."No.", EmpNo);
        if EmpTbt.FINDFIRST then begin
            if EmpTbt."Employment Type Code" <> '' then begin
                EmployTypTbt.SETRANGE(EmployTypTbt.Code, EmpTbt."Employment Type Code");
                if EmployTypTbt.FINDFIRST then begin
                    if EmployTypTbt."First Last Punch Only" = true then
                        FLOnly := true;
                end;
            end;
        end;

        exit(FLOnly);
    end;

    procedure GetEmployeeWorkingMonths(EmpNo: Code[20]; FromPeriod: Date; TillPeriod: Date) M: Decimal;
    var
        EmpTbt: Record Employee;
        AVGDayPerMonth: Decimal;
        FDate: Date;
        TDate: Date;
    begin
        if (EmpNo = '') or (FromPeriod = 0D) or (TillPeriod = 0D) then
            exit(0);

        AVGDayPerMonth := GetAverageDaysPerMonth();
        M := 0;

        EmpTbt.SETRANGE("No.", EmpNo);
        if EmpTbt.FINDFIRST then begin
            if EmpTbt."NSSF Date" <= FromPeriod then begin
                FDate := FromPeriod;
                if (EmpTbt."Termination Date" > TillPeriod) or (EmpTbt."Termination Date" = 0D) then
                    TDate := TillPeriod
                else
                    TDate := EmpTbt."Termination Date";
            end
            else begin
                FDate := EmpTbt."NSSF Date";
                if (EmpTbt."Termination Date" > TillPeriod) or (EmpTbt."Termination Date" = 0D) then
                    TDate := TillPeriod
                else
                    TDate := EmpTbt."Termination Date";
            end;
        end;
        M := ROUND((TDate - FDate) / AVGDayPerMonth, 0.01);
        exit(M);
    end;

    procedure GetAverageDaysPerMonth() D: Decimal;
    var
        HRSetupTbt: Record "Human Resources Setup";
    begin
        HRSetupTbt.GET;
        if HRSetupTbt."Average Days Per Month" > 0 then
            D := HRSetupTbt."Average Days Per Month"
        else
            D := ROUND(365 / 12, 0.001);
        exit(D);
    end;

    procedure GetEmployeeDepartmentCode(EmpNo: Code[20]) V: Code[20];
    var
        L_HRSetupTbt: Record "Human Resources Setup";
        L_EmpTbt: Record Employee;
    begin
        if EmpNo = '' then
            exit('');
        V := '';
        L_EmpTbt.SETRANGE("No.", EmpNo);
        if L_EmpTbt.FINDFIRST = false then
            exit('');

        if L_HRSetupTbt.FINDFIRST then begin
            if L_HRSetupTbt."Department Dimension Type" = L_HRSetupTbt."Department Dimension Type"::"Global Dimension1" then
                V := L_EmpTbt."Global Dimension 1 Code"
            else
                if L_HRSetupTbt."Department Dimension Type" = L_HRSetupTbt."Department Dimension Type"::"Global Dimension2" then
                    V := L_EmpTbt."Global Dimension 2 Code"
                else
                    if L_HRSetupTbt."Department Dimension Type" = L_HRSetupTbt."Department Dimension Type"::"Shortcut Dimension" then begin
                        L_EmpTbt.CALCFIELDS(Department);
                        V := L_EmpTbt.Department;
                    end;
        end;
        exit(V);
    end;

    procedure GetDimensionValueDescription(DimType: Code[20]; DimVal: Code[20]): Text[150];
    var
        L_DimValTbt: Record "Dimension Value";
    begin
        L_DimValTbt.SETRANGE("Dimension Code", DimType);
        L_DimValTbt.SETRANGE(Code, DimVal);
        if L_DimValTbt.FINDFIRST then
            exit(L_DimValTbt.Name)
        else
            exit('');
    end;

    procedure GetDepartmentSymbol() V: Text[20];
    begin
        V := 'DEPARTMENT';
    end;

    procedure GetEmpDepartmentDescription(EmpNo: Code[20]) V: Text[150];
    var
        L_EmpTbt: Record Employee;
    begin
        V := GetDimensionValueDescription(GetDepartmentSymbol(), GetEmployeeDepartmentCode(EmpNo));
    end;

    procedure GetProjectSymbol() V: Text[20];
    begin
        V := 'PROJECT';
    end;

    procedure GetDivisionSymbol() V: Text[20];
    begin
        V := 'DIVISION';
    end;

    procedure GetBranchSymbol() V: Text[20];
    begin
        V := 'BRANCH';
    end;

    procedure GetEmployeeProjectCode(EmpNo: Code[20]) V: Code[20];
    var
        L_HRSetupTbt: Record "Human Resources Setup";
        L_EmpTbt: Record Employee;
    begin
        if EmpNo = '' then
            exit('');
        V := '';
        L_EmpTbt.SETRANGE("No.", EmpNo);
        if L_EmpTbt.FINDFIRST = false then
            exit('');

        if L_HRSetupTbt.FINDFIRST then begin
            if L_HRSetupTbt."Project Dimension Type" = L_HRSetupTbt."Project Dimension Type"::"Global Dimension1" then
                V := L_EmpTbt."Global Dimension 1 Code"
            else
                if L_HRSetupTbt."Project Dimension Type" = L_HRSetupTbt."Project Dimension Type"::"Global Dimension2" then
                    V := L_EmpTbt."Global Dimension 2 Code"
                else
                    if L_HRSetupTbt."Project Dimension Type" = L_HRSetupTbt."Project Dimension Type"::"Shortcut Dimension" then begin
                        L_EmpTbt.CALCFIELDS(Project);
                        V := L_EmpTbt.Project;
                    end;
        end;
        exit(V);
    end;

    procedure GetEmployeeDivisionCode(EmpNo: Code[20]) V: Code[20];
    var
        L_HRSetupTbt: Record "Human Resources Setup";
        L_EmpTbt: Record Employee;
    begin
        if EmpNo = '' then
            exit('');
        V := '';
        L_EmpTbt.SETRANGE("No.", EmpNo);
        if L_EmpTbt.FINDFIRST = false then
            exit('');

        if L_HRSetupTbt.FINDFIRST then begin
            if L_HRSetupTbt."Division Dimension Type" = L_HRSetupTbt."Division Dimension Type"::"Global Dimension1" then
                V := L_EmpTbt."Global Dimension 1 Code"
            else
                if L_HRSetupTbt."Division Dimension Type" = L_HRSetupTbt."Division Dimension Type"::"Global Dimension2" then
                    V := L_EmpTbt."Global Dimension 2 Code"
                else
                    if L_HRSetupTbt."Division Dimension Type" = L_HRSetupTbt."Division Dimension Type"::"Shortcut Dimension" then begin
                        L_EmpTbt.CALCFIELDS(Division);
                        V := L_EmpTbt.Division;
                    end;
        end;
        exit(V);
    end;

    procedure GetEmployeeBranchCode(EmpNo: Code[20]) V: Code[20];
    var
        L_HRSetupTbt: Record "Human Resources Setup";
        L_EmpTbt: Record Employee;
    begin
        if EmpNo = '' then
            exit('');
        V := '';
        L_EmpTbt.SETRANGE("No.", EmpNo);
        if L_EmpTbt.FINDFIRST = false then
            exit('');

        if L_HRSetupTbt.FINDFIRST then begin
            if L_HRSetupTbt."Branch Dimension Type" = L_HRSetupTbt."Branch Dimension Type"::"Global Dimension1" then
                V := L_EmpTbt."Global Dimension 1 Code"
            else
                if L_HRSetupTbt."Branch Dimension Type" = L_HRSetupTbt."Branch Dimension Type"::"Global Dimension2" then
                    V := L_EmpTbt."Global Dimension 2 Code"
                else
                    if L_HRSetupTbt."Branch Dimension Type" = L_HRSetupTbt."Branch Dimension Type"::"Shortcut Dimension" then begin
                        L_EmpTbt.CALCFIELDS(Branch);
                        V := L_EmpTbt.Branch;
                    end;
        end;
        exit(V);
    end;

    procedure GetJobTitleDescription(JobCode: Code[20]): Text[150];
    var
        L_HRInformationTbt: Record "HR Information";
    begin
        L_HRInformationTbt.SETRANGE("Table Name", L_HRInformationTbt."Table Name"::"Job Title");
        L_HRInformationTbt.SETRANGE(Code, JobCode);
        if L_HRInformationTbt.FINDFIRST then
            exit(L_HRInformationTbt.Description)
        else
            exit('');
    end;

    procedure DeleteEmployeePayrollJournals(EmpNo: Code[20]; TransType: Code[20]; FromDate: Date; TillDate: Date);
    var
        L_HRTransactionTypeTbt: Record "HR Transaction Types";
        L_EmpJournalLineTbt: Record "Employee Journal Line";
    begin
        if (EmpNo = '') or (FromDate = 0D) or (TillDate = 0D) then
            exit;

        if TransType <> '' then
            L_HRTransactionTypeTbt.SETRANGE(Code, TransType)
        else
            L_HRTransactionTypeTbt.SETFILTER(Type, '%1|%2', 'BENEFIT', 'DEDUCTIONS');
        if L_HRTransactionTypeTbt.FINDFIRST then
            repeat
                L_EmpJournalLineTbt.RESET;
                CLEAR(L_EmpJournalLineTbt);
                L_EmpJournalLineTbt.SETRANGE("Employee No.", EmpNo);
                L_EmpJournalLineTbt.SETFILTER("Transaction Date", '%1..%2', FromDate, TillDate);
                L_EmpJournalLineTbt.SETRANGE(Processed, false);
                L_EmpJournalLineTbt.SETRANGE("Document Status", L_EmpJournalLineTbt."Document Status"::Opened);
                L_EmpJournalLineTbt.SETRANGE("Released By", '');
                L_EmpJournalLineTbt.SETRANGE("Approved By", '');
                L_EmpJournalLineTbt.SETRANGE("Transaction Type", L_HRTransactionTypeTbt.Code);
                if L_EmpJournalLineTbt.FINDFIRST then
                    L_EmpJournalLineTbt.DELETE
          until L_HRTransactionTypeTbt.NEXT = 0;
    end;

    procedure GetEmployeesScheduleDaysPerMonth(EmpNo: Code[20]; CauseofAbsCode: Code[10]) Monthlydays: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        PayElement: Record "Pay Element";
        HRSetup: Record "Human Resources Setup";
        EmployTypeCode: Code[20];
        PayElemCode: Code[10];
        CauseofAbsence: Record "Cause of Absence";
    begin

        HRSetup.GET();

        Monthlydays := 0;

        if EmpNo = '' then
            exit(0);

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin

            if Employee."Employment Type Code" <> '' then // Check at the level of Employment Type
              begin
                EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
                if EmploymentType.FINDFIRST then begin
                    Monthlydays := EmploymentType."Working Days Per Month";
                end;
            end;


            if Monthlydays = 0 then // Check at the level of Pay Element that is associated to the Cause OF Absence
              begin


                if CauseofAbsCode <> '' then // Check if the Cuase of Attendance is associated with a pay element
                  begin
                    CauseofAbsence.SETRANGE(Code, CauseofAbsCode);
                    if CauseofAbsence.FINDFIRST then begin
                        if CauseofAbsence."Associated Pay Element" <> '' then begin
                            PayElemCode := CauseofAbsence."Associated Pay Element";
                            PayElement.SETRANGE(Code, PayElemCode);
                            if PayElement.FINDFIRST then begin
                                Monthlydays := PayElement."Days in  Month";
                            end;
                        end;
                    end;
                end;


            end;

            if Monthlydays = 0 then //Check at the level of Pay Element Basic Pay
              begin
                PayElemCode := '01'; // Default value is Basic Salary
                PayElement.SETRANGE(Code, PayElemCode);
                if PayElement.FINDFIRST then begin
                    Monthlydays := PayElement."Days in  Month";
                end;
            end;

            if Monthlydays <= 0 then begin
                Monthlydays := 30;
            end;
        end;


        exit(Monthlydays);
    end;

    procedure IsLoanRequestApproved(RecordID: RecordID) IsApproved: Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        //approval cycle for employee loan 2017-06 SC+
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            IF (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                IsApproved := TRUE
            ELSE
                IsApproved := FALSE;

        END
        ELSE
            IsApproved := FALSE;

        EXIT(IsApproved);
        //approval cycle for employee loan 2017-06 SC-
    end;

    procedure IsLoanRequestRejected(RecordID: RecordID) IsRejected: Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        //approval cycle for employee loan 2017-06 SC+
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        IF ApprovalEntry.FINDFIRST THEN BEGIN

            IF (ApprovalEntry.Status = ApprovalEntry.Status::Rejected) THEN BEGIN
                IsRejected := TRUE;
            END
            ELSE
                IsRejected := FALSE;

        END
        ELSE
            IsRejected := FALSE;

        EXIT(IsRejected);
        //approval cycle for employee loan 2017-06 SC-
    end;

    procedure CheckLoanApprovalSystem(): Boolean;
    var
        HRSetUp: Record "Human Resources Setup";
        HRPermissions: Record "HR Permissions";
        IsReqApprovalOnLoan: Boolean;
        IsUseSystemApproval: Boolean;
    begin
        //approval cycle for employee loan 2017-06 SC+
        HRSetUp.RESET;
        IF HRSetUp.FINDFIRST THEN
            IsUseSystemApproval := HRSetUp."Use System Approval";
        HRPermissions.RESET;
        HRPermissions.SETFILTER("User ID", USERID);
        IF HRPermissions.FINDFIRST THEN
            IsReqApprovalOnLoan := HRPermissions."Req. Approval on Loan";
        IF IsUseSystemApproval AND IsReqApprovalOnLoan THEN
            EXIT(TRUE);
        EXIT(FALSE);
        //approval cycle for employee loan 2017-06 SC-
    end;

    procedure GetEmployeeRemainingLoanBalance(EmpNo: Code[20]; LoanTillPeriod: Date) Val: Decimal;
    var
        LoanTbt: Record "Employee Loan";
        LoanSubTbt: Record "Employee Loan Line";
    begin
        IF CheckLoanApprovalSystem THEN
            LoanSubTbt.SETRANGE("Change Status", LoanSubTbt."Change Status"::Approved);
        LoanSubTbt.SETRANGE("Employee No.", EmpNo);
        LoanSubTbt.SETFILTER("Payment Date", '%1..', LoanTillPeriod);
        // 08.01.2018 : A2+
        LoanSubTbt.SETFILTER(DOL, '<>%1', 0D);
        // 08.01.2018 : A2-
        if LoanSubTbt.FINDFIRST then
            repeat
                Val += LoanSubTbt."Payment Amount";
            until LoanSubTbt.NEXT = 0;
        exit(Val);
    end;

    procedure GenerateAllowanceDeductions(PayrollDate: Date; PayrollGroupCode: Code[20]; EmployeeNo: Code[20]; ResetExisting: Boolean; FixedPeriod: Boolean; EmployeeCategory: Code[20]; TemplateCode: Code[20]; SourceType: Option "Pay Detail",Journals,"Sub Payroll"; IsSchool: Boolean);
    var
        AllowanceDeductionTemplate: Record "Allowance Deduction Template";
        EmployeeJournalLine: Record "Employee Journal Line";
        AllowanceDeductionTempCatg: Record "Allowance Deduction Temp Catg";
        Employee: Record Employee;
        AllowanceDeductionPayElement: Record "Allowance Deduction Pay Elemt";
        HrTransactionTypes: Record "HR Transaction Types";
        PayElement: Record "Pay Element";
        PercentageValue: Decimal;
        allowanceDeductionCounter: Integer;
        ValueAmount: Decimal;
        EmployeeTotalAllowance: Decimal;
        EmployeeJournalLine2: Record "Employee Journal Line";
        ValueAmountNew: Decimal;
        CalculatedAmountNew: Decimal;
        PayDetailLine: Record "Pay Detail Line";
    begin

        if PayrollDate = 0D then
            ERROR('You must select Payroll Date');
        if ResetExisting then
            // 27.07.2017 : A2+
            if SourceType = SourceType::Journals then
                DeleteExistingAllowanceDeductions(PayrollDate, PayrollGroupCode, EmployeeNo, FixedPeriod, EmployeeCategory, TemplateCode, SourceType::Journals);
        // 27.07.2017 : A2-
        AllowanceDeductionTemplate.RESET;

        if TemplateCode <> '' then
            AllowanceDeductionTemplate.SETRANGE(Code, TemplateCode);

        if FixedPeriod then begin
            AllowanceDeductionTemplate.SETRANGE("Apply to Period Day", DATE2DMY(PayrollDate, 1));
            AllowanceDeductionTemplate.SETRANGE("Apply to Period Month", DATE2DMY(PayrollDate, 2));
        end;

        // 27.07.2017 : A2+
        if SourceType = SourceType::Journals then
            AllowanceDeductionTemplate.SETRANGE("Auto Generate", false)
        else
            if SourceType = SourceType::"Pay Detail" then
                AllowanceDeductionTemplate.SETRANGE("Auto Generate", true);
        // 27.07.2017 : A2-

        AllowanceDeductionTemplate.SETRANGE(Inactive, false);

        // Added in order to separate Allowance deduction from school allowance - 09.11.2017 : A2+
        AllowanceDeductionTemplate.SETRANGE(IsSchoolAllowance, IsSchool);
        // Added in order to separate Allowance deduction from school allowance - 09.11.2017 : A2-

        if AllowanceDeductionTemplate.FINDFIRST then
            repeat
                // check if payroll date is less than till date
                if (AllowanceDeductionTemplate."Till Date" > PayrollDate) and (AllowanceDeductionTemplate."Valid From" < PayrollDate) then begin

                    // Get Percentage Value Per Period (Month)+
                    CASE DATE2DMY(PayrollDate, 2) OF
                        1:
                            PercentageValue := AllowanceDeductionTemplate.JAN;
                        2:
                            PercentageValue := AllowanceDeductionTemplate.FEB;
                        3:
                            PercentageValue := AllowanceDeductionTemplate.MAR;
                        4:
                            PercentageValue := AllowanceDeductionTemplate.APR;
                        5:
                            PercentageValue := AllowanceDeductionTemplate.MAY;
                        6:
                            PercentageValue := AllowanceDeductionTemplate.JUN;
                        7:
                            PercentageValue := AllowanceDeductionTemplate.JUL;
                        8:
                            PercentageValue := AllowanceDeductionTemplate.AUG;
                        9:
                            PercentageValue := AllowanceDeductionTemplate.SEP;
                        10:
                            PercentageValue := AllowanceDeductionTemplate.OCT;
                        11:
                            PercentageValue := AllowanceDeductionTemplate.NOV;
                        12:
                            PercentageValue := AllowanceDeductionTemplate.DEC;
                    end;
                    // Get Percentage Value Per Period (Month)-

                    // repeat on AllowanceDeductionTempCatg+
                    AllowanceDeductionTempCatg.RESET;
                    AllowanceDeductionTempCatg.SETRANGE("Document No.", AllowanceDeductionTemplate.Code);
                    if EmployeeCategory <> '' then
                        AllowanceDeductionTempCatg.SETRANGE("Category Code", EmployeeCategory);

                    if AllowanceDeductionTempCatg.FINDFIRST then
                        repeat

                            // repeat on AllowanceDeductionPayElement+
                            AllowanceDeductionPayElement.RESET;
                            AllowanceDeductionPayElement.SETRANGE("Document No.", AllowanceDeductionTemplate.Code);
                            if AllowanceDeductionPayElement.FINDFIRST then
                                repeat

                                    // Get Pay Element+
                                    PayElement.RESET;
                                    PayElement.SETRANGE(Code, AllowanceDeductionPayElement."Pay Element Code");
                                    if PayElement.FINDFIRST then begin
                                        // repeat on Employees+
                                        Employee.RESET;
                                        Employee.SETRANGE("Employee Category Code", AllowanceDeductionTempCatg."Category Code");
                                        Employee.SETRANGE(Status, Employee.Status::Active);
                                        if EmployeeCategory <> '' then
                                            Employee.SETRANGE("Employee Category Code", EmployeeCategory);
                                        if PayrollGroupCode <> '' then
                                            Employee.SETRANGE("Payroll Group Code", PayrollGroupCode);
                                        if EmployeeNo <> '' then
                                            Employee.SETRANGE("No.", EmployeeNo);

                                        if Employee.FINDFIRST then
                                            repeat
                                                //Check if payroll date for this employee is valid 2017-07-13 SC+
                                                if IsValidPayrollDate(Employee."Payroll Group Code", PayrollDate) then begin
                                                    // get Add Ded counter+
                                                    allowanceDeductionCounter := GetAllowanceDeductionCounter(Employee."No.", AllowanceDeductionTemplate."Applied by",
                                                                        AllowanceDeductionTemplate."Maximum Children",
                                                                        AllowanceDeductionTemplate."Declare Type", AllowanceDeductionPayElement."School Level");
                                                    // get Add Ded counter-

                                                    // get amount+
                                                    if AllowanceDeductionPayElement."Calculation Type" = AllowanceDeductionPayElement."Calculation Type"::"Fixed Amount" then
                                                        if AllowanceDeductionTemplate."Affected By Attendance" then
                                                            ValueAmount := (GetEmployeeNbWorkingDays(Employee."No.", PayrollDate) * AllowanceDeductionPayElement."Daily Amount" *
                                                                         PercentageValue * allowanceDeductionCounter) / 100
                                                        else
                                                            ValueAmount := (AllowanceDeductionPayElement."Monthly Amount" * PercentageValue * allowanceDeductionCounter) / 100

                                                    else
                                                        if AllowanceDeductionPayElement."Calculation Type" = AllowanceDeductionPayElement."Calculation Type"::"Basic Pay" then
                                                            if AllowanceDeductionTemplate."Affected By Attendance" then begin
                                                                if AllowanceDeductionTemplate."Average Days/Month" <> 0 then
                                                                    ValueAmount := (GetEmployeeNbWorkingDays(Employee."No.", PayrollDate) * (Employee."Basic Pay" / AllowanceDeductionTemplate."Average Days/Month") *
                                                                                PercentageValue * allowanceDeductionCounter) / 100
                                                                else
                                                                    ValueAmount := (GetEmployeeNbWorkingDays(Employee."No.", PayrollDate) * (Employee."Basic Pay" / 30) *
                                                                                PercentageValue * allowanceDeductionCounter) / 100;
                                                            end
                                                            else
                                                                ValueAmount := (Employee."Basic Pay" * PercentageValue * allowanceDeductionCounter) / 100

                                                        else
                                                            if AllowanceDeductionPayElement."Calculation Type" = AllowanceDeductionPayElement."Calculation Type"::"Total Allowances" then begin
                                                                EmployeeTotalAllowance := Employee."Basic Pay" + Employee."Cost of Living" + Employee."Phone Allowance" + Employee."Car Allowance" +
                                                                                      Employee."House Allowance" + Employee."Other Allowances" + Employee."Food Allowance" +
                                                                                      Employee."Ticket Allowance";

                                                                if AllowanceDeductionTemplate."Affected By Attendance" then begin
                                                                    if AllowanceDeductionTemplate."Average Days/Month" <> 0 then
                                                                        ValueAmount := (GetEmployeeNbWorkingDays(Employee."No.", PayrollDate) * (EmployeeTotalAllowance / AllowanceDeductionTemplate."Average Days/Month") *
                                                                                  PercentageValue * allowanceDeductionCounter) / 100
                                                                    else
                                                                        ValueAmount := (GetEmployeeNbWorkingDays(Employee."No.", PayrollDate) * (EmployeeTotalAllowance / 30) *
                                                                                  PercentageValue * allowanceDeductionCounter) / 100;
                                                                end
                                                                else
                                                                    ValueAmount := (EmployeeTotalAllowance * PercentageValue * allowanceDeductionCounter) / 100
                                                            end;
                                                    // get amount-

                                                    if ValueAmount > 0 then begin
                                                        // 27.07.2017 : A2+
                                                        if ValueAmount > AllowanceDeductionPayElement."Maximum Monthly Amount" then
                                                            ValueAmount := AllowanceDeductionPayElement."Maximum Monthly Amount";
                                                        if SourceType = SourceType::"Pay Detail" then
                                                          // 27.07.2017 : A2-
                                                          begin
                                                            // create Pay Detail Line+
                                                            // 26.07.2017 : A2+
                                                            PayLedgEntry.RESET;
                                                            CLEAR(PayLedgEntry);
                                                            PayLedgEntry.SETRANGE("Payroll Date", PayrollDate);
                                                            if PayLedgEntry.FINDFIRST then
                                                                PayLedgEntryNo := PayLedgEntry."Entry No.";

                                                            PayDetailLine2.RESET;
                                                            PayDetailLine2.SETRANGE("Employee No.", Employee."No.");
                                                            if PayDetailLine2.FINDFIRST then
                                                                LineNo := PayDetailLine2."Line No." + 1
                                                            else
                                                                LineNo := 1;
                                                            // 26.07.2017 : A2-

                                                            PayDetailLine.RESET;
                                                            PayDetailLine.INIT;
                                                            PayDetailLine."Line No." := LineNo;
                                                            PayDetailLine."Tax Year" := DATE2DMY(PayrollDate, 3);
                                                            PayDetailLine.Period := DATE2DMY(PayrollDate, 2);
                                                            PayDetailLine."Pay Frequency" := Employee."Pay Frequency";
                                                            PayDetailLine."Pay Element Code" := PayElement.Code;
                                                            PayDetailLine.Description := PayElement.Description;
                                                            PayDetailLine.VALIDATE("Employee No.", Employee."No.");
                                                            PayDetailLine.VALIDATE("Payroll Date", PayrollDate);
                                                            PayDetailLine.VALIDATE("Manual Pay Line", false);

                                                            if PayElement.Type = PayElement.Type::Addition then
                                                                PayDetailLine.VALIDATE(Type, PayDetailLine.Type::Addition)
                                                            else
                                                                PayDetailLine.VALIDATE(Type, PayDetailLine.Type::Deduction);

                                                            PayDetailLine.VALIDATE(Amount, ValueAmount);
                                                            PayDetailLine.VALIDATE("Calculated Amount", ValueAmount);
                                                            //******************************************************//
                                                            PayDetailLine.Recurring := false;
                                                            PayDetailLine.Open := true;
                                                            PayDetailLine."Payroll Special Code" := PayElement."Payroll Special Code";
                                                            PayDetailLine."Not Included in Net Pay" := PayElement."Not Included in Net Pay";
                                                            PayDetailLine."Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
                                                            PayDetailLine."Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                                            PayDetailLine."Payroll Group Code" := Employee."Payroll Group Code";
                                                            PayDetailLine."Exchange Rate" := Paystatus."Exchange Rate";
                                                            PayDetailLine."Payroll Ledger Entry No." := PayLedgEntryNo;
                                                            //******************************************************//
                                                            PayDetailLine.INSERT(true);
                                                            // create Pay Detail Line-
                                                        end
                                                        // 27.07.2017 : A2+
                                                        else
                                                            if SourceType = SourceType::Journals then
                                                         // 27.07.2017 : A2-
                                                         begin
                                                                HrTransactionTypes.RESET;
                                                                HrTransactionTypes.SETRANGE("Associated Pay Element", AllowanceDeductionPayElement."Pay Element Code");
                                                                if HrTransactionTypes.FINDFIRST then begin
                                                                    EmployeeJournalLine2.RESET;
                                                                    EmployeeJournalLine2.SETRANGE("Transaction Date", PayrollDate);
                                                                    EmployeeJournalLine2.SETFILTER("Transaction Type", HrTransactionTypes.Code);
                                                                    EmployeeJournalLine2.SETFILTER("Employee No.", Employee."No.");
                                                                    EmployeeJournalLine2.SETRANGE("System Insert", true);
                                                                    if EmployeeJournalLine2.FINDFIRST then begin
                                                                        ValueAmountNew := EmployeeJournalLine2.Value + ValueAmount;
                                                                        CalculatedAmountNew := EmployeeJournalLine2."Calculated Value" + ValueAmount;
                                                                        EmployeeJournalLine2.VALIDATE(Value, ValueAmountNew);
                                                                        EmployeeJournalLine2.VALIDATE("Calculated Value", CalculatedAmountNew);
                                                                        EmployeeJournalLine2.MODIFY;
                                                                    end
                                                                    else begin
                                                                        // create EmployeeJournalLine+
                                                                        EmployeeJournalLine.RESET;
                                                                        EmployeeJournalLine.INIT;
                                                                        EmployeeJournalLine.VALIDATE("Transaction Type", HrTransactionTypes.Code);
                                                                        EmployeeJournalLine.VALIDATE("Employee No.", Employee."No.");
                                                                        EmployeeJournalLine.VALIDATE("Transaction Date", PayrollDate);
                                                                        EmployeeJournalLine.VALIDATE("System Insert", true);

                                                                        if PayElement.Type = PayElement.Type::Addition then
                                                                            EmployeeJournalLine.VALIDATE(Type, 'BENEFIT')
                                                                        else
                                                                            EmployeeJournalLine.VALIDATE(Type, 'DEDUCTIONS');

                                                                        EmployeeJournalLine.VALIDATE(Value, ValueAmount);
                                                                        EmployeeJournalLine.VALIDATE("Calculated Value", ValueAmount);
                                                                        EmployeeJournalLine.VALIDATE("Opened By", USERID);
                                                                        EmployeeJournalLine.VALIDATE("Opened Date", TODAY);
                                                                        EmployeeJournalLine.VALIDATE("Released By", USERID);
                                                                        EmployeeJournalLine.VALIDATE("Released Date", TODAY);
                                                                        EmployeeJournalLine.VALIDATE("Approved By", USERID);
                                                                        EmployeeJournalLine.VALIDATE("Approved Date", TODAY);
                                                                        EmployeeJournalLine.VALIDATE("Document Status", EmployeeJournalLine."Document Status"::Approved);

                                                                        EmployeeJournalLine.INSERT(true);
                                                                        // create EmployeeJournalLine-

                                                                    end;

                                                                end;
                                                                // Get HrTransactionTypes-
                                                            end;
                                                    end;
                                                end;
                                            //Check if payroll date for this employee is valid 2017-07-13 SC-
                                            until Employee.NEXT = 0;
                                        // repeat on Employees-
                                        // Get HrTransactionTypes-*/

                                    end;
                                // Get Pay Element-

                                until AllowanceDeductionPayElement.NEXT = 0;
                        // repeat on AllowanceDeductionPayElement-

                        until AllowanceDeductionTempCatg.NEXT = 0;
                    // repeat on AllowanceDeductionTempCatg-

                end;

            until AllowanceDeductionTemplate.NEXT = 0;
        // repeat on AllowanceDeductionTemplate-

    end;

    local procedure GetAllowanceDeductionCounter(EmpNo: Code[20]; AppliedBy: Option Child,Wife,Other; MaxChild: Integer; DeclareType: Option All,"Eligible Only"; SchoolLevel: Code[50]) Result: Integer;
    var
        EmployeeRelative: Record "Employee Relative";
    begin

        if MaxChild < 0 then
            exit(0);
        if AppliedBy <> AppliedBy::Other then begin
            EmployeeRelative.RESET;
            EmployeeRelative.SETRANGE("Employee No.", EmpNo);
            if DeclareType = DeclareType::"Eligible Only" then begin
                if AppliedBy = AppliedBy::Child then
                    EmployeeRelative.SETRANGE("Eligible Child", true)
                else
                    if AppliedBy = AppliedBy::Wife then
                        EmployeeRelative.SETRANGE("Eligible Exempt Tax", true);
            end;
            if SchoolLevel <> '' then
                EmployeeRelative.SETFILTER("School Level", SchoolLevel);
            if EmployeeRelative.FINDFIRST then
                repeat
                    if AppliedBy = AppliedBy::Child then begin
                        EmployeeRelative.CALCFIELDS(Type);
                        if (EmployeeRelative.Type = EmployeeRelative.Type::Child) and (Result < MaxChild) then
                            Result += 1;
                    end
                    else
                        if AppliedBy = AppliedBy::Wife then begin
                            EmployeeRelative.CALCFIELDS(Type);
                            if EmployeeRelative.Type = EmployeeRelative.Type::Wife then
                                Result += 1;
                        end;
                until EmployeeRelative.NEXT = 0;
        end
        else
            Result := 1;

        exit(Result);
    end;

    local procedure GetEmployeeNbWorkingDays(EmpNo: Code[20]; PayrollDate: Date) Result: Decimal;
    var
        Employee: Record Employee;
        L_CalcEmpPay: Codeunit "Calculate Employee Pay";
        L_AttStartDate: Date;
        L_AttEndDate: Date;
    begin

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin
            L_AttStartDate := L_CalcEmpPay.GetAttendanceStartDate(Employee."Payroll Group Code");
            L_AttEndDate := L_CalcEmpPay.GetAttendanceEndDate(Employee."Payroll Group Code");
            Employee.SETFILTER("Date Filter", '%1..%2', L_AttStartDate, L_AttEndDate);
            if Employee.FINDFIRST then begin
                Employee.CALCFIELDS("No. of Working Days");
                Result := Employee."No. of Working Days";
            end;
        end;
        exit(Result);
    end;

    procedure IsEmployeeCodeUsed(EmpNo: Code[20]): Boolean;
    var
        L_EmployeeJournalLineTbt: Record "Employee Journal Line";
        L_PayDetailLineTbt: Record "Pay Detail Line";
        L_PayDetailHeaderTbt: Record "Pay Detail Header";
        L_PayrollLedgerEntryTbt: Record "Payroll Ledger Entry";
        L_EmployeeLoanTbt: Record "Employee Loan";
        L_EmployeeAbsenceTbt: Record "Employee Absence";
        L_HandPunchTbt: Record "Hand Punch";
        L_LeaveRequestTbt: Record "Leave Request";
        L_EmployeeAbsenceEntitlementTbt: Record "Employee Absence Entitlement";
        L_EmployeeDimensionTbt: Record "Employee Dimensions";
        L_EmployeeSalaryHistoryTbt: Record "Employee Salary History";
        L_EvaluationTbt: Record "Evaluation Data Main";
        L_EmployeeTBT: Record Employee;
    begin
        L_EmployeeAbsenceEntitlementTbt.SETRANGE("Employee No.", EmpNo);
        if L_EmployeeAbsenceEntitlementTbt.FINDFIRST then
            exit(true);

        L_EmployeeAbsenceTbt.SETRANGE("Employee No.", EmpNo);
        if L_EmployeeAbsenceTbt.FINDFIRST then
            exit(true);

        L_EmployeeDimensionTbt.SETRANGE("Employee No.", EmpNo);
        if L_EmployeeDimensionTbt.FINDFIRST then
            exit(true);

        L_EmployeeJournalLineTbt.SETRANGE("Employee No.", EmpNo);
        if L_EmployeeJournalLineTbt.FINDFIRST then
            exit(true);

        L_EmployeeLoanTbt.SETRANGE("Employee No.", EmpNo);
        if L_EmployeeLoanTbt.FINDFIRST then
            exit(true);

        L_EmployeeSalaryHistoryTbt.SETRANGE("Employee No.", EmpNo);
        if L_EmployeeSalaryHistoryTbt.FINDFIRST then
            exit(true);

        L_EvaluationTbt.SETRANGE("Employee No", EmpNo);
        if L_EvaluationTbt.FINDFIRST then
            exit(true);

        L_LeaveRequestTbt.SETRANGE("Employee No.", EmpNo);
        if L_LeaveRequestTbt.FINDFIRST then
            exit(true);

        L_PayDetailLineTbt.SETRANGE("Employee No.", EmpNo);
        L_PayDetailLineTbt.SETFILTER("Tax Year", '<>%1', 0);
        L_PayDetailLineTbt.SETFILTER(Period, '<>%1', 0);
        if L_PayDetailLineTbt.FINDFIRST then
            exit(true);

        L_PayrollLedgerEntryTbt.SETRANGE("Employee No.", EmpNo);
        L_PayrollLedgerEntryTbt.SETFILTER("Tax Year", '<>%1', 0);
        L_PayrollLedgerEntryTbt.SETFILTER(Period, '<>%1', 0);
        if L_PayrollLedgerEntryTbt.FINDFIRST then
            exit(true);

        L_EmployeeTBT.SETRANGE("No.", EmpNo);
        if L_EmployeeTBT.FINDFIRST then begin
            L_HandPunchTbt.SETRANGE("Attendnace No.", L_EmployeeTBT."Attendance No.");
            if L_HandPunchTbt.FINDFIRST then
                exit(true);
        end;
        exit(false);
    end;

    procedure CalculateIncomeTax(TaxableTotal: Decimal; FreePay: Decimal; MonthCount: Decimal) TaxAmount: Decimal;
    var
        Amt: Decimal;
        TaxBandTbt: Record "Tax Band";
    begin
        Amt := TaxableTotal - FreePay;
        TaxAmount := 0;
        TaxBandTbt.SETCURRENTKEY("Annual Bandwidth");
        if TaxBandTbt.FINDFIRST then
            repeat
                if Amt > 0 then begin
                    if Amt <= ((TaxBandTbt."Annual Bandwidth" * MonthCount) / 12) then
                        TaxAmount += Amt * TaxBandTbt.Rate / 100
                    else
                        TaxAmount += (((TaxBandTbt."Annual Bandwidth" * MonthCount) / 12) * TaxBandTbt.Rate) / 100;
                end;
                Amt := Amt - ((TaxBandTbt."Annual Bandwidth" * MonthCount) / 12);
            until TaxBandTbt.NEXT = 0;
        exit(TaxAmount);
    end;

    procedure GetEmployeePaidIncomeTax(EmpNo: Code[20]; PayrollDate: Date) L_Val: Decimal;
    var
        PayrollLedgerEntryTbt: Record "Payroll Ledger Entry";
        Year: Integer;
    begin
        if (EmpNo = '') or (PayrollDate = 0D) then
            exit(0);

        L_Val := 0;
        Year := DATE2DMY(PayrollDate, 3);
        PayrollLedgerEntryTbt.SETFILTER(Declared, '%1|%2', PayrollLedgerEntryTbt.Declared::Declared, PayrollLedgerEntryTbt.Declared::"Non-NSSF");
        PayrollLedgerEntryTbt.SETFILTER(Period, '>=%1', 1);
        PayrollLedgerEntryTbt.SETRANGE("Tax Year", Year);
        PayrollLedgerEntryTbt.SETRANGE("Employee No.", EmpNo);
        PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '<%1', PayrollDate);
        if PayrollLedgerEntryTbt.FINDFIRST then
            repeat
                L_Val += PayrollLedgerEntryTbt."Tax Paid";
            until PayrollLedgerEntryTbt.NEXT = 0;
        exit(L_Val);
    end;

    procedure CalculateEmployeeIncomeTax(EmpNo: Code[20]; PayrollDate: Date; TaxableAmount: Decimal; FreePay: Decimal; UseRetro: Boolean) L_Val: Decimal;
    var
        L_MonthCount: Decimal;
        L_DaysPerMonth: Decimal;
        L_EmpTbt: Record Employee;
        L_StartDate: Date;
        L_TillDate: Date;
        L_PayrollLedgerEntryTbt: Record "Payroll Ledger Entry";
        L_HRSetupTbt: Record "Human Resources Setup";
        L_DeclareDate: Date;
        L_TerminationDate: Date;
        L_PayParameterTbt: Record "Payroll Parameter";
    begin
        L_DaysPerMonth := GetAverageDaysPerMonth();
        if (EmpNo = '') or (PayrollDate = 0D) then
            exit(0);

        L_EmpTbt.SETRANGE("No.", EmpNo);
        if not L_EmpTbt.FINDFIRST then
            exit(0);

        L_DeclareDate := L_EmpTbt."Declaration Date";
        L_TerminationDate := L_EmpTbt."Termination Date";

        L_TillDate := PayrollDate;
        L_StartDate := DMY2DATE(1, 1, DATE2DMY(PayrollDate, 3));
        if (L_TerminationDate <> 0D) and (PayrollDate > L_TerminationDate) then //18.05.2017 : A2+-
          begin
            L_TillDate := L_TerminationDate;
            if DATE2DMY(PayrollDate, 3) > DATE2DMY(L_TerminationDate, 3) then
                exit(0);
            if DATE2DMY(PayrollDate, 3) = DATE2DMY(L_TerminationDate, 3) then begin
                if DATE2DMY(PayrollDate, 2) < DATE2DMY(L_TerminationDate, 2) then
                    exit(0);
                if DATE2DMY(PayrollDate, 2) = DATE2DMY(L_TerminationDate, 2) then
                    L_TillDate := L_TerminationDate;
            end;
        end;

        if (L_EmpTbt."Inactive Date" <> 0D) and (PayrollDate > L_EmpTbt."Inactive Date") then // 18.05.2017 : A2+-
            exit(0);

        L_PayParameterTbt.GET();
        L_MonthCount := GetEmployeesNoOfDeclaredMonths(EmpNo, PayrollDate);

        if L_MonthCount <= 0 then
            L_MonthCount := 1;

        if (not UseRetro) and (L_MonthCount > 1) then
            L_MonthCount := 1;

        if UseRetro then begin
            L_PayrollLedgerEntryTbt.SETFILTER(Declared, '%1|%2', L_PayrollLedgerEntryTbt.Declared::Declared, L_PayrollLedgerEntryTbt.Declared::"Non-NSSF");
            L_PayrollLedgerEntryTbt.SETFILTER(Period, '>=%1', 1);
            L_PayrollLedgerEntryTbt.SETRANGE("Tax Year", DATE2DMY(PayrollDate, 3));
            L_PayrollLedgerEntryTbt.SETRANGE("Employee No.", EmpNo);
            L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '<%1', PayrollDate);
            if L_PayrollLedgerEntryTbt.FINDFIRST then
                repeat
                    TaxableAmount += L_PayrollLedgerEntryTbt."Taxable Pay";
                    FreePay += L_PayrollLedgerEntryTbt."Free Pay";
                until L_PayrollLedgerEntryTbt.NEXT = 0;
        end;

        L_MonthCount := ROUND(L_MonthCount, 0.01, '=');
        L_Val := CalculateIncomeTax(TaxableAmount, FreePay, L_MonthCount);

        if UseRetro then
            L_Val := L_Val - GetEmployeePaidIncomeTax(EmpNo, PayrollDate);

        L_Val := ROUND(L_Val, 1, '=');
        exit(L_Val);

    end;

    procedure CalculateNSSFContribution(TotalForNSSF: Decimal; MonthCount: Decimal; MonthCountBefore: Decimal; MonthCountBefore2: Decimal; NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5"; PostingGroup: Code[20]) L_Val: Decimal;
    var
        L_PensionScheme: Record "Pension Scheme";
    begin
        L_Val := 0;

        if (NSSFType = NSSFType::MHOOD2) or (NSSFType = NSSFType::MHOOD7) then
            L_PensionScheme.SETRANGE(Type, L_PensionScheme.Type::MHOOD)
        else
            if (NSSFType = NSSFType::FAMSUB6) then
                L_PensionScheme.SETRANGE(Type, L_PensionScheme.Type::FAMSUB)
            else
                if (NSSFType = NSSFType::"EOS8.5") then
                    L_PensionScheme.SETRANGE(Type, L_PensionScheme.Type::EOSIND)
                else
                    exit(0);

        if PostingGroup = '' then
            exit(0);

        L_PensionScheme.SETRANGE("Payroll Posting Group", PostingGroup);
        L_PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
        if L_PensionScheme.FINDFIRST then begin
            if NSSFType <> NSSFType::"EOS8.5" then begin
                //if (L_PensionScheme."Maximum Monthly Contribution" > 0) and (TotalForNSSF > (L_PensionScheme."Maximum Monthly Contribution" * MonthCount)) then
                //  TotalForNSSF := L_PensionScheme."Maximum Monthly Contribution" * MonthCount;
                //20220611
                if (L_PensionScheme."Maximum Monthly Contribution" > 0) and (TotalForNSSF >
                ((L_PensionScheme."Maximum Monthly Contribution" * (MonthCount - MonthCountBefore - MonthCountBefore2)) + (L_PensionScheme."Before Max Monthly Cont" * MonthCountBefore)
                + (L_PensionScheme."Before Max Monthly Cont 2" * MonthCountBefore2))) then
                    TotalForNSSF := L_PensionScheme."Maximum Monthly Contribution" * (MonthCount - MonthCountBefore - MonthCountBefore2) + L_PensionScheme."Before Max Monthly Cont" * MonthCountBefore
                    + L_PensionScheme."Before Max Monthly Cont 2" * MonthCountBefore2;
            end;

            if (NSSFType = NSSFType::MHOOD2) then
                L_Val := (TotalForNSSF * L_PensionScheme."Employee Contribution %") / 100
            else
                if (NSSFType = NSSFType::MHOOD7) then
                    L_Val := (TotalForNSSF * L_PensionScheme."Employer Contribution %") / 100
                else
                    if (NSSFType = NSSFType::FAMSUB6) then
                        L_Val := (TotalForNSSF * L_PensionScheme."Employer Contribution %") / 100
                    else
                        if (NSSFType = NSSFType::"EOS8.5") then
                            L_Val := (TotalForNSSF * L_PensionScheme."Employer Contribution %") / 100
                        else
                            exit(0);
        end;
        L_Val := ROUND(L_Val, GetNSSFPrecision(), '>');
        exit(L_Val);
    end;

    procedure GetEmployeePaidNSSFContribution(EmpNo: Code[20]; PayrollDate: Date; NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5") L_Val: Decimal;
    var
        L_PayrollLedgerEntryTbt: Record "Payroll Ledger Entry";
        L_Year: Integer;
        L_EmpTbt: Record Employee;
        L_PayDetailLine: Record "Pay Detail Line";
        L_PayElement: Code[20];
        L_MainNSSFT: Option MHOOD9,FAMSUB6,"EOS8.5";
        L_PayParameterTbt: Record "Payroll Parameter";
    begin
        // 04.08.2017 : A2+
        L_PayParameterTbt.GET();
        // 04.08.2017 : A2-
        L_Val := 0;
        if (EmpNo = '') or (PayrollDate = 0D) then
            exit(0);

        L_EmpTbt.SETRANGE("No.", EmpNo);
        if not L_EmpTbt.FINDFIRST then
            exit(0);

        if (NSSFType = NSSFType::MHOOD2) or (NSSFType = NSSFType::MHOOD7) then
            L_MainNSSFT := L_MainNSSFT::MHOOD9
        else
            if NSSFType = NSSFType::FAMSUB6 then
                L_MainNSSFT := L_MainNSSFT::FAMSUB6
            else
                if NSSFType = NSSFType::"EOS8.5" then
                    L_MainNSSFT := L_MainNSSFT::"EOS8.5"
                else
                    exit(0);

        L_PayElement := GetNSSFContributionPayElement(L_MainNSSFT, L_EmpTbt."Posting Group");
        if L_PayElement = '' then
            exit(0);

        L_Year := DATE2DMY(PayrollDate, 3);
        L_PayrollLedgerEntryTbt.SETFILTER(Declared, '%1', L_PayrollLedgerEntryTbt.Declared::Declared);
        L_PayrollLedgerEntryTbt.SETFILTER(Period, '>=%1', 1);
        L_PayrollLedgerEntryTbt.SETRANGE("Tax Year", L_Year);
        L_PayrollLedgerEntryTbt.SETRANGE("Employee No.", EmpNo);
        // 04.07.2017 : A2+
        if (L_PayParameterTbt."MHOOD Retro Start Date" <> 0D) and ((NSSFType = NSSFType::MHOOD2) or (NSSFType = NSSFType::MHOOD7)) then
            L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '%1..%2', L_PayParameterTbt."MHOOD Retro Start Date", PayrollDate - 1)
        else
            if (L_PayParameterTbt."Family Sub Retro Start Date" <> 0D) and (NSSFType = NSSFType::FAMSUB6) then
                L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '%1..%2', L_PayParameterTbt."Family Sub Retro Start Date", PayrollDate - 1)
            else
                if (L_PayParameterTbt."Family Sub Retro Start Date" <> 0D) and (NSSFType = NSSFType::"EOS8.5") then
                    L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '%1..%2', L_PayParameterTbt."EOS Retro Start Date", PayrollDate - 1)
                else
                    L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '<%1', PayrollDate);
        // 04.08.2017 : A2-
        if L_PayrollLedgerEntryTbt.FINDFIRST then
            repeat
            begin
                L_PayDetailLine.SETFILTER(Period, '>=%1', 1);
                L_PayDetailLine.SETRANGE("Tax Year", L_Year);
                L_PayDetailLine.SETRANGE("Employee No.", EmpNo);
                L_PayDetailLine.SETRANGE("Payroll Date", L_PayrollLedgerEntryTbt."Payroll Date");
                L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollLedgerEntryTbt."Sub Payroll Code");
                L_PayDetailLine.SETRANGE("Pay Element Code", L_PayElement);
                if L_PayDetailLine.FINDFIRST then begin
                    if NSSFType = NSSFType::MHOOD2 then
                        L_Val += L_PayDetailLine."Calculated Amount"
                    else
                        L_Val += L_PayDetailLine."Employer Amount";
                end;
            end;
            until L_PayrollLedgerEntryTbt.NEXT = 0;
        exit(L_Val);
    end;

    procedure GetNSSFContributionPayElement(NSSFType: Option MHOOD9,FAMSUB6,"EOS8.5"; PostingGroup: Code[20]) L_Val: Code[20];
    var
        L_PensionScheme: Record "Pension Scheme";
    begin
        L_Val := '';

        if (NSSFType = NSSFType::MHOOD9) then
            L_PensionScheme.SETRANGE(Type, L_PensionScheme.Type::MHOOD)
        else
            if (NSSFType = NSSFType::FAMSUB6) then
                L_PensionScheme.SETRANGE(Type, L_PensionScheme.Type::FAMSUB)
            else
                if (NSSFType = NSSFType::"EOS8.5") then
                    L_PensionScheme.SETRANGE(Type, L_PensionScheme.Type::EOSIND)
                else
                    exit('');

        if PostingGroup = '' then
            exit('');

        L_PensionScheme.SETRANGE("Payroll Posting Group", PostingGroup);
        L_PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
        if L_PensionScheme.FINDFIRST then begin
            L_Val := L_PensionScheme."Associated Pay Element";
        end;

        exit(L_Val);
    end;

    procedure CalculateEmployeeNSSFContribution(EmpNo: Code[20]; PayrollDate: Date; TotalForNSSF: Decimal; NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5"; UseRetro: Boolean) L_Val: Decimal;
    var
        L_MonthCount: Decimal;
        L_MonthCountBefore: Decimal;
        L_MonthCountBefore2: Decimal;
        L_DaysPerMonth: Decimal;
        L_EmpTbt: Record Employee;
        L_StartDate: Date;
        L_TillDate: Date;
        L_PayrollLedgerEntryTbt: Record "Payroll Ledger Entry";
        L_HRSetupTbt: Record "Human Resources Setup";
        L_DeclareDate: Date;
        L_TerminationDate: Date;
        L_PayParameterTbt: Record "Payroll Parameter";
        L_TNSSF: Decimal;
        L_NSSFTypeCategory: Option All,MHOOD9,FAMSUB6,"EOS8.5";
    begin
        // 04.08.2017 : A2+
        L_PayParameterTbt.GET();
        // 04.08.2017 : A2-
        L_DaysPerMonth := GetAverageDaysPerMonth();
        if (EmpNo = '') or (PayrollDate = 0D) then
            exit(0);

        L_EmpTbt.SETRANGE("No.", EmpNo);
        if not L_EmpTbt.FINDFIRST then
            exit(0);
        if L_EmpTbt."NSSF Date" <> 0D then
            L_DeclareDate := L_EmpTbt."NSSF Date"
        else
            L_DeclareDate := L_EmpTbt."Declaration Date";
        L_TerminationDate := L_EmpTbt."Termination Date";

        L_TillDate := PayrollDate;
        L_StartDate := DMY2DATE(1, 1, DATE2DMY(PayrollDate, 3));

        if (L_TerminationDate <> 0D) and (PayrollDate > L_TerminationDate) then // 18.05.2017 : A2+-
          begin
            L_TillDate := L_TerminationDate;
            if DATE2DMY(PayrollDate, 3) > DATE2DMY(L_TerminationDate, 3) then
                exit(0);
            if DATE2DMY(PayrollDate, 3) = DATE2DMY(L_TerminationDate, 3) then begin
                if DATE2DMY(PayrollDate, 2) < DATE2DMY(L_TerminationDate, 2) then
                    exit(0);
                if DATE2DMY(PayrollDate, 2) = DATE2DMY(L_TerminationDate, 2) then
                    L_TillDate := L_TerminationDate;
            end;
        end;

        if (L_EmpTbt."Inactive Date" <> 0D) and (PayrollDate > L_EmpTbt."Inactive Date") then // 23.05.2017 : A2+-
            exit(0);

        L_PayParameterTbt.GET();
        if not L_PayParameterTbt."Employ-Termination Affect NSSF" then begin
            L_DeclareDate := DMY2DATE(1, DATE2DMY(L_DeclareDate, 2), DATE2DMY(L_DeclareDate, 3));
            if L_TerminationDate <> 0D then
                L_TerminationDate := DMY2DATE(GetLastDayinMonth(L_TerminationDate), DATE2DMY(L_TerminationDate, 2), DATE2DMY(L_TerminationDate, 3))
        end;

        if not UseRetro then begin
            if (DATE2DMY(PayrollDate, 2) = DATE2DMY(L_DeclareDate, 2)) and (DATE2DMY(PayrollDate, 3) = DATE2DMY(L_DeclareDate, 3)) then
                L_StartDate := L_DeclareDate;
        end;

        if L_DeclareDate > L_StartDate then
            L_StartDate := L_DeclareDate;

        if not UseRetro then begin
            if DATE2DMY(L_StartDate, 3) < DATE2DMY(PayrollDate, 3) then
                L_StartDate := DMY2DATE(1, DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3))
            else
                if DATE2DMY(L_StartDate, 3) > DATE2DMY(PayrollDate, 3) then
                    exit(0)
                else
                    if L_StartDate > PayrollDate then
                        exit(0)
                    else begin
                        if DATE2DMY(L_StartDate, 2) <> DATE2DMY(PayrollDate, 2) then
                            L_StartDate := DMY2DATE(1, DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3));
                    end;

            if DATE2DMY(L_TillDate, 3) > DATE2DMY(PayrollDate, 3) then
                L_TillDate := PayrollDate
            else
                if DATE2DMY(L_TillDate, 3) < DATE2DMY(PayrollDate, 3) then
                    exit(0)
                /*else if (L_TerminationDate <> 0D) and (L_TerminationDate < PayrollDate) then
                  exit(0)*/
                else
                    L_TillDate := PayrollDate;
        end
        else begin
            if DATE2DMY(L_StartDate, 3) < DATE2DMY(PayrollDate, 3) then
                L_StartDate := DMY2DATE(1, 1, DATE2DMY(PayrollDate, 3))
            else
                if DATE2DMY(L_StartDate, 3) > DATE2DMY(PayrollDate, 3) then
                    exit(0)
                else
                    if L_StartDate > PayrollDate then
                        exit(0);

            if DATE2DMY(L_TillDate, 3) > DATE2DMY(PayrollDate, 3) then
                L_TillDate := PayrollDate
            else
                if DATE2DMY(L_TillDate, 3) < DATE2DMY(PayrollDate, 3) then
                    exit(0)
                /*else if (L_TerminationDate <> 0D) and (L_TerminationDate < PayrollDate) then
                  exit(0)*/
                else
                    L_TillDate := PayrollDate;
        end;
        // 14.07.2017 : A2+
        if (L_PayParameterTbt."MHOOD Retro Start Date" <> 0D) and ((NSSFType = NSSFType::MHOOD2) or (NSSFType = NSSFType::MHOOD7)) then BEGIN
            L_MonthCount := GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, PayrollDate, L_NSSFTypeCategory::MHOOD9);
            IF FORMAT(L_PayParameterTbt."Before Monthly Cont Date") <> '' THEN
                L_MonthCountBefore := ROUND(GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, L_PayParameterTbt."Before Monthly Cont Date", L_NSSFTypeCategory::MHOOD9), 0.1, '=')//20220611
            ELSE
                L_MonthCountBefore := 0;//20220719
            IF FORMAT(L_PayParameterTbt."Before Monthly Cont Date 2") <> '' then
                L_MonthCountBefore2 := ROUND(GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, L_PayParameterTbt."Before Monthly Cont Date 2", L_NSSFTypeCategory::MHOOD9), 0.1, '=')
                - ROUND(GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, L_PayParameterTbt."Before Monthly Cont Date", L_NSSFTypeCategory::MHOOD9), 0.1, '=')//20220722
            ELSE
                L_MonthCountBefore2 := 0;//20220719
        END
        else
            if (L_PayParameterTbt."Family Sub Retro Start Date" <> 0D) and (NSSFType = NSSFType::FAMSUB6) then begin
                L_MonthCount := GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, PayrollDate, L_NSSFTypeCategory::FAMSUB6);
                IF FORMAT(L_PayParameterTbt."Before Monthly Cont Date") <> '' THEN
                    L_MonthCountBefore := ROUND(GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, L_PayParameterTbt."Before Monthly Cont Date", L_NSSFTypeCategory::FAMSUB6), 0.1, '=')//20220611
                ELSE
                    L_MonthCountBefore := 0;
            END
            else
                if (L_PayParameterTbt."Family Sub Retro Start Date" <> 0D) and (NSSFType = NSSFType::FAMSUB6) then
                    L_MonthCount := GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, PayrollDate, L_NSSFTypeCategory::FAMSUB6)
                else
                    if (L_PayParameterTbt."Family Sub Retro Start Date" <> 0D) and (NSSFType = NSSFType::"EOS8.5") then
                        L_MonthCount := GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, PayrollDate, L_NSSFTypeCategory::"EOS8.5")
                    else
                        L_MonthCount := GetEmployeesNoOfNSSFDeclaredMonths(EmpNo, PayrollDate, L_NSSFTypeCategory::All);
        // 04.08.2017 : A2-
        // 14.07.2017 : A2-

        if (not UseRetro) and (L_MonthCount > 1) then
            L_MonthCount := 1;

        if UseRetro then begin
            L_PayrollLedgerEntryTbt.SETFILTER(Declared, '%1', L_PayrollLedgerEntryTbt.Declared::Declared);
            L_PayrollLedgerEntryTbt.SETFILTER(Period, '>=%1', 1);
            L_PayrollLedgerEntryTbt.SETRANGE("Tax Year", DATE2DMY(PayrollDate, 3));
            L_PayrollLedgerEntryTbt.SETRANGE("Employee No.", EmpNo);

            // 04.07.2017 : A2+
            if (L_PayParameterTbt."MHOOD Retro Start Date" <> 0D) and ((NSSFType = NSSFType::MHOOD2) or (NSSFType = NSSFType::MHOOD7)) then
                L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '%1..%2', L_PayParameterTbt."MHOOD Retro Start Date", PayrollDate - 1)
            else
                if (L_PayParameterTbt."Family Sub Retro Start Date" <> 0D) and (NSSFType = NSSFType::FAMSUB6) then
                    L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '%1..%2', L_PayParameterTbt."Family Sub Retro Start Date", PayrollDate - 1)
                else
                    if (L_PayParameterTbt."Family Sub Retro Start Date" <> 0D) and (NSSFType = NSSFType::"EOS8.5") then
                        L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '%1..%2', L_PayParameterTbt."EOS Retro Start Date", PayrollDate - 1)
                    else
                        L_PayrollLedgerEntryTbt.SETFILTER("Payroll Date", '<%1', PayrollDate);
            // 04.08.2017 : A2-
            if L_PayrollLedgerEntryTbt.FINDFIRST then
                repeat
                    L_TNSSF += L_PayrollLedgerEntryTbt."Total Salary for NSSF";
                until L_PayrollLedgerEntryTbt.NEXT = 0;
            if NSSFType <> NSSFType::"EOS8.5" then begin
                L_Val := CalculateNSSFContribution(TotalForNSSF + L_TNSSF, L_MonthCount, L_MonthCountBefore, L_MonthCountBefore2, NSSFType, L_EmpTbt."Posting Group");
                L_Val := L_Val - GetEmployeePaidNSSFContribution(EmpNo, PayrollDate, NSSFType);
            end
            else
                L_Val := CalculateNSSFContribution(TotalForNSSF, 1, 0, 0, NSSFType, L_EmpTbt."Posting Group");
        end
        else
            if not L_PayParameterTbt."Employ-Termination Affect NSSF" then
                L_Val := CalculateNSSFContribution(TotalForNSSF, 1, 0, 0, NSSFType, L_EmpTbt."Posting Group")
            else
                L_Val := CalculateNSSFContribution(TotalForNSSF, L_MonthCount, L_MonthCountBefore, L_MonthCountBefore2, NSSFType, L_EmpTbt."Posting Group");

        L_Val := ROUND(L_Val, GetNSSFPrecision(), '>');
        exit(L_Val);

    end;

    procedure PostSubPayrollRecords(RefCode: Code[20]; PostType: Option "Payroll Only","G/L Only",All) NoError: Boolean;
    var
        L_PayrollSubMain: Record "Payroll Sub Main";
        L_PayrollSubDetails: Record "Payroll Sub Details";
        L_NSSFOption: Option MHOOD9,FAMSUB6,"EOS8.5";
    begin
        if RefCode = '' then
            exit(true);
        L_PayrollSubMain.SETRANGE("Ref Code", RefCode);
        if not L_PayrollSubMain.FINDFIRST then
            exit(true);
        if L_PayrollSubMain.Status <> L_PayrollSubMain.Status::Approved then
            exit(true);
        if L_PayrollSubMain."Posting Status" = L_PayrollSubMain."Posting Status"::Posted then
            exit(true);
        if (L_PayrollSubMain."Posting Status" = L_PayrollSubMain."Posting Status"::Payroll) and (PostType = PostType::"Payroll Only") then
            exit(true);
        if (L_PayrollSubMain."Posting Status" = L_PayrollSubMain."Posting Status"::"G/L") and (PostType = PostType::"G/L Only") then
            exit(true);

        L_PayrollSubDetails.SETRANGE("Ref Code", RefCode);
        if not L_PayrollSubDetails.FINDFIRST then
            exit(false)
        else begin
            if not InsertSubPayrollPayDetailLine(RefCode) then exit(false);
            begin
                if not InsertSubPayrollIncomeTaxPayLine(RefCode) then exit(false);
                if not InsertSubPayrollNSSFContributionPayLine(RefCode, L_NSSFOption::MHOOD9) then exit(false);
                if not InsertSubPayrollNSSFContributionPayLine(RefCode, L_NSSFOption::FAMSUB6) then exit(false);
                if not InsertSubPayrollNSSFContributionPayLine(RefCode, L_NSSFOption::"EOS8.5") then exit(false);
                if not InsertSubPayrollPayLedgerEntry(RefCode) then exit(false);
                if (PostType = PostType::"G/L Only") or (PostType = PostType::All) then
                    if not InsertSubPayrollGLJournals(RefCode) then exit(false);
            end;
        end;

        exit(true);
    end;

    procedure InsertSubPayrollPayLedgerEntry(RefCode: Code[20]) NoError: Boolean;
    var
        L_PayLedgerEntry: Record "Payroll Ledger Entry";
        L_EntryNo: Integer;
        L_PayrollSubDetails: Record "Payroll Sub Details";
        L_EmpTbt: Record Employee;
        L_PayElement: Record "Pay Element";
        L_PayrollSubMain: Record "Payroll Sub Main";
        L_PayDetailLine: Record "Pay Detail Line";
        L_EmpNo: Code[20];
        L_NetPay: Decimal;
        L_TaxableAmount: Decimal;
        L_TotalForNSSF: Decimal;
        L_PaidTax: Decimal;
        L_MHOOD2: Decimal;
        L_MHOOD7: Decimal;
        L_FAMSUB6: Decimal;
        "L_EOS8.5": Decimal;
        L_PayParameter: Record "Payroll Parameter";
        L_NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5";
        L_Declared: Option " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        L_EmpDeclareTypeID: Integer;
    begin
        if RefCode = '' then exit(true);

        L_PayrollSubMain.SETRANGE("Ref Code", RefCode);
        if not L_PayrollSubMain.FINDFIRST then exit(true);

        L_PayLedgerEntry.SETRANGE("Sub Payroll Code", RefCode);
        if L_PayLedgerEntry.FINDFIRST then
            exit(true)

        else begin
            L_PayrollSubDetails.SETCURRENTKEY("Ref Code", "Employee No.");
            L_PayrollSubDetails.SETRANGE("Ref Code", RefCode);
            if L_PayrollSubDetails.FINDFIRST then
                repeat
                    if L_EmpNo <> L_PayrollSubDetails."Employee No." then begin
                        L_EmpNo := L_PayrollSubDetails."Employee No.";
                        L_TaxableAmount := 0;
                        L_TotalForNSSF := 0;
                        L_NetPay := 0;
                        L_PaidTax := 0;
                        L_MHOOD2 := 0;
                        L_MHOOD7 := 0;
                        L_FAMSUB6 := 0;
                        "L_EOS8.5" := 0;

                        L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                        L_EmpTbt.FINDFIRST;

                        L_PayDetailLine.RESET;
                        CLEAR(L_PayDetailLine);
                        L_PayDetailLine.SETRANGE("Sub Payroll Code", RefCode);
                        L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                        if L_PayDetailLine.FINDFIRST then
                            repeat
                                L_PayElement.SETRANGE(Code, L_PayDetailLine."Pay Element Code");
                                if L_PayElement.FINDFIRST then begin
                                    if L_PayElement.Type = L_PayElement.Type::Addition then
                                        L_NetPay += L_PayDetailLine."Calculated Amount"
                                    else
                                        L_NetPay := L_NetPay - L_PayDetailLine."Calculated Amount";

                                    if L_PayElement.Tax then
                                        if L_PayElement.Type = L_PayElement.Type::Addition then
                                            L_TaxableAmount += L_PayDetailLine."Calculated Amount"
                                        else
                                            L_TaxableAmount -= L_PayDetailLine."Calculated Amount";

                                    if L_PayElement."Affect NSSF" then
                                        if L_PayElement.Type = L_PayElement.Type::Addition then
                                            L_TotalForNSSF += L_PayDetailLine."Calculated Amount"
                                        else
                                            L_TotalForNSSF -= L_PayDetailLine."Calculated Amount";
                                end;
                            until L_PayDetailLine.NEXT = 0;
                        // Get Income Tax +
                        L_PayParameter.GET;
                        L_PayDetailLine.RESET;
                        CLEAR(L_PayDetailLine);
                        L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                        L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                        L_PayDetailLine.SETRANGE("Pay Element Code", L_PayParameter."Income Tax Code");
                        if L_PayDetailLine.FINDFIRST then
                            L_PaidTax := L_PayDetailLine."Calculated Amount";
                        // Get Income Tax -

                        // MHOOD 2% +
                        L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                        if L_EmpTbt.FINDFIRST then begin
                            L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                            L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                            L_PayDetailLine.SETRANGE("Pay Element Code", GetNSSFContributionPayElement(L_NSSFType::MHOOD2, L_EmpTbt."Posting Group"));
                            if L_PayDetailLine.FINDFIRST then
                                L_MHOOD2 := L_PayDetailLine."Calculated Amount";
                        end;
                        // MHOOD 2% -

                        // MHOOD 7% +
                        L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                        if L_EmpTbt.FINDFIRST then begin
                            L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                            L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                            L_PayDetailLine.SETRANGE("Pay Element Code", GetNSSFContributionPayElement(L_NSSFType::MHOOD7, L_EmpTbt."Posting Group"));
                            if L_PayDetailLine.FINDFIRST then
                                L_MHOOD7 := L_PayDetailLine."Calculated Amount";
                        end;
                        // MHOOD 7% -

                        // FAMSUB 6% +
                        L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                        if L_EmpTbt.FINDFIRST then begin
                            L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                            L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                            L_PayDetailLine.SETRANGE("Pay Element Code", GetNSSFContributionPayElement(L_NSSFType::FAMSUB6, L_EmpTbt."Posting Group"));
                            if L_PayDetailLine.FINDFIRST then
                                L_FAMSUB6 := L_PayDetailLine."Calculated Amount";
                        end;
                        // FAMSUB 6% -

                        // EOS 8.5% +
                        L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                        if L_EmpTbt.FINDFIRST then begin
                            L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                            L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                            L_PayDetailLine.SETRANGE("Pay Element Code", GetNSSFContributionPayElement(L_NSSFType::FAMSUB6, L_EmpTbt."Posting Group"));
                            if L_PayDetailLine.FINDFIRST then
                                "L_EOS8.5" := L_PayDetailLine."Calculated Amount";
                        end;
                        // EOS 8.5% -

                        //  Insert Payroll ledger entry Line +
                        L_PayLedgerEntry.RESET;
                        CLEAR(L_PayLedgerEntry);
                        if L_PayLedgerEntry.FINDLAST then
                            L_EntryNo := L_PayLedgerEntry."Entry No." + 1
                        else
                            L_EntryNo := 1;

                        L_PayLedgerEntry.INIT;
                        L_PayLedgerEntry."Entry No." := L_EntryNo;
                        L_PayLedgerEntry."Employee No." := L_PayrollSubDetails."Employee No.";
                        L_PayLedgerEntry."Payroll Date" := L_PayrollSubMain."Pay Date";
                        L_PayLedgerEntry."Period Start Date" := L_PayrollSubMain."Pay Date";
                        L_PayLedgerEntry."Period End Date" := L_PayrollSubMain."Pay Date";
                        L_PayLedgerEntry."Posting Date" := L_PayrollSubMain."Pay Date";
                        L_PayLedgerEntry."Tax Year" := DATE2DMY(L_PayrollSubMain."Pay Date", 3);
                        L_PayLedgerEntry.Period := DATE2DMY(L_PayrollSubMain."Pay Date", 2);
                        L_PayLedgerEntry.Open := false;
                        L_PayLedgerEntry."Gross Pay" := L_NetPay + L_PaidTax + L_MHOOD2;
                        L_PayLedgerEntry."Taxable Pay" := L_TaxableAmount;
                        L_PayLedgerEntry."Total Salary for NSSF" := L_TotalForNSSF;
                        L_PayLedgerEntry."Sub Payroll Code" := L_PayrollSubMain."Ref Code";
                        L_PayLedgerEntry."Document No." := L_PayrollSubMain."Document No.";
                        L_PayLedgerEntry.Description := L_PayrollSubMain.Description;

                        L_EmpDeclareTypeID := GetEmployeeDeclaredTypeIDForPeriod(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date");
                        if L_EmpDeclareTypeID = 1 then
                            L_PayLedgerEntry.Declared := L_PayLedgerEntry.Declared::Declared
                        else
                            if L_EmpDeclareTypeID = 3 then
                                L_PayLedgerEntry.Declared := L_PayLedgerEntry.Declared::Contractual
                            else
                                if L_EmpDeclareTypeID = 4 then
                                    L_PayLedgerEntry.Declared := L_PayLedgerEntry.Declared::"Non-NSSF"
                                else
                                    L_PayLedgerEntry.Declared := L_PayLedgerEntry.Declared::"Non-Declared";

                        if L_PayrollSubMain."Include Exemption" = true then
                            L_PayLedgerEntry."Free Pay" := GetEmployeeFreePayForPeriod(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date");

                        L_PayLedgerEntry."Tax Paid" := L_PaidTax;
                        L_PayLedgerEntry."Employee Pension" := L_MHOOD2;
                        L_PayLedgerEntry."Employer EOSIND" := "L_EOS8.5";
                        L_PayLedgerEntry."Employer Family Subscription" := L_FAMSUB6;
                        L_PayLedgerEntry."Employer Pension" := L_MHOOD7;
                        L_PayLedgerEntry."First Name" := L_EmpTbt."First Name";
                        L_PayLedgerEntry."Last Name" := L_EmpTbt."Last Name";
                        L_PayLedgerEntry."Payroll Group Code" := L_EmpTbt."Payroll Group Code";
                        L_PayLedgerEntry."Net Pay" := L_NetPay;
                        L_PayLedgerEntry."Exchange Rate" := 1;
                        L_PayLedgerEntry."Basic Salary" := L_EmpTbt."Basic Pay";
                        L_PayLedgerEntry."Shortcut Dimension 1 Code" := L_EmpTbt."Global Dimension 1 Code";
                        L_PayLedgerEntry."Shortcut Dimension 2 Code" := L_EmpTbt."Global Dimension 2 Code";
                        L_PayLedgerEntry."Employment Type Code" := L_EmpTbt."Employment Type Code";
                        L_PayLedgerEntry."Spouse Secured" := L_EmpTbt."Spouse Secured";
                        L_PayLedgerEntry."Bank No." := L_EmpTbt."Bank No.";
                        L_PayLedgerEntry."Job Title" := L_EmpTbt."Job Title";
                        L_PayLedgerEntry."Job Position Code" := L_EmpTbt."Job Position Code";
                        // 27.02.2018 : A2+
                        L_PayLedgerEntry."Payment Method" := L_EmpTbt."Payment Method";
                        L_PayLedgerEntry."Payment Method (ACY)" := L_EmpTbt."Payment Method (ACY)";
                        // 27.02.2018 : A2-
                        L_PayLedgerEntry.INSERT;
                        //  Insert Payroll ledger entry Line -
                    end;
                until L_PayrollSubDetails.NEXT = 0;

        end;
        // Update Payroll ledger entry No. in Pay detail line +
        L_PayDetailLine.RESET;
        CLEAR(L_PayDetailLine);
        L_PayLedgerEntry.RESET;
        CLEAR(L_PayLedgerEntry);
        L_PayLedgerEntry.SETRANGE("Sub Payroll Code", RefCode);
        if L_PayLedgerEntry.FINDFIRST then
            repeat
                L_PayDetailLine.RESET;
                CLEAR(L_PayDetailLine);
                L_PayDetailLine.SETRANGE("Employee No.", L_PayLedgerEntry."Employee No.");
                L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayLedgerEntry."Sub Payroll Code");
                if L_PayDetailLine.FINDFIRST then
                    repeat
                        L_PayDetailLine."Payroll Ledger Entry No." := L_PayLedgerEntry."Entry No.";
                        L_PayDetailLine.MODIFY;
                    until L_PayDetailLine.NEXT = 0;
            until L_PayLedgerEntry.NEXT = 0;

        // Update Payroll ledger entry No. in Pay detail line -
        exit(true);
    end;

    procedure InsertSubPayrollPayDetailLine(RefCode: Code[20]) NoError: Boolean;
    var
        L_PayDetailLine: Record "Pay Detail Line";
        L_PayrollSubMain: Record "Payroll Sub Main";
        L_Seq: Integer;
        L_PayrollSubDetails: Record "Payroll Sub Details";
        L_EmpTbt: Record Employee;
        L_PayElementTbt: Record "Pay Element";
        L_LineNo: Integer;
    begin
        if RefCode = '' then exit(true);
        L_PayrollSubMain.SETRANGE("Ref Code", RefCode);
        if L_PayrollSubMain.FINDFIRST then begin
            L_PayrollSubDetails.SETRANGE("Ref Code", RefCode);
            if L_PayrollSubDetails.FINDFIRST then
                repeat
                    L_PayDetailLine.RESET;
                    CLEAR(L_PayDetailLine);
                    L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                    L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                    L_PayDetailLine.SETRANGE("Pay Element Code", L_PayrollSubDetails."Pay Element Code");
                    if not L_PayDetailLine.FINDFIRST then begin
                        L_PayElementTbt.SETRANGE(Code, L_PayrollSubDetails."Pay Element Code");
                        if L_PayElementTbt.FINDFIRST then begin
                            L_PayDetailLine.RESET;
                            CLEAR(L_PayDetailLine);
                            L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                            if L_PayDetailLine.FINDLAST then
                                L_LineNo := L_PayDetailLine."Line No." + 1
                            else
                                L_LineNo := 1;
                            L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                            if L_EmpTbt.FINDFIRST then begin
                                L_PayDetailLine.INIT;
                                L_PayDetailLine."Employee No." := L_PayrollSubDetails."Employee No.";
                                L_PayDetailLine."Line No." := L_LineNo;
                                L_PayDetailLine."Tax Year" := DATE2DMY(L_PayrollSubMain."Pay Date", 3);
                                L_PayDetailLine.Period := DATE2DMY(L_PayrollSubMain."Pay Date", 2);
                                L_PayDetailLine."Payroll Date" := L_PayrollSubMain."Pay Date";
                                L_PayDetailLine."Pay Frequency" := L_EmpTbt."Pay Frequency";
                                L_PayDetailLine."Pay Element Code" := L_PayrollSubDetails."Pay Element Code";
                                L_PayDetailLine.Description := L_PayElementTbt.Description;
                                L_PayDetailLine.Type := L_PayElementTbt.Type;
                                L_PayDetailLine.Recurring := false;
                                L_PayDetailLine.Open := false;
                                L_PayDetailLine."Payroll Special Code" := L_PayElementTbt."Payroll Special Code";
                                L_PayDetailLine."Not Included in Net Pay" := L_PayElementTbt."Not Included in Net Pay";
                                L_PayDetailLine."Shortcut Dimension 1 Code" := L_EmpTbt."Global Dimension 1 Code";
                                L_PayDetailLine."Shortcut Dimension 2 Code" := L_EmpTbt."Global Dimension 2 Code";
                                L_PayDetailLine."Payroll Group Code" := L_EmpTbt."Payroll Group Code";
                                L_PayDetailLine."Exchange Rate" := 1;
                                L_PayDetailLine.Amount := L_PayrollSubDetails."Amount (LCY)";
                                L_PayDetailLine."Calculated Amount" := L_PayrollSubDetails."Amount (LCY)";
                                L_PayDetailLine."Sub Payroll Code" := L_PayrollSubMain."Ref Code";
                                L_PayDetailLine.INSERT;
                            end;
                        end;
                    end;
                until L_PayrollSubDetails.NEXT = 0;
        end;

        exit(true);
    end;

    procedure InsertSubPayrollGLJournals(RefCode: Code[20]) NoError: Boolean;
    var
        L_FinalizeEmpPay: Codeunit "Finalize Employee Pay";
        L_PayStatuse: Record "Payroll Status";
        L_FinalizeEmpPayByDim: Codeunit "Finalize Employee Pay By Dim.";
    begin
        PayParam.GET;
        if PayParam."Payroll Finalize Type" = PayParam."Payroll Finalize Type"::Default then
            L_FinalizeEmpPay.FinalizeEmployeePay(L_PayStatuse, false, RefCode)
        else
            L_FinalizeEmpPayByDim.FinalizeEmployeePay(L_PayStatuse, false, RefCode, false);

        exit(true);
    end;

    procedure InsertSubPayrollIncomeTaxPayLine(RefCode: Code[20]) NoError: Boolean;
    var
        L_EmpNo: Code[20];
        L_PayDetailLine: Record "Pay Detail Line";
        L_PayrollSubDetails: Record "Payroll Sub Details";
        L_PayrollSubDetails2: Record "Payroll Sub Details";
        L_PayrollSubMain: Record "Payroll Sub Main";
        L_PayElement: Record "Pay Element";
        L_PayrollParameter: Record "Payroll Parameter";
        L_TaxableAmount: Decimal;
        L_UseRetro: Boolean;
        L_FreePay: Decimal;
        L_Tax: Decimal;
        L_DeclaredTypeID: Integer;
        L_PayElementTbt: Record "Pay Element";
        L_LineNo: Integer;
        L_EmpTbt: Record Employee;
    begin
        if RefCode = '' then exit(true);
        //L_UseRetro := FALSE;//A2+-
        L_PayrollParameter.GET();
        if L_PayrollParameter."Income Tax Code" = '' then exit(true);
        L_UseRetro := not L_PayrollParameter."No Income Tax Retro";

        L_PayrollSubMain.SETRANGE("Ref Code", RefCode);
        if L_PayrollSubMain.FINDFIRST then begin
            if not L_PayrollSubMain."Calculate Income Tax" then exit(true);

            L_PayrollSubDetails.SETRANGE("Ref Code", RefCode);
            if L_PayrollSubDetails.FINDFIRST then
                repeat
                    if GetEmployeeDeclaredTypeIDForPeriod(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date") <> 2 then // Non-Declared
                      begin
                        L_PayDetailLine.RESET;
                        CLEAR(L_PayDetailLine);
                        L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                        L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                        L_PayDetailLine.SETRANGE("Pay Element Code", L_PayrollParameter."Income Tax Code");
                        if not L_PayDetailLine.FINDFIRST then begin
                            L_EmpNo := '';
                            L_TaxableAmount := 0;
                            L_PayrollSubDetails.RESET;
                            CLEAR(L_PayrollSubDetails);
                            L_PayrollSubDetails.SETCURRENTKEY("Ref Code", "Employee No.");
                            L_PayrollSubDetails.SETRANGE("Ref Code", L_PayrollSubMain."Ref Code");
                            if L_PayrollSubDetails.FINDFIRST then
                                repeat
                                    if L_EmpNo <> L_PayrollSubDetails."Employee No." then begin
                                        L_EmpNo := L_PayrollSubDetails."Employee No.";
                                        L_FreePay := 0;
                                        L_TaxableAmount := 0;
                                        L_Tax := 0;
                                        L_DeclaredTypeID := 0;
                                        L_PayrollSubDetails2.RESET;
                                        CLEAR(L_PayrollSubDetails2);
                                        L_PayrollSubDetails2.SETRANGE("Ref Code", L_PayrollSubDetails."Ref Code");
                                        L_PayrollSubDetails2.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                                        if L_PayrollSubDetails2.FINDFIRST then
                                            repeat
                                                L_PayElement.RESET;
                                                CLEAR(L_PayElement);
                                                L_PayElement.SETRANGE(Code, L_PayrollSubDetails2."Pay Element Code");
                                                if L_PayElement.FINDFIRST then begin
                                                    if L_PayElement.Tax = true then begin
                                                        if L_PayElement.Type = L_PayElement.Type::Addition then
                                                            L_TaxableAmount += L_PayrollSubDetails2."Amount (LCY)"
                                                        else
                                                            L_TaxableAmount -= L_PayrollSubDetails2."Amount (LCY)";
                                                    end;
                                                end;
                                            until L_PayrollSubDetails2.NEXT = 0;
                                        L_DeclaredTypeID := GetEmployeeDeclaredTypeIDForPeriod(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date");
                                        if L_DeclaredTypeID = 2 then // Non-Declared
                                            L_TaxableAmount := 0;

                                        if L_TaxableAmount > 0 then begin
                                            if L_DeclaredTypeID = 3 then // Contractual
                                                L_Tax := (L_TaxableAmount * L_PayrollParameter."Contractual Tax %") / 100
                                            else begin
                                                if L_PayrollSubMain."Include Exemption" = true then
                                                    L_FreePay := GetEmployeeFreePayForPeriod(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date");
                                                L_Tax := CalculateEmployeeIncomeTax(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date", L_TaxableAmount, L_FreePay, L_UseRetro);
                                            end;
                                            if L_Tax < 0 then
                                                if L_PayrollParameter."Discard Negative Income Tax" = false then
                                                    L_Tax := 0;
                                            if L_Tax <> 0 then begin
                                                L_PayElementTbt.RESET;
                                                CLEAR(L_PayElementTbt);
                                                L_PayElementTbt.SETRANGE(Code, L_PayrollParameter."Income Tax Code");
                                                if L_PayElementTbt.FINDFIRST then begin
                                                    L_PayDetailLine.RESET;
                                                    CLEAR(L_PayDetailLine);
                                                    L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                                                    if L_PayDetailLine.FINDLAST then
                                                        L_LineNo := L_PayDetailLine."Line No." + 1
                                                    else
                                                        L_LineNo := 1;
                                                    L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                                                    if L_EmpTbt.FINDFIRST then begin
                                                        L_PayDetailLine.INIT;
                                                        L_PayDetailLine."Employee No." := L_PayrollSubDetails."Employee No.";
                                                        L_PayDetailLine."Line No." := L_LineNo;
                                                        L_PayDetailLine."Tax Year" := DATE2DMY(L_PayrollSubMain."Pay Date", 3);
                                                        L_PayDetailLine.Period := DATE2DMY(L_PayrollSubMain."Pay Date", 2);
                                                        L_PayDetailLine."Payroll Date" := L_PayrollSubMain."Pay Date";
                                                        L_PayDetailLine."Pay Frequency" := L_EmpTbt."Pay Frequency";
                                                        L_PayDetailLine."Pay Element Code" := L_PayrollParameter."Income Tax Code";
                                                        L_PayDetailLine.Description := L_PayElementTbt.Description;
                                                        L_PayDetailLine.Type := L_PayElementTbt.Type;
                                                        L_PayDetailLine.Recurring := false;
                                                        L_PayDetailLine.Open := false;
                                                        L_PayDetailLine.Amount := L_Tax;
                                                        L_PayDetailLine."Payroll Special Code" := L_PayElementTbt."Payroll Special Code";
                                                        L_PayDetailLine."Not Included in Net Pay" := L_PayElementTbt."Not Included in Net Pay";
                                                        L_PayDetailLine."Shortcut Dimension 1 Code" := L_EmpTbt."Global Dimension 1 Code";
                                                        L_PayDetailLine."Shortcut Dimension 2 Code" := L_EmpTbt."Global Dimension 2 Code";
                                                        L_PayDetailLine."Payroll Group Code" := L_EmpTbt."Payroll Group Code";
                                                        L_PayDetailLine."Exchange Rate" := Paystatus."Exchange Rate";
                                                        L_PayDetailLine."Calculated Amount" := L_Tax;
                                                        L_PayDetailLine."Sub Payroll Code" := L_PayrollSubMain."Ref Code";
                                                        L_PayDetailLine.INSERT;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                until L_PayrollSubDetails.NEXT = 0;
                        end;
                    end;
                until L_PayrollSubDetails.NEXT = 0;
        end;

        exit(true);
    end;

    procedure GetEmployeeDeclaredTypeIDForPeriod(EmpNo: Code[20]; PayDate: Date) L_Val: Integer;
    var
        L_EmpTbt: Record Employee;
        L_PayStatus: Record "Payroll Status";
        L_PayLedgerEntry: Record "Payroll Ledger Entry";
    begin
        // Declared = 1,Non-Declared = 2,Contractuar = 3,Non-NSSF = 4
        if (EmpNo = '') or (PayDate = 0D) then exit(2);

        L_EmpTbt.SETRANGE("No.", EmpNo);
        if not L_EmpTbt.FINDFIRST then exit(2);
        if L_EmpTbt."Payroll Group Code" = '' then exit(2);

        L_PayStatus.SETRANGE("Payroll Group Code", L_EmpTbt."Payroll Group Code");
        if L_PayStatus.FINDFIRST then begin
            if (PayDate > L_PayStatus."Period Start Date") then // < 23.05.2017 : A2+-
              begin
                if L_EmpTbt.Declared = L_EmpTbt.Declared::Declared then
                    exit(1)
                else
                    if L_EmpTbt.Declared = L_EmpTbt.Declared::Contractual then
                        exit(3)
                    else
                        if L_EmpTbt.Declared = L_EmpTbt.Declared::"Non-NSSF" then
                            exit(4)
                        else
                            exit(2);
            end
            else begin
                L_PayLedgerEntry.SETCURRENTKEY("Employee No.", "Payroll Date");
                L_PayLedgerEntry.SETFILTER(Period, '=%1', DATE2DMY(PayDate, 2));
                L_PayLedgerEntry.SETRANGE("Tax Year", DATE2DMY(PayDate, 3));
                L_PayLedgerEntry.SETRANGE("Employee No.", EmpNo);
                L_PayLedgerEntry.SETRANGE("Sub Payroll Code", '');
                if L_PayLedgerEntry.FINDLAST then begin
                    if L_PayLedgerEntry."Posting Date" <> 0D then begin
                        if L_PayLedgerEntry.Declared = L_PayLedgerEntry.Declared::Declared then
                            exit(1)
                        else
                            if L_PayLedgerEntry.Declared = L_PayLedgerEntry.Declared::Contractual then
                                exit(3)
                            else
                                if L_PayLedgerEntry.Declared = L_PayLedgerEntry.Declared::"Non-NSSF" then
                                    exit(4)
                                else
                                    exit(2);
                    end
                    else begin
                        if L_EmpTbt.Declared = L_EmpTbt.Declared::Declared then
                            exit(1)
                        else
                            if L_EmpTbt.Declared = L_EmpTbt.Declared::Contractual then
                                exit(3)
                            else
                                if L_EmpTbt.Declared = L_EmpTbt.Declared::"Non-NSSF" then
                                    exit(4)
                                else
                                    exit(2);
                    end;
                end
                else begin
                    if L_EmpTbt.Declared = L_EmpTbt.Declared::Declared then
                        exit(1)
                    else
                        if L_EmpTbt.Declared = L_EmpTbt.Declared::Contractual then
                            exit(3)
                        else
                            if L_EmpTbt.Declared = L_EmpTbt.Declared::"Non-NSSF" then
                                exit(4)
                            else
                                exit(2);
                end;
            end;
        end
        else begin
            if L_EmpTbt.Declared = L_EmpTbt.Declared::Declared then
                exit(1)
            else
                if L_EmpTbt.Declared = L_EmpTbt.Declared::Contractual then
                    exit(3)
                else
                    if L_EmpTbt.Declared = L_EmpTbt.Declared::"Non-NSSF" then
                        exit(4)
                    else
                        exit(2);
        end;
        exit(2);
    end;

    procedure GetEmployeeFreePayForPeriod(EmpNo: Code[20]; PayDate: Date) L_Val: Decimal;
    var
        L_Emptbt: Record Employee;
        L_PayLedgerEntry: Record "Payroll Ledger Entry";
        L_PayStatus: Record "Payroll Status";
        L_EmpDefFreePay: Decimal;
        L_SpouseExemptTax: Boolean;
    begin
        // Declared = 1,Non-Declared = 2,Contractuar = 3,Non-NSSF = 4
        if (EmpNo = '') or (PayDate = 0D) then exit(0);

        L_Emptbt.SETRANGE("No.", EmpNo);
        if not L_Emptbt.FINDFIRST then exit(0);
        if L_Emptbt."Payroll Group Code" = '' then exit(0);
        L_EmpDefFreePay := CalculateTaxCode(L_Emptbt, true, L_SpouseExemptTax, PayDate) / 12;
        if IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
            L_EmpDefFreePay := L_EmpDefFreePay * (GetEmployeeTaxDays(EmpNo, DATE2DMY(PayDate, 3), DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 2))
                               / GetDaysInMonth(DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3)));
            L_EmpDefFreePay := ROUND(L_EmpDefFreePay, 0.01);
        end;

        L_PayStatus.SETRANGE("Payroll Group Code", L_Emptbt."Payroll Group Code");
        if L_PayStatus.FINDFIRST then begin
            if (PayDate < L_PayStatus."Period Start Date") then //18.05.2017 : A2+-
              begin
                exit(L_EmpDefFreePay);
            end
            else begin
                L_PayLedgerEntry.SETCURRENTKEY("Employee No.", "Payroll Date");
                L_PayLedgerEntry.SETFILTER(Period, '=%1', DATE2DMY(PayDate, 2));
                L_PayLedgerEntry.SETRANGE("Tax Year", DATE2DMY(PayDate, 3));
                L_PayLedgerEntry.SETRANGE("Employee No.", EmpNo);
                L_PayLedgerEntry.SETRANGE("Sub Payroll Code", '');
                if L_PayLedgerEntry.FINDLAST then begin
                    if L_PayLedgerEntry."Posting Date" <> 0D then
                        exit(L_PayLedgerEntry."Free Pay")
                    else begin
                        if DATE2DMY(PayDate, 2) <> GetLastDayinMonth(PayDate) then begin
                            exit((DATE2DMY(PayDate, 1) * L_EmpDefFreePay) / GetEmployeeTaxDays(EmpNo, DATE2DMY(PayDate, 3), DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 2)))
                        end
                        else
                            exit(L_EmpDefFreePay);
                    end;
                end
                else begin
                    if DATE2DMY(PayDate, 2) <> GetLastDayinMonth(PayDate) then begin
                        exit((DATE2DMY(PayDate, 1) * L_EmpDefFreePay) / GetEmployeeTaxDays(EmpNo, DATE2DMY(PayDate, 3), DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 2)))
                    end
                    else
                        exit(L_EmpDefFreePay);
                end;
            end;
        end
        else begin
            exit(L_EmpDefFreePay);
        end;
        exit(0);
    end;

    procedure InsertSubPayrollNSSFContributionPayLine(RefCode: Code[20]; NSSFOption: Option MHOOD9,FAMSUB6,"EOS8.5") NoError: Boolean;
    var
        L_EmpNo: Code[20];
        L_PayDetailLine: Record "Pay Detail Line";
        L_PayrollSubDetails: Record "Payroll Sub Details";
        L_PayrollSubDetails2: Record "Payroll Sub Details";
        L_PayrollSubMain: Record "Payroll Sub Main";
        L_PensionScheme: Record "Pension Scheme";
        L_UseRetro: Boolean;
        L_EmpTbt: Record Employee;
        L_PayElement: Code[20];
        L_DeclaredTypeID: Integer;
        L_TotalForNSSF: Decimal;
        L_NSSF: Decimal;
        L_PayElementTbt: Record "Pay Element";
        L_PayParameter: Record "Payroll Parameter";
        L_NSSFEmployee: Decimal;
        L_NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5";
        L_LineNo: Integer;
        L_PayLedgerEntry: Record "Payroll Ledger Entry";
    begin
        if RefCode = '' then exit(true);
        L_UseRetro := false;
        L_PayParameter.GET();
        L_UseRetro := not L_PayParameter."No Pension Retro";
        L_PayrollSubMain.SETRANGE("Ref Code", RefCode);
        if L_PayrollSubMain.FINDFIRST then begin
            if not L_PayrollSubMain."Calculate NSSF Contributions" then exit(true);

            L_PayrollSubDetails.SETRANGE("Ref Code", RefCode);
            if L_PayrollSubDetails.FINDFIRST then
                repeat
                    if GetEmployeeDeclaredTypeIDForPeriod(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date") = 1 then // Declared
                      begin
                        L_EmpTbt.RESET;
                        CLEAR(L_EmpTbt);
                        L_EmpTbt.SETRANGE("No.", L_PayrollSubDetails."Employee No.");
                        if L_EmpTbt.FINDFIRST then begin
                            L_PayElement := GetNSSFContributionPayElement(NSSFOption, L_EmpTbt."Posting Group");
                        end;
                        L_PayDetailLine.RESET;
                        CLEAR(L_PayDetailLine);
                        L_PayDetailLine.SETRANGE("Sub Payroll Code", L_PayrollSubDetails."Ref Code");
                        L_PayDetailLine.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                        L_PayDetailLine.SETRANGE("Pay Element Code", L_PayElement);
                        if not L_PayDetailLine.FINDFIRST then begin
                            L_EmpNo := '';
                            L_TotalForNSSF := 0;
                            if L_EmpNo <> L_PayrollSubDetails."Employee No." then begin
                                L_EmpNo := L_PayrollSubDetails."Employee No.";
                                L_TotalForNSSF := 0;
                                L_NSSF := 0;
                                L_DeclaredTypeID := 0;
                                L_PayrollSubDetails2.RESET;
                                CLEAR(L_PayrollSubDetails2);
                                L_PayrollSubDetails2.SETRANGE("Ref Code", L_PayrollSubDetails."Ref Code");
                                L_PayrollSubDetails2.SETRANGE("Employee No.", L_PayrollSubDetails."Employee No.");
                                if L_PayrollSubDetails2.FINDFIRST then
                                    repeat
                                        L_PayElementTbt.RESET;
                                        CLEAR(L_PayElementTbt);
                                        L_PayElementTbt.SETRANGE(Code, L_PayrollSubDetails2."Pay Element Code");
                                        if L_PayElementTbt.FINDFIRST then begin
                                            if L_PayElementTbt."Affect NSSF" = true then begin
                                                if L_PayElementTbt.Type = L_PayElementTbt.Type::Addition then
                                                    L_TotalForNSSF += L_PayrollSubDetails2."Amount (LCY)"
                                                else
                                                    L_TotalForNSSF -= L_PayrollSubDetails2."Amount (LCY)";
                                            end;
                                        end;
                                    until L_PayrollSubDetails2.NEXT = 0;
                                L_DeclaredTypeID := GetEmployeeDeclaredTypeIDForPeriod(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date");
                                if L_DeclaredTypeID <> 1 then // Declared
                                    L_TotalForNSSF := 0;

                                if L_TotalForNSSF > 0 then begin
                                    if NSSFOption = NSSFOption::"EOS8.5" then begin
                                        L_NSSF := CalculateEmployeeNSSFContribution(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date", L_TotalForNSSF, L_NSSFType::"EOS8.5", false);
                                        L_NSSFEmployee := 0;
                                    end
                                    else
                                        if NSSFOption = NSSFOption::FAMSUB6 then begin
                                            L_NSSF := CalculateEmployeeNSSFContribution(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date", L_TotalForNSSF, L_NSSFType::FAMSUB6, L_UseRetro);
                                            L_NSSFEmployee := 0;
                                        end
                                        else
                                            if NSSFOption = NSSFOption::MHOOD9 then begin
                                                L_NSSF := CalculateEmployeeNSSFContribution(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date", L_TotalForNSSF, L_NSSFType::MHOOD7, L_UseRetro);
                                                L_NSSFEmployee := CalculateEmployeeNSSFContribution(L_PayrollSubDetails."Employee No.", L_PayrollSubMain."Pay Date", L_TotalForNSSF, L_NSSFType::MHOOD2, L_UseRetro);
                                            end;
                                    if L_NSSF > 0 then begin
                                        L_PayElementTbt.RESET;
                                        CLEAR(L_PayElementTbt);
                                        L_PayElementTbt.SETRANGE(Code, L_PayElement);
                                        if L_PayElementTbt.FINDFIRST then begin
                                            L_PayDetailLine.RESET;
                                            CLEAR(L_PayDetailLine);
                                            L_PayDetailLine.SETRANGE("Employee No.", L_EmpTbt."No.");
                                            if L_PayDetailLine.FINDLAST then
                                                L_LineNo := L_PayDetailLine."Line No." + 1
                                            else
                                                L_LineNo := 1;
                                            L_PayDetailLine.INIT;
                                            L_PayDetailLine."Employee No." := L_PayrollSubDetails."Employee No.";
                                            L_PayDetailLine."Line No." := L_LineNo;
                                            L_PayDetailLine."Tax Year" := DATE2DMY(L_PayrollSubMain."Pay Date", 3);
                                            L_PayDetailLine.Period := DATE2DMY(L_PayrollSubMain."Pay Date", 2);
                                            L_PayDetailLine."Payroll Date" := L_PayrollSubMain."Pay Date";
                                            L_PayDetailLine."Pay Frequency" := L_EmpTbt."Pay Frequency";
                                            L_PayDetailLine."Pay Element Code" := L_PayElement;
                                            L_PayDetailLine.Description := L_PayElementTbt.Description;
                                            L_PayDetailLine.Type := L_PayElementTbt.Type;
                                            L_PayDetailLine.Recurring := false;
                                            L_PayDetailLine.Open := false;
                                            L_PayDetailLine.Amount := L_NSSFEmployee;
                                            L_PayDetailLine."Payroll Special Code" := L_PayElementTbt."Payroll Special Code";
                                            L_PayDetailLine."Not Included in Net Pay" := L_PayElementTbt."Not Included in Net Pay";
                                            L_PayDetailLine."Shortcut Dimension 1 Code" := L_EmpTbt."Global Dimension 1 Code";
                                            L_PayDetailLine."Shortcut Dimension 2 Code" := L_EmpTbt."Global Dimension 2 Code";
                                            L_PayDetailLine."Payroll Group Code" := L_EmpTbt."Payroll Group Code";
                                            L_PayDetailLine."Exchange Rate" := Paystatus."Exchange Rate";
                                            L_PayDetailLine."Calculated Amount" := L_NSSFEmployee;
                                            L_PayDetailLine."Employer Amount" := L_NSSF;
                                            L_PayDetailLine."Sub Payroll Code" := L_PayrollSubMain."Ref Code";
                                            L_PayDetailLine.INSERT;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                until L_PayrollSubDetails.NEXT = 0;
        end;

        exit(true);

    end;

    procedure GetEmployeeTillDateGLBalance(DateFrom: Date; DateTo: Date; EmployeeCode: Code[20]; EmployeeDimension: Code[20]; var GLBalanceAdditional: Decimal) GLBalance: Decimal;
    begin
        GLBalance := 0;
        GLBalanceAdditional := 0;
        DimensionSetEntry.RESET;
        DimensionSetEntry.SETRANGE("Dimension Code", EmployeeDimension);
        DimensionSetEntry.SETRANGE("Dimension Value Code", EmployeeCode);

        if DimensionSetEntry.FINDFIRST then
            repeat
                GLEntry.RESET;
                GLEntry.CALCFIELDS("Exclude from Employee Stmt");
                GLEntry.SETCURRENTKEY("Posting Date", "Dimension Set ID");
                GLEntry.SETRANGE("Exclude from Employee Stmt", false);
                GLEntry.SETRANGE("Posting Date", DateFrom, DateTo);
                GLEntry.SETRANGE("Dimension Set ID", DimensionSetEntry."Dimension Set ID");
                GLEntry.CALCSUMS(Amount, "Additional-Currency Amount");
                GLBalance := GLBalance + GLEntry.Amount;
                GLBalanceAdditional := GLBalanceAdditional + GLEntry."Additional-Currency Amount";
            until DimensionSetEntry.NEXT = 0;
        exit(GLBalance);
    end;

    procedure GetEmpAbsenceEntitlementValue(EmpNo: Code[20]; AbsEntitleCode: Code[10]; Entitledate: Date; EntitleTillDate: Date; EntitleType: Option "Interval Basis","Yearly Basis","Employment Basis"; ClonePrevDateInterval: Boolean) V: Decimal;
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        AbsEntitleBandsTBT: Record "Absence Entitlement";
        EmpTBT: Record Employee;
        AllowGenerate: Boolean;
        DefEntitleValue: Decimal;
        PeriodType: DateFormula;
        FUnitD: Decimal;
        TUnitD: Decimal;
        DaysPerMonth: Decimal;
        FilterNbOfDays: Decimal;
        FDate: Date;
        TDate: Date;
        HRSetupTbt: Record "Human Resources Setup";
        EmptyDateFormula: DateFormula;
        AbsEntitleVal: Decimal;
        AbsEntitleAllowedToTransfer: Decimal;
        YearsofService: Decimal;
        EntitleBandExist: Boolean;
        DayDiff: Integer;
        EntitleYear: Integer;
        L_EmployDate: Date;
    begin
        HRSetupTbt.GET();
        if Entitledate = 0D then exit(0);
        EntitleYear := DATE2DMY(Entitledate, 3);

        if (EmpNo = '') or (AbsEntitleCode = '') then
            exit;

        if ClonePrevDateInterval then begin
            EmpAbsEntitleTBT.RESET();
            EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
            EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
            if EmpAbsEntitleTBT.FINDFIRST then begin
                repeat // Get the last entitlement year which is generated for the employee
                    if FDate < EmpAbsEntitleTBT."From Date" then
                        FDate := EmpAbsEntitleTBT."From Date";
                    if TDate < EmpAbsEntitleTBT."Till Date" then
                        TDate := EmpAbsEntitleTBT."Till Date";
                until EmpAbsEntitleTBT.NEXT = 0;

                if TDate <> 0D then // if there are entitlement generated for the previous years,then the new entitlement record will be for the interval [To date of the Last record + 1D] .. [[To date of the Last record + 1D] + 1Y]
                  begin
                    FDate := CALCDATE('1D', TDate);
                    TDate := CALCDATE('1Y', FDate);
                    TDate := CALCDATE('-1D', TDate);
                    DayDiff := TDate - FDate;
                    if EntitleYear > 0 then begin
                        FDate := DMY2DATE(DATE2DMY(FDate, 1), DATE2DMY(FDate, 2), EntitleYear);
                        TDate := FDate + DayDiff;
                    end;
                end;
            end;
        end;

        if (FDate = 0D) or (TDate = 0D) then // if no entitlement record exists then
          begin
            if EntitleType = EntitleType::"Yearly Basis" then // Yearly basis means that the entitlement is given from 1/1/YYYY till 31/12/YYYY
              begin
                FDate := DMY2DATE(1, 1, EntitleYear);
                TDate := DMY2DATE(31, 12, EntitleYear);
            end
            else
                if EntitleType = EntitleType::"Employment Basis" then // Employment basis means that the first entitlement year will be [Employment Date] .. [Employment Date + 1Y]
             begin
                    CLEAR(EmpTBT);
                    EmpTBT.RESET;
                    EmpTBT.SETRANGE("No.", EmpNo);
                    if EmpTBT.FINDFIRST then begin
                        if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then // If it is for Annual Leave and "Annual Leave Starting Date" is mentioned in the employee card then 'From Date of Entitlement' = 'Annual Leave Starting Date'
                          begin
                            FDate := EmpTBT."AL Starting Date";
                        end
                        else
                            if (EmpTBT."Employment Date" <> 0D) then begin
                                FDate := EmpTBT."Employment Date";
                                if HRSetupTbt."Trial Period" <> EmptyDateFormula then
                                    FDate := CALCDATE(HRSetupTbt."Trial Period", FDate);
                            end
                            else
                                exit;
                        TDate := CALCDATE('1Y', FDate) - 1;
                    end;

                    DayDiff := TDate - FDate;
                    if DayDiff > 364 then
                        DayDiff := 364;
                    if (EntitleYear > 0) and (FDate <> 0D) and (TDate <> 0D) then begin
                        FDate := DMY2DATE(DATE2DMY(FDate, 1), DATE2DMY(FDate, 2), EntitleYear);
                        TDate := FDate + DayDiff;
                    end;
                end
                else begin
                    FDate := Entitledate;
                    if EntitleTillDate = 0D then
                        TDate := CALCDATE('1Y', FDate) - 1
                    else
                        TDate := EntitleTillDate;
                end;
        end;

        if (FDate = 0D) or (TDate = 0D) then
            exit;

        CLEAR(EmpTBT);
        EmpTBT.RESET;
        EmpTBT.SETRANGE("No.", EmpNo);
        if EmpTBT.FINDFIRST then begin
            if (EmpTBT.Status <> EmpTBT.Status::Active) or (EmpTBT."Employment Date" = 0D) or (EmpTBT."End of Service Date" = 0D) then
                exit;
        end
        else
            exit;

        if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then
            L_EmployDate := EmpTBT."AL Starting Date"
        else
            L_EmployDate := EmpTBT."Employment Date";

        if (EmpTBT."Employment Date" = 0D) then
            exit;

        if EmpTBT."Termination Date" <> 0D then
            if EmpTBT."Termination Date" < TDate then
                exit;

        if EmpTBT."Inactive Date" <> 0D then
            if EmpTBT."Inactive Date" < TDate then
                exit;

        DaysPerMonth := 365 / 12;

        if DATE2DMY(L_EmployDate, 3) = DATE2DMY(FDate, 3) then
            YearsofService := ABS((FDate - L_EmployDate) / 365)
        else
            YearsofService := (FDate - L_EmployDate) / 365;

        if YearsofService <= 0 then
            YearsofService := 0;

        if (EntitleType = EntitleType::"Yearly Basis") then begin
            if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then begin
                if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."AL Starting Date", 3) then
                    FilterNbOfDays := TDate - EmpTBT."AL Starting Date"
                else
                    FilterNbOfDays := TDate - FDate;
            end
            else
                if (EmpTBT."Employment Date" <> 0D) then begin
                    if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."Employment Date", 3) then
                        FilterNbOfDays := TDate - EmpTBT."Employment Date"
                    else
                        FilterNbOfDays := TDate - FDate;

                    if HRSetupTbt."Trial Period" <> EmptyDateFormula then begin
                        if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."Employment Date", 3) then
                            FilterNbOfDays := TDate - CALCDATE(HRSetupTbt."Trial Period", EmpTBT."Employment Date")
                        else
                            FilterNbOfDays := TDate - FDate;
                    end;
                end
                else
                    FilterNbOfDays := TDate - FDate;
        end
        else
            FilterNbOfDays := TDate - FDate;

        FilterNbOfDays := FilterNbOfDays + 1;
        if FilterNbOfDays > 365 then
            FilterNbOfDays := 365;

        if DATE2DMY(TDate, 3) < DATE2DMY(EmpTBT."Employment Date", 3) then
            exit;

        CLEAR(EmpAbsEntitleTBT);
        EmpAbsEntitleTBT.RESET();
        EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
        EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
        EmpAbsEntitleTBT.FINDFIRST;

        DefEntitleValue := 0;
        AbsEntitleVal := 0;
        AbsEntitleAllowedToTransfer := 0;
        EntitleBandExist := false;

        AbsEntitleBandsTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
        AbsEntitleBandsTBT.SETRANGE("Employee Category", GetEntitlementEmpCategoryFilter(AbsEntitleCode, EmpNo, true));

        //Note: When assigning bands for AL or SKD kindly take into consideration the following:
        //      1. The entitlement assigned is for the period (From Unit - To Unit)
        //      2. It means that if the value falls within the interval,then it take the related entitlement
        //      3. The below two examples give the same result. They mean that if the value falls within the interval of 5 years then give 15 days
        //          Period     |   From Unit    |  To Unit  |  Entitlement
        //            Y        |      0         |     5     |   15
        //            M        |      0         |     60    |   15

        if AbsEntitleBandsTBT.FINDFIRST then
            repeat
                FUnitD := 0;
                TUnitD := 0;
                DefEntitleValue := AbsEntitleBandsTBT.Entitlement;

                EVALUATE(PeriodType, '1Y');
                if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a year
begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * 365;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * 365;
                    DefEntitleValue := ROUND(FilterNbOfDays / 365, 0.01); // get nb of years
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                EVALUATE(PeriodType, '1M');
                if PeriodType = AbsEntitleBandsTBT.Period then// the entitlement assigned is for a month
                  begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * DaysPerMonth;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * DaysPerMonth;
                    DefEntitleValue := ROUND(FilterNbOfDays / DaysPerMonth, 1, '='); // get nb of months
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                EVALUATE(PeriodType, '1W');
                if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a week
                begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * 7;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * 7;
                    DefEntitleValue := ROUND(FilterNbOfDays / 7, 1, '='); // get nb of weeks
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                if (FUnitD = 0) and (TUnitD = 0) then // the entitlement assigned is for a day
                  begin
                    FUnitD := AbsEntitleBandsTBT."From Unit";
                    TUnitD := AbsEntitleBandsTBT."To Unit";
                    DefEntitleValue := ROUND(FilterNbOfDays * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                if (YearsofService * 365 >= FUnitD) and (YearsofService * 365 <= TUnitD) and (not EntitleBandExist) then begin
                    if AbsEntitleBandsTBT.Type = AbsEntitleBandsTBT.Type::"Non-Cumulative" then begin
                        AbsEntitleVal := DefEntitleValue;
                        AbsEntitleAllowedToTransfer := 0;
                    end
                    else begin
                        AbsEntitleVal := DefEntitleValue;
                        AbsEntitleAllowedToTransfer := AbsEntitleBandsTBT."Allowed Days To Transfer";
                        if AbsEntitleBandsTBT."Balance Cummulative Years" > 0 then begin
                            if not IsEntitlementCummulativeYear(FDate, EmpTBT."Employment Date", AbsEntitleBandsTBT."Balance Cummulative Years") then
                                AbsEntitleAllowedToTransfer := 0;
                        end;
                    end;
                    EntitleBandExist := true;
                    //Modified for first year - 18.10.2017 : AIM +
                    if (AbsEntitleBandsTBT."First Year Entitlement" > 0) and (GetEmployeeNoEntitlRecordNo(EmpNo, AbsEntitleCode) <= 2) then
                      //Modified for first year - 18.10.2017 : AIM -
                      begin
                        if (AbsEntitleBandsTBT."From Unit" >= 0) then begin
                            //Modified for first year - 18.10.2017 : AIM +
                            if (YearsofService >= 1) and (YearsofService < 2) and (DATE2DMY(L_EmployDate, 2) <= DATE2DMY(WORKDATE, 2)) then
                                //Modified for first year - 18.10.2017 : AIM -
                                AbsEntitleVal := AbsEntitleVal + AbsEntitleBandsTBT."First Year Entitlement";
                        end;
                    end;
                end;
            until AbsEntitleBandsTBT.NEXT = 0;
        exit(AbsEntitleVal);
    end;

    procedure GetFamilyAllowanceRetro(EmpNo: Code[20]; PDate: Date): Decimal;
    var
        EmpTbt: Record Employee;
        EmpAddTbt: Record "Employee Additional Info";
        PayDetailLineTbt: Record "Pay Detail Line";
        Paid: Decimal;
        Amt: Decimal;
        FamAllow: Decimal;
        FamAllowCode: Code[10];
        PayParam: Record "Payroll Parameter";
    begin
        if (EmpNo = '') or (PDate = 0D) then
            exit(0);

        EmpTbt.SETRANGE("No.", EmpNo);
        if not EmpTbt.FINDFIRST then
            exit(0);

        if (EmpTbt.Declared <> EmpTbt.Declared::Declared) or (EmpTbt.Status <> EmpTbt.Status::Active) then
            exit(0);

        EmpAddTbt.SETRANGE("Employee No.", EmpNo);
        if not EmpAddTbt.FINDFIRST then
            exit(0);

        if EmpAddTbt."Family Allowance Retro Date" = 0D then
            exit(0);

        if DATE2DMY(EmpAddTbt."Family Allowance Retro Date", 3) <> DATE2DMY(PDate, 3) then
            exit(0);

        if DATE2DMY(EmpAddTbt."Family Allowance Retro Date", 2) = DATE2DMY(PDate, 2) then
            exit(0);

        if EmpAddTbt."Family Allowance Retro Date" > PDate then
            exit(0);

        PayParam.GET();
        FamAllowCode := PayParam."Family Allowance Code";
        if FamAllowCode = '' then
            exit(0);

        Paid := 0;
        PayDetailLineTbt.SETRANGE("Tax Year", DATE2DMY(PDate, 3));
        PayDetailLineTbt.SETRANGE("Pay Element Code", FamAllowCode);
        PayDetailLineTbt.SETFILTER(Period, '%1..%2', DATE2DMY(EmpAddTbt."Family Allowance Retro Date", 2), DATE2DMY(PDate, 2) - 1);
        PayDetailLineTbt.SETRANGE("Employee No.", EmpNo);
        if PayDetailLineTbt.FINDFIRST then
            repeat
                Paid += PayDetailLineTbt."Calculated Amount";
            until PayDetailLineTbt.NEXT = 0;

        FamAllow := CalculateFamilyAllowance(EmpTbt, true, PDate);
        Amt := ((DATE2DMY(PDate, 2) - DATE2DMY(EmpAddTbt."Family Allowance Retro Date", 2)) * FamAllow) - Paid;

        exit(Amt);
    end;

    procedure DeleteSubPayrollData(RefCode: Code[20]; DeleteOption: Option "Re-Open",Delete);
    var
        L_PayrollSubMain: Record "Payroll Sub Main";
        L_PayrollSubDetail: Record "Payroll Sub Details";
        L_PayDetailLine: Record "Pay Detail Line";
        L_PayrollLedgerEntry: Record "Payroll Ledger Entry";
    begin
        L_PayDetailLine.SETRANGE("Sub Payroll Code", RefCode);
        if L_PayDetailLine.FINDFIRST then
            repeat
                L_PayDetailLine.DELETE;
            until L_PayDetailLine.NEXT = 0;

        L_PayrollLedgerEntry.SETRANGE("Sub Payroll Code", RefCode);
        if L_PayrollLedgerEntry.FINDFIRST then
            repeat
                L_PayrollLedgerEntry.DELETE;
            until L_PayrollLedgerEntry.NEXT = 0;

        if DeleteOption = DeleteOption::Delete then begin
            L_PayrollSubDetail.SETRANGE("Ref Code", RefCode);
            if L_PayrollSubDetail.FINDFIRST then
                repeat
                    L_PayrollSubDetail.DELETE;
                until L_PayrollSubDetail.NEXT = 0;

            L_PayrollSubMain.SETRANGE("Ref Code", RefCode);
            if L_PayrollSubMain.FINDFIRST then
                repeat
                    L_PayrollSubMain.DELETE;
                until L_PayrollSubMain.NEXT = 0;
        end;
    end;

    procedure GetEmployeesNoOfDeclaredMonths(EmpNo: Code[20]; PayrollDate: Date) L_NoOfMonth: Decimal;
    var
        L_PayrollLedgerEntry: Record "Payroll Ledger Entry";
        L_EmpTbt: Record Employee;
        L_Month: Integer;
        L_Date: Date;
        L_PayrollParameter: Record "Payroll Parameter";
        L_UseRetro: Boolean;
        i: Integer;
        L_PayrollLedgerEntry1: Record "Payroll Ledger Entry";
    begin
        if (EmpNo = '') or (PayrollDate = 0D) then exit(0);
        L_PayrollParameter.GET();
        if not L_PayrollParameter."No Income Tax Retro" then begin
            // to exclude counting the Un-declared Months in month count . example; IF employee is Un-Declared in JAN and FEB and is declared starting from MAR then L_date = 1/3/YYYY +
            L_PayrollLedgerEntry.SETCURRENTKEY("Employee No.", Period, "Tax Year");
            L_PayrollLedgerEntry.SETFILTER(Period, '<%1', DATE2DMY(PayrollDate, 2));
            L_PayrollLedgerEntry.SETFILTER("Tax Year", '=%1', DATE2DMY(PayrollDate, 3));
            L_PayrollLedgerEntry.SETRANGE("Employee No.", EmpNo);
            // Modified in order to filter by Non-Declared or Contractual - 01.12.2017 : A2+
            L_PayrollLedgerEntry.SETFILTER(Declared, '%1|%2', L_PayrollLedgerEntry.Declared::"Non-Declared", L_PayrollLedgerEntry.Declared::Contractual);
            // Modified in order to filter by Non-Declared or Contractual - 01.12.2017 : A2-
            if L_PayrollLedgerEntry.FINDLAST then begin
                L_PayrollLedgerEntry1.SETCURRENTKEY("Employee No.", Period, "Tax Year");
                L_PayrollLedgerEntry1.SETFILTER(Period, '>%1', L_PayrollLedgerEntry.Period);
                L_PayrollLedgerEntry1.SETFILTER("Tax Year", '=%1', DATE2DMY(L_PayrollLedgerEntry."Payroll Date", 3));
                L_PayrollLedgerEntry1.SETRANGE("Employee No.", EmpNo);
                L_PayrollLedgerEntry1.SETFILTER(Declared, '%1|%2', L_PayrollLedgerEntry1.Declared::Declared, L_PayrollLedgerEntry1.Declared::"Non-NSSF");
                if L_PayrollLedgerEntry1.FINDFIRST then
                    L_Month := L_PayrollLedgerEntry1.Period
                else
                    L_Month := 1;
            end
            else begin
                L_PayrollLedgerEntry1.SETCURRENTKEY("Employee No.", Period, "Tax Year");
                L_PayrollLedgerEntry1.SETFILTER(Period, '<%1', DATE2DMY(PayrollDate, 2));
                L_PayrollLedgerEntry1.SETFILTER("Tax Year", '=%1', DATE2DMY(PayrollDate, 3));
                L_PayrollLedgerEntry1.SETRANGE("Employee No.", EmpNo);
                L_PayrollLedgerEntry1.SETFILTER(Declared, '%1|%2', L_PayrollLedgerEntry1.Declared::Declared, L_PayrollLedgerEntry1.Declared::"Non-NSSF");
                if L_PayrollLedgerEntry1.FINDFIRST then
                    L_Month := L_PayrollLedgerEntry1.Period
                else
                    L_Month := 1;
            end;
            // to exclude counting the Un-declared Months in month count . example; IF employee is Un-Declared in JAN and FEB and is declared starting from MAR then L_date = 1/3/YYYY -
        end
        else begin
            L_Month := DATE2DMY(PayrollDate, 2);
        end;

        if (L_Month > 0) and (L_Month < 12) then
            L_Date := DMY2DATE(1, L_Month, DATE2DMY(PayrollDate, 3))
        else
            if L_Month = 12 then
                L_Date := DMY2DATE(1, 1, DATE2DMY(PayrollDate, 3) + 1)
            else
                if L_Month = 0 then
                    L_Date := DMY2DATE(1, DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3));

        L_EmpTbt.SETRANGE("No.", EmpNo);
        if L_EmpTbt.FINDFIRST then begin
            if L_Date < L_EmpTbt."Employment Date" then
                L_Date := L_EmpTbt."Employment Date";
            if L_Date > PayrollDate then
                L_Date := PayrollDate;
            if (L_EmpTbt."Termination Date" <> 0D) and (PayrollDate > L_EmpTbt."Termination Date") then
                PayrollDate := L_EmpTbt."Termination Date";

            if L_PayrollParameter."Employ-Termination Affect Tax" = false then begin
                L_Date := DMY2DATE(1, DATE2DMY(L_Date, 2), DATE2DMY(L_Date, 3));
                //  Modified Because it is causing problem on FEB - 01.11.2017 : A2+
                PayrollDate := DMY2DATE(GetLastDayinMonth(PayrollDate), DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3));
                //  Modified Because it is causing problem on FEB - 01.11.2017 : A2-
            end;
        end;

        if (DATE2DMY(PayrollDate, 2) = DATE2DMY(L_Date, 2)) or ((DATE2DMY(L_Date, 1) <> 1) and (L_PayrollParameter."Employ-Termination Affect Tax" = true)) then begin
            L_NoOfMonth := ((PayrollDate - L_Date) + 1) / GetAverageDaysPerMonth();
        end
        else begin
            L_NoOfMonth := 0;
            i := DATE2DMY(L_Date, 2);
            while i < DATE2DMY(PayrollDate, 2) do begin
                L_NoOfMonth := L_NoOfMonth + 1;
                i := i + 1;
            end;
            if i = DATE2DMY(PayrollDate, 2) then
                // 14.02.2018 : A2+
                IF HRSetup."Average Days Per Month" <> 0 THEN
                    L_NoOfMonth := L_NoOfMonth + (((PayrollDate - DMY2DATE(1, DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3))) + 1) / GetAverageDaysPerMonth())
                ELSE
                    L_NoOfMonth := L_NoOfMonth + (((PayrollDate - DMY2DATE(1, DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3))) + 1) / GetDaysInMonth(DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3)));
            // 14.02.2018 : A2-
        end;
        if L_NoOfMonth < 0 then
            L_NoOfMonth := 0;

        exit(L_NoOfMonth);
    end;

    procedure CheckSalaryRaiseApprovalSystem(): Boolean;
    var
        HRSetUp: Record "Human Resources Setup";
        HRPermissions: Record "HR Permissions";
        IsReqApprovalOnLoan: Boolean;
        IsUseSystemApproval: Boolean;
    begin
        //approval cycle for employee loan 2017-06 SC+
        HRSetUp.RESET;
        if HRSetUp.FINDFIRST then
            IsUseSystemApproval := HRSetUp."Use System Approval";
        HRPermissions.RESET;
        HRPermissions.SETFILTER("User ID", USERID);
        if HRPermissions.FINDFIRST then
            IsReqApprovalOnLoan := HRPermissions."Req. Approval on Salary Change";
        if IsUseSystemApproval and IsReqApprovalOnLoan then
            exit(true);
        exit(false);
        //approval cycle for employee loan 2017-06 SC-
    end;

    procedure GetEmployeesNoOfNSSFDeclaredMonths(EmpNo: Code[20]; PayrollDate: Date; NSSFTypeCategory: Option All,MHOOD9,FAMSUB6,"EOS8.5") L_NoOfMonth: Decimal;
    var
        L_PayrollLedgerEntry: Record "Payroll Ledger Entry";
        L_EmpTbt: Record Employee;
        L_Month: Integer;
        L_Date: Date;
        L_PayrollParameter: Record "Payroll Parameter";
        L_UseRetro: Boolean;
        i: Integer;
    begin
        if (EmpNo = '') or (PayrollDate = 0D) then exit(0);
        L_PayrollParameter.GET();
        if not L_PayrollParameter."No Pension Retro" then begin
            // to exclude counting the Un-declared Months in month count . example; IF employee is Un-Declared in JAN and FEB and is declared starting from MAR then L_date = 1/3/YYYY +
            L_PayrollLedgerEntry.SETCURRENTKEY("Employee No.", Period, "Tax Year");
            L_PayrollLedgerEntry.SETFILTER(Period, '<%1', DATE2DMY(PayrollDate, 2));
            L_PayrollLedgerEntry.SETFILTER("Tax Year", '=%1', DATE2DMY(PayrollDate, 3));
            L_PayrollLedgerEntry.SETRANGE("Employee No.", EmpNo);
            L_PayrollLedgerEntry.SETFILTER(Declared, '%1', L_PayrollLedgerEntry.Declared::Declared);
            // 04.07.2017 : A2+
            if (L_PayrollParameter."MHOOD Retro Start Date" <> 0D) and (NSSFTypeCategory = NSSFTypeCategory::MHOOD9) then
                L_PayrollLedgerEntry.SETFILTER("Payroll Date", '%1..%2', L_PayrollParameter."MHOOD Retro Start Date", PayrollDate - 1)
            else
                if (L_PayrollParameter."Family Sub Retro Start Date" <> 0D) and (NSSFTypeCategory = NSSFTypeCategory::FAMSUB6) then
                    L_PayrollLedgerEntry.SETFILTER("Payroll Date", '%1..%2', L_PayrollParameter."Family Sub Retro Start Date", PayrollDate - 1)
                else
                    if (L_PayrollParameter."Family Sub Retro Start Date" <> 0D) and (NSSFTypeCategory = NSSFTypeCategory::"EOS8.5") then
                        L_PayrollLedgerEntry.SETFILTER("Payroll Date", '%1..%2', L_PayrollParameter."EOS Retro Start Date", PayrollDate - 1);
            // 04.08.2017 : A2-
            // 04.08.2017 : A2+
            if L_PayrollLedgerEntry.FINDFIRST then
                // 04.08.2017 : A2-
                L_Month := L_PayrollLedgerEntry.Period;
            // to exclude counting the Un-declared Months in month count . example; IF employee is Un-Declared in JAN and FEB and is declared starting from MAR then L_date = 1/3/YYYY -
        end
        else begin
            L_Month := DATE2DMY(PayrollDate, 2);
        end;

        //if (L_Month > 0) and (L_Month < 12) then//20181224:A2+-
        if (L_Month > 0) and (L_Month <= 12) then//20181224:A2+-
            L_Date := DMY2DATE(1, L_Month, DATE2DMY(PayrollDate, 3))
        /*//20181224:A2+

        
        else if L_Month = 12 then
          //Modified because L_NoOfMonth := ((PayrollDate - L_Date) + 1) / GetAverageDaysPerMonth() = 1/ (365/12) which is wrong - 11.12.2018 : AIM+
          //L_Date := DMY2DATE(1,1,DATE2DMY(PayrollDate,3) + 1)
          L_Date := DMY2DATE(1,1,DATE2DMY(PayrollDate,3))
          //Modified because L_NoOfMonth := ((PayrollDate - L_Date) + 1) / GetAverageDaysPerMonth() = 1/ (365/12) which is wrong - 11.12.2018 : AIM-
        *///20181224:A2-
        else
            if L_Month = 0 then
                L_Date := DMY2DATE(1, DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3));

        L_EmpTbt.SETRANGE("No.", EmpNo);
        if L_EmpTbt.FINDFIRST then begin
            if L_Date < L_EmpTbt."Employment Date" then
                L_Date := L_EmpTbt."Employment Date";
            if L_Date > PayrollDate then
                L_Date := PayrollDate;
            if (L_EmpTbt."Termination Date" <> 0D) and (PayrollDate > L_EmpTbt."Termination Date") then
                PayrollDate := L_EmpTbt."Termination Date";

            if not L_PayrollParameter."Employ-Termination Affect NSSF" then begin
                L_Date := DMY2DATE(1, DATE2DMY(L_Date, 2), DATE2DMY(L_Date, 3));
                PayrollDate := DMY2DATE(GetDaysInMonth(DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3)), DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3));
            end;
        end;

        if (DATE2DMY(PayrollDate, 2) = DATE2DMY(L_Date, 2)) or ((DATE2DMY(L_Date, 1) <> 1) and (L_PayrollParameter."Employ-Termination Affect NSSF" = true)) then begin
            // 04.09.2017 : AIM +
            if (DATE2DMY(PayrollDate, 2) = DATE2DMY(L_Date, 2)) and (DATE2DMY(PayrollDate, 1) = GetDaysInMonth(DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3)))
               and (DATE2DMY(L_Date, 1) = 1) then
                L_NoOfMonth := 1
            else
                L_NoOfMonth := ((PayrollDate - L_Date) + 1) / GetAverageDaysPerMonth();
            // 04.09.2017 : AIM -
        end
        else begin
            L_NoOfMonth := 0;
            i := DATE2DMY(L_Date, 2);
            while i < DATE2DMY(PayrollDate, 2) do begin
                L_NoOfMonth := L_NoOfMonth + 1;
                i := i + 1;
            end;
            if i = DATE2DMY(PayrollDate, 2) then begin
                if DATE2DMY(PayrollDate, 1) = GetLastDayinMonth(PayrollDate) then
                    L_NoOfMonth += 1
                else begin
                    if not L_PayrollParameter."Employ-Termination Affect NSSF" then
                        L_NoOfMonth += 1
                    else
                        L_NoOfMonth := L_NoOfMonth + (((PayrollDate - DMY2DATE(1, DATE2DMY(PayrollDate, 2), DATE2DMY(PayrollDate, 3))) + 1) / GetAverageDaysPerMonth());
                end;
            end;
        end;

        if L_NoOfMonth < 0 then
            L_NoOfMonth := 0;

        exit(L_NoOfMonth);
    end;

    procedure UseGradingSystem() AllowGradingSystem: Boolean;
    var
        HumanResorceSetup: Record "Human Resources Setup";
    begin

        HumanResorceSetup.GET;
        exit(HumanResorceSetup."Use Grading System");
    end;

    procedure DeleteExistingAllowanceDeductions(PayrollDate: Date; PayrollGroupCode: Code[20]; EmployeeNo: Code[20]; FixedPeriod: Boolean; EmployeeCategory: Code[20]; TemplateCode: Code[20]; SourceType: Option "Pay Detail",Journals,"Sub Payroll");
    var
        AllowanceDeductionTemplate: Record "Allowance Deduction Template";
        EmployeeJournalLine: Record "Employee Journal Line";
        AllowanceDeductionTempCatg: Record "Allowance Deduction Temp Catg";
        Employee: Record Employee;
        AllowanceDeductionPayElement: Record "Allowance Deduction Pay Elemt";
        HrTransactionTypes: Record "HR Transaction Types";
        PayElement: Record "Pay Element";
        PercentageValue: Decimal;
        allowanceDeductionCounter: Integer;
        ValueAmount: Decimal;
        EmployeeTotalAllowance: Decimal;
        EmployeeJournalLine2: Record "Employee Journal Line";
        ValueAmountNew: Decimal;
        CalculatedAmountNew: Decimal;
    begin

        // repeat on AllowanceDeductionTemplate+
        AllowanceDeductionTemplate.RESET;

        if TemplateCode <> '' then
            AllowanceDeductionTemplate.SETRANGE(Code, TemplateCode);



        if FixedPeriod then begin
            AllowanceDeductionTemplate.SETRANGE("Apply to Period Day", DATE2DMY(PayrollDate, 1));
            AllowanceDeductionTemplate.SETRANGE("Apply to Period Month", DATE2DMY(PayrollDate, 2));
        end;

        // 27.07.2017 : A2+
        if SourceType = SourceType::Journals then
            AllowanceDeductionTemplate.SETRANGE("Auto Generate", false);
        // 27.07.2017 : A2-

        AllowanceDeductionTemplate.SETRANGE(Inactive, false);

        if AllowanceDeductionTemplate.FINDFIRST then
            repeat
                // check if payroll date is less than till date
                if (AllowanceDeductionTemplate."Till Date" > PayrollDate) and (AllowanceDeductionTemplate."Valid From" < PayrollDate) then begin

                    // repeat on AllowanceDeductionTempCatg+
                    AllowanceDeductionTempCatg.RESET;
                    AllowanceDeductionTempCatg.SETRANGE("Document No.", AllowanceDeductionTemplate.Code);
                    if EmployeeCategory <> '' then
                        AllowanceDeductionTempCatg.SETRANGE("Category Code", EmployeeCategory);

                    if AllowanceDeductionTempCatg.FINDFIRST then
                        repeat

                            // repeat on AllowanceDeductionPayElement+
                            AllowanceDeductionPayElement.RESET;
                            AllowanceDeductionPayElement.SETRANGE("Document No.", AllowanceDeductionTemplate.Code);
                            if AllowanceDeductionPayElement.FINDFIRST then
                                repeat

                                    // Get Pay Element+
                                    PayElement.RESET;
                                    PayElement.SETRANGE(Code, AllowanceDeductionPayElement."Pay Element Code");
                                    if PayElement.FINDFIRST then begin

                                        // Get HrTransactionTypes+
                                        HrTransactionTypes.RESET;
                                        HrTransactionTypes.SETRANGE("Associated Pay Element", AllowanceDeductionPayElement."Pay Element Code");
                                        if HrTransactionTypes.FINDFIRST then begin

                                            // repeat on Employees+
                                            Employee.RESET;
                                            Employee.SETRANGE("Employee Category Code", AllowanceDeductionTempCatg."Category Code");
                                            Employee.SETRANGE(Status, Employee.Status::Active);
                                            if EmployeeCategory <> '' then
                                                Employee.SETRANGE("Employee Category Code", EmployeeCategory);
                                            if PayrollGroupCode <> '' then
                                                Employee.SETRANGE("Payroll Group Code", PayrollGroupCode);
                                            if EmployeeNo <> '' then
                                                Employee.SETRANGE("No.", EmployeeNo);

                                            if Employee.FINDFIRST then
                                                repeat


                                                    //Check if payroll date for this employee is valid 2017-07-13 SC+
                                                    if IsValidPayrollDate(Employee."Payroll Group Code", PayrollDate) then begin
                                                        // delete existing EmployeeJournalLine+

                                                        EmployeeJournalLine.RESET;
                                                        EmployeeJournalLine.SETRANGE("Transaction Date", PayrollDate);
                                                        EmployeeJournalLine.SETRANGE("Transaction Type", HrTransactionTypes.Code);
                                                        EmployeeJournalLine.SETRANGE("Employee No.", Employee."No.");
                                                        EmployeeJournalLine.SETRANGE("System Insert", true);
                                                        if EmployeeJournalLine.FIND('-') then
                                                            EmployeeJournalLine.DELETEALL(true);

                                                        // delete existing EmployeeJournalLine-

                                                    end;
                                                //Check if payroll date for this employee is valid 2017-07-13 SC-
                                                until Employee.NEXT = 0;
                                            // repeat on Employees-

                                        end;
                                        // Get HrTransactionTypes-

                                    end;
                                // Get Pay Element-

                                until AllowanceDeductionPayElement.NEXT = 0;
                        // repeat on AllowanceDeductionPayElement-

                        until AllowanceDeductionTempCatg.NEXT = 0;
                    // repeat on AllowanceDeductionTempCatg-

                end;

            until AllowanceDeductionTemplate.NEXT = 0;
        // repeat on AllowanceDeductionTemplate-
    end;

    procedure GetEmpFirstYearEntitlement(EmpNo: Code[20]; AbsEntitleCode: Code[10]; Entitledate: Date; EntitleTillDate: Date; EntitleType: Option "Interval Basis","Yearly Basis","Employment Basis"; ClonePrevDateInterval: Boolean) V: Decimal;
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        AbsEntitleBandsTBT: Record "Absence Entitlement";
        EmpTBT: Record Employee;
        AllowGenerate: Boolean;
        DefEntitleValue: Decimal;
        PeriodType: DateFormula;
        FUnitD: Decimal;
        TUnitD: Decimal;
        DaysPerMonth: Decimal;
        FilterNbOfDays: Decimal;
        FDate: Date;
        TDate: Date;
        HRSetupTbt: Record "Human Resources Setup";
        EmptyDateFormula: DateFormula;
        AbsEntitleVal: Decimal;
        AbsEntitleAllowedToTransfer: Decimal;
        YearsofService: Decimal;
        EntitleBandExist: Boolean;
        DayDiff: Integer;
        EntitleYear: Integer;
        L_EmployDate: Date;
    begin
        HRSetupTbt.GET();
        if Entitledate = 0D then exit(0);
        EntitleYear := DATE2DMY(Entitledate, 3);

        if EmpNo = '' then
            exit;

        if AbsEntitleCode = '' then
            exit;

        if ClonePrevDateInterval = true then begin
            EmpAbsEntitleTBT.RESET();
            EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
            EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
            if EmpAbsEntitleTBT.FINDFIRST = true then begin
                repeat // Get the last entitlement year which is generated for the employee
                    if FDate < EmpAbsEntitleTBT."From Date" then
                        FDate := EmpAbsEntitleTBT."From Date";
                    if TDate < EmpAbsEntitleTBT."Till Date" then
                        TDate := EmpAbsEntitleTBT."Till Date";
                until EmpAbsEntitleTBT.NEXT = 0;
                if TDate <> 0D then // if there are entitlement generated for the previous years,then the new entitlement record will be for the interval [To date of the Last record + 1D] .. [[To date of the Last record + 1D] + 1Y]
                  begin
                    FDate := CALCDATE('1D', TDate);
                    TDate := CALCDATE('1Y', FDate);
                    TDate := CALCDATE('-1D', TDate);
                    DayDiff := TDate - FDate;
                    if EntitleYear > 0 then begin
                        FDate := DMY2DATE(DATE2DMY(FDate, 1), DATE2DMY(FDate, 2), EntitleYear);
                        TDate := FDate + DayDiff;
                    end;
                end;
            end;
        end;

        if (FDate = 0D) or (TDate = 0D) then // if no entitlement record exists then
          begin

            if EntitleType = EntitleType::"Yearly Basis" then // Yearly basis means that the entitlement is given from 1/1/YYYY till 31/12/YYYY
                 begin
                FDate := DMY2DATE(1, 1, EntitleYear);
                TDate := DMY2DATE(31, 12, EntitleYear);
            end
            else
                if EntitleType = EntitleType::"Employment Basis" then // Employment basis means that the first entitlement year will be [Employment Date] .. [Employment Date + 1Y]
               begin
                    CLEAR(EmpTBT);
                    EmpTBT.RESET;
                    EmpTBT.SETRANGE("No.", EmpNo);
                    if EmpTBT.FINDFIRST then begin
                        if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then
                          // If it is for Annual Leave and "Annual Leave Starting Date" is mentioned in the employee card then 'From Date of Entitlement' = 'Annual Leave Starting Date'
                          begin
                            FDate := EmpTBT."AL Starting Date";
                        end
                        else
                            if (EmpTBT."Employment Date" <> 0D) then begin
                                FDate := EmpTBT."Employment Date";
                                if HRSetupTbt."Trial Period" <> EmptyDateFormula then  //If probation interval is mentioned in the Human Resources setup then
                                    FDate := CALCDATE(HRSetupTbt."Trial Period", FDate);
                            end
                            else begin
                                exit;
                            end;
                        TDate := CALCDATE('1Y', FDate) - 1;
                    end;
                    DayDiff := TDate - FDate;
                    if DayDiff > 364 then
                        DayDiff := 364;
                    if (EntitleYear > 0) and (FDate <> 0D) and (TDate <> 0D) then begin
                        FDate := DMY2DATE(DATE2DMY(FDate, 1), DATE2DMY(FDate, 2), EntitleYear);
                        TDate := FDate + DayDiff;
                    end;
                end
                else begin
                    FDate := Entitledate;
                    if EntitleTillDate = 0D then
                        TDate := CALCDATE('1Y', FDate) - 1
                    else
                        TDate := EntitleTillDate;
                end;
        end
        else begin

        end;


        if (FDate = 0D) or (TDate = 0D) then
            exit;


        CLEAR(EmpTBT);
        EmpTBT.RESET;
        EmpTBT.SETRANGE("No.", EmpNo);
        if EmpTBT.FINDFIRST then begin
            if (EmpTBT.Status <> EmpTBT.Status::Active) or (EmpTBT."Employment Date" = 0D) or (EmpTBT."End of Service Date" = 0D) then
                exit;
        end
        else begin
            exit;
        end;


        if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then
            L_EmployDate := EmpTBT."AL Starting Date"
        else
            L_EmployDate := EmpTBT."Employment Date";


        if (EmpTBT."Employment Date" = 0D) then
            exit;

        if EmpTBT."Termination Date" <> 0D then
            if EmpTBT."Termination Date" < TDate then
                exit;

        if EmpTBT."Inactive Date" <> 0D then
            if EmpTBT."Inactive Date" < TDate then
                exit;

        DaysPerMonth := 365 / 12;

        if DATE2DMY(L_EmployDate, 3) = DATE2DMY(FDate, 3) then
            YearsofService := ABS((FDate - L_EmployDate) / 365)
        else
            YearsofService := (FDate - L_EmployDate) / 365;


        if YearsofService <= 0 then
            YearsofService := 0;

        if (EntitleType = EntitleType::"Yearly Basis") then begin
            if (AbsEntitleCode = 'AL') and (EmpTBT."AL Starting Date" <> 0D) then begin
                if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."AL Starting Date", 3) then
                    FilterNbOfDays := TDate - EmpTBT."AL Starting Date"
                else
                    FilterNbOfDays := TDate - FDate;
            end
            else
                if (EmpTBT."Employment Date" <> 0D) then begin
                    if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."Employment Date", 3) then
                        FilterNbOfDays := TDate - EmpTBT."Employment Date"
                    else
                        FilterNbOfDays := TDate - FDate;

                    if HRSetupTbt."Trial Period" <> EmptyDateFormula then begin
                        if DATE2DMY(FDate, 3) = DATE2DMY(EmpTBT."Employment Date", 3) then
                            FilterNbOfDays := TDate - CALCDATE(HRSetupTbt."Trial Period", EmpTBT."Employment Date")
                        else
                            FilterNbOfDays := TDate - FDate;
                    end;
                end
                else begin
                    FilterNbOfDays := TDate - FDate;
                end;
        end
        else
            FilterNbOfDays := TDate - FDate;


        FilterNbOfDays := FilterNbOfDays + 1;
        if FilterNbOfDays > 365 then
            FilterNbOfDays := 365;

        if DATE2DMY(TDate, 3) < DATE2DMY(EmpTBT."Employment Date", 3) then
            exit;

        CLEAR(EmpAbsEntitleTBT);
        EmpAbsEntitleTBT.RESET();
        EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
        EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
        EmpAbsEntitleTBT.FINDFIRST;

        DefEntitleValue := 0;
        AbsEntitleVal := 0;
        AbsEntitleAllowedToTransfer := 0;
        EntitleBandExist := false;

        AbsEntitleBandsTBT.SETRANGE("Cause of Absence Code", AbsEntitleCode);
        AbsEntitleBandsTBT.SETRANGE("Employee Category", GetEntitlementEmpCategoryFilter(AbsEntitleCode, EmpNo, true));

        //Note: When assigning bands for AL or SKD kindly take into consideration the following:
        //      1. The entitlement assigned is for the period (From Unit - To Unit)
        //      2. It means that if the value falls within the interval,then it take the related entitlement
        //      3. The below two examples give the same result. They mean that if the value falls within the interval of 5 years then give 15 days
        //          Period     |   From Unit    |  To Unit  |  Entitlement
        //            Y        |      0         |     5     |   15
        //            M        |      0         |     60    |   15
        //
        if AbsEntitleBandsTBT.FINDFIRST = true then
            repeat
                FUnitD := 0;
                TUnitD := 0;

                DefEntitleValue := AbsEntitleBandsTBT.Entitlement;

                EVALUATE(PeriodType, '1Y');
                if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a year
begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * 365;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * 365;
                    DefEntitleValue := ROUND(FilterNbOfDays / 365, 0.01); // get nb of years
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                EVALUATE(PeriodType, '1M');
                if PeriodType = AbsEntitleBandsTBT.Period then// the entitlement assigned is for a month
                  begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * DaysPerMonth;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * DaysPerMonth;
                    DefEntitleValue := ROUND(FilterNbOfDays / DaysPerMonth, 1, '='); // get nb of months
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                EVALUATE(PeriodType, '1W');
                if PeriodType = AbsEntitleBandsTBT.Period then // the entitlement assigned is for a week
                begin
                    FUnitD := AbsEntitleBandsTBT."From Unit" * 7;
                    TUnitD := AbsEntitleBandsTBT."To Unit" * 7;
                    DefEntitleValue := ROUND(FilterNbOfDays / 7, 1, '='); // get nb of weeks
                    DefEntitleValue := ROUND(DefEntitleValue * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;

                if (FUnitD = 0) and (TUnitD = 0) then // the entitlement assigned is for a day
                  begin
                    FUnitD := AbsEntitleBandsTBT."From Unit";
                    TUnitD := AbsEntitleBandsTBT."To Unit";
                    DefEntitleValue := ROUND(FilterNbOfDays * AbsEntitleBandsTBT.Entitlement, 0.01);
                end;


                if (YearsofService * 365 >= FUnitD) and (YearsofService * 365 <= TUnitD) and (EntitleBandExist = false) then begin
                    if AbsEntitleBandsTBT.Type = AbsEntitleBandsTBT.Type::"Non-Cumulative" then begin
                        AbsEntitleAllowedToTransfer := 0;
                    end
                    else begin
                        AbsEntitleAllowedToTransfer := AbsEntitleBandsTBT."Allowed Days To Transfer";
                        if AbsEntitleBandsTBT."Balance Cummulative Years" > 0 then begin
                            if IsEntitlementCummulativeYear(FDate, EmpTBT."Employment Date", AbsEntitleBandsTBT."Balance Cummulative Years") = false then
                                AbsEntitleAllowedToTransfer := 0;
                        end;
                    end;
                    EntitleBandExist := true;
                    if (AbsEntitleBandsTBT."First Year Entitlement" > 0) and (GetEmployeeNoEntitlRecordNo(EmpNo, AbsEntitleCode) <= 2) then begin
                        if (AbsEntitleBandsTBT."From Unit" >= 0) then begin
                            // 08.06.2017 : A2+
                            if (YearsofService >= 1) and (YearsofService < 2) and (DATE2DMY(L_EmployDate, 2) <= DATE2DMY(WORKDATE, 2)) then
                                // 08.06.2017 : A2-
                                AbsEntitleVal := AbsEntitleBandsTBT."First Year Entitlement";
                        end;
                    end;
                end;

            until AbsEntitleBandsTBT.NEXT = 0;
        exit(AbsEntitleVal);
    end;

    local procedure GetEmployeeNoEntitlRecordNo(EmpNo: Code[20]; CauseCode: Code[10]) RecCount: Integer;
    var
        EmpAbsEntitlement: Record "Employee Absence Entitlement";
    begin
    end;

    procedure GetEmployeeExtraSalary(EmpNo: Code[20]) V: Decimal;
    var
        L_EmpAddInfoTbt: Record "Employee Additional Info";
    begin
        V := 0;
        if EmpNo <> '' then begin
            L_EmpAddInfoTbt.SETRANGE("Employee No.", EmpNo);
            if L_EmpAddInfoTbt.FINDFIRST then
                V := L_EmpAddInfoTbt."Extra Salary";
        end;


        exit(V);
    end;

    procedure GetEmployeeBasicSecondHourlyRate(EmpNo: Code[20]; CauseofAbsCode: Code[10]; BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount; FixedAmount: Decimal) RatePerHour: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        PayElement: Record "Pay Element";
        HRSetup: Record "Human Resources Setup";
        EmployTypeCode: Code[20];
        PayElemCode: Code[10];
        Amount: Decimal;
        MonthlyHours: Decimal;
        CauseofAbsence: Record "Cause of Absence";
        EmpAddInfo: Record "Employee Additional Info";
        ExtraSalary: Decimal;
        SecondHourlyRate: Decimal;
    begin
        RatePerHour := 0;

        if EmpNo = '' then
            exit(0);

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin
            MonthlyHours := 0;
            MonthlyHours := GetEmployeeMonthlyHours(EmpNo, CauseofAbsCode);
            if MonthlyHours = 0 then // If monthly hours is zero,then rate will be zero
                exit(0);

            Amount := 0;
            EmpAddInfo.SETRANGE("Employee No.", EmpNo);
            if EmpAddInfo.FINDFIRST then begin
                ExtraSalary := EmpAddInfo."Extra Salary";
                SecondHourlyRate := EmpAddInfo."Second Hourly Rate";
            end;

            if BasicType = BasicType::BasicPay then
                Amount := Employee."Basic Pay" + ExtraSalary
            else
                if BasicType = BasicType::SalaryACY then
                    Amount := Employee."Salary (ACY)"
                else
                    if BasicType = BasicType::FixedAmount then
                        Amount := FixedAmount;

            if (BasicType = BasicType::BasicPay) or (BasicType = BasicType::SalaryACY) or (BasicType = BasicType::FixedAmount) then
                RatePerHour := Amount / MonthlyHours
            else
                if BasicType = BasicType::HourlyRate then begin
                    if SecondHourlyRate > 0 then
                        RatePerHour := SecondHourlyRate
                    else
                        RatePerHour := Employee."Basic Pay" / MonthlyHours;
                end;
        end;
        exit(RatePerHour);
    end;

    procedure CanOpenEmployeesCardPage(UserV: Code[50]) L_ErrorMsg: Text;
    var
        L_UserTbt: Record User;
        L_HRPermisssionTbt: Record "HR Permissions";
        L_HRPayrollUserTbt: Record "HR Payroll User";
    begin
        L_UserTbt.SETRANGE(L_UserTbt."User Name", UserV);
        if L_UserTbt.FINDFIRST = false then
            exit('User does not exist!')
        else begin
            if L_UserTbt."License Type" <> L_UserTbt."License Type"::"Full User" then
                exit('The user is not a FULL USER!!');
        end;

        L_HRPermisssionTbt.SETRANGE(L_HRPermisssionTbt."User ID", UserV);
        if L_HRPermisssionTbt.FINDFIRST = false then
            exit('No Permission');

        L_HRPayrollUserTbt.SETRANGE(L_HRPayrollUserTbt."User Id", UserV);
        if L_HRPayrollUserTbt.FINDFIRST() = false then
            exit('Access Denied');

        exit('');
    end;

    procedure IsSeparateAttendanceInterval(PayGrp: Code[20]): Boolean;
    var
        L_PayStatus: Record "Payroll Status";
        L_HRSetup: Record "Human Resources Setup";
    begin
        L_HRSetup.GET();

        if not L_HRSetup."Seperate Attendance Interval" then
            exit(false);

        L_PayStatus.SETRANGE("Payroll Group Code", PayGrp);
        if L_PayStatus.FINDFIRST then
            if (L_PayStatus."Separate Attendance Interval") then
                exit(true)
            else
                exit(false);
    end;

    procedure PostMonthlyAttendanceLateArriveToJournal(EmpNo: Code[20]; AttendDate: Date; MergeLateAttend: Boolean);
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        DeductionCode: Code[10];
        DedPayElem: Code[10];
        LateArriveMin: Decimal;
        AbsentHrs: Decimal;
        PolicyType: Option LateArrive,LateLeave,EarlyArrive,EarlyLeave;
        AttType: Option Overtime,Absence;
        ALBalance: Decimal;
        ALAbsHrs: Decimal;
    begin
        DedPayElem := '';
        //Get Deduction Code +
        DeductionCode := GetAttendanceCauseOfAbsenceCode(AttType::Absence);
        CauseofAbsence.SETRANGE(CauseofAbsence.Code, DeductionCode);
        if not CauseofAbsence.FINDFIRST then
            exit;

        if DeductionCode = '' then
            exit;

        EmployeeABS.SETRANGE("Employee No.", EmpNo);
        EmployeeABS.SETRANGE("From Date", AttendDate);
        if not EmployeeABS.FINDFIRST then
            exit;

        if ((EmployeeABS.Type = EmployeeABS.Type::"Paid Day") or
           (EmployeeABS.Type = EmployeeABS.Type::"Paid Vacation") or
           (EmployeeABS.Type = EmployeeABS.Type::"Working Day")) and
           (EmployeeABS."Attend Hrs." > 0) and
           (EmployeeABS."Required Hrs" > 0) then begin
            if IsPenalizeLateArrive(EmployeeABS."Employee No.") then
                LateArriveMin := EmployeeABS."Late Arrive"
            else
                LateArriveMin := 0;

            AbsentHrs := 0;
            if EmployeeABS."Required Hrs" - EmployeeABS."Attend Hrs." > 0 then begin
                AbsentHrs := EmployeeABS."Required Hrs" - EmployeeABS."Attend Hrs.";
                AbsentHrs := AbsentHrs - ROUND(GetDailyShiftAssignedBreakMinute(EmployeeABS."Shift Code") / 60, 0.01);
                // 20.09.2017 : A2+
                AbsentHrs := AbsentHrs - GetAttendanceAbsenceToleranceBySchedule(EmpNo, EmployeeABS."Shift Code");
                // 20.09.2017 : A2-
            end;
            if AbsentHrs > (LateArriveMin / 60) then
                AbsentHrs := AbsentHrs - (LateArriveMin / 60)
            else
                AbsentHrs := 0;

            AbsentHrs := AbsentHrs * GetAttendanceAbsenceRateBySchedule(EmpNo, EmployeeABS."Shift Code");
            if AbsentHrs <= 0 then
                AbsentHrs := 0;

            AbsentHrs := 0;
            if (MergeLateAttend) and (LateArriveMin > 0) then
                LateArriveMin := CalculateLateArrivePenalty(GetAttendancePolicyCauseCodes(PolicyType::LateArrive), LateArriveMin, CauseofAbsence."Unit of Measure Code", EmpNo);

            ALAbsHrs := 0;
            HRSetup.GET;
            if (HRSetup."Deduct Absence From AL") and (HRSetup."Deduct Absence From AL Code" <> '') then begin
                ALBalance := GetEmpAbsenceEntitlementCurrentBalance(EmpNo, HRSetup."Annual Leave Code", 0D);
                ALBalance := ROUND(ALBalance * GetEmployeeDailyHours(EmpNo, ''));
                if (ALBalance > 0) and (AbsentHrs > 0) then begin
                    if (AbsentHrs >= ALBalance) then begin
                        ALAbsHrs := ALAbsHrs + ALBalance;
                        AbsentHrs := ROUND(AbsentHrs - ALBalance, 0.01);
                        ALBalance := 0;
                    end
                    else begin
                        ALBalance := ALBalance - AbsentHrs;
                        ALAbsHrs := ALAbsHrs + AbsentHrs;
                        AbsentHrs := 0;
                    end;
                end;

                if (ALBalance > 0) and (LateArriveMin > 0) then begin
                    if (LateArriveMin >= ALBalance) then begin
                        ALAbsHrs := ALAbsHrs + ALBalance;
                        LateArriveMin := ROUND(LateArriveMin - ALBalance, 0.01);
                        ALBalance := 0;
                    end
                    else begin
                        ALBalance := ALBalance - LateArriveMin;
                        ALAbsHrs := ALAbsHrs + LateArriveMin;
                        LateArriveMin := 0;
                    end;
                end;

                if ALAbsHrs > 0 then begin
                    EmployeeJournal.INIT;
                    EmployeeJournal.VALIDATE("Employee No.", EmpNo);
                    EmployeeJournal."Transaction Type" := 'ABS';
                    EmployeeJournal.VALIDATE("Cause of Absence Code", HRSetup."Deduct Absence From AL Code");
                    EmployeeJournal.VALIDATE("Starting Date", EmployeeABS."From Date");
                    EmployeeJournal.VALIDATE("Ending Date", EmployeeABS."From Date");
                    EmployeeJournal.Type := 'ABSENCE';
                    EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
                    EmployeeJournal.VALIDATE(EmployeeJournal.Value, ALAbsHrs);
                    EmployeeJournal."Opened By" := USERID;
                    EmployeeJournal."Opened Date" := WORKDATE;
                    EmployeeJournal."Released By" := USERID;
                    EmployeeJournal."Released Date" := WORKDATE;
                    EmployeeJournal."Approved By" := USERID;
                    EmployeeJournal."Approved Date" := WORKDATE;
                    EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
                    EmployeeJournal.INSERT(true);
                end;
            end;

            if LateArriveMin > 0 then begin
                EmployeeJournal.INIT;
                EmployeeJournal.VALIDATE("Employee No.", EmpNo);
                EmployeeJournal."Transaction Type" := 'ABS';
                EmployeeJournal.VALIDATE("Cause of Absence Code", DeductionCode);
                EmployeeJournal.VALIDATE("Starting Date", EmployeeABS."From Date");
                EmployeeJournal.VALIDATE("Ending Date", EmployeeABS."From Date");
                EmployeeJournal.Type := 'ABSENCE';
                EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
                EmployeeJournal.VALIDATE(EmployeeJournal.Value, LateArriveMin);
                EmployeeJournal."Opened By" := USERID;
                EmployeeJournal."Opened Date" := WORKDATE;
                EmployeeJournal."Released By" := USERID;
                EmployeeJournal."Released Date" := WORKDATE;
                EmployeeJournal."Approved By" := USERID;
                EmployeeJournal."Approved Date" := WORKDATE;
                EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
                EmployeeJournal.INSERT(true);
            end;

        end;
        //Added in order to update entitle balance on each insert - 08.03.2018 : AIM +
        UpdateEmpEntitlementTotals(EmployeeABS.Period, EmpNo);
        //Added in order to update entitle balance on each insert - 08.03.2018 : AIM -
    end;

    procedure GetEmployeeMonthlyEmploymentUnpaidOvertimeHrs(EmpNo: Code[20]; P_Period: Date) OvrHrs: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        EmpAbs: Record "Employee Absence";
        L_Val: Decimal;
        L_OvrUnpaidHrs: Decimal;
        L_DefUnpaidHrs: Decimal;
        L_UseDailyShiftTolerance: Boolean;
        L_DailyShiftTbt: Record "Daily Shifts";
    begin
        OvrHrs := 0;

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin
            EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
            if (EmploymentType.FINDFIRST) then begin
                L_UseDailyShiftTolerance := EmploymentType."Use Daily Shift Tolerance";
                if not L_UseDailyShiftTolerance then
                    L_DefUnpaidHrs := EmploymentType."Overtime Unpaid Hours";
            end;
        end;

        EmpAbs.SETRANGE("Employee No.", EmpNo);
        EmpAbs.SETRANGE(Period, P_Period);
        if EmpAbs.FINDFIRST then
            repeat
                if L_UseDailyShiftTolerance then begin
                    L_DailyShiftTbt.SETRANGE("Shift Code", EmpAbs."Shift Code");
                    if L_DailyShiftTbt.FINDFIRST then
                        L_DefUnpaidHrs := L_DailyShiftTbt."Unpaid Overtime Hrs";
                end;

                if EmpAbs."Attend Hrs." - EmpAbs."Required Hrs" > L_DefUnpaidHrs then
                    OvrHrs := OvrHrs + L_DefUnpaidHrs
                else
                    if (EmpAbs."Attend Hrs." > EmpAbs."Required Hrs") and (EmpAbs."Attend Hrs." - EmpAbs."Required Hrs" < L_DefUnpaidHrs) then
                        OvrHrs := OvrHrs + EmpAbs."Attend Hrs." - EmpAbs."Required Hrs";

            until EmpAbs.NEXT = 0;
        exit(OvrHrs);
    end;

    procedure GetEmployeeUnpaidOVRHrsByDailyShift(EmpNo: Code[20]; ShiftCode: Code[20]) OvrHrs: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        L_UseDailyShiftTolerance: Boolean;
        L_DailyShiftTbt: Record "Daily Shifts";
        L_DefUnpaidHrs: Decimal;
    begin
        OvrHrs := 0;

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin
            EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
            if (EmploymentType.FINDFIRST) then begin
                L_DefUnpaidHrs := EmploymentType."Overtime Unpaid Hours";

                L_UseDailyShiftTolerance := EmploymentType."Use Daily Shift Tolerance";
            end;
        end;

        if (L_UseDailyShiftTolerance) and (ShiftCode <> '') then begin
            L_DailyShiftTbt.SETRANGE("Shift Code", ShiftCode);
            if L_DailyShiftTbt.FINDFIRST then
                L_DefUnpaidHrs := L_DailyShiftTbt."Unpaid Overtime Hrs";
        end;

        exit(L_DefUnpaidHrs);
    end;

    procedure GetEmployeeToleranceABSHrsByDailyShift(EmpNo: Code[20]; ShiftCode: Code[20]) ABSHrs: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        L_UseDailyShiftTolerance: Boolean;
        L_DailyShiftTbt: Record "Daily Shifts";
        L_DefUnpaidHrs: Decimal;
    begin
        ABSHrs := 0;

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin
            EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
            if (EmploymentType.FINDFIRST) then begin
                L_DefUnpaidHrs := EmploymentType."Absence Tolerance Hours";

                L_UseDailyShiftTolerance := EmploymentType."Use Daily Shift Tolerance";
            end;
        end;

        if (L_UseDailyShiftTolerance) and (ShiftCode <> '') then begin
            L_DailyShiftTbt.SETRANGE("Shift Code", ShiftCode);
            if L_DailyShiftTbt.FINDFIRST then
                L_DefUnpaidHrs := L_DailyShiftTbt.Tolerance;
        end;

        exit(L_DefUnpaidHrs);
    end;

    procedure GetEmployeeMonthlyEmploymentToleranceABSHrs(EmpNo: Code[20]; P_Period: Date) ABSHrs: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        EmpAbs: Record "Employee Absence";
        L_Val: Decimal;
        L_ToleranceHrs: Decimal;
        L_DefToleranceABSHrs: Decimal;
        L_UseDailyShiftTolerance: Boolean;
        L_DailyShiftTbt: Record "Daily Shifts";
        HRSetup: Record "Human Resources Setup";
    begin
        ABSHrs := 0;

        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin
            EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
            if (EmploymentType.FINDFIRST) then begin
                L_UseDailyShiftTolerance := EmploymentType."Use Daily Shift Tolerance";
                if not L_UseDailyShiftTolerance then
                    L_DefToleranceABSHrs := EmploymentType."Absence Tolerance Hours";
            end;
        end;

        EmpAbs.SETRANGE("Employee No.", EmpNo);
        EmpAbs.SETRANGE(Period, P_Period);
        if EmpAbs.FINDFIRST then
            repeat
                if L_UseDailyShiftTolerance then begin
                    L_DailyShiftTbt.SETRANGE("Shift Code", EmpAbs."Shift Code");
                    if L_DailyShiftTbt.FINDFIRST then
                        L_DefToleranceABSHrs := L_DailyShiftTbt.Tolerance;
                end;
                if EmpAbs."Required Hrs" - EmpAbs."Attend Hrs." > L_DefToleranceABSHrs then
                    ABSHrs := ABSHrs + L_DefToleranceABSHrs
                else
                    if (EmpAbs."Attend Hrs." < EmpAbs."Required Hrs") and (EmpAbs."Required Hrs" - EmpAbs."Attend Hrs." < L_DefToleranceABSHrs) then
                        ABSHrs := ABSHrs + EmpAbs."Required Hrs" - EmpAbs."Attend Hrs.";
            until EmpAbs.NEXT = 0;
        exit(ABSHrs);
    end;

    procedure GetEmployeeLateArriveHrs(EmpNo: Code[20]; P_Period: Date) LateArriveMin: Decimal;
    var
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        EmpAbs: Record "Employee Absence";
        L_Val: Decimal;
        L_ToleranceHrs: Decimal;
        L_DefToleranceABSHrs: Decimal;
        L_UseDailyShiftTolerance: Boolean;
        L_DailyShiftTbt: Record "Daily Shifts";
    begin
        LateArriveMin := 0;
        if IsPenalizeLateArrive(EmpNo) then begin
            EmpAbs.SETRANGE("Employee No.", EmpNo);
            EmpAbs.SETRANGE(Period, P_Period);
            if EmpAbs.FINDFIRST then
                repeat
                    LateArriveMin += EmpAbs."Late Arrive";
                until EmpAbs.NEXT = 0;
        end;

        LateArriveMin := ROUND(LateArriveMin / 60, 0.01, '=');
        exit(LateArriveMin);
    end;

    procedure IsEmployeeCategoryUseGradingSystem(EmpCategCode: Code[10]): Boolean;
    var
        EmpCategory: Record "Employee Categories";
    begin
        if not UseGradingSystem() then
            exit(false);

        if EmpCategCode = '' then
            exit(false);

        EmpCategory.SETRANGE(Code, EmpCategCode);
        if EmpCategory.FINDFIRST then
            exit(EmpCategory."Use Grading System");
    end;

    procedure IsGradeValueValid(GradeCode: Code[10]; EmpCateg: Code[10]): Boolean;
    var
        GradeScale: Record "Grading Scale";
    begin
        if (GradeCode = '') or (EmpCateg = '') then
            exit(false);

        GradeScale.SETRANGE("Grade Code", GradeCode);
        GradeScale.SETRANGE("Employee Category", EmpCateg);
        if GradeScale.FINDFIRST then
            if not GradeScale."Is Inactive" then
                exit(true)
            else
                exit(false)
        else
            exit(false);
    end;

    procedure AttendanceRecManuallyModified(EmployeeNo: Code[20]; AttendanceDate: Date): Boolean;
    var
        EmpAbsence: Record "Employee Absence";
    begin
        EmpAbsence.RESET;
        EmpAbsence.SETRANGE("Employee No.", EmployeeNo);
        EmpAbsence.SETRANGE("From Date", AttendanceDate);
        if EmpAbsence.FINDFIRST then
            if (EmpAbsence."Attend Hrs." <> 0) or (EmpAbsence."Actual Attend Hrs" <> 0) or (EmpAbsence."Early Arrive" <> 0) or (EmpAbsence."Actual Early Arrive" <> 0)
            or (EmpAbsence."Late Arrive" <> 0) or (EmpAbsence."Actual Late Arrive" <> 0) or (EmpAbsence."Early Leave" <> 0)
            or (EmpAbsence."Actual Early Leave" <> 0) or (EmpAbsence."Late Leave" <> 0) or (EmpAbsence."Actual Late Leave" <> 0)
            or (EmpAbsence.Remarks <> '') or (EmpAbsence."Web Attend HRs" <> 0) then
                exit(true);

        exit(false);
    end;

    procedure IsValideSubPayrollPostingDate(PostingDate: Date): Boolean;
    var
        PayLedgEntry: Record "Payroll Ledger Entry";
    begin
        if PostingDate = 0D then
            exit(false);

        PayLedgEntry.SETFILTER("Sub Payroll Code", '=%1', '');
        PayLedgEntry.SETRANGE("Payroll Date", PostingDate);
        if PayLedgEntry.FINDFIRST then
            exit(true)
        else
            exit(false);
    end;

    procedure EmpHasAbsenceEntitlementRecord(EmpNo: Code[20]; AbsCode: Code[10]; DateV: Date) HasRec: Boolean;
    var
        EmpAbsEntitleTBT: Record "Employee Absence Entitlement";
        FDate: Date;
        TDate: Date;
    begin
        HasRec := false;

        EmpAbsEntitleTBT.SETCURRENTKEY("Employee No.", "Cause of Absence Code", "From Date", "Till Date");
        EmpAbsEntitleTBT.SETRANGE("Employee No.", EmpNo);
        EmpAbsEntitleTBT.SETRANGE("Cause of Absence Code", AbsCode);

        if DateV = 0D then
            DateV := WORKDATE;

        if EmpAbsEntitleTBT.FINDFIRST() then
            repeat
                if (DateV >= EmpAbsEntitleTBT."From Date") and (DateV <= EmpAbsEntitleTBT."Till Date") and (HasRec = false) then
                    HasRec := true;
            until EmpAbsEntitleTBT.NEXT = 0;
        exit(HasRec);
    end;

    procedure UpdateEmployeeNo(var Employee: Record Employee);
    var
        DimValue: Record "Dimension Value";
    begin
        Employee."Full Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
        DimValue.SETRANGE(Code, Employee."No.");
        if DimValue.FINDFIRST then begin
            DimValue.Name := COPYSTR(Employee."First Name", 1, 1) + '.' + Employee."Last Name";
            DimValue.MODIFY;
        end else begin
            DimValue.INIT;
            DimValue."Dimension Code" := 'EMPLOYEE';
            DimValue.Code := Employee."No.";
            DimValue.Name := COPYSTR(Employee."First Name", 1, 1) + '.' + Employee."Last Name";
            DimValue.INSERT(true);
        end;

        //Update Emp No (Change No. 01) - 07.11.2016 : MCHAMI +
        HumanResSetup.GET;
        if HumanResSetup."Employee No. Format Type" = HumanResSetup."Employee No. Format Type"::"[First Name] + [Last Name]" then begin
            Employee.RENAME(GetEmployeeNoFromName(Employee."First Name", Employee."Last Name"));
            Employee."Related to" := Employee."No.";
            Employee.MODIFY;
        end;
        //Update Emp No (Change No. 01) - 07.11.2016 : MCHAMI -
    end;

    procedure CalculateServiceYears(var Employee: Record Employee);
    var
        D: Integer;
        Y: Decimal;
    begin
        if Employee."Employment Date" = 0D then begin
            Employee."Service Years" := 0;
            Employee."Actual Service Years" := 0;
        end else begin
            D := WORKDATE - Employee."Employment Date";
            if D <= 0 then begin
                Employee."Service Years" := 0;
                Employee."Actual Service Years" := 0;
            end else begin
                Employee."Service Years" := DATE2DMY(WORKDATE, 3) - DATE2DMY(Employee."Employment Date", 3);
                Y := ROUND(D / 365, 0.01);
                Employee."Actual Service Years" := Y;
            end;
        end;
    end;

    procedure UpdatePayDetail(NewEmp: Boolean; var P_Rec: Record Employee; var P_xRec: Record Employee);
    var
        HourlyRate: Decimal;
        NoOfHours: Decimal;
        VExist: Boolean;
        PayDetailHeader: Record "Pay Detail Header";
        PayElement: Record "Pay Element";
        PayDetailLine: Record "Pay Detail Line";
        Loan: Record "Employee Loan";
        NextLineNo: Integer;
    begin
        //Added in order not insert records for PayDetailHeader,PayDetailLine and PayrollLedger entry in case no 'Payroll Group' is specified - 23.01.2017 : AIM +
        if P_Rec."Payroll Group Code" = '' then
            exit;
        //Added in order not insert records for PayDetailHeader,PayDetailLine and PayrollLedger entry in case no 'Payroll Group' is specified - 23.01.2017 : AIM -

        if P_Rec."Payroll Group Code" <> '' then
            if not Paystatus.GET(P_Rec."Payroll Group Code", P_Rec."Pay Frequency") then begin
                Paystatus.INIT;
                Paystatus."Payroll Group Code" := P_Rec."Payroll Group Code";
                Paystatus."Pay Frequency" := P_Rec."Pay Frequency";
                Paystatus.INSERT;
            end;

        if not PayDetailHeader.GET(P_Rec."No.") then begin
            PayDetailHeader.INIT;
            PayDetailHeader."Employee No." := P_Rec."No.";
            PayDetailHeader."Pay Frequency" := P_Rec."Pay Frequency";
            PayDetailHeader."Payroll Group Code" := P_Rec."Payroll Group Code";
            PayDetailHeader."Shortcut Dimension 1 Code" := P_Rec."Global Dimension 1 Code";
            PayDetailHeader."Shortcut Dimension 2 Code" := P_Rec."Global Dimension 2 Code";
            PayDetailHeader."Include in Pay Cycle" := true;
            PayDetailHeader.INSERT;
        end else begin
            PayDetailHeader."Calculation Required" := true;
            PayDetailHeader.MODIFY;
        end;

        PayParam.GET;
        PayElement.GET(PayParam."Basic Pay Code");

        if P_Rec.Status <> P_xRec.Status then begin
            if PayDetailHeader.GET(P_Rec."No.") then begin
                PayDetailHeader."Include in Pay Cycle" := true;
                if (Paystatus."Starting Payroll Day" = DATE2DMY(WORKDATE, 1)) and
                (P_Rec.Status <> P_Rec.Status::Active) then
                    PayDetailHeader."Include in Pay Cycle" := false;
                PayDetailHeader.MODIFY;
            end;

            if (P_Rec.Status = P_Rec.Status::Inactive) or (P_Rec.Status = P_Rec.Status::Terminated) then begin
                PayLedgEntry.RESET;
                PayLedgEntry.SETCURRENTKEY("Employee No.", Open);
                PayLedgEntry.SETRANGE("Employee No.", P_Rec."No.");
                PayLedgEntry.SETRANGE(Open, true);
                PayLedgEntry.DELETEALL;

                PayDetailLine.RESET;
                PayDetailLine.SETCURRENTKEY("Employee No.", Open);
                PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Payroll Special Code", true);
                PayDetailLine.DELETEALL;

                PayDetailLine.SETRANGE("Payroll Special Code");
                PayDetailLine.MODIFYALL("Tax Year", 0);
                PayDetailLine.MODIFYALL(Period, 0);
            end; // status : Inactive,Terminated
        end; // <> status

        //SB modify pay detail header/lines G.dimensions
        if (P_Rec."Global Dimension 1 Code" <> P_xRec."Global Dimension 1 Code") or
           (P_Rec."Global Dimension 2 Code" <> P_xRec."Global Dimension 2 Code") then begin
            PayDetailHeader.GET(P_Rec."No.");
            PayDetailHeader."Shortcut Dimension 1 Code" := P_Rec."Global Dimension 1 Code";
            PayDetailHeader."Shortcut Dimension 2 Code" := P_Rec."Global Dimension 2 Code";
            PayDetailHeader.MODIFY;
            PayDetailLine.RESET;
            PayDetailLine.SETCURRENTKEY("Employee No.", Open);
            PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.MODIFYALL("Shortcut Dimension 1 Code", P_Rec."Global Dimension 1 Code");
            PayDetailLine.MODIFYALL("Shortcut Dimension 2 Code", P_Rec."Global Dimension 2 Code");
        end;

        if (P_Rec."Pay Frequency" <> P_xRec."Pay Frequency") or
           (P_Rec."Payroll Group Code" <> P_xRec."Payroll Group Code")
        then begin
            PayDetailHeader.GET(P_Rec."No.");
            PayDetailHeader."Pay Frequency" := P_Rec."Pay Frequency";
            PayDetailHeader."Payroll Group Code" := P_Rec."Payroll Group Code";
            PayDetailHeader.MODIFY;

            PayLedgEntry.RESET;
            PayLedgEntry.SETCURRENTKEY("Employee No.", Open);
            PayLedgEntry.SETRANGE("Employee No.", P_Rec."No.");
            PayLedgEntry.SETRANGE(Open, true);
            PayLedgEntry.MODIFYALL("Pay Frequency", P_Rec."Pay Frequency");
            PayLedgEntry.MODIFYALL("Payroll Group Code", P_Rec."Payroll Group Code");
            PayDetailLine.RESET;
            PayDetailLine.SETCURRENTKEY("Employee No.", Open);
            PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.MODIFYALL("Payroll Group Code", P_Rec."Payroll Group Code");
            PayDetailLine.MODIFYALL("Pay Frequency", P_Rec."Pay Frequency");
            Loan.RESET;
            Loan.SETRANGE("Employee No.", P_Rec."No.");
            Loan.MODIFYALL("Payroll Group Code", P_Rec."Payroll Group Code");
        end;

        // Update Basic Pay record in Pay Detail Lines
        if (P_Rec."Basic Pay" <> P_xRec."Basic Pay") or (NewEmp) or
           (P_Rec."Salary (ACY)" <> P_xRec."Salary (ACY)") then begin
            PayDetailLine.RESET;
            PayDetailLine.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
            PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Pay Element Code", PayParam."Basic Pay Code");
            if PayDetailLine.FIND('-') then begin
                if PayDetailLine.Amount <> P_Rec."Basic Pay" then begin
                    PayDetailLine.Amount := P_Rec."Basic Pay";
                    PayDetailLine."Calculated Amount" := 0;
                end;
                if PayDetailLine."Amount (ACY)" <> P_Rec."Salary (ACY)" then begin
                    PayDetailLine."Amount (ACY)" := P_Rec."Salary (ACY)";
                    PayDetailLine."Calculated Amount (ACY)" := 0;
                end;
                PayDetailLine.MODIFY;
            end else begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
                if PayDetailLine.FIND('+') then
                    NextLineNo := PayDetailLine."Line No." + 1
                else
                    NextLineNo := 1;
                PayDetailLine.INIT;
                PayDetailLine."Employee No." := P_Rec."No.";
                PayDetailLine."Line No." := NextLineNo;
                PayDetailLine."Pay Element Code" := PayParam."Basic Pay Code";
                PayDetailLine.Description := PayElement.Description;
                PayDetailLine.Recurring := true;
                PayDetailLine.Type := PayElement.Type;
                PayDetailLine."Pay Frequency" := P_Rec."Pay Frequency";
                PayDetailLine.Open := true;
                PayDetailLine."Payroll Group Code" := P_Rec."Payroll Group Code";
                PayDetailLine."Shortcut Dimension 1 Code" := P_Rec."Global Dimension 1 Code";
                PayDetailLine."Shortcut Dimension 2 Code" := P_Rec."Global Dimension 2 Code";
                PayDetailLine.INSERT;
            end; // pay detail not F.
        end; // <> basic pay

        // updt fam.allow - tax.trsp - nontax.trsp
        //del.fam.allow
        PayDetailLine.RESET;
        PayDetailLine.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
        PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.SETRANGE("Pay Element Code", PayParam."Family Allowance Code");
        if PayDetailLine.FIND('-') then
            PayDetailLine.DELETE;
        //del.nonTax.trsp
        PayDetailLine.RESET;
        PayDetailLine.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
        PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.SETRANGE("Pay Element Code", PayParam."Non-Taxable Transp. Code");
        if PayDetailLine.FIND('-') then
            PayDetailLine.DELETE;
        //del.tax.trsp
        PayDetailLine.RESET;
        PayDetailLine.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
        PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.SETRANGE("Pay Element Code", PayParam."Mobile allowance");
        if PayDetailLine.FIND('-') then
            PayDetailLine.DELETE;
        Loop := 1;
        while Loop <= 3 do begin
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
            if PayDetailLine.FIND('+') then
                NextLineNo := PayDetailLine."Line No." + 1
            else
                NextLineNo := 1;
            PayDetailLine.INIT;
            PayDetailLine."Employee No." := P_Rec."No.";
            PayDetailLine."Line No." := NextLineNo;
            PayDetailLine.Recurring := true;
            PayDetailLine."Pay Frequency" := P_Rec."Pay Frequency";
            PayDetailLine.Open := true;
            PayDetailLine."Payroll Group Code" := P_Rec."Payroll Group Code";
            PayDetailLine."Shortcut Dimension 1 Code" := P_Rec."Global Dimension 1 Code";
            PayDetailLine."Shortcut Dimension 2 Code" := P_Rec."Global Dimension 2 Code";
            VExist := false;
            case Loop of
                1:
                    begin
                        if PayElement.GET(PayParam."Family Allowance Code") then
                            VExist := true;
                    end;
                2:
                    begin
                        if PayElement.GET(PayParam."Non-Taxable Transp. Code") then
                            VExist := true;
                    end;
                3:
                    begin
                        if PayElement.GET(PayParam."Mobile allowance") then
                            VExist := true;
                    end;
            end; //case
            if VExist then begin
                PayDetailLine."Pay Element Code" := PayElement.Code;
                PayDetailLine.Description := PayElement.Description;
                PayDetailLine.Type := PayElement.Type;
                PayDetailLine."Payroll Special Code" := PayElement."Payroll Special Code";
                GetSpePayAmount(PayElement.Code, P_Rec, PayDetailLine);
                PayDetailLine.INSERT;
            end; //exist
            Loop := Loop + 1;
        end; // loop
    end;

    procedure ReCalcWarning(var Employee: Record Employee; var xEmployee: Record Employee);
    var
        PayDetailHeader: Record "Pay Detail Header";
        PayDetailLine: Record "Pay Detail Line";
    begin
        //Modified in order not insert records for PayDetailHeader,PayDetailLine and PayrollLedger entry in case no 'Payroll Group' is specified - 23.01.2017 : AIM +
        PayDetailHeader.SETRANGE("Employee No.", Employee."No.");
        if not PayDetailHeader.FINDFIRST then
            exit;
        //Modified in order not insert records for PayDetailHeader,PayDetailLine and PayrollLedger entry in case no 'Payroll Group' is specified - 23.01.2017 : AIM -

        if PayDetailHeader."Calculation Required" then
            exit;

        Paystatus.RESET;
        if not Paystatus.GET(xEmployee."Payroll Group Code", xEmployee."Pay Frequency") then
            if not Paystatus.GET(Employee."Payroll Group Code", Employee."Pay Frequency") then
                exit;

        if not CONFIRM(
          'The Current Period has not been Finalised.\' +
          'Re-calculation may be Necessary if you Modify the Contents of this Field.\\' +
          'Do you want to continue?', false)
        then
            ERROR('Changes were not Saved.');

        PayDetailHeader."Calculation Required" := true;
        PayDetailHeader."Payslip Printed" := false;
        PayDetailHeader.MODIFY;
        if xEmployee."Payroll Group Code" <> Employee."Payroll Group Code" then begin
            PayDetailLine.SETCURRENTKEY("Employee No.", Open);
            PayDetailLine.SETRANGE("Employee No.", Employee."No.");
            PayDetailLine.SETRANGE(Open, true);
            if PayDetailLine.FINDFIRST then
                repeat
                    PayDetailLine."Payroll Group Code" := Employee."Payroll Group Code";
                    PayDetailLine.MODIFY;
                until PayDetailLine.NEXT = 0;
        end
    end;

    procedure ChkRelCodeUnique(var Rec: Record "Employee Relative"; var xRec: Record "Employee Relative"; P_Type: Code[10]);
    var
        Text001: Label 'Relative Code must be Unique';
        EmpRelative: Record "Employee Relative";
    begin
        //shr2.0
        EmpRelative.RESET;
        EmpRelative.SETRANGE("Employee No.", Rec."Employee No.");
        EmpRelative.SETRANGE("Relative Code", Rec."Relative Code");
        if P_Type = 'I' then begin
            if EmpRelative.FINDFIRST then
                ERROR(Text001);
        end else begin
            if EmpRelative.FINDFIRST then
                repeat
                    if xRec."Relative Code" <> EmpRelative."Relative Code" then
                        if EmpRelative."Relative Code" = Rec."Relative Code" then
                            ERROR(Text001);
                until EmpRelative.NEXT = 0;
        end; //'M'
    end;

    procedure RecalSpePayWarning();
    var
        PayDetailLine: Record "Pay Detail Line";
    begin
        // Readjust all pay detail related to the modified SpeE
        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            PayParam.GET;
            PayDetailLine.RESET;
            PayDetailLine.SETCURRENTKEY(Open, Type, "Pay Element Code");
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Pay Element Code", PayParam."Family Allowance Code");
            if PayDetailLine.FINDFIRST then begin
                if not CONFIRM('ReCalculation Function on Pay Details is Required . Do you want to Continue ?', true) then
                    ERROR('Operation Aborted !');
            end;
        end;
    end;

    procedure CanModifyAttendanceRecord(AttDate: Date; EmpNo: Code[20]) CanEdit: Boolean;
    var
        Employee: Record Employee;
        PayrollStatus: Record "Payroll Status";
        HRSetup: Record "Human Resources Setup";
    begin
        if (AttDate = 0D) or (EmpNo = '') then
            exit(false);

        CanEdit := false;
        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then
            if Employee.Period <> 0D then
                if not IsSeparateAttendanceInterval(Employee."Payroll Group Code") then begin
                    if AttDate >= Employee.Period then
                        CanEdit := true;
                end
                else begin
                    HRSetup.GEt;
                    IF HRSetup."Seperate Attend From Payroll" THEN begin
                        PayrollStatus.RESET;
                        PayrollStatus.SETRANGE("Payroll Group Code", Employee."Payroll Group Code");
                        if PayrollStatus.FINDFIRST then begin
                            if (PayrollStatus."Separate Attendance Interval") and (PayrollStatus."Attendance Start Date" <> 0D) and
                            (PayrollStatus."Attendance End Date" <> 0D) then begin
                                if (AttDate >= PayrollStatus."Attendance Start Date") and (AttDate <= PayrollStatus."Attendance End Date") then
                                    CanEdit := true;
                            end;
                        end;
                    end
                    ELSE begin
                        PayrollStatus.RESET;
                        PayrollStatus.SETRANGE("Payroll Group Code", Employee."Payroll Group Code");
                        if PayrollStatus.FINDFIRST then begin
                            if (PayrollStatus."Separate Attendance Interval") and (PayrollStatus."Attendance Start Date" <> 0D) and
                                (PayrollStatus."Attendance End Date" <> 0D) and (DATE2DMY(PayrollStatus."Payroll Date", 2) = DATE2DMY(PayrollStatus."Attendance End Date", 2))
                            //and (DATE2DMY(PayrollStatus."Payroll Date",3) = DATE2DMY(PayrollStatus."Attendance End Date",3)) then
                            THEN begin
                                if (AttDate >= PayrollStatus."Attendance Start Date") and (AttDate <= PayrollStatus."Attendance End Date") then
                                    CanEdit := true;
                            end;
                        end;
                    end;
                end;
        //Modified in order to consider Attendance Interval - 18.09.2017 : A2-
        IF CanEdit THEN
            IF CanModifyEmployeeAttendance(EmpNo, AttDate, AttDate, TRUE) THEN
                CanEdit := TRUE;

        exit(CanEdit);
    end;

    procedure GetDimensionNo(DimCode: Code[20]): Integer;
    var
        i: Integer;
    begin
        GLSetup.GET;
        for i := 3 to 8 do begin
            case i of
                3:
                    if GLSetup."Shortcut Dimension 3 Code" <> '' then
                        if GLSetup."Shortcut Dimension 3 Code" = DimCode then
                            exit(i);
                4:
                    if GLSetup."Shortcut Dimension 4 Code" <> '' then
                        if GLSetup."Shortcut Dimension 4 Code" = DimCode then
                            exit(i);
                5:
                    if GLSetup."Shortcut Dimension 5 Code" <> '' then
                        if GLSetup."Shortcut Dimension 5 Code" = DimCode then
                            exit(i);
                6:
                    if GLSetup."Shortcut Dimension 6 Code" <> '' then
                        if GLSetup."Shortcut Dimension 6 Code" = DimCode then
                            exit(i);
                7:
                    if GLSetup."Shortcut Dimension 7 Code" <> '' then
                        if GLSetup."Shortcut Dimension 7 Code" = DimCode then
                            exit(i);
                8:
                    if GLSetup."Shortcut Dimension 8 Code" <> '' then
                        if GLSetup."Shortcut Dimension 8 Code" = DimCode then
                            exit(i);
            end;
        end;
    end;

    procedure RunWorkflowOnSendCalculatePayForApprovalCode(): Code[128];
    begin
        exit(UPPERCASE('RunWorkflowOnSendCalculatePayForApproval'));
    end;

    procedure RunWorkflowOnSendPaySlipForApprovalCode(): Code[128];
    begin
        exit(UPPERCASE('RunWorkflowOnSendPaySlipForApproval'));
    end;

    procedure RunWorkflowOnSendFinalizePayForApprovalCode(): Code[128];
    begin
        exit(UPPERCASE('RunWorkflowOnSendFinalizePayForApproval'));
    end;

    procedure RunWorkflowOnSendSalaryRaiseForApprovalCode(): Code[128];
    begin
        exit(UPPERCASE('RunWorkflowOnSendSalaryRaiseForApproval'));
    end;

    procedure HasOpenApprovalEntriesWithField(RecordID: RecordID; FieldNumber: Integer): Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        //EDM.Contracting+
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", false);
        ApprovalEntry.SETRANGE("Approval Field Number", FieldNumber);
        exit(not ApprovalEntry.ISEMPTY);
        //EDM.Contracting-
    end;

    procedure CheckCalculatePayApprovalsWorkflowEnabled(var PayDetailsApproval: Record "Pay Details Approval"): Boolean;
    begin

        if not WorkflowManagement.CanExecuteWorkflow(PayDetailsApproval, RunWorkflowOnSendCalculatePayForApprovalCode) then
            ERROR(NoWorkflowEnabledErr);

        exit(true);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendCalculatePayForApproval(var PayDetailsApproval: Record "Pay Details Approval");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelCalculatePayApprovalRequest(var PayDetailsApproval: Record "Pay Details Approval");
    begin
    end;

    procedure CheckPaySlipApprovalsWorkflowEnabled(var PayDetailsApproval: Record "Pay Details Approval"): Boolean;
    begin

        if not WorkflowManagement.CanExecuteWorkflow(PayDetailsApproval, RunWorkflowOnSendPaySlipForApprovalCode) then
            ERROR(NoWorkflowEnabledErr);

        exit(true);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPaySlipForApproval(var PayDetailsApproval: Record "Pay Details Approval");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPaySlipApprovalRequest(var PayDetailsApproval: Record "Pay Details Approval");
    begin
    end;

    procedure CheckFinalizePayApprovalsWorkflowEnabled(var PayDetailsApproval: Record "Pay Details Approval"): Boolean;
    begin

        if not WorkflowManagement.CanExecuteWorkflow(PayDetailsApproval, RunWorkflowOnSendFinalizePayForApprovalCode) then
            ERROR(NoWorkflowEnabledErr);

        exit(true);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendFinalizePayForApproval(var PayDetailsApproval: Record "Pay Details Approval");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelFinalizePayApprovalRequest(var PayDetailsApproval: Record "Pay Details Approval");
    begin
    end;

    procedure CheckSalaryRaiseApprovalsWorkflowEnabled(var EmployeeSalaryHistory: Record "Employee Salary History"): Boolean;
    begin

        if not WorkflowManagement.CanExecuteWorkflow(EmployeeSalaryHistory, RunWorkflowOnSendSalaryRaiseForApprovalCode) then
            ERROR(NoWorkflowEnabledErr);

        exit(true);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendSalaryRaiseForApproval(var EmployeeSalaryHistory: Record "Employee Salary History");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelSalaryRaiseApprovalRequest(var EmployeeSalaryHistory: Record "Employee Salary History");
    begin
    end;

    procedure GetEmployeeNumberOfDocuments(EmployeeNo: Code[20]): Integer;
    var
        RequestedDocument: Record "Requested Documents";
    begin
        RequestedDocument.RESET;
        RequestedDocument.SETRANGE("No.", EmployeeNo);
        if RequestedDocument.FINDFIRST then
            exit(RequestedDocument.COUNT);

        exit(0);
    end;

    procedure GetEmployeeSalaryInfoBeforeChange(var Employee: Record Employee);
    begin
        ExtraSalaryPrevious := 0;
        EmpAddInfo.RESET;
        CLEAR(EmpAddInfo);
        if EmpAddInfo.GET(Employee."No.") then
            ExtraSalaryPrevious := EmpAddInfo."Extra Salary";

        BasicPrevious := Employee."Basic Pay";
        CostofLivingPrevious := Employee."Cost of Living";
        CarAllPrevious := Employee."Car Allowance";
        PhoneAllPrevous := Employee."Phone Allowance";
        HouseAllPrevious := Employee."House Allowance";
        FoodAllPrevious := Employee."Food Allowance";
        TicketAllPrevious := Employee."Ticket Allowance";
        OtherAllPrevious := Employee."Other Allowances";
        TotalPrevious := CaluclateTotalAllowances(Employee, ExtraSalaryPrevious);
        InsurencePrevious := Employee."Insurance Contribution";
    end;

    procedure CaluclateTotalAllowances(var Employee: Record Employee; ExtraSalary: Decimal): Decimal;
    var
        V: Decimal;
        PayrollParameterRec: Record "Payroll Parameter";
        HalfV: Decimal;
        HalfVConverted: Decimal;
    begin
        V := 0;
        V += Employee."Basic Pay";
        V += Employee."Cost of Living";
        V += Employee."Phone Allowance";
        V += Employee."Car Allowance";
        V += Employee."House Allowance";
        V += Employee."Other Allowances";
        V += Employee."Food Allowance";
        V += Employee."Ticket Allowance";
        V += ExtraSalary;
        V += Employee."Commission Amount";
        V += Employee."Commission Addition";
        V += Employee."Cost of Living Amount";
        V += Employee."Water Compensation";
        exit(V);
    end;

    procedure CaluclateTotalAllowancesBasic(var Employee: Record Employee; ExtraSalary: Decimal): Decimal;
    var
        V: Decimal;
        PayrollParameterRec: Record "Payroll Parameter";
        HalfV: Decimal;
        HalfVConverted: Decimal;
    begin
        V := 0;
        V += Employee."Basic Pay";
        V += ExtraSalary;
        exit(V);
    end;

    procedure UpdateSalaryHistory(var Employee: Record Employee);
    var
        EmployeeSalaryHistory: Record "Employee Salary History";
    begin
        EmployeeSalaryHistory.INIT();

        EmployeeSalaryHistory."Basic Previous" := BasicPrevious;
        EmployeeSalaryHistory."Cost of Living" := CostofLivingPrevious;
        EmployeeSalaryHistory."Phone Previous" := PhoneAllPrevous;
        EmployeeSalaryHistory."Car Previous" := CarAllPrevious;
        EmployeeSalaryHistory."House Previous" := HouseAllPrevious;
        EmployeeSalaryHistory."Food Previous" := FoodAllPrevious;
        EmployeeSalaryHistory."Ticket Previous" := TicketAllPrevious;
        EmployeeSalaryHistory."Other Previous" := OtherAllPrevious;
        EmployeeSalaryHistory."Total Previous" := TotalPrevious;
        EmployeeSalaryHistory."Insurence Previous" := InsurencePrevious;

        EmployeeSalaryHistory."Basic Pay" := Employee."Basic Pay";
        EmployeeSalaryHistory."Cost of Living" := Employee."Cost of Living";
        EmployeeSalaryHistory."Phone Allowance" := Employee."Phone Allowance";
        EmployeeSalaryHistory."Car Allowance" := Employee."Car Allowance";
        EmployeeSalaryHistory."House Allowance" := Employee."House Allowance";
        EmployeeSalaryHistory."Food Allowance" := Employee."Food Allowance";
        EmployeeSalaryHistory."Ticket Allowance" := Employee."Ticket Allowance";
        EmployeeSalaryHistory."Other Allowance" := Employee."Other Allowances";
        EmployeeSalaryHistory."TotalPay&Allow" := CaluclateTotalAllowances(Employee, 0);
        EmployeeSalaryHistory."Insurence Contribution" := Employee."Insurance Contribution";

        EmployeeSalaryHistory."Modified Date" := WORKDATE;
        EmployeeSalaryHistory."Modified Time" := SYSTEM.TIME;
        EmployeeSalaryHistory."Modified By" := USERID;

        EmployeeSalaryHistory."Change Status" := EmployeeSalaryHistory."Change Status"::Approved;
        EmployeeSalaryHistory."Employee No." := Employee."No.";
        EmployeeSalaryHistory."Source Type" := EmployeeSalaryHistory."Source Type"::"Auto-Save";
        EmployeeSalaryHistory.INSERT;
    end;

    procedure SaveEmployeeSalaryHistory(var Employee: Record Employee);
    begin
        if (Employee."Basic Pay" <> BasicPrevious) or (Employee."Cost of Living" <> CostofLivingPrevious) or(Employee."Car Allowance" <> CarAllPrevious)
          or (Employee."Phone Allowance" <> PhoneAllPrevous) or (Employee."House Allowance" <> HouseAllPrevious)
          or (Employee."Food Allowance" <> FoodAllPrevious) or (Employee."Ticket Allowance" <> TicketAllPrevious)
          or (Employee."Other Allowances" <> OtherAllPrevious) or (Employee."Insurance Contribution" <> InsurencePrevious)
        then
            UpdateSalaryHistory(Employee);
    end;

    procedure SaveEmpDimension(var Employee: Record Employee);
    var
        DefDimension: Record "Default Dimension";
        GenLedgSetup: Record "General Ledger Setup";
    begin
        DefDimension.SETRANGE("Table ID", 5200);
        DefDimension.SETRANGE("No.", Employee."No.");
        DefDimension.SETRANGE("Dimension Code", 'EMPLOYEE');
        if not DefDimension.FINDFIRST then begin
            DefDimension.INIT;
            DefDimension."Table ID" := 5200;
            DefDimension."No." := Employee."No.";
            DefDimension."Dimension Code" := 'EMPLOYEE';
            DefDimension."Dimension Value Code" := Employee."No.";
            DefDimension.INSERT;
        end;
    end;

    procedure GetEmployeeLastFinalizedPayDate(var Employee: Record Employee): Date;
    var
        PayLedgEntry: Record "Payroll Ledger Entry";
    begin
        PayLedgEntry.SETRANGE("Employee No.", Employee."No.");
        PayLedgEntry.SETFILTER("Posting Date", '<>%1', 0D);
        if PayLedgEntry.FINDLAST then
            exit(PayLedgEntry."Posting Date");

        exit(0D);
    end;

    procedure InsertEmployeeInfoFromRelatedFile(var Employee: Record Employee; EmpNo: Code[20]; RelatedToCode: Code[20]; ShowWarningMsg: Boolean);
    var
        RelatedFile: Record Employee;
        EmpRelatives: Record "Employee Relative";
        EmpQualifications: Record "Employee Qualification";
        EmpAcademicHist: Record "Academic History";
        EmpLangSkills: Record "Language Skills";
        EmpCompSkills: Record "Employee Computer Skills";
        EmpDoc: Record "Requested Documents";
        RelRelatives: Record "Employee Relative";
        RelQualifications: Record "Employee Qualification";
        RelAcademicHist: Record "Academic History";
        RelLangSkills: Record "Language Skills";
        RelCompSkills: Record "Employee Computer Skills";
        RelDoc: Record "Requested Documents";
    begin
        if RelatedToCode = '' then
            exit;

        if ShowWarningMsg = true then begin
            if not CONFIRM('Are you sure you want to import data from employee %1', false, Employee."Related to") then
                exit;
            if EmpNo = '' then
                ERROR('Enter Employee No.');
        end else begin
            if EmpNo = '' then
                exit;
        end;

        RelatedFile.RESET;
        RelatedFile.SETRANGE("No.", RelatedToCode);
        if RelatedFile.FINDFIRST then begin
            Employee.TRANSFERFIELDS(RelatedFile, false);
            Employee."No." := EmpNo;
            Employee."Related to" := RelatedToCode;
            Employee.Status := Employee.Status::Active;
            Employee."Termination Date" := 0D;
            Employee."Grounds for Term. Code" := '';
            Employee."Inactive Date" := 0D;
            Employee."Cause of Inactivity Code" := '';
            Employee."Declaration Date" := 0D;
            Employee."NSSF Date" := 0D;
            Employee."AL Starting Date" := 0D;
            Employee.Period := 0D;
            Employee."Employment Date" := WORKDATE;
            Employee.VALIDATE("Employment Date");
            //EDM+ 30-05-2020
            RelatedFile.CALCFIELDS(Image);
            Employee.Image := RelatedFile.Image;
            //EDM- 30-05-2020 
        end else
            exit;

        //********************************************************************
        EmpRelatives.RESET;
        EmpRelatives.SETRANGE(EmpRelatives."Employee No.", EmpNo);
        EmpRelatives.DELETEALL;

        RelRelatives.RESET;
        RelRelatives.SETRANGE(RelRelatives."Employee No.", RelatedToCode);
        if RelRelatives.FINDFIRST then
            repeat
                EmpRelatives.INIT;
                EmpRelatives.TRANSFERFIELDS(RelRelatives);
                EmpRelatives."Employee No." := EmpNo;
                EmpRelatives.INSERT;
            until RelRelatives.NEXT = 0;
        //********************************************************************
        EmpQualifications.RESET;
        EmpQualifications.SETRANGE(EmpQualifications."Employee No.", EmpNo);
        EmpQualifications.DELETEALL;

        RelQualifications.RESET;
        RelQualifications.SETRANGE(RelQualifications."Employee No.", RelatedToCode);
        if RelQualifications.FINDFIRST then
            repeat
                EmpQualifications.INIT;
                EmpQualifications.TRANSFERFIELDS(RelQualifications);
                EmpQualifications."Employee No." := EmpNo;
                EmpQualifications.INSERT;
            until RelQualifications.NEXT = 0;
        //********************************************************************
        EmpAcademicHist.RESET;
        EmpAcademicHist.SETRANGE(EmpAcademicHist."No.", EmpNo);
        EmpAcademicHist.SETRANGE(EmpAcademicHist."Table Name", EmpAcademicHist."Table Name"::Employee);
        EmpAcademicHist.DELETEALL;

        RelAcademicHist.RESET;
        RelAcademicHist.SETRANGE(RelAcademicHist."No.", RelatedToCode);
        RelAcademicHist.SETRANGE(RelAcademicHist."Table Name", RelAcademicHist."Table Name"::Employee);
        if RelAcademicHist.FINDFIRST then
            repeat
                EmpAcademicHist.INIT;
                EmpAcademicHist.TRANSFERFIELDS(RelAcademicHist);
                EmpAcademicHist."No." := EmpNo;
                EmpAcademicHist.INSERT;
            until RelAcademicHist.NEXT = 0;
        //********************************************************************
        EmpLangSkills.RESET;
        EmpLangSkills.SETRANGE(EmpLangSkills."No.", EmpNo);
        EmpLangSkills.SETRANGE(EmpLangSkills."Table Name", EmpLangSkills."Table Name"::Employee);
        EmpLangSkills.DELETEALL;

        RelLangSkills.RESET;
        RelLangSkills.SETRANGE(RelLangSkills."No.", RelatedToCode);
        RelLangSkills.SETRANGE(RelLangSkills."Table Name", RelLangSkills."Table Name"::Employee);
        if RelLangSkills.FINDFIRST then
            repeat
                EmpLangSkills.INIT;
                EmpLangSkills.TRANSFERFIELDS(RelLangSkills);
                EmpLangSkills."No." := EmpNo;
                EmpLangSkills.INSERT;
            until RelLangSkills.NEXT = 0;
        //********************************************************************
        EmpCompSkills.RESET;
        EmpCompSkills.SETRANGE(EmpCompSkills."Employee No.", EmpNo);
        EmpCompSkills.DELETEALL;

        RelCompSkills.RESET;
        RelCompSkills.SETRANGE(RelCompSkills."Employee No.", RelatedToCode);
        if RelCompSkills.FINDFIRST then
            repeat
                EmpCompSkills.INIT;
                EmpCompSkills.TRANSFERFIELDS(RelCompSkills);
                EmpCompSkills."Employee No." := EmpNo;
                EmpCompSkills.INSERT;
            until RelCompSkills.NEXT = 0;
        //********************************************************************
        EmpDoc.RESET;
        EmpDoc.SETRANGE(EmpDoc."No.", EmpNo);
        EmpDoc.SETRANGE(EmpDoc."Table Name", EmpDoc."Table Name"::Employee);
        EmpDoc.DELETEALL;

        RelDoc.RESET;
        RelDoc.SETRANGE(RelDoc."No.", RelatedToCode);
        RelDoc.SETRANGE(RelDoc."Table Name", RelDoc."Table Name"::Employee);
        if RelDoc.FINDFIRST then
            repeat
                EmpDoc.INIT;
                EmpDoc.TRANSFERFIELDS(RelDoc);
                EmpDoc."No." := EmpNo;
                EmpDoc.INSERT;
            until RelDoc.NEXT = 0;
        //********************************************************************
    end;

    procedure GetTaxableSalary(EmployeeNo: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        PayDetailLine: Record "Pay Detail Line";
        TotalTaxSalary: Decimal;
        PayElement: Record "Pay Element";
    begin
        TotalTaxSalary := 0;
        PayDetailLine.RESET;
        PayDetailLine.SETRANGE("Employee No.", EmployeeNo);
        PayDetailLine.SETRANGE("Payroll Date", FromDate, ToDate);
        IF PayDetailLine.FINDFIRST THEN
            REPEAT
                IF PayElement.GET(PayDetailLine."Pay Element Code") THEN
                    IF PayElement.Tax THEN
                        TotalTaxSalary += PayDetailLine."Calculated Amount";
            UNTIL PayDetailLine.NEXT = 0;

        EXIT(TotalTaxSalary);
    end;

    procedure GetNSSFAmountOfTypeClassification(EmployeeNo: Code[20]; FromDate: Date; ToDate: Date; ClassificationType: Option " ","FIXED",VARIABLE): Decimal;
    var
        PayDetailLine: Record "Pay Detail Line";
        TotalNSSFAmount: Decimal;
        PayElement: Record "Pay Element";
    begin
        TotalNSSFAmount := 0;
        PayDetailLine.RESET;
        PayDetailLine.SETRANGE("Employee No.", EmployeeNo);
        PayDetailLine.SETRANGE("Payroll Date", FromDate, ToDate);
        IF PayDetailLine.FINDFIRST THEN
            REPEAT
                IF PayElement.GET(PayDetailLine."Pay Element Code") THEN
                    IF (PayElement."Affect NSSF") AND (PayElement."Type Classification" = ClassificationType) THEN
                        TotalNSSFAmount += PayDetailLine."Calculated Amount";
            UNTIL PayDetailLine.NEXT = 0;

        EXIT(TotalNSSFAmount);
    end;

    procedure GetNSSFPercentOfTypeClassification(EmployeeNo: Code[20]; ClassificationType: Option " ","FIXED",VARIABLE): Decimal;
    var
        PensionScheme: Record "Pension Scheme";
        Employee: Record Employee;
    begin
        IF Employee.GET(EmployeeNo) THEN BEGIN
            PensionScheme.RESET;
            IF ClassificationType = ClassificationType::FIXED THEN
                PensionScheme.SETRANGE(Type, PensionScheme.Type::MHOOD)
            ELSE
                IF ClassificationType = ClassificationType::VARIABLE THEN
                    PensionScheme.SETRANGE(Type, PensionScheme.Type::FAMSUB);
            PensionScheme.SETRANGE("Amount Type Classification", ClassificationType);
            PensionScheme.SETRANGE("Payroll Posting Group", Employee."Posting Group");
            IF PensionScheme.FINDFIRST THEN
                EXIT(PensionScheme."Employee Contribution %");
        END;

        EXIT(0);
    end;

    local procedure FixLunchBreakTime(ShiftCode: Code[10]; var FromTime: DateTime; var ToTime: DateTime; AttendanceNo: Integer);
    var
        DailyShifts: Record "Daily Shifts";
        LunchStartTime: Time;
        LunchEndTime: Time;
        LunchEndTimeWithTolerance: Time;
    begin
        IF DailyShifts.GET(ShiftCode) THEN BEGIN
            IF NOT DailyShifts."Force Lunch Break" THEN
                EXIT;
            IF DailyShifts."Lunch Break Start time" = 0T THEN
                EXIT;
            IF DailyShifts."Allowed Break Minute" <= 0 THEN
                EXIT;
        END ELSE
            EXIT;

        LunchStartTime := DailyShifts."Lunch Break Start time";
        LunchEndTime := DailyShifts."Lunch Break Start time" + (DailyShifts."Allowed Break Minute" * 60000);
        LunchEndTimeWithTolerance := LunchEndTime + (DailyShifts."Lunch Break Tolerance" * 60000);

        IF ((FromTime <> 0DT) AND (ToTime <> 0DT)) THEN BEGIN
            IF NOT HasLunchBreakPunch(AttendanceNo, DT2DATE(FromTime), LunchStartTime, LunchEndTimeWithTolerance) THEN BEGIN
                FromTime := 0DT;
                ToTime := 0DT;
                EXIT;
            END;

            IF (DT2TIME(FromTime) <= LunchStartTime) AND (DT2TIME(ToTime) <= LunchStartTime) THEN
                EXIT
            ELSE
                IF (DT2TIME(FromTime) < LunchStartTime) AND ((DT2TIME(ToTime) >= LunchStartTime) AND (DT2TIME(ToTime) <= LunchEndTime)) THEN
                    ToTime := CREATEDATETIME(DT2DATE(ToTime), LunchStartTime)
                ELSE
                    IF (DT2TIME(FromTime) < LunchStartTime) AND ((DT2TIME(ToTime) > LunchEndTime)) THEN BEGIN
                        FromTime := 0DT;
                        ToTime := 0DT;
                    END ELSE
                        IF (DT2TIME(FromTime) >= LunchStartTime) AND ((DT2TIME(ToTime) <= LunchEndTime)) THEN BEGIN
                            FromTime := 0DT;
                            ToTime := 0DT;
                        END ELSE
                            IF ((DT2TIME(FromTime) >= LunchStartTime) AND (DT2TIME(FromTime) <= LunchEndTime)) AND (DT2TIME(ToTime) >= LunchEndTime) THEN
                                FromTime := CREATEDATETIME(DT2DATE(FromTime), LunchEndTime)
                            ELSE
                                IF ((DT2TIME(FromTime) >= LunchEndTime) AND (DT2TIME(FromTime) <= LunchEndTimeWithTolerance)) AND (DT2TIME(ToTime) >= LunchEndTime) THEN
                                    FromTime := CREATEDATETIME(DT2DATE(FromTime), LunchEndTime)
                                ELSE
                                    IF (DT2TIME(FromTime) >= LunchEndTime) AND (DT2TIME(ToTime) >= LunchEndTime) THEN
                                        EXIT;
        END;
    end;

    local procedure HasLunchBreakPunch(AttendanceNumber: Integer; AttendanceDate: Date; LunchStartTime: Time; LunchEndTime: Time): Boolean;
    var
        HandPunch: Record "Hand Punch";
    begin
        HandPunch.RESET;
        HandPunch.SETRANGE("Attendnace No.", AttendanceNumber);
        HandPunch.SETRANGE("Real Date", AttendanceDate);
        HandPunch.SETRANGE("Real Time", LunchStartTime, LunchEndTime);
        IF HandPunch.FINDFIRST THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure CauseofAbsenceAffectsTransport(CauseCode: Code[20]) IsAffect: Boolean;
    var
        L_CauseofAbsenceTbt: Record "Cause of Absence";
    begin
        IF CauseCode = '' THEN
            EXIT(FALSE);

        IsAffect := FALSE;

        L_CauseofAbsenceTbt.SETRANGE(L_CauseofAbsenceTbt.Code, CauseCode);
        IF L_CauseofAbsenceTbt.FINDFIRST THEN BEGIN
            IsAffect := L_CauseofAbsenceTbt."Affect Attendance Days";
        END;


        EXIT(IsAffect);
    end;

    procedure ShiftCodeAffectsTransport(ShiftCode: Code[20]) IsAffect: Boolean;
    var
        L_ShiftTbt: Record "Daily Shifts";
    begin
        IF ShiftCode = '' THEN
            EXIT(FALSE);

        IsAffect := FALSE;

        L_ShiftTbt.SETRANGE(L_ShiftTbt."Shift Code", ShiftCode);
        IF L_ShiftTbt.FINDFIRST THEN BEGIN
            IF L_ShiftTbt."Cause Code" <> '' THEN BEGIN
                IsAffect := CauseofAbsenceAffectsTransport(L_ShiftTbt."Cause Code");
            END;
        END;


        EXIT(IsAffect);
    end;

    local procedure GetShiftCodeType(ShiftCode: Code[20]) ShiftType: Text;
    var
        L_DailyShiftTbt: Record "Daily Shifts";
        L_ShiftTypeOption: Option "Unpaid Vacation","Paid Vacation","Sick Day","No Duty","Signal Absence",Holiday,"Working Day","Working Holiday",Subtraction,"Work Accident","Paid Day",AL;
    begin
        ShiftType := '';

        IF ShiftCode = '' THEN
            EXIT('');

        L_DailyShiftTbt.SETRANGE(L_DailyShiftTbt."Shift Code", ShiftCode);
        IF L_DailyShiftTbt.FINDFIRST THEN BEGIN
            IF (L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::Holiday) OR (L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::"Working Holiday") THEN
                ShiftType := 'HOLIDAY'
            ELSE
                IF L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::AL THEN
                    ShiftType := 'AL'
                ELSE
                    IF L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::"No Duty" THEN
                        ShiftType := 'NODUTY'
                    ELSE
                        IF L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::"Sick Day" THEN
                            ShiftType := 'SKD'
                        ELSE
                            IF L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::"Work Accident" THEN
                                ShiftType := 'WORKACCIDENT'
                            ELSE
                                IF (L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::"Paid Vacation") OR (L_DailyShiftTbt.Type = L_DailyShiftTbt.Type::"Unpaid Vacation") THEN
                                    ShiftType := 'VACATION'
                                ELSE
                                    ShiftType := 'WORKINGDAY';
        END;

        EXIT(ShiftType);
    end;

    local procedure FixCauseCodeforGenerateAttendance(AbsCode: Code[20]; EmpAbsrec: Record "Employee Absence") AbsCauseCode: Code[20];
    var
        L_JnlAttType: Option Overtime,Absence,WorkingDay;
        L_ShiftTyp: Text;
    begin
        IF AbsCode = '' THEN
            EXIT('');

        AbsCauseCode := AbsCode;

        L_ShiftTyp := UPPERCASE(GetShiftCodeType(EmpAbsrec."Shift Code"));
        IF (UPPERCASE(L_ShiftTyp) = UPPERCASE('HOLIDAY')) OR (UPPERCASE(L_ShiftTyp) = UPPERCASE('VACATION')) OR (UPPERCASE(L_ShiftTyp) = UPPERCASE('NODUTY')) THEN BEGIN
            IF ShiftCodeAffectsTransport(EmpAbsrec."Shift Code") THEN BEGIN
                IF (EmpAbsrec."Attend Hrs." > 0) AND (EmpAbsrec."Required Hrs" = 0) THEN
                    AbsCauseCode := 'WD';//GetAttendanceCauseOfAbsenceCode(L_JnlAttType::WorkingDay);
            END;
        END;

        EXIT(AbsCauseCode);
    end;

    procedure ImportHandPunch() IsImported: Boolean;
    begin
        IsImported := ImportAttendancePunchFile();
        EXIT(IsImported);
    end;

    procedure ImportAttendancePunchFile() PunchesImported: Boolean
    var
        FileImported: Boolean;
        TempHandPunch: Record "Temp Hand Punch";
        HandPunch: Record "Hand Punch";
        L_IsSeparateAttendanceInterval: Boolean;
        L_PayrollStatus: Record "Payroll Status";
        PunchFileType: Option ExcelStyle5C,ExcelStyle4C,TextCommaDelimiter1,ExcelStyle3C,ExcelStyleInOut,AccessDB,SQLDB,ExcelStyle4;
        PunchDateFormat: Option "DD-MM-YYYY HH:MM","MM-DD-YYYY HH:MM","DD-MM-YYYY","MM-DD-YYYY";
        PunchTimeFormat: Option DateTime,Time;
        PunchDateSeperator: Option "/","-",".";
        DtSeperator: Text;
        PunchDateTimeMerged: Boolean;
        PunchEmpTBT: Record Employee;
    begin
        HumanResSetup.GET;
        PunchFileType := HumanResSetup."Type of Attendance Punch file";
        PunchDateFormat := HumanResSetup."Attendance Punch Date Format";
        PunchTimeFormat := HumanResSetup."Attendance Punch Time Format";
        PunchDateSeperator := HumanResSetup."Attendance Date Seperator";
        IF PunchDateSeperator = PunchDateSeperator::"-" THEN
            DtSeperator := '-'
        ELSE
            IF PunchDateSeperator = PunchDateSeperator::"." THEN
                DtSeperator := '.'
            ELSE
                IF PunchDateSeperator = PunchDateSeperator::"/" THEN
                    DtSeperator := '/'
                ELSE
                    DtSeperator := '/';

        IF PunchFileType = PunchFileType::ExcelStyle4C THEN BEGIN
            PunchDateTimeMerged := TRUE;
            FileImported := ImportPunchExcel4C;
        END ELSE
            IF PunchFileType = PunchFileType::ExcelStyle3C THEN BEGIN
                PunchDateTimeMerged := TRUE;
                FileImported := ImportPunchExcel3C;
            END ELSE
                IF PunchFileType = PunchFileType::ExcelStyle5C THEN BEGIN
                    PunchDateTimeMerged := FALSE;
                    FileImported := ImportPunchExcel5C;
                END ELSE
                    IF PunchFileType = PunchFileType::ExcelStyle4 THEN BEGIN
                        PunchDateTimeMerged := FALSE;
                        FileImported := ImportPunchExcel4;
                    END ELSE
                        IF PunchFileType = PunchFileType::ExcelStyleInOut THEN BEGIN
                            PunchDateTimeMerged := FALSE;
                            FileImported := ImportPunchExcelINOUT;
                        END ELSE
                            IF PunchFileType = PunchFileType::AccessDB THEN BEGIN
                                PunchDateTimeMerged := TRUE;
                                FileImported := ImportPunchAccessDB;
                            END ELSE BEGIN
                                PunchDateTimeMerged := FALSE;
                                FileImported := ImportPunchExcel5C;
                            END;

        IF FileImported = FALSE THEN
            EXIT(FALSE);

        TempHandPunch.SETRANGE(Status, TempHandPunch.Status::Active);
        IF TempHandPunch.FINDFIRST THEN
            REPEAT
                IF TempHandPunch."Attendnace No." > 0 THEN BEGIN
                    PunchEmpTBT.RESET;
                    CLEAR(PunchEmpTBT);
                    PunchEmpTBT.SETRANGE("Attendance No.", TempHandPunch."Attendnace No.");
                    PunchEmpTBT.SETFILTER("Full Name", '<>%1', '');
                    PunchEmpTBT.SETFILTER(Period, '<>%1', 0D);
                    PunchEmpTBT.SETFILTER("Employment Date", '<>%1', 0D);
                    PunchEmpTBT.SETFILTER("Employment Type Code", '<>%1', '');
                    PunchEmpTBT.SETFILTER(Status, '=%1', PunchEmpTBT.Status::Active);
                    IF PunchEmpTBT.FINDFIRST() THEN BEGIN
                        IF CheckIfAttendanceNoExists(TempHandPunch."Attendnace No.") <> '' THEN BEGIN
                            HandPunch.SETRANGE("Attendnace No.", TempHandPunch."Attendnace No.");
                            IF (not PunchDateTimeMerged) AND (PunchTimeFormat = PunchTimeFormat::Time) THEN
                                HandPunch.SETRANGE("Date Time", CREATEDATETIME(DT2DATE(TempHandPunch."Transaction Date"), TempHandPunch."Transaction Time2"))
                            ELSE
                                HandPunch.SETRANGE("Date Time", CREATEDATETIME(DT2DATE(TempHandPunch."Transaction Date"), DT2TIME(TempHandPunch."Transaction Time")));

                            HandPunch.SETRANGE("Action Type", TempHandPunch."Action Type");
                            IF NOT HandPunch.FINDFIRST THEN BEGIN
                                HandPunch.INIT;
                                HandPunch."Attendnace No." := TempHandPunch."Attendnace No.";

                                IF (not PunchDateTimeMerged) AND (PunchTimeFormat = PunchTimeFormat::Time) THEN
                                    HandPunch.VALIDATE("Date Time", CREATEDATETIME(DT2DATE(TempHandPunch."Transaction Date"), TempHandPunch."Transaction Time2"))
                                ELSE
                                    HandPunch.VALIDATE("Date Time", CREATEDATETIME(DT2DATE(TempHandPunch."Transaction Date"), DT2TIME(TempHandPunch."Transaction Time")));

                                HandPunch."Employee Name" := TempHandPunch."Employee Name";
                                HandPunch."Action Type" := TempHandPunch."Action Type";

                                HandPunch."Scheduled Date" := FixPunchScheduledDate(PunchEmpTBT."No.", HandPunch."Real Date", HandPunch."Real Time");//20180919:A2+-
                                IF HandPunch."Scheduled Date" = 0D THEN
                                    HandPunch."Scheduled Date" := HandPunch."Real Date";

                                IF HandPunch."Action Type" = '' THEN
                                    HandPunch."Action Type" := 'IN';

                                HandPunch."Modified By" := COPYSTR(USERID, 1, 49);
                                HandPunch."Modification Date" := WORKDATE;

                                L_IsSeparateAttendanceInterval := IsSeparateAttendanceInterval(PunchEmpTBT."Payroll Group Code");
                                IF L_IsSeparateAttendanceInterval = FALSE THEN BEGIN
                                    IF PunchEmpTBT.Period <= HandPunch."Real Date" THEN
                                        HandPunch.INSERT;
                                END ELSE BEGIN
                                    L_PayrollStatus.SETRANGE("Payroll Group Code", PunchEmpTBT."Payroll Group Code");
                                    IF L_PayrollStatus.FINDFIRST = TRUE THEN BEGIN
                                        IF (L_PayrollStatus."Separate Attendance Interval")
                                          AND (L_PayrollStatus."Attendance Start Date" <> 0D)
                                          AND (L_PayrollStatus."Attendance End Date" <> 0D)
                                          AND (DATE2DMY(L_PayrollStatus."Payroll Date", 2) = DATE2DMY(L_PayrollStatus."Attendance End Date", 2)) THEN BEGIN
                                            //(DATE2DMY(L_PayrollStatus."Payroll Date",3) = DATE2DMY(L_PayrollStatus."Attendance End Date",3)) 
                                            IF (HandPunch."Real Date" >= L_PayrollStatus."Attendance Start Date") AND (HandPunch."Real Date" <= L_PayrollStatus."Attendance End Date") THEN
                                                HandPunch.INSERT;
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END;
                END;
            UNTIL TempHandPunch.NEXT = 0;


        IF TempHandPunch.FINDFIRST THEN
            REPEAT
                TempHandPunch.DELETE;
            UNTIL TempHandPunch.NEXT = 0;
        MESSAGE('Successfully Imported!!!');
        EXIT(TRUE);
    End;

    procedure ImportPunchExcel4C() IsImported: Boolean;
    var
        UploadedFileName: Text[250];
        index: Integer;
        RowNo: Integer;
        cellFound: Boolean;
        cellValue: Text[250];
        MaxRow: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        SheetName: Text[250];
        AttendanceNo: Integer;
        EmployeeName: Text[100];
        PunchDateTime: DateTime;
        PunchType: Code[20];
        TempHandPunch: Record "Temp Hand Punch";
        FileMgt: Codeunit "File Management";
        Text006: TextConst ENU = 'Import Excel File';
        ImportWindowTitle: TextConst ENU = 'Import Excel File';
        ExcelExtensionTok: TextConst ENU = '.xlsx';
        Instr: InStream;
        FileUploaded: Boolean;
        Columns: Integer;
        Rows: integer;
    begin
        //Excel Format : Attendance No   | Employee Name |  Punch Date Time     | Punch Type
        //                   1           |   Rana        |   16.06.2016 8:00 AM |   IN


        //EDM_KM_09062020
        //UploadedFileName := FileMgt.UploadFile(ImportWindowTitle, ExcelExtensionTok);
        //   FileName := UploadedFileName;
        //  SheetName := ExcelBuf.SelectSheetsName(FileName);
        //  ExcelBuf.OpenBook(FileName, SheetName);
        //  ExcelBuf.ReadSheet;

        //EDM_KM_09062020
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuf.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuf.Reset;
        ExcelBuf.OpenBookStream(Instr, Sheetname);
        ExcelBuf.ReadSheet();

        Commit();

        RowNo := 2;
        Window.OPEN('Attendance Process \' +
                    'Attendance No.: #1########\');

        if ExcelBuf.FINDFIRST then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                IF ExcelBuf.FINDLAST THEN
                    MaxRow := ExcelBuf."Row No.";
                While RowNo <= MaxRow Do Begin
                    index := 0;
                    AttendanceNo := 0;
                    EmployeeName := '';
                    PunchDateTime := 0DT;
                    PunchType := '';
                    WHILE index < 4 DO BEGIN
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            CASE index OF
                                1:
                                    EVALUATE(AttendanceNo, cellValue);
                                2:
                                    EVALUATE(EmployeeName, cellValue);
                                3:
                                    Evaluate(PunchDateTime, cellValue);
                                4:
                                    EVALUATE(PunchType, cellValue);
                            END;
                        END;
                    END;

                    Window.UPDATE(1, AttendanceNo);

                    TempHandPunch.Reset;
                    TempHandPunch.SetRange("Attendnace No.", AttendanceNo);
                    TempHandPunch.SetRange("Transaction Date", PunchDateTime);
                    TempHandPunch.SetRange("Transaction Time2", DT2Time(PunchDateTime));
                    TempHandPunch.SetRange("Transaction Time", PunchDateTime);
                    if TempHandPunch.FindFirst then
                        AttendanceNo := 0;

                    IF AttendanceNo <> 0 THEN BEGIN
                        TempHandPunch.INIT;
                        TempHandPunch.VALIDATE("Attendnace No.", AttendanceNo);
                        TempHandPunch.VALIDATE("Employee Name", EmployeeName);
                        TempHandPunch."Transaction Date" := PunchDateTime;
                        TempHandPunch."Transaction Time2" := DT2Time(PunchDateTime);
                        TempHandPunch."Transaction Time" := PunchDateTime;
                        TempHandPunch.VALIDATE("Action Type", PunchType);
                        TempHandPunch.INSERT;
                    END;
                    RowNo += 1;
                END;
            UNTIL ExcelBuf.NEXT = 0;
        Window.CLOSE;
        UploadedFileName := '';
        exit(true);
    end;

    procedure ImportPunchExcel3C() IsImported: Boolean;
    var
        UploadedFileName: Text[250];
        index: Integer;
        RowNo: Integer;
        cellFound: Boolean;
        cellValue: Text[250];
        MaxRow: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        SheetName: Text[250];
        AttendanceNo: Integer;
        EmployeeName: Text[100];
        PunchDateTime: DateTime;
        TempHandPunch: Record "Temp Hand Punch";
        FileMgt: Codeunit "File Management";
        Text006: TextConst ENU = 'Import Excel File';
        ImportWindowTitle: TextConst ENU = 'Import Excel File';
        ExcelExtensionTok: TextConst ENU = '.xlsx';
        PunchTimeFormat: Option DateTime,Time;
        Instr: InStream;
        FileUploaded: Boolean;
        Columns: Integer;
        Rows: integer;
    begin
        //Excel Format : Attendance No   | Employee Name |  Punch Date Time
        //                   1           |   Rana        |   16.06.2016 8:00 AM
        //UploadedFileName := FileMgt.UploadFile(ImportWindowTitle, ExcelExtensionTok);
        //FileName := UploadedFileName;
        //SheetName := ExcelBuf.SelectSheetsName(FileName);
        //ExcelBuf.OpenBook(FileName, SheetName);
        //ExcelBuf.ReadSheet;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuf.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuf.Reset;
        ExcelBuf.OpenBookStream(Instr, Sheetname);
        ExcelBuf.ReadSheet();

        Commit();

        RowNo := 2;
        Window.OPEN('Attendance Process \' +
                    'Attendance No.: #1########\');
        if ExcelBuf.FINDFIRST then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                IF ExcelBuf.FINDLAST THEN
                    MaxRow := ExcelBuf."Row No.";
                While RowNo <= MaxRow Do Begin
                    index := 0;
                    AttendanceNo := 0;
                    EmployeeName := '';
                    PunchDateTime := 0DT;
                    WHILE index < 3 DO BEGIN
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            CASE index OF
                                1:
                                    EVALUATE(AttendanceNo, cellValue);
                                2:
                                    EVALUATE(EmployeeName, cellValue);
                                3:
                                    EVALUATE(PunchDateTime, cellValue);
                            END;
                        END;
                    END;

                    Window.UPDATE(1, AttendanceNo);

                    TempHandPunch.Reset;
                    TempHandPunch.SetRange("Attendnace No.", AttendanceNo);
                    TempHandPunch.SetRange("Transaction Date", PunchDateTime);
                    TempHandPunch.SetRange("Transaction Time2", DT2Time(PunchDateTime));
                    TempHandPunch.SetRange("Transaction Time", PunchDateTime);
                    if TempHandPunch.FindFirst then
                        AttendanceNo := 0;

                    IF AttendanceNo <> 0 THEN BEGIN
                        TempHandPunch.INIT;
                        TempHandPunch.VALIDATE("Attendnace No.", AttendanceNo);
                        TempHandPunch.VALIDATE("Employee Name", EmployeeName);
                        TempHandPunch."Transaction Date" := PunchDateTime;
                        TempHandPunch."Transaction Time2" := DT2Time(PunchDateTime);
                        TempHandPunch."Transaction Time" := PunchDateTime;
                        TempHandPunch.VALIDATE("Action Type", 'IN');
                        TempHandPunch.INSERT;
                    END;
                    RowNo += 1;
                end;
            UNTIL ExcelBuf.NEXT = 0;
        Window.CLOSE;
        UploadedFileName := '';
        exit(true);
    end;

    procedure ImportPunchExcel4() IsImported: Boolean;
    var
        UploadedFileName: Text[250];
        index: Integer;
        RowNo: Integer;
        cellFound: Boolean;
        cellValue: Text[250];
        MaxRow: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        SheetName: Text[250];
        AttendanceNo: Integer;
        EmployeeName: Text[100];
        PunchDate: Date;
        PunchTime: Time;
        PunchDateTimeVar: DateTime;
        PunchType: Code[20];
        TempHandPunch: Record "Temp Hand Punch";
        FileMgt: Codeunit "File Management";
        Text006: TextConst ENU = 'Import Excel File';
        ImportWindowTitle: TextConst ENU = 'Import Excel File';
        ExcelExtensionTok: TextConst ENU = '.xlsx';
        PunchTimeFormat: Option DateTime,Time;
        Instr: InStream;
        FileUploaded: Boolean;
        Columns: Integer;
        Rows: integer;
    begin
        //Excel Format : Attendance No   | Employee Name |  Punch Date  |     Punch Time    
        //                   1           |   Rana        |   16.06.2016 |   1/0/00 8:00 AM 
        HRSetup.Get();
        //UploadedFileName := FileMgt.UploadFile(ImportWindowTitle, ExcelExtensionTok);
        //FileName := UploadedFileName;
        //SheetName := ExcelBuf.SelectSheetsName(FileName);
        //ExcelBuf.OpenBook(FileName, SheetName);
        //ExcelBuf.ReadSheet;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuf.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuf.Reset;
        ExcelBuf.OpenBookStream(Instr, Sheetname);
        ExcelBuf.ReadSheet();

        Commit();

        RowNo := 2;

        Window.OPEN('Attendance Process \' +
                    'Attendance No.: #1########\');

        if ExcelBuf.FINDFIRST then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                IF ExcelBuf.FINDLAST THEN
                    MaxRow := ExcelBuf."Row No.";
                While RowNo <= MaxRow Do Begin
                    index := 0;
                    AttendanceNo := 0;
                    EmployeeName := '';
                    PunchDate := 0D;
                    PunchTime := 0T;
                    PunchDateTimeVar := 0DT;
                    PunchType := '';
                    WHILE index < 4 DO BEGIN
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            CASE index OF
                                1:
                                    EVALUATE(AttendanceNo, cellValue);
                                2:
                                    EVALUATE(EmployeeName, cellValue);
                                3:
                                    EVALUATE(PunchDate, cellValue);
                                4:
                                    EVALUATE(PunchDateTimeVar, cellValue);
                            END;
                        END;
                    END;
                    PunchTime := DT2Time(PunchDateTimeVar);
                    Window.UPDATE(1, AttendanceNo);

                    TempHandPunch.Reset;
                    TempHandPunch.SetRange("Attendnace No.", AttendanceNo);
                    //TempHandPunch.SetRange("Transaction Date", CreateDateTime(PunchDate, DT2Time(PunchTime)));
                    TempHandPunch.SetRange("Transaction Date", CreateDateTime(PunchDate, PunchTime));
                    //TempHandPunch.SetRange("Transaction Time2", DT2Time(PunchTime));
                    TempHandPunch.SetRange("Transaction Time2", PunchTime);
                    //TempHandPunch.SetRange("Transaction Time", CreateDateTime(PunchDate, DT2Time(PunchTime)));
                    TempHandPunch.SetRange("Transaction Time", CreateDateTime(PunchDate, PunchTime));
                    if TempHandPunch.FindFirst then
                        AttendanceNo := 0;

                    IF AttendanceNo <> 0 THEN BEGIN
                        TempHandPunch.INIT;
                        TempHandPunch.VALIDATE("Attendnace No.", AttendanceNo);
                        TempHandPunch.VALIDATE("Employee Name", EmployeeName);
                        //TempHandPunch."Transaction Date" := CreateDateTime(PunchDate, DT2Time(PunchTime));
                        //TempHandPunch."Transaction Time2" := DT2Time(PunchTime);
                        //TempHandPunch."Transaction Time" := CreateDateTime(PunchDate, DT2Time(PunchTime));
                        TempHandPunch."Transaction Date" := CreateDateTime(PunchDate, PunchTime);
                        TempHandPunch."Transaction Time2" := PunchTime;
                        TempHandPunch."Transaction Time" := CreateDateTime(PunchDate, PunchTime);
                        TempHandPunch.VALIDATE("Action Type", 'IN');
                        TempHandPunch.INSERT;
                    END;
                    RowNo += 1;
                end;
            UNTIL ExcelBuf.NEXT = 0;
        Window.CLOSE;
        UploadedFileName := '';
        exit(true);
    end;

    procedure ImportPunchExcel5C() IsImported: Boolean;
    var
        UploadedFileName: Text[250];
        index: Integer;
        RowNo: Integer;
        cellFound: Boolean;
        cellValue: Text[250];
        MaxRow: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        SheetName: Text[250];
        AttendanceNo: Integer;
        EmployeeName: Text[100];
        PunchDate: Date;
        PunchDateTime: DateTime;
        PunchType: Code[20];
        TempHandPunch: Record "Temp Hand Punch";
        FileMgt: Codeunit "File Management";
        Text006: TextConst ENU = 'Import Excel File';
        ImportWindowTitle: TextConst ENU = 'Import Excel File';
        ExcelExtensionTok: TextConst ENU = '.xlsx';
        PunchTimeFormat: Option DateTime,Time;
        Instr: InStream;
        FileUploaded: Boolean;
        Columns: Integer;
        Rows: integer;
    begin
        //Excel Format : Attendance No   | Employee Name |  Punch Date  |     Punch Time    | Punch Type
        //                   1           |   Rana        |   16.06.2016 |   1/0/00 8:00 AM  |   IN
        HRSetup.Get();
        //UploadedFileName := FileMgt.UploadFile(ImportWindowTitle, ExcelExtensionTok);
        //FileName := UploadedFileName;
        //SheetName := ExcelBuf.SelectSheetsName(FileName);
        //ExcelBuf.OpenBook(FileName, SheetName);
        //ExcelBuf.ReadSheet;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuf.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuf.Reset;
        ExcelBuf.OpenBookStream(Instr, Sheetname);
        ExcelBuf.ReadSheet();

        Commit();

        RowNo := 2;

        Window.OPEN('Attendance Process \' +
                    'Attendance No.: #1########\');

        if ExcelBuf.FINDFIRST then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                IF ExcelBuf.FINDLAST THEN
                    MaxRow := ExcelBuf."Row No.";
                While RowNo <= MaxRow Do Begin
                    index := 0;
                    AttendanceNo := 0;
                    EmployeeName := '';
                    PunchDate := 0D;
                    PunchDateTime := 0DT;
                    PunchType := '';
                    WHILE index < 5 DO BEGIN
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            CASE index OF
                                1:
                                    EVALUATE(AttendanceNo, cellValue);
                                2:
                                    EVALUATE(EmployeeName, cellValue);
                                3:
                                    EVALUATE(PunchDate, cellValue);
                                4:
                                    EVALUATE(PunchDateTime, cellValue);
                                5:
                                    EVALUATE(PunchType, cellValue);
                            END;
                        END;
                    END;

                    Window.UPDATE(1, AttendanceNo);

                    TempHandPunch.Reset;
                    TempHandPunch.SetRange("Attendnace No.", AttendanceNo);
                    TempHandPunch.SetRange("Transaction Date", CreateDateTime(PunchDate, DT2Time(PunchDateTime)));
                    TempHandPunch.SetRange("Transaction Time2", DT2Time(PunchDateTime));
                    TempHandPunch.SetRange("Transaction Time", CreateDateTime(PunchDate, DT2Time(PunchDateTime)));
                    if TempHandPunch.FindFirst then
                        AttendanceNo := 0;

                    IF AttendanceNo <> 0 THEN BEGIN
                        TempHandPunch.INIT;
                        TempHandPunch.VALIDATE("Attendnace No.", AttendanceNo);
                        TempHandPunch.VALIDATE("Employee Name", EmployeeName);
                        TempHandPunch."Transaction Date" := CreateDateTime(PunchDate, DT2Time(PunchDateTime));
                        TempHandPunch."Transaction Time2" := DT2Time(PunchDateTime);
                        TempHandPunch."Transaction Time" := CreateDateTime(PunchDate, DT2Time(PunchDateTime));
                        TempHandPunch.VALIDATE("Action Type", PunchType);
                        TempHandPunch.INSERT;
                    END;
                    RowNo += 1;
                end;
            UNTIL ExcelBuf.NEXT = 0;
        Window.CLOSE;
        UploadedFileName := '';
        exit(true);
    end;

    procedure ImportPunchExcelINOUT() IsImported: Boolean;
    var
        UploadedFileName: Text[250];
        index: Integer;
        RowNo: Integer;
        cellFound: Boolean;
        cellValue: Text[250];
        MaxRow: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        SheetName: Text[250];
        AttendanceNo: Integer;
        EmployeeName: Text[100];
        PunchDate: Date;
        PunchTimeIn: Time;
        PunchTimeOut: Time;
        TempHandPunch: Record "Temp Hand Punch";
        FileMgt: Codeunit "File Management";
        Text006: TextConst ENU = 'Import Excel File';
        ImportWindowTitle: TextConst ENU = 'Import Excel File';
        ExcelExtensionTok: TextConst ENU = '.xlsx';
        PunchTimeFormat: Option DateTime,Time;
        Instr: InStream;
        FileUploaded: Boolean;
        Columns: Integer;
        Rows: integer;
    begin
        //Excel Format : Attendance No   | Employee Name |  Punch Date  | Punch IN Time | Punch OUT Time
        //                   1           |   Rana        |   16.06.2016 |      8:00     |      16:00
        //UploadedFileName := FileMgt.UploadFile(ImportWindowTitle, ExcelExtensionTok);
        //FileName := UploadedFileName;
        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        //ExcelBuf.ReadSheet;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuf.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuf.Reset;
        ExcelBuf.OpenBookStream(Instr, Sheetname);
        ExcelBuf.ReadSheet();

        Commit();
        RowNo := 2;
        Window.OPEN('Attendance Process \' +
                    'Attendance No.: #1########\');

        if ExcelBuf.FINDFIRST then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                IF ExcelBuf.FINDLAST THEN
                    MaxRow := ExcelBuf."Row No.";
                While RowNo <= MaxRow Do Begin
                    index := 0;
                    AttendanceNo := 0;
                    EmployeeName := '';
                    PunchDate := 0D;
                    PunchTimeIn := 0T;
                    PunchTimeOut := 0T;
                    WHILE index < 5 DO BEGIN
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            CASE index OF
                                1:
                                    EVALUATE(AttendanceNo, cellValue);
                                2:
                                    EVALUATE(EmployeeName, cellValue);
                                3:
                                    EVALUATE(PunchDate, cellValue);
                                4:
                                    EVALUATE(PunchTimeIn, cellValue);
                                5:
                                    EVALUATE(PunchTimeOut, cellValue);
                            END;
                        END;
                    END;

                    TempHandPunch.Reset;
                    TempHandPunch.SetRange("Attendnace No.", AttendanceNo);
                    TempHandPunch.SetRange("Transaction Date", CreateDateTime(PunchDate, PunchTimeIn));
                    TempHandPunch.SetRange("Transaction Time2", PunchTimeIn);
                    TempHandPunch.SetRange("Transaction Time", CreateDateTime(PunchDate, PunchTimeIn));
                    if TempHandPunch.FindFirst then
                        PunchTimeIn := 0T;

                    TempHandPunch.Reset;
                    TempHandPunch.SetRange("Attendnace No.", AttendanceNo);
                    TempHandPunch.SetRange("Transaction Date", CreateDateTime(PunchDate, PunchTimeOut));
                    TempHandPunch.SetRange("Transaction Time2", PunchTimeOut);
                    TempHandPunch.SetRange("Transaction Time", CreateDateTime(PunchDate, PunchTimeOut));
                    if TempHandPunch.FindFirst then
                        PunchTimeOut := 0T;

                    Window.UPDATE(1, AttendanceNo);
                    IF (AttendanceNo <> 0) and (PunchTimeIn <> 0T) THEN BEGIN
                        TempHandPunch.INIT;
                        TempHandPunch.VALIDATE("Attendnace No.", AttendanceNo);
                        TempHandPunch.VALIDATE("Employee Name", EmployeeName);
                        TempHandPunch."Transaction Date" := CreateDateTime(PunchDate, PunchTimeIn);
                        TempHandPunch."Transaction Time2" := PunchTimeIn;
                        TempHandPunch."Transaction Time" := CreateDateTime(PunchDate, PunchTimeIn);
                        TempHandPunch.VALIDATE("Action Type", 'IN');
                        TempHandPunch.INSERT;
                    end;
                    IF (AttendanceNo <> 0) and (PunchTimeOut <> 0T) THEN BEGIN
                        TempHandPunch.INIT;
                        TempHandPunch.VALIDATE("Attendnace No.", AttendanceNo);
                        TempHandPunch.VALIDATE("Employee Name", EmployeeName);
                        TempHandPunch."Transaction Date" := CreateDateTime(PunchDate, PunchTimeOut);
                        TempHandPunch."Transaction Time2" := PunchTimeOut;
                        TempHandPunch."Transaction Time" := CreateDateTime(PunchDate, PunchTimeOut);
                        TempHandPunch.VALIDATE("Action Type", 'OUT');
                        TempHandPunch.INSERT;
                    END;
                    RowNo += 1;
                END;
            UNTIL ExcelBuf.NEXT = 0;
        Window.CLOSE;
        UploadedFileName := '';
        exit(true);
    end;

    procedure ImportPunchAccessDB() IsImported: Boolean;
    var

    begin
    end;

    procedure CreatePayDetail(var P_Rec: Record Employee);
    var
        PayDetailLine: Record "Pay Detail Line";
        NextLineNo: Integer;
        PayElement: Record "Pay Element";
        PayDetailHeader: Record "Pay Detail Header";
        MyPayDetailHeaderTest: Record "Pay Detail Header";
        MyPayDetailLineTest: Record "Pay Detail Line";
        PayElementTbt: Record "Pay Element";
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        PayParam.GET;
        Loop := 1;
        WHILE Loop <= 17 DO BEGIN
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Employee No.", P_Rec."No.");
            IF PayDetailLine.FIND('+') THEN
                NextLineNo := PayDetailLine."Line No." + 1
            ELSE
                NextLineNo := 1;
            PayDetailLine.INIT;
            PayDetailLine."Employee No." := P_Rec."No.";
            PayDetailLine."Line No." := NextLineNo;
            PayDetailLine.Recurring := TRUE;
            PayDetailLine.Type := PayElement.Type;
            PayDetailLine."Pay Frequency" := P_Rec."Pay Frequency";
            PayDetailLine.Open := TRUE;
            PayDetailLine."Payroll Group Code" := P_Rec."Payroll Group Code";
            CASE Loop OF
                1:
                    BEGIN
                        PayDetailHeader.INIT;
                        PayDetailHeader."Employee No." := P_Rec."No.";
                        PayDetailHeader."Pay Frequency" := P_Rec."Pay Frequency";
                        PayDetailHeader."Payroll Group Code" := P_Rec."Payroll Group Code";
                        PayDetailHeader."Shortcut Dimension 1 Code" := P_Rec."Global Dimension 1 Code";
                        PayDetailHeader."Shortcut Dimension 2 Code" := P_Rec."Global Dimension 2 Code";
                        PayDetailHeader."Include in Pay Cycle" := TRUE;
                        //test if existing
                        MyPayDetailHeaderTest.SETRANGE("Employee No.", PayDetailHeader."Employee No.");
                        MyPayDetailHeaderTest.SETRANGE("Pay Frequency", PayDetailHeader."Pay Frequency");
                        MyPayDetailHeaderTest.SETRANGE("Payroll Group Code", PayDetailHeader."Payroll Group Code");
                        MyPayDetailHeaderTest.SETRANGE("Shortcut Dimension 1 Code", PayDetailHeader."Shortcut Dimension 1 Code");
                        MyPayDetailHeaderTest.SETRANGE("Shortcut Dimension 2 Code", PayDetailHeader."Shortcut Dimension 2 Code");
                        IF NOT MyPayDetailHeaderTest.FIND('-') THEN
                            PayDetailHeader.INSERT;
                        IF PayElement.GET(PayParam."Basic Pay Code") THEN
                            PayDetailLine."Pay Element Code" := PayParam."Basic Pay Code";
                        IF P_Rec."Basic Pay" > 0 THEN begin
                            PayDetailLine.Amount := P_Rec."Basic Pay";
                        end;
                    END;
                2:
                    BEGIN
                        IF PayParam."Family Allowance Code" <> '' THEN BEGIN
                            IF PayElement.GET(PayParam."Family Allowance Code") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Family Allowance Code";
                                IF P_Rec."Basic Pay" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                4:
                    BEGIN
                        IF PayParam."Non-Taxable Transp. Code" <> '' THEN BEGIN
                            IF PayElement.GET(PayParam."Non-Taxable Transp. Code") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Non-Taxable Transp. Code";
                                IF P_Rec."Basic Pay" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                5:
                    BEGIN
                        IF (PayParam."Housing Allowance" <> '') THEN // AND (P_Rec."House Allowance" > 0) THEN
                          BEGIN
                            IF PayElement.GET(PayParam."Housing Allowance") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Housing Allowance";
                                IF P_Rec."House Allowance" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                6:
                    BEGIN
                        IF (PayParam.Food <> '') THEN //AND (P_Rec."Food Allowance" > 0) THEN
                          BEGIN
                            IF PayElement.GET(PayParam.Food) THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam.Food;
                                IF P_Rec."Food Allowance" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                7:
                    BEGIN
                        IF PayParam.Bonus <> '' THEN BEGIN
                            IF PayElement.GET(PayParam.Bonus) THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam.Bonus;
                                IF P_Rec."Basic Pay" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                8:
                    BEGIN
                        IF (PayParam."Car Allowance" <> '') THEN //AND (P_Rec."Car Allowance" > 0) THEN
                          BEGIN
                            IF PayElement.GET(PayParam."Car Allowance") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Car Allowance";
                                IF P_Rec."Car Allowance" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                9:
                    BEGIN
                        IF (PayParam."Ticket Allowance" <> '') THEN //AND (P_Rec."Ticket Allowance" > 0 ) THEN
                          BEGIN
                            IF PayElement.GET(PayParam."Ticket Allowance") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Ticket Allowance";
                                IF P_Rec."Ticket Allowance" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                10:
                    BEGIN
                        IF (PayParam."Mobile allowance" <> '') THEN //AND (P_Rec."Phone Allowance" > 0) THEN
                              BEGIN
                            IF PayElement.GET(PayParam."Mobile allowance") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Mobile allowance";
                                IF P_Rec."Phone Allowance" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                11:
                    BEGIN
                        IF (PayParam."High Cost of Living Code" <> '') THEN //AND (P_Rec."Cost of Living Amount" > 0) THEN
                          BEGIN
                            IF PayElement.GET(PayParam."High Cost of Living Code") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."High Cost of Living Code";
                                IF P_Rec."Cost of Living Amount" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                12:
                    BEGIN
                        IF (PayParam."Water Compensation Allowance" <> '') THEN //AND (P_Rec."Water Compensation" > 0) THEN
                             BEGIN
                            IF PayElement.GET(PayParam."Water Compensation Allowance") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Water Compensation Allowance";
                                IF P_Rec."Water Compensation" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                13:
                    BEGIN
                        IF (PayParam."Production Allowance" <> '') THEN //AND (P_Rec."Commission Amount" > 0) THEN
                          BEGIN
                            IF PayElement.GET(PayParam."Production Allowance") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Production Allowance";
                                IF P_Rec."Commission Amount" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                14:
                    BEGIN
                        IF (PayParam.Allowance <> '') THEN //AND (P_Rec."Other Allowances"> 0) THEN
                          BEGIN
                            IF PayElement.GET(PayParam.Allowance) THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam.Allowance;
                                IF P_Rec."Other Allowances" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                15:
                    BEGIN
                        IF (PayParam."Commision Addition" <> '') THEN //AND (P_Rec."Commission Addition"> 0) THEN
                          BEGIN
                            IF PayElement.GET(PayParam."Commision Addition") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Commision Addition";
                                IF P_Rec."Commission Addition" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                16:
                    BEGIN
                        IF (PayParam."Comission Deduction" <> '') THEN //AND (P_Rec."Commission Deduction"> 0 ) THEN
                          BEGIN

                            IF PayElement.GET(PayParam."Comission Deduction") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Comission Deduction";
                                IF P_Rec."Commission Deduction" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
                17:
                    BEGIN
                        IF (PayParam."Cost of Living" <> '') THEN
                          BEGIN
                            IF PayElement.GET(PayParam."Cost of Living") THEN BEGIN
                                PayDetailLine."Pay Element Code" := PayParam."Cost of Living";
                                IF P_Rec."Cost of Living" > 0 THEN
                                    GetSpePayAmount(PayDetailLine."Pay Element Code", P_Rec, PayDetailLine);
                            END;
                        END;
                    END;
            END; //case
            IF PayDetailLine."Pay Element Code" <> '' THEN BEGIN
                MyPayDetailLineTest.RESET;
                MyPayDetailLineTest.SETRANGE("Employee No.", PayDetailLine."Employee No.");
                MyPayDetailLineTest.SETRANGE("Tax Year", PayDetailLine."Tax Year");
                MyPayDetailLineTest.SETRANGE(Period, PayDetailLine.Period);
                MyPayDetailLineTest.SETRANGE("Pay Element Code", PayDetailLine."Pay Element Code");
                IF NOT MyPayDetailLineTest.FIND('-') THEN BEGIN
                    // Added in order to insert pay element type in Pay detail line - 03.04.2017 : A2+
                    PayElementTbt.SETRANGE(Code, PayDetailLine."Pay Element Code");
                    IF PayElementTbt.FINDFIRST THEN
                        IF PayElementTbt.Type = PayElementTbt.Type::Addition THEN
                            PayDetailLine.Type := PayDetailLine.Type::Addition
                        ELSE
                            PayDetailLine.Type := PayDetailLine.Type::Deduction;
                    // Added in order to insert pay element type in Pay detail line - 03.04.2017 : A2-
                    PayDetailLine.Description := PayElement.Description;
                    PayDetailLine.INSERT;
                END;
            END;
            Loop := Loop + 1;
        END; // loop
    end;

    procedure ImportEmpAttendanceByDimensionFromExcel() IsImported: Boolean;
    var
        ExcelImporter: Codeunit "Excel Importer";
        UploadedFileName: Text[100];
        TableNo: Integer;
        index: Integer;
        RowNo: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        cellFound: Boolean;
        i_value: Integer;
        dec_value: Decimal;
        dat_value: Date;
        tim_value: Time;
        b_value: Boolean;
        bi_value: BigInteger;
        dattim_value: DateTime;
        datform_value: DateFormula;
        cellValue: Text[262];
        cellValue2: Text[262];
        J: Integer;
        headerName: Text[50];
        NoOfRecords: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        SheetName: Text[250];
        ColCount: Integer;
        FileMgt: Codeunit "File Management";
        TxtM: Text;
        TxtD: Text;
        TxtY: Text;
        TxtT: Text;
        Text006: TextConst ENU = 'Import Excel File', ESM = 'Importar fich. Excel', FRC = 'Importer fichier Excel', ENC = 'Import Excel File';
        rInd: Integer;
        AttendanceNo: Integer;
        EmpName: Text[100];
        TransDate: DateTime;
        TimeIn: Time;
        TimeOut: Time;
        InitDate: Date;
        NoOfHours: Decimal;
        ProjectDim: Text[100];
        BOQ: Text[100];
        LastAttendanceNo: Integer;
        TempHandPunch: Record "Temp Hand Punch";
        MaxRow: Integer;
        EmpAttendanceDim: Record "Employees Attendance Dimension";
        LineNo: Integer;
        EmpAbsence: Record "Employee Absence";
        BatchingPlant: Code[20];
        MissingAttendanceNo: Label 'Missing Attendance No in Row %1';
        FromFile: Text;
        IStream: InStream;
    begin
        //Excel Format :
        // Attendance | Employee |            | Time | Time  | Nb Of |         |      |
        //    No      |   Name   |    Date    |  IN  |  OUT  |  Hrs  | Project | BOQ  | Batching Plant
        // Example:
        //     1      |   Tarek  | 11/11/2017 | 8:00 | 16:00 |   8   |  ABCD   | XYZ  |   ABCDEFGH

        TempHandPunch.RESET;
        TempHandPunch.DELETEALL;

        UploadedFileName := '';
        TableNo := DATABASE::"Temp Hand Punch";

        if UploadedFileName = '' then begin
            //UploadedFileName := FileMgt.OpenFileDialog(Text006, '', '');
            //Jad: v20+
            UploadIntoStream(Text006, '', '', FromFile, IStream);
            if FromFile <> '' then begin
                UploadedFileName := FileMgt.GetFileName(FromFile);
                SheetName := ExcelBuf.SelectSheetsNameStream(IStream);
            end else
                Error('No File Found');
            ExcelBuf.Reset();
            ExcelBuf.DeleteAll();
            ExcelBuf.OpenBookStream(IStream, SheetName);
            ExcelBuf.ReadSheet();
            //Jad: v20-
            FileName := UploadedFileName;
        end else
            FileName := UploadedFileName;

        if FileName = '' then
            exit(false);
        /*
                if ExcelImporter.SelectExcelSource(FileName, SheetName) < 0 then
                    exit(false);

                if not ExcelImporter.testTableNo(TableNo) then
                    exit(false);
                    *///EDM.NED
                      //ExcelBuf.OpenBook(FileName, SheetName);
                      //ExcelBuf.ReadSheet;
        RowNo := 2;

        InitDate := DMY2DATE(1, 1, 1900);
        J := 0;

        if ExcelBuf.FIND('-') then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                if ExcelBuf.FINDLAST then
                    MaxRow := ExcelBuf."Row No.";

                NoOfRecords := ExcelBuf.COUNT;
                while RowNo <= MaxRow do begin
                    index := 0;
                    AttendanceNo := 0;
                    EmpName := '';
                    TransDate := 0DT;
                    TimeIn := 000000T;
                    TimeOut := 000000T;
                    NoOfHours := 0;
                    ProjectDim := '';
                    BOQ := '';
                    BatchingPlant := '';

                    while index < 10 do begin
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        if cellFound then begin
                            cellValue := ExcelBuf."Cell Value as Text";
                            case index of
                                1:
                                    EVALUATE(AttendanceNo, cellValue);
                                2:
                                    EmpName := cellValue;
                                3:
                                    EVALUATE(TransDate, cellValue);
                                4:
                                    EVALUATE(TimeIn, cellValue);
                                5:
                                    EVALUATE(TimeOut, cellValue);
                                6:
                                    EVALUATE(NoOfHours, cellValue);
                                7:
                                    EVALUATE(ProjectDim, cellValue);
                                8:
                                    EVALUATE(BOQ, cellValue);
                                9:
                                    EVALUATE(BatchingPlant, cellValue);
                            end;
                        end;
                    end;
                    if AttendanceNo = 0 then
                        AttendanceNo := LastAttendanceNo;
                    if AttendanceNo = 0 then
                        ERROR(MissingAttendanceNo, RowNo);

                    if (AttendanceNo > 0) then
                        if ((TimeIn <> 000000T) and (TimeOut <> 000000T)) or (NoOfHours > 0) then begin
                            CLEAR(TempHandPunch);
                            TempHandPunch.INIT;
                            TempHandPunch."Attendnace No." := AttendanceNo;
                            TempHandPunch."Employee Name" := FORMAT(AttendanceNo);
                            TempHandPunch."Transaction Date" := TransDate;
                            if TimeIn <> 000000T then
                                TempHandPunch."Job Time IN" := TimeIn;
                            if TimeOut <> 000000T then
                                TempHandPunch."Job Time OUT" := TimeOut;
                            if NoOfHours > 0 then
                                TempHandPunch."Job Number Of Hours" := NoOfHours
                            else
                                TempHandPunch."Job Number Of Hours" := (TempHandPunch."Job Time OUT" - TempHandPunch."Job Time IN") / 3600000; //To get the difference in hours
                            TempHandPunch."Job No." := ProjectDim;
                            TempHandPunch."Job Task No." := BOQ;
                            TempHandPunch."Batching Plant" := BatchingPlant;
                            TempHandPunch.INSERT
                        end;
                    if (AttendanceNo > 0) and (AttendanceNo <> LastAttendanceNo) then
                        LastAttendanceNo := AttendanceNo;
                    RowNo += 1;
                end;
            until ExcelBuf.NEXT = 0;

        UploadedFileName := '';

        exit(true);
    end;

    procedure ValidateEmpAttendanceByDimensionFromExcel(EmployeeNo: Code[20]; AttPeriod: Date; AttNo: Integer; UpdateAttendance: Boolean) IsImported: Boolean;
    var
        UploadedFileName: Text[100];
        TableNo: Integer;
        index: Integer;
        RowNo: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        cellFound: Boolean;
        i_value: Integer;
        dec_value: Decimal;
        dat_value: Date;
        tim_value: Time;
        b_value: Boolean;
        bi_value: BigInteger;
        dattim_value: DateTime;
        datform_value: DateFormula;
        cellValue: Text[262];
        cellValue2: Text[262];
        J: Integer;
        headerName: Text[50];
        NoOfRecords: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        SheetName: Text[250];
        ColCount: Integer;
        FileMgt: Codeunit "File Management";
        TxtM: Text;
        TxtD: Text;
        TxtY: Text;
        TxtT: Text;
        Text006: TextConst ENU = 'Import Excel File', ESM = 'Importar fich. Excel', FRC = 'Importer fichier Excel', ENC = 'Import Excel File';
        rInd: Integer;
        AttendanceNo: Integer;
        EmpName: Text[100];
        TransDate: DateTime;
        TimeIn: Time;
        TimeOut: Time;
        InitDate: Date;
        NoOfHours: Integer;
        ProjectDim: Text[100];
        BOQ: Text[100];
        LastAttendanceNo: Integer;
        TempHandPunch: Record "Temp Hand Punch";
        MaxRow: Integer;
        EmpAttendanceDim: Record "Employees Attendance Dimension";
        LineNo: Integer;
        EmpAbsence: Record "Employee Absence";
        Employee: Record Employee;
    begin
        LineNo := 0;
        TempHandPunch.RESET;
        TempHandPunch.SETRANGE(Status, TempHandPunch.Status::Active);
        TempHandPunch.SETRANGE("Attendnace No.", AttNo);
        if TempHandPunch.FINDFIRST then
            repeat
                if TempHandPunch."Attendnace No." > 0 then begin
                    Employee.RESET;
                    CLEAR(Employee);
                    Employee.SETRANGE("No.", EmployeeNo);
                    Employee.SETRANGE("Attendance No.", TempHandPunch."Attendnace No.");
                    Employee.SETFILTER("Full Name", '<>%1', '');
                    Employee.SETFILTER(Period, '=%1', AttPeriod);
                    Employee.SETFILTER("Employment Date", '<>%1', 0D);
                    Employee.SETFILTER("Employment Type Code", '<>%1', '');
                    Employee.SETFILTER(Status, '=%1', Employee.Status::Active);
                    if Employee.FINDFIRST() then begin
                        if (CheckIfAttendanceNoExists(TempHandPunch."Attendnace No.") <> '')
                          and (CanModifyAttendancePeriod(Employee."No.", Employee.Period, true, false, false, false))
                          and (not AttendanceRecManuallyModified(Employee."No.", DT2DATE(TempHandPunch."Transaction Date"))) then begin
                            CLEAR(EmpAttendanceDim);
                            EmpAttendanceDim.RESET;
                            EmpAttendanceDim.SETRANGE("Employee No", Employee."No.");
                            EmpAttendanceDim.SETRANGE("Attendance Date", DT2DATE(TempHandPunch."Transaction Date"));
                            EmpAttendanceDim.SETRANGE("From Time", TempHandPunch."Job Time IN");
                            EmpAttendanceDim.SETRANGE("To Time", TempHandPunch."Job Time OUT");
                            EmpAttendanceDim.SETRANGE("Attended Hrs", TempHandPunch."Job Number Of Hours");
                            EmpAttendanceDim.SETRANGE("Job No.", TempHandPunch."Job No.");
                            EmpAttendanceDim.SETRANGE("Job Task No.", TempHandPunch."Job Task No.");
                            EmpAttendanceDim.SETRANGE("Shortcut Dimension 7", TempHandPunch."Batching Plant");
                            if not EmpAttendanceDim.FINDFIRST then begin
                                EmpAttendanceDim.INIT;
                                LineNo := GetLastLineNo(Employee."No.", Employee.Period) + 1;
                                EmpAttendanceDim."Line No" := LineNo;
                                EmpAttendanceDim."Attendance No" := TempHandPunch."Attendnace No.";
                                EmpAttendanceDim."Employee No" := Employee."No.";
                                EmpAttendanceDim.VALIDATE("Attendance Date", DT2DATE(TempHandPunch."Transaction Date"));
                                EmpAttendanceDim."From Time" := TempHandPunch."Job Time IN";
                                EmpAttendanceDim."To Time" := TempHandPunch."Job Time OUT";
                                EmpAttendanceDim."Attended Hrs" := TempHandPunch."Job Number Of Hours";
                                EmpAttendanceDim.VALIDATE("Job No.", TempHandPunch."Job No.");
                                EmpAttendanceDim."Job Task No." := TempHandPunch."Job Task No.";
                                EmpAttendanceDim."Required Hrs" := TempHandPunch."Job Number Of Hours";
                                EmpAttendanceDim.Period := Employee.Period;
                                EmpAttendanceDim.VALIDATE("Shortcut Dimension 7", TempHandPunch."Batching Plant");
                                EmpAttendanceDim.VALIDATE("Shortcut Dimension 4", Employee."No.");
                                EmpAttendanceDim.INSERT;
                            end;
                        end;
                    end;
                end;
            until TempHandPunch.NEXT = 0;
        TempHandPunch.DELETEALL;

        if UpdateAttendance then begin
            EmpAbsence.RESET;
            EmpAbsence.SETRANGE("Employee No.", EmployeeNo);
            EmpAbsence.SETRANGE(Period, AttPeriod);
            if EmpAbsence.FINDFIRST then
                repeat
                    if (CanModifyAttendancePeriod(EmployeeNo, AttPeriod, true, false, false, false))
                          and (not AttendanceRecManuallyModified(EmployeeNo, EmpAbsence."From Date")) then
                        EmpAttendanceDim.RESET;
                    EmpAttendanceDim.SETRANGE("Employee No", EmployeeNo);
                    EmpAttendanceDim.SETRANGE("Attendance Date", EmpAbsence."From Date");
                    if EmpAttendanceDim.FINDSET then begin
                        EmpAttendanceDim.CALCSUMS("Attended Hrs");
                        EmpAbsence."Attend Hrs." := EmpAttendanceDim."Attended Hrs";
                        EmpAbsence."Actual Attend Hrs" := EmpAttendanceDim."Attended Hrs";
                        EmpAbsence.MODIFY;
                    end;
                until EmpAbsence.NEXT = 0;
        end;

        exit(true);
    end;

    local procedure GetLastLineNo(EmployeeNo: Code[20]; AttPeriod: Date): Integer;
    var
        EmpAttendanceDim: Record "Employees Attendance Dimension";
    begin
        EmpAttendanceDim.RESET;
        EmpAttendanceDim.SETRANGE("Employee No", EmployeeNo);
        EmpAttendanceDim.SETRANGE(Period, AttPeriod);
        if EmpAttendanceDim.FINDLAST then
            exit(EmpAttendanceDim."Line No");

        exit(0);
    end;

    local Procedure IsLateArriveDayPenalty(EmployeeNo: Code[20]): Boolean;
    var
        EmploymentTypeRec: Record "Employment Type";
        EmployeeRec: Record Employee;
    begin
        EmployeeRec.SETRANGE("No.", EmployeeNo);
        IF EmployeeRec.FINDFIRST then begin
            EmploymentTypeRec.SETRANGE(Code, EmployeeRec."Employment Type Code");
            IF EmploymentTypeRec.FINDFIRST then begin
                IF EmploymentTypeRec."Late Arrive Policy" = EmploymentTypeRec."Late Arrive Policy"::"Day Count Penalty" then
                    exit(True)
                ELSE
                    exit(False);
            end;
        end;
    end;

    local procedure GetLateArriveDayCountPenalizedDays(EmployeeNo: Code[20]; Period: date; FromDate: date; ToDate: date): Decimal;
    var
        EmployeeAbsenceRec: Record "Employee Absence";
        EmployeeRec: Record Employee;
        EmploymentTypeRec: Record "Employment Type";
        LACount: Integer;
        LACummulativeDays: Integer;
        LAdaysVar: Integer;
    begin
        IF IsLateArriveDayPenalty(EmployeeNo) = False then
            exit(0);

        EmployeeAbsenceRec.SETRANGE("Employee No.", EmployeeNo);
        if Period <> 0D then
            EmployeeAbsenceRec.Setrange(Period, Period);
        if (FromDate <> 0D) and (ToDate <> 0D) then
            EmployeeAbsenceRec.SetFilter("From Date", '%1..%2', FromDate, ToDate);
        EmployeeAbsenceRec.SetFilter("Late Arrive", '>1', 0);
        IF EmployeeAbsenceRec.FindFirst then
            LACount := EmployeeAbsenceRec.COUNT;

        EmployeeRec.SETRANGE("No.", EmployeeNo);
        IF EmployeeRec.FindFirst then begin
            EmploymentTypeRec.SETRANGE(Code, EmployeeRec."Employment Type Code");
            IF EmploymentTypeRec.FINDFIRST then
                LACummulativeDays := EmploymentTypeRec."Late Arrive Cummulative Days";
        end;

        LAdaysVar := Round(LACount / LACummulativeDays, 1, '<');
        EXIT(LAdaysVar);
    end;

    procedure PostLateArriveDayCountPolicyDeductionToJournal(EmpNo: Code[20]; AttendDate: Date)
    var
        CauseofAbsence: Record "Cause of Absence";
        EmployeeRec: Record Employee;
        EmploymentTypeRec: Record "Employment Type";
        EmployeeJournal: Record "Employee Journal Line";
        DeductionCode: Code[10];
        DedPayElem: Code[10];
        AbsentHrs: Decimal;
        PolicyType: Option LateArrive,LateLeave,EarlyArrive,EarlyLeave;
        AttType: Option Overtime,Absence,WorkingDay,LateArrive;
        ALBalance: Decimal;
        ALAbsHrs: Decimal;
        L_MaxLineNo: Integer;
    begin
        DedPayElem := '';
        DeductionCode := GetAttendanceCauseOfAbsenceCode(AttType::LateArrive);
        CauseofAbsence.SETRANGE(CauseofAbsence.Code, DeductionCode);
        if CauseofAbsence.FINDFIRST then begin
        end
        else
            exit;

        if DeductionCode = '' then
            exit;

        if IsPenalizeLateArrive(EmpNo) = true then begin
            EmployeeRec.SETRANGE("No.", EmpNo);
            IF EmployeeRec.FINDFIRST THEN begin
                EmploymentTypeRec.SETRANGE(Code, EmployeeRec."Employment Type Code");
                IF EmploymentTypeRec.FindFirst then
                    AbsentHrs := GetLateArriveDayCountPenalizedDays(EmpNo, AttendDate, 0D, 0D) * EmploymentTypeRec."Late Arrive Penalty Days"
                * EmploymentTypeRec."Working Hours Per Day";
            end;

            if AbsentHrs <= 0 then
                AbsentHrs := 0;
            ALAbsHrs := 0;
            HRSetup.GET;
            if (HRSetup."Deduct Absence From AL") and (HRSetup."Deduct Absence From AL Code" <> '') then begin
                ALBalance := GetEmpAbsenceEntitlementCurrentBalance(EmpNo, HRSetup."Annual Leave Code", 0D);
                ALBalance := ROUND(ALBalance * GetEmployeeDailyHours(EmpNo, ''));
                if (ALBalance > 0) and (AbsentHrs > 0) then begin
                    if (AbsentHrs >= ALBalance) then begin
                        ALAbsHrs := ALAbsHrs + ALBalance;
                        AbsentHrs := ROUND(AbsentHrs - ALBalance, 0.01);
                        ALBalance := 0;
                    end
                    else begin
                        ALBalance := ALBalance - AbsentHrs;
                        ALAbsHrs := ALAbsHrs + AbsentHrs;
                        AbsentHrs := 0;
                    end;
                end;
                EmployeeJournal.RESET;
                CLEAR(EmployeeJournal);
                L_MaxLineNo := 0;

                EmployeeJournal.SETRANGE("Employee No.", EmpNo);
                if EmployeeJournal.FIND('+') then
                    L_MaxLineNo := EmployeeJournal."Entry No.";
                L_MaxLineNo := L_MaxLineNo + 1;
                CLEAR(EmployeeJournal);
                EmployeeJournal.RESET;
                if ALAbsHrs > 0 then begin
                    EmployeeJournal.INIT;
                    EmployeeJournal.VALIDATE("Employee No.", EmpNo);
                    EmployeeJournal."Transaction Type" := 'ABS';
                    EmployeeJournal.VALIDATE("Cause of Absence Code", HRSetup."Deduct Absence From AL Code");
                    EmployeeJournal."Starting Date" := AttendDate;
                    EmployeeJournal."Ending Date" := AttendDate;
                    EmployeeJournal.Type := 'ABSENCE';
                    EmployeeJournal.VALIDATE("Transaction Date", AttendDate);
                    EmployeeJournal.VALIDATE(EmployeeJournal.Value, ALAbsHrs);
                    EmployeeJournal."Opened By" := USERID;
                    EmployeeJournal."Opened Date" := WORKDATE;
                    EmployeeJournal."Released By" := USERID;
                    EmployeeJournal."Released Date" := WORKDATE;
                    EmployeeJournal."Approved By" := USERID;
                    EmployeeJournal."Approved Date" := WORKDATE;
                    EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
                    EmployeeJournal."Entry No." := L_MaxLineNo;
                    EmployeeJournal.INSERT(true);
                    EmployeeJournal.RESET;
                    CLEAR(EmployeeJournal);
                    L_MaxLineNo := L_MaxLineNo + 1;
                end;
            end;
            EmployeeJournal.RESET;
            CLEAR(EmployeeJournal);
            if AbsentHrs > 0 then begin
                EmployeeJournal.INIT;
                EmployeeJournal.VALIDATE("Employee No.", EmpNo);
                EmployeeJournal."Transaction Type" := 'ABS';
                EmployeeJournal.VALIDATE("Cause of Absence Code", DeductionCode);
                EmployeeJournal."Starting Date" := AttendDate;
                EmployeeJournal."Ending Date" := AttendDate;
                EmployeeJournal.Type := 'ABSENCE';
                EmployeeJournal.VALIDATE("Transaction Date", AttendDate);
                EmployeeJournal.VALIDATE(EmployeeJournal.Value, AbsentHrs);
                EmployeeJournal."Opened By" := USERID;
                EmployeeJournal."Opened Date" := WORKDATE;
                EmployeeJournal."Released By" := USERID;
                EmployeeJournal."Released Date" := WORKDATE;
                EmployeeJournal."Approved By" := USERID;
                EmployeeJournal."Approved Date" := WORKDATE;
                EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
                EmployeeJournal."Entry No." := L_MaxLineNo;
                EmployeeJournal.INSERT(true);
                EmployeeJournal.RESET;
                CLEAR(EmployeeJournal);
            end;
        end;
        UpdateEmpEntitlementTotals(AttendDate, EmpNo);
    end;

    Procedure IsFeatureVisible(FeatureName: Text[250]) Val: Boolean
    var
        TablePH: Record "Table PH";
    begin
        TablePH.Setrange(Description, FeatureName);
        IF TablePH.FindFirst then
            exit(true)
        else
            exit(false)
    end;

    Procedure IsHROfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."HR Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end;
        exit(false);
    end;

    Procedure IsPayrollOfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."Payroll Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end;
        exit(false);
    end;

    Procedure IsAttendanceOfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."Attendance Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end;
        exit(false);
    end;

    Procedure IsLeavesOfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."Leaves Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end;
        exit(false);
    end;

    Procedure IsDataEntryOfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."Data Entry Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end;
        exit(false);
    end;

    Procedure IsRecruitmentOfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."Recruitment Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end;
        exit(false);
    end;

    Procedure IsEvaluationOfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."Evaluation Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end;
        exit(false);
    end;

    Procedure IsAdministrationOfficer(UserID: Code[50]) Val: Boolean
    var
        HRPermissions: Record "HR Permissions";
    begin
        HRPermissions.Setrange("User ID", UserID);
        IF HRPermissions.FindFirst then begin
            IF HRPermissions."Permission Type" = HRPermissions."Permission Type"::Restricted then
                exit(HRPermissions."Administration Officer")
            Else
                if HRPermissions."Permission Type" = HRPermissions."Permission Type"::General then
                    exit(true);
        end else
            exit(true);
    end;

    procedure ImportEmployeeBenefits(AutoApprove: Boolean; DeleteExisting: Boolean);
    var
        FileManagement: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer" temporary;
        FileName: Text[250];
        RowNo: Integer;
        EmployeeNo: Code[20];
        TransType: Code[20];
        TransDate: Date;
        TransAmt: Decimal;
        L_EmployeeJournalLine: Record "Employee Journal Line";
        PayStatus: Record "Payroll Status";
        Employee: Record Employee;
        EmpJnlLine: Record "Employee Journal Line";
        L_NewJrnlLine: Boolean;
        L_PayGroup: Code[10];
        UploadedFileName: Text[250];
        index: Integer;
        cellFound: Boolean;
        cellValue: Text[250];
        MaxRow: Integer;
        Window: Dialog;
        SheetName: Text[250];
        EmployeeName: Text[100];
        FileMgt: Codeunit "File Management";
        HRTransTypes: Record "HR Transaction Types";
        ImportWindowTitle: TextConst ENU = 'Import Excel File';
        ExcelExtensionTok: TextConst ENU = '.xlsx';
        Instr: InStream;
        FileUploaded: Boolean;
        Columns: Integer;
        Rows: integer;
    begin
        //UploadedFileName := FileMgt.UploadFile(ImportWindowTitle, ExcelExtensionTok);
        //FileName := UploadedFileName;
        //SheetName := ExcelBuf.SelectSheetsName(FileName);
        //ExcelBuf.OpenBook(FileName, SheetName);
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuf.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuf.Reset;
        ExcelBuf.OpenBookStream(Instr, Sheetname);
        ExcelBuf.SetReadDateTimeInUtcDate(true);
        ExcelBuf.ReadSheet();
        ExcelBuf.SetReadDateTimeInUtcDate(false);

        Commit();

        RowNo := 2;
        Window.OPEN('Record Process \' +
        'Employee No.: #1########\');

        if ExcelBuf.FINDFIRST then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                IF ExcelBuf.FINDLAST THEN
                    MaxRow := ExcelBuf."Row No.";
                While RowNo <= MaxRow Do Begin
                    index := 0;
                    EmployeeNo := '';
                    TransType := '';
                    TransDate := 0D;
                    TransAmt := 0;
                    WHILE index < 4 DO BEGIN
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            CASE index OF
                                1:
                                    EVALUATE(EmployeeNo, cellValue);
                                2:
                                    EVALUATE(TransType, cellValue);
                                3:
                                    EVALUATE(TransDate, cellValue);
                                4:
                                    EVALUATE(TransAmt, cellValue);
                            END;
                        END;
                    END;

                    Window.UPDATE(1, EmployeeNo);
                    if DeleteExisting then begin
                        EmpJnlLine.RESET;
                        CLEAR(EmpJnlLine);
                        EmpJnlLine.SETRANGE("Employee No.", EmployeeNo);
                        EmpJnlLine.SETRANGE("Transaction Type", TransType);
                        EmpJnlLine.SETRANGE("Transaction Date", TransDate);
                        if EmpJnlLine.FINDFIRST then
                            EmpJnlLine.DELETEALL;
                    end;

                    EmpJnlLine.RESET;
                    CLEAR(EmpJnlLine);
                    EmpJnlLine.SETRANGE("Employee No.", EmployeeNo);
                    EmpJnlLine.SETRANGE("Transaction Type", TransType);
                    EmpJnlLine.SETRANGE("Transaction Date", TransDate);
                    if not EmpJnlLine.FINDFIRST then begin
                        EmpJnlLine.RESET;
                        EmpJnlLine.INIT;
                        EmpJnlLine.VALIDATE("Employee No.", EmployeeNo);
                        EmpJnlLine.VALIDATE("Transaction Type", TransType);
                        EmpJnlLine.VALIDATE("Starting Date", TransDate);
                        EmpJnlLine.VALIDATE("Ending Date", TransDate);

                        HRTransTypes.SETRANGE(Code, TransType);
                        if HRTransTypes.FINDFIRST then
                            EmpJnlLine.Type := HRTransTypes.Type;

                        EmpJnlLine.Description := 'Transaction Imported from Excel';
                        EmpJnlLine.VALIDATE("Transaction Date", TransDate);
                        EmpJnlLine.Value := TransAmt;
                        EmpJnlLine."Calculated Value" := TransAmt;

                        if AutoApprove then begin
                            EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Approved;
                            EmpJnlLine."Approved By" := USERID;
                            EmpJnlLine."Approved Date" := WORKDATE;
                            EmpJnlLine."Released By" := USERID;
                            EmpJnlLine."Released Date" := WORKDATE;
                            EmpJnlLine."Opened By" := '';
                            EmpJnlLine."Opened Date" := 0D;
                        end else begin
                            EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Opened;
                            EmpJnlLine."Opened By" := USERID;
                            EmpJnlLine."Opened Date" := WORKDATE;
                        end;

                        EmpJnlLine.INSERT(true);
                        RowNo += 1;
                    end;
                end;
            UNTIL ExcelBuf.NEXT = 0;
        Window.CLOSE;
        UploadedFileName := '';
    end;

    procedure GetMonthName(PayrollDate: Date; NameLanguage: Option EN,AR) Txt: text[100]
    var
        Month: integer;
    begin
        IF PayrollDate = 0D THEN
            EXIT('');
        Month := DATE2DMY(PayrollDate, 2);
        CASE Month OF
            1:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'كانون الثاني'
                ELSE
                    Txt := 'JANUARY';
            2:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'شباط'
                ELSE
                    Txt := 'FEBRUARY';
            3:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'أذار'
                ELSE
                    Txt := 'MARCH';
            4:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'نيسان'
                ELSE
                    Txt := 'APRIL';
            5:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'أيار'
                ELSE
                    Txt := 'MAY';
            6:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'حزيران'
                ELSE
                    Txt := 'JUNE';
            7:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'تموز'
                ELSE
                    Txt := 'JULY';
            8:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'أب'
                ELSE
                    Txt := 'AUGUST';
            9:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'أيلول'
                ELSE
                    Txt := 'SEPTEMBER';
            10:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'تشرين الأول'
                ELSE
                    Txt := 'OCTOBER';
            11:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'تشرين الثاني'
                ELSE
                    Txt := 'NOVEMBER';
            12:
                IF NameLanguage = NameLanguage::AR THEN
                    Txt := 'كانون الأول'
                ELSE
                    Txt := 'DECEMBRE';
        END;
        EXIT(Txt);
    end;

    procedure GetFirstDateofMonth(PayrollDate: Date) FirstDateofMonth: Date
    var
        Month: Integer;
        Year: Integer;
        DateRec: Record Date;
    begin
        IF PayrollDate = 0D THEN
            EXIT;

        Month := DATE2DMY(PayrollDate, 2);
        Year := DATE2DMY(PayrollDate, 3);

        DateRec.SETRANGE("Period Type", DateRec."Period Type"::Month);
        DateRec.SETRANGE("Period No.", Month);
        DateRec.SETRANGE("Period Start", DMY2DATE(1, Month, Year));
        IF DateRec.FINDFIRST THEN
            FirstDateofMonth := DateRec."Period Start";
        EXIT(FirstDateofMonth);
    end;

    procedure GetLastDateofMonth(PayrollDate: Date) LastDateofMonth: Date
    var
        Month: Integer;
        Year: Integer;
        DateRec: Record Date;
    begin
        IF PayrollDate = 0D THEN
            EXIT;

        Month := DATE2DMY(PayrollDate, 2);
        Year := DATE2DMY(PayrollDate, 3);

        DateRec.SETRANGE("Period Type", DateRec."Period Type"::Month);
        DateRec.SETRANGE("Period No.", Month);
        DateRec.SETRANGE("Period Start", DMY2DATE(1, Month, Year));
        IF DateRec.FINDFIRST THEN
            LastDateofMonth := DateRec."Period End";
        EXIT(LastDateofMonth);
    end;

    procedure GetNSSFPrecision() Val: Decimal;
    var
        PayrollParameter: Record "Payroll Parameter";
    begin
        PayrollParameter.GET;
        //The value cannot be 0
        if PayrollParameter."NSSF Precision" > 0 then
            exit(PayrollParameter."NSSF Precision")
        else
            exit(1000);
    end;
}