report 98042 "Employee Personel Data"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employee Personel Data.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(NSSFNo_Employee;Employee."Social Security No.")
            {
            }
            column(EmploymentDate_Employee;Employee."Employment Date")
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(BloodType_Employee;Employee."Blood Type")
            {
            }
            column(EMail_Employee;Employee."E-Mail")
            {
            }
            column(NoofChildren_Employee;Employee."No of Children")
            {
            }
            column(Address_Employee;Employee.Address)
            {
            }
            column(Address2_Employee;Employee."Address 2")
            {
            }
            column(SocialStatus_Employee;Employee."Social Status")
            {
            }
            column(BirthDate_Employee;Employee."Birth Date")
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(FirstName_Employee;Employee."First Name")
            {
            }
            column(MiddleName_Employee;Employee."Middle Name")
            {
            }
            column(LastName_Employee;Employee."Last Name")
            {
            }
            column(County_Employee;Employee.County)
            {
            }
            column(InsuranceContribution_Employee;Employee."Insurance Contribution")
            {
            }
            column(Grade_Employee;Employee.Grade)
            {
            }
            column(EngineerSyndicateALFees_Employee;Employee."Engineer Syndicate AL Fees")
            {
            }
            column(ReportHeader;ReportHeader)
            {
            }
            column(GlobalDimension1Code_Employee;Employee."Global Dimension 1 Code")
            {
            }
            column(MobilePhoneNo_Employee;Employee."Mobile Phone No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Employee.Status= Employee.Status::Inactive then
                begin
                    CurrReport.SKIP;
                end;
                if Employee.Status= Employee.Status::Terminated then
                  begin
                    CurrReport.SKIP;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInfo : Record "Company Information";
        UserSetup : Record "User Setup";
        EmployeeLoan : Record "Employee Loan";
        EmployeeDimension : Record "Employee Dimensions";
        PayLedgerEntry : Record "Payroll Ledger Entry";
        Department : Code[20];
        ReportHeader : Label 'Employee Informations';
}

