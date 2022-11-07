table 98092 "Eligible Countries"
{
    // version PY1.0,EDM.HRPY2


    fields
    {
        field(1;"Pay Element Code";Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(2;"Country Code";Code[10])
        {
            NotBlank = true;
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1;"Pay Element Code","Country Code")
        {
        }
    }

    fieldgroups
    {
    }
}

