page 98116 "Scheduling System Card"
{
    // version EDM.HRPY2

    PageType = Card;
    SourceTable = "Scheduling System";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No";"Document No")
                {
                    ApplicationArea=All;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Employee Name";"Employee Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea=All;
                }
                field("Is Inactive";"Is Inactive")
                {
                    ApplicationArea=All;
                }
            }
            part(Control9;"Scheduling System Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Document No"=FIELD("Document No"),"Employee No"=FIELD("Employee No");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(creation)
        {
            //Caption = 'General';
        }
    }
}

