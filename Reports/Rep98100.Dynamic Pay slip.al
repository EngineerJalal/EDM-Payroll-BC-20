report 98100 "Dynamic Payslip"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Dynamic Payslip.rdl';

    dataset
    {
        dataitem("Pay Detail Header"; "Pay Detail Header")
        {
            RequestFilterFields = "Employee No.", "Payroll Group Code";
            column(PayFrequency_PayDetailHeader; "Pay Detail Header"."Pay Frequency")
            {
            }
            column(EmployeeNo_PayDetailHeader; "Pay Detail Header"."Employee No.")
            {
            }
            column(CalculationRequired_PayDetailHeader; "Pay Detail Header"."Calculation Required")
            {
            }
            column(PayslipPrinted_PayDetailHeader; "Pay Detail Header"."Payslip Printed")
            {
            }
            column(IncludeinPayCycle_PayDetailHeader; "Pay Detail Header"."Include in Pay Cycle")
            {
            }
            column(PayrollGroupCode_PayDetailHeader; "Pay Detail Header"."Payroll Group Code")
            {
            }
            column(EmployeeName_PayDetailHeader; "Pay Detail Header"."Employee Name")
            {
            }
            column(USDExchangeRate_PayDetailHeader; "Pay Detail Header"."USD Exchange Rate")
            {
            }
            column(ShortcutDimension1Code_PayDetailHeader; "Pay Detail Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PayDetailHeader; "Pay Detail Header"."Shortcut Dimension 2 Code")
            {
            }
            column(UserID_PayDetailHeader; "Pay Detail Header"."User ID")
            {
            }
            column(WorkingDaysAffected_PayDetailHeader; "Pay Detail Header"."Working Days Affected")
            {
            }
            column(AttendanceDaysAffected_PayDetailHeader; "Pay Detail Header"."Attendance Days Affected")
            {
            }
            column(OvertimeHours_PayDetailHeader; "Pay Detail Header"."Overtime Hours")
            {
            }
            column(OvertimePublicHoliday_PayDetailHeader; "Pay Detail Header"."Overtime Public Holiday")
            {
            }
            column(DateFilter_PayDetailHeader; "Pay Detail Header"."Date Filter")
            {
            }
            column(ConvertedSalary_PayDetailHeader; "Pay Detail Header"."Converted Salary")
            {
            }
            column(Country; Country)
            {
            }
            column(EmpName; EmpName)
            {
            }
            column(BankName; BankName)
            {
            }
            column(JobDesc; JobDesc)
            {
            }
            column(EmploymentDate; EmploymentDate)
            {
            }
            column(GlobalDimension1; GlobalDimension1)
            {
            }
            column(GlobalDimension2; GlobalDimension2)
            {
            }
            column(GlobalDimension1Caption; GlobalDimension1Caption)
            {
            }
            column(GlobalDimension2Caption; GlobalDimension2Caption)
            {
            }
            column(CompName; CompanyInformation.Name)
            {
            }
            column(CompArabicName; CompanyInformation."Arabic Name")
            {
            }
            column(CompPicture; CompanyInformation.Picture)
            {
            }
            column(CompAddress; CompanyInformation.Address)
            {
            }
            column(CompAddress2; CompanyInformation."Address 2")
            {
            }
            column(CompCity; CompanyInformation.City)
            {
            }
            column(PhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(PostCode; CompanyInformation."Post Code")
            {
            }
            column(PayMethod; PayMethod)
            {
            }
            column(EmpBankNo; EmpBankNo)
            {
            }
            column(EmpBankAccNo; EmpBankAccNo)
            {
            }
            column(EmpBankAccName; EmpBankAccName)
            {
            }
            column(ShowDimen; ShowDimen)
            {
            }
            column(ShowDaysDetail; ShowDaysDetail)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(To_Date; "To Date")
            {
            }
            column(WorkingDays; WorkingDays)
            {
            }
            column(AL; AnnL)
            {
            }
            column(SL; SickL)
            {
            }
            column(UL; UnL)
            {
            }
            column(EmpNSSFNo; EmpNSSFNo)
            {
            }
            column(EmpFinanceNo; EmpFinanceNo)
            {
            }
            column(Comment; Comment)
            {
            }
            column(ArabicMonthName; ArabicMonthName)
            {
            }
            column(EnglishMonthName; EnglishMonthName)
            {
            }
            column(YearVar; YearVar)
            {
            }
            column(ReportDate; ReportDate)
            {
            }
            column(ALBalance; ALBalance)
            { }//edm.ai DIV
            dataitem("Pay Detail Line"; "Pay Detail Line")
            {
                DataItemLink = "Employee No." = FIELD("Employee No.");
                DataItemLinkReference = "Pay Detail Header";
                DataItemTableView = SORTING("Employee No.", "Line No.") WHERE("Payment Category" = FILTER(''));
                column(EmployeeNo_PayDetailLine; "Pay Detail Line"."Employee No.")
                {
                }
                column(Period; Period)
                {
                }
                column(CalculatedAmount_PayDetailLine; "Pay Detail Line"."Calculated Amount")
                {
                }
                column(DescriptioninPaySlip_PayDetailLine; PayElement."Description in PaySlip")
                {
                }
                column(Type_PayDetailLine; "Pay Detail Line".Type)
                {
                }
                column(payslipDesc; payslipDesc)
                {
                }
                column(CalAmount; CalAmount)
                {
                }
                column(Type; Type)
                {
                }
                column(Curr; Curr)
                {
                }
                column(TotalDed; TotalDed)
                {
                }
                column(TotalAdd; TotalAdd)
                {
                }
                column(NetPayRounded; NetPayRounded)
                {
                }
                column(NetPayRoundedUSD; NetPayRoundedUSD)
                {
                }
                column(AdditionalCurrency; AdditionalCurrency)
                {
                }
                column(AdditionalCurrencyRate; AdditionalCurrencyRate)
                {
                }
                column(Taxable; Taxable)
                {
                }
                column(OvertimeAmount; OvertimeAmount)
                {
                }

                column(OvertimeHours; OvertimeHours)
                {
                }
                trigger OnAfterGetRecord();
                begin
                    // 28.1.2017 : A2+
                    PayParam.RESET;
                    CLEAR(PayParam);
                    PayParam.GET;
                    if PayParam."Show Pay Element with Amount 0" = false then begin
                        if "Pay Detail Line"."Calculated Amount" = 0 then
                            CurrReport.SKIP
                    end;
                    // 28.1.2017 : A2-

                    CLEAR(PayElement);

                    if ("Payroll Date" < FromDate) or ("Payroll Date" > "To Date") then
                        CurrReport.SKIP;

                    PayElement.SETRANGE(Code, "Pay Detail Line"."Pay Element Code");
                    if PayElement.FINDFIRST then
                        if not PayElement."Show in PaySlip" then
                            CurrReport.SKIP;
                    payslipDesc := PayElement."Description in PaySlip";
                    if PreEmp <> "Pay Detail Line"."Employee No." then begin
                        TotalAdd := 0;
                        TotalDed := 0;
                        CLEAR(PayDetailLine);
                        PayDetailLine.CalcFields("Payment Category");
                        PayDetailLine.SETRANGE("Payment Category", "Payment Category"::" ");
                        PayDetailLine.SETRANGE("Employee No.", "Employee No.");
                        PayDetailLine.SETRANGE("Payroll Date", FromDate, "To Date");
                        if PayDetailLine.FINDFIRST then
                            repeat
                                if PayDetailLine.Type = PayDetailLine.Type::Addition then
                                    TotalAdd += PayDetailLine."Calculated Amount"
                                else
                                    TotalDed += PayDetailLine."Calculated Amount";
                            until PayDetailLine.NEXT = 0;
                        //Added in order to show the results in USD - 04.08.2016 : AIM +
                        if ShowInUSD then begin
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
                    SETRANGE("Pay Detail Line"."Payroll Date", FromDate, "To Date");
                    GLSetup.GET;
                    //Modified in order to show the proper Currency 08.11.2016 : A2+
                    //Curr := GLSetup."LCY Code";
                    if ShowInUSD then
                        Curr := PayrollFunction.GetCurrencyCode(CurrencyType::ACY)
                    else
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
                    PayrollLedgerEntry.SETRANGE("Employee No.", "Pay Detail Line"."Employee No.");
                    PayrollLedgerEntry.SETRANGE(Period, "Pay Detail Line".Period);
                    PayrollLedgerEntry.SETRANGE("Tax Year", "Pay Detail Line"."Tax Year");
                    PayrollLedgerEntry.SETRANGE("Payroll Date", FromDate, "To Date");
                    PayrollLedgerEntry.SETRANGE("Payment Category", "Payment Category"::" ");
                    if PayrollLedgerEntry.FINDFIRST then
                        repeat
                            NetPayRounded += PayrollLedgerEntry."Net Pay";
                            PayMethod := FORMAT(PayrollLedgerEntry."Payment Method");
                        until PayrollLedgerEntry.NEXT = 0;
                    //Added in order to show the results in USD - 04.08.2016 : AIM +
                    if ShowInUSD then
                        //Modified to calculate Amount in ACY 8.11.2016 : A2+
                        //NetPayRounded := ROUND(NetPayRounded / ExchangeRate,AmountRoundingPrecision,'=');
                            NetPayRounded := ExchEquivAmountInACY(NetPayRounded);
                    //Modified to calculate Amount in ACY 8.11.2016 : A2+

                    //Added in order to show the results in USD - 04.08.2016 : AIM -

                    //Added in order to get the Rounded value of Net Pay - 30.05.2016 : AIM -
                    AdditionalCurrency := PayrollFunction.GetCurrencyCode(CurrencyType::ACY);
                    NetPayRoundedUSD := ExchEquivAmountInACY(NetPayRounded);
                    PayParam.Get;
                    AdditionalCurrencyRate := PayParam."ACY Currency Rate";
                end;

                trigger OnPreDataItem();
                begin
                    //EDM:MChami (send Payslip by email to the employees)+
                    if (not IsSendMailChecked) and (EmployeeNoFilter <> '') then begin
                        "Pay Detail Line".COPYFILTERS(PayDetailLineFilter);
                        "Pay Detail Line".SETRANGE("Pay Detail Line"."Employee No.", EmployeeNoFilter);
                    end;
                    //EDM:MChami (send Payslip by email to the employees)-
                end;
            }
            dataitem("Employee Loan"; "Employee Loan")
            {
                DataItemLink = "Employee No." = FIELD("Employee No.");
                DataItemTableView = SORTING("Employee No.", "Loan No.");
                column(AssociatedPayElement_EmployeeLoan; "Employee Loan"."Associated Pay Element")
                {
                }
                column(Amount_EmployeeLoan; AmountLoan)
                {
                }
                column(PayElementDescription; PayElementDescription)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    //Employee Loans: MCHAMI+
                    AmountLoan := 0;
                    AmountLoanPaid := 0;
                    PayElementDescription := '';

                    PayElementRec.RESET;
                    PayElementRec.SETRANGE(Code, "Employee Loan"."Associated Pay Element");
                    if PayElementRec.FINDFIRST then
                        PayElementDescription := PayElementRec.Description;

                    EmployeeLoanRec.RESET;
                    EmployeeLoanRec.SETRANGE("Employee No.", "Employee Loan"."Employee No.");
                    EmployeeLoanRec.SETRANGE("Associated Pay Element", "Employee Loan"."Associated Pay Element");
                    if EmployeeLoanRec.FINDFIRST then
                        repeat
                            EmpLoanLineRec.RESET;
                            EmpLoanLineRec.SETRANGE("Loan No.", EmployeeLoanRec."Loan No.");
                            EmpLoanLineRec.SETFILTER("Payment Date", '%1..%2', FromDate, "To Date");
                            EmpLoanLineRec.SETRANGE(Completed, False);
                            if EmpLoanLineRec.FINDFIRST then
                                repeat
                                    AmountLoanPaid += EmpLoanLineRec."Payment Amount";
                                until EmpLoanLineRec.NEXT = 0;
                            //
                            EmpLoanLine.RESET;
                            EmpLoanLine.SETRANGE("Loan No.", EmployeeLoanRec."Loan No.");
                            EmpLoanLine.SETFILTER("Payment Date", '%1..', FromDate);
                            if EmpLoanLine.FINDFIRST then
                                repeat
                                    AmountLoan += EmpLoanLine."Payment Amount";
                                until EmpLoanLine.NEXT = 0;
                        until EmployeeLoanRec.NEXT = 0;
                    AmountLoan := AmountLoan - AmountLoanPaid;
                    if ShowInUSD then
                        AmountLoan := ExchEquivAmountInACY(AmountLoan);
                    //Employee Loans: MCHAMI-
                end;

                trigger OnPreDataItem();
                begin

                    //EDM:MChami (send Payslip by email to the employees)+
                    if (not IsSendMailChecked) and (EmployeeNoFilter <> '') then begin
                        "Employee Loan".COPYFILTERS(EmployeeLoanFilter);
                        "Employee Loan".SETRANGE("Employee Loan"."Employee No.", EmployeeNoFilter);
                    end;
                    //EDM:MChami (send Payslip by email to the employees)-
                end;
            }

            trigger OnAfterGetRecord();
            begin
                // 20.02.2018 : A2+
                BankName := '';
                GlobalDimension1 := '';
                GlobalDimension2 := '';
                EmpBankAccName := '';
                EmpBankAccNo := '';
                EmpBankNo := '';
                EmpNSSFNo := '';
                EmpFinanceNo := '';
                JobDesc := '';
                EmploymentDate := 0D;
                NetPayRounded := 0;
                NetPayRoundedUSD := 0;

                // 20.02.2018 : A2-
                if "Pay Detail Header"."Employee No." = '' then
                    CurrReport.SKIP;

                //Added in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM +
                if ("Pay Detail Header"."Employee No." = '') or (PayrollFunction.CanUserAccessEmployeeSalary('', "Pay Detail Header"."Employee No.") = false) then
                    CurrReport.SKIP;
                //Added in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM -


                //Added in order to show the results in USD - 04.08.2016 : AIM -
                if ExchangeRate <= 0 then
                    ExchangeRate := 1500;
                //Added in order to show the results in USD - 04.08.2016 : AIM -

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
                CLEAR(CountryRegion);
                CountryRegion.SETRANGE(Code, CompanyInformation."Country/Region Code");
                if CountryRegion.FINDFIRST then
                    Country := CountryRegion.Name;
                CLEAR(Employee);

                //Added in order to specify Date Range - 28.07.2016 : AIM +
                Employee.SETFILTER("Date Filter", '%1..%2', FromDate, "To Date");
                //Added in order to specify Date Range - 28.07.2016 : AIM -

                Employee.SETRANGE("No.", "Pay Detail Header"."Employee No.");
                if Employee.FINDFIRST then begin
                    Employee.CALCFIELDS("No. of Working Days", AL, SL, UL, "Job Title Description");
                    WorkingDays := Employee."No. of Working Days";
                    AnnL := Employee.AL;
                    SickL := Employee.SL;
                    UnL := Employee.UL;
                    JobDesc := Employee."Job Title Description";
                    EmploymentDate := Employee."Employment Date";
                    EmpBankNo := Employee."Bank No.";
                    EmpBankAccNo := Employee."Emp. Bank Acc No.";
                    EmpBankAccName := Employee."Emp. Bank Acc Name";
                    //Added on 28.07.2016 : AIM +
                    EmpFinanceNo := Employee."Personal Finance No.";
                    EmpNSSFNo := Employee."Social Security No.";
                    //Added on 28.07.2016 : AIM -                
                    GlobalDimension1 := Employee."Global Dimension 1 Code";
                    GlobalDimension2 := Employee."Global Dimension 2 Code";
                    EmpName := Employee."Full Name";
                end;
                GLSetup.Get;
                DimensionRec.SETRANGE(Code, GLSetup."Global Dimension 1 Code");
                IF DimensionRec.FINDFIRST then
                    GlobalDimension1Caption := DimensionRec.Name;

                DimensionRec.SETRANGE(Code, GLSetup."Global Dimension 2 Code");
                IF DimensionRec.FINDFIRST then
                    GlobalDimension2Caption := DimensionRec.Name;
                //EDM:MChami (send Payslip by email to the employees)+
                if IsSendMailChecked then begin
                    PayDetailLineFilter.RESET;
                    PayDetailLineFilter.COPYFILTERS("Pay Detail Line");
                    PayDetailLineFilter.SETRANGE("Employee No.", "Pay Detail Header"."Employee No.");

                    EmployeeLoanFilter.RESET;
                    EmployeeLoanFilter.COPYFILTERS("Employee Loan");
                    EmployeeLoanFilter.SETRANGE("Employee No.", "Pay Detail Header"."Employee No.");

                    //Stopped by EDM.MM   SendMail.SendDynamicPaySlipToEmployees("Pay Detail Header",PayDetailLineFilter,EmployeeLoanFilter,FromDate,"To Date");
                end;
                //EDM:MChami (send Payslip by email to the employees)-
                YearVar := DATE2DMY(FromDate, 3);
                ArabicMonthName := PayrollFunctions.GetMonthName(FromDate, MonthLanguage::AR);
                EnglishMonthName := PayrollFunctions.GetMonthName(FromDate, MonthLanguage::EN);

                //edm.ai++ DIV 16/12/2020
                ALBalance := 0;
                Clear(EmployeeAbsenceEntitlment);
                EmployeeAbsenceEntitlment.SetRange("Employee No.", "Employee No.");
                EmployeeAbsenceEntitlment.SetRange("Cause of Absence Code", 'AL');
                EmployeeAbsenceEntitlment.SetFilter("From Date", '<= %1', WorkDate());
                EmployeeAbsenceEntitlment.SetFilter("Till Date", '>= %1', WorkDate());
                IF EmployeeAbsenceEntitlment.FindFirst() then
                    repeat
                        Balance := 0;
                        Balance := (EmployeeAbsenceEntitlment."Transfer from Previous Year" + EmployeeAbsenceEntitlment.Entitlement + EmployeeAbsenceEntitlment."Manual Additions" + EmployeeAbsenceEntitlment."Attendance Additions") - (EmployeeAbsenceEntitlment."Manual Deductions" + EmployeeAbsenceEntitlment."Attendance Deductions");
                        Balance := Balance - EmployeeAbsenceEntitlment.Taken;


                        ALBalance += Balance;
                    until EmployeeAbsenceEntitlment.Next() = 0;

                //edm.ai-- DIV 16/12/2020

            end;

            trigger OnPreDataItem();
            begin

                //EDM:MChami (send Payslip by email to the employees)+
                if (not IsSendMailChecked) and (EmployeeNoFilter <> '') then begin
                    "Pay Detail Header".COPYFILTERS(PayDetailHeaderFilter);
                    "Pay Detail Header".SETRANGE("Employee No.", EmployeeNoFilter);
                end;
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
                field(FromDate; FromDate)
                {
                    Caption = 'From Date';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        "To Date" := CALCDATE('+1M-1D', FromDate);
                    end;
                }
                field("To Date"; "To Date")
                {
                    Caption = 'To Date';
                    ApplicationArea = All;
                }
                field(ShowDimen; ShowDimen)
                {
                    Caption = 'Show Dimensions';
                    ApplicationArea = All;
                }
                field("US - Dollar"; ShowInUSD)
                {
                    ApplicationArea = All;
                }
                field(ShowDaysDetail; ShowDaysDetail)
                {
                    Caption = 'Show Days Details';
                    ApplicationArea = All;
                }
                field(ExchangeRate; ExchangeRate)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            // Modified to disable Change ExchangeRate,8.11.2016 : A2+
            if PayParam.FINDFIRST then
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
        if PayrollFunction.HideSalaryFields() = true then
            if PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' then
                ERROR('No Permission!');
        //Modified in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM -
        //Added in order to show the results in USD - 04.08.2016 : AIM +
        AmountRoundingPrecision := 2;
        Currency.SETRANGE(Code, 'USD');
        if Currency.FINDFIRST then begin
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
            CurrencyFactor := CurrExchRate.ExchangeRate(TODAY, 'USD');
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
        //
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        //
        ReportDate := WorkDate;
    end;

    var
        CompanyInformation: Record "Company Information";
        Country: Text;
        CountryRegion: Record "Country/Region";
        EmpName: Text;
        BankName: Text;
        JobDesc: Text[150];
        EmploymentDate: Date;
        Employee: Record Employee;
        PayMethod: Text;
        EmpBankNo: Text;
        EmpBankAccNo: Text;
        EmpBankAccName: Text;
        payslipDesc: Text;
        CalAmount: Decimal;
        Curr: Text;
        ShowDaysDetail: Boolean;
        FromDate: Date;
        "To Date": Date;
        GLSetup: Record "General Ledger Setup";
        txterror: Label '"You have to enter Payroll Date "';
        TotalDed: Decimal;
        TotalAdd: Decimal;
        PreEmp: Text;
        PayDetailLine: Record "Pay Detail Line";
        ShowDimen: Boolean;
        WorkingDays: Decimal;
        AnnL: Decimal;
        SickL: Decimal;
        UnL: Decimal;
        PayElement: Record "Pay Element";
        NetPayRounded: Decimal;
        NetPayRoundedUSD: Decimal;
        AdditionalCurrency: Code[20];
        AdditionalCurrencyRate: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        EmpNSSFNo: Text[30];
        EmpFinanceNo: Code[20];
        ExchangeRate: Decimal;
        ShowInUSD: Boolean;
        AmountRoundingPrecision: Decimal;
        Currency: Record Currency;
        CurrencyFactor: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        PayrollFunction: Codeunit "Payroll Functions";
        PayParam: Record "Payroll Parameter";
        CurrencyType: Option LCY,ACY;
        IsSendMailChecked: Boolean;
        EmployeeNoFilter: Code[20];
        PayElementDescription: Text;
        PayElementRec: Record "Pay Element";
        AmountLoan: Decimal;
        AmountLoanPaid: Decimal;
        EmployeeLoanRec: Record "Employee Loan";
        EmpLoanLine: Record "Employee Loan Line";
        EmpLoanLineRec: Record "Employee Loan Line";
        PayDetailHeaderFilter: Record "Pay Detail Header";
        PayDetailLineFilter: Record "Pay Detail Line";
        EmployeeLoanFilter: Record "Employee Loan";
        Comment: Text[80];
        HumanResourceCommentLine: Record "Human Resource Comment Line";
        HRSetup: Record "Human Resources Setup";
        DimensionRec: Record "Dimension";
        GlobalDimension1: Text[50];
        GlobalDimension2: Text[50];
        GlobalDimension1Caption: Text[50];
        GlobalDimension2Caption: Text[50];
        YearVar: Integer;
        ArabicMonthName: Text[100];
        PayrollFunctions: Codeunit "Payroll Functions";
        MonthLanguage: Option EN,AR;
        ReportDate: Date;
        EnglishMonthName: Text[50];
        OvertimeAmount: Decimal;
        OvertimeHours: Decimal;
        ALBalance: Decimal;//edm.ai for div
        EmployeeAbsenceEntitlment: Record "Employee Absence Entitlement";//edm.ai for div
        Balance: Decimal;

    local procedure ExchEquivAmountInACY(L_AmoountInLCY: Decimal) L_AmouontInACY: Decimal;
    begin
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
    end;

    procedure SetSendMail(IsSendMailCheckedParam: Boolean);
    begin

        IsSendMailChecked := IsSendMailCheckedParam;
    end;
}

