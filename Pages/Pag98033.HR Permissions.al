page 98033 "HR Permissions"
{
    // version SHR1.0,EDM.HRPY1

    PageType = list;
    SourceTable = "HR Permissions";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User Type";Rec."User Type")
                {
                    ApplicationArea = All;
                }
                field("User ID";Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type";Rec."Transaction Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Function";Rec."Function")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Hide Salaries";Rec."Hide Salaries")
                {
                    ApplicationArea = All;
                }
                field("Access Only Employee View";Rec."Access Only Employee View")
                {
                    ApplicationArea = All;
                }
                field("Assigned Employee Code";Rec."Assigned Employee Code")
                {
                    ApplicationArea = All;
                }
                field("Req. Approval on Salary Change";Rec."Req. Approval on Salary Change")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Req. App. on Calculate Pay";Rec."Req. App. on Calculate Pay")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Req. App. on Finalize Pay";Rec."Req. App. on Finalize Pay")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Req. Approval on Pay Slip";Rec."Req. Approval on Pay Slip")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Attendance Limited Access";Rec."Attendance Limited Access")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("HR Officer";Rec."HR Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payroll Officer";Rec."Payroll Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Attendance Officer";Rec."Attendance Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Leaves Officer";Rec."Leaves Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Data entry Officer";Rec."Data entry Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Recruitment Officer";Rec."Recruitment Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Evaluation Officer";Rec."Evaluation Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Permission Type";Rec."Permission Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Administration Officer";Rec."Administration Officer")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

