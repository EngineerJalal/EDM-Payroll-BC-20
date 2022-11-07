page 98075 "Employee Attendance View"
{
    // version EDM.HRPY1

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SaveValues = false;
    SourceTable = "Employee Absence";

    layout
    {
        area(content)
        {
            group(Filters)
            {
                field(FromDate; FDate)
                {
                    Caption = 'From Date';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        TDate := FDate;
                    end;
                }
                field(TillDate; TDate)
                {
                    Caption = 'Till Date';
                    ApplicationArea = All;
                }
                field(Employee; EmpNoFilter)
                {
                    TableRelation = Employee."No." WHERE(Status = FILTER(Active));
                    ApplicationArea = All;
                }
                field("Employment Type"; EmploymentType)
                {
                    TableRelation = "Employment Type".Code;
                    ApplicationArea = All;
                }
                field("Payroll Group"; PayrollGroup)
                {
                    TableRelation = "HR Payroll Group".Code;
                    ApplicationArea = All;
                }
                field("Employee Category Group"; EmpCategoryCode)
                {
                    TableRelation = "Employee Categories".Code;
                    ApplicationArea = All;
                }
                field("Manager No"; ManagerNo)
                {
                    Enabled = false;
                    TableRelation = Employee;
                    ApplicationArea = All;
                }
                field("Employee Dimension1"; Dimension1)
                {
                    CaptionClass = '1,1,1';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                    ApplicationArea = All;
                }
                field("Employee Dimension2"; Dimension2)
                {
                    CaptionClass = '1,1,2';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                    ApplicationArea = All;
                }
                field(Department; Dimension3)
                {
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
                    ApplicationArea = All;
                }
                field("Attendance Type"; AttendDRowType)
                {
                    Caption = 'Attendance Type';
                    ApplicationArea = All;
                }
                field("Daily Shift Code"; DailyShift)
                {
                    TableRelation = "Daily Shifts"."Shift Code";
                    ApplicationArea = All;
                }
            }
            repeater(Group)
            {
                field("Employee Name"; "Employee Name")
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attendance No."; "Attendance No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("From Date"; "From Date")
                {
                    Caption = 'Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("From Time"; "From Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("To Time"; "To Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Day of the Week"; "Day of the Week")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shift Code"; "Shift Code")
                {
                    Editable = Editible;
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Required Hrs"; "Required Hrs")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attend Hrs."; "Attend Hrs.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Hand Punch Exist"; "Hand Punch Exist")
                {
                    ApplicationArea = All;
                }
                field("Late Arrive"; "Late Arrive")
                {
                    Editable = Editible;
                    ApplicationArea = All;
                }
                field("Early Leave"; "Early Leave")
                {
                    Editable = Editible;
                    ApplicationArea = All;
                }
                field("Early Arrive"; "Early Arrive")
                {
                    Editable = Editible;
                    ApplicationArea = All;
                }
                field("Late Leave"; "Late Leave")
                {
                    Editable = Editible;
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field("Actual Attend Hrs"; "Actual Attend Hrs")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Late Arrive"; "Actual Late Arrive")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Early Leave"; "Actual Early Leave")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Early Arrive"; "Actual Early Arrive")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Late Leave"; "Actual Late Leave")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Refresh List")
            {
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    CurrPage.UPDATE;
                    SETFILTER("Employee Status", 'Active');
                    SETFILTER("Employee Name", '<>%1', '');
                    SETFILTER("Employee No.", EmpNoFilter);
                    SETFILTER("Employment Type", EmploymentType);
                    SETFILTER("Employee Category", EmpCategoryCode);
                    SETFILTER("Employee Dimension1", Dimension1);
                    SETFILTER("Employee Dimension2", Dimension2);
                    SETFILTER("Payroll Group", PayrollGroup);
                    SETFILTER("Employee Manager No", ManagerNo);
                    SETFILTER("Shift Code", DailyShift);

                    if (FDate <> 0D) and (TDate <> 0D) then
                        SETFILTER("From Date", '>=%1 & <=%2 ', FDate, TDate);

                    if AttendDRowType = AttendDRowType::"No Attendance" then begin
                        SETFILTER("Hand Punch Exist", '=%1', false);
                        SETFILTER("Attend Hrs.", '=%1', 0);
                        SETFILTER("Required Hrs", '>%1', 0);
                    end
                    else
                        if AttendDRowType = AttendDRowType::"Invalid Punch" then begin
                            SETFILTER("Hand Punch Exist", '=%1', true);
                            SETFILTER("Attend Hrs.", '=%1', 0);
                            SETFILTER("Required Hrs", '>%1', 0);
                        end
                        else
                            if AttendDRowType = AttendDRowType::"Has Attendance" then begin
                                SETFILTER("Attend Hrs.", '>%1', 0);
                                SETFILTER(Type, '=%1|%2', Type::"Working Day", Type::"Working Holiday");
                            end
                            else begin
                                SETRANGE("Required Hrs");
                                SETRANGE("Attend Hrs.");
                                SETRANGE("Hand Punch Exist");
                            end;
                    // Added in order to filter by ZOHO ID - 21.03.2017 : A2+
                    if HasZOHOID = true then
                        SETFILTER("ZOHO ID", '<>%1', '')
                    else
                        SETFILTER("ZOHO ID", '=%1|<>%2', '', '');
                    // Added in order to filter by ZOHO ID - 21.03.2017 : A2-

                    FILTERGROUP(0);
                end;
            }
            action("Assign as Absent Day")
            {
                Image = Absence;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Visible = Visible;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if Rec.FINDFIRST = false then
                        exit;

                    HRSetupTBT.GET();
                    if HRSetupTBT.Deduction = '' then
                        ERROR('Deduction COde not specified');

                    Rec.FINDFIRST;
                    repeat
                        if PayrollFunctions.CanModifyAttendanceRecord(Rec."From Date", Rec."Employee No.") = true then begin
                            Rec.CALCFIELDS("Hand Punch Exist");
                            if (Rec.Type = Rec.Type::"Working Day") and (Rec."Required Hrs" > 0) and (Rec."Attend Hrs." = 0) and (Rec."Hand Punch Exist" = false)
                               and (Rec."Late Arrive" = 0) and (Rec."Late Leave" = 0) and (Rec."Early Arrive" = 0) and (Rec."Early Leave" = 0) then begin
                                Rec.VALIDATE("Shift Code", HRSetupTBT.Deduction);
                                Rec.MODIFY;
                            end;
                        end;
                    until Rec.NEXT = 0;
                end;
            }
            action("Assign Missing Punch as Attended")
            {
                Image = AdjustEntries;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Visible = Visible;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if Rec.FINDFIRST = false then
                        exit;

                    Rec.FINDFIRST;
                    repeat
                        if PayrollFunctions.CanModifyAttendanceRecord(Rec."From Date", Rec."Employee No.") = true then begin
                            Rec.CALCFIELDS("Hand Punch Exist");
                            if (Rec.Type = Rec.Type::"Working Day") and (Rec."Required Hrs" > 0) and (Rec."Attend Hrs." = 0) and (Rec."Hand Punch Exist" = true) then begin
                                Rec.VALIDATE("Attend Hrs.", Rec."Required Hrs");
                                Rec.MODIFY;
                            end;
                        end;
                    until Rec.NEXT = 0;
                end;
            }
            action("Reset Late Arrive")
            {
                Image = ResetStatus;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    if Rec.FINDFIRST then
                        repeat
                            Rec."Late Arrive" := 0;
                            Rec.Modify;
                        until Rec.NEXT = 0;
                    MESSAGE('Process Done !');
                end;
            }
            action("Reset Attended Hours")
            {
                Image = ResetStatus;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    if Rec.FINDFIRST then
                        repeat
                            Rec."Attend Hrs." := Rec."Required Hrs";
                            Rec."Late Arrive" := 0;
                            Rec."Actual Late Arrive" := 0;
                            Rec."Late Leave" := 0;
                            Rec."Actual Late Leave" := 0;
                            Rec."Early Arrive" := 0;
                            Rec."Early Leave" := 0;
                            Rec."Actual Early Arrive" := 0;
                            Rec."Actual Early Leave" := 0;
                            Rec.Modify;
                        until Rec.NEXT = 0;
                    MESSAGE('Process Done !');
                end;
            }
            action("Update Daily Attendance")
            {
                Image = ResetStatus;
                ApplicationArea = All;

                trigger OnAction();
                var
                    KyStr: Text;
                    EmployeeAbsenceRec: Record "Employee Absence";
                begin
                    EmployeeAbsenceRec.reset;
                   // EmployeeAbsenceRec.SetCurrentKey("Employee No.","From Date");
                    EmployeeAbsenceRec.SETFILTER("Employee Status", 'Active');
                    EmployeeAbsenceRec.SETFILTER("Employee Name", '<>%1', '');              
                

                    if (FDate <> 0D) and (TDate <> 0D) then
                        // EmployeeAbsenceRec.SETFILTER("From Date", '>=%1 & <=%2 ', FDate, TDate);
                           EmployeeAbsenceRec.SetRange("From Date", FDate, TDate);

                  
                   
                     IF EmpNoFilter <> '' then
                        EmployeeAbsenceRec.SETRANGE("Employee No.", EmpNoFilter);

                    IF EmploymentType <> '' then
                        EmployeeAbsenceRec.SETRANGE("Employment Type Code", EmploymentType);

                    IF PayrollGroup <> '' then
                        EmployeeAbsenceRec.SETRANGE("Payroll Group", PayrollGroup);

                    IF EmpCategoryCode <> '' then
                        EmployeeAbsenceRec.SETRANGE("Employee Category", EmpCategoryCode);

                    IF ManagerNo <> '' then
                        EmployeeAbsenceRec.SETRANGE("Employee Manager No", ManagerNo);

                    IF Dimension1 <> '' then
                        EmployeeAbsenceRec.SETRANGE("Employee Dimension1", Dimension1);

                    IF Dimension2 <> '' then 
                        EmployeeAbsenceRec.SETRANGE("Employee Dimension2", Dimension2);

                    IF DailyShift <> '' then
                        EmployeeAbsenceRec.SETRANGE("Shift Code", DailyShift);

                    if EmployeeAbsenceRec.FINDFIRST then
                        repeat
                            KyStr := 'ACT-';
                            IF PayrollFunctions.CanModifyAttendanceRecord(EmployeeAbsenceRec."From Date", EmployeeAbsenceRec."Employee No.") THEN BEGIN
                                KyStr := KyStr + 'ALL';

                                PayrollFunctions.FixEmployeeDailyAttendanceHours(EmployeeAbsenceRec."Employee No.", EmployeeAbsenceRec.Period, EmployeeAbsenceRec."From Date", TRUE, KyStr);
                               // EmployeeAbsenceRec.Modify(false);
                            END;
                        until EmployeeAbsenceRec.NEXT = 0;
                    MESSAGE('Process Done !');
                end;
            }
            action("Reset Attendance")
            {
                Image = ResetStatus;
                ApplicationArea = All;
                Visible = ModifyPayrollLedger;
                trigger OnAction();
                var
                    HandPunchRec: Record "Hand Punch";
                begin
                    if Rec.FINDFIRST then
                        repeat
                            Rec."Attend Hrs." := 0;
                            Rec."Late Arrive" := 0;
                            Rec."Late Leave" := 0;
                            Rec."Early Arrive" := 0;
                            Rec."Early Leave" := 0;
                            Rec."Actual Attend Hrs" := 0;
                            Rec."Actual Late Arrive" := 0;
                            Rec."Actual Late Leave" := 0;
                            Rec."Actual Early Arrive" := 0;
                            Rec."Actual Early Leave" := 0;
                            Rec.Modify;
                            HandPunchRec.SETRANGE("Real Date", Rec."From Date");
                            IF HandPunchRec.FindFirst then
                                repeat
                                    HandPunchRec.Delete();
                                until HandPunchRec.next = 0;
                        until Rec.NEXT = 0;
                    MESSAGE('Process Done !');
                end;
            }

            action("Reset No Punch As Attended")
            {
                Image = ResetStatus;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.SETFILTER("Attend Hrs.", '=%1', 0);
                    if Rec.FINDFIRST then
                        repeat
                            Rec."Attend Hrs." := Rec."Required Hrs";
                            Rec."Late Arrive" := 0;
                            Rec."Actual Late Arrive" := 0;
                            Rec."Late Leave" := 0;
                            Rec."Actual Late Leave" := 0;
                            Rec."Early Arrive" := 0;
                            Rec."Early Leave" := 0;
                            Rec."Actual Early Arrive" := 0;
                            Rec."Actual Early Leave" := 0;
                            Rec.Modify;
                        until Rec.NEXT = 0;
                    MESSAGE('Process Done !');
                end;
            }
        }
    }

    trigger OnInit();
    begin
        AttendDRowType := AttendDRowType::All;
    end;

    trigger OnOpenPage();
    begin
        // Added in order to show only Employee related to Manger - 20.04.2017 : A2+
        Visible := true;
        Editible := true;
        HRPermission.SETRANGE("User ID", USERID);
        if (HRPermission.FINDFIRST) and (HRPermission."Attendance Limited Access") then begin
            Editible := false;
            Visible := false;
            ManagerNo := HRPermission."Assigned Employee Code";
            SETFILTER("Employee Manager No", '=%1', HRPermission."Assigned Employee Code");
        end;
        // Added in order to show only Employee related to Manger - 20.04.2017 : A2-

        AttendDRowType := AttendDRowType::All;
        SETFILTER("Employee No.", '=%1', '');
        // Added for Megaprefab - 21.03.2017 : A2+
        FDate := DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
        TDate := DMY2DATE(PayrollFunctions.GetLastDayinMonth(WORKDATE), DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
        // Added for Megaprefab - 21.03.2017 : A2-
        IF UserSetup.GET(USERID) THEN begin
            IF UserSetup."Allow Modify Payroll Ledger" THEN
                ModifyPayrollLedger := true
            else
                ModifyPayrollLedger := False;
        end;
    end;

    var
        FDate: Date;
        TDate: Date;
        EmpNoFilter: Code[20];
        EmploymentType: Code[20];
        PayrollGroup: Code[10];
        EmpCategoryCode: Code[10];
        Dimension1: Code[20];
        Dimension2: Code[20];
        ManagerNo: Code[20];
        AttendDRowType: Option All,"No Attendance","Invalid Punch","Has Attendance";
        DailyShift: Code[10];
        HRSetupTBT: Record "Human Resources Setup";
        HasZOHOID: Boolean;
        PayrollFunctions: Codeunit "Payroll Functions";
        Dimension3: Code[20];
        Visible: Boolean;
        HRPermission: Record "HR Permissions";
        Editible: Boolean;
        ModifyPayrollLedger: Boolean;
        UserSetup: Record "User Setup";
}

