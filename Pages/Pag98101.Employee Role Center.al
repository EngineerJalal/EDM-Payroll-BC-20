page 98101 "Employee Role Center"
{
    // version EDM.HRPY2

    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control7)
            {
                systempart(Control5;MyNotes)
                {
                    ApplicationArea=All;
                }
                /*systempart(Control4;Outlook)
                {
                }*/
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Employee Card")
            {
                Image = Employee;
                RunObject = Page "Employee View Card";
                ApplicationArea=All;
            }
        }
    }
}

