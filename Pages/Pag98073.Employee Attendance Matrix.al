page 98073 "Employee Attendance Matrix"
{
    // version EDM.HRPY1

    // 'Style :

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                field("From Date"; FDate)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        TDate := FDate;
                    end;
                }
                field("Till Date"; TDate)
                {
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
                field(Department; DepartmentFld)
                {
                    Visible = false;
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
                    ApplicationArea = All;
                }
                field(Declared; VarDeclared)
                {
                    ApplicationArea = All;
                }
            }
            repeater(Control5)
            {
                FreezeColumn = "Employee Name";
                field("Employee No."; Rec."No.")
                {
                    Editable = false;
                    Width = 25;
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Full Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(DCol1; DataColumn[1])
                {
                    CaptionClass = ColumnCaption[1];
                    Caption = 'DCol1';
                    Editable = false;
                    StyleExpr = T1;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 1);
                    end;
                }
                field(DCol2; DataColumn[2])
                {
                    CaptionClass = ColumnCaption[2];
                    Caption = 'DCol2';
                    Editable = false;
                    StyleExpr = T2;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 2);
                    end;
                }
                field(DCol3; DataColumn[3])
                {
                    CaptionClass = ColumnCaption[3];
                    Caption = 'DCol3';
                    Editable = false;
                    StyleExpr = T3;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 3);
                    end;
                }
                field(DCol4; DataColumn[4])
                {
                    CaptionClass = ColumnCaption[4];
                    Caption = 'DCol4';
                    Editable = false;
                    StyleExpr = T4;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 4);
                    end;
                }
                field(DCol5; DataColumn[5])
                {
                    CaptionClass = ColumnCaption[5];
                    Caption = 'DCol5';
                    Editable = false;
                    StyleExpr = T5;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 5);
                    end;
                }
                field(DCol6; DataColumn[6])
                {
                    CaptionClass = ColumnCaption[6];
                    Caption = 'DCol6';
                    Editable = false;
                    StyleExpr = T6;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 6);
                    end;
                }
                field(DCol7; DataColumn[7])
                {
                    CaptionClass = ColumnCaption[7];
                    Caption = 'DCol7';
                    Editable = false;
                    StyleExpr = T7;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 7);
                    end;
                }
                field(DCol8; DataColumn[8])
                {
                    CaptionClass = ColumnCaption[8];
                    Caption = 'DCol8';
                    Editable = false;
                    StyleExpr = T8;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 8);
                    end;
                }
                field(DCol9; DataColumn[9])
                {
                    CaptionClass = ColumnCaption[9];
                    Caption = 'DCol9';
                    Editable = false;
                    StyleExpr = T9;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 9);
                    end;
                }
                field(DCol10; DataColumn[10])
                {
                    CaptionClass = ColumnCaption[10];
                    Caption = 'DCol10';
                    Editable = false;
                    StyleExpr = T10;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 10);
                    end;
                }
                field(DCol11; DataColumn[11])
                {
                    CaptionClass = ColumnCaption[11];
                    Caption = 'DCol11';
                    Editable = false;
                    StyleExpr = T11;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 11);
                    end;
                }
                field(DCol12; DataColumn[12])
                {
                    CaptionClass = ColumnCaption[12];
                    Caption = 'DCol12';
                    Editable = false;
                    StyleExpr = T12;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 12);
                    end;
                }
                field(DCol13; DataColumn[13])
                {
                    CaptionClass = ColumnCaption[13];
                    Caption = 'DCol13';
                    Editable = false;
                    StyleExpr = T13;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 13);
                    end;
                }
                field(DCol14; DataColumn[14])
                {
                    CaptionClass = ColumnCaption[14];
                    Caption = 'DCol14';
                    Editable = false;
                    StyleExpr = T14;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 14);
                    end;
                }
                field(DCol15; DataColumn[15])
                {
                    CaptionClass = ColumnCaption[15];
                    Caption = 'DCol15';
                    Editable = false;
                    StyleExpr = T15;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 15);
                    end;
                }
                field(DCol16; DataColumn[16])
                {
                    CaptionClass = ColumnCaption[16];
                    Caption = 'DCol16';
                    Editable = false;
                    StyleExpr = T16;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 16);
                    end;
                }
                field(DCol17; DataColumn[17])
                {
                    CaptionClass = ColumnCaption[17];
                    Caption = 'DCol17';
                    Editable = false;
                    StyleExpr = T17;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 17);
                    end;
                }
                field(DCol18; DataColumn[18])
                {
                    CaptionClass = ColumnCaption[18];
                    Caption = 'DCol18';
                    Editable = false;
                    StyleExpr = T18;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 18);
                    end;
                }
                field(DCol19; DataColumn[19])
                {
                    CaptionClass = ColumnCaption[19];
                    Caption = 'DCol19';
                    Editable = false;
                    StyleExpr = T19;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 19);
                    end;
                }
                field(DCol20; DataColumn[20])
                {
                    CaptionClass = ColumnCaption[20];
                    Caption = 'DCol20';
                    Editable = false;
                    StyleExpr = T20;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 20);
                    end;
                }
                field(DCol21; DataColumn[21])
                {
                    CaptionClass = ColumnCaption[21];
                    Caption = 'DCol21';
                    Editable = false;
                    StyleExpr = T21;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 21);
                    end;
                }
                field(DCol22; DataColumn[22])
                {
                    CaptionClass = ColumnCaption[22];
                    Caption = 'DCol22';
                    Editable = false;
                    StyleExpr = T22;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 22);
                    end;
                }
                field(DCol23; DataColumn[23])
                {
                    CaptionClass = ColumnCaption[23];
                    Caption = 'DCol23';
                    Editable = false;
                    StyleExpr = T23;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 23);
                    end;
                }
                field(DCol24; DataColumn[24])
                {
                    CaptionClass = ColumnCaption[24];
                    Caption = 'DCol24';
                    Editable = false;
                    StyleExpr = T24;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 24);
                    end;
                }
                field(DCol25; DataColumn[25])
                {
                    CaptionClass = ColumnCaption[25];
                    Caption = 'DCol25';
                    Editable = false;
                    StyleExpr = T25;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 25);
                    end;
                }
                field(DCol26; DataColumn[26])
                {
                    CaptionClass = ColumnCaption[26];
                    Caption = 'DCol26';
                    Editable = false;
                    StyleExpr = T26;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 26);
                    end;
                }
                field(DCol27; DataColumn[27])
                {
                    CaptionClass = ColumnCaption[27];
                    Caption = 'DCol27';
                    Editable = false;
                    StyleExpr = T27;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 27);
                    end;
                }
                field(DCol28; DataColumn[28])
                {
                    CaptionClass = ColumnCaption[28];
                    Caption = 'DCol28';
                    Editable = false;
                    StyleExpr = T28;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 28);
                    end;
                }
                field(DCol29; DataColumn[29])
                {
                    CaptionClass = ColumnCaption[29];
                    Caption = 'DCol29';
                    Editable = false;
                    StyleExpr = T29;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 29);
                    end;
                }
                field(DCol30; DataColumn[30])
                {
                    CaptionClass = ColumnCaption[30];
                    Caption = 'DCol30';
                    Editable = false;
                    StyleExpr = T30;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 30);
                    end;
                }
                field(DCol31; DataColumn[31])
                {
                    CaptionClass = ColumnCaption[31];
                    Caption = 'DCol31';
                    Editable = false;
                    StyleExpr = T31;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenAttendancePage(Rec."No.", 31);
                    end;
                }
            }
            group("")
            {
                Visible = Visible;
                field("New Shift Code"; NewShiftCode)
                {
                    TableRelation = "Daily Shifts"."Shift Code";
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Default Matrix")
            {
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //Modified in order to organize code - 10.09.2016 : AIM +
                    /*  SETFILTER (Status,'Active');
                      SETFILTER ("Full Name",'<>%1','');
                      SETFILTER("No.",EmpNoFilter);
                      SETFILTER("Employment Type Code",EmploymentType);
                      SETFILTER ("Employee Category Code",EmpCategoryCode);None,Standard,StandardAccent,Strong,StrongAccent,Attention,AttentionAccent,Favorable,Unfavorable,Ambiguous,SubOrdinate
                      SETFILTER ("Global Dimension 1 Code",Dimension1 );
                      SETFILTER ("Global Dimension 2 Code",Dimension2 );
                       SETFILTER("Payroll Group Code",PayrollGroup);
                       //Added for additional filter - 19.08.2016 : AIM +
                       SETFILTER("Manager No.",ManagerNo);
                       //Added for additional filter - 19.08.2016 : AIM -
                    */
                    SetPageFilter();
                    //Modified in order to organize code - 10.09.2016 : AIM -
                    Rec.FILTERGROUP(0);
                    MatrixTyp := 1;
                    ResetVariables();
                    IntializeMatrix();
                    SetRecordCellValues();

                end;
            }
            action("Attended Hours Matrix")
            {
                Image = AbsenceCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //Modified in order to organize code - 10.09.2016 : AIM +
                    /*
                      SETFILTER (Status,'Active');
                      SETFILTER ("Full Name",'<>%1','');
                      SETFILTER("No.",EmpNoFilter);
                      SETFILTER("Employment Type Code",EmploymentType);
                      SETFILTER ("Employee Category Code",EmpCategoryCode);
                      SETFILTER ("Global Dimension 1 Code",Dimension1 );
                      SETFILTER ("Global Dimension 2 Code",Dimension2 );
                       SETFILTER("Payroll Group Code",PayrollGroup);
                         //Added for additional filter - 19.08.2016 : AIM +
                       SETFILTER("Manager No.",ManagerNo);
                       //Added for additional filter - 19.08.2016 : AIM -
                    */
                    SetPageFilter();
                    //Modified in order to organize code - 10.09.2016 : AIM -
                    Rec.FILTERGROUP(0);
                    MatrixTyp := 2;
                    ResetVariables();
                    IntializeMatrix();
                    SetRecordCellValues();

                end;
            }
            action("Daily Shifts Matrix")
            {
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //Modified in order to organize code - 10.09.2016 : AIM +
                    /*
                      SETFILTER (Status,'Active');
                      SETFILTER ("Full Name",'<>%1','');
                      SETFILTER("No.",EmpNoFilter);
                      SETFILTER("Employment Type Code",EmploymentType);
                      SETFILTER ("Employee Category Code",EmpCategoryCode);
                      SETFILTER ("Global Dimension 1 Code",Dimension1 );
                      SETFILTER ("Global Dimension 2 Code",Dimension2 );
                       SETFILTER("Payroll Group Code",PayrollGroup);
                         //Added for additional filter - 19.08.2016 : AIM +
                       SETFILTER("Manager No.",ManagerNo);
                       //Added for additional filter - 19.08.2016 : AIM -
                    */
                    SetPageFilter();
                    //Modified in order to organize code - 10.09.2016 : AIM -
                    Rec.FILTERGROUP(0);
                    MatrixTyp := 3;
                    ResetVariables();
                    IntializeMatrix();
                    SetRecordCellValues();

                end;
            }
            action("Punch Matrix")
            {
                Image = PickWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //Modified in order to organize code - 10.09.2016 : AIM +
                    /*
                      SETFILTER (Status,'Active');
                      SETFILTER ("Full Name",'<>%1','');
                      SETFILTER("No.",EmpNoFilter);
                      SETFILTER("Employment Type Code",EmploymentType);
                      SETFILTER ("Employee Category Code",EmpCategoryCode);
                      SETFILTER ("Global Dimension 1 Code",Dimension1 );
                      SETFILTER ("Global Dimension 2 Code",Dimension2 );
                      SETFILTER("Payroll Group Code",PayrollGroup);
                       //Added for additional filter - 19.08.2016 : AIM +
                       SETFILTER("Manager No.",ManagerNo);
                       //Added for additional filter - 19.08.2016 : AIM -
                    */
                    SetPageFilter();
                    //Modified in order to organize code - 10.09.2016 : AIM -
                    Rec.FILTERGROUP(0);
                    MatrixTyp := 4;
                    ResetVariables();
                    IntializeMatrix();
                    SetRecordCellValues();
                    //SETFILTER("No.",'00001|00004');

                end;
            }
            action("Mark Missing Punch (???) as Attended")
            {
                Caption = 'Mark Missing Punch (???) as Attended';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                Visible = Visible;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if CONFIRM('Are you sure you want to set the attended Hours as Required Value for the records that have a missing punch?', false) = true then begin
                        MarkRecordofMissingPunchAsAttended;
                        ResetVariables();
                        IntializeMatrix();
                        SetRecordCellValues();
                    end;
                end;
            }
            action("Re-Assign New Shift Code")
            {
                Caption = 'Re-Assign New Shift Code';
                Image = ResetStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                Visible = Visible;
                ApplicationArea = All;

                trigger OnAction();
                begin

                    if CONFIRM('Are you sure you want to re-assign the new SHIFT CODE to the below record?', false) = true then begin
                        if CONFIRM('You will not be able to undo changes. Continue??????', false) = true then begin
                            if NewShiftCode = '' then
                                ERROR('Invalid Shift Code');

                            ReAssignNewDailyShift(NewShiftCode);
                            ResetVariables();
                            IntializeMatrix();
                            SetRecordCellValues();
                        end;
                    end;
                    NewShiftCode := '';
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        SetRecordCellValues();
    end;

    trigger OnAfterGetRecord();
    begin
        SetRecordCellValues();
    end;

    trigger OnOpenPage();
    begin
        // Added in order to show only Employee related to Manger - 20.04.2017 : A2+
        Visible := true;
        HRPermission.SETRANGE("User ID", USERID);
        if (HRPermission.FINDFIRST) and (HRPermission."Attendance Limited Access") then begin
            Visible := false;
            ManagerNo := HRPermission."Assigned Employee Code";
            Rec.SETFILTER("Manager No.", '=%1', HRPermission."Assigned Employee Code");
        end;
        // Added in order to show only Employee related to Manger - 20.04.2017 : A2-
        InitializeGlobalVariables();
        Rec.SETFILTER(Status, 'Active');
        Rec.SETFILTER("Full Name", '<>%1', '');
        Rec.FILTERGROUP(0);
        ResetVariables();
        IntializeMatrix();
    end;

    var
        FDate: Date;
        TDate: Date;
        DataColumn: array[32] of Text;
        ColumnCaption: array[32] of Text;
        ColumnVisible: array[32] of Boolean;
        CellStyle: array[32] of Text;
        MaxColumns: Integer;
        ColumnField: Text;
        ColumnDate: array[32] of Date;
        T1: Text;
        T2: Text;
        T3: Text;
        T4: Text;
        T5: Text;
        T6: Text;
        T7: Text;
        EmpNoFilter: Code[20];
        EmploymentType: Code[20];
        PayrollGroup: Code[10];
        EmpCategoryCode: Code[10];
        Dimension1: Code[20];
        Dimension2: Code[20];
        T8: Text;
        T9: Text;
        T10: Text;
        T11: Text;
        T12: Text;
        T13: Text;
        T14: Text;
        T15: Text;
        T16: Text;
        T17: Text;
        T18: Text;
        T19: Text;
        T20: Text;
        T21: Text;
        T22: Text;
        T23: Text;
        T24: Text;
        T25: Text;
        T26: Text;
        T27: Text;
        T28: Text;
        T29: Text;
        T30: Text;
        T31: Text;
        DataAdd1: array[32] of Text;
        MatrixTyp: Integer;
        DataAdd2: array[32] of Text;
        DataAdd3: array[32] of Text;
        PayrollFunctions: Codeunit "Payroll Functions";
        NewShiftCode: Code[20];
        ManagerNo: Code[20];
        DepartmentFld: Code[20];
        VarDeclared: Option " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        HRSetupTbt: Record "Human Resources Setup";
        ShowZOHOFlds: Boolean;
        HRPermission: Record "HR Permissions";
        Visible: Boolean;

    local procedure IntializeMatrix();
    var
        i: Integer;
    begin
        InitializeColumnCaptions();
        i := 1;
        while i <= MaxColumns do begin
            if ColumnCaption[i] = '' then
                ColumnVisible[i] := false
            else
                ColumnVisible[i] := true;
            i := i + 1;
        end;
    end;

    local procedure InitializeColumnCaptions();
    var
        Calendar: Record Date;
        i: Integer;
    begin
        Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
        Calendar.SETRANGE("Period Start", FDate, TDate);
        if Calendar.FINDSET then begin
            i := 1;
            repeat
                if i <= MaxColumns then begin
                    ColumnDate[i] := Calendar."Period Start";
                    ColumnCaption[i] := FORMAT(Calendar."Period Start") + ' ' + FORMAT(Calendar."Period Start", 0, '<WeekDay Text>');
                end;
                i := i + 1;
            until Calendar.NEXT = 0;

        end;
    end;

    local procedure InitializeGlobalVariables();
    begin
        MaxColumns := 31;
        FDate := CALCDATE('-1D', TODAY);
        TDate := FDate;
        MatrixTyp := 1;
    end;

    local procedure ResetVariables();
    var
        i: Integer;
    begin
        i := 1;
        while i <= MaxColumns do begin
            ColumnVisible[i] := false;
            ColumnCaption[i] := '';
            CellStyle[i] := 'Standard';
            CLEAR(ColumnDate);
            CLEAR(DataColumn);
            CLEAR(DataAdd1);
            CLEAR(DataAdd2);
            CLEAR(DataAdd3);
            i := i + 1;
        end;
    end;

    local procedure SetRecordCellValues();
    var
        i: Integer;
    begin
        i := 1;
        while i <= MaxColumns do begin
            if (Rec."No." <> '') and (ColumnDate[i] <> 0D) then begin
                DataColumn[i] := GetEmpAttendanceDayStatus(Rec."No.", ColumnDate[i], i);
                SetCellStyle(i, DataColumn[i]);
                if MatrixTyp = 2 then
                    DataColumn[i] := DataAdd1[i]
                else
                    if MatrixTyp = 3 then
                        DataColumn[i] := DataAdd2[i]
                    else
                        if MatrixTyp = 4 then
                            if DataAdd3[i] <> '.' then
                                DataColumn[i] := DataAdd3[i];
            end;
            i := i + 1;
        end;
    end;

    local procedure GetEmpAttendanceDayStatus(EmpNo: Code[20]; AttendanceDate: Date; RecID: Integer) DayStatus: Text;
    var
        EmpAbsenceTable: Record "Employee Absence";
        str: Text;
        CauseofAbs: Record "Cause of Absence";
        HandPunch: Record "Hand Punch";
        PunchExists: Boolean;
        PunchCnt: Integer;
    begin
        str := '';
        DataAdd1[RecID] := '';
        DataAdd2[RecID] := '';
        DataAdd3[RecID] := '';
        EmpAbsenceTable.INIT;
        CLEAR(EmpAbsenceTable);

        EmpAbsenceTable.SETCURRENTKEY(EmpAbsenceTable."Employee No.", EmpAbsenceTable."From Date");
        EmpAbsenceTable.SETRANGE(EmpAbsenceTable."Employee No.", EmpNo);
        EmpAbsenceTable.SETRANGE(EmpAbsenceTable."From Date", AttendanceDate);


        //REPEAT
        if EmpAbsenceTable.FIND('-') then begin
            if EmpAbsenceTable."Cause of Absence Code" <> '' then begin
                str := EmpAbsenceTable."Cause of Absence Code";

                CauseofAbs.INIT;
                CLEAR(CauseofAbs);
                CauseofAbs.SETRANGE(Code, EmpAbsenceTable."Cause of Absence Code");
                CauseofAbs.FINDFIRST();

                HandPunch.SETRANGE("Attendnace No.", EmpAbsenceTable."Attendance No.");
                HandPunch.SETRANGE("Scheduled Date", EmpAbsenceTable."From Date");
                if HandPunch.FINDFIRST then begin
                    PunchExists := true;
                    // 08.12.2017 : A2+
                    PunchCnt := HandPunch.COUNT;
                    // 08.12.2017 : A2-
                end
                else
                    PunchExists := false;

                if EmpAbsenceTable."Shift Code" = 'HOLIDAY' then
                    str := 'HOLIDAY'
                else
                    if EmpAbsenceTable."Shift Code" = 'NWD' then
                        str := 'Non Working Day'
                    else
                        if EmpAbsenceTable."Attend Hrs." > EmpAbsenceTable."Required Hrs" then
                            str := 'OVERTIME'
                        else
                            if (EmpAbsenceTable."Required Hrs" > 0) and (EmpAbsenceTable."Attend Hrs." > 0) and (EmpAbsenceTable."Late Arrive" > 0) then
                                str := 'Late Arrive'
                            else
                                if (EmpAbsenceTable."Required Hrs" > 0) and (EmpAbsenceTable."Attend Hrs." > 0) and (EmpAbsenceTable."Early Leave" > 0) then
                                    str := 'Early Leave'
                                else
                                    if (EmpAbsenceTable."Required Hrs" > 0) and (EmpAbsenceTable."Attend Hrs." = 0) and (PunchExists = false) then
                                        str := 'Absence'
                                    // 08.12.2017 : A2+
                                    //ELSE IF (EmpAbsenceTable."Required Hrs" > 0 ) AND (EmpAbsenceTable."Attend Hrs." = 0 )  AND (PunchExists = TRUE) THEN
                                    else
                                        if ((EmpAbsenceTable."Required Hrs" > 0) and (EmpAbsenceTable."Attend Hrs." = 0) and (PunchExists = true)) or (PunchCnt mod 2 <> 0) then
                                            // 08.12.2017 : A2-
                                            str := '????'
                                        else
                                            if (EmpAbsenceTable."Required Hrs" > 0) and (EmpAbsenceTable."Attend Hrs." > 0) and (EmpAbsenceTable."Attend Hrs." < EmpAbsenceTable."Required Hrs") then
                                                str := 'DEDUCTION'
                                            else
                                                if ((CauseofAbs.Type = CauseofAbs.Type::"Working Day") or (CauseofAbs.Type = CauseofAbs.Type::"Working Holiday")) and (PunchExists = false) then
                                                    str := 'MISSING PUNCH'
                                                // 08.12.2017 : A2+
                                                //ELSE  IF ((CauseofAbs.Type = CauseofAbs.Type::"Working Day") OR (CauseofAbs.Type = CauseofAbs.Type::"Working Holiday")  ) AND (EmpAbsenceTable."Attend Hrs."=0) THEN
                                                else
                                                    if (((CauseofAbs.Type = CauseofAbs.Type::"Working Day") or (CauseofAbs.Type = CauseofAbs.Type::"Working Holiday")) and (EmpAbsenceTable."Attend Hrs." = 0)) or (PunchCnt mod 2 <> 0) then
                                                        // 08.12.2017 : A2-
                                                        str := '????'
                                                    else
                                                        str := str;

                DataAdd1[RecID] := FORMAT(ROUND(EmpAbsenceTable."Attend Hrs.", 0.01));
                DataAdd2[RecID] := FORMAT(EmpAbsenceTable."Shift Code");
                if (EmpAbsenceTable."Attend Hrs." > 0) then
                    DataAdd3[RecID] := '[ ' + FORMAT(ROUND(EmpAbsenceTable."Attend Hrs.", 0.01)) + ' ] : ' + FORMAT(PayrollFunctions.GetDailyAttendanceInOutTime(EmpNo, AttendanceDate, true, true))
                                         + ' - ' + FORMAT(PayrollFunctions.GetDailyAttendanceInOutTime(EmpNo, AttendanceDate, false, true))
                else
                    DataAdd3[RecID] := str;
            end;
        end;
        //UNTIL EmpAbsenceTable.NEXT = 0;

        exit(str);
    end;

    local procedure SetCellStyle(RecID: Integer; RecVal: Text);
    var
        Txt: Text;
    begin


        case RecID of
            1:
                T1 := GetCellStyle(RecVal);
            2:
                T2 := GetCellStyle(RecVal);
            3:
                T3 := GetCellStyle(RecVal);
            4:
                T4 := GetCellStyle(RecVal);
            5:
                T5 := GetCellStyle(RecVal);
            6:
                T6 := GetCellStyle(RecVal);
            7:
                T7 := GetCellStyle(RecVal);
            8:
                T8 := GetCellStyle(RecVal);
            9:
                T9 := GetCellStyle(RecVal);
            10:
                T10 := GetCellStyle(RecVal);
            11:
                T11 := GetCellStyle(RecVal);
            12:
                T12 := GetCellStyle(RecVal);
            13:
                T13 := GetCellStyle(RecVal);
            14:
                T14 := GetCellStyle(RecVal);
            15:
                T15 := GetCellStyle(RecVal);
            16:
                T16 := GetCellStyle(RecVal);
            17:
                T17 := GetCellStyle(RecVal);
            18:
                T18 := GetCellStyle(RecVal);
            19:
                T19 := GetCellStyle(RecVal);
            20:
                T20 := GetCellStyle(RecVal);
            21:
                T21 := GetCellStyle(RecVal);
            22:
                T22 := GetCellStyle(RecVal);
            23:
                T23 := GetCellStyle(RecVal);
            24:
                T24 := GetCellStyle(RecVal);
            25:
                T25 := GetCellStyle(RecVal);
            26:
                T26 := GetCellStyle(RecVal);
            27:
                T27 := GetCellStyle(RecVal);
            28:
                T28 := GetCellStyle(RecVal);
            29:
                T29 := GetCellStyle(RecVal);
            30:
                T30 := GetCellStyle(RecVal);
            31:
                T31 := GetCellStyle(RecVal);
        end;
    end;

    local procedure GetCellStyle(CellVal: Text) StyleN: Text;
    var
        Txt: Text;
    begin

        CASE UPPERCASE(CellVal) OF
            'HOLIDAY':
                Txt := 'Strong';
            'NODUTY':
                Txt := 'SubOrdinate';
            'OVERTIME':
                Txt := 'StrongAccent';
            'MISSING PUNCH':
                Txt := 'Attention';
            'NON WORKING DAY':
                Txt := 'AttentionAccent';//'Favorable';
            'LATE ARRIVE':
                Txt := 'Unfavorable';//'StandardAccent';
            'EARLY LEAVE':
                Txt := 'Unfavorable';//'StandardAccent';
            UPPERCASE('Absence'):
                Txt := 'Favorable';
            'DEDUCTION':
                Txt := 'Unfavorable';
            '????':
                Txt := 'Ambiguous';
            else
                Txt := 'Standard';
        end;
        exit(Txt);
    end;

    local procedure OpenAttendancePage(EmpNo: Code[20]; RecID: Integer);
    var
        EmpAbs: Record "Employee Absence";
    begin
        EmpAbs.SETRANGE("Employee No.", EmpNo);
        EmpAbs.SETRANGE("From Date", ColumnDate[RecID]);
        PAGE.RUN(PAGE::"Attendance SubForm List", EmpAbs);
        CurrPage.UPDATE;
    end;

    local procedure MarkRecordofMissingPunchAsAttended();
    var
        EmpAbs: Record "Employee Absence";
        HandPunch: Record "Hand Punch";
        HandPunchExist: Boolean;
        EmpTbt: Record Employee;
    begin
        EmpTbt.SETFILTER(Status, 'Active');
        EmpTbt.SETFILTER("Full Name", '<>%1', '');
        EmpTbt.SETFILTER("No.", EmpNoFilter);
        EmpTbt.SETFILTER("Employment Type Code", EmploymentType);
        EmpTbt.SETFILTER("Employee Category Code", EmpCategoryCode);
        EmpTbt.SETFILTER("Global Dimension 1 Code", Dimension1);
        EmpTbt.SETFILTER("Global Dimension 2 Code", Dimension2);
        EmpTbt.SETFILTER(EmpTbt."Payroll Group Code", Rec."Payroll Group Code");
        //Added for new filter by department - 14.12.2016 : A2 +
        Rec.SETFILTER(Department, DepartmentFld);
        //Added for new filter by department - 14.12.2016 : A2 -
        if EmpTbt.FINDFIRST then
            repeat
                EmpAbs.SETRANGE("Employee No.", EmpTbt."No.");
                EmpAbs.SETFILTER("From Date", '%1..%2', FDate, TDate);
                EmpAbs.SETFILTER("Attend Hrs.", '=%1', 0);
                if EmpAbs.FINDFIRST then
                    repeat
                        //Added in order to add validation in case the period is closed - 10.09.2016 : AIM +
                        if PayrollFunctions.CanModifyAttendanceRecord(EmpAbs."From Date", EmpAbs."Employee No.") = true then begin
                            //Added in order to add validation in case the period is closed - 10.09.2016 : AIM -
                            if (EmpAbs.Type = EmpAbs.Type::"Working Day") or (EmpAbs.Type = EmpAbs.Type::"Working Holiday") then begin
                                if EmpAbs."Attend Hrs." = 0 then begin
                                    HandPunchExist := false;

                                    HandPunch.SETRANGE("Attendnace No.", Rec."Attendance No.");
                                    if HandPunch.FINDFIRST then
                                        HandPunchExist := true;

                                    if HandPunchExist = true then
                                        EmpAbs."Attend Hrs." := EmpAbs."Required Hrs";
                                    EmpAbs.MODIFY;

                                end;
                            end;
                            //Added in order to add validation in case the period is closed - 10.09.2016 : AIM +
                        end;
                    //Added in order to add validation in case the period is closed - 10.09.2016 : AIM -
                    until EmpAbs.NEXT = 0;
            until EmpTbt.NEXT = 0;
    end;

    local procedure MarkRecordAsHoliday();
    var
        EmpAbs: Record "Employee Absence";
        EmpTbt: Record Employee;
        DailyShift: Record "Daily Shifts";
        ShiftCode: Code[20];
        EmpSchedule: Code[20];
        EmploymentTypeSchedule: Record "Employment Type Schedule";
        WorkDayName: Text;
    begin

        DailyShift.SETRANGE("Shift Code", 'HOLIDAY');
        if DailyShift.FINDFIRST then begin
            ShiftCode := DailyShift."Shift Code";
        end
        else begin
            DailyShift.RESET;
            DailyShift.SETRANGE(Type, DailyShift.Type::Holiday);
            if DailyShift.FINDFIRST then begin
                ShiftCode := DailyShift."Shift Code";
            end;
        end;

        if (ShiftCode = '') then
            exit;

        EmpTbt.SETFILTER(Status, 'Active');
        EmpTbt.SETFILTER("Full Name", '<>%1', '');
        EmpTbt.SETFILTER("No.", EmpNoFilter);
        EmpTbt.SETFILTER("Employment Type Code", EmploymentType);
        EmpTbt.SETFILTER("Employee Category Code", EmpCategoryCode);
        EmpTbt.SETFILTER("Global Dimension 1 Code", Dimension1);
        EmpTbt.SETFILTER("Global Dimension 2 Code", Dimension2);
        EmpTbt.SETFILTER(EmpTbt."Payroll Group Code", Rec."Payroll Group Code");
        //Added for new filter by department - 14.12.2016 : A2 +
        Rec.SETFILTER(Department, DepartmentFld);
        //Added for new filter by department - 14.12.2016 : A2 -
        if EmpTbt.FINDFIRST then
            repeat

                EmpAbs.SETRANGE("Employee No.", EmpTbt."No.");
                EmpAbs.SETFILTER("From Date", '%1..%2', FDate, TDate);
                EmpAbs.SETFILTER("Attend Hrs.", '=%1', 0);
                if EmpAbs.FINDFIRST then
                    repeat
                        //Added in order to add validation in case the period is closed - 10.09.2016 : AIM +
                        if PayrollFunctions.CanModifyAttendanceRecord(EmpAbs."From Date", EmpAbs."Employee No.") = true then begin
                            //Added in order to add validation in case the period is closed - 10.09.2016 : AIM -
                            EmpAbs.VALIDATE("Shift Code", ShiftCode);
                            EmpAbs.MODIFY;
                            //Added in order to add validation in case the period is closed - 10.09.2016 : AIM +
                        end;
                    //Added in order to add validation in case the period is closed - 10.09.2016 : AIM -
                    until EmpAbs.NEXT = 0;
            until EmpTbt.NEXT = 0;
    end;

    local procedure ReAssignNewDailyShift(ShiftCode: Code[20]);
    var
        EmpAbs: Record "Employee Absence";
        EmpTbt: Record Employee;
    begin
        if (ShiftCode = '') then
            exit;

        EmpTbt.SETFILTER(Status, 'Active');
        EmpTbt.SETFILTER("Full Name", '<>%1', '');
        EmpTbt.SETFILTER("No.", EmpNoFilter);
        EmpTbt.SETFILTER("Employment Type Code", EmploymentType);
        EmpTbt.SETFILTER("Employee Category Code", EmpCategoryCode);
        EmpTbt.SETFILTER("Global Dimension 1 Code", Dimension1);
        EmpTbt.SETFILTER("Global Dimension 2 Code", Dimension2);
        EmpTbt.SETFILTER(EmpTbt."Payroll Group Code", PayrollGroup);
        EmpTbt.SETFILTER(Department, DepartmentFld);
        if EmpTbt.FINDFIRST then
            repeat
                EmpAbs.SETRANGE("Employee No.", EmpTbt."No.");
                EmpAbs.SETFILTER("From Date", '%1..%2', FDate, TDate);
                if EmpAbs.FINDFIRST then
                    repeat
                        if PayrollFunctions.CanModifyAttendanceRecord(EmpAbs."From Date", EmpAbs."Employee No.") then begin
                            EmpAbs.VALIDATE("Shift Code", ShiftCode);
                            EmpAbs.MODIFY;
                        end;
                    until EmpAbs.NEXT = 0;
            until EmpTbt.NEXT = 0;
    end;

    local procedure SetPageFilter();
    begin
        Rec.SETFILTER(Status, 'Active');
        Rec.SETFILTER("Full Name", '<>%1', '');
        Rec.SETFILTER("No.", EmpNoFilter);
        Rec.SETFILTER("Employment Type Code", EmploymentType);
        Rec.SETFILTER("Employee Category Code", EmpCategoryCode);
        Rec.SETFILTER("Global Dimension 1 Code", Dimension1);
        Rec.SETFILTER("Global Dimension 2 Code", Dimension2);

        Rec.SETFILTER("Payroll Group Code", PayrollGroup);
        Rec.SETFILTER("Manager No.", ManagerNo);
        //Added for new filter by department - 14.12.2016 : A2 +
        //SETFILTER (Department,DepartmentFld);
        //Added for new filter by department - 14.12.2016 : A2 -
        //Add in order to filter by "Declared" - 06.03.2017 : A2 +
        if VarDeclared <> Rec.Declared::" " then
            Rec.SETFILTER(Declared, '=%1', VarDeclared)
        else
            Rec.SETFILTER(Declared, '<>%1', Rec.Declared::" ");

        Rec.SETFILTER("Attendance No.", '<>%1', 0);
        //Add in order to filter by "Declared" - 06.03.2017 : A2 -
    end;
}

