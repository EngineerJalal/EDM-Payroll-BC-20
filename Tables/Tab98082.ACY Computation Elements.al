table 98082 "ACY Computation Elements"
{
    fields
    {
        field(1;"Element Code";Option)
        {
            NotBlank = true;
            OptionMembers = " ","Working Days","Attendance Days","Converted Salary","Income Tax",Overtime,Public;
        }
    }

    keys
    {
        key(Key1;"Element Code")
        {
        }
    }

    fieldgroups
    {
    }
}