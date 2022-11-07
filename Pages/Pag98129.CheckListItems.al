page 98129 "CheckList Items"
{
    PageType = List;
    SourceTable = "CheckList Items";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type;Type)
                {
                    ApplicationArea=All;
                    
                }
                field("Code";"Code")
                {
                    ApplicationArea=All;

                }   
                field("Job Title";"Job Title")   
                {
                    ApplicationArea=All;

                }   
                field(Description;Description)  
                {
                    ApplicationArea=All;

                }
                field(Remark;Remark)
                {
                    ApplicationArea=All;

                }
                field("Is Active";"Is Active")
                {
                    ApplicationArea=All;

                }
            }
        }
    }
}