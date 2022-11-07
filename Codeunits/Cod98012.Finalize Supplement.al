codeunit 98012 "Finalize Supplement"
{

    trigger OnRun();
    begin
    end;

    var
        PayParam: Record "Payroll Parameter";
        PayPostG: Record "Payroll Posting Group";
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        PensionScheme: Record "Pension Scheme";
        PayDetailLine: Record "Pay Detail Line";
        GenJnlLine: Record "Gen. Journal Line";
        PayDetailHeader: Record "Pay Detail Header";
        PayE: Record "Pay Element";
        LineNo: Integer;
        VAccountNo: Code[20];
        VCalcAmount: Decimal;
        VCurrencyCode: Code[10];
        PayrollNo: Code[10];
        PayrollTitle: Text[50];
        PayStatus: Record "Payroll Status";
        VBatchName: Code[10];
        Loop: Integer;
        TaxYear: Integer;
        PeriodNo: Integer;
        PayLedgEntryNo: Integer;
        PayDetFound: Boolean;
        PayLedgEntry: Record "Payroll Ledger Entry";
        VFinalize: Boolean;
        Window: Dialog;
        NoOfRecs: Integer;
        RecNo: Integer;
        FirstEntryNo: Integer;
        LastEntryNo: Integer;
        TempSplitPayDetLine: Record "Split Pay Detail Line" temporary;
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        VBatchNamePay: Code[10];
        PayrollElementPostingGroup: Record "Payroll Element Posting";
        PayDate: Date;
        GLSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Factor: Decimal;
        BankAcc: Record "Bank Account";
        AccountType: Option "G/L Account", Customer, Vendor, "Bank Account", "Fixed Asset", "IC Partner";
        GenJnl2AmountLCY: Decimal;
        PayrollFunctions: Codeunit "Payroll Functions";
        PayElementDesc: Text[100];
        GLAccountRec: Record "G/L Account";
        VendorRec: Record Vendor;

    local procedure SetupPayrollInfo();
    var
        StartDate: Date;
        EndDate: Date;
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        PayParam.GET;
        Day := DATE2DMY(PayStatus."Payroll Date", 1);
        Month := DATE2DMY(PayStatus."Payroll Date", 2);
        Year := DATE2DMY(PayStatus."Payroll Date", 3);
        TaxYear := Year;
        PayrollTitle := 'Week No. ';
        PeriodNo := DATE2DMY(PayStatus."Payroll Date", 2);
        case PayStatus."Pay Frequency" of
          PayStatus."Pay Frequency"::Weekly :
        begin
            PayrollNo := 'W';
        end;
        PayStatus."Pay Frequency"::Monthly :
        begin
            PayrollNo := 'M';
            PayrollTitle := 'Month No. ';
        end;
        end;
        PayrollNo := FORMAT(Year) + PayrollNo + FORMAT(PeriodNo);
        PayrollTitle := PayrollTitle + FORMAT(PeriodNo) + ' - ' + PayStatus."Payroll Group Code" + ' - ';
    end;

    procedure InsertGenJnlLine(P_AccountNo: Code[20]; P_BalAccountNo: Code[20]; P_CalcAmount: Decimal; P_CurrencyCode: Code[10]; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    var
        GenJnlLine2: Record "Gen. Journal Line";
        BatchName: Code[10];
        VDocNo: Code[20];
        Desc2: Text[120];
        v_DimensionNo: Integer;
        EmployeeDimensions: Record "Employee Dimensions";
        DefaultPayDate: Date;
        DefaultDocNo: Code[20];
        DefaultDesc: Text;
        L_PayLedgEntry: Record "Payroll Ledger Entry";
    begin
        PayParam.GET;
        if Sub_Payroll_Code <> '' then begin
            L_PayLedgEntry.RESET();
            CLEAR(L_PayLedgEntry);
            GLSetup.GET;

            L_PayLedgEntry.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
            if L_PayLedgEntry.FINDFIRST then begin
                DefaultPayDate := L_PayLedgEntry."Payroll Date";
                DefaultDocNo := L_PayLedgEntry."Document No.";
                DefaultDesc := L_PayLedgEntry.Description;
            end;
        end;
        EmployeeDimensions.SETRANGE("Employee No.", Employee."No.");
        if Sub_Payroll_Code = '' then
            EmployeeDimensions.SETRANGE("Payroll Date", PayDate)
        else
            EmployeeDimensions.SETRANGE("Payroll Date", DefaultPayDate);
        if EmployeeDimensions.FINDFIRST then begin
            repeat
            if P_CurrencyCode = '' then begin
                if(not VFinalize) or
                 ((VFinalize) and(not PayParam."Summary Payroll to GL Transfer")) then
                    VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20) //py1.2
                else
                    VDocNo := COPYSTR(PayrollNo, 1, 20);
                IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Batch Supplement" = '') OR
                 (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                    BatchName := PayParam."Journal Batch Supplement"
                else
                    BatchName := PayParam."Temp Batch Supplement";
                CLEAR(GenJnlLine2);
                GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
                if GenJnlLine2.FIND('+') then
                    LineNo := GenJnlLine2."Line No." + 10000
                else
                    LineNo := 10000;
            end else begin
                VDocNo := COPYSTR(PayrollNo + 'ACY' + '-' + Employee."No.", 1, 20);
                BatchName := PayParam."Journal Batch Name (ACY)";
                CLEAR(GenJnlLine2);
                GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
                if GenJnlLine2.FIND('+') then
                    LineNo := GenJnlLine2."Line No." + 10000
                else
                    LineNo := 10000;
            end;
            GenJnlLine2.INIT;
            GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name");
            GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
            GenJnlLine2."Line No." := LineNo;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Posting Date", PayDate)
            else
                GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
            GenJnlLine2."Source Code" := PayPostG."Source Code";
            GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
            GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document No.", VDocNo)
            else
                GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
            GenJnlLine2.VALIDATE("Currency Code", P_CurrencyCode);
            if P_BalAccountNo <> '' then begin
                GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
                GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
            end;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.Description := PayrollTitle
            else
                GenJnlLine2.Description := DefaultDesc;
            GenJnlLine2.Comment := PayElementDesc;
            if(not VFinalize) or
               ((VFinalize) and(not PayParam."Summary Payroll to GL Transfer")) then begin
                Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
                GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
                if not P_SplitEntry then begin
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
                end else begin
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");
                end;
            end;
            GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", EmployeeDimensions."Shortcut Dimension 1 Code");
            GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", EmployeeDimensions."Shortcut Dimension 2 Code");
            GenJnlLine2.ValidateShortcutDimCode(3, EmployeeDimensions."Shortcut Dimension 3 Code");
            GenJnlLine2.ValidateShortcutDimCode(4, EmployeeDimensions."Shortcut Dimension 4 Code");
            GenJnlLine2.ValidateShortcutDimCode(5, EmployeeDimensions."Shortcut Dimension 5 Code");
            GenJnlLine2.ValidateShortcutDimCode(6, EmployeeDimensions."Shortcut Dimension 6 Code");
            GenJnlLine2.ValidateShortcutDimCode(7, EmployeeDimensions."Shortcut Dimension 7 Code");
            GenJnlLine2.ValidateShortcutDimCode(8, EmployeeDimensions."Shortcut Dimension 8 Code");

            if PayE."Use Job" then begin
                GenJnlLine2.VALIDATE("Job No.", EmployeeDimensions."Job No.");
                GenJnlLine2.VALIDATE("Job Task No.", EmployeeDimensions."Job Task No.");
                GenJnlLine2.VALIDATE("Job Quantity", 1);
            end;
            GenJnlLine2.VALIDATE(GenJnlLine2.Comment, Employee."Full Name");

            GenJnlLine2.VALIDATE(Amount, P_CalcAmount * EmployeeDimensions.Percentage / 100);
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document Date", PayDate)
            else
                GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);

            if(PayParam."Use Payroll ACY Rate") and(PayParam."ACY Currency Rate" <> 0) then
                if GenJnlLine2."Currency Code" = '' then begin
                    GenJnl2AmountLCY := P_CalcAmount * (EmployeeDimensions.Percentage / 100);

                    GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                    case PayParam."ACY Exchange Operation" of
                    PayParam."ACY Exchange Operation"::Division :
                      GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY / PayParam."ACY Currency Rate");
                    PayParam."ACY Exchange Operation"::Multiplication :
                      GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * PayParam."ACY Currency Rate");
                    end;
                    if ROUND(GenJnl2AmountLCY, 0.01, '=') <> 0 then
                        GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY);
                    GenJnlLine2.ValidateShortcutDimCode(8, EmployeeDimensions."Shortcut Dimension 8 Code");
                end;
            GenJnlLine2.INSERT;
            until EmployeeDimensions.NEXT = 0;
        end
        else begin
            if P_CurrencyCode = '' then begin
                if(not VFinalize) or
                 ((VFinalize) and(not PayParam."Summary Payroll to GL Transfer")) then
                    VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20)
                else
                    VDocNo := COPYSTR(PayrollNo, 1, 20); 

                if(PayParam."Group By Dimension" = '') or
                 (PayParam."Temp Pay Batch Supplement" = '') or
                 (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
                    BatchName := PayParam."Journal Batch Supplement"
                else
                    BatchName := PayParam."Temp Batch Supplement";

                CLEAR(GenJnlLine2);
                GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
                if GenJnlLine2.FIND('+') then
                    LineNo := GenJnlLine2."Line No." + 10000
                else
                    LineNo := 10000;
            end else begin
                VDocNo := COPYSTR(PayrollNo + 'ACY' + '-' + Employee."No.", 1, 20); //py1.2;
                BatchName := PayParam."Journal Batch Name (ACY)";
                CLEAR(GenJnlLine2);
                GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
                if GenJnlLine2.FIND('+') then
                    LineNo := GenJnlLine2."Line No." + 10000
                else
                    LineNo := 10000;
            end; 
            GenJnlLine2.INIT;
            GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name");
            GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
            GenJnlLine2."Line No." := LineNo;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Posting Date", PayDate)
            else
                GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
            GenJnlLine2."Source Code" := PayPostG."Source Code";
            GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
            GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document No.", VDocNo)
            else
                GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
            GenJnlLine2.VALIDATE("Currency Code", P_CurrencyCode);
            if P_BalAccountNo <> '' then begin
                GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
                GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
            end;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.Description := PayrollTitle
            else
                GenJnlLine2.Description := DefaultDesc;
            GenJnlLine2.Comment := PayElementDesc;
            if(not VFinalize) or
               ((VFinalize) and(not PayParam."Summary Payroll to GL Transfer")) then begin
                Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
                GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
                if not P_SplitEntry then begin
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
                end else begin
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");

                end;
            end;
            if Employee."Related to" = '' then begin
                if DimensionValue.GET('EMPLOYEE', Employee."No.") then begin
                    v_DimensionNo := PayrollFunctions.GetDimensionNo('EMPLOYEE');
                    GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, Employee."No.");
                end;
            end else begin
                if DimensionValue.GET('EMPLOYEE', Employee."Related to") then begin
                    v_DimensionNo := PayrollFunctions.GetDimensionNo('EMPLOYEE');
                    GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, Employee."Related to");
                end;
            end;
            DefaultDimension.SETRANGE("Table ID", 5200);
            DefaultDimension.SETRANGE("No.", Employee."No.");
            if DefaultDimension.FINDFIRST then
                repeat
            v_DimensionNo := PayrollFunctions.GetDimensionNo(DefaultDimension."Dimension Code");
                if v_DimensionNo <> 0 then
                    GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, DefaultDimension."Dimension Value Code");
                until DefaultDimension.NEXT = 0;
            GenJnlLine2.VALIDATE(Amount, P_CalcAmount);
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document Date", PayDate)
            else
                GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
            if(PayParam."ACY Currency Rate" <> 0) and(PayParam."Use Payroll ACY Rate") then
                if GenJnlLine2."Currency Code" = '' then begin
                    GenJnl2AmountLCY := GenJnlLine2.Amount;
                    GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                    case PayParam."ACY Exchange Operation" of
                    PayParam."ACY Exchange Operation"::Division :
                      GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY / PayParam."ACY Currency Rate");
                    PayParam."ACY Exchange Operation"::Multiplication :
                      GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * PayParam."ACY Currency Rate");
                    end;
                    if ROUND(GenJnl2AmountLCY, 0.01, '=') <> 0 then
                        GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY);
                end;
            GenJnlLine2.INSERT;
        end;
    end;

    procedure InsertGenJnlLinePayWithDim(P_AccountNo: Code[20]; P_BalAccountNo: Code[20]; P_CalcAmount: Decimal; P_CurrencyCode: Code[10]; P_SplitEntry: Boolean; P_SummarizeGL: Boolean; AccountType: Option "G/L Account", Customer, Vendor, "Bank Account", "Fixed Asset", "IC Partner"; Sub_Payroll_Code: Code[20]);
    var
        GenJnlLine2: Record "Gen. Journal Line";
        BatchName: Code[10];
        VDocNo: Code[20];
        Desc2: Text[120];
        v_DimensionNo: Integer;
        EmployeeDimensions: Record "Employee Dimensions";
        PayLedgEntry: Record "Payroll Ledger Entry";
        DefaultPayDate: Date;
        DefaultDocNo: Code[20];
        DefaultDesc: Text;
    begin
        IF Sub_Payroll_Code <> '' THEN BEGIN
            PayLedgEntry.RESET();
            CLEAR(PayLedgEntry);
            GLSetup.GET;
            PayLedgEntry.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
            IF PayLedgEntry.FINDFIRST THEN BEGIN
                DefaultPayDate := PayLedgEntry."Payroll Date";
                DefaultDocNo := PayLedgEntry."Document No.";
                DefaultDesc := PayLedgEntry.Description;
            END;
        END;
        EmployeeDimensions.SETRANGE("Employee No.", Employee."No.");
        if Sub_Payroll_Code = '' then
            EmployeeDimensions.SETRANGE("Payroll Date", PayDate)
        else
            EmployeeDimensions.SETRANGE("Payroll Date", DefaultPayDate);
        if EmployeeDimensions.FINDFIRST then begin
            repeat
            if P_CurrencyCode = '' then begin
                if(not VFinalize) or
                 ((VFinalize) and(not P_SummarizeGL)) then
                    VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20) 
                else
                    VDocNo := COPYSTR(PayrollNo, 1, 20);
                IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Pay Batch Supplement" = '') OR
                   (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                BEGIN
                    IF NOT PayParam."Enable Payment Acc. Grouping" THEN
                        BatchName := PayParam."Journal Batch Supplement Pay"  
                END ELSE
                    BatchName := PayParam."Temp Pay Batch Supplement";
                CLEAR(GenJnlLine2);
                GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
                GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
                if GenJnlLine2.FIND('+') then
                    LineNo := GenJnlLine2."Line No." + 10000
                else
                    LineNo := 10000;
            end else begin
                VDocNo := COPYSTR(PayrollNo + 'ACY' + '-' + Employee."No.", 1, 20); //py1.2;
                BatchName := PayParam."Journal Batch Name (ACY)";
                CLEAR(GenJnlLine2);
                GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
                GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
                if GenJnlLine2.FIND('+') then
                    LineNo := GenJnlLine2."Line No." + 10000
                else
                    LineNo := 10000;
            end;

            GenJnlLine2.INIT;
            GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name Pay");
            GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
            GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
            GenJnlLine2."Line No." := LineNo;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Posting Date", PayStatus."Payroll Date")
            else
                GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
            GenJnlLine2."Source Code" := PayPostG."Source Code";
            if AccountType = AccountType::"Bank Account" then begin
                IF Employee."Payment Method" = Employee."Payment Method"::Cheque THEN
                    GenJnlLine2.VALIDATE("Payment Method Code", 'CHECK');
                IF(Employee."Payment Method" <> Employee."Payment Method"::Cash) AND(Employee."Bank No." <> '') THEN
                    BankAcc.GET(Employee."Bank No.")
                else
                    BankAcc.GET(P_AccountNo);
            end;
            GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
            GenJnlLine2."Account Type" := AccountType;
            if(Employee."Payment Method" <> Employee."Payment Method"::Cash)
                       and(Employee."Bank No." <> '') and(AccountType = AccountType::"Bank Account") then
                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.")
            else
                GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
            IF AccountType = AccountType::"Bank Account" THEN BEGIN
                IF(Employee."Payment Method" <> Employee."Payment Method"::Cash) AND(Employee."Bank No." <> '') THEN
                BEGIN
                    CASE Employee."Payment Method" OF
                    Employee."Payment Method"::Bank :
                      BankAcc.GET(Employee."Bank No.");
                    Employee."Payment Method"::Cheque :
                      BankAcc.GET(Employee."Bank No.");
                    Employee."Payment Method"::"G/LAccount" :
                      GLAccountRec.GET(Employee."Bank No.");
                    Employee."Payment Method"::Vendor :
                      VendorRec.GET(Employee."Bank No.");
                    END;
                END
                ELSE
                    BankAcc.GET(P_AccountNo);
            END;
            GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
            IF(Employee."Payment Method" <> Employee."Payment Method"::Cash) AND
               (Employee."Bank No." <> '') AND
               (AccountType = AccountType::"Bank Account") THEN
              BEGIN
                CASE Employee."Payment Method" OF
                  Employee."Payment Method"::Bank :
                BEGIN
                    GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                    GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                END;
                Employee."Payment Method"::Cheque :
                BEGIN
                    GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                    GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                END;
                Employee."Payment Method"::"G/LAccount" :
                BEGIN
                    GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
                    GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                END;
                Employee."Payment Method"::Vendor :
                BEGIN
                    GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::Vendor;
                    GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                END;
                END;
            END
            ELSE BEGIN
                GenJnlLine2."Account Type" := AccountType;
                GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
            END;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document No.", VDocNo)
            else
                GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
            if P_BalAccountNo <> '' then begin
                GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
                GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
            end;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.Description := PayrollTitle
            else
                GenJnlLine2.Description := DefaultDesc;
            if(not VFinalize) or
               ((VFinalize) and(not P_SummarizeGL)) then begin
                Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
                GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
                IF NOT P_SplitEntry THEN BEGIN
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
                END ELSE BEGIN
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");
                END;
            END;
            GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", EmployeeDimensions."Shortcut Dimension 1 Code");
            GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", EmployeeDimensions."Shortcut Dimension 2 Code");
            GenJnlLine2.ValidateShortcutDimCode(3, EmployeeDimensions."Shortcut Dimension 3 Code");
            GenJnlLine2.ValidateShortcutDimCode(4, EmployeeDimensions."Shortcut Dimension 4 Code");
            GenJnlLine2.ValidateShortcutDimCode(5, EmployeeDimensions."Shortcut Dimension 5 Code");
            GenJnlLine2.ValidateShortcutDimCode(6, EmployeeDimensions."Shortcut Dimension 6 Code");
            GenJnlLine2.ValidateShortcutDimCode(7, EmployeeDimensions."Shortcut Dimension 7 Code");
            GenJnlLine2.ValidateShortcutDimCode(8, EmployeeDimensions."Shortcut Dimension 8 Code");
            IF(GenJnlLine2."Account Type" = GenJnlLine2."Account Type"::"G/L Account") AND(GenJnlLine2."Currency Code" = '') THEN BEGIN
                IF(PayParam."ACY Currency Rate" <> 0) THEN BEGIN
                    GenJnl2AmountLCY := P_CalcAmount;
                    GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                    CASE PayParam."ACY Exchange Operation" OF
                      PayParam."ACY Exchange Operation"::Division :
                        GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * (EmployeeDimensions.Percentage / 100) / PayParam."ACY Currency Rate");
                    PayParam."ACY Exchange Operation"::Multiplication :
                        GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * (EmployeeDimensions.Percentage / 100) * PayParam."ACY Currency Rate");
                    END;
                    GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY * (EmployeeDimensions.Percentage / 100));
                END;
            END
            ELSE
          IF GenJnlLine2."Currency Code" = '' THEN
                    GenJnlLine2.VALIDATE(Amount, P_CalcAmount * EmployeeDimensions.Percentage / 100)
                ELSE IF(GenJnlLine2."Currency Code" = GLSetup."Additional Reporting Currency") AND(PayParam."ACY Currency Rate" > 0) THEN BEGIN
                        Factor := 1 / PayParam."ACY Currency Rate";
                        GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                                      GenJnlLine2."Currency Code", P_CalcAmount * (EmployeeDimensions.Percentage / 100), Factor));
                        GenJnlLine2.VALIDATE("Amount (LCY)", P_CalcAmount);
                    END
                    ELSE BEGIN
                        Factor := CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date", GenJnlLine2."Currency Code");
                        GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                           GenJnlLine2."Currency Code", P_CalcAmount * (EmployeeDimensions.Percentage / 100), Factor));
                    END;
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document Date", PayStatus."Payroll Date")
            else
                GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
            GenJnlLine2.VALIDATE(Comment, Employee."Full Name");
            GenJnlLine2.INSERT;
            until EmployeeDimensions.NEXT = 0;
        end else InsertGenJnlLinePay(P_AccountNo, P_BalAccountNo, P_CalcAmount, P_CurrencyCode, P_SplitEntry, P_SummarizeGL, AccountType,
                                     Sub_Payroll_Code);
        OnAfterInsertSupplementPayrollJournal(GenJnlLine2);
    end;

    procedure OnAfterInsertSupplementPayrollJournal(Var GenJnlLine: Record "Gen. Journal Line");
    begin
    end;

    procedure InsertGenJnlLinePay(P_AccountNo: Code[20]; P_BalAccountNo: Code[20]; P_CalcAmount: Decimal; P_CurrencyCode: Code[10]; P_SplitEntry: Boolean; P_SummarizeGL: Boolean; AccountType: Option "G/L Account", Customer, Vendor, "Bank Account", "Fixed Asset", "IC Partner"; Sub_Payroll_Code: Code[20]);
    var
        GenJnlLine2: Record "Gen. Journal Line";
        BatchName: Code[10];
        VDocNo: Code[20];
        Desc2: Text[120];
        v_DimensionNo: Integer;
        DefaultPayDate: Date;
        DefaultDocNo: Code[20];
        DefaultDesc: Text;
        L_PayLedgEntry: Record "Payroll Ledger Entry";
    begin
        GLSetup.GET;
        PayParam.GET;
        if Sub_Payroll_Code <> '' then begin
            L_PayLedgEntry.RESET();
            CLEAR(L_PayLedgEntry);
            L_PayLedgEntry.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
            if L_PayLedgEntry.FINDFIRST then begin
                DefaultPayDate := L_PayLedgEntry."Payroll Date";
                DefaultDocNo := L_PayLedgEntry."Document No.";
                DefaultDesc := L_PayLedgEntry.Description;
            end;
        end;
        if P_CurrencyCode = '' then begin
            if(not VFinalize) or
             ((VFinalize) and(not P_SummarizeGL)) then
                VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20)
            else
                VDocNo := COPYSTR(PayrollNo, 1, 20); 
            IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Pay Batch Supplement" = '')
              OR(PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                BatchName := PayParam."Journal Batch Supplement Pay"
            else
                BatchName := PayParam."Temp Pay Batch Supplement";
            CLEAR(GenJnlLine2);
            GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
            GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
            if GenJnlLine2.FIND('+') then
                LineNo := GenJnlLine2."Line No." + 10000
            else
                LineNo := 10000;
        end else begin
            VDocNo := COPYSTR(PayrollNo + 'ACY' + '-' + Employee."No.", 1, 20);
            BatchName := PayParam."Journal Batch Name (ACY)";
            CLEAR(GenJnlLine2);
            GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
            GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
            if GenJnlLine2.FIND('+') then
                LineNo := GenJnlLine2."Line No." + 10000
            else
                LineNo := 10000;
        end;
        GenJnlLine2.INIT;
        GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name Pay");
        GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
        GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
        GenJnlLine2."Line No." := LineNo;
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Posting Date", PayStatus."Payroll Date")
        else
            GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
        GenJnlLine2."Source Code" := PayPostG."Source Code";
        IF AccountType = AccountType::"Bank Account" THEN BEGIN
            IF(Employee."Payment Method" <> Employee."Payment Method"::Cash) AND(Employee."Bank No." <> '') THEN
            BEGIN
                CASE Employee."Payment Method" OF
                Employee."Payment Method"::Bank :
                  BankAcc.GET(Employee."Bank No.");
                Employee."Payment Method"::Cheque :
                  BankAcc.GET(Employee."Bank No.");
                Employee."Payment Method"::"G/LAccount" :
                  GLAccountRec.GET(Employee."Bank No.");
                Employee."Payment Method"::Vendor :
                  VendorRec.GET(Employee."Bank No.");
                END;
            END
            ELSE
                BankAcc.GET(P_AccountNo);
        END;
        GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
        GenJnlLine2."Account Type" := AccountType;
        IF(Employee."Payment Method" <> Employee."Payment Method"::Cash)
                   AND(Employee."Bank No." <> '') AND(AccountType = AccountType::"Bank Account") THEN
        BEGIN
            CASE Employee."Payment Method" OF
            Employee."Payment Method"::Bank :
            BEGIN
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
            END;
            Employee."Payment Method"::Cheque :
            BEGIN
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
            END;
            Employee."Payment Method"::"G/LAccount" :
            BEGIN
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
            END;
            Employee."Payment Method"::Vendor :
            BEGIN
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::Vendor;
                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
            END;
            END;
        END
        ELSE
            GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Document No.", VDocNo)
        else
            GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
        if P_BalAccountNo <> '' then begin
            GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
            GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
        end;
        if Sub_Payroll_Code = '' then
            GenJnlLine2.Description := PayrollTitle
        else
            GenJnlLine2.Description := DefaultDesc;
        if(not VFinalize) or
           ((VFinalize) and(not P_SummarizeGL)) then begin
            Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
            GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
            if not P_SplitEntry then begin
                GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
            end else begin
                GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");
            end;
        end;
        DefaultDimension.SETRANGE("Table ID", 5200);
        DefaultDimension.SETRANGE("No.", Employee."No.");
        if DefaultDimension.FINDFIRST then
            repeat
          v_DimensionNo := PayrollFunctions.GetDimensionNo(DefaultDimension."Dimension Code");
            if v_DimensionNo <> 0 then
                GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, DefaultDimension."Dimension Value Code");
            until DefaultDimension.NEXT = 0;
        if(GenJnlLine2."Account Type" = GenJnlLine2."Account Type"::"G/L Account") and(GenJnlLine2."Currency Code" = '') then begin
            if(PayParam."ACY Currency Rate" <> 0) and(PayParam."Use Payroll ACY Rate") then
            begin
                GenJnl2AmountLCY := P_CalcAmount;
                GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                case PayParam."ACY Exchange Operation" of
                  PayParam."ACY Exchange Operation"::Division :
                    GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY / PayParam."ACY Currency Rate");
                PayParam."ACY Exchange Operation"::Multiplication :
                    GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * PayParam."ACY Currency Rate");
                end;
                GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY);
            END ELSE BEGIN
                if GenJnlLine2."Currency Code" = '' then
                    GenJnlLine2.VALIDATE(Amount, P_CalcAmount)
            end;
        END ELSE BEGIN
            if(GenJnlLine2."Currency Code" = GLSetup."Additional Reporting Currency") and(PayParam."ACY Currency Rate" > 0) and(PayParam."Use Payroll ACY Rate") then
            begin
                Factor := 1 / PayParam."ACY Currency Rate";
                GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                             GenJnlLine2."Currency Code", P_CalcAmount, Factor));
                GenJnlLine2.VALIDATE("Amount (LCY)", P_CalcAmount);
            END ELSE BEGIN
                Factor := CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date", GenJnlLine2."Currency Code");
                GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                           GenJnlLine2."Currency Code", P_CalcAmount, Factor));
            end;
        end;
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Document Date", PayStatus."Payroll Date")
        else
            GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
        GenJnlLine2.VALIDATE(Comment, Employee."Full Name");
        GenJnlLine2.INSERT;
        OnAfterInsertSupplementPayrollJournal(GenJnlLine2);
    end;

    procedure ProcessCostNetAccounts(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    var
        PayElement: Record "Pay Element";
    begin
        Loop := 1;
        while Loop <= 2 do
        begin
            if Loop = 1 then begin
                VCurrencyCode := '';
                if PayParam."Group By Dimension" = '' then
                    VBatchName := PayParam."Journal Batch Supplement"
                else
                    VBatchName := PayParam."Temp Batch Supplement";
                if P_CostNet = 'COST' then begin
                    PayElementDesc := '';
                    PayElement.RESET;
                    PayElement.SETRANGE(Code, PayE.Code);
                    IF PayElement.FINDFIRST THEN
                        PayElementDesc := PayElement.Description;

                    VCalcAmount := P_CalcAmtLCY;

                    PayrollElementPostingGroup.SETRANGE("Payroll Posting Group", PayPostG.Code);
                    PayrollElementPostingGroup.SETRANGE("Pay Element", PayE.Code);
                    if PayrollElementPostingGroup.FINDFIRST then
                        VAccountNo := PayrollElementPostingGroup."Posting Account"
                    else
                        VAccountNo := PayE."Posting Account";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Cost of Payroll Account";
                end else begin
                    PayElementDesc := ''; 
                    VCalcAmount := P_CalcAmtLCY;
                    VAccountNo := PayPostG."Net Pay Account";
                end;
            end else begin
                VCurrencyCode := HumanResSetup."Additional Currency Code";
                VBatchName := PayParam."Journal Batch Name (ACY)";
                if P_CostNet = 'COST' then begin
                    VCalcAmount := P_CalcAmtACY;
                    VAccountNo := PayE."Posting Account (ACY)";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Cost of Payroll Account (ACY)";
                end else begin
                    VCalcAmount := P_CalcAmtACY;
                    VAccountNo := PayPostG."Net Pay Account (ACY)";
                end;
            end;
            if(P_CostNet = 'COST') and(PayE.Type = PayE.Type::Deduction) then
                VCalcAmount := VCalcAmount * (-1);
            if P_CostNet = 'NET' then
                VCalcAmount := VCalcAmount * (-1);
            if VCalcAmount <> 0 then begin
                if VFinalize = true then begin
                    if PayParam."Summary Payroll to GL Transfer" then begin
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", VBatchName);
                        GenJnlLine.SETRANGE("Account No.", VAccountNo);
                        if GenJnlLine.FIND('-') then begin
                            GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + VCalcAmount);
                            GenJnlLine.MODIFY;
                        end else
                            InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                    end else
                        InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                end else
                    InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
            end;
            Loop := Loop + 1;
        end;
    end;

    procedure ProcessCostNetAccountsRound(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    begin
        Loop := 1;
        while Loop <= 2 do
        begin
            if Loop = 1 then begin
                VCurrencyCode := '';
                VBatchName := PayParam."Temp Batch Supplement"; 
                if P_CostNet = 'COST' then begin
                    VCalcAmount := P_CalcAmtLCY;

                    PayrollElementPostingGroup.SETRANGE("Payroll Posting Group", PayPostG.Code);
                    PayrollElementPostingGroup.SETRANGE("Pay Element", PayE.Code);
                    if PayrollElementPostingGroup.FINDFIRST then
                        VAccountNo := PayrollElementPostingGroup."Posting Account"
                    else
                        VAccountNo := PayE."Posting Account";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Rounding Account";
                end else begin
                    VCalcAmount := P_CalcAmtLCY;
                    VAccountNo := PayPostG."Rounding Account";
                end;
            end else begin
                VCurrencyCode := HumanResSetup."Additional Currency Code";
                VBatchName := PayParam."Journal Batch Name (ACY)";
                if P_CostNet = 'COST' then begin
                    VCalcAmount := P_CalcAmtACY;
                    VAccountNo := PayE."Posting Account (ACY)";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Cost of Payroll Account (ACY)";
                end else begin
                    VCalcAmount := P_CalcAmtACY;
                    VAccountNo := PayPostG."Net Pay Account (ACY)";
                end;
            end;
            if(P_CostNet = 'COST') and(PayE.Type = PayE.Type::Deduction) then
                VCalcAmount := VCalcAmount * (-1);
            if P_CostNet = 'NET' then
                VCalcAmount := VCalcAmount * (-1);
            if VCalcAmount <> 0 then begin
                if VFinalize = true then begin
                    if PayParam."Summary Payroll to GL Transfer" then begin //summary
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", VBatchName);
                        GenJnlLine.SETRANGE("Account No.", VAccountNo);
                        if GenJnlLine.FIND('-') then begin
                            GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + VCalcAmount);
                            GenJnlLine.MODIFY;
                        end else
                            InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                    end else
                        InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                end else
                    InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
            end;
            Loop := Loop + 1;
        end;
    end;

    procedure ProcessCostNetAccountsPay(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    begin
        Loop := 1;
        while Loop <= 2 do
        begin
            if Loop = 1 then begin
                VCurrencyCode := '';
                IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Pay Batch Supplement" = '') OR
                 (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                    VBatchNamePay := PayParam."Journal Batch Supplement Pay"
                else
                    VBatchNamePay := PayParam."Temp Pay Batch Supplement";

                if P_CostNet = 'COST' then begin
                    VCalcAmount := P_CalcAmtLCY;
                    PayrollElementPostingGroup.SETRANGE("Payroll Posting Group", PayPostG.Code);
                    PayrollElementPostingGroup.SETRANGE("Pay Element", PayE.Code);
                    if PayrollElementPostingGroup.FINDFIRST then
                        VAccountNo := PayrollElementPostingGroup."Posting Account"
                    else
                        VAccountNo := PayE."Posting Account";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Cost of Payroll Account";
                end else begin
                    VCalcAmount := P_CalcAmtLCY;
                    VAccountNo := PayPostG."Net Pay Account";
                end;
            end else begin
                VCurrencyCode := HumanResSetup."Additional Currency Code";
                VBatchName := PayParam."Journal Batch Name (ACY)";
                if P_CostNet = 'COST' then begin
                    VCalcAmount := P_CalcAmtACY;
                    VAccountNo := PayE."Posting Account (ACY)";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Cost of Payroll Account (ACY)";
                end else begin
                    VCalcAmount := P_CalcAmtACY;
                    VAccountNo := PayPostG."Net Pay Account (ACY)";
                end;
            end;
            if(P_CostNet = 'COST') and(PayE.Type = PayE.Type::Deduction) then
                VCalcAmount := VCalcAmount;
            if P_CostNet = 'NET' then
                VCalcAmount := VCalcAmount;
            if VCalcAmount <> 0 then begin
                if VFinalize = true then begin
                    if PayParam."Summary Payroll to GL Transfer" then begin
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", VBatchNamePay);
                        GenJnlLine.SETRANGE("Account No.", VAccountNo);
                        if GenJnlLine.FIND('-') then begin
                            GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + VCalcAmount);
                            GenJnlLine.MODIFY;
                        end else
                            InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                    end else
                        InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                end else 
                    InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
            end;
            Loop := Loop + 1;
        end; 
    end;

    procedure CreateNewPayDetails();
    var
        PayDetailLine2: Record "Pay Detail Line";
        NewPayDetailLine: Record "Pay Detail Line";
        SplitPayDetailLine: Record "Split Pay Detail Line";
    begin
        PayDetailLine.RESET;
        PayDetailLine.SETCURRENTKEY("Employee No.", "Tax Year", "Pay Frequency", Period, "Pay Element Code", Recurring);
        PayDetailLine.SETRANGE("Employee No.", Employee."No.");
        PayDetailLine.SETRANGE("Tax Year", TaxYear);
        PayDetailLine.SETRANGE("Pay Frequency", Employee."Pay Frequency");
        PayDetailLine.SETRANGE(Period, PeriodNo);
        PayDetailLine.SETRANGE(Open, true);
        if PayDetailLine.FIND('-') then
            repeat
            if PayDetailLine.Recurring then begin
                NewPayDetailLine.INIT;
                NewPayDetailLine.COPY(PayDetailLine);
                PayDetailLine2.RESET;
                PayDetailLine2.SETRANGE("Employee No.", Employee."No.");
                if PayDetailLine2.FIND('+') then
                    NewPayDetailLine."Line No." := PayDetailLine2."Line No." + 10000
                else
                    NewPayDetailLine."Line No." := 10000;
                NewPayDetailLine.Amount := PayDetailLine.Amount;
                NewPayDetailLine."Amount (ACY)" := PayDetailLine."Amount (ACY)";
                NewPayDetailLine."Calculated Amount" := 0;
                NewPayDetailLine."Calculated Amount (ACY)" := 0;
                NewPayDetailLine."Efective Nb. of Days" := 0;
                NewPayDetailLine."Payroll Ledger Entry No." := 0;
                NewPayDetailLine."Tax Year" := 0;
                NewPayDetailLine.Period := 0;
                NewPayDetailLine."Payroll Date" := 0D;
                NewPayDetailLine.Open := true;
                NewPayDetailLine."Not Included in Net Pay" := false;
                NewPayDetailLine.INSERT;
            end;
            SplitPayDetailLine.RESET;
            SplitPayDetailLine.SETRANGE("Employee No.", PayDetailLine."Employee No.");
            SplitPayDetailLine.SETRANGE("Pay Detail Line No.", PayDetailLine."Line No.");
            SplitPayDetailLine.MODIFYALL(Open, false);
            SplitPayDetailLine.MODIFYALL("Posting Date", PayStatus."Payroll Date");
            PayDetailLine.Open := false;
            PayDetailLine.MODIFY;
            until PayDetailLine.NEXT = 0;
    end;

    procedure ProcessBankAccount(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    begin
        VCalcAmount := P_CalcAmtLCY;
        VAccountNo := PayPostG."Bank Pay Account";
        if VFinalize = true then begin
            if PayParam."Summary Payroll to GL Transfer" then begin
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", VBatchName);
                GenJnlLine.SETRANGE("Account No.", VAccountNo);
                if GenJnlLine.FIND('-') then begin
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE(Amount, (GenJnlLine.Amount + VCalcAmount));
                    GenJnlLine.MODIFY;
                end else
                    InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
            end else
                InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
        end else
            InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
    end;

    procedure PostPayRegister();
    var
        PayReg: Record "Payroll Register";
        NextEntryNo: Integer;
    begin
        PayReg.LOCKTABLE;
        if PayReg.FIND('+') then
            NextEntryNo := PayReg."No." + 1
        else
            NextEntryNo := 1;

        PayReg.INIT;
        PayReg."No." := NextEntryNo;
        PayReg."From Entry No." := FirstEntryNo;
        PayReg."To Entry No." := LastEntryNo;
        PayReg."Creation Date" := TODAY;
        PayReg."Source Code" := PayPostG."Source Code";
        PayReg."Payroll Group Code" := PayStatus."Payroll Group Code";
        PayReg."User ID" := USERID;
        PayReg.INSERT;
    end;

    procedure FinalizeEmployeePay(PayStatusRec: Record "Payroll Status"; P_Finalize: Boolean; Sub_Payroll_Code: Code[20]; AutoFixEmpDim: Boolean);
    var
        MyEmployee: Record Employee;
        MyPayrollLedgerEntry: Record "Payroll Ledger Entry";
        PayDetailLineRec: Record "Pay Detail Line";
        SumofAddition: Decimal;
        SumofDeduction: Decimal;
        EmpCalculatePay: Codeunit "Calculate Employee Pay";
        PayrollFunction: Codeunit "Payroll Functions";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLineDoc: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        PayElement: Record "Pay Element";
    begin
        MyEmployee.RESET;
        MyEmployee.SETFILTER("Termination Date", '<> %1', 0D);
        MyEmployee.SETRANGE(Status, MyEmployee.Status::Active);
        if MyEmployee.FIND('-') then
            repeat
            MyPayrollLedgerEntry.SETCURRENTKEY("Employee No.", "Posting Date", "Period Start Date", "Period End Date");
            MyPayrollLedgerEntry.SETRANGE("Employee No.", MyEmployee."No.");
            MyPayrollLedgerEntry.SETFILTER("Period Start Date", '%1..', (MyEmployee."Termination Date" + 1));
            MyPayrollLedgerEntry.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
            if MyPayrollLedgerEntry.FIND('-') then
                MyPayrollLedgerEntry.DELETEALL;
            until MyEmployee.NEXT = 0;
        PayDate := PayStatusRec."Payroll Date";
        PayStatus.COPY(PayStatusRec);
        VFinalize := P_Finalize;
        FirstEntryNo := 0;
        RecNo := 0;
        if Sub_Payroll_Code = '' then
            SetupPayrollInfo;
        PayParam.GET;
        HumanResSetup.GET;
        Window.OPEN(
            'Payroll Update\\' +
            'Payroll Run:            #1########\' +
            'Processing Employee:    #2########\' +
            'Number    #3######  of  #4######\' +
            '@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        Window.UPDATE(1, PayrollTitle);
        if PayParam."Integrate to G/L" = true then begin
            if(PayParam."Journal Template Name" = '') or(PayParam."Journal Batch Supplement" = '') or
                  ((HumanResSetup."Additional Currency Code" <> '') and(PayParam."Journal Batch Name (ACY)" = '')) then
                ERROR('Payroll Parameter Setup related to G/L Journals is missing.');
            if PayPostG.FIND('-') then
                repeat
                  if(PayPostG."Cost of Payroll Account" = '') or(PayPostG."Net Pay Account" = '') then
                    ERROR('Payroll Posting Group Setup is missing');
                if(HumanResSetup."Additional Currency Code" <> '') and
                    ((PayPostG."Cost of Payroll Account (ACY)" = '') or(PayPostG."Net Pay Account (ACY)" = '')) then
                    ERROR('Payroll Posting Group Setup is missing');
                until PayPostG.NEXT = 0;
            if PensionScheme.FIND('-') then
                repeat
                    PayE.GET(PensionScheme."Associated Pay Element");
                if PensionScheme."Employee Contribution %" <> 0 then
                    if(PensionScheme."Employee Posting Account" = '') or
                        ((PensionScheme."Expense Account" = '') and(PayE."Not Included in Net Pay")) then
                        ERROR('Pension Scheme Posting Account Setup is missing.');
                if PensionScheme."Employer Contribution %" <> 0 then
                    if(PensionScheme."Employer Posting Account" = '') or(PensionScheme."Expense Account" = '') then
                        ERROR('Pension Scheme Posting Account Setup is missing.');
                until PensionScheme.NEXT = 0;
            Employee.RESET;
            if Sub_Payroll_Code = '' then begin
                Employee.SETRANGE("Payroll Group Code", PayStatusRec."Payroll Group Code");
                Employee.SETRANGE("Pay Frequency", PayStatusRec."Pay Frequency");
            end;
            Employee.SETRANGE("Include in Pay Cycle", true);
            NoOfRecs := Employee.COUNT;
            IF Sub_Payroll_Code = '' THEN BEGIN
                IF Employee.FIND('-') THEN
                    REPEAT
                  IF Employee."Posting Group" = '' THEN
                        ERROR('There are some Employees not assigned to a Posting Group.');
                    UNTIL Employee.NEXT = 0;
            END;
        end;

        Employee.RESET;
        if Sub_Payroll_Code = '' then begin
            Employee.SETRANGE("Payroll Group Code", PayStatusRec."Payroll Group Code");
            Employee.SETRANGE("Pay Frequency", PayStatusRec."Pay Frequency");
        end;
        Employee.SETRANGE("Include in Pay Cycle", true);
        NoOfRecs := Employee.COUNT;
        if Employee.FIND('-') then
            repeat
            if AutoFixEmpDim then begin
                PayParam.GET();
                if(PayParam."Auto Copy Payroll Dimensions") and(Sub_Payroll_Code = '') then
                    EmpCalculatePay.CopyPayrollDimensions(PayStatus."Payroll Group Code", 0D, PayStatus."Payroll Date", false);
                PayDetailHeader.RESET;
                if Sub_Payroll_Code = '' then
                    PayDetailHeader.SETRANGE("Payroll Group Code", PayStatus."Payroll Group Code");
                if PayDetailHeader.FINDFIRST = true then
                    repeat
                    if not PayrollFunction.IsValidEmployeePayrollDimension(Employee."No.", PayStatus."Payroll Date", true) then begin
                        ERROR('');
                        exit;
                    end;
                    until PayDetailHeader.NEXT = 0;
            end;
            PayDetailHeader.GET(Employee."No.");
            RecNo := RecNo + 1;
            PayPostG.GET(Employee."Posting Group");
            PayDetFound := false;
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Employee No.", Employee."No.");
            PayDetailLine.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
            if Sub_Payroll_Code = '' then
                PayDetailLine.SETRANGE(Open, true)
            else
                PayDetailLine.SETRANGE(Open, false);
            if PayDetailLine.FIND('-') then
                repeat
                  Window.UPDATE(4, NoOfRecs);
                Window.UPDATE(2, Employee."No.");
                Window.UPDATE(3, RecNo);
                PayDetFound := true;
                PayLedgEntryNo := PayDetailLine."Payroll Ledger Entry No.";
                PayE.GET(PayDetailLine."Pay Element Code");
                if PayParam."Integrate to G/L" = true then begin
                    PensionScheme.RESET;
                    PensionScheme.SETCURRENTKEY(PensionScheme."Associated Pay Element");
                    PensionScheme.SETRANGE("Associated Pay Element", PayDetailLine."Pay Element Code");
                    PensionScheme.SETRANGE("Payroll Posting Group", PayPostG.Code);
                    if PensionScheme.FIND('-') then begin
                        PayElementDesc := '';
                        PayElement.RESET;
                        PayElement.SETRANGE(Code, PensionScheme."Associated Pay Element");
                        IF PayElement.FINDFIRST THEN
                            PayElementDesc := PayElement.Description;
                        if PayDetailLine."Calculated Amount" <> 0 then begin
                            if PayE."Not Included in Net Pay" then begin
                                if VFinalize = true then begin
                                    if PayParam."Summary Payroll to GL Transfer" then begin
                                        GenJnlLine.RESET;
                                        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                        IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Batch Supplement" = '')
                                                  OR(PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                                            GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Supplement")
                                        else
                                            GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Supplement");
                                        GenJnlLine.SETRANGE("Account No.", PensionScheme."Expense Account");
                                        GenJnlLine.SETRANGE("Bal. Account No.", PensionScheme."Employee Posting Account");
                                        if GenJnlLine.FIND('-') then begin
                                            GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + PayDetailLine."Calculated Amount");
                                            GenJnlLine.MODIFY;
                                        end
                                        else
                                            InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                                PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                    end
                                    else
                                        InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                            PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                end
                                else 
                                    InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                         PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                            end
                            else begin
                                IF PayDetailLine.Type = PayDetailLine.Type::Deduction THEN
                                    VCalcAmount := PayDetailLine."Calculated Amount" * (-1)
                                ELSE
                                    VCalcAmount := PayDetailLine."Calculated Amount";

                                if VFinalize = true then begin
                                    if PayParam."Summary Payroll to GL Transfer" then begin
                                        GenJnlLine.RESET;
                                        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                        if(PayParam."Group By Dimension" = '') or(PayParam."Temp Batch Supplement" = '') or
                                              (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
                                            GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Supplement")
                                        else
                                            GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Supplement");
                                        GenJnlLine.SETRANGE("Account No.", PensionScheme."Employee Posting Account");
                                        if GenJnlLine.FIND('-') then begin
                                            GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + VCalcAmount);
                                            GenJnlLine.MODIFY;
                                        end
                                        else
                                            InsertGenJnlLine(PensionScheme."Employee Posting Account", '', VCalcAmount, '', false, Sub_Payroll_Code);
                                    end
                                    else
                                        InsertGenJnlLine(PensionScheme."Employee Posting Account", '', VCalcAmount, '', false, Sub_Payroll_Code);
                                end
                                else 
                                    InsertGenJnlLine(PensionScheme."Employee Posting Account", '', VCalcAmount, '', false, Sub_Payroll_Code);
                            end;

                        end;
                        if PayDetailLine."Employer Amount" <> 0 then begin
                            if VFinalize = true then begin
                                if PayParam."Summary Payroll to GL Transfer" then begin 
                                    GenJnlLine.RESET;
                                    GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                    if(PayParam."Group By Dimension" = '') or(PayParam."Temp Batch Supplement" = '') or
                                            (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
                                        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Supplement")
                                    else
                                        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Supplement");
                                    GenJnlLine.SETRANGE("Account No.", PensionScheme."Expense Account");
                                    GenJnlLine.SETRANGE("Bal. Account No.", PensionScheme."Employer Posting Account");
                                    if GenJnlLine.FIND('-') then begin
                                        GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + PayDetailLine."Employer Amount");
                                        GenJnlLine.MODIFY;
                                    end
                                    else
                                        InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employer Posting Account",
                                                                PayDetailLine."Employer Amount", '', false, Sub_Payroll_Code);
                                end
                                else
                                    InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employer Posting Account",
                                                            PayDetailLine."Employer Amount", '', false, Sub_Payroll_Code);
                            end
                            else 
                                InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employer Posting Account",
                                                     PayDetailLine."Employer Amount", '', false, Sub_Payroll_Code);
                        end;

                    end
                    else begin
                        if(PayDetailLine."Pay Element Code" <> PayParam."Income Tax Code") or
                           ((PayDetailLine."Pay Element Code" = PayParam."Income Tax Code") and(not PayDetailLine."Not Included in Net Pay"
                                ))
                        then begin
                            if((PayDetailLine."Calculated Amount" <> 0) or(PayDetailLine."Calculated Amount (ACY)" <> 0)) and
                                (not PayE."Not Included in Net Pay") then begin
                                PayDetailLine.CALCFIELDS("Split Entries");
                                if PayDetailLine."Split Entries" = 0 then
                                    ProcessCostNetAccounts('COST', PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", false, Sub_Payroll_Code)
                                else begin
                                end;
                            end; 

                        end;
                    end;
                end;
                if NoOfRecs <> 0 then
                    Window.UPDATE(5, ROUND(RecNo / NoOfRecs * 10000, 1));

                until PayDetailLine.NEXT = 0;

            if PayDetFound = true then begin
                PayLedgEntry.GET(PayLedgEntryNo);
                if PayParam."Integrate to G/L" = true then begin
                    if(PayLedgEntry."Net Pay" <> 0) or(PayLedgEntry."Net Pay (ACY)" <> 0) then begin
                        ProcessCostNetAccounts('NET', PayLedgEntry."Net Pay", PayLedgEntry."Net Pay (ACY)", false, Sub_Payroll_Code);
                    end;
                    PayLedgEntry.GET(PayLedgEntryNo);
                    if(PayLedgEntry.Rounding <> 0) then begin
                        ProcessCostNetAccountsRound('NET', -1 * PayLedgEntry.Rounding, 0, false, Sub_Payroll_Code);
                    end;
                    ProcessCostNetAccountsPay('NET', PayLedgEntry."Net Pay", 0, false, Sub_Payroll_Code);
                    ProcessBankAccount('NET', -1 * PayLedgEntry."Net Pay", 0, false, Sub_Payroll_Code);
                end;

                if VFinalize = true then begin
                    if Sub_Payroll_Code = '' then begin
                        if FirstEntryNo = 0 then begin
                            FirstEntryNo := PayLedgEntry."Entry No.";
                            LastEntryNo := PayLedgEntry."Entry No.";
                        end;

                        if PayLedgEntry."Entry No." < FirstEntryNo then
                            FirstEntryNo := PayLedgEntry."Entry No.";

                        if PayLedgEntry."Entry No." > LastEntryNo then
                            LastEntryNo := PayLedgEntry."Entry No.";

                        PayLedgEntry.Open := false;
                        PayLedgEntry."Posting Date" := PayStatus."Payroll Date";
                        PayLedgEntry.MODIFY;

                        CreateNewPayDetails;
                        PayDetailHeader."Calculation Required" := true;
                        PayDetailHeader."Payslip Printed" := false;
                        if Employee.Status <> Employee.Status::Active then
                            PayDetailHeader."Include in Pay Cycle" := false;
                        PayDetailHeader.MODIFY;
                    end;
                end;
            end;
            until Employee.NEXT = 0;
        if PayParam."Group By Dimension" = '' then
            VBatchName := PayParam."Journal Batch Supplement"
        else
            VBatchName := PayParam."Temp Batch Supplement";

        DocumentNo := '';

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", VBatchName);
        if GenJnlLine.FINDFIRST then
            repeat
          if DocumentNo <> GenJnlLine."Document No." then begin
                DocumentNo := GenJnlLine."Document No.";
                GenJnlLineDoc.RESET;
                GenJnlLineDoc.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLineDoc.SETRANGE("Journal Batch Name", VBatchName);
                GenJnlLineDoc.SETRANGE("Document No.", DocumentNo);
                if GenJnlLineDoc.FINDLAST then
                    GenJnlLineDoc.CloseJournal2(FALSE);
            end;
            until GenJnlLine.NEXT = 0;
        if VFinalize = true then begin
            PostPayRegister;
            if PayParam."Integrate to G/L" = true then begin
                Loop := 1;
                while Loop <= 2 do
                begin
                    if Loop = 1 then begin
                        if PayParam."Group By Dimension" = '' then
                            VBatchName := PayParam."Journal Batch Supplement"
                        else
                            VBatchName := PayParam."Temp Batch Supplement";
                    end else
                        VBatchName := PayParam."Journal Batch Name (ACY)";

                    GenJnlLine.RESET;
                    Loop := Loop + 1;
                end;
            end;
        end;

        Window.CLOSE;

    end;

    procedure GroupAccountWithDimension();
    var
        GenJnlLine: Record "Gen. Journal Line";
        GrpGenJnLine: Record "Gen. Journal Line";
        TotalAmtDbt: Decimal;
        InsertGenJnlRec: Record "Gen. Journal Line";
        TotalAmtCr: Decimal;
        DocNb: Code[20];
        TotalAmtDbtLCY: Decimal;
        TotalAmtCrLCY: Decimal;
        LineNo: Integer;
    begin
        PayParam.GET;
        GLSetup.GET;
        IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Batch Supplement" = '') OR
           (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
            exit;
        InsertGenJnlRec.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        InsertGenJnlRec.SETRANGE("Journal Batch Name", PayParam."Journal Batch Supplement");
        if InsertGenJnlRec.FINDLAST then
            LineNo := InsertGenJnlRec."Line No."
        else
            LineNo := 0;
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Supplement");
        GenJnlLine.SETRANGE(Inserted2, false);
        GenJnlLine.SETRANGE("Bal. Account No.", '');
        if GenJnlLine.FINDFIRST then
            repeat
          TotalAmtCr := 0;
            TotalAmtDbt := 0;
            TotalAmtCrLCY := 0;
            TotalAmtDbtLCY := 0;
            GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Template Name", PayParam."Journal Template Name");
            GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Batch Name", PayParam."Temp Batch Supplement");
            GrpGenJnLine.SETRANGE(GrpGenJnLine.Inserted2, false);
            GrpGenJnLine.SETRANGE("Account No.", GenJnlLine."Account No.");
            GrpGenJnLine.SETRANGE("Currency Code", GenJnlLine."Currency Code");
            if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                GrpGenJnLine.SETRANGE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
            else if GLSetup."Global Dimension 2 Code" = PayParam."Group By Dimension" then
                    GrpGenJnLine.SETRANGE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
            GrpGenJnLine.SETRANGE("Bal. Account No.", '');
            if GrpGenJnLine.FINDFIRST then
                repeat
            TotalAmtDbt += GrpGenJnLine."Debit Amount";
                TotalAmtCr += GrpGenJnLine."Credit Amount";
                if GrpGenJnLine."Amount (LCY)" > 0 then
                    TotalAmtDbtLCY += GrpGenJnLine."Amount (LCY)";
                if GrpGenJnLine."Amount (LCY)" < 0 then
                    TotalAmtCrLCY += GrpGenJnLine."Amount (LCY)";
                GrpGenJnLine.Inserted2 := true;
                GrpGenJnLine.MODIFY;
                until GrpGenJnLine.NEXT = 0;
            if(TotalAmtDbt <> 0) then begin
                DocNb := COPYSTR(GenJnlLine."Document No.", 1, STRPOS(GenJnlLine."Document No.", '-') - 1);
                InsertGenJnlRec.INIT;
                InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name";
                InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Supplement";
                LineNo += 10000;
                InsertGenJnlRec."Line No." := LineNo;
                InsertGenJnlRec.INSERT;
                InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                InsertGenJnlRec."Document No." := DocNb;
                InsertGenJnlRec."Account Type" := InsertGenJnlRec."Account Type"::"G/L Account";
                InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                InsertGenJnlRec.VALIDATE("Debit Amount", TotalAmtDbt);
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
                else if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                        InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                if PayParam."Use Payroll ACY Rate" then
                    InsertGenJnlRec.VALIDATE("Amount (LCY)", TotalAmtDbtLCY);
                InsertGenJnlRec.MODIFY;
            end;
            if(TotalAmtCr <> 0) then begin
                InsertGenJnlRec.INIT;
                InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name";
                InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Supplement";
                LineNo += 10000;
                InsertGenJnlRec."Line No." := LineNo;
                InsertGenJnlRec.INSERT;
                InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                InsertGenJnlRec."Document No." := DocNb;
                InsertGenJnlRec."Account Type" := InsertGenJnlRec."Account Type"::"G/L Account";
                InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                //EDM-20170905+
                InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                //EDM-20170905-
                InsertGenJnlRec.VALIDATE("Credit Amount", TotalAmtCr);
                //EDM-20170905+
                //InsertGenJnlRec.VALIDATE("Credit Amount (LCY)",TotalAmtCrLCY);
                //EDM-20170905-
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
                else if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                        InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                //EDM-20170905+
                if PayParam."Use Payroll ACY Rate" then
                    InsertGenJnlRec.VALIDATE("Amount (LCY)", TotalAmtCrLCY);
                //EDM-20170905-
                InsertGenJnlRec.MODIFY;
            end;
            GenJnlLine.Inserted2 := true;
            GenJnlLine.MODIFY;
            until GenJnlLine.NEXT = 0;
    end;

    procedure GroupAccountWithDimensionBal();
    var
        GenJnlLine: Record "Gen. Journal Line";
        GrpGenJnLine: Record "Gen. Journal Line";
        TotalAmtDbt: Decimal;
        InsertGenJnlRec: Record "Gen. Journal Line";
        TotalAmtCr: Decimal;
        LineNb: Integer;
        DocNb: Code[20];
        TotalAmtDbtLCY: Decimal;
        TotalAmtCrLCY: Decimal;
    begin
        PayParam.GET;
        GLSetup.GET;
        // 11.10.2017 : NEW MOD +
        IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Batch Supplement" = '') OR
           (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
            exit;
        // 11.10.2017 : NEW MOD -
        GenJnlLine.SETCURRENTKEY("Line No.");
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Supplement");
        if GenJnlLine.FINDLAST then
            LineNb := GenJnlLine."Line No."
        else
            LineNb := 0;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Supplement");
        GenJnlLine.SETRANGE(Inserted2, false);
        GenJnlLine.SETFILTER("Bal. Account No.", '<>%1', '');
        if GenJnlLine.FINDFIRST then
            repeat
          TotalAmtCr := 0;
            TotalAmtDbt := 0;
            //EDM-20170905+
            TotalAmtCrLCY := 0;
            TotalAmtDbtLCY := 0;
            //EDM-20170905-
            GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Template Name", PayParam."Journal Template Name");
            GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Batch Name", PayParam."Temp Batch Supplement");
            GrpGenJnLine.SETRANGE(GrpGenJnLine.Inserted2, false);
            GrpGenJnLine.SETRANGE("Account No.", GenJnlLine."Account No.");
            //EDM-20170905+
            GrpGenJnLine.SETRANGE("Currency Code", GenJnlLine."Currency Code");
            //EDM-20170905-
            if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                GrpGenJnLine.SETRANGE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
            else if GLSetup."Global Dimension 2 Code" = PayParam."Group By Dimension" then
                    GrpGenJnLine.SETRANGE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
            GrpGenJnLine.SETRANGE("Bal. Account No.", GenJnlLine."Bal. Account No.");
            if GrpGenJnLine.FINDFIRST then
                repeat
            TotalAmtDbt += GrpGenJnLine.Amount;
                //EDM-20170905+
                TotalAmtDbtLCY += GrpGenJnLine."Amount (LCY)";
                //EDM-20170905-
                GrpGenJnLine.Inserted2 := true;
                GrpGenJnLine.MODIFY;
                until GrpGenJnLine.NEXT = 0;
            if TotalAmtDbt <> 0 then begin
                DocNb := COPYSTR(GenJnlLine."Document No.", 1, STRPOS(GenJnlLine."Document No.", '-') - 1);
                InsertGenJnlRec.INIT;
                InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name";
                InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Supplement";
                LineNb += 10000;
                InsertGenJnlRec."Line No." := LineNb;
                InsertGenJnlRec.INSERT;
                InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                InsertGenJnlRec."Document No." := DocNb;
                InsertGenJnlRec."Account Type" := InsertGenJnlRec."Account Type"::"G/L Account";
                InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                //EDM-20170905+
                InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                //EDM-20170905-
                InsertGenJnlRec.VALIDATE(Amount, TotalAmtDbt);
                //EDM-20170905+
                if PayParam."Use Payroll ACY Rate" then
                    InsertGenJnlRec.VALIDATE("Amount (LCY)", TotalAmtDbtLCY);
                //EDM-20170905-
                // 11.10.2017 : NEW MOD +
                //InsertGenJnlRec."Bal. Account Type" := GenJnlLine."Bal. Account Type";
                //InsertGenJnlRec."Bal. Account No." := GenJnlLine."Bal. Account No.";
                InsertGenJnlRec.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type");
                InsertGenJnlRec.VALIDATE("Bal. Account No.", GenJnlLine."Bal. Account No.");
                // 11.10.2017 : NEW MOD -
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
                else if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                        InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                InsertGenJnlRec.MODIFY;
            end;
            GenJnlLine.Inserted2 := true;
            GenJnlLine.MODIFY;
            until GenJnlLine.NEXT = 0;
    end;

    procedure GroupPaymentAccountWithDimension();
    var
        GenJnlLine: Record "Gen. Journal Line";
        GrpGenJnLine: Record "Gen. Journal Line";
        TotalAmtDbt: Decimal;
        InsertGenJnlRec: Record "Gen. Journal Line";
        TotalAmtCr: Decimal;
        DocNb: Code[20];
        BankAcc: Record "Bank Account";
        AccRec: Record "G/L Account";
        TotalAmtDbtLCY: Decimal;
        TotalAmtCrLCY: Decimal;
        LineNo: Integer;
        HRSetup: Record "Human Resources Setup";
    begin
        PayParam.GET;
        GLSetup.GET;
        // 11.10.2017 : NEW MOD +
        IF(PayParam."Group By Dimension" = '') OR(PayParam."Temp Pay Batch Supplement" = '') OR
           (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
            exit;
        // 11.10.2017 : NEW MOD -
        //28.03.2018 TAREKH. Added in order to fix the line no. increment
        InsertGenJnlRec.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
        InsertGenJnlRec.SETRANGE("Journal Batch Name", PayParam."Journal Batch Supplement Pay");
        if InsertGenJnlRec.FINDLAST then
            LineNo := InsertGenJnlRec."Line No."
        else
            LineNo := 0;
        //28.03.2018 TAREKH. Added in order to fix the line no. increment
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Pay Batch Supplement");
        GenJnlLine.SETRANGE(Inserted2, false);
        GenJnlLine.SETRANGE("Bal. Account No.", '');
        if GenJnlLine.FINDFIRST then
            repeat
          TotalAmtCr := 0;
            TotalAmtDbt := 0;
            //EDM-20170905+
            TotalAmtCrLCY := 0;
            TotalAmtDbtLCY := 0;
            //EDM-20170905-
            GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Template Name", PayParam."Journal Template Name Pay");
            GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Batch Name", PayParam."Temp Pay Batch Supplement");
            GrpGenJnLine.SETRANGE(GrpGenJnLine.Inserted2, false);
            GrpGenJnLine.SETRANGE("Account Type", GenJnlLine."Account Type");
            GrpGenJnLine.SETRANGE("Account No.", GenJnlLine."Account No.");
            //EDM-20170905+
            GrpGenJnLine.SETRANGE("Currency Code", GenJnlLine."Currency Code");
            //EDM-20170905-
            if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                GrpGenJnLine.SETRANGE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
            else if GLSetup."Global Dimension 2 Code" = PayParam."Group By Dimension" then
                    GrpGenJnLine.SETRANGE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
            GrpGenJnLine.SETRANGE("Bal. Account No.", '');
            //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
            GrpGenJnLine.SETFILTER("Payment Method Code", '<>%1', 'CHECK');
            //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
            if GrpGenJnLine.FINDFIRST then
                repeat
            TotalAmtDbt += GrpGenJnLine."Debit Amount";
                TotalAmtCr += GrpGenJnLine."Credit Amount";
                //EDM-20170905+
                if GrpGenJnLine."Amount (LCY)" > 0 then
                    TotalAmtDbtLCY += GrpGenJnLine."Amount (LCY)";
                if GrpGenJnLine."Amount (LCY)" < 0 then
                    TotalAmtCrLCY += GrpGenJnLine."Amount (LCY)";
                //EDM-20170905-
                GrpGenJnLine.Inserted2 := true;
                GrpGenJnLine.MODIFY;
                AccountType := GrpGenJnLine."Account Type";
                until GrpGenJnLine.NEXT = 0;
            if(TotalAmtDbt <> 0) then begin
                DocNb := COPYSTR(GenJnlLine."Document No.", 1, STRPOS(GenJnlLine."Document No.", '-') - 1);
                InsertGenJnlRec.INIT;
                InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name Pay";
                InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Supplement Pay";
                //28.03.2018 TAREKH. Added in order to fix the line no. increment
                LineNo += 10000;
                InsertGenJnlRec."Line No." := LineNo;
                //28.03.2018 TAREKH. Added in order to fix the line no. increment
                InsertGenJnlRec.INSERT;
                InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                InsertGenJnlRec."Document No." := DocNb;
                InsertGenJnlRec.VALIDATE("Account Type", AccountType);
                InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                //EDM-20170905+
                InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                //EDM-20170905-
                InsertGenJnlRec.VALIDATE("Debit Amount", TotalAmtDbt);
                //EDM-20170905+
                if PayParam."Use Payroll ACY Rate" then
                    InsertGenJnlRec.VALIDATE("Amount (LCY)", TotalAmtDbtLCY);
                //EDM-20170905-
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GrpGenJnLine."Shortcut Dimension 1 Code")
                else if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                        InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GrpGenJnLine."Shortcut Dimension 2 Code");
                InsertGenJnlRec.MODIFY;
            end;
            if(TotalAmtCr <> 0) then begin
                InsertGenJnlRec.INIT;
                InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name Pay";
                InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Supplement Pay";
                //28.03.2018 TAREKH. Added in order to fix the line no. increment
                LineNo += 10000;
                InsertGenJnlRec."Line No." := LineNo;
                //28.03.2018 TAREKH. Added in order to fix the line no. increment
                InsertGenJnlRec.INSERT;
                InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                InsertGenJnlRec."Document No." := DocNb;
                InsertGenJnlRec.VALIDATE("Account Type", AccountType);
                InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                //EDM-20170905+
                InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                //EDM-20170905-
                InsertGenJnlRec.VALIDATE("Credit Amount", TotalAmtCr);
                //EDM-20170905+
                if PayParam."Use Payroll ACY Rate" then
                    InsertGenJnlRec.VALIDATE("Amount (LCY)", TotalAmtCrLCY);
                //EDM-20170905-
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GrpGenJnLine."Shortcut Dimension 1 Code")
                else if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                        InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GrpGenJnLine."Shortcut Dimension 2 Code");
                InsertGenJnlRec.MODIFY;
            end;
            GenJnlLine.Inserted2 := true;
            GenJnlLine.MODIFY;

            //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
            HRSetup.GET;
               IF GenJnlLine."Payment Method Code" = 'CHECK' THEN BEGIN
                    InsertGenJnlRec.INIT;
                    InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name Pay";
                    InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Supplement Pay";
                    LineNo += 10000;
                    InsertGenJnlRec."Line No." := LineNo;
                    InsertGenJnlRec.INSERT;
                    InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                    InsertGenJnlRec."Document No." := DocNb;
                    InsertGenJnlRec.VALIDATE("Account Type",InsertGenJnlRec."Account Type"::"Bank Account");
                    InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                    InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                    InsertGenJnlRec.VALIDATE("Credit Amount", GenJnlLine."Credit Amount");
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code");
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                    InsertGenJnlRec."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    InsertGenJnlRec.VALIDATE("Payment Method Code", GenJnlLine."Payment Method Code");
                    InsertGenJnlRec.VALIDATE("External Document No.",GenJnlLine."External Document No.");
                    InsertGenJnlRec.VALIDATE("Due Date",GenJnlLine."Due Date");
                    InsertGenJnlRec.MODIFY;
                END;
            //END;
            //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
            UNTIL GenJnlLine.NEXT = 0;
    end;
}