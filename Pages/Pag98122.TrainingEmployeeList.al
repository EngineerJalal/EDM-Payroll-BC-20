page 98122 "Training Employee List"
{
    // version EDM.HRPY2

    PageType = ListPart;
    SourceTable = "Training Employee List";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea=All;
                }
                field("Employee First Name";"Employee First Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Employee Last Name";"Employee Last Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Employee Job Title";"Employee Job Title")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Employee Job Position";"Employee Job Position")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

