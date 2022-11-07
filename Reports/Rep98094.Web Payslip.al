report 98094 "Web Payslip"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Web Payslip.rdlc';

    dataset
    {
        dataitem("Pay Detail Header";"Pay Detail Header")
        {
            RequestFilterFields = "Employee No.","Payroll Group Code";
            column(PayFrequency_PayDetailHeader;"Pay Detail Header"."Pay Frequency")
            {
            }
            column(EmployeeNo_PayDetailHeader;"Pay Detail Header"."Employee No.")
            {
            }
            column(CalculationRequired_PayDetailHeader;"Pay Detail Header"."Calculation Required")
            {
            }
            column(PayslipPrinted_PayDetailHeader;"Pay Detail Header"."Payslip Printed")
            {
            }
            column(IncludeinPayCycle_PayDetailHeader;"Pay Detail Header"."Include in Pay Cycle")
            {
            }
            column(PayrollGroupCode_PayDetailHeader;"Pay Detail Header"."Payroll Group Code")
            {
            }
            column(EmployeeName_PayDetailHeader;"Pay Detail Header"."Employee Name")
            {
            }
            column(USDExchangeRate_PayDetailHeader;"Pay Detail Header"."USD Exchange Rate")
            {
            }
            column(ShortcutDimension1Code_PayDetailHeader;"Pay Detail Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PayDetailHeader;"Pay Detail Header"."Shortcut Dimension 2 Code")
            {
            }
            column(UserID_PayDetailHeader;"Pay Detail Header"."User ID")
            {
            }
            column(WorkingDaysAffected_PayDetailHeader;"Pay Detail Header"."Working Days Affected")
            {
            }
            column(AttendanceDaysAffected_PayDetailHeader;"Pay Detail Header"."Attendance Days Affected")
            {
            }
            column(OvertimeHours_PayDetailHeader;"Pay Detail Header"."Overtime Hours")
            {
            }
            column(OvertimePublicHoliday_PayDetailHeader;"Pay Detail Header"."Overtime Public Holiday")
            {
            }
            column(DateFilter_PayDetailHeader;"Pay Detail Header"."Date Filter")
            {
            }
            column(ConvertedSalary_PayDetailHeader;"Pay Detail Header"."Converted Salary")
            {
            }
            column(Country;Country)
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(BankName;BankName)
            {
            }
            column(JobDesc;JobDesc)
            {
            }
            column(Department;Department)
            {
            }
            column(Division;Division)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompAddress2;CompanyInformation."Address 2")
            {
            }
            column(CompCity;CompanyInformation.City)
            {
            }
            column(PhoneNo;CompanyInformation."Phone No.")
            {
            }
            column(PostCode;CompanyInformation."Post Code")
            {
            }
            column(PayMethod;PayMethod)
            {
            }
            column(EmpBankNo;EmpBankNo)
            {
            }
            column(EmpBankAccNo;EmpBankAccNo)
            {
            }
            column(EmpBankAccName;EmpBankAccName)
            {
            }
            column(ShowDimen;ShowDimen)
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(To_Date;"To Date")
            {
            }
            column(WorkingDays;WorkingDays)
            {
            }
            column(AL;AnnL)
            {
            }
            column(SL;SickL)
            {
            }
            column(UL;UnL)
            {
            }
            column(BankNo;BankNo)
            {
            }
            column(EmpNSSFNo;EmpNSSFNo)
            {
            }
            column(EmpFinanceNo;EmpFinanceNo)
            {
            }
            dataitem("Pay Detail Line";"Pay Detail Line")
            {
                DataItemLink = "Employee No."=FIELD("Employee No.");
                DataItemLinkReference = "Pay Detail Header";
                column(EmployeeNo_PayDetailLine;"Pay Detail Line"."Employee No.")
                {
                }
                column(CalculatedAmount_PayDetailLine;"Pay Detail Line"."Calculated Amount")
                {
                }
                column(DescriptioninPaySlip_PayDetailLine;PayElement."Description in PaySlip")
                {
                }
                column(Type_PayDetailLine;"Pay Detail Line".Type)
                {
                }
                column(payslipDesc;payslipDesc)
                {
                }
                column(CalAmount;CalAmount)
                {
                }
                column(Type;Type)
                {
                }
                column(Curr;Curr)
                {
                }
                column(TotalDed;TotalDed)
                {
                }
                column(TotalAdd;TotalAdd)
                {
                }
                column(NetPayRounded;NetPayRounded)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    // 28.1.2017 : A2+
                    PayParam.RESET;
                    CLEAR(PayParam);
                    PayParam.GET;
                    IF PayParam."Show Pay Element with Amount 0" = FALSE THEN
                      BEGIN
                        IF "Pay Detail Line"."Calculated Amount" = 0 THEN
                          CurrReport.SKIP
                      END;
                    // 28.1.2017 : A2-
                    
                    CLEAR(PayElement);
                    
                    if ("Payroll Date" < FromDate) or ("Payroll Date" > "To Date") then
                    CurrReport.SKIP;
                    
                    PayElement.SETRANGE(Code,"Pay Detail Line"."Pay Element Code");
                    if PayElement.FINDFIRST then
                    if not PayElement."Show in PaySlip" then
                      CurrReport.SKIP;
                    payslipDesc := PayElement."Description in PaySlip";
                    if PreEmp <> "Pay Detail Line"."Employee No." then begin
                      TotalAdd := 0;
                      TotalDed := 0;
                      CLEAR(PayDetailLine);
                      PayDetailLine.SETRANGE("Employee No.","Employee No.");
                      PayDetailLine.SETRANGE("Payroll Date",FromDate,"To Date");
                      if PayDetailLine.FINDFIRST then repeat
                        if PayDetailLine.Type = PayDetailLine.Type::Addition then
                          TotalAdd += PayDetailLine."Calculated Amount"
                        else
                          TotalDed += PayDetailLine."Calculated Amount";
                        until PayDetailLine.NEXT = 0;
                        //Added in order to show the results in USD - 04.08.2016 : AIM +
                        if ShowInUSD then
                          begin
                      //Modified to calculate Amount in ACY 8.11.2016 : A2+
                      //TotalAdd := ROUND(TotalAdd / ExchangeRate,AmountRoundingPrecision,'=');
                      //TotalDed := ROUND(TotalDed / ExchangeRate,AmountRoundingPrecision,'=');
                          TotalAdd := ExchEquivAmountInACY(TotalAdd);
                          TotalDed := ExchEquivAmountInACY(TotalDed);
                    
                      //Modified to calculate Amount in ACY 8.11.2016 : A2-
                          end;
                         //Added in order to show the results in USD - 04.08.2016 : AIM -
                    
                        end;
                    /*IF "Pay Detail Line".Type = "Pay Detail Line".Type::Addition THEN
                      TotalAdd += "Pay Detail Line"."Calculated Amount"
                    ELSE
                      TotalDed += "Pay Detail Line"."Calculated Amount";*/
                    SETRANGE("Pay Detail Line"."Payroll Date",FromDate,"To Date");
                    GLSetup.GET;
                    //Modified in order to show the proper Currency 08.11.2016 : A2+
                    //Curr := GLSetup."LCY Code";
                    IF ShowInUSD THEN
                       Curr := PayrollFunction.GetCurrencyCode(CurrencyType::ACY)
                    ELSE
                       Curr := PayrollFunction.GetCurrencyCode(CurrencyType::LCY);
                    //Modified in order to show the proper Currency 08.11.2016 : A2
                    
                    //payslipDesc := "Pay Detail Line"."Description in PaySlip";
                    Type := "Pay Detail Line".Type;
                    CalAmount := "Pay Detail Line"."Calculated Amount";
                    
                    //Added in order to show the results in USD - 04.08.2016 : AIM +
                    if ShowInUSD then
                       //Modified to calculate Amount in ACY 8.11.2016 : A2+
                       //CalAmount := ROUND((CalAmount / ExchangeRate),AmountRoundingPrecision,'=');
                          CalAmount := ExchEquivAmountInACY(CalAmount);
                       //Modified to calculate Amount in ACY 8.11.2016 : A2-
                    
                    //Added in order to show the results in USD - 04.08.2016 : AIM -
                    
                    PreEmp := "Pay Detail Line"."Employee No.";
                    
                    //Added in order to get the Rounded value of Net Pay - 30.05.2016 : AIM +
                    PayrollLedgerEntry.SETRANGE("Employee No." , "Pay Detail Line"."Employee No.");
                    PayrollLedgerEntry.SETRANGE(Period  ,"Pay Detail Line".Period);
                    PayrollLedgerEntry.SETRANGE("Tax Year"  ,"Pay Detail Line"."Tax Year");
                    if PayrollLedgerEntry.FINDFIRST then
                      NetPayRounded :=     PayrollLedgerEntry."Net Pay";
                      //Added in order to show the results in USD - 04.08.2016 : AIM +
                      if ShowInUSD then
                        //Modified to calculate Amount in ACY 8.11.2016 : A2+
                        //NetPayRounded := ROUND(NetPayRounded / ExchangeRate,AmountRoundingPrecision,'=');
                            NetPayRounded := ExchEquivAmountInACY(NetPayRounded);
                        //Modified to calculate Amount in ACY 8.11.2016 : A2+
                    
                      //Added in order to show the results in USD - 04.08.2016 : AIM -
                    
                    //Added in order to get the Rounded value of Net Pay - 30.05.2016 : AIM -

                end;

                trigger OnPreDataItem();
                begin
                    //EDM:MChami (send Payslip by email to the employees)+
                    IF (NOT IsSendMailChecked) AND (EmployeeNoFilter <> '') THEN
                      BEGIN
                        "Pay Detail Line".COPYFILTERS(PayDetailLineFilter);
                        "Pay Detail Line".SETFILTER("Pay Detail Line"."Employee No.",EmployeeNoFilter);
                      END;
                    //EDM:MChami (send Payslip by email to the employees)-
                end;
            }
            dataitem("Employee Loan";"Employee Loan")
            {
                DataItemLink = "Employee No."=FIELD("Employee No.");
                column(AssociatedPayElement_EmployeeLoan;"Employee Loan"."Associated Pay Element")
                {
                }
                column(Amount_EmployeeLoan;AmountLoan)
                {
                }
                column(PayElementDescription;PayElementDescription)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    //Employee Loans: MCHAMI+
                    AmountLoan := 0;
                    PayElementDescription := '';

                    PayElementRec.RESET;
                    PayElementRec.SETRANGE(Code,"Employee Loan"."Associated Pay Element");
                    IF PayElementRec.FINDFIRST THEN
                      PayElementDescription := PayElementRec.Description;

                    EmployeeLoanRec.RESET;
                    EmployeeLoanRec.SETRANGE("Employee No.","Employee Loan"."Employee No.");
                    EmployeeLoanRec.SETRANGE("Associated Pay Element","Employee Loan"."Associated Pay Element");
                    IF EmployeeLoanRec.FINDFIRST THEN
                      REPEAT
                        EmpLoanLine.RESET;
                        EmpLoanLine.SETRANGE("Loan No.",EmployeeLoanRec."Loan No.");
                        // 16.03.2018 : A2+
                        //EmpLoanLine.SETFILTER("Payment Date",'%1..',FromDate);
                        EmpLoanLine.SETFILTER("Payment Date",'%1..',CALCDATE('<+1D>',"To Date"));
                        // 16.03.2018 : A2-
                        IF EmpLoanLine.FINDFIRST THEN
                          REPEAT
                            AmountLoan += EmpLoanLine."Payment Amount";
                          UNTIL EmpLoanLine.NEXT = 0;
                      UNTIL EmployeeLoanRec.NEXT = 0;

                    IF ShowInUSD THEN
                      AmountLoan := ExchEquivAmountInACY(AmountLoan);
                    //Employee Loans: MCHAMI-
                end;

                trigger OnPreDataItem();
                begin

                    //EDM:MChami (send Payslip by email to the employees)+
                    IF (NOT IsSendMailChecked) AND (EmployeeNoFilter <> '') THEN
                      BEGIN
                        "Employee Loan".COPYFILTERS(EmployeeLoanFilter);
                        "Employee Loan".SETFILTER("Employee Loan"."Employee No.",EmployeeNoFilter);
                      END;
                    //EDM:MChami (send Payslip by email to the employees)-
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if "Pay Detail Header"."Employee No." = '' then
                  CurrReport.SKIP;

                //Added in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM +
                IF ("Pay Detail Header"."Employee No." = '') OR ( PayrollFunction.CanUserAccessEmployeeSalary('',"Pay Detail Header"."Employee No.") = FALSE) THEN
                  CurrReport.SKIP;
                //Added in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM -


                //Added in order to show the results in USD - 04.08.2016 : AIM -
                if ExchangeRate <= 0 then
                  ExchangeRate := 1500;
                //Added in order to show the results in USD - 04.08.2016 : AIM -

                CompanyInformation.GET;
                CLEAR(CountryRegion);
                CountryRegion.SETRANGE(Code,CompanyInformation."Country/Region Code");
                if CountryRegion.FINDFIRST then
                  Country := CountryRegion.Name;
                CLEAR(Employee);

                //Added in order to specify Date Range - 28.07.2016 : AIM +
                Employee.SETFILTER("Date Filter",'%1..%2',FromDate,"To Date");
                //Added in order to specify Date Range - 28.07.2016 : AIM -

                Employee.SETRANGE("No.","Pay Detail Header"."Employee No.");
                if Employee.FINDFIRST then begin
                Employee.CALCFIELDS("No. of Working Days",AL,SL,UL);
                  WorkingDays := Employee."No. of Working Days";
                  AnnL := Employee.AL;
                  SickL := Employee.SL;
                  UnL := Employee.UL;
                EmpBankNo := Employee."Bank No.";
                EmpBankAccNo := Employee."Emp. Bank Acc No.";
                EmpBankAccName := Employee."Emp. Bank Acc Name";

                //Added on 28.07.2016 : AIM +
                EmpFinanceNo := Employee."Personal Finance No.";
                EmpNSSFNo := Employee."Social Security No.";
                //Added on 28.07.2016 : AIM -

                CLEAR(BankAccount);
                BankAccount.SETRANGE("No.",Employee."Bank No.");
                if BankAccount.FINDFIRST then begin
                  BankName := BankAccount.Name;
                  BankNo := BankAccount."Bank Account No.";
                  end;
                EmpName := Employee."Full Name";
                CLEAR(HRInfo);
                HRInfo.SETRANGE(Code,Employee."Job Title");
                HRInfo.SETRANGE("Table Name",HRInfo."Table Name"::"Job Title");
                if HRInfo.FINDFIRST then
                  JobDesc := HRInfo.Description;
                Department := Employee."Global Dimension 1 Code";
                Division := Employee."Global Dimension 2 Code";
                PayMethod := FORMAT(Employee."Payment Method"::Bank);
                end;

                //EDM:MChami (send Payslip by email to the employees)+
                IF IsSendMailChecked THEN
                  BEGIN
                    PayDetailLineFilter.RESET;
                    PayDetailLineFilter.COPYFILTERS("Pay Detail Line");
                    PayDetailLineFilter.SETRANGE("Employee No.","Pay Detail Header"."Employee No.");

                    EmployeeLoanFilter.RESET;
                    EmployeeLoanFilter.COPYFILTERS("Employee Loan");
                    EmployeeLoanFilter.SETRANGE("Employee No.","Pay Detail Header"."Employee No.");

                  //Stopped by EDM.MM   SendMail.SendDynamicPaySlipToEmployees("Pay Detail Header",PayDetailLineFilter,EmployeeLoanFilter,FromDate,"To Date");
                  END;
                //EDM:MChami (send Payslip by email to the employees)-
            end;

            trigger OnPreDataItem();
            begin

                //EDM:MChami (send Payslip by email to the employees)+
                IF (NOT IsSendMailChecked) AND (EmployeeNoFilter <> '') THEN
                  BEGIN
                    "Pay Detail Header".COPYFILTERS(PayDetailHeaderFilter);
                    "Pay Detail Header".SETRANGE("Employee No.",EmployeeNoFilter);
                  END;
                //EDM:MChami (send Payslip by email to the employees)-
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FromDate;FromDate)
                {
                    Caption = 'From Date';
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        "To Date":=CALCDATE('+1M-1D',FromDate);
                    end;
                }
                field("To Date";"To Date")
                {
                    Caption = 'To Date';
                    ApplicationArea=All;
                }
                field(ShowDimen;ShowDimen)
                {
                    Caption = 'Show Dimensions';
                    ApplicationArea=All;
                }
                field("US - Dollar";ShowInUSD)
                {
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
            // Modified to disable Change ExchangeRate,8.11.2016 : A2+
              IF PayParam.FINDFIRST THEN
              ExchangeRate := PayParam."ACY Currency Rate";
            // Modified to disable Change ExchangeRate,8.11.2016 : A2+
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
        IF  PayrollFunction.HideSalaryFields() = TRUE THEN
          IF PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' THEN
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
        if FromDate = 0D then
          ERROR(txterror);
    end;

    var
        CompanyInformation : Record "Company Information";
        Country : Text;
        CountryRegion : Record "Country/Region";
        EmpName : Text;
        BankName : Text;
        BankAccount : Record "Bank Account";
        JobDesc : Text;
        HRInfo : Record "HR Information";
        Employee : Record Employee;
        Department : Text;
        Division : Text;
        PayMethod : Text;
        EmpBankNo : Text;
        EmpBankAccNo : Text;
        EmpBankAccName : Text;
        payslipDesc : Text;
        CalAmount : Decimal;
        Type : Text;
        Curr : Text;
        FromDate : Date;
        "To Date" : Date;
        GLSetup : Record "General Ledger Setup";
        txterror : Label '"You have to enter Payroll Date "';
        TotalDed : Decimal;
        TotalAdd : Decimal;
        PreEmp : Text;
        PayDetailLine : Record "Pay Detail Line";
        ShowDimen : Boolean;
        BankNo : Text;
        WorkingDays : Decimal;
        AnnL : Decimal;
        SickL : Decimal;
        UnL : Decimal;
        PayElement : Record "Pay Element";
        NetPayRounded : Decimal;
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        EmpNSSFNo : Text[30];
        EmpFinanceNo : Code[20];
        ExchangeRate : Decimal;
        ShowInUSD : Boolean;
        AmountRoundingPrecision : Decimal;
        Currency : Record Currency;
        CurrencyFactor : Decimal;
        CurrExchRate : Record "Currency Exchange Rate";
        PayrollFunction : Codeunit "Payroll Functions";
        PayParam : Record "Payroll Parameter";
        CurrencyType : Option LCY,ACY;
        IsSendMailChecked : Boolean;
        EmployeeNoFilter : Code[20];
        PayElementDescription : Text;
        PayElementRec : Record "Pay Element";
        AmountLoan : Decimal;
        EmployeeLoanRec : Record "Employee Loan";
        EmpLoanLine : Record "Employee Loan Line";
        PayDetailHeaderFilter : Record "Pay Detail Header";
        PayDetailLineFilter : Record "Pay Detail Line";
        EmployeeLoanFilter : Record "Employee Loan";

    local procedure ExchEquivAmountInACY(L_AmoountInLCY : Decimal) L_AmouontInACY : Decimal;
    begin
        //Modified because the rate is set in parameter card - 08.11.2016 : A2+
        //L_AmouontInACY := L_AmoountInLCY/PayParam."ACY Currency Rate";
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        EXIT(L_AmouontInACY);
        //Modified because the rate is set in parameter card - 08.11.2016 : A2-
    end;

    procedure SetParameters(FromDateParam : Date;ToDateParam : Date;EmployeeNoFilterParam : Code[20];PayDetailHeaderFilterParam : Record "Pay Detail Header";PayDetailLineFilterParam : Record "Pay Detail Line";EmployeeLoanFilterParam : Record "Employee Loan");
    begin

        IsSendMailChecked := FALSE;
        FromDate := FromDateParam;
        "To Date" := ToDateParam;
        EmployeeNoFilter := EmployeeNoFilterParam;
        PayDetailHeaderFilter := PayDetailHeaderFilterParam;
        PayDetailLineFilter := PayDetailLineFilterParam;
        EmployeeLoanFilter := EmployeeLoanFilterParam;
    end;

    procedure SetSendMail(IsSendMailCheckedParam : Boolean);
    begin

        IsSendMailChecked := IsSendMailCheckedParam;
    end;

    procedure SetWebParameters(EmployeeNoFilterParam : Code[20];FromDateParam : Date;ToDateParam : Date);
    begin

        IsSendMailChecked := FALSE;
        EmployeeNoFilter := EmployeeNoFilterParam;
        FromDate := FromDateParam;
        "To Date" := ToDateParam;
    end;
}

