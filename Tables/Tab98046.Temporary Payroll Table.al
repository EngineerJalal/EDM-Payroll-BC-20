table 98046 "Temporary Payroll Table"
{
    fields
    {
        field(1;"Program Code";Code[20])
        {
        }
        field(2;"User ID";Code[20])
        {
            TableRelation = User;
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Employee No.";Code[20])
        {
        }
        field(5;Description;Text[30])
        {
        }
        field(6;Type;Option)
        {
            OptionMembers = Addition,Deduction;
        }
        field(7;Amount;Decimal)
        {
        }
        field(8;"Amount (ACY)";Decimal)
        {
        }
        field(9;"General Code";Code[50])
        {
            TableRelation = "Cause of Absence";
        }
        field(10;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(11;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(12;"Extra Amount";Decimal)
        {
        }
        field(13;"Extra Amount (ACY)";Decimal)
        {
        }
        field(14;"Total Work Days";Integer)
        {
        }
        field(15;"Pay Element";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Program Code","User ID","Line No.",Type,"Employee No.","General Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }
}