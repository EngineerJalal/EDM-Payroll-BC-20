report 98103 "Dynamic Summary List"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Dynamic Summary List.rdlc';

    dataset
    {
        dataitem("Payroll Ledger Entry"; "Payroll Ledger Entry")
        {
            DataItemTableView = SORTING ("Employee No.", Open);
            RequestFilterFields = "Employee No.", "Payroll Date", "Payment Category", "Payroll Group Code","Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(NetPay_PayrollLedgerEntry; "Payroll Ledger Entry"."Net Pay")
            {
            }
            column(EmployeeNo; "Payroll Ledger Entry"."Employee No.")
            {
            }
            column(EmployeeNoFilter;EmployeeNoFilter)
            {
            }
            column(GrandTotalDeduction;GrandTotalDeduction)
            {
            }
            column(GrandTotalAddition;GrandTotalAddition)
            {
            }   
            column(GrandTotalDeductionUSD;GrandTotalDeductionUSD)
            {
            }
            column(GrandTotalAdditionUSD;GrandTotalAdditionUSD)
            {
            }
            column(NetPay; NetPay)
            {
            }
            column(NetPayACY; NetPayACY)
            {
            }
            column(LeaveBalance; LeaveBalance)
            {
            }
            column(Payroll_Ledger_Entry__Job_Title_; "Job Title")
            {
            }
            column(Payroll_Ledger_Entry__Job_Position_Code_; "Job Position Code")
            {
            }
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(RemainingLoan; RemainingLoan)
            {
            }
            column(EmployeeName; EmployeeName)
            {
            }
            column(Payroll_Ledger_Entry__Payroll_Date_; "Payroll Date")
            {
            }
            column(Payroll_Ledger_Entry__Department_Name_; "Income Tax")
            {
            }
            column(Roundings; Roundings)
            {
            }
            column(NSSFNo; NSSFNo)
            {
            }
            column(FinanceNo; FinanceNo)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(LineNumber; LineNumber)
            {
            }
            column(TotalNetpay; TotalNetpay)
            {
            }
            column(TotalNetpayUSD; TotalNetpayUSD)
            {
            }
            column(USD_Currency; USD_Currency)
            {
            }
            column(HeaderCaption; HeaderCaption)
            {
            }
            column(GroupValue; GroupValue)
            {
            }
            column(rowdata; rowdata)
            {
            }
            column(Hdata1; Hdata1)
            {
            }
            column(Hdata2; Hdata2)
            {
            }
            column(HCaption1; HCaption1)
            {
            }
            column(HCaption2; HCaption2)
            {
            }
            column(TAdditions; TAdditions)
            {
            }
            column(TDeductions; TDeductions)
            {
            }
            column(TAdditionsUSD; TAdditionsUSD)
            {
            }
            column(TDeductionsUSD; TDeductionsUSD)
            {
            }
            column(Group2Value; Group2Value)
            {
            }
            column(LoanBalance; LoanBalance)
            {
            }
            column(LoanBalanceACY; LoanBalanceACY)
            {
            }
            column(TotalLoanBalance; TotalLoanBalance)
            {
            }
            column(TotalLoanBalanceACY; TotalLoanBalanceACY)
            {
            }
            column(GroupType; GroupType)
            {
            }
            column(GlobalDimension1Name; GlobalDimension1Name)
            {
            }
            column(GlobalDimension2Name; GlobalDimension2Name)
            {
            }
            column(CUSTINDVar; CUSTINDVar)
            {
            }
            column(GlobalDimension1Caption; GlobalDimension1Caption)
            {
            }
            column(GlobalDimension2Caption; GlobalDimension2Caption)
            {
            }
            column(EmploymentDate; EmploymentDate)
            {
            }
            dataitem("Pay Element"; "Pay Element")
            {
                DataItemLink = "Date Filter" = FIELD ("Payroll Date"),
                "Employee No. Filter" = FIELD ("Employee No."),               
                "Payment Category Filter"=FIELD("Payment Category");
                DataItemTableView = SORTING ("Order No.", Code, Type) ORDER(Ascending);
                column(PayslipDescription_PayElement; "Pay Element"."Payslip Description")
                {
                }
                column(Tax;Tax)
                {
                }
                column(Type;Type)
                {
                }
                column(ShowinPayslip_PayElement; "Pay Element"."Show in Reports")
                {
                }
                column(CalculatedAmount_PayElement; "Pay Element"."Calculated Amount")
                {
                }
                column(CalculatedAmount_PayElement_ACY; "Pay Element"."Calculated Amount (ACY)")
                {
                }
                column(CalculatedAmount_PayElement_USD; CalculatedAmount_PayElement_USD)
                {
                }
                column(Code_PayElement; "Pay Element".Code)
                {
                }
                column(Type_PayElement; "Pay Element".Type)
                {
                }
                column(OtherAddition; OtherAddition)
                {
                }
                column(OtherDeduction; OtherDeduction)
                {
                }
                column(TotalDeduction; TotalDeduction)
                {
                }
                column(TotalAddition; TotalAddition)
                {
                }                           
                column(OtherAdditionUSD; OtherAdditionUSD)
                {
                }
                column(OtherDeductionUSD; OtherDeductionUSD)
                {
                }
                column(TotalAdditionUSD; TotalAdditionUSD)
                {
                }
                column(TotalDeductionUSD; TotalDeductionUSD)
                {
                }
                column(OrderNo; "Pay Element"."Order No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PayelementAmount := 0;
                    CALCFIELDS("Calculated Amount");
                    if "Calculated Amount" = 0 then
                        CurrReport.SKIP;

                    if "Show in Reports" = false then
                        if Type = Type::Addition then
                            OtherAddition := OtherAddition + "Calculated Amount"
                        else
                            OtherDeduction := OtherDeduction + "Calculated Amount";

                    if "Show in Reports" = false then
                        if Type = Type::Addition then
                            OtherAdditionUSD := OtherAdditionUSD + ExchEquivAmountInACY(OtherAddition)
                        else
                            OtherDeductionUSD := OtherDeductionUSD + ExchEquivAmountInACY(OtherDeduction);

                    CalculatedAmount_PayElement_USD := ExchEquivAmountInACY("Calculated Amount");
                end;
            }
        
            trigger OnAfterGetRecord();
            begin
                if("Payroll Ledger Entry"."Employee No." = '') or(PayrollFunction.CanUserAccessEmployeeSalary('', "Payroll Ledger Entry"."Employee No.") = false) then
                    CurrReport.SKIP;
                //EDM+
                PayDetailLineRec.RESET;
                PayDetailLineRec.CalcFields("Payment Category");
                PayDetailLineRec.SETRANGE("Payment Category","Payment Category");
                PayDetailLineRec.SETRANGE("Employee No.","Employee No.");
                PayDetailLineRec.SETRANGE("Payroll Date","Payroll Date"); 
                PayDetailLineRec.SETRANGE(Type,PayDetailLineRec.Type::Addition);  
                IF PayDetailLineRec.FINDFIRST THEN repeat
                    GrandTotalAddition := GrandTotalAddition+PayDetailLineRec."Calculated Amount";
                UNTIL PayDetailLineRec.NEXt=0;  

                PayDetailLineRec.RESET;
                PayDetailLineRec.CalcFields("Payment Category");
                PayDetailLineRec.SETRANGE("Payment Category","Payment Category");
                PayDetailLineRec.SETRANGE("Employee No.","Employee No.");
                PayDetailLineRec.SETRANGE("Payroll Date","Payroll Date"); 
                PayDetailLineRec.SETRANGE(Type,PayDetailLineRec.Type::Deduction);  
                IF PayDetailLineRec.FINDFIRST THEN repeat
                    GrandTotalDeduction := GrandTotalDeduction+PayDetailLineRec."Calculated Amount";
                UNTIL PayDetailLineRec.NEXt=0;  

                GrandTotalAdditionUSD := ExchEquivAmountInACY(GrandTotalAddition);
                GrandTotalDeductionUSD  := ExchEquivAmountInACY(GrandTotalDeduction);
                //EDM-    
                if ExchangeRate <= 0 then
                    ExchangeRate := 1500;

                LineNumber := LineNumber + 1;
                if GroupType = GroupType::"Employee No." then begin
                    Group2Value := FORMAT("Payroll Ledger Entry"."Payroll Date");
                    GroupValue := "Payroll Ledger Entry"."Employee No.";
                end
                else begin
                    GroupValue := FORMAT(1);
                    Group2Value := FORMAT(LineNumber);
                end;
                if GroupType = GroupType::"Employee No." then begin
                    rowdata := FORMAT("Payroll Ledger Entry"."Payroll Date");
                    Hdata1 := "Payroll Ledger Entry"."Employee No.";
                    CLEAR(Employee);
                    Employee.SETRANGE("No.", "Employee No.");
                    if Employee.FINDFIRST then
                        EmployeeName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    Hdata2 := EmployeeName;
                end
                else begin
                    Hdata1 := FORMAT(FromDate);
                    Hdata2 := FORMAT(ToDate);
                    CLEAR(Employee);
                    Employee.SETRANGE("No.", "Employee No.");
                    if Employee.FINDFIRST then begin
                        EmployeeName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                        rowdata := "Employee No.";
                    end;
                end;
                NetPay := 0;
                RemainingLoan := 0;
                LeaveBalance := 0;
                TotalAddition := 0;
                TotalDeduction := 0;
                OtherAddition := 0;
                OtherDeduction := 0;
                OtherAdditionUSD := 0;
                OtherDeductionUSD := 0;
                TotalAdditionUSD := 0;
                TotalDeductionUSD := 0;

                Roundings := 0;
                ShowAddition := true;
                ShowDeduction := true;
                NetPayACY := 0;

                RemainingLoan := "Payroll Ledger Entry"."Outstanding Loan";
                NetPay := "Payroll Ledger Entry"."Net Pay";

                NetPayACY := ExchEquivAmountInACY(NetPay);

                LeaveBalance := "Payroll Ledger Entry"."Vacation Balance";
                Roundings := "Payroll Ledger Entry".Rounding;

                Employee.SETRANGE("No.", "Employee No.");
                if Employee.FINDFIRST then begin
                    EmployeeName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    NSSFNo := Employee."Social Security No.";
                    FinanceNo := Employee."Personal Finance No.";
                    GlobalDimension1Code := Employee."Global Dimension 1 Code";
                    GlobalDimension2Code := Employee."Global Dimension 2 Code";
                    EmploymentDate := Employee."Employment Date";
                end
                else begin
                    EmployeeName := '';
                    NSSFNo := '';
                    FinanceNo := '';
                    GlobalDimension1Code := '';
                    GlobalDimension2Code := '';
                    EmploymentDate := 0D;
                end;
                DimensionValueRec.SETRANGE("Code", GlobalDimension1Code);
                DimensionValueRec.SETRANGE("Global Dimension No.", 1);
                IF DimensionValueRec.FINDFIRST then
                    GlobalDimension1Name := DimensionValueRec.Name;
                DimensionValueRec.SETRANGE("Code", GlobalDimension2Code);
                DimensionValueRec.SETRANGE("Global Dimension No.", 2);
                IF DimensionValueRec.FINDFIRST then
                    GlobalDimension2Name := DimensionValueRec.Name;
                //
                GLSetup.GET;
                DimensionRec.SETRANGE(Code, GLSetup."Global Dimension 1 Code");
                IF DimensionRec.FINDFIRST then
                    GlobalDimension1Caption := DimensionRec.Name;
                DimensionRec.SETRANGE(Code, GLSetup."Global Dimension 2 Code");
                IF DimensionRec.FINDFIRST then
                    GlobalDimension2Caption := DimensionRec.Name;
                //
                HRSetup.GET;
                CUSTINDVar := UpperCase(HRSetup.CUSTIND);
                //
                /*if GroupType = GroupType::"Payroll Date" then begin
                    TotalNetpay := TotalNetpay + NetPay;
                    TotalNetpayUSD := ExchEquivAmountInACY(TotalNetpay);
                end
                else begin
                    TotalNetpay := 0;
                    TotalNetpayUSD := 0;
                    CLEAR(payledentry);
                    payledentry.SETRANGE("Employee No.", "Employee No.");
                    payledentry.SETRANGE("Payroll Date", FromDate, ToDate);
                    payledentry.SETRANGE("Payment Category", "Payment Category");
                    if payledentry.FINDFIRST then repeat
                        TotalNetpay += payledentry."Net Pay";
                    until payledentry.NEXT = 0;
                    TotalNetpayUSD := ExchEquivAmountInACY(TotalNetpay);
                end;*/
                //
                if GroupType = GroupType::"Payroll Date" then begin
                    TotalAddition := 0;
                    TotalAdditionUSD := 0;
                    TotalDeduction := 0;
                    TotalDeductionUSD := 0;
                    PayDetailLine.CalcFields("Payment Category");
                    PayDetailLine.SETRANGE("Payment Category", "Payment Category");
                    PayDetailLine.SETRANGE("Payroll Date", "Payroll Date");
                    PayDetailLine.SETRANGE("Employee No.", "Employee No.");
                    if PayDetailLine.FINDFIRST then repeat
                    if PayDetailLine.Type = PayDetailLine.Type::Addition then begin
                            TotalAddition += PayDetailLine."Calculated Amount";
                            TotalAdditionUSD := ExchEquivAmountInACY(TotalAddition);
                        end
                        else begin
                            TotalDeduction += PayDetailLine."Calculated Amount";
                            TotalDeductionUSD := ExchEquivAmountInACY(TotalDeduction);
                        end;
                        until PayDetailLine.NEXT = 0;
                    TAdditions += TotalAddition;
                    TAdditionsUSD += TotalAdditionUSD;
                    TDeductions += TotalDeduction;
                    TDeductionsUSD += TotalDeductionUSD;
                end
                else begin
                    if preEmployee <> "Payroll Ledger Entry"."Employee No." then begin
                        TAdditions := 0;
                        TAdditionsUSD := 0;
                        TDeductions := 0;
                        TDeductionsUSD := 0;
                    end;
                    TotalAddition := 0;
                    TotalAdditionUSD := 0;
                    TotalDeduction := 0;
                    TotalDeductionUSD := 0;
                    PayDetailLine.CalcFields("Payment Category");
                    PayDetailLine.SETRANGE("Payment Category", "Payment Category");
                    PayDetailLine.SETRANGE("Payroll Date", "Payroll Date");
                    PayDetailLine.SETRANGE("Employee No.", "Employee No.");
                    if PayDetailLine.FINDFIRST then repeat
                    if PayDetailLine.Type = PayDetailLine.Type::Addition then begin
                            TotalAddition += PayDetailLine."Calculated Amount";
                            TotalAdditionUSD := ExchEquivAmountInACY(TotalAddition);
                        end
                        else begin
                            TotalDeduction += PayDetailLine."Calculated Amount";
                            TotalDeductionUSD := ExchEquivAmountInACY(TotalDeduction);
                        end;
                        until PayDetailLine.NEXT = 0;
                    TAdditions += TotalAddition;
                    TAdditionsUSD += TotalAdditionUSD;
                    TDeductions += TotalDeduction;
                    TDeductionsUSD += TotalDeductionUSD;
                end;
                preEmployee := "Payroll Ledger Entry"."Employee No.";

                LoanBalance := 0;
                LoanBalanceACY := 0;
                LoanBalance := PayrollFunction.GetEmployeeRemainingLoanBalance("Payroll Ledger Entry"."Employee No.", "Payroll Ledger Entry"."Payroll Date");
                LoanBalanceACY := ExchEquivAmountInACY(LoanBalance);
                if GroupType = GroupType::"Payroll Date" then begin
                    TotalLoanBalance += LoanBalance;
                    TotalLoanBalanceACY += LoanBalanceACY;
                end;

            end;

            trigger OnPreDataItem();
            begin
                FromDate := GETRANGEMIN("Payroll Date");
                ToDate := GETRANGEMAX("Payroll Date");
                EmployeeNoFilter := GetFilter("Employee No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                field("USD Currency"; USD_Currency)
                {
                    Visible = true;
                    ApplicationArea=All;
                }
                field(ExchangeRate; ExchangeRate)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            if PayParam.FINDFIRST then
                ExchangeRate := PayParam."ACY Currency Rate";
            //
            GroupType := GroupType::"Employee No.";
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        if PayrollFunction.HideSalaryFields() = true then
            if PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' then
                ERROR('No Permission!');

        AmountRoundingPrecision := 2;
        Currency.SETRANGE(Code, 'USD');
        if Currency.FINDFIRST then begin
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
            CurrencyFactor := CurrExchRate.ExchangeRate(TODAY, 'USD');
            ExchangeRate := CurrExchRate."Relational Adjmt Exch Rate Amt";
        end;
        if ExchangeRate <= 0 then
            ExchangeRate := 1500;
        CompanyInfo.GET;

    end;

    trigger OnPreReport();
    begin
        CompanyInfo.CALCFIELDS(Picture);
        if GroupType = GroupType::"Payroll Date" then begin
            HeaderCaption := 'Employee';
            HCaption1 := 'Payroll Date From';
            HCaption2 := 'Payroll Date To';
        end
        else begin
            HeaderCaption := 'Payroll Date';
            HCaption1 := 'Employee No.';
            HCaption2 := 'Employee Name';
        end;
        TAdditions := 0;
        TAdditionsUSD := 0;
        TDeductions := 0;
        TDeductionsUSD := 0;
    end;

    var
        CompanyInformation: Record "Company Information";
        PayParam: Record "Payroll Parameter";
        PayDetailLine: Record "Pay Detail Line";
        HRSetup: Record "Human Resources Setup";
        CUSTINDVar: Text[15];
        NetPay: Decimal;
        RemainingLoan: Decimal;
        LeaveBalance: Decimal;
        Employee: Record Employee;
        EmployeeName: Text[150];
        FromDate: Date;
        ToDate: Date;
        Roundings: Decimal;
        DescriptionAddition: Text[100];
        DescriptionDeduction: Text[100];
        AmountAddition: Decimal;
        AmountDeduction: Decimal;
        TotalAddition: Decimal;
        TotalDeduction: Decimal;
        ShowAddition: Boolean;
        ShowDeduction: Boolean;
        OtherAddition: Decimal;
        OtherDeduction: Decimal;
        CompanyInfo: Record "Company Information";
        NSSFNo: Code[30];
        FinanceNo: Code[30];
        PayElementRecord: Record "Pay Element";
        VarCuFactor: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        NetPayACY: Decimal;
        GLSetup: Record "General Ledger Setup";
        AmounttoArabic: Codeunit "EDM Functions";
        TotalFor: Label '"Total for "';
        TotalEarning: Decimal;
        LineNumber: Integer;
        PayelementAmount: Decimal;
        TotalNetpay: Decimal;
        TotalNetpayUSD: Decimal;
        USD_Currency: Boolean;
        TotalAdditionUSD: Decimal;
        TotalDeductionUSD: Decimal;
        OtherAdditionUSD: Decimal;
        OtherDeductionUSD: Decimal;
        HeaderCaption: Text;
        rowdata: Text;
        GroupType: Option "Payroll Date", "Employee No.";
        GroupValue: Text;
        Hdata1: Text;
        Hdata2: Text;
        HCaption1: Text;
        HCaption2: Text;
        payledentry: Record "Payroll Ledger Entry";
        TAdditions: Decimal;
        TDeductions: Decimal;
        TAdditionsUSD: Decimal;
        TDeductionsUSD: Decimal;
        Group2Value: Text;
        preEmployee: Code[20];
        PayrollFunction: Codeunit "Payroll Functions";
        ExchangeRate: Decimal;
        AmountRoundingPrecision: Decimal;
        Currency: Record Currency;
        CurrencyFactor: Decimal;
        CalculatedAmount_PayElement_USD: Decimal;
        LoanBalance: Decimal;
        LoanBalanceACY: Decimal;
        TotalLoanBalance: Decimal;
        TotalLoanBalanceACY: Decimal;
        GlobalDimension1Code: Code[20];
        GlobalDimension1Caption: Text[50];
        GlobalDimension1Name: Text[50];
        GlobalDimension2Code: Code[20];
        GlobalDimension2Caption: Text[50];
        GlobalDimension2Name: Text[50];
        EmploymentDate: Date;
        DimensionValueRec: Record "Dimension Value";
        DimensionRec: Record "Dimension";
        GrandTotalAddition: Decimal;
        GrandTotalDeduction: Decimal;
        GrandTotalAdditionUSD: Decimal;
        GrandTotalDeductionUSD: Decimal;
        EmployeeNoFilter : text [250];
        PayDetailLineRec : Record "Pay Detail Line";
    local procedure ExchangeTotaltoUSD(TotalVal: Decimal) Val: Decimal;
    begin

        if ExchangeRate <= 0 then
            ExchangeRate := 1500;
        Val := ROUND(TotalVal / ExchangeRate, AmountRoundingPrecision, '=');
        exit(Val);
    end;

    local procedure ExchEquivAmountInACY(L_AmoountInLCY: Decimal) L_AmouontInACY: Decimal;
    begin
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
    end;
}

