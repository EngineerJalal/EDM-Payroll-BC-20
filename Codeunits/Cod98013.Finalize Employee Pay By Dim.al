codeunit 98013 "Finalize Employee Pay By Dim."
{
    // version PY1.0,EDM.HRPY1

    // PY1.2 : - Fix the Mistake of Description in case of summarize GLs.

    Permissions = TableData "Employee Loan Line" = rimd;

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
        VBalAccountNo: Code[20];
        VCalcAmount: Decimal;
        VCurrencyCode: Code[10];
        PayrollNo: Code[10];
        PayrollTitle: Text[50];
        PayStatus: Record "Payroll Status";
        VBatchName: Code[10];
        Loop: Integer;
        EmpLoan: Record "Employee Loan";
        EmpJnlLine: Record "Employee Journal Line";
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
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TempSplitPayDetLine: Record "Split Pay Detail Line" temporary;
        SplitPayDetLine: Record "Split Pay Detail Line";
        Resource: Record Resource;
        DimMgt: Codeunit DimensionManagement;
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        VBatchNamePay: Code[10];
        vBatchDescPay: Text[30];
        PayrollElementPostingGroup: Record "Payroll Element Posting";
        PayDate: Date;
        GLSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Factor: Decimal;
        BankAcc: Record "Bank Account";
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        GenJnl2AmountLCY: Decimal;
        PayFunction: Codeunit "Payroll Functions";
        PayrollFunctions: Codeunit "Payroll Functions";
        PayElementDesc: Text[100];
        GLAccountRec: Record "G/L Account";
        VendorRec: Record Vendor;

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
        HRSetup: Record "Human Resources Setup";
    begin
        //MB.1105A+
        MyEmployee.RESET;
        MyEmployee.SETFILTER("Termination Date", '<> %1', 0D);
        MyEmployee.SETRANGE(Status, MyEmployee.Status::Active);
        if MyEmployee.FIND('-') then
            repeat
                MyPayrollLedgerEntry.SETCURRENTKEY("Employee No.", "Posting Date", "Period Start Date", "Period End Date");
                MyPayrollLedgerEntry.SETRANGE("Employee No.", MyEmployee."No.");
                MyPayrollLedgerEntry.SETFILTER("Period Start Date", '%1..', (MyEmployee."Termination Date" + 1));
                //EDM_16052017
                MyPayrollLedgerEntry.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
                //EDM_16052017
                if MyPayrollLedgerEntry.FIND('-') then
                    MyPayrollLedgerEntry.DELETEALL;
            until MyEmployee.NEXT = 0;
        //MB.1105A+
        PayDate := PayStatusRec."Payroll Date";
        PayStatus.COPY(PayStatusRec);
        VFinalize := P_Finalize;
        FirstEntryNo := 0;
        RecNo := 0;
        // 04.08.2017 : A2+
        if Sub_Payroll_Code = '' then
            SetupPayrollInfo;
        // 04.08.2017 : A2-
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
            if (PayParam."Journal Template Name" = '') or (PayParam."Journal Batch Name" = '') or
                ((HumanResSetup."Additional Currency Code" <> '') and (PayParam."Journal Batch Name (ACY)" = '')) then
                ERROR('Payroll Parameter Setup related to G/L Journals is missing.');
            // chk post a/c
            if PayPostG.FIND('-') then
                repeat
                    if (PayPostG."Cost of Payroll Account" = '') or (PayPostG."Net Pay Account" = '') then
                        ERROR('Payroll Posting Group Setup is missing');
                    if (HumanResSetup."Additional Currency Code" <> '') and
                      ((PayPostG."Cost of Payroll Account (ACY)" = '') or (PayPostG."Net Pay Account (ACY)" = '')) then
                        ERROR('Payroll Posting Group Setup is missing');
                until PayPostG.NEXT = 0;
            PayParam.GET;
            IF PayParam."Payroll Labor Law" <> PayParam."Payroll Labor Law"::UAE then begin
                if PensionScheme.FIND('-') then
                    repeat
                        PayE.GET(PensionScheme."Associated Pay Element");
                        if PensionScheme."Employee Contribution %" <> 0 then
                            if (PensionScheme."Employee Posting Account" = '') or
                              ((PensionScheme."Expense Account" = '') and (PayE."Not Included in Net Pay")) then
                                ERROR('Pension Scheme Posting Account Setup is missing.');
                        if PensionScheme."Employer Contribution %" <> 0 then
                            if (PensionScheme."Employer Posting Account" = '') or (PensionScheme."Expense Account" = '') then
                                ERROR('Pension Scheme Posting Account Setup is missing.');
                    until PensionScheme.NEXT = 0;
            end;
            Employee.RESET;
            // 28.07.2017 : A2+
            if Sub_Payroll_Code = '' then begin
                Employee.SETRANGE("Payroll Group Code", PayStatusRec."Payroll Group Code");
                Employee.SETRANGE("Pay Frequency", PayStatusRec."Pay Frequency");
            end;
            // 28.07.2017 : A2-
            //  Employee.SETRANGE(Status,MyEmployee.Status::Active);
            //py2.0+
            //Employee.SETRANGE(Status,Employee.Status::Active);
            Employee.SETRANGE("Include in Pay Cycle", true);
            //py2.0-
            NoOfRecs := Employee.COUNT;
            // 13.02.2018 : A2+
            IF Sub_Payroll_Code = '' THEN BEGIN
                // 13.02.2018 : A2-
                IF Employee.FIND('-') THEN
                    REPEAT
                        IF Employee."Posting Group" = '' THEN
                            ERROR('There are some Employees not assigned to a Posting Group.');
                    UNTIL Employee.NEXT = 0;
                // 13.02.2018 : A2+
            END;
            // 13.02.2018 : A2-
            // del. payroll jnl.
            /*  GenJnlLine.RESET;
              GenJnlLine.SETRANGE("Journal Template Name",PayParam."Journal Template Name");
              GenJnlLine.SETRANGE("Journal Batch Name",PayParam."Journal Batch Name");
              GenJnlLine.DELETEALL;
              GenJnlLine.SETRANGE("Journal Template Name",PayParam."Journal Template Name");
              GenJnlLine.SETRANGE("Journal Batch Name",PayParam."Journal Batch Name (ACY)");
              GenJnlLine.DELETEALL;   */

        end; //gl integ1

        Employee.RESET;
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then begin
            Employee.SETRANGE("Payroll Group Code", PayStatusRec."Payroll Group Code");
            Employee.SETRANGE("Pay Frequency", PayStatusRec."Pay Frequency");
        end;
        // 28.07.2017 : A2-
        //py2.0+
        //Employee.SETRANGE(Status,Employee.Status::Active);
        Employee.SETRANGE("Include in Pay Cycle", true);
        //py2.0-
        NoOfRecs := Employee.COUNT;
        if Employee.FIND('-') then
            repeat
                // Added in order to set missing Employees Dimensions percentag - 27.07.2017 : A2+
                if AutoFixEmpDim then begin
                    PayParam.GET();
                    // 28.07.2017 : A2+
                    //IF PayParam."Auto Copy Payroll Dimensions" THEN
                    if (PayParam."Auto Copy Payroll Dimensions") and (Sub_Payroll_Code = '') then
                        EmpCalculatePay.CopyPayrollDimensions(PayStatus."Payroll Group Code", 0D, PayStatus."Payroll Date", false);
                    // 28.07.2017 : A2-
                    //Added in order to check if the allocation of dimensions is properly assigned +
                    PayDetailHeader.RESET;
                    // 28.07.2017 : A2+
                    if Sub_Payroll_Code = '' then
                        PayDetailHeader.SETRANGE("Payroll Group Code", PayStatus."Payroll Group Code");
                    // 28.07.2017 : A2-
                    if PayDetailHeader.FINDFIRST = true then
                        repeat
                            if not PayrollFunction.IsValidEmployeePayrollDimension(Employee."No.", PayStatus."Payroll Date", true) then begin
                                ERROR('');
                                exit;
                            end;
                        until PayDetailHeader.NEXT = 0;
                    //Added in order to check if the allocation of dimensions is properly assigned -
                end;
                // Added in order to set missing Employees Dimensions percentag - 27.07.2017 : A2-

                PayDetailHeader.GET(Employee."No.");
                // py2.0 IF PayDetailHeader."Include in Pay Cycle" = TRUE THEN BEGIN
                RecNo := RecNo + 1;
                PayPostG.GET(Employee."Posting Group");
                PayDetFound := false;
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Employee No.", Employee."No.");
                //EDM_16052017
                PayDetailLine.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
                //EDM_16052017
                //EDM.IT+-PayDetailLine.SETFILTER(Amount,'<>0');
                // 04.08.2017 : A2+
                if Sub_Payroll_Code = '' then
                    PayDetailLine.SETRANGE(Open, true)
                else
                    PayDetailLine.SETRANGE(Open, false);
                // 04.08.2017 : A2-
                if PayDetailLine.FIND('-') then
                    repeat
                        Window.UPDATE(4, NoOfRecs);
                        Window.UPDATE(2, Employee."No.");
                        Window.UPDATE(3, RecNo);
                        PayDetFound := true;
                        PayLedgEntryNo := PayDetailLine."Payroll Ledger Entry No.";
                        PayE.GET(PayDetailLine."Pay Element Code");
                        // 1+
                        if PayParam."Integrate to G/L" = true then begin
                            PensionScheme.RESET;
                            PensionScheme.SETCURRENTKEY(PensionScheme."Associated Pay Element");
                            PensionScheme.SETRANGE("Associated Pay Element", PayDetailLine."Pay Element Code");
                            //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM +
                            PensionScheme.SETRANGE("Payroll Posting Group", PayPostG.Code);//EDM.IT+++
                                                                                           //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM -
                                                                                           // 2+
                            if PensionScheme.FIND('-') then begin
                                /////HTK
                                // 14.03.2018 : A2+
                                PayElementDesc := '';
                                PayElement.RESET;
                                PayElement.SETRANGE(Code, PensionScheme."Associated Pay Element");
                                IF PayElement.FINDFIRST THEN
                                    PayElementDesc := PayElement.Description;
                                // 14.03.2018 : A2-
                                // 3+
                                if PayDetailLine."Calculated Amount" <> 0 then begin
                                    // 4+
                                    if PayE."Not Included in Net Pay" then begin
                                        // 5+
                                        if VFinalize = true then begin
                                            if PayParam."Summary Payroll to GL Transfer" then begin //summary
                                                GenJnlLine.RESET;
                                                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                                //NEW MOD.
                                                IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Batch Name" = '')
                                                        OR (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                                                    GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name")
                                                else
                                                    GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Name");
                                                //NEW MOD.
                                                GenJnlLine.SETRANGE("Account No.", PensionScheme."Expense Account");
                                                GenJnlLine.SETRANGE("Bal. Account No.", PensionScheme."Employee Posting Account");
                                                if GenJnlLine.FIND('-') then begin
                                                    GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + PayDetailLine."Calculated Amount");
                                                    GenJnlLine.MODIFY;
                                                end
                                                else
                                                    // 28.07.2017 : A2+
                                                    // InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employee Posting Account",
                                                    //    PayDetailLine."Calculated Amount",'',FALSE);
                                                    InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                                            PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                                // 28.07.2017 : A2-
                                            end
                                            else
                                                // 28.07.2017 : A2+
                                                // InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employee Posting Account",
                                                //    PayDetailLine."Calculated Amount",'',FALSE);
                                                InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                                      PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                            // 28.07.2017 : A2-
                                        end
                                        else // test final.
                                             // 28.07.2017 : A2+
                                             // InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employee Posting Account",
                                             //    PayDetailLine."Calculated Amount",'',FALSE);
                                            InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                                PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                        // 28.07.2017 : A2-
                                        // 5-
                                    end
                                    else begin // inc in net pay
                                        IF PayDetailLine.Type = PayDetailLine.Type::Deduction THEN
                                            VCalcAmount := PayDetailLine."Calculated Amount" * (-1)
                                        ELSE
                                            VCalcAmount := PayDetailLine."Calculated Amount";

                                        if VFinalize = true then begin
                                            if PayParam."Summary Payroll to GL Transfer" then begin //summary
                                                GenJnlLine.RESET;
                                                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                                //NEW MOD.
                                                // 11.10.2017 : A2+
                                                /*IF PayParam."Group By Dimension" = '' THEN
                                                  GenJnlLine.SETRANGE("Journal Batch Name",PayParam."Journal Batch Name")*/
                                                if (PayParam."Group By Dimension" = '') or (PayParam."Temp Batch Name" = '') or
                                                   (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
                                                    GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name")
                                                // 11.10.2017 : A2-
                                                else
                                                    GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Name");
                                                //NEW MOD.
                                                GenJnlLine.SETRANGE("Account No.", PensionScheme."Employee Posting Account");
                                                if GenJnlLine.FIND('-') then begin
                                                    GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + VCalcAmount);
                                                    GenJnlLine.MODIFY;
                                                end
                                                else
                                                    // 28.07.2017 : A2+
                                                    // InsertGenJnlLine(PensionScheme."Employee Posting Account",'',VCalcAmount,'',FALSE);
                                                    InsertGenJnlLine(PensionScheme."Employee Posting Account", '', VCalcAmount, '', false, Sub_Payroll_Code);
                                                // 28.07.2017 : A2-
                                            end
                                            else
                                                // 28.07.2017 : A2+
                                                // InsertGenJnlLine(PensionScheme."Employee Posting Account",'',VCalcAmount,'',FALSE);
                                                InsertGenJnlLine(PensionScheme."Employee Posting Account", '', VCalcAmount, '', false, Sub_Payroll_Code);
                                            // 28.07.2017 : A2-
                                        end
                                        else // test final.
                                             // 28.07.2017 : A2+
                                             // InsertGenJnlLine(PensionScheme."Employee Posting Account",'',VCalcAmount,'',FALSE);
                                            InsertGenJnlLine(PensionScheme."Employee Posting Account", '', VCalcAmount, '', false, Sub_Payroll_Code);
                                        // 28.07.2017 : A2-

                                    end; // EmployeeCont inc. in NET pay
                                         // 4-

                                end; //EmployeeContb.
                                     // 3+


                                if PayDetailLine."Employer Amount" <> 0 then begin
                                    if VFinalize = true then begin
                                        if PayParam."Summary Payroll to GL Transfer" then begin //summary
                                            GenJnlLine.RESET;
                                            GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                            //NEW MOD.
                                            // 11.10.2017 : A2+
                                            /*IF PayParam."Group By Dimension" = '' THEN
                                              GenJnlLine.SETRANGE("Journal Batch Name",PayParam."Journal Batch Name")*/
                                            if (PayParam."Group By Dimension" = '') or (PayParam."Temp Batch Name" = '') or
                                               (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
                                                GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name")
                                            // 11.10.2017 : A2-
                                            else
                                                GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Name");
                                            //NEW MOD.
                                            GenJnlLine.SETRANGE("Account No.", PensionScheme."Expense Account");
                                            GenJnlLine.SETRANGE("Bal. Account No.", PensionScheme."Employer Posting Account");
                                            if GenJnlLine.FIND('-') then begin
                                                GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + PayDetailLine."Employer Amount");
                                                GenJnlLine.MODIFY;
                                            end
                                            else
                                                // 28.07.2017 : A2+
                                                //  InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employer Posting Account",
                                                //                     PayDetailLine."Employer Amount",'',FALSE);
                                                InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employer Posting Account",
                                                                         PayDetailLine."Employer Amount", '', false, Sub_Payroll_Code);
                                            // 28.07.2017 : A2-
                                        end
                                        else
                                            // 28.07.2017 : A2+
                                            //  InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employer Posting Account",
                                            //                     PayDetailLine."Employer Amount",'',FALSE);
                                            InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employer Posting Account",
                                                                  PayDetailLine."Employer Amount", '', false, Sub_Payroll_Code);
                                        // 28.07.2017 : A2-
                                    end
                                    else // test final.
                                         // 28.07.2017 : A2+
                                         //  InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employer Posting Account",
                                         //                     PayDetailLine."Employer Amount",'',FALSE);
                                        InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employer Posting Account",
                                                          PayDetailLine."Employer Amount", '', false, Sub_Payroll_Code);
                                    // 28.07.2017 : A2-

                                end; // EmployerContb.

                            end
                            else begin // <>PensionScheme
                                if (PayDetailLine."Pay Element Code" <> PayParam."Income Tax Code") or
                                   ((PayDetailLine."Pay Element Code" = PayParam."Income Tax Code") and (not PayDetailLine."Not Included in Net Pay"
                                        ))
                                then begin
                                    if ((PayDetailLine."Calculated Amount" <> 0) or (PayDetailLine."Calculated Amount (ACY)" <> 0)) and
                                        (not PayE."Not Included in Net Pay") then begin
                                        PayDetailLine.CALCFIELDS("Split Entries");
                                        if PayDetailLine."Split Entries" = 0 then //py2.0
                                                                                  // 28.07.2017 : A2+
                                                                                  //ProcessCostNetAccounts('COST',PayDetailLine."Calculated Amount",PayDetailLine."Calculated Amount (ACY)",FALSE)
                                            ProcessCostNetAccounts('COST', PayDetailLine."Calculated Amount", PayDetailLine."Calculated Amount (ACY)", false, Sub_Payroll_Code)
                                        // 28.07.2017 : A2-
                                        else begin //py2.0+
                                                   //read the correspond split entries (emp#,pay detail line#)
                                                   /*
                                                   TempSplitPayDetLine.RESET;
                                                   TempSplitPayDetLine.DELETEALL;
                                                   SplitPayDetLine.RESET;
                                                   SplitPayDetLine.SETRANGE("Employee No.",PayDetailLine."Employee No.");
                                                   SplitPayDetLine.SETRANGE("Pay Detail Line No.",PayDetailLine."Line No.");
                                                   SplitPayDetLine.SETFILTER("Efective Nb. of Days",'<>0');
                                                   //fill temporary table unique by dim1/dim2 directly Insert/Modify
                                                   IF SplitPayDetLine.FIND('-') THEN
                                                     REPEAT
                                                       TempSplitPayDetLine.SETRANGE(TempSplitPayDetLine."Shortcut Dimension 1 Code",
                                                                                     SplitPayDetLine."Shortcut Dimension 1 Code");
                                                       TempSplitPayDetLine.SETRANGE(TempSplitPayDetLine."Shortcut Dimension 2 Code",
                                                                                     SplitPayDetLine."Shortcut Dimension 2 Code");
                                                       IF TempSplitPayDetLine.FIND('-') THEN BEGIN
                                                          TempSplitPayDetLine."Calculated Amount" := TempSplitPayDetLine."Calculated Amount" +
                                                                                                    SplitPayDetLine."Calculated Amount";
                                                          TempSplitPayDetLine."Calculated Amount (ACY)" := TempSplitPayDetLine."Calculated Amount (ACY)" +
                                                                                                          SplitPayDetLine."Calculated Amount (ACY)";
                                                          TempSplitPayDetLine.MODIFY;
                                                       END ELSE BEGIN
                                                             TempSplitPayDetLine.INIT;
                                                             TempSplitPayDetLine."Employee No." := SplitPayDetLine."Employee No.";
                                                             TempSplitPayDetLine."Pay Detail Line No." := SplitPayDetLine."Pay Detail Line No.";
                                                             TempSplitPayDetLine."Line No." := SplitPayDetLine."Line No.";
                                                             TempSplitPayDetLine."Shortcut Dimension 1 Code" := SplitPayDetLine."Shortcut Dimension 1 Code";
                                                             TempSplitPayDetLine."Shortcut Dimension 2 Code" := SplitPayDetLine."Shortcut Dimension 2 Code";
                                                             TempSplitPayDetLine."Calculated Amount" := SplitPayDetLine."Calculated Amount";
                                                             TempSplitPayDetLine."Calculated Amount (ACY)" := SplitPayDetLine."Calculated Amount (ACY)";
                                                             TempSplitPayDetLine.INSERT;
                                                       END;
                                                     UNTIL SplitPayDetLine.NEXT = 0;
                                                   TempSplitPayDetLine.RESET;
                                                   IF TempSplitPayDetLine.FIND('-') THEN
                                                     REPEAT
                                                     ProcessCostNetAccounts('COST',TempSplitPayDetLine."Calculated Amount",
                                                                            TempSplitPayDetLine."Calculated Amount (ACY)",TRUE);
                                                     UNTIL TempSplitPayDetLine.NEXT = 0; */
                                        end; //split py2.0-
                                    end; // calcamt<>0

                                end; //income.tax chk

                            end; // <>PensionScheme
                                 // 2-

                        end; //gl integ2
                             // 1+

                        if VFinalize = true then begin
                            // 28.07.2017 : A2+
                            if Sub_Payroll_Code = '' then begin
                                UpdateLoan;
                                PayDetailLine."Payroll Date" := PayStatus."Payroll Date";
                                PayDetailLine."Tax Year" := TaxYear;
                                PayDetailLine.Period := PeriodNo;
                                PayDetailLine.MODIFY;
                            end;
                            // 28.07.2017 : A2-
                        end; // finalize

                        if NoOfRecs <> 0 then
                            Window.UPDATE(5, ROUND(RecNo / NoOfRecs * 10000, 1));

                    until PayDetailLine.NEXT = 0; //PayDetLine

                if PayDetFound = true then begin
                    PayLedgEntry.GET(PayLedgEntryNo);
                    if PayParam."Integrate to G/L" = true then begin
                        if (PayLedgEntry."Net Pay" <> 0) or (PayLedgEntry."Net Pay (ACY)" <> 0) then begin
                            // 28.07.2017 : A2+
                            //  ProcessCostNetAccounts('NET',PayLedgEntry."Net Pay",PayLedgEntry."Net Pay (ACY)",FALSE);
                            ProcessCostNetAccounts('NET', PayLedgEntry."Net Pay", PayLedgEntry."Net Pay (ACY)", false, Sub_Payroll_Code);
                            // 28.07.2017 : A2-
                            //EDM.IT+
                        end;
                        PayLedgEntry.GET(PayLedgEntryNo);
                        if (PayLedgEntry.Rounding <> 0) then begin
                            // 28.07.2017 : A2+
                            //  ProcessCostNetAccountsRound('NET',-1*PayLedgEntry.Rounding,0,FALSE);
                            ProcessCostNetAccountsRound('NET', -1 * PayLedgEntry.Rounding, 0, false, Sub_Payroll_Code);
                            // 28.07.2017 : A2-
                            //EDM.IT-
                        end; // netamt<>0

                        //EDM.IT++++
                        // 28.07.2017 : A2+
                        //ProcessCostNetAccountsPay('NET',PayLedgEntry."Net Pay",0,FALSE);
                        //ProcessBankAccount('NET',-1*PayLedgEntry."Net Pay",0,FALSE);
                        ProcessCostNetAccountsPay('NET', PayLedgEntry."Net Pay", 0, false, Sub_Payroll_Code);
                        //EDM+ Special Calculation 02-02-2021
                        HRSetup.GET;
                        IF HRSetup."Use Payroll Special Calculation" then begin
                            ProcessBankAccountSpecialCalculation('NET', -1 * PayLedgEntry."Net Pay", 0, false, Sub_Payroll_Code);
                            ProcessDifferenceAccountSpecialCalculation('NET', -1 * PayLedgEntry."Net Pay", 0, false, Sub_Payroll_Code);
                        end
                        ELSE
                            //EDM- Special Calculation 02-02-2021
                            ProcessBankAccount('NET', -1 * PayLedgEntry."Net Pay", 0, false, Sub_Payroll_Code);
                        // 28.07.2017 : A2-
                        //EDM.IT----

                    end; // gl.integ3

                    if VFinalize = true then begin
                        // 28.07.2017 : A2+
                        if Sub_Payroll_Code = '' then begin
                            UpdateAbsences;
                            UpdateSplitEmpJnls;
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
                            //py2.0+
                            if Employee.Status <> Employee.Status::Active then
                                PayDetailHeader."Include in Pay Cycle" := false;
                            UpdateDailySales;
                            //py2.0-
                            PayDetailHeader.MODIFY;
                        end;
                        // 28.07.2017 : A2-
                    end; // finalize1

                end; //paydetfound

            // py2.0 END; // payDetHeader
            until Employee.NEXT = 0; // Emp - Inc.in Pay Cycle

        // 19.03.2018 - TarekH.+
        //Loop on all employees to close the JV. Very small difference occurs and should be closed on the last line
        if PayParam."Group By Dimension" = '' then
            VBatchName := PayParam."Journal Batch Name"
        else
            VBatchName := PayParam."Temp Batch Name";

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
        // 19.03.2018 - TarekH.-

        if VFinalize = true then begin
            PostPayRegister;
            if PayParam."Integrate to G/L" = true then begin
                Loop := 1;
                while Loop <= 2 do begin
                    if Loop = 1 then begin
                        // NEW MOD.
                        if PayParam."Group By Dimension" = '' then
                            VBatchName := PayParam."Journal Batch Name"
                        else
                            VBatchName := PayParam."Temp Batch Name";
                        // NEW MOD.
                    end else
                        VBatchName := PayParam."Journal Batch Name (ACY)";

                    GenJnlLine.RESET;
                    //GenJnlLine.SETRANGE("Journal Template Name",PayParam."Journal Template Name");
                    //GenJnlLine.SETRANGE("Journal Batch Name",VBatchName);
                    //IF GenJnlLine.FIND('-') THEN
                    // CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
                    //GenJnlPost.Code(GenJnlLine,FALSE);
                    Loop := Loop + 1;
                end; //loop
            end; //gl integ4
        end; //finalize2

        Window.CLOSE;

    end;

    local procedure SetupPayrollInfo();
    var
        StartDate: Date;
        EndDate: Date;
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        // Get the Payment Codes from the payroll parameter record
        PayParam.GET;
        Day := DATE2DMY(PayStatus."Payroll Date", 1);
        Month := DATE2DMY(PayStatus."Payroll Date", 2);
        Year := DATE2DMY(PayStatus."Payroll Date", 3);
        TaxYear := Year;
        // Setup the payroll title,and payroll number
        PayrollTitle := 'Week No. ';
        PeriodNo := DATE2DMY(PayStatus."Payroll Date", 2);
        case PayStatus."Pay Frequency" of
            PayStatus."Pay Frequency"::Weekly:
                begin
                    PayrollNo := 'W'; //py1.2
                end;
            PayStatus."Pay Frequency"::Monthly:
                begin
                    PayrollNo := 'M'; //py1.2
                    PayrollTitle := 'Month No. ';
                end;
        end;
        PayrollNo := FORMAT(Year) + PayrollNo + FORMAT(PeriodNo);
        PayrollTitle := PayrollTitle + FORMAT(PeriodNo) + ' - ' + PayStatus."Payroll Group Code" + ' - ';
    end;

    procedure UpdateLoan();
    var
        EmployeeLoanLine: Record "Employee Loan Line";
    begin
        EmpLoan.RESET;
        EmpLoan.SETCURRENTKEY("Employee No.", "Associated Pay Element");
        EmpLoan.SETRANGE("Employee No.", Employee."No.");
        EmpLoan.SETRANGE("Associated Pay Element", PayDetailLine."Pay Element Code");
        //EDM+
        EmpLoan.SETRANGE("Loan No.", PayDetailLine."Loan No.");
        EmpLoan.SETFILTER("Date of Loan", '<=%1', PayDetailLine."Payroll Date");
        //EDM-
        EmpLoan.SETRANGE(Completed, false);
        if EmpLoan.FIND('-') then begin
            if not EmpLoan."In Additional Currency" then
                VCalcAmount := PayDetailLine."Calculated Amount"
            else
                VCalcAmount := PayDetailLine."Calculated Amount (ACY)";
            EmpLoan."Total Payments Made" := EmpLoan."Total Payments Made" + VCalcAmount;
            if EmpLoan.Payment <> 0 then
                EmpLoan."No. of Payments Made" :=
                     EmpLoan."No. of Payments Made" + 1;//EDM.IT ROUND(VCalcAmount/EmpLoan.Payment,1,'>');
            EmpLoan."Final Payment" := VCalcAmount;
            if (EmpLoan."No. of Payments Made" = EmpLoan."No. of Payments") or (EmpLoan."Total Payments Made" = EmpLoan.Amount) then
                EmpLoan.Completed := true;
            EmpLoan.MODIFY;
        end; // Loan
        //EDM+
        EmployeeLoanLine.SETRANGE("Employee No.", Employee."No.");
        EmployeeLoanLine.SETRANGE("Loan No.", PayDetailLine."Loan No.");
        EmployeeLoanLine.SETFILTER("Payment Date", '<=%1', PayDetailLine."Payroll Date");
        EmployeeLoanLine.SETRANGE(Completed, false);
        if EmployeeLoanLine.FINDFIRST then
            repeat
                EmployeeLoanLine.Completed := true;
                EmployeeLoanLine.MODIFY;
            until EmployeeLoanLine.NEXT = 0;
        //EDM-
    end;

    procedure ProcessCostNetAccounts(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    var
        PayElement: Record "Pay Element";
    begin
        Loop := 1;
        while Loop <= 2 do begin
            if Loop = 1 then begin
                VCurrencyCode := '';
                // NEW MOD.
                if PayParam."Group By Dimension" = '' then
                    VBatchName := PayParam."Journal Batch Name"
                else
                    VBatchName := PayParam."Temp Batch Name";
                // NEW MOD.

                if P_CostNet = 'COST' then begin
                    // 14.03.2018 : A2+
                    PayElementDesc := '';
                    PayElement.RESET;
                    PayElement.SETRANGE(Code, PayE.Code);
                    IF PayElement.FINDFIRST THEN
                        PayElementDesc := PayElement.Description;
                    // 14.03.2018 : A2-

                    VCalcAmount := P_CalcAmtLCY;
                    //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM +
                    //NEW++
                    PayrollElementPostingGroup.SETRANGE("Payroll Posting Group", PayPostG.Code);
                    PayrollElementPostingGroup.SETRANGE("Pay Element", PayE.Code);
                    if PayrollElementPostingGroup.FINDFIRST then
                        VAccountNo := PayrollElementPostingGroup."Posting Account"
                    else
                        //NEW--
                        //Imported from AVSI Database in order to post pay element to different Accounts (NEW--) - 26.01.2016 : AIM -
                        VAccountNo := PayE."Posting Account";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Cost of Payroll Account";
                end else begin
                    PayElementDesc := ''; // 14.03.2018 : A2+-
                    VCalcAmount := P_CalcAmtLCY;
                    VAccountNo := PayPostG."Net Pay Account";
                end; // net
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
                end; //net
            end; // loop=2
            if (P_CostNet = 'COST') and (PayE.Type = PayE.Type::Deduction) then
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
                            // 28.07.2017 : A2+
                            //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                            InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                        // 28.07.2017 : A2-
                    end else
                        // 28.07.2017 : A2+
                        //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                        InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                    // 28.07.2017 : A2-
                end else // test.final.
                         // 28.07.2017 : A2+
                         //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                    InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end; // calcamt<>0
            Loop := Loop + 1;
        end; // Loop on 2 ccys
    end;

    procedure UpdateAbsences();
    begin
        EmpJnlLine.RESET;
        //Modified in order to set Attendance journals as processed / Wrong Validation - 06.07.2016 : AIM +
        //EmpJnlLine.SETCURRENTKEY("Payroll Ledger Entry No.");
        //EmpJnlLine.SETRANGE("Payroll Ledger Entry No.",PayLedgEntryNo);
        EmpJnlLine.SETRANGE(Processed, false);
        //Modified in order to set Attendance journals as processed / Wrong Validation - 06.07.2016 : AIM +
        EmpJnlLine.SETRANGE(Type, 'ABSENCE');

        //Added in order not to consider all employees or Employees in all groups - 01.12.2016 : AIM +
        EmpJnlLine.SETRANGE(EmpJnlLine."Employee No.", Employee."No.");
        //Added in order not to consider all employees or Employees in all groups - 01.12.2016 : AIM -

        //Added in order to modify only the records that falls within the Payroll Interval - 07.12.2016 : AIM +
        // Modified in order to consider Attendance Interval - 18.09.2017 : A2+
        //EmpJnlLine.SETFILTER(EmpJnlLine."Starting Date",'%1..%2',PayStatus."Period Start Date",PayStatus."Period End Date");
        if PayFunction.IsSeparateAttendanceInterval(PayStatus."Payroll Group Code") then
            EmpJnlLine.SETFILTER("Starting Date", '%1..%2', PayStatus."Attendance Start Date", PayStatus."Attendance End Date")
        else
            EmpJnlLine.SETFILTER(EmpJnlLine."Starting Date", '%1..%2', PayStatus."Period Start Date", PayStatus."Period End Date");
        // Modified in order to consider Attendance Interval - 18.09.2017 : A2-
        //Added in order to modify only the records that falls within the Payroll Interval - 07.12.2016 : AIM -


        EmpJnlLine.MODIFYALL("Processed Date", PayStatus."Payroll Date");
        EmpJnlLine.MODIFYALL(Processed, true);
    end;

    procedure UpdateSplitEmpJnls();
    var
        EmpJnlLine: Record "Employee Journal Line";
        EmpJnlLine2: Record "Employee Journal Line";
    begin
        //shr2.0+
        EmpJnlLine.RESET;

        //Modified in order to set Benefit AND deduction journals as processed / Wrong Validation - 06.07.2016 : AIM +
        //EmpJnlLine.SETCURRENTKEY("Payroll Ledger Entry No.");
        //EmpJnlLine.SETRANGE("Payroll Ledger Entry No.",PayLedgEntryNo);
        //EmpJnlLine.SETRANGE(Split,TRUE);
        EmpJnlLine.SETRANGE(Processed, false);
        EmpJnlLine.SETFILTER(Type, '<>%1', 'ABSENCE');
        //Modified in order to set Benefit AND deduction journals as processed / Wrong Validation - 06.07.2016 : AIM -

        //Added in order not to consider all employees or Employees in all groups - 01.12.2016 : AIM +
        EmpJnlLine.SETRANGE(EmpJnlLine."Employee No.", Employee."No.");
        //Added in order not to consider all employees or Employees in all groups - 01.12.2016 : AIM -

        //Added in order to modify only the records that falls within the Payroll Interval - 07.12.2016 : AIM +
        EmpJnlLine.SETFILTER(EmpJnlLine."Transaction Date", '%1..%2', PayStatus."Period Start Date", PayStatus."Period End Date");
        //Added in order to modify only the records that falls within the Payroll Interval - 07.12.2016 : AIM -


        EmpJnlLine.MODIFYALL("Processed Date", PayStatus."Payroll Date");
        EmpJnlLine.MODIFYALL(Processed, true);
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
                end; // create recurring lines
                     //py2.0+
                SplitPayDetailLine.RESET;
                SplitPayDetailLine.SETRANGE("Employee No.", PayDetailLine."Employee No.");
                SplitPayDetailLine.SETRANGE("Pay Detail Line No.", PayDetailLine."Line No.");
                SplitPayDetailLine.MODIFYALL(Open, false);
                SplitPayDetailLine.MODIFYALL("Posting Date", PayStatus."Payroll Date");
                //py2.0-
                PayDetailLine.Open := false;
                PayDetailLine.MODIFY;
            until PayDetailLine.NEXT = 0;
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

    procedure UpdateDailySales();
    begin
        /*DailySales.SETCURRENTKEY("Month From","Shift Group Code","Working Shift Code","Global Dimension 1 Code",
                                 "Global Dimension 2 Code",Processed,Applied);
        DailySales.SETRANGE(Applied,TRUE);
        DailySales.SETRANGE(Processed,FALSE);
        IF DailySales.FIND('-') THEN
        REPEAT
          DailySales2.COPY(DailySales);
          DailySales2.Processed := TRUE;
          DailySales2.MODIFY;
        UNTIL DailySales.NEXT = 0;
        */

    end;

    procedure ProcessCostNetAccountsRound(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    begin
        Loop := 1;
        while Loop <= 2 do begin
            if Loop = 1 then begin
                VCurrencyCode := '';
                VBatchName := PayParam."Temp Batch Name"; //PayParam."Journal Batch Name"; NEW MOD;
                if P_CostNet = 'COST' then begin
                    VCalcAmount := P_CalcAmtLCY;
                    //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM +
                    //NEW++
                    PayrollElementPostingGroup.SETRANGE("Payroll Posting Group", PayPostG.Code);
                    PayrollElementPostingGroup.SETRANGE("Pay Element", PayE.Code);
                    if PayrollElementPostingGroup.FINDFIRST then
                        VAccountNo := PayrollElementPostingGroup."Posting Account"
                    else
                        //NEW--
                        //Imported from AVSI Database in order to post pay element to different Accounts (NEW--) - 26.01.2016 : AIM -
                        VAccountNo := PayE."Posting Account";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Rounding Account";
                end else begin
                    VCalcAmount := P_CalcAmtLCY;
                    VAccountNo := PayPostG."Rounding Account";
                end; // net
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
                end; //net
            end; // loop=2
            if (P_CostNet = 'COST') and (PayE.Type = PayE.Type::Deduction) then
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
                            // 28.07.2017 : A2+
                            //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                            InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                        // 28.07.2017 : A2-
                    end else
                        // 28.07.2017 : A2+
                        //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                        InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                    // 28.07.2017 : A2-
                end else // test.final.
                         // 28.07.2017 : A2+
                         //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                    InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end; // calcamt<>0
            Loop := Loop + 1;
        end; // Loop on 2 ccys
    end;

    procedure ProcessCostNetAccountsPay(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    begin
        Loop := 1;
        while Loop <= 2 do begin
            if Loop = 1 then begin
                VCurrencyCode := '';
                //IF PayStatus."Payment Category" = PayStatus."Payment Category"::Supplement THEN
                //  VBatchName := PayParam."NSSF EOSI"
                ///ELSE
                //NEW MOD.
                // 11.10.2017 : A2+
                //IF PayParam."Group By Dimension" = '' THEN
                IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Pay Batch Name" = '') OR
                   (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                    // 11.10.2017 : A2-
                    VBatchNamePay := PayParam."Journal Batch Name Pay"
                else
                    VBatchNamePay := PayParam."Temp Pay Batch Name";

                //message(VBatchName);

                if P_CostNet = 'COST' then begin
                    VCalcAmount := P_CalcAmtLCY;
                    //Imported from AVSI Database in order to post pay element to different Accounts (NEW++) - 26.01.2016 : AIM +
                    //NEW++
                    PayrollElementPostingGroup.SETRANGE("Payroll Posting Group", PayPostG.Code);
                    PayrollElementPostingGroup.SETRANGE("Pay Element", PayE.Code);
                    if PayrollElementPostingGroup.FINDFIRST then
                        VAccountNo := PayrollElementPostingGroup."Posting Account"
                    else
                        //NEW--
                        //Imported from AVSI Database in order to post pay element to different Accounts (NEW--) - 26.01.2016 : AIM -

                        VAccountNo := PayE."Posting Account";
                    if VAccountNo = '' then
                        VAccountNo := PayPostG."Cost of Payroll Account";
                end else begin
                    VCalcAmount := P_CalcAmtLCY;
                    VAccountNo := PayPostG."Net Pay Account";
                end; // net
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
                end; //net
            end; // loop=2
            if (P_CostNet = 'COST') and (PayE.Type = PayE.Type::Deduction) then
                VCalcAmount := VCalcAmount;//* (-1);
            if P_CostNet = 'NET' then
                VCalcAmount := VCalcAmount;//* (-1);
            if VCalcAmount <> 0 then begin
                if VFinalize = true then begin
                    if PayParam."Summary Payroll to GL Transfer" then begin //summary
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", VBatchNamePay);
                        GenJnlLine.SETRANGE("Account No.", VAccountNo);
                        if GenJnlLine.FIND('-') then begin
                            GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + VCalcAmount);
                            GenJnlLine.MODIFY;
                        end else
                            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                            // 28.07.2017 : A2+
                            //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                            InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                        // 28.07.2017 : A2-
                    end else
                        //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                        // 28.07.2017 : A2+
                        //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                        InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                    // 28.07.2017 : A2-
                end else // test.final.
                         //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                         // 28.07.2017 : A2+
                         //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                    InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end; // calcamt<>0
            Loop := Loop + 1;
        end; // Loop on 2 ccys
    end;

    procedure ProcessBankAccount(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    begin
        VCalcAmount := P_CalcAmtLCY;
        VAccountNo := PayPostG."Bank Pay Account";
        if VFinalize = true then begin
            if PayParam."Summary Payroll to GL Transfer" then begin //summary
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", VBatchName);
                GenJnlLine.SETRANGE("Account No.", VAccountNo);
                if GenJnlLine.FIND('-') then begin
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE(Amount, (GenJnlLine.Amount + VCalcAmount));
                    GenJnlLine.MODIFY;
                end else
                    //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    // 28.07.2017 : A2+
                    //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end else
                //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                // 28.07.2017 : A2+
                //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
            // 28.07.2017 : A2-
        end else // test.final.
            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            // 28.07.2017 : A2+
            //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
        // 28.07.2017 : A2-
    end;

    procedure ProcessBankAccountSpecialCalculation(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    var
        HRSEtup: Record "Human Resources Setup";
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        PayrollParameterRec.GET;
        VCalcAmount := ROUND((P_CalcAmtLCY / 2) + (((P_CalcAmtLCY / 2) * PayrollParameterRec."ACY Currency Rate") / PayrollParameterRec."Monthly ACY Currency Rate"), 0.01, '=');
        VAccountNo := PayPostG."Bank Pay Account";
        if VFinalize = true then begin
            if PayParam."Summary Payroll to GL Transfer" then begin //summary
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", VBatchName);
                GenJnlLine.SETRANGE("Account No.", VAccountNo);
                if GenJnlLine.FIND('-') then begin
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE(Amount, (GenJnlLine.Amount + VCalcAmount));
                    GenJnlLine.MODIFY;
                end else
                    //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    // 28.07.2017 : A2+
                    //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end else
                //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                // 28.07.2017 : A2+
                //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
            // 28.07.2017 : A2-
        end else // test.final.
            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            // 28.07.2017 : A2+
            //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
        // 28.07.2017 : A2-
    end;

    procedure ProcessDifferenceAccountSpecialCalculation(P_CostNet: Code[10]; P_CalcAmtLCY: Decimal; P_CalcAmtACY: Decimal; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    var
        HRSEtup: Record "Human Resources Setup";
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        PayrollParameterRec.GET;
        VCalcAmount := P_CalcAmtLCY - ROUND((P_CalcAmtLCY / 2) + (((P_CalcAmtLCY / 2) * PayrollParameterRec."ACY Currency Rate") / PayrollParameterRec."Monthly ACY Currency Rate"), 0.01, '=');
        VAccountNo := PayPostG."Difference Account";

        if VFinalize = true then begin
            if PayParam."Summary Payroll to GL Transfer" then begin //summary
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", VBatchName);
                GenJnlLine.SETRANGE("Account No.", VAccountNo);
                if GenJnlLine.FIND('-') then begin
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE(Amount, (GenJnlLine.Amount + VCalcAmount));
                    GenJnlLine.MODIFY;
                end else
                    //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    // 28.07.2017 : A2+
                    //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end else
                //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                // 28.07.2017 : A2+
                //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
            // 28.07.2017 : A2-
        end else // test.final.
            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            // 28.07.2017 : A2+
            //InsertGenJnlLinePayWithDim(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            InsertGenJnlLinePayWithDim(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
        // 28.07.2017 : A2-
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
        //EDM_29.09.2017+
        PayParam.GET;
        //EDM_29.09.2017-
        // 03.08.2017 : A2+
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
        // 03.08.2017 : A2-

        //EDM.IT Dim++
        EmployeeDimensions.SETRANGE("Employee No.", Employee."No.");
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            EmployeeDimensions.SETRANGE("Payroll Date", PayDate)
        else
            EmployeeDimensions.SETRANGE("Payroll Date", DefaultPayDate);
        // 28.07.2017 : A2-
        //EmployeeDimensions.SETRANGE("Payroll Date",DMY2DATE(31,12,2015));
        if EmployeeDimensions.FINDFIRST then begin
            repeat
                //EDM.IT Dim--
                if P_CurrencyCode = '' then begin
                    if (not VFinalize) or
                       ((VFinalize) and (not PayParam."Summary Payroll to GL Transfer")) then
                        VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20) //py1.2
                    else
                        VDocNo := COPYSTR(PayrollNo, 1, 20); //py1.2
                                                             //NEW MOD.
                                                             // 11.10.2017 : NEW MOD+
                                                             //IF PayParam."Group By Dimension" = '' THEN
                    IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Batch Name" = '') OR
                       (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                        // 11.10.2017 : NEW MOD-
                        BatchName := PayParam."Journal Batch Name"
                    else
                        BatchName := PayParam."Temp Batch Name"; // NEW MOD.
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
                end; // ACY
                GenJnlLine2.INIT;
                GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
                GenJnlLine2."Line No." := LineNo;
                // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.VALIDATE("Posting Date", PayDate)
                else
                    GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
                // 28.07.2017 : A2-
                //GenJnlLine2.VALIDATE("Posting Date",DMY2DATE(31,12,2015));
                GenJnlLine2."Source Code" := PayPostG."Source Code";
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
                GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
                // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.VALIDATE("Document No.", VDocNo)
                else
                    GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
                // 28.07.2017 : A2-
                GenJnlLine2.VALIDATE("Currency Code", P_CurrencyCode);
                if P_BalAccountNo <> '' then begin
                    GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
                    GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
                end;
                // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.Description := PayrollTitle
                else
                    GenJnlLine2.Description := DefaultDesc;
                // 28.07.2017 : A2-
                // 25.01.2018 : A2+
                GenJnlLine2.Comment := PayElementDesc;
                // 25.01.2018 : A2-
                if (not VFinalize) or
                   ((VFinalize) and (not PayParam."Summary Payroll to GL Transfer")) then begin
                    Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
                    //  GenJnlLine2."Description 2" := COPYSTR(Desc2,1,50);
                    GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
                    //py2.0+
                    if not P_SplitEntry then begin
                        GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                        GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
                    end else begin
                        GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                        GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");
                    end; //split
                         //py2.0-

                end; //assign Desc+Dims
                     //EDM.IT+
                     // IF DimensionValue.GET('EMPLOYEE',Employee."No.") THEN
                     // BEGIN
                     //   v_DimensionNo := DimMgt.GetConsolidatedDimFilterByDimFilter('EMPLOYEE');
                     //   GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,Employee."No.")
                     ///  END;

                //EDM.IT DIM+
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
                //Stopped By EDM.MM GenJnlLine2.VALIDATE("Attention To",Employee."Full Name");
                GenJnlLine2.VALIDATE(GenJnlLine2.Comment, Employee."Full Name");

                //v_DimensionNo := DimMgt.GetDimensionNo(EmployeeDimensions."Dimension Code");
                // GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,EmployeeDimensions."Dimension Value Code");
                //EDM.IT DIM-
                //EDM.IT-

                GenJnlLine2.VALIDATE(Amount, P_CalcAmount * EmployeeDimensions.Percentage / 100);//+-GenJnlLine2.VALIDATE(Amount,P_CalcAmount);
                                                                                                 // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.VALIDATE("Document Date", PayDate)
                else
                    GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
                // 28.07.2017 : A2-
                //GenJnlLine2.VALIDATE("Document Date",DMY2DATE(31,12,2015));
                //EDM_05092017
                if (PayParam."Use Payroll ACY Rate") and (PayParam."ACY Currency Rate" <> 0) then
                    if GenJnlLine2."Currency Code" = '' then begin
                        GenJnl2AmountLCY := P_CalcAmount * (EmployeeDimensions.Percentage / 100);

                        GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                        case PayParam."ACY Exchange Operation" of
                            PayParam."ACY Exchange Operation"::Division:
                                GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY / PayParam."ACY Currency Rate");
                            PayParam."ACY Exchange Operation"::Multiplication:
                                GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * PayParam."ACY Currency Rate");
                        end;
                        //EDM_29.09.2017+
                        if ROUND(GenJnl2AmountLCY, 0.01, '=') <> 0 then
                            //EDM_29.09.2017-
                            GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY);
                        GenJnlLine2.ValidateShortcutDimCode(8, EmployeeDimensions."Shortcut Dimension 8 Code");
                    end;
                //EDM_05092017
                GenJnlLine2.INSERT;
            until EmployeeDimensions.NEXT = 0;//EDM.IT Dim+-
        end
        else begin
            if P_CurrencyCode = '' then begin
                if (not VFinalize) or
                   ((VFinalize) and (not PayParam."Summary Payroll to GL Transfer")) then
                    VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20) //py1.2
                else
                    VDocNo := COPYSTR(PayrollNo, 1, 20); //py1.2
                                                         // NEW MOD.
                                                         // 11.10.2017 : NEW MOD +
                                                         //IF PayParam."Group By Dimension" = '' THEN
                if (PayParam."Group By Dimension" = '') or
                   (PayParam."Temp Pay Batch Name" = '') or
                   (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
                    // 11.10.2017 : NEW MOD -
                    BatchName := PayParam."Journal Batch Name"
                else
                    BatchName := PayParam."Temp Batch Name";
                // NEW MOD.

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
            end; // ACY
            GenJnlLine2.INIT;
            GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name");
            GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
            GenJnlLine2."Line No." := LineNo;
            // 28.07.2017 : A2+
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Posting Date", PayDate)
            else
                GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
            // 28.07.2017 : A2-
            //GenJnlLine2.VALIDATE("Posting Date",DMY2DATE(31,12,2015));
            GenJnlLine2."Source Code" := PayPostG."Source Code";
            GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
            GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
            // 28.07.2017 : A2+
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document No.", VDocNo)
            else
                GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
            // 28.07.2017 : A2-
            GenJnlLine2.VALIDATE("Currency Code", P_CurrencyCode);
            if P_BalAccountNo <> '' then begin
                GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
                GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
            end;
            // 28.07.2017 : A2+
            if Sub_Payroll_Code = '' then
                GenJnlLine2.Description := PayrollTitle
            else
                GenJnlLine2.Description := DefaultDesc;
            // 28.07.2017 : A2-
            // 25.01.2018 : A2+
            GenJnlLine2.Comment := PayElementDesc;
            // 25.01.2018 : A2-
            if (not VFinalize) or
               ((VFinalize) and (not PayParam."Summary Payroll to GL Transfer")) then begin
                Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
                //  GenJnlLine2."Description 2" := COPYSTR(Desc2,1,50);
                GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
                //py2.0+
                if not P_SplitEntry then begin
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
                end else begin
                    GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                    GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");

                end; //split
                     //py2.0-
            end; //assign Desc+Dims
                 //EDM.IT+
                 /*   GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code",EmployeeDimensions."Shortcut Dimension 1 Code");
                     GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code",EmployeeDimensions."Shortcut Dimension 2 Code");
                     GenJnlLine2.ValidateShortcutDimCode(3,EmployeeDimensions."Shortcut Dimension 3 Code");
                     GenJnlLine2.ValidateShortcutDimCode(4,EmployeeDimensions."Shortcut Dimension 4 Code");
                     GenJnlLine2.ValidateShortcutDimCode(5,EmployeeDimensions."Shortcut Dimension 5 Code");
                     GenJnlLine2.ValidateShortcutDimCode(6,EmployeeDimensions."Shortcut Dimension 6 Code");
                     GenJnlLine2.ValidateShortcutDimCode(7,EmployeeDimensions."Shortcut Dimension 7 Code");
                     GenJnlLine2.ValidateShortcutDimCode(8,EmployeeDimensions."Shortcut Dimension 8 Code");
                 IF DimensionValue.GET('EMPLOYEE',Employee."No.") THEN
                   BEGIN
                     v_DimensionNo := DimMgt.GetDimensionNo('EMPLOYEE');
                     GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,Employee."No.")
                   END;*/
                 //EDM.IT-
                 //EDM_16052017
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
            //EDM_16052017
            GenJnlLine2.VALIDATE(Amount, P_CalcAmount);
            //GenJnlLine2.VALIDATE("Document Date",DMY2DATE(31,12,2015));
            // 28.07.2017 : A2+
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document Date", PayDate)
            else
                GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
            // 28.07.2017 : A2-
            //EDM_05092017
            // 24.10.2017 : A2+
            //IF (PayParam."ACY Currency Rate" <> 0)  THEN
            if (PayParam."ACY Currency Rate" <> 0) and (PayParam."Use Payroll ACY Rate") then
                // 24.10.2017 : A2-
                if GenJnlLine2."Currency Code" = '' then begin
                    GenJnl2AmountLCY := GenJnlLine2.Amount;
                    GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                    case PayParam."ACY Exchange Operation" of
                        PayParam."ACY Exchange Operation"::Division:
                            GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY / PayParam."ACY Currency Rate");
                        PayParam."ACY Exchange Operation"::Multiplication:
                            GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * PayParam."ACY Currency Rate");
                    end;
                    //EDM_29.09.2017+
                    if ROUND(GenJnl2AmountLCY, 0.01, '=') <> 0 then
                        //EDM_29.09.2017-
                        GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY);
                end;
            //EDM_05092017

            GenJnlLine2.INSERT;
        end;

    end;

    procedure InsertGenJnlLinePay(P_AccountNo: Code[20]; P_BalAccountNo: Code[20]; P_CalcAmount: Decimal; P_CurrencyCode: Code[10]; P_SplitEntry: Boolean; P_SummarizeGL: Boolean; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; Sub_Payroll_Code: Code[20]);
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
        // 28.09.2017 : A2+
        GLSetup.GET;
        PayParam.GET;
        // 28.09.2017 : A2-
        // 03.08.2017 : A2+
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
        // 03.08.2017 : A2-

        if P_CurrencyCode = '' then begin
            if (not VFinalize) or
               ((VFinalize) and (not P_SummarizeGL)) then
                VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20) //py1.2
            else
                VDocNo := COPYSTR(PayrollNo, 1, 20); //py1.2
                                                     ///BatchName := PayParam."Journal Batch Name";
            //IF PayStatus."Payment Category" = PayStatus."Payment Category"::"2" THEN
            //   BatchName := PayParam."NSSF EOSI"
            //  ELSE
            //NEW MOD.
            IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Pay Batch Name" = '')
              OR (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                //BatchName :=  PayParam."Journal Batch Name"
                BatchName := PayParam."Journal Batch Name Pay"
            else
                //BatchName := PayParam."Temp Batch Name";
                BatchName := PayParam."Temp Pay Batch Name";
            //NEW MOD.

            ///
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
        end; // ACY


        GenJnlLine2.INIT;
        GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name Pay");
        GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
        GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
        GenJnlLine2."Line No." := LineNo;
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Posting Date", PayStatus."Payroll Date")
        else
            GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
        // 28.07.2017 : A2-
        GenJnlLine2."Source Code" := PayPostG."Source Code";
        // 02.03.2018 : A2+
        /*IF AccountType = AccountType::"Bank Account" THEN
          BEGIN
            //EDM_16052017
            if (Employee."Payment Method" <> Employee."Payment Method"::Cash)
                     and (Employee."Bank No." <> '') then
              BankAcc.GET(Employee."Bank No.")
            else
              BankAcc.GET(P_AccountNo);
          END;*/
        IF AccountType = AccountType::"Bank Account" THEN BEGIN
            IF (Employee."Payment Method" <> Employee."Payment Method"::Cash) AND (Employee."Bank No." <> '') THEN
            // 22.02.2018 : A2+
            //BankAcc.GET(Employee."Bank No.")
            BEGIN
                CASE Employee."Payment Method" OF
                    Employee."Payment Method"::Bank:
                        BankAcc.GET(Employee."Bank No.");
                    //EDM+ 17-12-2019
                    Employee."Payment Method"::Cheque:
                        BankAcc.GET(Employee."Bank No.");
                    //EDM-17-12-2019     
                    Employee."Payment Method"::"G/LAccount":
                        GLAccountRec.GET(Employee."Bank No.");
                    Employee."Payment Method"::Vendor:
                        VendorRec.GET(Employee."Bank No.");
                END;
            END
            // 22.02.2018 : A2-
            ELSE
                BankAcc.GET(P_AccountNo);
        END;
        // 02.03.2018 : A2-
        GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
        GenJnlLine2."Account Type" := AccountType;
        IF (Employee."Payment Method" <> Employee."Payment Method"::Cash)
                   AND (Employee."Bank No." <> '') AND (AccountType = AccountType::"Bank Account") THEN
        // 02.03.2018 : A2+
        //GenJnlLine2.VALIDATE("Account No.",Employee."Bank No.")
        BEGIN
            CASE Employee."Payment Method" OF
                Employee."Payment Method"::Bank:
                    BEGIN
                        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                        GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                    END;
                //EDM+ 17-12-2019
                Employee."Payment Method"::Cheque:
                    BEGIN
                        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                        GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                    END;
                //EDM-17-12-2019
                Employee."Payment Method"::"G/LAccount":
                    BEGIN
                        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
                        GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                    END;
                Employee."Payment Method"::Vendor:
                    BEGIN
                        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::Vendor;
                        GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                    END;
            END;
        END
        // 02.03.2018 : A2-
        ELSE
            GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
        //EDM_16052017

        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Document No.", VDocNo)
        else
            GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
        // 28.07.2017 : A2-
        //GenJnlLine2.VALIDATE("Currency Code",P_CurrencyCode);
        if P_BalAccountNo <> '' then begin
            GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
            GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
        end;
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            GenJnlLine2.Description := PayrollTitle
        else
            GenJnlLine2.Description := DefaultDesc;
        // 28.07.2017 : A2-
        if (not VFinalize) or
           ((VFinalize) and (not P_SummarizeGL)) then begin
            Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
            //  GenJnlLine2."Description 2" := COPYSTR(Desc2,1,50);
            GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
            //py2.0+
            if not P_SplitEntry then begin
                GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
            end else begin
                GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");
            end; //split
                 //py2.0-
        end; //assign Desc+Dims
             //EDM+

        //EDM_06032017
        DefaultDimension.SETRANGE("Table ID", 5200);
        DefaultDimension.SETRANGE("No.", Employee."No.");
        if DefaultDimension.FINDFIRST then
            repeat
                v_DimensionNo := PayrollFunctions.GetDimensionNo(DefaultDimension."Dimension Code");
                if v_DimensionNo <> 0 then
                    GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, DefaultDimension."Dimension Value Code");
            until DefaultDimension.NEXT = 0;
        //EDM_06032017

        //commented on 06032017
        //MGH
        /*
            IF DimensionValue.GET('EMPLOYEE',Employee."No.") THEN
              BEGIN
                v_DimensionNo := DimMgt.GetDimensionNo('EMPLOYEE');
                GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,Employee."No.")
              END;
            //IF DefaultDimension.GET(DATABASE::Employee,Employee."No.",'DEPARTMENT') THEN
            //  BEGIN
             //   v_DimensionNo := DimMgt.GetDimensionNo('DEPARTMENT');
             //   GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,DefaultDimension."Dimension Value Code");
            //  END;
            IF DefaultDimension.GET(DATABASE::Employee,Employee."No.",'PROJECT') THEN
              BEGIN
                v_DimensionNo := DimMgt.GetDimensionNo('PROJECT');
                GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,DefaultDimension."Dimension Value Code");
              END;
            IF DefaultDimension.GET(DATABASE::Employee,Employee."No.",'SOURCE') THEN
              BEGIN
                v_DimensionNo := DimMgt.GetDimensionNo('SOURCE');
                GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,DefaultDimension."Dimension Value Code");
              END;
              IF DefaultDimension.GET(DATABASE::Employee,Employee."No.",'TASK') THEN
              BEGIN
                v_DimensionNo := DimMgt.GetDimensionNo('TASK');
                GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,DefaultDimension."Dimension Value Code");
              END;
        */
        //commented on 06032017


        //EDM-
        //MESSAGE(FORMAT(P_CalcAmount));
        if (GenJnlLine2."Account Type" = GenJnlLine2."Account Type"::"G/L Account") and (GenJnlLine2."Currency Code" = '') then begin
            // 19.02.2018 : A2+
            //IF (PayParam."ACY Currency Rate" <> 0) THEN
            if (PayParam."ACY Currency Rate" <> 0) and (PayParam."Use Payroll ACY Rate") then
            // 19.02.2018 : A2-
            begin
                GenJnl2AmountLCY := P_CalcAmount;
                GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                case PayParam."ACY Exchange Operation" of
                    PayParam."ACY Exchange Operation"::Division:
                        GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY / PayParam."ACY Currency Rate");
                    PayParam."ACY Exchange Operation"::Multiplication:
                        GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * PayParam."ACY Currency Rate");
                end;
                GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY);
            END ELSE BEGIN
                if GenJnlLine2."Currency Code" = '' then
                    GenJnlLine2.VALIDATE(Amount, P_CalcAmount)
            end;
        END ELSE BEGIN
            //EDM_07092017
            // 19.02.2018 : A2+
            //IF (GenJnlLine2."Currency Code" = GLSetup."Additional Reporting Currency") AND (PayParam."ACY Currency Rate" > 0) THEN
            if (GenJnlLine2."Currency Code" = GLSetup."Additional Reporting Currency") and (PayParam."ACY Currency Rate" > 0) and (PayParam."Use Payroll ACY Rate") then
            // 19.02.2018 : A2-
            begin
                //GenJnlLine2.VALIDATE(Amount,P_CalcAmount);
                Factor := 1 / PayParam."ACY Currency Rate";//CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date",GenJnlLine2."Currency Code");
                GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                               GenJnlLine2."Currency Code", P_CalcAmount, Factor));
                GenJnlLine2.VALIDATE("Amount (LCY)", P_CalcAmount);
            END ELSE BEGIN
                //GenJnlLine2.VALIDATE(Amount,P_CalcAmount);
                Factor := CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date", GenJnlLine2."Currency Code");
                GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                               GenJnlLine2."Currency Code", P_CalcAmount, Factor));
            end;
        end;
        //EDM_07092017
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Document Date", PayStatus."Payroll Date")
        else
            GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
        // 28.07.2017 : A2-
        //Stopped BY EDM.MM GenJnlLine2.VALIDATE("Attention To",Employee."Full Name");
        GenJnlLine2.VALIDATE(Comment, Employee."Full Name");
        GenJnlLine2.INSERT;
        OnAfterInsertPayrollJournal(GenJnlLine2);
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
        // 11.10.2017 : NEW MOD +
        IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Batch Name" = '') OR
           (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
            exit;
        // 11.10.2017 : NEW MOD -
        //28.03.2018 TAREKH. Added in order to fix the line no. increment
        InsertGenJnlRec.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        InsertGenJnlRec.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name");
        if InsertGenJnlRec.FINDLAST then
            LineNo := InsertGenJnlRec."Line No."
        else
            LineNo := 0;
        //28.03.2018 TAREKH. Added in order to fix the line no. increment
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Name");
        GenJnlLine.SETRANGE(Inserted2, false);
        GenJnlLine.SETRANGE("Bal. Account No.", '');
        if GenJnlLine.FINDFIRST then
            repeat
                TotalAmtCr := 0;
                TotalAmtDbt := 0;
                //EDM_07.09.2017+
                TotalAmtCrLCY := 0;
                TotalAmtDbtLCY := 0;
                //EDM_07.09.2017-
                GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Template Name", PayParam."Journal Template Name");
                GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Batch Name", PayParam."Temp Batch Name");
                GrpGenJnLine.SETRANGE(GrpGenJnLine.Inserted2, false);
                GrpGenJnLine.SETRANGE("Account No.", GenJnlLine."Account No.");
                //EDM-20170905+
                GrpGenJnLine.SETRANGE("Currency Code", GenJnlLine."Currency Code");
                //EDM-20170905-
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    GrpGenJnLine.SETRANGE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
                else
                    if GLSetup."Global Dimension 2 Code" = PayParam."Group By Dimension" then
                        GrpGenJnLine.SETRANGE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                GrpGenJnLine.SETRANGE("Bal. Account No.", '');
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
                    until GrpGenJnLine.NEXT = 0;
                if (TotalAmtDbt <> 0) then begin
                    DocNb := COPYSTR(GenJnlLine."Document No.", 1, STRPOS(GenJnlLine."Document No.", '-') - 1);
                    InsertGenJnlRec.INIT;
                    InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name";
                    InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Name";
                    //28.03.2018 TAREKH. Added in order to fix the line no. increment
                    LineNo += 10000;
                    InsertGenJnlRec."Line No." := LineNo;
                    //28.03.2018 TAREKH. Added in order to fix the line no. increment
                    InsertGenJnlRec.INSERT;
                    InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                    InsertGenJnlRec."Document No." := DocNb;
                    InsertGenJnlRec."Account Type" := InsertGenJnlRec."Account Type"::"G/L Account";
                    InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                    //EDM-20170905+
                    InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                    //EDM-20170905-
                    InsertGenJnlRec.VALIDATE("Debit Amount", TotalAmtDbt);
                    //InsertGenJnlRec.VALIDATE("Debit Amount (LCY)",TotalAmtDbtLCY);
                    if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                        InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
                    else
                        if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                            InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                    //EDM-20170905+
                    if PayParam."Use Payroll ACY Rate" then
                        InsertGenJnlRec.VALIDATE("Amount (LCY)", TotalAmtDbtLCY);
                    //EDM-20170905-
                    InsertGenJnlRec.MODIFY;
                end;
                if (TotalAmtCr <> 0) then begin
                    InsertGenJnlRec.INIT;
                    InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name";
                    InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Name";
                    //28.03.2018 TAREKH. Added in order to fix the line no. increment
                    LineNo += 10000;
                    InsertGenJnlRec."Line No." := LineNo;
                    //28.03.2018 TAREKH. Added in order to fix the line no. increment
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
                    else
                        if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
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
        IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Batch Name" = '') OR
           (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
            exit;
        // 11.10.2017 : NEW MOD -
        GenJnlLine.SETCURRENTKEY("Line No.");
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name");
        if GenJnlLine.FINDLAST then
            LineNb := GenJnlLine."Line No."
        else
            LineNb := 0;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Batch Name");
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
                GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Batch Name", PayParam."Temp Batch Name");
                GrpGenJnLine.SETRANGE(GrpGenJnLine.Inserted2, false);
                GrpGenJnLine.SETRANGE("Account No.", GenJnlLine."Account No.");
                //EDM-20170905+
                GrpGenJnLine.SETRANGE("Currency Code", GenJnlLine."Currency Code");
                //EDM-20170905-
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    GrpGenJnLine.SETRANGE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
                else
                    if GLSetup."Global Dimension 2 Code" = PayParam."Group By Dimension" then
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
                    InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Name";
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
                    else
                        if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                            InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                    InsertGenJnlRec.MODIFY;
                end;
                GenJnlLine.Inserted2 := true;
                GenJnlLine.MODIFY;
            until GenJnlLine.NEXT = 0;
    end;

    procedure InsertGenJnlLinePayWithDim(P_AccountNo: Code[20]; P_BalAccountNo: Code[20]; P_CalcAmount: Decimal; P_CurrencyCode: Code[10]; P_SplitEntry: Boolean; P_SummarizeGL: Boolean; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; Sub_Payroll_Code: Code[20]);
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
        // 03.08.2017 : A2+
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
        // 03.08.2017 : A2-

        EmployeeDimensions.SETRANGE("Employee No.", Employee."No.");
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            EmployeeDimensions.SETRANGE("Payroll Date", PayDate)
        else
            EmployeeDimensions.SETRANGE("Payroll Date", DefaultPayDate);
        // 28.07.2017 : A2-
        if EmployeeDimensions.FINDFIRST then begin
            repeat
                if P_CurrencyCode = '' then begin
                    if (not VFinalize) or
                       ((VFinalize) and (not P_SummarizeGL)) then
                        VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20) //py1.2
                    else
                        VDocNo := COPYSTR(PayrollNo, 1, 20); //py1.2
                                                             //NEW MOD.
                                                             // 11.10.2017 : NEW MOD +
                                                             //IF PayParam."Group By Dimension" = '' THEN
                    IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Pay Batch Name" = '') OR
                       (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") THEN
                    // 11.10.2017 : NEW MOD -
                    BEGIN
                        IF NOT PayParam."Enable Payment Acc. Grouping" THEN //EDM_30012018 By Tarek
                            BatchName := PayParam."Journal Batch Name Pay"   //EDM_30012018 By Tarek
                    END ELSE
                        BatchName := PayParam."Temp Pay Batch Name";
                    //NEW MOD.
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
                // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.VALIDATE("Posting Date", PayStatus."Payroll Date")
                else
                    GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
                // 28.07.2017 : A2-
                GenJnlLine2."Source Code" := PayPostG."Source Code";
                if AccountType = AccountType::"Bank Account" then begin
                    //EDM_16052017
                    //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
                    IF Employee."Payment Method" = Employee."Payment Method"::Cheque THEN
                        GenJnlLine2.VALIDATE("Payment Method Code", 'CHECK');
                    //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
                    IF (Employee."Payment Method" <> Employee."Payment Method"::Cash) AND (Employee."Bank No." <> '') THEN
                        BankAcc.GET(Employee."Bank No.")
                    else
                        BankAcc.GET(P_AccountNo);
                end;
                GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
                GenJnlLine2."Account Type" := AccountType;
                if (Employee."Payment Method" <> Employee."Payment Method"::Cash)
                           and (Employee."Bank No." <> '') and (AccountType = AccountType::"Bank Account") then
                    GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.")
                else
                    GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
                //EDM_16052017
                //IF EmpGLAccount = '' THEN
                //BEGIN
                IF AccountType = AccountType::"Bank Account" THEN BEGIN
                    IF (Employee."Payment Method" <> Employee."Payment Method"::Cash) AND (Employee."Bank No." <> '') THEN
                    // 22.02.2018 : A2+
                    //BankAcc.GET(Employee."Bank No.")
                    BEGIN
                        CASE Employee."Payment Method" OF
                            Employee."Payment Method"::Bank:
                                BankAcc.GET(Employee."Bank No.");
                            //EDM+ 17-12-2019
                            Employee."Payment Method"::Cheque:
                                BankAcc.GET(Employee."Bank No.");
                            //EDM- 17-12-2019
                            Employee."Payment Method"::"G/LAccount":
                                GLAccountRec.GET(Employee."Bank No.");
                            Employee."Payment Method"::Vendor:
                                VendorRec.GET(Employee."Bank No.");
                        END;
                    END
                    // 22.02.2018 : A2-
                    ELSE
                        BankAcc.GET(P_AccountNo);
                END;

                GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
                // 22.02.2018 : A2+
                //GenJnlLine2."Account Type" := AccountType;
                // 22.02.2018 : A2-

                IF (Employee."Payment Method" <> Employee."Payment Method"::Cash) AND
                   (Employee."Bank No." <> '') AND
                   (AccountType = AccountType::"Bank Account") THEN
                  // 22.02.2018 : A2+
                  //GenJnlLine2.VALIDATE("Account No.",Employee."Bank No.")
                  BEGIN
                    CASE Employee."Payment Method" OF
                        Employee."Payment Method"::Bank:
                            BEGIN
                                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                            END;
                        //EDM+ 17-12-2019
                        Employee."Payment Method"::Cheque:
                            BEGIN
                                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                            END;
                        //EDM- 17-12-2019
                        Employee."Payment Method"::"G/LAccount":
                            BEGIN
                                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
                                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                            END;
                        Employee."Payment Method"::Vendor:
                            BEGIN
                                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::Vendor;
                                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.");
                            END;
                    END;
                END
                // 22.02.2018 : A2-
                ELSE BEGIN
                    GenJnlLine2."Account Type" := AccountType;
                    GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
                END;
                //END ELSE
                /*BEGIN
                  GLAccountRec.GET(EmpGLAccount);
                  GenJnlLine2.VALIDATE("Currency Code",P_CurrencyCode);
                  GenJnlLine2."Account Type" := AccountType::"G/L Account";
                  IF (EmpGLAccount <> '') AND (AccountType = AccountType::"Bank Account") THEN
                    GenJnlLine2.VALIDATE("Account No.",GLAccountRec."No.")
                  ELSE
                    GenJnlLine2.VALIDATE("Account No.",P_AccountNo);
                END;*/
                // 14.02.2018 : A2-
                // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.VALIDATE("Document No.", VDocNo)
                else
                    GenJnlLine2.VALIDATE("Document No.", DefaultDocNo);
                // 28.07.2017 : A2-
                if P_BalAccountNo <> '' then begin
                    GenJnlLine2."Bal. Account Type" := GenJnlLine2."Bal. Account Type"::"G/L Account";
                    GenJnlLine2.VALIDATE("Bal. Account No.", P_BalAccountNo);
                end;
                // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.Description := PayrollTitle
                else
                    GenJnlLine2.Description := DefaultDesc;
                // 28.07.2017 : A2-
                if (not VFinalize) or
                   ((VFinalize) and (not P_SummarizeGL)) then begin
                    Desc2 := Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name";
                    GenJnlLine2.Description := GenJnlLine2.Description + ' ' + Employee."No.";
                    //py2.0+
                    IF NOT P_SplitEntry THEN BEGIN
                        GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", PayDetailLine."Shortcut Dimension 1 Code");
                        GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", PayDetailLine."Shortcut Dimension 2 Code");
                    END ELSE BEGIN
                        GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", TempSplitPayDetLine."Shortcut Dimension 1 Code");
                        GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", TempSplitPayDetLine."Shortcut Dimension 2 Code");
                    END; //split
                         //py2.0-
                END; //assign Desc+Dims

                GenJnlLine2.VALIDATE("Shortcut Dimension 1 Code", EmployeeDimensions."Shortcut Dimension 1 Code");
                GenJnlLine2.VALIDATE("Shortcut Dimension 2 Code", EmployeeDimensions."Shortcut Dimension 2 Code");
                GenJnlLine2.ValidateShortcutDimCode(3, EmployeeDimensions."Shortcut Dimension 3 Code");
                GenJnlLine2.ValidateShortcutDimCode(4, EmployeeDimensions."Shortcut Dimension 4 Code");
                GenJnlLine2.ValidateShortcutDimCode(5, EmployeeDimensions."Shortcut Dimension 5 Code");
                GenJnlLine2.ValidateShortcutDimCode(6, EmployeeDimensions."Shortcut Dimension 6 Code");
                GenJnlLine2.ValidateShortcutDimCode(7, EmployeeDimensions."Shortcut Dimension 7 Code");
                GenJnlLine2.ValidateShortcutDimCode(8, EmployeeDimensions."Shortcut Dimension 8 Code");

                //EDM_07092017+
                IF (GenJnlLine2."Account Type" = GenJnlLine2."Account Type"::"G/L Account") AND (GenJnlLine2."Currency Code" = '') THEN BEGIN
                    IF (PayParam."ACY Currency Rate" <> 0) and (PayParam."Use Payroll ACY Rate") THEN BEGIN
                        GenJnl2AmountLCY := P_CalcAmount;
                        GenJnlLine2.VALIDATE("Currency Code", GLSetup."Additional Reporting Currency");
                        CASE PayParam."ACY Exchange Operation" OF
                            PayParam."ACY Exchange Operation"::Division:
                                GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * (EmployeeDimensions.Percentage / 100) / PayParam."ACY Currency Rate");
                            PayParam."ACY Exchange Operation"::Multiplication:
                                GenJnlLine2.VALIDATE(Amount, GenJnl2AmountLCY * (EmployeeDimensions.Percentage / 100) * PayParam."ACY Currency Rate");
                        END;
                        GenJnlLine2.VALIDATE("Amount (LCY)", GenJnl2AmountLCY * (EmployeeDimensions.Percentage / 100));
                    END else begin //EDM_KM_180920
                        IF GenJnlLine2."Currency Code" = '' THEN
                            GenJnlLine2.VALIDATE(Amount, P_CalcAmount * EmployeeDimensions.Percentage / 100)
                        ELSE
                            IF (GenJnlLine2."Currency Code" = GLSetup."Additional Reporting Currency") AND (PayParam."ACY Currency Rate" > 0) THEN BEGIN
                                //GenJnlLine2.VALIDATE(Amount,P_CalcAmount);
                                Factor := 1 / PayParam."ACY Currency Rate";//CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date",GenJnlLine2."Currency Code");
                                GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                                              GenJnlLine2."Currency Code", P_CalcAmount * (EmployeeDimensions.Percentage / 100), Factor));
                                GenJnlLine2.VALIDATE("Amount (LCY)", P_CalcAmount);
                            END
                            ELSE BEGIN
                                //GenJnlLine2.VALIDATE(Amount,P_CalcAmount);
                                Factor := CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date", GenJnlLine2."Currency Code");
                                GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                                              GenJnlLine2."Currency Code", P_CalcAmount * (EmployeeDimensions.Percentage / 100), Factor));
                            END;//EDM_KM_180920
                    end;
                END
                ELSE
                    //EDM_07092017-
                    IF GenJnlLine2."Currency Code" = '' THEN
                        GenJnlLine2.VALIDATE(Amount, P_CalcAmount * EmployeeDimensions.Percentage / 100)
                    ELSE
                        IF (GenJnlLine2."Currency Code" = GLSetup."Additional Reporting Currency") AND (PayParam."ACY Currency Rate" > 0) THEN BEGIN
                            //GenJnlLine2.VALIDATE(Amount,P_CalcAmount);
                            Factor := 1 / PayParam."ACY Currency Rate";//CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date",GenJnlLine2."Currency Code");
                            GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                                          GenJnlLine2."Currency Code", P_CalcAmount * (EmployeeDimensions.Percentage / 100), Factor));
                            GenJnlLine2.VALIDATE("Amount (LCY)", P_CalcAmount);
                        END
                        ELSE BEGIN
                            //GenJnlLine2.VALIDATE(Amount,P_CalcAmount);
                            Factor := CurrencyExchangeRate.ExchangeRate(GenJnlLine2."Posting Date", GenJnlLine2."Currency Code");
                            GenJnlLine2.VALIDATE(Amount, CurrencyExchangeRate.ExchangeAmtLCYToFCY(GenJnlLine2."Posting Date",
                                                                          GenJnlLine2."Currency Code", P_CalcAmount * (EmployeeDimensions.Percentage / 100), Factor));
                        END;
                // 28.07.2017 : A2+
                if Sub_Payroll_Code = '' then
                    GenJnlLine2.VALIDATE("Document Date", PayStatus."Payroll Date")
                else
                    GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
                // 28.07.2017 : A2-
                //Stopped BY EDM.MM GenJnlLine2.VALIDATE("Attention To",Employee."Full Name");
                GenJnlLine2.VALIDATE(Comment, Employee."Full Name");
                GenJnlLine2.INSERT;
                OnAfterInsertPayrollJournal(GenJnlLine2);
            until EmployeeDimensions.NEXT = 0;
            // 28.07.2017 : A2+
            //END ELSE InsertGenJnlLinePay(P_AccountNo ,P_BalAccountNo ,P_CalcAmount ,P_CurrencyCode,P_SplitEntry ,P_SummarizeGL,AccountType);
        end else
            InsertGenJnlLinePay(P_AccountNo, P_BalAccountNo, P_CalcAmount, P_CurrencyCode, P_SplitEntry, P_SummarizeGL, AccountType,
                                Sub_Payroll_Code);
        // 28.07.2017 : A2-
        //onsfetrinsert journal line
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterInsertPayrollJournal(Var GenJnlLine: Record "Gen. Journal Line");
    begin
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
        IF (PayParam."Group By Dimension" = '') OR (PayParam."Temp Pay Batch Name" = '') OR
           (PayParam."Payroll Finalize Type" <> PayParam."Payroll Finalize Type"::"By Dimension") then
            exit;
        // 11.10.2017 : NEW MOD -
        //28.03.2018 TAREKH. Added in order to fix the line no. increment
        InsertGenJnlRec.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
        InsertGenJnlRec.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name Pay");
        if InsertGenJnlRec.FINDLAST then
            LineNo := InsertGenJnlRec."Line No."
        else
            LineNo := 0;
        //28.03.2018 TAREKH. Added in order to fix the line no. increment
        GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
        GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Temp Pay Batch Name");
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
                GrpGenJnLine.SETRANGE(GrpGenJnLine."Journal Batch Name", PayParam."Temp Pay Batch Name");
                GrpGenJnLine.SETRANGE(GrpGenJnLine.Inserted2, false);
                GrpGenJnLine.SETRANGE("Account Type", GenJnlLine."Account Type");
                GrpGenJnLine.SETRANGE("Account No.", GenJnlLine."Account No.");
                //EDM-20170905+
                GrpGenJnLine.SETRANGE("Currency Code", GenJnlLine."Currency Code");
                //EDM-20170905-
                if PayParam."Group By Dimension" = GLSetup."Global Dimension 1 Code" then
                    GrpGenJnLine.SETRANGE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code")
                else
                    if GLSetup."Global Dimension 2 Code" = PayParam."Group By Dimension" then
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
                if (TotalAmtDbt <> 0) then begin
                    DocNb := COPYSTR(GenJnlLine."Document No.", 1, STRPOS(GenJnlLine."Document No.", '-') - 1);
                    InsertGenJnlRec.INIT;
                    InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name Pay";
                    InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Name Pay";
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
                    else
                        if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                            InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GrpGenJnLine."Shortcut Dimension 2 Code");
                    InsertGenJnlRec.MODIFY;
                end;
                if (TotalAmtCr <> 0) then begin
                    InsertGenJnlRec.INIT;
                    InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name Pay";
                    InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Name Pay";
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
                    else
                        if PayParam."Group By Dimension" = GLSetup."Global Dimension 2 Code" then
                            InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GrpGenJnLine."Shortcut Dimension 2 Code");
                    InsertGenJnlRec.MODIFY;
                end;
                GenJnlLine.Inserted2 := true;
                GenJnlLine.MODIFY;

                //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
                HRSetup.GET;
                IF (GenJnlLine."Payment Method Code" = 'CHECK') THEN BEGIN
                    InsertGenJnlRec.INIT;
                    InsertGenJnlRec."Journal Template Name" := PayParam."Journal Template Name Pay";
                    InsertGenJnlRec."Journal Batch Name" := PayParam."Journal Batch Name Pay";
                    LineNo += 10000;
                    InsertGenJnlRec."Line No." := LineNo;
                    InsertGenJnlRec.INSERT;
                    InsertGenJnlRec."Posting Date" := GenJnlLine."Posting Date";
                    InsertGenJnlRec."Document No." := DocNb;
                    InsertGenJnlRec.VALIDATE("Account Type", GenJnlLine."Account Type");
                    InsertGenJnlRec.VALIDATE("Account No.", GenJnlLine."Account No.");
                    InsertGenJnlRec.VALIDATE("Currency Code", GenJnlLine."Currency Code");
                    InsertGenJnlRec.VALIDATE("Amount", GenJnlLine."Amount");
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code");
                    InsertGenJnlRec.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine."Shortcut Dimension 2 Code");
                    InsertGenJnlRec."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    InsertGenJnlRec.VALIDATE("Payment Method Code", GenJnlLine."Payment Method Code");
                    InsertGenJnlRec.VALIDATE("External Document No.", GenJnlLine."External Document No.");
                    InsertGenJnlRec.VALIDATE("Due Date", GenJnlLine."Due Date");
                    InsertGenJnlRec.MODIFY;
                END;
            //END;
            //22.03.2018 TAREKH. Added in order to split the payment line for check in a separate line
            UNTIL GenJnlLine.NEXT = 0;
    end;
}