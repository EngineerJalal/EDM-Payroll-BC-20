page 98068 "Payroll Element Posting"
{
    // version EDM.HRPY1

    PageType = List;
    Permissions = TableData "Payroll Element Posting"=rimd;
    SourceTable = "Payroll Element Posting";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payroll Posting Group";"Payroll Posting Group")
                {
                    ApplicationArea=All;
                }
                field("Pay Element";"Pay Element")
                {
                    ApplicationArea=All;
                }
                field("Posting Account";"Posting Account")
                {
                    ApplicationArea=All;
                }
                field("Pay Element Name";"Pay Element Name")
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

