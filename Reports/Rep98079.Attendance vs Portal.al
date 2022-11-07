report 98079 "Attendance vs Portal"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance vs Portal.rdlc';

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(ToDate;ToDate)
            {
            }

            trigger OnPreDataItem();
            begin

                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
        dataitem("Employee Absence";"Employee Absence")
        {
            RequestFilterFields = "Employee No.";
            column(EmployeeNo_EmployeeAbsence;"Employee Absence"."Employee No.")
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(FromDate_EmployeeAbsence;"Employee Absence"."From Date")
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
            column(OvertimePortal;OvertimePortal)
            {
            }
            column(EarlyLeavePortal;EarlyLeavePortal)
            {
            }
            column(EarlyArrivePortal;EarlyArrivePortal)
            {
            }
            column(LateArrivePortal;LateArrivePortal)
            {
            }

            trigger OnAfterGetRecord();
            begin

                EmployeeName := '';
                OvertimePortal := 0;
                EarlyLeavePortal := 0;
                EarlyArrivePortal := 0;
                LateArrivePortal := 0;

                if Employee.GET("Employee Absence"."Employee No.") then
                  EmployeeName := Employee."Full Name";

                LeaveRequest.RESET;
                LeaveRequest.SETRANGE("Employee No.","Employee Absence"."Employee No.");
                LeaveRequest.SETRANGE("From Date","Employee Absence"."From Date");
                //LeaveRequest.SETRANGE(Status,LeaveRequest.Status::Generated);


                LeaveRequest.SETRANGE("Request Type",LeaveRequest."Request Type"::Overtime);
                if LeaveRequest.FINDFIRST then
                  repeat
                    OvertimePortal += LeaveRequest."Hours Value";
                  until LeaveRequest.NEXT = 0;

                LeaveRequest.SETRANGE("Request Type",LeaveRequest."Request Type"::EarlyLeave);
                if LeaveRequest.FINDFIRST then
                  repeat
                    EarlyLeavePortal += (LeaveRequest."Hours Value" * 60);
                  until LeaveRequest.NEXT = 0;

                LeaveRequest.SETRANGE("Request Type",LeaveRequest."Request Type"::EarlyArrive);
                if LeaveRequest.FINDFIRST then
                  repeat
                    EarlyArrivePortal += (LeaveRequest."Hours Value" * 60);
                  until LeaveRequest.NEXT = 0;

                LeaveRequest.SETRANGE("Request Type",LeaveRequest."Request Type"::LateArrive);
                if LeaveRequest.FINDFIRST then
                  repeat
                    LateArrivePortal += (LeaveRequest."Hours Value" * 60);
                  until LeaveRequest.NEXT = 0;
            end;

            trigger OnPreDataItem();
            begin

                "Employee Absence".SETRANGE("From Date",FromDate,ToDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Filters)
                {
                    field(FromDate;FromDate)
                    {
                        ApplicationArea=All;
                    }
                    field(ToDate;ToDate)
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
        ReportHeader = 'Attendance vs Portal';}

    trigger OnPreReport();
    begin

        if (FromDate = 0D) or (ToDate = 0D) then
          ERROR('You must select from date and to date');
    end;

    var
        FromDate : Date;
        ToDate : Date;
        CompanyInfo : Record "Company Information";
        Employee : Record Employee;
        EmployeeName : Text;
        LeaveRequest : Record "Leave Request";
        OvertimePortal : Decimal;
        EarlyLeavePortal : Decimal;
        EarlyArrivePortal : Decimal;
        LateArrivePortal : Decimal;
}

