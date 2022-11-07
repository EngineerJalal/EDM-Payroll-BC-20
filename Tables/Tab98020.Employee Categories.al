table 98020 "Employee Categories"
{
    DrillDownPageID = "Employee Category List";
    LookupPageID = "Employee Category List";

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Update All Absences";Boolean)
        {
        }
        field(4;"Total Employees";Integer)
        {
            CalcFormula = Count(Employee WHERE ("Employee Category Code"=FIELD(Code)));
            FieldClass = FlowField;
        }
        field(5;"Employee Code";Code[20])
        {
        }
        field(6;"Employee Type";Option)
        {
            OptionMembers = Employee,Supervisor,OperationManager,HR;
        }
        field(7;"Use Grading System";Boolean)
        {
        }
        field(8;"Additional Description";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
        key(Key2;Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Total Employees" <> 0 then
          ERROR ('Cannot Delete Record : Some Employees are Assigned to this Level !');
    end;

    trigger OnInsert();
    begin
        "Update All Absences":= true;
    end;
}