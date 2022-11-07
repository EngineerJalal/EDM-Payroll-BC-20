report 98031 "Print-Prepare Bank Payment..2"
{
    ProcessingOnly = true;
    dataset
    {
        dataitem("Payroll Ledger Entry"; "Payroll Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.");
            RequestFilterFields = "Payroll Group Code";

            trigger OnPreDataItem();
            begin
                FILTERGROUP(2);
                PayGroup.FILTERGROUP(2);
                SETFILTER("Payroll Group Code", PayGroup.GETFILTER(Code));
                PayGroup.FILTERGROUP(0);
                FILTERGROUP(0);

                "Payroll Ledger Entry".SETRANGE("Payroll Ledger Entry"."Bank No.", BankNo);
                HumanResSetup.GET;
                SETCURRENTKEY("Employee No.");
                SETRANGE("Payroll Date", PayrollDate);

                BankAccTbt.RESET;
                CLEAR(BankAccTbt);
                BankAccTbt.SETRANGE("No.", BankNo);
                if BankAccTbt.FINDFIRST then begin
                    CompIBAN := BankAccTbt.IBAN;
                    ContactName := BankAccTbt.Contact;
                    if BankAccTbt."Currency Code" = '' then
                        CurrCode := 'LBP'
                    else
                        CurrCode := BankAccTbt."Currency Code";
                    BankName := BankAccTbt.Name;
                end;

                //EDM.Export+
                case BankFormat of
                    BankFormat::BBAC:
                        InsertBBACExcelHeader;
                    BankFormat::"Bank Med":
                        begin
                            // File1.CREATE(HumanResSetup."Export Report Path" + '\BankMED_' + CONVERTSTR(FORMAT(PayrollDate), '/', '-') + '.txt');
                            // File1.CREATEOUTSTREAM(OutStreamObj);
                        end;
                    BankFormat::"AUDI Bank":
                        InsertAUDIExcelHeader;
                    BankFormat::SGBL:
                        InsertSGBLHeader;
                    BankFormat::Byblos:
                        InsertByblosHeader;
                    BankFormat::BLOM:
                        InsertBLOMExcelHeader;
                end;
            end;

            trigger OnAfterGetRecord();
            begin
                BankName := '';
                BankAdd := '';
                IBAN := '';
                CurrCode := '';
                BankBranch := '';
                Title := '';

                CLEAR(Employee);
                Employee.SETRANGE("No.", "Employee No.");
                if Employee.FINDFIRST then begin
                    if Employee."Freeze Salary" then
                        CurrReport.SKIP;

                    if Employee."Payment Method" <> Employee."Payment Method"::Bank then
                        CurrReport.SKIP;

                    if Employee."Emp. Bank Acc Name" = '' then
                        EmpBankName := Employee."Full Name"
                    else
                        EmpBankName := Employee."Emp. Bank Acc Name";

                    if ShowAmountACY then
                        BankAcct := Employee."Bank No. (ACY)"
                    else
                        BankAcct := Employee."Bank No.";

                    CLEAR(BankAcc);
                    BankAcc.SETRANGE("No.", BankAcct);
                    if BankAcc.FINDFIRST then begin
                        BankName := BankAcc.Name;
                        BankAdd := BankAcc.Address;
                        BankBranch := BankAcc."Bank Branch No.";
                        if BankAcc."Currency Code" = '' then
                            CurrCode := 'LBP'
                        else
                            CurrCode := BankAcc."Currency Code";
                    end;

                    EmpAccNo := Employee."Emp. Bank Acc No.";
                    if ShowAmountACY then begin
                        EmpNetPay := ExchEquivAmountInACY("Net Pay");
                        EmpAccNo := Employee."Emp. Bank Acc No. (ACY)";
                        TotalEmpNetPay += EmpNetPay;
                    end else begin
                        EmpNetPay := "Net Pay";
                        EmpAccNo := Employee."Emp. Bank Acc No.";
                        TotalEmpNetPay += EmpNetPay;
                    end;

                    if EmployeeAdditionalInfo.GET(Employee."No.") then
                        IBAN := EmployeeAdditionalInfo."IBAN No";

                    EmpBranchCode := Employee."Global Dimension 2 Code";
                    if Employee.Gender = Employee.Gender::Male then
                        Title := 'Mr.'
                    else
                        Title := 'Mrs.';

                    //EDM.Export+
                    case BankFormat of
                        BankFormat::BBAC:
                            InsertBBACExcelLine;
                        BankFormat::"Bank Med":
                            InsertBankMedLine;
                        BankFormat::"AUDI Bank":
                            InsertAUDIExcelLine;
                        BankFormat::SGBL:
                            InsertSGBLLine;
                        BankFormat::Byblos:
                            InsertByblosLine;
                        BankFormat::BLOM:
                            InsertBLOMExcelLine;

                    end;
                end;
            end;

            /* trigger OnPostDataItem();
             begin
                 //EDM.Export+
                 case BankFormat of
                     BankFormat::BBAC:
                         //TempExcelBuffer.CreateBookAndOpenExcel('', 'Payroll', '', '', '');
                  //   BankFormat::"Bank Med":
                      //   File1.CLOSE;
                     BankFormat::"AUDI Bank":
                         begin
                             InsertAUDIExcelFooter();
                             //TempExcelBuffer.CreateBookAndOpenExcel('', 'Payroll', '', '', '');
                         end;
                     BankFormat::SGBL:
                         begin
                             InsertSGBLFooter();
                            // TempExcelBuffer.CreateBookAndOpenExcel('', 'Payroll', '', '', '');
                         end;
                     BankFormat::Byblos:
                         begin
                             InsertByblosTotalAmt();
                            // TempExcelBuffer.CreateBookAndOpenExcel('', 'Payroll', '', '', '');
                         end;
                     BankFormat::BLOM:
                         begin
                             InsertBLOMFooter;
                         //    TempExcelBuffer.CreateBookAndOpenExcel('', 'Payroll', '', '', '');
                         end;
                 end;
                 //EDM.Export-
             end;*/
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Requirments)
                {
                    Caption = 'Requirments';
                    field(BankFormat; BankFormat)
                    {
                        Caption = 'Bank Format';
                        ApplicationArea = All;
                    }
                    field("Bank No"; BankNo)
                    {
                        TableRelation = "Bank Account"."No.";
                        ApplicationArea = All;
                    }
                    field(PayrollDate; PayrollDate)
                    {
                        Caption = 'Payroll Date';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            MotifDePaiement := 'Salaries ' + FORMAT(PayrollDate, 0, '<Month Text>') + ' ' + FORMAT(DATE2DMY(PayrollDate, 3));
                        end;
                    }
                    field("Value Date"; ValueDate)
                    {
                        ApplicationArea = All;
                    }
                    field(Description; MotifDePaiement)
                    {
                        ApplicationArea = All;
                    }
                    field(Chairman; Chairman)
                    {
                        ApplicationArea = All;
                    }
                    field(ShowAmountACY; ShowAmountACY)
                    {
                        Caption = 'Show Amount in ACY';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnInitReport();
    begin
        if PayrollFunction.HideSalaryFields() then
            ERROR('Permission NOT Allowed!');
        if USERID <> '' then
            HRFunction.SetPayGroupFilter(PayGroup);
    end;

    trigger OnPreReport();
    begin
        if PayrollDate = 0D then
            ERROR('Payroll Date must be entered');

        VFilter := "Payroll Ledger Entry".GETFILTER("Payroll Date");
        if VFilter <> '' then
            ERROR('The Payroll Date is an Option field,it cannot be specified from the request Field Filter.');

        VFilter := "Payroll Ledger Entry".GETFILTER("Pay Frequency");
        if VFilter <> '' then
            ERROR('The Pay Frequency is an Option field,it cannot be specified from the request Field Filter.');

        if BankNo = '' then
            ERROR('Bank No. must not be empty');
    end;

    var
        Employee: Record Employee;
        BankAcc: Record "Bank Account";
        PayGroup: Record "HR Payroll Group";
        HumanResSetup: Record "Human Resources Setup";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        EmployeeAdditionalInfo: Record "Employee Additional Info";
        DimensionValueRec: Record "Dimension Value";
        BankAccTbt: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        HRFunction: Codeunit "Human Resource Functions";
        PayrollFunction: Codeunit "Payroll Functions";
        BankAcct: Code[20];
        CurrCode: Code[10];
        PayrollDate: Date;
        EmpAccNo: Code[30];
        EmpNetPay: Decimal;
        VFilter: Text[150];
        EmpBankName: Text[100];
        BankName: Text[50];
        BankAdd: Text;
        ShowAmountACY: Boolean;
        RowNo: Integer;
        BankFormat: Option BBAC,"Bank Med","AUDI Bank",SGBL,Byblos,BLOM;
        IBAN: Text;
        OutStreamObj: OutStream;
        File1: File;
        BankBranch: Text;
        TotalNetPay: Decimal;
        EmpBranchCode: Code[20];
        TotalEmpNetPay: Decimal;
        MotifDePaiement: Text;
        IDNo: Integer;
        CompIBAN: Code[50];
        BankNo: Code[20];
        ContactName: Text[50];
        Title: Text[50];
        ValueDate: Date;
        Chairman: Text;

    local procedure ExchEquivAmountInACY(L_AmoountInLCY: Decimal) L_AmouontInACY: Decimal;
    begin
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
    end;

    local procedure InsertBBACExcelHeader();
    begin
        RowNo := 1;
        EnterCell(RowNo, 1, COMPANYNAME, true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := RowNo + 1;
        EnterCell(RowNo, 1, 'Year', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 2, 'Month', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, 'Bank Name', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, 'Bank Branch', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, 'Customer ID Number', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 6, 'Customer Name', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 7, 'Account Number', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 8, 'IBAN', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 9, 'Amount', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 10, 'Currency', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 11, 'Status', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertBBACExcelLine();
    begin
        RowNo := RowNo + 1;
        EnterCell(RowNo, 1, FORMAT(DATE2DMY(PayrollDate, 3)), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 2, FORMAT(DATE2DMY(PayrollDate, 2)), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 3, BankName, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, BankBranch, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, "Payroll Ledger Entry"."Employee No.", false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 6, EmpBankName, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 7, EmpAccNo, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 8, IBAN, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 9, FORMAT(EmpNetPay), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 10, CurrCode, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 11, 'Active', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertBankMedLine();
    var
        EmpNetPayWithLeadingZero: Text;
        EmpNo: Text;
    begin
        EmpNo := "Payroll Ledger Entry"."Employee No.";
        if STRLEN(EmpNo) < 6 then
            EmpNo := PADSTR(EmpNo, 6, ' ')
        else
            if STRLEN(EmpNo) > 6 then
                EmpNo := COPYSTR(EmpNo, 1, 6);

        if STRLEN(EmpBankName) < 51 then
            EmpBankName := PADSTR(EmpBankName, 51, ' ')
        else
            if STRLEN(EmpBankName) > 51 then
                EmpBankName := COPYSTR(EmpBankName, 1, 51);

        if STRLEN(EmpAccNo) < 13 then
            EmpAccNo := PADSTR(EmpAccNo, 13, ' ')
        else
            if STRLEN(EmpAccNo) > 13 then
                EmpAccNo := COPYSTR(EmpAccNo, 1, 13);

        if STRLEN(FORMAT(EmpNetPay, 0, 1)) < 9 then
            EmpNetPayWithLeadingZero := PADSTR('', 9 - STRLEN(FORMAT(EmpNetPay, 0, 1)), '0') + FORMAT(EmpNetPay, 0, 1)
        else
            if STRLEN(FORMAT(EmpNetPay, 0, 1)) > 9 then
                EmpNetPayWithLeadingZero := COPYSTR(FORMAT(EmpNetPay, 0, 1), 1, 9);

        if STRLEN(BankBranch) < 2 then
            BankBranch := PADSTR('', 2, ' ')
        else
            if STRLEN(BankBranch) > 2 then
                BankBranch := COPYSTR(BankBranch, 1, 2);

        if STRLEN(EmpNo) = 0 then
            OutStreamObj.WRITETEXT('      ')
        else
            OutStreamObj.WRITETEXT(EmpNo);

        if STRLEN(EmpBankName) = 0 then
            OutStreamObj.WRITETEXT('                                                   ')
        else
            OutStreamObj.WRITETEXT(EmpBankName);

        if STRLEN(EmpBankName) = 0 then
            OutStreamObj.WRITETEXT('  ')
        else
            OutStreamObj.WRITETEXT(BankBranch);

        if STRLEN(EmpAccNo) = 0 then
            OutStreamObj.WRITETEXT('             ')
        else
            OutStreamObj.WRITETEXT(EmpAccNo);

        if STRLEN(EmpNetPayWithLeadingZero) = 0 then
            OutStreamObj.WRITETEXT('         ')
        else
            OutStreamObj.WRITETEXT(EmpNetPayWithLeadingZero);

        OutStreamObj.WRITETEXT();
    end;

    local procedure InsertAUDIExcelHeader();
    begin
        RowNo := 1;
        EnterCell(RowNo, 1, 'Title', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 2, 'Name', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, 'Salary', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, 'Account Number', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, 'Value Date', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertAUDIExcelLine();
    begin
        RowNo := RowNo + 1;
        EnterCell(RowNo, 1, Title, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 2, EmpBankName, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, FORMAT(EmpNetPay), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 4, EmpAccNo, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, format(ValueDate), false, false, false, '', TempExcelBuffer."Cell Type"::Date);
    end;

    local procedure InsertAUDIExcelFooter();
    var
        Payledtbt: Record "Payroll Ledger Entry";
        DimCode: Code[20];
        DimCode2: Code[20];
        PayLedNetPay: Decimal;
        DimCode3: Code[20];
        ShortcutValue: Code[20];
        FirstRow: Boolean;
    begin
        /*RowNo := RowNo + 1;
        EnterCell(RowNo,3,FORMAT(TotalEmpNetPay),false,false,false,'',TempExcelBuffer."Cell Type"::Number);

        TotalEmpNetPay := 0;
        TotalNetPay := 0;
        RowNo := RowNo + 2;
        DimCode := '';
        DimCode2 := '';

        Payledtbt.SETCURRENTKEY("Shortcut Dimension 2 Code");
        Payledtbt.SETRANGE(Payledtbt."Payroll Date",PayrollDate);
        Payledtbt.SETFILTER("Shortcut Dimension 2 Code",'<>%1','');
        Payledtbt.SETRANGE("Payment Method",Payledtbt."Payment Method"::Bank);
        if Payledtbt.FINDFIRST then repeat
          if DimCode <> Payledtbt."Shortcut Dimension 2 Code" then begin
            if (DimCode2 <> '') or (FirstRow) then begin
              if FirstRow then
                DimCode2 := DimCode;

              DimensionValueRec.SETCURRENTKEY(Code,"Global Dimension No.");
              if DimensionValueRec.GET(DimCode2,2) then
                EnterCell(RowNo,2,DimensionValueRec.Name,false,false,false,'',TempExcelBuffer."Cell Type"::Text)
              else
                EnterCell(RowNo,2,DimCode2,false,false,false,'',TempExcelBuffer."Cell Type"::Text);

              EnterCell(RowNo,3,FORMAT(TotalNetPay),false,false,false,'',TempExcelBuffer."Cell Type"::Number);
            end;
            RowNo := RowNo + 1;
            DimCode := Payledtbt."Shortcut Dimension 2 Code";
            TotalNetPay := 0;
            FirstRow := true;
          end else begin
            DimCode2 := Payledtbt."Shortcut Dimension 2 Code";
            FirstRow := false;
          end;

          DimCode3 := Payledtbt."Shortcut Dimension 2 Code";
          TotalNetPay += Payledtbt."Net Pay";
          TotalEmpNetPay += Payledtbt."Net Pay";// Added - 12.06.2017 : A2+-
        until Payledtbt.NEXT = 0;

        if DimCode3 <> '' then begin
          DimensionValueRec.SETCURRENTKEY(Code,"Global Dimension No.");
          if DimensionValueRec.GET(DimCode3,2) then
            EnterCell(RowNo,2,DimensionValueRec.Name,false,false,false,'',TempExcelBuffer."Cell Type"::Text)
          else
            EnterCell(RowNo,2,DimCode3,false,false,false,'',TempExcelBuffer."Cell Type"::Text);

          EnterCell(RowNo,3,FORMAT(TotalNetPay),false,false,false,'',TempExcelBuffer."Cell Type"::Number);
        end;
        EnterCell(RowNo + 1,3,FORMAT(TotalEmpNetPay),false,false,false,'',TempExcelBuffer."Cell Type"::Number);*/
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; NumberFormat: Text[30]; CellType: Option);
    begin
        TempExcelBuffer.INIT;
        TempExcelBuffer.VALIDATE("Row No.", RowNo);
        TempExcelBuffer.VALIDATE("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.NumberFormat := NumberFormat;
        TempExcelBuffer."Cell Type" := CellType;
        TempExcelBuffer.INSERT;
    end;

    local procedure InsertSGBLHeader();
    begin
        CompanyInfo.GET();

        RowNo := 1;
        EnterCell(RowNo, 4, 'Nom Donneur d' + '''' + 'ordre', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, CompanyInfo.Name, true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 2;
        EnterCell(RowNo, 4, 'Date Valeur', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, FORMAT(PayrollDate), false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 3;
        EnterCell(RowNo, 4, 'Motif De Paiement', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, MotifDePaiement, true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 4;
        EnterCell(RowNo, 1, 'SOCIETE GENERALE DE BANQUE DU LIBAN SAL', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, 'REF', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 5;
        EnterCell(RowNo, 1, 'BEIROUTH', true, false, true, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 7;
        EnterCell(RowNo, 1, 'Attention', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 8;
        EnterCell(RowNo, 1, ContactName, true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 9;
        EnterCell(RowNo, 1, 'Nous vous prions de bien vouloir procéder au débit de notre compte SERUM PRODUCTS SARL', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 10;
        EnterCell(RowNo, 1, 'en ' + CurrCode + ' No ' + CompIBAN + ' en date du ' + FORMAT(PayrollDate) + ' des montants dètaillés comme suit:', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        //insert columns header
        RowNo := RowNo + 2;
        EnterCell(RowNo, 1, 'ID NUM', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 2, 'Compte Donneur d' + '''' + 'Ordre', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, 'NOMS', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, 'Compte Bénéficiaire', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, 'Salaire LBP', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 6, 'Date Valeur', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 7, 'Motif De Paiement', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertSGBLLine();
    begin
        RowNo += 1;
        IDNo += 1;

        EnterCell(RowNo, 1, FORMAT(IDNo), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 2, CompIBAN, false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 3, EmpBankName, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, EmpAccNo, false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 5, FORMAT(EmpNetPay), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 6, FORMAT(PayrollDate), false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        EnterCell(RowNo, 7, MotifDePaiement, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertSGBLFooter();
    begin
        RowNo += 1;
        EnterCell(RowNo, 4, 'Total Salary', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, FORMAT(TotalEmpNetPay), false, false, false, '', TempExcelBuffer."Cell Type"::Number);

        RowNo += 2;
        EnterCell(RowNo, 1, 'et de créditer les comptes des noms précités à titre de domicilation.', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo += 1;
        EnterCell(RowNo, 1, 'En vous remerciant d' + '''' + 'avance,veuillez agréer,Messieurs,nos salutations', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo += 1;
        EnterCell(RowNo, 1, 'distinguées', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo += 1;
        EnterCell(RowNo, 4, 'Administrateur délègué', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertByblosHeader();
    var
        BranchCode: Text[20];
    begin
        CompanyInfo.GET();

        CLEAR(BankAcc);
        BankAcc.RESET;
        BankAcc.SETRANGE("No.", BankNo);
        if BankAcc.FINDFIRST then
            BankNo := BankAcc."Bank Branch No.";

        RowNo := 1;
        EnterCell(RowNo, 1, 'Company CIF', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, 'Branch Code', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, BankNo, false, false, false, '', TempExcelBuffer."Cell Type"::Number);

        RowNo += 1;
        EnterCell(RowNo, 1, 'Company Name', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 2, CompanyInfo.Name, false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo += 1;
        EnterCell(RowNo, 1, 'Company Account Number', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 2, CompIBAN, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, 'Currency', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, CurrCode, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, 'Total Amount', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo += 2;
        EnterCell(RowNo, 1, 'Employee Number (Ref)', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 2, 'Account Number', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, 'Employee Name', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, 'Branch', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, 'Value Date', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 6, 'Amount', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertByblosLine();
    begin
        RowNo += 1;
        EnterCell(RowNo, 1, Employee."No.", false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 2, EmpAccNo, false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        EnterCell(RowNo, 3, Employee."Full Name", false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, Employee.Branch, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, FORMAT("Payroll Ledger Entry"."Payroll Date"), false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        EnterCell(RowNo, 6, FORMAT(EmpNetPay), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure InsertByblosTotalAmt();
    begin
        EnterCell(3, 6, FORMAT(TotalEmpNetPay), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure InsertBLOMExcelHeader();
    begin
        RowNo := 1;
        EnterCell(RowNo, 1, 'BEIRUT ' + Format(ValueDate), true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 3;
        EnterCell(RowNo, 1, BankName, true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo := 4;
        EnterCell(RowNo, 1, 'Reference', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 2, 'Client Name', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, 'Account Number', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, 'IBAN', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, 'Description', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 6, 'Monthly salary', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure InsertBLOMExcelLine();
    begin
        RowNo := RowNo + 1;
        //EnterCell(RowNo,1,FORMAT(ValueDate),false,false,false,'',TempExcelBuffer."Cell Type"::Date);
        EnterCell(RowNo, 2, EmpBankName, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 3, EmpAccNo, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 4, IBAN, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 5, 'Monthly Salay', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 6, FORMAT(EmpNetPay), false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure InsertBLOMFooter();
    begin
        RowNo += 1;
        EnterCell(RowNo, 5, 'Total', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        EnterCell(RowNo, 6, FORMAT(TotalEmpNetPay), true, false, false, '', TempExcelBuffer."Cell Type"::Number);

        RowNo += 2;
        EnterCell(RowNo, 1, 'AUTHORIZED SIGNATURE', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo += 4;
        EnterCell(RowNo, 1, Chairman, true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        RowNo += 1;
        EnterCell(RowNo, 1, 'CHAIRMAN', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;
}

