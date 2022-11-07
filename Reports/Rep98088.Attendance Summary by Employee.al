report 98088 "Attendance Summary by Employee"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Summary by Employee.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(No_Employee; Employee."No.")
            {
            }
            column(FromPeriod; FPeriod)
            {
            }
            column(TillPeriod; TPeriod)
            {
            }
            column(FullName_Employee; Employee."Full Name")
            {
            }
            column(MonthYear; MonthYear)
            {
            }
            column(HourlyRate; HourlyRate)
            {
            }
            column(PaidOvertime; PaidOvertime)
            {
            }
            column(AbsenceDed; AbsenceDed)
            {
            }
            column(TotalAmountToPay; TotalAmountToPay)
            {
            }
            column(DailyRate; DailyRate)
            {
            }
            dataitem("Employee Absence"; "Employee Absence")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                column(CauseofAbsenceCode_EmployeeAbsence; "Employee Absence"."Cause of Absence Code")
                {
                }
                column(AttendHrs_EmployeeAbsence; "Employee Absence"."Attend Hrs.")
                {
                }
                column(Description_EmployeeAbsence; "Employee Absence".Description)
                {
                }
                column(RequiredHrs_EmployeeAbsence; "Employee Absence"."Required Hrs")
                {
                }
                column(ActualAttendHrs_EmployeeAbsence; "Employee Absence"."Actual Attend Hrs")
                {
                }
                column(FromDate_EmployeeAbsence; "Employee Absence"."From Date")
                {
                }
                column(OverTimeHrs; OverTimeHrs)
                {
                }
                column(AbsentHrs; AbsentHrs)
                {
                }
                column(OverTimeAmount; OverTimeAmount)
                {
                }
                column(AbsentAmount; AbsentAmount)
                {
                }
                column(AbsDays; AbsDays)
                {
                }
                column(IsHideSalary; IsHideSalary)
                {
                }

                trigger OnAfterGetRecord();
                var
                    L_JnlLineExist: Boolean;
                    L_AbsJnlLine: Decimal;
                begin
                    OverTimeHrs := 0;
                    AbsentHrs := 0;
                    OverTimeAmount := 0;
                    AbsentAmount := 0;
                    AbsenceDed := 0;
                    PaidOvertime := 0;
                    AbsDays := 0;
                    L_AbsJnlLine := 0;


                    MonthYear := FORMAT(DATE2DMY("Employee Absence"."From Date", 3)) + '-' + FORMAT(DATE2DMY("Employee Absence"."From Date", 2));
                    if "Employee Absence"."Attend Hrs." > "Employee Absence"."Required Hrs" then
                        OverTimeHrs += "Employee Absence"."Attend Hrs." - "Employee Absence"."Required Hrs";

                    if "Employee Absence"."Attend Hrs." < "Employee Absence"."Required Hrs" then
                        AbsentHrs += "Employee Absence"."Required Hrs" - "Employee Absence"."Attend Hrs.";

                    if OverTimeHrs > 0 then
                        OverTimeAmount += OverTimeHrs * HourlyRate;

                    if AbsentHrs > 0 then
                        AbsentAmount += AbsentHrs * HourlyRate;

                    EmpJnlLine.RESET;
                    CLEAR(EmpJnlLine);
                    EmpJnlLine.SETRANGE("Employee No.", Employee."No.");
                    EmpJnlLine.SETRANGE("Transaction Type", 'ABS');
                    EmpJnlLine.SETFILTER("Starting Date", '%1', "Employee Absence"."From Date");
                    EmpJnlLine.SETRANGE("Document Status", EmpJnlLine."Document Status"::Approved);
                    if EmpJnlLine.FINDFIRST then
                        repeat
                            if (EmpJnlLine."Transaction Type" = 'ABS') and (EmpJnlLine."Document Status" = EmpJnlLine."Document Status"::Approved) and
                                (UPPERCASE(EmpJnlLine."Unit of Measure Code") = UPPERCASE('Day')) and (EmpJnlLine."Absence Code Type" = EmpJnlLine."Absence Code Type"::"Unpaid Vacation") and
                                (EmpJnlLine."Affect Work Days" = true) then
                                L_AbsJnlLine += 1
                            else
                                if EmpJnlLine."Cause of Absence Code" = AbsCode then
                                    AbsenceDed := EmpJnlLine."Calculated Value" * HourlyRate * ABSRate
                                else
                                    if EmpJnlLine."Cause of Absence Code" = OvertimeCode then
                                        PaidOvertime := EmpJnlLine."Calculated Value" * HourlyRate * OvertimeRate;


                        until EmpJnlLine.NEXT = 0;
                    L_JnlLineExist := true;

                    if ("Employee Absence".Type = "Employee Absence".Type::"Unpaid Vacation") and ("Employee Absence"."Required Hrs" = 0) and ("Employee Absence"."Attend Hrs." = 0) then
                        AbsDays += 1;

                    if (PayFunction.IsScheduleUseEmployeeCardHourlyRate(Employee."No.")) and (Employee."Hourly Rate" > 0) then
                        AbsenceDed += (L_AbsJnlLine * PayFunction.GetEmployeeDailyHours(Employee."No.", '')) * PayFunction.GetEmployeeBasicHourlyRate(Employee."No.", '', BasicType::HourlyRate, 0)
                    else
                        AbsenceDed += (L_AbsJnlLine * PayFunction.GetEmployeeDailyHours(Employee."No.", '')) * PayFunction.GetEmployeeBasicHourlyRate(Employee."No.", '', BasicType::BasicPay, 0);
                    // 23.11.2017 : A2+
                    TotalAmountToPay := DailyRate * NoOfWD;
                    // 23.11.2017 : A2-
                end;

                trigger OnPreDataItem();
                begin
                    "Employee Absence".SETFILTER("Employee Absence"."From Date", '%1..%2', FPeriod, TPeriod);
                end;
            }

            trigger OnAfterGetRecord();
            var
                CalcEmpPay: Codeunit "Calculate Employee Pay";
                EmpLine: Record "Employee Journal Line";
            begin
                if not EmployeeHasAttendanceData(Employee."No.") then
                    CurrReport.SKIP;

                HourlyRate := 0;
                PaidOvertime := 0;
                AbsenceDed := 0;
                // 23.11.2017 : A2+
                TotalAmountToPay := 0;
                NoOfWD := 0;
                DailyRate := 0;
                // 23.11.2017 : A2-

                if (PayFunction.IsScheduleUseEmployeeCardHourlyRate(Employee."No.")) and (Employee."Hourly Rate" > 0) then begin
                    HourlyRate := PayFunction.GetEmployeeBasicHourlyRate(Employee."No.", '', BasicType::HourlyRate, 0);
                    DailyRate := Employee."Daily Rate";
                end
                else begin
                    HourlyRate := PayFunction.GetEmployeeBasicHourlyRate(Employee."No.", '', BasicType::BasicPay, 0);

                    EmployType.SETRANGE(Code, Employee."Employment Type Code");
                    if EmployType.FINDFIRST then begin
                        IF EmployType."Working Days Per Month" <> 0 then begin//EDM.AI
                            DailyRate := Employee."Basic Pay" / EmployType."Working Days Per Month";
                        end;
                    end;
                end;

                // 23.11.2017 : A2+
                EmpLine.SETRANGE("Employee No.", Employee."No.");
                EmpLine.SETRANGE("Transaction Type", 'ABS');
                EmpLine.SETRANGE("Document Status", EmpLine."Document Status"::Approved);
                EmpLine.SETRANGE("Absence Code Type", EmpLine."Absence Code Type"::"Working Day", EmpLine."Absence Code Type"::"Working Holiday");

                if EmpLine.FINDFIRST then
                    NoOfWD := EmpLine.COUNT;
                // 23.11.2017 : A2-
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("From Period"; FPeriod)
                    {
                        ApplicationArea = All;
                    }
                    field("Till Period"; TPeriod)
                    {
                        ApplicationArea = All;
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

    trigger OnPreReport();
    begin
        if PayFunction.HideSalaryFields() then
            IsHideSalary := true
        else
            IsHideSalary := false;

        AbsCode := PayFunction.GetAttendanceCauseOfAbsenceCode(AttType::Absence);
        OvertimeCode := PayFunction.GetAttendanceCauseOfAbsenceCode(AttType::Overtime);
        ABSRate := 1;
        OvertimeRate := 1;
    end;

    var
        FPeriod: Date;
        TPeriod: Date;
        OverTimeHrs: Decimal;
        AbsentHrs: Decimal;
        OverTimeAmount: Decimal;
        AbsentAmount: Decimal;
        MonthYear: Text;
        HourlyRate: Decimal;
        PaidOvertime: Decimal;
        AbsenceDed: Decimal;
        AbsCode: Code[20];
        OvertimeCode: Code[20];
        PayFunction: Codeunit "Payroll Functions";
        EmpJnlLine: Record "Employee Journal Line";
        AttType: Option Overtime,Absence,WorkingDay,LateArrive;
        CauseOfAbsence: Record "Cause of Absence";
        ABSRate: Decimal;
        OvertimeRate: Decimal;
        CalculateEmpPay: Codeunit "Calculate Employee Pay";
        AbsDays: Decimal;
        BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount;
        IsHideSalary: Boolean;
        DailyRate: Decimal;
        TotalAmountToPay: Decimal;
        NoOfWD: Decimal;
        EmployType: Record "Employment Type";

    local procedure EmployeeHasAttendanceData(EmpNo: Code[20]): Boolean;
    var
        EmpAbs: Record "Employee Absence";
    begin
        EmpAbs.SETRANGE("Employee No.", EmpNo);
        EmpAbs.SETFILTER("From Date", '%1..%2', FPeriod, TPeriod);
        if EmpAbs.FINDFIRST then
            exit(true)
        else
            exit(false);
    end;
}

