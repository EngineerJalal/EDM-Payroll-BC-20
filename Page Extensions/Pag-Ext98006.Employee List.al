pageextension 98006 "ExtEmployeeList" extends "Employee List"
{
    layout
    {
        modify("No.")
        {
            Visible = true;
        }
        modify(FullName)
        {
            Visible = true;
        }
        modify("First Name")
        {
            Visible = true;
        }
        modify("Middle Name")
        {
            Visible = true;
        }
        modify("Last Name")
        {
            Visible = true;
        }
        modify(Initials)
        {
            Visible = false;
        }
        modify("Job Title")
        {
            Enabled = False;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify("Phone No.")
        {
            Visible = false;
        }
        modify(Extension)
        {
            Visible = true;
        }
        modify("Mobile Phone No.")
        {
            Visible = true;
        }
        modify("E-Mail")
        {
            Visible = true;
        }
        modify("Statistics Group Code")
        {
            Visible = false;
        }
        modify("Resource No.")
        {
            Visible = false;
        }
        /*modify ("Privacy Blocked")
        {
            Visible = true;
        }*/
        modify("Search Name")
        {
            Visible = true;
        }
        modify(Comment)
        {
            Visible = true;
        }

        addafter(Comment)
        {

            field("Attendance No."; Rec."Attendance No.")
            {
                ApplicationArea = All;
            }
            field("Full Name"; Rec."Full Name")
            {
                ApplicationArea = All;
            }
            field(Gender; Rec.Gender)
            {
                ApplicationArea = All;
            }
            field(Age; AgeVar)
            {
                ApplicationArea = All;
            }
            field("Social Status"; Rec."Social Status")
            {
                ApplicationArea = All;
            }
            field("First Nationality Code"; Rec."First Nationality Code")
            {
                ApplicationArea = All;
            }
            field("No of Children"; Rec."No of Children")
            {
                ApplicationArea = All;
            }
            field("No of Employee Relatives"; Rec."No of Employee Relatives")
            {
                ApplicationArea = All;
            }
            field("Employment Date"; Rec."Employment Date")
            {
                ApplicationArea = All;
            }
            field("Termination Date"; Rec."Termination Date")
            {
                ApplicationArea = All;
            }
            field("Birth Date"; Rec."Birth Date")
            {
                ApplicationArea = All;
            }
            field("Employee Category Code"; Rec."Employee Category Code")
            {
                ApplicationArea = All;
            }
            field("Employment Type Code"; Rec."Employment Type Code")
            {
                ApplicationArea = All;
            }
            field("Social Security No."; Rec."Social Security No.")
            {
                ApplicationArea = All;
            }
            field(Declared; Rec.Declared)
            {
                ApplicationArea = All;
            }
            field("Declaration Date"; Rec."Declaration Date")
            {
                ApplicationArea = All;
            }
            field("NSSF Date"; Rec."NSSF Date")
            {
                ApplicationArea = All;
            }
            field("Tax Status"; Rec."Tax Status")
            {
                ApplicationArea = All;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field("Last Date Modified"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
            }
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = All;
            }
            field("Payroll Group Code"; Rec."Payroll Group Code")
            {
                ApplicationArea = All;
            }
            field("Basic Pay"; Rec."Basic Pay")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Cost of Living"; "Cost of Living")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("Business Unit"; Rec."Business Unit")
            {
                ApplicationArea = All;
            }
            field("Related to"; Rec."Related to")
            {
                ApplicationArea = All;
            }
            field("Hourly Rate"; Rec."Hourly Rate")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Daily Rate"; Rec."Daily Rate")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Actual Service Years"; Rec."Actual Service Years")
            {
                ApplicationArea = All;
            }
            field(Address; Rec.Address)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Building; Rec.Building)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Floor; Rec.Floor)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Address 2"; Rec."Address 2")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Emergency Contact"; Rec."Emergency Contact")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Emergency Phone"; Rec."Emergency Phone")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Company E-Mail"; Rec."Company E-Mail")
            {
                Visible = true;
                ApplicationArea = All;
            }
            field("End of Service Date"; Rec."End of Service Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Job Category"; Rec."Job Category")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Band; Rec.Band)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Grade; Rec.Grade)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Applicant No."; Rec."Applicant No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Company Organization No."; Rec."Company Organization No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Manager No."; Rec."Manager No.")
            {
                Visible = TRUE;
                ApplicationArea = All;
            }
            field("Report Manager No."; Rec."Report Manager No.")
            {
                Visible = TRUE;
                ApplicationArea = All;
            }
            field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Inactive Date"; Rec."Inactive Date")
            {
                Editable = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Cause of Inactivity Code"; Rec."Cause of Inactivity Code")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Government ID No."; Rec."Government ID No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Driving License"; Rec."Driving License")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Driving License Type"; Rec."Driving License Type")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Driving License Expiry Date"; Rec."Driving License Expiry Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Period; Rec.Period)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Personal Finance No."; Rec."Personal Finance No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(IsForeigner; Rec.IsForeigner)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Foreigner; Rec.Foreigner)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("No Exempt"; Rec."No Exempt")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Exempt Tax"; "Exempt Tax")
            {
                ApplicationArea = All;

            }
            field("Don't Deserve Family Allowance"; Rec."Don't Deserve Family Allowance")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Spouse Secured"; Rec."Spouse Secured")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Husband Paralyzed"; Rec."Husband Paralyzed")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Freeze Salary"; Rec."Freeze Salary")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Phone Allowance"; Rec."Phone Allowance")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Car Allowance"; Rec."Car Allowance")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("House Allowance"; Rec."House Allowance")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Food Allowance"; Rec."Food Allowance")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Ticket Allowance"; Rec."Ticket Allowance")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Other Allowances"; Rec."Other Allowances")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Insurance Contribution"; Rec."Insurance Contribution")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Hourly Basis"; Rec."Hourly Basis")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Pay Frequency"; Rec."Pay Frequency")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Payment Method"; Rec."Payment Method")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Bank No."; Rec."Bank No.")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Emp. Bank Acc Name"; Rec."Emp. Bank Acc Name")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Emp. Bank Acc No."; Rec."Emp. Bank Acc No.")
            {
                hidevalue = Not ShowSalaryFld;
                ApplicationArea = All;
            }
            field("Engineer Syndicate AL Fees"; Rec."Engineer Syndicate AL Fees")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Eng Syndicate AL Pymt Date"; Rec."Eng Syndicate AL Pymt Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Health Card No"; Rec."Health Card No")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Health Card Issue Place"; Rec."Health Card Issue Place")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Health Card Issue Date"; Rec."Health Card Issue Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Health Card Expiry Date"; Rec."Health Card Expiry Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Blood Type"; Rec."Blood Type")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Chronic Disease"; Rec."Chronic Disease")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Chronic Disease Details"; Rec."Chronic Disease Details")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Other Health Information"; Rec."Other Health Information")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Passport No."; Rec."Passport No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Passport Issue Place"; Rec."Passport Issue Place")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Passport Issue Date"; Rec."Passport Issue Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Passport Expiry Date"; Rec."Passport Expiry Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Visa Number"; Rec."Visa Number")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Resident No."; Rec."Resident No.")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Resident Issue Place"; Rec."Resident Issue Place")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Resident Issue Date"; Rec."Resident Issue Date")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Resident Expiry Date"; Rec."Resident Expiry Date")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Work Permit No."; Rec."Work Permit No.")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Work Permit Issue Place"; Rec."Work Permit Issue Place")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Work Permit Issue Date"; Rec."Work Permit Issue Date")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Work Permit Expiry Date"; Rec."Work Permit Expiry Date")
            {
                Enabled = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Copy of Identification Card"; Rec."Copy of Identification Card")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Copy of Judiciary Record"; Rec."Copy of Judiciary Record")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Copy of Employment Contract"; Rec."Copy of Employment Contract")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Copy of Passport"; Rec."Copy of Passport")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Copy of Diplomas"; Rec."Copy of Diplomas")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Curriculum Vitae"; Rec."Curriculum Vitae")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Letters of Recommendations"; Rec."Letters of Recommendations")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Permission to practice prof."; Rec."Permission to practice prof.")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }

            field("Individual Civil Record"; Rec."Individual Civil Record")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Family Record"; Rec."Family Record")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Supervisor Evaluation Form"; Rec."Supervisor Evaluation Form")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Self Evaluation Form"; Rec."Self Evaluation Form")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }

            field("Residence Certificate"; Rec."Residence Certificate")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Driving Licenses"; Rec."Driving Licenses")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field("Position Request Form"; Rec."Position Request Form")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Employment Approval Form"; Rec."Employment Approval Form")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Job Application Form"; Rec."Job Application Form")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Pre-Hiring Interview Sheet"; Rec."Pre-Hiring Interview Sheet")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Engineering Syndicate Card"; Rec."Engineering Syndicate Card")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Application Photos"; Rec."Application Photos")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Employee Banking Form"; Rec."Employee Banking Form")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Proxy(Wakeleh)"; Rec."Proxy(Wakeleh)")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Terms Of Employment"; Rec."Terms Of Employment")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("last Work Permit"; Rec."last Work Permit")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Others; Rec.Others)
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
            field(Computer; Rec.Computer)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Chair; Rec.Chair)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Stationery; Rec.Stationery)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Extension phone number"; Rec."Extension phone number")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Email Signature"; Rec."Email Signature")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Business Cards"; Rec."Business Cards")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Network Logins"; Rec."Network Logins")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Server Access"; Rec."Server Access")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Office Regular Hours"; Rec."Office Regular Hours")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Code Of Conduct"; Rec."Code Of Conduct")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Employee HandBook"; Rec."Employee HandBook")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Finger Print"; Rec."Finger Print")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Parking Lod"; Rec."Parking Lod")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Employee To Staff Member"; Rec."Employee To Staff Member")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Send Welcoming Letter"; Rec."Send Welcoming Letter")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = All;
            }
            field("Bank Name (ACY)"; Rec."Bank Name (ACY)")
            {
                ApplicationArea = All;
            }
            field("Job Title Code"; Rec."Job Title Code")
            {
                ApplicationArea = All;
            }
            field("Job Title Description"; Rec."Job Title Description")
            {
                ApplicationArea = All;
            }
            field("Job Position Code"; Rec."Job Position Code")
            {
                ApplicationArea = All;
            }
            field("Job Position"; Rec."Job Position")
            {
                ApplicationArea = All;
            }
            field("Arabic First Name"; Rec."Arabic First Name")
            {
                ApplicationArea = All;
            }
            field("Arabic Middle Name"; Rec."Arabic Middle Name")
            {
                ApplicationArea = All;
            }
            field("Arabic Last Name"; Rec."Arabic Last Name")
            {
                ApplicationArea = All;
            }
            field("Arabic Mother Name"; Rec."Arabic Mother Name")
            {
                ApplicationArea = All;
            }
            field("Arabic Name"; Rec."Arabic Name")
            {
                ApplicationArea = All;
            }

            field("Arabic Job Title"; Rec."Arabic Job Title")
            {
                ApplicationArea = All;
            }
            field("Arabic Place of Birth"; Rec."Arabic Place of Birth")
            {
                ApplicationArea = All;
            }
            field("Arabic Nationality"; Rec."Arabic Nationality")
            {
                ApplicationArea = All;
            }
            field("Arabic Governorate"; Rec."Arabic Governorate")
            {
                ApplicationArea = All;
            }
            field("Arabic Elimination"; Rec."Arabic Elimination")
            {
                ApplicationArea = All;
            }
            field("Arabic City"; Rec."Arabic City")
            {
                ApplicationArea = All;
            }
            field("Arabic District"; Rec."Arabic District")
            {
                ApplicationArea = All;
            }
            field("Arabic Street"; Rec."Arabic Street")
            {
                ApplicationArea = All;
            }
            field("Arabic Building"; Rec."Arabic Building")
            {
                ApplicationArea = All;
            }
            field("Arabic Floor"; Rec."Arabic Floor")
            {
                ApplicationArea = All;
            }
            field("Arabic Land Area"; Rec."Arabic Land Area")
            {
                ApplicationArea = All;
            }
            field("Arabic Land Area  No."; Rec."Arabic Land Area  No.")
            {
                ApplicationArea = All;
            }
            field("Mailbox ID"; Rec."Mailbox ID")
            {
                ApplicationArea = All;
            }
            field("Arabic MailBox Area"; Rec."Arabic MailBox Area")
            {
                ApplicationArea = All;
            }
            field("Register No."; Rec."Register No.")
            {
                ApplicationArea = All;
            }
            field("Arabic Registeration Place"; Rec."Arabic Registeration Place")
            {
                ApplicationArea = All;
            }
        }
        addlast(FactBoxes)
        {
            part(Control; "Employee Picture")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        Modify("Co&mments")
        {
            Visible = false;
        }
        modify("&Picture")
        {
            Visible = false;
        }
        Modify(AlternativeAddresses)
        {
            Visible = false;
        }
        Modify("&Relatives")
        {
            Visible = false;
        }
        Modify("Mi&sc. Article Information")
        {
            Visible = false;
        }
        Modify("Co&nfidential Information")
        {
            Visible = false;
        }
        Modify("Q&ualifications")
        {
            Visible = false;
        }
        Modify("A&bsences")
        {
            Visible = false;
        }
        Modify("Absences by Ca&tegories")
        {
            Visible = false;
        }
        Modify("Misc. Articles &Overview")
        {
            Visible = false;
        }
        Modify("Con&fidential Info. Overview")
        {
            Visible = false;
        }
        Modify("Absence Registration")
        {
            Visible = false;
        }
        Modify("Ledger E&ntries")
        {
            Visible = false;
        }
        Modify(Dimensions)
        {
            Visible = false;
        }
        addafter("E&mployee")
        {
            group(Employee)
            {
                Caption = 'Employee';
                Visible = IsHROfficer;
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "HR Comment Sheet EDM";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Picture)
                {
                    Caption = 'Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Alternative Address")
                {
                    Caption = 'Alternative Addresses';
                    Image = AlternativeAddress;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action(Relatives)
                {
                    Caption = 'Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Employees Relatives")
                {
                    Caption = 'Employees Relatives';
                    Image = Relatives;
                    RunPageMode = View;
                    RunObject = Page "Employee Relatives";
                    ApplicationArea = All;
                }

                action("Misc. Article Information")
                {
                    Caption = 'Misc. Article Information';
                    Image = Info;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Confidential Information")
                {
                    Caption = 'Confidential Information';
                    Image = Info;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Qualifications)
                {
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Absences Entitlement")
                {
                    Caption = 'Absences Entitlement';
                    Visible = IsAttendanceOfficer;
                    Image = AbsenceCalendar;
                    RunObject = Page "Employee Absence Entitlement";
                    ApplicationArea = All;
                }
                action("Employee view list")
                {
                    Caption = 'Employees View List';
                    Visible = IsHROfficer and IsPayrollOfficer;
                    Image = Employee;
                    RunObject = Page "Employee view list";
                    ApplicationArea = All;
                }
                action("Probation Evaluation Sheet")
                {
                    Image = Evaluate;
                    Visible = IsEvaluationOfficer;
                    RunObject = Page "Probation Evaluation Sheet";
                    ApplicationArea = All;
                }
                action("New Hire Check List")
                {
                    visible = UseHiringCheckList;
                    Image = CheckList;
                    RunObject = Page "New Hire Check List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("IT Check List")
                {
                    visible = UseHiringCheckList;
                    Image = CheckList;
                    RunObject = Page "IT Check List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Absences by Categories")
                {
                    Caption = 'Absences by Categories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."), "Employee No. Filter" = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Misc. Articles Overview")
                {
                    Caption = 'Misc. Articles Overview';
                    RunObject = Page "Misc. Articles Overview";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Confidential Info. Overview")
                {
                    Caption = 'Confidential Info. Overview';
                    RunObject = Page "Confidential Info. Overview";
                    Visible = false;
                    ApplicationArea = All;
                }

                action("Work Ministry")
                {
                    Caption = 'Work Ministry';
                    Image = WorkCenter;
                    RunObject = Report "Rep Work Ministry";
                    ApplicationArea = All;
                }
                action("Cause of Attendance")
                {
                    Caption = 'Cause of Attendance';
                    Image = Absence;
                    RunObject = Report "Emp. Cause of Attendance Rpt";
                    Visible = true;
                    ApplicationArea = All;
                }
                action("Payroll Journals")
                {
                    Caption = 'Payroll Journals';
                    Image = Journals;
                    RunObject = Report "Emp. Payroll Journals Report";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Emp. Log History")
                {
                    Caption = 'Log History';
                    Image = Log;
                    Visible = false;
                    ApplicationArea = All;
                }
                action("General Employees")
                {
                    Caption = 'General Employees';
                    Image = Info;
                    RunObject = Report "Employee Personel Data";
                    ApplicationArea = All;
                }
                action("Certificate of Employment")
                {
                    Image = "Report";
                    RunObject = Report "Certificate of Employment";
                    ApplicationArea = All;
                }
                action("Certificate of Employment 2")
                {
                    Image = "Report";
                    RunObject = Report "Certificate of Employment 2";
                    ApplicationArea = All;
                }
                action("Renumber Emp No")
                {
                    Visible = false;
                    ApplicationArea = All;
                    trigger OnAction();
                    var
                        EmpNo: Code[10];
                        DimValue: Record "Dimension Value";
                    begin
                    end;
                }
                action("Employees Info")
                {
                    Image = "Report";
                    RunObject = Report "Employees Info";
                    ApplicationArea = All;
                }
                group(Statistics)
                {
                    Image = "Report";
                    action("Employees Hourly Rate Report")
                    {
                        Image = "Report";
                        //PromotedCategory = New;
                        RunObject = Report "Employees Hourly Rate";
                        Visible = true;
                        ApplicationArea = All;
                    }
                    action("ManPower Turnover")
                    {
                        Image = "Report";
                        RunObject = Report "ManPower Turnover";
                        ApplicationArea = All;
                    }
                    action("Absenteeism Index Report")
                    {
                        Image = "Report";
                        RunObject = Report "Absenteeism Index - Late Att";
                        ApplicationArea = All;
                    }
                    action("List of New Employees")
                    {
                        Image = "Report";
                        RunObject = Report "List of New Employee";
                        ApplicationArea = All;
                    }
                    action("List of Employees Terminated")
                    {
                        Image = "Report";
                        RunObject = Report "List of Employee Terminated";
                        ApplicationArea = All;
                    }
                    //  action("Send Dynamic Payslip By Email")
                    //     {
                    //         ApplicationArea = All;
                    //         Image = SendEmailPDF;
                    //         RunObject = Report "Dynamic-Payslip";
                    //     }
                }
            }

        }
    }
    trigger OnAfterGetRecord();
    var
        D: Integer;
        Y: Decimal;
    begin
        ShowSalaryFld := PayrollFunctions.CanUserAccessEmployeeSalary('', Rec."No.");

        if "Birth Date" = 0D then
            AgeVar := 0
        else begin
            D := WORKDATE - "Birth Date";
            if D <= 0 then
                AgeVar := 0
            else
                AgeVar := DATE2DMY(WORKDATE, 3) - DATE2DMY("Birth Date", 3);
        end;
    END;

    trigger OnOpenPage();
    begin
        IsHROfficer := PayrollFunctions.IsHROfficer(UserId);
        IsDataEntryOfficer := PayrollFunctions.IsDataEntryOfficer(Userid);
        IsPayrollOfficer := PayrollFunctions.IsPayrollOfficer(Userid);
        IsAttendanceOfficer := PayrollFunctions.IsAttendanceOfficer(Userid);
        IsEvaluationOfficer := PayrollFunctions.IsEvaluationOfficer(Userid);
        IF NOT (IsHROfficer or IsDataEntryOfficer or IsPayrollOfficer or IsAttendanceOfficer or IsEvaluationOfficer) then
            error('No Permission!');

        UseHiringCheckList := PayFunction.IsFeatureVisible('HiringCheckList');
    end;

    var
        PayrollFunctions: Codeunit "Payroll Functions";
        ShowSalaryFld: Boolean;
        UseHiringCheckList: Boolean;
        PayFunction: Codeunit "Payroll Functions";
        IsHROfficer: Boolean;
        IsDataEntryOfficer: Boolean;
        IsPayrollOfficer: Boolean;
        IsAttendanceOfficer: Boolean;
        IsEvaluationOfficer: Boolean;
        AgeVar: Decimal;
}