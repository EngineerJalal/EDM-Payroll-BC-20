page 98036 "Employment Type"
{
    // version SHR1.0,EDM.HRPY1

    PageType = List;
    SourceTable = "Employment Type";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Period Type";Rec."Period Type")
                {
                    ApplicationArea = All;
                }
                field("Holiday Calendar Code";Rec."Base Calendar Code")
                {
                    TableRelation = "Base Calendar N".Code;
                    ApplicationArea = All;
                }
                field("Working Days Per Month";Rec."Working Days Per Month")
                {
                    Caption = 'Working Days Per Month';
                    ApplicationArea = All;
                }
                field("Working Hours Per Day";Rec."Working Hours Per Day")
                {
                    Caption = 'Average Working Hours Per Day';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin

                        //Added on 16.06.2016 : AIM +
                        RefreshMaxAllowedWorkingHours();
                        //Added on 16.06.2016 : AIM -
                    end;
                }
                field("Max Allowed Overtime Per Day";Rec."Max Allowed Overtime Per Day")
                {
                    Caption = 'Max Allowed Overtime Hours Per Day';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added on 16.06.2016 : AIM +
                        RefreshMaxAllowedWorkingHours();
                        //Added on 16.06.2016 : AIM -
                    end;
                }
                field(MaxAllowedWorkingHours; MaxAllowedWorkingHours)
                {
                    Caption = 'Max Allowed Working Hours per day';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Overtime Rate";Rec."Overtime Rate")
                {
                    Caption = 'Overtime Rate Ratio';
                    ApplicationArea = All;
                }
                field("Overtime Unpaid Hours";Rec."Overtime Unpaid Hours")
                {
                    ApplicationArea = All;
                }
                field("Absence Deduction Rate";Rec."Absence Deduction Rate")
                {
                    Caption = 'Absence Deduction Rate Ratio';
                    ApplicationArea = All;
                }
                field("Absence Tolerance Hours";Rec."Absence Tolerance Hours")
                {
                    ApplicationArea = All;
                }
                field("Early Arrive Not Allowed";Rec."Early Arrive Not Allowed")
                {
                    ApplicationArea = All;
                }
                field("Late Leave Not Allowed";Rec."Late Leave Not Allowed")
                {
                    ApplicationArea = All;
                }
                field("Use Daily Shift Rates";Rec."Use Daily Shift Rates")
                {
                    ApplicationArea = All;
                }
                field("Standard Schedule";Rec."Standard Schedule")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No. of Working Days";Rec."No. of Working Days")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Use Hourly Rate";Rec."Use Hourly Rate")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Penalize Late Arrive";Rec."Penalize Late Arrive")
                {
                    ApplicationArea = All;
                }
                field("Auto fix missing punch";Rec."Auto fix missing punch")
                {
                    ApplicationArea = All;
                }
                field("Missing Punch In Penalty Hrs";Rec."Missing Punch In Penalty Hrs")
                {
                    ApplicationArea = All;
                }
                field("Missing Punch Out Penalty Hrs";Rec."Missing Punch Out Penalty Hrs")
                {
                    ApplicationArea = All;
                }
                field("Punch In Time Ceil";Rec."Punch In Time Ceil")
                {
                    ApplicationArea = All;
                }
                field("First Last Punch Only";Rec."First Last Punch Only")
                {
                    Caption = 'Consider Only First and Last Punch';
                    ApplicationArea = All;
                }
                field("Ignore Payroll Posting";Rec."Ignore Payroll Posting")
                {
                    ApplicationArea = All;
                }
                field("Manual Finalize";Rec."Manual Finalize")
                {
                    ApplicationArea = All;
                }
                field("Use Daily Shift Tolerance";Rec."Use Daily Shift Tolerance")
                {
                    ApplicationArea = All;
                }
                field("Max Monthly Paid Overtime";Rec."Max Monthly Paid Overtime")
                {
                    ApplicationArea = All;
                }
                field("Late Arrive Base Time";Rec."Late Arrive Base Time")
                {
                    ApplicationArea = All;
                }
                field("Late Arrive Policy";Rec."Late Arrive Policy")
                {
                    ApplicationArea = All;
                }
                field("Late Arrive Cummulative Days";Rec."Late Arrive Cummulative Days")
                {
                    ApplicationArea = All;
                }
                field("Late Arrive Penalty Days";Rec."Late Arrive Penalty Days")
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
            group("Empl.&Type")
            {
                Caption = 'Empl.&Type';
                action("&Standard Schedule")
                {
                    Caption = '&Standard Schedule';
                    Image = Calendar;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Employment Type Schedule";
                    RunPageLink = "Employment Type Code" = FIELD(Code);
                    RunPageView = SORTING("Employment Type Code", "Day of the Week", "Starting Time", "Table Name") WHERE("Table Name" = CONST("StandardSched"));
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        //Added on 16.06.2016 : AIM +
        RefreshMaxAllowedWorkingHours();
        //Added on 16.06.2016 : AIM -
    end;

    trigger OnAfterGetRecord();
    begin
        //Added on 16.06.2016 : AIM +
        RefreshMaxAllowedWorkingHours();
        //Added on 16.06.2016 : AIM -
    end;

    var
        MaxAllowedWorkingHours: Decimal;

    local procedure RefreshMaxAllowedWorkingHours();
    begin
        //Added in order to refresh Max Allowed Working Hours - 16.06.2016 : AIM +-
        MaxAllowedWorkingHours := Rec."Working Hours Per Day" + Rec."Max Allowed Overtime Per Day";
    end;
}

