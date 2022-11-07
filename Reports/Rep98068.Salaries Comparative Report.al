report 98068 "Salaries Comparative Report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salaries Comparative Report.rdlc';

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }

            trigger OnAfterGetRecord();
            begin

                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(Department_Employee;Employee.Department)
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(JanNetPay;JanNetPay)
            {
            }
            column(FebNetPay;FebNetPay)
            {
            }
            column(MarNetPay;MarNetPay)
            {
            }
            column(AprNetPay;AprNetPay)
            {
            }
            column(MayNetPay;MayNetPay)
            {
            }
            column(JunNetPay;JunNetPay)
            {
            }
            column(JulNetPay;JulNetPay)
            {
            }
            column(AugNetPay;AugNetPay)
            {
            }
            column(SepNetPay;SepNetPay)
            {
            }
            column(OctNetPay;OctNetPay)
            {
            }
            column(NovNetPay;NovNetPay)
            {
            }
            column(DecNetPay;DecNetPay)
            {
            }
            column(TotalNetPay;TotalNetPay)
            {
            }
            column(Dep;Dep)
            {
            }
            column(JobTitleDescription;JobTitleDescription)
            {
            }

            trigger OnAfterGetRecord();
            begin

                InitNetPay;

                PayrollLedgerEntry.SETRANGE("Employee No.","No.");
                PayrollLedgerEntry.SETRANGE("Tax Year",Year);
                if PayrollLedgerEntry.FINDFIRST then
                  repeat

                    if ACYCurrency then
                      NetPayValue := ROUND(PayrollFunctions.ExchangeLCYAmountToACY(PayrollLedgerEntry."Net Pay"),0.01)
                    else
                      NetPayValue := PayrollLedgerEntry."Net Pay";

                    case PayrollLedgerEntry.Period of
                      1: JanNetPay := NetPayValue;
                      2: FebNetPay := NetPayValue;
                      3: MarNetPay := NetPayValue;
                      4: AprNetPay := NetPayValue;
                      5: MayNetPay := NetPayValue;
                      6: JunNetPay := NetPayValue;
                      7: JulNetPay := NetPayValue;
                      8: AugNetPay := NetPayValue;
                      9: SepNetPay := NetPayValue;
                      10: OctNetPay := NetPayValue;
                      11: NovNetPay := NetPayValue;
                      12: DecNetPay := NetPayValue;
                    end;

                    TotalNetPay += NetPayValue;

                  until PayrollLedgerEntry.NEXT = 0;
                // 26.04.2017 : A2+
                Dep := PayrollFunctions.GetEmpDepartmentDescription(Employee."No.");
                JobTitleDescription := PayrollFunctions.GetJobTitleDescription(Employee."Job Title");
                // 26.04.2017 : A2-
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Select Year";Year)
                    {
                        ApplicationArea=All;
                    }
                    field("Show in ACY";ACYCurrency)
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
        ReportHeader = 'Dynamic Sumary';}

    var
        Year : Integer;
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        ACYCurrency : Boolean;
        JanNetPay : Decimal;
        FebNetPay : Decimal;
        MarNetPay : Decimal;
        AprNetPay : Decimal;
        MayNetPay : Decimal;
        JunNetPay : Decimal;
        JulNetPay : Decimal;
        AugNetPay : Decimal;
        SepNetPay : Decimal;
        OctNetPay : Decimal;
        NovNetPay : Decimal;
        DecNetPay : Decimal;
        TotalNetPay : Decimal;
        CompanyInfo : Record "Company Information";
        PayrollFunctions : Codeunit "Payroll Functions";
        NetPayValue : Decimal;
        Dep : Text[150];
        JobTitleDescription : Text[150];

    local procedure InitNetPay();
    begin

        JanNetPay := 0;
        FebNetPay := 0;
        MarNetPay := 0;
        AprNetPay := 0;
        MayNetPay := 0;
        JunNetPay := 0;
        JulNetPay := 0;
        AugNetPay := 0;
        SepNetPay := 0;
        OctNetPay := 0;
        NovNetPay := 0;
        DecNetPay := 0;

        TotalNetPay := 0;
    end;
}

