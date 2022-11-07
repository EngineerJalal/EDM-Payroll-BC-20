page 98013 "Academic History"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Academic History";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea=All;
                }
                field("Institute Type";Rec."Institute Type")
                {
                    ApplicationArea=All;
                }
                field("From Date";Rec."From Date")
                {
                    ApplicationArea=All;
                }
                field("To Date";Rec."To Date")
                {
                    ApplicationArea=All;
                }
                field("Degree Code";Rec."Degree Code")
                {
                    ApplicationArea=All;
                }
                field("Degree Name";Rec."Degree Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Specialty Code";Rec."Specialty Code")
                {
                    ApplicationArea=All;
                }
                field("Speciality Name";Rec."Speciality Name")
                {
                    Editable = false;
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
    }
}

