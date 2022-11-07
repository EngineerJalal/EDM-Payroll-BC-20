table 98006 "Daily Shifts"
{

    LookupPageID = "Daily Shift";

    fields
    {
        field(1;"Shift Code";Code[10])
        {
        }
        field(2;"From Time";Time)
        {
        }
        field(3;"To Time";Time)
        {
        }
        field(4;"Break";Time)
        {
        }
        field(5;"Cause Code";Code[20])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(6;Tolerance;Decimal)
        {
            CaptionClass = 'Absence Tolerance';
        }
        field(7;Type;Option)
        {
            OptionCaption = 'Unpaid Vacation,Paid Vacation,Sick Day,No Duty,Signal Absence,Holiday,Working Day,Working Holiday,Subtraction,Work Accident,Paid Day,AL';
            OptionMembers = "Unpaid Vacation","Paid Vacation","Sick Day","No Duty","Signal Absence",Holiday,"Working Day","Working Holiday",Subtraction,"Work Accident","Paid Day",AL;
        }
        field(8;"Allowed Break Minute";Decimal)
        {
        }
        field(9;"Overtime Rate";Decimal)
        {
        }
        field(10;"Absence Deduction Rate";Decimal)
        {
        }
        field(11;"Unpaid Overtime Hrs";Decimal)
        {
        }
        field(12;"Force Lunch Break";Boolean)
        {
        }
        field(13;"Lunch Break Start time";Time)
        {
        }
        field(14;"Lunch Break Tolerance";Decimal)
        {
            CaptionClass = 'Lunch Break Tolerance (MIN)';
        }
    }

    keys
    {
        key(Key1;"Shift Code")
        {
        }
    }
    fieldgroups
    {
    }
}