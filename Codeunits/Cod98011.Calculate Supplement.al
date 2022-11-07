codeunit 98011 "Calculate Supplement"
{
    // version PY1.0,SHR1.0

    // #py1.1 : consider updt to pay ledg entry where : scholarship PayE must not be Manual and must not be payroll Special  code.
    // #NA : calculate of split entries + delete of all split records where status is inactive
    //        + delete of all splittted entries where status is terminated + delete of all transactions before the employment date.
    // #py2.0 : consider updt to pay ledg entry where : Commission on Sales PayE must not be Manual + must not be payroll Special  code.
    // #syria : All modifications done lately
    // #PY4.0 : to fix problem of duplicate income tax in case of multiple calculation
    // #PY4.1 : to fix problem of duplicate Days Off Transportation in case of multiple calculation
    // #PY1.3 : to add manual line to net pay in case it's defined as included in pay element setup
    // MEG01.00 [MB.3007] : - Calculate manual pension referring to Pension payroll Date

    TableNo = "Payroll Status";

    trigger OnRun();
    begin
        HRSetup.GET;
        Paystatus.COPY(Rec);
        CalcAllEmployees := true;
        Code;
        Rec := Paystatus;
        CalcAllEmployees := false;
    end;

    var
        Paystatus: Record "Payroll Status";
        CalcAllEmployees: Boolean;
        Window: Dialog;
        PayEmployee2: Record Employee;
        NoOfRecords: Integer;
        RecordNo: Integer;
        PayParam: Record "Payroll Parameter";
        PayrollNo: Code[10];
        PayrollTitle: Text[20];
        TaxYear: Integer;
        PayrollDate: Date;
        Divisor: Integer;
        PeriodNo: Integer;
        PayEmployee: Record Employee;
        EmployeeJnl: Record "Employee Journal Line";
        V_NSSFSalary: Decimal;
        NSSFSalaryFIXED: Decimal;
        NSSFSalaryVARIABLE: Decimal;
        NSSFSalary: Decimal;
        CauseOfAbsence: Record "Cause of Absence";
        PayElement2: Record "Pay Element";
        EmploymentType: Record "Employment Type";
        PayDetailLine: Record "Pay Detail Line";
        PayDetailHeader: Record "Pay Detail Header";
        PayDetailHeader2: Record "Pay Detail Header";
        PayElement: Record "Pay Element";
        V_EmployeeLoan: Decimal;
        PayDetailLine2: Record "Pay Detail Line";
        PayrollFunctions: Codeunit "Payroll Functions";
        PayLedgEntry: Record "Payroll Ledger Entry";
        NextLineNo: Integer;
        V_Allowances: Decimal;
        V_Deductions: Decimal;
        V_TaxAllowances: Decimal;
        V_TaxDeductions: Decimal;
        V_NTaxAllowances: Decimal;
        V_NTaxDeductions: Decimal;
        V_PayeTax: Decimal;
        V_CalcBasicPay: Decimal;
        V_CalcNTaxTransp: Decimal;
        V_CalcTaxTransp: Decimal;
        V_WorkingDaysAbs: Decimal;
        V_NTaxAttendanceDaysAbs: Decimal;
        V_TaxAttendanceDaysAbs: Decimal;
        V_ExemptTax: Decimal;
        V_TaxableSalary: Decimal;
        V_NetTaxSalary: Decimal;
        V_CalculatedAmount: Decimal;
        V_CalcExemptTax: Decimal;
        V_CalcPayeTax: Decimal;
        V_CalcNetTaxSalary: Decimal;
        TaxBand: Record "Tax Band";
        V_NetSalary: Decimal;
        Loop: Integer;
        V_EmployeePension: Decimal;
        V_EmployerPension: Decimal;
        PensionScheme: Record "Pension Scheme";
        V_BasicPay: Decimal;
        V_FamilyAllowances: Decimal;
        V_OvertimePay: Decimal;
        V_PublicOvertimePay: Decimal;
        InBaseccy: Boolean;
        InAddccy: Boolean;
        InBothccy: Boolean;
        VA_Salary: Decimal;
        VA_CalcSalary: Decimal;
        VA_CalculatedAmount: Decimal;
        VS_Salary: Decimal;
        VS_Transportation: Decimal;
        VA_Allowances: Decimal;
        VA_Deductions: Decimal;
        VA_NetSalary: Decimal;
        VA_EmployeeLoan: Decimal;
        PayLedgEntryNo: Integer;
        ACYCompE: Record "ACY Computation Elements";
        V_ConvertedSalaryPay: Decimal;
        ACYComp_WorkingDays: Boolean;
        ACYComp_AttendanceDays: Boolean;
        ACY_ConvertedSalaryPay: Decimal;
        ACY_OvertimePay: Decimal;
        ACY_PublicOvertimePay: Decimal;
        ACYComp_IncomeTax: Boolean;
        ACY_WorkingDaysAbs: Decimal;
        V_LatenessDaysAbs: Decimal;
        ACY_LatenessDaysAbs: Decimal;
        LatenessPerc: Decimal;
        V_OutstandingLoan: Decimal;
        ACY_OutstandingLoan: Decimal;
        V_VacationBalance: Decimal;
        EmpAbsEntitle: Record "Employee Absence Entitlement";
        SpouseExemptTax: Boolean;
        LCY_TransportationPerDay: Decimal;
        ACY_TransportationPerDay: Decimal;
        LCY_OffDays_Transportation: Decimal;
        ACY_OffDays_Transportation: Decimal;
        ACYComp_Overtime: Boolean;
        ACYComp_Public: Boolean;
        ACYComp_ConvertedSalary: Boolean;
        V_HCL: Decimal;
        ACY_HCL: Decimal;
        V_Scholar: Decimal;
        ACY_Scholar: Decimal;
        HRFunctions: Codeunit "Human Resource Functions";
        DailyBasis: Boolean;
        WrkDays: Decimal;
        SplitPayDetLine: Record "Split Pay Detail Line";
        TempSplitPayDetLine: Record "Split Pay Detail Line" temporary;
        TempSplitPayDetLine2: Record "Split Pay Detail Line" temporary;
        SplitLineNo: Integer;
        Date1: Date;
        Date2: Date;
        SplitTotCalAmtLCY: Decimal;
        SplitTotCalAmtACY: Decimal;
        SplitTotEffDays: Decimal;
        NbOfDays: Integer;
        NbOfNonWD: Integer;
        AmntPerDayLCY: Decimal;
        AmntPerDayACY: Decimal;
        V_SalesCom: Decimal;
        ACY_SalesCom: Decimal;
        SpecPayElt: Record "Specific Pay Element";
        ACY_CalcNTaxTransp: Decimal;
        VLateEarlyPay: Decimal;
        HRSetup: Record "Human Resources Setup";
        HRTransactionType: Record "HR Transaction Types";
        V_EmployeePensionAbove: Decimal;
        V_EmployerPensionAbove: Decimal;
        V_Rounding: Decimal;
        V_YearlyExemptTax: Decimal;

    local procedure "Code"();
    begin
        Paystatus.TESTFIELD("Supplement Start Date");
        Window.OPEN(
          'Payroll Calculation\\' +
          'Processing Employee:    #2########\' +
          'Number    #3######  of  #4######\' +
          '@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        // Find calc.pay and update Employees in current pay frequency
        with PayEmployee2 do begin
            RESET;
            SETCURRENTKEY("Payroll Group Code", "Pay Frequency", "Global Dimension 1 Code");
            SETRANGE("Payroll Group Code", Paystatus."Payroll Group Code");
            SETRANGE("Pay Frequency", Paystatus."Pay Frequency");
            SETRANGE(Status, PayEmployee.Status::Active);
            SETFILTER("Employment Date", '<=%1', Paystatus."Supplement Start Date");
            NoOfRecords := COUNT;
            Window.UPDATE(4, NoOfRecords);

            RecordNo := 0;
            if FIND('-') then
                repeat
                    RecordNo := RecordNo + 1;
                    Window.UPDATE(2, "No.");
                    Window.UPDATE(3, RecordNo);
                    CalculateEmployeePay(PayEmployee2, Paystatus, true);
                    Window.UPDATE(5, ROUND(RecordNo / NoOfRecords * 10000, 1));
                until NEXT = 0;

            UpdatePayStatus(Paystatus);
        end; // emp. main selection

        MESSAGE(
          'Pay has been calculated for all %1 Employees.',
          Paystatus."Pay Frequency", Paystatus."Payroll Group Code");
        Window.CLOSE;
    end;

    procedure CalculateEmployeePay(EmpRec: Record Employee; PayStatusRec: Record "Payroll Status"; ShowMessage: Boolean);
    var
        PayDetailLine2: Record "Pay Detail Line";
        MyPensionScheme: Record "Pension Scheme";
        TaxPeriod: Decimal;
        EmpJournalLineRec: Record "Employee Journal Line";
        EntryNumber: Integer;
    begin
        Paystatus.COPY(PayStatusRec);
        InitialisePayroll(Paystatus);
        PayEmployee.COPY(EmpRec);
        //py2.0
        PayEmployee.CALCFIELDS("Include in Pay Cycle");
        if not EmploymentType.GET(PayEmployee."Employment Type Code") then
            ERROR('Employment Type not Defined for Employee %1 : ', PayEmployee."No.");

        InBaseccy := false;
        InAddccy := false;
        InBothccy := false;
        if (PayEmployee."Basic Pay" <> 0) and (PayEmployee."Salary (ACY)" = 0) then
            InBaseccy := true;
        if (PayEmployee."Basic Pay" = 0) and (PayEmployee."Salary (ACY)" <> 0) then
            InAddccy := true;
        if (PayEmployee."Basic Pay" <> 0) and (PayEmployee."Salary (ACY)" <> 0) then
            InBothccy := true;

        ACYComp_WorkingDays := false;
        ACYComp_AttendanceDays := false;
        ACYComp_Overtime := false;
        ACYComp_Public := false;
        ACYComp_ConvertedSalary := false;
        ACYComp_IncomeTax := false;
        ACYCompE.RESET;
        ACYCompE.SETRANGE("Element Code", ACYCompE."Element Code"::"Working Days");
        if ACYCompE.FIND('-') then
            ACYComp_WorkingDays := true;
        ACYCompE.RESET;
        ACYCompE.SETRANGE("Element Code", ACYCompE."Element Code"::"Attendance Days");
        if ACYCompE.FIND('-') then
            ACYComp_AttendanceDays := true;
        ACYCompE.RESET;
        ACYCompE.SETRANGE("Element Code", ACYCompE."Element Code"::Overtime);
        if ACYCompE.FIND('-') then
            ACYComp_Overtime := true;
        ACYCompE.RESET;
        ACYCompE.SETRANGE("Element Code", ACYCompE."Element Code"::Public);
        if ACYCompE.FIND('-') then
            ACYComp_Public := true;
        ACYCompE.RESET;
        ACYCompE.SETRANGE("Element Code", ACYCompE."Element Code"::"Converted Salary");
        if ACYCompE.FIND('-') then
            ACYComp_ConvertedSalary := true;
        ACYCompE.RESET;
        ACYCompE.SETRANGE("Element Code", ACYCompE."Element Code"::"Income Tax");
        if ACYCompE.FIND('-') then
            ACYComp_IncomeTax := true;

        CLEAR(PayDetailHeader);
        if PayDetailHeader.GET(PayEmployee."No.") then begin
            if not PayDetailHeader."Include in Pay Cycle" then
                exit;
            PayDetailHeader.SETFILTER("Date Filter", '%1..%2', Paystatus."Supplement Start Date", Paystatus."Period End Date");
            PayDetailHeader.CALCFIELDS("Working Days Affected", "Attendance Days Affected", "Overtime Hours", "Overtime with Unpaid Hours",
                                     "Converted Salary", "Lateness Days Affected", "Late/ Early Attendance (Hours)"); //Mb.0605+-
        end;

        // Delete all Opened records
        PayLedgEntry.RESET;
        PayLedgEntry.SETCURRENTKEY("Employee No.", Open);
        PayLedgEntry.SETRANGE("Employee No.", PayEmployee."No.");
        PayLedgEntry.SETRANGE(Open, true);
        PayLedgEntry.DELETEALL;
        PayLedgEntry.RESET;
        if PayLedgEntry.FIND('+') then
            PayLedgEntryNo := PayLedgEntry."Entry No." + 1
        else
            PayLedgEntryNo := 1;

        PayDetailLine.RESET;
        SplitPayDetLine.RESET; //py2.0
        PayDetailLine.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
        PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.SETRANGE("Manual Pay Line", false);
        if PayDetailLine.FIND('-') then
            repeat
                PayElement.GET(PayDetailLine."Pay Element Code");
                if PayElement."Payroll Special Code" then
                    PayDetailLine.DELETE;
                //py2.0+
                SplitPayDetLine.SETRANGE("Employee No.", PayEmployee."No.");
                SplitPayDetLine.SETRANGE("Pay Detail Line No.", PayDetailLine."Line No.");
                SplitPayDetLine.SETRANGE(Open, true);
                SplitPayDetLine.DELETEALL;
            //py2.0-
            until PayDetailLine.NEXT = 0;
        //MB.0307+
        MyPensionScheme.RESET;
        MyPensionScheme.SETRANGE("Manual Pension", true);
        if MyPensionScheme.FIND('-') then
            repeat
                PayDetailLine.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Manual Pay Line", true);
                PayDetailLine.SETRANGE("Pay Element Code", MyPensionScheme."Associated Pay Element");
                PayDetailLine.SETRANGE(Recurring, false);
                if PayDetailLine.FIND('-') then
                    PayDetailLine.DELETEALL;
            until MyPensionScheme.NEXT = 0;

        //MB.0307-
        //PY4.0+
        PayParam.GET;
        if PayElement.GET(PayParam."Income Tax Code") then
            if not PayElement."Payroll Special Code" then begin
                PayDetailLine2.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
                PayDetailLine2.SETRANGE("Employee No.", PayEmployee."No.");
                PayDetailLine2.SETRANGE(Open, true);
                PayDetailLine2.SETRANGE("Pay Element Code", PayParam."Income Tax Code");
                if PayDetailLine2.FIND('-') then
                    PayDetailLine2.DELETEALL;
            end;
        //PY4.0-
        //PY4.1+
        PayParam.GET;
        if PayElement.GET(PayParam."Day-Off Transportation") then begin
            PayDetailLine2.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
            PayDetailLine2.SETRANGE("Employee No.", PayEmployee."No.");
            PayDetailLine2.SETRANGE(Open, true);
            PayDetailLine2.SETRANGE("Pay Element Code", PayParam."Day-Off Transportation");
            if PayDetailLine2.FIND('-') then
                PayDetailLine2.DELETEALL;
        end;
        //PY4.1-
        //PY4.1+
        PayParam.GET;
        if PayElement.GET(PayParam.OverTime) then begin
            PayDetailLine2.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
            PayDetailLine2.SETRANGE("Employee No.", PayEmployee."No.");
            PayDetailLine2.SETRANGE(Open, true);
            PayDetailLine2.SETRANGE("Pay Element Code", PayParam.OverTime);
            if PayDetailLine2.FIND('-') then
                PayDetailLine2.DELETEALL;
        end;

        //++++++++++++++++++++
        PayParam.GET;
        if PayElement.GET(PayParam."High Cost of Living Code") then begin
            PayDetailLine2.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
            PayDetailLine2.SETRANGE("Employee No.", PayEmployee."No.");
            PayDetailLine2.SETRANGE(Open, true);
            PayDetailLine2.SETRANGE("Pay Element Code", PayParam."High Cost of Living Code");
            if PayDetailLine2.FIND('-') then
                PayDetailLine2.DELETEALL;
        end;
        //----------------
        //PY4.1-

        //py2.0+
        //IF PayEmployee.Status <> PayEmployee.Status::Active THEN BEGIN
        if not PayEmployee."Include in Pay Cycle" then begin
            //py2.0-
            PayDetailLine.SETFILTER(Period, '<>0');
            PayDetailLine.MODIFYALL("Tax Year", 0);
            PayDetailLine.MODIFYALL(Period, 0);
            exit;
        end;

        // Calculate Employee Pay
        with PayEmployee do begin
            ClearTotals;
            //py2.0+
            //IF Status = Status::Active THEN BEGIN
            if PayDetailHeader."Include in Pay Cycle" then begin
                //py2.0-
                //Period := DATE2DMY(Paystatus."Supplement Payroll Date",2);
                //EDM+
                InsertEmployeeBenefitPenalties;
                //EDM-
                CALCFIELDS("Pay To Date", "Taxable Pay To Date", "Tax Paid To Date", "Outstanding Loans");
                CalculateGrossPay;
                GetManualPayE;
                InsertSpePayE;
                if (PayEmployee.Declared <> PayEmployee.Declared::"Non-Declared") and (not InAddccy) and
                   (PayEmployee.Declared <> PayEmployee.Declared::Contractual) then begin
                    if (PayEmployee."No Exempt" = false) then begin
                        TaxPeriod := 12;
                        V_CalcExemptTax := PayrollFunctions.CalculateTaxCode(PayEmployee, true, SpouseExemptTax, Paystatus."Supplement End Date") / 12;
                        if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                            V_CalcExemptTax := V_CalcExemptTax * (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                                            / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3)));
                            V_CalcExemptTax := ROUND(V_CalcExemptTax, 0.01);
                        end;
                    end
                    else
                        V_CalcExemptTax := 0;
                    CalculateTax;
                end else
                    V_CalcExemptTax := 0;
                //EDM.IT+
                CalculateNetPay;
                InsertEmpLedgEntry(Paystatus."Supplement Payroll Date");
                //IF (PayEmployee."Month 13 Amount"<>0) OR (PayEmployee."Comission EOY"<>0)THEN
                //BEGIN
                CalcPensionRetroactive(PayStatusRec."Supplement End Date", PayEmployee."No.", PayLedgEntry);
                CalculateNetPay;
                PayLedgEntry.SETRANGE("Payroll Date", Paystatus."Supplement Payroll Date");
                PayLedgEntry.SETRANGE(Open, true);
                PayLedgEntry.SETRANGE("Employee No.", PayEmployee."No.");
                if PayLedgEntry.FINDFIRST then
                    repeat
                        PayLedgEntry.DELETE;
                    until PayLedgEntry.NEXT = 0;
                InsertEmpLedgEntry(Paystatus."Supplement Payroll Date");
                CalculateTaxRetro(PayStatusRec."Period End Date", PayEmployee."No.", PayLedgEntry, PeriodNo);
                CalculateNetPay;
                //END;
                //EDM.IT-

                UpdateAbsences;
                UpdateSplitEmpJnls;
            end; //emp.active
        end; // ledg

        with PayDetailHeader do begin
            if GET(PayEmployee."No.") and "Include in Pay Cycle" then begin
                "Calculation Required" := false;
                "Payslip Printed" := false;
                MODIFY;
            end;
        end;

        EmpRec := PayEmployee;

        if not CalcAllEmployees then
            if ShowMessage then
                MESSAGE('Pay has been calculated for %1.', EmpRec.FullName);

    end;

    local procedure InitialisePayroll(PayStatus: Record "Payroll Status");
    begin
        // Setup the Payroll No and title
        SetupPayrollInfo(PayStatus);

        // Get the tax bands record
        if (not TaxBand.FIND('-')) and (PayParam."Income Tax Code" <> '') then
            ERROR('Tax Bands have not been Setup.');
    end;

    local procedure SetupPayrollInfo(PayStatus: Record "Payroll Status");
    var
        StartDate: Date;
        EndDate: Date;
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        // Get the Payment Codes from the payroll parameter record
        PayParam.GET;

        Day := DATE2DMY(PayStatus."Supplement Payroll Date", 1);
        Month := DATE2DMY(PayStatus."Supplement Payroll Date", 2);
        Year := DATE2DMY(PayStatus."Supplement Payroll Date", 3);
        TaxYear := Year;

        // Setup the payroll title,and payroll number
        PayrollDate := PayStatus."Supplement Payroll Date";
        PayrollTitle := 'Week No. ';
        Divisor := 52;
        PeriodNo := DATE2DMY(PayStatus."Supplement Payroll Date", 2);
        case PayStatus."Pay Frequency" of
            PayStatus."Pay Frequency"::Weekly:
                begin
                    PayrollNo := 'W-';
                end;
            PayStatus."Pay Frequency"::Monthly:
                begin
                    PayrollNo := 'M-';
                    PayrollTitle := 'Month No. ';
                    Divisor := 12;
                end;
        end;

        PayrollNo := FORMAT(TaxYear) + PayrollNo + FORMAT(PeriodNo);
        PayrollTitle := PayrollTitle + FORMAT(PeriodNo);
    end;

    local procedure UpdatePayStatus(PayStatus: Record "Payroll Status");
    var
        PayStatus2: Record "Payroll Status";
    begin
        if not PayStatus2.GET(PayStatus."Payroll Group Code", PayStatus."Pay Frequency") then begin
            PayStatus2 := PayStatus;
            PayStatus2.INSERT
        end else begin
            PayStatus2 := PayStatus;
            PayStatus2.MODIFY
        end;
    end;

    local procedure ClearTotals();
    begin
        V_Allowances := 0;
        VA_Allowances := 0;
        V_Deductions := 0;
        VA_Deductions := 0;
        V_TaxAllowances := 0;
        V_TaxDeductions := 0;
        V_NTaxAllowances := 0;
        V_NTaxDeductions := 0;
        V_PayeTax := 0;
        V_CalcPayeTax := 0;
        V_BasicPay := 0;
        V_CalcBasicPay := 0;
        V_CalcNTaxTransp := 0;
        V_CalcTaxTransp := 0;
        V_WorkingDaysAbs := 0;
        VLateEarlyPay := 0;//MB.240607+-
        ACY_WorkingDaysAbs := 0;
        V_LatenessDaysAbs := 0;
        ACY_LatenessDaysAbs := 0;
        V_NTaxAttendanceDaysAbs := 0;
        V_TaxAttendanceDaysAbs := 0;
        V_TaxableSalary := 0;
        V_NetTaxSalary := 0;
        V_EmployeePension := 0;
        V_EmployerPension := 0;
        //EDM.IT+
        V_EmployeePensionAbove := 0;
        V_EmployerPensionAbove := 0;
        //EDM.IT-
        V_EmployeeLoan := 0;
        VA_EmployeeLoan := 0;
        V_FamilyAllowances := 0;
        V_OvertimePay := 0;
        V_PublicOvertimePay := 0;
        ACY_OvertimePay := 0;
        ACY_PublicOvertimePay := 0;
        V_ConvertedSalaryPay := 0;
        ACY_ConvertedSalaryPay := 0;
        VA_Salary := 0;
        VS_Salary := 0;
        VS_Transportation := 0;
        VA_CalcSalary := 0;
        V_VacationBalance := 0;
        V_OutstandingLoan := 0;
        ACY_OutstandingLoan := 0;
        ACY_TransportationPerDay := 0;
        LCY_TransportationPerDay := 0;
        ACY_OffDays_Transportation := 0;
        LCY_OffDays_Transportation := 0;
        V_HCL := 0;
        ACY_HCL := 0;
        V_Scholar := 0;
        ACY_Scholar := 0;
        V_SalesCom := 0;
        ACY_SalesCom := 0;
        V_YearlyExemptTax := 0;
    end;

    local procedure CalculateGrossPay();
    var
        Loans: Record "Employee Loan";
        TempAmount: Decimal;
        RemainingAmount: Decimal;
        NoOfLoanPayments: Integer;
        PayrollAbsenceUnits: Decimal;
        ExcessTranspAmt: Decimal;
        ExcessPayE: Code[10];
        PayDetailHeadSplit: Record "Pay Detail Header";
        FromDate: Date;
        ToDate: Date;
        OldDateTo: Date;
        AttendanceDaysAffected: Decimal;
        DaysToCalculate: Decimal;
    begin
        with PayDetailLine do begin
            RESET;
            SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
            SETRANGE("Employee No.", PayEmployee."No.");
            SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Manual Pay Line", false);
            if FIND('-') then
                repeat
                    CLEAR(SplitTotCalAmtLCY);
                    CLEAR(SplitTotCalAmtACY);
                    CLEAR(SplitTotEffDays);
                    PayElement.GET("Pay Element Code");
                    V_CalculatedAmount := Amount;
                    VA_CalculatedAmount := 0;
                    case "Pay Element Code" of
                        PayParam."Basic Pay Code":
                            begin
                                V_CalculatedAmount := 0;
                                Amount := 0;
                                if not SplitEntries(PayElement, PayEmployee."No.") then begin
                                    V_BasicPay := 0;
                                    V_CalcBasicPay := 0;
                                    VA_Salary := "Amount (ACY)";
                                    if InBothccy then begin
                                        if not DailyBasis then
                                            VS_Salary := 0
                                        else
                                            VS_Salary := 0;
                                    end;
                                    if ((((PayDetailHeader."Working Days Affected" <> 0) or (PayDetailHeader."Late/ Early Attendance (Hours)" <> 0))
                                      and (not DailyBasis)) or (DailyBasis)) and
                                        (PayElement."Days in  Month" <> 0) then begin
                                        if (ACYComp_WorkingDays) and (InBothccy) then begin
                                            if not DailyBasis then begin
                                                ACY_WorkingDaysAbs := 0;
                                                ACY_WorkingDaysAbs := 0;
                                                VA_CalcSalary := 0;
                                            end else
                                                VA_CalcSalary := 0;
                                            VA_CalculatedAmount := 0;
                                        end;
                                        if ((not ACYComp_WorkingDays) or (InBaseccy) or (InAddccy)) then begin
                                            if V_BasicPay <> 0 then begin
                                                if not DailyBasis then begin
                                                    V_WorkingDaysAbs := 0;
                                                    V_WorkingDaysAbs := 0;
                                                    VLateEarlyPay := 0;
                                                    VLateEarlyPay := 0;
                                                    V_CalcBasicPay := 0;
                                                end else
                                                    V_CalcBasicPay := 0;
                                                V_CalculatedAmount := 0;
                                            end;
                                            if VA_Salary <> 0 then begin
                                                if not DailyBasis then begin
                                                    ACY_WorkingDaysAbs := 0;
                                                    ACY_WorkingDaysAbs := 0;
                                                    VA_CalcSalary := 0;
                                                end else
                                                    VA_CalcSalary := 0;
                                                VA_CalculatedAmount := 0;
                                            end;
                                        end;
                                    end;
                                    if (ACYComp_WorkingDays) and (InBothccy) and (VA_CalcSalary < 0) then begin
                                        V_CalcBasicPay := 0;
                                        VA_CalcSalary := 0;
                                        V_CalcBasicPay := 0;
                                        V_CalculatedAmount := 0;
                                        VA_CalculatedAmount := 0;
                                    end;
                                end
                                else begin
                                    V_CalculatedAmount := SplitTotCalAmtLCY;
                                    VA_CalculatedAmount := SplitTotCalAmtACY;
                                    V_BasicPay := 0;
                                    V_CalcBasicPay := 0;
                                    VA_Salary := 0;
                                    if InBothccy then begin
                                        if not DailyBasis then
                                            VS_Salary := 0
                                        else
                                            VS_Salary := 0;
                                    end;
                                end;
                            end;
                        PayParam."Family Allowance Code":
                            begin
                                V_CalculatedAmount := 0;
                                V_FamilyAllowances := 0;
                                Amount := 0;
                            end;

                        PayParam."Non-Taxable Transp. Code":
                            begin
                                V_CalculatedAmount := 0;
                                if (V_BasicPay = 0) and (Amount = 0) then
                                    V_CalculatedAmount := 0;
                            end;
                        PayParam."Mobile allowance":
                            begin
                                V_CalculatedAmount := 0;
                            end;
                        PayParam."Housing Allowance":
                            begin
                                V_CalculatedAmount := 0;
                            end;
                        PayParam."Scholarship Code":
                            begin
                                V_Scholar := 0;
                                ACY_Scholar := 0;
                                V_CalculatedAmount := 0;
                                VA_CalculatedAmount := 0;
                            end;
                        PayParam."Commission on Sales Code":
                            begin
                                V_SalesCom := 0;
                                ACY_SalesCom := 0;
                                V_CalculatedAmount := 0;
                                VA_CalculatedAmount := 0;
                            end;
                    end;
                    "Calculated Amount" := V_CalculatedAmount;
                    "Calculated Amount (ACY)" := VA_CalculatedAmount;
                    "Efective Nb. of Days" := SplitTotEffDays;
                    if not PayElement."Not Included in Net Pay" then
                        SumUpAllowDeduct(PayElement, "Calculated Amount", "Calculated Amount (ACY)", ExcessTranspAmt, ExcessPayE);
                    "Exchange Rate" := Paystatus."Exchange Rate";
                    "Payroll Ledger Entry No." := PayLedgEntryNo;
                    "Tax Year" := TaxYear;
                    Period := PeriodNo;
                    "Payroll Date" := PayrollDate;
                    "Not Included in Net Pay" := PayElement."Not Included in Net Pay";
                    "Shortcut Dimension 1 Code" := PayEmployee."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PayEmployee."Global Dimension 2 Code";
                    MODIFY;
                until NEXT = 0;
        end;
        V_TaxableSalary := V_TaxAllowances;
    end;

    local procedure CalculateTax();
    var
        TaxPeriod: Decimal;
        Computed: Boolean;
        Remainder: Decimal;
        LastBand: Boolean;
        PayLedgerEntryTEMP: Record "Payroll Ledger Entry";
        TotalTaxablePay: Decimal;
        TotalMonth: Decimal;
        TotalTaxPaid: Decimal;
        TotalFreePay: Decimal;
        CurrTaxableAmount: Decimal;
        OriTax: Decimal;
        TxBnd: Decimal;
        TaxDiscountPerc: Decimal;
        Numberoftaxdays: Decimal;
    begin
        if PayParam."Income Tax Code" = '' then
            exit;
        //EDM+
        CalculateTaxableSalary;
        //EDM-
        TaxPeriod := 12;

        V_YearlyExemptTax := PayrollFunctions.CalculateTaxCode(PayEmployee, TRUE, SpouseExemptTax, Paystatus."Supplement End Date");

        if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
            V_ExemptTax := V_YearlyExemptTax / TaxPeriod;
            V_ExemptTax := (V_ExemptTax) * (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                           / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3)));

        end
        else
            V_ExemptTax := V_YearlyExemptTax / TaxPeriod;

        V_NetTaxSalary := V_TaxableSalary - V_ExemptTax;
        V_CalcNetTaxSalary := V_TaxableSalary - V_CalcExemptTax;

        CurrTaxableAmount := V_CalcNetTaxSalary + TotalTaxablePay - TotalFreePay;

        Loop := 1;
        while Loop <= 2 do begin
            LastBand := false;
            Computed := false;
            if Loop = 1 then
                Remainder := V_NetTaxSalary
            else
                Remainder := V_CalcNetTaxSalary;
            if TaxBand.FIND('-') then
                repeat
                    if Remainder >= TaxBand."Annual Bandwidth" / TaxPeriod then begin
                        Computed := true;
                        Remainder := Remainder - TaxBand."Annual Bandwidth" / TaxPeriod;
                        if Loop = 1 then
                            V_PayeTax := V_PayeTax + (TaxBand."Annual Bandwidth" / TaxPeriod) * (TaxBand.Rate / 100)
                        else
                            V_CalcPayeTax := V_CalcPayeTax + (TaxBand."Annual Bandwidth" / TaxPeriod) * (TaxBand.Rate / 100);
                    end else begin
                        LastBand := true;
                        if Remainder > 0 then begin
                            if Loop = 1 then
                                V_PayeTax := V_PayeTax + (Remainder * (TaxBand.Rate / 100))
                            else
                                V_CalcPayeTax := V_CalcPayeTax + (Remainder * (TaxBand.Rate / 100));
                        end;
                    end;
                until (TaxBand.NEXT = 0) or (LastBand);
            Loop := Loop + 1;
        end; // loop
        //
        V_CalcPayeTax := PayrollFunctions.RoundingAmt(V_CalcPayeTax, false);
        V_CalcPayeTax := V_CalcPayeTax - TotalTaxPaid;


        if V_CalcPayeTax < 0 then
            V_CalcPayeTax := 0;

        OriTax := V_CalcPayeTax;

        V_CalcPayeTax := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');

        if PayEmployee.Declared = PayEmployee.Declared::Contractual then begin
            PayParam.GET;
            V_CalcPayeTax := V_TaxableSalary * PayParam."Contractual Tax %" / 100;
            V_CalcPayeTax := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
        end;

        // Insert PAYE Tax
        PayDetailLine.INIT;
        PayElement.GET(PayParam."Income Tax Code");
        V_CalcPayeTax := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
        PayDetailLine.Amount := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
        PayDetailLine."Calculated Amount" := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
        InsertPayDetailLine(PayElement.Code, '');
        if not PayElement."Not Included in Net Pay" then
            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '')
        else
            V_TaxDeductions := PayDetailLine."Calculated Amount";
    end;

    local procedure CalculateNetPay();
    begin
        FixTotals;
        V_NetSalary := ROUND(V_Allowances - V_Deductions, GetPayrollNETPrecision(), '=');
        V_Rounding := V_NetSalary - (V_Allowances - V_Deductions);
        VA_NetSalary := ROUND(VA_Allowances - VA_Deductions, GetPayrollNETPrecision(), '=');
    end;

    local procedure FixTotals();
    var
        PayDetailLineRec: Record "Pay Detail Line";
        PayElementrRec: Record "Pay Element";
    begin
        V_Allowances := 0;
        VA_Allowances := 0;
        V_TaxAllowances := 0;
        V_NTaxAllowances := 0;
        V_Deductions := 0;
        VA_Deductions := 0;
        V_TaxDeductions := 0;
        V_NTaxDeductions := 0;

        PayDetailLineRec.CALCFIELDS("Payment Category");
        PayDetailLineRec.SETRANGE("Payment Category", PayDetailLineRec."Payment Category"::Supplement);
        PayDetailLineRec.SETRANGE("Employee No.", PayEmployee."No.");
        PayDetailLineRec.SETRANGE("Tax Year", TaxYear);
        PayDetailLineRec.SETRANGE(Period, PeriodNo);
        PayDetailLineRec.SETRANGE("Payroll Date", PayrollDate);
        PayDetailLineRec.SETRANGE("Payroll Group Code", PayEmployee."Payroll Group Code");
        if PayDetailLineRec.FINDFIRST then
            repeat
                PayElementrRec.SETRANGE(PayElementrRec.Code, PayDetailLineRec."Pay Element Code");
                if PayElementrRec.FINDFIRST then begin
                    if PayElementrRec.Type = PayElementrRec.Type::Addition then begin
                        V_Allowances := V_Allowances + PayDetailLineRec."Calculated Amount";
                        VA_Allowances := VA_Allowances + PayDetailLineRec."Calculated Amount (ACY)";
                        if (PayElementrRec.Tax) and (PayElementrRec.Code <> PayParam."Basic Pay Code") then begin
                            V_TaxAllowances := V_TaxAllowances + PayDetailLineRec."Calculated Amount";
                        end else
                            if not PayElementrRec.Tax then
                                V_NTaxAllowances := V_NTaxAllowances + PayDetailLineRec."Calculated Amount";
                    end
                    else
                        if PayElementrRec.Type = PayElementrRec.Type::Deduction then begin
                            V_Deductions := V_Deductions + PayDetailLineRec."Calculated Amount";
                            VA_Deductions := VA_Deductions + PayDetailLineRec."Calculated Amount (ACY)";
                            if (PayElementrRec.Code = PayParam."Income Tax Code") then
                                V_TaxDeductions := V_TaxDeductions + PayDetailLineRec."Calculated Amount"
                            else
                                V_NTaxDeductions := V_NTaxDeductions + PayDetailLineRec."Calculated Amount";
                        end;
                end;
            until PayDetailLineRec.NEXT = 0;
    end;

    procedure InsertEmpLedgEntry(PayrollDate: Date);
    var
        Calc1: Decimal;
        Calc2: Decimal;
    begin
        // Update Employee Ledger Entry table
        with PayLedgEntry do begin
            INIT;
            "Entry No." := PayLedgEntryNo;
            "Employee No." := PayEmployee."No.";
            "Payroll Date" := PayrollDate;
            "Period Start Date" := Paystatus."Supplement Start Date";
            "Period End Date" := Paystatus."Supplement End Date";
            "Document No." := PayrollNo;
            Description := PayrollTitle;
            "Shortcut Dimension 1 Code" := PayEmployee."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PayEmployee."Global Dimension 2 Code";
            "Gross Pay" := V_Allowances;
            "Taxable Pay" := V_TaxableSalary;
            "Tax Paid" := V_CalcPayeTax;
            //EDM.IT+
            "Income Tax" := V_CalcPayeTax;
            "Payment Category" := PayLedgEntry."Payment Category"::Supplement;
            //EDM.IT-
            "Net Pay" := V_NetSalary;
            "Free Pay" := V_CalcExemptTax;
            "Pay Frequency" := PayEmployee."Pay Frequency";
            "Exempt Tax" := PayEmployee."Exempt Tax";
            "Tax Year" := TaxYear;
            Period := PeriodNo;
            "Payment Method" := PayEmployee."Payment Method";
            "Payment Method (ACY)" := PayEmployee."Payment Method (ACY)";
            Open := true;
            "Current Year" := true;
            "Payroll Group Code" := PayEmployee."Payroll Group Code";
            "Basic Salary" := V_BasicPay;
            "Salary (ACY)" := VA_Salary;
            "Taxable Allowances" := V_TaxAllowances;
            "Non-Taxable Allowances" := V_NTaxAllowances;
            "Non-Taxable Deductions" := V_NTaxDeductions;
            "Taxable Deductions" := V_TaxDeductions;
            "Family Allowance" := V_FamilyAllowances;
            Overtime := ROUND(PayDetailHeader."Overtime Hours" + PayDetailHeader."Overtime with Unpaid Hours", 1, '>');
            "Overtime Pay" := V_OvertimePay;
            "Overtime Pay (ACY)" := ACY_OvertimePay;
            "Working Days Absence" := PayDetailHeader."Working Days Affected";
            "Working Days Absence Pay" := V_WorkingDaysAbs;
            "Late/ Early Hours Pay" := VLateEarlyPay;//MB.250607
            "Working Days Absence Pay (ACY)" := ACY_WorkingDaysAbs;
            "Late/ Early Attendance (Hours)" := PayDetailHeader."Late/ Early Attendance (Hours)";//MB.0605+-
            "Lateness Days Abs." := PayDetailHeader."Lateness Days Affected";
            //EDM+
            Rounding := V_NetSalary - (V_Allowances - V_Deductions);
            //EDM-

            // get amt on Lateness WDA amt.
            if ("Lateness Days Abs." <> 0) and (not DailyBasis) then begin
                LatenessPerc := ("Lateness Days Abs." / "Working Days Absence") * 100;
                LatenessPerc := ROUND(LatenessPerc, 1, '=');
                if "Working Days Absence Pay" <> 0 then begin
                    V_LatenessDaysAbs := ("Working Days Absence Pay" * LatenessPerc) / 100;
                    V_LatenessDaysAbs := ROUND(V_LatenessDaysAbs, 1, '=');
                end;
                if "Working Days Absence Pay (ACY)" <> 0 then begin
                    ACY_LatenessDaysAbs := ("Working Days Absence Pay (ACY)" * LatenessPerc) / 100;
                    ACY_LatenessDaysAbs := ROUND(ACY_LatenessDaysAbs, 1, '=');
                end;
            end; //Lateness
            "Lateness Days Abs. Pay" := V_LatenessDaysAbs;
            "Lateness Days Abs. Pay (ACY)" := ACY_LatenessDaysAbs;
            "Attendance Days Absence" := PayDetailHeader."Attendance Days Affected";
            "Attendance Days Absence Pay" := V_NTaxAttendanceDaysAbs;
            "Attendance Days Abs Pay (ACY)" := V_TaxAttendanceDaysAbs;
            "Public Overtime Pay" := V_PublicOvertimePay;
            "Public Overtime Pay (ACY)" := ACY_PublicOvertimePay;
            "Converted Salary" := PayDetailHeader."Converted Salary";
            "Converted Salary Pay" := V_ConvertedSalaryPay;
            "Converted Salary Pay (ACY)" := ACY_ConvertedSalaryPay;
            "Employee Loan" := V_EmployeeLoan;
            "Employee Loan (ACY)" := VA_EmployeeLoan;
            "Gross Pay (ACY)" := VA_Allowances;
            "Net Pay (ACY)" := VA_NetSalary;
            "Allowances (ACY)" := VA_Allowances;
            "Deductions (ACY)" := VA_Deductions;
            "Employee Pension" := V_EmployeePension;
            "Employer Pension" := V_EmployerPension;
            "Exchange Rate" := Paystatus."Exchange Rate";
            "Employment Type Code" := PayEmployee."Employment Type Code";
            "Social Status" := PayEmployee."Social Status";
            "Spouse Secured" := PayEmployee."Spouse Secured";
            "Husband Paralysed" := PayEmployee."Husband Paralyzed";
            Foreigner := PayEmployee.Foreigner;
            Declared := PayEmployee.Declared;
            "First Name" := PayEmployee."First Name";
            "Last Name" := PayEmployee."Last Name";
            "Emp. Bank Acc No." := PayEmployee."Emp. Bank Acc No.";
            "Emp. Bank Acc No. (ACY)" := PayEmployee."Emp. Bank Acc No. (ACY)";
            "Bank No." := PayEmployee."Bank No.";
            "Bank No. (ACY)" := PayEmployee."Bank No. (ACY)";
            if V_CalcExemptTax <> 0 then
                "Spouse Exempt Tax" := SpouseExemptTax;
            CauseOfAbsence.RESET;
            CauseOfAbsence.SETCURRENTKEY("Transaction Type");
            CauseOfAbsence.SETRANGE("Transaction Type", CauseOfAbsence."Transaction Type"::Vacation);
            if CauseOfAbsence.FIND('-') then
                repeat
                    if EmpAbsEntitle.GET(PayEmployee."No.", CauseOfAbsence.Code) then begin
                        EmpAbsEntitle.CALCFIELDS(Taken);
                        V_VacationBalance := V_VacationBalance + (EmpAbsEntitle.Entitlement - EmpAbsEntitle.Taken);
                    end;
                until CauseOfAbsence.NEXT = 0;
            "Vacation Balance" := V_VacationBalance;
            "Outstanding Loan" := V_OutstandingLoan;
            "Outstanding Loan (ACY)" := ACY_OutstandingLoan;
            "Job Title" := PayEmployee."Job Title";
            "Job Position Code" := PayEmployee."Job Position Code";
            "HCL Pay" := V_HCL;
            "HCL Pay (ACY)" := ACY_HCL;
            "Scholarship Pay" := V_Scholar;
            "Scholarship Pay (ACY)" := ACY_Scholar;
            "Sales Commission Pay" := V_SalesCom;
            "Sales Commission Pay (ACY)" := ACY_SalesCom;
            "Total Salary for NSSF" := V_NSSFSalary;//EDM.JA+-
            if DailyBasis then
                "Contract Type" := "Contract Type"::"Daily Basis";
            INSERT;
            NextLineNo := NextLineNo + 1;
        end;
    end;

    procedure InsertSpePayE();
    var
        LineNo: Integer;
        PayElementCode: Code[10];
        V_Amount: Decimal;
        EmployeeLoan: Record "Employee Loan";
        TempPayment: Decimal;
        RemainingPayment: Decimal;
        V_OvertimeHours: Decimal;
        DaysinMonth: Integer;
        HoursinDay: Decimal;
        IsOTUnpaidHours: Boolean;
        BusinessTripCalc: Boolean;
        HRSetup: Record "Human Resources Setup";
        EmployeeLoanLine: Record "Employee Loan Line";
        L_NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5";
    begin
        // Insert Special Pay Elements :

        // 1.Attendance with Associated PYE
        CauseOfAbsence.RESET;
        CauseOfAbsence.SETFILTER("Associated Pay Element", '<>%1', '');
        if CauseOfAbsence.FINDFIRST then
            repeat
                CLEAR(IsOTUnpaidHours);
                CLEAR(DaysinMonth);
                CLEAR(HoursinDay);
                CLEAR(V_Amount);
                PayDetailLine.INIT;
                PayElementCode := CauseOfAbsence."Associated Pay Element";
                PayElement.GET(PayElementCode);
                case CauseOfAbsence."Transaction Type" of
                    CauseOfAbsence."Transaction Type"::Overtime:
                        begin
                            if (EmploymentType."Max Allowed Overtime Per Day" <> 0) and (EmploymentType."Max Monthly Paid Overtime" <> 0) then begin
                                DaysinMonth := EmploymentType."Max Monthly Paid Overtime";
                                HoursinDay := EmploymentType."Max Allowed Overtime Per Day";
                            end;
                            if (DaysinMonth = 0) or (HoursinDay = 0) then begin
                                if PayElement."Days in  Month" = 0 then
                                    DaysinMonth := PayrollFunctions.GetWorkingDay(Paystatus."Supplement Start Date"
                                , Paystatus."Supplement End Date", PayEmployee)
                                else
                                    DaysinMonth := PayElement."Days in  Month";
                                HoursinDay := PayElement."Hours in  Day";
                            end;
                            if DailyBasis then
                                DaysinMonth := 1;
                            if (((PayDetailHeader."Overtime Hours" <> 0) and (CauseOfAbsence."Unpaid Hours" = 0)) or
                                 ((PayDetailHeader."Overtime with Unpaid Hours" <> 0) and (CauseOfAbsence."Unpaid Hours" <> 0))) and
                               (DaysinMonth <> 0) and (HoursinDay <> 0) then begin
                                if CauseOfAbsence."Unpaid Hours" = 0 then
                                    V_OvertimeHours := ABS(PayDetailHeader."Overtime Hours")
                                else begin
                                    V_OvertimeHours := ABS(PayDetailHeader."Overtime with Unpaid Hours");
                                    IsOTUnpaidHours := true;
                                end;
                                if (ACYComp_Overtime) and (InBothccy) then begin
                                    // V_Amount := VS_Salary / DaysinMonth;
                                    // V_Amount := V_Amount / HoursinDay;
                                    //EDM+
                                    HRSetup.GET;
                                    if HRSetup."Monthly Hours" <> 0 then
                                        V_Amount := VS_Salary / HRSetup."Monthly Hours"
                                    else begin
                                        V_Amount := VS_Salary / DaysinMonth;
                                        V_Amount := V_Amount / HoursinDay;
                                    end;
                                    //EDM-
                                    V_Amount := V_Amount * V_OvertimeHours;
                                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
                                    PayDetailLine."Amount (ACY)" := V_Amount;
                                    PayDetailLine."Calculated Amount (ACY)" := V_Amount;
                                    //ACY_OvertimePay := ACY_OvertimePay + V_Amount; //py2.0
                                end;  //ot-acy.E
                                if ((not ACYComp_Overtime) or (InBaseccy) or (InAddccy)) then begin
                                    if V_BasicPay <> 0 then begin
                                        // V_Amount := V_BasicPay / DaysinMonth;
                                        // V_Amount := V_Amount / HoursinDay;
                                        //EDM+
                                        HRSetup.GET;
                                        if HRSetup."Monthly Hours" <> 0 then
                                            V_Amount := V_BasicPay / HRSetup."Monthly Hours"
                                        else begin
                                            V_Amount := V_BasicPay / DaysinMonth;
                                            V_Amount := V_Amount / HoursinDay;
                                        end;
                                        //EDM-

                                        V_Amount := V_Amount * V_OvertimeHours;
                                        V_Amount := PayrollFunctions.RoundingAmt(V_Amount, false);
                                        PayDetailLine.Amount := ROUND(V_Amount, 1, '>');
                                        PayDetailLine."Calculated Amount" := ROUND(V_Amount, 1, '>');
                                        //V_OvertimePay := V_OvertimePay + V_Amount; //py2.0
                                    end;
                                    if VA_Salary <> 0 then begin
                                        //EDM+ V_Amount := V_BasicPay / DaysinMonth;
                                        //EDM+ V_Amount := V_Amount / HoursinDay;
                                        //EDM+
                                        HRSetup.GET;
                                        if HRSetup."Monthly Hours" <> 0 then
                                            V_Amount := V_BasicPay / HRSetup."Monthly Hours"
                                        else begin
                                            V_Amount := V_BasicPay / DaysinMonth;
                                            V_Amount := V_Amount / HoursinDay;
                                        end;
                                        //EDM-

                                        V_Amount := V_Amount * V_OvertimeHours;
                                        V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
                                        PayDetailLine."Amount (ACY)" := V_Amount;
                                        PayDetailLine."Calculated Amount (ACY)" := V_Amount;
                                        //ACY_OvertimePay := ACY_OvertimePay + V_Amount; //py2.0
                                    end;
                                end; //not an ACY.E - only lcy/acy
                            end; // overtime<>0
                            InsertPayDetailLine(PayElementCode, 'OverTime');//EDM+-
                                                                            //EDM+++++
                            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, ''); //PY1.3
                            V_TaxableSalary := V_TaxableSalary + PayDetailLine."Calculated Amount";
                            //EDM----
                        end; //overtime
                    CauseOfAbsence."Transaction Type"::Salary:
                        begin
                            PayElement2.GET(PayParam."Basic Pay Code");
                            PayEmployee.GET(PayDetailHeader."Employee No.");
                            PayDetailHeader.CALCFIELDS(PayDetailHeader."Late/ Early Attendance (Hours)");
                            if PayEmployee."Hourly Basis" = true then begin
                                V_Amount := 0;//PayEmployee."Hourly Rate" *  ABS(PayDetailHeader."Late/ Early Attendance (Hours)");
                                V_Amount := 0;//PayrollFunctions.RoundingAmt(V_Amount,TRUE);
                                PayDetailLine.Amount := 0;// V_Amount;
                                PayDetailLine."Calculated Amount" := 0;// V_Amount;
                                V_ConvertedSalaryPay := 0;//V_Amount;
                            end else begin
                                if DailyBasis then
                                    PayElement2."Days in  Month" := 1;
                                if (PayDetailHeader."Converted Salary" <> 0) and (PayElement2."Days in  Month" <> 0) then begin
                                    if (ACYComp_ConvertedSalary) and (InBothccy) then begin
                                        V_Amount := 0;//(VS_Salary / PayElement2."Days in  Month") *
                                                      //                  ABS(PayDetailHeader."Converted Salary");
                                        V_Amount := 0;//PayrollFunctions.RoundingAmt(V_Amount,TRUE);
                                        PayDetailLine."Amount (ACY)" := 0;// V_Amount;
                                        PayDetailLine."Calculated Amount (ACY)" := 0;// V_Amount;
                                        ACY_ConvertedSalaryPay := 0;// V_Amount;
                                    end; //csal-acy.E
                                end;
                                if ((not ACYComp_ConvertedSalary) or (InBaseccy) or (InAddccy)) then begin
                                    if V_BasicPay <> 0 then begin
                                        V_Amount := 0;// (V_BasicPay / PayElement2."Days in  Month") *
                                                      //                 ABS(PayDetailHeader."Converted Salary");
                                        V_Amount := 0;//PayrollFunctions.RoundingAmt(V_Amount,FALSE);
                                        PayDetailLine.Amount := 0;// V_Amount;
                                        PayDetailLine."Calculated Amount" := 0;// V_Amount;
                                        V_ConvertedSalaryPay := 0;//V_Amount;
                                    end;
                                    if VA_Salary <> 0 then begin
                                        V_Amount := 0;//(VA_Salary / PayElement2."Days in  Month") *
                                                      //                ABS(PayDetailHeader."Converted Salary");
                                        V_Amount := 0;//PayrollFunctions.RoundingAmt(V_Amount,TRUE);
                                        PayDetailLine."Amount (ACY)" := 0;// V_Amount;
                                        PayDetailLine."Calculated Amount (ACY)" := 0;// V_Amount;
                                        ACY_ConvertedSalaryPay := 0;//V_Amount;
                                    end;
                                end; //not an ACY.E - only lcy/acy
                            end; //conv.salary <> 0
                            InsertPayDetailLine(PayElementCode, '');
                        end; //conv.salary
                end; //case abs trx.type
                     //InsertPayDetailLine(PayElementCode,'');
                     //py2.0+
                     //IF (CauseOfAbsence."Transaction Type" = CauseOfAbsence."Transaction Type"::Overtime) AND
                     // ((PayDetailLine.Amount <> 0) OR (PayDetailLine."Amount (ACY)" <> 0)) THEN BEGIN
                     //IF GetSplitLineNo(PayParam."Basic Pay Code") <> 0 THEN BEGIN
                     //SplitOvertime(IsOTUnpaidHours,HoursinDay,PayDetailLine."Line No.");
                     //END ELSE BEGIN
                     //V_OvertimePay := V_OvertimePay + PayDetailLine.Amount;
                     //ACY_OvertimePay := ACY_OvertimePay + PayDetailLine."Amount (ACY)";
                     //END; //upd.pay.ledg
                     //END;//split overtime
                     //py2.0-
                     /* IF NOT PayElement."Not Included in Net Pay" THEN BEGIN
                        SumUpAllowDeduct(PayElement,PayDetailLine."Calculated Amount",PayDetailLine."Calculated Amount (ACY)",0,''); //PY1.3
                        IF (PayElement.Type = PayElement.Type::Addition) AND (PayElement.Tax)THEN
                          V_TaxableSalary := V_TaxableSalary + PayDetailLine."Calculated Amount";
                      END;*/ // not.inc.net

            until CauseOfAbsence.NEXT = 0; // Overtime

        // 2.Pension Scheme with Associated PYE
        PensionScheme.RESET;
        PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
        PensionScheme.SETRANGE("Manual Pension", false);
        //EDM.JA+
        PensionScheme.SETFILTER(PensionScheme.Type, '<>%1 & <>%2 & <>%3 & <>%4  ', PensionScheme.Type::ReturnTax, PensionScheme.Type::ReturnMH, PensionScheme.Type::"FundContribution-Basic", PensionScheme.Type::"FundContribution-Net");
        //EDM.JA- 
        if PensionScheme.FINDFIRST then
            repeat
                //EDM.JA+
                CalculateSalaryNSSF();
                IF PensionScheme."Amount Type Classification" = PensionScheme."Amount Type Classification"::FIXED THEN
                    NSSFSalary := NSSFSalaryFIXED
                ELSE
                    IF PensionScheme."Amount Type Classification" = PensionScheme."Amount Type Classification"::VARIABLE THEN
                        NSSFSalary := NSSFSalaryVARIABLE
                    ELSE
                        NSSFSalary := V_NSSFSalary;
                //add in order to consider maximun age in validation - 22.12.2016 : AIM +
                IF (PensionScheme."Maximum Applicable Age" = 0) OR (PayrollFunctions.GetEmployeeAge(PayDetailHeader."Employee No.", Paystatus."Payroll Date") <= PensionScheme."Maximum Applicable Age") THEN BEGIN
                    //EDM.JA-
                    PayDetailLine.INIT;
                    IF PayrollFunctions.PensionApplicable(NSSFSalary, PayEmployee, PensionScheme) THEN BEGIN
                        PayElementCode := PensionScheme."Associated Pay Element";
                        PayElement.GET(PayElementCode);
                        if PensionScheme."Employee Contribution %" <> 0 then begin
                            IF PensionScheme.Type = PensionScheme.Type::MHOOD THEN
                                PayDetailLine.Amount := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::MHOOD2, FALSE)
                            ELSE BEGIN

                                PayDetailLine.Amount := NSSFSalary * (PensionScheme."Employee Contribution %" / 100);
                                PayDetailLine.Amount := Round(PayDetailLine.Amount, PayrollFunctions.GetNSSFPrecision, '>');
                                IF (PayDetailLine.Amount > (PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employee Contribution %" / 100))) AND
                                   (PensionScheme."Maximum Monthly Contribution" <> 0) THEN
                                    PayDetailLine.Amount := Round(PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employee Contribution %" / 100), PayrollFunctions.GetNSSFPrecision(), '>');
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                            END;
                            // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2-
                            V_EmployeePension := ROUND(V_EmployeePension + PayDetailLine.Amount, PayrollFunctions.GetNSSFPrecision(), '>');
                        END; // employee
                        IF PensionScheme."Employer Contribution %" <> 0 THEN BEGIN
                            IF (NOT PayEmployee.IsForeigner) OR (NOT PensionScheme."Foreigners Ineligible") THEN BEGIN
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                                IF (PensionScheme.Type = PensionScheme.Type::MHOOD) OR
                                  (PensionScheme.Type = PensionScheme.Type::FAMSUB) OR
                                  (PensionScheme.Type = PensionScheme.Type::EOSIND) THEN BEGIN
                                    IF PensionScheme.Type = PensionScheme.Type::MHOOD THEN
                                        PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::MHOOD7, FALSE)
                                    ELSE
                                        IF PensionScheme.Type = PensionScheme.Type::FAMSUB THEN
                                            PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::FAMSUB6, FALSE)
                                        ELSE
                                            IF PensionScheme.Type = PensionScheme.Type::EOSIND THEN
                                                PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::"EOS8.5", FALSE)
                                END ELSE BEGIN
                                    // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                                    PayDetailLine."Employer Amount" := Round(NSSFSalary * (PensionScheme."Employer Contribution %" / 100), PayrollFunctions.GetNSSFPrecision(), '>');
                                    PayDetailLine."Employer Amount" := Round(PayDetailLine."Employer Amount", PayrollFunctions.GetNSSFPrecision(), '>');
                                    IF (PayDetailLine."Employer Amount" > (PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employer Contribution %" / 100))) AND
                                   (PensionScheme."Maximum Monthly Contribution" <> 0) THEN
                                        PayDetailLine."Employer Amount" := Round(PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employer Contribution %" / 100), PayrollFunctions.GetNSSFPrecision(), '>');
                                    // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                                END;
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2-
                                V_EmployerPension := Round(V_EmployerPension + PayDetailLine."Employer Amount", PayrollFunctions.GetNSSFPrecision(), '>');
                            END; // employer
                        END;//+---
                        PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                        InsertPayDetailLine(PayElementCode, '');
                        IF Not PayElement."Not Included in Net Pay" Then
                            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
                    END;
                    //add in order to consider maximun age in validation - 22.12.2016 : AIM +
                END;
            //add in order to consider maximun age in validation - 22.12.2016 : AIM -

            UNTIL PensionScheme.NEXT = 0; // Pension

        // 2.1 Manual Pension Scheme with Associated PYE
        PensionScheme.RESET;
        PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
        PensionScheme.SETRANGE("Manual Pension", true);
        PensionScheme.SETRANGE("Pension Payroll Date", PayrollDate);
        PensionScheme.SETFILTER(PensionScheme.Type, '<>%1 & <>%2 & <>%3 & <>%4', PensionScheme.Type::ReturnTax, PensionScheme.Type::ReturnMH, PensionScheme.Type::"FundContribution-Basic", PensionScheme.Type::"FundContribution-Net");
        if PensionScheme.FIND('-') then
            repeat
                IF (PensionScheme."Maximum Applicable Age" = 0) OR (PayrollFunctions.GetEmployeeAge(PayDetailHeader."Employee No.", Paystatus."Payroll Date") <= PensionScheme."Maximum Applicable Age") THEN BEGIN
                    PayDetailLine.INIT;
                    if PayrollFunctions.PensionApplicable(V_TaxableSalary, PayEmployee, PensionScheme) then begin
                        PayElementCode := PensionScheme."Associated Pay Element";
                        PayElement.GET(PayElementCode);
                        IF PensionScheme."Employee Contribution %" <> 0 THEN BEGIN
                            // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                            IF PensionScheme.Type = PensionScheme.Type::MHOOD THEN
                                PayDetailLine.Amount := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::MHOOD2, FALSE)
                            ELSE BEGIN
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2-
                                PayDetailLine.Amount := NSSFSalary * (PensionScheme."Employee Contribution %" / 100);
                                PayDetailLine.Amount := Round(PayDetailLine.Amount, PayrollFunctions.GetNSSFPrecision(), '>');
                                IF (PayDetailLine.Amount > (PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employee Contribution %" / 100))) AND
                                 (PensionScheme."Maximum Monthly Contribution" <> 0) THEN
                                    PayDetailLine.Amount := Round(PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employee Contribution %" / 100), PayrollFunctions.GetNSSFPrecision(), '>');
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                            END;

                            V_EmployeePension := V_EmployeePension + PayDetailLine.Amount;
                        END; // employee
                        IF PensionScheme."Employer Contribution %" <> 0 THEN BEGIN
                            // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                            IF (PensionScheme.Type = PensionScheme.Type::MHOOD) OR
                              (PensionScheme.Type = PensionScheme.Type::FAMSUB) OR
                              (PensionScheme.Type = PensionScheme.Type::EOSIND) THEN BEGIN
                                IF PensionScheme.Type = PensionScheme.Type::MHOOD THEN
                                    PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::MHOOD7, FALSE)
                                ELSE
                                    IF PensionScheme.Type = PensionScheme.Type::FAMSUB THEN
                                        PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::FAMSUB6, FALSE)
                                    ELSE
                                        IF PensionScheme.Type = PensionScheme.Type::EOSIND THEN
                                            PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::"EOS8.5", FALSE)
                            END ELSE BEGIN
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2-
                                PayDetailLine."Employer Amount" := NSSFSalary * (PensionScheme."Employer Contribution %" / 100);
                                PayDetailLine."Employer Amount" := Round(PayDetailLine."Employer Amount", PayrollFunctions.GetNSSFPrecision(), '>');
                                IF (PayDetailLine."Employer Amount" > (PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employer Contribution %" / 100))) AND
                               (PensionScheme."Maximum Monthly Contribution" <> 0) THEN
                                    PayDetailLine."Employer Amount" := Round(PensionScheme."Maximum Monthly Contribution" * (PensionScheme."Employer Contribution %" / 100), PayrollFunctions.GetNSSFPrecision(), '>');
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                            END;
                            // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2-
                            V_EmployerPension := Round(V_EmployerPension + PayDetailLine."Employer Amount", PayrollFunctions.GetNSSFPrecision(), '>');
                        END; // employer
                        PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                        PayDetailLine."Manual Pay Line" := true;
                        InsertPayDetailLine(PayElementCode, '');
                        if not PayElement."Not Included in Net Pay" then
                            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
                    end;//EDM.IT+-; // apply pension

                END;
            until PensionScheme.NEXT = 0; // Pension

        //MB0307-
        // 3. Employee Loan
        // 4. Days-Off Transportation
    end;

    procedure InsertPayDetailLine(P_PayECode: Code[10]; PayCodeDescription: Text[30]);
    var
        LineNo: Integer;
    begin
        if (PayDetailLine.Amount = 0) and (PayDetailLine."Amount (ACY)" = 0) and (PayDetailLine."Employer Amount" = 0) then
            exit;

        PayDetailLine2.RESET;
        PayDetailLine2.SETRANGE("Employee No.", PayEmployee."No.");
        if PayDetailLine2.FIND('+') then
            LineNo := PayDetailLine2."Line No." + 1
        else
            LineNo := 1;

        PayDetailLine."Employee No." := PayEmployee."No.";
        PayDetailLine."Line No." := LineNo;
        PayDetailLine."Tax Year" := TaxYear;
        PayDetailLine.Period := PeriodNo;
        PayDetailLine."Payroll Date" := PayrollDate;
        PayDetailLine."Pay Frequency" := PayEmployee."Pay Frequency";
        PayDetailLine."Pay Element Code" := P_PayECode;
        if PayCodeDescription <> '' then
            PayDetailLine.Description := PayCodeDescription
        else
            PayDetailLine.Description := PayElement.Description;
        PayDetailLine.Type := PayElement.Type;
        PayDetailLine.Recurring := false;
        PayDetailLine.Open := true;
        PayDetailLine."Payroll Special Code" := PayElement."Payroll Special Code";
        PayDetailLine."Not Included in Net Pay" := PayElement."Not Included in Net Pay";
        PayDetailLine."Shortcut Dimension 1 Code" := PayEmployee."Global Dimension 1 Code";
        PayDetailLine."Shortcut Dimension 2 Code" := PayEmployee."Global Dimension 2 Code";
        PayDetailLine."Payroll Group Code" := PayEmployee."Payroll Group Code";
        PayDetailLine."Exchange Rate" := Paystatus."Exchange Rate";
        PayDetailLine."Payroll Ledger Entry No." := PayLedgEntryNo;
        PayDetailLine.INSERT;
    end;

    procedure SumUpAllowDeduct(P_PayE: Record "Pay Element"; P_CalcAmount: Decimal; PA_CalcAmount: Decimal; P_ExcAmount: Decimal; P_ExcPayECode: Code[10]);
    begin
        if (P_CalcAmount <> 0) or (PA_CalcAmount <> 0) then begin
            if P_PayE.Type = P_PayE.Type::Addition then begin
                V_Allowances := V_Allowances + P_CalcAmount;
                VA_Allowances := VA_Allowances + PA_CalcAmount;
                if (P_PayE.Tax) and (P_PayE.Code <> PayParam."Basic Pay Code") then begin
                    V_TaxAllowances := V_TaxAllowances + P_CalcAmount;
                end else
                    if not P_PayE.Tax then
                        V_NTaxAllowances := V_NTaxAllowances + P_CalcAmount;
            end else
                if P_PayE.Type = P_PayE.Type::Deduction then begin
                    V_Deductions := V_Deductions + P_CalcAmount;
                    VA_Deductions := VA_Deductions + PA_CalcAmount;
                    if (P_PayE.Code = PayParam."Income Tax Code") then
                        V_TaxDeductions := V_TaxDeductions + P_CalcAmount
                    else
                        V_NTaxDeductions := V_NTaxDeductions + P_CalcAmount;
                end; //deduction
        end;

        // excess in taxable transp will affect NT.transp : type=Addition Tax=No
        if (P_ExcAmount <> 0) and (P_ExcPayECode <> '') then begin
            PayElement2.GET(P_ExcPayECode);
            if PayElement2.Code = PayParam."Non-Taxable Transp. Code" then begin
                V_Allowances := V_Allowances - P_ExcAmount;
                V_NTaxAllowances := V_NTaxAllowances - P_ExcAmount;
            end;
        end; //excess transp.amt
    end;

    procedure GetManualPayE();
    var
        AttendanceDaysAffected: Decimal;
    begin
        with PayDetailLine do begin
            RESET;
            SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
            SETRANGE("Employee No.", PayEmployee."No.");
            SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Manual Pay Line", true);
            if FIND('-') then
                repeat
                    PayElement.GET("Pay Element Code");
                    if "Pay Element Code" = PayParam."High Cost of Living Code" then begin
                        //V_HCL := Amount;
                        //ACY_HCL := "Amount (ACY)";
                    end;
                    //"Calculated Amount" := Amount;
                    //"Calculated Amount (ACY)" := "Amount (ACY)";
                    //Syria+
                    /*
                    AttendanceDaysAffected := GetAffectedAttendanceTransport(PayEmployee,
                       Paystatus."Supplement Start Date",Paystatus."Supplement End Date",
                       Paystatus."Supplement Start Date",Paystatus."Supplement End Date");
                    IF PayElement."Days in  Month" > 0 THEN BEGIN
                      "Calculated Amount" := Amount - (Amount / PayElement."Days in  Month" * AttendanceDaysAffected);
                      "Calculated Amount (ACY)" := "Amount (ACY)"- ("Amount (ACY)"/ PayElement."Days in  Month" * AttendanceDaysAffected);
                    END ELSE BEGIN
                      "Calculated Amount" := Amount - (Amount * AttendanceDaysAffected
                           / PayrollFunctions.GetWorkingDay(Paystatus."Supplement Start Date",Paystatus."Supplement End Date",PayEmployee));
                      "Calculated Amount (ACY)" := "Amount (ACY)"- ("Amount (ACY)" * AttendanceDaysAffected
                           / PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee));
                    END;
                    */

                    //Syria-
                    if not PayElement."Not Included in Net Pay" then begin
                        if (PayElement.Type = PayElement.Type::Addition) and (PayElement.Tax) then//* BEGIN
                            V_TaxableSalary := V_TaxableSalary + "Calculated Amount";
                        SumUpAllowDeduct(PayElement, "Calculated Amount", "Calculated Amount (ACY)", 0, '');
                        //* END;
                    end; //not.inc.net
                    "Exchange Rate" := Paystatus."Exchange Rate";
                    "Payroll Ledger Entry No." := PayLedgEntryNo;
                    "Tax Year" := TaxYear;
                    Period := PeriodNo;
                    "Payroll Date" := PayrollDate;
                    "Not Included in Net Pay" := PayElement."Not Included in Net Pay";
                    //py2.0+
                    "Shortcut Dimension 1 Code" := PayEmployee."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PayEmployee."Global Dimension 2 Code";
                    //py2.0-
                    MODIFY;
                until NEXT = 0;
        end; //paydetail line

    end;

    procedure UpdateAbsences();
    var
        EmpJnlLine: Record "Employee Journal Line";
        EmpJnlLine2: Record "Employee Journal Line";
    begin
        EmpJnlLine.RESET;
        EmpJnlLine.SETCURRENTKEY("Employee No.", Type, Processed, "Document Status", Converted,
                  "Ending Date", "Affect Work Days", "Affect Attendance Days",
                  "Absence Transaction Type", "Unit of Measure Code", "Associate Pay Element", "Transaction Date", Entitled, Reseted);
        EmpJnlLine.SETRANGE("Employee No.", PayEmployee."No.");
        EmpJnlLine.SETRANGE(Type, 'ABSENCE');
        EmpJnlLine.SETRANGE(Processed, false);
        EmpJnlLine.SETRANGE(Reseted, false);
        EmpJnlLine.SETRANGE(Entitled, false);
        EmpJnlLine.SETRANGE(Converted, false);
        EmpJnlLine.SETRANGE("Document Status", EmpJnlLine."Document Status"::Approved);
        EmpJnlLine.SETFILTER("Transaction Date", '%1..%2', Paystatus."Supplement Start Date", Paystatus."Supplement End Date");
        EmpJnlLine2.COPY(EmpJnlLine);
        EmpJnlLine2.MODIFYALL("Payroll Ledger Entry No.", PayLedgEntryNo);
    end;

    procedure UpdateSplitEmpJnls();
    var
        EmpJnlLine: Record "Employee Journal Line";
        EmpJnlLine2: Record "Employee Journal Line";
    begin
        //shr2.0+
        EmpJnlLine.RESET;
        EmpJnlLine.SETCURRENTKEY("Employee No.", "Transaction Date");
        EmpJnlLine.SETRANGE("Employee No.", PayEmployee."No.");
        EmpJnlLine.SETFILTER("Transaction Date", '%1..%2', Paystatus."Supplement Start Date", Paystatus."Supplement End Date");
        EmpJnlLine.SETRANGE(Processed, false);
        EmpJnlLine.SETRANGE(Split, true);
        EmpJnlLine2.COPY(EmpJnlLine);
        EmpJnlLine2.MODIFYALL("Payroll Ledger Entry No.", PayLedgEntryNo);
    end;

    procedure SplitEntries(P_PayE: Record "Pay Element"; P_EmpNo: Code[20]): Boolean;
    var
        I: Integer;
    begin
        //NA,py2.0
        EmployeeJnl.RESET;
        TempSplitPayDetLine.RESET;
        TempSplitPayDetLine2.RESET;
        TempSplitPayDetLine.DELETEALL;
        TempSplitPayDetLine2.DELETEALL;

        case P_PayE.Code of
            PayParam."Basic Pay Code":
                begin
                    EmployeeJnl.SETCURRENTKEY("Employee No.", "Transaction Date", "Entry No.");
                    EmployeeJnl.SETRANGE("Employee No.", P_EmpNo);
                    Date1 := Paystatus."Supplement Start Date";
                    Date2 := Paystatus."Supplement End Date";
                    EmployeeJnl.SETFILTER("Transaction Date", '%1..%2', CALCDATE('+1D', Date1), Date2);
                    EmployeeJnl.SETRANGE(Split, true);
                    EmployeeJnl.SETRANGE(Processed, false); //py2.0
                    if not EmployeeJnl.FIND('-') then
                        exit(false)
                    else begin
                        //insert transactions into split temporary table
                        SplitLineNo := 0;
                        repeat
                            TempSplitPayDetLine.RESET;
                            TempSplitPayDetLine.SETFILTER("Transaction Date", '%1', EmployeeJnl."Transaction Date");
                            if TempSplitPayDetLine.FIND('-') then
                                FillSplitFields('M')
                            else
                                FillSplitFields('I');
                            if TempSplitPayDetLine."Old Transaction Type Value" = TempSplitPayDetLine."New Transaction Type Value" then begin
                                TempSplitPayDetLine.DELETE;
                                SplitLineNo := SplitLineNo - 1;
                            end;
                        until EmployeeJnl.NEXT = 0;

                        //copying records to another temporary table
                        TempSplitPayDetLine.RESET;
                        TempSplitPayDetLine2.RESET;
                        if TempSplitPayDetLine.FIND('-') then begin
                            repeat
                                TempSplitPayDetLine2.INIT;
                                TempSplitPayDetLine2.COPY(TempSplitPayDetLine);
                                TempSplitPayDetLine2.INSERT;
                            until TempSplitPayDetLine.NEXT = 0;
                        end;//end if

                        //fill of Split date fields
                        TempSplitPayDetLine.RESET;
                        FillSplitDates;

                        //delete of all transactions where the transaction date is less than the employment date
                        TempSplitPayDetLine.RESET;
                        TempSplitPayDetLine.SETCURRENTKEY("Transaction Date", Employed);
                        TempSplitPayDetLine.SETRANGE(Employed, true);
                        if TempSplitPayDetLine.FIND('+') then begin
                            SplitLineNo := TempSplitPayDetLine."Line No.";
                            TempSplitPayDetLine.RESET;
                            TempSplitPayDetLine.SETFILTER(TempSplitPayDetLine."Line No.", '< %1', SplitLineNo);
                            TempSplitPayDetLine.DELETEALL;
                        end; //end if

                        //renumbering and recopying of records
                        TempSplitPayDetLine2.RESET;
                        TempSplitPayDetLine2.DELETEALL;
                        TempSplitPayDetLine.RESET;
                        if TempSplitPayDetLine.FIND('-') then begin
                            SplitLineNo := 0;
                            repeat
                                TempSplitPayDetLine2.INIT;
                                TempSplitPayDetLine2.COPY(TempSplitPayDetLine);
                                SplitLineNo := SplitLineNo + 1;
                                TempSplitPayDetLine2."Line No." := SplitLineNo;
                                TempSplitPayDetLine2.INSERT;
                            until TempSplitPayDetLine.NEXT = 0;
                        end;//end if
                        TempSplitPayDetLine.RESET;
                        TempSplitPayDetLine.DELETEALL;
                        if TempSplitPayDetLine2.FIND('-') then
                            repeat
                                TempSplitPayDetLine.COPY(TempSplitPayDetLine2);
                                TempSplitPayDetLine.INSERT;
                            until TempSplitPayDetLine2.NEXT = 0;

                        //delete of all transactions where status is inactivated
                        TempSplitPayDetLine.RESET;
                        TempSplitPayDetLine.SETFILTER("Employee Status", 'Inactive');
                        if TempSplitPayDetLine.FIND('-') then begin
                            I := TempSplitPayDetLine."Line No.";
                            TempSplitPayDetLine.RESET;
                            TempSplitPayDetLine.SETFILTER("Line No.", '>%1', I);
                            if TempSplitPayDetLine.FIND('-') then
                                repeat
                                    if TempSplitPayDetLine."Employee Status" <> TempSplitPayDetLine."Employee Status"::Active then begin
                                        TempSplitPayDetLine.DELETE;
                                        //Activated := FALSE;
                                    end else
                                        if TempSplitPayDetLine."Employee Status" = TempSplitPayDetLine."Employee Status"::Active then begin
                                            //Activated := TRUE;
                                            I := TempSplitPayDetLine."Line No.";
                                            TempSplitPayDetLine.RESET;
                                            TempSplitPayDetLine.SETFILTER("Line No.", '>%1', I);
                                            TempSplitPayDetLine.SETFILTER("Employee Status", 'Inactive');
                                            if TempSplitPayDetLine.FIND('-') then begin
                                                I := TempSplitPayDetLine."Line No.";
                                                TempSplitPayDetLine.RESET;
                                                TempSplitPayDetLine.SETFILTER("Line No.", '>%1', I);
                                            end;
                                        end;
                                until (TempSplitPayDetLine.NEXT = 0);
                        end;

                        //delete of all transactions Terminated
                        TempSplitPayDetLine.RESET;
                        TempSplitPayDetLine.SETFILTER("Employee Status", 'Terminated');
                        if TempSplitPayDetLine.FIND('-') then begin
                            I := TempSplitPayDetLine."Line No.";
                            TempSplitPayDetLine.RESET;
                            TempSplitPayDetLine.SETFILTER("Line No.", '>%1', I);
                            TempSplitPayDetLine.DELETEALL;
                        end;//end if

                        //py2.0+
                        TempSplitPayDetLine.RESET;
                        //last rec must have its split end date = end payroll date
                        if TempSplitPayDetLine.FIND('+') then begin
                            TempSplitPayDetLine."Ending Split Date" := Date2;
                            TempSplitPayDetLine.MODIFY;
                        end;
                        //py2.0-

                        //calculated amounts
                        TempSplitPayDetLine.RESET;
                        if TempSplitPayDetLine.FIND('-') then begin
                            Date1 := Paystatus."Supplement Start Date";
                            Date2 := Paystatus."Supplement End Date";
                            NbOfDays := Date2 - Date1 + 1;
                            NbOfNonWD := HRFunctions.GetNonWD(EmploymentType."Base Calendar Code", Date1, Date2);
                            repeat
                                CalcSplitEntries();
                            until TempSplitPayDetLine.NEXT = 0;
                        end;

                        //copying records to the details split table
                        SplitPayDetLine.RESET;
                        TempSplitPayDetLine.RESET;
                        if TempSplitPayDetLine.FIND('-') then begin
                            SplitLineNo := 0;
                            repeat
                                SplitPayDetLine.INIT;
                                SplitPayDetLine.COPY(TempSplitPayDetLine);
                                SplitLineNo := SplitLineNo + 1;
                                SplitPayDetLine."Line No." := SplitLineNo;
                                SplitPayDetLine.INSERT;
                            until TempSplitPayDetLine.NEXT = 0;
                        end;//end if
                        exit(true);
                    end;
                end; //Basic Pay Element Code
        end; //case payE code
    end;

    procedure CalcSplitEntries();
    begin
        //NA,py2.0
        //calculate of amounts
        AmntPerDayLCY := TempSplitPayDetLine.Amount / (NbOfDays - NbOfNonWD);
        AmntPerDayACY := TempSplitPayDetLine."Amount (ACY)" / (NbOfDays - NbOfNonWD);

        CLEAR(PayDetailHeader2);
        PayDetailHeader2.RESET;
        if PayDetailHeader2.GET(PayEmployee."No.") then begin
            PayDetailHeader2.SETFILTER("Date Filter", '%1..%2', TempSplitPayDetLine."Starting Split Date",
                                     TempSplitPayDetLine."Ending Split Date");
            PayDetailHeader2.CALCFIELDS(PayDetailHeader2."Working Days Affected");
            TempSplitPayDetLine."Efective Nb. of Days" := TempSplitPayDetLine."Efective Nb. of Days" -
                                                        PayDetailHeader2."Working Days Affected";

            if (TempSplitPayDetLine."Employee Status" = TempSplitPayDetLine."Employee Status"::Inactive) or
               (TempSplitPayDetLine."Employee Status" = TempSplitPayDetLine."Employee Status"::Terminated) or
               //py2.0+
               ((TempSplitPayDetLine."Line No." = 1) and (TempSplitPayDetLine."Old Transaction Type Value" = 'Inactive') and
                                                         (TempSplitPayDetLine."New Transaction Type Value" = 'Active')) then begin
                //py2.0-
                TempSplitPayDetLine."Calculated Amount" := 0;
                TempSplitPayDetLine."Calculated Amount (ACY)" := 0;
                TempSplitPayDetLine."Efective Nb. of Days" := 0;
            end else begin
                TempSplitPayDetLine."Calculated Amount" := TempSplitPayDetLine."Efective Nb. of Days" * AmntPerDayLCY;
                TempSplitPayDetLine."Calculated Amount (ACY)" := TempSplitPayDetLine."Efective Nb. of Days" * AmntPerDayACY;
                //py2.0+ //rounding amts
                TempSplitPayDetLine."Calculated Amount" := PayrollFunctions.RoundingAmt(TempSplitPayDetLine."Calculated Amount", false);
                TempSplitPayDetLine."Calculated Amount (ACY)" :=
                                        PayrollFunctions.RoundingAmt(TempSplitPayDetLine."Calculated Amount (ACY)", true);
                //py2.0-
                SplitTotCalAmtLCY := SplitTotCalAmtLCY + TempSplitPayDetLine."Calculated Amount";
                SplitTotCalAmtACY := SplitTotCalAmtACY + TempSplitPayDetLine."Calculated Amount (ACY)";
                SplitTotEffDays := SplitTotEffDays + TempSplitPayDetLine."Efective Nb. of Days";
            end;
            TempSplitPayDetLine.MODIFY;
        end;
    end;

    procedure FillSplitFields(P_Par: Text[1]);
    begin
        //NA
        //TempSplitPayDetLine.RESET;
        //TempSplitPayDetLine2.RESET;

        if P_Par = 'I' then begin
            TempSplitPayDetLine.INIT;
            TempSplitPayDetLine."Pay Detail Line No." := PayDetailLine."Line No.";
            TempSplitPayDetLine."Employee No." := EmployeeJnl."Employee No.";
            TempSplitPayDetLine."Transaction Date" := EmployeeJnl."Transaction Date";
            TempSplitPayDetLine."Transaction Type" := EmployeeJnl.Type;
            SplitLineNo := SplitLineNo + 1;
            TempSplitPayDetLine."Line No." := SplitLineNo;
            TempSplitPayDetLine."Shortcut Dimension 1 Code" := EmployeeJnl."Shortcut Dimension 1 Code";
            TempSplitPayDetLine."Shortcut Dimension 2 Code" := EmployeeJnl."Shortcut Dimension 2 Code";
            TempSplitPayDetLine."Job Title" := EmployeeJnl."Job Title Code";
            TempSplitPayDetLine.Amount := EmployeeJnl."Basic Pay";
            TempSplitPayDetLine."Amount (ACY)" := EmployeeJnl."Additional Salary";
            TempSplitPayDetLine."Employee Status" := EmployeeJnl."Employee Status";
            TempSplitPayDetLine."Employment Date" := EmployeeJnl."Employment Date";

            case EmployeeJnl.Type of
                'CHANGE STATUS':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Employee Status");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Employee Status");
                        if (EmployeeJnl."Employee Status" = EmployeeJnl."Employee Status"::Active) and
                       (EmployeeJnl."Old Employee Status" = EmployeeJnl."Old Employee Status"::Inactive) then
                            TempSplitPayDetLine.ReActivated := true
                        else
                            if EmployeeJnl."Employee Status" = EmployeeJnl."Employee Status"::Inactive then
                                TempSplitPayDetLine.Inactivated := true
                            else
                                if EmployeeJnl."Employee Status" = EmployeeJnl."Employee Status"::Terminated then
                                    TempSplitPayDetLine.Terminated := true;
                    end;// change status

                'CHANGE JOB TITLE':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Job Title Code");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Job Title Code");
                    end;// change job title

                'CHANGE GLOBAL DIM1':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Shortcut Dimension 1 Code");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Shortcut Dimension 1 Code");
                    end;//change global dim1

                'CHANGE GLOBAL DIM2':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Shortcut Dimension 2 Code");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Shortcut Dimension 2 Code");
                    end;//change global dim2

                'CHANGE EMPLOYMENT DATE':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Employment Date");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Employment Date");
                        TempSplitPayDetLine.Employed := true;
                    end;//change employment date

                'CHANGE DECLARED':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Declared");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl.Declared);
                        if EmployeeJnl.Declared = EmployeeJnl.Declared::Declared then
                            TempSplitPayDetLine.Declared := true;
                    end;//change declared

                'CHANGE BASIC PAY':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Basic Pay");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Basic Pay");
                    end;//change basic pay

                'CHANGE ADDITIONAL SALARY':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Additional Salary");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Additional Salary");
                    end;//change additional salary
            end;  //END CASe
                  //divide first record in 2 records
            if SplitLineNo = 1 then begin
                TempSplitPayDetLine2.INIT;
                TempSplitPayDetLine2.COPY(TempSplitPayDetLine);
                TempSplitPayDetLine."Transaction Date" := Paystatus."Supplement Start Date";
                TempSplitPayDetLine.ReActivated := false;
                TempSplitPayDetLine.Inactivated := false;
                TempSplitPayDetLine.Employed := false;
                TempSplitPayDetLine.Terminated := false;
                TempSplitPayDetLine.INSERT;
                TempSplitPayDetLine.INIT;
                TempSplitPayDetLine.COPY(TempSplitPayDetLine2);
                SplitLineNo := SplitLineNo + 1;
                TempSplitPayDetLine."Line No." := SplitLineNo;
                TempSplitPayDetLine.INSERT;
            end else
                TempSplitPayDetLine.INSERT;
        end else begin //Modify
            TempSplitPayDetLine."Transaction Type" := EmployeeJnl.Type;
            TempSplitPayDetLine."Shortcut Dimension 1 Code" := EmployeeJnl."Shortcut Dimension 1 Code";
            TempSplitPayDetLine."Shortcut Dimension 2 Code" := EmployeeJnl."Shortcut Dimension 2 Code";
            TempSplitPayDetLine."Job Title" := EmployeeJnl."Job Title Code";
            TempSplitPayDetLine.Amount := EmployeeJnl."Basic Pay";
            TempSplitPayDetLine."Amount (ACY)" := EmployeeJnl."Additional Salary";
            TempSplitPayDetLine."Employee Status" := EmployeeJnl."Employee Status";
            TempSplitPayDetLine."Employment Date" := EmployeeJnl."Employment Date";

            case EmployeeJnl.Type of
                'CHANGE STATUS':
                    begin
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Employee Status");
                        if (EmployeeJnl."Employee Status" = EmployeeJnl."Employee Status"::Active) and
                       (EmployeeJnl."Old Employee Status" = EmployeeJnl."Employee Status"::Inactive) then
                            TempSplitPayDetLine.ReActivated := true
                        else
                            if EmployeeJnl."Employee Status" = EmployeeJnl."Employee Status"::Inactive then
                                TempSplitPayDetLine.Inactivated := true
                            else
                                if EmployeeJnl."Employee Status" = EmployeeJnl."Employee Status"::Terminated then
                                    TempSplitPayDetLine.Terminated := true;
                    end;// change status

                'CHANGE JOB TITLE':
                    begin
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Job Title Code");
                    end;// change job title

                'CHANGE GLOBAL DIM1':
                    begin
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Shortcut Dimension 1 Code");
                    end;//change global dim1

                'CHANGE GLOBAL DIM2':
                    begin
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Shortcut Dimension 2 Code");
                    end;//change global dim2

                'CHANGE EMPLOYMENT DATE':
                    begin
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Employment Date");
                        TempSplitPayDetLine.Employed := true;
                    end;//change emplyment date

                'CHANGE DECLARED':
                    begin
                        TempSplitPayDetLine."Old Transaction Type Value" := FORMAT(EmployeeJnl."Old Declared");
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl.Declared);
                        if EmployeeJnl.Declared = EmployeeJnl.Declared::Declared then
                            TempSplitPayDetLine.Declared := true;
                    end;//change declared

                'CHANGE BASIC PAY':
                    begin
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Basic Pay");
                    end;//change basic pay

                'CHANGE ADDITIONAL SALARY':
                    begin
                        TempSplitPayDetLine."New Transaction Type Value" := FORMAT(EmployeeJnl."Additional Salary");
                    end;//change additional salary
            end;  //END CASE
            TempSplitPayDetLine.MODIFY;
        end;//end if
    end;

    procedure FillSplitDates();
    begin
        //NA
        if TempSplitPayDetLine.FIND('-') then
            repeat
                if TempSplitPayDetLine."Line No." = 1 then
                    TempSplitPayDetLine."Starting Split Date" := Paystatus."Supplement Start Date"
                else
                    TempSplitPayDetLine."Starting Split Date" := TempSplitPayDetLine."Transaction Date";

                TempSplitPayDetLine2.RESET;
                TempSplitPayDetLine2.SETFILTER(TempSplitPayDetLine2."Line No.", '%1', TempSplitPayDetLine."Line No." + 1);
                if TempSplitPayDetLine2.FIND('-') then
                    TempSplitPayDetLine."Ending Split Date" := CALCDATE('-1D', TempSplitPayDetLine2."Transaction Date")
                else
                    TempSplitPayDetLine."Ending Split Date" := Paystatus."Period End Date";

                NbOfNonWD := HRFunctions.GetNonWD(EmploymentType."Base Calendar Code", TempSplitPayDetLine."Starting Split Date",
                             TempSplitPayDetLine."Ending Split Date");
                NbOfDays := (TempSplitPayDetLine."Ending Split Date" - TempSplitPayDetLine."Starting Split Date") + 1;
                TempSplitPayDetLine."Efective Nb. of Days" := NbOfDays - NbOfNonWD;
                TempSplitPayDetLine.MODIFY;
            until TempSplitPayDetLine.NEXT = 0;
    end;

    procedure InsertEmployeeBenefitPenalties();
    var
        LineNo: Integer;
        PayElementCode: Code[10];
        V_Amount: Decimal;
        EmployeeLoan: Record "Employee Loan";
        TempPayment: Decimal;
        RemainingPayment: Decimal;
        V_OvertimeHours: Decimal;
        DaysinMonth: Integer;
        HoursinDay: Decimal;
        IsOTUnpaidHours: Boolean;
        V_DaysDeducted: Decimal;
        L_EmployeeJournal: Record "Employee Journal Line";
    begin
        PayDetailLine.RESET;
        PayDetailLine.SETRANGE("Pay Element Code", PayParam."Month 13");
        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
        if PayDetailLine.FINDFIRST then
            repeat
                PayDetailLine.DELETE(true);
            until PayDetailLine.NEXT = 0;
        PayDetailLine.RESET;

        HRSetup.GET;

        // 1.HR Transaction Type with Associated PYE
        HRTransactionType.RESET;
        HRTransactionType.SETFILTER("Associated Pay Element", '<>%1', '');
        HRTransactionType.SETFILTER(Type, '=%1|=%2|=%3', 'BENEFIT', 'DEDUCTIONS');
        if HRTransactionType.FIND('-') then
            repeat
                PayDetailLine.INIT;
                V_Amount := 0;
                PayElementCode := HRTransactionType."Associated Pay Element";
                PayElement.GET(PayElementCode);
                L_EmployeeJournal.SETCURRENTKEY("Employee No.", "Document Status", "Transaction Type", Processed,
                                                      "Transaction Date");
                //Employee No.,Document Status,Transaction Type,Processed,Transaction Date
                L_EmployeeJournal.SETRANGE("Employee No.", PayDetailHeader."Employee No.");
                L_EmployeeJournal.SETRANGE("Document Status", L_EmployeeJournal."Document Status"::Approved);
                L_EmployeeJournal.SETRANGE("Transaction Type", HRTransactionType.Code);
                L_EmployeeJournal.SETRANGE(Processed, false);
                L_EmployeeJournal.SETRANGE("Transaction Date", Paystatus."Period Start Date", Paystatus."Period End Date");
                L_EmployeeJournal.SETRANGE("Month 13", true);
                //L_EmployeeJournal.CALCSUMS(Value);
                if L_EmployeeJournal.FIND('-') then
                    repeat
                        V_Amount := V_Amount + L_EmployeeJournal.Value
                    until L_EmployeeJournal.NEXT = 0;

                if V_Amount > 0 then begin
                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, false);
                    PayDetailLine.Amount := V_Amount;
                    PayDetailLine."Calculated Amount" := V_Amount;
                end;

                InsertPayDetailLine(PayElementCode, '');
            until HRTransactionType.NEXT = 0;
    end;

    procedure CalculateTaxableSalary(): Decimal;
    var
        vPaydetail: Record "Pay Detail Line";
        vPayElement: Record "Pay Element";
    begin
        //Added By Ibrahim
        vPaydetail.RESET;
        vPaydetail.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
        vPaydetail.SETRANGE("Employee No.", PayEmployee."No.");
        vPaydetail.SETRANGE(Open, true);

        V_TaxableSalary := 0;

        if vPaydetail.FIND('-') then
            repeat
                if vPayElement.GET(vPaydetail."Pay Element Code") then begin
                    if vPayElement.Tax = true then begin
                        if vPayElement.Type = vPayElement.Type::Addition then
                            V_TaxableSalary := V_TaxableSalary + vPaydetail."Calculated Amount"
                        else
                            V_TaxableSalary := V_TaxableSalary - vPaydetail."Calculated Amount";
                    end;
                end;
            until vPaydetail.NEXT = 0;

        exit(V_TaxableSalary)
    end;

    procedure CalcPensionRetroactive(pToDate: Date; pEmployeeNo: Code[20]; var pPayrollLedgerEntry: Record "Payroll Ledger Entry");
    var
        PayElementCode: Code[10];
        PensionScheme: Record "Pension Scheme";
        V_TaxableSalary: Decimal;
        EmployeeAmount: Decimal;
        EmployerAmount: Decimal;
        PayElement: Record "Pay Element";
        VEmployeePension: Decimal;
        V_EmployeePensionGiven: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        PeriodNo: Integer;
        pFromDate: Date;
        MaxMonthlyContrbMHOOD: Decimal;
        EmployerContributionMHOOD: Decimal;
        EmployeeContributionMHOOD: Decimal;
        MHOODPayElementCode: Code[20];
        PayParam: Record "Payroll Parameter";
        V_TotalTaxPayable: Decimal;
        EmployeePensionMaximum: Decimal;
        PayDetailLineRec: Record "Pay Detail Line";
        V_EmployerMHOODMaximum: Decimal;
        V_EmployerPensionMaximum: Decimal;
        PayElementRec: Record "Pay Element";
        VEmployerPension: Decimal;
        MaxMonthlyContrbFMSUB: Decimal;
        EmployerContributionFMSUB: Decimal;
        FMSUBPayElementCode: Code[10];
        V_EmployerPensionMaximumMHOOD: Decimal;
        V_EmployerPensionMaximumFMSUB: Decimal;
        PayDetailsLineRecord: Record "Pay Detail Line";
        VMHOODGiven: Decimal;
        VMHOODGivenEmployee: Decimal;
        VFAMSUBGiven: Decimal;
        VEmployerPensionMHOOD: Decimal;
        VEmployerPensionFAMSUB: Decimal;
        MaxMonthContrbMHOOD: Decimal;
        MaxMonthContrbFMSUB: Decimal;
        MaxEmpPensionRange: Decimal;
        UseRetro: Boolean;
        EmpRec: Record "Employee";
        PayDetailRec: Record "Pay Detail Line";
        MHOODEmployeePaid: Decimal;
        MHOODEmployerPaid: Decimal;
        FAMSUBPaid: Decimal;
        V_EmployerPensionGiven: Decimal;
        NumberofMonths: Decimal;
    begin
        PayParam.GET();
        UseRetro := false;
        if not PayParam."No Pension Retro" then
            UseRetro := true;
        if UseRetro = false then
            exit;

        EmpRec.SETRANGE("No.", pEmployeeNo);
        if not EmpRec.FINDFIRST then
            exit;
        //Number of Months
        EmpRec.Get(pEmployeeNo);
        if EmpRec."Termination Date" = 0D then begin
            if EmpRec."Employment Date" <= DMY2Date(01, 01, Date2DMY(pToDate, 3)) then
                NumberofMonths := 12;
            if EmpRec."Employment Date" >= pToDate then
                NumberofMonths := 0;
            if (DMY2Date(01, 01, Date2DMY(pToDate, 3)) < EmpRec."Employment Date") and (EmpRec."Employment Date" < pToDate) then
                NumberofMonths := (12 - Date2DMY(EmpRec."Employment Date", 2) + 1);
        end;
        //
        PayrollLedgerEntry.SETCURRENTKEY("Employee No.", "Tax Year", "Period End Date", Open);
        PayrollLedgerEntry.SETFILTER("Period End Date", '..%1', pToDate);
        PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
        PayrollLedgerEntry.SETRANGE(Open, true);
        if PayrollLedgerEntry.FINDFIRST then
            if PayrollLedgerEntry."Taxable Pay" = 0 then
                exit;

        VEmployerPension := 0;
        VEmployeePension := 0;
        V_TaxableSalary := 0;
        VMHOODGiven := 0;
        VFAMSUBGiven := 0;
        MaxMonthlyContrbFMSUB := 0;
        V_EmployerMHOODMaximum := 0;
        V_EmployerPensionGiven := 0;
        V_EmployerPensionMaximum := 0;
        EmployerContributionFMSUB := 0;
        V_EmployerPensionMaximumMHOOD := 0;
        V_EmployerPensionMaximumFMSUB := 0;
        VEmployerPension := 0;
        MHOODEmployeePaid := 0;
        MHOODEmployerPaid := 0;
        FAMSUBPaid := 0;

        PayParam.GET;
        PayrollLedgerEntry.RESET;
        PayrollLedgerEntry.SETCURRENTKEY("Employee No.", "Tax Year", "Period End Date", Open);
        PayrollLedgerEntry.SETFILTER("Period End Date", '..%1', pToDate);
        PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
        PayrollLedgerEntry.CALCSUMS("Employee Pension", "Employer Pension", "Taxable Pay", "Total Salary for NSSF");
        V_EmployeePensionGiven := PayrollLedgerEntry."Employee Pension";
        V_TotalTaxPayable := PayrollLedgerEntry."Total Salary for NSSF";
        V_EmployerPensionGiven := PayrollLedgerEntry."Employer Pension";
        if PayrollLedgerEntry.FIND('-') then
            repeat
                if PeriodNo = 0 then begin
                    pFromDate := PayrollLedgerEntry."Period Start Date";
                    PeriodNo := DATE2DMY(pToDate, 2) - DATE2DMY(pFromDate, 2);
                end;
                V_TaxableSalary := PayrollLedgerEntry."Taxable Pay";

                if PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement then begin
                    PensionScheme.RESET;
                    PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
                    PensionScheme.SETRANGE("Manual Pension", false);
                    if PensionScheme.FIND('-') then
                        repeat
                            case PensionScheme.Type of
                                PensionScheme.Type::MHOOD:
                                    begin
                                        IF (Format(PensionScheme."Before Monthly Cont Date") <> '') AND (PayrollLedgerEntry."Payroll Date" < PensionScheme."Before Monthly Cont Date") Then begin
                                            MaxMonthlyContrbMHOOD := MaxMonthlyContrbMHOOD + PensionScheme."Before Max Monthly Cont";
                                            MaxMonthContrbMHOOD := PensionScheme."Before Max Monthly Cont";
                                        END
                                        ELSE begin
                                            //20220611--
                                            MaxMonthlyContrbMHOOD := MaxMonthlyContrbMHOOD + PensionScheme."Maximum Monthly Contribution";
                                            MaxMonthContrbMHOOD := PensionScheme."Maximum Monthly Contribution";
                                        END;
                                        MHOODPayElementCode := PensionScheme."Associated Pay Element";
                                        EmployeeContributionMHOOD := PensionScheme."Employee Contribution %";
                                        EmployerContributionMHOOD := PensionScheme."Employer Contribution %";
                                    end;

                                PensionScheme.Type::FAMSUB:
                                    begin
                                        IF (Format(PensionScheme."Before Monthly Cont Date") <> '') AND (PayrollLedgerEntry."Payroll Date" < PensionScheme."Before Monthly Cont Date") Then begin
                                            MaxMonthlyContrbFMSUB := MaxMonthlyContrbFMSUB + PensionScheme."Before Max Monthly Cont";
                                            MaxMonthContrbFMSUB := PensionScheme."Before Max Monthly Cont";
                                        END
                                        ELSE begin
                                            MaxMonthlyContrbFMSUB := MaxMonthlyContrbFMSUB + PensionScheme."Maximum Monthly Contribution";
                                            MaxMonthContrbFMSUB := PensionScheme."Maximum Monthly Contribution";
                                        end;
                                        EmployerContributionFMSUB := PensionScheme."Employer Contribution %";
                                        FMSUBPayElementCode := PensionScheme."Associated Pay Element";
                                    end;
                            end;
                        until PensionScheme.NEXT = 0;
                end;
            until PayrollLedgerEntry.NEXT = 0;

        //NSSF 3%
        if V_TotalTaxPayable > MaxMonthlyContrbMHOOD then begin
            EmployeePensionMaximum := MaxMonthlyContrbMHOOD * (EmployeeContributionMHOOD / 100);
            VEmployeePension := EmployeePensionMaximum - V_EmployeePensionGiven;
        end
        else begin
            EmployeePensionMaximum := V_TotalTaxPayable * (EmployeeContributionMHOOD / 100);
            VEmployeePension := EmployeePensionMaximum - V_EmployeePensionGiven;
        end;

        MaxEmpPensionRange := (MaxMonthContrbMHOOD * EmployeeContributionMHOOD / 100) * NumberofMonths;
        if V_EmployeePensionGiven > MaxEmpPensionRange then
            VEmployeePension := -V_EmployeePension;

        PayElementRec.SETRANGE(Code, MHOODPayElementCode);
        if PayElementRec.FINDFIRST then
            SumUpAllowDeduct(PayElementRec, VEmployeePension, 0, 0, '');
        V_EmployeePension := V_EmployeePension + VEmployeePension;

        //8% and FamSub
        PayDetailsLineRecord.RESET;
        PayDetailsLineRecord.SETFILTER("Payroll Date", '..%1', pToDate);
        PayDetailsLineRecord.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayDetailsLineRecord.SETRANGE("Employee No.", pEmployeeNo);
        if PayDetailsLineRecord.FINDFIRST then
            repeat
                if PayDetailsLineRecord."Pay Element Code" = MHOODPayElementCode then
                    VMHOODGiven := VMHOODGiven + PayDetailsLineRecord."Employer Amount";

                if PayDetailsLineRecord."Pay Element Code" = FMSUBPayElementCode then
                    VFAMSUBGiven := VFAMSUBGiven + PayDetailsLineRecord."Employer Amount";
            until PayDetailsLineRecord.NEXT = 0;
        //
        //Paid MHOOD
        PayDetailRec.RESET;
        PayDetailRec.CALCFIELDS("Payment Category");
        PayDetailRec.SETRANGE("Payment Category", PayDetailRec."Payment Category"::" ");
        PayDetailRec.SETFILTER("Payroll Date", '..%1', pToDate);
        PayDetailRec.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayDetailRec.SETRANGE("Employee No.", pEmployeeNo);
        PayDetailRec.SETRANGE("Pay Element Code", MHOODPayElementCode);
        if PayDetailRec.FINDFIRST then
            repeat
                MHOODEmployeePaid := MHOODEmployeePaid + PayDetailRec."Calculated Amount";
                MHOODEmployerPaid := MHOODEmployerPaid + PayDetailRec."Employer Amount";
            until PayDetailRec.NEXT = 0;
        //Paid FSUB
        PayDetailRec.RESET;
        PayDetailRec.CALCFIELDS("Payment Category");
        PayDetailRec.SETRANGE("Payment Category", PayDetailRec."Payment Category"::" ");
        PayDetailRec.SETFILTER("Payroll Date", '..%1', pToDate);
        PayDetailRec.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayDetailRec.SETRANGE("Employee No.", pEmployeeNo);
        PayDetailRec.SETRANGE("Pay Element Code", FMSUBPayElementCode);
        if PayDetailRec.FINDFIRST then
            repeat
                FAMSUBPaid := FAMSUBPaid + PayDetailRec."Employer Amount";
            until PayDetailRec.NEXT = 0;
        //NSSF 8%
        if V_TotalTaxPayable > MaxMonthlyContrbMHOOD then begin
            V_EmployerPensionMaximumMHOOD := MaxMonthlyContrbMHOOD * (EmployerContributionMHOOD / 100);
            VEmployerPensionMHOOD := V_EmployerPensionMaximumMHOOD - VMHOODGiven;
        end
        else begin
            V_EmployerPensionMaximumMHOOD := V_TotalTaxPayable * (EmployerContributionMHOOD / 100);
            VEmployerPensionMHOOD := V_EmployerPensionMaximumMHOOD - VMHOODGiven;
        end;

        //Family Subscription
        if V_TotalTaxPayable > MaxMonthlyContrbFMSUB then begin
            V_EmployerPensionMaximumFMSUB := MaxMonthlyContrbFMSUB * (EmployerContributionFMSUB / 100);
            VEmployerPensionFAMSUB := V_EmployerPensionMaximumFMSUB - VFAMSUBGiven;
        end
        else begin
            V_EmployerPensionMaximumFMSUB := V_TotalTaxPayable * (EmployerContributionFMSUB / 100);
            VEmployerPensionFAMSUB := V_EmployerPensionMaximumFMSUB - VFAMSUBGiven;
        end;

        VEmployerPension := VEmployerPensionMHOOD + VEmployerPensionFAMSUB;
        pPayrollLedgerEntry."Employer Pension" := pPayrollLedgerEntry."Employer Pension" + VEmployerPension;
        pPayrollLedgerEntry."Employee Pension" := pPayrollLedgerEntry."Employee Pension" + VEmployeePension;
        pPayrollLedgerEntry.MODIFY;

        PayDetailLineRec.SETRANGE(Open, true);
        PayDetailLineRec.SETRANGE("Pay Element Code", MHOODPayElementCode);
        PayDetailLineRec.SETRANGE("Employee No.", pPayrollLedgerEntry."Employee No.");
        if PayDetailLineRec.FINDFIRST then begin
            //MHOOD Employee
            if V_EmployeePensionGiven > (MaxMonthContrbMHOOD * EmployeeContributionMHOOD / 100) * NumberofMonths then begin
                IF (V_EmployeePensionGiven > MHOODEmployeePaid) and (MHOODEmployeePaid < (MaxMonthContrbMHOOD * EmployeeContributionMHOOD / 100) * NumberofMonths) THEN begin
                    PayDetailLineRec.Amount := ((MaxMonthContrbMHOOD * EmployeeContributionMHOOD / 100) * NumberofMonths) - MHOODEmployeePaid;
                    PayDetailLineRec."Calculated Amount" := ((MaxMonthContrbMHOOD * EmployeeContributionMHOOD / 100) * NumberofMonths) - MHOODEmployeePaid;
                    VEmployeePension := ((MaxMonthContrbMHOOD * EmployeeContributionMHOOD / 100) * NumberofMonths) - MHOODEmployeePaid;
                END
                ELSE begin
                    PayDetailLineRec.Amount := 0;
                    PayDetailLineRec."Calculated Amount" := 0;
                    VEmployeePension := 0;
                END;
                PayDetailLineRec.MODIFY;
            end
            else begin
                //PayDetailLineRec.Amount := pPayrollLedgerEntry."Employee Pension" - VEmployeePension;
                PayDetailLineRec.Amount := pPayrollLedgerEntry."Employee Pension";
                PayDetailLineRec."Calculated Amount" := pPayrollLedgerEntry."Employee Pension";
            end;
            //MHOOD Employer
            if VMHOODGiven > (MaxMonthContrbMHOOD * EmployerContributionMHOOD / 100) * NumberofMonths then begin
                IF (VMHOODGiven > MHOODEmployerPaid) and (MHOODEmployerPaid < (MaxMonthContrbMHOOD * EmployerContributionMHOOD / 100) * NumberofMonths) then begin
                    PayDetailLineRec."Employer Amount" := ((MaxMonthContrbMHOOD * EmployerContributionMHOOD / 100) * NumberofMonths) - MHOODEmployerPaid;
                    VEmployerPensionMHOOD := ((MaxMonthContrbMHOOD * EmployerContributionMHOOD / 100) * NumberofMonths) - MHOODEmployerPaid;
                end
                ELSE BEGIN
                    PayDetailLineRec."Employer Amount" := 0;
                    VEmployerPensionMHOOD := 0;
                END;
                PayDetailLineRec.MODIFY;
            end
            else begin
                PayDetailLineRec."Employer Amount" := PayDetailLineRec."Employer Amount" + VEmployerPensionMHOOD;
                PayDetailLineRec.MODIFY;
            end;
        end;

        PayDetailLineRec.SETRANGE(Open, true);
        PayDetailLineRec.SETRANGE("Pay Element Code", FMSUBPayElementCode);
        PayDetailLineRec.SETRANGE("Employee No.", pPayrollLedgerEntry."Employee No.");
        if PayDetailLineRec.FINDFIRST then begin
            if VFAMSUBGiven > (MaxMonthContrbFMSUB * EmployerContributionFMSUB / 100) * NumberofMonths then begin
                if (VFAMSUBGiven > FAMSUBPaid) and (FAMSUBPaid < (MaxMonthContrbFMSUB * EmployerContributionFMSUB / 100) * NumberofMonths) then begin
                    PayDetailLineRec."Employer Amount" := ((MaxMonthContrbFMSUB * EmployerContributionFMSUB / 100) * NumberofMonths) - FAMSUBPaid;
                    VEmployerPensionFAMSUB := ((MaxMonthContrbFMSUB * EmployerContributionFMSUB / 100) * NumberofMonths) - FAMSUBPaid;
                end
                ELSE begin
                    PayDetailLineRec."Employer Amount" := 0;
                    VEmployerPensionFAMSUB := 0;
                end;
                PayDetailLineRec.MODIFY;
            end
            else begin
                PayDetailLineRec."Employer Amount" := PayDetailLineRec."Employer Amount" + VEmployerPensionFAMSUB;
                PayDetailLineRec.MODIFY;
            end;
        end;
    end;

    procedure CalculateSalaryNSSF(): Decimal;
    var
        PayDetail: Record "Pay Detail Line";
        PayElement: Record "Pay Element";
    begin
        //Added to get the Amount that will be used in NSSF Contributions (Medical,family,EOS) - 09.02.2016 : AIM + -
        PayParam.GET;
        PayDetail.RESET;
        PayDetail.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
        PayDetail.SETRANGE("Employee No.", PayEmployee."No.");
        PayDetail.SETRANGE(Open, TRUE);

        V_NSSFSalary := 0;
        NSSFSalaryFIXED := 0;
        NSSFSalaryVARIABLE := 0;

        IF PayDetail.FINDFIRST THEN
            REPEAT
                IF PayElement.GET(PayDetail."Pay Element Code") THEN BEGIN
                    //IF (PayElement."Affect NSSF") OR (PayElement.Code = PayParam."Basic Pay Code") THEN
                    IF PayElement."Affect NSSF" THEN BEGIN
                        IF PayElement.Type = PayElement.Type::Addition THEN
                            CASE PayElement."Type Classification" OF
                                PayElement."Type Classification"::" ":
                                    V_NSSFSalary += PayDetail."Calculated Amount";
                                PayElement."Type Classification"::FIXED:
                                    NSSFSalaryFIXED += PayDetail."Calculated Amount";
                                PayElement."Type Classification"::VARIABLE:
                                    NSSFSalaryVARIABLE += PayDetail."Calculated Amount";
                            END
                        ELSE
                            CASE PayElement."Type Classification" OF
                                PayElement."Type Classification"::" ":
                                    V_NSSFSalary -= PayDetail."Calculated Amount";
                                PayElement."Type Classification"::FIXED:
                                    NSSFSalaryFIXED -= PayDetail."Calculated Amount";
                                PayElement."Type Classification"::VARIABLE:
                                    NSSFSalaryVARIABLE -= PayDetail."Calculated Amount";
                            END
                    END;
                END;
            UNTIL PayDetail.NEXT = 0;

        EXIT(V_NSSFSalary);
    end;

    local procedure CalculateTaxRetro(pToDate: Date; pEmployeeNo: Code[20]; var pPayrollLedgerEntry: Record "Payroll Ledger Entry"; PeriodNb: Integer);
    var
        TaxPeriod: Integer;
        Computed: Boolean;
        Remainder: Decimal;
        LastBand: Boolean;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        VCalcPayeTax: Decimal;
        VPayeTax: Decimal;
        VTotalTaxable: Decimal;
        VTaxGiven: Decimal;
        VTotalTax: Decimal;
        VExemptTax: Decimal;
        VCalcExemptTax: Decimal;
        VNetTaxSalary: Decimal;
        VCalcNetTaxSalary: Integer;
        PayDetailLineRec: Record "Pay Detail Line";
        PayParm: Record "Payroll Parameter";
        VTotalTaxGiven: Decimal;
        DateFilter: Date;
        PayElementRec: Record "Pay Element";
        PeriodNumber: Integer;
        InsertNegativeTax: Boolean;
        TxVal: Decimal;
        V: Decimal;
    begin
        PayParm.GET;
        if PayParm."No Income Tax Retro" then
            exit;

        PayElementRec.SETRANGE("Affect Exempt Tax", true);
        repeat
            PayDetailLineRec.SETRANGE("Pay Element Code", PayElementRec.Code);
            PayDetailLineRec.SETRANGE("Employee No.", pEmployeeNo);
            PayDetailLineRec.SETRANGE(Open, true);
            if PayDetailLineRec.FINDFIRST then begin
                pPayrollLedgerEntry."Exempt Tax" := pPayrollLedgerEntry."Exempt Tax" + PayDetailLineRec."Exempt Tax Retro";
                pPayrollLedgerEntry."Free Pay" := pPayrollLedgerEntry."Free Pay" + PayDetailLineRec."Exempt Tax Retro" / 12;
                pPayrollLedgerEntry.MODIFY;
            end;
        until PayElementRec.NEXT = 0;

        TaxPeriod := 12;
        VCalcPayeTax := 0;
        VPayeTax := 0;
        VTotalTaxable := 0;
        VTaxGiven := 0;
        VTotalTaxGiven := 0;
        VTotalTax := 0;
        VExemptTax := 0;
        PeriodNumber := 0;
        PayrollLedgerEntry.RESET;
        PayrollLedgerEntry.SETFILTER("Period End Date", '..%1', pToDate);
        PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
        if PayrollLedgerEntry.FINDFIRST then
            repeat
                VTotalTax := VTotalTax + PayrollLedgerEntry."Taxable Pay";
                if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then BEGIN
                    IF PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement THEN Begin
                        VExemptTax := VExemptTax + PayrollLedgerEntry."Free Pay";
                        PeriodNumber := PeriodNumber + (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", PayrollLedgerEntry."Tax Year", PayrollLedgerEntry.Period, PayrollLedgerEntry.Period)
                          / PayrollFunctions.GetDaysInMonth(PayrollLedgerEntry.Period, PayrollLedgerEntry."Tax Year"));
                    end;
                end
                ELSE BEGIN
                    IF PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement THEN BEGIN
                        VExemptTax := VExemptTax + PayrollLedgerEntry."Free Pay";
                        PeriodNumber := PeriodNumber + 1;
                    END;
                END;
                VTotalTaxGiven := VTotalTaxGiven + PayrollLedgerEntry."Tax Paid";
            until PayrollLedgerEntry.NEXT = 0;
        VExemptTax := VExemptTax;
        VCalcExemptTax := VExemptTax;
        VNetTaxSalary := ROUND(VTotalTax - VExemptTax, 2);
        VCalcNetTaxSalary := ROUND(VTotalTax - VCalcExemptTax, 2);

        // apply Tax Bands
        Loop := 1;
        while Loop <= 2 do begin
            LastBand := false;
            Computed := false;
            if Loop = 1 then
                Remainder := VNetTaxSalary
            else
                Remainder := VCalcNetTaxSalary;
            if TaxBand.FIND('-') then
                repeat
                    if Remainder >= (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumber then begin
                        Computed := true;
                        Remainder := Remainder - (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumber;
                        if Loop = 1 then
                            VPayeTax := VPayeTax + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumber * (TaxBand.Rate / 100)
                        else
                            VCalcPayeTax := VCalcPayeTax + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumber * (TaxBand.Rate / 100);
                    end else begin
                        LastBand := true;
                        if Remainder > 0 then begin
                            if Loop = 1 then
                                VPayeTax := VPayeTax + (Remainder * (TaxBand.Rate / 100))
                            else
                                VCalcPayeTax := VCalcPayeTax + (Remainder * (TaxBand.Rate / 100));
                        end;
                    end;
                until (TaxBand.NEXT = 0) or (LastBand);
            Loop := Loop + 1;
        end; // loop

        PayrollLedgerEntry.RESET;
        PayrollLedgerEntry.SETFILTER("Payroll Date", '..%1', pToDate);
        PayrollLedgerEntry.SETRANGE(Open, false);
        PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
        PayrollLedgerEntry.SETFILTER(Declared, '%1|%2', PayrollLedgerEntry.Declared::Declared, PayrollLedgerEntry.Declared::"Non-NSSF");
        PayrollLedgerEntry.SETFILTER(PayrollLedgerEntry.Period, '<=%1', DATE2DMY(pToDate, 2));
        if PayrollLedgerEntry.FINDFIRST then
            repeat
                VTaxGiven := VTaxGiven + PayrollLedgerEntry."Tax Paid";
            until PayrollLedgerEntry.NEXT = 0;
        PayParm.GET;

        InsertNegativeTax := true;

        if PayParm."Discard Negative Income Tax" = true then
            InsertNegativeTax := false;

        if InsertNegativeTax = true then
            TxVal := ABS(VCalcPayeTax - VTaxGiven)
        else
            TxVal := (VCalcPayeTax - VTaxGiven);
        // Insert PAYE Tax
        if TxVal > 100 then begin
            pPayrollLedgerEntry."Tax Paid" := ROUND(VCalcPayeTax - VTaxGiven, GetIncomeTaxPrecision(), '>');
            pPayrollLedgerEntry."Income Tax Retro" := ROUND(VCalcPayeTax - VTotalTaxGiven, GetIncomeTaxPrecision(), '>');
            pPayrollLedgerEntry.MODIFY;

            PayParm.GET;
            PayDetailLineRec.SETRANGE(Open, true);
            PayDetailLineRec.SETRANGE("Pay Element Code", PayParm."Income Tax Code");
            PayDetailLineRec.SETRANGE("Employee No.", pPayrollLedgerEntry."Employee No.");
            if PayDetailLineRec.FINDFIRST then begin
                PayDetailLineRec.Amount := ROUND(VCalcPayeTax - VTaxGiven, GetIncomeTaxPrecision(), '>');
                PayDetailLineRec."Calculated Amount" := ROUND(VCalcPayeTax - VTaxGiven, GetIncomeTaxPrecision(), '>');
                PayDetailLineRec.MODIFY;
            end
            else begin
                PayDetailLine.INIT;
                PayElement.GET(PayParam."Income Tax Code");
                PayDetailLine.Amount := ROUND(VCalcPayeTax - VTaxGiven, GetIncomeTaxPrecision(), '>');
                PayDetailLine."Calculated Amount" := ROUND(VCalcPayeTax - VTaxGiven, GetIncomeTaxPrecision(), '>');
                InsertPayDetailLine(PayElement.Code, '');
            end;

        end;
        //EDM+
        PayElementRec.RESET;
        PayElementRec.SETRANGE(Code, PayParm."Income Tax Code");
        if PayElementRec.FINDFIRST then
            if InsertNegativeTax = true then begin
                SumUpAllowDeduct(PayElementRec, V, 0, 0, '');
            end
            else begin
                if (VCalcPayeTax + VCalcPayeTax) - (VTotalTaxGiven + VTotalTaxGiven) > 0 then
                    SumUpAllowDeduct(PayElementRec, V, 0, 0, '')
                else
                    if V > 0 then
                        SumUpAllowDeduct(PayElementRec, V, 0, 0, '')
                    else
                        SumUpAllowDeduct(PayElementRec, 0, 0, 0, '');
            end;
        CalculateNetPay;
        pPayrollLedgerEntry."Net Pay" := V_NetSalary;
        pPayrollLedgerEntry.Rounding := V_Rounding;
        pPayrollLedgerEntry.MODIFY;
    end;

    local procedure GetPayrollNETPrecision() Val: Decimal;
    var
        PayrollParameter: Record "Payroll Parameter";
    begin
        PayrollParameter.GET;
        //The value cannot be 0
        if PayrollParameter."Payroll NET Precision" > 0 then
            exit(PayrollParameter."Payroll NET Precision")
        else
            exit(1000);
    end;

    local procedure GetIncomeTaxPrecision() Val: Decimal;
    var
        PayrollParameter: Record "Payroll Parameter";
    begin
        PayrollParameter.GET;
        if PayrollParameter."Income Tax Precision" > 0 then
            exit(PayrollParameter."Income Tax Precision")
        else
            exit(1000);
    end;
}