page 98066 "Payroll Status"
{
    // version PY1.0,EDM.HRPY1

    PageType = List;
    SourceTable = "Payroll Status";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Payroll Group Code"; "Payroll Group Code")
                {
                    ApplicationArea = All;
                }
                field("Pay Frequency"; "Pay Frequency")
                {
                    ApplicationArea = All;
                }
                field("Starting Payroll Day"; "Starting Payroll Day")
                {
                    ApplicationArea = All;
                }
                field("Ending Payroll Day"; "Ending Payroll Day")
                {
                    ApplicationArea = All;
                }
                field("Start Fiscal Period"; "Start Fiscal Period")
                {
                    ApplicationArea = All;
                }
                field("Last Period Calculated"; "Last Period Calculated")
                {
                    ApplicationArea = All;
                }
                field("Last Period Finalized"; "Last Period Finalized")
                {
                    ApplicationArea = All;
                }
                field("Finalized Payroll Date"; "Finalized Payroll Date")
                {
                    ApplicationArea = All;
                }
                field("Calculated Payroll Date"; "Calculated Payroll Date")
                {
                    ApplicationArea = All;
                }
                field("Period Start Date"; "Period Start Date")
                {
                    ApplicationArea = All;
                }
                field("Period End Date"; "Period End Date")
                {
                    ApplicationArea = All;
                }
                field("Payroll Date"; "Payroll Date")
                {
                    ApplicationArea = All;
                }
                field("Separate Attendance Interval"; "Separate Attendance Interval")
                {
                    ApplicationArea = All;
                }
                field("Attendance Start Day"; "Attendance Start Day")
                {
                    ApplicationArea = All;
                }
                field("Attendance Start Date"; "Attendance Start Date")
                {
                    ApplicationArea = All;
                }
                field("Attendance End Date"; "Attendance End Date")
                {
                    ApplicationArea = All;
                }
                field("Attendance Period"; "Attendance Period")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field("Supplement Payroll Date"; "Supplement Payroll Date")
                {
                    ApplicationArea = All;
                }
                field("Supplement Period"; "Supplement Period")
                {
                    ApplicationArea = All;
                }
                field("Supplement Start Date"; "Supplement Start Date")
                {
                    ApplicationArea = All;
                }
                field("Supplement End Date"; "Supplement End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    var
        L_UserSetup: Record "User Setup";
    begin
        // Added in order to set permission for Payroll Status Page - 20.09.2017 : A2+
        L_UserSetup.SETRANGE("User ID", USERID);
        if (L_UserSetup.FINDFIRST) and (not L_UserSetup."Allow Access Pay Status Page") then
            ERROR('');
        // Added in order to set permission for Payroll Status Page - 20.09.2017 : A2-
    end;

    trigger OnClosePage();
    var
        L_UserSetup: Record "User Setup";
    begin
        // Added in order to set permission for Payroll Status Page - 20.09.2017 : A2-
        if L_UserSetup.FINDFIRST then
            repeat
                L_UserSetup."Allow Access Pay Status Page" := false;
                L_UserSetup.MODIFY;
            until L_UserSetup.NEXT = 0;
        // Added in order to set permission for Payroll Status Page - 20.09.2017 : A2-
    end;
}

