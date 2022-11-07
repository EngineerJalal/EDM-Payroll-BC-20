table 98018 "Language Skills"
{
    DataCaptionFields = "No.";

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
            TableRelation = IF ("Table Name"=CONST("Applicant")) Applicant."No." ELSE IF ("Table Name"=CONST("Employee")) Employee."No.";
        }
        field(2;"Language Code";Code[10])
        {
            NotBlank = true;
            TableRelation = Language;
        }
        field(3;Understanding;Option)
        {
            OptionMembers = Excellent,Medium,Normal,Poor;
        }
        field(4;Speaking;Option)
        {
            OptionMembers = Excellent,Medium,Normal,Poor;
        }
        field(5;Reading;Option)
        {
            OptionMembers = Excellent,Medium,Normal,Poor;
        }
        field(6;Writing;Option)
        {
            OptionMembers = Excellent,Medium,Normal,Poor;
        }
        field(7;"Table Name";Option)
        {
            OptionMembers = Applicant,Employee;
        }
    }

    keys
    {
        key(Key1;"Table Name","No.","Language Code")
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
        Applicant : Record Applicant;

    procedure CheckApplicantEdsiting();
    begin
        if "Table Name" = "Table Name"::Applicant then begin
            Applicant.GET("No.");
            if (Applicant.Status = Applicant.Status::Hired) then
                ERROR ('Hired Applicants Cannot be Edited !');
        end;
    end;
}