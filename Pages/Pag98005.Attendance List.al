page 98005 "Attendance List"
{
    // version EDM.HRPY1

    // 
    // // 30.12.2015 : AIM +
    // // if a customer wants to use the buttons 'Import Schedule ','Generate Auto Schedule' and 'Validate Holiday' (Page Attendance List)
    // // instead of auto generating them from 'Add Schedule'
    // // Then the variable 'VarCreateTemplate' in the report 'Add Schedule' must be set to false in the procedure 'OnInitReport()'
    // // 30.12.2015 : AIM -

    CardPageID = "Attendance View";
    PageType = List;
    SourceTable = Employee;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTableView = WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attendance No."; Rec."Attendance No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    Visible = PeriodVisibility;
                    ApplicationArea = All;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employment Type Code"; Rec."Employment Type Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payroll Group Code"; Rec."Payroll Group Code")
                {
                    ApplicationArea = All;
                }
                field("Last Day Present"; Rec."Last Day Present")
                {
                    Editable = false;
                    Visible = SQLDBAttendance;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control9; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control10; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Schedule)
            {
                action("Import Schedule from Excel")
                {
                    Visible = ManualSchedule;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ConfigPackageRec: Record "Config. Package";
                    begin
                        ConfigPackageRec.SETRANGE(Code, 'SCHEDULE');
                        PAGE.RUN(8614, ConfigPackageRec)
                    end;
                }
                action("Imported Schedule")
                {
                    RunObject = Page "Imported Schedule";
                    Visible = ManualSchedule;
                    ApplicationArea = All;
                }
                action("Add Schedule")
                {
                    Image = Post;
                    RunObject = Report "Add schedule";
                    Visible = ShowActions;
                    ApplicationArea = All;
                }
                action("Generate Auto Schedule")
                {
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if CONFIRM('Are you sure you want to generate Schedule for all Employees?', false) then begin
                            Rec.FINDFIRST;
                            repeat
                                PayrollFunctions.DeleteEmpAttendanceJournals(Rec."No.", Rec.Period);
                                PayrollFunctions.AutoGenerateSchedule(Rec."No.", Rec.Period, Rec.Period, true, true);
                            until Rec.NEXT = 0;
                        end;
                    end;
                }
                action("Import Schedule ")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        EDMUtility: Codeunit "EDM Utility";
                    begin
                        if Temp.FINDFIRST then
                            repeat
                                Temp.DELETE;
                            until Temp.NEXT = 0;
                        EDMUtility.ImportSchedule;
                    end;
                }
            }
            group(Attendance)
            {
                action("Insert Hand Punch")
                {
                    Image = ImportExcel;
                    Visible = ShowActions;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        TempHandPunchRec: Record "Temp Hand Punch";
                        HandPunchRec: Record "Hand Punch";
                        CompanyInfo: Record "Company Information";
                        KyStr: Text;
                    begin
                        if CONFIRM('Are you sure you want to insert Hand Punches?', false) then begin
                            if CONFIRM('Import from File???', true) then begin
                                //
                                IF TempHandPunchRec.FINDFIRST THEN
                                    REPEAT
                                        TempHandPunchRec.DELETE;
                                    UNTIL TempHandPunchRec.NEXT = 0;
                                //
                                if not PayrollFunctions.ImportHandPunch() then
                                    exit;

                                Rec.FINDFIRST;
                                repeat
                                    if PayrollFunctions.CanModifyAttendancePeriod(Rec."No.", Rec.Period, true, false, false, false) = true then begin
                                        PayrollFunctions.CheckEmployeeAttendance(Rec."No.", Rec.Period);
                                        PayrollFunctions.FixEmployeeDailyAttendanceHours(Rec."No.", Rec.Period, 0D, true, 'A0-LA-EL-EA-LL');
                                    end;
                                until Rec.NEXT = 0;

                            end else begin
                                if CONFIRM('Are you sure you want to auto insert punches as per DAILY SHIFTS ???', false) then begin
                                    Rec.FINDFIRST;
                                    repeat
                                        PayrollFunctions.AutoGenerateAttendance(Rec."No.", Rec.Period, true, false, true);
                                    until Rec.NEXT = 0;
                                    Message('Punches Imported as per Daily Shift');
                                end;
                            end;
                        end;
                    end;
                }

                action("Insert Hand Punch-SQL")
                {
                    Caption = 'Insert Hand Punch from Attendance machine';
                    Image = Import;
                    Visible = SQLDBAttendance;
                    ApplicationArea = All;
                    trigger OnAction();
                    var
                        ImportSQLPunches: Report "Import Punches From SQL DB";
                    begin
                        ImportSQLPunches.SetParameters(Rec);
                        ImportSQLPunches.RUNMODAL;
                    end;
                }
                action("Insert Full Attendance")
                {
                    Image = AutoReserve;
                    Promoted = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if CONFIRM('Are you sure you want to auto insert punches as per DAILY SHIFTS ???', false) then begin
                            Rec.FINDFIRST;
                            repeat
                                PayrollFunctions.AutoGenerateAttendance(Rec."No.", Rec.Period, true, false, true);
                            until Rec.NEXT = 0;
                        end;
                    end;
                }

                action("Check Attendance")
                {
                    Image = Import;
                    Promoted = true;
                    RunObject = Report "Check Hand Punch";
                    Visible = false;
                    ApplicationArea = All;
                }

                action("Import Employee Attendance By Project")
                {
                    Visible = false;
                    Caption = 'Import Employee Attendance By Project';
                    Image = ImportExcel;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        ImportEmployeeAttendanceByDimension;
                    end;
                }
                action("Generate Job Journal By Project")
                {
                    Image = JobJournal;
                    Visible = UseresourceConcept;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        GenerateJobJournalForAttendanceByDimension;
                    end;
                }
            }
            group("Leaves & Holidays")
            {
                action("Import Scheduled Leaves")
                {
                    Caption = 'Assign Scheduled Leaves';
                    Image = ApplyEntries;
                    Visible = ShowActions;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin

                        if CONFIRM('Are you sure you want to import Scheduled Leaves', false) then begin
                            IF Rec.FINDFIRST Then
                                Repeat
                                    PayrollFunctions.AssignScheduledLeavesonAttendance(Rec."No.", false);
                                Until Rec.Next = 0;
                            MESSAGE('Data Imported!');
                        end;
                    end;
                }
            }
            group("Attendance Tools")
            {
                action("Attendance Matrix")
                {
                    Image = Dimensions;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        PAGE.RUN(PAGE::"Employee Attendance Matrix");
                    end;
                }
                action("Attendance View")
                {
                    Image = ViewDescription;
                    RunObject = Page "Employee Attendance View";
                    ApplicationArea = All;
                }
                action("Employee Punches Data")//20190121:A2+-
                {
                    Image = CalendarMachine;
                    Visible = SQLDBAttendance;
                    RunObject = Page "Machine Attendance Data";
                    ApplicationArea = All;
                }
                action("View Schedule By Dimension")
                {
                    Image = ViewDetails;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        EmpAttDimTbt: Record "Employees Attendance Dimension";
                        EmpAttDimPg: Page "Employees Attendance Dimension";
                    begin
                        EmpAttDimTbt.SETRANGE("Employee No", Rec."No.");
                        EmpAttDimTbt.SETRANGE(Period, Rec.Period);

                        EmpAttDimPg.SETTABLEVIEW(EmpAttDimTbt);
                        EmpAttDimPg.RUN;
                    end;
                }

                action("Gen. Atten. Job Jrnl By Proj.")
                {
                    Caption = 'Post To Job Journals';
                    RunObject = Report "Gen. Atten. Job Jrnl By Proj.";
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            group("Attendance Journals")
            {
                action("Generate Journal")
                {
                    Caption = 'Generate Attendance Journals';
                    Image = PostBatch;
                    Visible = ShowActions;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        HRSetup.GET;
                        if Rec.FINDFIRST then
                            repeat
                                EmploymentType.SETRANGE(Code, Rec."Employment Type Code");
                                if EmploymentType.FINDFIRST then
                                    if not EmploymentType."Ignore Payroll Posting" then
                                        PayrollFunctions.GenerateAttendance(Rec."No.", Rec.Period);
                            until Rec.NEXT = 0;
                        MESSAGE('Successfully Done');
                    end;
                }
                action("Delete Attendance Journals")
                {
                    Image = Delete;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if CONFIRM('This will delete the related ATTENDANCE JOURNALS. Continue???', false) then begin
                            if CONFIRM('Are you sure ???', false) then begin
                                if Rec.FINDFIRST then
                                    repeat
                                        PayrollFunctions.DeleteEmpAttendanceJournals(Rec."No.", Rec.Period)
              until Rec.NEXT = 0;
                                MESSAGE('Process Done');
                            end;
                        end;
                    end;
                }
                action("Finalize Attendance Period")
                {
                    Image = Period;
                    Visible = ShowFinalizeAction;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        HRSetup: Record "Human Resources Setup";
                        PayrollStatus: Record "Payroll Status";
                    begin
                        HRSetup.GET;
                        IF HRSetup."Seperate Attend From Payroll" THEN BEGIN
                            if CONFIRM('Are you sure you want to finalize attendance ???', false) then begin
                                PayrollStatus.SETRANGE("Payroll Group Code", Rec."Payroll Group Code");
                                PayrollStatus.SetFilter("Attendance Start Date", '<>%1', 0D);
                                PayrollStatus.SetFilter("Attendance End Date", '<>%1', 0D);
                                PayrollStatus.SetFilter("Attendance Period", '<>%1', 0D);
                                if PayrollStatus.FINDFIRST then
                                    repeat
                                        PayrollStatus."Attendance Start Date" := CalcDate('+1M', PayrollStatus."Attendance Start Date");
                                        PayrollStatus."Attendance End Date" := CalcDate('+1M', PayrollStatus."Attendance End Date");
                                        PayrollStatus."Attendance Period" := CalcDate('+1M', PayrollStatus."Attendance Period");
                                        PayrollStatus.MODIFY;
                                    UNTIL PayrollStatus.NEXT = 0;
                                MESSAGE('Period Set');
                            end;
                        END;
                    end;
                }
            }
            group(Reports)
            {
                group("Attendance Reports")
                {
                    Image = SelectReport;
                    action("Attendance Report")
                    {
                        Image = AbsenceCalendar;
                        RunObject = Report "Attendnace By Date";
                        ApplicationArea = All;
                    }
                    action("Attendance Report - Detailed")
                    {
                        Caption = 'Attendance Report - Detailed';
                        Image = AbsenceCategory;
                        RunObject = Report "Attendance Report - Detailed";
                        ApplicationArea = All;
                    }
                    action("Attendance Cost")
                    {
                        Image = "Report";
                        RunObject = Report "Attendance Cost";
                        ApplicationArea = All;
                    }
                    action("Attendance Summarized by Period")
                    {
                        Image = "Report";
                        RunObject = Report "Attendance Summary by Period";
                        ApplicationArea = All;
                    }
                    action("Attendance Summarized by Employee")
                    {
                        Image = "Report";
                        RunObject = Report "Attendance Summary by Employee";
                        ApplicationArea = All;
                    }
                    action("Employees Punches")
                    {
                        Image = "Report";
                        RunObject = Report "Employees Punches";
                        ApplicationArea = All;
                    }
                    action("Attendance Shift Details")
                    {
                        Image = "Report";
                        RunObject = Report "Attendance Shift Codes";
                        ApplicationArea = All;
                    }
                    action("Attendance Report by Project")
                    {
                        Image = Report2;
                        RunObject = Report "Attendance Report by Project";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Attendance vs Portal")
                    {
                        Image = "Report";
                        RunObject = Report "Attendance vs Portal";
                        ApplicationArea = All;
                    }
                    action("Actual Employee Attendance")
                    {
                        Image = "Report";
                        RunObject = Report "Actual Employee Attendance";
                        ApplicationArea = All;
                    }
                }
                action("Employees Cost-Hrs Per Project")
                {
                    visible = false;
                    Caption = 'Labors Cost by Project';
                    Image = "Report";
                    RunObject = Report "Employees Cost-Hrs Per Project";
                    ApplicationArea = All;
                }
            }
            group("Attendance Utilities")
            {
                action("Fix Attended Hours according to Punches")
                {
                    Caption = 'Fix Attended Hours according to Punches';
                    Image = Recalculate;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if CONFIRM('Are you sure you want to Fix Attended Hours?', false) then begin
                            if CONFIRM('You will not be able to Undo Changes. Continue???', false) then begin
                                Rec.FINDFIRST;
                                repeat
                                    if PayrollFunctions.CanModifyAttendancePeriod(Rec."No.", Rec.Period, true, false, false, false) then
                                        PayrollFunctions.FixEmployeeDailyAttendanceHours(Rec."No.", Rec.Period, 0D, true, 'AH-LA-EL-EA-LL');
                                until Rec.NEXT = 0;
                            end;
                        end;
                        MESSAGE('Process Done');
                    end;
                }
                action("Fix Missing Punch as per Attendance Policy")
                {
                    Caption = 'Fix Missing Punch as per Attendance Policy';
                    Image = Recalculate;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if CONFIRM('Are you sure you want to auto fix the missing punches as per Attendance Policy?', false) = false then
                            exit;

                        Rec.FINDFIRST;
                        repeat
                            PayrollFunctions.FixMissingPunchAsPerAttendancePolicy(Rec.Period, Rec."No.");
                        until Rec.NEXT = 0;
                        MESSAGE('Process Done');
                    end;
                }
                action("Fix Missing Attendance as Absent Day")
                {
                    Caption = 'Fix Missing Attendance as Absent Day';
                    Image = Absence;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        HRSetupTBT: Record "Human Resources Setup";
                    begin
                        if CONFIRM('Are you sure you want to fix missiong Attendance as absent day', true) = false then
                            exit
                        else begin
                            HRSetupTBT.GET();
                            if HRSetupTBT.Deduction = '' then
                                ERROR('Deduction Code not specified');
                            Rec.FINDFIRST;
                            repeat
                                EmployeeAbsence.SETRANGE("Employee No.", Rec."No.");
                                if EmployeeAbsence.FINDFIRST then
                                    repeat
                                        if PayrollFunctions.CanModifyAttendanceRecord(EmployeeAbsence."From Date", EmployeeAbsence."Employee No.") then begin
                                            EmployeeAbsence.CALCFIELDS("Hand Punch Exist");
                                            if (EmployeeAbsence.Type = EmployeeAbsence.Type::"Working Day")
                                               and (EmployeeAbsence."Required Hrs" > 0)
                                               and (EmployeeAbsence."Attend Hrs." = 0)
                                               and (EmployeeAbsence."Hand Punch Exist" = false)
                                               and (EmployeeAbsence."Late Arrive" = 0)
                                               and (EmployeeAbsence."Late Leave" = 0)
                                               and (EmployeeAbsence."Early Arrive" = 0)
                                               and (EmployeeAbsence."Early Leave" = 0) then begin
                                                EmployeeAbsence.VALIDATE("Shift Code", HRSetupTBT.Deduction);
                                                EmployeeAbsence.MODIFY;
                                            end;
                                        end;
                                    until EmployeeAbsence.NEXT = 0;
                            until Rec.NEXT = 0;
                        end;
                    end;
                }
            }
            group(Process)
            {
                action("Email Absent Days")
                {
                    Image = Absence;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        AttendanceSummarizedRpt: Report "Attendance Report - Summarized";
                    begin
                        AttendanceSummarizedRpt.SetParameters(true, 0D, 0D, '');
                        AttendanceSummarizedRpt.RUN;
                    end;
                }
                action("Update Attendance Sheet - Web")
                {
                    Image = UpdateDescription;
                    RunObject = Page "Employee Attendance - Web";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Import Attendance from ZOHO")
                {
                    //RunObject = Report Report17450;
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            group(ActionGroup57)
            {
                action(FixOvertime)
                {
                    Caption = 'Fix Overtime';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        Employee: Record Employee;
                        EmployeeAbsence: Record "Employee Absence";
                        EmploymentType: Record "Employment Type";
                        EmpAbsEntitlement: Record "Employee Absence Entitlement";
                        EmpJnlLine: Record "Employee Journal Line";
                        NoOVHAL: Boolean;
                        NoOVRHRS: Boolean;
                        OvrHrs: Decimal;
                        PayrollStatus: Record "Payroll Status";
                        EmpJnlLine1: Record "Employee Journal Line";
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("Payroll Group Code", 'MONTHLY');
                        if Employee.FINDFIRST then
                            repeat
                                if EmploymentType.GET(Employee."Employment Type Code") then
                                    if EmploymentType."Overtime Rate" > 0 then begin
                                        EmployeeAbsence.RESET;
                                        EmployeeAbsence.SETRANGE("Employee No.", Employee."No.");
                                        if EmployeeAbsence.FINDFIRST then
                                            repeat
                                                HRSetup.GET;
                                                IF HRSetup."Use OverTime Unpaid Hours" then BEGIN
                                                    IF (EmployeeAbsence."Attend Hrs." - EmployeeAbsence."Required Hrs") >= EmploymentType."Overtime Unpaid Hours" then
                                                        OvrHrs := EmployeeAbsence."Attend Hrs." - EmployeeAbsence."Required Hrs"
                                                    else
                                                        OvrHrs := 0;
                                                END
                                                else
                                                    OvrHrs := EmployeeAbsence."Attend Hrs." - EmployeeAbsence."Required Hrs" - EmploymentType."Overtime Unpaid Hours";
                                                if OvrHrs > 0 then begin
                                                    EmpAbsEntitlement.RESET;
                                                    EmpAbsEntitlement.SETRANGE("Employee No.", Employee."No.");
                                                    EmpAbsEntitlement.SETRANGE("From Date", DMY2DATE(1, 1, 2018));
                                                    EmpAbsEntitlement.SETRANGE("Cause of Absence Code", 'AL');
                                                    if EmpAbsEntitlement.FINDFIRST then begin
                                                        NoOVHAL := false;
                                                        NoOVRHRS := false;
                                                        EmpJnlLine.RESET;
                                                        EmpJnlLine.SETRANGE("Employee No.", Employee."No.");
                                                        EmpJnlLine.SETRANGE("Starting Date", EmployeeAbsence."From Date");
                                                        EmpJnlLine.SETRANGE("Transaction Type", 'ABS');
                                                        EmpJnlLine.SETRANGE("Cause of Absence Code", 'OVHAL');
                                                        if not EmpJnlLine.FINDFIRST then
                                                            NoOVHAL := true;
                                                        EmpJnlLine.SETRANGE("Cause of Absence Code", 'OVRHRS');
                                                        if EmpJnlLine.FINDFIRST then begin
                                                            repeat
                                                                EmpJnlLine."Cause of Absence Code" := 'OVHAL';
                                                                EmpJnlLine.Description := 'Changed Cause of Absence from "OVRHRS" to "OVHAL"';
                                                                EmpJnlLine.MODIFY;
                                                            until EmpJnlLine.NEXT = 0;
                                                        end else
                                                            NoOVRHRS := true;

                                                        if NoOVHAL and NoOVRHRS then begin
                                                            EmpJnlLine.INIT;
                                                            EmpJnlLine.VALIDATE("Employee No.", Employee."No.");
                                                            EmpJnlLine."Transaction Type" := 'ABS';
                                                            EmpJnlLine.Description := 'Added this line when fixing overtime code';
                                                            EmpJnlLine.VALIDATE("Cause of Absence Code", 'OVHAL');
                                                            EmpJnlLine."Starting Date" := EmployeeAbsence."From Date";
                                                            EmpJnlLine."Ending Date" := EmployeeAbsence."From Date";
                                                            EmpJnlLine.Type := 'ABSENCE';
                                                            EmpJnlLine.VALIDATE("Transaction Date", EmployeeAbsence.Period);
                                                            EmpJnlLine.VALIDATE(Value, OvrHrs);
                                                            EmpJnlLine."Opened By" := USERID;
                                                            EmpJnlLine."Opened Date" := WORKDATE;
                                                            EmpJnlLine."Released By" := USERID;
                                                            EmpJnlLine."Released Date" := WORKDATE;
                                                            EmpJnlLine."Approved By" := USERID;
                                                            EmpJnlLine."Approved Date" := WORKDATE;
                                                            EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Approved;
                                                            EmpJnlLine1.RESET;
                                                            EmpJnlLine1.SETRANGE("Employee No.", Employee."No.");
                                                            EmpJnlLine1.SETRANGE("Transaction Date", EmployeeAbsence.Period);
                                                            EmpJnlLine1.SETRANGE("Transaction Type", 'ABS');
                                                            if EmpJnlLine1.FINDFIRST then begin
                                                                EmpJnlLine."Processed Date" := EmpJnlLine1."Processed Date";
                                                                EmpJnlLine.Processed := EmpJnlLine1.Processed;
                                                            end;
                                                            EmpJnlLine.INSERT(true);
                                                        end;
                                                    end;
                                                end;
                                            until EmployeeAbsence.NEXT = 0;
                                    end;
                            until Employee.NEXT = 0;

                        MESSAGE('Finished');
                    end;
                }
                action(FixLateAbsence)
                {
                    Caption = 'Fix Late Absence';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        Employee: Record Employee;
                        EmployeeAbsence: Record "Employee Absence";
                        EmploymentType: Record "Employment Type";
                        EmpAbsEntitlement: Record "Employee Absence Entitlement";
                        EmpJnlLine: Record "Employee Journal Line";
                        LateArrive: Decimal;
                        PayrollStatus: Record "Payroll Status";
                        EmpJnlLine1: Record "Employee Journal Line";
                        PayrollFunctions: Codeunit "Payroll Functions";
                        ALBalance: Decimal;
                        AbsentHrs: Decimal;
                        AbsentRate: Decimal;
                        L: Decimal;
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("Payroll Group Code", 'MONTHLY');
                        //Employee.SETRANGE("No.",'0134');
                        if Employee.FINDFIRST then
                            repeat
                                if EmploymentType.GET(Employee."Employment Type Code") then
                                    if EmploymentType.Code <> '' then//   "Absence Deduction Rate" > 0 THEN
                                    begin
                                        /* ALBalance := 0;
                                           PayrollFunctions.UpdateEmpEntitlementTotals(EmployeeAbsence.Period,Employee."No.");
                                           ALBalance := PayrollFunctions.GetEmpAbsenceEntitlementCurrentBalance(Employee."No.",HRSetup."Annual Leave Code",0D);
                                           ALBalance := ROUND(ALBalance * PayrollFunctions.GetEmployeeDailyHours(Employee."No.",''));
                                   */
                                        EmployeeAbsence.RESET;
                                        EmployeeAbsence.SETRANGE("Employee No.", Employee."No.");
                                        if EmployeeAbsence.FINDFIRST then
                                            repeat


                                                LateArrive := 0;
                                                LateArrive := EmployeeAbsence."Late Arrive";
                                                //
                                                AbsentHrs := 0;
                                                AbsentRate := 0;
                                                if (EmployeeAbsence."Required Hrs" > 0) and (EmployeeAbsence."Attend Hrs." > 0) then
                                                    AbsentHrs := EmployeeAbsence."Required Hrs" - EmployeeAbsence."Attend Hrs.";
                                                if AbsentHrs <= 0 then
                                                    AbsentHrs := 0;
                                                AbsentHrs := AbsentHrs - (LateArrive / 60);
                                                if AbsentHrs <= 0 then
                                                    AbsentHrs := 0;
                                                AbsentRate := 0;
                                                //EmploymentType.SETRANGE(EmploymentType.Code,Employee."Employment Type Code");
                                                //IF EmploymentType.FINDFIRST THEN
                                                //  BEGIN
                                                AbsentHrs := AbsentHrs - EmploymentType."Absence Tolerance Hours";
                                                AbsentRate := EmploymentType."Absence Deduction Rate";
                                                AbsentHrs := AbsentHrs * AbsentRate;
                                                //   END;

                                                if AbsentHrs <= 0 then
                                                    AbsentHrs := 0;

                                                LateArrive := PayrollFunctions.CalculateLateArrivePenalty('LATEARRIVE', LateArrive, 'HOUR', Employee."No.");
                                                LateArrive := LateArrive + AbsentHrs;
                                                /*
                                                IF ALBalance <= 0  THEN
                                                  LateArrive := 0
                                                ELSE
                                                  BEGIN
                                                    IF LateArrive >= ALBalance THEN
                                                      begin
                                                         L := LateArrive;
                                                         LateArrive := ALBalance;
                                                         ALBalance := ALBalance - L;
                                                      END;
                                                  END;
                                                  */
                                                //
                                                if LateArrive > 0 then begin
                                                    EmpAbsEntitlement.RESET;
                                                    EmpAbsEntitlement.SETRANGE("Employee No.", Employee."No.");
                                                    EmpAbsEntitlement.SETRANGE("From Date", DMY2DATE(1, 1, 2018));
                                                    EmpAbsEntitlement.SETRANGE("Cause of Absence Code", 'AL');
                                                    if EmpAbsEntitlement.FINDFIRST then begin
                                                        EmpJnlLine.RESET;
                                                        EmpJnlLine.SETRANGE("Employee No.", Employee."No.");
                                                        EmpJnlLine.SETRANGE("Starting Date", EmployeeAbsence."From Date");
                                                        EmpJnlLine.SETRANGE("Transaction Type", 'ABS');
                                                        EmpJnlLine.SETFILTER("Cause of Absence Code", '%1|%2', 'LATENESS', 'ABSAL');
                                                        if not EmpJnlLine.FINDFIRST then begin
                                                            EmpJnlLine.INIT;
                                                            EmpJnlLine.VALIDATE("Employee No.", Employee."No.");
                                                            EmpJnlLine."Transaction Type" := 'ABS';
                                                            EmpJnlLine.Description := 'Added this line when fixing late absence';
                                                            EmpJnlLine.VALIDATE("Cause of Absence Code", 'ABSAL');
                                                            EmpJnlLine."Starting Date" := EmployeeAbsence."From Date";
                                                            EmpJnlLine."Ending Date" := EmployeeAbsence."From Date";
                                                            EmpJnlLine.Type := 'ABSENCE';
                                                            EmpJnlLine.VALIDATE("Transaction Date", EmployeeAbsence.Period);
                                                            EmpJnlLine.VALIDATE(Value, LateArrive);//PayrollFunctions.CalculateLateArrivePenalty('LATEARRIVE',LateArrive,'HOUR',Employee."No."));
                                                            EmpJnlLine.VALIDATE("Calculated Value", EmpJnlLine.Value);
                                                            EmpJnlLine."Opened By" := USERID;
                                                            EmpJnlLine."Opened Date" := WORKDATE;
                                                            EmpJnlLine."Released By" := USERID;
                                                            EmpJnlLine."Released Date" := WORKDATE;
                                                            EmpJnlLine."Approved By" := USERID;
                                                            EmpJnlLine."Approved Date" := WORKDATE;
                                                            EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Approved;
                                                            EmpJnlLine1.RESET;
                                                            EmpJnlLine1.SETRANGE("Employee No.", Employee."No.");
                                                            EmpJnlLine1.SETRANGE("Transaction Date", EmployeeAbsence.Period);
                                                            EmpJnlLine1.SETRANGE("Transaction Type", 'ABS');
                                                            if EmpJnlLine1.FINDFIRST then begin
                                                                EmpJnlLine."Processed Date" := EmpJnlLine1."Processed Date";
                                                                EmpJnlLine.Processed := EmpJnlLine1.Processed;
                                                            end;
                                                            EmpJnlLine.INSERT(true);
                                                        end//;
                                                        else begin
                                                            if EmpJnlLine."Cause of Absence Code" = 'ABSAL' then begin
                                                                EmpJnlLine.VALIDATE(Value, LateArrive);//PayrollFunctions.CalculateLateArrivePenalty('LATEARRIVE',LateArrive,'HOUR',Employee."No."));
                                                                EmpJnlLine.VALIDATE("Calculated Value", EmpJnlLine.Value);
                                                                if EmpJnlLine.Description = '' then
                                                                    EmpJnlLine.Description := 'EDIT this line when fixing late absence'
                                                                else
                                                                    EmpJnlLine.Description := EmpJnlLine.Description + '^FLAU';
                                                                EmpJnlLine.MODIFY(true);
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            until EmployeeAbsence.NEXT = 0;
                                    end;
                            until Employee.NEXT = 0;

                        MESSAGE('Finished');

                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SetFilter("Current Date Filter", '=%1', WorkDate);

        AttendanceOfficerPermission := PayFunction.IsAttendanceOfficer(UserId);
        IF not AttendanceOfficerPermission then
            Error('No Permission!');
        //Added in order to show only employees who have correct info for Attendance - 28.12.2016 : A2+
        Rec.FILTERGROUP(2);
        Rec.SETFILTER("Full Name", '<>%1', '');
        Rec.SETFILTER("Attendance No.", '<>%1', 0);
        Rec.SETFILTER(Period, '<>%1', 0D);
        Rec.SETFILTER("Employment Date", '<>%1', 0D);
        Rec.SETFILTER("Employment Type Code", '<>%1', '');
        Rec.SETFILTER(Status, '=%1', Rec.Status::Active);
        Rec.SetFilter("Payroll Group Code", '<>%1', '');//20190121:A2+-
        //Add in order to show only Employees related to Manager - 18.04.2017 : A2+
        HRPermission.SETRANGE("User ID", USERID);
        if (HRPermission.FINDFIRST) and (HRPermission."Attendance Limited Access") and (HRPermission."Assigned Employee Code" <> '') then
            Rec.SETFILTER("Manager No.", HRPermission."Assigned Employee Code");
        //Add in order to show only Employees related to Manager - 18.04.2017 : A2-
        Rec.FILTERGROUP(0);
        //Added in order to show only employees who have correct info for Attendance - 28.12.2016 : A2-
        // Added in order to show or hide "Finalize Attendance" & Actions - 20.04.2017 : A2+
        F_ShowFinalizeAction();
        F_ShowActions();
        // Added in order to show or hide "Finalize Attendance" & Actions - 18.04.2017 : A2-
        HRSetup.GET;
        ManualSchedule := HRSetup."Manual Schedule";
        UseResourceConcept := PayFunction.IsFeatureVisible('ResourcesConcept');
        ;
        SQLDBAttendance := HRSetup."Auto Synchronize Attendance";
        PeriodVisibility := Not HRSetup."Seperate Attend From Payroll";
    end;

    var
        Temp: Record "Import Schedule from Excel";
        ManualSchedule: Boolean;
        EmployeeAbsence: Record "Employee Absence";
        HRSetup: Record "Human Resources Setup";
        PeriodVisibility: Boolean;
        EmploymentType: Record "Employment Type";
        VarDate: Date;
        PayrollFunctions: Codeunit "Payroll Functions";
        HRPermission: Record "HR Permissions";
        ShowFinalizeAction: Boolean;
        ShowActions: Boolean;
        PayFunction: Codeunit "Payroll Functions";
        UseResourceConcept: Boolean;
        AttendanceOfficerPermission: Boolean;
        SQLDBAttendance: Boolean;

    local procedure F_ShowFinalizeAction();
    var
        EmploymentType: Record "Employment Type";
    begin
        ShowFinalizeAction := false;
        if Rec.FINDFIRST then
            repeat
                EmploymentType.SETRANGE(Code, Rec."Employment Type Code");
                if EmploymentType.FINDFIRST then
                    if EmploymentType."Manual Finalize" = true then
                        ShowFinalizeAction := true;
            until Rec.NEXT = 0;
    end;

    local procedure F_ShowActions();
    var
        HRPermission: Record "HR Permissions";
    begin
        ShowActions := true;
        HRPermission.SETRANGE("User ID", USERID);
        if HRPermission.FINDFIRST and HRPermission."Attendance Limited Access" then
            ShowActions := false;
    end;

    local procedure ImportEmployeeAttendanceByDimension();
    var
        UpdateAttendance: Boolean;
    begin
        //EDM.EmpAttDim+
        if CONFIRM('Are you sure you want to import employee attendance by project?', false) then begin
            if not Payrollfunctions.ImportEmpAttendanceByDimensionFromExcel then
                exit;

            UpdateAttendance := CONFIRM('Update Attended Hours?', false);
            if Rec.FINDFIRST then
                repeat
                    if not Payrollfunctions.ValidateEmpAttendanceByDimensionFromExcel(Rec."No.", Rec.Period, Rec."Attendance No.", UpdateAttendance) then
                        ERROR('');
                until Rec.NEXT = 0;
            MESSAGE('Process Done');
        end;
        //EDM.EmpAttDim-
    end;

    local procedure GenerateJobJournalForAttendanceByDimension();
    begin
        //EDM.EmpAttDim+
        //IF CONFIRM ('Are you sure you want to generate job journal for employee attendance by project?',FALSE) THEN
        //BEGIN
        REPORT.RUNMODAL(REPORT::"Gen. Atten. Job Jrnl By Proj.", true, false, Rec);
        //MESSAGE('Process Done');
        //END;
        //EDM.EmpAttDim-
    end;
}

