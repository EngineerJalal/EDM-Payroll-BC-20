codeunit 98007 "Finalize Employee Pay"
{
    // version PY1.0,EDM.HRPY1

    // PY1.2 : - Fix the Mistake of Description in case of summarize GLs.


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
        PayrollFunctions: Codeunit "Payroll Functions";

    procedure FinalizeEmployeePay(PayStatusRec: Record "Payroll Status"; P_Finalize: Boolean; Sub_Payroll_Code: Code[20]);
    var
        MyEmployee: Record Employee;
        MyPayrollLedgerEntry: Record "Payroll Ledger Entry";
        PayDetailLineRec: Record "Pay Detail Line";
        SumofAddition: Decimal;
        SumofDeduction: Decimal;
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
                if MyPayrollLedgerEntry.FIND('-') then
                    MyPayrollLedgerEntry.DELETEALL;
            until MyEmployee.NEXT = 0;
        //MB.1105A+

        PayStatus.COPY(PayStatusRec);
        VFinalize := P_Finalize;
        FirstEntryNo := 0;
        RecNo := 0;
        // 27.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            SetupPayrollInfo;
        // 27.07.2017 : A2-
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
            Employee.RESET;
            // 27.07.2017 : A2+
            if Sub_Payroll_Code = '' then begin
                Employee.SETRANGE("Payroll Group Code", PayStatusRec."Payroll Group Code");
                Employee.SETRANGE("Pay Frequency", PayStatusRec."Pay Frequency");
            end;
            // 27.07.2017 : A2-
            /*IF EmpNoFilter <> '' THEN
              Employee.SETRANGE("No.",EmpNoFilter);*/
            // 27.07.2017 : A2-
            //  Employee.SETRANGE(Status,MyEmployee.Status::Active);
            //py2.0+
            //Employee.SETRANGE(Status,Employee.Status::Active);
            Employee.SETRANGE("Include in Pay Cycle", true);
            //py2.0-
            NoOfRecs := Employee.COUNT;
            if Employee.FIND('-') then
                repeat
                    if Employee."Posting Group" = '' then
                        ERROR('There are some Employees not assigned to a Posting Group.');
                until Employee.NEXT = 0;

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
        // 27.07.2017 : A2+
        if Sub_Payroll_Code = '' then begin
            Employee.SETRANGE("Payroll Group Code", PayStatusRec."Payroll Group Code");
            Employee.SETRANGE("Pay Frequency", PayStatusRec."Pay Frequency");
        end;
        // 27.07.2017 : A2-
        //py2.0+
        //Employee.SETRANGE(Status,Employee.Status::Active);
        Employee.SETRANGE("Include in Pay Cycle", true);
        //py2.0-
        NoOfRecs := Employee.COUNT;
        if Employee.FIND('-') then
            repeat
                PayDetailHeader.GET(Employee."No.");
                // py2.0 IF PayDetailHeader."Include in Pay Cycle" = TRUE THEN BEGIN
                RecNo := RecNo + 1;
                PayPostG.GET(Employee."Posting Group");
                PayDetFound := false;
                PayDetailLine.RESET;
                PayDetailLine.SETRANGE("Employee No.", Employee."No.");
                PayDetailLine.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
                //EDM.IT+-PayDetailLine.SETFILTER(Amount,'<>0');
                // 27.07.2017 : A2+
                //PayDetailLine.SETRANGE(Open,TRUE);
                if Sub_Payroll_Code = '' then
                    PayDetailLine.SETRANGE(Open, true)
                else
                    PayDetailLine.SETRANGE(Open, false);
                // 27.07.2017 : A2-
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
                                // 3+
                                if PayDetailLine."Calculated Amount" <> 0 then begin
                                    // 4+
                                    if PayE."Not Included in Net Pay" then begin
                                        // 5+
                                        if VFinalize = true then begin
                                            if PayParam."Summary Payroll to GL Transfer" then begin //summary
                                                GenJnlLine.RESET;
                                                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                                GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name");
                                                GenJnlLine.SETRANGE("Account No.", PensionScheme."Expense Account");
                                                GenJnlLine.SETRANGE("Bal. Account No.", PensionScheme."Employee Posting Account");
                                                if GenJnlLine.FIND('-') then begin
                                                    GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount + PayDetailLine."Calculated Amount");
                                                    GenJnlLine.MODIFY;
                                                end
                                                else
                                                    // 28.07.2017 : A2+
                                                    //InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employee Posting Account",
                                                    //  PayDetailLine."Calculated Amount",'',FALSE);
                                                    InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                                            PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                                // 28.07.2017 : A2-
                                            end
                                            else
                                                // 28.07.217 : A2+
                                                //InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employee Posting Account",
                                                //    PayDetailLine."Calculated Amount",'',FALSE);
                                                InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                                      PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                            // 28.07.217 : A2-
                                        end
                                        else // test final.
                                             // 28.07.2017 : A2+
                                             // InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employee Posting Account",
                                             //     PayDetailLine."Calculated Amount",'',FALSE);
                                            InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employee Posting Account",
                                                   PayDetailLine."Calculated Amount", '', false, Sub_Payroll_Code);
                                        // 28.07.2017 : A2-
                                        // 5-
                                    end
                                    else begin // inc in net pay
                                        VCalcAmount := PayDetailLine."Calculated Amount" * (-1);

                                        if VFinalize = true then begin
                                            if PayParam."Summary Payroll to GL Transfer" then begin //summary
                                                GenJnlLine.RESET;
                                                GenJnlLine.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
                                                GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name");
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
                                                //   InsertGenJnlLine(PensionScheme."Employee Posting Account",'',VCalcAmount,'',FALSE);
                                                InsertGenJnlLine(PensionScheme."Employee Posting Account", '', VCalcAmount, '', false, Sub_Payroll_Code);
                                            // 28.07.2017 : A2-
                                        end
                                        else // test final.
                                             // 28.07.2017 : A2+
                                             //  InsertGenJnlLine(PensionScheme."Employee Posting Account",'',VCalcAmount,'',FALSE);
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
                                            GenJnlLine.SETRANGE("Journal Batch Name", PayParam."Journal Batch Name");
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
                                            //   InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employer Posting Account",
                                            //                       PayDetailLine."Employer Amount",'',FALSE);
                                            InsertGenJnlLine(PensionScheme."Expense Account", PensionScheme."Employer Posting Account",
                                                                  PayDetailLine."Employer Amount", '', false, Sub_Payroll_Code);
                                        // 28.07.2017 : A2-
                                    end
                                    else // test final.
                                         // 28.07.2017 : A2+
                                         //    InsertGenJnlLine(PensionScheme."Expense Account",PensionScheme."Employer Posting Account",
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
                                                                                  //  ProcessCostNetAccounts('COST',PayDetailLine."Calculated Amount",PayDetailLine."Calculated Amount (ACY)",FALSE)
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
                            // 27.07.2017 : A2+
                            if Sub_Payroll_Code = '' then begin
                                UpdateLoan;
                                PayDetailLine."Payroll Date" := PayStatus."Payroll Date";
                                PayDetailLine."Tax Year" := TaxYear;
                                PayDetailLine.Period := PeriodNo;
                                PayDetailLine.MODIFY;
                            end;
                            // 27.07.2017 : A2-
                        end; // finalize

                        if NoOfRecs <> 0 then
                            Window.UPDATE(5, ROUND(RecNo / NoOfRecs * 10000, 1));

                    until PayDetailLine.NEXT = 0; //PayDetLine

                if PayDetFound = true then begin
                    PayLedgEntry.GET(PayLedgEntryNo);
                    if PayParam."Integrate to G/L" = true then begin
                        if (PayLedgEntry."Net Pay" <> 0) or (PayLedgEntry."Net Pay (ACY)" <> 0) then begin
                            // 28.07.2017 : A2+
                            //ProcessCostNetAccounts('NET',PayLedgEntry."Net Pay",PayLedgEntry."Net Pay (ACY)",FALSE);
                            ProcessCostNetAccounts('NET', PayLedgEntry."Net Pay", PayLedgEntry."Net Pay (ACY)", false, Sub_Payroll_Code);
                            // 28.07.2017 : A2-
                            //EDM.IT+
                        end;
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
                        // 27.07.2017 : A2+
                        if Sub_Payroll_Code = '' then begin
                            UpdateAbsences;
                            UpdateSplitEmpJnls;
                        end;
                        // 27.07.2017 : A2-
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
                        // 27.07.2017 : A2+
                        if Sub_Payroll_Code = '' then begin
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
                        // 27.07.2017 : A2-
                    end; // finalize1

                end; //paydetfound


            // py2.0 END; // payDetHeader
            until Employee.NEXT = 0; // Emp - Inc.in Pay Cycle

        if VFinalize = true then begin
            PostPayRegister;
            if PayParam."Integrate to G/L" = true then begin
                Loop := 1;
                while Loop <= 2 do begin
                    if Loop = 1 then
                        VBatchName := PayParam."Journal Batch Name"
                    else
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

    procedure InsertGenJnlLine(P_AccountNo: Code[20]; P_BalAccountNo: Code[20]; P_CalcAmount: Decimal; P_CurrencyCode: Code[10]; P_SplitEntry: Boolean; Sub_Payroll_Code: Code[20]);
    var
        GenJnlLine2: Record "Gen. Journal Line";
        BatchName: Code[10];
        VDocNo: Code[20];
        Desc2: Text[120];
        v_DimensionNo: Integer;
        PayLedgerEntry: Record "Payroll Ledger Entry";
        DefaultDocNo: Code[20];
        DefaultDesc: Text;
        DefaultPayDate: Date;
    begin
        // 03.08.2017 : A2+
        PayLedgEntry.RESET();
        CLEAR(PayLedgEntry);
        PayLedgEntry.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
        if PayLedgEntry.FINDFIRST then begin
            DefaultPayDate := PayLedgEntry."Payroll Date";
            DefaultDocNo := PayLedgEntry."Document No.";
            DefaultDesc := PayLedgEntry.Description;
        end;
        // 03.08.2017 : A2-

        //EDM_12022016_ACTS

        if P_CurrencyCode = '' then begin

            if PayParam."Original Payroll Currency" <> '' then
                P_CurrencyCode := PayParam."Original Payroll Currency"
            else
                P_CurrencyCode := '';
        end;
        //EDM_12022016_ACTS

        if P_CurrencyCode = '' then begin
            if (not VFinalize) or
               ((VFinalize) and (not PayParam."Summary Payroll to GL Transfer")) then
                VDocNo := COPYSTR(PayrollNo + '-' + Employee."No.", 1, 20) //py1.2
            else
                VDocNo := COPYSTR(PayrollNo, 1, 20); //py1.2
            BatchName := PayParam."Journal Batch Name";
            CLEAR(GenJnlLine2);
            GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
            GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
            if GenJnlLine2.FIND('+') then
                LineNo := GenJnlLine2."Line No." + 1
            else
                LineNo := 1;
        end else begin
            VDocNo := COPYSTR(PayrollNo + 'ACY' + '-' + Employee."No.", 1, 20); //py1.2;
            BatchName := PayParam."Journal Batch Name (ACY)";
            CLEAR(GenJnlLine2);
            GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name");
            GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
            if GenJnlLine2.FIND('+') then
                LineNo := GenJnlLine2."Line No." + 1
            else
                LineNo := 1;
        end; // ACY
        GenJnlLine2.INIT;
        GenJnlLine2.VALIDATE("Journal Template Name", PayParam."Journal Template Name");
        GenJnlLine2.VALIDATE("Journal Batch Name", BatchName);
        GenJnlLine2."Line No." := LineNo;
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Posting Date", PayStatus."Payroll Date")
        else
            GenJnlLine2.VALIDATE("Posting Date", DefaultPayDate);
        // 28.07.2017 : A2-
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
        if DimensionValue.GET('EMPLOYEE', Employee."No.") then begin
            v_DimensionNo := PayrollFunctions.GetDimensionNo('EMPLOYEE');
            GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, Employee."No.")
        end;
        if DefaultDimension.GET(DATABASE::Employee, Employee."No.", 'AREA') then begin
            v_DimensionNo := PayrollFunctions.GetDimensionNo('AREA');
            GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, DefaultDimension."Dimension Value Code");
        end;
        if DefaultDimension.GET(DATABASE::Employee, Employee."No.", 'PROJECT') then begin
            v_DimensionNo := PayrollFunctions.GetDimensionNo('PROJECT');
            GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, DefaultDimension."Dimension Value Code");
        end;
        /*IF DefaultDimension.GET(DATABASE::Employee,Employee."No.",'DEPARTMENT') THEN
          BEGIN
            v_DimensionNo := DimMgt.GetDimensionNo('DEPARTMENT');
            GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo,DefaultDimension."Dimension Value Code");
          END; */
        //EDM.IT-

        GenJnlLine2.VALIDATE(Amount, P_CalcAmount);
        //EDM_05092017
        // 24.10.2017 : A2+
        //IF (PayParam."ACY Currency Rate" <> 0)  THEN
        IF (PayParam."ACY Currency Rate" <> 0) AND (PayParam."Use Payroll ACY Rate") THEN
            // 24.10.2017 : A2-
            /* 
            Stopped By EDM.MM
              if GenJnlLine2."Currency Code" = '' then
              begin
                case PayParam."ACY Exchange Operation" of
                  PayParam."ACY Exchange Operation"::Division:
                    GenJnlLine2.VALIDATE("Amount (ACY)",GenJnlLine2.Amount/ PayParam."ACY Currency Rate");
                  PayParam."ACY Exchange Operation"::Multiplication:
                    GenJnlLine2.VALIDATE("Amount (ACY)",GenJnlLine2.Amount* PayParam."ACY Currency Rate");
                end;
              end;
              Stopped By EDM.MM
              */
            //EDM_05092017

            /*IF P_CalcAmount > 0 THEN
              GenJnlLine2."Entry Type" := GenJnlLine2."Entry Type"::"0"
            ELSE
              GenJnlLine2."Entry Type" := GenJnlLine2."Entry Type"::"1";
              */

            // 28.07.2017 : A2+
            if Sub_Payroll_Code = '' then
                GenJnlLine2.VALIDATE("Document Date", PayStatus."Payroll Date")
            else
                GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
        // 28.07.2017 : A2-

        GenJnlLine2.INSERT;

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
    begin
        Loop := 1;
        while Loop <= 2 do begin
            if Loop = 1 then begin
                VCurrencyCode := '';
                VBatchName := PayParam."Journal Batch Name";
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
                        // 28.08.2017 : A2+
                        //  InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
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
        if PayrollFunctions.IsSeparateAttendanceInterval(PayStatus."Payroll Group Code") then
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
                        NewPayDetailLine."Line No." := PayDetailLine2."Line No." + 1
                    else
                        NewPayDetailLine."Line No." := 1;
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
                VBatchName := PayParam."Journal Batch Name";
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
                            // 28.08.2017 : A2+
                            //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                            InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                        // 28.08.2017 : A2-
                    end else
                        // 28.08.2017 : A2+
                        //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                        InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                    // 28.08.2017 : A2-
                end else // test.final.
                         // 28.08.2017 : A2+
                         //InsertGenJnlLine(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry);
                    InsertGenJnlLine(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, Sub_Payroll_Code);
                // 28.08.2017 : A2-
            end; // calcamt<>0
            Loop := Loop + 1;
        end; // Loop on 2 ccys
    end;

    procedure InsertGenJnlLinePay(P_AccountNo: Code[20]; P_BalAccountNo: Code[20]; P_CalcAmount: Decimal; P_CurrencyCode: Code[10]; P_SplitEntry: Boolean; P_SummarizeGL: Boolean; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; Sub_Payroll_Code: Code[20]);
    var
        GenJnlLine2: Record "Gen. Journal Line";
        BatchName: Code[10];
        VDocNo: Code[20];
        Desc2: Text[120];
        v_DimensionNo: Integer;
        PayLedgerEntry: Record "Payroll Ledger Entry";
        DefaultDocNo: Code[20];
        DefaultDesc: Text;
        DefaultPayDate: Date;
        HRSetup: Record "Human Resources Setup";
        PayrollParameterRec: Record "Payroll Parameter";
    begin
        // 03.08.2017 : A2+
        PayLedgEntry.RESET();
        CLEAR(PayLedgEntry);
        PayLedgEntry.SETRANGE("Sub Payroll Code", Sub_Payroll_Code);
        if PayLedgEntry.FINDFIRST then begin
            DefaultPayDate := PayLedgEntry."Payroll Date";
            DefaultDocNo := PayLedgEntry."Document No.";
            DefaultDesc := PayLedgEntry.Description;
        end;
        // 03.08.2017 : A2-

        //EDM_12022016_ACTS

        if P_CurrencyCode = '' then begin

            if PayParam."Original Payroll Currency" <> '' then
                P_CurrencyCode := PayParam."Original Payroll Currency"
            else
                P_CurrencyCode := '';
        end;
        //EDM_12022016_ACTS
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
            BatchName := PayParam."Journal Batch Name";

            ///
            CLEAR(GenJnlLine2);
            GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
            GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
            if GenJnlLine2.FIND('+') then
                LineNo := GenJnlLine2."Line No." + 1
            else
                LineNo := 1;
        end else begin
            VDocNo := COPYSTR(PayrollNo + 'ACY' + '-' + Employee."No.", 1, 20); //py1.2;
            BatchName := PayParam."Journal Batch Name (ACY)";
            CLEAR(GenJnlLine2);
            GenJnlLine2.SETRANGE("Journal Template Name", PayParam."Journal Template Name Pay");
            GenJnlLine2.SETRANGE("Journal Batch Name", BatchName);
            if GenJnlLine2.FIND('+') then
                LineNo := GenJnlLine2."Line No." + 1
            else
                LineNo := 1;
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
        GenJnlLine2."Account Type" := AccountType;
        if AccountType = AccountType::"Bank Account" then begin
            //EDM_16052017
            if (Employee."Payment Method" <> Employee."Payment Method"::Cash)
                     and (Employee."Bank No." <> '') then
                GenJnlLine2.VALIDATE("Account No.", Employee."Bank No.")
            else
                GenJnlLine2.VALIDATE("Account No.", P_AccountNo);
            //EDM_16052017
        end else
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
             //MGH
        if DimensionValue.GET('EMPLOYEE', Employee."No.") then begin
            v_DimensionNo := PayrollFunctions.GetDimensionNo('EMPLOYEE');
            GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, Employee."No.")
        end;
        if DefaultDimension.GET(DATABASE::Employee, Employee."No.", 'AREA') then begin
            v_DimensionNo := PayrollFunctions.GetDimensionNo('AREA');
            GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, DefaultDimension."Dimension Value Code");
        end;
        if DefaultDimension.GET(DATABASE::Employee, Employee."No.", 'PROJECT') then begin
            v_DimensionNo := PayrollFunctions.GetDimensionNo('PROJECT');
            GenJnlLine2.ValidateShortcutDimCode(v_DimensionNo, DefaultDimension."Dimension Value Code");
        end;
        //EDM-
        //MESSAGE(FORMAT(P_CalcAmount));
        GenJnlLine2.VALIDATE(Amount, P_CalcAmount);
        // 28.07.2017 : A2+
        if Sub_Payroll_Code = '' then
            GenJnlLine2.VALIDATE("Document Date", PayStatus."Payroll Date")
        else
            GenJnlLine2.VALIDATE("Document Date", DefaultPayDate);
        // 28.07.2017 : A2-
        GenJnlLine2.INSERT;
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
                VBatchNamePay := PayParam."Journal Batch Name Pay";

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
                            // 28.07.2017 : A2+
                            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                            InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                        // 28.07.2017 : A2-
                    end else
                        // 28.07.2017 : A2+
                        //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                        InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
                    // 28.07.2017 : A2-
                end else // test.final.
                         // 28.07.2017 : A2+
                         //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,0);
                    InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 0, Sub_Payroll_Code);
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
                    // 28.07.2017 : A2+
                    //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end else
                // 28.07.2017 : A2+
                //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
            // 28.07.2017 : A2-
        end else // test.final.
            // 28.07.2017 : A2+
            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
        // 28.07.2017 : A2
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
                    // 28.07.2017 : A2+
                    //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end else
                // 28.07.2017 : A2+
                //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
            // 28.07.2017 : A2-
        end else // test.final.
            // 28.07.2017 : A2+
            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false, 3, Sub_Payroll_Code);
        // 28.07.2017 : A2
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
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE(Amount, (GenJnlLine.Amount + VCalcAmount));
                    GenJnlLine.MODIFY;
                end else
                    // 28.07.2017 : A2+
                    //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                    InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false,0, Sub_Payroll_Code);
                // 28.07.2017 : A2-
            end else
                // 28.07.2017 : A2+
                //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
                InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false,0, Sub_Payroll_Code);
            // 28.07.2017 : A2-
        end else // test.final.
            // 28.07.2017 : A2+
            //InsertGenJnlLinePay(VAccountNo,'',VCalcAmount,VCurrencyCode,P_SplitEntry,FALSE,3);
            InsertGenJnlLinePay(VAccountNo, '', VCalcAmount, VCurrencyCode, P_SplitEntry, false,0, Sub_Payroll_Code);
        // 28.07.2017 : A2
    end;
}

