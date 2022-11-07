report 98008 "Salary NSSF 1"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary NSSF 1.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", Status;
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(CompanyPic; CompanyInformation.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(Employee__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Global_Dimension_1_Code__Control16; "Global Dimension 1 Code")
            {
            }
            column(Employee__First_Name_; "First Name")
            {
            }
            column(Employee__Middle_Name_; "Middle Name")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(Employee__NSSF_No__; "Social Security No.")
            {
            }
            column(Employee__Employment_Date_; "Employment Date")
            {
            }
            column(Employee__Termination_Date_; "Termination Date")
            {
            }
            column(BasicSalary; BasicSalary)
            {
            }
            column(NSSF2; "NSSF2%")
            {
            }
            column(NSSF7; "NSSF7%")
            {
            }
            column(EOSI85; "EOSI8.5%")
            {
            }
            column(FamilyCompensation; FamilyCompensation)
            {
            }
            column(EOS; EOS)
            {
            }
            column(FamilyAllowancePaid; FamilyAllowancePaid)
            {
            }
            column(NumberofPeriod; NumberofPeriod)
            {
            }
            column(NumberOfEligible; NumberOfEligible)
            {
            }
            column(MStatus; MStatus)
            {
            }
            column(Employee__First_Nationality_Code_; "First Nationality Code")
            {
            }
            column(EOSUPTO64; EOSUPTO64)
            {
            }
            column(DepartmentCode; DepartmentCode)
            {
            }
            column(DepartmentName; DepartmentName)
            {
            }
            column(FamilySubscriptionMax; FamilySubscriptionMax)
            {
            }
            column(SalaryMotherhoodMax; SalaryMotherhoodMax)
            {
            }
            column(MHoodCeilingCaption; MHoodCeilingCaption)
            {
            }
            column(FSUBCeilingCaption; FSUBCeilingCaption)
            {
            }
            column(Employee__NSSF_Date_; "NSSF Date")
            {
            }
            column(EmployeeCaption; EmployeeCaptionLbl)
            {
            }
            column(Employee__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Employee__Global_Dimension_1_Code__Control16Caption; FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(Employee__First_Name_Caption; FIELDCAPTION("First Name"))
            {
            }
            column(Employee__Middle_Name_Caption; FIELDCAPTION("Middle Name"))
            {
            }
            column(Employee__Last_Name_Caption; FIELDCAPTION("Last Name"))
            {
            }
            column(Employee__NSSF_No__Caption; FIELDCAPTION("Social Security No."))
            {
            }
            column(Employee__Employment_Date_Caption; FIELDCAPTION("Employment Date"))
            {
            }
            column(Employee__Termination_Date_Caption; FIELDCAPTION("Termination Date"))
            {
            }
            column(Employee__NSSF_Date_Caption; FIELDCAPTION("NSSF Date"))
            {
            }
            column(Employee__Global_Dimension_1_Code_Caption; FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(Employee__First_Nationality_Code_Caption; FIELDCAPTION("First Nationality Code"))
            {
            }
            column(WorkingDays; WorkingDays)
            {
            }
            column(NoOfMonth; NoOfMonth)
            {
            }
            column(SpouseSecured_Employee; Employee."Spouse Secured")
            {
            }
            column(SpouseHusbandWork; SpouseHusbandWork)
            {
            }
            column(TotalEOS; TotalEOS)
            {
            }

            trigger OnAfterGetRecord();
            begin
                NoOfMonth := Payrollfunction.GetEmployeeWorkingMonths(Employee."No.", FromDate, ToDate);
                EmpRelative.SETRANGE("Employee No.", Employee."No.");
                EmpRelative.SETFILTER(Type, '%1|%2', EmpRelative.Type::Husband, EmpRelative.Type::Wife);
                if EmpRelative.FINDFIRST then begin
                    if EmpRelative.Working then
                        SpouseHusbandWork := true
                    else
                        SpouseHusbandWork := false;
                end;

                if ((Employee."Termination Date" <> 0D) and (Employee."Termination Date" < FromDate)) or (Employee."Employment Date" > ToDate) then
                    CurrReport.SKIP;
                //
                MHoodCeilingCaption := 0;
                FSUBCeilingCaption := 0;
                PayParm.GET;
                IF FromDate < PayParm."Before Monthly Cont Date" THEN BEGIN
                    MHoodCeilingCaption := PayParm."MHood Before Max Monthly Cont";
                    FSUBCeilingCaption := PayParm."FSUB Before Max Monthly Cont";
                end
                ELSE
                    IF (FromDate >= PayParm."Before Monthly Cont Date") AND (FromDate < PayParm."Before Monthly Cont Date 2") THEN BEGIN
                        MHoodCeilingCaption := PayParm."MHood Before Max Monthly Cont2";
                        FSUBCeilingCaption := PayParm."FSUB Before Max Monthly Cont2";
                    end
                    ELSE BEGIN
                        MHoodCeilingCaption := PayParm."MHood Max Monthly Cont";
                        FSUBCeilingCaption := PayParm."FSUB Max Monthly Cont";
                    END;
                //
                CalculateReportsData(Employee);
                exit;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Date Filter")
                {
                    Caption = 'Date Filter';
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            ToDate := CALCDATE('+1M-1D', FromDate);
                        end;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if ToDate < FromDate then
                                ERROR('To Date Must be Greater than From Date');
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        if Payrollfunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
        CompanyInfo.GET;
    end;

    var
        FromDate: Date;
        ToDate: Date;
        PayDetailLine: Record "Pay Detail Line";
        PayParm: Record "Payroll Parameter";
        BasicSalary: Decimal;
        "NSSF2%": Decimal;
        "NSSF7%": Decimal;
        "EOSI8.5%": Decimal;
        FamilyCompensation: Decimal;
        EOS: Decimal;
        FamilyAllowancePaid: Decimal;
        NumberofPeriod: Integer;
        CompanyInformation: Record "Company Information";
        CompanyInfo: Record "Company Information";
        PayLedgerEntry: Record "Payroll Ledger Entry";
        PayLedgerRec: Record "Payroll Ledger Entry";
        NumberOfEligible: Integer;
        MStatus: Text[10];
        EOSUPTO64: Decimal;
        DepartmentCode: Code[20];
        DepartmentName: Text[100];
        FamilySubscriptionMax: Decimal;
        SalaryMotherhoodMax: Decimal;
        MHoodCeilingCaption: Decimal;
        FSUBCeilingCaption: Decimal;
        MHoodCeiling: Decimal;
        FSUBCeiling: Decimal;
        EmployeeCaptionLbl: Label 'Employee';
        Payrollfunction: Codeunit "Payroll Functions";
        WorkingDays: Decimal;
        NoOfMonth: Decimal;
        SpouseHusbandWork: Boolean;
        EmpRelative: Record "Employee Relative";
        HRSetup: Record "Human Resources Setup";
        TotalEOS: Decimal;
        PayElement: Record "Pay Element";

    local procedure CalculateReportsData(EmployeeTbt: Record Employee);
    begin
        BasicSalary := 0;
        "NSSF2%" := 0;
        "NSSF7%" := 0;
        "EOSI8.5%" := 0;
        FamilyCompensation := 0;
        EOS := 0;
        FamilyAllowancePaid := 0;
        NumberofPeriod := 0;
        MStatus := '';
        NumberOfEligible := 0;
        FamilySubscriptionMax := 0;
        SalaryMotherhoodMax := 0;
        MHoodCeiling := 0;
        FSUBCeiling := 0;
        WorkingDays := 0;

        PayParm.GET;
        PayDetailLine.SETRANGE("Employee No.", EmployeeTbt."No.");
        PayDetailLine.SETFILTER("Payroll Date", '%1..%2', FromDate, ToDate);
        if PayDetailLine.FINDFIRST then
            repeat
                NumberofPeriod := PayDetailLine.Period;
                PayElement.Get(PayDetailLine."Pay Element Code");

                //if PayDetailLine."Pay Element Code" = '032' then begin
                if PayElement."Category Type" = PayElement."Category Type"::"MedicalMotherhood-9" then begin
                    "NSSF2%" += PayDetailLine."Calculated Amount";
                    "NSSF7%" += PayDetailLine."Employer Amount";
                end;

                //if PayDetailLine."Pay Element Code" = '031' then begin
                if PayElement."Category Type" = PayElement."Category Type"::"EOS-8.5" then begin
                    "EOSI8.5%" += PayDetailLine."Employer Amount";
                end;

                //if PayDetailLine."Pay Element Code" = '030' then begin
                if PayElement."Category Type" = PayElement."Category Type"::"FamilySubscription-6" then begin
                    FamilyCompensation += PayDetailLine."Employer Amount";
                end;

                if PayDetailLine."Pay Element Code" = PayParm."Family Allowance Code" then begin
                    FamilyAllowancePaid += PayDetailLine."Calculated Amount";
                end;
            until PayDetailLine.NEXT = 0;

        PayLedgerEntry.SETRANGE("Employee No.", EmployeeTbt."No.");
        PayLedgerEntry.SETFILTER("Payroll Date", '%1..%2', FromDate, ToDate);
        if PayLedgerEntry.FINDFIRST then
            repeat
                BasicSalary += PayLedgerEntry."Total Salary for NSSF";
                if DepartmentCode = '' then
                    DepartmentCode := PayLedgerEntry."Shortcut Dimension 1 Code";

                if NumberOfEligible = 0 then
                    NumberOfEligible := PayLedgerEntry."Eligible Children Count";

                if MStatus = '' then begin
                    if PayLedgerEntry."Social Status" = PayLedgerEntry."Social Status"::Married then begin
                        if PayLedgerEntry."Spouse Secured" then
                            MStatus := 'M - '
                        else
                            MStatus := 'M + ';

                        if Employee.Gender = Employee.Gender::Female then
                            MStatus := 'M';
                    end
                    else
                        if PayLedgerEntry."Social Status" = PayLedgerEntry."Social Status"::Single then
                            MStatus := 'S'
                        else
                            if PayLedgerEntry."Social Status" = PayLedgerEntry."Social Status"::Widow then
                                MStatus := 'W'
                            else
                                if PayLedgerEntry."Social Status" = PayLedgerEntry."Social Status"::Divorced then
                                    MStatus := 'D'
                end;
                WorkingDays += PayLedgerEntry."Working Days";
            until PayLedgerEntry.NEXT = 0;

        PayLedgerRec.SETRANGE("Employee No.", EmployeeTbt."No.");
        PayLedgerRec.SETFILTER("Payroll Date", '%1..%2', FromDate, ToDate);
        PayLedgerRec.SETFILTER("Payment Category", '%1', PayLedgerRec."Payment Category"::" ");
        if PayLedgerRec.FINDFIRST then
            repeat
                PayParm.GET;
                IF PayLedgerRec."Payroll Date" < PayParm."Before Monthly Cont Date" THEN BEGIN
                    MHoodCeiling := PayParm."MHood Before Max Monthly Cont";
                    FSUBCeiling := PayParm."FSUB Before Max Monthly Cont";
                end
                ELSE
                    IF (PayLedgerRec."Payroll Date" >= PayParm."Before Monthly Cont Date") AND (PayLedgerRec."Payroll Date" < PayParm."Before Monthly Cont Date 2") THEN BEGIN
                        MHoodCeiling := PayParm."MHood Before Max Monthly Cont2";
                        FSUBCeiling := PayParm."FSUB Before Max Monthly Cont2";
                    end
                    ELSE BEGIN
                        MHoodCeiling := PayParm."MHood Max Monthly Cont";
                        FSUBCeiling := PayParm."FSUB Max Monthly Cont";
                    END;
                if Employee."Termination Date" = 0D THEN BEGIN
                    IF BasicSalary > MHoodCeiling THEN
                        SalaryMotherhoodMax += MHoodCeiling
                    ELSE
                        SalaryMotherhoodMax += BasicSalary;
                end
                else begin
                    IF PayParm."Employ-Termination Affect NSSF" THEN BEGIN
                        IF BasicSalary > ((Employee."Termination Date" - FromDate + 1) / (Payrollfunction.GetDaysInMonth(DATE2DMY(Employee."Termination Date", 2), DATE2DMY(Employee."Termination Date", 3)))) * MHoodCeiling THEN
                            SalaryMotherhoodMax += ((Employee."Termination Date" - FromDate + 1) / (Payrollfunction.GetDaysInMonth(DATE2DMY(Employee."Termination Date", 2), DATE2DMY(Employee."Termination Date", 3)))) * MHoodCeiling
                        ELSE
                            SalaryMotherhoodMax += BasicSalary;
                    END
                    ELSE BEGIN
                        IF BasicSalary > MHoodCeiling THEN
                            SalaryMotherhoodMax += MHoodCeiling
                        ELSE
                            SalaryMotherhoodMax += BasicSalary;
                    END;
                END;

                IF Employee."Termination Date" = 0D THEN BEGIN
                    IF BasicSalary > FSUBCeiling THEN
                        FamilySubscriptionMax += FSUBCeiling
                    ELSE
                        FamilySubscriptionMax += BasicSalary;
                END
                ELSE BEGIN
                    IF PayParm."Employ-Termination Affect NSSF" THEN BEGIN
                        IF BasicSalary > ((Employee."Termination Date" - FromDate + 1) / (Payrollfunction.GetDaysInMonth(DATE2DMY(Employee."Termination Date", 2), DATE2DMY(Employee."Termination Date", 3)))) * FSUBCeiling THEN
                            FamilySubscriptionMax += ((Employee."Termination Date" - FromDate + 1) / (Payrollfunction.GetDaysInMonth(DATE2DMY(Employee."Termination Date", 2), DATE2DMY(Employee."Termination Date", 3)))) * FSUBCeiling
                        ELSE
                            FamilySubscriptionMax += BasicSalary;
                    END
                    ELSE BEGIN
                        IF BasicSalary > FSUBCeiling THEN
                            FamilySubscriptionMax += FSUBCeiling
                        ELSE
                            FamilySubscriptionMax += BasicSalary;
                    END;
                END;
            until PayLedgerRec.NEXT = 0;

        IF "EOSI8.5%" = 0 THEN
            TotalEOS += 0
        ELSE
            TotalEOS += BasicSalary;
    end;
}

