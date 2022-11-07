table 98086 "Payroll Element Posting"
{
    // version EDM.HRPY1


    fields
    {
        field(1;"Payroll Posting Group";Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll Posting Group";
        }
        field(2;"Pay Element";Code[10])
        {
            NotBlank = true;
            TableRelation = "Pay Element".Code;
        }
        field(3;"Posting Account";Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(4;"Pay Element Name";Text[100])
        {
            CalcFormula = Lookup("Pay Element".Description WHERE (Code=FIELD("Pay Element")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Payroll Posting Group","Pay Element")
        {
        }
    }

    fieldgroups
    {
    }
}

