page 98081 "Employee Add Info Subform"
{
    // version EDM.HRPY2

    PageType = CardPart;
    SourceTable = "Employee Additional Info";

    layout
    {
        area(content)
        {
            field("Work Location";"Work Location")
            {
                TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Work Location"));
                ApplicationArea=All;
            }
            field("Bonus System";"Bonus System")
            {
                TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Bonus System"));
                ApplicationArea=All;
            }
            field("Zoho Id";"Zoho Id")
            {
                ApplicationArea=All;
            }
        }
    }

    actions
    {
    }
}

