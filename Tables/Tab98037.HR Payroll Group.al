table 98037 "HR Payroll Group"
{

    DrillDownPageID = "HR Payroll Group List";
    LookupPageID = "HR Payroll Group List";

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Employees Assigned";Integer)
        {
            CalcFormula = Count(Employee WHERE ("Payroll Group Code"=FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Users Assigned";Integer)
        {
            CalcFormula = Count("HR Payroll User" WHERE ("Payroll Group Code"=FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"PaySlip Report No.";Integer)
        {
        }
        field(6;"Report Name";Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE ("Object Type"=CONST(Report),
                                                                        "Object ID"=FIELD("PaySlip Report No.")));
            FieldClass = FlowField;
        }
        field(7;"Report Title Name";Text[50])
        {
        }
        field(1000;"Is Project Group";Boolean)
        {
        }
        field(50000;"R5 Groups";Option)
        {
            OptionCaption = 'Employee,Administration';
            OptionMembers = Employee,Administration;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Employees Assigned" > 1 then
          ERROR('You cannot delete Payroll Group ''%1'' : Existence of %2 Employee(s) in this Group.',Code,"Employees Assigned");
        PayrollUser.RESET;
        PayrollUser.SETRANGE("Payroll Group Code",Code);
        PayrollUser.DELETEALL;
    end;

    var
        PayrollUser : Record "HR Payroll User";
}