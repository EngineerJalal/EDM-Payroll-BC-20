table 98028 "Requested Documents"
{
    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Table Name" = CONST(Employee)) Employee ELSE
            IF ("Table Name" = CONST(Applicant)) Applicant;
        }
        field(2; "Document Code"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST(Document));

            trigger OnValidate();
            begin
                Description := "Document Code";
            end;
        }
        field(3; Description; Text[30])
        {
        }
        field(4; Status; Option)
        {
            OptionMembers = "Not Received",Received;
        }
        field(5; "Is Required"; Boolean)
        {
        }
        field(6; "Is Copy"; Boolean)
        {
        }
        field(7; "Issue Date"; Date)
        {
        }
        field(8; "Expiry Date"; Date)
        {

            trigger OnValidate();
            begin
                if "Expiry Date" < "Issue Date" then
                    ERROR('Expiry date must be greater than Issue date');
            end;
        }
        field(9; "Receipt Date"; Date)
        {
        }
        field(10; "Receipt Info"; Text[30])
        {
        }
        field(11; Requirements; Text[30])
        {
        }
        field(12; "Line No."; Integer)
        {
        }
        field(14; "No. of Copies"; Integer)
        {
        }
        field(15; "Requested From"; Option)
        {
            OptionMembers = Company,Employee;
        }
        field(16; "Table Name"; Option)
        {
            OptionMembers = Employee,Applicant;
        }
        field(17; "File Type"; Option)
        {
            OptionMembers = " ",Word,Excel,pdf,Image;
        }
        field(18; "File Name"; Text[100])
        {
            trigger OnValidate();
            begin
                if STRPOS("File Name", '.') = 0 then begin
                    case "File Type" of
                        "File Type"::Word:
                            "File Name" := "File Name" + '.doc';
                        "File Type"::Excel:
                            "File Name" := "File Name" + '.xls';
                        "File Type"::pdf:
                            "File Name" := "File Name" + '.pdf';
                    end;
                end;
            end;
        }
        field(19; "Show on Report"; Option)
        {
            OptionMembers = " ",EmpGenInfo,AppGenInfo;
        }
        field(60000; "Checklist Type"; Option)
        {
            OptionCaption = 'Copy of ID Card,Copy of Judiciary Record,Family Record,Supervisor Eval. Form,Self Eval. Form,Copy of Employment Contract,Individual Civil Record,Copy of Passport,Copy of Diplomas,CV,Letters of Recommendations,Permission to practice prof.,Home Address Certificate,Labor Office Certificate,Military Service,Residence Cert.,Driving License,Others,Position Request Form,Employment Approval Form,Job Application Form,Pre-Hiring Interview Sheet,Eng. Syndicate Card,App. Photos,Employee Banking Form,Proxy(Wakeleh),Undertaking-Terms Of Employment,last Work Permit,Proof of Residence,MOF No,Confidantiality Contract,Judiciary Record,Order of Engineers No,Signed Contract,Salary Raise,English Exam,Behavioral interview,Technical interview,Job offer approved,Photo passports,Judicial Records,Original Register,Original Family,NSSF Certificate,Employment Verification,Educational Verification,Medical Exam report,App. Form,Tax declaration form,Written agreement,Confidentiality Letter,Employee job description,Marriage Certificate,National Identity,Degree (UAE),Emirates ID Copies';
            OptionMembers = "Copy of ID Card","Copy of Judiciary Record","Family Record","Supervisor Eval. Form","Self Eval. Form","Copy of Employment Contract","Individual Civil Record","Copy of Passport","Copy of Diplomas",CV,"Letters of Recommendations","Permission to practice prof.","Home Address Certificate","Labor Office Certificate","Military Service","Residence Cert.","Driving License",Others,"Position Request Form","Employment Approval Form","Job Application Form","Pre-Hiring Interview Sheet","Eng. Syndicate Card","App. Photos","Employee Banking Form","Proxy(Wakeleh)","Undertaking-Terms Of Employment","last Work Permit","Proof of Residence","MOF No","Confidantiality Contract","Judiciary Record","Order of Engineers No","Signed Contract","Salary Raise","English Exam","Behavioral interview","Technical interview","Job offer approved","Photo passports","Judicial Records","Original Register","Original Family","NSSF Certificate","Employment Verification","Educational Verification","Medical Exam report","App. Form","Tax declaration form","Written agreement","Confidentiality Letter","Employee job description","Marriage Certificate","National Identity","Degree (UAE)","Emirates ID Copies";
        }
        field(60001; Attachments; Text[3])
        {
            Editable = false;
            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Requested Documents", Rec.RECORDID, Rec.FIELDNO(Attachments));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Requested Documents", Rec.RECORDID, Rec.FIELDNO(Attachments)) <> '' then
                                Attachments := 'YES'
                            else
                                Attachments := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Requested Documents", Rec.RECORDID, Rec.FIELDNO(Attachments));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Requested Documents", Rec.RECORDID, Rec.FIELDNO(Attachments)) then begin
                                Attachments := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(60002; "Document Description"; Text[150])
        {
        }
        field(60003; "Document Name"; Text[150])
        {
            CalcFormula = Lookup ("HR Information".Description WHERE(Code = FIELD("Document Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.", "Document Code", "Table Name", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        CheckApplicantEdsiting;
    end;

    trigger OnInsert();
    begin
        CheckApplicantEdsiting;
    end;

    trigger OnModify();
    begin
        CheckApplicantEdsiting;
    end;

    trigger OnRename();
    begin
        CheckApplicantEdsiting;
    end;

    var
        Selection: Integer;
        AttachmentManagment: Record "Attachment Managment";
        AttachmentSelection: Label 'Upload,Download,Delete';

    procedure CheckApplicantEdsiting();
    var
        applicant: Record Applicant;
    begin
        if "Table Name" = "Table Name"::Applicant then begin
            applicant.GET("No.");
            if (applicant.Status = applicant.Status::Hired) then
                ERROR('Hired Applicants Cannot be Edited !');
        end;
    end;

    local procedure GetAttachmentFileName(L_RecID: RecordID; L_FieldID: Integer) FName: Text;
    var
        AttachManageTBT: Record "Attachment Managment";
    begin
        exit(AttachManageTBT.GetAttachmentFileName(DATABASE::"Requested Documents", L_RecID, L_FieldID));
    end;

    procedure GetAttachmentName() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO(Attachments)));
    end;
}