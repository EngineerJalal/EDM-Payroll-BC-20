report 98073 "List of New Employee"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/List of New Employee.rdlc';

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
            column(EmploymentDate_Employee;Employee."Employment Date")
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
            column(FromPeriod;FromPeriod)
            {
            }
            column(TillPeriod;TillPeriod)
            {
            }

            trigger OnPreDataItem();
            begin
                Employee.SETFILTER(Employee."Employment Date",'%1..%2',FromPeriod,TillPeriod);
                Employee.SETFILTER(Employee.Status,'=%1',Employee.Status::Active);
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

        trigger OnOpenPage();
        begin
            TillPeriod := WORKDATE;
        end;
    }

    labels
    {
    }

    var
        FromPeriod : Date;
        TillPeriod : Date;
}

