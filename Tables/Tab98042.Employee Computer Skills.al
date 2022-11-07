table 98042 "Employee Computer Skills"
{
    fields
    {
        field(1;"Employee No.";Code[20])
        {
            TableRelation = Employee."No." WHERE ("No."=FIELD("Employee No."));
        }
        field(2;"Computer Skills Code";Code[20])
        {
            TableRelation = "Computer Skills"."Skills Code" WHERE ("Skills Code"=FIELD("Computer Skills Code"));
        }
        field(3;"Skills Level";Option)
        {
            OptionCaption = '1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "1","2","3","4","5","6","7","8","9","10";
        }
        field(4;"To Be Accomplished";Boolean)
        {
        }
        field(5;"Expected Accomplishment Date";Date)
        {
        }
        field(6;Accomplished;Boolean)
        {
        }
        field(7;"Accomplishment Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Computer Skills Code")
        {
        }
    }

    fieldgroups
    {
    }
}