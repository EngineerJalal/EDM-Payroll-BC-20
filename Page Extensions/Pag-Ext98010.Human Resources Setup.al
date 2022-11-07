pageextension 98010 "ExtHumanResourcesSetup" extends "Human Resources Setup"
{

    layout
    {
        modify(Numbering)
        {
            Visible = false;
        }
        addafter(Numbering)
        {
            group(General)
            {
                Caption = 'General';
                field("Period Filter"; Rec."Period Filter")
                {
                    ApplicationArea = All;
                }
                field("Minimum Salary"; Rec."Minimum Salary")
                {
                    ApplicationArea = All;
                }
                field("Additional Currency Code"; Rec."Additional Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Additional Currency Short Desc"; Rec."Additional Currency Short Desc")
                {
                    ApplicationArea = All;
                }
                field("Payroll in Use"; Rec."Payroll in Use")
                {
                    ApplicationArea = All;
                }
                field("Allow Single with Children"; Rec."Allow Single with Children")
                {
                    ApplicationArea = All;
                }
                field("Trial Period"; Rec."Trial Period")
                {
                    ApplicationArea = All;
                }
                field("Due Date Formula"; Rec."Due Date Formula")
                {
                    ApplicationArea = All;
                }
                field("Disable Data Entry Validation"; Rec."Disable Data Entry Validation")
                {
                    ApplicationArea = All;
                }
                field("<Base Unit of Measure1>"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Use System Approval"; Rec."Use System Approval")
                {
                    ApplicationArea = All;
                }
                field("Auto Update Emp Related"; Rec."Auto Update Emp Related")
                {
                    Caption = 'Auto Update Employee Related Cards';
                    ApplicationArea = All;
                }
                field("Use Payroll Special Calculation"; "Use Payroll Special Calculation")
                {
                    ApplicationArea = All;

                }
                field("Average Days Per Month"; Rec."Average Days Per Month")
                {
                    ApplicationArea = All;
                }
                field(CUSTIND; Rec.CUSTIND)
                {
                    ApplicationArea = All;
                }
                field("Use OverTime Unpaid Hours"; "Use OverTime Unpaid Hours")
                {
                    ApplicationArea = All;

                }
            }
            group(Control78)
            {
                Caption = 'Numbering';
                field("<Employee Nos.1>"; Rec."Employee Nos.")
                {
                    ApplicationArea = All;
                }
                field("Applicant Nos."; Rec."Applicant Nos.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Training No."; Rec."Training No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Attendance)
            {
                Caption = 'Attendance';
                field("Days In A Year"; Rec."Days In A Year")
                {
                    ApplicationArea = All;
                }
                field("Monthly Hours"; Rec."Monthly Hours")
                {
                    ApplicationArea = All;
                }
                field("Hours To Days Month Period"; Rec."Hours To Days Month Period")
                {
                    Caption = 'Hours To Days Month Validity';
                    ApplicationArea = All;
                }
                field("Type of Attendance Punch file"; Rec."Type of Attendance Punch file")
                {
                    ApplicationArea = All;
                }
                field("Attendance Punch Date Format"; Rec."Attendance Punch Date Format")
                {
                    ApplicationArea = All;
                }
                field("Attendance Punch Time Format"; Rec."Attendance Punch Time Format")
                {
                    ApplicationArea = All;
                }
                field("Attendance Date Seperator"; Rec."Attendance Date Seperator")
                {
                    ApplicationArea = All;
                }
                field(Overtime; Rec.Overtime)
                {
                    Caption = 'Overtime Code';
                    ApplicationArea = All;
                }
                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = All;
                }
                field(Deduction; Rec.Deduction)
                {
                    Caption = 'Deduction Code';
                    ApplicationArea = All;
                }
                field("Late Arrive Code"; Rec."Late Arrive Code")
                {
                    ApplicationArea = All;
                }
                field("Termination/Employment Code"; Rec."Termination/Employment Code")
                {
                    ApplicationArea = All;
                }
                field("Annual Leave Code"; Rec."Annual Leave Code")
                {
                    Caption = 'Annual Leave Code';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Accumulate Overtime To AL"; Rec."Accumulate Overtime To AL")
                {
                    Caption = 'Accumulate Overtime to Annual Leave';
                    ApplicationArea = All;
                }
                field("Overtime To AL Code"; Rec."Overtime To AL Code")
                {
                    Caption = 'Overtime To Annual Leave Code';
                    ApplicationArea = All;
                }
                field("Deduct Absence From AL"; Rec."Deduct Absence From AL")
                {
                    Caption = 'Deduct Absence From Annual Leave';
                    ApplicationArea = All;
                }
                field("Deduct Absence From AL Code"; Rec."Deduct Absence From AL Code")
                {
                    Caption = 'Deduct Absence From AL Code';
                    ApplicationArea = All;
                }
                field("Working Day Code"; Rec."Working Day Code")
                {
                    ApplicationArea = All;
                }
                field("Working From Home Code"; Rec."Working From Home Code")
                {
                    ApplicationArea = All;
                }
                field("Entitlement Generation Type"; Rec."Entitlement Generation Type")
                {
                    ApplicationArea = All;
                }
                field("Transfer Negative AL from Previous Year"; "Transfer Negative AL from Previous Year")
                {
                    ApplicationArea = All;

                }
                field("Customized Leave Code"; Rec."Customized Leave Code")
                {
                    ApplicationArea = All;
                }
                field("Check Entitlement Balance"; Rec."Check Entitlement Balance")
                {
                    ApplicationArea = All;
                }
                field("Auto Assign Attendance No"; Rec."Auto Assign Attendance No")
                {
                    ApplicationArea = All;
                }
                field("Reset Attend Jnls Manual"; Rec."Reset Attendance Jnls Manual")
                {
                    Caption = 'Reset Attendance Journals Manually';
                    ApplicationArea = All;
                }
                field("Auto Calculate Entitlement"; Rec."Auto Calculate Entitlement")
                {
                    ApplicationArea = All;
                }
                field("Seperate Attendance Interval"; Rec."Seperate Attendance Interval")
                {
                    ApplicationArea = All;
                }
                field("Seperate Attendance From Payroll"; Rec."Seperate Attend From Payroll")
                {
                    ApplicationArea = All;
                }
                field("Use Resources Concept"; Rec."Use Resources Concept")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Auto Reset Attend Hrs for leave"; Rec."Auto Reset leave Attend Hrs")
                {
                    ApplicationArea = All;
                }
                field("Give Holiday Transportation"; Rec."Give Holiday Transportation")
                {
                    ApplicationArea = All;
                }
                field("Auto Synchronize Attendance"; Rec."Auto Synchronize Attendance")
                {
                    ApplicationArea = All;
                }
                field("Control Transportation For Working Days"; Rec."Control Trans For Working Days")
                {
                    ApplicationArea = All;
                }
                field("Number of Days Transport"; Rec."Number of Days Transport")
                {
                    ApplicationArea = All;
                }
                field("Accumulate Weekend Overtime To Sunday"; "Accumulate Weekend Overtime To Sunday")
                {
                    ApplicationArea = All;

                }
                field("Sunday Leave Code"; "Sunday Leave Code")
                {
                    ApplicationArea = All;

                }
                field("Accumulate Holiday Overtime To HolidayVac"; "Accumulate Holiday Overtime To HolidayVac")
                {
                    ApplicationArea = All;

                }
                field("Holiday Leave Code"; "Holiday Leave Code")
                {
                    ApplicationArea = All;

                }
                field("Generate Monthly Entitlement"; "Generate Monthly Entitlement")
                {
                    ApplicationArea = All;

                }
                field("Manual Schedule"; "Manual Schedule")
                {
                    ApplicationArea = All;
                }
            }
            group(AttendJobJournal)
            {
                Caption = 'Attendance Job Journal Generation';
                Visible = UseResourcesConceptVisible;
                field("Job Hourly Rate Calculation"; Rec."Job Hourly Rate Calculation")
                {
                    ApplicationArea = All;
                }
                field("Job Journal Template"; Rec."Job Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Job Journal Batch"; Rec."Job Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Job Line Type"; Rec."Job Line Type")
                {
                    ApplicationArea = All;
                }
                field("Job Source Code"; Rec."Job Source Code")
                {
                    ApplicationArea = All;
                }
                field("Def. Job Resource No."; Rec."Def. Job Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Job Resource UOM"; Rec."Job Resource UOM")
                {
                    ApplicationArea = All;
                }
                field("Def. Gen. Bus. Posting Group"; Rec."Def. Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Def. Gen. Prod. Posting Group"; Rec."Def. Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
            }
            group(Picture)
            {
                Caption = 'Picture';
                Visible = false;
                field("HR Logo"; Rec."HR Logo")
                {
                    ApplicationArea = All;
                }
            }
            group(Dimensions)
            {
                Visible = false;
                field("Project Dimension Type"; Rec."Project Dimension Type")
                {
                    ApplicationArea = All;
                }
                field("Department Dimension Type"; Rec."Department Dimension Type")
                {
                    ApplicationArea = All;
                }
                field("Division Dimension Type"; Rec."Division Dimension Type")
                {
                    ApplicationArea = All;
                }
            }
            group(WTR)
            {
                Caption = 'WTR';
                Visible = false;
                field("IN Against Annual Leave Code"; Rec."IN Against Annual Leave Code")
                {
                    Caption = 'Against Annual Leave Code';
                    ApplicationArea = All;
                }
                field("OUT Against Annual Leave Code"; Rec."OUT Against Annual Leave Code")
                {
                    ApplicationArea = All;
                }
                field("IN Day-Off Overtime Code"; Rec."IN Day-Off Overtime Code")
                {
                    Caption = 'Day-Off Overtime Code';
                    ApplicationArea = All;
                }
                field("OUT Day-Off Overtime Code"; Rec."OUT Day-Off Overtime Code")
                {
                    ApplicationArea = All;
                }
                field("IN Standard Overtime Code"; Rec."IN Standard Overtime Code")
                {
                    Caption = 'Standard Overtime Code';
                    ApplicationArea = All;
                }
                field("OUT Standard Overtime Code"; Rec."OUT Standard Overtime Code")
                {
                    ApplicationArea = All;
                }
                field("IN Public Overtime Code"; Rec."IN Public Overtime Code")
                {
                    Caption = 'Public Overtime Code';
                    ApplicationArea = All;
                }
                field("OUT Public Overtime Code"; Rec."OUT Public Overtime Code")
                {
                    ApplicationArea = All;
                }
                field("IN Late Tolerance Minutes"; Rec."IN Late Tolerance Minutes")
                {
                    Caption = 'Late\Early Tolerance Minutes';
                    ApplicationArea = All;
                }
                field("OUT Late Tolerance Minutes"; Rec."OUT Late Tolerance Minutes")
                {
                    ApplicationArea = All;
                }
                field("IN Overtime Tolerance Minutes"; Rec."IN Overtime Tolerance Minutes")
                {
                    Caption = 'Overtime Tolerance Minutes';
                    ApplicationArea = All;
                }
                field("OUT Overtime Tolerance Minutes"; Rec."OUT Overtime Tolerance Minutes")
                {
                    ApplicationArea = All;
                }
                field("Over Lunch Break Out"; Rec."Over Lunch Break Out")
                {
                    ApplicationArea = All;
                }
                field("Over Lunch Break Out Tolerance"; Rec."Over Lunch Break Out Tolerance")
                {
                    ApplicationArea = All;
                }
                field("Against Annual Leave Hours"; Rec."Against Annual Leave Hours")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("WTR File Path"; Rec."WTR File Path")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        modify("Causes of Absence")
        {
            Visible = false;
        }
        modify("Causes of Inactivity")
        {
            Visible = false;
        }
        modify("Grounds for Termination")
        {
            Visible = false;
        }
        modify(Unions)
        {
            Visible = false;
        }
        modify(Relatives)
        {
            Visible = false;
        }
        modify("Misc. Articles")
        {
            Visible = false;
        }
        modify(Confidential)
        {
            Visible = false;
        }
        modify(Qualifications)
        {
            Visible = false;
        }
        modify("Employee Statistics Groups")
        {
            Visible = false;
        }
        modify("Employment Contracts")
        {
            Visible = false;
        }
        addafter("Employee Statistics Groups")
        {
            group("Function")
            {
                Caption = 'Function';
                action("Insert System Codes")
                {
                    Caption = 'Insert System Codes';
                    Image = Insert;
                    ApplicationArea = All;
                }
                action("Create Pay Details")
                {
                    Caption = 'Create Pay Details';
                    Image = CreateDocument;
                    ApplicationArea = All;
                }
                action("Delete All Pay Details")
                {
                    Caption = 'Delete All Pay Details';
                    Image = Delete;
                    ApplicationArea = All;
                }
            }
        }
    }
    Var
        UseResourcesConceptVisible: Boolean;

    trigger OnAfterGetRecord()
    begin
        UseResourcesConceptVisible := Rec."Use Resources Concept";
    end;

    procedure GetDecimalString(a: Record "Employee"; b: Integer; c: Integer): Text
    var
    begin
        exit(format(a));
    end;
}