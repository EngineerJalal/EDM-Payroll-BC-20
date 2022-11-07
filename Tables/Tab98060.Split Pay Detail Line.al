table 98060 "Split Pay Detail Line"
{
    // version PY1.0,EDM.HRPY2

    //DrillDownPageID = 80225;
    //LookupPageID = 80225;

    fields
    {
        field(1;"Pay Detail Line No.";Integer)
        {
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(5;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(6;"Job Title";Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST("Job Title"));
        }
        field(7;Amount;Decimal)
        {
        }
        field(8;"Calculated Amount";Decimal)
        {
        }
        field(9;"Amount (ACY)";Decimal)
        {
        }
        field(10;"Calculated Amount (ACY)";Decimal)
        {
        }
        field(13;"Efective Nb. of Days";Decimal)
        {
        }
        field(14;"Starting Split Date";Date)
        {
        }
        field(15;"Transaction Type";Code[30])
        {
            Editable = true;
            TableRelation = "HR Transaction Types"."Code" WHERE (System=CONST(true));
        }
        field(31;"Old Transaction Type Value";Text[50])
        {
        }
        field(32;"New Transaction Type Value";Text[50])
        {
        }
        field(33;"Ending Split Date";Date)
        {
        }
        field(34;"Transaction Date";Date)
        {
        }
        field(35;"Employee Status";Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(36;Open;Boolean)
        {
            InitValue = true;
        }
        field(37;"Posting Date";Date)
        {
        }
        field(38;"Employment Date";Date)
        {
        }
        field(39;Employed;Boolean)
        {
        }
        field(40;Declared;Boolean)
        {
        }
        field(41;Terminated;Boolean)
        {
        }
        field(42;Inactivated;Boolean)
        {
        }
        field(43;ReActivated;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Pay Detail Line No.","Transaction Date","Line No.")
        {
        }
        key(Key2;"Transaction Date",Employed)
        {
        }
    }

    fieldgroups
    {
    }
}

