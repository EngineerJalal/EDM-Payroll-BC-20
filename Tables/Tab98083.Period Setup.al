table 98083 "Period Setup"
{
    // version PY1.0,EDM.HRPY2


    fields
    {
        field(1;"Table Name";Option)
        {
            OptionMembers = Pension;
        }
        field(2;Period;DateFormula)
        {
        }
        field(3;"From Unit";Integer)
        {
        }
        field(4;"To Unit";Integer)
        {
        }
        field(5;"Pension %";Decimal)
        {
        }
        field(6;"Pension Scheme No.";Code[10])
        {
            TableRelation = "Pension Scheme";
        }
    }

    keys
    {
        key(Key1;"Table Name","Pension Scheme No.","From Unit","To Unit")
        {
        }
    }

    fieldgroups
    {
    }
}

