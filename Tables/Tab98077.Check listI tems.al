table 98077 "Checklist Items"
{
    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement=True;
        }
        field(2;Type;Option)
        {
            OptionCaption = 'New Hire,IT';
            OptionMembers = "New Hire",IT;
        }
        field(3;"Code";Code[20])
        {
        }
        field(4;"Job Title";Code[50])
        {
            TableRelation = "HR Information".Code where ("Table Name" = CONST ("Job Title")); 
        }
        field(5;Description;text[250])
        {
        }
        field(6;Remark;text[250])
        {
        }
        field(7;"Is Active";Boolean)
        {
        }
    }
    keys
    {
        key(Key1;"Line No.",Code)
        {
        }
    }
}