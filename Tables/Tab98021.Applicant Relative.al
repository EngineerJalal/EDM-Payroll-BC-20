table 98021 "Applicant Relative"
{
    Caption = 'Employee Relative';
    DataCaptionFields = "Applicant No.";
    DrillDownPageID = "Applicant Relatives";
    LookupPageID = "Applicant Relatives";

    fields
    {
        field(1; "Applicant No."; Code[20])
        {
            Caption = 'Applicant No.';
            Editable = false;
            NotBlank = true;
            TableRelation = Applicant;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Relative Code"; Code[10])
        {
            Caption = 'Relative Code';
            TableRelation = Relative;
            trigger OnValidate();
            begin
                if Relative.GET("Relative Code") then begin
                    Applicant.GET("Applicant No.");
                    if Relative.Type = Relative.Type::Child then
                        "Eligible Child" := true
                    else
                        "Eligible Child" := false;
                    if Relative.Type = Relative.Type::Mother then
                        "First Name" := Applicant."Mother Name";
                end;
            end;
        }
        field(4; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(5; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(6; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(7; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(9; "Relative's Employee No."; Code[20])
        {
            Caption = 'Relative''s Employee No.';
            TableRelation = Employee;
        }
        field(10; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = Normal;
        }
        field(80000; Working; Boolean)
        {
            Description = 'PY1.0';
        }
        field(80001; "Eligible Child"; Boolean)
        {
            Description = 'PY1.0';

            trigger OnValidate();
            begin
                if Relative.GET("Relative Code") then
                    if (Relative.Type <> Relative.Type::Child) and ("Eligible Child") then
                        ERROR('The Relative is not a Child');
            end;
        }
    }

    keys
    {
        key(Key1; "Applicant No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        HRCommentLine: Record "HR Comment Line EDM";
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
        Applicant: Record Applicant;
        Relative: Record Relative;

    procedure CheckApplicantEditing();
    begin
        Applicant.GET("Applicant No.");
        if (Applicant.Status = Applicant.Status::Hired) then
            ERROR('Hired Applicants Cannot be Edited !');
    end;
}