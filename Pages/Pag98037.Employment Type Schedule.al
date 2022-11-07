page 98037 "Employment Type Schedule"
{
    // version SHR1.0,EDM.HRPY1

    DataCaptionFields = "Employment Type Code";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Employment Type Schedule";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Day of the Week";Rec."Day of the Week")
                {
                    ApplicationArea=All;
                }
                field("Shift Code";Rec."Shift Code")
                {
                    ApplicationArea=All;
                }
                field("Starting Time";Rec."Starting Time")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Ending Time";Rec."Ending Time")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("No. of Hours";Rec."No. of Hours")
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field("Global Dimension 1 Code";Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Global Dimension 2 Code";Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Working Shift Code";Rec."Working Shift Code")
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

