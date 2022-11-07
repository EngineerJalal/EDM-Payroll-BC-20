table 98022 "HR Transaction Types"
{
    DrillDownPageID = "HR Transaction Types List";
    LookupPageID = "HR Transaction Types List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; Type; Code[30])
        {
        }
        field(4; System; Boolean)
        {
        }
        field(5; "Insurance Type"; Boolean)
        {
            Editable = false;
        }
        field(10; "Associated Pay Element"; Code[20])
        {
            TableRelation = "Pay Element".Code WHERE("Payroll Special Code" = CONST(true));
        }
        field(11; "Calculation Type"; Option)
        {
            BlankZero = true;
            OptionMembers = ,"Fixed Amount",Days,Automatic;
        }
        field(12; Recurring; Boolean)
        {
        }
        field(13; "Payroll Group Code"; Code[100])
        {
            Description = 'Added for Employee Journals Matrix';
        }
        field(14; "Employee Category"; Code[100])
        {
            Description = 'Added for Employee Journals Matrix';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SysCode: Record "HR System Code";
}