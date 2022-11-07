page 98035 "HR Transaction Types List"
{
    // version SHR1.0,EDM.HRPY1

    Editable = false;
    PageType = List;
    SourceTable = "HR Transaction Types";

    layout
    {
        area(content)
        {
            repeater(Control1)
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

