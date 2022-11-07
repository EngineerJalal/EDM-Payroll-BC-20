page 98017 "Cause of Absence List"
{
    // version SHR1.0,EDM.HRPY1

    Editable = false;
    PageType = List;
    SourceTable = "Cause of Absence";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field(Vacation;Rec.Vacation)
                {
                    ApplicationArea=All;
                }
                field("Unit of Measure Code";Rec."Unit of Measure Code")
                {
                    ApplicationArea=All;
                }
                field("Total Absence (Base)";Rec."Total Absence (Base)")
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

