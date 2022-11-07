table 98096 "Allowance Deduction Temp Catg"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Category Code";Code[20])
        {
            TableRelation = "Employee Categories"."Code";
        }
        field(2;"Category Name";Text[30])
        {
            CalcFormula = Lookup("Employee Categories".Description WHERE (Code=FIELD("Category Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Document No.";Code[20])
        {
            TableRelation = "Allowance Deduction Template"."Code";
        }
    }

    keys
    {
        key(Key1;"Document No.","Category Code")
        {
        }
    }

    fieldgroups
    {
    }
}

