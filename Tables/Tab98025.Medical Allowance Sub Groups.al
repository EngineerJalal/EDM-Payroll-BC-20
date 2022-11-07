table 98025 "Medical Allowance Sub Groups"
{
    fields
    {
        field(1;"Medical Allowance Group";Code[10])
        {
            NotBlank = true;
        }
        field(2;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(3;Description;Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Medical Allowance Group","Code")
        {
        }
    }

    fieldgroups
    {
    }
}