report 98074 "List of Employee Terminated"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/List of Employee Terminated.rdlc';

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
            column(TerminationDate_Employee;Employee."Termination Date")
            {
            }
            column(PayrollGroupCode_Employee;Employee."Payroll Group Code")
            {
            }
            column(EmployeeCategoryCode_Employee;Employee."Employee Category Code")
            {
            }
            column(EmploymentTypeCode_Employee;Employee."Employment Type Code")
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(EmploymentDate_Employee;Employee."Employment Date")
            {
            }
            column(FromPeriod;FromPeriod)
            {
            }
            column(TillPeriod;TillPeriod)
            {
            }
            column(JobTitleDescription;JobTitleDescription)
            {
            }

            trigger OnAfterGetRecord();
            begin
                HRInformation.SETRANGE("Table Name",HRInformation."Table Name"::"Job Title");
                HRInformation.SETRANGE(Code,Employee."Job Title");
                if HRInformation.FINDFIRST then
                  JobTitleDescription := HRInformation.Description;
            end;

            trigger OnPreDataItem();
            begin
                Employee.SETFILTER(Employee."Termination Date",'%1..%2',FromPeriod,TillPeriod);
                Employee.SETFILTER(Employee.Status,'=%1',Employee.Status::Terminated);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Period";FromPeriod)
                {
                    ApplicationArea=All;
                }
                field("Till Period";TillPeriod)
                {
                    ApplicationArea=All;
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

    var
        FromPeriod : Date;
        TillPeriod : Date;
        JobTitleDescription : Text[150];
        HRInformation : Record "HR Information";
}

