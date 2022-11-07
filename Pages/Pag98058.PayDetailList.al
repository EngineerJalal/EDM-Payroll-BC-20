page 98058 "Pay Detail List"
{
    // version PY1.0,EDM.HRPY1

    DataCaptionFields = "Employee No.", "Payroll Ledger Entry No.";
    PageType = List;
    SourceTable = "Pay Detail Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Employee No."; "Employee No.")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Full Name"; FullName)
                {
                    Caption = 'Full Name';
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Payroll Ledger Entry No."; "Payroll Ledger Entry No.")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Open; Open)
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
                field("Pay Element Code"; "Pay Element Code")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Split Entries"; "Split Entries")
                {
                    Editable = EditLedger;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Calculated Amount"; "Calculated Amount")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Employer Amount"; "Employer Amount")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Payroll Group Code"; "Payroll Group Code")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Recurring; Recurring)
                {
                    Editable = EditLedger;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Sub Payroll Code"; "Sub Payroll Code")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Payroll Date"; "Payroll Date")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field("Payment Category"; "Payment Category")
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
                field(Declared; Declared)
                {
                    Editable = EditLedger;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if Employee.GET("Employee No.") then
            FullName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name"
    end;

    trigger OnInit();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if payrollfunction.HideSalaryFields() = true then
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
        Employee: Record Employee;
        FullName: Text[100];
        UserSetup: Record "User Setup";
        payrollfunction: Codeunit "Payroll Functions";
        PayrollOfficerPermission: Boolean;
        EditLedger: Boolean;
}

