report 98010 "Salary Taxes"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary Taxes.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("Labor Type"=FILTER(<>Driver));
            RequestFilterFields = "No.","Global Dimension 1 Code";
            column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(ToDate;ToDate)
            {
            }
            column(CompanyPic;CompanyInformation.Picture)
            {
            }
            column(CompanyName;CompanyInfo.Name)
            {
            }
            column(CompanyAddress;CompanyInfo.Address)
            {
            }
            column(CompanyPhone;CompanyInfo."Phone No.")
            {
            }
            column(CompanyFax;CompanyInfo."Fax No.")
            {
            }
            column(CompanyHomePage;CompanyInfo."Home Page")
            {
            }
            column(Payroll_Ledger_Entry__Employee_No__;"No.")
            {
            }
            column(Payroll_Ledger_Entry__Shortcut_Dimension_1_Code_;Employee."Global Dimension 1 Code")
            {
            }
            column(Payroll_Ledger_Entry__Shortcut_Dimension_2_Code_;Employee."Global Dimension 2 Code")
            {
            }
            column(Payroll_Ledger_Entry__Taxable_Pay_;TaxablePay)
            {
            }
            column(Payroll_Ledger_Entry__Tax_Paid_;TaxPaid)
            {
            }
            column(Payroll_Ledger_Entry__Net_Pay_;NetPay)
            {
            }
            column(Payroll_Ledger_Entry__Exempt_Tax_;ExemptTax)
            {
            }
            column(Payroll_Ledger_Entry_Period;PeriodText)
            {
            }
            column(Payroll_Ledger_Entry__Basic_Salary_;BasicSalary)
            {
            }
            column(Payroll_Ledger_Entry__Taxable_Allowances_;TaxableAllowance)
            {
            }
            column(Payroll_Ledger_Entry__Non_Taxable_Deductions_;NonTaxableDeduction)
            {
            }
            column(Payroll_Ledger_Entry__Family_Allowance_;FamilyAllowance)
            {
            }
            column(Payroll_Ledger_Entry__Non_Taxable_Allowances_;NonTaxableAllowance)
            {
            }
            column(Payroll_Ledger_Entry__Taxable_Deductions_;TaxableDeduction)
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(EmpTermination;EmpTermination)
            {
            }
            column(EmpDate;EmpDate)
            {
            }
            column(FinanceNumber;FinanceNumber)
            {
            }
            column(MStatus;MStatus)
            {
            }
            column(NumberOfEligible;NumberOfEligible)
            {
            }
            column(Employee__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(Employee__First_Nationality_Code_;"First Nationality Code")
            {
            }
            column(DepartmentCode;DepartmentCode)
            {
            }
            column(DepartmentName;DepartmentName)
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
            {
            }
            column(Employee__Global_Dimension_1_Code_Caption;FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(Employee__First_Nationality_Code_Caption;FIELDCAPTION("First Nationality Code"))
            {
            }
            column(FreePay;FreePay)
            {
            }

            trigger OnAfterGetRecord();
            begin

                FLAG:=false;
                EmpName:="First Name"+' '+"Middle Name"+' '+"Last Name";
                FinanceNumber:="Personal Finance No.";
                EmpDate:="Employment Date";
                EmpTermination:="Termination Date";
                if Gender = Gender::Female then
                    FLAG := true;

                TaxablePay := 0;
                TaxPaid := 0;
                NetPay := 0;
                ExemptTax := 0;
                PeriodInt := 0;
                BasicSalary := 0;
                TaxableAllowance := 0;
                NonTaxableDeduction := 0;
                NonTaxableAllowance := 0;
                FamilyAllowance := 0;
                TaxableDeduction := 0;
                DepartmentCode := '';
                DepartmentName := '';
                FreePay := 0;

                PayrollLedgerEntry.SETRANGE("Employee No.","No.");
                PayrollLedgerEntry.SETFILTER(PayrollLedgerEntry."Payroll Date",'%1..%2',FromDate,ToDate);
                if not PayrollLedgerEntry.FINDFIRST then
                  CurrReport.SKIP
                else repeat
                    PeriodInt := PeriodInt + 1;
                    if PeriodInt > 12 then
                       PeriodInt := 12;

                    PeriodText := FORMAT(PeriodInt);
                    DepartmentCode := PayrollLedgerEntry."Shortcut Dimension 1 Code";

                    NumberOfEligible := PayrollLedgerEntry."Eligible Children Count";
                    if PayrollLedgerEntry."Social Status" = PayrollLedgerEntry."Social Status"::Married then begin
                        if PayrollLedgerEntry."Spouse Secured" then
                            MStatus := 'M - '
                        else MStatus:='M + ';

                        if FLAG then
                            MStatus:='M';
                    end else if PayrollLedgerEntry."Social Status"=PayrollLedgerEntry."Social Status"::Single then
                        MStatus:='S'
                    else if PayrollLedgerEntry."Social Status"=PayrollLedgerEntry."Social Status"::Widow then
                        MStatus:='W'
                    else if PayrollLedgerEntry."Social Status"=PayrollLedgerEntry."Social Status"::Divorced then
                        MStatus:='D';

                    TaxablePay += PayrollLedgerEntry."Taxable Pay";
                    TaxPaid += PayrollLedgerEntry."Tax Paid";
                    NetPay += PayrollLedgerEntry."Net Pay";
                    BasicSalary += PayrollLedgerEntry."Basic Salary";
                    TaxableAllowance += PayrollLedgerEntry."Taxable Allowances";
                    NonTaxableDeduction += PayrollLedgerEntry."Non-Taxable Deductions";
                    FamilyAllowance += PayrollLedgerEntry."Family Allowance";
                    NonTaxableAllowance += PayrollLedgerEntry."Non-Taxable Allowances";
                    TaxableDeduction += PayrollLedgerEntry."Taxable Deductions";
                until PayrollLedgerEntry.NEXT = 0;
                //
                PayrollLedgerRec.SETRANGE("Employee No.","No.");
                PayrollLedgerRec.SETFILTER(PayrollLedgerRec."Payroll Date",'%1..%2',FromDate,ToDate);
                PayrollLedgerRec.SETRANGE("Payment Category",PayrollLedgerRec."Payment Category"::" ");
                if not PayrollLedgerRec.FINDFIRST then
                  CurrReport.SKIP
                else repeat
                    ExemptTax := ExemptTax + (PayrollLedgerRec."Exempt Tax") / 12;
                    FreePay += PayrollLedgerRec."Free Pay";
                until PayrollLedgerRec.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Date Filter")
                {
                    Caption = 'Date Filter';
                    field(FromDate;FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea=All;

                        trigger OnValidate();
                        begin
                            ToDate := CALCDATE('+1M-1D',FromDate);
                        end;
                    }
                    field(ToDate;ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea=All;

                        trigger OnValidate();
                        begin
                            if ToDate < FromDate then
                              ERROR('To Date Must be Greater than From Date');
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        if  PayrollFunction.HideSalaryFields() then
           ERROR('Permission NOT Allowed!');
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
        CompanyInfo.GET;
    end;

    var
        FromDate : Date;
        ToDate : Date;
        CompanyInformation : Record "Company Information";
        CompanyInfo : Record "Company Information";
        EmpName : Text[100];
        EmpTermination : Date;
        EmpDate : Date;
        FinanceNumber : Code[20];
        NumberOfEligible : Integer;
        MStatus : Text[30];
        FLAG : Boolean;
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        PayrollLedgerRec : Record "Payroll Ledger Entry";
        TaxablePay : Decimal;
        TaxPaid : Decimal;
        NetPay : Decimal;
        ExemptTax : Decimal;
        PeriodInt : Integer;
        PeriodText : Text[30];
        BasicSalary : Decimal;
        TaxableAllowance : Decimal;
        NonTaxableDeduction : Decimal;
        NonTaxableAllowance : Decimal;
        FamilyAllowance : Decimal;
        TaxableDeduction : Decimal;
        DepartmentCode : Code[20];
        DepartmentName : Text[100];
        EmployeeCaptionLbl : Label 'Employee';
        PayrollFunction : Codeunit "Payroll Functions";
        FreePay : Decimal;
}

