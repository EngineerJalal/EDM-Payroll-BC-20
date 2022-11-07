page 98086 "Employee Assets List"
{
    // version EDM.HRPY2

    InsertAllowed = true;
    PageType = List;
    SourceTable = "Employee Asset";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Asset details"; "Asset details")
                {
                    ApplicationArea = All;
                }
                field("Type of asset"; "Type of asset")
                {
                    ApplicationArea = All;
                }
                field("Given Date"; "Given Date")
                {
                    ApplicationArea = All;
                }
                field("Returned Date"; "Returned Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field(Attachment; GetAssetAttach)
                {
                    Caption = 'Attachment';
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Selection := STRMENU(AttachmentSelection, 2);
                        if Selection = 0 then
                            exit;
                        case Selection of
                            1:
                                begin
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Asset", Rec.RECORDID, Rec.FIELDNO(Attachment));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Asset", Rec.RECORDID, Rec.FIELDNO(Attachment)) <> '' then
                                        Attachment := 'YES'
                                    else
                                        Attachment := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Asset", Rec.RECORDID, Rec.FIELDNO(Attachment));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Asset", Rec.RECORDID, Rec.FIELDNO(Attachment)) then begin
                                        Attachment := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
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

