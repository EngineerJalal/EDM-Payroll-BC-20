page 98099 "Evaluation Template List"
{
    // version EDM.HRPY2

    CardPageID = "Evaluation Template";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Evaluation Template";

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Is Inactive";"Is Inactive")
                {
                    ApplicationArea=All;
                }
                field("Evaluation Interval";"Evaluation Interval")
                {
                    ApplicationArea=All;
                }
                field("Evaluation Interval Name";"Evaluation Interval Name")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Pass Score";"Pass Score")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Evaluation Template Sheet")
            {
                Image = Evaluate;
                Promoted = true;
                RunObject = Report "Evaluation Sheet";
                ApplicationArea=All;
            }
        }
    }
}

