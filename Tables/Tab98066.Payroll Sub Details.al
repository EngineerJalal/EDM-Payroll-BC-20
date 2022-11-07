table 98066 "Payroll Sub Details"
{
    // version EDM.HRPY2


    fields
    {
        field(1;ID;Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Ref Code";Code[20])
        {
        }
        field(3;"Employee No.";Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(4;"Pay Element Code";Code[20])
        {
            TableRelation = "Pay Element"."Code" WHERE ("Payroll Special Code"=FILTER(true));
        }
        field(5;"Is ACY";Boolean)
        {
        }
        field(6;Amount;Decimal)
        {

            trigger OnValidate();
            begin
                "Amount (LCY)" := Amount;
            end;
        }
        field(7;"Amount (LCY)";Decimal)
        {

            trigger OnValidate();
            begin
                "Amount (ACY)" := PayrollFunction.ExchangeLCYAmountToACY("Amount (LCY)");
            end;
        }
        field(8;"Amount (ACY)";Decimal)
        {

            trigger OnValidate();
            begin
                "Amount (LCY)" := PayrollFunction.ExchangeACYAmountToLCY("Amount (ACY)");
            end;
        }
        field(9;"Created By";Code[50])
        {
        }
        field(10;"Created DateTime";DateTime)
        {
        }
        field(11;"Modified By";Code[50])
        {
        }
        field(12;"Modified DateTime";DateTime)
        {
        }
        field(13;"Pay Element Description";Text[30])
        {
            CalcFormula = Lookup("Pay Element".Description WHERE (Code=FIELD("Pay Element Code")));
            FieldClass = FlowField;
        }
        field(14;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;ID,"Ref Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if Rec."Ref Code" = '' then
          ERROR('Please fill Ref Code');
    end;

    var
        PayrollFunction : Codeunit "Payroll Functions";
}

