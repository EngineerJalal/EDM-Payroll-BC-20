report 98111 "Employees Punches"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employees Punches.rdlc';

    dataset
    {
        dataitem("Machine Attendance Data";"Machine Attendance Data")
        {
            column(UserID_MachineAttendanceData;"Machine Attendance Data"."User ID")
            {}
            column(PunchDate_MachineAttendanceData;"Machine Attendance Data"."Punch Date")
            {}
            column(PunchTime_MachineAttendanceData;"Machine Attendance Data"."Punch Time")
            {}
            column(PunchType_MachineAttendanceData;"Machine Attendance Data"."Punch Type")
            {}
            column(EmployeeName;EmployeeName)
            {}
            column(EmployeeNo;EmployeeNo)
            {}
            column(FromDate;FromDate)
            {}
            column(TillDate;TillDate)
            {}

            trigger OnAfterGetRecord();
            begin
                EmployeeTbt.SETRANGE("Attendance No.","Machine Attendance Data"."User ID");
                if EmployeeTbt.FINDFIRST then begin
                  EmployeeNo := EmployeeTbt."No.";
                  EmployeeName := EmployeeTbt."Full Name";
                end else
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem();
            begin
                "Machine Attendance Data".SETFILTER("Machine Attendance Data"."Punch Date",'%1..%2',FromDate,TillDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Report Parameter")
                {
                    field("From Date";FromDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Till Date";TillDate)
                    {
                        ApplicationArea=All;
                    }
                }
            }
        }
    }

    var
        EmployeeTbt : Record Employee;
        EmployeeName : Text[100];
        EmployeeNo : Code[20];
        FromDate : Date;
        TillDate : Date;
}

