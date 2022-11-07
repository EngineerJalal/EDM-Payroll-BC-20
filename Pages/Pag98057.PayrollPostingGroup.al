page 98057 "Payroll Posting Group"
{
    // version PY1.0,EDM.HRPY1

    PageType = List;
    SourceTable = "Payroll Posting Group";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Cost of Payroll Account"; "Cost of Payroll Account")
                {
                    ApplicationArea = All;
                }
                field("Net Pay Account"; "Net Pay Account")
                {
                    ApplicationArea = All;
                }
                field("Rounding Account"; "Rounding Account")
                {
                    ApplicationArea = All;
                }
                field("Bank Pay Account"; "Bank Pay Account")
                {
                    ApplicationArea = All;
                }
                field("Difference Account"; "Difference Account")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
    }
}

