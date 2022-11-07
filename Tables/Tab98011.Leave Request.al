table 98011 "Leave Request"
{
    fields
    {
        field(1;"Leave Request No.";Code[20])
        {
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(3;"Requested By";Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(4;"Alternative Employee No.";Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(5;"Demand Date";Date)
        {
        }
        field(6;"From Date";Date)
        {
        }
        field(7;"From Time";Time)
        {
        }
        field(8;"To Date";Date)
        {
        }
        field(9;"To Time";Time)
        {
        }
        field(10;"Leave Type";Code[10])
        {
            TableRelation = "Cause of Absence".Code;
            trigger OnValidate();
            begin
                //Added to fix 'Day Value' if the leave request is not from Portal - 24.07.2018 : AIM +
                "Days Value" := 0;
                "Hours Value" := 0;

                IF (STRPOS (UPPERCASE ("Leave Type") ,UPPERCASE('0.25')) > 0) THEN
                    "Days Value" := 0.25
                ELSE IF (STRPOS (UPPERCASE ("Leave Type") ,UPPERCASE('0.5')) > 0) THEN
                    "Days Value" := 0.5
                ELSE IF (STRPOS (UPPERCASE ("Leave Type") ,UPPERCASE('0.75')) > 0) THEN
                    "Days Value" := 0.75;
                //Added to fix 'Day Value' if the leave request is not from Portal - 24.07.2018 : AIM -
            END;
        }
        field(11;Reason;Text[250])
        {
        }
        field(12;Remark;Text[250])
        {
        }
        field(13;Status;Option)
        {
            OptionMembers = Open,Generated,Canceled,"Semi-Generated";
        }
        field(14;"Days Value";Decimal)
        {
        }
        field(15;"Hours Value";Decimal)
        {
        }
        field(16;"Leave Request Seq";Integer)
        {
            AutoIncrement = true;
        }
        field(17;"Request Type";Option)
        {
            OptionCaption = 'Leave,Overtime,EarlyLeave,EarlyArrive,LateArrive';
            OptionMembers = Leave,Overtime,EarlyLeave,EarlyArrive,LateArrive;
        }
    }

    keys
    {
        key(Key1;"Leave Request Seq")
        {
        }
        key(Key2;"Leave Request No.")
        {
        }
        key(Key3;"Request Type","Employee No.","Leave Request No.")
        {
        }
        key(Key4;"Employee No.","Demand Date")
        {
        }
        key(Key5;"From Date")
        {
        }
        key(Key6;"To Date")
        {
        }
    }
    fieldgroups
    {
    }
}