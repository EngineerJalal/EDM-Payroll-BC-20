table 98079 "Employee Work Accidents"
{
    fields
    {
        field(1;"Employee No.";Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2;Date;Date)
        {
            NotBlank = true;
        }
        field(3;"Accident Code";Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Work Accident"));
        }
        field(4;"Injured Part Code";Code[50])
        {
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Injured Part"));
        }
        field(5;Reason;Text[80])
        {
        }
        field(6;"Hospital Name";Text[30])
        {
        }
        field(7;"Rest Period";DateFormula)
        {
        }
        field(8;"Declaration No.";Text[30])
        {
        }
        field(9;Severity;Option)
        {
            OptionMembers = Minor,Major;
        }
        field(10;Remark;Text[80])
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.",Date,"Accident Code")
        {
        }
    }

    fieldgroups
    {
    }
}