page 98015 "Language Skills"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = false;
    DataCaptionFields = "No.";
    PageType = Card;
    SourceTable = "Language Skills";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea=All;
                }
                field("Table Name";Rec."Table Name")
                {
                    ApplicationArea=All;
                }
                field("Language Code";Rec."Language Code")
                {
                    ApplicationArea=All;
                }
                field(Understanding;Rec.Understanding)
                {
                    ApplicationArea=All;
                }
                field(Speaking;Rec.Speaking)
                {
                    ApplicationArea=All;
                }
                field(Reading;Rec.Reading)
                {
                    ApplicationArea=All;
                }
                field(Writing;Rec.Writing)
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    var
        aPPLICANT : Record Applicant;
}

