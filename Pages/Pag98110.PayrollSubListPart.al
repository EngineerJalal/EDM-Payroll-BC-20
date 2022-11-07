page 98110 "Payroll Sub ListPart"
{
    // version EDM.HRPY2

    PageType = ListPart;
    SourceTable = "Payroll Sub Details";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea=All;
                }
                field("Pay Element Code";"Pay Element Code")
                {
                    ApplicationArea=All;
                }
                field("Pay Element Description";"Pay Element Description")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field(Amount;Amount)
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

