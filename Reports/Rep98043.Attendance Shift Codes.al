report 98043 "Attendance Shift Codes"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Shift Codes.rdlc';

    dataset
    {
        dataitem("Employee Absence"; "Employee Absence")
        {
            RequestFilterFields = "Employee No.", "Shift Code";
            column(empAbsNo; "Employee Absence"."Employee No.")
            {
            }
            column(ShiftCode; "Employee Absence"."Shift Code")
            {
            }
            column(empAbsFromDate; "Employee Absence"."From Date")
            {
            }
            column(empAbsToDate; "Employee Absence"."To Date")
            {
            }
            column(employeeName; employeeName)
            {
            }
            column(fromDateFilter; fromDate)
            {
            }
            column(toDateFilter; toDate)
            {
            }
            column(Remarks_EmployeeAbsence; "Employee Absence".Remarks)
            {
            }

            trigger OnAfterGetRecord();
            begin

                CLEAR(employee);
                employee.SETFILTER("No.", "Employee Absence"."Employee No.");
                if employee.FINDLAST then
                    employeeName := employee."Full Name";
            end;

            trigger OnPreDataItem();
            begin
                SETFILTER("Employee Absence"."From Date", '%1..%2', fromDate, toDate);
                // Added in order to show only Employee related to Manger - 20.04.2017 : A2+
                HRPermission.SETRANGE("User ID", USERID);
                if (HRPermission.FINDFIRST) and (HRPermission."Attendance Limited Access") then
                    "Employee Absence".SETFILTER("Employee Absence"."Employee Manager No", '=%1', HRPermission."Assigned Employee Code");
                // Added in order to show only Employee related to Manger - 20.04.2017 : A2-
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control2)
                {
                    Visible = true;
                    field(fromDate; fromDate)
                    {
                        Caption = 'From Date';
                        NotBlank = false;
                        ApplicationArea = All;
                    }
                    field(toDate; toDate)
                    {
                        Caption = 'To Date';
                        NotBlank = false;
                        ApplicationArea = All;
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

    trigger OnPreReport();
    begin
        if fromDate = 0D then
            ERROR('Please Fill Starting Date');
        if toDate = 0D then
            toDate := TODAY;
    end;

    var
        employee: Record Employee;
        employeeName: Text;
        fromDate: Date;
        toDate: Date;
        employeeNo: Code[20];
        HRPermission: Record "HR Permissions";
}

