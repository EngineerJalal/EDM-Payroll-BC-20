page 98094 "Evaluation Template"
{
    // version EDM.HRPY2

    PageType = Card;
    SourceTable = "Evaluation Template";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea=All;
                }
                field(Name;Name)
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Evaluation Interval";"Evaluation Interval")
                {
                    ApplicationArea=All;
                }
                field("Pass Score";"Pass Score")
                {
                    ApplicationArea=All;
                }
                field("Is Inactive";"Is Inactive")
                {
                    ApplicationArea=All;
                }
            }
            part(Control10;"Evaluation Template KPI")
            {
                SubPageLink = "Evaluation Code"=FIELD(Code);
                ApplicationArea=All;
            }
        }
    }

    actions
    {
    }
}

