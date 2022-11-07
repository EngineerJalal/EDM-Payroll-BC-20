page 98102 "Payroll Journals Matrix"
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
                field("Payroll Date"; PDate)
                {
                    ApplicationArea = All;
                }
                field(Employee; EmpNoFilter)
                {
                    TableRelation = Employee."No." WHERE(Status = FILTER("Active"));
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
                field(BonusSystemOption; BonusSystemOption)
                {
                    Caption = 'Bonus System Option';
                    Visible = ShowBonusSystemFld;
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
                    Visible = ShowManagerFld;
                    ApplicationArea = All;
                }
                field("Employee Dimension1"; Dimension1)
                {
                    CaptionClass = '1,1,1';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                    Visible = ShowDimFlds;
                    ApplicationArea = All;
                }
                field("Employee Dimension2"; Dimension2)
                {
                    CaptionClass = '1,1,2';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                    Visible = ShowDimFlds;
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
                field("Use ACY"; UseACY)
                {
                    Caption = 'Amount in ACY';
                    ApplicationArea = All;
                }
            }
            repeater(Control11)
            {
                field("Employee No."; "No.")
                {
                    Editable = false;
                    Width = 30;
                    ApplicationArea = All;
                }
                field("Employee Name"; "Full Name")
                {
                    Editable = false;
                    Visible = ShowEmployeeName;
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
                        OpenCellLinkPage("No.", 1);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 1);
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
                        OpenCellLinkPage("No.", 2);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 2);
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
                        OpenCellLinkPage("No.", 3);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 3);
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
                        OpenCellLinkPage("No.", 4);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 4);
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
                        OpenCellLinkPage("No.", 5);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 5);
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
                        OpenCellLinkPage("No.", 6);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 6);
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
                        OpenCellLinkPage("No.", 7);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 7);
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
                        OpenCellLinkPage("No.", 8);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 8);
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
                        OpenCellLinkPage("No.", 9);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 9);
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
                        OpenCellLinkPage("No.", 10);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 10);
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
                        OpenCellLinkPage("No.", 11);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 11);
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
                        OpenCellLinkPage("No.", 12);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 12);
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
                        OpenCellLinkPage("No.", 13);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 13);
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
                        OpenCellLinkPage("No.", 14);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 14);
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
                        OpenCellLinkPage("No.", 15);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 15);
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
                        OpenCellLinkPage("No.", 16);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 16);
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
                        OpenCellLinkPage("No.", 17);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 17);
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
                        OpenCellLinkPage("No.", 18);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 18);
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
                        OpenCellLinkPage("No.", 19);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 19);
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
                        OpenCellLinkPage("No.", 20);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 20);
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
                        OpenCellLinkPage("No.", 21);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 21);
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
                        OpenCellLinkPage("No.", 22);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 22);
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
                        OpenCellLinkPage("No.", 23);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 23);
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
                        OpenCellLinkPage("No.", 24);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 24);
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
                        OpenCellLinkPage("No.", 25);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 25);
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
                        OpenCellLinkPage("No.", 26);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 26);
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
                        OpenCellLinkPage("No.", 27);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 27);
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
                        OpenCellLinkPage("No.", 28);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 28);
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
                        OpenCellLinkPage("No.", 29);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 29);
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
                        OpenCellLinkPage("No.", 30);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 30);
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
                        OpenCellLinkPage("No.", 31);
                    end;

                    trigger OnValidate();
                    begin
                        UpdateCellRecord("No.", 31);
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

                    FILTERGROUP(0);
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

                    FILTERGROUP(0);
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
            action("Import Recurring Payroll Journals")
            {
                Image = Import;
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
        UseACY := false;

        // 15.03.2017 : AIM +
        ShowDimFlds := true;
        BonusSystemOption := BonusSystemOption::All;
        ShowBonusSystemFld := false;
        ShowManagerFld := true;
        ShowEmployeeName := true;
        // 15.03.2017 : AIM -
    end;

    trigger OnOpenPage();
    begin
        PayrollOfficerPermission := PayrollFunctions.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');

        InitializeGlobalVariables();
        SETFILTER(Status, 'Active');

        SETFILTER("Full Name", '=%1', '~~~');

        FILTERGROUP(0);
        ResetVariables();
        IntializeMatrix();
    end;

    var
        PDate: Date;
        DataColumn: array[32] of Decimal;
        ColumnCaption: array[32] of Text;
        ColumnVisible: array[32] of Boolean;
        CellStyle: array[32] of Text;
        MaxColumns: Integer;
        ColumnField: Text;
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
        ColumnTrxType: array[32] of Code[20];
        JournalTrxType: Code[20];
        UseACY: Boolean;
        PayParam: Record "Payroll Parameter";
        BonusSystemOption: Option "Has Bonus System","No Bonus System",All;
        ShowBonusSystemFld: Boolean;
        ShowDimFlds: Boolean;
        ShowManagerFld: Boolean;
        ShowEmployeeName: Boolean;
        PayrollOfficerPermission: Boolean;

    local procedure OpenCellLinkPage(No: Code[20]; RecID: Integer);
    var
        EmpAbs: Record "Employee Absence";
    begin
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
            DataAdd1[i] := '';
            DataAdd2[i] := '';
            DataAdd3[i] := '';
            ColumnTrxType[i] := '';
            i := i + 1;
        end;
        CLEAR(ColumnTrxType);
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
        i: Integer;
        L_HRTrxType: Record "HR Transaction Types";
        IncludeTrxTyp: Boolean;
    begin
        L_HRTrxType.SETRANGE(System, false);
        L_HRTrxType.SETFILTER(L_HRTrxType."Associated Pay Element", '<>%1', '');
        // 15.03.2017 : AIM +
        L_HRTrxType.SETRANGE(L_HRTrxType.System, false);
        // 15.03.2017 : AIM -
        if L_HRTrxType.FINDFIRST then begin
            i := 1;
            repeat
                if i <= MaxColumns then begin
                    IncludeTrxTyp := true;
                    if PayrollGroup <> '' then begin
                        if (STRPOS(UPPERCASE(L_HRTrxType."Payroll Group Code"), UPPERCASE(PayrollGroup)) <= 0) then
                          // 15.03.2017 : AIM +
                          begin
                            if (L_HRTrxType."Payroll Group Code" <> '') then
                                IncludeTrxTyp := false;
                        end;
                        // 15.03.2017 : AIM -
                    end;
                    if IncludeTrxTyp = true then begin
                        if EmpCategoryCode <> '' then begin
                            if (STRPOS(UPPERCASE(L_HRTrxType."Employee Category"), UPPERCASE(EmpCategoryCode)) <= 0) then
                              // 15.03.2017 : AIM +
                              begin
                                if (L_HRTrxType."Employee Category" <> '') then
                                    IncludeTrxTyp := false;
                            end;
                            // 15.03.2017 : AIM -
                        end;
                    end;
                    if IncludeTrxTyp = true then begin
                        ColumnTrxType[i] := L_HRTrxType.Code;
                        ColumnCaption[i] := L_HRTrxType.Description;
                        // 15.03.2017 : AIM +
                        i := i + 1;
                        // 15.03.2017 : AIM -
                    end;
                end;
            // 15.03.2017 : AIM +
            //i := i + 1;
            // 15.03.2017 : AIM -
            until L_HRTrxType.NEXT = 0;
        end;
    end;

    local procedure SetRecordCellValues();
    var
        i: Integer;
    begin
        i := 1;
        while i <= MaxColumns do begin

            if ("No." <> '') and (ColumnTrxType[i] <> '') then begin
                DataColumn[i] := GetEmpJournalValue("No.", PDate, ColumnTrxType[i], i);
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

            PayParam.RESET;
            CLEAR(PayParam);
            PayParam.GET;
            if UseACY = true then begin
                if PayParam."ACY Currency Rate" > 0 then begin
                    if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Division then
                        Val := ROUND(Val / PayParam."ACY Currency Rate", 0.01)
                    else
                        Val := ROUND(Val * PayParam."ACY Currency Rate", 0.01);
                end;
            end;

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
        //TrxType := JournalTrxType;
        TrxType := ColumnTrxType[RecID];
        if TrxType = '' then
            exit(false);

        TrxDate := PDate;
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

        PayParam.RESET;
        CLEAR(PayParam);
        PayParam.GET;

        CLEAR(EmpJournalLine);

        EmpJournalLine.SETCURRENTKEY("Transaction Type", "Employee No.", "Transaction Date", Type);
        EmpJournalLine.SETRANGE("Employee No.", EmpNo);
        EmpJournalLine.SETRANGE("Transaction Type", TrxType);
        EmpJournalLine.SETRANGE("Transaction Date", TrxDate);
        EmpJournalLine.SETRANGE(Type, Typ);

        Val := 0;
        Val := DataColumn[RecID];

        if UseACY = true then begin
            if PayParam."ACY Currency Rate" > 0 then begin
                if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Division then
                    Val := ROUND(Val * PayParam."ACY Currency Rate", 0.01)
                else
                    Val := ROUND(Val / PayParam."ACY Currency Rate", 0.01);
            end;
        end;
        if EmpJournalLine.FINDFIRST then begin

            EmpJournalLine.DELETE;

        end;

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

            i := 1;
            while i <= MaxColumns do begin
                if ColumnVisible[i] = true then begin
                    TrxDate := PDate;
                    TrxType := ColumnTrxType[i];

                    if (TrxType <> '') and (TrxDate <> 0D) then begin
                        HRTransTypes.SETCURRENTKEY(Code);
                        HRTransTypes.SETRANGE(Code, TrxType);
                        if HRTransTypes.FINDFIRST() then
                            Typ := HRTransTypes.Type;

                        CLEAR(EmpJournalLine);

                        EmpJournalLine.SETCURRENTKEY("Transaction Type", "Employee No.", "Transaction Date", Type);
                        EmpJournalLine.SETRANGE("Employee No.", EmpNo);
                        EmpJournalLine.SETRANGE("Transaction Type", TrxType);
                        EmpJournalLine.SETRANGE("Transaction Date", TrxDate);
                        EmpJournalLine.SETRANGE(Type, Typ);

                        EmpJournalLine.SETFILTER(EmpJournalLine.Processed, '<>%1', true);

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

        PDate := DMY2DATE(PayrollFunctions.GetLastDayinMonth(Period), M, Y);
    end;

    local procedure SetMatrixFilters();
    begin
        // 15.03.2017 : AIM +
        RESET;
        // 15.03.2017 : AIM -
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

        if PDate = 0D then
            ERROR('Enter Payroll Date');

        HRSetup.GET;


        SETFILTER(Status, 'Active');
        SETFILTER("Full Name", '<>%1', '');
        SETFILTER("No.", EmpNoFilter);
        SETFILTER("Employment Type Code", EmploymentType);


        SETFILTER("Employee Category Code", EmpCategoryCode);

        SETFILTER("Global Dimension 1 Code", Dimension1);
        SETFILTER("Global Dimension 2 Code", Dimension2);


        SETFILTER("Payroll Group Code", PayrollGroup);

        SETFILTER("Manager No.", ManagerNo);
        SETFILTER(Department, DepartmentFld);

        if VarDeclared <> Declared::" " then
            SETFILTER(Declared, '=%1', VarDeclared);

        // 15.03.2017 : AIM +
        if (ShowBonusSystemFld = true) then begin
            if BonusSystemOption = BonusSystemOption::"Has Bonus System" then
                SETFILTER("Bonus System", '<>%1', '')
            else
                if BonusSystemOption = BonusSystemOption::"No Bonus System" then
                    SETFILTER("Bonus System", '=%1', '');

        end;
        // 15.03.2017 : AIM -
    end;
}

