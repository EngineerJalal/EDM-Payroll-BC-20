table 98076 "Check List"
{
    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement=True;
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation=Employee;
        }
        field(3;Type;Option)
        {
            OptionCaption = 'New Hire,IT';
            OptionMembers = "New Hire",IT;
        }
        field(4;"Check List Code";Code[20])
        {
            TableRelation = "Checklist Items".Code where (Type = field(Type),"Is Active" = const(true));
        }
        field(5;"Check List Description";text[250])
        {
        }
        field(6;"Responsible Person";text[250])
        {
        }
        field(7;"From Date";Date)
        {
        }
        field(8;"Till Date";Date)
        {
        }
        field(9;Applicable;Boolean)
        {
        }
        field(10;Done;Boolean)
        {
        }
        field(11;Remarks;text[250])
        {
        }                                        
    }
        
}