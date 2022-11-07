page 98093 "Evaluation Item Relation"
{
    // version EDM.HRPY2

    PageType = List;
    SourceTable = "Evaluation Item Relation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Parent Item Type";"Parent Item Type")
                {
                    ApplicationArea=All;
                }
                field("Parent Code";"Parent Code")
                {
                    ApplicationArea=All;
                }
                field("Parent Name";"Parent Name")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Child Item Type";"Child Item Type")
                {
                    ApplicationArea=All;
                }
                field("Child Code";"Child Code")
                {
                    ApplicationArea=All;
                }
                field("Child Name";"Child Name")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("is Inactive";"is Inactive")
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

