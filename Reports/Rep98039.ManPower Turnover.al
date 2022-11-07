report 98039 "ManPower Turnover"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/ManPower Turnover.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = SORTING("No.","First Name");
            RequestFilterFields = "No.","Employee Category Code","Employment Date";
            column(No_Employee;Employee."No.")
            {
                //IncludeCaption = true;
            }
            column(FirstName_Employee;Employee."First Name")
            {
                //IncludeCaption = true;
            }
            column(LastName_Employee;Employee."Last Name")
            {
                //IncludeCaption = true;
            }
            column(Address_Employee;Employee.Address)
            {
                //IncludeCaption = true;
            }
            column(BirthDate_Employee;Employee."Birth Date")
            {
                //IncludeCaption = true;
            }
            column(Sex_Employee;Employee.Gender)
            {
                //IncludeCaption = true;
            }
            column(EmploymentDate_Employee;Employee."Employment Date")
            {
                //IncludeCaption = true;
            }
            column(Status_Employee;Employee.Status)
            {
                //IncludeCaption = true;
            }
            column(TerminationDate_Employee;Employee."Termination Date")
            {
                //IncludeCaption = true;
            }
            column(EmployeeCategoryCode_Employee;Employee."Employee Category Code")
            {
                //IncludeCaption = true;
            }
            column(View_Report_by;ViewReportBy)
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(Group_by;GroupBy)
            {
            }

            trigger OnAfterGetRecord();
            begin
                GroupBy := '';
                if ViewReportBy = ViewReportBy::"Employee Category Code" then
                   begin
                     HRInformation.SETRANGE(Code,Employee."Employee Category Code");
                     if HRInformation.FINDFIRST then
                        GroupBy := HRInformation.Description
                   end
                else HRInformation.SETRANGE(Code,Employee."Job Title");
                     if HRInformation.FINDFIRST then
                        GroupBy := HRInformation.Description;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Report")
                {
                    field("Group by";ViewReportBy)
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

    var
        ViewReportBy : Option "Job Title","Employee Category Code";
        GroupBy : Text[300];
        HRInformation : Record "HR Information";
}

