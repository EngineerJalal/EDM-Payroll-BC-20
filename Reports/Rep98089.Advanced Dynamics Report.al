report 98089 "Advanced Dynamics Report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Advanced Dynamics Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(NSSFDate_Employee;Employee."NSSF Date")
            {
            }
            column(DeclarationDate_Employee;Employee."Declaration Date")
            {
            }
            column(TerminationDate_Employee;Employee."Termination Date")
            {
            }
            column(NoofChildren_Employee;Employee."No of Children")
            {
            }
            column(SocialStatus_Employee;Employee."Social Status")
            {
            }
            column(PersonalFinanceNo_Employee;Employee."Personal Finance No.")
            {
            }
            column(SocialSecurityNo_Employee;Employee."Social Security No.")
            {
            }
            column(Declared_Employee;Employee.Declared)
            {
            }
            column(EmploymentDate_Employee;Employee."Employment Date")
            {
            }
            column(PayrollGroupCode_Employee;Employee."Payroll Group Code")
            {
            }
            column(GlobalDimension1Code_Employee;Employee."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_Employee;Employee."Global Dimension 2 Code")
            {
            }
            column(Month;Month)
            {
            }
            column(BasicACY;BasicACY)
            {
            }
            column(BasicLCY;BasicLCY)
            {
            }
            column(Rebate;Rebate)
            {
            }
            column(MHOOD3;MHOOD3)
            {
            }
            column(MHOOD8;MHOOD8)
            {
            }
            column(FAMSUB6;FAMSUB6)
            {
            }
            column(EOS85;EOS85)
            {
            }
            column(Nationality;Nlty)
            {
            }
            column(PayrollDate;PayDate)
            {
            }
            column(NSSFTotalSalay;NSSFTotalSalay)
            {
            }
            column(TaxableSalary;TaxableSalary)
            {
            }
            column(IncomeTax;IncomeTax)
            {
            }
            column(NetACY;NetACY)
            {
            }
            column(NetLCY;NetLCY)
            {
            }
            column(OrderNo;OrderNo)
            {
            }
            column(ShowEmpAddInfo;ShowEmpAddInfo)
            {
            }
            column(ShowEmpTaxInfo;ShowEmpTaxInfo)
            {
            }
            column(ShowEmpNSSFInfo;ShowEmpNSSFInfo)
            {
            }
            column(JobTitle;JobTitle)
            {
            }
            column(JobCategory;JobCategory)
            {
            }
            column(Dimension1;Dimension1)
            {
            }
            column(Dimension2;Dimension2)
            {
            }
            dataitem("Pay Detail Line";"Pay Detail Line")
            {
                DataItemLink = "Employee No."=FIELD("No.");
                column(EmployerAmount_PayDetailLine;"Pay Detail Line"."Employer Amount")
                {
                }
                column(CalculatedAmount_PayDetailLine;"Pay Detail Line"."Calculated Amount")
                {
                }
                column(Description_PayDetailLine;"Pay Detail Line".Description)
                {
                }
                column(PayElementCode_PayDetailLine;"Pay Detail Line"."Pay Element Code")
                {
                }

                trigger OnAfterGetRecord();
                var
                    PayElement : Record "Pay Element";
                begin
                    PayElement.SETRANGE(Code,"Pay Detail Line"."Pay Element Code");
                    if PayElement.FINDFIRST then
                      OrderNo := PayElement."Order No.";
                end;

                trigger OnPreDataItem();
                begin
                    //"Pay Detail Line".SETFILTER("Pay Detail Line"."Payroll Date",'%1..%2',FDate,TDate);
                    "Pay Detail Line".SETFILTER("Pay Detail Line"."Payroll Date",'%1',PayDate);
                    "Pay Detail Line".SETFILTER("Pay Detail Line"."Pay Element Code",'<>%1&<>%2&<>%3','84','85','86');
                end;
            }

            trigger OnAfterGetRecord();
            begin
                PayParam.GET();
                Month := 0;
                BasicACY := 0;
                BasicLCY := 0;
                Rebate := 0;
                MHOOD3 := 0;
                MHOOD8 := 0;
                FAMSUB6 := 0;
                EOS85 := 0;
                Nlty := '';
                NSSFTotalSalay := 0;
                IncomeTax := 0;
                NetLCY := 0;
                NetACY := 0;
                TaxableSalary := 0;
                NonTaxSalary := 0;
                ExemptTax := 0;
                JobCategory := '';
                JobTitle := '';


                if (Employee."Termination Date" = 0D) and (Employee."Employment Date" <> 0D) then
                  begin
                    if Employee."NSSF Date" <> 0D then
                      Month := (PayDate - Employee."NSSF Date") / 365
                    else
                      Month := (PayDate - Employee."Employment Date") / 365;
                  end
                else
                  begin
                    if (Employee."NSSF Date" <> 0D) and (Employee."Employment Date" <> 0D) then
                      Month := (Employee."Termination Date" - Employee."NSSF Date") / 365
                    else
                      Month := (Employee."Termination Date" - Employee."Employment Date") / 365;
                  end;

                PayLedgEntry.SETRANGE("Employee No.",Employee."No.");
                //PayLedgEntry.SETFILTER("Payroll Date",'%1..%2',FDate,TDate);
                PayLedgEntry.SETFILTER("Payroll Date",'%1',PayDate);
                if PayLedgEntry.FINDFIRST then
                  begin
                    BasicLCY := PayLedgEntry."Basic Salary";
                    Rebate := PayLedgEntry."Free Pay";
                    NSSFTotalSalay := PayLedgEntry."Total Salary for NSSF";
                    IncomeTax := PayLedgEntry."Tax Paid";
                    NetLCY := PayLedgEntry."Net Pay";
                    TaxableSalary := PayLedgEntry."Taxable Pay";
                    ExemptTax := PayLedgEntry."Exempt Tax";

                    if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Division then
                      begin
                        BasicACY := PayLedgEntry."Basic Salary" / PayParam."ACY Currency Rate";
                        NetACY := PayLedgEntry."Net Pay" / PayParam."ACY Currency Rate";
                      end
                    else
                      begin
                        BasicACY := PayLedgEntry."Basic Salary" * PayParam."ACY Currency Rate";
                        NetACY := PayLedgEntry."Net Pay" * PayParam."ACY Currency Rate";
                      end
                  end;

                PayDetailLine.SETRANGE("Employee No.",Employee."No.");
                //PayDetailLine.SETFILTER("Payroll Date",'%1..%2',FDate,TDate);
                PayDetailLine.SETFILTER("Payroll Date",'%1',PayDate);
                if PayDetailLine.FINDFIRST then
                  repeat
                    if PayDetailLine."Pay Element Code" = '85' then
                      EOS85 := PayDetailLine."Employer Amount";

                    if PayDetailLine."Pay Element Code" = '84' then
                      FAMSUB6 := PayDetailLine."Employer Amount";

                    if PayDetailLine."Pay Element Code" = '86' then
                      begin
                        MHOOD3 := PayDetailLine."Calculated Amount";
                        MHOOD8 := PayDetailLine."Employer Amount";
                      end;
                  until PayDetailLine.NEXT = 0;

                CountryReg.SETRANGE(Code,Employee."First Nationality Code");
                if CountryReg.FINDFIRST then
                  Nlty := CountryReg.Name;

                HRInformation.SETRANGE(Code,Employee."Job Title");
                HRInformation.SETRANGE("Table Name",HRInformation."Table Name"::"Job Title");
                if HRInformation.FINDFIRST then
                  JobTitle := HRInformation.Description;

                HRInformation.SETRANGE(Code,Employee."Job Category");
                HRInformation.SETRANGE("Table Name",HRInformation."Table Name"::"Job Category");
                if HRInformation.FINDFIRST then
                  JobCategory := HRInformation.Description;
            end;

            trigger OnPreDataItem();
            begin
                Employee.CALCFIELDS("No of Children");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Report Parameter")
                {
                    field("Payroll Date";PayDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Show Employee Additional Info";ShowEmpAddInfo)
                    {
                        ApplicationArea=All;
                    }
                    field("Show Employee Tax Info";ShowEmpTaxInfo)
                    {
                        ApplicationArea=All;
                    }
                    field("Show Employee NSSF Info";ShowEmpNSSFInfo)
                    {
                        ApplicationArea=All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            ShowEmpAddInfo := true;
            ShowEmpNSSFInfo := true;
            ShowEmpTaxInfo := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        GenLedSetup.GET();
        Dimensions.SETRANGE(Code,GenLedSetup."Global Dimension 1 Code");
        if Dimensions.FINDFIRST then
          Dimension1 := Dimensions.Name;

        Dimensions.SETRANGE(Code,GenLedSetup."Global Dimension 2 Code");
        if Dimensions.FINDFIRST then
          Dimension2 := Dimensions.Name;
    end;

    var
        PayLedgEntry : Record "Payroll Ledger Entry";
        EmpLoan : Record "Employee Loan";
        PayParam : Record "Payroll Parameter";
        CountryReg : Record "Country/Region";
        PayDetailLine : Record "Pay Detail Line";
        PayFunction : Codeunit "Payroll Functions";
        HRInformation : Record "HR Information";
        GenLedSetup : Record "General Ledger Setup";
        Dimensions : Record Dimension;
        BasicACY : Decimal;
        BasicLCY : Decimal;
        Rebate : Decimal;
        NetLCY : Decimal;
        NetACY : Decimal;
        NSSFTotalSalay : Decimal;
        FDate : Date;
        TDate : Date;
        Month : Decimal;
        MHOOD3 : Decimal;
        MHOOD8 : Decimal;
        FAMSUB6 : Decimal;
        EOS85 : Decimal;
        Nlty : Text;
        IncomeTax : Decimal;
        OrderNo : Integer;
        PayDate : Date;
        ShowEmpAddInfo : Boolean;
        ShowEmpTaxInfo : Boolean;
        ShowEmpNSSFInfo : Boolean;
        TaxableSalary : Decimal;
        NonTaxSalary : Decimal;
        ExemptTax : Decimal;
        JobTitle : Text[100];
        JobCategory : Text[100];
        Dimension1 : Text[50];
        Dimension2 : Text[50];
}

