tableextension 98013 ExtDimension extends Dimension
{
    fields
    {
        field(90000; "Dimension No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Dimension Value"."Global Dimension No." WHERE("Dimension Code" = FIELD(Code)));
        }
    }
}
