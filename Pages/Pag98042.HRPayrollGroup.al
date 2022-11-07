page 98042 "HR Payroll Group"
{
    // version SHR1.0;PY1.0,EDM.HRPY1

    PageType = List;
    SourceTable = "HR Payroll Group";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Employees Assigned"; "Employees Assigned")
                {
                    ApplicationArea = All;
                }
                field("Users Assigned"; "Users Assigned")
                {
                    ApplicationArea = All;
                }
                field("Is Project Group"; "Is Project Group")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("R5 Groups"; "R5 Groups")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Group")
            {
                Caption = '&Group';
                action("&Users")
                {
                    Caption = '&Users';
                    Image = UserInterface;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "HR Payroll User";
                    RunPageLink = "Payroll Group Code" = FIELD(Code);
                    ApplicationArea = All;
                }
            }
        }
    }
}

