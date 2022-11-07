table 98017 "Employment History"
{
    DataCaptionFields = "No.";

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
            TableRelation = IF ("Table Name"=CONST("Applicant")) Applicant."No." ELSE IF ("Table Name"=CONST("Employee")) Employee."No.";
        }
        field(3;"Employer Type";Option)
        {
            OptionMembers = Current," Previous";
        }
        field(4;Company;Text[30])
        {
            NotBlank = false;
        }
        field(5;Contact;Text[30])
        {
        }
        field(6;Position;Text[30])
        {
        }
        field(7;"From Date";Date)
        {
            NotBlank = false;
        }
        field(8;"To Date";Date)
        {
        }
        field(9;"Last Salary";Decimal)
        {
        }
        field(10;"Reason for Leaving";Text[30])
        {
        }
        field(11;"Line No.";Integer)
        {
        }
        field(12;"Phone No.";Text[30])
        {
        }
        field(13;Validated;Boolean)
        {
        }
        field(14;References;Text[100])
        {
        }
        field(15;"Table Name";Option)
        {
            OptionMembers = Applicant,Employee;
        }
        field(16;"In Our Own Company";Boolean)
        {
        }
        field(17;"Job Title";Text[50])
        {
            Caption = 'Job Title';
            Description = 'SHR2.0';
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Job Title"));
        }
        field(18;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'SHR2.0';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(19;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Description = 'SHR2.0';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(20;"Stategy Business Unit";Code[50])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("SBU"));
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