tableextension 98001 "ExtGLEntry" extends "G/L Entry" 
{
    fields
    {
        field(96022;"Exclude from Employee Stmt";Boolean)
        {
            CalcFormula = Lookup("G/L Account"."Exclude from Employee Stmt" WHERE ("No."=FIELD("G/L Account No.")));
            Description = 'EDM Employee Statement Account';
            FieldClass = FlowField;
        }
    }
}

