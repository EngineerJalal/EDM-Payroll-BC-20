page 98026 "Absence Entitlement"
{
    // version SHR1.0,EDM.HRPY1

    // MB6.26  : -fix problem of non cumulative

    DataCaptionFields = "Cause of Absence Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Absence Entitlement";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Rec.Type)
                {
                    ApplicationArea=All;
                }
                field(Period;Rec.Period)
                {
                    ApplicationArea=All;
                }
                field("From Unit";Rec."From Unit")
                {
                    ApplicationArea=All;
                }
                field("To Unit";Rec."To Unit")
                {
                    ApplicationArea=All;
                }
                field(Entitlement;Rec.Entitlement)
                {
                    DecimalPlaces = 2:2;
                    ApplicationArea=All;
                }
                field("Allowed Days To Transfer";Rec."Allowed Days To Transfer")
                {
                    ApplicationArea=All;
                }
                field("Employee Category";Rec."Employee Category")
                {
                    ApplicationArea=All;
                }
                field("Calculation Type";Rec."Calculation Type")
                {
                    Visible = true;
                    ApplicationArea=All;
                }
                field("Balance Cummulative Years";Rec."Balance Cummulative Years")
                {
                    Visible = true;
                    ApplicationArea=All;
                }
                field("First Year Entitlement";Rec."First Year Entitlement")
                {
                    Visible = true;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

