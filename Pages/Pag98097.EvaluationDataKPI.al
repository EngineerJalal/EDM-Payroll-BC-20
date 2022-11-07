page 98097 "Evaluation Data KPI"
{
    // version EDM.HRPY2

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Evaluation Data KPI";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Evaluation Code";"Evaluation Code")
                {
                    ApplicationArea=All;
                }
                field("KPI Category";"KPI Category")
                {
                    Editable = false;
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
                    Editable = false;
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
                field(Score;Score)
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        /*TemplateKPI.SETRANGE("KPI Category","KPI Category");
                        TemplateKPI.SETRANGE("KPI Item","KPI Item");
                        TemplateKPI.SETRANGE("Evaluation Code","Evaluation Template");
                        IF TemplateKPI.FINDFIRST THEN
                          IF (Score > TemplateKPI."Max Evaluation Score") OR (Score < TemplateKPI."Min Evaluation Score") THEN
                            ERROR('Invalid Score');
                        
                        //EvaluationDataMain.UPDATE;
                        */
                        CurrPage.UPDATE;

                    end;
                }
                field("Score Range";GetScoreRange)
                {
                    Editable = false;
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

    var
        TemplateKPI : Record "Evaluation Template KPI";
        EvaluationDataMain : Page "Evaluation Data Main";
}

