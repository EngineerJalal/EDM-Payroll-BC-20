page 98124 "Employee Computer Skills"
{
    PageType = List;
    SourceTable = "Employee Computer Skills";
    layout
    {
    area(content)
        {
            repeater(Control1)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea=All;
                }
                field("Computer Skills Code";"Computer Skills Code")
                {
                    ApplicationArea=All;
                }
                field("Skills Level";"Skills Level")
                {
                    ApplicationArea=All;
                }
                field("To Be Accomplished";"To Be Accomplished")
                {
                    ApplicationArea=All;
                }
                field("Expected Accomplishment Date";"Expected Accomplishment Date")
                {
                    ApplicationArea=All;
                }
                field(Accomplished;Accomplished)
                {
                    ApplicationArea=All;
                }
                field("Accomplishment Date";"Accomplishment Date")
                {
                    ApplicationArea=All;
                }
            }
        }
    }
}        