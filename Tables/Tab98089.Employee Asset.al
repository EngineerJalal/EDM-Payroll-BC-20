table 98089 "Employee Asset"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Line No";Integer)
        {
        }
        field(2;"Employee No";Code[20])
        {
        }
        field(3;"Asset details";Text[50])
        {
        }
        field(4;"Given Date";Date)
        {
        }
        field(5;"Type of asset";Code[10])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST("Type of Asset"));
        }
        field(6;Status;Option)
        {
            OptionMembers = "Not handed over yet","In use","Damaged-will not be returned","Returned with damages","Returned in good condition";
        }
        field(7;"Returned Date";Date)
        {
        }
        field(8;Attachment;Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection,2);
                if Selection = 0 then
                  exit;
                case Selection of
                  1:begin
                      AttachmentManagment.ImportAttachment(DATABASE::"Employee Asset",Rec.RECORDID,Rec.FIELDNO(Attachment));
                      if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Asset",Rec.RECORDID,Rec.FIELDNO(Attachment))  <> '' then
                         Attachment :=  'YES'
                      else
                        Attachment :=  'NO';
                      MODIFY(true);
                    end;
                  2:begin
                      AttachmentManagment.ExportAttachment(DATABASE::"Employee Asset",Rec.RECORDID,Rec.FIELDNO(Attachment));
                    end;
                  3:begin
                      if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Asset",Rec.RECORDID,Rec.FIELDNO(Attachment)) then begin
                       Attachment := 'NO';
                        MODIFY(true);
                      end;
                    end;
                end;
            end;
        }
        field(9;Remarks;Text[150])
        {
        }
    }

    keys
    {
        key(Key1;"Line No","Employee No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "Line No" := 0;
        EmpAsset.SETRANGE("Employee No","Employee No");
        if EmpAsset.FINDLAST() then
          "Line No" := EmpAsset."Line No" + 1
        else
          "Line No" := 1;
    end;

    var
        Selection : Integer;
        AttachmentManagment : Record "Attachment Managment";
        AttachmentSelection : Label 'Upload,Download,Delete';
        EmpAsset : Record "Employee Asset";

    local procedure GetAttachmentFileName(L_RecID : RecordID;L_FieldID : Integer) FName : Text;
    var
        AttachManageTBT : Record "Attachment Managment";
    begin
        exit(AttachManageTBT.GetAttachmentFileName(DATABASE::"Employee Asset",L_RecID,L_FieldID));
    end;

    procedure GetAssetAttach() Fname : Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID,Rec.FIELDNO(Attachment)));
    end;
}

