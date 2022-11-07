table 98068 "Scheduling System"
{
    // version EDM.HRPY2

    DrillDownPageID = "Scheduling System List";
    LookupPageID = "Scheduling System List";

    fields
    {
        field(1;"Document No";Code[20])
        {
        }
        field(2;"Employee No";Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(3;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(4;Description;Text[100])
        {
        }
        field(5;"Academic Year";Integer)
        {
        }
        field(6;"Is Inactive";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Document No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        SchedSystLine.SETRANGE("Document No","Document No");
        if SchedSystLine.FINDFIRST then
          SchedSystLine.DELETEALL(true);
    end;

    var
        SchedSystLine : Record "Scheduling System Line";
}

