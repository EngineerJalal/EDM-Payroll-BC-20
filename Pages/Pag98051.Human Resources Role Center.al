page 98051 "Human Resources RoleCenter"
{
    CaptionML = ENU = 'Home';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(HRControl)
            {
                part("Human Resource Activities"; "Human Resource Activities")
                {
                    ApplicationArea = All;
                }
                part("Administration Setup"; "HR Activities Role Center")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(embedding)
        {
        }
        area(processing)
        {

            action("Employees List")
            {
                Image = Employee;
                Promoted = true;
                PromotedIsBig = true;
                Visible = true;
                RunObject = Page "Employee List";
                ApplicationArea = All;
            }
            action("Active Employees List")
            {
                Image = Employee;
                Promoted = true;
                PromotedIsBig = true;
                Visible = true;
                RunObject = Page "Employee List";
                RunPageView = WHERE("Status" = FILTER(Active));
                ApplicationArea = All;
            }

            action("Attendance List")
            {
                Image = AbsenceCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Attendance List";
                ApplicationArea = All;
            }
            action("Journals Matrix")
            {
                Image = Journals;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Employee Journals Matrix";
                ApplicationArea = All;
            }
            action("Pay Details")
            {
                Caption = 'Payroll Details';
                Image = PayrollStatistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Pay Details";
                ApplicationArea = All;
            }
            action("Pay Details Supplement")
            {
                Caption = 'Payroll Supplement';
                Image = PayrollStatistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Pay Details Supplement";
                ApplicationArea = All;
            }

            separator(Administration)
            {
                CaptionML = ENU = 'Administration',
                            ESM = 'Administracion',
                            FRC = 'Administration',
                            ENC = 'Administration';
                IsHeader = true;
            }
            action("Import Journals From Excel")
            {
                Image = ImportExcel;
                Promoted = false;
                RunObject = Report "Import Benefits";
                ApplicationArea = All;
            }
            action(Loans)
            {
                Image = Loaner;
                Promoted = false;
                RunObject = Page "Loan List";
                ApplicationArea = All;
            }
            action("Employees Dimensions")
            {
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Employee Dimensions";
                ApplicationArea = All;
            }
            action("Employees Absence Entitlements")
            {
                Image = Balance;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Employee Absence Entitlement";
                ApplicationArea = All;
            }

            action("Leaves Request List")
            {
                Image = Absence;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Leave Request List";
                ApplicationArea = All;
            }
            action("Purchase Quotes")
            {
                Image = Purchase;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Purchase Quotes";
                ApplicationArea = All;
            }
            action("إفادة عمل")
            {
                Image = "Report";
                RunObject = Report "Working Statement";
                ApplicationArea = All;
            }
            separator(Separator5)
            {
            }
        }
        area(sections)
        {
            group(HR)
            {
                Caption = 'HR';
                Image = HumanResources;
                action(Employees)
                {
                    Image = Employee;
                    RunObject = Page "Employee List";
                    ApplicationArea = All;
                }
                action(Applicants)
                {
                    RunObject = Page "Applicant List";
                    ApplicationArea = All;
                }
            }
            group(Attendance)
            {
                Caption = 'Attendance';
                Image = Worksheets;
                action("Attendance ")
                {
                    RunObject = Page "Attendance List";
                    ApplicationArea = All;
                }
                action("Leave Request")
                {
                    RunObject = Page "Leave Request List";
                    ApplicationArea = All;
                }
                action("Employees Absence")
                {
                    RunObject = Page "Employee Absence Entitlement";
                    ApplicationArea = All;
                }
            }
            group(Payroll)
            {
                Caption = 'Payroll';
                Image = Journals;
                action("Raise Requests")
                {
                    RunObject = Page "Salary Raise Request List";
                    ApplicationArea = All;
                    Visible=false;
                }
                action("Employee Salary History")
                {
                    RunObject = Page "Employee Salary History";
                    ApplicationArea = All;
                }
                action("Loan List ")
                {
                    RunObject = Page "Loan List";
                    ApplicationArea = All;
                }
                action("Employee Dimensions ")
                {
                    RunObject = Page "Employee Dimensions";
                    ApplicationArea = All;
                }
                action("Pay Detail List")
                {
                    RunObject = Page "Pay Detail List";
                    ApplicationArea = All;
                }
                action("Payroll Ledger Entries")
                {
                    RunObject = Page "Payroll Ledger Entries";
                    ApplicationArea = All;
                }
                action("Pension Scheme List")
                {
                    Caption = 'Pension Scheme List';
                    RunObject = Page "Pension Scheme List";
                    ApplicationArea = All;
                }
            }
            group(Evaluation)
            {
                Visible = False;
                action("Evaluation List")
                {
                    RunObject = Page "Evaluation Data Main List";
                    ApplicationArea = All;
                }
                action("Evaluation Template List")
                {
                    RunObject = Page "Evaluation Template List";
                    ApplicationArea = All;
                }
            }
            group(Training)
            {
                action("Training List")
                {
                    RunObject = Page "Training List";
                    ApplicationArea = All;
                }
                action("Performance List")
                {
                    RunObject = Page "Performance List";
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        HRSetup: Record "Human Resources Setup";
        PurchQuote: Boolean;
}

