report 98046 "Employee Salary History"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employee Salary History.rdlc';

    dataset
    {
        dataitem("Employee Salary History";"Employee Salary History")
        {
            column(EmployeeNo_EmployeeSalaryHistory;"Employee Salary History"."Employee No.")
            {
            }
            column(ModifiedDate_EmployeeSalaryHistory;"Employee Salary History"."Modified Date")
            {
            }
            column(ModifiedTime_EmployeeSalaryHistory;"Employee Salary History"."Modified Time")
            {
            }
            column(SourceType_EmployeeSalaryHistory;"Employee Salary History"."Source Type")
            {
            }
            column(BasicPay_EmployeeSalaryHistory;"Employee Salary History"."Basic Pay")
            {
            }
            column(PhoneAllowance_EmployeeSalaryHistory;"Employee Salary History"."Phone Allowance")
            {
            }
            column(CarAllowance_EmployeeSalaryHistory;"Employee Salary History"."Car Allowance")
            {
            }
            column(HouseAllowance_EmployeeSalaryHistory;"Employee Salary History"."House Allowance")
            {
            }
            column(FoodAllowance_EmployeeSalaryHistory;"Employee Salary History"."Food Allowance")
            {
            }
            column(TicketAllowance_EmployeeSalaryHistory;"Employee Salary History"."Ticket Allowance")
            {
            }
            column(OtherAllowance_EmployeeSalaryHistory;"Employee Salary History"."Other Allowance")
            {
            }
            column(TotalPayAllow_EmployeeSalaryHistory;"Employee Salary History"."TotalPay&Allow")
            {
            }
            column(Location_EmployeeSalaryHistory;"Employee Salary History".Location)
            {
            }
            column(BasicPrevious_EmployeeSalaryHistory;"Employee Salary History"."Basic Previous")
            {
            }
            column(PhonePrevious_EmployeeSalaryHistory;"Employee Salary History"."Phone Previous")
            {
            }
            column(CarPrevious_EmployeeSalaryHistory;"Employee Salary History"."Car Previous")
            {
            }
            column(HousePrevious_EmployeeSalaryHistory;"Employee Salary History"."House Previous")
            {
            }
            column(FoodPrevious_EmployeeSalaryHistory;"Employee Salary History"."Food Previous")
            {
            }
            column(TicketPrevious_EmployeeSalaryHistory;"Employee Salary History"."Ticket Previous")
            {
            }
            column(OtherPrevious_EmployeeSalaryHistory;"Employee Salary History"."Other Previous")
            {
            }
            column(ModifiedBy_EmployeeSalaryHistory;"Employee Salary History"."Modified By")
            {
            }
            column(ChangeStatus_EmployeeSalaryHistory;"Employee Salary History"."Change Status")
            {
            }
            column(EmployeeName_EmployeeSalaryHistory;"Employee Salary History"."Employee Name")
            {
            }
            column(AllowanceCaption1;AllowanceCaption[1])
            {
            }
            column(AllowanceCaption2;AllowanceCaption[2])
            {
            }
            column(AllowanceCaption3;AllowanceCaption[3])
            {
            }
            column(AllowanceCaption4;AllowanceCaption[4])
            {
            }
            column(AllowanceCaption5;AllowanceCaption[5])
            {
            }
            column(AllowanceCaption6;AllowanceCaption[6])
            {
            }
            column(AllowanceCaption7;AllowanceCaption[7])
            {
            }

            trigger OnPreDataItem();
            var
                Employee : Record Employee;
            begin

                AllowanceCaption[1] := Employee.FIELDCAPTION("Phone Allowance");
                AllowanceCaption[2] := Employee.FIELDCAPTION("House Allowance");
                AllowanceCaption[3] := Employee.FIELDCAPTION("Ticket Allowance");
                AllowanceCaption[4] := Employee.FIELDCAPTION("Food Allowance");
                AllowanceCaption[5] := Employee.FIELDCAPTION("Car Allowance");
                AllowanceCaption[6] := Employee.FIELDCAPTION("Other Allowances");
                AllowanceCaption[7] := Employee.FIELDCAPTION("Basic Pay");
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
        Location : Code[10];
        AllowanceCaption : array [7] of Text[100];
}

