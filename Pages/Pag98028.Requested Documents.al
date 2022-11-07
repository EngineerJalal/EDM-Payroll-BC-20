page 98028 "Requested Documents"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    DataCaptionFields = "No.";
    PageType = Card;
    SourceTable = "Requested Documents";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee No.";Rec."No.")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Document Code";Rec."Document Code")
                {
                    ApplicationArea=All;
                }
                field("Checklist Type";Rec."Checklist Type")
                {
                    ApplicationArea=All;
                }
                field("File Type";Rec."File Type")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("File Name";Rec."File Name")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Document Name";Rec."Document Name")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Document Description";Rec."Document Description")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Requested From";Rec."Requested From")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Receipt Info";Rec."Receipt Info")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Status;Rec.Status)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Is Required";Rec."Is Required")
                {
                    Caption = 'Required';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Is Copy";Rec."Is Copy")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("No. of Copies";Rec."No. of Copies")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Issue Date";Rec."Issue Date")
                {
                    ApplicationArea=All;
                }
                field("Expiry Date";Rec."Expiry Date")
                {
                    ApplicationArea=All;
                }
                field("Receipt Date";Rec."Receipt Date")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Requirements;Rec.Requirements)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Show on Report";Rec."Show on Report")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Attachment;Rec.GetAttachmentName)
                {
                    Visible = false;
                    ApplicationArea=All;
                    trigger OnLookup(var Text : Text) : Boolean;
                    begin
                        Selection := STRMENU(AttachmentSelection,2);
                        if Selection = 0 then
                          exit;
                        case Selection of
                          1:begin
                              AttachmentManagment.ImportAttachment(DATABASE::"Requested Documents",Rec.RECORDID,Rec.FIELDNO(Attachments));
                              if AttachmentManagment.GetAttachmentFileName(DATABASE::"Requested Documents",Rec.RECORDID,Rec.FIELDNO(Attachments))  <> '' then
                                 Rec.Attachments :=  'YES'
                              else
                                Rec.Attachments :=  'NO';
                              Rec.MODIFY(true);
                            end;
                          2:begin
                              AttachmentManagment.ExportAttachment(DATABASE::"Requested Documents",Rec.RECORDID,Rec.FIELDNO(Attachments));
                            end;
                          3:begin
                              if AttachmentManagment.DeleteAttachment(DATABASE::"Requested Documents",Rec.RECORDID,Rec.FIELDNO(Attachments)) then begin
                                Rec.Attachments := 'NO';
                                Rec.MODIFY(true);
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
            group("F&unctions")
            {
                Caption = 'F&unctions';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        HRInformation.SETRANGE(Code,Rec."Document Code");
        if HRInformation.FINDFIRST then
          Rec."Document Description" := HRInformation.Description;
    end;

    trigger OnOpenPage();
    begin
        CreateExtraDocTypeList();
    end;

    var
        RequestedDocument : Record "Requested Documents";
        HumanResSetup : Record "Human Resources Setup";
        HRInformation : Record "HR Information";
        ExtraDocTypeList : Option "Confidantiality Contract","Copy of Diplomas","Driving License","Copy of Employment Contract","Family Record","Copy of Identification Card","Copy of Judiciary Record","NSSF Docs","Proof of Residence","Permission to practice prof.","Ministry of Finance No","Order of Engineers No","Salary Raise";
        Selection : Integer;
        AttachmentManagment : Record "Attachment Managment";
        AttachmentSelection : Label 'Upload,Download,Delete';

    local procedure GetSuitableDocType(DocCode : Text[50]);
    var
        RequestedDoc : Record "Requested Documents";
    begin
        case DocCode of
        'CONFI.CONT' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Confidantiality Contract";
        'Diplomas' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Copy of Diplomas";
        'DriveLic' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Driving License";
        'EMPLOYMENT' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Copy of Employment Contract";
        'FAMILYREC' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Family Record";
        'IDENTITY' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Copy of ID Card";
        'JUDICIARY' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Copy of Judiciary Record";
        'NSSF' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"NSSF Certificate";
        'RESIDENCE' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Proof of Residence";
        'Permiprof' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Permission to practice prof.";
        'MinistFin' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"MOF No";
        'OrderEng' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Order of Engineers No";
        'SALRYRAISE' : Rec."Checklist Type" := RequestedDoc."Checklist Type"::"Salary Raise";
        end;
    end;

    local procedure CreateExtraDocTypeList();
    var
        HRInfoTbt : Record "HR Information";
    begin
        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Confidantiality Contract"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Confidantiality Contract");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Confidantiality Contract");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Diplomas"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Diplomas");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Copy of Diplomas");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Driving License"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Driving License");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Driving License");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Employment Contract"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Employment Contract");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Copy of Employment Contract");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Family Record"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Family Record");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Family Record");
             HRInfoTbt.INSERT;
          end;


        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Identification Card"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Identification Card");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Copy of Identification Card");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Judiciary Record"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Copy of Judiciary Record");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Copy of Judiciary Record");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"NSSF Docs"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"NSSF Docs");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"NSSF Docs");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Proof of Residence"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Proof of Residence");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Proof of Residence");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Permission to practice prof."));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Permission to practice prof.");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Permission to practice prof.");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Ministry of Finance No"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Ministry of Finance No");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Ministry of Finance No");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Order of Engineers No"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Order of Engineers No");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Order of Engineers No");
             HRInfoTbt.INSERT;
          end;

        HRInfoTbt.RESET;
        CLEAR(HRInfoTbt);
        HRInfoTbt.SETRANGE(HRInfoTbt.Code,GetExtraDocTypeCode(ExtraDocTypeList::"Salary Raise"));
        HRInfoTbt.SETRANGE(HRInfoTbt."Table Name",HRInfoTbt."Table Name"::Document);
        if HRInfoTbt.FINDFIRST = false then
          begin
             HRInfoTbt.INIT;
             HRInfoTbt.Code := GetExtraDocTypeCode(ExtraDocTypeList::"Salary Raise");
             HRInfoTbt."Table Name" := HRInfoTbt."Table Name"::Document;
             HRInfoTbt.Description := GetExtraDocTypeName(ExtraDocTypeList::"Salary Raise");
             HRInfoTbt.INSERT;
          end;
    end;

    local procedure GetExtraDocTypeCode(ExtraDocType : Option "Confidantiality Contract","Copy of Diplomas","Driving License","Copy of Employment Contract","Family Record","Copy of Identification Card","Copy of Judiciary Record","NSSF Docs","Proof of Residence","Permission to practice prof.","Ministry of Finance No","Order of Engineers No","Salary Raise") DocCodeV : Code[10];
    begin
        case ExtraDocType of
          ExtraDocType::"Confidantiality Contract" : DocCodeV := 'CONFI.CONT';
          ExtraDocType::"Copy of Diplomas" : DocCodeV := 'Diplomas';
          ExtraDocType::"Driving License" : DocCodeV := 'DriveLic';
          ExtraDocType::"Copy of Employment Contract" : DocCodeV := 'EMPLOYMENT';
          ExtraDocType::"Family Record" : DocCodeV := 'FAMILYREC';
          ExtraDocType::"Copy of Identification Card" : DocCodeV := 'IDENTITY';
          ExtraDocType::"Copy of Judiciary Record" : DocCodeV := 'JUDICIARY';
          ExtraDocType::"NSSF Docs": DocCodeV := 'NSSF';
          ExtraDocType::"Proof of Residence" : DocCodeV := 'RESIDENCE';
          ExtraDocType::"Permission to practice prof." : DocCodeV := 'Permiprof';
          ExtraDocType::"Ministry of Finance No" : DocCodeV := 'MinistFin';
          ExtraDocType::"Order of Engineers No" : DocCodeV := 'OrderEng';
          // 22.05.2017 : A2+
          ExtraDocType::"Salary Raise" : DocCodeV := 'SALRYRAISE';
          // 22.05.2017 : A2-
        end;

        exit (DocCodeV);
    end;

    local procedure GetExtraDocTypeName(ExtraDocType : Option "Confidantiality Contract","Copy of Diplomas","Driving License","Copy of Employment Contract","Family Record","Copy of Identification Card","Copy of Judiciary Record","NSSF Docs","Proof of Residence","Permission to practice prof.","Ministry of Finance No","Order of Engineers No","Salary Raise") DocNameV : Text;
    begin
        case ExtraDocType of
          ExtraDocType::"Confidantiality Contract" : DocNameV := 'Confidentiality Contract';
          ExtraDocType::"Copy of Diplomas": DocNameV:= 'Copy of Diplomas';
          ExtraDocType::"Driving License": DocNameV:= 'Driving License';
          ExtraDocType::"Copy of Employment Contract": DocNameV := 'Copy of Employment Contract';
          ExtraDocType::"Family Record": DocNameV := 'Family Record';
          ExtraDocType::"Copy of Identification Card": DocNameV := 'Copy of Identification Card';
          ExtraDocType::"Copy of Judiciary Record": DocNameV := 'Copy of Judiciary Record';
          ExtraDocType::"NSSF Docs": DocNameV := 'NSSF Docs';
          ExtraDocType::"Proof of Residence": DocNameV := 'Proof of Residence';
          ExtraDocType::"Permission to practice prof.": DocNameV := 'Permission to practice prof.';
          ExtraDocType::"Ministry of Finance No": DocNameV := 'Ministry of Finance No';
          ExtraDocType::"Order of Engineers No": DocNameV := 'Order of Engineers No';
          // 22.05.2017 : A2+
          ExtraDocType::"Salary Raise": DocNameV := 'Salary Raise';
          // 22.05.2017 : A2-
        end;

        exit (DocNameV);
    end;
}

