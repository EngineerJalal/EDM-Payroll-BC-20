report 98052 "Payroll Summary by Location"
{
    // version Temp,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll Summary by Location.rdlc';

    dataset
    {
        dataitem("Payroll Ledger Entry";"Payroll Ledger Entry")
        {
            DataItemTableView = SORTING("Employee No.",Open);
            RequestFilterFields = "Employee No.","Payroll Date";
            column(NetPay_PayrollLedgerEntry;"Payroll Ledger Entry"."Net Pay")
            {
            }
            column(EmployeeNo_PayrollLedgerEntry;"Payroll Ledger Entry"."Employee No.")
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(NetPayACY;NetPayACY)
            {
            }
            column(LeaveBalance;LeaveBalance)
            {
            }
            column(Payroll_Ledger_Entry__Job_Title_;"Job Title")
            {
            }
            column(Payroll_Ledger_Entry__Job_Position_Code_;"Job Position Code")
            {
            }
            column(CompanyName;CompanyInformation.Name)
            {
            }
            column(CompanyPicture;CompanyInfo.Picture)
            {
            }
            column(RemainingLoan;RemainingLoan)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(Location_PayrollLedgerEntry;Location)
            {
            }
            column(Payroll_Ledger_Entry__Payroll_Date_;"Payroll Date")
            {
            }
            column(Payroll_Ledger_Entry__Department_Name_;"Income Tax")
            {
            }
            column(Roundings;Roundings)
            {
            }
            column(NSSFNo;NSSFNo)
            {
            }
            column(FinanceNo;FinanceNo)
            {
            }
            column(ArabicAmountText;ArabicAmountText[1])
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(ToDate;ToDate)
            {
            }
            column(LineNumber;LineNumber)
            {
            }
            column(TotalNetpay;TotalNetpay)
            {
            }
            column(TotalNetpayUSD;TotalNetpayUSD)
            {
            }
            column(USD_Currency;USD_Currency)
            {
            }
            column(HeaderCaption;HeaderCaption)
            {
            }
            column(GroupValue;GroupValue)
            {
            }
            column(rowdata;rowdata)
            {
            }
            column(Hdata1;Hdata1)
            {
            }
            column(Hdata2;Hdata2)
            {
            }
            column(HCaption1;HCaption1)
            {
            }
            column(HCaption2;HCaption2)
            {
            }
            column(TAdditions;TAdditions)
            {
            }
            column(TDeductions;TDeductions)
            {
            }
            column(TAdditionsUSD;TAdditionsUSD)
            {
            }
            column(TDeductionsUSD;TDeductionsUSD)
            {
            }
            column(Group2Value;Group2Value)
            {
            }
            column(EmployeeCntPerLocation;EmployeeCntPerLocation)
            {
            }
            dataitem("Pay Element";"Pay Element")
            {
                DataItemLink = "Date Filter"=FIELD("Payroll Date"),"Employee No. Filter"=FIELD("Employee No.");
                DataItemTableView = SORTING("Order No.",Code,Type) ORDER(Ascending);
                column(PayslipDescription_PayElement;"Pay Element"."Payslip Description")
                {
                }
                column(ShowinPayslip_PayElement;"Pay Element"."Show in Reports")
                {
                }
                column(CalculatedAmount_PayElement;"Pay Element"."Calculated Amount")
                {
                }
                column(CalculatedAmount_PayElement_ACY;"Pay Element"."Calculated Amount (ACY)")
                {
                }
                column(CalculatedAmount_PayElement_USD;CalculatedAmount_PayElement_USD)
                {
                }
                column(Code_PayElement;"Pay Element".Code)
                {
                }
                column(Type_PayElement;"Pay Element".Type)
                {
                }
                column(OtherAddition;OtherAddition)
                {
                }
                column(OtherDeduction;OtherDeduction)
                {
                }
                column(TotalDeduction;TotalDeduction)
                {
                }
                column(TotalAddition;TotalAddition)
                {
                }
                column(OtherAdditionUSD;OtherAdditionUSD)
                {
                }
                column(OtherDeductionUSD;OtherDeductionUSD)
                {
                }
                column(TotalAdditionUSD;TotalAdditionUSD)
                {
                }
                column(TotalDeductionUSD;TotalDeductionUSD)
                {
                }
                column(OrderNo;"Pay Element"."Order No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PayelementAmount:=0;
                    CALCFIELDS("Calculated Amount");
                    if "Calculated Amount"=0 then
                      CurrReport.SKIP;
                    
                    //MESSAGE(FORMAT("Pay Element"."Employee No. Filter"));
                    
                    if "Show in Reports" = false then
                      if Type=Type::Addition then
                          OtherAddition := OtherAddition+"Calculated Amount"
                      else
                          OtherDeduction :=  OtherDeduction + "Calculated Amount";
                    
                    /*IF Type=Type::Addition THEN
                      TotalAddition:=TotalAddition+"Calculated Amount"
                    ELSE
                      TotalDeduction:=TotalDeduction+"Calculated Amount";
                      */
                    if "Show in Reports" = false then
                      if Type=Type::Addition then
                          //Modified to get value in USD - 04.08.2016 : AIM +
                          //OtherAdditionUSD := OtherAdditionUSD+"Calculated Amount (ACY)"
                    
                          // Modified in order to show amount in ACY - 15.11.2016 : A2+
                          //OtherAdditionUSD := OtherAdditionUSD + ExchangeTotaltoUSD(OtherAddition)
                          OtherAdditionUSD := OtherAdditionUSD + ExchEquivAmountInACY(OtherAddition)
                          // Modified in order to show amount in ACY - 15.11.2016 : A2-
                    
                         //Modified to get value in USD - 04.08.2016 : AIM -
                      else
                         //Modified to get value in USD - 04.08.2016 : AIM +
                         // OtherDeductionUSD :=  OtherDeductionUSD + "Calculated Amount (ACY)";
                    
                         // Modified in order to show amount in ACY - 15.11.2016 : A2+
                         //OtherDeductionUSD := OtherDeductionUSD + ExchangeTotaltoUSD(OtherDeduction);
                         OtherDeductionUSD := OtherDeductionUSD + ExchEquivAmountInACY(OtherDeduction);
                         // Modified in order to show amount in ACY - 15.11.2016 : A2-
                    
                        //Modified to get value in USD - 04.08.2016 : AIM -
                    /*
                    IF Type=Type::Addition THEN
                      TotalAdditionUSD :=TotalAdditionUSD +"Calculated Amount (ACY)"
                    ELSE
                      TotalDeductionUSD :=TotalDeductionUSD +"Calculated Amount (ACY)";
                      */
                    //Added to get value in USD - 04.08.2016 : AIM +
                    
                    // Modified in order to show amount in ACY - 15.11.2016 : A2+
                    //CalculatedAmount_PayElement_USD := ExchangeTotaltoUSD("Calculated Amount");
                    CalculatedAmount_PayElement_USD := ExchEquivAmountInACY("Calculated Amount");
                    // Modified in order to show amount in ACY - 15.11.2016 : A2-
                    
                    //Added to get value in USD - 04.08.2016 : AIM -

                end;
            }

            trigger OnAfterGetRecord();
            begin

                //Added in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM +
                if ("Payroll Ledger Entry"."Employee No." = '') or ( PayrollFunction.CanUserAccessEmployeeSalary('',"Payroll Ledger Entry"."Employee No.") = false) then
                  CurrReport.SKIP;
                //Added in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM -

                //Added in order to show the results in USD - 04.08.2016 : AIM -
                if ExchangeRate <= 0 then
                  ExchangeRate := 1500;
                //Added in order to show the results in USD - 04.08.2016 : AIM -

                LineNumber:=LineNumber+1;


                GroupValue :=FORMAT(1);
                Group2Value := FORMAT(LineNumber);

                Hdata1 := FORMAT(FromDate);
                Hdata2 := FORMAT(ToDate);
                CLEAR(Employee);
                Employee.SETRANGE("No.","Employee No.");
                if Employee.FINDFIRST then
                begin
                EmployeeName:=Employee."First Name"+' '+Employee."Middle Name"+' '+Employee."Last Name";
                rowdata := "Employee No." +' '+ EmployeeName;
                Location := "Payroll Ledger Entry".Location;
                end;

                NetPay:=0;
                RemainingLoan:=0;
                LeaveBalance:=0;
                TotalAddition :=0;
                TotalDeduction :=0;
                OtherAddition :=0;
                OtherDeduction  :=0;
                OtherAdditionUSD:=0;
                OtherDeductionUSD:=0;
                TotalAdditionUSD:=0;
                TotalDeductionUSD:=0;

                Roundings:=0;
                ShowAddition:=true;
                ShowDeduction := true;
                NetPayACY:=0;

                RemainingLoan:="Payroll Ledger Entry"."Outstanding Loan";
                NetPay := "Payroll Ledger Entry"."Net Pay";

                //EDM.IT+
                //GLSetup.GET;
                //VarCuFactor:= CurrExchRate.ExchangeRate(TODAY,GLSetup."Additional Reporting Currency");
                //Modified to get value in USD - 04.08.2016 : AIM +
                //NetPayACY:=ROUND(CurrExchRate.ExchangeAmtFCYToFCY("Posting Date",'','USD',NetPay),2);
                //CurrExchRate.ExchangeAmtLCYToFCY(TODAY,GLSetup."Additional Reporting Currency",NetPay,VarCuFactor);

                // Modified in order to show amount in ACY - 15.11.2016 : A2+
                //NetPayACY := ExchangeTotaltoUSD(NetPay);
                  NetPayACY := ExchEquivAmountInACY(NetPay);
                // Modified in order to show amount in ACY - 15.11.2016 : A2-

                //Modified to get value in USD - 04.08.2016 : AIM -
                //AmounttoArabic.FormatNoText(ArabicAmountText,NetPay,'');
                //EDM.IT-

                LeaveBalance:="Payroll Ledger Entry"."Vacation Balance";
                Roundings:="Payroll Ledger Entry".Rounding;

                Employee.SETRANGE("No.","Employee No.");
                if Employee.FINDFIRST then
                begin
                  EmployeeName:=Employee."First Name"+' '+Employee."Middle Name"+' '+Employee."Last Name";
                  NSSFNo:=Employee."Social Security No.";
                  FinanceNo:=Employee."Personal Finance No.";
                end
                else
                begin
                  EmployeeName:='';
                  NSSFNo:='';
                  FinanceNo:='';

                end;
                //IF GroupType = GroupType::"Payroll Date" THEN BEGIN

                //TotalNetpay:=TotalNetpay+NetPay;
                TotalNetpay := GetNetPayTotal("Payroll Ledger Entry"."Payroll Date");
                //Modified to get value in USD - 04.08.2016 : AIM +
                //TotalNetpayUSD:=CurrExchRate.ExchangeAmtFCYToFCY("Posting Date",'','USD',TotalNetpay);

                // Modified in order to show amount in ACY - 15.11.2016 : A2+
                //TotalNetpayUSD := ExchangeTotaltoUSD(TotalNetpay);
                TotalNetpayUSD := ExchEquivAmountInACY(TotalNetpay);
                // Modified in order to show amount in ACY - 15.11.2016 : A2-

                //Modified to get value in USD - 04.08.2016 : AIM -

                TotalAddition := 0;
                TotalAdditionUSD := 0;
                TotalDeduction := 0;
                TotalDeductionUSD := 0;
                PayDetailLine.SETRANGE("Payroll Date","Payroll Ledger Entry"."Payroll Date");
                PayDetailLine.SETRANGE("Employee No.","Employee No.");
                if PayDetailLine.FINDFIRST then
                  repeat
                      if PayDetailLine.Type = PayDetailLine.Type::Addition then
                      begin
                          TotalAddition += PayDetailLine."Calculated Amount";
                          //Modified to get value in USD - 04.08.2016 : AIM +
                          //TotalAdditionUSD += PayDetailLine."Calculated Amount (ACY)";

                          // Modified in order to show amount in ACY - 15.11.2016 : A2+
                          //TotalAdditionUSD += ExchangeTotaltoUSD(TotalAddition);
                            TotalAdditionUSD := ExchEquivAmountInACY(TotalAddition);
                          // Modified in order to show amount in ACY - 15.11.2016 : A2-

                          //Modified to get value in USD - 04.08.2016 : AIM -
                      end
                      else
                          begin
                                TotalDeduction += PayDetailLine."Calculated Amount";
                                //Modified to get value in USD - 04.08.2016 : AIM +
                                //TotalDeductionUSD += PayDetailLine."Calculated Amount (ACY)";

                                // Modified in order to show amount in ACY - 15.11.2016 : A2+
                                //TotalDeductionUSD   += ExchangeTotaltoUSD(TotalDeduction);
                                TotalDeductionUSD := ExchEquivAmountInACY(TotalDeduction);
                                // Modified in order to show amount in ACY - 15.11.2016 : A2-

                                //Modified to get value in USD - 04.08.2016 : AIM -
                          end;
                  until PayDetailLine.NEXT = 0;

                TAdditions += TotalAddition;
                TAdditionsUSD += TotalAdditionUSD;
                TDeductions += TotalDeduction;
                TDeductionsUSD += TotalDeductionUSD;
                "Payroll Ledger Entry".CALCFIELDS(Location);
                EmployeeCntPerLocation := GetEmployeeCountPerLocation( "Payroll Ledger Entry".Location);
                NetPay := GetNetPayTotalPerLocation("Payroll Ledger Entry".Location ,"Payroll Ledger Entry"."Payroll Date");
                NetPayACY := ExchEquivAmountInACY(NetPay);
            end;

            trigger OnPreDataItem();
            begin
                FromDate:=GETRANGEMIN("Payroll Date");
                ToDate:=GETRANGEMAX("Payroll Date");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("USD Currency";USD_Currency)
                {
                    Visible = true;
                    ApplicationArea=All;
                }
                field(ExchangeRate;ExchangeRate)
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
            // Modified to disable Change ExchangeRate,15.11.2016 : A2+
              if PayParam.FINDFIRST then
              ExchangeRate := PayParam."ACY Currency Rate";
            // Modified to disable Change ExchangeRate,15.11.2016 : A2-
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        //Modified in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM +
         /*
          //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
          IF  PayrollFunction.HideSalaryFields() = TRUE THEN
             ERROR('Permission NOT Allowed!');
          //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
          */
        if  PayrollFunction.HideSalaryFields() = true then
          if PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' then
            ERROR('No Permission!');
        //Modified in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM -
        
        //Added in order to show the results in USD - 04.08.2016 : AIM +
        AmountRoundingPrecision := 2;
        Currency.SETRANGE(Code,'USD');
        if Currency.FINDFIRST then begin
          AmountRoundingPrecision := Currency."Amount Rounding Precision";
          CurrencyFactor := CurrExchRate.ExchangeRate(TODAY,'USD');
          ExchangeRate := CurrExchRate."Relational Adjmt Exch Rate Amt";
        end;
        if ExchangeRate <= 0 then
          ExchangeRate := 1500;
        //Added in order to show the results in USD - 04.08.2016 : AIM -

    end;

    trigger OnPreReport();
    begin
        CompanyInfo.CALCFIELDS(Picture);
        //IF GroupType = GroupType::"Payroll Date" THEN BEGIN
          HeaderCaption := 'Employee';
          HCaption1 := 'Payroll Date From';
          HCaption2 := 'Payroll Date To';
        TAdditions := 0;
        TAdditionsUSD := 0;
        TDeductions := 0;
        TDeductionsUSD := 0;
    end;

    var
        CompanyInformation : Record "Company Information";
        PayParam : Record "Payroll Parameter";
        PayDetailLine : Record "Pay Detail Line";
        NetPay : Decimal;
        RemainingLoan : Decimal;
        LeaveBalance : Decimal;
        Employee : Record Employee;
        EmployeeName : Text[150];
        FromDate : Date;
        ToDate : Date;
        Roundings : Decimal;
        DescriptionAddition : Text[100];
        DescriptionDeduction : Text[100];
        AmountAddition : Decimal;
        AmountDeduction : Decimal;
        TotalAddition : Decimal;
        TotalDeduction : Decimal;
        ShowAddition : Boolean;
        ShowDeduction : Boolean;
        OtherAddition : Decimal;
        OtherDeduction : Decimal;
        CompanyInfo : Record "Company Information";
        NSSFNo : Code[30];
        FinanceNo : Code[30];
        PayElementRecord : Record "Pay Element";
        VarCuFactor : Decimal;
        CurrExchRate : Record "Currency Exchange Rate";
        NetPayACY : Decimal;
        GLSetup : Record "General Ledger Setup";
        AmounttoArabic : Codeunit "EDM Functions";
        ArabicAmountText : array [2] of Text[100];
        TotalFor : Label '"Total for "';
        TotalEarning : Decimal;
        LineNumber : Integer;
        PayelementAmount : Decimal;
        TotalNetpay : Decimal;
        TotalNetpayUSD : Decimal;
        USD_Currency : Boolean;
        TotalAdditionUSD : Decimal;
        TotalDeductionUSD : Decimal;
        OtherAdditionUSD : Decimal;
        OtherDeductionUSD : Decimal;
        HeaderCaption : Text;
        rowdata : Text;
        GroupType : Option "Payroll Date","Employee No.";
        GroupValue : Text;
        Hdata1 : Text;
        Hdata2 : Text;
        HCaption1 : Text;
        HCaption2 : Text;
        payledentry : Record "Payroll Ledger Entry";
        TAdditions : Decimal;
        TDeductions : Decimal;
        TAdditionsUSD : Decimal;
        TDeductionsUSD : Decimal;
        Group2Value : Text;
        preEmployee : Code[20];
        PayrollFunction : Codeunit "Payroll Functions";
        ExchangeRate : Decimal;
        AmountRoundingPrecision : Decimal;
        Currency : Record Currency;
        CurrencyFactor : Decimal;
        CalculatedAmount_PayElement_USD : Decimal;
        Location : Code[20];
        EmployeeCntPerLocation : Integer;

    local procedure ExchangeTotaltoUSD(TotalVal : Decimal) Val : Decimal;
    begin

        //Val := ROUND(CurrExchRate.ExchangeAmtFCYToFCY("Posting Date",'','USD',TotalVal),2);
        if ExchangeRate <= 0 then
          ExchangeRate := 1500;
        Val := ROUND(TotalVal / ExchangeRate,AmountRoundingPrecision,'=');
        exit(Val);
    end;

    local procedure ExchEquivAmountInACY(L_AmoountInLCY : Decimal) L_AmouontInACY : Decimal;
    begin
        //Modified because the rate is set in parameter card - 08.11.2016 : A2+
        //L_AmouontInACY := L_AmoountInLCY/PayParam."ACY Currency Rate";
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
        //Modified because the rate is set in parameter card - 08.11.2016 : A2-
    end;

    local procedure GetEmployeeCountPerLocation(LocationCode : Code[10]) Val : Integer;
    var
        EmpTbt : Record Employee;
        i : Integer;
    begin


        i := 0;

        EmpTbt.SETRANGE(EmpTbt.Location,LocationCode);
        if EmpTbt.FINDFIRST then
          repeat
            i := i + 1;
          until EmpTbt.NEXT = 0;

        exit(i);
    end;

    local procedure GetNetPayTotalPerLocation(LocationCode : Code[10];PayDate : Date) Val : Decimal;
    var
        PayLedgerEntryTbt : Record "Payroll Ledger Entry";
    begin



        Val := 0;
        if LocationCode <>  '' then
           PayLedgerEntryTbt.SETRANGE(PayLedgerEntryTbt.Location,LocationCode);
        PayLedgerEntryTbt.SETRANGE(PayLedgerEntryTbt."Payroll Date",PayDate);

        if PayLedgerEntryTbt.FINDFIRST then
          repeat
            Val := Val + PayLedgerEntryTbt."Net Pay";
          until PayLedgerEntryTbt.NEXT = 0;

        exit(Val);
    end;

    local procedure GetNetPayTotal(PayDate : Date) Val : Decimal;
    var
        PayLedgerEntryTbt : Record "Payroll Ledger Entry";
    begin
        Val := 0;
        PayLedgerEntryTbt.SETRANGE(PayLedgerEntryTbt."Payroll Date",PayDate);

        if PayLedgerEntryTbt.FINDFIRST then
          repeat
            Val := Val + PayLedgerEntryTbt."Net Pay";
          until PayLedgerEntryTbt.NEXT = 0;

        exit(Val);
    end;
}

