page 98062 "Loan Card"
{
    // version PY1.0,EDM.HRPY1

    DataCaptionFields = "Employee No.";
    PageType = Card;
    Permissions = TableData "Employee Loan Line" = rimd;
    SourceTable = "Employee Loan";
    SourceTableView = SORTING("Payroll Group Code");

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Loan No."; "Loan No.")
                {
                    AssistEdit = true;
                    Editable = true;
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added as validation - 16.09.2016 : AIM +
                        if "Loan No." = '' then
                            ERROR('Enter Loan No');
                        //Added as validation - 16.09.2016 : AIM -
                        CurrPage.UPDATE;
                    end;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Purpose; Purpose)
                {
                    Caption = 'Purpose';
                    ApplicationArea = All;
                }
                field("Granted Date"; "Granted Date")
                {
                    ApplicationArea = All;
                }
                field("Date of Loan"; "Date of Loan")
                {
                    ApplicationArea = All;
                }
                field("In Additional Currency"; "In Additional Currency")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    Editable = AmountEditable;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2+
                        PayParam.GET;
                        IF PayParam."ACY Currency Rate" <> 0 then
                            "Amount (ACY)" := Amount / PayParam."ACY Currency Rate";
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2-
                        CurrPage.UPDATE;
                    end;
                }
                field("Amount (ACY)"; "Amount (ACY)")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2+
                        PayParam.GET;
                        IF PayParam."ACY Currency Rate" <> 0 then
                            Amount := "Amount (ACY)" * PayParam."ACY Currency Rate";
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2-
                        CurrPage.UPDATE;
                    end;
                }
                field("Monthly Amount"; "Monthly Amount")
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        Rec.VALIDATE("No. of Payments", Round((Amount / "Monthly Amount"), 1, '>'));
                        CurrPage.Control8.Page.Update();
                        IF "Monthly Amount" <> 0 then begin
                            InsertLoanLines;
                        end;
                    end;
                }
                field("No. of Payments"; "No. of Payments")
                {
                    Editable = "No. of PaymentsEditable";
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Payroll Group Code"; "Payroll Group Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Associated Pay Element"; "Associated Pay Element")
                {
                    ApplicationArea = All;
                }
            }
            group("Loan Lines")
            {
                Caption = 'Loan Lines';
                part(Control8; "Employee Loan SubForm")
                {
                    SubPageLink = "Employee No." = FIELD("Employee No."), "Loan No." = FIELD("Loan No.");
                    ApplicationArea = All;
                }
            }
            group("Loan Info")
            {
                Caption = 'Loan Info';
                field(Type; Type)
                {
                    Caption = 'Balance Status Type';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if Amount <> 0 then
                            Balance := ROUND("Total Payments Made" / Amount * 10000, 1)
                        else
                            Balance := 0;
                        if Type = Type::"Reducing Balance" then
                            Balance := 10000 - Balance;
                    end;
                }
                field(Balance; Balance)
                {
                    Caption = 'Balance Status';
                    ExtendedDatatype = Ratio;
                    ApplicationArea = All;
                }
                field(LoanRemainingAmount; LoanRemainingAmount)
                {
                    Caption = 'Remaining Balance';
                    ApplicationArea = All;
                }
                field(Completed; Completed)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("No. of Payments Made"; "No. of Payments Made")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Payments Made"; "Total Payments Made")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Payment; Payment)
                {
                    ApplicationArea = All;
                }
            }
            group("General Journal")
            {
                Caption = 'General Journal';
                Visible = false;
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Balance Account No"; "Balance Account No")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    Caption = 'Journal Template';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    Caption = 'Journal Batch';
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
                Caption = 'Loan';
                action("Close Loan")
                {
                    Caption = 'Close Loan';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if Completed then
                            ERROR('This loan is already closed.');

                        if CONFIRM('Do you wish to close this loan?', false) then begin
                            //EDM.IT+
                            EmployeeLoanLine.SETRANGE("Employee No.", "Employee No.");
                            EmployeeLoanLine.SETRANGE("Loan No.", "Loan No.");
                            EmployeeLoanLine.SETRANGE(Completed, false);
                            if EmployeeLoanLine.FINDFIRST then
                                repeat
                                    EmployeeLoanLine.DELETE;
                                until EmployeeLoanLine.NEXT = 0;

                            EmployeeLoanLine.RESET;
                            if EmployeeLoanLine.FINDLAST then
                                Identity := EmployeeLoanLine.ID
                            else
                                Identity := 0;

                            EmployeeLoanLine.RESET;
                            EmployeeLoanLine.INIT;
                            EmployeeLoanLine.ID := Identity + 1;
                            EmployeeLoanLine."Employee No." := "Employee No.";
                            EmployeeLoanLine."Loan No." := "Loan No.";
                            EmployeeLoanLine."Payment Number" := "No. of Payments Made" + 1;
                            EmployeeLoanLine."Payment Amount" := Amount - "Total Payments Made";
                            EmployeeLoanLine."Payment Date" := WORKDATE;
                            EmployeeLoanLine.Completed := true;
                            EmployeeLoanLine.INSERT(true);

                            //EDM.IT-
                            "No. of Payments Made" := "No. of Payments";
                            "Total Payments Made" := Amount;
                            Completed := true;
                            MODIFY;
                        end;
                    end;
                }
            }
        }
        area(processing)
        {
            action(Process)
            {
                Caption = 'Make General Journal';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    batch.RESET;
                    "Gen.Journal".RESET;
                    //Get the last General Journal
                    "Gen.Journal".SETRANGE("Gen.Journal"."Journal Template Name", "Journal Template Name");
                    "Gen.Journal".SETRANGE("Gen.Journal"."Journal Batch Name", "Journal Batch Name");

                    if "Gen.Journal".FINDLAST then;
                    var2 := "Gen.Journal"."Line No.";

                    batch.SETRANGE(batch."Journal Template Name", "Journal Template Name");
                    batch.SETRANGE(batch.Name, "Journal Batch Name");

                    if batch.FIND('-') then
                        "Gen.Journal".INIT;
                    "Gen.Journal"."Line No." := var2 + 1;
                    "Gen.Journal"."Journal Template Name" := "Journal Template Name";
                    "Gen.Journal"."Journal Batch Name" := "Journal Batch Name";
                    //Initialize the document No.
                    if batch."No. Series" <> '' then begin
                        CLEAR(NoSeriesMgt);
                        "Gen.Journal"."Document No." := NoSeriesMgt.TryGetNextNo(batch."No. Series", "Gen.Journal"."Posting Date");
                    end;

                    //+++
                    if DimensionValue.GET('EMPLOYEE', "Employee No.") then begin
                        v_DimensionNo := PayrollFunctions.GetDimensionNo('EMPLOYEE');
                        "Gen.Journal".ValidateShortcutDimCode(v_DimensionNo, "Employee No.")
                    end;
                    //--

                    "Gen.Journal".VALIDATE("Posting Date", "Date of Loan");
                    "Gen.Journal"."Document Type" := "Gen.Journal"."Document Type"::Payment;
                    "Gen.Journal"."Account Type" := "Gen.Journal"."Account Type"::"G/L Account";
                    if PayElement.GET("Associated Pay Element") then
                        "Gen.Journal".VALIDATE("Account No.", PayElement."Posting Account")
                    else
                        ERROR('you must specify Posting Account of the Loan');
                    "Gen.Journal".Description := 'Loan for ' + "Employee No.";
                    "Gen.Journal".VALIDATE(Amount, Amount);

                    if "Bal. Account Type" = 1 then
                        "Gen.Journal"."Bal. Account Type" := 3;
                    if "Bal. Account Type" = 0 then
                        "Gen.Journal"."Bal. Account Type" := 0;
                    "Gen.Journal"."Bal. Account No." := "Balance Account No";
                    "Gen.Journal".INSERT;
                    var2 := 0;
                    MESSAGE('The Loan has been entered as a record in the General Journal');
                end;
            }
            action("<Action12>")
            {
                Caption = 'Refresh';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        /*IF Amount <> 0 THEN
          Balance := ROUND("Total Payments Made" / Amount * 10000,1)
        ELSE
          Balance := 0;
        IF Type = Type::"Reducing Balance" THEN
          Balance := 10000 - Balance;
        
        IF NOT "Varying Loan" THEN BEGIN
          IF "No. of Payments Made" <> 0 THEN BEGIN
            AmountEditable := FALSE;
            "No. of PaymentsEditable" := FALSE
          END ELSE BEGIN
            AmountEditable := TRUE;
            "No. of PaymentsEditable" := TRUE
          END;
        END;
         */
        //Added in order to show remaining balance - 16.09.2016 : AIM +
        RefreshLoanBalanceInfo;
        //Added in order to show remaining balance - 16.09.2016 : AIM -

    end;

    trigger OnInit();
    begin
        "No. of PaymentsEditable" := true;
        AmountEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //EDM+
        HRSetup.GET;
        // added in order to Prevent show error on new record - 27.02.2017 : A2+
        if HRSetup."Loan No." <> '' then
            // added in order to Prevent show error on new record - 27.02.2017 : A2-
            "Loan No." := NoSeriesMgt.GetNextNo(HRSetup."Loan No.", WORKDATE, true);

        PayParam.GET();
        //Modified in order to take the Loan Pay Element by default - 01.06.2016 : AIM +
        //"Associated Pay Element" := PayParam."Advance on Salary";
        "Associated Pay Element" := PayParam.Loan;
        //Modified in order to take the Loan Pay Element by default - 01.06.2016 : AIM -

        "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
        //EDM-
    end;

    trigger OnOpenPage();
    var
        EmpLoanLine: Record "Employee Loan Line";
    begin
        PayrollOfficerPermission := PayrollFunctions.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            error('No Permission!');
        //Adding in order to set a default Balance Type on open - 16.09.2016 : AIM +
        Type := Type::"Accumulating Balance";
        RefreshLoanBalanceInfo;
        //Adding in order to set a default Balance Type on open - 16.09.2016 : AIM +
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        ValidateLoanData();
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    var
    begin
        CurrPage.Control8.Page.Update(true);
    end;
    var
        PayGroup: Record "HR Payroll Group";
        HRFunction: Codeunit "Human Resource Functions";
        Balance: Decimal;
        "Gen.Journal": Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Series: Record "No. Series";
        batch: Record "Gen. Journal Batch";
        var2: Decimal;
        PayElement: Record "Pay Element";
        [InDataSet]
        AmountEditable: Boolean;
        [InDataSet]
        "No. of PaymentsEditable": Boolean;
        HRSetup: Record "Human Resources Setup";
        PayParam: Record "Payroll Parameter";
        Difference: Decimal;
        EmployeeLoanLine: Record "Employee Loan Line";
        Identity: Integer;
        DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        v_DimensionNo: Integer;
        EmpLoanLineTbt: Record "Employee Loan Line";
        LoanRemainingAmount: Decimal;
        PayrollFunctions: Codeunit "Payroll Functions";
        PayrollOfficerPermission: Boolean;

    local procedure RefreshLoanBalanceInfo();
    begin
        if "Loan No." <> '' then begin

            "No. of Payments Made" := 0;
            "Total Payments Made" := 0;
            EmpLoanLineTbt.SETRANGE(EmpLoanLineTbt."Employee No.", "Employee No.");
            EmpLoanLineTbt.SETRANGE(EmpLoanLineTbt."Loan No.", "Loan No.");
            if EmpLoanLineTbt.FINDFIRST then
                repeat
                    if EmpLoanLineTbt.Completed = true then begin
                        "No. of Payments Made" := "No. of Payments Made" + 1;
                        "Total Payments Made" := "Total Payments Made" + EmpLoanLineTbt."Payment Amount";
                    end;
                until EmpLoanLineTbt.NEXT = 0;

            if Amount <> 0 then
                Balance := ROUND("Total Payments Made" / Amount * 10000, 1)
            else
                Balance := 0;
            LoanRemainingAmount := Amount - "Total Payments Made";
        end;
    end;

    local procedure ValidateLoanData();
    var
        EmpLoanLine: Record "Employee Loan Line";
        TotalLoan: Decimal;
    begin
        //EDM.IT+ Added New Request
        //Added as validation - 16.09.2016 : AIM +
        // added in order to Prevent show error on close - 27.02.2017 : A2+
        //IF "Loan No." <> '' THEN
        IF (("Loan No." <> '') AND ("Employee No." <> '') AND ("Date of Loan" <> 0D)) THEN
        // added in order to Prevent show error on close - 27.02.2017 : A2-
          BEGIN
            //Added as validation - 16.09.2016 : AIM -
            EmpLoanLine.SETRANGE("Employee No.", "Employee No.");
            EmpLoanLine.SETRANGE("Loan No.", "Loan No.");
            IF EmpLoanLine.FINDFIRST THEN
                REPEAT
                    TotalLoan := TotalLoan + EmpLoanLine."Payment Amount";
                UNTIL EmpLoanLine.NEXT = 0;
            if TotalLoan = 0 then
                exit;
            IF TotalLoan <> Amount THEN BEGIN
                //Modified in order to solve rounding problems - 02.08.2016 : AIM +
                //Difference:= Amount-TotalLoan;
                //ERROR('The Difference is '+FORMAT(Difference)+' Please Recheck the Balance');
                Difference := ROUND(Amount - TotalLoan, 0.01);
                IF Difference <> 0 THEN
                    ERROR('The Difference is ' + FORMAT(Difference) + ' Please Recheck the Balance');
                //Modified in order to solve rounding problems - 02.08.2016 : AIM -
            END;
            //EDM.IT-

            //Added in order to modify the TOTALS of loan - 02.08.2016 : AIM +
            "No. of Payments Made" := 0;
            "Total Payments Made" := 0;
            EmpLoanLineTbt.SETRANGE(EmpLoanLineTbt."Employee No.", "Employee No.");
            EmpLoanLineTbt.SETRANGE(EmpLoanLineTbt."Loan No.", "Loan No.");
            IF EmpLoanLineTbt.FINDFIRST THEN
                REPEAT
                    IF EmpLoanLineTbt.Completed = TRUE THEN BEGIN
                        "No. of Payments Made" := "No. of Payments Made" + 1;
                        "Total Payments Made" := "Total Payments Made" + EmpLoanLineTbt."Payment Amount";
                    END;
                UNTIL EmpLoanLineTbt.NEXT = 0;
            MODIFY;
            //Added in order to modify the TOTALS of loan - 02.08.2016 : AIM -
            //Added as validation - 16.09.2016 : AIM +
        END;
        //Added as validation - 16.09.2016 : AIM -
    end;

    local procedure InsertLoanLines()
    var
        EmployeeLoanLine: Record "Employee Loan Line";
        LineAmount: Decimal;
        IntLineAmount: Integer;
        LineAmountDiff: Decimal;
        i: Integer;
        Identity: Integer;
        PayParam: Record "Payroll Parameter";
        dateofloan: Date;
    begin
        Identity := 0;
        LineAmount := 0;
        IntLineAmount := 0;
        LineAmountDiff := 0;
        LineAmount := Amount / "Monthly Amount";
        IntLineAmount := LineAmount div 1;
        LineAmountDiff := LineAmount - IntLineAmount;
        dateofloan := "Date of Loan";
        FOR i := 1 to IntLineAmount do BEGIN
            Identity := Identity + 1;
            EmployeeLoanLine.Init();
            EmployeeLoanLine."Loan No." := "Loan No.";
            EmployeeLoanLine.Validate("Employee No.", "Employee No.");
            EmployeeLoanLine.ID := Identity;
            EmployeeLoanLine.Validate("Payment Amount", "Monthly Amount");
            PayParam.GET;
            IF PayParam."ACY Currency Rate" <> 0 then
                EmployeeLoanLine."Amount (ACY)" := "Monthly Amount" / PayParam."ACY Currency Rate";
            // Added in order to Show Amount in ACY - 24.02.2017 : A2+

            EmployeeLoanLine."Payment Date" := dateofloan;
            EmployeeLoanLine.Insert();
            dateofloan := CALCDATE('+1M', dateofloan);

        END;

        IF LineAmountDiff <> 0 then begin
            EmployeeLoanLine.Init();
            EmployeeLoanLine."Loan No." := "Loan No.";
            EmployeeLoanLine.Validate("Employee No.", "Employee No.");
            EmployeeLoanLine.ID := Identity + 1;
            EmployeeLoanLine.Insert();
            EmployeeLoanLine.Validate("Payment Amount", "Monthly Amount" * LineAmountDiff);
            PayParam.GET;
            IF PayParam."ACY Currency Rate" <> 0 then
                EmployeeLoanLine."Amount (ACY)" := ("Monthly Amount" * LineAmountDiff) / PayParam."ACY Currency Rate";
            EmployeeLoanLine."Payment Date" := dateofloan;
            EmployeeLoanLine.Modify();
        end;
    end;
}

