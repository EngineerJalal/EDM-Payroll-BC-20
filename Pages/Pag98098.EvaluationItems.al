page 98098 "Evaluation Items"
{
    // version EDM.HRPY2

    PageType = List;
    ShowFilter = false;
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
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnOpenPage();
    begin
        FILTERGROUP := 2;
        FILTERGROUP := 0;
    end;

    var
        EvaluationItem : Record "Evaluation Items";
        TEST : Page "Evaluation Items List";
}

