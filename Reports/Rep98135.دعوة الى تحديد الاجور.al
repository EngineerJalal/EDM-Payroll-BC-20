report 98135 "دعوة الى تحديد الاجور"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/دعوة الى تحديد الاجور.rdl';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(EmployeeNo; Employee."No.")
            {
            }
            column(EmployeeName; Employee."Arabic Name")
            {
            }
            column(NSSFNo; EmpNSSF)
            { }
            column(NSSFDate; "NSSF Date")
            { }
            column(BasicPay; "Basic Pay")
            { }
            column(CompanyName; CompanyInfo."Arabic Name")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyOwner; CompanyInfo."Company Owner")
            {
            }
            column(CompanyAddress; CompanyInfo."Arabic City" + '  ' + CompanyInfo."Arabic Street" + '  ' + CompanyInfo."Arabic Building" + '  ' + CompanyInfo."Arabic Floor")
            {
            }
            column(CompanyNSSF1; CompanyNSSF1)
            {
            }
            column(CompanyNSSF2; CompanyNSSF2)
            {
            }
            column(CompanyNSSF3; CompanyNSSF3)
            {
            }
            column(CompanyOwnerDescription; CompanyInfo."Job Description")
            {
            }
            column(SalaryArabicAmount; SalaryArabicAmount[1])
            { }
            column(NSSFArabicAmount; NSSFArabicAmount[1])
            { }
            column(TotalSalary; TotalSalary)
            { }
            column(NSSFAmount; NSSFAmount)
            { }
            column(BirthYear; BirthYear)
            { }
            column(ReportDate; ReportDate)
            { }
            column(ToDate; ToDate)
            { }
            trigger OnAfterGetRecord()
            begin
                CompanyNSSF1 := COPYSTR(CompanyInfo."Registration No.", 1, 2);
                CompanyNSSF2 := COPYSTR(CompanyInfo."Registration No.", 4, 2);
                CompanyNSSF3 := COPYSTR(CompanyInfo."Registration No.", 7, 20);

                BirthYear := COPYSTR("Social Security No.", 1, 2);
                EmpNSSF := COPYSTR("Social Security No.", 4, 20);
                //
                PayrollLedgerEntry.SETRANGE("Employee No.", "No.");
                PayrollLedgerEntry.SETFILTER("Payroll Date", '%1..%2', "NSSF Date", ToDate);
                IF PayrollLedgerEntry.FINDFIRST then
                    repeat
                        TotalSalary := TotalSalary + PayrollLedgerEntry."Total Salary for NSSF";
                    until PayrollLedgerEntry.Next() = 0;

                NSSFAmount := Round((TotalSalary * 8.5) / 100, 0.01);

                EDMUtility.FormatNoText(SalaryArabicAmount, TotalSalary, 'LBP');

                EDMUtility.FormatNoText(NSSFArabicAmount, NSSFAmount, 'LBP');

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Date)
                {
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                    }
                    field(ReportDate; ReportDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnPreReport();
    begin
        CompanyInfo.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyNSSF1: Text[20];
        CompanyNSSF2: Text[20];
        CompanyNSSF3: Text[20];
        EmployeeYearofBirth: integer;
        ReportDate: date;
        ToDate: date;
        EDMUtility: Codeunit "EDM Utility";
        NSSFArabicAmount: array[2] of Text[250];
        SalaryArabicAmount: array[2] of Text[250];
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        TotalSalary: Decimal;
        NSSFAmount: Decimal;
        BirthYear: Text[20];
        EmpNSSF: Text[20];
}