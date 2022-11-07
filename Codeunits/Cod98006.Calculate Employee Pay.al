codeunit 98006 "Calculate Employee Pay"
{
    // version PY1.0,SHR1.0,EDM.HRPY1

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
        ThresholdTax: array[10] of Decimal;
        TaxRate: array[10] of Decimal;
        CumulativeBandWidth: array[10] of Decimal;
        CumulativeAnnualTax: array[10] of Decimal;
        BasicRate: Decimal;
        PayEmployee: Record Employee;
        Threshold: array[10] of Decimal;
        CumulativeValue: array[10] of Decimal;
        EmployeeJnl: Record "Employee Journal Line";
        ProporAmount: Decimal;
        AssociateAmount: Decimal;
        CauseOfAbsence: Record "Cause of Absence";
        PayElement2: Record "Pay Element";
        OvertimeHours: Decimal;
        TaxableAllowances: Decimal;
        NonTaxableAllowances: Decimal;
        Deductions: Decimal;
        TaxDeductions: Decimal;
        OvertimePay: Decimal;
        EmploymentType: Record "Employment Type";
        PayDetailLine: Record "Pay Detail Line";
        PayDetailHeader: Record "Pay Detail Header";
        PayDetailHeader2: Record "Pay Detail Header";
        USDExchgRate: Decimal;
        HoursWorked: Decimal;
        HolidayPay: Decimal;
        PayElement: Record "Pay Element";
        MonthlyBasicPay: Decimal;
        WorkingDaysProporAllowance: Decimal;
        GrossPay: Decimal;
        ProporBasicPay: Decimal;
        TaxablePay: Decimal;
        FamilyAllowance: Decimal;
        NonTaxDeductions: Decimal;
        V_EmployeeLoan: Decimal;
        PayDetailLine2: Record "Pay Detail Line";
        PayrollFunctions: Codeunit "Payroll Functions";
        TaxPaid: Decimal;
        PayLedgEntry: Record "Payroll Ledger Entry";
        NextLineNo: Integer;
        NetPay: Decimal;
        AdjNetPay: Decimal;
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
        Period: Integer;
        TaxBand: Record "Tax Band";
        V_NetSalary: Decimal;
        Loop: Integer;

        LoopAfter: Integer;

        LoopBefore: Integer;
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
        V_ExcAmount: Decimal;
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
        ACY_NTaxAttDaysAbs: Decimal;
        V_LatenessAbs: Decimal;
        ACY_LatenessAbs: Decimal;
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
        EmpContracts: Record "Employee Contracts";
        DailyBasis: Boolean;
        WrkDays: Decimal;
        SplitPayDetLine: Record "Split Pay Detail Line";
        TempSplitPayDetLine: Record "Split Pay Detail Line" temporary;
        TempSplitPayDetLine2: Record "Split Pay Detail Line" temporary;
        SplitLineNo: Integer;
        Month: Integer;
        Year: Integer;
        Date1: Date;
        Date2: Date;
        Activated: Boolean;
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
        DailyAmount: Decimal;
        HRSetup: Record "Human Resources Setup";
        HRTransactionType: Record "HR Transaction Types";
        V_EmployeePensionAbove: Decimal;
        V_EmployerPensionAbove: Decimal;
        V_Rounding: Decimal;
        NumberofWorkingDays: Decimal;
        EmployeeRec: Record Employee;
        SpecificPayElementRec: Record "Specific Pay Element";
        V_NSSFSalary: Decimal;
        G_AttStartDate: Date;
        G_AttEndDate: Date;
        G_IsSeparateAttendanceInterval: Boolean;
        NSSFSalaryFIXED: Decimal;
        NSSFSalaryVARIABLE: Decimal;
        V_YearlyExemptTax: Decimal;

    local procedure "Code"();
    begin
        Paystatus.TESTFIELD("Period Start Date");
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
            //Modified in order to consider employees whose employment date is > Start Date and <= End Date - 11.05.2016 : AIM +
            //SETFILTER("Employment Date",'<=%1',Paystatus."Period Start Date");
            SETFILTER("Employment Date", '<=%1', Paystatus."Period End Date");
            //Modified in order to consider employees whose employment date is > Start Date and <= End Date - 11.05.2016 : AIM -
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
        SourceType: Option "Pay Detail",Journals,"Sub Payroll";
        HRSetup: Record "Human Resources Setup";
        Numberoftaxdays: Integer;
    begin
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        G_IsSeparateAttendanceInterval := PayrollFunctions.IsSeparateAttendanceInterval(PayStatusRec."Payroll Group Code");
        if G_IsSeparateAttendanceInterval then begin
            G_AttStartDate := GetAttendanceStartDate(PayStatusRec."Payroll Group Code");
            G_AttEndDate := GetAttendanceEndDate(PayStatusRec."Payroll Group Code");
        end
        else begin
            G_AttStartDate := PayStatusRec."Period Start Date";
            G_AttEndDate := PayStatusRec."Period End Date";
        end;
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-

        //Added in order to automatically reset Pay Details instead of using [Human Resource Setup -> Delete/Create pay] - 29.03.2016 : AIM +
        PayrollFunctions.ResetEmployeePayDetailsInfo(EmpRec."No.", false);
        //Added in order to automatically reset Pay Details instead of using [Human Resource Setup -> Delete/Create pay] - 29.03.2016 : AIM -


        //Added in order to check if the employee can be included in current payroll - 13.04.2016 : AIM +
        if PayrollFunctions.UseEmployeeInPayrollCalculation(EmpRec."No.", PayStatusRec."Payroll Date", PayStatusRec."Period Start Date", PayStatusRec."Period End Date") = false then
            exit;
        //Added in order to check if the employee can be included in current payroll - 13.04.2016 : AIM -

        Paystatus.COPY(PayStatusRec);
        InitialisePayroll(Paystatus);
        PayEmployee.COPY(EmpRec);

        //IT++--
        EmployeeRec.SETRANGE("No.", PayEmployee."No.");

        //Modified in order to consider Attendance Interval - 18.09.2017 : A2+
        if not G_IsSeparateAttendanceInterval then
            EmployeeRec.SETFILTER("Date Filter", '%1..%2', Paystatus."Period Start Date", Paystatus."Period End Date")
        else
            EmployeeRec.SETFILTER("Date Filter", '%1..%2', G_AttStartDate, G_AttEndDate);
        //Modified in order to consider Attendance Interval - 18.09.2017 : A2-

        if EmployeeRec.FINDFIRST then begin
            HRSetup.GET;
            IF HRSetup."Control Trans For Working Days" then BEGIN
                EmployeeRec.CALCFIELDS("No. of Working Days");
                EmployeeRec.CALCFIELDS("No. of days without trans");
                NumberofWorkingDays := HRSetup."Number of Days Transport" - EmployeeRec."No. of days without trans";
            END
        end;

        if NumberofWorkingDays = 0 then
            NumberofWorkingDays := 0;

        //IT++--
        //py2.0
        PayEmployee.CALCFIELDS("Include in Pay Cycle");
        if not EmploymentType.GET(PayEmployee."Employment Type Code") then
            ERROR('Employment Type not Defined for Employee %1 : ', PayEmployee."No.");

        //+++++
        //NumberofWorkingDays:=EmploymentType."No. of Working Days";
        //-----
        //EDM.IT20140212+
        HRSetup.GET;
        //**********************
        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM +
        InsertEmployeeTerminationEmployAbsJournals(PayEmployee, Paystatus, true);
        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM -
        //********************
        //EDM.IT20140212-

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

            //Modified in order to consider Attendance Interval - 18.09.2017 : A2+
            // PayDetailHeader.SETFILTER("Date Filter",'%1..%2',Paystatus."Period Start Date",Paystatus."Period End Date");
            if not G_IsSeparateAttendanceInterval then
                PayDetailHeader.SETFILTER("Date Filter", '%1..%2', Paystatus."Period Start Date", Paystatus."Period End Date")
            else
                PayDetailHeader.SETFILTER("Date Filter", '%1..%2', G_AttStartDate, G_AttEndDate);
            //Modified in order to consider Attendance Interval - 18.09.2017 : A2-
            //PayDetailHeader.SETFILTER("Date Filter",'%1..%2',Paystatus."Period Start Date",Paystatus."Period End Date");
            PayDetailHeader.CALCFIELDS("Working Days Affected", "Attendance Days Affected", "Overtime Hours", "Overtime with Unpaid Hours",
                                       "Converted Salary", "Lateness Days Affected", "Days-Off Transportation",
                                       "Late/ Early Attendance (Hours)", "Overtime Days"); //Mb.0605+-
            PayDetailHeader.CALCFIELDS("No. of Working Days");
            PayDetailHeader.CALCFIELDS("No. Of Working Days-Attendance");
        end;

        //Added in order to read data from Journal Line and not atendance - 10.09.2016 : AIM +
        HRSetup.GET;
        IF NOT HRSetup."Control Trans For Working Days" then
            NumberofWorkingDays := PayDetailHeader."No. of Working Days";
        //Added in order to read data from Journal Line and not atendance - 10.09.2016 : AIM -

        //Added in order to give HOLIDAY Transportation - 19.01.2018 : AIM + // To be fixed to be as parameter
        if HRSetup."Give Holiday Transportation" then
            NumberofWorkingDays := NumberofWorkingDays + GetAbsCauseCodeDaysForTransportation(PayEmployee."No.", 'HOLIDAY', Paystatus."Period Start Date", Paystatus."Period End Date");
        //Added in order to give HOLIDAY Transportation - 19.01.2018 : AIM -
        //EMD+
        if HRSetup."Working From Home Code" <> '' then
            NumberofWorkingDays := NumberofWorkingDays - GetAbsCauseCodeDaysForTransportation(PayEmployee."No.", HRSetup."Working From Home Code", Paystatus."Period Start Date", Paystatus."Period End Date");
        //EDM-
        //Chk Daily Basis Contract
        DailyBasis := false;
        ChkDailyBasisContract;
        if DailyBasis then begin
            WrkDays := 0;
            GetEffectiveWorkDays;
            WrkDays := WrkDays - PayDetailHeader."Working Days Affected" - (PayDetailHeader."Late/ Early Attendance (Hours)" / 10);
            //MB.0605+-
        end;

        CLEAR(EmployeeJnl);
        EmployeeJnl.SETCURRENTKEY("Employee No.", Type, Processed, "Document Status");
        EmployeeJnl.SETRANGE("Employee No.", PayEmployee."No.");
        EmployeeJnl.SETRANGE(Type, 'ABSENCE');
        EmployeeJnl.SETRANGE(Processed, false);
        EmployeeJnl.SETFILTER("Document Status", '<>%1', EmployeeJnl."Document Status"::Approved);
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        //EmployeeJnl.SETFILTER("Transaction Date",'%1..%2',Paystatus."Period Start Date",Paystatus."Period End Date");
        EmployeeJnl.SETFILTER("Transaction Date", '%1..%2', G_AttStartDate, G_AttEndDate);
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-
        if EmployeeJnl.FIND('-') then
            ERROR('There are Still Journal Lines not Approved Yet for %1 Empolyee. Operation Aborted !', PayEmployee."No.");

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

        //**1**//
        with PayEmployee do begin
            ClearTotals;
            //py2.0+
            //IF Status = Status::Active THEN BEGIN

            //**2**//
            if PayDetailHeader."Include in Pay Cycle" then begin
                //py2.0-
                //Period := DATE2DMY(Paystatus."Payroll Date",2);
                //EDM.IT+
                InsertEmployeeBenefitPenalties;
                //EDM.IT-
                CALCFIELDS("Pay To Date", "Taxable Pay To Date", "Tax Paid To Date", "Outstanding Loans");
                CalculateGrossPay;
                // Added in order to insert Family Allowance Retro - 07.06.2017 : A2+
                InsertFamilyAllowanceRetro(PayEmployee."No.", Paystatus."Period End Date");
                // Added in order to insert Family Allowance Retro - 07.06.2017 : A2-

                // 25.07.2017 : A2+
                PayrollFunctions.GenerateAllowanceDeductions(PayStatusRec."Payroll Date", PayStatusRec."Payroll Group Code", EmpRec."No.", true, false, EmpRec."Employee Category Code", '', SourceType::"Pay Detail", false);
                // 25.07.2017 : A2-

                GetManualPayE;
                InsertPayDetailsPensionSchemeElements(PayEmployee);
                InsertSpePayE;
                //**3**//
                if (PayEmployee.Declared <> PayEmployee.Declared::"Non-Declared") and (not InAddccy) and
                      (PayEmployee.Declared <> PayEmployee.Declared::Contractual) then begin
                    if (PayEmployee."No Exempt" = false) then begin
                        //EDM.IT+ 20130916
                        PayDetailHeader.CALCFIELDS("Working Days Affected");
                        TaxPeriod := 12;//360/(30-PayDetailHeader."Working Days Affected");
                        //EDM.IT-
                        // Modified in order to use the new function CalculateTaxCode - 13.02.2016 -  AIM  +
                        //V_CalcExemptTax := PayrollFunctions.CalculateTaxCode(PayEmployee,TRUE,SpouseExemptTax) / TaxPeriod;
                        V_CalcExemptTax := PayrollFunctions.CalculateTaxCode(PayEmployee, true, SpouseExemptTax, Paystatus."Period End Date") / 12;
                        // Modified in order to use the new function CalculateTaxCode - 13.02.2016 -  AIM  -

                        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM +
                        if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                            V_CalcExemptTax := V_CalcExemptTax * (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                                        / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3)));
                            V_CalcExemptTax := ROUND(V_CalcExemptTax, 0.01);
                        end;
                        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM -
                    end
                    else begin
                        //EDM.IT+ 20130916
                        PayDetailHeader.CALCFIELDS("Working Days Affected");
                        TaxPeriod := 360 / (30 - PayDetailHeader."Working Days Affected");
                        //EDM.IT-
                        V_CalcExemptTax := 0;
                    end;

                    CalculateTax;
                end
                else
                    V_CalcExemptTax := 0;
                //**3**//

                //Added in ordr to consider the case where Income Tax and MHOOD are returned to employee - 24.08.2016 : AIM +
                ReturnIncomeTaxToEmployee(PayEmployee);
                ReturnMHOODToEmployee(PayEmployee);
                //Added in ordr to consider the case where Income Tax and MHOOD are returned to employee - 24.08.2016 : AIM -
                CalculateNetPay;

                //EDM.IT+
                InsertEmpLedgEntry(Paystatus."Payroll Date");

                //**4**//
                // Added in order to consider the case of contractual - 23.02.2016 : AIM +
                if PayEmployee.Declared <> PayEmployee.Declared::Contractual then begin // Added in order to consider the case of contractual - 23.02.2016 : AIM -
                    if PayEmployee.Declared = PayEmployee.Declared::Declared then begin
                        //Coders++ 06-07-2021
                        //IF NOT PayEmployee.IsForeigner then
                        CalcPensionRetroactive(PayStatusRec."Period End Date", PayEmployee."No.", PayLedgEntry);
                    end;
                    //Coders-- 06-07-2021
                    CalculateNetPay;
                    PayLedgEntry.SETRANGE("Payroll Date", Paystatus."Payroll Date");
                    PayLedgEntry.SETRANGE(Open, true);
                    PayLedgEntry.SETRANGE("Employee No.", PayEmployee."No.");
                    if PayLedgEntry.FINDFIRST then
                        repeat
                            PayLedgEntry.DELETE;
                        until PayLedgEntry.NEXT = 0;

                    InsertEmpLedgEntry(Paystatus."Payroll Date");

                    if (PayEmployee.Declared <> PayEmployee.Declared::"Non-Declared") and (not InAddccy) and
                           (PayEmployee.Declared <> PayEmployee.Declared::Contractual) then
                        CalculateTaxRetro(PayStatusRec."Period End Date", PayEmployee."No.", PayLedgEntry, PeriodNo);

                end // Added in order to consider the case of contractual - 23.02.2016 : AIM +
                else begin
                    CalculateTaxNetPercentage;
                    CalculateNetPay;
                    PayLedgEntry.SETRANGE("Payroll Date", Paystatus."Payroll Date");
                    PayLedgEntry.SETRANGE(Open, true);
                    PayLedgEntry.SETRANGE("Employee No.", PayEmployee."No.");
                    if PayLedgEntry.FINDFIRST then
                        repeat
                            PayLedgEntry.DELETE;
                        until PayLedgEntry.NEXT = 0;

                    InsertEmpLedgEntry(Paystatus."Payroll Date");///

                end;
                // Added in order to consider the case of contractual - 23.02.2016 : AIM -

                //**4**//

                CalculateNetPay;
                //EDM.IT-
                //Added in order to consider Fund Contribution - 10.10.2017 : AIM +
                GetFundContributionValue(PayEmployee);
                //Added in order to consider Fund Contribution - 10.10.2017 : AIM -
                AddDeductPercentagOfNetSalary(PayEmployee);

                UpdateAbsences;
                UpdateSplitEmpJnls;
            end; //emp.active
                 //**2**//

        end; // ledg
             //**1**//

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
    var
        PayParam: Record "Payroll Parameter";
    begin
        // Setup the Payroll No and title
        SetupPayrollInfo(PayStatus);

        // Get the tax bands record
        PayParam.GET;
        IF PayParam."Payroll Labor Law" <> PayParam."Payroll Labor Law"::UAE then begin
            if (not TaxBand.FIND('-')) and (PayParam."Income Tax Code" <> '') then
                ERROR('Tax Bands have not been Setup.');
        end
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

        Day := DATE2DMY(PayStatus."Payroll Date", 1);
        Month := DATE2DMY(PayStatus."Payroll Date", 2);
        Year := DATE2DMY(PayStatus."Payroll Date", 3);
        TaxYear := Year;

        // Setup the payroll title,and payroll number
        PayrollDate := PayStatus."Payroll Date";
        PayrollTitle := 'Week No. ';
        Divisor := 52;
        PeriodNo := DATE2DMY(PayStatus."Payroll Date", 2);
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
        V_NSSFSalary := 0; // Added to calculate Salary subject to NSSF Contribution - 13.02.2016 : AIM +-
        //20180524-EDM.TarekH+
        NSSFSalaryFIXED := 0;
        NSSFSalaryVARIABLE := 0;
        //20180524-EDM.TarekH-
        //Added to reset variables - 04.06.2018 : AIM +
        V_ExemptTax := 0;
        V_YearlyExemptTax := 0;
        //Added to reset variables - 04.06.2018 : AIM -
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
        MaxDate: Date;
        RateofCost: Decimal;
        EffectiveDays: Decimal;
        BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount;
        L_PayStatusTbt: Record "Payroll Status";
        L_EmployHrsPerDay: Decimal;
        L_EmployTypeTbt: Record "Employment Type";
        HalfTaxableSalary: Decimal;
        HalfTaxableSalaryConverted: Decimal;
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        // Gross Pay
        with PayDetailLine do begin
            RESET;
            SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
            SETRANGE("Employee No.", PayEmployee."No.");
            SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Manual Pay Line", false);
            if FIND('-') then
                repeat
                    //py2.0+
                    CLEAR(SplitTotCalAmtLCY);
                    CLEAR(SplitTotCalAmtACY);
                    CLEAR(SplitTotEffDays);
                    //py2.0-
                    PayElement.GET("Pay Element Code");
                    V_CalculatedAmount := Amount;
                    VA_CalculatedAmount := "Amount (ACY)";
                    case "Pay Element Code" of
                        PayParam."Basic Pay Code":
                            begin
                                if not SplitEntries(PayElement, PayEmployee."No.") then begin
                                    //salaries+
                                    //Modified to consider employee who work on daily basis - no fixed salary but affected by Payroll generation interval - 19.03.2018 : AIM +
                                    //V_BasicPay := Amount;
                                    if PayEmployee."Hourly Basis" = false then
                                        V_BasicPay := Amount
                                    else begin
                                        L_PayStatusTbt.SETRANGE(L_PayStatusTbt."Payroll Group Code", PayEmployee."Payroll Group Code");
                                        if L_PayStatusTbt.FINDFIRST then begin
                                            if PayEmployee."Daily Rate" > 0 then
                                                V_BasicPay := (PayEmployee."Daily Rate") * ((L_PayStatusTbt."Period End Date" - L_PayStatusTbt."Period Start Date") + 1)
                                            else begin
                                                L_EmployHrsPerDay := 0;
                                                CLEAR(L_EmployTypeTbt);
                                                L_EmployTypeTbt.RESET;
                                                L_EmployTypeTbt.SETRANGE(L_EmployTypeTbt.Code, PayEmployee."Employment Type Code");
                                                if L_EmployTypeTbt.FINDFIRST then begin
                                                    L_EmployHrsPerDay := L_EmployTypeTbt."Working Days Per Month";
                                                end;
                                                if L_EmployHrsPerDay > 0 then
                                                    V_BasicPay := (PayEmployee."Basic Pay" / L_EmployHrsPerDay) * ((L_PayStatusTbt."Period End Date" - L_PayStatusTbt."Period Start Date") + 1);
                                            end;
                                        end;
                                    end;
                                    //Modified to consider employee who work on daily basis - no fixed salary but affected by Payroll generation interval - 19.03.2018 : AIM -

                                    V_CalcBasicPay := V_BasicPay;
                                    VA_Salary := "Amount (ACY)";
                                    IF InBothccy THEN BEGIN
                                        if not DailyBasis then
                                            VS_Salary := ROUND(V_BasicPay / Paystatus."Exchange Rate", 0.01) + VA_Salary
                                        else
                                            VS_Salary := VA_Salary;
                                    end;
                                    //Salaries-
                                    if ((((PayDetailHeader."Working Days Affected" <> 0) or (PayDetailHeader."Late/ Early Attendance (Hours)" <> 0))
                                         //MB.060
                                         and (not DailyBasis)) or (DailyBasis))
                                          // Disabled in order to fix the calculation of Absence - 10.03.2016 : AIM +
                                          //AND (PayElement."Days in  Month" <> 0)
                                          // Disabled in order to fix the calculation of Absence - 10.03.2016 : AIM -
                                          //Added to consider case where employee is Hourly Basis and has worked all days in the payroll period - to prevent zero salary - 18.06.2018 : AIM +
                                          OR ((PayEmployee."Hourly Basis") AND (NOT DailyBasis))
                                          //Added to consider case where employee is Hourly Basis and has worked all days in the payroll period - to prevent zero salary - 18.06.2018 : AIM -
                                          then begin
                                        if (ACYComp_WorkingDays) and (InBothccy) then begin
                                            if not DailyBasis then begin

                                                // Changed in order to fix the calculation of Absence - 10.03.2016 : AIM +
                                                /*ACY_WorkingDaysAbs := (VS_Salary / PayElement."Days in  Month") *
                                                                (ABS(PayDetailHeader."Working Days Affected" +
                                                                ABS(PayDetailHeader."Late/ Early Attendance (Hours)" / 10))); //MB.0605+-
                                                  */
                                                //Modified in order to use the Hourly Rate which is set at Employee Card - 18.08.2016 : AIM +
                                                //V_WorkingDaysAbs := GetSalaryAbsenceAmount(PayEmployee."No.",PayDetailHeader."Working Days Affected",PayDetailHeader."Late/ Early Attendance (Hours)" ,BasicType::FixedAmount,VS_Salary);
                                                if (PayrollFunctions.IsScheduleUseEmployeeCardHourlyRate(PayEmployee."No.") = true) and (PayEmployee."Hourly Rate" > 0) then
                                                    V_WorkingDaysAbs := GetSalaryAbsenceAmount(PayEmployee."No.", PayDetailHeader."Working Days Affected", PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::HourlyRate, 0)
                                                else
                                                    V_WorkingDaysAbs := GetSalaryAbsenceAmount(PayEmployee."No.", PayDetailHeader."Working Days Affected", PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::FixedAmount, VS_Salary);
                                                //Modified in order to use the Hourly Rate which is set at Employee Card - 18.08.2016 : AIM -
                                                // Changed in order to fix the calculation of Absence - 10.03.2016 : AIM -

                                                ACY_WorkingDaysAbs := PayrollFunctions.RoundingAmt(ACY_WorkingDaysAbs, true);



                                                VA_CalcSalary := VA_Salary - ACY_WorkingDaysAbs;
                                            end
                                            else //DailyBasis
                                                VA_CalcSalary := VA_Salary * WrkDays;

                                            VA_CalculatedAmount := PayrollFunctions.RoundingAmt(VA_CalcSalary, true);
                                        end; //b.p-acy.E

                                        if ((not ACYComp_WorkingDays) or (InBaseccy) or (InAddccy)) then begin
                                            if V_BasicPay <> 0 then begin
                                                if not DailyBasis then begin
                                                    //EDM.IT+
                                                    HRSetup.GET;
                                                    //Modified because of wrong condition - 23.02.2016 : AIM +
                                                    //IF HRSetup."Monthly Hours" <> 0 THEN

                                                    // Changed in order to fix the calculation of Absence - 10.03.2016 : AIM +
                                                    /*IF PayElement."Days in  Month" = 0 THEN
                                                      //Modified because of wrong condition - 23.02.2016 : AIM -
                                                      BEGIN
                                                         IF PayDetailHeader."Late/ Early Attendance (Hours)" <> 0 THEN
                                                            BEGIN
                                                                 //Modified in order to use Hrs/Day in Payelement as primary choice - 23.02.2016 : AIM+
                                                                 {V_WorkingDaysAbs := (V_BasicPay /HRSetup."Monthly Hours")
                                                                         (ABS(PayDetailHeader."Working Days Affected")* HRSetup."Hours in the Day"
                                                                          +(PayDetailHeader."Late/ Early Attendance (Hours)")); //MB.0605+-}
                                                                  IF PayElement."Hours in  Day" = 0 THEN
                                                                       V_WorkingDaysAbs := (V_BasicPay /HRSetup."Monthly Hours")
                                                                           (ABS(PayDetailHeader."Working Days Affected")* HRSetup."Hours in the Day"
                                                                            +(PayDetailHeader."Late/ Early Attendance (Hours)"))
                                                                  ELSE
                                                                       V_WorkingDaysAbs := (V_BasicPay /HRSetup."Monthly Hours")
                                                                           (ABS(PayDetailHeader."Working Days Affected")* PayElement."Hours in  Day"
                                                                            +(PayDetailHeader."Late/ Early Attendance (Hours)"));
                                                                  //Modified in order to use Hrs/Day in Payelement as primary choice - 23.02.2016 : AIM-
              
                                                            END;
              
                                                         IF PayDetailHeader."Working Days Affected"<>0 THEN
                                                             V_WorkingDaysAbs := (V_BasicPay /HRSetup."Monthly Hours")*{//}EmploymentType."No. of Working Days") *
                                                                        (ABS(PayDetailHeader."Working Days Affected")) * HRSetup."Hours in the Day";//+
                                                                        //+(PayDetailHeader."Late/ Early Attendance (Hours)")); //MB.0605+-
              
                                                         //Stopped+- V_WorkingDaysAbs := PayrollFunctions.RoundingAmt(V_WorkingDaysAbs,FALSE);
                                                         V_WorkingDaysAbs := ROUND(V_WorkingDaysAbs,500,'>');//EDM.IT
                                                         VLateEarlyPay := (V_BasicPay / HRSetup."Monthly Hours") *
                                                                        (PayDetailHeader."Late/ Early Attendance (Hours)"); //MB.250607+-
                                                         //VLateEarlyPay := PayrollFunctions.RoundingAmt(VLateEarlyPay,FALSE);
                                                         VLateEarlyPay := ROUND(VLateEarlyPay,500,'>');//EDM.IT
                                                      END
                                                    ELSE
                                                      BEGIN
                                                          //EDM.IT-
                                                          V_WorkingDaysAbs := (V_BasicPay /PayElement."Days in  Month" ) *
                                                                        (ABS(PayDetailHeader."Working Days Affected")
                                                                        );//+(PayDetailHeader."Late/ Early Attendance (Hours)" / 10)); //MB.0605+-
                                                          V_WorkingDaysAbs :=  PayrollFunctions.RoundingAmt(V_WorkingDaysAbs,FALSE);
                                                          VLateEarlyPay := (V_BasicPay / PayElement."Days in  Month") *
                                                                        (PayDetailHeader."Late/ Early Attendance (Hours)" / 10); //MB.250607+-
                                                          VLateEarlyPay :=PayrollFunctions.RoundingAmt(VLateEarlyPay,FALSE);
                                                      END;//EDM.IT+-
                                                      V_CalcBasicPay := V_BasicPay - V_WorkingDaysAbs;*/

                                                    //Modified in order to use the Hourly Rate which is set at Employee Card - 18.08.2016 : AIM +
                                                    //V_WorkingDaysAbs := GetSalaryAbsenceAmount(PayEmployee."No.",PayDetailHeader."Working Days Affected",0,BasicType::FixedAmount,V_BasicPay);
                                                    if (PayrollFunctions.IsScheduleUseEmployeeCardHourlyRate(PayEmployee."No.") = true) and (PayEmployee."Hourly Rate" > 0) then
                                                        V_WorkingDaysAbs := GetSalaryAbsenceAmount(PayEmployee."No.", PayDetailHeader."Working Days Affected", 0, BasicType::HourlyRate, 0)
                                                    else
                                                        V_WorkingDaysAbs := GetSalaryAbsenceAmount(PayEmployee."No.", PayDetailHeader."Working Days Affected", 0, BasicType::FixedAmount, V_BasicPay);
                                                    //Modified in order to use the Hourly Rate which is set at Employee Card - 18.08.2016 : AIM -
                                                    V_WorkingDaysAbs := PayrollFunctions.RoundingAmt(V_WorkingDaysAbs, false);


                                                    //Modified in order to use the Hourly Rate which is set at Employee Card - 18.08.2016 : AIM +
                                                    //VLateEarlyPay := GetSalaryAbsenceAmount(PayEmployee."No.",0,PayDetailHeader."Late/ Early Attendance (Hours)",BasicType::FixedAmount,V_BasicPay);
                                                    if (PayrollFunctions.IsScheduleUseEmployeeCardHourlyRate(PayEmployee."No.") = true) and (PayEmployee."Hourly Rate" > 0) then
                                                        VLateEarlyPay := GetSalaryAbsenceAmount(PayEmployee."No.", 0, PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::HourlyRate, 0)
                                                    else
                                                        VLateEarlyPay := GetSalaryAbsenceAmount(PayEmployee."No.", 0, PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::FixedAmount, V_BasicPay);
                                                    //Modified in order to use the Hourly Rate which is set at Employee Card - 18.08.2016 : AIM -
                                                    VLateEarlyPay := PayrollFunctions.RoundingAmt(VLateEarlyPay, false);

                                                    V_CalcBasicPay := V_BasicPay - (V_WorkingDaysAbs + VLateEarlyPay);
                                                    // Changed in order to fix the calculation of Absence - 10.03.2016 : AIM -

                                                end

                                                else //DailyBasis
                                                    V_CalcBasicPay := V_BasicPay * WrkDays;


                                                V_CalculatedAmount := PayrollFunctions.RoundingAmt(V_CalcBasicPay, false);
                                            end;

                                            if VA_Salary <> 0 then begin
                                                if not DailyBasis then begin
                                                    // Changed in order to fix the calculation of Absence - 10.03.2016 : AIM +
                                                    /*ACY_WorkingDaysAbs := (VA_Salary / PayElement."Days in  Month") *
                                                        (ABS(PayDetailHeader."Working Days Affected") +
                                                        (PayDetailHeader."Late/ Early Attendance (Hours)" / 10)); //Mb.0605+-
                                                        */
                                                    V_WorkingDaysAbs := GetSalaryAbsenceAmount(PayEmployee."No.", PayDetailHeader."Working Days Affected", PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::FixedAmount, VA_Salary);
                                                    // Changed in order to fix the calculation of Absence - 10.03.2016 : AIM -
                                                    ACY_WorkingDaysAbs := PayrollFunctions.RoundingAmt(ACY_WorkingDaysAbs, true);
                                                    VA_CalcSalary := VA_Salary - ACY_WorkingDaysAbs;
                                                end
                                                else //DailyBasis
                                                    VA_CalcSalary := PayrollFunctions.RoundingAmt(VA_Salary * WrkDays, true);

                                                VA_CalculatedAmount := VA_CalcSalary;
                                            end;

                                        end; //not an ACY.E - only lcy/acy
                                    end; // wrkdays<>0

                                    if (ACYComp_WorkingDays) and (InBothccy) and (VA_CalcSalary < 0) then begin
                                        V_CalcBasicPay := V_BasicPay - (ROUND((ABS(VA_CalcSalary) * Paystatus."Exchange Rate"), 0.01));
                                        VA_CalcSalary := 0;
                                        V_CalcBasicPay := PayrollFunctions.RoundingAmt(V_CalcBasicPay, false);
                                        V_CalculatedAmount := V_CalcBasicPay;
                                        VA_CalculatedAmount := VA_CalcSalary;
                                    end; //exc

                                end
                                else begin
                                    V_CalculatedAmount := SplitTotCalAmtLCY;
                                    VA_CalculatedAmount := SplitTotCalAmtACY;
                                    V_BasicPay := Amount;
                                    V_CalcBasicPay := V_CalculatedAmount;
                                    VA_Salary := "Amount (ACY)";
                                    if InBothccy then begin
                                        if not DailyBasis then
                                            VS_Salary := ROUND(V_BasicPay / Paystatus."Exchange Rate", 0.01) + VA_Salary
                                        else
                                            VS_Salary := VA_Salary;
                                    end;
                                    //Salaries-
                                end; //split Entries.
                            end; // b.p


                        PayParam."Family Allowance Code":
                            begin
                                //EDM.IT+
                                if PayEmployee."Don't Deserve Family Allowance" then begin
                                    V_CalculatedAmount := 0;
                                    Amount := 0;
                                end
                                else begin
                                    if FORMAT(PayEmployee."End of Service Date") <> '' then begin
                                        MaxDate := DMY2DATE(15, DATE2DMY(PayEmployee."End of Service Date", 2), DATE2DMY(PayEmployee."End of Service Date", 3));
                                    end;
                                    if (PayEmployee."End of Service Date" < MaxDate) and
                                    (DATE2DMY(PayEmployee."End of Service Date", 2) = DATE2DMY(PayrollDate, 2))
                                    and (DATE2DMY(PayEmployee."End of Service Date", 3) = DATE2DMY(PayrollDate, 3))
                                    then begin
                                        V_CalculatedAmount := 0;
                                        V_FamilyAllowances := 0;
                                        Amount := 0;
                                    end else begin
                                        //Modified in order to use the new function CalculateFamilyAllowance - 13.02.2016 : AIM +
                                        //V_CalculatedAmount := PayrollFunctions.CalculateFamilyAllowance(PayEmployee,TRUE);
                                        V_CalculatedAmount := PayrollFunctions.CalculateFamilyAllowance(PayEmployee, true, Paystatus."Period End Date");

                                        if (PayEmployee."Termination Date" <> 0D) then begin
                                            if (PayEmployee."Termination Date" > Paystatus."Period Start Date") and (PayEmployee."Termination Date" < Paystatus."Period End Date") then begin
                                                if (PayEmployee."Termination Date" - Paystatus."Period Start Date") + 1 >= 15 then begin
                                                    //V_CalculatedAmount := V_CalculatedAmount - ((V_CalculatedAmount / 30) * (Paystatus."Period End Date" - PayEmployee."Termination Date" ));
                                                    V_CalculatedAmount := PayrollFunctions.CalculateFamilyAllowance(PayEmployee, true, Paystatus."Period End Date");
                                                    V_CalculatedAmount := PayrollFunctions.RoundingAmt(V_CalculatedAmount, true);
                                                end;
                                            end;
                                        end;
                                        //Modified in order to use the new function CalculateFamilyAllowance - 13.02.2016 : AIM -
                                        V_FamilyAllowances := V_CalculatedAmount;
                                        Amount := V_FamilyAllowances;
                                    end
                                    //EDM.IT-
                                end; // fam.all
                            end;
                        //EDM.IT+
                        PayParam."High Cost of Living Code":
                            begin
                                //Code fixed - 05.10.2017 : AIM +
                                /*
                                //EDM.IT+
                                EffectiveDays:=0;
                                PayDetailHeader.CALCFIELDS("Working Days Affected");
                                EffectiveDays:=30-PayDetailHeader."Working Days Affected";
                                IF PayDetailHeader."Working Days Affected" <> 0 THEN
                                  RateofCost:=EffectiveDays/30
                                ELSE
                                  RateofCost:=1;
                                //EDM.IT-
                                  //V_CalculatedAmount :=PayEmployee."Accommodation Type"*RateofCost;
                                END;
                                //EDM.IT-
                                */

                                if PayEmployee."Cost of Living Amount" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;

                        //Code fixed - 05.10.2017 : AIM -

                        PayParam."Non-Taxable Transp. Code":
                            begin
                                //+++++++
                                SpecificPayElementRec.SETRANGE("Internal Pay Element ID", PayParam."Non-Taxable Transp. Code");
                                SpecificPayElementRec.SETRANGE("Employee Category Code", PayEmployee."Employee Category Code");
                                SpecificPayElementRec.SETRANGE("Pay Unit", SpecificPayElementRec."Pay Unit"::Monthly);
                                if SpecificPayElementRec.FINDFIRST then begin
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                                end
                                else
                              //-------
                              begin
                                    if Paystatus."Supplement Exist" then//EDM+++
                                        V_CalculatedAmount := 0//EDM---
                                    else
                                        V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                                    if (V_BasicPay = 0) and (Amount = 0) then
                                        V_CalculatedAmount := 0;
                                end;
                            end;
                        //Enabled in order to consider Mobile Allowance (By Employee Category) and deny conflicts in case the Mobile Allowance is assigned at Employee Card - 04.04.2016 : AIM +
                        //   PayParam."Mobile allowance": BEGIN
                        //     V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader,PayDetailLine,PayElement.Code);
                        //      END;

                        PayParam."Mobile allowance":
                            begin
                                if PayEmployee."Phone Allowance" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        //Enabled in order to consider Mobile Allowance (By Employee Category) and deny conflicts in case the Mobile Allowance is assigned at Employee Card - 04.04.2016 : AIM -

                        PayParam."Housing Allowance":
                            begin
                                //Modified in order to deny conflicts in case the House Allowance is assigned at Employee Card - 04.04.2016 : AIM +
                                //V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader,PayDetailLine,PayElement.Code);
                                if PayEmployee."House Allowance" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                                //Modified in order to deny conflicts in case the House Allowance is assigned at Employee Card - 04.04.2016 : AIM -
                            end;

                        //Added in order to consider Car Allowance (By Employee Category) and deny conflicts in case the Car Allowance is assigned at Employee Card - 04.04.2016 : AIM +
                        PayParam."Car Allowance":
                            begin
                                if PayEmployee."Car Allowance" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        //Added in order to consider Car Allowance (By Employee Category) and deny conflicts in case the Car Allowance is assigned at Employee Card - 04.04.2016 : AIM -
                        PayParam."Cost of Living":
                            begin
                                if PayEmployee."Cost of Living" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        //Added in order to consider Food Allowance (By Employee Category) and deny conflicts in case the Food Allowance is assigned at Employee Card - 01.08.2016 : AIM +
                        PayParam.Food:
                            begin
                                if PayEmployee."Food Allowance" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        //Added in order to consider Food Allowance (By Employee Category) and deny conflicts in case the Food Allowance is assigned at Employee Card - 01.08.2016 : AIM -

                        //Added in order to consider Ticket Allowance (By Employee Category) and deny conflicts in case the Ticket Allowance is assigned at Employee Card - 01.08.2016 : AIM +
                        PayParam."Ticket Allowance":
                            begin
                                if PayEmployee."Ticket Allowance" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        //Added in order to consider Ticket Allowance (By Employee Category) and deny conflicts in case the Ticket Allowance is assigned at Employee Card - 01.08.2016 : AIM -

                        //Added in order to consider Extra Salary Allowance (By Employee Category) and deny conflicts in case the Extra Salary Allowance is assigned at Employee Card - 25.08.2017 : AIM +
                        PayParam."Extra Salary":
                            begin
                                if PayrollFunctions.GetEmployeeExtraSalary(PayEmployee."No.") <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        //Added in order to consider Extra Salary Allowance (By Employee Category) and deny conflicts in case the Extra Salary Allowance is assigned at Employee Card - 25.08.2017 : AIM -

                        //Added in order to consider Allowances / deductions (By Employee Category) assigned at Employee Card - 05.10.2017 : AIM +

                        PayParam."Water Compensation Allowance":
                            begin
                                if PayEmployee."Water Compensation" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        PayParam."Production Allowance":
                            begin
                                if PayEmployee."Commission Amount" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        PayParam."Commision Addition":
                            begin
                                if PayEmployee."Commission Addition" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        PayParam.Allowance:
                            begin
                                if PayEmployee."Other Allowances" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        PayParam."Comission Deduction":
                            begin
                                if PayEmployee."Commission Deduction" <= 0 then
                                    V_CalculatedAmount := CalculatePayEltSpecial(PayDetailHeader, PayDetailLine, PayElement.Code);
                            end;
                        //Added in order to consider Allowances / deductions (By Employee Category) assigned at Employee Card - 05.10.2017 : AIM -


                        PayParam."Scholarship Code":
                            begin
                                V_Scholar := Amount;
                                ACY_Scholar := "Amount (ACY)";
                                V_CalculatedAmount := Amount;
                                VA_CalculatedAmount := "Amount (ACY)";
                            end; //scholarship
                        PayParam."Commission on Sales Code":
                            begin
                                V_SalesCom := Amount;
                                ACY_SalesCom := "Amount (ACY)";
                                V_CalculatedAmount := Amount;
                                VA_CalculatedAmount := "Amount (ACY)";
                            end; //sales com.
                    end; //pye case
                    "Calculated Amount" := V_CalculatedAmount;
                    "Calculated Amount (ACY)" := VA_CalculatedAmount;
                    "Efective Nb. of Days" := SplitTotEffDays; //py2.0
                    if not PayElement."Not Included in Net Pay" then
                        SumUpAllowDeduct(PayElement, "Calculated Amount", "Calculated Amount (ACY)", ExcessTranspAmt, ExcessPayE);
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
                until NEXT = 0; // pay detail line
        end; // PayDetailLine      
        V_TaxableSalary := V_CalcBasicPay + V_TaxAllowances;

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

        //
        CalculateTaxableSalary();
        //
        TaxPeriod := 12;

        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM +
        /*V_ExemptTax := PayEmployee."Exempt Tax" / TaxPeriod;
        PayDetailHeader.CALCFIELDS("Working Days Affected");
        TaxPeriod:=360/(30-PayDetailHeader."Working Days Affected");
        V_ExemptTax := PayEmployee."Exempt Tax" / TaxPeriod;
        TaxPeriod:=12;
        */
        //Added for new Payroll Laws - not to read the Yearly Exemption from Employee Card - 04.06.2018 : AIM +
        V_YearlyExemptTax := PayrollFunctions.CalculateTaxCode(PayEmployee, TRUE, SpouseExemptTax, Paystatus."Period End Date");
        //Added for new Payroll Laws - not to read the Yearly Exemption from Employee Card - 04.06.2018 : AIM -

        if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
            V_ExemptTax := V_YearlyExemptTax / TaxPeriod;
            V_ExemptTax := (V_ExemptTax) * (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                          / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3)));
        end
        else
            V_ExemptTax := V_YearlyExemptTax / TaxPeriod;
        V_NetTaxSalary := V_TaxableSalary - V_ExemptTax;
        V_CalcNetTaxSalary := V_TaxableSalary - V_CalcExemptTax;

        CLEAR(PayLedgerEntryTEMP);
        TotalTaxablePay := 0;
        TotalMonth := 1;
        TotalTaxPaid := 0;
        TotalFreePay := 0;
        CurrTaxableAmount := 0;

        PayLedgerEntryTEMP.SETCURRENTKEY("Entry No.");

        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM +
        //PayLedgerEntryTEMP.SETRANGE("Current Year",TRUE);
        PayLedgerEntryTEMP.SETRANGE("Tax Year", DATE2DMY(Paystatus."Payroll Date", 3));
        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM -

        PayLedgerEntryTEMP.SETRANGE("Employee No.", PayEmployee."No.");
        //CORE_Update to restrict to only basic accumulated
        //PayLedgerEntryTEMP.SETRANGE(PayLedgerEntryTEMP."Payment Category",PayLedgerEntryTEMP."Payment Category"::Basic);
        //CORE+

        //Added in order to exclude un-declared records - 06.06.2016 : AIM +
        PayLedgerEntryTEMP.SETFILTER(Declared, '%1|%2', PayLedgerEntryTEMP.Declared::Declared, PayLedgerEntryTEMP.Declared::"Non-NSSF");
        //Added in order to exclude un-declared records - 06.06.2016 : AIM -

        //Added in order to consider only months <= month(Payroll date) - 27.02.2018 : AIM +
        PayLedgerEntryTEMP.SETFILTER(PayLedgerEntryTEMP.Period, '<=%1', DATE2DMY(Paystatus."Payroll Date", 2));
        //Added in order to consider only months <= month(Payroll date) - 27.02.2018 : AIM -
        if PayParam."No Income Tax Retro" then
            PayLedgerEntryTEMP.SetFilter("Payroll Date", '=%1', Paystatus."Payroll Date");
        PayLedgerEntryTEMP.SETRANGE(Open, false);
        if PayLedgerEntryTEMP.FIND('-') then
            repeat
                TotalTaxablePay := TotalTaxablePay + PayLedgerEntryTEMP."Taxable Pay"; // Get total posted taxable amount for current year
                TotalTaxPaid := TotalTaxPaid + PayLedgerEntryTEMP."Tax Paid"; // Get total tax paid for current year
            until PayLedgerEntryTEMP.NEXT = 0;

        CLEAR(PayLedgerEntryTEMP);
        PayLedgerEntryTEMP.SETCURRENTKEY("Entry No.");

        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM +
        //PayLedgerEntryTEMP.SETRANGE("Current Year",TRUE);
        PayLedgerEntryTEMP.SETRANGE("Tax Year", DATE2DMY(Paystatus."Payroll Date", 3));
        //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM -

        PayLedgerEntryTEMP.SETRANGE("Employee No.", PayEmployee."No.");
        PayLedgerEntryTEMP.SETRANGE(Open, false);

        //Added in order to exclude un-declared records - 06.06.2016 : AIM +
        PayLedgerEntryTEMP.SETFILTER(Declared, '%1|%2', PayLedgerEntryTEMP.Declared::Declared, PayLedgerEntryTEMP.Declared::"Non-NSSF");
        //Added in order to exclude un-declared records - 06.06.2016 : AIM -

        //Added in order to consider only months <= month(Payroll date) - 27.02.2018 : AIM +
        PayLedgerEntryTEMP.SETFILTER(PayLedgerEntryTEMP.Period, '<=%1', DATE2DMY(Paystatus."Payroll Date", 2));
        //Added in order to consider only months <= month(Payroll date) - 27.02.2018 : AIM -
        if PayParam."No Income Tax Retro" then
            PayLedgerEntryTEMP.SetFilter("Payroll Date", '=%1', Paystatus."Payroll Date");
        //PayLedgerEntryTEMP.SETRANGE(PayLedgerEntryTEMP."Payment Category",PayLedgerEntryTEMP."Payment Category"::Basic);
        if PayLedgerEntryTEMP.FIND('-') then
            repeat
                //Modified in order to take the real Free Pay as saved in table - 01.07.2016 : AIM +
                //TotalFreePay := TotalFreePay +  PayLedgerEntryTEMP."Exempt Tax"/12;  //Get total tax deductions for current year
                TotalFreePay := TotalFreePay + PayLedgerEntryTEMP."Free Pay";
                //Modified in order to take the real Free Pay as saved in table - 01.07.2016 : AIM -

                //Added to ignore Sub Payroll in month count - 27.02.2018 : AIM +
                IF PayLedgerEntryTEMP."Sub Payroll Code" = '' THEN BEGIN
                    //Added to ignore Sub Payroll in month count - 27.02.2018 : AIM -
                    //Modified in order to calculate Income Tax according to Employment and Termination Date - 30.05.2016 : AIM +
                    //TotalMonth := TotalMonth + 1;
                    if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                        TotalMonth := TotalMonth + (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                                     / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3)));
                    end
                    else begin
                        TotalMonth := TotalMonth + 1;
                    end;
                    //Modified in order to calculate Income Tax according to Employment and Termination Date - 30.05.2016 : AIM -
                    //Added to ignore Sub Payroll in month count - 27.02.2018 : AIM +
                END;
            //Added to ignore Sub Payroll in month count - 27.02.2018 : AIM -

            until PayLedgerEntryTEMP.NEXT = 0;

        CurrTaxableAmount := V_CalcNetTaxSalary + TotalTaxablePay - TotalFreePay;


        //Modified in order to consider the case where TotalMonth is zero - 30.05.2016: AIM +
        if TotalMonth = 0 then begin
            //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM +
            if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                TotalMonth := PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                             / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3));
            end;

            //Modified in order to calculate Income Tax according to Employment and Termination Date - 14.04.2016 : AIM -
        end;
        //Modified in order to consider the case where TotalMonth is zero - 30.05.2016: AIM -

        // apply Tax Bands
        PayParam.GET;
        IF PayParam."Tax Bands Decision Date" <> 0D THEN BEGIN
            Loop := 1;
            while Loop <= 2 do begin
                LastBand := false;
                Computed := false;
                if Loop = 1 then
                    Remainder := V_NetTaxSalary
                else
                    Remainder := V_CalcNetTaxSalary;
                TaxBand.SETRANGE(Date, PayParam."Tax Bands Decision Date");
                IF TaxBand.FINDFIRST THEN
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
        End
        ELSE BEGIN
            Loop := 1;
            WHILE Loop <= 2 DO BEGIN
                LastBand := FALSE;
                Computed := FALSE;
                IF Loop = 1 THEN
                    Remainder := V_NetTaxSalary
                ELSE
                    Remainder := V_CalcNetTaxSalary;
                TaxBand.SETFILTER(Date, '%1', 0D);
                IF TaxBand.FINDFIRST THEN
                    REPEAT
                        IF Remainder >= TaxBand."Annual Bandwidth" / TaxPeriod THEN BEGIN
                            Computed := TRUE;
                            Remainder := Remainder - TaxBand."Annual Bandwidth" / TaxPeriod;
                            IF Loop = 1 THEN
                                V_PayeTax := V_PayeTax + (TaxBand."Annual Bandwidth" / TaxPeriod) * (TaxBand.Rate / 100)
                            ELSE
                                V_CalcPayeTax := V_CalcPayeTax + (TaxBand."Annual Bandwidth" / TaxPeriod) * (TaxBand.Rate / 100);
                        END ELSE BEGIN
                            LastBand := TRUE;
                            IF Remainder > 0 THEN BEGIN
                                IF Loop = 1 THEN
                                    V_PayeTax := V_PayeTax + (Remainder * (TaxBand.Rate / 100))
                                ELSE
                                    V_CalcPayeTax := V_CalcPayeTax + (Remainder * (TaxBand.Rate / 100));
                            END;
                        END;
                    UNTIL (TaxBand.NEXT = 0) OR (LastBand);
                Loop := Loop + 1;
            END;
        END;
        //*************************************TxBnd******************************************
        V_CalcPayeTax := PayrollFunctions.RoundingAmt(V_CalcPayeTax, false);
        V_CalcPayeTax := V_CalcPayeTax - TotalTaxPaid;
        V_CalcPayeTax := V_CalcPayeTax - (V_CalcPayeTax * TaxDiscountPerc / 100); //20180524-TarekH+- Added for Egypt Payroll Law

        //CORE_ Update Income tax amount in case Income Tax Manual Amount Field is greater than zero
        /*IF PayEmployee."Manual Income Tax" > 0 THEN
           V_CalcPayeTax := PayEmployee."Manual Income Tax";
           */
        //CORE+

        //CORE_ Update Income tax amount in case calculated amount is less than zero
        if V_CalcPayeTax < 0 then
            V_CalcPayeTax := 0;
        //CORE+


        //Added in order to prevent wrong NET Pay due to rounded Income tax - 07.03.2016 : AIM +
        OriTax := V_CalcPayeTax;
        //Added in order to prevent wrong NET Pay due to rounded Income tax - 07.03.2016 : AIM -

        //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM +
        //V_CalcPayeTax :=ROUND(V_CalcPayeTax,1000,'>');//EDM.IT+- PayrollFunctions.RoundingAmt(V_CalcPayeTax,TRUE);
        V_CalcPayeTax := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
        //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM +
        //EDM.IT++
        if PayEmployee.Declared = PayEmployee.Declared::Contractual then begin
            PayParam.GET;
            V_CalcPayeTax := V_TaxableSalary * PayParam."Contractual Tax %" / 100;
            //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM +
            //V_CalcPayeTax :=ROUND(V_CalcPayeTax,1000,'>');
            V_CalcPayeTax := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
            //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM -
        end;
        //EDM.IT--

        PayDetailLine.INIT;
        PayElement.GET(PayParam."Income Tax Code");

        PayDetailLine.Amount := Round(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
        PayDetailLine."Calculated Amount" := Round(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');

        InsertPayDetailLine(PayElement.Code, '');
        if not PayElement."Not Included in Net Pay" then
            //Changed in order to prevent wrong NET Pay due to rounded Income tax  - 07.03.2016 : AIM +
            //SumUpAllowDeduct(PayElement,PayDetailLine."Calculated Amount",0,0,'')
            SumUpAllowDeduct(PayElement, OriTax, 0, 0, '')
        //Changed in order to prevent wrong NET Pay due to rounded Income tax  - 07.03.2016 : AIM +
        else
            V_TaxDeductions := PayDetailLine."Calculated Amount";

        //Added in order to consider the case of a special Insurance Calculation (Spinneys) - 04.11.2016 : AIM +
        CalculateInsuranceTax(PayEmployee."No.", V_CalcExemptTax, V_TaxableSalary);
        //Added in order to consider the case of a special Insurance Calculation (Spinneys) - 04.11.2016 : AIM -

    end;

    local procedure CalculateNetPay();
    var
        PayrollParameterRec: Record "Payroll Parameter";
    begin

        //Added in order to re-calculate Totals in order to prevent wrong NET Pay - 11.08.2016 : AIM +
        FixTotals;
        //Added in order to re-calculate Totals in order to prevent wrong NET Pay - 11.08.2016 : AIM -

        // Net Pay = Gross Pay minus Deductions
        //EDM.IT+-
        //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM +
        //V_NetSalary := ROUND( V_Allowances - V_Deductions,1000,'=');
        V_NetSalary := ROUND(V_Allowances - V_Deductions, GetPayrollNETPrecision(), '=');
        //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM +
        V_Rounding := V_NetSalary - (V_Allowances - V_Deductions);
        VA_NetSalary := VA_Allowances - VA_Deductions;
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
            "Period Start Date" := Paystatus."Period Start Date";
            "Period End Date" := Paystatus."Period End Date";
            "Document No." := PayrollNo;
            Description := PayrollTitle;
            "Shortcut Dimension 1 Code" := PayEmployee."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PayEmployee."Global Dimension 2 Code";
            "Gross Pay" := V_Allowances;
            "Taxable Pay" := V_TaxableSalary;
            "Tax Paid" := V_CalcPayeTax;
            //EDM.IT+
            "Income Tax" := V_CalcPayeTax;
            "Working Days" := NumberofWorkingDays;//IT++---EmploymentType."No. of Working Days";
                                                  //EDM.IT-

            "Net Pay" := V_NetSalary;
            "Pay Frequency" := PayEmployee."Pay Frequency";
            "Free Pay" := V_CalcExemptTax;
            "Exempt Tax" := V_YearlyExemptTax;
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
            "Income Tax Retro" := PayDetailHeader."Overtime Days";//EDM030711+-
                                                                  //EDM.IT+
            Rounding := V_NetSalary - (V_Allowances - V_Deductions);
            //EDM.IT-

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
            //EDM.IT+
            "Income Tax" := V_EmployeePensionAbove;
            "Family Allowance Retroactive" := V_EmployerPensionAbove;
            //EDM.IT-
            "Exchange Rate" := Paystatus."Exchange Rate";
            "Employment Type Code" := PayEmployee."Employment Type Code";
            "Social Status" := PayEmployee."Social Status";
            "Spouse Secured" := PayEmployee."Spouse Secured";
            "Husband Paralysed" := PayEmployee."Husband Paralyzed";
            Foreigner := PayEmployee.Foreigner;
            Declared := PayEmployee.Declared;
            // Modified in order to use the new function GetNoOfEligibleChilds - 13.02.2016 : AIM +
            //"Eligible Children Count" := PayrollFunctions.GetNoOfEligibleChilds(PayEmployee );
            "Eligible Children Count" := PayrollFunctions.GetNoOfEligibleChilds(PayEmployee, 0, Paystatus."Period End Date");
            // Modified in order to use the new function GetNoOfEligibleChilds - 13.02.2016 : AIM -
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
                        // Replaced in order to work on the new concept - 19.02.2016 : AIM +
                        //EmpAbsEntitle.CALCFIELDS(Taken);
                        //V_VacationBalance := V_VacationBalance + (EmpAbsEntitle.Entitlement - EmpAbsEntitle.Taken);
                        V_VacationBalance := PayrollFunctions.GetEmpAbsenceEntitlementCurrentBalance(PayEmployee."No.", CauseOfAbsence.Code, 0D);
                        // Replaced in order to work on the new concept - 19.02.2016 : AIM -
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
            "Total Salary for NSSF" := V_NSSFSalary;
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
        AdminFeesPerc: Decimal;
        L_NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5";
        NSSFSalary: Decimal;
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        // Insert Special Pay Elements :

        // 1.Attendance with Associated PYE
        CauseOfAbsence.RESET;
        CauseOfAbsence.SETFILTER("Associated Pay Element", '<>%1', '');
        IF CauseOfAbsence.FINDFIRST THEN
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
                        InsertOvertimePayDetailLine(PayElement, CauseOfAbsence);

                    CauseOfAbsence."Transaction Type"::Salary:
                        PayElement2.GET(PayParam."Basic Pay Code");
                END; //case abs trx.type

                //py2.0+
                IF (CauseOfAbsence."Transaction Type" = CauseOfAbsence."Transaction Type"::Overtime) AND
                  ((PayDetailLine.Amount <> 0) OR (PayDetailLine."Amount (ACY)" <> 0)) THEN BEGIN
                    IF GetSplitLineNo(PayParam."Basic Pay Code") <> 0 THEN BEGIN
                        SplitOvertime(IsOTUnpaidHours, HoursinDay, PayDetailLine."Line No.");
                    END ELSE BEGIN
                        V_OvertimePay := V_OvertimePay + PayDetailLine.Amount;
                        ACY_OvertimePay := ACY_OvertimePay + PayDetailLine."Amount (ACY)";
                    END; //upd.pay.ledg
                END;//split overtime
                    //py2.0-
            UNTIL CauseOfAbsence.NEXT = 0; // Overtime

        //***********Added in order to insert Salary Deduction as a seperate Pay Element - 22.03.2016 : AIM+
        InsertSalaryAbsenceDeductionPayDetailLine();
        InsertLateArriveDeductionPayDetailLine();
        //***********Added in order to insert Salary Deduction as a seperate Pay Element - 22.03.2016 : AIM-

        // 2.Pension Scheme with Associated PYE
        IF PayEmployee.Declared = PayEmployee.Declared::Declared THEN BEGIN
            CalculateSalaryNSSF(); // Added in order to calculate the Salary to use for NSSF - 13.02.2016 : AIM +-

            PensionScheme.RESET;
            PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
            PensionScheme.SETRANGE("Manual Pension", FALSE);
            //Added to order to prevent pension schemes of Return Tax and Return MHOOD - 24.08.2016 : AIM +
            PensionScheme.SETFILTER(PensionScheme.Type, '<>%1 & <>%2 & <>%3 & <>%4 & <>%5 & <>%6 & <>%7 & <>%8 & <>%9', PensionScheme.Type::ReturnTax, PensionScheme.Type::ReturnMH, PensionScheme.Type::"FundContribution-Basic", PensionScheme.Type::"FundContribution-Net",
            PensionScheme.Type::GOSI, PensionScheme.Type::Medical, PensionScheme.Type::IQAMA, PensionScheme.Type::VacTickets, PensionScheme.Type::Baladiyah);
            //Added to order to prevent pension schemes of Return Tax and Return MHOOD - 24.08.2016 : AIM -

            //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM +
            PensionScheme.SETRANGE("Payroll Posting Group", PayEmployee."Posting Group");//Ibrahim+-
                                                                                         //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM -

            IF PensionScheme.FINDFIRST THEN
                REPEAT
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
                        //add in order to consider maximun age in validation - 22.12.2016 : AIM -
                        PayDetailLine.INIT;
                        IF PayrollFunctions.PensionApplicable(NSSFSalary, PayEmployee, PensionScheme) THEN BEGIN
                            PayElementCode := PensionScheme."Associated Pay Element";
                            PayElement.GET(PayElementCode);
                            IF PensionScheme."Employee Contribution %" <> 0 THEN BEGIN
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2+
                                IF PensionScheme.Type = PensionScheme.Type::MHOOD THEN
                                    PayDetailLine.Amount := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::MHOOD2, FALSE)
                                ELSE BEGIN
                                    // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2-
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
                                IF NOT PayEmployee.IsForeigner THEN BEGIN
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
                                END // employer
                                ELSE
                                    //Coders++ 06-07-2021
                                    IF PayEmployee.IsForeigner then begin
                                        IF (PensionScheme.Type = PensionScheme.Type::MHOOD) OR
                                        (PensionScheme.Type = PensionScheme.Type::FAMSUB) OR
                                        (PensionScheme.Type = PensionScheme.Type::EOSIND) THEN BEGIN
                                            IF PensionScheme.Type = PensionScheme.Type::MHOOD THEN
                                                PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::MHOOD7, FALSE)
                                            ELSE
                                                IF PensionScheme.Type = PensionScheme.Type::FAMSUB THEN
                                                    PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::FAMSUB6, FALSE)
                                                ELSE
                                                    IF PensionScheme.Type = PensionScheme.Type::EOSIND THEN begin
                                                        IF PayEmployee.Foreigner = PayEmployee.Foreigner::"End of Service" then
                                                            PayDetailLine."Employer Amount" := PayrollFunctions.CalculateEmployeeNSSFContribution(PayEmployee."No.", Paystatus."Period End Date", NSSFSalary, L_NSSFType::"EOS8.5", FALSE)
                                                    end;
                                        END
                                        ELSE BEGIN
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
                                    end;
                                //Coders-- 06-07-2021
                            END;//+---
                            PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                            InsertPayDetailLine(PayElementCode, '');
                            IF NOT PayElement."Not Included in Net Pay" THEN
                                SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
                        END;
                        //add in order to consider maximun age in validation - 22.12.2016 : AIM +
                    END;
                //add in order to consider maximun age in validation - 22.12.2016 : AIM -

                UNTIL PensionScheme.NEXT = 0; // Pension

            // 2.1 Manual Pension Scheme with Associated PYE
            PensionScheme.RESET;
            PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
            PensionScheme.SETRANGE("Manual Pension", TRUE);
            PensionScheme.SETRANGE("Pension Payroll Date", PayrollDate);
            //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM +
            PensionScheme.SETRANGE("Payroll Posting Group", PayEmployee."Posting Group");//Ibrahim+-
                                                                                         //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM -
                                                                                         //Added to order to prevent pension schemes of Return Tax and Return MHOOD - 24.08.2016 : AIM +
            PensionScheme.SETFILTER(PensionScheme.Type, '<>%1 & <>%2 & <>%3 & <>%4', PensionScheme.Type::ReturnTax, PensionScheme.Type::ReturnMH, PensionScheme.Type::"FundContribution-Basic", PensionScheme.Type::"FundContribution-Net");
            //Added to order to prevent pension schemes of Return Tax and Return MHOOD - 24.08.2016 : AIM -
            IF PensionScheme.FINDFIRST THEN
                REPEAT
                    //add in order to consider maximun age in validation - 22.12.2016 : AIM +
                    IF (PensionScheme."Maximum Applicable Age" = 0) OR (PayrollFunctions.GetEmployeeAge(PayDetailHeader."Employee No.", Paystatus."Payroll Date") <= PensionScheme."Maximum Applicable Age") THEN BEGIN
                        //add in order to consider maximun age in validation - 22.12.2016 : AIM -
                        PayDetailLine.INIT;
                        IF PayrollFunctions.PensionApplicable(NSSFSalary, PayEmployee, PensionScheme) THEN BEGIN
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
                                // Replaced in order to consider Employment-Termination date - 22.09.2017 : A2-
                                V_EmployeePension := Round(V_EmployeePension + PayDetailLine.Amount, PayrollFunctions.GetNSSFPrecision(), '>');
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
                            PayDetailLine."Manual Pay Line" := TRUE;
                            InsertPayDetailLine(PayElementCode, '');
                            IF NOT PayElement."Not Included in Net Pay" THEN
                                SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
                        END;
                        //add in order to consider maximun age in validation - 22.12.2016 : AIM +
                    END;
                //add in order to consider maximun age in validation - 22.12.2016 : AIM -
                UNTIL PensionScheme.NEXT = 0; // Pension
        END;//EDM.IT+++---
            //MB0307-
            //Pension Amounts
            // 3. Employee Loan
        EmployeeLoan.RESET;
        PayEmployee.CALCFIELDS("Outstanding Loans");
        IF PayEmployee."Outstanding Loans" THEN
            WITH EmployeeLoan DO BEGIN
                RESET;
                SETFILTER("Date of Loan", '<=%1', PayrollDate); //Added If Another Loan entered
                SETRANGE("Employee No.", PayEmployee."No.");
                SETRANGE(Completed, FALSE);
                SETFILTER("Associated Pay Element", '<>%1', '');
                IF FINDFIRST THEN
                    REPEAT
                        EmployeeLoanLine.SETRANGE("Employee No.", "Employee No.");
                        EmployeeLoanLine.SETRANGE("Loan No.", "Loan No.");
                        EmployeeLoanLine.SETRANGE(Completed, FALSE);
                        EmployeeLoanLine.SETFILTER("Payment Date", '<=%1', PayrollDate);
                        //Modified in order to consider all loan details which are <= Payroll Date - 23.01.2017 :AIM +
                        TempPayment := 0;
                        IF EmployeeLoanLine.FINDFIRST THEN
                            REPEAT
                                TempPayment := TempPayment + EmployeeLoanLine."Payment Amount";
                            UNTIL EmployeeLoanLine.NEXT = 0;
                        //Modified in order to consider all loan details which are <= Payroll Date - 23.01.2017 :AIM -

                        RemainingPayment := Amount - "Total Payments Made";

                        IF (TempPayment > RemainingPayment) OR (PayEmployee.Status = PayEmployee.Status::Terminated) THEN
                            TempPayment := RemainingPayment;

                        IF TempPayment <> 0 THEN BEGIN
                            PayDetailLine.INIT;
                            PayElementCode := "Associated Pay Element";
                            PayElement.GET(PayElementCode);
                            IF NOT "In Additional Currency" THEN BEGIN
                                V_EmployeeLoan := V_EmployeeLoan + TempPayment;
                                PayDetailLine."Loan No." := EmployeeLoan."Loan No.";
                                PayDetailLine.Amount := TempPayment;
                                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                                V_OutstandingLoan := V_OutstandingLoan + RemainingPayment - TempPayment;
                            END ELSE BEGIN
                                VA_EmployeeLoan := VA_EmployeeLoan + TempPayment;
                                PayDetailLine."Amount (ACY)" := TempPayment;
                                PayDetailLine."Calculated Amount (ACY)" := PayDetailLine."Amount (ACY)";
                                ACY_OutstandingLoan := ACY_OutstandingLoan + RemainingPayment - TempPayment;
                            END;
                            InsertPayDetailLine(PayElementCode, '');
                            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
                        END;
                    UNTIL NEXT = 0;
            END; // emp. loan

        // 4. Days-Off Transportation
        //Modified in order to discard error in case the Pay element of "Days-Off Transportation" is not set in order not to add PayDetailHeader."Days-Off Transportation" to Pay Details - 01.06.2016 : AIM +
        IF (PayDetailHeader."Days-Off Transportation" <> 0) AND (PayParam."Day-Off Transportation" <> '') THEN BEGIN
            //Modified in order to discard error in case the Pay element of "Days-Off Transportation" is not set in order not to add PayDetailHeader."Days-Off Transportation" to Pay Details - 01.06.2016 : AIM -
            PayDetailLine.INIT;
            PayElementCode := PayParam."Day-Off Transportation";
            PayElement.GET(PayElementCode);
            IF (ACYComp_AttendanceDays) AND (InBothccy) THEN BEGIN
                V_Amount := ACY_TransportationPerDay * PayDetailHeader."Days-Off Transportation";
                PayDetailLine."Amount (ACY)" := PayrollFunctions.RoundingAmt(V_Amount, TRUE);
                PayDetailLine."Calculated Amount (ACY)" := PayDetailLine."Amount (ACY)";
            END;  //Off-Days ot-acy.E
            IF ((NOT ACYComp_AttendanceDays) OR (InBaseccy) OR (InAddccy)) THEN BEGIN
                IF V_BasicPay <> 0 THEN BEGIN
                    V_Amount := LCY_TransportationPerDay * PayDetailHeader."Days-Off Transportation";
                    PayDetailLine.Amount := V_Amount;
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                END;

                IF VA_Salary <> 0 THEN BEGIN
                    V_Amount := ACY_TransportationPerDay * PayDetailHeader."Days-Off Transportation";
                    PayDetailLine."Amount (ACY)" := PayrollFunctions.RoundingAmt(V_Amount, true);
                    PayDetailLine."Calculated Amount (ACY)" := PayDetailLine."Amount (ACY)";
                end;
            end; // not acy.comp
            InsertPayDetailLine(PayElementCode, '');
            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
        end; //off-days trsp.
             //edm.sc+
        OnAfterInsertSpePayE(PayEmployee, PayrollDate, PayLedgEntryNo, TaxYear, PeriodNo, Paystatus);
        //edm.sc-        

    end;

    procedure InsertPayDetailLine(P_PayECode: Code[10]; PayCodeDescription: Text[30]);
    var
        LineNo: Integer;
    begin
        if (PayDetailLine.Amount = 0) and (PayDetailLine."Amount (ACY)" = 0) and (PayDetailLine."Employer Amount" = 0) then
            exit;

        //******Added in order to prevent Record duplicates - 15.02.2016 : AIM +
        if PayElementExistsInPayDetails(PayEmployee."No.", TaxYear, PeriodNo, PayrollDate, P_PayECode, PayElement.Type, PayEmployee."Payroll Group Code") = true then
            exit;
        //******Added in order to prevent Record duplicates - 15.02.2016 : AIM -

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
    var
        PayrollParameterRec: Record "Payroll Parameter";
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
                        V_HCL := Amount;
                        ACY_HCL := "Amount (ACY)";
                    end;
                    "Calculated Amount" := Amount;
                    "Calculated Amount (ACY)" := "Amount (ACY)";
                    //Syria+
                    /*
                    AttendanceDaysAffected := GetAffectedAttendanceTransport(PayEmployee,
                       Paystatus."Period Start Date",Paystatus."Period End Date",
                       Paystatus."Period Start Date",Paystatus."Period End Date");
                    IF PayElement."Days in  Month" > 0 THEN BEGIN
                      "Calculated Amount" := Amount - (Amount / PayElement."Days in  Month" * AttendanceDaysAffected);
                      "Calculated Amount (ACY)" := "Amount (ACY)"- ("Amount (ACY)"/ PayElement."Days in  Month" * AttendanceDaysAffected);
                    END ELSE BEGIN
                      "Calculated Amount" := Amount - (Amount * AttendanceDaysAffected
                           / PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee));
                      "Calculated Amount (ACY)" := "Amount (ACY)"- ("Amount (ACY)" * AttendanceDaysAffected
                           /PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee));
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
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        //EmpJnlLine.SETFILTER("Transaction Date",'%1..%2',Paystatus."Period Start Date",Paystatus."Period End Date");
        EmpJnlLine.SETFILTER("Transaction Date", '%1..%2', G_AttStartDate, G_AttEndDate);
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-
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
        EmpJnlLine.SETFILTER("Transaction Date", '%1..%2', Paystatus."Period Start Date", Paystatus."Period End Date");
        EmpJnlLine.SETRANGE(Processed, false);
        EmpJnlLine.SETRANGE(Split, true);
        EmpJnlLine2.COPY(EmpJnlLine);
        EmpJnlLine2.MODIFYALL("Payroll Ledger Entry No.", PayLedgEntryNo);
    end;

    procedure GetEffectiveWorkDays();
    var
        NoofNonWD: Integer;
    begin
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        if (G_IsSeparateAttendanceInterval = false) or (G_AttStartDate = 0D) or (G_AttEndDate = 0D) then begin
            WrkDays := Paystatus."Period End Date" - Paystatus."Period Start Date" + 1;
            NoofNonWD := HRFunctions.GetNonWD(EmploymentType."Base Calendar Code", Paystatus."Period Start Date", Paystatus."Period End Date");
        end
        else begin
            WrkDays := G_AttEndDate - G_AttStartDate + 1;
            NoofNonWD := HRFunctions.GetNonWD(EmploymentType."Base Calendar Code", G_AttStartDate, G_AttEndDate);
        end;
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-
        WrkDays := WrkDays - NoofNonWD;
    end;

    procedure ChkDailyBasisContract();
    var
        Contracts: Record "Employment Contract";
        mont: Integer;
    begin
        /*EmpContracts.SETRANGE("Employee No.",PayEmployee."No.");
        EmpContracts.SETFILTER(EmpContracts."Valid From",'<=%1',Paystatus."Payroll Date");
        EmpContracts.SETFILTER(EmpContracts."Valid To",'>=%1',Paystatus."Payroll Date");
        IF EmpContracts.FIND('-') THEN
          REPEAT
            Contracts.GET(EmpContracts."Employment Contract Code");
            IF Contracts.Type = Contracts.Type::"1" THEN BEGIN
              DailyBasis := TRUE;
              EXIT;
            END;
          UNTIL EmpContracts.NEXT = 0;                    */

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
                    Date1 := Paystatus."Period Start Date";
                    Date2 := Paystatus."Period End Date";
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
                            Date1 := Paystatus."Period Start Date";
                            Date2 := Paystatus."Period End Date";
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
                TempSplitPayDetLine."Transaction Date" := Paystatus."Period Start Date";
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
                    TempSplitPayDetLine."Starting Split Date" := Paystatus."Period Start Date"
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

    procedure SplitOvertime(P_IsOTunpaidHours: Boolean; P_HoursinDay: Decimal; P_PayDetLineNo: Integer);
    var
        PayDetLn: Record "Pay Detail Line";
        SplitPayDetLn: Record "Split Pay Detail Line";
        SplitPayDetLn2: Record "Split Pay Detail Line";
        PayDetHeader: Record "Pay Detail Header";
        OTAmtLCY: Decimal;
        OTAmtACY: Decimal;
        OTHours: Decimal;
        DaysinMonth: Decimal;
        NonWD: Decimal;
        LnNo: Integer;
        SumOTAmtLCY: Decimal;
        SumOTAmtACY: Decimal;
        SumNbDays: Integer;
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        //py2.0
        SplitPayDetLn.SETRANGE("Employee No.", PayEmployee."No.");
        SplitPayDetLn.SETRANGE("Pay Detail Line No.", GetSplitLineNo(PayParam."Basic Pay Code"));
        SplitPayDetLn.SETFILTER("Efective Nb. of Days", '<>0');
        if SplitPayDetLn.FIND('-') then
            repeat
                PayDetHeader.GET(PayEmployee."No.");
                PayDetHeader.SETFILTER("Date Filter", '%1..%2', SplitPayDetLn."Starting Split Date", SplitPayDetLn."Ending Split Date");
                if not P_IsOTunpaidHours then begin
                    PayDetHeader.CALCFIELDS("Overtime Hours");
                    OTHours := PayDetHeader."Overtime Hours";
                end else begin
                    PayDetHeader.CALCFIELDS("Overtime with Unpaid Hours");
                    OTHours := PayDetHeader."Overtime with Unpaid Hours";
                end;
                if OTHours <> 0 then begin
                    NonWD := HRFunctions.GetNonWD(EmploymentType."Base Calendar Code", Paystatus."Period Start Date", Paystatus."Period End Date");
                    DaysinMonth := Paystatus."Period End Date" - Paystatus."Period Start Date" + 1 - NonWD;
                    if SplitPayDetLn.Amount <> 0 then begin
                        OTAmtLCY := SplitPayDetLn.Amount / DaysinMonth;
                        OTAmtLCY := OTAmtLCY / P_HoursinDay;
                        OTAmtLCY := OTAmtLCY * OTHours;
                        OTAmtLCY := PayrollFunctions.RoundingAmt(OTAmtLCY, false);
                    end;//lcy
                    if SplitPayDetLn."Amount (ACY)" <> 0 then begin
                        OTAmtACY := SplitPayDetLn."Amount (ACY)" / DaysinMonth;
                        OTAmtACY := OTAmtACY / P_HoursinDay;
                        OTAmtACY := OTAmtACY * OTHours;
                        OTAmtACY := PayrollFunctions.RoundingAmt(OTAmtACY, true);
                    end;//acy
                    if (OTAmtLCY <> 0) or (OTAmtACY <> 0) then begin
                        SplitPayDetLn2.INIT;
                        SplitPayDetLn2.TRANSFERFIELDS(SplitPayDetLn);
                        LnNo := LnNo + 1;
                        SplitPayDetLn2."Line No." := LnNo;
                        SplitPayDetLn2."Pay Detail Line No." := P_PayDetLineNo;
                        SplitPayDetLn2.Amount := OTAmtLCY;
                        SplitPayDetLn2."Calculated Amount" := OTAmtLCY;
                        SplitPayDetLn2."Amount (ACY)" := OTAmtACY;
                        SplitPayDetLn2."Calculated Amount (ACY)" := OTAmtACY;
                        SplitPayDetLn2.INSERT;
                        SumOTAmtLCY := SumOTAmtLCY + OTAmtLCY;
                        SumOTAmtACY := SumOTAmtACY + OTAmtACY;
                        SumNbDays := SumNbDays + SplitPayDetLn2."Efective Nb. of Days";
                    end;//ins. split ot.
                end;//ot.hours <> 0
            until SplitPayDetLn.NEXT = 0; //split basic pay entries

        //updt pay det. line
        if (SumOTAmtLCY <> 0) or (SumOTAmtACY <> 0) then begin
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
            PayDetailLine.SETRANGE("Line No.", P_PayDetLineNo);
            if PayDetailLine.FIND('-') then begin
                PayDetailLine.Amount := SumOTAmtLCY;
                PayDetailLine."Calculated Amount" := SumOTAmtLCY;
                PayDetailLine."Amount (ACY)" := SumOTAmtACY;
                PayDetailLine."Calculated Amount (ACY)" := SumOTAmtACY;
                PayDetailLine."Efective Nb. of Days" := SumNbDays;
                PayDetailLine.MODIFY;
            end;
        end;//updt paydet.

        //updt pay ledg. entry
        V_OvertimePay := V_OvertimePay + SumOTAmtLCY;
        ACY_OvertimePay := ACY_OvertimePay + SumOTAmtACY;
    end;

    procedure GetSplitLineNo(P_PayECode: Code[10]): Integer;
    var
        PayDetLn: Record "Pay Detail Line";
        SplitPayDetLn: Record "Split Pay Detail Line";
    begin
        //py2.0
        PayDetLn.SETCURRENTKEY("Employee No.", Open, Type, "Pay Element Code");
        PayDetLn.SETRANGE("Employee No.", PayEmployee."No.");
        PayDetLn.SETRANGE(Open, true);
        PayDetLn.SETRANGE("Pay Element Code", P_PayECode);
        if PayDetLn.FIND('-') then begin
            SplitPayDetLn.SETRANGE("Employee No.", PayEmployee."No.");
            SplitPayDetLn.SETRANGE("Pay Detail Line No.", PayDetLn."Line No.");
            if SplitPayDetLn.FIND('-') then
                exit(SplitPayDetLn."Pay Detail Line No.");
        end;
    end;

    procedure GetAffectedAttendance(Employee: Record Employee; FromDate: Date; ToDate: Date; PayrollFromDate: Date; PayrollToDate: Date): Decimal;
    var
        EmployeeJournalLine: Record "Employee Journal Line";
        PayrollFunctions: Codeunit "Payroll Functions";
        SumDaysOff: Decimal;
    begin
        SumDaysOff := 0;
        EmployeeJournalLine.SETCURRENTKEY("Employee No.", Type, Processed, "Document Status", Converted, "Ending Date",
                            "Affect Work Days", "Affect Attendance Days", "Absence Transaction Type", "Unit of Measure Code",
                            "Associate Pay Element", "Transaction Date", Entitled, Reseted);
        EmployeeJournalLine.SETRANGE("Employee No.", Employee."No.");
        EmployeeJournalLine.SETRANGE(Type, 'Absence');
        EmployeeJournalLine.SETRANGE(Processed, false);
        EmployeeJournalLine.SETRANGE("Document Status", EmployeeJournalLine."Document Status"::Approved);
        EmployeeJournalLine.SETRANGE(Converted, false);
        EmployeeJournalLine.SETRANGE("Affect Attendance Days", true);
        EmployeeJournalLine.SETFILTER("Absence Transaction Type", '<>%1', EmployeeJournalLine."Absence Transaction Type"::Overtime);
        EmployeeJournalLine.SETRANGE("Unit of Measure Code", 'DAY');
        EmployeeJournalLine.SETRANGE("Associate Pay Element", false);
        EmployeeJournalLine.SETFILTER("Transaction Date", '%1..%2', PayrollFromDate, PayrollToDate);
        EmployeeJournalLine.SETRANGE(Entitled, false);
        EmployeeJournalLine.SETRANGE(Reseted, false);
        EmployeeJournalLine.CALCSUMS("Calculated Value");
        if EmployeeJournalLine."Calculated Value" > 0 then
            if EmployeeJournalLine.FIND('-') then
                repeat
                    if (EmployeeJournalLine."Starting Date" <= FromDate) and (EmployeeJournalLine."Ending Date" >= ToDate) then begin
                        SumDaysOff += (PayrollFunctions.GetWorkingDay(FromDate, ToDate, Employee));
                    end else
                        if (EmployeeJournalLine."Starting Date" <= FromDate) and (EmployeeJournalLine."Ending Date" <= ToDate) and
                           (EmployeeJournalLine."Ending Date" >= FromDate) then begin
                            SumDaysOff += (PayrollFunctions.GetWorkingDay(FromDate, EmployeeJournalLine."Ending Date", Employee));
                        end else
                            if (EmployeeJournalLine."Starting Date" >= FromDate) and (EmployeeJournalLine."Starting Date" <= ToDate) and
                               (EmployeeJournalLine."Ending Date" >= ToDate) then begin
                                SumDaysOff += (PayrollFunctions.GetWorkingDay(EmployeeJournalLine."Starting Date", ToDate, Employee));
                            end else
                                if (EmployeeJournalLine."Starting Date" >= FromDate) and (EmployeeJournalLine."Starting Date" <= ToDate) and
                                   (EmployeeJournalLine."Ending Date" <= ToDate) then begin
                                    SumDaysOff += (PayrollFunctions.GetWorkingDay(EmployeeJournalLine."Starting Date",
                                                                               EmployeeJournalLine."Ending Date", Employee));
                                end;
                until EmployeeJournalLine.NEXT = 0;
        exit(SumDaysOff);
    end;

    procedure GetApproNoOfDays(PeriodFrom: Date; PeriodTo: Date; DateFrom: Date; DateTo: Date; NoOfDays: Decimal): Decimal;
    begin
        exit(((DateTo - DateFrom + 1) * NoOfDays) / (PeriodTo - PeriodFrom + 1))
    end;

    procedure GetPayEltDate(SpecPayEltChanges: Record "Specific Pay Elements Changes"; PayStatus: Record "Payroll Status"; var FromDate: Date; var ToDate: Date);
    begin
        if ((SpecPayEltChanges."Date Applicable From" = 0D) or
            (SpecPayEltChanges."Date Applicable From" <= PayStatus."Period Start Date")) and
           (SpecPayEltChanges."Date Applicable To" >= PayStatus."Period End Date") then begin
            FromDate := PayStatus."Period Start Date";
            ToDate := PayStatus."Period End Date"
        end else
            if ((SpecPayEltChanges."Date Applicable From" = 0D) or
                (SpecPayEltChanges."Date Applicable From" <= PayStatus."Period Start Date")) and
               (SpecPayEltChanges."Date Applicable To" < PayStatus."Period End Date") then begin
                FromDate := PayStatus."Period Start Date";
                ToDate := SpecPayEltChanges."Date Applicable To"
            end else
                if ((SpecPayEltChanges."Date Applicable From" = 0D) or
                    (SpecPayEltChanges."Date Applicable From" > PayStatus."Period Start Date")) and
                   (SpecPayEltChanges."Date Applicable From" <= PayStatus."Period End Date") and
                   (SpecPayEltChanges."Date Applicable To" >= PayStatus."Period End Date") then begin
                    if (SpecPayEltChanges."Date Applicable From" = 0D) then
                        FromDate := PayStatus."Period Start Date"
                    else
                        FromDate := SpecPayEltChanges."Date Applicable From";
                    ToDate := PayStatus."Period End Date"
                end else
                    if ((SpecPayEltChanges."Date Applicable From" = 0D) or
                        ((SpecPayEltChanges."Date Applicable From" > PayStatus."Period Start Date") and
                       (SpecPayEltChanges."Date Applicable From" <= PayStatus."Period End Date"))) and
                       (SpecPayEltChanges."Date Applicable To" < PayStatus."Period End Date") then begin
                        if (SpecPayEltChanges."Date Applicable From" = 0D) then
                            FromDate := PayStatus."Period Start Date"
                        else
                            FromDate := SpecPayEltChanges."Date Applicable From";
                        ToDate := SpecPayEltChanges."Date Applicable To"
                    end;
    end;

    procedure CalculatePayEltSpecial(PayDetailHead: Record "Pay Detail Header"; PayDetailLine: Record "Pay Detail Line"; PayElementCode: Code[10]): Decimal;
    var
        FromDate: Date;
        ToDate: Date;
        AttendanceDaysAffected: Decimal;
        DaysToCalculate: Decimal;
        PayDetailHeadSplit: Record "Pay Detail Header";
        L_EmpAddInfo: Record "Employee Additional Info";
        L_ExtraSalary: Decimal;
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        // 10.10.2017 +
        L_ExtraSalary := 0;
        L_EmpAddInfo.SETRANGE("Employee No.", PayEmployee."No.");
        if L_EmpAddInfo.FINDFIRST then
            L_ExtraSalary := L_EmpAddInfo."Extra Salary";
        // 10.10.2017 -

        V_CalculatedAmount := 0;
        VA_CalculatedAmount := 0;
        SpecPayElt.SETCURRENTKEY("Pay Element Code", "Internal Pay Element ID");
        SpecPayElt.SETRANGE("Internal Pay Element ID", PayElementCode);
        SpecPayElt.SETRANGE("Employee Category Code", PayEmployee."Employee Category Code");
        //**1**//
        if SpecPayElt.FIND('-') then begin
            //**2**//
            if SpecPayElt.Splited then begin
            end
            else begin //IF not Splited
                       //**3**//
                if SpecPayElt."Pay Unit" = SpecPayElt."Pay Unit"::Monthly then begin
                    //**4**//
                    // Added in order to set a suitable "Days in Month" - 04.04.2016 : AIM +
                    if PayElement."Days in  Month" = 0 then
                        PayElement."Days in  Month" := 30;
                    // Added in order to set a suitable "Days in Month" - 04.04.2016 : AIM -

                    if PayElement."Days in  Month" <> 0 then begin
                        if SpecPayElt.Amount = 0 then begin
                            //08.06.2017 : AIM +
                            if SpecPayElt."Affected By Presence" = true then begin
                                //08.06.2017 : AIM -
                                //Modified due to wrong calculation - 23.02.2016: AIM +
                                /*LCY_TransportationPerDay := PayEmployee."Basic Pay" *  SpecPayElt."% Basic Pay" /
                                 PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee);
                                ACY_TransportationPerDay := PayEmployee."Salary (ACY)"*  SpecPayElt."% Basic Pay"  /
                                 PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee);*/

                                // Modified because No of Working Days is after deducting Absence days - 29.05.2017 : A2+
                                //IF (NumberofWorkingDays > 0) AND (SpecPayElt."Affected By Presence" = TRUE)  THEN
                                if (NumberofWorkingDays > 0) and (PayElement."Affected By Working Days" = true) then
                                  // Modified because No of Working Days is after deducting Absence days - 29.05.2017 : A2-
                                  begin
                                    // 10.10.2017 : A2-
                                    //LCY_TransportationPerDay := (PayEmployee."Basic Pay" *  (SpecPayElt."% Basic Pay"/100)) /NumberofWorkingDays;
                                    LCY_TransportationPerDay := ((PayEmployee."Basic Pay" + L_ExtraSalary) * (SpecPayElt."% Basic Pay" / 100)) / NumberofWorkingDays;
                                    // 10.10.2017 : A2+
                                    ACY_TransportationPerDay := (PayEmployee."Salary (ACY)" * (SpecPayElt."% Basic Pay" / 100)) / NumberofWorkingDays;
                                end
                                else begin
                                    // 10.10.2017 : A2+
                                    //LCY_TransportationPerDay := (PayEmployee."Basic Pay" *  (SpecPayElt."% Basic Pay"/100)) /PayElement."Days in  Month";
                                    LCY_TransportationPerDay := ((PayEmployee."Basic Pay" + L_ExtraSalary) * (SpecPayElt."% Basic Pay" / 100)) / PayElement."Days in  Month";
                                    // 10.10.2017 : A2-
                                    ACY_TransportationPerDay := (PayEmployee."Salary (ACY)" * (SpecPayElt."% Basic Pay" / 100)) / PayElement."Days in  Month";
                                end;
                                //Modified due to wrong calculation - 23.02.2016: AIM +
                                // 08.06.2017 : AIM +
                            end
                            else begin
                                // 10.10.2017 : A2+
                                //LCY_TransportationPerDay := (PayEmployee."Basic Pay" *  (SpecPayElt."% Basic Pay"/100));
                                LCY_TransportationPerDay := ((PayEmployee."Basic Pay" + L_ExtraSalary) * (SpecPayElt."% Basic Pay" / 100));
                                // 10.10.2017 : A2-
                                ACY_TransportationPerDay := (PayEmployee."Salary (ACY)" * (SpecPayElt."% Basic Pay" / 100));
                            end;
                            // 08.06.2017 : AIM -

                        end
                        else begin
                            // 08.06.2017 : AIM +
                            if SpecPayElt."Affected By Presence" = true then begin
                                // 08.06.2017 : AIM -
                                //++++++//IT++--
                                // Modified in order to have the same working days for both LCY and ACY - 12.02.2016 : AIM +
                                //LCY_TransportationPerDay := SpecPayElt.Amount /NumberofWorkingDays;//+++EmploymentType."No. of Working Days";//EDM.IT2015PayElement."Days in  Month";
                                //ACY_TransportationPerDay := SpecPayElt."Amount (ACY)" /PayElement."Days in  Month";
                                // Modified because No of Working Days is after deducting Absence days - 29.05.2017 : A2+
                                //IF (NumberofWorkingDays > 0 ) AND (SpecPayElt."Affected By Presence" = TRUE)  THEN
                                if (NumberofWorkingDays > 0) and (PayElement."Affected By Working Days" = true) then
                                  // Modified because No of Working Days is after deducting Absence days - 29.05.2017 : A2-
                                  begin

                                    LCY_TransportationPerDay := SpecPayElt.Amount / NumberofWorkingDays;
                                    ACY_TransportationPerDay := SpecPayElt."Amount (ACY)" / NumberofWorkingDays;
                                end
                                else
                                    if PayElement."Days in  Month" > 0 then begin
                                        LCY_TransportationPerDay := SpecPayElt.Amount / PayElement."Days in  Month";
                                        ACY_TransportationPerDay := SpecPayElt."Amount (ACY)" / PayElement."Days in  Month";
                                    end
                                    else begin
                                        LCY_TransportationPerDay := 0;
                                        ACY_TransportationPerDay := 0;
                                    end;
                                // Modified in order to have the same working days for both LCY and ACY - 12.02.2016 : AIM +
                                // 08.06.2017 : AIM +
                            end
                            else begin
                                LCY_TransportationPerDay := SpecPayElt.Amount;
                                ACY_TransportationPerDay := SpecPayElt."Amount (ACY)";
                            end;
                            // 08.06.2017 : AIM -

                        end;
                    end
                    else
                        ERROR('Specify Days in Month for Pay Element :%1', PayElement.Description);
                    //**4**//
                end
                else begin
                    if SpecPayElt.Amount = 0 then begin
                        //Modified due to wrong calculation - 23.02.2016: AIM +
                        /*LCY_TransportationPerDay := PayEmployee."Basic Pay" * SpecPayElt."% Basic Pay";
                        ACY_TransportationPerDay := PayEmployee."Salary (ACY)"* SpecPayElt."% Basic Pay";*/
                        // 10.10.2017 : A2+
                        //LCY_TransportationPerDay := PayEmployee."Basic Pay" * (SpecPayElt."% Basic Pay"/100);
                        LCY_TransportationPerDay := (PayEmployee."Basic Pay" + L_ExtraSalary) * (SpecPayElt."% Basic Pay" / 100);
                        // 10.10.2017 : A2-
                        ACY_TransportationPerDay := PayEmployee."Salary (ACY)" * (SpecPayElt."% Basic Pay" / 100);
                        //Modified due to wrong calculation - 23.02.2016: AIM -
                    end
                    else begin
                        LCY_TransportationPerDay := SpecPayElt.Amount;
                        ACY_TransportationPerDay := SpecPayElt."Amount (ACY)"
                    end;
                end;
                //**3**//




                if SpecPayElt."Affected By Presence" then
                    // Added for Payroll Attendance Interval - 15.09.2017 : A2+
                    /*AttendanceDaysAffected := GetAffectedAttendanceTransport(PayEmployee,Paystatus."Period Start Date",
                                                                             Paystatus."Period End Date",
                                                                             Paystatus."Period Start Date",
                                                                             Paystatus."Period End Date")*/
                      AttendanceDaysAffected := GetAffectedAttendanceTransport(PayEmployee, G_AttStartDate, G_AttEndDate, G_AttStartDate, G_AttEndDate)
                // Added for Payroll Attendance Interval - 15.09.2017 : A2-
                else
                    AttendanceDaysAffected := 0;


                // Added for Payroll Attendance Interval - 15.09.2017 : A2+
                /*IF (NOT ACYComp_AttendanceDays) THEN
                    ACY_CalcNTaxTransp := ACY_TransportationPerDay *
                         PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee)
                ELSE
                     ACY_CalcNTaxTransp := (ACY_TransportationPerDay *
                         PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee)) -
                                  ACY_TransportationPerDay * ABS(AttendanceDaysAffected);*/
                if (not ACYComp_AttendanceDays) then
                    ACY_CalcNTaxTransp := ACY_TransportationPerDay * PayrollFunctions.GetWorkingDay(G_AttStartDate, G_AttEndDate, PayEmployee)
                else
                    ACY_CalcNTaxTransp := (ACY_TransportationPerDay * PayrollFunctions.GetWorkingDay(G_AttStartDate, G_AttEndDate, PayEmployee)) -
                                           ACY_TransportationPerDay * ABS(AttendanceDaysAffected);
                // Added for Payroll Attendance Interval - 15.09.2017 : A2-

                V_NTaxAttendanceDaysAbs := LCY_TransportationPerDay * ABS(AttendanceDaysAffected);
                V_NTaxAttendanceDaysAbs := PayrollFunctions.RoundingAmt(V_NTaxAttendanceDaysAbs, false);
                // 08.06.2017 : AIM +
                if SpecPayElt."Affected By Presence" = true then begin
                    // 08.06.2017 : AIM -

                    if PayElement."Days in  Month" <> 0 then

                        // Modified in order to have the same working days for both LCY and ACY - 12.02.2016 : AIM +
                        // V_CalcNTaxTransp := (LCY_TransportationPerDay * NumberofWorkingDays)//IT++-- EmploymentType."No. of Working Days")//EDM.IT2015PayElement."Days in  Month")
                        //                              - V_NTaxAttendanceDaysAbs
                        if NumberofWorkingDays > 0 then begin
                            //Modified because number of working days already deduct absent days - 08.03.2016 : AIM+
                            //V_CalcNTaxTransp := (LCY_TransportationPerDay * NumberofWorkingDays)  - V_NTaxAttendanceDaysAbs
                            V_CalcNTaxTransp := (LCY_TransportationPerDay * NumberofWorkingDays)
                            //Modified because number of working days already deduct absent days - 08.03.2016 : AIM-
                        end
                        else
                           //Modified in order to consider the case where the employee is absent the whole month working days  - 02.08.2016 : AIM +
                           //V_CalcNTaxTransp := (LCY_TransportationPerDay * PayElement."Days in  Month")  - V_NTaxAttendanceDaysAbs
                           begin
                            if AttendanceDaysAffected > 0 then
                                V_CalcNTaxTransp := 0
                        end
                end
                else begin
                    V_CalcNTaxTransp := LCY_TransportationPerDay;
                    ACY_CalcNTaxTransp := ACY_TransportationPerDay;
                end;
                // 08.06.2017 : AIM -

                V_CalcNTaxTransp := PayrollFunctions.RoundingAmt(V_CalcNTaxTransp, false);
                ACY_CalcNTaxTransp := PayrollFunctions.RoundingAmt(ACY_CalcNTaxTransp, true);
                V_CalculatedAmount := V_CalcNTaxTransp;
                VA_CalculatedAmount := ACY_CalcNTaxTransp;
            end;
            //**2**//

            /*      IF (ToDate < Paystatus."Period End Date") AND (ToDate <> 0D) THEN BEGIN  //syria+-
                    IF SpecPayElt."Pay Unit" = SpecPayElt."Pay Unit"::Monthly THEN BEGIN
                  END;
                END ELSE BEGIN //IF not Splited
                  IF SpecPayElt."Pay Unit" = SpecPayElt."Pay Unit"::Monthly THEN BEGIN
                    IF PayElement."Days in  Month" <> 0 THEN BEGIN
                      IF SpecPayElt.Amount = 0 THEN BEGIN
                        LCY_TransportationPerDay := PayEmployee."Basic Pay" * SpecPayElt."% Basic Pay" /
                         PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee);
                        ACY_TransportationPerDay := PayEmployee."Salary (ACY)"* SpecPayElt."% Basic Pay" /
                         PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee);
                      END ELSE BEGIN
                      LCY_TransportationPerDay := SpecPayElt.Amount /
                       PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee);
                      ACY_TransportationPerDay := SpecPayElt."Amount (ACY)" /
                       PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee)
                      END;
                    END ELSE
                      ERROR('Specify Days in Month for Pay Element :%1',PayElement.Description);
                  END ELSE BEGIN
                    IF SpecPayElt.Amount = 0 THEN BEGIN
                      LCY_TransportationPerDay := PayEmployee."Basic Pay" * SpecPayElt."% Basic Pay";
                      ACY_TransportationPerDay := PayEmployee."Salary (ACY)"* SpecPayElt."% Basic Pay";
                    END ELSE BEGIN
                    LCY_TransportationPerDay := SpecPayElt.Amount;
                    ACY_TransportationPerDay := SpecPayElt."Amount (ACY)"
                  END;
                  END;

                  IF SpecPayElt."Affected By Presence" THEN
                    AttendanceDaysAffected :=GetAffectedAttendanceTransport(PayEmployee,Paystatus."Period Start Date",
                        Paystatus."Period End Date",Paystatus."Period Start Date",Paystatus."Period End Date")
                  ELSE
                    AttendanceDaysAffected := 0;

                  IF (NOT ACYComp_AttendanceDays) THEN
                    ACY_CalcNTaxTransp := ACY_TransportationPerDay *
                          PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee)
                  ELSE
                    ACY_CalcNTaxTransp := (ACY_TransportationPerDay *
                          PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee)) -
                                          ACY_TransportationPerDay * ABS(AttendanceDaysAffected);
                  V_NTaxAttendanceDaysAbs := LCY_TransportationPerDay * ABS(AttendanceDaysAffected);
                  V_NTaxAttendanceDaysAbs := PayrollFunctions.RoundingAmt(V_NTaxAttendanceDaysAbs,FALSE);
                  V_CalcNTaxTransp := (LCY_TransportationPerDay *
                            PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee))
                                                 - V_NTaxAttendanceDaysAbs;
                  V_CalcNTaxTransp := PayrollFunctions.RoundingAmt(V_CalcNTaxTransp,FALSE);
                  ACY_CalcNTaxTransp := PayrollFunctions.RoundingAmt(ACY_CalcNTaxTransp,TRUE);
                  V_CalculatedAmount := V_CalcNTaxTransp;
                  VA_CalculatedAmount := ACY_CalcNTaxTransp;
                END;
              END ELSE BEGIN //find special pay element changes
                IF SpecPayElt."Pay Unit" = SpecPayElt."Pay Unit"::Monthly THEN BEGIN
                  IF PayElement."Days in  Month" <> 0 THEN BEGIN
                    LCY_TransportationPerDay := PayDetailLine.Amount /
                     PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee);
                    ACY_TransportationPerDay := PayDetailLine."Amount (ACY)"/
                     PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee);
                  END ELSE
                     ERROR('Specify Days in Month for Pay Element :%1',PayElement.Description);
                END ELSE BEGIN
                  LCY_TransportationPerDay := PayDetailLine.Amount;
                  ACY_TransportationPerDay := PayDetailLine."Amount (ACY)";
                END;

                IF NOT (ACYComp_AttendanceDays AND NOT (SpecPayElt."Affected By Presence")) THEN
                  ACY_CalcNTaxTransp := (ACY_TransportationPerDay *
                                PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee))
                ELSE
                  ACY_CalcNTaxTransp := (ACY_TransportationPerDay *
                                PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee))
                                - LCY_TransportationPerDay * ABS(PayDetailHead."Attendance Days Affected");

                IF SpecPayElt."Affected By Presence" THEN
                  V_NTaxAttendanceDaysAbs := LCY_TransportationPerDay * ABS(PayDetailHead."Attendance Days Affected")
                ELSE
                  V_NTaxAttendanceDaysAbs := 0;
                V_NTaxAttendanceDaysAbs := (LCY_TransportationPerDay *
                              PayrollFunctions.GetWorkingDay(Paystatus."Period Start Date",Paystatus."Period End Date",PayEmployee))
                              - V_NTaxAttendanceDaysAbs;
                V_CalcNTaxTransp := PayrollFunctions.RoundingAmt(V_CalcNTaxTransp,FALSE);
                ACY_CalcNTaxTransp := PayrollFunctions.RoundingAmt(ACY_CalcNTaxTransp,TRUE);
                V_CalculatedAmount := V_CalcNTaxTransp;
                VA_CalculatedAmount := ACY_CalcNTaxTransp;
            END; // N.T transp*/
        end;
        //**1**//0
        if V_CalculatedAmount > 0 then begin
            exit(V_CalculatedAmount);
        end
    end;

    procedure InsertSplitDetailLine(PayDetailLine: Record "Pay Detail Line"; Employee: Record Employee; TransDate: Date; OldValue: Decimal; NewValue: Decimal; FromDate: Date; ToDate: Date; SplitAmount: Decimal; CalculatedAmount: Decimal; EfectiveNoDays: Decimal; SplitAmountACY: Decimal; CalculatedAmountACY: Decimal);
    var
        SplitPayDetLine2: Record "Split Pay Detail Line";
    begin
        SplitPayDetLine2.SETCURRENTKEY("Employee No.", "Pay Detail Line No.", "Transaction Date");
        SplitPayDetLine2.SETRANGE("Employee No.", Employee."No.");
        SplitPayDetLine2.SETRANGE("Pay Detail Line No.", PayDetailLine."Line No.");
        SplitPayDetLine2.SETRANGE("Transaction Date", TransDate);
        if SplitPayDetLine2.FIND('-') then
            SplitPayDetLine2.DELETEALL;
        SplitPayDetLine.INIT;
        SplitPayDetLine."Starting Split Date" := FromDate;
        SplitPayDetLine."Ending Split Date" := ToDate;
        SplitPayDetLine."Pay Detail Line No." := PayDetailLine."Line No.";
        SplitPayDetLine."Employee No." := Employee."No.";
        SplitPayDetLine."Transaction Date" := TransDate;
        SplitPayDetLine."Transaction Type" := 'CHANGE PAY ELEMENT';
        SplitLineNo := SplitLineNo + 1;
        SplitPayDetLine."Line No." := SplitLineNo;
        SplitPayDetLine."Shortcut Dimension 1 Code" := PayDetailLine."Shortcut Dimension 1 Code";
        SplitPayDetLine."Shortcut Dimension 2 Code" := PayDetailLine."Shortcut Dimension 2 Code";
        SplitPayDetLine."Job Title" := Employee."Job Title";
        SplitPayDetLine.Amount := SplitAmount;
        SplitPayDetLine."Amount (ACY)" := SplitAmountACY;
        SplitPayDetLine."Employee Status" := Employee.Status;
        SplitPayDetLine."Employment Date" := Employee."Employment Date";
        SplitPayDetLine."Old Transaction Type Value" := FORMAT(OldValue);
        SplitPayDetLine."New Transaction Type Value" := FORMAT(NewValue);
        SplitPayDetLine."Efective Nb. of Days" := EfectiveNoDays;
        SplitPayDetLine."Calculated Amount" := CalculatedAmount;
        SplitPayDetLine."Calculated Amount (ACY)" := CalculatedAmountACY;
        SplitPayDetLine.INSERT;
    end;

    procedure GetAffectedAttendanceTransport(Employee: Record Employee; FromDate: Date; ToDate: Date; PayrollFromDate: Date; PayrollToDate: Date): Decimal;
    var
        EmployeeJournalLine: Record "Employee Journal Line";
        PayrollFunctions: Codeunit "Payroll Functions";
        SumDaysOff: Decimal;
    begin
        SumDaysOff := 0;
        EmployeeJournalLine.SETCURRENTKEY("Employee No.", Type, Processed, "Document Status", Converted, "Ending Date",
                            "Affect Work Days", "Affect Attendance Days", "Absence Transaction Type", "Unit of Measure Code",
                            "Associate Pay Element", "Transaction Date", Entitled, Reseted);
        EmployeeJournalLine.SETRANGE("Employee No.", Employee."No.");
        EmployeeJournalLine.SETRANGE(Type, 'Absence');
        EmployeeJournalLine.SETRANGE(Processed, false);
        EmployeeJournalLine.SETRANGE("Document Status", EmployeeJournalLine."Document Status"::Approved);
        EmployeeJournalLine.SETRANGE(Converted, false);
        EmployeeJournalLine.SETRANGE("Affect Attendance Days", true);
        EmployeeJournalLine.SETFILTER("Absence Transaction Type", '<>%1', EmployeeJournalLine."Absence Transaction Type"::Overtime);
        EmployeeJournalLine.SETRANGE("Unit of Measure Code", 'DAY');
        EmployeeJournalLine.SETRANGE("Associate Pay Element", false);
        EmployeeJournalLine.SETFILTER("Transaction Date", '%1..%2', PayrollFromDate, PayrollToDate);
        EmployeeJournalLine.SETRANGE(Entitled, false);
        EmployeeJournalLine.SETRANGE(Reseted, false);
        EmployeeJournalLine.SETRANGE("Day-Off", false);
        //Disabled because it is wrong to use CALCSUMS prior to Find Loop - 01.06.2016 : AIM +
        /*
        EmployeeJournalLine.CALCSUMS("Rounding of Calculated Value");
        IF EmployeeJournalLine."Rounding of Calculated Value" > 0 THEN
        */
        //Disabled because it is wrong to use CALCSUMS prior to Find Loop - 01.06.2016 : AIM -
        if EmployeeJournalLine.FIND('-') then
            repeat
                if (EmployeeJournalLine."Rounding of Calculated Value" > 0) and
                (EmployeeJournalLine."Starting Date" <= FromDate) and (EmployeeJournalLine."Ending Date" >= ToDate) then begin
                    SumDaysOff += EmployeeJournalLine."Rounding of Calculated Value";
                end else
                    if (EmployeeJournalLine."Rounding of Calculated Value" > 0) and
                       (EmployeeJournalLine."Starting Date" <= FromDate) and (EmployeeJournalLine."Ending Date" <= ToDate) and
                       (EmployeeJournalLine."Ending Date" >= FromDate) then begin
                        SumDaysOff += EmployeeJournalLine."Rounding of Calculated Value";
                    end else
                        if (EmployeeJournalLine."Rounding of Calculated Value" > 0) and
                           (EmployeeJournalLine."Starting Date" >= FromDate) and (EmployeeJournalLine."Starting Date" <= ToDate) and
                           (EmployeeJournalLine."Ending Date" >= ToDate) then begin
                            SumDaysOff += EmployeeJournalLine."Rounding of Calculated Value";
                        end else
                            if (EmployeeJournalLine."Rounding of Calculated Value" > 0) and
                               (EmployeeJournalLine."Starting Date" >= FromDate) and (EmployeeJournalLine."Starting Date" <= ToDate) and
                               (EmployeeJournalLine."Ending Date" <= ToDate) then begin
                                SumDaysOff += EmployeeJournalLine."Rounding of Calculated Value";
                            end;
            until EmployeeJournalLine.NEXT = 0;
        exit(SumDaysOff);

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
        VbasicPay2: Decimal;
    begin
        //ADDED By IBRAHIM
        // Insert Special Pay Elements :
        //Added For Insurance
        // 11.10.2017 : A2+
        if (PayParam."Commision Addition" <> '') and (PayEmployee."Commission Addition" <> 0) then begin
            // 11.10.2017 : A2-
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Pay Element Code", PayParam."Commision Addition");
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
            if PayDetailLine.FINDFIRST then
                repeat
                    PayDetailLine.DELETE(true);
                until PayDetailLine.NEXT = 0;
            PayDetailLine.RESET;
            // 11.09.2017 : A2+
            //IF PayParam."Commision Addition" <> '' THEN
            // BEGIN
            //11.09.2017 A2-
            PayDetailLine.INIT;
            PayElement.GET(PayParam."Commision Addition");
            if PayEmployee."Commission Addition" <> 0 then begin
                //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                /*PayDetailLine.Amount := PayEmployee."Commission Addition";
                PayDetailLine."Calculated Amount" := PayEmployee."Commission Addition";
                */
                PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Commision Addition", PayEmployee."Commission Addition");
                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                //Modified in order to calculate value as per working days - 01.08.2016 : AIM -
                InsertPayDetailLine(PayElement.Code, '');
                //11.09.2017 A2+
            end;
            //11.09.2017 A2-
            //IF NOT PayElement."Not Included in Net Pay" THEN
            //  SumUpAllowDeduct(PayElement,PayDetailLine."Calculated Amount",0,0,'');
        end;

        // 11.09.2017 : A2+
        //IF PayParam."Comission Deduction" <> '' THEN
        if (PayParam."Comission Deduction" <> '') and (PayEmployee."Commission Deduction" <> 0) then begin
            //11.09.2017 A2-
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Pay Element Code", PayParam."Comission Deduction");
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
            if PayDetailLine.FINDFIRST then
                repeat
                    PayDetailLine.DELETE(true);
                until PayDetailLine.NEXT = 0;
            //11.09.2017 A2+
        end;
        //11.09.2017 A2-
        PayDetailLine.RESET;
        // 11.09.2017 : A2+
        if PayParam."Comission Deduction" <> '' then begin
            //11.09.2017 A2-
            PayDetailLine.INIT;
            PayElement.GET(PayParam."Comission Deduction");
            if PayEmployee."Commission Deduction" <> 0 then begin
                //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                /*PayDetailLine.Amount := PayEmployee."Commission Deduction";
                PayDetailLine."Calculated Amount" := PayEmployee."Commission Deduction";
                */
                PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Comission Deduction", PayEmployee."Commission Deduction");
                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                //Modified in order to calculate value as per working days - 01.08.2016 : AIM -
                InsertPayDetailLine(PayElement.Code, '');
                //11.09.2017 A2+
            end;
            //11.09.2017 A2-
        end;

        //EDM.IT+++
        if PayEmployee."Phone Allowance" > 0 then begin
            if PayParam."Mobile allowance" <> '' then // Added for more validations - 01.08.2016 : AIM +-
              begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Mobile allowance");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Mobile allowance");
                if PayEmployee."Phone Allowance" <> 0 then begin

                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                    //PayDetailLine.Amount := PayEmployee."Phone Allowance";
                    //PayDetailLine."Calculated Amount" := PayEmployee."Phone Allowance";
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Mobile allowance", PayEmployee."Phone Allowance");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM -
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;

        if PayEmployee."Car Allowance" > 0 then begin
            if PayParam."Car Allowance" <> '' then // Added for more validations - 01.08.2016 : AIM +-
                begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Car Allowance");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Car Allowance");
                if PayEmployee."Car Allowance" <> 0 then begin


                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                    //PayDetailLine.Amount := PayEmployee."Car Allowance";
                    //PayDetailLine."Calculated Amount" := PayEmployee."Car Allowance";
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Car Allowance", PayEmployee."Car Allowance");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM -

                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;
        //EDM.IT---
        if PayEmployee."Cost of Living" > 0 then begin
            if PayParam."Cost of Living" <> '' then begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Cost of Living");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Cost of Living");
                if PayEmployee."Cost of Living" <> 0 then begin
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Cost of Living", PayEmployee."Cost of Living");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;

                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;
        //Added for considering new fields in employee table - 01.04.2016 : AIM +
        if PayEmployee."House Allowance" > 0 then begin
            if PayParam."Housing Allowance" <> '' then // Added for more validations - 01.08.2016 : AIM +-
                begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Housing Allowance");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Housing Allowance");
                if PayEmployee."House Allowance" <> 0 then begin


                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                    //PayDetailLine.Amount := PayEmployee."House Allowance";
                    //PayDetailLine."Calculated Amount" := PayEmployee."House Allowance";
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Housing Allowance", PayEmployee."House Allowance");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM -
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;

        if PayEmployee."Other Allowances" > 0 then begin
            if PayParam.Allowance <> '' then // Added for more validations - 01.08.2016 : AIM +-
              begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam.Allowance);
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam.Allowance);
                if PayEmployee."Other Allowances" <> 0 then begin
                    ;

                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                    // PayDetailLine.Amount := PayEmployee."Other Allowances"
                    //PayDetailLine."Calculated Amount" := PayEmployee."Other Allowances";
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam.Allowance, PayEmployee."Other Allowances");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM -
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;
        //Added for considering new fields in employee table - 01.04.2016 : AIM -                        

        //Added for considering new fields in employee table - 01.08.2016 : AIM +
        if PayEmployee."Ticket Allowance" > 0 then begin
            if PayParam."Ticket Allowance" <> '' then // Added for more validations - 01.08.2016 : AIM +-
              begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Ticket Allowance");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Ticket Allowance");
                if PayEmployee."Ticket Allowance" <> 0 then begin


                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                    //PayDetailLine.Amount := PayEmployee."Ticket Allowance";
                    //PayDetailLine."Calculated Amount" := PayEmployee."Ticket Allowance";
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Ticket Allowance", PayEmployee."Ticket Allowance");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM -
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;

        if PayEmployee."Food Allowance" > 0 then begin
            if PayParam.Food <> '' then // Added for more validations - 01.08.2016 : AIM +-
              begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam.Food);
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam.Food);
                if PayEmployee."Food Allowance" <> 0 then begin


                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM +
                    //PayDetailLine.Amount := PayEmployee."Food Allowance";
                    // PayDetailLine."Calculated Amount" := PayEmployee."Food Allowance";
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam.Food, PayEmployee."Food Allowance");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    //Modified in order to calculate value as per working days - 01.08.2016 : AIM -
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;
        //Added for considering new fields in employee table - 01.08.2016 : AIM -
        //Added for considering new fields in employee table - 25.08.2017 : AIM +
        if PayrollFunctions.GetEmployeeExtraSalary(PayEmployee."No.") > 0 then begin
            if PayParam."Extra Salary" <> '' then begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Extra Salary");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Extra Salary");
                if PayrollFunctions.GetEmployeeExtraSalary(PayEmployee."No.") <> 0 then begin
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Extra Salary", PayrollFunctions.GetEmployeeExtraSalary(PayEmployee."No."));
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;
        //Added for considering new fields in employee table - 25.08.2017 : AIM -

        //Added in order to consider Allowances / deductions (By Employee Category) assigned at Employee Card - 05.10.2017 : AIM +

        if PayEmployee."Cost of Living Amount" > 0 then begin
            if PayParam."High Cost of Living Code" <> '' then begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."High Cost of Living Code");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."High Cost of Living Code");
                if PayEmployee."Cost of Living Amount" <> 0 then begin
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."High Cost of Living Code", PayEmployee."Cost of Living Amount");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;
        if PayEmployee."Water Compensation" > 0 then begin
            if PayParam."Water Compensation Allowance" <> '' then begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Water Compensation Allowance");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Water Compensation Allowance");
                if PayEmployee."Water Compensation" <> 0 then begin
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Water Compensation Allowance", PayEmployee."Water Compensation");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;
        if PayEmployee."Commission Amount" > 0 then begin
            if PayParam."Production Allowance" <> '' then begin
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Pay Element Code", PayParam."Production Allowance");
                PayDetailLine.SETRANGE(Open, true);
                PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        PayDetailLine.DELETE(true);
                    until PayDetailLine.NEXT = 0;
                PayDetailLine.RESET;

                PayDetailLine.INIT;
                PayElement.GET(PayParam."Production Allowance");
                if PayEmployee."Commission Amount" <> 0 then begin
                    PayDetailLine.Amount := FixEmployeeFixedAllowance(PayParam."Production Allowance", PayEmployee."Commission Amount");
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    InsertPayDetailLine(PayElement.Code, '');
                end;
            end;
        end;

        //Added in order to consider Allowances / deductions (By Employee Category) assigned at Employee Card - 05.10.2017 : AIM -


        //Added for GOSI Deduction - 27.04.2016 : AIM +
        if PayParam.GOSI <> '' then // Added for more validations - 01.08.2016 : AIM +-
          begin
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Pay Element Code", PayParam.GOSI);
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.SETRANGE("Employee No.", PayEmployee."No.");
            if PayDetailLine.FINDFIRST then
                repeat
                    PayDetailLine.DELETE(true);
                until PayDetailLine.NEXT = 0;
            PayDetailLine.RESET;

            PayDetailLine.INIT;
            PayElement.GET(PayParam.GOSI);
            if GetGOSIValue(PayEmployee."No.") <> 0 then begin
                PayDetailLine.Amount := GetGOSIValue(PayEmployee."No.");
                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                InsertPayDetailLine(PayElement.Code, '');
            end;
        end;
        //Added for GOSI Deduction - 27.04.2016 : AIM -

        HRSetup.GET;
        // 1.HR Transaction Type with Associated PYE
        HRTransactionType.RESET;
        HRTransactionType.SETFILTER("Associated Pay Element", '<>%1', '');
        HRTransactionType.SETFILTER(Type, '=%1|=%2|=%3', 'BENEFIT', 'DEDUCTIONS');
        if HRTransactionType.FIND('-') then
            repeat
                PayDetailLine.INIT;
                PayElementCode := '';
                PayElement.Reset();

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
                //L_EmployeeJournal.CALCSUMS(Value);
                if L_EmployeeJournal.FIND('-') then
                    repeat
                        V_Amount := V_Amount + L_EmployeeJournal.Value
                    until L_EmployeeJournal.NEXT = 0;
                //EDm_04112020
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
        PayrollParameterRec: Record "Payroll Parameter";
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
        L_PayLedgEntry: Record "Payroll Ledger Entry";
        L_PayParam: Record "Payroll Parameter";
        L_PayDetailLine: Record "Pay Detail Line";
        L_EmpTbt: Record Employee;
        L_TotalForNSSF: Decimal;
        L_MHOODEmployer: Decimal;
        L_MHOODEmployee: Decimal;
        L_NSSFType: Option MHOOD2,MHOOD7,FAMSUB6,"EOS8.5";
        L_UseRetro: Boolean;
        L_FAMEmployer: Decimal;
        L_EOSEmployer: Decimal;
        L_NSSFCatType: Option MHOOD9,FAMSUB6,"EOS8.5";
        L_PayElement: Record "Pay Element";
        L_MHOODPayElement: Code[20];
    begin
        L_PayParam.GET();
        L_UseRetro := false;
        if not PayParam."No Pension Retro" then
            L_UseRetro := true;
        if L_UseRetro = false then
            exit;

        L_EmpTbt.SETRANGE("No.", pEmployeeNo);
        if not L_EmpTbt.FINDFIRST then
            exit;

        L_TotalForNSSF := 0;
        CalculateSalaryNSSF();
        L_TotalForNSSF := V_NSSFSalary;

        L_MHOODEmployer := PayrollFunctions.CalculateEmployeeNSSFContribution(pEmployeeNo, pToDate, L_TotalForNSSF, L_NSSFType::MHOOD7, L_UseRetro);
        L_MHOODEmployee := PayrollFunctions.CalculateEmployeeNSSFContribution(pEmployeeNo, pToDate, L_TotalForNSSF, L_NSSFType::MHOOD2, L_UseRetro);
        L_FAMEmployer := PayrollFunctions.CalculateEmployeeNSSFContribution(pEmployeeNo, pToDate, L_TotalForNSSF, L_NSSFType::FAMSUB6, L_UseRetro);
        L_EOSEmployer := PayrollFunctions.CalculateEmployeeNSSFContribution(pEmployeeNo, pToDate, L_TotalForNSSF, L_NSSFType::"EOS8.5", L_UseRetro);
        V_EmployeePension := L_MHOODEmployee;
        V_EmployerPension := L_MHOODEmployer + L_EOSEmployer + L_FAMEmployer;

        pPayrollLedgerEntry."Employer Pension" := L_MHOODEmployer + L_EOSEmployer + L_FAMEmployer;
        pPayrollLedgerEntry."Employee Pension" := L_MHOODEmployee;
        pPayrollLedgerEntry.MODIFY;

        L_PayDetailLine.RESET;
        L_PayDetailLine.SETRANGE(Open, true);
        L_PayDetailLine.SETRANGE("Payroll Date", pToDate);
        L_PayDetailLine.SETRANGE("Pay Element Code", PayrollFunctions.GetNSSFContributionPayElement(L_NSSFCatType::MHOOD9, L_EmpTbt."Posting Group"));
        L_PayDetailLine.SETRANGE("Employee No.", pPayrollLedgerEntry."Employee No.");
        if L_PayDetailLine.FINDFIRST then begin
            L_PayDetailLine.Amount := L_MHOODEmployee;
            L_PayDetailLine."Calculated Amount" := L_MHOODEmployee;
            L_PayDetailLine."Employer Amount" := L_MHOODEmployer;
            L_PayDetailLine.MODIFY;
        end;

        L_PayDetailLine.RESET;
        L_PayDetailLine.SETRANGE(Open, true);
        L_PayDetailLine.SETRANGE("Payroll Date", pToDate);
        L_PayDetailLine.SETRANGE("Pay Element Code", PayrollFunctions.GetNSSFContributionPayElement(L_NSSFCatType::FAMSUB6, L_EmpTbt."Posting Group"));
        L_PayDetailLine.SETRANGE("Employee No.", pPayrollLedgerEntry."Employee No.");
        if L_PayDetailLine.FINDFIRST then begin
            L_PayDetailLine.Amount := 0;
            L_PayDetailLine."Calculated Amount" := 0;
            L_PayDetailLine."Employer Amount" := L_FAMEmployer;
            L_PayDetailLine.MODIFY;
        end;
        L_MHOODPayElement := PayrollFunctions.GetNSSFContributionPayElement(L_NSSFCatType::MHOOD9, L_EmpTbt."Posting Group");
        if L_MHOODPayElement <> '' then begin
            L_PayElement.GET(L_MHOODPayElement);
            SumUpAllowDeduct(L_PayElement, L_MHOODEmployee, 0, 0, '');
        end;
        CalculateNetPay();
    end;

    local procedure CalculateTaxRetro(pToDate: Date; pEmployeeNo: Code[20]; var pPayrollLedgerEntry: Record "Payroll Ledger Entry"; PeriodNb: Integer);
    var
        TaxPeriod: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        VTaxGiven: Decimal;
        VCalcExemptTax: Decimal;
        VNetTaxSalary: Decimal;
        VCalcNetTaxSalary: Decimal;
        PayDetailLineRec: Record "Pay Detail Line";
        PayParm: Record "Payroll Parameter";
        RemainderBefore: Decimal;
        VCalcPayeTaxBefore: Decimal;
        VPayeTaxBefore: Decimal;
        VTotalTaxBefore: Decimal;
        VExemptTaxBefore: Decimal;
        VCalcExemptTaxBefore: Decimal;
        VNetTaxSalaryBefore: Decimal;
        VCalcNetTaxSalaryBefore: Decimal;
        VTotalTaxGivenBefore: Decimal;
        PeriodNumberBefore: Decimal;
        RemainderAfter: Decimal;
        VCalcPayeTaxAfter: Decimal;
        VPayeTaxAfter: Decimal;
        VTotalTaxAfter: Decimal;
        VExemptTaxAfter: Decimal;
        VCalcExemptTaxAfter: Decimal;
        VNetTaxSalaryAfter: Decimal;
        VCalcNetTaxSalaryAfter: Decimal;
        VTotalTaxGivenAfter: Decimal;
        PeriodNumberAfter: Decimal;
        ComputedBefore: Boolean;
        LastBandBefore: Boolean;
        ComputedAfter: Boolean;
        LastBandAfter: Boolean;
        PayElementRec: Record "Pay Element";
        WorkingDays: Decimal;
        InsertNegativeTax: Boolean;
        TxVal: Decimal;
        V: Decimal;
        NumberoftaxdaysAfter: Decimal;
        NumberoftaxdaysBefore: Decimal;
    begin
        //EDM-
        //EDM.IT ExemptTax+
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
        //EDM.IT-

        TaxPeriod := 12;
        VTaxGiven := 0;
        //EDM+ 30-08-2019		
        PeriodNumberBefore := 0;
        VTotalTaxGivenBefore := 0;
        VTotalTaxBefore := 0;
        VExemptTaxBefore := 0;
        VCalcPayeTaxBefore := 0;
        VPayeTaxBefore := 0;
        PeriodNumberAfter := 0;
        VTotalTaxGivenAfter := 0;
        VTotalTaxAfter := 0;
        VExemptTaxAfter := 0;
        VCalcPayeTaxAfter := 0;
        VPayeTaxAfter := 0;
        //EDM- 30-08-2019
        PayParam.GET;
        IF PayParam."Tax Bands Decision Date" <> 0D THEN BEGIN
            IF pToDate >= PayParam."Tax Bands Decision Date" then begin
                PayrollLedgerEntry.RESET;
                PayrollLedgerEntry.SETFILTER("Period End Date", '%1..%2', PayParam."Tax Bands Decision Date", pToDate);
                PayrollLedgerEntry.SETFILTER(PayrollLedgerEntry.Period, '%1..%2', DATE2DMY(PayParam."Tax Bands Decision Date", 2), DATE2DMY(pToDate, 2));
                PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
                PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
                PayrollLedgerEntry.SETFILTER(Declared, '%1|%2', PayrollLedgerEntry.Declared::Declared, PayrollLedgerEntry.Declared::"Non-NSSF");
                if PayrollLedgerEntry.FINDFIRST then
                    repeat
                        VTotalTaxAfter := VTotalTaxAfter + PayrollLedgerEntry."Taxable Pay";
                        IF PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement THEN
                            VExemptTaxAfter := VExemptTaxAfter + PayrollLedgerEntry."Free Pay";//EDM.IT New(PayrollLedgerEntry."Exempt Tax"/12);

                        IF PayrollLedgerEntry."Sub Payroll Code" = '' THEN BEGIN
                            if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                                IF PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement THEN
                                    PeriodNumberAfter := PeriodNumberAfter + (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", PayrollLedgerEntry."Tax Year", PayrollLedgerEntry.Period, PayrollLedgerEntry.Period)
                                          / PayrollFunctions.GetDaysInMonth(PayrollLedgerEntry.Period, PayrollLedgerEntry."Tax Year"));
                            end
                            else begin
                                IF PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement THEN
                                    PeriodNumberAfter := PeriodNumberAfter + 1;
                            end;
                        END;
                        WorkingDays := WorkingDays + (30 - PayrollLedgerEntry."Working Days Absence");
                        VTotalTaxGivenAfter := VTotalTaxGivenAfter + PayrollLedgerEntry."Tax Paid";
                    until PayrollLedgerEntry.NEXT = 0;
            END
            ELSE BEGIN
                PayParam.GET;
                PayrollLedgerEntry.RESET;
                PayrollLedgerEntry.SETFILTER("Period End Date", '..%1', CALCDATE('-1D', PayParam."Tax Bands Decision Date"));
                PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
                PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
                PayrollLedgerEntry.SETFILTER(Declared, '%1|%2', PayrollLedgerEntry.Declared::Declared, PayrollLedgerEntry.Declared::"Non-NSSF");
                PayrollLedgerEntry.SETFILTER(PayrollLedgerEntry.Period, '..%1', DATE2DMY(pToDate, 2) - 1);
                IF PayrollLedgerEntry.FINDFIRST THEN
                    REPEAT
                        VTotalTaxBefore := VTotalTaxBefore + PayrollLedgerEntry."Taxable Pay";
                        IF PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement THEN BEGIN
                            VExemptTaxBefore := VExemptTaxBefore + PayrollLedgerEntry."Free Pay";//EDM.IT New(PayrollLedgerEntry."Exempt Tax"/12);

                            IF PayrollLedgerEntry."Sub Payroll Code" = '' THEN BEGIN
                                if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                                    PeriodNumberBefore := PeriodNumberBefore + (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", PayrollLedgerEntry."Tax Year", PayrollLedgerEntry.Period, PayrollLedgerEntry.Period)
                                              / PayrollFunctions.GetDaysInMonth(PayrollLedgerEntry.Period, PayrollLedgerEntry."Tax Year"));
                                end
                                else
                                    PeriodNumberBefore := PeriodNumberBefore + 1;
                            END;
                        end;
                        WorkingDays := WorkingDays + (30 - PayrollLedgerEntry."Working Days Absence");
                        VTotalTaxGivenBefore := VTotalTaxGivenBefore + PayrollLedgerEntry."Tax Paid";
                    UNTIL PayrollLedgerEntry.NEXT = 0;
            END;
        END
        ELSE BEGIN
            VTotalTaxAfter := 0;
            VExemptTaxAfter := 0;
            VTotalTaxGivenAfter := 0;
            PeriodNumberAfter := 0;
            PayParam.GET;
            PayrollLedgerEntry.RESET;
            PayrollLedgerEntry.SETFILTER("Period End Date", '..%1', pToDate);
            PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
            PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
            PayrollLedgerEntry.SETFILTER(Declared, '%1|%2', PayrollLedgerEntry.Declared::Declared, PayrollLedgerEntry.Declared::"Non-NSSF");
            PayrollLedgerEntry.SETFILTER(PayrollLedgerEntry.Period, '..%1', DATE2DMY(pToDate, 2));
            IF PayrollLedgerEntry.FINDFIRST THEN
                REPEAT
                    VTotalTaxBefore := VTotalTaxBefore + PayrollLedgerEntry."Taxable Pay";
                    IF PayrollLedgerEntry."Payment Category" <> PayrollLedgerEntry."Payment Category"::Supplement THEN BEGIN
                        VExemptTaxBefore := VExemptTaxBefore + PayrollLedgerEntry."Free Pay";//EDM.IT New(PayrollLedgerEntry."Exempt Tax"/12);

                        IF PayrollLedgerEntry."Sub Payroll Code" = '' THEN BEGIN
                            if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                                PeriodNumberBefore := PeriodNumberBefore + (PayrollFunctions.GetEmployeeTaxDays(PayEmployee."No.", PayrollLedgerEntry."Tax Year", PayrollLedgerEntry.Period, PayrollLedgerEntry.Period)
                                          / PayrollFunctions.GetDaysInMonth(PayrollLedgerEntry.Period, PayrollLedgerEntry."Tax Year"));
                            end
                            else
                                PeriodNumberBefore := PeriodNumberBefore + 1;
                        END;
                    end;
                    WorkingDays := WorkingDays + (30 - PayrollLedgerEntry."Working Days Absence");
                    VTotalTaxGivenBefore := VTotalTaxGivenBefore + PayrollLedgerEntry."Tax Paid";
                UNTIL PayrollLedgerEntry.NEXT = 0;
        END;
        VExemptTaxAfter := VExemptTaxAfter;
        VCalcExemptTaxAfter := VExemptTaxAfter;
        VNetTaxSalaryAfter := ROUND(VTotalTaxAfter - VExemptTaxAfter, 2);
        VCalcNetTaxSalaryAfter := ROUND(VTotalTaxAfter - VCalcExemptTaxAfter, 2);
        //
        VExemptTaxBefore := VExemptTaxBefore;
        VCalcExemptTaxBefore := VExemptTaxBefore;
        VNetTaxSalaryBefore := ROUND(VTotalTaxBefore - VExemptTaxBefore, 2);
        VCalcNetTaxSalaryBefore := ROUND(VTotalTaxBefore - VCalcExemptTaxBefore, 2);
        // apply Tax Bands
        IF PayParam."Tax Bands Decision Date" <> 0D THEN BEGIN
            IF pToDate >= PayParam."Tax Bands Decision Date" THEN BEGIN
                LoopAfter := 1;
                WHILE LoopAfter <= 2 DO BEGIN
                    LastBandAfter := FALSE;
                    ComputedAfter := FALSE;
                    IF LoopAfter = 1 THEN
                        RemainderAfter := VNetTaxSalaryAfter
                    ELSE
                        RemainderAfter := VCalcNetTaxSalaryAfter;
                    PayParam.GET;
                    TaxBand.SETFILTER(Date, '=%1', PayParam."Tax Bands Decision Date");
                    IF TaxBand.FINDFIRST THEN
                        REPEAT
                            IF RemainderAfter >= (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberAfter THEN BEGIN
                                ComputedAfter := TRUE;
                                RemainderAfter := RemainderAfter - (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberAfter;
                                IF LoopAfter = 1 THEN
                                    VPayeTaxAfter := VPayeTaxAfter + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberAfter * (TaxBand.Rate / 100)
                                ELSE
                                    VCalcPayeTaxAfter := VCalcPayeTaxAfter + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberAfter * (TaxBand.Rate / 100);
                            END ELSE BEGIN
                                LastBandAfter := TRUE;
                                IF RemainderAfter > 0 THEN BEGIN
                                    IF LoopAfter = 1 THEN
                                        VPayeTaxAfter := VPayeTaxAfter + (RemainderAfter * (TaxBand.Rate / 100))
                                    ELSE
                                        VCalcPayeTaxAfter := VCalcPayeTaxAfter + (RemainderAfter * (TaxBand.Rate / 100));
                                END;
                            END;
                        UNTIL (TaxBand.NEXT = 0) OR (LastBandAfter);
                    LoopAfter := LoopAfter + 1;
                END;
            END
            ELSE BEGIN
                LoopBefore := 1;
                WHILE LoopBefore <= 2 DO BEGIN
                    LastBandBefore := FALSE;
                    ComputedBefore := FALSE;
                    IF LoopBefore = 1 THEN
                        RemainderBefore := VNetTaxSalaryBefore
                    ELSE
                        RemainderBefore := VCalcNetTaxSalaryBefore;
                    PayParam.GET;
                    TaxBand.SETFILTER(Date, '%1', 0D);
                    IF TaxBand.FINDFIRST THEN
                        REPEAT
                            IF RemainderBefore >= (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore THEN BEGIN
                                ComputedBefore := TRUE;
                                RemainderBefore := RemainderBefore - (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore;
                                IF LoopBefore = 1 THEN
                                    VPayeTaxBefore := VPayeTaxBefore + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore * (TaxBand.Rate / 100)
                                ELSE
                                    VCalcPayeTaxBefore := VCalcPayeTaxBefore + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore * (TaxBand.Rate / 100);
                            END ELSE BEGIN
                                LastBandBefore := TRUE;
                                IF RemainderBefore > 0 THEN BEGIN
                                    IF LoopBefore = 1 THEN
                                        VPayeTaxBefore := VPayeTaxBefore + (RemainderBefore * (TaxBand.Rate / 100))
                                    ELSE
                                        VCalcPayeTaxBefore := VCalcPayeTaxBefore + (RemainderBefore * (TaxBand.Rate / 100));
                                END;
                            END;
                        UNTIL (TaxBand.NEXT = 0) OR (LastBandBefore);
                    LoopBefore := LoopBefore + 1;
                END;
            END;
        END
        ELSE BEGIN
            LoopBefore := 1;
            WHILE LoopBefore <= 2 DO BEGIN
                LastBandBefore := FALSE;
                ComputedBefore := FALSE;
                IF LoopBefore = 1 THEN
                    RemainderBefore := VNetTaxSalaryBefore
                ELSE
                    RemainderBefore := VCalcNetTaxSalaryBefore;
                PayParam.GET;
                TaxBand.SETFILTER(Date, '%1', 0D);
                IF TaxBand.FINDFIRST THEN
                    REPEAT
                        IF RemainderBefore >= (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore THEN BEGIN
                            ComputedBefore := TRUE;
                            RemainderBefore := RemainderBefore - (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore;
                            IF LoopBefore = 1 THEN
                                VPayeTaxBefore := VPayeTaxBefore + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore * (TaxBand.Rate / 100)
                            ELSE
                                VCalcPayeTaxBefore := VCalcPayeTaxBefore + (TaxBand."Annual Bandwidth" / TaxPeriod) * PeriodNumberBefore * (TaxBand.Rate / 100);
                        END ELSE BEGIN
                            LastBandBefore := TRUE;
                            IF RemainderBefore > 0 THEN BEGIN
                                IF LoopBefore = 1 THEN
                                    VPayeTaxBefore := VPayeTaxBefore + (RemainderBefore * (TaxBand.Rate / 100))
                                ELSE
                                    VCalcPayeTaxBefore := VCalcPayeTaxBefore + (RemainderBefore * (TaxBand.Rate / 100));
                            END;
                        END;
                    UNTIL (TaxBand.NEXT = 0) OR (LastBandBefore);
                LoopBefore := LoopBefore + 1;
            END;
        END;
        // loop       
        PayrollLedgerEntry.RESET;
        PayrollLedgerEntry.SETFILTER("Payroll Date", '..%1', pToDate);
        PayrollLedgerEntry.SETRANGE(Open, false);
        PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);

        //Added in order to exclude un-declared records - 06.06.2016 : AIM +
        PayrollLedgerEntry.SETFILTER(Declared, '%1|%2', PayrollLedgerEntry.Declared::Declared, PayrollLedgerEntry.Declared::"Non-NSSF");
        //Added in order to exclude un-declared records - 06.06.2016 : AIM -

        //Added in order to consider only months <= month(Payroll date) - 27.02.2018 : AIM +
        PayrollLedgerEntry.SETFILTER(PayrollLedgerEntry.Period, '<=%1', DATE2DMY(pToDate, 2));
        //Added in order to consider only months <= month(Payroll date) - 27.02.2018 : AIM -

        if PayrollLedgerEntry.FINDFIRST then
            repeat
                VTaxGiven := VTaxGiven + PayrollLedgerEntry."Tax Paid";
            until PayrollLedgerEntry.NEXT = 0;

        PayParm.GET;

        // Insert PAYE Tax
        //Modified in order not to insert a -Ve income Tax - 07.03.2016 : AIM +
        InsertNegativeTax := true;
        if PayParm."Discard Negative Income Tax" = true then
            InsertNegativeTax := false;

        if InsertNegativeTax = true then
            TxVal := ABS((VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven)
        else
            TxVal := (VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven;
        //Modified in order not to insert a -Ve income Tax - 07.03.2016 : AIM -

        //Modified in order not to insert a -Ve income Tax - 07.03.2016 : AIM +
        //IF ABS(VCalcPayeTax-VTaxGiven)>100 THEN BEGIN
        if TxVal > 100 then begin
            //Modified in order not to insert a -Ve income Tax - 07.03.2016 : AIM -
            pPayrollLedgerEntry."Tax Paid" := Round((VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven, GetIncomeTaxPrecision(), '>');
            pPayrollLedgerEntry."Income Tax Retro" := Round((VCalcPayeTaxAfter + VCalcPayeTaxBefore) - (VTotalTaxGivenAfter + VTotalTaxGivenBefore), GetIncomeTaxPrecision(), '>');
            pPayrollLedgerEntry.MODIFY;
            //PayParm.GET;

            PayDetailLineRec.SETRANGE(Open, true);
            PayDetailLineRec.SETRANGE("Pay Element Code", PayParm."Income Tax Code");
            PayDetailLineRec.SETRANGE("Employee No.", pPayrollLedgerEntry."Employee No.");
            if PayDetailLineRec.FINDFIRST then begin
                //Added in order to prevent adding the difference in tax retro to the PayNet value - 30.03.2016 : AIM +
                V_Deductions := V_Deductions - V_TaxDeductions;
                V := (VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven;
                V_TaxDeductions := 0;
                //Added in order to prevent adding the difference in tax retro to the PayNet value - 30.03.2016 : AIM -

                PayDetailLineRec.Amount := Round((VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven, GetIncomeTaxPrecision(), '>');
                PayDetailLineRec."Calculated Amount" := Round((VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven, GetIncomeTaxPrecision(), '>');
                PayDetailLineRec.MODIFY;
            end
            else begin
                PayParm.GET;
                PayDetailLine.INIT;
                PayDetailLine.Amount := ROUND((VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven, GetIncomeTaxPrecision(), '>');
                PayDetailLine."Calculated Amount" := ROUND((VCalcPayeTaxAfter + VCalcPayeTaxBefore) - VTaxGiven, GetIncomeTaxPrecision(), '>');
                InsertPayDetailLine(PayParm."Income Tax Code", '');
            end;

        end;
        //EDM+
        PayElementRec.RESET;
        PayElementRec.SETRANGE(Code, PayParm."Income Tax Code");
        if PayElementRec.FINDFIRST then
            //Modified in order not to insert a -Ve income Tax - 07.03.2016 : AIM +
            //SumUpAllowDeduct(PayElementRec,VCalcPayeTax-VTotalTaxGiven,0,0,'');
            if InsertNegativeTax = true then begin
                //Modified in order to prevent adding the difference in tax retro to the PayNet value - 30.03.2016 : AIM +
                //SumUpAllowDeduct(PayElementRec,VCalcPayeTax-VTotalTaxGiven,0,0,'');
                SumUpAllowDeduct(PayElementRec, V, 0, 0, '');
                //Modified in order to prevent adding the difference in tax retro to the PayNet value - 30.03.2016 : AIM -
            end
            else begin
                if (VCalcPayeTaxAfter + VCalcPayeTaxBefore) - (VTotalTaxGivenAfter + VTotalTaxGivenBefore) > 0 then
                    //Modified in order to prevent adding the difference in tax retro to the PayNet value - 30.03.2016 : AIM +
                    //SumUpAllowDeduct(PayElementRec,VCalcPayeTax-VTotalTaxGiven,0,0,'')
                    SumUpAllowDeduct(PayElementRec, V, 0, 0, '')
                //Modified in order to prevent adding the difference in tax retro to the PayNet value - 30.03.2016 : AIM -
                else
                    //Modified in order to prevent adding the difference in tax retro to the PayNet value - 30.05.2016 : AIM +
                    //SumUpAllowDeduct(PayElementRec,0,0,0,'');
                    if V > 0 then
                        SumUpAllowDeduct(PayElementRec, V, 0, 0, '')
                    else
                        SumUpAllowDeduct(PayElementRec, 0, 0, 0, '');
                //Modified in order to prevent adding the difference in tax retro to the PayNet value - 30.05.2016 : AIM -
            end;
        //Modified in order not to insert a -Ve income Tax - 07.03.2016 : AIM -


        CalculateNetPay;
        pPayrollLedgerEntry."Net Pay" := V_NetSalary;
        pPayrollLedgerEntry.Rounding := V_Rounding;
        pPayrollLedgerEntry.MODIFY;

    end;

    procedure CalcFamilyAllownaceRetro(pToDate: Date; pEmployeeNo: Code[20]; var pPayrollLedgerEntry: Record "Payroll Ledger Entry");
    var
        PayElementCode: Code[10];
        SpecificElement: Record "Specific Pay Element";
        VFamilyAllowanceGiven: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        PeriodNo: Integer;
        PayParameter: Record "Payroll Parameter";
        PayDetailLineRec: Record "Pay Detail Line";
        PayElementRec: Record "Pay Element";
        EmployeeRelatives: Record "Employee Relative";
        Spouse: Integer;
        NotSpouse: Integer;
        EligibleChild: Integer;
        WifeAmount: Decimal;
        ChildAmount: Decimal;
        WifeAllowanceDue: Decimal;
        ChildAllowanceDue: Decimal;
        EndDate: Date;
        StartDate: Date;
        PayrollParameter: Record "Payroll Parameter";
        ExemptTaxWifeDue: Decimal;
        ExemptTaxChildDue: Decimal;
        ExemptTaxGiven: Decimal;
        ExemptTaxWife: Decimal;
        ExemptTaxChild: Decimal;
    begin
        //EDM.IT+
        VFamilyAllowanceGiven := 0;
        PayParameter.GET;

        ExemptTaxWife := PayParam."Tax Exempt P/Y NonWork Spouse";
        ExemptTaxChild := PayParam."Tax Exempt P/Y Per Child";


        SpecificElement.SETRANGE("Pay Element Code", PayParameter."Family Allowance Code");
        if SpecificElement.FINDFIRST then begin
            WifeAmount := SpecificElement."Wife Entitlement";
            ChildAmount := SpecificElement."Per Children Entitlement";
        end;
        PayParam.GET;
        PayrollLedgerEntry.RESET;
        PayrollLedgerEntry.SETCURRENTKEY("Employee No.", "Tax Year", "Period End Date", Open);
        PayrollLedgerEntry.SETFILTER("Period End Date", '..%1', pToDate);
        PayrollLedgerEntry.SETRANGE("Tax Year", DATE2DMY(pToDate, 3));
        PayrollLedgerEntry.SETRANGE("Employee No.", pEmployeeNo);
        if PayrollLedgerEntry.FINDFIRST then
            repeat
                VFamilyAllowanceGiven := VFamilyAllowanceGiven + PayrollLedgerEntry."Family Allowance";
                ExemptTaxGiven := ExemptTaxGiven + PayLedgEntry."Exempt Tax";
                EmployeeRelatives.SETRANGE("Employee No.", pEmployeeNo);
                if EmployeeRelatives.FINDFIRST then
                    repeat
                        EmployeeRelatives.CALCFIELDS(Type);
                        if FORMAT(EmployeeRelatives."Registeration Start Date") = '' then
                            StartDate := PayrollLedgerEntry."Payroll Date"
                        else
                            StartDate := EmployeeRelatives."Registeration Start Date";
                        if FORMAT(EmployeeRelatives."Registeration End Date") = '' then
                            EndDate := PayrollLedgerEntry."Payroll Date"
                        else
                            EndDate := EmployeeRelatives."Registeration End Date";

                        if (EmployeeRelatives.Type = EmployeeRelatives.Type::Wife) and
                        (PayrollLedgerEntry."Payroll Date" >= StartDate) and
                        (PayrollLedgerEntry."Payroll Date" <= EndDate) then begin
                            WifeAllowanceDue := WifeAllowanceDue + WifeAmount;
                            ExemptTaxWifeDue := ExemptTaxWifeDue + ExemptTaxWife;
                        end
                        else
                            if (EmployeeRelatives.Type = EmployeeRelatives.Type::Child) and
                       (PayrollLedgerEntry."Payroll Date" >= StartDate) and
                       (PayrollLedgerEntry."Payroll Date" <= EndDate) then begin
                                ChildAllowanceDue := ChildAllowanceDue + ChildAmount;
                                ExemptTaxChildDue := ExemptTaxChildDue + ExemptTaxChild;
                            end;
                    until EmployeeRelatives.NEXT = 0;
            until PayrollLedgerEntry.NEXT = 0;

        if ((WifeAllowanceDue + ChildAllowanceDue) - VFamilyAllowanceGiven) <> 0 then begin
            pPayrollLedgerEntry."Family Allowance Retroactive" := ((WifeAllowanceDue + ChildAllowanceDue) - VFamilyAllowanceGiven);
            pPayrollLedgerEntry."Family Allowance" := pPayrollLedgerEntry."Family Allowance" +
            ((WifeAllowanceDue + ChildAllowanceDue) - VFamilyAllowanceGiven);
            pPayrollLedgerEntry.MODIFY;

            PayParameter.GET;
            PayDetailLineRec.SETRANGE(Open, true);
            PayDetailLineRec.SETRANGE("Pay Element Code", PayParameter."Family Allowance Code");
            PayDetailLineRec.SETRANGE("Employee No.", pPayrollLedgerEntry."Employee No.");
            if PayDetailLineRec.FINDFIRST then begin
                PayDetailLineRec.Amount := ((WifeAllowanceDue + ChildAllowanceDue) - VFamilyAllowanceGiven);
                PayDetailLineRec."Calculated Amount" := ((WifeAllowanceDue + ChildAllowanceDue) - VFamilyAllowanceGiven);
                PayDetailLineRec.MODIFY;
            end;
        end;
        //EDM.IT-
    end;

    procedure CalculateSalaryNSSF(): Decimal;
    var
        PayDetail: Record "Pay Detail Line";
        PayElement: Record "Pay Element";
        PayrollParameterRec: Record "Payroll Parameter";
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

    procedure DifferenceBetweenDates(FromDate: Date; ToDate: Date): Integer;
    var
        Diff: Integer;
        StartDate: Date;
        DateExpr: Text[30];
    begin
        StartDate := FromDate;
        Diff := 0;
        if DATE2DMY(FromDate, 1) = 31 then
            Diff := -1;

        if DATE2DMY(ToDate, 1) = 31 then
            Diff := -1;


        if (DATE2DMY(StartDate, 1) = 29) and (DATE2DMY(StartDate, 2) = 2) then
            Diff := Diff + 1;
        if (DATE2DMY(StartDate, 1) = 28) and (DATE2DMY(StartDate, 2) = 2) then
            Diff := Diff + 2;


        if DATE2DMY(FromDate, 2) < DATE2DMY(ToDate, 2) then begin
            repeat
                if (DATE2DMY(StartDate, 2) = 1) or (DATE2DMY(StartDate, 2) = 3) or (DATE2DMY(StartDate, 2) = 5) or (DATE2DMY(StartDate, 2) = 7)
                or (DATE2DMY(StartDate, 2) = 8)
                or (DATE2DMY(StartDate, 2) = 10) or (DATE2DMY(StartDate, 2) = 12) then
                    Diff := Diff + 1;
                if (DATE2DMY(StartDate, 2) = 2) then
                    Diff := Diff - 2;



                if DATE2DMY(StartDate, 1) = 30 then
                    DateExpr := '+1M+1D' else
                    if DATE2DMY(StartDate, 1) = 28 then
                        DateExpr := '+1M+3D'
                    else
                        DateExpr := '+1M';

                StartDate := CALCDATE(DateExpr, StartDate);
            until StartDate > ToDate;
            exit(Diff);
        end;
    end;

    local procedure PayElementExistsInPayDetails(EmpNo: Code[20]; TaxYear: Integer; PeriodNo: Integer; PayrollDate: Date; PayElementCode: Code[10]; PayElementType: Option Addition,Deduction; PayrollGroupCode: Code[10]) RecExists: Boolean;
    var
        PayDetailLine: Record "Pay Detail Line";
        PayParamTbt: Record "Payroll Parameter";
    begin
        RecExists := false;

        //Added in order to allow inserting more one line for loans in pay detail line - 19.05.2016 : AIM +
        PayParamTbt.RESET();
        PayParamTbt.GET;
        if (PayElementCode = PayParamTbt.Loan) and (PayParamTbt.Loan <> '') then
            exit(false);
        //Added in order to allow inserting more one line for loans in pay detail line - 19.05.2016 : AIM -

        PayDetailLine.SETRANGE("Employee No.", EmpNo);
        PayDetailLine.SETRANGE("Tax Year", TaxYear);
        PayDetailLine.SETRANGE(Period, PeriodNo);
        PayDetailLine.SETRANGE("Payroll Date", PayrollDate);
        PayDetailLine.SETRANGE("Pay Element Code", PayElementCode);
        PayDetailLine.SETRANGE(Type, PayElementType);
        PayDetailLine.SETRANGE("Payroll Group Code", PayrollGroupCode);
        if PayDetailLine.FINDFIRST then
            RecExists := true;

        exit(RecExists);
    end;

    local procedure CalculateTaxNetPercentage();
    var
        TaxPeriod: Decimal;
        Computed: Boolean;
        Remainder: Decimal;
        LastBand: Boolean;
    begin
        PayParam.GET;
        //IF PayParam."Sup.Tax" = '' THEN
        //  EXIT;

        CalculateTaxableSalary();
        V_NetTaxSalary := V_TaxableSalary;

        // Insert PAYE Tax
        PayDetailLine.INIT;
        //PayElement.GET(PayParam."Sup.Tax");
        PayElement.GET(PayParam."Income Tax Code");
        V_CalcPayeTax := V_NetTaxSalary * PayParam."Contractual Tax %" / 100;
        //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM +
        //V_CalcPayeTax :=ROUND(V_CalcPayeTax,1000,'>');
        V_CalcPayeTax := ROUND(V_CalcPayeTax, GetIncomeTaxPrecision(), '>');
        //Modified in order to make the precision as a parametrized value - 11.03.2016 : AIM -
        //EDM-
        PayDetailLine.Amount := V_CalcPayeTax;
        PayDetailLine."Calculated Amount" := V_CalcPayeTax;
        InsertPayDetailLine(PayElement.Code, '');
        if not PayElement."Not Included in Net Pay" then
            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '')
        else
            V_TaxDeductions := PayDetailLine."Calculated Amount";
        //InsertPayDetailLine(PayParam."Sup.Tax");
    end;

    local procedure InsertOvertimePayDetailLine(PayElement: Record "Pay Element"; CauseOfAbsence: Record "Cause of Absence");
    var
        EmploymentType: Record "Employment Type";
        V_OvertimeHours: Decimal;
        V_Amount: Decimal;
        HrsPerDay: Decimal;
        BasicType: Option BasicPay,SalaryACY,BasicRate,ScaleRate;
        OV_UnpaidHrs: Decimal;
        MonthlyHours: Decimal;
        lEmpAddInfo: Record "Employee Additional Info";
        lExtraSalry: Decimal;
        HumanResourceSetup: Record "Human Resources Setup";
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        MonthlyHours := PayrollFunctions.GetEmployeeMonthlyHours(PayEmployee."No.", CauseOfAbsence.Code);
        HrsPerDay := 0;
        //20190528:A2+
        if lEmpAddInfo.get(PayEmployee."No.") then
            lExtraSalry := lEmpAddInfo."Extra Salary";
        //20190528:A2-
        if PayEmployee."Employment Type Code" <> '' then begin
            EmploymentType.SETRANGE(Code, PayEmployee."Employment Type Code");
            if EmploymentType.FINDFIRST then begin
                HrsPerDay := EmploymentType."Working Hours Per Day";
                OV_UnpaidHrs := EmploymentType."Overtime Unpaid Hours";
            end;
        end;

        if OV_UnpaidHrs = 0 then
            OV_UnpaidHrs := CauseOfAbsence."Unpaid Hours";

        if HrsPerDay = 0 then begin
            if (PayElement."Hours in  Day" > 0) then
                HrsPerDay := PayElement."Hours in  Day"
            else
                HrsPerDay := HRSetup."Hours in the Day";
        end;


        V_OvertimeHours := ROUND(PayDetailHeader."Overtime Days" * HrsPerDay, 0.01, '=');

        V_OvertimeHours := ROUND(V_OvertimeHours + PayDetailHeader."Overtime Hours", 0.01, '=');

        V_OvertimeHours := ROUND(V_OvertimeHours + PayDetailHeader."Overtime with Unpaid Hours", 0.01, '=');

        if V_OvertimeHours <= 0 then
            V_OvertimeHours := 0;

        if MonthlyHours = 0 then
            exit;

        if (ACYComp_Overtime) and (InBothccy) then begin
            V_Amount := VS_Salary / MonthlyHours;
            V_Amount := V_Amount * V_OvertimeHours;
            V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
            PayDetailLine."Amount (ACY)" := V_Amount;
            PayDetailLine."Calculated Amount (ACY)" := V_Amount;
        end;


        if ((not ACYComp_Overtime) or (InBaseccy) or (InAddccy)) then begin
            //Disabled for the case where Basic Pay is 0 but Hourly rate is specified - 24.03.2017 : AIM +
            /*IF V_BasicPay <> 0 THEN
              BEGIN*/
            //Disabled for the case where Basic Pay is 0 but Hourly rate is specified - 24.03.2017 : AIM -
            if PayEmployee."Hourly Rate" <= 0 then
                V_Amount := PayrollFunctions.CaluclateTotalAllowances(PayEmployee, lExtraSalry) / MonthlyHours
            else
                //Modified in order to consider Hourly rate in employee card if allowed in employment type - 18.08.2016 : AIM +
                //V_Amount := PayEmployee."Hourly Rate";
                if (PayrollFunctions.IsScheduleUseEmployeeCardHourlyRate(PayEmployee."No.") = true) or (PayEmployee."Hourly Basis" = true) then
                    V_Amount := PayEmployee."Hourly Rate"
                else begin
                    //20190528:A2+
                    //V_Amount := V_BasicPay / MonthlyHours;
                    //V_Amount := (V_BasicPay + lExtraSalry) / MonthlyHours;
                    V_Amount := PayrollFunctions.CaluclateTotalAllowances(PayEmployee, lExtraSalry) / MonthlyHours;//19062019 EDM+-
                                                                                                                   //20190528:A2-
                                                                                                                   //Modified in order to consider Hourly rate in employee card if allowed in employment type - 18.08.2016 : AIM -
                end;
            V_Amount := V_Amount * V_OvertimeHours;
            V_Amount := PayrollFunctions.RoundingAmt(V_Amount, false);

            PayDetailLine.Amount := ROUND(V_Amount, GetPayrollNETPrecision(), '>');
            PayDetailLine."Calculated Amount" := ROUND(V_Amount, GetPayrollNETPrecision(), '>');
            //Disabled for the case where Basic Pay is 0 but Hourly rate is specified - 24.03.2017 : AIM +
            //END;
            //Disabled for the case where Basic Pay is 0 but Hourly rate is specified - 24.03.2017 : AIM -
            if VA_Salary <> 0 then begin
                V_Amount := V_BasicPay / MonthlyHours;
                V_Amount := V_Amount * V_OvertimeHours;
                V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
                PayDetailLine."Amount (ACY)" := V_Amount;
                PayDetailLine."Calculated Amount (ACY)" := V_Amount;
            end;

        end;


        InsertPayDetailLine(CauseOfAbsence."Associated Pay Element", 'OverTime');

        SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
        if PayElement.Tax = true then
            V_TaxableSalary := V_TaxableSalary + PayDetailLine."Calculated Amount";

    end;

    procedure GetSalaryAbsenceAmount(EmpNo: Code[30]; AbsentDays: Decimal; AbsentHrs: Decimal; BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount; FixedAmount: Decimal) AbsentAmount: Decimal;
    var
        THrs: Decimal;
        AbsDedCode: Code[10];
        L_EmpTbt: Record Employee;
        L_IsHourlyBasis: Boolean;
    begin
        // Added to fix Absent Days - 02.05.2017 : A2+
        //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM +
        L_IsHourlyBasis := false;

        L_EmpTbt.SETRANGE(L_EmpTbt."No.", EmpNo);
        if L_EmpTbt.FINDFIRST then
            L_IsHourlyBasis := L_EmpTbt."Hourly Basis";
        //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM -


        /*if AbsentDays > 0 then begin
          //20190125:A2+
          //if NumberofWorkingDays <= AbsentDays then
          if (NumberofWorkingDays <= AbsentDays) and (NumberofWorkingDays <> 0) then
          //20190125:A2-
            //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM +
            if not ((BasicType = BasicType::FixedAmount) and (L_IsHourlyBasis)) then
            //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM -
              AbsentDays := PayrollFunctions.GetEmployeesScheduleDaysPerMonth(EmpNo,'') - NumberofWorkingDays;
        end;
        */

        //if (AbsentDays > 0) and ( NumberofWorkingDays <= AbsentDays ) and ( NumberofWorkingDays <= 0 )  then begin
        if AbsentDays >= PayrollFunctions.GetEmployeesScheduleDaysPerMonth(EmpNo, '') then begin
            //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM +
            if not ((BasicType = BasicType::FixedAmount) and (L_IsHourlyBasis)) then
                //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM -
                AbsentDays := PayrollFunctions.GetEmployeesScheduleDaysPerMonth(EmpNo, '');// - NumberofWorkingDays - paidvacations;
        end;


        if AbsentDays <= 0 then
            AbsentDays := 0;
        // Added to fix Absent Days - 02.05.2017 : A2-
        //IF PayrollFunctions.GetSalaryAbsenceDeductionCode() = '' THEN //stopped by EDM.SC+-
        if PayrollFunctions.GetSalaryAbsenceDeductionCode(EmpNo) = '' then //EDM.SC+-
            AbsentAmount := CalculateSalaryAbsenceAmount(EmpNo, AbsentDays, AbsentHrs, BasicType, FixedAmount)
        else
            AbsentAmount := 0;

        exit(AbsentAmount);
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
        //The value cannot be 0
        if PayrollParameter."Income Tax Precision" > 0 then
            exit(PayrollParameter."Income Tax Precision")
        else
            exit(1000);
    end;

    local procedure CalculateSalaryAbsenceAmount(EmpNo: Code[30]; AbsentDays: Decimal; AbsentHrs: Decimal; BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount; FixedAmount: Decimal) AbsentAmount: Decimal;
    var
        THrs: Decimal;
        L_emptbt: Record Employee;
        L_IsHourlyBasis: Boolean;
    begin
        //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM +
        L_IsHourlyBasis := false;

        L_emptbt.SETRANGE(L_emptbt."No.", EmpNo);
        if L_emptbt.FINDFIRST then
            L_IsHourlyBasis := L_emptbt."Hourly Basis";
        //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM -


        // Added to fix Absent Days - 02.05.2017 : A2+
        if AbsentDays > 0 then begin
            //20190125:A2+
            //if NumberofWorkingDays <= AbsentDays then
            //if (NumberofWorkingDays <= AbsentDays) and (NumberofWorkingDays <> 0) then
            if AbsentDays >= PayrollFunctions.GetEmployeesScheduleDaysPerMonth(EmpNo, '') then
                //20190125:A2-
                //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM +
                if not ((BasicType = BasicType::FixedAmount) and (L_IsHourlyBasis = true)) then
                    //Added to consider case of Employee who works on Hourly Basis - 21.03.2018 : AIM -
                    AbsentDays := PayrollFunctions.GetEmployeesScheduleDaysPerMonth(EmpNo, '');// - NumberofWorkingDays;
        end;
        if AbsentDays <= 0 then
            AbsentDays := 0;
        // Added to fix Absent Days - 02.05.2017 : A2-
        THrs := (AbsentDays * PayrollFunctions.GetEmployeeDailyHours(EmpNo, '')) + AbsentHrs;
        AbsentAmount := THrs * PayrollFunctions.GetEmployeeBasicHourlyRate(EmpNo, '', BasicType, FixedAmount);

        exit(AbsentAmount);
    end;

    local procedure InsertSalaryAbsenceDeductionPayDetailLine();
    var
        AbsentTHrs: Decimal;
        BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount;
        V_Amount: Decimal;
        EmpNo: Code[20];
        PayElementCode: Code[10];
        PayrollParameterRec: Record "Payroll Parameter";
    begin

        //PayElementCode := PayrollFunctions.GetSalaryAbsenceDeductionCode();//STOPPED BY EDM.SC+-
        PayElementCode := PayrollFunctions.GetSalaryAbsenceDeductionCode(PayEmployee."No.");//EDM.SC+-
        if PayElementCode = '' then
            exit;

        PayElement.GET(PayElementCode);

        EmpNo := PayEmployee."No.";
        PayDetailHeader.CALCFIELDS(PayDetailHeader."Late/ Early Attendance (Hours)", PayDetailHeader."Working Days Affected");
        AbsentTHrs := (PayDetailHeader."Working Days Affected" * PayrollFunctions.GetEmployeeDailyHours(EmpNo, '')) + PayDetailHeader."Late/ Early Attendance (Hours)";

        PayDetailLine.Amount := 0;
        PayDetailLine."Calculated Amount" := 0;

        //Modified in order to consider rate at employee card - 18.08.2016 : AIM +
        //IF PayEmployee."Hourly Basis" = TRUE THEN
        if (PayEmployee."Hourly Basis" = true) or (PayrollFunctions.IsScheduleUseEmployeeCardHourlyRate(PayEmployee."No.") = true) then
        //Modified in order to consider rate at employee card - 18.08.2016 : AIM -
          begin
            V_Amount := AbsentTHrs * PayrollFunctions.GetEmployeeBasicHourlyRate(EmpNo, '', BasicType::HourlyRate, 0);
            V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
            PayDetailLine.Amount := V_Amount;
            PayDetailLine."Calculated Amount" := V_Amount;
            V_ConvertedSalaryPay := V_Amount;
        end
        else begin
            if DailyBasis then
                PayElement2."Days in  Month" := 1;

            if (PayDetailHeader."Converted Salary" <> 0) then begin
                if (ACYComp_ConvertedSalary) and (InBothccy) then begin
                    V_Amount := CalculateSalaryAbsenceAmount(EmpNo, PayDetailHeader."Working Days Affected", PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::FixedAmount, VS_Salary);
                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
                    PayDetailLine."Amount (ACY)" := V_Amount;
                    PayDetailLine."Calculated Amount (ACY)" := V_Amount;
                    ACY_ConvertedSalaryPay := V_Amount;
                end;
            end;
            if ((not ACYComp_ConvertedSalary) or (InBaseccy) or (InAddccy)) then begin
                if V_BasicPay <> 0 then begin
                    //20190528:A2+
                    //V_Amount := CalculateSalaryAbsenceAmount(EmpNo,PayDetailHeader."Working Days Affected",PayDetailHeader."Late/ Early Attendance (Hours)" ,BasicType::FixedAmount,V_BasicPay);
                    V_Amount := CalculateSalaryAbsenceAmount(EmpNo, PayDetailHeader."Working Days Affected", PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::BasicPay, V_BasicPay);
                    //20190528:A2-
                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, false);
                    PayDetailLine.Amount := V_Amount;
                    PayDetailLine."Calculated Amount" := V_Amount;
                    V_ConvertedSalaryPay := V_Amount;
                end;
                if VA_Salary <> 0 then begin
                    V_Amount := CalculateSalaryAbsenceAmount(EmpNo, PayDetailHeader."Working Days Affected", PayDetailHeader."Late/ Early Attendance (Hours)", BasicType::FixedAmount, VA_Salary);
                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
                    PayDetailLine."Amount (ACY)" := V_Amount;
                    PayDetailLine."Calculated Amount (ACY)" := V_Amount;
                    ACY_ConvertedSalaryPay := V_Amount;
                end;
            end;

        end;

        InsertPayDetailLine(PayElementCode, '');

        SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
        if PayElement.Tax = true then
            V_TaxableSalary := V_TaxableSalary - PayDetailLine."Calculated Amount";
    end;

    local procedure DeleteEmployeeTerminationEmployAbsJournals(PayEmp: Record Employee; PayStatus: Record "Payroll Status");
    var
        TrxType: Code[20];
        TrxDescr: Text[50];
        AbsTyp: Code[30];
        EmployTermCode: Code[10];
        EmpJnlLine: Record "Employee Journal Line";
        HRSetup: Record "Human Resources Setup";
    begin
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        //IF (PayEmp."No." = '') OR (PayStatus."Payroll Date" = 0D) OR (PayStatus."Period Start Date" = 0D) OR (PayStatus."Period End Date" = 0D) THEN
        if (PayEmp."No." = '') or (PayStatus."Payroll Date" = 0D) or (G_AttStartDate = 0D) or (G_AttEndDate = 0D) then
            exit;
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-

        HRSetup.GET();
        EmployTermCode := HRSetup."Termination/Employment Code";

        if EmployTermCode = '' then
            exit;

        TrxType := 'ABS';
        AbsTyp := 'ABSENCE';
        TrxDescr := 'System Deducted Days';

        EmpJnlLine.SETRANGE("System Insert", true);
        EmpJnlLine.SETRANGE("Document Status", EmpJnlLine."Document Status"::Approved);
        EmpJnlLine.SETRANGE(Type, AbsTyp);
        EmpJnlLine.SETRANGE("Transaction Type", TrxType);
        EmpJnlLine.SETRANGE(Description, TrxDescr);
        EmpJnlLine.SETRANGE("Cause of Absence Code", EmployTermCode);
        EmpJnlLine.SETRANGE("Employee No.", PayEmp."No.");
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        //EmpJnlLine.SETFILTER("Transaction Date",'%1..%2',PayStatus."Period Start Date", PayStatus."Period End Date");
        EmpJnlLine.SETFILTER("Transaction Date", '%1..%2', G_AttStartDate, G_AttEndDate);
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-

        if EmpJnlLine.FINDFIRST then
            repeat
                EmpJnlLine.DELETE;
            until EmpJnlLine.NEXT = 0;
    end;

    local procedure InsertEmployeeTerminationEmployAbsJournals(PayEmp: Record Employee; PayStatus: Record "Payroll Status"; ResetExisiting: Boolean);
    var
        TrxType: Code[20];
        TrxDescr: Text[50];
        AbsTyp: Code[30];
        EmployTermCode: Code[10];
        EmpJnlLine: Record "Employee Journal Line";
        HRSetup: Record "Human Resources Setup";
        JnlEntryNo: Integer;
        EmpJnlAttendance: Record "Employee Journal Line";
        DaystoDeduct: Integer;
    begin
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        //IF (PayEmp."No." = '') OR (PayStatus."Payroll Date" = 0D) OR (PayStatus."Period Start Date" = 0D) OR (PayStatus."Period End Date" = 0D) THEN
        if (PayEmp."No." = '') or (PayStatus."Payroll Date" = 0D) or (G_AttStartDate = 0D) or (G_AttEndDate = 0D) then
            exit;
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-

        HRSetup.GET();
        EmployTermCode := HRSetup."Termination/Employment Code";

        if EmployTermCode = '' then
            exit;

        if ResetExisiting = true then
            DeleteEmployeeTerminationEmployAbsJournals(PayEmp, PayStatus);

        //If Attendance records exists then the Days before employment and days after termination will be deducted from attendance
        EmpJnlAttendance.SETRANGE("Employee No.", PayEmp."No.");
        // Added for Payroll Attendance Interval - 15.09.2017 : A2+
        //EmpJnlAttendance.SETFILTER("Transaction Date",'%1..%2',PayStatus."Period Start Date", PayStatus."Period End Date");
        EmpJnlAttendance.SETFILTER("Transaction Date", '%1..%2', G_AttStartDate, G_AttEndDate);
        // Added for Payroll Attendance Interval - 15.09.2017 : A2-
        EmpJnlAttendance.SETRANGE("System Insert", false);
        EmpJnlAttendance.SETRANGE(Type, 'ABSENCE');
        EmpJnlAttendance.SETRANGE("Transaction Type", 'ABS');
        if EmpJnlAttendance.FINDFIRST then
            exit;
        //If Attendance records exists then the Days before employment and days after termination will be deducted from attendance

        TrxType := 'ABS';
        AbsTyp := 'ABSENCE';
        TrxDescr := 'System Deducted Days';

        JnlEntryNo := 0;

        EmpJnlLine.SETRANGE("Employee No.", PayEmployee."No.");
        if EmpJnlLine.FINDLAST then
            JnlEntryNo := EmpJnlLine."Entry No.";

        EmpJnlLine.RESET;

        DaystoDeduct := PayrollFunctions.GetDaysInMonth(DATE2DMY(PayStatus."Payroll Date", 2), DATE2DMY(PayStatus."Payroll Date", 3))
                        - PayrollFunctions.GetEmployeeTaxDays(PayEmp."No.", DATE2DMY(PayStatus."Payroll Date", 3), DATE2DMY(PayStatus."Payroll Date", 2), DATE2DMY(PayStatus."Payroll Date", 2));

        if DaystoDeduct > 0 then begin
            EmpJnlLine.INIT;
            EmpJnlLine.VALIDATE("Employee No.", PayEmployee."No.");
            EmpJnlLine."Entry No." := JnlEntryNo + 1;
            EmpJnlLine."Transaction Type" := TrxType;
            EmpJnlLine.VALIDATE("Cause of Absence Code", EmployTermCode);
            // Added for Payroll Attendance Interval - 15.09.2017 : A2+
            //EmpJnlLine."Starting Date":=PayStatus."Period Start Date";
            //EmpJnlLine."Ending Date"  :=PayStatus."Period End Date";
            EmpJnlLine."Starting Date" := G_AttStartDate;
            EmpJnlLine."Ending Date" := G_AttEndDate;
            // Added for Payroll Attendance Interval - 15.09.2017 : A2-
            EmpJnlLine.Type := AbsTyp;
            EmpJnlLine.Description := TrxDescr;
            EmpJnlLine.VALIDATE("Transaction Date", PayStatus."Period Start Date");
            EmpJnlLine.Value := DaystoDeduct;
            EmpJnlLine."Calculated Value" := DaystoDeduct;
            EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Approved;
            EmpJnlLine."System Insert" := true;
            EmpJnlLine.INSERT(true);

            JnlEntryNo := JnlEntryNo + 1;
        end;
    end;

    local procedure InsertPayDetailsPensionSchemeElements(gEmployeeRec: Record Employee);
    begin
        PensionScheme.RESET;
        PensionScheme.SETRANGE(PensionScheme."Amount Type", PensionScheme."Amount Type"::"Fixed Amount");
        PensionScheme.SETFILTER(PensionScheme."Associated Pay Element", '<>%1', '');
        //Added to order to prevent pension schemes of Return Tax and Return MHOOD - 24.08.2016 : AIM +
        // 11.10.2017 : +
        //PensionScheme.SETFILTER(PensionScheme.Type,'<>%1 & <>%2',PensionScheme.Type::ReturnTax,PensionScheme.Type::ReturnMH);
        PensionScheme.SETFILTER(PensionScheme.Type, '<>%1 & <>%2 & <>%3 & <>%4', PensionScheme.Type::ReturnTax, PensionScheme.Type::ReturnMH, PensionScheme.Type::"FundContribution-Basic", PensionScheme.Type::"FundContribution-Net");
        // 11.10.2017 : -
        //Added to order to prevent pension schemes of Return Tax and Return MHOOD - 24.08.2016 : AIM -
        if PensionScheme.FINDFIRST then
            repeat
            begin
                if (PensionScheme.Type = PensionScheme.Type::Insurance) and (gEmployeeRec."Insurance Contribution" > 0) then begin
                    PayDetailLine.INIT;
                    PayElement.GET(PensionScheme."Associated Pay Element");

                    PayDetailLine.Amount := gEmployeeRec."Insurance Contribution";
                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                    InsertPayDetailLine(PensionScheme."Associated Pay Element", '');

                    if not PayElement."Not Included in Net Pay" then
                        SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');

                end;
            end;
            until PensionScheme.NEXT = 0;
    end;

    procedure CopyPayrollDimensions(PayrollGroup: Code[10]; FromPeriod: Date; TillPeriod: Date; OverwriteRec: Boolean);
    var
        PayEmpDimTbt: Record "Employee Dimensions";
        NewPayDim: Record "Employee Dimensions";
        EmpTbt: Record Employee;
        RecExists: Boolean;
        OriPeriodFilter: Date;
    begin
        if (TillPeriod = 0D) or (PayrollGroup = '') then
            exit;


        //Added  - 03.01.2017 : AIM +
        OriPeriodFilter := FromPeriod;
        //Added  - 03.01.2017 : AIM -

        EmpTbt.SETRANGE(EmpTbt."Payroll Group Code", PayrollGroup);
        EmpTbt.SETRANGE(EmpTbt.Status, EmpTbt.Status::Active);

        if EmpTbt.FINDFIRST() then
            repeat

                //Added  - 03.01.2017 : AIM+
                if OriPeriodFilter <> 0D then
                    FromPeriod := OriPeriodFilter
                else
                    FromPeriod := 0D;
                //Added  - 03.01.2017 : AIM -

                if FromPeriod = 0D then begin
                    CLEAR(PayEmpDimTbt);
                    PayEmpDimTbt.SETCURRENTKEY("Employee No.", "Payroll Date");

                    //Added in order to filter by Employee No. - 03.01.2017 : AIM +
                    PayEmpDimTbt.SETRANGE(PayEmpDimTbt."Employee No.", EmpTbt."No.");
                    //Added in order to filter by Employee No. - 03.01.2017 : AIM -

                    if PayEmpDimTbt.FINDLAST() then
                        FromPeriod := PayEmpDimTbt."Payroll Date";
                end;

                if FromPeriod <> 0D then begin
                    RecExists := true;
                    if OverwriteRec = true then
                        RecExists := false;

                    NewPayDim.SETRANGE(NewPayDim."Employee No.", EmpTbt."No.");
                    NewPayDim.SETRANGE(NewPayDim."Payroll Date", TillPeriod);
                    if NewPayDim.FINDFIRST() then begin
                        repeat
                            if OverwriteRec = true then
                                NewPayDim.DELETE;
                        until NewPayDim.NEXT = 0;
                    end
                    else
                        RecExists := false;

                    if RecExists = false then begin
                        CLEAR(PayEmpDimTbt);
                        PayEmpDimTbt.SETRANGE(PayEmpDimTbt."Employee No.", EmpTbt."No.");
                        PayEmpDimTbt.SETRANGE(PayEmpDimTbt."Payroll Date", FromPeriod);
                        if PayEmpDimTbt.FINDFIRST then
                            repeat
                                NewPayDim.INIT;
                                NewPayDim.TRANSFERFIELDS(PayEmpDimTbt);
                                NewPayDim."Payroll Date" := TillPeriod;
                                NewPayDim.INSERT;
                            until PayEmpDimTbt.NEXT = 0;
                    end;
                end;
            until EmpTbt.NEXT = 0;
    end;

    procedure GetGOSIValue(EmpNo: Code[30]) Val: Decimal;
    var
        EMPTbt: Record Employee;
        SpePayElemTbt: Record "Specific Pay Element";
        PayParmTbt: Record "Payroll Parameter";
        EmpCat: Code[10];
        GOSICode: Code[10];
    begin
        if EmpNo = '' then
            exit(0);

        Val := 0;

        PayParmTbt.GET;
        GOSICode := PayParmTbt.GOSI;
        if GOSICode = '' then
            exit(0);


        EMPTbt.SETRANGE("No.", EmpNo);
        if EMPTbt.FINDFIRST then begin
            EmpCat := EMPTbt."Employee Category Code";
            if EmpCat <> '' then begin
                SpePayElemTbt.SETRANGE(SpePayElemTbt."Internal Pay Element ID", GOSICode);
                SpePayElemTbt.SETRANGE(SpePayElemTbt."Employee Category Code", EmpCat);
                if SpePayElemTbt.FINDFIRST then begin
                    if SpePayElemTbt.Amount = 0 then
                        Val := (EMPTbt."Basic Pay" + EMPTbt."House Allowance") * (SpePayElemTbt."% Basic Pay" / 100)
                    else
                        Val := SpePayElemTbt.Amount;

                end;
            end;
        end;

        exit(Val);
    end;

    local procedure FixEmployeeFixedAllowance(PayElemCode: Code[10]; PayElemVal: Decimal) Val: Decimal;
    var
        PayElementTBT: Record "Pay Element";
        PayrollParameter: Record "Payroll Parameter";
        HRSetup: Record "Human Resources Setup";
        PayrollParameterRec: Record "Payroll Parameter";
        HalfVal: Decimal;
        HalfValConverted: Decimal;
    begin
        if (PayElemCode = '') or (PayElemVal = 0) then
            exit(PayElemVal);

        Val := PayElemVal;

        PayElementTBT.SETRANGE(PayElementTBT.Code, PayElemCode);
        if PayElementTBT.FINDFIRST() then begin
            if PayElementTBT."Affected By Attendance Days" = true then begin
                if PayElementTBT."Days in  Month" > 0 then begin
                    //IF (PayDetailHeader."No. of Working Days" - PayDetailHeader."Working Days Affected") > 0 THEN
                    // Val := ROUND((PayElemVal * (PayDetailHeader."No. of Working Days" - PayDetailHeader."Working Days Affected")) / (PayElementTBT."Days in  Month"),0.01)
                    //IF (PayDetailHeader."No. of Working Days" ) > 0 THEN
                    //Val := ROUND((PayElemVal * (PayDetailHeader."No. of Working Days" )) / (PayElementTBT."Days in  Month"),0.01)
                    if (PayElementTBT."Days in  Month" - PayDetailHeader."Working Days Affected") >= 0 then
                        Val := ROUND((PayElemVal * (PayElementTBT."Days in  Month" - PayDetailHeader."Working Days Affected")) / (PayElementTBT."Days in  Month"), 0.01)
                    else
                        Val := 0;
                end;
            end;
        end;
        exit(Val);
    end;

    local procedure FixTotals();
    var
        L_PayDetTBT: Record "Pay Detail Line";
        L_PayElemTbt: Record "Pay Element";
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        V_Allowances := 0;
        VA_Allowances := 0;
        V_TaxAllowances := 0;
        V_NTaxAllowances := 0;
        V_Deductions := 0;
        VA_Deductions := 0;
        V_TaxDeductions := 0;
        V_NTaxDeductions := 0;

        L_PayDetTBT.SETRANGE("Employee No.", PayEmployee."No.");
        L_PayDetTBT.SETRANGE("Tax Year", TaxYear);
        L_PayDetTBT.SETRANGE(Period, PeriodNo);
        L_PayDetTBT.SETRANGE("Payroll Date", PayrollDate);
        L_PayDetTBT.SETRANGE("Payroll Group Code", PayEmployee."Payroll Group Code");
        if L_PayDetTBT.FINDFIRST then
            repeat
                L_PayElemTbt.SETRANGE(L_PayElemTbt.Code, L_PayDetTBT."Pay Element Code");
                if L_PayElemTbt.FINDFIRST then begin
                    if L_PayElemTbt.Type = L_PayElemTbt.Type::Addition then begin
                        V_Allowances := V_Allowances + L_PayDetTBT."Calculated Amount";
                        VA_Allowances := VA_Allowances + L_PayDetTBT."Calculated Amount (ACY)";
                        if (L_PayElemTbt.Tax) and (L_PayElemTbt.Code <> PayParam."Basic Pay Code") then begin
                            V_TaxAllowances := V_TaxAllowances + L_PayDetTBT."Calculated Amount";
                        end else
                            if not L_PayElemTbt.Tax then
                                V_NTaxAllowances := V_NTaxAllowances + L_PayDetTBT."Calculated Amount";
                    end
                    else
                        if L_PayElemTbt.Type = L_PayElemTbt.Type::Deduction then begin
                            V_Deductions := V_Deductions + L_PayDetTBT."Calculated Amount";
                            VA_Deductions := VA_Deductions + L_PayDetTBT."Calculated Amount (ACY)";
                            if (L_PayElemTbt.Code = PayParam."Income Tax Code") then
                                V_TaxDeductions := V_TaxDeductions + L_PayDetTBT."Calculated Amount"
                            else
                                V_NTaxDeductions := V_NTaxDeductions + L_PayDetTBT."Calculated Amount";
                        end;
                end;
            until L_PayDetTBT.NEXT = 0;
    end;

    local procedure ReturnIncomeTaxToEmployee(gEmployeeRec: Record Employee);
    var
        ValToReturn: Decimal;
        PayLineTbT: Record "Pay Detail Line";
        TaxPayElement: Record "Pay Element";
        PayParamCardTBT: Record "Payroll Parameter";
    begin
        PensionScheme.RESET;
        PensionScheme.SETRANGE(PensionScheme.Type, PensionScheme.Type::ReturnTax);
        PensionScheme.SETRANGE(PensionScheme."Payroll Posting Group", gEmployeeRec."Posting Group");
        PensionScheme.SETFILTER(PensionScheme."Associated Pay Element", '<>%1', '');
        if PensionScheme.FINDFIRST then
            repeat
            begin
                ValToReturn := 0;

                if (PensionScheme.Type = PensionScheme.Type::ReturnTax) and ((gEmployeeRec.Declared = gEmployeeRec.Declared::Declared) or (gEmployeeRec.Declared = gEmployeeRec.Declared::Contractual)) then begin
                    PayParamCardTBT.GET();
                    if PayParamCardTBT."Income Tax Code" <> '' then begin
                        TaxPayElement.SETRANGE(TaxPayElement.Code, PayParamCardTBT."Income Tax Code");
                        if TaxPayElement.FINDFIRST then begin
                            PayLineTbT.SETRANGE("Employee No.", gEmployeeRec."No.");
                            PayLineTbT.SETRANGE("Tax Year", TaxYear);
                            PayLineTbT.SETRANGE(Period, PeriodNo);
                            PayLineTbT.SETRANGE("Payroll Date", PayrollDate);
                            PayLineTbT.SETRANGE("Pay Element Code", TaxPayElement.Code);
                            PayLineTbT.SETRANGE(Type, TaxPayElement.Type);
                            PayLineTbT.SETRANGE("Payroll Group Code", gEmployeeRec."Payroll Group Code");
                            if PayLineTbT.FINDFIRST then
                                ValToReturn := PayLineTbT."Calculated Amount";

                            if ValToReturn > 0 then begin
                                PayDetailLine.INIT;
                                PayElement.GET(PensionScheme."Associated Pay Element");

                                PayDetailLine.Amount := ROUND(ValToReturn * (PensionScheme."Employee Contribution %" / 100), 0.01);
                                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                                PayDetailLine."Employer Amount" := ValToReturn * (PensionScheme."Employer Contribution %" / 100);
                                PayDetailLine."Employer Amount" := PayrollFunctions.RoundingAmt(PayDetailLine."Employer Amount", false);
                                InsertPayDetailLine(PensionScheme."Associated Pay Element", '');

                                if not PayElement."Not Included in Net Pay" then
                                    SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
                            end;

                        end;
                    end;
                end;
            end;
            until PensionScheme.NEXT = 0;
        FixTotals;
    end;

    local procedure ReturnMHOODToEmployee(gEmployeeRec: Record Employee);
    var
        ValToReturn: Decimal;
        PayLineTbT: Record "Pay Detail Line";
        MHOODPayElement: Record "Pay Element";
        PensionSchemeTBT: Record "Pension Scheme";
    begin
        PensionScheme.RESET;
        PensionScheme.SETRANGE(Type, PensionScheme.Type::ReturnMH);
        PensionScheme.SETRANGE("Payroll Posting Group", gEmployeeRec."Posting Group");
        PensionScheme.SETFILTER("Associated Pay Element", '<>%1', '');
        if PensionScheme.FINDFIRST then
            repeat
            begin
                ValToReturn := 0;

                if (PensionScheme.Type = PensionScheme.Type::ReturnMH) and ((gEmployeeRec.Declared = gEmployeeRec.Declared::Declared)) then begin
                    PensionSchemeTBT.SETRANGE(Type, PensionScheme.Type::MHOOD);
                    PensionSchemeTBT.SETRANGE("Payroll Posting Group", gEmployeeRec."Posting Group");
                    PensionSchemeTBT.SETFILTER("Associated Pay Element", '<>%1', '');
                    if PensionSchemeTBT.FINDFIRST then begin

                        if PensionSchemeTBT."Associated Pay Element" <> '' then begin
                            MHOODPayElement.SETRANGE(Code, PensionSchemeTBT."Associated Pay Element");
                            if MHOODPayElement.FINDFIRST then begin
                                PayLineTbT.SETRANGE("Employee No.", gEmployeeRec."No.");
                                PayLineTbT.SETRANGE("Tax Year", TaxYear);
                                PayLineTbT.SETRANGE(Period, PeriodNo);
                                PayLineTbT.SETRANGE("Payroll Date", PayrollDate);
                                PayLineTbT.SETRANGE("Pay Element Code", MHOODPayElement.Code);
                                PayLineTbT.SETRANGE(Type, MHOODPayElement.Type);
                                PayLineTbT.SETRANGE("Payroll Group Code", gEmployeeRec."Payroll Group Code");
                                if PayLineTbT.FINDFIRST then
                                    ValToReturn := PayLineTbT."Calculated Amount";

                                if ValToReturn > 0 then begin
                                    PayDetailLine.INIT;
                                    PayElement.GET(PensionScheme."Associated Pay Element");

                                    PayDetailLine.Amount := ROUND(ValToReturn * (PensionScheme."Employee Contribution %" / 100), 0.01);
                                    PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                                    PayDetailLine."Employer Amount" := ValToReturn * (PensionScheme."Employer Contribution %" / 100);
                                    PayDetailLine."Employer Amount" := PayrollFunctions.RoundingAmt(PayDetailLine."Employer Amount", false);
                                    InsertPayDetailLine(PensionScheme."Associated Pay Element", '');

                                    if not PayElement."Not Included in Net Pay" then
                                        SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
                                end;

                            end;
                        end;
                    end;
                end;
            end;
            until PensionScheme.NEXT = 0;
        FixTotals;
    end;

    local procedure CalculateInsuranceTax(L_EmpNo: Code[20]; L_CalcExemptTax: Decimal; L_TaxableSalary: Decimal);
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
        L_Exemp: Decimal;
        L_EmpTbt: Record Employee;
        L_CalcNetTaxSalary: Decimal;
        L_NetTaxSalary: Decimal;
        L_TaxBandTbt: Record "Tax Band";
        L_PayeTax: Decimal;
        L_CalcPayeTax: Decimal;
        L_IncomeTax: Decimal;
        L_PayDetLine: Record "Pay Detail Line";
        L_PensionSchemeTbt: Record "Pension Scheme";
    begin
        //This function is for calculating the Income Tax without 'Insurance Contibution'. The Tax of 'Insurance Contribution' is returned to employee and paid by employer - 04.11.2016: AIM +
        //Analysis is as follows
        //  1. Calculate Income Tax for all taxable Pay Elements except for Insurance Contribution (V1)
        //  2. Tax on Insurance Contribution = Income Tax on all taxable salary - V1
        //  3. Insert a detail line that returns the amount of 'Tax on Insurance Contribution) to employee
        //  4. Insert a detail line that assign the amount of 'Tax on Insurance Contribution) to employer

        if (PayParam."Employee Insurance Tax Code" = '') and (PayParam."Employer Insurance Tax Code" = '') then
            exit;

        if PayParam."Income Tax Code" = '' then
            exit;

        if L_EmpNo = '' then
            exit;

        L_EmpTbt.SETRANGE(L_EmpTbt."No.", L_EmpNo);
        if L_EmpTbt.FINDFIRST = false then
            exit;

        //20181227:A2+
        L_PensionSchemeTbt.SETRANGE("Payroll Posting Group", L_EmpTbt."Posting Group");
        L_PensionSchemeTbt.SETRANGE(Type, L_PensionSchemeTbt.Type::Insurance);
        IF L_PensionSchemeTbt.FINDFIRST THEN
            EXIT;
        //20181227:A2-

        if L_EmpTbt."Insurance Contribution" <= 0 then
            exit;

        L_TaxableSalary := L_TaxableSalary - L_EmpTbt."Insurance Contribution";

        TaxPeriod := 12;

        IF PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = FALSE THEN BEGIN
            //Modified for new Payroll Laws - not to read the Yearly Exemption from Employee Card - 04.06.2018 : AIM +
            //L_Exemp := L_EmpTbt."Exempt Tax" / TaxPeriod;
            L_Exemp := V_YearlyExemptTax / TaxPeriod;
            //Modified for new Payroll Laws - not to read the Yearly Exemption from Employee Card - 04.06.2018 : AIM -
            L_Exemp := (L_Exemp) * (PayrollFunctions.GetEmployeeTaxDays(L_EmpTbt."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                          / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3)));
        END
        ELSE
            //Modified for new Payroll Laws - not to read the Yearly Exemption from Employee Card - 04.06.2018 : AIM +
            //L_Exemp := L_EmpTbt."Exempt Tax" / TaxPeriod;
            L_Exemp := V_YearlyExemptTax / TaxPeriod;
        //Modified for new Payroll Laws - not to read the Yearly Exemption from Employee Card - 04.06.2018 : AIM -
        L_NetTaxSalary := L_TaxableSalary - L_Exemp;
        L_CalcNetTaxSalary := L_TaxableSalary - L_CalcExemptTax; // Current Monthly Taxable Amount

        CLEAR(PayLedgerEntryTEMP);
        TotalTaxablePay := 0;
        TotalMonth := 1;
        TotalTaxPaid := 0;
        TotalFreePay := 0;
        CurrTaxableAmount := 0;

        PayLedgerEntryTEMP.SETCURRENTKEY("Entry No.");
        PayLedgerEntryTEMP.SETRANGE("Tax Year", DATE2DMY(Paystatus."Payroll Date", 3));
        PayLedgerEntryTEMP.SETRANGE("Employee No.", L_EmpTbt."No.");
        PayLedgerEntryTEMP.SETFILTER(Declared, '%1|%2', PayLedgerEntryTEMP.Declared::Declared, PayLedgerEntryTEMP.Declared::"Non-NSSF");

        PayLedgerEntryTEMP.SETRANGE(Open, false);
        if PayLedgerEntryTEMP.FIND('-') then
            repeat
                TotalTaxablePay := TotalTaxablePay + PayLedgerEntryTEMP."Taxable Pay"; // Get total posted taxable amount for current year
                TotalTaxPaid := TotalTaxPaid + PayLedgerEntryTEMP."Tax Paid"; // Get total tax paid for current year
            until PayLedgerEntryTEMP.NEXT = 0;

        CLEAR(PayLedgerEntryTEMP);
        PayLedgerEntryTEMP.SETCURRENTKEY("Entry No.");


        PayLedgerEntryTEMP.SETRANGE("Tax Year", DATE2DMY(Paystatus."Payroll Date", 3));
        PayLedgerEntryTEMP.SETRANGE("Employee No.", L_EmpTbt."No.");
        PayLedgerEntryTEMP.SETRANGE(Open, false);
        PayLedgerEntryTEMP.SETFILTER(Declared, '%1|%2', PayLedgerEntryTEMP.Declared::Declared, PayLedgerEntryTEMP.Declared::"Non-NSSF");
        if PayLedgerEntryTEMP.FIND('-') then
            repeat
                TotalFreePay := TotalFreePay + PayLedgerEntryTEMP."Free Pay";
                if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                    TotalMonth := TotalMonth + (PayrollFunctions.GetEmployeeTaxDays(L_EmpTbt."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                                 / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3)));
                end
                else begin
                    TotalMonth := TotalMonth + 1;
                end;
            until PayLedgerEntryTEMP.NEXT = 0;

        CurrTaxableAmount := L_CalcNetTaxSalary + TotalTaxablePay - TotalFreePay;

        if TotalMonth = 0 then begin
            if PayrollFunctions.IgnoreEmploymentTerminationDatesinTaxCalc() = false then begin
                TotalMonth := PayrollFunctions.GetEmployeeTaxDays(L_EmpTbt."No.", DATE2DMY(Paystatus."Payroll Date", 3), DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 2))
                             / PayrollFunctions.GetDaysInMonth(DATE2DMY(Paystatus."Payroll Date", 2), DATE2DMY(Paystatus."Payroll Date", 3));
            end;
        end;

        Loop := 1;

        while Loop <= 2 do begin
            LastBand := false;
            Computed := false;
            if Loop = 1 then
                Remainder := CurrTaxableAmount
            else
                Remainder := CurrTaxableAmount;
            if L_TaxBandTbt.FIND('-') then
                repeat
                    if Remainder >= (TotalMonth * L_TaxBandTbt."Annual Bandwidth" / TaxPeriod) then begin
                        Computed := true;
                        Remainder := Remainder - (TotalMonth * L_TaxBandTbt."Annual Bandwidth" / TaxPeriod);
                        if Loop = 1 then
                            L_PayeTax := L_PayeTax + (TotalMonth * L_TaxBandTbt."Annual Bandwidth" / TaxPeriod) * (L_TaxBandTbt.Rate / 100)
                        else
                            L_CalcPayeTax := L_CalcPayeTax + (TotalMonth * L_TaxBandTbt."Annual Bandwidth" / TaxPeriod) * (L_TaxBandTbt.Rate / 100);
                    end else begin
                        LastBand := true;
                        if Remainder > 0 then begin
                            if Loop = 1 then
                                L_PayeTax := L_PayeTax + (Remainder * (L_TaxBandTbt.Rate / 100))
                            else
                                L_CalcPayeTax := L_CalcPayeTax + (Remainder * (L_TaxBandTbt.Rate / 100));
                        end;
                    end;
                until (L_TaxBandTbt.NEXT = 0) or (LastBand);
            Loop := Loop + 1;
        end;

        L_CalcPayeTax := PayrollFunctions.RoundingAmt(L_CalcPayeTax, false);
        L_CalcPayeTax := L_CalcPayeTax - TotalTaxPaid;

        if L_CalcPayeTax < 0 then
            L_CalcPayeTax := 0;

        OriTax := L_CalcPayeTax;


        if L_EmpTbt.Declared = L_EmpTbt.Declared::Contractual then begin
            PayParam.GET;
            L_CalcPayeTax := L_TaxableSalary * PayParam."Contractual Tax %" / 100;

            L_CalcPayeTax := ROUND(L_CalcPayeTax, GetIncomeTaxPrecision(), '>')
        end;


        L_PayDetLine.SETRANGE("Employee No.", L_EmpNo);
        L_PayDetLine.SETRANGE("Tax Year", TaxYear);
        L_PayDetLine.SETRANGE(Period, PeriodNo);
        L_PayDetLine.SETRANGE("Payroll Date", PayrollDate);
        L_PayDetLine.SETRANGE("Pay Element Code", PayParam."Income Tax Code");
        L_PayDetLine.SETRANGE("Payroll Group Code", L_EmpTbt."Payroll Group Code");
        if L_PayDetLine.FINDFIRST = false then
            exit
        else begin
            if L_PayDetLine."Calculated Amount" > 0 then
                L_IncomeTax := L_PayDetLine."Calculated Amount"
            else
                exit;
        end;

        if PayParam."Employee Insurance Tax Code" <> '' then begin
            PayElement.GET(PayParam."Employee Insurance Tax Code");
            PayDetailLine.INIT;
            PayDetailLine.Amount := ROUND(L_IncomeTax - L_CalcPayeTax, GetIncomeTaxPrecision());
            PayDetailLine."Calculated Amount" := ROUND(L_IncomeTax - L_CalcPayeTax, GetIncomeTaxPrecision());
            PayDetailLine."Employer Amount" := 0;
            InsertPayDetailLine(PayElement.Code, '');
            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
        end;

        if PayParam."Employer Insurance Tax Code" <> '' then begin
            PayElement.GET(PayParam."Employer Insurance Tax Code");
            PayDetailLine.INIT;
            PayDetailLine.Amount := 0;
            PayDetailLine."Calculated Amount" := 0;
            PayDetailLine."Employer Amount" := ROUND(L_IncomeTax - L_CalcPayeTax, GetIncomeTaxPrecision());
            InsertPayDetailLine(PayElement.Code, '');
        end;

        FixTotals;
        CalculateNetPay;
    end;

    local procedure AddDeductPercentagOfNetSalary(gEmployeeRec: Record Employee);
    begin

        CalculateNetPay;
        PensionScheme.RESET;
        PensionScheme.SETRANGE(PensionScheme.Type, PensionScheme.Type::"Net Salary");
        PensionScheme.SETRANGE(PensionScheme."Payroll Posting Group", gEmployeeRec."Posting Group");
        PensionScheme.SETFILTER(PensionScheme."Associated Pay Element", '<>%1', '');
        if PensionScheme.FINDFIRST then
            repeat
            begin
                PayDetailLine.INIT;
                PayElement.GET(PensionScheme."Associated Pay Element");
                PayDetailLine.Amount := (V_NetSalary * PensionScheme."Employee Contribution %") / 100;
                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                PayDetailLine."Employer Amount" := (V_NetSalary * PensionScheme."Employer Contribution %") / 100;
                InsertPayDetailLine(PensionScheme."Associated Pay Element", '');

                if not PayElement."Not Included in Net Pay" then
                    SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
            end;
            until PensionScheme.NEXT = 0;
        CalculateNetPay;
    end;

    procedure InsertFamilyAllowanceRetro(EmpNo: Code[20]; PDate: Date);
    var
        EmpTbt: Record Employee;
        EmpAddTbt: Record "Employee Additional Info";
        PayDetailLineTbt: Record "Pay Detail Line";
        Paid: Decimal;
        Amt: Decimal;
        FamAllow: Decimal;
        FamAddCode: Code[10];
        FamDedCode: Code[10];
        PayParam: Record "Payroll Parameter";
        HalfAmt: Decimal;
        HalfAmtConverted: Decimal;
    begin
        PayParam.GET();
        FamAddCode := PayParam."Retro Family Allow Addition";
        FamDedCode := PayParam."Retro Family Allow Deduction";

        Amt := PayrollFunctions.GetFamilyAllowanceRetro(EmpNo, PDate);

        if (Amt > 0) and (FamAddCode <> '') then begin
            PayElement.GET(FamAddCode);
            PayDetailLine.INIT;
            PayDetailLine.Amount := Amt;
            PayDetailLine."Calculated Amount" := Amt;
            PayDetailLine."Employer Amount" := 0;
            InsertPayDetailLine(PayElement.Code, '');
            SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
        end
        else
            if (Amt < 0) and (FamDedCode <> '') then begin
                PayElement.GET(FamDedCode);
                PayDetailLine.INIT;
                PayDetailLine.Amount := -Amt;
                PayDetailLine."Calculated Amount" := -Amt;
                PayDetailLine."Employer Amount" := 0;
                InsertPayDetailLine(PayElement.Code, '');
                SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
            end;

        FixTotals;
        CalculateNetPay;
    end;

    procedure GetAttendanceStartDate(PayGrp: Code[20]) L_AttDate: Date;
    var
        PayStatus: Record "Payroll Status";
    begin
        L_AttDate := 0D;
        PayStatus.SETRANGE("Payroll Group Code", PayGrp);
        if PayStatus.FINDFIRST then begin
            if PayrollFunctions.IsSeparateAttendanceInterval(PayGrp) then begin
                if PayStatus."Attendance Start Date" <> 0D then
                    L_AttDate := PayStatus."Attendance Start Date"
                else
                    L_AttDate := PayStatus."Period Start Date";
            end
            else begin
                L_AttDate := PayStatus."Period Start Date";
            end;
        end;

        exit(L_AttDate);
    end;

    procedure GetAttendanceEndDate(PayGrp: Code[20]) L_AttDate: Date;
    var
        PayStatus: Record "Payroll Status";
    begin
        L_AttDate := 0D;
        PayStatus.SETRANGE("Payroll Group Code", PayGrp);
        if PayStatus.FINDFIRST then begin
            if PayrollFunctions.IsSeparateAttendanceInterval(PayGrp) then begin
                if PayStatus."Attendance End Date" <> 0D then
                    L_AttDate := PayStatus."Attendance End Date"
                else
                    L_AttDate := PayStatus."Period End Date";
            end
            else begin
                L_AttDate := PayStatus."Period End Date";
            end;
        end;

        exit(L_AttDate);
    end;

    local procedure GetFundContributionValue(gEmployeeRec: Record Employee);
    var
        l_EmpAddInfo: Record "Employee Additional Info";
        L_ExtraSal: Decimal;
    begin

        l_EmpAddInfo.SETRANGE(l_EmpAddInfo."Employee No.", gEmployeeRec."No.");
        if l_EmpAddInfo.FINDFIRST then
            L_ExtraSal := l_EmpAddInfo."Extra Salary";

        PensionScheme.RESET;
        PensionScheme.SETRANGE(PensionScheme.Type, PensionScheme.Type::"FundContribution-Basic");
        PensionScheme.SETRANGE(PensionScheme."Payroll Posting Group", gEmployeeRec."Posting Group");
        PensionScheme.SETFILTER(PensionScheme."Associated Pay Element", '<>%1', '');
        if PensionScheme.FINDFIRST then
            repeat
            begin
                PayDetailLine.INIT;
                PayElement.GET(PensionScheme."Associated Pay Element");
                PayDetailLine.Amount := ((gEmployeeRec."Basic Pay" + L_ExtraSal) * PensionScheme."Employee Contribution %") / 100;
                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                PayDetailLine."Employer Amount" := ((gEmployeeRec."Basic Pay" + L_ExtraSal) * PensionScheme."Employer Contribution %") / 100;
                InsertPayDetailLine(PensionScheme."Associated Pay Element", '');

                if not PayElement."Not Included in Net Pay" then
                    SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
            end;
            until PensionScheme.NEXT = 0;

        CalculateNetPay;
        PensionScheme.RESET;
        PensionScheme.SETRANGE(PensionScheme.Type, PensionScheme.Type::"FundContribution-Net");
        PensionScheme.SETRANGE(PensionScheme."Payroll Posting Group", gEmployeeRec."Posting Group");
        PensionScheme.SETFILTER(PensionScheme."Associated Pay Element", '<>%1', '');
        if PensionScheme.FINDFIRST then
            repeat
            begin
                PayDetailLine.INIT;
                PayElement.GET(PensionScheme."Associated Pay Element");
                PayDetailLine.Amount := (V_NetSalary * PensionScheme."Employee Contribution %") / 100;
                PayDetailLine."Calculated Amount" := PayDetailLine.Amount;
                PayDetailLine."Employer Amount" := (V_NetSalary * PensionScheme."Employer Contribution %") / 100;
                InsertPayDetailLine(PensionScheme."Associated Pay Element", '');

                if not PayElement."Not Included in Net Pay" then
                    SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", 0, 0, '');
            end;
            until PensionScheme.NEXT = 0;
        CalculateNetPay;
    end;

    local procedure GetAbsCauseCodeDaysForTransportation(EmpNo: Code[20]; AbsCauseCode: Code[10]; FDate: Date; TDate: Date) Cnt: Decimal;
    var
        L_EmpAbsTbt: Record "Employee Absence";
        L_Cnt: Decimal;
        L_CauseAbsTbt: Record "Cause of Absence";
        L_EmpAbsJnlTbt: Record "Employee Journal Line";
    begin
        IF (EmpNo = '') OR (AbsCauseCode = '') OR (FDate = 0D) OR (TDate = 0D) THEN
            EXIT(0);

        /*L_CauseAbsTbt.SETRANGE(L_CauseAbsTbt.Code,AbsCauseCode);
        IF L_CauseAbsTbt.FINDFIRST = FALSE THEN
          EXIT (0)
        ELSE
          BEGIN
            IF L_CauseAbsTbt."Affect Attendance Days" = FALSE THEN
              EXIT(0);
          END;
        */
        L_Cnt := 0;

        L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt."Employee No.", EmpNo);
        L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt."Cause of Absence Code", AbsCauseCode);
        L_EmpAbsTbt.SETFILTER(L_EmpAbsTbt."From Date", '%1..%2', FDate, TDate);
        IF L_EmpAbsTbt.FINDFIRST THEN
            REPEAT
                L_Cnt := L_Cnt + 1;
            UNTIL L_EmpAbsTbt.NEXT = 0;
        /*
        L_EmpAbsJnlTbt.SETRANGE(L_EmpAbsJnlTbt."Employee No.",EmpNo);
        L_EmpAbsJnlTbt.SETRANGE(L_EmpAbsJnlTbt."Cause of Absence Code"  ,AbsCauseCode);
        L_EmpAbsJnlTbt.SETFILTER(L_EmpAbsJnlTbt."Transaction Date",'%1..%2',FDate,TDate);
        IF L_EmpAbsJnlTbt.FINDFIRST THEN
          REPEAT
            L_Cnt := L_Cnt + 1;
          UNTIL L_EmpAbsJnlTbt.next = 0;
        */

        EXIT(L_Cnt);

    end;

    local procedure InsertLateArriveDeductionPayDetailLine();
    var
        AbsentTHrs: Decimal;
        BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount;
        V_Amount: Decimal;
        EmpNo: Code[20];
        PayElementCode: Code[10];
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        PayElementCode := PayrollFunctions.GetSalaryLateArriveDeductionCode();
        if PayElementCode = '' then
            exit;

        PayElement.GET(PayElementCode);

        EmpNo := PayEmployee."No.";
        PayDetailHeader.CALCFIELDS(PayDetailHeader."Late Arrive Hours");
        AbsentTHrs := PayDetailHeader."Late Arrive Hours";
        IF AbsentTHrs <= 0 THEN
            EXIT;
        PayDetailLine.Amount := 0;
        PayDetailLine."Calculated Amount" := 0;
        if (PayEmployee."Hourly Basis" = true) or (PayrollFunctions.IsScheduleUseEmployeeCardHourlyRate(PayEmployee."No.") = true) then begin
            V_Amount := AbsentTHrs * PayrollFunctions.GetEmployeeBasicHourlyRate(EmpNo, '', BasicType::HourlyRate, 0);
            V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
            PayDetailLine.Amount := V_Amount;
            PayDetailLine."Calculated Amount" := V_Amount;
            V_ConvertedSalaryPay := V_Amount;
        end
        else begin
            if DailyBasis then
                PayElement2."Days in  Month" := 1;

            if (PayDetailHeader."Converted Salary" <> 0) then begin
                if (ACYComp_ConvertedSalary) and (InBothccy) then begin
                    V_Amount := CalculateSalaryAbsenceAmount(EmpNo, 0, PayDetailHeader."Late Arrive Hours", BasicType::FixedAmount, VS_Salary);
                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
                    PayDetailLine."Amount (ACY)" := V_Amount;
                    PayDetailLine."Calculated Amount (ACY)" := V_Amount;
                    ACY_ConvertedSalaryPay := V_Amount;
                end;
            end;
            if ((not ACYComp_ConvertedSalary) or (InBaseccy) or (InAddccy)) then begin
                if V_BasicPay <> 0 then begin
                    V_Amount := CalculateSalaryAbsenceAmount(EmpNo, 0, PayDetailHeader."Late Arrive Hours", BasicType::FixedAmount, V_BasicPay);
                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, false);
                    PayDetailLine.Amount := V_Amount;
                    PayDetailLine."Calculated Amount" := V_Amount;
                    V_ConvertedSalaryPay := V_Amount;
                end;
                if VA_Salary <> 0 then begin
                    V_Amount := CalculateSalaryAbsenceAmount(EmpNo, 0, PayDetailHeader."Late Arrive Hours", BasicType::FixedAmount, VA_Salary);
                    V_Amount := PayrollFunctions.RoundingAmt(V_Amount, true);
                    PayDetailLine."Amount (ACY)" := V_Amount;
                    PayDetailLine."Calculated Amount (ACY)" := V_Amount;
                    ACY_ConvertedSalaryPay := V_Amount;
                end;
            end;

        end;

        InsertPayDetailLine(PayElementCode, '');

        SumUpAllowDeduct(PayElement, PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", 0, '');
        if PayElement.Tax = true then
            V_TaxableSalary := V_TaxableSalary - PayDetailLine."Calculated Amount";
    end;
    //edm.sc+
    [IntegrationEvent(False, False)]
    local procedure OnAfterInsertSpePayE(PayEmployee: Record Employee; PayrollDate: Date; PayLedgEntryNo: Integer; TaxYear: Integer; PeriodNo: Integer; Paystatus: Record "Payroll Status");
    begin
    end;
    //edm.sc-         
}

