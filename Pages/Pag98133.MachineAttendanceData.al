page 98133 "Machine Attendance Data"
{
    PageType = List;
    SourceTable = "Machine Attendance Data";
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
               field("Attendance No";"User ID")
               {                   ApplicationArea=All;
}
               field("Employee Name";"User Name")
               {                   ApplicationArea=All;
}
               field("Punch Date";"Punch Date")
               {                   ApplicationArea=All;
}
               field("Punch Time";"Punch Time")
               {                   ApplicationArea=All;
}
                field("Punch Type";"Punch Type")
               {                    ApplicationArea=All;
}
            }
        }
    }
}