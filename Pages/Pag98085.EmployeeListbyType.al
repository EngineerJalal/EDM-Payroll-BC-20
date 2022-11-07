page 98085 "Employee List by Type"
{
    // version EDM.HRPY2

    Caption = 'Employee List';
    CardPageID = "Employee View By Type";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Attendance No."; "Attendance No.")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Employee Type"; "Employee Type")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Social Status"; "Social Status")
                {
                    ApplicationArea = All;
                }
                field("First Nationality Code"; "First Nationality Code")
                {
                    ApplicationArea = All;
                }
                field("No of Children"; "No of Children")
                {
                    Caption = 'No of Children declared';
                    ApplicationArea = All;
                }
                field("No of Employee Relatives"; "No of Employee Relatives")
                {
                    ApplicationArea = All;
                }
                field("Religion Code"; "Religion Code")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Termination Date"; "Termination Date")
                {
                    ApplicationArea = All;
                }
                field("Birth Date"; "Birth Date")
                {
                    ApplicationArea = All;
                }
                field("Employee Category Code"; "Employee Category Code")
                {
                    ApplicationArea = All;
                }
                field("Employment Type Code"; "Employment Type Code")
                {
                    ApplicationArea = All;
                }
                field("Social Security No."; "Social Security No.")
                {
                    ApplicationArea = All;
                }
                field(Declared; Declared)
                {
                    ApplicationArea = All;
                }
                field("Declaration Date"; "Declaration Date")
                {
                    ApplicationArea = All;
                }
                field("NSSF Date"; "NSSF Date")
                {
                    ApplicationArea = All;
                }
                field("Tax Status"; "Tax Status")
                {
                    ApplicationArea = All;
                }
                field(Initials; Initials)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Extension; Extension)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field("Statistics Group Code"; "Statistics Group Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Payroll Group Code"; "Payroll Group Code")
                {
                    ApplicationArea = All;
                }
                field("Basic Pay"; "Basic Pay")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Cost of Living"; "Cost of Living")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Resource No."; "Resource No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field("Related to"; "Related to")
                {
                    ApplicationArea = All;
                }
                field("Hourly Rate"; "Hourly Rate")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Daily Rate"; "Daily Rate")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Actual Service Years"; "Actual Service Years")
                {
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Building; Building)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Floor; Floor)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Emergency Contact"; "Emergency Contact")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Emergency Phone"; "Emergency Phone")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Company E-Mail"; "Company E-Mail")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("End of Service Date"; "End of Service Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Category"; "Job Category")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Position Code"; "Job Position Code")
                {
                    Caption = 'Job Position Code';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Band; Band)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Grade; Grade)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Applicant No."; "Applicant No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Company Organization No."; "Company Organization No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Manager No."; "Manager No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Report Manager No."; "Report Manager No.")
                {
                    Caption = 'Reporting Manager No.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Grounds for Term. Code"; "Grounds for Term. Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Inactive Date"; "Inactive Date")
                {
                    Editable = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Cause of Inactivity Code"; "Cause of Inactivity Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Government ID No."; "Government ID No.")
                {
                    Caption = 'Identity Card No.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Driving License"; "Driving License")
                {
                    Caption = 'Driving License No.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Driving License Type"; "Driving License Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Driving License Expiry Date"; "Driving License Expiry Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Period; Period)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Personal Finance No."; "Personal Finance No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(IsForeigner; IsForeigner)
                {
                    Caption = 'IsForeigner';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Foreigner; Foreigner)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("No Exempt"; "No Exempt")
                {
                    Caption = 'No Exemption';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Don't Deserve Family Allowance"; "Don't Deserve Family Allowance")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Spouse Secured"; "Spouse Secured")
                {
                    Caption = 'Spouse / Husband Secured';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Husband Paralyzed"; "Husband Paralyzed")
                {
                    Caption = 'Husband Paralyzed';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Freeze Salary"; "Freeze Salary")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Phone Allowance"; "Phone Allowance")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Car Allowance"; "Car Allowance")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("House Allowance"; "House Allowance")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Food Allowance"; "Food Allowance")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Ticket Allowance"; "Ticket Allowance")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Other Allowances"; "Other Allowances")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Insurance Contribution"; "Insurance Contribution")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Hourly Basis"; "Hourly Basis")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Pay Frequency"; "Pay Frequency")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Payment Method"; "Payment Method")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Bank No."; "Bank No.")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc Name"; "Emp. Bank Acc Name")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc No."; "Emp. Bank Acc No.")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Engineer Syndicate AL Fees"; "Engineer Syndicate AL Fees")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Eng Syndicate AL Pymt Date"; "Eng Syndicate AL Pymt Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Health Card No"; "Health Card No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Health Insurance Company"; "Health Card Issue Place")
                {
                    Caption = 'Health Insurance Company';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Health Card Issue Date"; "Health Card Issue Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Health Card Expiry Date"; "Health Card Expiry Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Blood Type"; "Blood Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Chronic Disease"; "Chronic Disease")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Chronic Disease Details"; "Chronic Disease Details")
                {
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Other Health Information"; "Other Health Information")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Passport No."; "Passport No.")
                {
                    Caption = 'Passport No';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Passport Issue Place"; "Passport Issue Place")
                {
                    Caption = 'Passport Issue Place';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Passport Issue Date"; "Passport Issue Date")
                {
                    Caption = 'Passport Issue Date';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Passport Expiry Date"; "Passport Expiry Date")
                {
                    Caption = 'Passport Expiry Date';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Visa Number"; "Visa Number")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Resident No."; "Resident No.")
                {
                    Caption = 'Resident No';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Resident Issue Place"; "Resident Issue Place")
                {
                    Caption = 'Resident Issue Place';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Resident Issue Date"; "Resident Issue Date")
                {
                    Caption = 'Resident Issue Date';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Resident Expiry Date"; "Resident Expiry Date")
                {
                    Caption = 'Resident Expiry Date';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Work Permit No."; "Work Permit No.")
                {
                    Caption = 'Work Permit No';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Work Permit Issue Place"; "Work Permit Issue Place")
                {
                    Caption = 'Work Permit Issue Place';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Work Permit Issue Date"; "Work Permit Issue Date")
                {
                    Caption = 'Work Permit Issue Date';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Work Permit Expiry Date"; "Work Permit Expiry Date")
                {
                    Caption = 'Work Permit Expiry Date';
                    Enabled = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(QID; QID)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic First Name"; "Arabic First Name")
                {
                    Caption = 'الإسم';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Middle Name"; "Arabic Middle Name")
                {
                    Caption = 'إسم الأب';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Last Name"; "Arabic Last Name")
                {
                    Caption = 'الشهرة';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Mother Name"; "Arabic Mother Name")
                {
                    Caption = 'إسم الوالدة';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Name"; "Arabic Name")
                {
                    Caption = 'الإسم الثلاثي';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Place of Birth"; "Arabic Place of Birth")
                {
                    Caption = 'مكان الولادة';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Nationality"; "Arabic Nationality")
                {
                    Caption = 'الجنسية';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Governorate"; "Arabic Governorate")
                {
                    Caption = 'المحافظة';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Elimination"; "Arabic Elimination")
                {
                    Caption = 'القضاء';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic City"; "Arabic City")
                {
                    Caption = 'المنطقة';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic District"; "Arabic District")
                {
                    Caption = 'الحي';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Street"; "Arabic Street")
                {
                    Caption = 'الشارع';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Building"; "Arabic Building")
                {
                    Caption = 'المبنى';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Floor"; "Arabic Floor")
                {
                    Caption = 'الطابق';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Land Area"; "Arabic Land Area")
                {
                    Caption = 'المنطقة العقارية';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Land Area  No."; "Arabic Land Area  No.")
                {
                    Caption = 'رقم العقار';
                    ApplicationArea = All;
                }
                field("Mailbox ID"; "Mailbox ID")
                {
                    Caption = 'رقم صندوق البريد';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic MailBox Area"; "Arabic MailBox Area")
                {
                    Caption = 'منطقة صندوق البريد';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Register No."; "Register No.")
                {
                    Caption = 'رقم السجل';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Registeration Place"; "Arabic Registeration Place")
                {
                    Caption = 'مكان السجل';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Identification Card"; "Copy of Identification Card")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Judiciary Record"; "Copy of Judiciary Record")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Employment Contract"; "Copy of Employment Contract")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Passport"; "Copy of Passport")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Diplomas"; "Copy of Diplomas")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Curriculum Vitae"; "Curriculum Vitae")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Letters of Recommendations"; "Letters of Recommendations")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Permission to practice prof."; "Permission to practice prof.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }

                field("Individual Civil Record"; "Individual Civil Record")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Family Record"; "Family Record")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Supervisor Evaluation Form"; "Supervisor Evaluation Form")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Self Evaluation Form"; "Self Evaluation Form")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }

                field("Residence Certificate"; "Residence Certificate")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Driving Licenses"; "Driving Licenses")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Position Request Form"; "Position Request Form")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employment Approval Form"; "Employment Approval Form")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Application Form"; "Job Application Form")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pre-Hiring Interview Sheet"; "Pre-Hiring Interview Sheet")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Engineering Syndicate Card"; "Engineering Syndicate Card")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Application Photos"; "Application Photos")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee Banking Form"; "Employee Banking Form")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Proxy(Wakeleh)"; "Proxy(Wakeleh)")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Terms Of Employment"; "Terms Of Employment")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("last Work Permit"; "last Work Permit")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Others; Others)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Computer; Computer)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Chair; Chair)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Stationery; Stationery)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Extension phone number"; "Extension phone number")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Email Signature"; "Email Signature")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Business Cards"; "Business Cards")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Network Logins"; "Network Logins")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Server Access"; "Server Access")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Office Regular Hours"; "Office Regular Hours")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Code Of Conduct"; "Code Of Conduct")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee HandBook"; "Employee HandBook")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Finger Print"; "Finger Print")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Parking Lod"; "Parking Lod")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee To Staff Member"; "Employee To Staff Member")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Send Welcoming Letter"; "Send Welcoming Letter")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            /*//Stopped by EDM.MM
            systempart(Control1000000015;"Employee Picture")
            {
                SubPageLink = "No."=FIELD("No.");
            }
            */
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
            group("E&mployee")
            {
                Caption = 'E&mployee';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "HR Comment Sheet EDM";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(5200), "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ApplicationArea = All;
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ApplicationArea = All;

                        trigger OnAction();
                        var
                            Employee: Record Employee;
                        begin
                            CurrPage.SETSELECTIONFILTER(Employee);
                            //DefaultDimMultiple.SetMultiEmployee(Employee);
                            //DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("&Alternative Addresses")
                {
                    Caption = '&Alternative Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Relatives")
                {
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    Image = Info;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Co&nfidential Information")
                {
                    Caption = 'Co&nfidential Information';
                    Image = Info;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Q&ualifications")
                {
                    Caption = 'Q&ualifications';
                    Image = QualificationOverview;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("<Action50>")
                {
                    Caption = 'A&bsences Entitlement';
                    Image = AbsenceCategory;
                    RunObject = Page "Employee Absence Entitlement";
                    ApplicationArea = All;
                }
                action("Employee View card")
                {
                    Image = Card;
                    RunObject = Page "Employee View Card";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Employees View List")
                {
                    Caption = 'Employees View List';
                    Image = ListPage;
                    RunObject = Page "Employee view list";
                    ApplicationArea = All;
                }
                separator(Separator51)
                {
                }
                action("Absences by Ca&tegories")
                {
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."), "Employee No. Filter" = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    RunObject = Page "Misc. Articles Overview";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Con&fidential Info. Overview")
                {
                    Caption = 'Con&fidential Info. Overview';
                    RunObject = Page "Confidential Info. Overview";
                    Visible = false;
                    ApplicationArea = All;
                }
                group("Importy Tool")
                {
                    Caption = 'Dimensions';
                    Visible = false;
                    action("Import Attendance")
                    {
                        Image = Import;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction();
                        begin
                            ImportTool.ImportAttendance;
                        end;
                    }
                    action("Import Benefit")
                    {
                        Image = Import;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction();
                        begin
                            ImportTool.ImportEmployeeJournalLine(1);
                        end;
                    }
                    action("Import Deduction")
                    {
                        Image = Import;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction();
                        begin
                            ImportTool.ImportEmployeeJournalLine(2);
                        end;
                    }
                }
                action("Rep Work Ministry")
                {
                    Image = "Report";
                    RunObject = Report "Rep Work Ministry";
                    ApplicationArea = All;
                }
                action("Emp. Cause of Attendance Rpt")
                {
                    Image = "Report";
                    RunObject = Report "Emp. Cause of Attendance Rpt";
                    Visible = true;
                    ApplicationArea = All;
                }
                action("Emp. Payroll Journals Report")
                {
                    Image = "Report";
                    RunObject = Report "Emp. Payroll Journals Report";
                    Visible = true;
                    ApplicationArea = All;
                }
                action("Emp. Log History")
                {
                    Image = "Report";
                    RunObject = Report "Advanced Dynamics Report";
                    ApplicationArea = All;
                }
                action("General Employees Report")
                {
                    Image = "Report";
                    RunObject = Report "Employee Personel Data";
                    ApplicationArea = All;
                }
                group("Payroll Reports")
                {
                    Caption = 'Payroll Reports';
                    Image = "Report";
                    action("Salary NSSF")
                    {
                        Image = "Report";
                        RunObject = Report "Salary NSSF 1";
                        ApplicationArea = All;
                    }
                    action("Salary Taxes")
                    {
                        Image = "Report";
                        RunObject = Report "Salary Taxes";
                        ApplicationArea = All;
                    }
                    action(Provision)
                    {
                        Image = "Report";
                        ApplicationArea = All;
                        //RunObject = Report Report70070;
                    }
                    action("Dynamic Summary")
                    {
                        Image = "Report";
                        RunObject = Report "Generate Shedule Dimension";
                        ApplicationArea = All;
                    }
                    action("Summary Payroll")
                    {
                        Image = "Report";
                        RunObject = Report "Summary Payroll";
                        ApplicationArea = All;
                    }
                    action("Salary NSSF Per Employee")
                    {
                        Image = "Report";
                        RunObject = Report "Salary NSSF 1";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Salary Taxes Per Employee")
                    {
                        Image = "Report";
                        RunObject = Report "Salary Taxes";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Employee Payroll by Period")
                    {
                        Image = "Report";
                        RunObject = Report "Salary Variance Report";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("EOS Provision Report")
                    {
                        Image = "Report";
                        RunObject = Report "EOS Provision Advanced";
                        ApplicationArea = All;
                    }
                }
                group("NSSF ")
                {
                    Caption = 'NSSF Reports';
                    Image = "Report";
                    action("تصريح عن استخدام اجير")
                    {
                        Image = "Report";
                        RunObject = Report "تصريح عن استخدام اجير";
                        ApplicationArea = All;
                    }
                    action("اعلام عن استخدام اجير")
                    {
                        Image = "Report";
                        RunObject = Report "اعلام عن استخدام اجير";
                        ApplicationArea = All;
                    }
                    action("تصريح ترك اجير عمله")
                    {
                        Image = "Report";
                        RunObject = Report "تصريح ترك اجير عمله";
                        ApplicationArea = All;
                    }
                    action("اعلام عن افراد العائلة")
                    {
                        Image = "Report";
                        //RunObject = Report Report70093;
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("تصريح عن الزوجة")
                    {
                        Image = "Report";
                        //RunObject = Report Report70094;
                        Visible = false;
                        ApplicationArea = All;
                    }
                }
                group("R Reports")
                {
                    Caption = 'R Reports';
                    Image = "Report";
                    action("R6 List")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R6 List";
                        ApplicationArea = All;
                    }
                    action("Payroll R3")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R3 New";
                        ApplicationArea = All;
                    }
                    action("Payroll R4-1")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R4 -1";
                        ApplicationArea = All;
                    }
                    action("Payroll R4")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R4";
                        ApplicationArea = All;
                    }
                    action("Payroll R5")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R5";
                        ApplicationArea = All;
                    }
                    action("Payroll R10")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R10";
                        ApplicationArea = All;
                    }
                    action("Payroll R7")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R7";
                        ApplicationArea = All;
                    }
                    action("Payroll R3-1")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll R3-1";
                        ApplicationArea = All;
                    }
                }
                group(Statistics)
                {
                    Image = "Report";
                    action("Employees Hourly Rate Report")
                    {
                        Image = "Report";
                        RunObject = Report "Employees Hourly Rate";
                        Visible = false;
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
                }
                action("Employees Documents")
                {
                    Image = Documents;
                    RunObject = Page "Requested Documents";
                    RunPageMode = View;
                    RunPageView = SORTING("No.", "Document Code", "Table Name", "Line No.") ORDER(Ascending) WHERE("No." = FILTER(<> ''));
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        RequestedDocument.SETFILTER("No.", '<>%1', '');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        ShowSalaryFld := not PayrollFunctions.HideSalaryFields();
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    var
        ImportTool: Codeunit "EDM Utility";
        ShowSalaryFld: Boolean;
        PayrollFunctions: Codeunit "Payroll Functions";
        RequestedDocument: Record "Requested Documents";
}

