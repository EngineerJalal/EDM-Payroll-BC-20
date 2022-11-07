table 98067 "Grading Scale"
{
    // version EDM.PYPS1,EDM.HRPY2


    fields
    {
        field(1;"Employee Category";Code[10])
        {
            TableRelation = "Employee Categories"."Code";
        }
        field(2;"Grade Code";Code[10])
        {

            trigger OnValidate();
            begin
                "Grade Effective Date" := DMY2DATE(1,1,1900);
                "Grade Description" := "Grade Code";
            end;
        }
        field(3;"Grade Effective Date";Date)
        {
        }
        field(4;"Grade Amount";Decimal)
        {
            Editable = false;
        }
        field(5;"Grade Basic Salary";Decimal)
        {

            trigger OnValidate();
            begin
                "Grade Amount" := "Grade Basic Salary" + "Grade Cost of Living";
            end;
        }
        field(6;"Grade Cost of Living";Decimal)
        {

            trigger OnValidate();
            begin
                "Grade Amount" := "Grade Basic Salary" + "Grade Cost of Living";
            end;
        }
        field(7;"Employee Category Name";Text[50])
        {
            CalcFormula = Lookup("Employee Categories".Description WHERE (Code=FIELD("Employee Category")));
            FieldClass = FlowField;
        }
        field(8;"Grade Description";Text[250])
        {
        }
        field(9;"Grade Sequence";Integer)
        {
        }
        field(10;"Grade Update Interval";Decimal)
        {
        }
        field(11;"Grade Interval Type";DateFormula)
        {
        }
        field(12;"Is Inactive";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Employee Category","Grade Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Employee Category","Grade Code","Grade Amount")
        {
        }
    }
}

