table 98039 "Employee Disciplinary Action"
{
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(2; "Action No."; Integer)
        {
        }
        field(3; "Date of Issue"; Date)
        {
        }
        field(4; "Nature of Action"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST(Disciplinary));
        }
        field(5; "Issued By"; Code[20])
        {
            TableRelation = Employee;
        }
        field(6; "Comments 1"; Text[250])
        {
        }
        field(7; "Comments 2"; Text[250])
        {
        }
        field(8; "Next Review Date"; Date)
        {
        }
        field(9; Severity; Option)
        {
            OptionMembers = "1","2","3","4","5";
        }
        field(10; Reference; Text[30])
        {
        }
        field(11; Descritption; Text[150])
        {
            CalcFormula = Lookup ("HR Information".Description WHERE(Code = FIELD("Nature of Action"),
                                                                     "Table Name" = CONST(Disciplinary)));
            FieldClass = FlowField;
        }
        field(12; Attachment; Text[3])
        {
            Editable = false;

            trigger OnValidate();
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
        field(13; "Type of Offense"; Code[50])
        {
            TableRelation = "HR Information".Code where("Table Name" = CONST("Type of Offense"));
        }
        field(14; "Description of Violation"; Text[250])
        {
        }
        field(15; "Plan of Improvement"; Text[250])
        {
        }
        field(16; "Conseq. of Further Violation"; Text[250])
        {
            Caption = 'Consequences of Further Violation';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Date of Issue", "Nature of Action", "Action No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Selection: Integer;
        AttachmentManagment: Record "Attachment Managment";
        AttachmentSelection: Label 'Upload,Download,Delete';

    local procedure GetAttachmentFileName(L_RecID: RecordID; L_FieldID: Integer) FName: Text;
    var
        AttachManageTBT: Record "Attachment Managment";
    begin
        exit(AttachManageTBT.GetAttachmentFileName(DATABASE::"Employee Disciplinary Action", L_RecID, L_FieldID));
    end;

    procedure GetAttachmentName() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO(Attachment)));
    end;
}