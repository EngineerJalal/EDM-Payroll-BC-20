report 98066 "Employee Attendance Report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employee Attendance Report.rdlc';

    dataset
    {
        dataitem("Employee Absence";"Employee Absence")
        {
            RequestFilterFields = "From Date","Shift Code";
            column(EmployeeNo_EmployeeAbsence;"Employee Absence"."Employee No.")
            {
            }
            column(CauseofAbsenceCode_EmployeeAbsence;"Employee Absence"."Cause of Absence Code")
            {
            }
            column(ShiftCode_EmployeeAbsence;"Employee Absence"."Shift Code")
            {
            }
            column(FromTime_EmployeeAbsence;"Employee Absence"."From Time")
            {
            }
            column(ToTime_EmployeeAbsence;"Employee Absence"."To Time")
            {
            }
            column(RequiredHrs_EmployeeAbsence;"Employee Absence"."Required Hrs")
            {
            }
            column(AttendHrs_EmployeeAbsence;"Employee Absence"."Attend Hrs.")
            {
            }
            column(LateArrive_EmployeeAbsence;"Employee Absence"."Late Arrive")
            {
            }
            column(EarlyLeave_EmployeeAbsence;"Employee Absence"."Early Leave")
            {
            }
            column(EarlyArrive_EmployeeAbsence;"Employee Absence"."Early Arrive")
            {
            }
            column(LateLeave_EmployeeAbsence;"Employee Absence"."Late Leave")
            {
            }
            column(EmployeeName_EmployeeAbsence;"Employee Absence"."Employee Name")
            {
            }
            column(FromDate_EmployeeAbsence;"Employee Absence"."From Date")
            {
            }
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
}

