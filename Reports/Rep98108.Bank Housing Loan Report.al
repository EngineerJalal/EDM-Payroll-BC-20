report 98108 "Bank Housing Loan Report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Bank Housing Loan Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(CompInfo_Name;CompInfo.Name)
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(NSSFDate_Employee;Employee."NSSF Date")
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(EmploymentDate_Employee;Employee."Employment Date")
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(JobTitleDesc;JobTitleDesc)
            {
            }
            column(BaiscSalary;BaiscSalary)
            {
            }
            column(TranspSalary;TranspSalary)
            {
            }
            column(FamAllow;FamAllow)
            {
            }
            column(MHOODSalary;MHOODSalary)
            {
            }
            column(IncomeTax;IncomeTax)
            {
            }
            column(NetSalary;NetSalary)
            {
            }
            column(ArabicAmount1;ArabicAmount[1])
            {
            }

            trigger OnAfterGetRecord();
            begin
                ResetParameter();
                PayrollParameter.GET();

                IF Employee."Arabic Name" <> '' THEN
                  EmpName := Employee."Arabic Name"
                ELSE
                  EmpName := Employee."Full Name";

                HRInformation.SETRANGE(Code,Employee."Job Title");
                IF HRInformation.FINDFIRST THEN
                  JobTitleDesc := HRInformation.Description;

                PayDetailLine.SETFILTER("Payroll Date",'%1',RefDate);
                PayDetailLine.SETRANGE("Employee No.",Employee."No.");
                IF PayDetailLine.FINDFIRST THEN
                REPEAT
                  CASE PayDetailLine."Pay Element Code" OF
                    PayrollParameter."Basic Pay Code":
                      BaiscSalary := PayDetailLine."Calculated Amount";
                    PayrollParameter."Non-Taxable Transp. Code":
                      TranspSalary := PayDetailLine."Calculated Amount";
                    PayrollParameter."Family Allowance Code":
                      FamAllow := PayDetailLine."Calculated Amount";
                    PayrollParameter."Income Tax Code":
                      IncomeTax := PayDetailLine."Calculated Amount";
                    '86':
                      MHOODSalary := PayDetailLine."Calculated Amount";
                  END;
                UNTIL PayDetailLine.NEXT = 0;

                NetSalary := ROUND((BaiscSalary + TranspSalary + FamAllow) - (IncomeTax + MHOODSalary),1000,'>');
                EDMUtility.FormatNoText(ArabicAmount,NetSalary,'');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Requested Parameter")
                {
                    field("Reference Date";RefDate)
                    {
                        ApplicationArea=All;
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

    trigger OnPreReport();
    begin
        CompInfo.GET();
    end;

    var
        CompInfo : Record "Company Information";
        HRInformation : Record "HR Information";
        EmpName : Text;
        JobTitleDesc : Text;
        RefDate : Date;
        PayDetailLine : Record "Pay Detail Line";
        PayrollParameter : Record "Payroll Parameter";
        BaiscSalary : Decimal;
        TranspSalary : Decimal;
        FamAllow : Decimal;
        MHOODSalary : Decimal;
        IncomeTax : Decimal;
        NetSalary : Decimal;
        EDMUtility : Codeunit "EDM Utility";
        ArabicAmount : array [2] of Text[250];

    local procedure ResetParameter();
    begin
        EmpName := '';
        JobTitleDesc := '';
        BaiscSalary := 0;
        TranspSalary := 0;
        FamAllow := 0;
        MHOODSalary := 0;
        IncomeTax := 0;
        NetSalary := 0;
    end;
}

