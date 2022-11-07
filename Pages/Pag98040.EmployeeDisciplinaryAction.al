page 98040 "Employee Disciplinary Action"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    DataCaptionFields = "Employee No.";
    PageType = Card;
    SourceTable = "Employee Disciplinary Action";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Employee No."; "Employee No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Nature of Action"; "Nature of Action")
                {
                    ApplicationArea = All;
                }
                field(Descritption; Descritption)
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Date of Issue"; "Date of Issue")
                {
                    ApplicationArea = All;
                }
                field("Issued By"; "Issued By")
                {
                    ApplicationArea = All;
                }
                field(Reference; Reference)
                {
                    ApplicationArea = All;
                }
                field("Comments 1"; "Comments 1")
                {
                    Caption = 'Comments';
                    ApplicationArea = All;

                }
                field("Next Review Date"; "Next Review Date")
                {
                    ApplicationArea = All;
                }
                field(Severity; Severity)
                {
                    ApplicationArea = All;
                }
                field(Attachment; GetAttachmentName)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Selection := STRMENU(AttachmentSelection, 2);
                        if Selection = 0 then
                            exit;
                        case Selection of
                            1:
                                begin
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Disciplinary Action", Rec.RECORDID, Rec.FIELDNO(Attachment));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Disciplinary Action", Rec.RECORDID, Rec.FIELDNO(Attachment)) <> '' then
                                        Attachment := 'YES'
                                    else
                                        Attachment := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Disciplinary Action", Rec.RECORDID, Rec.FIELDNO(Attachment));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Disciplinary Action", Rec.RECORDID, Rec.FIELDNO(Attachment)) then begin
                                        Attachment := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
                }
                field("Type of Offense"; "Type of Offense")
                {
                    ApplicationArea = All;
                }
                field("Description of Violation"; "Description of Violation")
                {
                    ApplicationArea = All;

                }
                field("Plan of Improvement"; "Plan of Improvement")
                {
                    ApplicationArea = All;

                }
                field("Consequences of Further Violation"; "Conseq. of Further Violation")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
    }

    var
        AttachmentManagment: Record "Attachment Managment";
        Selection: Integer;
        AttachmentSelection: Label 'Upload,Download,Delete';
}

