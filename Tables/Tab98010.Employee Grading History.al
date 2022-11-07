table 98010 "Employee Grading History"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Primery Key";Integer)
        {
        }
        field(2;"Employee No";Code[20])
        {
        }
        field(3;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD("Employee No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;Grade;Code[10])
        {
            TableRelation = "Grading Scale"."Grade Code" WHERE ("Employee Category"=FIELD("Grade Category"));
        }
        field(5;"Grade Category";Code[10])
        {
            TableRelation = "Employee Categories"."Code";
        }
        field(6;"Basic Pay";Decimal)
        {
        }
        field(7;HCL;Decimal)
        {
        }
        field(8;"Last Grading Date";Date)
        {
        }
        field(9;"Next grading Date";Date)
        {
        }
        field(10;"Created By";Code[50])
        {
        }
        field(11;"Created DateTime";DateTime)
        {
        }
        field(12;"Is Temp";Boolean)
        {
        }
        field(13;"Previous Grade";Code[10])
        {
        }
        field(14;"Previous Basic Pay";Decimal)
        {
        }
        field(15;"Previous HCL";Decimal)
        {
        }
        field(16;"Previous Last Grading Date";Date)
        {
        }
        field(17;"Previous Next Grading Date";Date)
        {
            CaptionClass = 'Expected Next Grading Date';
        }
        field(18;"Previous Grade Category";Code[10])
        {
        }
        field(19;"Job Title";Code[30])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(20;"Job Category";Code[20])
        {
            CalcFormula = Lookup(Employee."Job Category" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(21;"Job Position code";Code[50])
        {
            CalcFormula = Lookup(Employee."Job Position Code" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(22;"Global Dimension 1";Code[20])
        {
            CalcFormula = Lookup(Employee."Global Dimension 1 Code" WHERE ("No."=FIELD("Employee No")));
            CaptionClass = '1,1,1';
            FieldClass = FlowField;
        }
        field(23;"Global Dimension 2";Code[20])
        {
            CalcFormula = Lookup(Employee."Global Dimension 2 Code" WHERE ("No."=FIELD("Employee No")));
            CaptionClass = '1,1,2';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Primery Key")
        {
        }
    }

    fieldgroups
    {
    }
}

