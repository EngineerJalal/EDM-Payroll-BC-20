page 98012 "HR Confidential Comments"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    DataCaptionFields = "Applicant No.";
    PageType = Card;
    SourceTable = "HR Confidential Comments";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Applicant No.";Rec."Applicant No.")
                {
                    ApplicationArea=All;
                }
                field("Confidential Code";Rec."Confidential Code")
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field(Comment;Rec.Comment)
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Confidential")
            {
                Caption = '&Confidential';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    RunObject = Page "HR Confidential Comment Sheet";
                    RunPageLink = "Table Name"=CONST("Confidential Information"),"No."=FIELD("Applicant No."),Code=FIELD("Confidential Code"),"Table Line No."=FIELD("Line No.");
                    ApplicationArea=All;
                }
            }
        }
    }

    var
        Applicant : Record Applicant;
}

