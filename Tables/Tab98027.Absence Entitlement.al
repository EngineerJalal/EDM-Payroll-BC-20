table 98027 "Absence Entitlement"
{

    fields
    {
        field(1;"Cause of Absence Code";Code[10])
        {
            NotBlank = true;
            TableRelation = "Cause of Absence";
        }
        field(2;"From Unit";Integer)
        {
        }
        field(3;"To Unit";Integer)
        {
            trigger OnValidate();
            begin
                if "To Unit" < 0 then
                  ERROR ('Value Cannot be Negative');
                if "To Unit" < "From Unit" then
                  ERROR ('"To Unit" must be greater than "From Unit"');
            end;
        }
        field(4;Entitlement;Decimal)
        {
        }
        field(5;Type;Option)
        {
            OptionMembers = Cumulative,"Non-Cumulative";
        }
        field(6;Period;DateFormula)
        {
        }
        field(80;"Allowed Days To Transfer";Decimal)
        {
        }
        field(81;"Employee Category";Code[10])
        {
            TableRelation = "Employee Categories"."Code";
        }
        field(82;"Calculation Type";Option)
        {
            OptionMembers = "Fixed",Rate;
        }
        field(83;"Balance Cummulative Years";Decimal)
        {
        }
        field(84;"First Year Entitlement";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Cause of Absence Code","From Unit","Employee Category")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if Type = Type::Cumulative then
          TESTFIELD(Period);
        TESTFIELD("To Unit");
    end;
}