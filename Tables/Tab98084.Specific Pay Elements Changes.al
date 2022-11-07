table 98084 "Specific Pay Elements Changes"
{
    // version PY1.0,EDM.HRPY2


    fields
    {
        field(1;"Pay Element Code";Code[20])
        {
            Description = 'PY3.0';
            NotBlank = true;
        }
        field(2;"Internal Pay Element ID";Code[10])
        {
            Description = 'PY3.0';
            TableRelation = "Pay Element";
        }
        field(3;"Employee Category Code";Code[10])
        {
            Description = 'PY3.0';
            TableRelation = "Employee Categories";
        }
        field(4;Amount;Decimal)
        {
            Description = 'PY3.0';
        }
        field(5;"Wife Entitlement";Decimal)
        {
            Description = 'PY3.0';
        }
        field(6;"Per Children Entitlement";Decimal)
        {
            Description = 'PY3.0';
        }
        field(7;"Line No.";Integer)
        {
            Description = 'PY3.0';
        }
        field(8;"Amount (ACY)";Decimal)
        {
            Description = 'PY3.0';
        }
        field(9;"Maturity Period";DateFormula)
        {
            Description = 'PY3.0';
        }
        field(10;"Affected By Presence";Boolean)
        {
            Description = 'PY3.0';
        }
        field(11;"Pay Unit";Option)
        {
            Description = 'PY3.0';
            OptionMembers = Monthly,Daily;
        }
        field(12;Splited;Boolean)
        {
            Description = 'PY3.0';
        }
        field(13;"Date Applicable From";Date)
        {
            Description = 'PY3.0';
        }
        field(14;"Date Applicable To";Date)
        {
            Description = 'PY3.0';
        }
        field(15;"Changed Field";Option)
        {
            OptionMembers = Amount,"Amount(ACY)",Both;
        }
    }

    keys
    {
        key(Key1;"Pay Element Code","Internal Pay Element ID","Line No.","Date Applicable To")
        {
        }
    }

    fieldgroups
    {
    }
}

