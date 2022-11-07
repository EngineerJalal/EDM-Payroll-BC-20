table 98041 "Computer Skills"
{
    fields
    {
        field(1;"Skills Code";Code[20])
        {
        }
        field(2;"Skills Type";Option)
        {
            OptionCaption = 'Computer';
            OptionMembers = Computer;
        }
        field(3;"Skills Description";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Skills Code")
        {
        }
    }

    fieldgroups
    {
    }
}