page 98019 "Applicant Relatives"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    Caption = 'Employee Relatives';
    DataCaptionFields = "Applicant No.";
    PageType = Card;
    SourceTable = "Applicant Relative";

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
                field("Relative Code";Rec."Relative Code")
                {
                    ApplicationArea=All;
                }
                field("First Name";Rec."First Name")
                {
                    ApplicationArea=All;
                }
                field("Middle Name";Rec."Middle Name")
                {
                    Visible = true;
                    ApplicationArea=All;
                }
                field("Last Name";Rec."Last Name")
                {
                    ApplicationArea=All;
                }
                field("Birth Date";Rec."Birth Date")
                {
                    ApplicationArea=All;
                }
                field(Working;Rec.Working)
                {
                    ApplicationArea=All;
                }
                field("Relative's Employee No.";Rec."Relative's Employee No.")
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

