page 98106 "Categories ListPart"
{
    // version EDM.HRPY2

    PageType = ListPart;
    SourceTable = "Allowance Deduction Temp Catg";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code";"Category Code")
                {
                    TableRelation = "Allowance Deduction Temp Catg"."Category Code" WHERE ("Category Code"=FIELD("Category Code"));
                    ApplicationArea=All;
                }
                field("Category Name";"Category Name")
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

