page 98095 "Evaluation Template KPI"
{
    // version EDM.HRPY2

    PageType = ListPart;
    SourceTable = "Evaluation Template KPI";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("KPI Category";"KPI Category")
                {
                    ApplicationArea=All;
                }
                field("KPI Category Name";"KPI Category Name")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("KPI Category Description";"KPI Category Description")
                {
                    ApplicationArea=All;
                }
                field("KPI Item";"KPI Item")
                {
                    ApplicationArea=All;
                }
                field("KPI Item Name";"KPI Item Name")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("KPI Item Description";"KPI Item Description")
                {
                    ApplicationArea=All;
                }
                field("Min Evaluation Score";"Min Evaluation Score")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //CurrPage.UPDATE;
                    end;
                }
                field("Max Evaluation Score";"Max Evaluation Score")
                {
                    ApplicationArea=All;
                }
                field("KPI Score Range Definition";"KPI Score Range Definition")
                {
                    ApplicationArea=All;
                }
                field(Comments;Comments)
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

