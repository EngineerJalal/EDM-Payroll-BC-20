page 98074 "Employee Journals Matrix"
{
    // version EDM.HRPY1

    // 'Style : None,Standard,StandardAccent,Strong,StrongAccent,Attention,AttentionAccent,Favorable,Unfavorable,Ambiguous,SubOrdinate

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Transaction Type"; JournalTrxType)
                {
                    TableRelation = "HR Transaction Types".Code WHERE(Code = FILTER(<> 'ABS'), System = FILTER(false));
                    ApplicationArea = All;
                }
                field("From Date"; FDate)
                {
                    ApplicationArea = All;
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
                field("Has Bonus System"; HasBonusSystem)
                {
                    ApplicationArea = All;
                }
                field("Payroll Group"; PayrollGroup)
                {
                    TableRelation = "HR Payroll Group".Code;
                    ApplicationArea = All;
                }
                field("Posting Group"; PostingGrp)
                {
                    TableRelation = "Payroll Posting Group".Code;
                    ApplicationArea = All;
                }
                field("Employee Category Group"; EmpCategoryCode)
                {
                    TableRelation = "Employee Categories".Code;
                    ApplicationArea = All;
                }
                field("Manager No"; ManagerNo)
                {
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
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
                    ApplicationArea = All;
                }
                field(Declared; VarDeclared)
                {
                    ApplicationArea = All;
                }
            }
            repeater(Control11)
            {
                field("Employee No."; Rec."No.")
                {
                    Editable = false;
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
                    Editable = true;
                    Enabled = L1;
                    StyleExpr = T1;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 1);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 1);
                    end;
                }
                field(DCol2; DataColumn[2])
                {
                    CaptionClass = ColumnCaption[2];
                    Caption = 'DCol2';
                    Editable = true;
                    Enabled = L2;
                    StyleExpr = T2;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 2);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 2);
                    end;
                }
                field(DCol3; DataColumn[3])
                {
                    CaptionClass = ColumnCaption[3];
                    Caption = 'DCol3';
                    Editable = true;
                    Enabled = L3;
                    StyleExpr = T3;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 3);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 3);
                    end;
                }
                field(DCol4; DataColumn[4])
                {
                    CaptionClass = ColumnCaption[4];
                    Caption = 'DCol4';
                    Editable = true;
                    Enabled = L4;
                    StyleExpr = T4;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 4);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 4);
                    end;
                }
                field(DCol5; DataColumn[5])
                {
                    CaptionClass = ColumnCaption[5];
                    Caption = 'DCol5';
                    Editable = true;
                    Enabled = L5;
                    StyleExpr = T5;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 5);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 5);
                    end;
                }
                field(DCol6; DataColumn[6])
                {
                    CaptionClass = ColumnCaption[6];
                    Caption = 'DCol6';
                    Editable = true;
                    Enabled = L6;
                    StyleExpr = T6;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 6);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 6);
                    end;
                }
                field(DCol7; DataColumn[7])
                {
                    CaptionClass = ColumnCaption[7];
                    Caption = 'DCol7';
                    Editable = true;
                    Enabled = L7;
                    StyleExpr = T7;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 7);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 7);
                    end;
                }
                field(DCol8; DataColumn[8])
                {
                    CaptionClass = ColumnCaption[8];
                    Caption = 'DCol8';
                    Editable = true;
                    Enabled = L8;
                    StyleExpr = T8;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 8);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 8);
                    end;
                }
                field(DCol9; DataColumn[9])
                {
                    CaptionClass = ColumnCaption[9];
                    Caption = 'DCol9';
                    Editable = true;
                    Enabled = L9;
                    StyleExpr = T9;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 9);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 9);
                    end;
                }
                field(DCol10; DataColumn[10])
                {
                    CaptionClass = ColumnCaption[10];
                    Caption = 'DCol10';
                    Editable = true;
                    Enabled = L10;
                    StyleExpr = T10;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 10);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 10);
                    end;
                }
                field(DCol11; DataColumn[11])
                {
                    CaptionClass = ColumnCaption[11];
                    Caption = 'DCol11';
                    Editable = true;
                    Enabled = L11;
                    StyleExpr = T11;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 11);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 11);
                    end;
                }
                field(DCol12; DataColumn[12])
                {
                    CaptionClass = ColumnCaption[12];
                    Caption = 'DCol12';
                    Editable = true;
                    Enabled = L12;
                    StyleExpr = T12;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 12);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 12);
                    end;
                }
                field(DCol13; DataColumn[13])
                {
                    CaptionClass = ColumnCaption[13];
                    Caption = 'DCol13';
                    Editable = true;
                    Enabled = L13;
                    StyleExpr = T13;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 13);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 13);
                    end;
                }
                field(DCol14; DataColumn[14])
                {
                    CaptionClass = ColumnCaption[14];
                    Caption = 'DCol14';
                    Editable = true;
                    Enabled = L14;
                    StyleExpr = T14;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 14);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 14);
                    end;
                }
                field(DCol15; DataColumn[15])
                {
                    CaptionClass = ColumnCaption[15];
                    Caption = 'DCol15';
                    Editable = true;
                    Enabled = L15;
                    StyleExpr = T15;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 15);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 15);
                    end;
                }
                field(DCol16; DataColumn[16])
                {
                    CaptionClass = ColumnCaption[16];
                    Caption = 'DCol16';
                    Editable = true;
                    Enabled = L16;
                    StyleExpr = T16;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 16);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 16);
                    end;
                }
                field(DCol17; DataColumn[17])
                {
                    CaptionClass = ColumnCaption[17];
                    Caption = 'DCol17';
                    Editable = true;
                    Enabled = L17;
                    StyleExpr = T17;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 17);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 17);
                    end;
                }
                field(DCol18; DataColumn[18])
                {
                    CaptionClass = ColumnCaption[18];
                    Caption = 'DCol18';
                    Editable = true;
                    Enabled = L18;
                    StyleExpr = T18;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 18);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 18);
                    end;
                }
                field(DCol19; DataColumn[19])
                {
                    CaptionClass = ColumnCaption[19];
                    Caption = 'DCol19';
                    Editable = true;
                    Enabled = L19;
                    StyleExpr = T19;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 19);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 19);
                    end;
                }
                field(DCol20; DataColumn[20])
                {
                    CaptionClass = ColumnCaption[20];
                    Caption = 'DCol20';
                    Editable = true;
                    Enabled = L20;
                    StyleExpr = T20;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 20);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 20);
                    end;
                }
                field(DCol21; DataColumn[21])
                {
                    CaptionClass = ColumnCaption[21];
                    Caption = 'DCol21';
                    Editable = true;
                    Enabled = L21;
                    StyleExpr = T21;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 21);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 21);
                    end;
                }
                field(DCol22; DataColumn[22])
                {
                    CaptionClass = ColumnCaption[22];
                    Caption = 'DCol22';
                    Editable = true;
                    Enabled = L22;
                    StyleExpr = T22;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 22);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 22);
                    end;
                }
                field(DCol23; DataColumn[23])
                {
                    CaptionClass = ColumnCaption[23];
                    Caption = 'DCol23';
                    Editable = true;
                    Enabled = L23;
                    StyleExpr = T23;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 23);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 23);
                    end;
                }
                field(DCol24; DataColumn[24])
                {
                    CaptionClass = ColumnCaption[24];
                    Caption = 'DCol24';
                    Editable = true;
                    Enabled = L24;
                    StyleExpr = T24;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 24);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 24);
                    end;
                }
                field(DCol25; DataColumn[25])
                {
                    CaptionClass = ColumnCaption[25];
                    Caption = 'DCol25';
                    Editable = true;
                    Enabled = L25;
                    StyleExpr = T25;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 25);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 25);
                    end;
                }
                field(DCol26; DataColumn[26])
                {
                    CaptionClass = ColumnCaption[26];
                    Caption = 'DCol26';
                    Editable = true;
                    Enabled = L26;
                    StyleExpr = T26;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 26);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 26);
                    end;
                }
                field(DCol27; DataColumn[27])
                {
                    CaptionClass = ColumnCaption[27];
                    Caption = 'DCol27';
                    Editable = true;
                    Enabled = L27;
                    StyleExpr = T27;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 27);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 27);
                    end;
                }
                field(DCol28; DataColumn[28])
                {
                    CaptionClass = ColumnCaption[28];
                    Caption = 'DCol28';
                    Editable = true;
                    Enabled = L28;
                    StyleExpr = T28;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 28);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 28);
                    end;
                }
                field(DCol29; DataColumn[29])
                {
                    CaptionClass = ColumnCaption[29];
                    Caption = 'DCol29';
                    Editable = true;
                    Enabled = L29;
                    StyleExpr = T29;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 29);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 29);
                    end;
                }
                field(DCol30; DataColumn[30])
                {
                    CaptionClass = ColumnCaption[30];
                    Caption = 'DCol30';
                    Editable = true;
                    Enabled = L30;
                    StyleExpr = T30;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 30);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 30);
                    end;
                }
                field(DCol31; DataColumn[31])
                {
                    CaptionClass = ColumnCaption[31];
                    Caption = 'DCol31';
                    Editable = true;
                    Enabled = L31;
                    StyleExpr = T31;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        OpenCellLinkPage(Rec."No.", 31);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord(Rec."No.", 31);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View List")
            {
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    SetMatrixFilters();
                    Rec.FILTERGROUP(0);
                    MatrixTyp := 1;
                    IsEditMode := false;
                    ResetVariables();
                    IntializeMatrix();
                    SetRecordCellValues();

                end;
            }
            action("Edit List")
            {
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    SetMatrixFilters();
                    Rec.FILTERGROUP(0);
                    MatrixTyp := 1;
                    IsEditMode := true;
                    ResetVariables();
                    IntializeMatrix();
                    SetRecordCellValues();

                end;
            }
            action("Re-open")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if CONFIRM('Are you sure you want to re-open Journals', false) = true then
                        OpenReleaseApprove(1);
                end;
            }
            action("Release & Approve")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if CONFIRM('Are you sure you want to Release/Approve Journals', false) = true then
                        OpenReleaseApprove(3);
                end;
            }
            action("Import Recuring Journals")
            {
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "HR Import Recurring Journals";
                ApplicationArea = All;
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

    trigger OnInit();
    begin

        //Disabled because the permission is made at the level of HR Payroll User - 14.09.2016 : AIM +
        /*
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        IF  PayrollFunctions.HideSalaryFields() = TRUE THEN
           ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
        */
        //Disabled because the permission is made at the level of HR Payroll User - 14.09.2016 : AIM -

    end;

    trigger OnOpenPage();
    begin
        PayrollOfficerPermission := PayrollFunctions.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');

        InitializeGlobalVariables();
        Rec.SETFILTER(Status, 'Active');
        //Modified in order not to load employees on open - 14.09.2016 : AIM +
        //SETFILTER ("Full Name",'<>%1','');
        Rec.SETFILTER("Full Name", '=%1', '~~~');
        //Modified in order not to load employees on open - 14.09.2016 : AIM -
        Rec.FILTERGROUP(0);
        ResetVariables();
        IntializeMatrix();
    end;

    var
        FDate: Date;
        TDate: Date;
        DataColumn: array[32] of Decimal;
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
        JournalTrxType: Code[20];
        IsEditable: Boolean;
        L1: Boolean;
        L2: Boolean;
        L3: Boolean;
        L4: Boolean;
        L5: Boolean;
        L6: Boolean;
        L7: Boolean;
        L8: Boolean;
        L9: Boolean;
        L10: Boolean;
        L11: Boolean;
        L12: Boolean;
        L13: Boolean;
        L14: Boolean;
        L15: Boolean;
        L16: Boolean;
        L17: Boolean;
        L18: Boolean;
        L19: Boolean;
        L20: Boolean;
        L21: Boolean;
        L22: Boolean;
        L23: Boolean;
        L24: Boolean;
        L25: Boolean;
        L26: Boolean;
        L27: Boolean;
        L28: Boolean;
        L29: Boolean;
        L30: Boolean;
        L31: Boolean;
        IsEditMode: Boolean;
        ManagerNo: Code[20];
        DepartmentFld: Code[20];
        VarDeclared: Option " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        HRTransactionType: Record "HR Transaction Types";
        HRSetup: Record "Human Resources Setup";
        HasBonusSystem: Boolean;
        PostingGrp: Code[20];
        PayrollOfficerPermission: Boolean;

    local procedure OpenCellLinkPage(No: Code[20]; RecID: Integer);
    var
        EmpAbs: Record "Employee Absence";
    begin
        /*EmpAbs.SETRANGE("Employee No." ,EmpNo );
        EmpAbs.SETRANGE("From Date" ,ColumnDate[RecID]);
        PAGE.RUN(PAGE::"Attendance SubForm",EmpAbs);
        CurrPage.UPDATE;
         */

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
            DataColumn[i] := 0;
            ColumnDate[i] := 0D;
            DataAdd1[i] := '';
            DataAdd2[i] := '';
            DataAdd3[i] := '';
            i := i + 1;
        end;
        CLEAR(ColumnDate);
        CLEAR(DataColumn);
        CLEAR(DataAdd1);
        CLEAR(DataAdd2);
        CLEAR(DataAdd3);
    end;

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

    local procedure SetRecordCellValues();
    var
        i: Integer;
    begin
        i := 1;
        while i <= MaxColumns do begin
            if (Rec."No." <> '') and (ColumnDate[i] <> 0D) then begin
                DataColumn[i] := GetEmpJournalValue(Rec."No.", ColumnDate[i], JournalTrxType, i);
                SetCellStyle(i, DataAdd1[i]);
            end;
            i := i + 1;
        end;
    end;

    local procedure GetEmpJournalValue(EmpNo: Code[20]; TrxDate: Date; TrxType: Code[20]; RecID: Integer) CVal: Decimal;
    var
        EmpJournalLine: Record "Employee Journal Line";
        Val: Decimal;
    begin
        CLEAR(EmpJournalLine);
        EmpJournalLine.SETCURRENTKEY("Transaction Type", "Employee No.", "Transaction Date", Type);
        EmpJournalLine.SETRANGE("Employee No.", EmpNo);
        EmpJournalLine.SETRANGE("Transaction Type", TrxType);
        EmpJournalLine.SETRANGE("Transaction Date", TrxDate);

        Val := 0;

        if EmpJournalLine.FINDFIRST then begin
            if EmpJournalLine.Value <> 0 then
                Val := EmpJournalLine.Value;
            //Modified in order to consider other validations - 22.07.2016 : AIM +
            /*
            IF EmpJournalLine."Approved Date" <> 0D  THEN
                DataAdd1[RecID] :='Approved'
            ELSE IF  EmpJournalLine."Released Date" <> 0D THEN
                DataAdd1[RecID] :='Released'
            ELSE IF  EmpJournalLine."Opened Date" <> 0D THEN
                DataAdd1[RecID] :='Opened'
            ELSE
                DataAdd1[RecID] :='.';
            */
            if (EmpJournalLine."Approved Date" <> 0D) or (EmpJournalLine."Document Status" = EmpJournalLine."Document Status"::Approved) then
                DataAdd1[RecID] := 'Approved'
            else
                if (EmpJournalLine."Released Date" <> 0D) or (EmpJournalLine."Document Status" = EmpJournalLine."Document Status"::Released) then
                    DataAdd1[RecID] := 'Released'
                else
                    if (EmpJournalLine."Opened Date" <> 0D) or (EmpJournalLine."Document Status" = EmpJournalLine."Document Status"::Opened) then
                        DataAdd1[RecID] := 'Opened'
                    else
                        DataAdd1[RecID] := '.';
            //Modified in order to consider other validations - 22.07.2016 : AIM +
        end
        else begin
            DataAdd1[RecID] := '.';
        end;

        exit(Val);

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


        case RecID of
            1:
                L1 := EnableCell(RecVal);
            2:
                L2 := EnableCell(RecVal);
            3:
                L3 := EnableCell(RecVal);
            4:
                L4 := EnableCell(RecVal);
            5:
                L5 := EnableCell(RecVal);
            6:
                L6 := EnableCell(RecVal);
            7:
                L7 := EnableCell(RecVal);
            8:
                L8 := EnableCell(RecVal);
            9:
                L9 := EnableCell(RecVal);
            10:
                L10 := EnableCell(RecVal);
            11:
                L11 := EnableCell(RecVal);
            12:
                L12 := EnableCell(RecVal);
            13:
                L13 := EnableCell(RecVal);
            14:
                L14 := EnableCell(RecVal);
            15:
                L15 := EnableCell(RecVal);
            16:
                L16 := EnableCell(RecVal);
            17:
                L17 := EnableCell(RecVal);
            18:
                L18 := EnableCell(RecVal);
            19:
                L19 := EnableCell(RecVal);
            20:
                L20 := EnableCell(RecVal);
            21:
                L21 := EnableCell(RecVal);
            22:
                L22 := EnableCell(RecVal);
            23:
                L23 := EnableCell(RecVal);
            24:
                L24 := EnableCell(RecVal);
            25:
                L25 := EnableCell(RecVal);
            26:
                L26 := EnableCell(RecVal);
            27:
                L27 := EnableCell(RecVal);
            28:
                L28 := EnableCell(RecVal);
            29:
                L29 := EnableCell(RecVal);
            30:
                L30 := EnableCell(RecVal);
            31:
                L31 := EnableCell(RecVal);
        end;
    end;

    local procedure GetCellStyle(CellVal: Text) StyleN: Text;
    var
        Txt: Text;
    begin

        CASE UPPERCASE(CellVal) OF
            'OPENED':
                Txt := 'StrongAccent';
            'RELEASED':
                Txt := 'Ambiguous';
            'APPROVED':
                Txt := 'Unfavorable';
            else
                Txt := 'Standard';
        end;
        exit(Txt);
    end;

    local procedure InitializeGlobalVariables();
    begin
        MaxColumns := 31;
        MatrixTyp := 1;
        IsEditMode := false;
        SetDefaultPeriod();
    end;

    procedure UpdateCellRecord(EmpNo: Code[20]; RecID: Integer) CUpdated: Boolean;
    var
        EmpJournalLine: Record "Employee Journal Line";
        Val: Decimal;
        HRTransTypes: Record "HR Transaction Types";
        Typ: Code[20];
        TrxDate: Date;
        TrxType: Code[20];
        MaxLineNo: Integer;
        EmployeeJournals: Record "Employee Journal Line";
    begin
        CUpdated := false;
        TrxType := JournalTrxType;
        if TrxType = '' then
            exit(false);

        TrxDate := ColumnDate[RecID];
        if TrxDate = 0D then
            exit(false);

        HRTransTypes.SETCURRENTKEY(Code);
        HRTransTypes.SETRANGE(Code, TrxType);
        if HRTransTypes.FINDFIRST() then
            Typ := HRTransTypes.Type
        else
            exit(false);

        MaxLineNo := 0;
        EmployeeJournals.RESET;
        EmployeeJournals.SETRANGE("Employee No.", EmpNo);
        if EmployeeJournals.FIND('+') then
            MaxLineNo := EmployeeJournals."Entry No.";
        EmployeeJournals.RESET;



        CLEAR(EmpJournalLine);

        EmpJournalLine.SETCURRENTKEY("Transaction Type", "Employee No.", "Transaction Date", Type);
        EmpJournalLine.SETRANGE("Employee No.", EmpNo);
        EmpJournalLine.SETRANGE("Transaction Type", TrxType);
        EmpJournalLine.SETRANGE("Transaction Date", TrxDate);
        EmpJournalLine.SETRANGE(Type, Typ);

        Val := 0;
        Val := DataColumn[RecID];

        if EmpJournalLine.FINDFIRST then begin
            /*IF Val = 0 THEN
              BEGIN
                EmpJournalLine.VALIDATE(Value,Val  );
                 EmpJournalLine."Opened By":=USERID;
                 EmpJournalLine."Opened Date":=WORKDATE;
                 EmpJournalLine."Released By":= '';
                 EmpJournalLine."Released Date":= 0D ;
                 EmpJournalLine."Approved By":= '';
                 EmpJournalLine."Approved Date":= 0D;
                 EmpJournalLine."Document Status":= EmpJournalLine."Document Status"::Opened;

                 EmpJournalLine.MODIFY(TRUE);
               END
             ELSE
               BEGIN*/
            EmpJournalLine.DELETE;
            // END;
        end;
        //ELSE
        //   BEGIN

        EmpJournalLine.INIT;
        EmpJournalLine."Entry No." := MaxLineNo + 1;
        EmpJournalLine.VALIDATE("Employee No.", EmpNo);
        EmpJournalLine."Transaction Type" := TrxType;
        EmpJournalLine.Type := Typ;
        EmpJournalLine.VALIDATE("Transaction Date", TrxDate);
        EmpJournalLine.VALIDATE(Value, Val);
        EmpJournalLine."Opened By" := USERID;
        EmpJournalLine."Opened Date" := WORKDATE;
        EmpJournalLine."Released By" := '';
        EmpJournalLine."Released Date" := 0D;
        EmpJournalLine."Approved By" := '';
        EmpJournalLine."Approved Date" := 0D;
        EmpJournalLine."Document Status" := EmpJournalLine."Document Status"::Opened;
        EmpJournalLine.INSERT(true);

        //END;


        CUpdated := true;

        exit(CUpdated);

    end;

    procedure EnableCell(CellVal: Text) IsEnabled: Boolean;
    begin

        if IsEditMode = false then
            exit(false);

        CASE UPPERCASE(CellVal) OF
            'OPENED':
                exit(true);
            'RELEASED':
                exit(false);
            'APPROVED':
                exit(false);
            else
                exit(true);
        end;
    end;

    procedure OpenReleaseApprove(StatusID: Integer) NoError: Boolean;
    var
        EmpJournalLine: Record "Employee Journal Line";
        EmpNo: Code[20];
        HRTransTypes: Record "HR Transaction Types";
        Typ: Code[20];
        TrxDate: Date;
        TrxType: Code[20];
        i: Integer;
    begin

        Rec.FINDFIRST;
        repeat
        begin
            EmpNo := Rec."No.";
            //*************
            TrxType := JournalTrxType;
            if TrxType = '' then
                exit(false);

            //********
            HRTransTypes.SETCURRENTKEY(Code);
            HRTransTypes.SETRANGE(Code, TrxType);
            if HRTransTypes.FINDFIRST() then
                Typ := HRTransTypes.Type
            else
                exit(false);

            //********
            i := 1;
            while i <= MaxColumns do begin
                if ColumnVisible[i] = true then begin
                    TrxDate := ColumnDate[i];
                    if TrxDate <> 0D then begin
                        CLEAR(EmpJournalLine);

                        EmpJournalLine.SETCURRENTKEY("Transaction Type", "Employee No.", "Transaction Date", Type);
                        EmpJournalLine.SETRANGE("Employee No.", EmpNo);
                        EmpJournalLine.SETRANGE("Transaction Type", TrxType);
                        EmpJournalLine.SETRANGE("Transaction Date", TrxDate);
                        EmpJournalLine.SETRANGE(Type, Typ);
                        //Added in order not to modify in case period is closed - 10.09.2016 : AIM +
                        EmpJournalLine.SETFILTER(EmpJournalLine.Processed, '<>%1', true);
                        //Added in order not to modify in case period is closed - 10.09.2016 : AIM -
                        if EmpJournalLine.FINDFIRST then begin

                            case StatusID of
                                1:
                                    begin
                                        EmpJournalLine."Opened By" := USERID;
                                        EmpJournalLine."Opened Date" := WORKDATE;
                                        EmpJournalLine."Released By" := '';
                                        EmpJournalLine."Released Date" := 0D;
                                        EmpJournalLine."Approved By" := '';
                                        EmpJournalLine."Approved Date" := 0D;
                                        EmpJournalLine."Document Status" := EmpJournalLine."Document Status"::Opened;
                                    end;
                                2:
                                    begin
                                        if EmpJournalLine."Opened By" = '' then begin
                                            EmpJournalLine."Opened By" := USERID;
                                            EmpJournalLine."Opened Date" := WORKDATE;
                                        end;
                                        if EmpJournalLine."Released By" = '' then begin
                                            EmpJournalLine."Released By" := USERID;
                                            EmpJournalLine."Released Date" := WORKDATE;
                                            EmpJournalLine."Approved By" := '';
                                            EmpJournalLine."Approved Date" := 0D;
                                            EmpJournalLine."Document Status" := EmpJournalLine."Document Status"::Released;
                                        end;
                                    end;

                                3:
                                    begin
                                        if EmpJournalLine."Opened By" = '' then begin
                                            EmpJournalLine."Opened By" := USERID;
                                            EmpJournalLine."Opened Date" := WORKDATE;
                                        end;

                                        if EmpJournalLine."Released By" = '' then begin
                                            EmpJournalLine."Released By" := USERID;
                                            EmpJournalLine."Released Date" := WORKDATE;
                                        end;
                                        if EmpJournalLine."Approved By" = '' then begin
                                            EmpJournalLine."Approved By" := USERID;
                                            EmpJournalLine."Approved Date" := WORKDATE;
                                            EmpJournalLine."Document Status" := EmpJournalLine."Document Status"::Approved;
                                        end;
                                    end;

                            end;
                            EmpJournalLine.MODIFY(true);
                        end;

                    end;
                end;
                i := i + 1;
            end;



        end;
        until Rec.NEXT = 0;
    end;

    procedure SetDefaultPeriod();
    var
        Period: Date;
        D: Integer;
        M: Integer;
        Y: Integer;
    begin

        Period := TODAY;

        M := DATE2DMY(Period, 2);
        Y := DATE2DMY(Period, 3);

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
    end;

    local procedure SetMatrixFilters();
    begin

        // Added in order to Auto Show Employee related to "Transaction Type" - 24.02.2017 : A2+
        if PayrollFunctions.HideSalaryFields() = true then begin
            if PayrollGroup = '' then
                ERROR('Enter the Payroll Goup')
            else begin
                if PayrollFunctions.CanUserAccessSalaryofPayrollGroup('', PayrollGroup) = false then begin
                    PayrollGroup := '';
                    ERROR('You do not have permission to access this payroll group!');
                end;
            end;
        end;

        HRSetup.GET;
        HRTransactionType.SETRANGE(Code, JournalTrxType);
        if HRTransactionType.FINDFIRST = false then
            exit;

        Rec.SETFILTER(Status, 'Active');
        Rec.SETFILTER("Full Name", '<>%1', '');
        Rec.SETFILTER(Rec."No.", EmpNoFilter);
        Rec.SETFILTER("Employment Type Code", EmploymentType);

        if (HRTransactionType."Employee Category" <> '') and (EmpCategoryCode = '') then
            Rec.SETFILTER("Employee Category Code", HRTransactionType."Employee Category");
        // 06.03.2017 : A2+
        //ELSE
        // SETFILTER("Employee Category Code",EmpCategoryCode)
        if (HRTransactionType."Employee Category" = '') and (EmpCategoryCode <> '') then
            Rec.SETFILTER("Employee Category Code", EmpCategoryCode);
        if (HRTransactionType."Employee Category" <> '') and (EmpCategoryCode <> '') then
            Rec.SETFILTER("Employee Category Code", '%1|%2', HRTransactionType."Employee Category", EmpCategoryCode);
        // 06.03.2017 : A2-

        Rec.SETFILTER("Global Dimension 1 Code", Dimension1);
        Rec.SETFILTER("Global Dimension 2 Code", Dimension2);

        if (HRTransactionType."Payroll Group Code" <> '') and (PayrollGroup = '') then
            Rec.SETFILTER("Payroll Group Code", HRTransactionType."Payroll Group Code");
        // 06.03.2017 : A2+
        //ELSE
        //  SETFILTER("Payroll Group Code",PayrollGroup);
        if (HRTransactionType."Payroll Group Code" = '') and (PayrollGroup <> '') then
            Rec.SETFILTER("Payroll Group Code", PayrollGroup);
        if (HRTransactionType."Payroll Group Code" <> '') and (PayrollGroup <> '') then
            Rec.SETFILTER("Payroll Group Code", '%1|%2', PayrollGroup, HRTransactionType."Payroll Group Code");
        // 06.03.2017 : A2-

        Rec.SETFILTER("Manager No.", ManagerNo);
        Rec.SETFILTER(Department, DepartmentFld);

        if VarDeclared <> Rec.Declared::" " then
            Rec.SETFILTER(Declared, '=%1', VarDeclared)
        // 06.03.2017 : A2+
        else
            Rec.SETFILTER(Declared, '<>%1', Rec.Declared::" ");
        if HasBonusSystem = true then
            Rec.SETFILTER("Bonus System", '<>%1', '')
        else
            Rec.SETFILTER("Bonus System", '=%1|<>%2', '', '');
        // 06.03.2017 : A2-
        // 22.08.2017 : A2+
        if PostingGrp <> '' then
            Rec.SETFILTER("Posting Group", PostingGrp);
        // 22.08.2017 : A2-
        // Added in order to Auto Show Employee related to "Transaction Type" - 24.02.2017 : A2-
    end;
}

