table 98000 "Machine Attendance Data"
{
    DataPerCompany = false;
    fields
    {
        field(1;"User ID";Integer)
        {
        }
        field(2;"User Name";Text[100])
        {
        }
        field(3;"Punch Date Time";DateTime)
        {
        }
        field(4;"Punch Date";Date)
        {
        }
        field(5;"Punch Time";Time)
        {
        }
        field(6;"Punch Type";Code[10])
        {
        }
    }
    keys
    {
        key(Key1;"User ID","Punch Date Time")
        {
        }
    }
    fieldgroups
    {
    }
}