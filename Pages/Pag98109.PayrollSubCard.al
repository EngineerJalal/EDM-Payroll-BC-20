page 98109 "Payroll Sub Card"
{
    // version EDM.HRPY2

    PageType = Card;
    SourceTable = "Payroll Sub Main";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Ref Code";"Ref Code")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field("Pay Date";"Pay Date")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field("Document No.";"Document No.")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field(Status;Status)
                {
                    Caption = 'Status';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Calculate Income Tax";"Calculate Income Tax")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field("Calculate NSSF Contributions";"Calculate NSSF Contributions")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field("Include Exemption";"Include Exemption")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
            }
            group(Control16)
            {
                part(Control14;"Payroll Sub ListPart")
                {
                    Editable = IsEditable;
                    Enabled = IsEditable;
                    SubPageLink = "Ref Code"=FIELD("Ref Code");
                    UpdatePropagation = Both;
                    ApplicationArea=All;
                }
            }
            group("Additional Info")
            {
                field(Remark;Remark)
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field("Posting Status";"Posting Status")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Posting Date";"Posting Date")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Posting User";"Posting User")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            //Caption = 'General';
            action(Post)
            {
                Enabled = IsEditable;
                Image = Post;
                                                    ApplicationArea=All;

                trigger OnAction();
                var
                    L_PostType : Option "Payroll Only","G/L Only",All;
                begin
                    // Added in order prevent posting with same payroll date - 01.11.2017 : A2+
                    IF PayrollFunction.IsValideSubPayrollPostingDate("Pay Date") THEN
                      ERROR('Payroll date allready exist');
                    // Added in order prevent posting with same payroll date - 01.11.2017 : A2-

                    PayrollFunction.PostSubPayrollRecords("Ref Code",L_PostType::All);
                    MESSAGE('Process Done');

                    "Posting Status" := "Posting Status"::Posted;
                    "Posting Date" := WORKDATE;
                    "Posting User" := USERID;
                    IsEditable := false;
                end;
            }
            action("Re-Open")
            {
                Image = ReOpen;
                ApplicationArea=All;

                trigger OnAction();
                var
                    L_PayrollFunction : Codeunit "Payroll Functions";
                    L_DeleteOption : Option "Re-Open",Delete;
                begin
                    L_PayrollFunction.DeleteSubPayrollData(Rec."Ref Code",L_DeleteOption::"Re-Open");
                    MESSAGE('Process Done');

                    "Posting Status" := "Posting Status"::Pending;
                    IsEditable := true;
                end;
            }
            action(Delete)
            {
                Image = Delete;
                ApplicationArea=All;

                trigger OnAction();
                var
                    L_PayrollFunction : Codeunit "Payroll Functions";
                    L_DeleteOption : Option "Re-Open",Delete;
                begin
                    if not CONFIRM('Are you sure you want to delete this record',false) then
                      ERROR('');

                    if Rec."Posting Status" <> Rec."Posting Status"::Pending then
                      ERROR('Record cannot be deleted');

                    L_PayrollFunction.DeleteSubPayrollData(Rec."Ref Code",L_DeleteOption::Delete);
                    MESSAGE('Process Done');
                end;
            }
            group(Process)
            {
                Caption = 'Process';
                action("Import Recurring Sub Payroll")
                {
                    Image = Import;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        ImportRecSubPayRpt : Report "Import Recurring Sub Payroll";
                    begin
                        if Rec."Ref Code" = '' then
                          ERROR('Ref Code Must not be empty');

                        ImportRecSubPayRpt.SetParameter(Rec."Ref Code");
                        ImportRecSubPayRpt.RUN;
                    end;
                }
                action("Import Sub-Payroll Jnl From Excel")
                {
                    Image = ImportExcel;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        ImporSubPaytJnlFromExcel : Report "Import Sub Payroll Journals";
                    begin
                        if Rec."Ref Code" = '' then
                          ERROR('Ref Code Must not be empty');

                        ImporSubPaytJnlFromExcel.SetParameter(Rec."Ref Code");
                        ImporSubPaytJnlFromExcel.RUN;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        Status := Status::Approved;
    end;

    trigger OnOpenPage();
    begin
        if "Posting Status" = "Posting Status"::Pending then
          IsEditable := true;
    end;

    trigger OnQueryClosePage(CloseAction : Action) : Boolean;
    begin
        if Rec."Ref Code" <> '' then
          begin
            TESTFIELD("Document No.");
            TESTFIELD("Pay Date");
          end;
    end;

    var
        PayrollFunction : Codeunit "Payroll Functions";
        IsEditable : Boolean;
}

