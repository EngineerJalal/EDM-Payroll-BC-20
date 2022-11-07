page 98063 "Loan List"
{
    // version PY1.0,EDM.HRPY1

    CardPageID = "Loan Card";
    DataCaptionFields = "Employee No.";
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    Permissions = TableData "Employee Loan" = rimd;
    SourceTable = "Employee Loan";
    SourceTableView = SORTING("Payroll Group Code");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Purpose)
                {
                    ApplicationArea = All;
                }
                field("Change Status"; "Change Status")
                {
                    Caption = 'Request Status';
                    Visible = IsChangeStatusVisible;
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (ACY)"; "Amount (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Date of Loan"; "Date of Loan")
                {
                    ApplicationArea = All;
                }
                field("Granted Date"; "Granted Date")
                {
                    ApplicationArea = All;
                }
                field("Loan Endging Date"; "Loan Endging Date")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Payments Made"; "Total Payments Made")
                {
                    ApplicationArea = All;
                }
                field(Completed; Completed)
                {
                    ApplicationArea = All;
                }
                field(LoanRemainingAmount; LoanRemainingAmount)
                {
                    Caption = 'Remaining Balance';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Remaining Balance (ACY)"; LoanRemainingAmountACY)
                {
                    Caption = 'Remaining Balance (ACY)';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    Caption = 'Balance Status';
                    Editable = false;
                    ExtendedDatatype = Ratio;
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("L&oan")
            {
                Caption = 'L&oan';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Loan Card";
                    RunPageLink = "Employee No." = FIELD("Employee No."), "Loan No." = FIELD("Loan No.");
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;
                }
            }
        }
        area(reporting)
        {
            action("Employee Loan Details")
            {
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Employee Loan Details";
                ApplicationArea = All;
            }
            action("Employee Loan Summary")
            {
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = All;
                //RunObject = Report Report70096;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        EmployeeLoanLine: Record "Employee Loan Line";
    begin
        //Added in order to refresh Loan Balance - 16.09.2016 : AIM +
        RefreshLoanBalanceInfo;
        //Added in order to refresh Loan Balance - 16.09.2016 : AIM -
        Clear(EmployeeLoanLine);
        EmployeeLoanLine.SetRange("Loan No.", "Loan No.");
        EmployeeLoanLine.SetRange("Employee No.", "Employee No.");
        IF EmployeeLoanLine.FindLast() then begin
            "Loan Endging Date" := EmployeeLoanLine."Payment Date";
            Modify();
        end;
    end;

    trigger OnOpenPage();
    begin
        PayrollOfficerPermission := PayrollFunction.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');
        // Added in order to show/ Hide salary fields - 28.09.2017 : A2 +
        if PayrollFunction.HideSalaryFields() then
            ERROR('Permission NOT Allowed!');
        // Added in order to show/ Hide salary fields - 28.09.2017 : A2 -

        //Added in order to refresh Loan Balance - 16.09.2016 : AIM +
        RefreshLoanBalanceInfo;
        //Added in order to refresh Loan Balance - 16.09.2016 : AIM -
        IF PayrollFunction.CheckLoanApprovalSystem THEN
            IsChangeStatusVisible := TRUE
        ELSE
            IsChangeStatusVisible := FALSE;
    end;

    var
        PayGroup: Record "HR Payroll Group";
        HRFunction: Codeunit "Human Resource Functions";
        LoanRemainingAmount: Decimal;
        Balance: Decimal;
        LoanRemainingAmountACY: Decimal;
        PayParam: Record "Payroll Parameter";
        PayrollFunction: Codeunit "Payroll Functions";
        IsChangeStatusVisible: Boolean;
        PayrollOfficerPermission: Boolean;

    local procedure RefreshLoanBalanceInfo();
    begin
        //28.052.2017 : A2+
        PayParam.GET;
        //28.052.2017 : A2-
        if "Loan No." <> '' then begin
            if Amount <> 0 then
                Balance := ROUND("Total Payments Made" / Amount * 10000, 1)
            else
                Balance := 0;
            LoanRemainingAmount := Amount - "Total Payments Made";
            //28.052.2017 : A2+
            IF PayParam."ACY Currency Rate" <> 0 then
                LoanRemainingAmountACY := (Amount - "Total Payments Made") / PayParam."ACY Currency Rate";
            //28.052.2017 : A2-
        end;
    end;
}

