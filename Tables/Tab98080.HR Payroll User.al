table 98080 "HR Payroll User"
{

    DrillDownPageID = "HR Payroll User";
    LookupPageID = "HR Payroll User";

    fields
    {
        field(1; "Payroll Group Code"; Code[10])
        {
            NotBlank = true;
            TableRelation = "HR Payroll Group".Code;
        }
        field(2; "User Type"; Option)
        {
            Editable = false;
            InitValue = "Windows Login";
            OptionMembers = "Database Logins","Windows Login";
        }
        field(5; "User Id"; Code[50])
        {
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            /*
                        trigger OnLookup();
                        begin
                            //UserMgt.LookupUserID("User ID");
                            UserMgt.DisplayUserInformation("User ID");
                        end;

                        trigger OnValidate();
                        begin
                            //UserMgt.LookupUserID("User ID");
                            UserMgt.DisplayUserInformation("User ID");
                            CALCFIELDS(Name);
                        end;*/
        }
        field(10; Name; Text[80])
        {
            CalcFormula = Lookup (User."Full Name" WHERE("User Name" = FIELD("User Id")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Hide Salary"; Boolean)
        {
        }
        field(12; "Disable Delete Emp Rec"; Boolean)
        {
            CaptionClass = 'Disable Employee Deletion';
            Description = 'Added in order to disable or enable delete Employee record';
        }
    }

    keys
    {
        key(Key1; "Payroll Group Code", "User Id")
        {
        }
    }

    fieldgroups
    {
    }

    var
        UserMgt: Codeunit "User Management";
}