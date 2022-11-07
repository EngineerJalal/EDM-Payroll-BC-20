table 98090 "Allowance Deduction Template"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Name;Text[30])
        {
        }
        field(3;Description;Text[50])
        {
        }
        field(4;"Valid From";Date)
        {
        }
        field(5;"Till Date";Date)
        {
        }
        field(6;Inactive;Boolean)
        {
        }
        field(7;"Applied by";Option)
        {
            CaptionClass = 'Affected By';
            OptionCaption = 'Child,Wife,Other';
            OptionMembers = Child,Wife,Other;
        }
        field(8;"Declare Type";Option)
        {
            OptionCaption = 'All,Eligible Only';
            OptionMembers = All,"Eligible Only";
        }
        field(9;"Maximum Children";Integer)
        {
        }
        field(10;"Affected By Attendance";Boolean)
        {
        }
        field(11;"Auto Generate";Boolean)
        {
        }
        field(12;"Average Days/Month";Decimal)
        {
        }
        field(13;"Apply to Period Day";Integer)
        {

            trigger OnValidate();
            begin

                if "Apply to Period Day" > 31 then
                  ERROR('Apply to Period Day must be less then 31');
            end;
        }
        field(14;JAN;Decimal)
        {
            InitValue = 100;
        }
        field(15;FEB;Decimal)
        {
            InitValue = 100;
        }
        field(16;MAR;Decimal)
        {
            InitValue = 100;
        }
        field(17;APR;Decimal)
        {
            InitValue = 100;
        }
        field(18;MAY;Decimal)
        {
            InitValue = 100;
        }
        field(19;JUN;Decimal)
        {
            InitValue = 100;
        }
        field(20;JUL;Decimal)
        {
            InitValue = 100;
        }
        field(21;AUG;Decimal)
        {
            InitValue = 100;
        }
        field(22;SEP;Decimal)
        {
            InitValue = 100;
        }
        field(23;OCT;Decimal)
        {
            InitValue = 100;
        }
        field(24;NOV;Decimal)
        {
            InitValue = 100;
        }
        field(25;DEC;Decimal)
        {
            InitValue = 100;
        }
        field(26;"Apply to Period Month";Integer)
        {

            trigger OnValidate();
            begin

                if "Apply to Period Month" > 12 then
                  ERROR('Apply to Period Month must be less then 12');
            end;
        }
        field(27;IsSchoolAllowance;Boolean)
        {
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

    trigger OnInsert();
    begin
        // 29.05.2017 : A2+
        //"Applied by" := "Applied by"::Other;
        // 29.05.2017 : A2-
    end;
}

