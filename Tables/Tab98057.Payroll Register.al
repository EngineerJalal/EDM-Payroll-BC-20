table 98057 "Payroll Register"
{
    // version PY1.0,EDM.HRPY1


    fields
    {
        field(1;"No.";Integer)
        {
        }
        field(2;"From Entry No.";Integer)
        {
            TableRelation = "Payroll Ledger Entry";
        }
        field(3;"To Entry No.";Integer)
        {
            TableRelation = "Payroll Ledger Entry";
        }
        field(4;"Creation Date";Date)
        {
        }
        field(5;"Source Code";Code[10])
        {
            TableRelation = "Source Code";
        }
        field(6;"User ID";Code[30])
        {
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(10;"Payroll Group Code";Code[10])
        {
            TableRelation = "HR Payroll Group"."Code";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;"Creation Date")
        {
        }
        key(Key3;"Source Code","Creation Date")
        {
        }
    }

    fieldgroups
    {
    }
}

