page 98079 "Employee View Relatives"
{
    // version EDM.HRPY2

    AutoSplitKey = true;
    Caption = 'Employee Relatives';
    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Employee Relative";
    SourceTableTemporary = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Relative Code"; "Relative Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Birth Date"; "Birth Date")
                {
                    ApplicationArea = All;
                }
                field("Arabic Gender"; "Arabic Gender")
                {
                    ApplicationArea = All;
                }
                field("Social Status"; "Social Status")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Relative")
            {
                Caption = '&Relative';
                Image = Relatives;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "HR Comment Sheet EDM";
                    RunPageLink = "Table Name" = CONST("Employee Relative"), "No." = FIELD("Employee No."), "Table Line No." = FIELD("Line No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        EmpRelativePerm: Record "Employee Relative";
}

