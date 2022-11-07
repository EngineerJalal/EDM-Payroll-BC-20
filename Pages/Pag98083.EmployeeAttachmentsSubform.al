page 98083 "Employee Attachments Subform"
{
    // version EDM.HRPY2

    PageType = CardPart;
    SourceTable = "Employee Additional Info";

    layout
    {
        area(content)
        {
            group(Control25)
            {
                field("Passport Valid Until"; "Passport Valid Until")
                {
                    ApplicationArea = All;
                }
                field("Work Permit Valid Until"; "Work Permit Valid Until")
                {
                    ApplicationArea = All;
                }
                field("Insurance Valid Until"; "Insurance Valid Until")
                {
                    ApplicationArea = All;
                }
                field("Work Residency Valid Unti"; "Work Residency Valid Until")
                {
                    ApplicationArea = All;
                }
                field(GetIDAttach; GetIDAttach)
                {
                    Caption = 'ID';
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Selection := STRMENU(AttachmentSelection, 2);
                        if Selection = 0 then
                            exit;
                        case Selection of
                            1:
                                begin
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID)) <> '' then
                                        ID := 'YES'
                                    else
                                        ID := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID)) then begin
                                        ID := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
                }
                field(GetPassportAttach; GetPassportAttach)
                {
                    Caption = 'Passport';
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
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport)) <> '' then
                                        Passport := 'YES'
                                    else
                                        Passport := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport)) then begin
                                        Passport := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
                }
                field(GetWorkPermitAttach; GetWorkPermitAttach)
                {
                    Caption = 'Work Permit';
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Selection := STRMENU(AttachmentSelection, 2);
                        if Selection = 0 then
                            exit;
                        case Selection of
                            1:
                                begin
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit"));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit")) <> '' then
                                        "Last Work Permit" := 'YES'
                                    else
                                        "Last Work Permit" := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit"));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit")) then begin
                                        "Last Work Permit" := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
                }
                field(GetInsuranceAttach; GetInsuranceAttach)
                {
                    Caption = 'Insurance';
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
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance)) <> '' then
                                        Insurance := 'YES'
                                    else
                                        Insurance := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance)) then begin
                                        Insurance := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
                }
                field(GetProxyAttach; GetProxyAttach())
                {
                    Caption = 'Proxy(Wakeleh)';
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
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)"));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)")) <> '' then
                                        "Proxy(Wakeleh)" := 'YES'
                                    else
                                        "Proxy(Wakeleh)" := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)"));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)")) then begin
                                        "Proxy(Wakeleh)" := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
                }
                field(GetUndertakingFormAttach; GetUndertakingFormAttach)
                {
                    Caption = 'Undertaking Form';
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Selection := STRMENU(AttachmentSelection, 2);
                        if Selection = 0 then
                            exit;
                        case Selection of
                            1:
                                begin
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form"));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form")) <> '' then
                                        "Undertaking Form" := 'YES'
                                    else
                                        "Undertaking Form" := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form"));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form")) then begin
                                        "Undertaking Form" := 'NO';
                                        MODIFY(true);
                                    end;
                                end;
                        end;
                    end;
                }
                field(GetWorkResidencyAttach; GetWorkResidencyAttach)
                {
                    Caption = 'Work Residency';
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
                                    AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency"));
                                    if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency")) <> '' then
                                        "Work Residency" := 'YES'
                                    else
                                        "Work Residency" := 'NO';
                                    MODIFY(true);
                                end;
                            2:
                                begin
                                    AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency"));
                                end;
                            3:
                                begin
                                    if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency")) then begin
                                        "Work Residency" := 'NO';
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
        area(processing)
        {
            group(Passport)
            {
                Caption = 'Passport';
                Visible = false;
                action("Import Passport")
                {
                    Caption = 'Import Passport';
                    Image = Attach;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport));

                        Passport := AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport));
                        MODIFY(true);
                    end;
                }
                action("Delete Passport")
                {
                    Caption = 'Delete Passport';
                    Image = Delete;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport)) then begin
                            Passport := '';
                            MODIFY(true);
                        end;
                    end;
                }
            }
            group(ID)
            {
                Caption = 'ID';
                Visible = false;
                action("Import ID")
                {
                    Caption = 'Import ID';
                    Image = Attach;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID));

                        ID := AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID));
                        MODIFY(true);
                    end;
                }
                action("Delete ID")
                {
                    Caption = 'Delete ID';
                    Image = Delete;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID)) then begin
                            ID := '';
                            MODIFY(true);
                        end;
                    end;
                }
            }
            group("Proxy(Wakeleh)")
            {
                Caption = 'Proxy(Wakeleh)';
                Visible = false;
                action("Import Proxy(Wakeleh)")
                {
                    Caption = 'Import Proxy(Wakeleh)';
                    Image = Attach;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)"));

                        "Proxy(Wakeleh)" := AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)"));
                        MODIFY(true);
                    end;
                }
                action("Delete Proxy(Wakeleh)")
                {
                    Caption = 'Delete Proxy(Wakeleh)';
                    Image = Delete;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)")) then begin
                            "Proxy(Wakeleh)" := '';
                            MODIFY(true);
                        end;
                    end;
                }
            }
            group("Undertaking Form")
            {
                Caption = 'Undertaking Form';
                Visible = false;
                action("Import Undertaking Form")
                {
                    Caption = 'Import Undertaking Form';
                    Image = Attach;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form"));

                        "Undertaking Form" := AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form"));
                        MODIFY(true);
                    end;
                }
                action("Delete Undertaking Form")
                {
                    Caption = 'Delete Undertaking Form';
                    Image = Delete;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form")) then begin
                            "Undertaking Form" := '';
                            MODIFY(true);
                        end;
                    end;
                }
            }
            group("Last Work Permit")
            {
                Caption = 'Last Work Permit';
                Visible = false;
                action("Import Last Work Permit")
                {
                    Caption = 'Import Last Work Permit';
                    Image = Attach;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit"));

                        "Last Work Permit" := AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit"));
                        MODIFY(true);
                    end;
                }
                action("Delete Last Work Permit")
                {
                    Caption = 'Delete Last Work Permit';
                    Image = Delete;
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin

                        if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit")) then begin
                            "Last Work Permit" := '';
                            MODIFY(true);
                        end;
                    end;
                }
            }
        }
    }

    var
        AttachmentManagment: Record "Attachment Managment";
        Selection: Integer;
        AttachmentSelection: Label 'Upload,Download,Delete';
}

