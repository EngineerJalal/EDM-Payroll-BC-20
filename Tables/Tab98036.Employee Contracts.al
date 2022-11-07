table 98036 "Employee Contracts"
{

    DrillDownPageID = "Employee Contracts";
    LookupPageID = "Employee Contracts";

    fields
    {
        field(1;"Employee No.";Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(2;"Employment Contract Code";Code[10])
        {
            NotBlank = true;
            TableRelation = "Employment Contract";
        }
        field(3;"Valid From";Date)
        {
            NotBlank = true;
        }
        field(4;"Valid To";Date)
        {
            NotBlank = true;

            trigger OnValidate();
            begin
                if "Valid To" < "Valid From" then
                  ERROR('Valid To must be greater than Valid From');
            end;
        }
        field(5;Amount;Decimal)
        {
        }
        field(6;"Termination Date";Date)
        {
        }
        field(7;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Employee No.","Employment Contract Code")
        {
        }
    }

    fieldgroups
    {
    }
}