page 98107 "Pay Element ListPart1"
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
                    TableRelation = "Allowance Deduction Pay Elemt"."Pay Element Code" WHERE ("Pay Element Code"=FIELD("Pay Element Code"));
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
                        CALCFIELDS("Affected by Working Days","No Of Working Days");
                        if not "Affected by Working Days" then
                          begin
                            UpdateDailyAmount();
                            UpdateMaxMonthlyAmount();
                          end
                        else
                          UpdateMonthlyAmount();
                    end;
                }
                field("Daily Amount";"Daily Amount")
                {
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        CALCFIELDS("Affected by Working Days","No Of Working Days");
                        if "Affected by Working Days" then
                          begin
                            UpdateMonthlyAmount();
                            UpdateMaxMonthlyAmount();
                          end
                        else
                          UpdateDailyAmount();
                    end;
                }
                field("Maximum Monthly Amount";"Maximum Monthly Amount")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

