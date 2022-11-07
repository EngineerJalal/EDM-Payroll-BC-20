report 98057 "Salary Appraisal History"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary Appraisal History.rdlc';

    dataset
    {
        dataitem("Employee Salary History"; "Employee Salary History")
        {
            column(SalaryStartDate_EmployeeSalaryHistory; "Employee Salary History"."Salary Start Date")
            {
            }
            column(EmployeeNo_EmployeeSalaryHistory; "Employee Salary History"."Employee No.")
            {
            }
            column(ChangeStatus_EmployeeSalaryHistory; "Employee Salary History"."Change Status")
            {
            }
            column(BasicPay_EmployeeSalaryHistory; "Employee Salary History"."Basic Pay")
            {
            }
            column(PhoneAllowance_EmployeeSalaryHistory; "Employee Salary History"."Phone Allowance")
            {
            }
            column(CarAllowance_EmployeeSalaryHistory; "Employee Salary History"."Car Allowance")
            {
            }
            column(Cost_of_Living; "Employee Salary History"."Cost of Living")
            {
            }
            column(HouseAllowance_EmployeeSalaryHistory; "Employee Salary History"."House Allowance")
            {
            }
            column(TotalPayAllow_EmployeeSalaryHistory; "Employee Salary History"."TotalPay&Allow")
            {
            }
            column(BasicPayRel_EmployeeSalaryHistory; "Employee Salary History"."Basic Pay Rel")
            {
            }
            column(PhoneRel_EmployeeSalaryHistory; "Employee Salary History"."Phone Rel")
            {
            }
            column(CarRel_EmployeeSalaryHistory; "Employee Salary History"."Car Rel")
            {
            }
            column(HouseRel_EmployeeSalaryHistory; "Employee Salary History"."House Rel")
            {
            }
            column(TotalRelPayAndAllowance; TotalRelatedPayAndAllowance)
            {
            }
            column(TypeOfSalary; GetSalaryRaiseReqyestStatus())
            {
            }

            trigger OnAfterGetRecord();
            begin
                if "Employee Salary History"."Source Type" <> "Employee Salary History"."Source Type"::"Raise Request" then
                    CurrReport.SKIP;
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
        TotalRelatedPayAndAllowance: Decimal;
}

