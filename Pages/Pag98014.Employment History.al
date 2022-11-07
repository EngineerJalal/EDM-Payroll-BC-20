page 98014 "Employment History"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    DataCaptionFields = "No.";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Employment History";

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
                field("Employer Type";Rec."Employer Type")
                {
                    ApplicationArea=All;
                }
                field(Company;Rec.Company)
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
                field(References;Rec.References)
                {
                    ApplicationArea=All;
                }
                field("Last Salary";Rec."Last Salary")
                {
                    ApplicationArea=All;
                }
                field(Contact;Rec.Contact)
                {
                    ApplicationArea=All;
                }
                field("Stategy Business Unit";Rec."Stategy Business Unit")
                {
                    ApplicationArea=All;
                }
                field("In Our Own Company";Rec."In Our Own Company")
                {
                    ApplicationArea=All;
                }
                field("Job Title";Rec."Job Title")
                {
                    ApplicationArea=All;
                }
                field("Global Dimension 1 Code";Rec."Global Dimension 1 Code")
                {
                    ApplicationArea=All;
                }
                field("Global Dimension 2 Code";Rec."Global Dimension 2 Code")
                {
                    ApplicationArea=All;
                }
                field(Validated;Rec.Validated)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Position;Rec.Position)
                {
                    ApplicationArea=All;
                }
                field("Phone No.";Rec."Phone No.")
                {
                    ApplicationArea=All;
                }
                field("Reason for Leaving";Rec."Reason for Leaving")
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
        Applicant : Record Applicant;
}

