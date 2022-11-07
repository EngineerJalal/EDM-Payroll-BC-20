page 98061 "Payroll Ledger Entries"
{
    // version PY1.0,EDM.HRPY1

    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Payroll Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("First Name"; "First Name")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Entry No."; "Entry No.")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Gross Pay"; "Gross Pay")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Taxable Pay"; "Taxable Pay")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Tax Paid"; "Tax Paid")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Employee Pension"; "Employee Pension")
                {
                    Editable = EditLedger;
                    Caption = '3% Employee Sickness';
                    ApplicationArea = All;
                }
                field("Net Pay"; "Net Pay")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Free Pay"; "Free Pay")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Employer Pension"; "Employer Pension")
                {
                    Editable = EditLedger;
                    Caption = 'Employer Pension';
                    ApplicationArea = All;
                }
                field("Pay Frequency"; "Pay Frequency")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Exempt Tax"; "Exempt Tax")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Tax Year"; "Tax Year")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Period; Period)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Payment Method"; "Payment Method")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Open; Open)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Current Year"; "Current Year")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payroll Group Code"; "Payroll Group Code")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                    Editable = EditLedger;
                    DecimalPlaces = 2 : 2;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Basic Salary"; "Basic Salary")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Taxable Allowances"; "Taxable Allowances")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Non-Taxable Deductions"; "Non-Taxable Deductions")
                {
                    Editable = EditLedger;
                    Caption = 'Non-Taxable Transport Deductions';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Family Allowance"; "Family Allowance")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Non-Taxable Allowances"; "Non-Taxable Allowances")
                {
                    Editable = EditLedger;
                    Caption = 'Non-Taxable Allowances - Transport + Fam. Allow.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee Loan"; "Employee Loan")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payroll Date"; "Payroll Date")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Outstanding Loan"; "Outstanding Loan")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Taxable Deductions"; "Taxable Deductions")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Period Start Date"; "Period Start Date")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Period End Date"; "Period End Date")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Foreigner; Foreigner)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Employment Type Code"; "Employment Type Code")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Social Status"; "Social Status")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Spouse Secured"; "Spouse Secured")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Husband Paralysed"; "Husband Paralysed")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Position Code"; "Job Position Code")
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Declared; Declared)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Sub Payroll Code"; "Sub Payroll Code")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Total Salary for NSSF"; "Total Salary for NSSF")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Payment Category"; "Payment Category")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ries")
            {
                Caption = 'Ent&ries';
                action("&Pay Details")
                {
                    Caption = '&Pay Details';
                    RunObject = Page "Pay Detail List";
                    RunPageLink = "Payroll Ledger Entry No." = FIELD("Entry No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if PayrollFunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    trigger OnOpenPage();
    begin
        PayrollOfficerPermission := PayrollFunction.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');
        //
        IF UserSetup.GET(USERID) THEN begin
            IF UserSetup."Allow Modify Payroll Ledger" THEN
                EditLedger := true
            ELSE
                EditLedger := false
        end;
    end;

    var
        UserSetup: Record "User Setup";
        PayrollFunction: Codeunit "Payroll Functions";
        PayrollOfficerPermission: Boolean;
        EditLedger: Boolean;
}

