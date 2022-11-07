page 98092 "Evaluation Items List"
{
    // version EDM.HRPY2

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Evaluation Items";

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
                field("Item Type";"Item Type")
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
            action("KPI Categories")
            {
                Image = Category;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea=All;

                trigger OnAction();
                begin
                    EvaluationItem.SETRANGE("Item Type",EvaluationItem."Item Type"::"KPI Category");
                    //EvaluationItem.FINDSET;
                    //PAGE.RUN(80335,EvaluationItem);
                    EvalItemPg.SETTABLEVIEW(EvaluationItem);
                    EvalItemPg.RUN();
                end;
            }
            action("KPI Items")
            {
                Image = Item;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ApplicationArea=All;

                trigger OnAction();
                begin
                    EvaluationItem.SETRANGE("Item Type",EvaluationItem."Item Type"::"KPI Item");
                    EvalItemPg.SETTABLEVIEW(EvaluationItem);
                    EvalItemPg.RUN();
                end;
            }
            action("Evaluation Intervals")
            {
                Image = Ranges;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ApplicationArea=All;

                trigger OnAction();
                begin
                    EvaluationItem.SETRANGE("Item Type",EvaluationItem."Item Type"::"Evaluation interval");
                    EvalItemPg.SETTABLEVIEW(EvaluationItem);
                    EvalItemPg.RUN();
                end;
            }
            action("Evaluation Periods")
            {
                Image = Period;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea=All;

                trigger OnAction();
                begin
                    EvaluationItem.SETRANGE("Item Type",EvaluationItem."Item Type"::"Evaluation period");
                    EvalItemPg.SETTABLEVIEW(EvaluationItem);
                    EvalItemPg.RUN();
                end;
            }
        }
    }

    var
        EvaluationItem : Record "Evaluation Items";
        EvalItemPg : Page "Evaluation Items";
}

