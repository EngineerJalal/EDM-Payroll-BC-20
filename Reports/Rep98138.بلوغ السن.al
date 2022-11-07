report 98138 "بلوغ السن"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/بلوغ السن.rdl';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(ReportDate; ReportDate)
            {

            }
            column(CompanyName; CompanyInfo."Arabic Name")
            {
            }
            column(CompanyOwner; CompanyInfo."Company Owner")
            {
            }
            column(CompanyAddress; CompanyInfo."Arabic City" + '  ' + CompanyInfo."Arabic Street" + '  ' + CompanyInfo."Arabic Building" + '  ' + CompanyInfo."Arabic Floor")
            {
            }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.")
            {
            }
            column(EmployeeNo; Employee."No.")
            {
            }
            column(EmployeeName; Employee."Arabic Name")
            {
            }
            column(NSSFNo; "Social Security No.")
            {
            }
            column(DeclarationDate; "Declaration Date")
            {
            }
            column(EndofServiceDate; "End of Service Date")
            {
            }
            column(BasicPay; "Basic Pay")
            { }
            column(ArabicAmount; ArabicAmount[1])
            { }
            trigger OnAfterGetRecord()
            begin
                IF "End of Service Date" > WORKDATE then
                    CurrReport.SKIP;

                EDMUtility.FormatNoText(ArabicAmount, "Basic Pay", 'LBP');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(ReportDate; ReportDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport();
    begin
        CompanyInfo.GET;
    end;

    var
        ReportDate: Date;
        CompanyInfo: Record "Company Information";

        EDMUtility: Codeunit "EDM Utility";
        ArabicAmount: array[2] of Text[250];
}
