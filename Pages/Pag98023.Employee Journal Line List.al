page 98023 "Employee Journal Line List"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Employee Journal Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }

                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Calculated Value"; Rec."Calculated Value")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Rounding of Calculated Value"; Rec."Rounding of Calculated Value")
                {
                    Visible = false;
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("More Information"; Rec."More Information")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Document Status"; Rec."Document Status")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Opened By"; Rec."Opened By")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Opened Date"; Rec."Opened Date")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Released By"; Rec."Released By")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Released Date"; Rec."Released Date")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Absence Transaction Type"; Rec."Absence Transaction Type")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("From Time"; Rec."From Time")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("To Time"; Rec."To Time")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Processed Date"; Rec."Processed Date")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }
                field("Month 13"; Rec."Month 13")
                {
                    Editable = EditEmployeeJournal;
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("&Dimensions")
                {
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    //Stopped By EDM.MM RunPageLink = "Table ID"=CONST(17373),"Dimension Code"=FIELD("Employee No."),"Dimension Value Code"=FIELD("Entry No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action(ReOpen)
                {
                    Caption = 'Re&Open';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        Rec.MARKEDONLY(true);
                        if Rec.FIND('-') then begin
                            repeat
                                DoFunction('ReOpen');
                            until Rec.NEXT = 0;
                            Rec.MARKEDONLY(false);
                        end else begin
                            Rec.MARKEDONLY(false);
                            DoFunction('ReOpen');
                        end;
                        Rec.CLEARMARKS;
                        //shr2.0-
                    end;
                }
                action(Release)
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        if CONFIRM(
                          'Do you wish to Make Release for All Journal lines?')
                        then begin
                            if Rec.FIND('-') then
                                repeat
                                    DoFunction('Release');
                                until Rec.NEXT = 0;
                        end
                        else begin
                            Rec.MARKEDONLY(true);
                            if Rec.FIND('-') then begin
                                repeat
                                    DoFunction('Release');
                                until Rec.NEXT = 0;
                                Rec.MARKEDONLY(false);
                            end else begin
                                Rec.MARKEDONLY(false);
                                DoFunction('Release');
                            end;
                            Rec.CLEARMARKS;
                        end;
                        //shr2.0-
                    end;
                }
                action(Approve)
                {
                    Caption = '&Approve';
                    Image = Approve;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        if CONFIRM(
                          'Do you wish to Make Approve for All Journal lines?')
                        then begin
                            if Rec.FIND('-') then
                                repeat
                                    DoFunction('Approve');
                                until Rec.NEXT = 0;
                        end
                        else begin
                            Rec.MARKEDONLY(true);
                            if Rec.FIND('-') then begin
                                repeat
                                    DoFunction('Approve');
                                until Rec.NEXT = 0;
                                Rec.MARKEDONLY(false);
                            end else begin
                                Rec.MARKEDONLY(false);
                                DoFunction('Approve');
                            end;
                            Rec.CLEARMARKS;
                        end;
                        //shr2.0-
                    end;
                }
            }
        }
    }

    trigger OnInit();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if PayrollFunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    trigger OnOpenPage();
    begin
        IF UserSetup.GET(USERID) THEN begin
            IF UserSetup."Allow Modify Payroll Ledger" THEN
                EditEmployeeJournal := true
            ELSE
                EditEmployeeJournal := false
        end;
    end;

    var
        PayrollFunction: Codeunit "Payroll Functions";
        EditEmployeeJournal: Boolean;
        UserSetup: Record "User Setup";

    procedure DoFunction(P_Type: Text[30]);
    begin
        case P_Type of
            'ReOpen':
                begin
                    if Rec."Transaction Type" <> '' then begin
                        if Rec."Document Status" = Rec."Document Status"::Opened then
                            ERROR('Document is already Opened.');
                        if Rec.Processed then
                            ERROR('Cannot Re-Open a Processed Benefit Journal Line.');
                        Rec.ReOpen_Document();
                    end;
                end;//reopen
            'Release':
                begin
                    if Rec."Transaction Type" <> '' then begin
                        if Rec."Document Status" <> Rec."Document Status"::Opened then
                            ERROR('Only Opened Documents Can be Released !');
                        Rec.Release_Document();
                    end;
                end; //release
            'Approve':
                begin
                    if Rec."Transaction Type" <> '' then begin
                        if Rec."Document Status" <> Rec."Document Status"::Released then
                            ERROR('Only Released Documents Can be Approved !');
                        Rec.Approve_Document();
                    end;
                end;//approve
        end; //case
    end;
}

