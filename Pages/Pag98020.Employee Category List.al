page 98020 "Employee Category List"
{
    // version SHR1.0,EDM.HRPY1

    Editable = false;
    PageType = List;
    SourceTable = "Employee Categories";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

