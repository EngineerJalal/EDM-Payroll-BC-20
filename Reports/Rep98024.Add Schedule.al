report 98024 "Add schedule"
{
    // version EDM.HRPY1

    // 
    // // 30.12.2015 : AIM +
    // // if a customer wants to use the buttons 'Import Schedule ' and 'Generate Auto Schedule' (Page Attendance List)
    // // instead of auto generating them from 'Report Add Schedule'
    // // Then the variable 'VarCreateTemplate' must be set to false in the procedure 'OnInitReport()'
    // // 30.12.2015 : AIM -

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = WHERE(Status = CONST(Active));
            RequestFilterFields = "No.";
            dataitem("Import Schedule from Excel"; "Import Schedule from Excel")
            {
                DataItemLink = "Employee No." = FIELD("No.");

                trigger OnAfterGetRecord();
                var
                    L_EmpAbsTbt: Record "Employee Absence";
                    L_DailyShiftTbt: Record "Daily Shifts";
                begin
                    // Check if Attendance Period can  be modified - 31.12.2015 : AIM +
                    if not PayrollFunctions.CanModifyAttendancePeriod(Employee."No.", VarCDate, true, false, false, false) then
                        exit;
                    // Check if Attendance Period can  be modified - 31.12.2015 : AIM -

                    //Modified so that attendance does not exceed Payroll Date especially for 15 Days Interval - 19.03.2018 : AIM +
                    if (AttendDaysCount <= 0) or (AttendDaysCount > 31) then
                        AttendDaysCount := 30;
                    for VarI := 1 to AttendDaysCount do begin
                        //Modified so that attendance does not exceed Payroll Date especially for 15 Days Interval - 19.03.2018 : AIM -
                        VarShift := '';
                        case true of
                            VarI = 1:
                                VarShift := "Import Schedule from Excel"."Day 1";
                            VarI = 2:
                                VarShift := "Import Schedule from Excel"."Day 2";
                            VarI = 3:
                                VarShift := "Import Schedule from Excel"."Day 3";
                            VarI = 4:
                                VarShift := "Import Schedule from Excel"."Day 4";
                            VarI = 5:
                                VarShift := "Import Schedule from Excel"."Day 5";
                            VarI = 6:
                                VarShift := "Import Schedule from Excel"."Day 6";
                            VarI = 7:
                                VarShift := "Import Schedule from Excel"."Day 7";
                            VarI = 8:
                                VarShift := "Import Schedule from Excel"."Day 8";
                            VarI = 9:
                                VarShift := "Import Schedule from Excel"."Day 9";
                            VarI = 10:
                                VarShift := "Import Schedule from Excel"."Day 10";
                            VarI = 11:
                                VarShift := "Import Schedule from Excel"."Day 11";
                            VarI = 12:
                                VarShift := "Import Schedule from Excel"."Day 12";
                            VarI = 13:
                                VarShift := "Import Schedule from Excel"."Day 13";
                            VarI = 14:
                                VarShift := "Import Schedule from Excel"."Day 14";
                            VarI = 15:
                                VarShift := "Import Schedule from Excel"."Day 15";
                            VarI = 16:
                                VarShift := "Import Schedule from Excel"."Day 16";
                            VarI = 17:
                                VarShift := "Import Schedule from Excel"."Day 17";
                            VarI = 18:
                                VarShift := "Import Schedule from Excel"."Day 18";
                            VarI = 19:
                                VarShift := "Import Schedule from Excel"."Day 19";
                            VarI = 20:
                                VarShift := "Import Schedule from Excel"."Day 20";
                            VarI = 21:
                                VarShift := "Import Schedule from Excel"."Day 21";
                            VarI = 22:
                                VarShift := "Import Schedule from Excel"."Day 22";
                            VarI = 23:
                                VarShift := "Import Schedule from Excel"."Day 23";
                            VarI = 24:
                                VarShift := "Import Schedule from Excel"."Day 24";
                            VarI = 25:
                                VarShift := "Import Schedule from Excel"."Day 25";
                            VarI = 26:
                                VarShift := "Import Schedule from Excel"."Day 26";
                            VarI = 27:
                                VarShift := "Import Schedule from Excel"."Day 27";
                            VarI = 28:
                                VarShift := "Import Schedule from Excel"."Day 28";
                            VarI = 29:
                                VarShift := "Import Schedule from Excel"."Day 29";
                            VarI = 30:
                                VarShift := "Import Schedule from Excel"."Day 30";
                            VarI = 31:
                                VarShift := "Import Schedule from Excel"."Day 31";
                        end;

                        EmplAttendance.RESET;
                        EmplAttendance.SETRANGE(EmplAttendance."Employee No.", Employee."No.");
                        EmplAttendance.SETRANGE(EmplAttendance."From Date", VarCDate);
                        if EmplAttendance.FINDFIRST and VarOvWr then
                            EmplAttendance.DELETE;

                        if not EmplAttendance.FINDFIRST then begin
                            EmplAttendance.INIT;
                            EmplAttendance."Employee No." := Employee."No.";
                            EmplAttendance.VALIDATE("From Date", VarCDate);
                            EmplAttendance."To Date" := VarCDate;
                            if VarShift <> '' then begin
                                DailyShift.GET(VarShift);
                                EmplAttendance."From Time" := DailyShift."From Time";
                                EmplAttendance."To Time" := DailyShift."To Time";
                                EmplAttendance."Break" := DailyShift."Break";

                                // Added in order to insert schedule as per Payroll Interval - 17.03.2016 : AIM +
                                if VarUsePayrollInterval = true then
                                    EmplAttendance.Period := VarDate
                                else
                                    EmplAttendance.Period := DMY2DATE(1, VarMonth, VarYear);
                                // Added in order to insert schedule as per Payroll Interval - 17.03.2016 : AIM -

                                EmplAttendance.VALIDATE("Cause of Absence Code", DailyShift."Cause Code");
                                EmplAttendance."Entry No." := VarLNo;
                                EmplAttendance.VALIDATE(EmplAttendance."Shift Code", VarShift);
                                EmplAttendance.VALIDATE("To Date", VarCDate);
                                EmplAttendance."Attendance No." := Employee."Attendance No.";
                                EmplAttendance."Inserted By" := USERID;
                                EmplAttendance.INSERT;
                            end;
                        end else begin
                            if VarShift <> '' then begin
                                if PayrollFunctions.CanModifyEmployeeAttendance(EmplAttendance."Employee No.", EmplAttendance."From Date", EmplAttendance."To Date", true) then begin
                                    DailyShift.GET(VarShift);
                                    EmplAttendance."From Time" := DailyShift."From Time";
                                    EmplAttendance."To Time" := DailyShift."To Time";
                                    EmplAttendance."Break" := DailyShift."Break";

                                    // Added in order to insert schedule as per Payroll Interval - 17.03.2016 : AIM +
                                    if VarUsePayrollInterval = true then
                                        EmplAttendance.Period := VarDate
                                    else
                                        EmplAttendance.Period := DMY2DATE(1, VarMonth, VarYear);
                                    // Added in order to insert schedule as per Payroll Interval - 17.03.2016 : AIM -

                                    EmplAttendance.VALIDATE("Cause of Absence Code", DailyShift."Cause Code");
                                    EmplAttendance.VALIDATE(EmplAttendance."Shift Code", VarShift);
                                    EmplAttendance.VALIDATE("To Date", VarCDate);
                                    //Reset below fields in order to help the user detect any change in Daily Shift Type
                                    EmplAttendance."Attend Hrs." := 0;
                                    EmplAttendance."Late Arrive" := 0;
                                    EmplAttendance."Early Leave" := 0;
                                    EmplAttendance."Early Arrive" := 0;
                                    EmplAttendance."Late Leave" := 0;
                                    //Reset below fields in order to help the user detect any change in Daily Shift Type
                                    EmplAttendance.MODIFY;
                                end;
                            end;
                        end;

                        //Added in order to auto assign days before employment date as absent - 24.03.2017 : AIM +
                        if (Employee.Status = Employee.Status::Active) and (Employee."Employment Date" <> 0D) and (HRSetupTBT.Deduction <> '') then begin
                            L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt."Employee No.", Employee."No.");
                            L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt."From Date", VarCDate);
                            if L_EmpAbsTbt.FINDFIRST then
                                repeat
                                    if L_EmpAbsTbt."From Date" < Employee."Employment Date" then begin
                                        L_DailyShiftTbt.SETRANGE(L_DailyShiftTbt."Cause Code", HRSetupTBT.Deduction);
                                        if L_DailyShiftTbt.FINDFIRST then begin
                                            L_EmpAbsTbt.VALIDATE(L_EmpAbsTbt."Cause of Absence Code", HRSetupTBT.Deduction);
                                            L_EmpAbsTbt.VALIDATE(L_EmpAbsTbt."Shift Code", L_DailyShiftTbt."Shift Code");
                                            L_EmpAbsTbt.MODIFY(true);
                                        end;
                                    end;
                                until L_EmpAbsTbt.NEXT = 0;
                        end;
                        //Added in order to auto assign days before employment date as absent - 24.03.2017 : AIM -

                        if VarUsePayrollInterval then
                            InsertEmpAttDefaultDim(Employee."No.", VarDate, VarCDate, VarOvWr)
                        else
                            InsertEmpAttDefaultDim(Employee."No.", DMY2DATE(1, VarMonth, VarYear), VarCDate, VarOvWr);

                        //Added in order to auto assign days before employment date and after termination date as absent - 02.06.2017 : AIM +
                        FixEmploymentTerminationDays(Employee."No.", VarDate);
                        //Added in order to auto assign days before employment date and after termination date as absent - 02.06.2017 : AIM -

                        // Added in order to update Attendance Record in case of 'Weekly Schedule' - 31.12.2015 : AIM +
                        VarCDate := CALCDATE('+1D', VarCDate);

                        //Modified in order to increment by one and not 10000 - 15.04.2016 : AIM +
                        //VarLNo := VarLNo + 10000;
                        VarLNo := VarLNo + 1;
                        //Modified in order to increment by one and not 10000 - 15.04.2016 : AIM -
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            var
                L_IsSeparateAttendanceInterval: Boolean;
            begin
                //Added in order to consider Attendance Interval - 18.09.2017 : A2+
                //V. Important: 'Use Payroll Interval' must be false if 'Seperate Attendance Interval' is true
                L_IsSeparateAttendanceInterval := PayrollFunctions.IsSeparateAttendanceInterval(Employee."Payroll Group Code");

                if L_IsSeparateAttendanceInterval then
                    VarUsePayrollInterval := false;
                //Added in order to consider Attendance Interval - 18.09.2017 : A2-

                //Added as a validation - 24.03.2017 : AIM +
                if Employee.Status <> Employee.Status::Active then
                    CurrReport.SKIP;
                //Modified in order to prevent creating a schedule for a period not yet reached - 08.04.2017 : AIM +
                if Employee.Period > RptDateFilter then
                    //Modified in order to prevent creating a schedule for a period not yet reached - 08.04.2017 : AIM -
                    CurrReport.SKIP;
                //Added as a validation - 24.03.2017 : AIM -
                RecNo := RecNo + 1;

                Window.UPDATE(2, ROUND(RecNo / TotalRecNo * 10000, 1));
                Window.UPDATE(1, Employee."No.");

                //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
                VarDate := Employee.Period;

                if Employee."Pay Frequency" = Employee."Pay Frequency"::Weekly then
                    VarUsePayrollInterval := true;
                //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +

                // Check if Attendance Period can  be modified - 31.12.2015 : AIM +
                if (PayrollFunctions.CanModifyAttendancePeriod("No.", VarDate, true, false, false, false) = false) then
                    exit;
                // Check if Attendance Period can  be modified - 31.12.2015 : AIM -


                // Auto Create Schedule Temp Data - 30.12.2015 : AIM +
                if VarCreateTemplate then begin
                    if not VarSelImp then begin
                        // Added in order to insert schedule as per Payroll Interval - 17.03.2016 : AIM +
                        FDate := VarDate;
                        TDate := VarDate;
                        PayrollStatus.RESET;
                        CLEAR(PayrollStatus);

                        if VarUsePayrollInterval then begin
                            PayrollStatus.SETRANGE(PayrollStatus."Payroll Group Code", "Payroll Group Code");
                            if PayrollStatus.FINDFIRST then begin
                                if (DATE2DMY(PayrollStatus."Period Start Date", 3) = DATE2DMY(VarDate, 3))
                                   and (DATE2DMY(PayrollStatus."Period Start Date", 2) = DATE2DMY(VarDate, 2))
                                   and (PayrollStatus."Period Start Date" <> 0D)
                                   and (PayrollStatus."Period End Date" <> 0D) then begin
                                    FDate := PayrollStatus."Period Start Date";
                                    TDate := PayrollStatus."Period End Date";
                                end;
                            end;
                            //Added in order to consider Attendance Interval - 18.09.2017 : A2+
                        end
                        else begin
                            PayrollStatus.SETRANGE(PayrollStatus."Payroll Group Code", "Payroll Group Code");
                            if PayrollStatus.FINDFIRST then begin
                                if (L_IsSeparateAttendanceInterval)
                                   and (PayrollStatus."Attendance Start Date" <> 0D)
                                   and (PayrollStatus."Attendance End Date" <> 0D) then begin
                                    if (DATE2DMY(PayrollStatus."Attendance End Date", 2) = DATE2DMY(VarDate, 2))
                                       and (DATE2DMY(PayrollStatus."Attendance End Date", 3) = DATE2DMY(VarDate, 3)) then begin
                                        FDate := PayrollStatus."Attendance Start Date";
                                        TDate := PayrollStatus."Attendance End Date";
                                        VarCDate := PayrollStatus."Attendance Start Date";
                                        VarYear := DATE2DMY(TDate, 3);
                                        VarMonth := DATE2DMY(TDate, 2);
                                    end;
                                end;
                            end;
                            //Added in order to consider Attendance Interval - 18.09.2017 : A2-
                        end;

                        //Added so that attendance does not exceed Payroll Date especially for 15 Days Interval - 19.03.2018 : AIM +
                        if TDate > FDate then
                            AttendDaysCount := (TDate - FDate) + 1;
                        //Added so that attendance does not exceed Payroll Date especially for 15 Days Interval - 19.03.2018 : AIM +
                        PayrollFunctions.AutoGenerateSchedule("No.", FDate, TDate, true, true);
                        // Added in order to insert schedule as per Payroll Interval - 17.03.2016 : AIM -
                    end;
                end;
                // Auto Create Schedule Temp Data -  30.12.2015 : AIM -
                //18.09.2017 : A2+
                if (not L_IsSeparateAttendanceInterval) then
                    //18.09.2017 : A2-
                    VarCDate := VarDate;
                //EmplAttendance.SETRANGE(EmplAttendance."Employee No.",Employee."No.");

                //Added in order to reset the variable and filter by employee no - 15.04.2016 : AIM +
                EmplAttendance.RESET;
                //Disbale this setrange cause employee no is not key in the table
                //EmplAttendance.SETRANGE(EmplAttendance."Employee No.",Employee."No.");//20180919:A2+- AIM +-
                //Added in order to reset the variable and filter by employee no - 15.04.2016 : AIM -
                if EmplAttendance.FINDLAST then
                    VarLNo := EmplAttendance."Entry No." + 1
                else
                    VarLNo := 1;

                if not L_IsSeparateAttendanceInterval then begin
                    VarYear := DATE2DMY(VarCDate, 3);
                    VarMonth := DATE2DMY(VarCDate, 2);
                    if VarMonth > 12 then begin
                        VarMonth := 1;
                        VarYear := VarYear + 1;
                    end;
                end;

                // Delete Employee Hand Punches for the related period - 30.12.2015 - AIM +
                if VarOvWr then begin
                    EmployeeAbsence.SETRANGE("Employee No.", "No.");
                    EmployeeAbsence.SETRANGE(Period, VarDate);
                    if EmployeeAbsence.FINDFIRST then
                        repeat
                            HandPunch.SETRANGE("Attendnace No.", EmployeeAbsence."Attendance No.");
                            HandPunch.SETRANGE("Real Date", EmployeeAbsence."From Date");
                            if HandPunch.FINDFIRST then
                                repeat
                                    HandPunch.DELETE;
                                until HandPunch.NEXT = 0;
                            EmployeeAbsence.DELETE;
                        until EmployeeAbsence.NEXT = 0;
                end;
                // Delete Employee Hand Punches for the related period - 30.12.2015 - AIM +
            end;

            trigger OnPostDataItem();
            begin
                //Added in order to assign Holidays directly from 'Add Schedule' - 24.03.2017 : AIM +
                PayrollFunctions.ValidateEmployeeAttendanceHolidays("No.", VarDate);
                //Added in order to assign Holidays directly from 'Add Schedule' - 24.03.2017 : AIM -
            end;

            trigger OnPreDataItem();
            begin
                // Insert Schedule Temp Data +
                if VarCreateTemplate = true then begin
                    if VarSelImp = true then    // Import Schedule from Excel - Replaces 'Import Schedule' (Page Attendance List)
                      begin
                        if Temp.FINDFIRST then
                            repeat
                                Temp.DELETE;
                            until Temp.NEXT = 0;
                        EDMUtility.ImportSchedule
                    end
                end;
                // Insert Schedule Temp Data -
                Window.OPEN(Text002 + Text001);
                TotalRecNo := Employee.COUNT;


                if VarOvWr = true then
                    if CONFIRM('Are You sure you want to OVERWRITE the specified Period ???', false) = true then
                        if CONFIRM('This will also delete all Related ATTENDANCES !!!! Proceed ??', false) = false then
                            VarOvWr := false;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Filter")
                {
                    field("Starting Date"; VarDate)
                    {
                        ApplicationArea = All;


                        trigger OnValidate();
                        begin
                            //Added in order to save the date filter entered by user - 08.04.2017 : AIM +
                            RptDateFilter := VarDate;
                            //Added in order to save the date filter entered by user - 08.04.2017 : AIM -
                        end;
                    }
                    field("Add From Import Schedule"; VarSelImp)
                    {
                        ApplicationArea = All;

                    }
                    field("Overwrite existent"; VarOvWr)
                    {
                        ApplicationArea = All;

                    }
                    field("Use Payroll Interval"; VarUsePayrollInterval)
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

    trigger OnInitReport();
    begin
        VarCreateTemplate := true;

        VarSelImp := false;

        //Added in order to set default period - 29.12.2016 : AIM +
        VarDate := DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
        //Added in order to set default period - 29.12.2016 : AIM -

        //Added in order to save the date filter entered by user - 08.04.2017 : AIM +
        RptDateFilter := VarDate;
        //Added in order to save the date filter entered by user - 08.04.2017 : AIM -

        //Added so that attendance does not exceed Payroll Date especially for 15 Days Interval - 19.03.2018 : AIM +
        AttendDaysCount := 31;
        //Added so that attendance does not exceed Payroll Date especially for 15 Days Interval - 19.03.2018 : AIM -
    end;

    trigger OnPostReport();
    begin
        //Added in order to assign scheduled leaves - 25.07.2016  : AIM +
        PayrollFunctions.AssignScheduledLeavesonAttendance('', false);
        //Added in order to assign scheduled leaves - 25.07.2016  : AIM -
        Message('Schedule has been created');
    end;

    var
        AttendCause: Record "Cause of Absence";
        DailyShift: Record "Daily Shifts";
        EmplAttendance: Record "Employee Absence";
        VarDate: Date;
        VarCDate: Date;
        VarSelImp: Boolean;
        VarI: Integer;
        VarShift: Code[20];
        VarYear: Integer;
        VarMonth: Integer;
        VarDay: Integer;
        VarLNo: Integer;
        VarOvWr: Boolean;
        Window: Dialog;
        TotalRecNo: Integer;
        RecNo: Integer;
        Test: Integer;
        Text001: Label 'Imported @2@@@@@@@@@@@@@@@@@@@@@@@@@\';
        Text002: Label 'Employee #1########################\\';
        Temp: Record "Import Schedule from Excel";
        EDMUtility: Codeunit "EDM Utility";
        VarCreateTemplate: Boolean;
        EmployeeAbsence: Record "Employee Absence";
        HandPunch: Record "Hand Punch";
        PayrollFunctions: Codeunit "Payroll Functions";
        VarUsePayrollInterval: Boolean;
        PayrollStatus: Record "Payroll Status";
        FDate: Date;
        TDate: Date;
        HRSetupTBT: Record "Human Resources Setup";
        RptDateFilter: Date;
        AttendDaysCount: Integer;

    local procedure FixEmploymentTerminationDays(EmpNo: Code[20]; VDate: Date);
    var
        L_Employee: Record Employee;
        L_EmpAbsTbt: Record "Employee Absence";
        L_DailyShiftTbt: Record "Daily Shifts";
    begin
        L_Employee.SETRANGE("No.", EmpNo);
        if not L_Employee.FINDFIRST then
            exit;

        if (L_Employee.Status = L_Employee.Status::Active) and (L_Employee."Employment Date" <> 0D) and (HRSetupTBT.Deduction <> '') then begin
            L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt."Employee No.", Employee."No.");
            L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt.Period, VDate);
            if L_EmpAbsTbt.FINDFIRST = true then
                repeat
                    if L_EmpAbsTbt."From Date" < L_Employee."Employment Date" then begin
                        L_DailyShiftTbt.SETRANGE(L_DailyShiftTbt."Cause Code", HRSetupTBT.Deduction);
                        if L_DailyShiftTbt.FINDFIRST = true then begin
                            L_EmpAbsTbt.VALIDATE(L_EmpAbsTbt."Cause of Absence Code", HRSetupTBT.Deduction);
                            L_EmpAbsTbt.VALIDATE(L_EmpAbsTbt."Shift Code", L_DailyShiftTbt."Shift Code");
                            L_EmpAbsTbt.MODIFY(true);
                        end;
                    end;
                until L_EmpAbsTbt.NEXT = 0;
        end;

        if (L_Employee.Status = L_Employee.Status::Active) and (L_Employee."Termination Date" <> 0D) and (HRSetupTBT.Deduction <> '') then begin
            L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt."Employee No.", Employee."No.");
            L_EmpAbsTbt.SETRANGE(L_EmpAbsTbt.Period, VDate);
            if L_EmpAbsTbt.FINDFIRST = true then
                repeat
                    if L_EmpAbsTbt."From Date" > L_Employee."Termination Date" then begin
                        L_DailyShiftTbt.SETRANGE(L_DailyShiftTbt."Cause Code", HRSetupTBT.Deduction);
                        if L_DailyShiftTbt.FINDFIRST = true then begin
                            L_EmpAbsTbt.VALIDATE(L_EmpAbsTbt."Cause of Absence Code", HRSetupTBT.Deduction);
                            L_EmpAbsTbt.VALIDATE(L_EmpAbsTbt."Shift Code", L_DailyShiftTbt."Shift Code");
                            L_EmpAbsTbt.MODIFY(true);
                        end;
                    end;
                until L_EmpAbsTbt.NEXT = 0;
        end;
    end;

    local procedure InsertEmpAttDefaultDim(EmpNo: Code[20]; AttPeriod: Date; AttDate: Date; Overwrite: Boolean);
    var
        SchedSysLine: Record "Scheduling System Line";
        SchedSys: Record "Scheduling System";
        PayFunction: Codeunit "Payroll Functions";
        EmpAttDim: Record "Employees Attendance Dimension";
        EDMUtility: Codeunit "EDM Utility";
        EmpTbt: Record Employee;
        NoOfDays: Integer;
        i: Integer;
        AttDay: Text;
        AttHrs: Decimal;
        EmpAbs: Record "Employee Absence";
        Ln: Integer;
    begin
        if (EmpNo = '') or (AttPeriod = 0D) then
            exit;

        if Overwrite then begin
            EmpAttDim.SETRANGE(EmpAttDim."Employee No", EmpNo);
            EmpAttDim.SETRANGE(EmpAttDim.Period, AttPeriod);
            EmpAttDim.SETRANGE("Attendance Date", AttDate);
            if EmpAttDim.FINDFIRST then
                EmpAttDim.DELETEALL;
        end;

        EmpAttDim.RESET;
        CLEAR(EmpAttDim);

        EmpAttDim.SETRANGE(EmpAttDim."Employee No", EmpNo);
        EmpAttDim.SETRANGE(EmpAttDim.Period, AttPeriod);
        EmpAttDim.SETRANGE("Attendance Date", AttDate);
        if EmpAttDim.FINDFIRST then
            exit;

        Ln := 1;

        EmpAttDim.RESET;
        CLEAR(EmpAttDim);
        if EmpAttDim.FINDLAST then
            Ln := EmpAttDim."Line No" + 1;

        SchedSys.SETCURRENTKEY("Academic Year", "Document No");
        SchedSys.SETRANGE("Employee No", EmpNo);
        SchedSys.SETRANGE("Is Inactive", false);
        if SchedSys.FINDLAST then begin
            AttDay := EDMUtility.GetDayDate(AttDate);

            SchedSysLine.RESET();
            CLEAR(SchedSysLine);
            SchedSysLine.SETRANGE("Document No", SchedSys."Document No");

            case AttDay of
                'Monday':
                    SchedSysLine.SETRANGE("Week Day", SchedSysLine."Week Day"::Monday);
                'Tuesday':
                    SchedSysLine.SETRANGE("Week Day", SchedSysLine."Week Day"::Tuesday);
                'Wednesday':
                    SchedSysLine.SETRANGE("Week Day", SchedSysLine."Week Day"::Wednesday);
                'Thursday':
                    SchedSysLine.SETRANGE("Week Day", SchedSysLine."Week Day"::Thursday);
                'Friday':
                    SchedSysLine.SETRANGE("Week Day", SchedSysLine."Week Day"::Friday);
                'Saturday':
                    SchedSysLine.SETRANGE("Week Day", SchedSysLine."Week Day"::Saturday);
                'Sunday':
                    SchedSysLine.SETRANGE("Week Day", SchedSysLine."Week Day"::Sunday);
            end;

            if SchedSysLine.FINDFIRST then
                repeat
                    EmpAttDim.RESET;
                    CLEAR(EmpAttDim);

                    EmpAttDim.INIT;
                    EmpAttDim."Line No" := Ln;
                    EmpAttDim."Employee No" := EmpNo;
                    EmpAttDim.Period := AttPeriod;
                    EmpAttDim."Required Hrs" := SchedSysLine.Hours;
                    EmpAttDim."Attended Hrs" := SchedSysLine.Hours;
                    EmpAttDim."Attendance Date" := AttDate;
                    EmpAttDim."From Time" := SchedSysLine."From Time";
                    EmpAttDim."To Time" := SchedSysLine."To Time";
                    EmpAttDim."Global Dimension 1" := SchedSysLine."Global Dimension 1";
                    EmpAttDim."Global Dimension 2" := SchedSysLine."Global Dimension 2";
                    EmpAttDim."Shortcut Dimension 3" := SchedSysLine."Shortcut Dimension 3";
                    EmpAttDim."Shortcut Dimension 4" := SchedSysLine."Shortcut Dimension 4";
                    EmpAttDim."Shortcut Dimension 5" := SchedSysLine."Shortcut Dimension 5";
                    EmpAttDim."Shortcut Dimension 6" := SchedSysLine."Shortcut Dimension 6";
                    EmpAttDim."Shortcut Dimension 7" := SchedSysLine."Shortcut Dimension 7";
                    EmpAttDim."Shortcut Dimension 8" := SchedSysLine."Shortcut Dimension 8";
                    EmpAttDim."Created By" := USERID;
                    EmpAttDim."Created DateTime" := CREATEDATETIME(WORKDATE, TIME);

                    case AttDay of
                        'Monday':
                            EmpAttDim."Attendance Day" := EmpAttDim."Attendance Day"::Monday;
                        'Tuesday':
                            EmpAttDim."Attendance Day" := EmpAttDim."Attendance Day"::Tuesday;
                        'Wednesday':
                            EmpAttDim."Attendance Day" := EmpAttDim."Attendance Day"::Wednesday;
                        'Thursday':
                            EmpAttDim."Attendance Day" := EmpAttDim."Attendance Day"::Thursday;
                        'Friday':
                            EmpAttDim."Attendance Day" := EmpAttDim."Attendance Day"::Friday;
                        'Saturday':
                            EmpAttDim."Attendance Day" := EmpAttDim."Attendance Day"::Saturday;
                        'Sunday':
                            EmpAttDim."Attendance Day" := EmpAttDim."Attendance Day"::Sunday;
                    end;

                    EmpAbs.SETRANGE("Employee No.", EmpNo);
                    EmpAbs.SETRANGE("From Date", AttDate);
                    if (EmpAbs.FINDFIRST) and (EmpAbs."Required Hrs" <> 0) then
                        EmpAttDim.INSERT;
                    Ln += 1;
                until SchedSysLine.NEXT = 0;
        end;
    end;
}

