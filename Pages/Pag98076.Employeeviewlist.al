page 98076 "Employee view list"
{
    // version EDM.HRPY1

    PageType = List;
    SourceTable = Employee;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        //IF AssistEdit(xRec) THEN
                        //  CurrPage.UPDATE;
                    end;

                    trigger OnValidate();
                    begin

                        //Added in order to limit the size of the employee No. in order to reserve space in related tables for other fields - 27.07.2016 : AIM +
                        if STRLEN("No.") > 10 then
                            ERROR('Code can be of maximum 10 characters');
                        //Added in order to limit the size of the employee No. in order to reserve space in related tables for other fields - 27.07.2016 : AIM -
                    end;
                }
                field("First Name"; "First Name")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    Caption = 'Middle Name';
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Mother Name"; "Mother Name")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    ApplicationArea = All;
                }
                field("Search Name"; "Search Name")
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Birth Date"; "Birth Date")
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
                field("Second Nationality Code"; "Second Nationality Code")
                {
                    ApplicationArea = All;
                }
                field("Religion Code"; "Religion Code")
                {
                    ApplicationArea = All;
                }
                field(Initials; Initials)
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    Caption = 'Mobile No.';
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field(Building; Building)
                {
                    ApplicationArea = All;
                }
                field(Floor; Floor)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                }
                field("Emergency Contact"; "Emergency Contact")
                {
                    ApplicationArea = All;
                }
                field("Emergency Phone"; "Emergency Phone")
                {
                    ApplicationArea = All;
                }
                field("Company E-Mail"; "Company E-Mail")
                {
                    ApplicationArea = All;
                }
                field(Extension; Extension)
                {
                    Caption = 'Company Phone Extension';
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    Caption = 'Employment Date';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Employee Category Code"; "Employee Category Code")
                {
                    ApplicationArea = All;
                }
                field("End of Service Date"; "End of Service Date")
                {
                    ApplicationArea = All;
                }
                field("Employment Type Code"; "Employment Type Code")
                {
                    ApplicationArea = All;
                }
                field("Attendance No."; "Attendance No.")
                {
                    ApplicationArea = All;
                }
                field("AL Starting Date"; "AL Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Job Category"; "Job Category")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Job Position Code"; "Job Position Code")
                {
                    Caption = 'Job Position Code';
                    ApplicationArea = All;
                }
                field(Band; Band)
                {
                    ApplicationArea = All;
                }
                field(Grade; Grade)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Applicant No."; "Applicant No.")
                {
                    ApplicationArea = All;
                }
                field("Company Organization No."; "Company Organization No.")
                {
                    ApplicationArea = All;
                }
                field("Manager No."; "Manager No.")
                {
                    ApplicationArea = All;
                }
                field("Report Manager No."; "Report Manager No.")
                {
                    Caption = 'Reporting Manager No.';
                    ApplicationArea = All;
                }
                field("Termination Date"; "Termination Date")
                {
                    Caption = 'Termination Date';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Grounds for Term. Code"; "Grounds for Term. Code")
                {
                    ApplicationArea = All;
                }
                field("Inactive Date"; "Inactive Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Cause of Inactivity Code"; "Cause of Inactivity Code")
                {
                    ApplicationArea = All;
                }
                field("Government ID No."; "Government ID No.")
                {
                    Caption = 'Identity Card No.';
                    ApplicationArea = All;
                }
                field("Driving License"; "Driving License")
                {
                    Caption = 'Driving License No.';
                    ApplicationArea = All;
                }
                field("Driving License Type"; "Driving License Type")
                {
                    ApplicationArea = All;
                }
                field("Driving License Expiry Date"; "Driving License Expiry Date")
                {
                    ApplicationArea = All;
                }
                field(Period; Period)
                {
                    ApplicationArea = All;
                }
                field("HR Payroll Group Code"; "Payroll Group Code")
                {
                    Caption = 'HR Payroll Group Code';
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Declared; Declared)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
                field("Declare Date"; "Declaration Date")
                {
                    ApplicationArea = All;
                }
                field("Personal Finance No."; "Personal Finance No.")
                {
                    ApplicationArea = All;
                }
                field("NSSF Date"; "NSSF Date")
                {
                    ApplicationArea = All;
                }
                field("Social Security No."; "Social Security No.")
                {
                    Caption = 'NSSF No.';
                    ApplicationArea = All;
                }
                field("Previously NSSF Secured"; "Previously NSSF Secured")
                {
                    Caption = 'Previous Social Security Registration';
                    ApplicationArea = All;
                }
                field("Social Security Information"; "Social Security Information")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field(IsForeigner; IsForeigner)
                {
                    Caption = 'IsForeigner';
                    ApplicationArea = All;
                }
                field(Foreigner; Foreigner)
                {
                    ApplicationArea = All;
                }
                field("No Exempt"; "No Exempt")
                {
                    Caption = 'No Exemption';
                    ApplicationArea = All;
                }
                field("Don't Deserve Family Allowance"; "Don't Deserve Family Allowance")
                {
                    ApplicationArea = All;
                }
                field("Spouse Secured"; "Spouse Secured")
                {
                    Caption = 'Spouse / Husband Secured';
                    ApplicationArea = All;
                }
                field("Husband Paralyzed"; "Husband Paralyzed")
                {
                    Caption = 'Husband Paralyzed';
                    ApplicationArea = All;
                }
                field("Freeze Salary"; "Freeze Salary")
                {
                    ApplicationArea = All;
                }
                field("Basic Pay"; "Basic Pay")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Cost of Living"; "Cost of Living")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Salary (ACY)"; "Salary (ACY)")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Phone Allowance"; "Phone Allowance")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Car Allowance"; "Car Allowance")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("House Allowance"; "House Allowance")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Food Allowance"; "Food Allowance")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Ticket Allowance"; "Ticket Allowance")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Other Allowances"; "Other Allowances")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Insurance Contribution"; "Insurance Contribution")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Hourly Basis"; "Hourly Basis")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Hourly Rate"; "Hourly Rate")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Daily Rate"; "Daily Rate")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Pay Frequency"; "Pay Frequency")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Payment Method"; "Payment Method")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Bank No."; "Bank No.")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc Name"; "Emp. Bank Acc Name")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc No."; "Emp. Bank Acc No.")
                {
                    HideValue = Not ShowSalaryFld;
                    Editable = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Engineer Syndicate AL Fees"; "Engineer Syndicate AL Fees")
                {
                    ApplicationArea = All;
                }
                field("Eng Syndicate AL Pymt Date"; "Eng Syndicate AL Pymt Date")
                {
                    ApplicationArea = All;
                }
                field("Health Card No"; "Health Card No")
                {
                    ApplicationArea = All;
                }
                field("Health Insurance Company"; "Health Card Issue Place")
                {
                    Caption = 'Health Insurance Company';
                    ApplicationArea = All;
                }
                field("Health Card Issue Date"; "Health Card Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Health Card Expiry Date"; "Health Card Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Blood Type"; "Blood Type")
                {
                    ApplicationArea = All;
                }
                field("Chronic Disease"; "Chronic Disease")
                {
                    ApplicationArea = All;
                }
                field("Chronic Disease Details"; "Chronic Disease Details")
                {
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Other Health Information"; "Other Health Information")
                {
                    ApplicationArea = All;
                }
                field("Passport No."; "Passport No.")
                {
                    Caption = 'Passport No';
                    ApplicationArea = All;
                }
                field("Passport Issue Place"; "Passport Issue Place")
                {
                    Caption = 'Passport Issue Place';
                    ApplicationArea = All;
                }
                field("Passport Issue Date"; "Passport Issue Date")
                {
                    Caption = 'Passport Issue Date';
                    ApplicationArea = All;
                }
                field("Passport Expiry Date"; "Passport Expiry Date")
                {
                    Caption = 'Passport Expiry Date';
                    ApplicationArea = All;
                }
                field("Visa Number"; "Visa Number")
                {
                    ApplicationArea = All;
                }
                field("Resident No."; "Resident No.")
                {
                    Caption = 'Resident No';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Resident Issue Place"; "Resident Issue Place")
                {
                    Caption = 'Resident Issue Place';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Resident Issue Date"; "Resident Issue Date")
                {
                    Caption = 'Resident Issue Date';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Resident Expiry Date"; "Resident Expiry Date")
                {
                    Caption = 'Resident Expiry Date';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Work Permit No."; "Work Permit No.")
                {
                    Caption = 'Work Permit No';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Work Permit Issue Place"; "Work Permit Issue Place")
                {
                    Caption = 'Work Permit Issue Place';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Work Permit Issue Date"; "Work Permit Issue Date")
                {
                    Caption = 'Work Permit Issue Date';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Work Permit Expiry Date"; "Work Permit Expiry Date")
                {
                    Caption = 'Work Permit Expiry Date';
                    Enabled = true;
                    ApplicationArea = All;
                }
                field(QID; QID)
                {
                    ApplicationArea = All;
                }
                field("Arabic First Name"; "Arabic First Name")
                {
                    Caption = 'الإسم';
                    ApplicationArea = All;
                }
                field("Arabic Middle Name"; "Arabic Middle Name")
                {
                    Caption = 'إسم الأب';
                    ApplicationArea = All;
                }
                field("Arabic Last Name"; "Arabic Last Name")
                {
                    Caption = 'الشهرة';
                    ApplicationArea = All;
                }
                field("Arabic Mother Name"; "Arabic Mother Name")
                {
                    Caption = 'إسم الوالدة';
                    ApplicationArea = All;
                }
                field("Arabic Name"; "Arabic Name")
                {
                    Caption = 'الإسم الثلاثي';
                    ApplicationArea = All;
                }
                field("Arabic Place of Birth"; "Arabic Place of Birth")
                {
                    Caption = 'مكان الولادة';
                    ApplicationArea = All;
                }
                field("Arabic Nationality"; "Arabic Nationality")
                {
                    Caption = 'الجنسية';
                    ApplicationArea = All;
                }
                field("Arabic Governorate"; "Arabic Governorate")
                {
                    Caption = 'المحافظة';
                    ApplicationArea = All;
                }
                field("Arabic Elimination"; "Arabic Elimination")
                {
                    Caption = 'القضاء';
                    ApplicationArea = All;
                }
                field("Arabic City"; "Arabic City")
                {
                    Caption = 'المنطقة';
                    ApplicationArea = All;
                }
                field("Arabic District"; "Arabic District")
                {
                    Caption = 'الحي';
                    ApplicationArea = All;
                }
                field("Arabic Street"; "Arabic Street")
                {
                    Caption = 'الشارع';
                    ApplicationArea = All;
                }
                field("Arabic Building"; "Arabic Building")
                {
                    Caption = 'المبنى';
                    ApplicationArea = All;
                }
                field("Arabic Floor"; "Arabic Floor")
                {
                    Caption = 'الطابق';
                    ApplicationArea = All;
                }
                field("Arabic Land Area"; "Arabic Land Area")
                {
                    Caption = 'المنطقة العقارية';
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
                    ApplicationArea = All;
                }
                field("Arabic MailBox Area"; "Arabic MailBox Area")
                {
                    Caption = 'منطقة صندوق البريد';
                    ApplicationArea = All;
                }
                field("Register No."; "Register No.")
                {
                    Caption = 'رقم السجل';
                    ApplicationArea = All;
                }
                field("Arabic Registeration Place"; "Arabic Registeration Place")
                {
                    Caption = 'مكان السجل';
                    ApplicationArea = All;
                }
                field(Password; Password)
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
    begin
        if PayrollFunction.HideSalaryFields() = true then
            if PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' then
                ERROR('you do not have Permission for all group!');
        ShowSalaryFld := not PayrollFunction.HideSalaryFields();
        //Added in order to prevent opening the page but only for authorized users - 04.09.2017 : AIM +
        if PayrollFunction.CanOpenEmployeesCardPage(USERID) <> '' then begin
            ERROR(PayrollFunction.CanOpenEmployeesCardPage(USERID));
        end;
        //Added in order to prevent opening the page but only for authorized users - 04.09.2017 : AIM -        
    end;

    trigger OnAfterGetRecord();
    begin
        ShowSalaryFld := PayrollFunctions.CanUserAccessEmployeeSalary('', "No.");
    END;

    var
        PayParam: Record "Payroll Parameter";
        PayrollFunctions: Codeunit "Payroll Functions";
        ShowSalaryFld: Boolean;
        PayrollFunction: Codeunit "Payroll Functions";
}