table 98071 "HR System Code"
{
    // version SHR1.0,PY1.0,EDM.HRPY1

    DrillDownPageID = "HR System Code";
    LookupPageID = "HR System Code";

    fields
    {
        field(1;"Code";Code[30])
        {
            Editable = true;
            NotBlank = true;
        }
        field(4;System;Boolean)
        {
            Editable = true;
        }
        field(5;"Affects Payroll";Boolean)
        {
            Editable = true;
        }
        field(6;Category;Option)
        {
            Editable = true;
            OptionMembers = " ","Function";
        }
        field(7;Split;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

