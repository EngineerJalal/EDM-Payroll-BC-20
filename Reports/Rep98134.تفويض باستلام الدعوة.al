report 98134 "تفويض باستلام الدعوة"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/تفويض باستلام الدعوة.rdl';
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
            column(CompanyName; CompanyInfo."Arabic Name")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyOwner; CompanyInfo."Company Owner")
            {
            }
            column(CompanyOwnerDescription; CompanyInfo."Job Description")
            {
            }
            column(CompanyAddress; CompanyInfo."Arabic City" + '  ' + CompanyInfo."Arabic Street" + '  ' + CompanyInfo."Arabic Building" + '  ' + CompanyInfo."Arabic Floor")
            {
            }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.")
            {
            }
        }
    }

    trigger OnPreReport();
    begin
        CompanyInfo.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
}
