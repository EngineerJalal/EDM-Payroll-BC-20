table 98035 "Base Calendar Additions"
{

    fields
    {
        field(1;"Base Calendar Code";Code[10])
        {
            Caption = 'Base Calendar Code';
            Editable = false;
            TableRelation = "Base Calendar";
        }
        field(2;"Recurring System";Option)
        {
            Caption = 'Recurring System';
            Editable = false;
            OptionCaption = '" ,Annual Recurring,Weekly Recurring"';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";
        }
        field(3;Date;Date)
        {
            Editable = false;
        }
        field(4;Day;Option)
        {
            Editable = false;
            OptionCaption = '" ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday"';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(5;"Working Shift Code";Code[10])
        {
            Editable = false;
            TableRelation = "Employment Type Schedule"."Working Shift Code" WHERE ("Table Name"=CONST(WorkShiftSched));
        }
        field(7;"Additions Type";Option)
        {
            OptionCaption = '" ,Attendance"';
            OptionMembers = " ",Attendance;
        }
        field(8;Description;Text[100])
        {
        }
        field(9;"Additions Value";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Base Calendar Code","Recurring System",Date,Day,"Working Shift Code","Additions Type")
        {
        }
    }

    fieldgroups
    {
    }
}