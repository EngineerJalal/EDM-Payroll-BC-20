page 98047 "Employee Relatives List"
{
    // version SHR1.0,PY1.0,EDM.HRPY1

    AutoSplitKey = true;
    Caption = 'Employee Relatives';
    DataCaptionFields = "Employee No.";
    Editable = false;
    PageType = List;
    SourceTable = "Employee Relative";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Relative Code"; Rec."Relative Code")
                {
                    ApplicationArea = All;
                }
                field("Eligible Child"; Rec."Eligible Child")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = All;
                }
                field(Working; Rec.Working)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Relative's Employee No."; Rec."Relative's Employee No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Academic Institute Code"; Rec."Academic Institute Code")
                {
                    ApplicationArea = All;
                }
                field("Scholarship Allowance"; Rec."Scholarship Allowance")
                {
                    ApplicationArea = All;
                }
                field("Scholarship Applicable"; Rec."Scholarship Applicable")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
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
            group("&Relative")
            {
                Caption = '&Relative';
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
}

