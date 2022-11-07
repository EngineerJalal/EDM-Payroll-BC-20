table 98038 "Training Employee List"
{

    fields
    {
        field(1; "Training No."; Code[10])
        {
            TableRelation = Training."Performance Code" WHERE("Table Name" = CONST(Training));
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(3; "Employee First Name"; Text[30])
        {
            CalcFormula = Lookup (Employee."First Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(4; "Employee Last Name"; Text[30])
        {
            CalcFormula = Lookup (Employee."Last Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(5; "Employee Job Title"; Text[50])
        {
            CalcFormula = Lookup (Employee."Job Title" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(6; "Employee Job Position"; Code[50])
        {
            CalcFormula = Lookup (Employee."Job Position Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(7; Cost; Decimal)
        {
        }
        field(8; "Training Evaluation"; Option)
        {
            OptionMembers = "Very Satisfied",Satisfied,"Average","Not Satisfied";
        }
        field(9; Attendance; Boolean)
        {
        }
        field(10; "Applicant No."; Code[20])
        {
            TableRelation = Applicant."No.";

            trigger OnValidate();
            begin
                Type := Type::Applicant;
            end;
        }
        field(11; "Applicant Name"; Text[100])
        {
            CalcFormula = Lookup (Applicant."Search Name" WHERE("No." = FIELD("Applicant No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; Type; Option)
        {
            Editable = false;
            OptionMembers = Employee,Applicant;
        }
        field(13; "Start Date"; Date)
        {
            CalcFormula = Lookup (Training."Start Date" WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "End Date"; Date)
        {
            CalcFormula = Lookup (Training."End Date" WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; Trainers; Text[100])
        {
            CalcFormula = Lookup (Training.Trainers WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Company Name"; Text[100])
        {
            CalcFormula = Lookup (Training."Company Name" WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; Objectives; Text[100])
        {
            CalcFormula = Lookup (Training.Objectives WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; Evaluation; Text[100])
        {
            CalcFormula = Lookup (Training.Evaluation WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Training Name"; Text[250])
        {
            CalcFormula = Lookup (Training."Training Name" WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "More Info"; Text[100])
        {
            CalcFormula = Lookup (Training."More Info" WHERE("No." = FIELD("Training No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Number of Trainings Done"; Integer)
        {
            CalcFormula = Count ("Training Employee List" WHERE("Employee No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Starting Date"; Date)
        {
        }
        field(24; "More Information"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Training No.", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }
}