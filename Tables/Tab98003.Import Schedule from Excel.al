table 98003 "Import Schedule from Excel"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                EmployeeRec: Record "Employee";
            begin
                EmployeeRec.GET("Employee No.");
                "Employee Name" := EmployeeRec."Full Name";
            end;
        }
        field(2; "Employee Name"; Text[150])
        {
            Editable = false;
        }
        field(3; "Day 1"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(4; "Day 2"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(5; "Day 3"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(6; "Day 4"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(7; "Day 5"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(8; "Day 6"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(9; "Day 7"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(10; "Day 8"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(11; "Day 9"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(12; "Day 10"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(13; "Day 11"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(14; "Day 12"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(15; "Day 13"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(16; "Day 14"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(17; "Day 15"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(18; "Day 16"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(19; "Day 17"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(20; "Day 18"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(21; "Day 19"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(22; "Day 20"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(23; "Day 21"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(24; "Day 22"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(25; "Day 23"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(26; "Day 24"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(27; "Day 25"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(28; "Day 26"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(29; "Day 27"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(30; "Day 28"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(31; "Day 29"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(32; "Day 30"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(33; "Day 31"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
    }


    keys
    {
        key(Key1; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin
    end;

    var
        PayrollStatus: Record "Payroll Status";
}