page 98006 "Attendance View"
{
    // version EDM.HRPY1

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No.";Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name";Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title Description";Rec."Job Title Description")
                {
                    ApplicationArea = All;
                }
                field("Attendance No.";Rec."Attendance No.")
                {
                    ApplicationArea = All;
                }
                field("Employment Type Code";Rec."Employment Type Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = All;
                }
                field("Employment Date";Rec."Employment Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(Control10; "Attendance SubForm")
            {
                SubPageLink = "Employee No." = FIELD("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(Control9; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Hand Punch")
            {
                Image = GeneralLedger;
                RunObject = Page "Hand Punch List";
                RunPageLink = "Attendnace No." = FIELD("Attendance No.");
                Visible = false;
                ApplicationArea = All;
            }
            action("Add Schedule")
            {
                Image = Post;
                Promoted = true;
                RunObject = Report "Add schedule";
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    // Replaced by code in 'Report Add Schedule - 30.12.2015 - AIM +
                    /*
                    EmployeeAbsence.SETRANGE(Period,"AL Starting Date");
                    IF EmployeeAbsence.FINDFIRST THEN
                    REPEAT
                      EmployeeAbsence.DELETE;
                    UNTIL EmployeeAbsence.NEXT=0;
                    */
                    // Replaced by code in 'Report Add Schedule - 30.12.2015 - AIM -

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
            action("Check Attendance")
            {
                Image = Import;
                Promoted = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin

                    // The action { Run Object 'Report Check Hand Punch } is replaced by the function below in order to prevent code redundancy  - 30.12.2015 : AIM +
                    PayrollFunctions.CheckEmployeeAttendance(Rec."No.", Rec.Period);
                    // The action { Run Object 'Report Check Hand Punch } is replaced by the function below in order to prevent code redundancy  - 30.12.2015 : AIM -
                end;
            }
            action("Update Attendance")
            {
                Image = Import;
                Promoted = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin

                    // The action { Run Object 'Report Update Attendance } is replaced by the function below in order to prevent code redundancy  - 30.12.2015 : AIM +
                    PayrollFunctions.GenerateAttendance(Rec."No.", Rec.Period);
                    // The action { Run Object 'Report Update Attendance } is replaced by the function below in order to prevent code redundancy  - 30.12.2015 : AIM -
                end;
            }

            action("Generate Auto Schedule")
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    // The part Code-1 is replaced by the current function in order to prevent code redundancy - 30.12.2015 : AIM +
                    if CONFIRM('Are you sure you want to generate Schedule?', false) = true then begin
                        if PayrollFunctions.AutoGenerateSchedule(Rec."No.", Rec.Period, Rec.Period, true, false) = true then
                            MESSAGE('Schedule Auto Generated')
                        else
                            MESSAGE('An Error Occured During Process')
                    end;
                    // The part Code-1 is replaced by the current function in order to prevent code redundancy - 30.12.2015 : AIM -

                    /*// Code-1  Commented - 30.12.2015 : AIM +
                    Temp.SETRANGE("Employee No.","No.");
                    //Empty existing Temporary Schedule
                    IF Temp.FINDFIRST THEN
                    REPEAT
                      Temp.DELETE;
                    UNTIL Temp.NEXT=0;
                    //Empty existing Temporary Schedule
                    IF NOT Temp.FINDFIRST THEN
                    BEGIN
                      Temp.INIT;
                      Temp."Employee No." :=  "No.";
                      EmpTypeSchedule.SETRANGE("Employment Type Code","Employment Type Code");
                      IF EmpTypeSchedule.FINDFIRST THEN
                      BEGIN
                        Temp."Day 1"  := EmpTypeSchedule."Shift Code";
                        Temp."Day 2"  := EmpTypeSchedule."Shift Code";
                        Temp."Day 3"  := EmpTypeSchedule."Shift Code";
                        Temp."Day 4"  := EmpTypeSchedule."Shift Code";
                        Temp."Day 5"   := EmpTypeSchedule."Shift Code";
                        Temp."Day 6"   := EmpTypeSchedule."Shift Code";
                        Temp."Day 7"  := EmpTypeSchedule."Shift Code";
                        Temp."Day 8" := EmpTypeSchedule."Shift Code";
                        Temp."Day 9" := EmpTypeSchedule."Shift Code";
                        Temp."Day 10" := EmpTypeSchedule."Shift Code";
                        Temp."Day 11":= EmpTypeSchedule."Shift Code";
                        Temp."Day 12" := EmpTypeSchedule."Shift Code";
                        Temp."Day 13" := EmpTypeSchedule."Shift Code";
                        Temp."Day 14" := EmpTypeSchedule."Shift Code";
                        Temp."Day 15" := EmpTypeSchedule."Shift Code";
                        Temp."Day 16" := EmpTypeSchedule."Shift Code";
                        Temp."Day 17":= EmpTypeSchedule."Shift Code";
                        Temp."Day 18":= EmpTypeSchedule."Shift Code";
                        Temp."Day 19":= EmpTypeSchedule."Shift Code";
                        Temp."Day 20":= EmpTypeSchedule."Shift Code";
                        Temp."Day 21":= EmpTypeSchedule."Shift Code";
                        Temp."Day 22":= EmpTypeSchedule."Shift Code";
                        Temp."Day 23":= EmpTypeSchedule."Shift Code";
                        Temp."Day 24":= EmpTypeSchedule."Shift Code";
                        Temp."Day 25":= EmpTypeSchedule."Shift Code";
                        Temp."Day 26":= EmpTypeSchedule."Shift Code";
                        Temp."Day 27":= EmpTypeSchedule."Shift Code";
                        Temp."Day 28":= EmpTypeSchedule."Shift Code";
                        Temp."Day 29":= EmpTypeSchedule."Shift Code";
                        Temp."Day 30":= EmpTypeSchedule."Shift Code";
                        Temp."Day 31":= EmpTypeSchedule."Shift Code";
                        Temp.INSERT;
                        MESSAGE('Schedule Auto Generated');
                      END;
                    END;
                     */// Code-1  Commented - 30.12.2015 : AIM +

                end;
            }
        }
    }

    trigger OnOpenPage();
    var
        HRPermissions: Record "HR Permissions";
        DisableEditingForManager: Boolean;
    begin
        // 20.4.2017 : A2+
        DisableEditingForManager := true;
        HRPermissions.SETRANGE("User ID", USERID);
        if (HRPermissions.FINDFIRST) and (HRPermissions."Attendance Limited Access" = true) then
            DisableEditingForManager := false;
        CurrPage.Control10.Page.SetFilters(Rec."No.", Rec."Payroll Group Code");
        CurrPage.Update;
        // 20.4.2017 : A2-
    end;

    var
        Temp: Record "Import Schedule from Excel";
        PayrollFunctions: Codeunit "Payroll Functions";
}