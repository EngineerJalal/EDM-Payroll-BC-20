page 98119 "School Allow Pay Element"
{
    // version EDM.HRPY2

    PageType = ListPart;
    SourceTable = "Allowance Deduction Pay Elemt";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pay Element Code";"Pay Element Code")
                {
                    ApplicationArea=All;
                }
                field("Pay Element Name";"Pay Element Name")
                {
                    ApplicationArea=All;
                }
                field("Calculation Type";"Calculation Type")
                {
                    ApplicationArea=All;
                }
                field("Monthly Amount";"Monthly Amount")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin

                        UpdateMaxMonthlyAmount();
                    end;
                }
                field("School Level";"School Level")
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

