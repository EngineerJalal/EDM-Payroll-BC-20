page 98123 "Emp. Travel Per Deem Policy"
{
    // version EDM.HRPY2

    PageType = List;
    SourceTable = "Emp. Travel Per Deem Policy";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Policy Code";"Policy Code")
                {
                    ApplicationArea=All;
                }
                field("Employment Years (From)";"Employment Years (From)")
                {
                    ApplicationArea=All;
                }
                field("Employment Years (To)";"Employment Years (To)")
                {
                    ApplicationArea=All;
                }
                field("Job Category";"Job Category")
                {
                    ApplicationArea=All;
                }
                field("Per Deem % Of Basic Salary";"Per Deem % Of Basic Salary")
                {
                    ApplicationArea=All;
                }

                field("Price per Hrs";"Price per Hrs")
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

