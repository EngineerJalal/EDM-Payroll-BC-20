table 98016 "Academic History"
{
    DataCaptionFields = "No.";

    fields
    {
        field(1;"Table Name";Option)
        {
            OptionMembers = Applicant,Employee;
        }
        field(2;"No.";Code[20])
        {
            Editable = false;
            TableRelation = IF ("Table Name"=CONST("Applicant")) Applicant."No." ELSE IF ("Table Name"=CONST(Employee)) Employee."No.";
        }
        field(3;"Institute Type";Option)
        {
            NotBlank = false;
            OptionMembers = School,College,University,Training;
        }
        field(4;"From Date";Date)
        {
            NotBlank = false;
        }
        field(5;"To Date";Date)
        {
            NotBlank = false;
        }
        field(6;"Degree Code";Code[50])
        {
            NotBlank = false;
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("AcadDegree"));
        }
        field(7;"Line No.";Integer)
        {
        }
        field(8;"Specialty Code";Code[50])
        {
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("AcadSpecialty"));
        }
        field(9;Comment;Text[150])
        {
            Description = 'SHR2.0';
        }
        field(10;"Degree Name";Text[150])
        {
            CalcFormula = Lookup("HR Information".Description WHERE ("Table Name"=FILTER("AcadDegree"),Code=FIELD("Degree Code")));
            FieldClass = FlowField;
        }
        field(11;"Speciality Name";Text[150])
        {
            CalcFormula = Lookup("HR Information".Description WHERE ("Table Name"=FILTER("AcadSpecialty"),Code=FIELD("Specialty Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Table Name","No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        CheckApplicantEditing;
    end;

    trigger OnInsert();
    begin
        CheckApplicantEditing;
    end;

    trigger OnModify();
    begin
        CheckApplicantEditing;
    end;

    trigger OnRename();
    begin
        CheckApplicantEditing;
    end;

    var
        Applicant : Record Applicant;

    procedure CheckApplicantEditing();
    begin
        if "Table Name" = "Table Name"::Applicant then begin
            Applicant.GET("No.");
            if (Applicant.Status = Applicant.Status::Hired) then
                ERROR ('Hired Applicants Cannot be Edited !');
        end;
    end;
}