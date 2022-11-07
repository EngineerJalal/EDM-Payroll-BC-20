table 98050 "Tax Band"
{
    fields
    {
        field(1;"Tax Band";Integer)
        {
        }
        field(10;"Annual Bandwidth";Decimal)
        {
            DecimalPlaces = 2:2;

            trigger OnValidate();
            begin
                "Annual Tax" := ROUND("Annual Bandwidth" * Rate / 100,0.01);
            end;
        }
        field(11;Rate;Decimal)
        {
            DecimalPlaces = 2:2;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                VALIDATE("Annual Bandwidth");
            end;
        }
        field(12;"Annual Tax";Decimal)
        {
            DecimalPlaces = 2:2;
            Editable = false;
        }
        field(20;"Basic Rate";Boolean)
        {

            trigger OnValidate();
            begin
                if "Basic Rate" then begin
                    TaxBand.RESET;
                    TaxBand.SETFILTER("Tax Band",'<>%1',"Tax Band");
                    TaxBand.MODIFYALL("Basic Rate",false);
                end;
            end;
        }
        field(25;"Tax Discount %";Decimal)
        {
        }
        field(26;"Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Tax Band")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TaxBand : Record "Tax Band";
}