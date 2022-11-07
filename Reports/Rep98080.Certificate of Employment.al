report 98080 "Certificate of Employment"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Certificate of Employment.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(CompInfo_Name;CompInfo.Name)
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(NSSFDate_Employee;Employee."NSSF Date")
            {
            }
            column(BasicPay_Employee;Employee."Basic Pay")
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(SocialSecurityNo_Employee;Employee."Social Security No.")
            {
            }
            column(Transportation;Transportation)
            {
            }
            column(JobTitleName;JobTitleName)
            {
            }

            trigger OnAfterGetRecord();
            begin
                SpecificPayElement.SETRANGE("Internal Pay Element ID",'02');
                SpecificPayElement.SETRANGE("Employee Category Code",Employee."Employee Category Code");
                if SpecificPayElement.FINDFIRST then
                  if SpecificPayElement."Pay Unit" = SpecificPayElement."Pay Unit"::Monthly then
                    Transportation := FORMAT(SpecificPayElement.Amount)
                  else if SpecificPayElement."Pay Unit" = SpecificPayElement."Pay Unit"::Daily then
                    Transportation := FORMAT(SpecificPayElement.Amount) + ' Per Day';

                HRInformation.SETRANGE(Code,Employee."Job Title");
                if HRInformation.FINDFIRST then
                  JobTitleName := HRInformation.Description;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
        CompInfo.GET;
        if  PayrollFunction.HideSalaryFields() = true then
          if PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' then
            ERROR('No Permission!');
    end;

    var
        Transportation : Text;
        SpecificPayElement : Record "Specific Pay Element";
        PayDate : Date;
        JobTitleName : Text[150];
        HRInformation : Record "HR Information";
        CompInfo : Record "Company Information";
        CompanyName : Text;
        PayrollFunction : Codeunit "Payroll Functions";
}

