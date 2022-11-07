page 98067 "Payroll Period Setup"
{
    // version PY1.0,EDM.HRPY2

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Period Setup";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Period;Period)
                {
                    ApplicationArea=All;
                }
                field("From Unit";"From Unit")
                {
                    ApplicationArea=All;
                }
                field("To Unit";"To Unit")
                {
                    ApplicationArea=All;
                }
                field("Pension %";"Pension %")
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

