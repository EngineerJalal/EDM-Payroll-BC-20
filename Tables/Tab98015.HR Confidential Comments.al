table 98015 "HR Confidential Comments"
{
    DataCaptionFields = "Applicant No.";

    fields
    {
        field(1;"Applicant No.";Code[20])
        {
            Editable = false;
            TableRelation = Applicant;
        }
        field(2;"Confidential Code";Code[10])
        {
            NotBlank = false;
            TableRelation = Confidential;

            trigger OnValidate();
            begin
                Confidential.GET("Confidential Code");
                Description := Confidential.Description;
            end;
        }
        field(3;"User ID";Code[20])
        {
            Editable = false;
            TableRelation = User;
        }
        field(4;Date;Date)
        {
            Editable = false;
        }
        field(6;"Line No.";Integer)
        {
        }
        field(7;Description;Text[30])
        {
        }
        field(8;Comment;Boolean)
        {
            CalcFormula = Exist("HR Confidential Comment Line" WHERE ("Table Name"=CONST("Confidential Information"),"No."=FIELD("Applicant No."),"Table Line No."=FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Applicant No.","Confidential Code","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        CheckApplicantEditing;

        HRConfidentialCommentLine.SETRANGE("No.","Applicant No.");
        HRConfidentialCommentLine.DELETEALL;
    end;

    trigger OnInsert();
    begin
        CheckApplicantEditing;
        "User ID" := USERID;
        Date := TODAY;
    end;

    trigger OnModify();
    begin
        CheckApplicantEditing;
        "User ID" := USERID;
        Date := TODAY;
    end;

    trigger OnRename();
    begin
        CheckApplicantEditing;
        "User ID" := USERID;
        Date := TODAY;
    end;

    var
        Confidential : Record Confidential;
        HRConfidentialCommentLine : Record "HR Confidential Comment Line";
        Applicant : Record Applicant;

    procedure CheckApplicantEditing();
    begin
        Applicant.GET("Applicant No.");
        if (Applicant.Status = Applicant.Status::Hired) then
          ERROR ('Hired Applicants Cannot be Edited !');
    end;
}