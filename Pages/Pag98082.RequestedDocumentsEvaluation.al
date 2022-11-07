page 98082 "Requested Documents Evaluation"
{
    // version SHR1.0,EDM.HRPY2

    AutoSplitKey = true;
    DataCaptionFields = "No.";
    PageType = Card;
    SourceTable = "Requested Documents";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea=All;
                }
                field("Document Code";"Document Code")
                {
                    ApplicationArea=All;
                }
                field("Checklist Type";"Checklist Type")
                {
                    ValuesAllowed = "Supervisor Eval. Form","Self Eval. Form";
                    ApplicationArea=All;
                }
                field("File Type";"File Type")
                {
                    ApplicationArea=All;
                }
                field("File Name";"File Name")
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Requested From";"Requested From")
                {
                    ApplicationArea=All;
                }
                field("Receipt Info";"Receipt Info")
                {
                    ApplicationArea=All;
                }
                field(Status;Status)
                {
                    ApplicationArea=All;
                }
                field("Is Required";"Is Required")
                {
                    Caption = 'Required';
                    ApplicationArea=All;
                }
                field("Is Copy";"Is Copy")
                {
                    ApplicationArea=All;
                }
                field("No. of Copies";"No. of Copies")
                {
                    ApplicationArea=All;
                }
                field("Issue Date";"Issue Date")
                {
                    ApplicationArea=All;
                }
                field("Expiry Date";"Expiry Date")
                {
                    ApplicationArea=All;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea=All;
                }
                field(Requirements;Requirements)
                {
                    ApplicationArea=All;
                }
                field("Show on Report";"Show on Report")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
            }
        }
    }
}

