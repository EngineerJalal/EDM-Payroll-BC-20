report 98004 "Attendnace By Date"
{
    // version Andrey Panko,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendnace By Date.rdlc';

    dataset
    {
        dataitem(Date;Date)
        {
            DataItemTableView = SORTING("Period Type","Period Start") ORDER(Ascending);
            RequestFilterFields = "Period Start";
            column(PeriodDate;"Period Start")
            {
            }
            column(Name;"Period Name")
            {
            }
            dataitem("Employee Absence";"Employee Absence")
            {
                DataItemLink = "From Date"=FIELD("Period Start");
                column(EmployeeNo;"Employee No.")
                {
                }
                column(EmployeeName;EmployeeName)
                {
                }
                column(AttendHours;"Employee Absence"."Attend Hrs.")
                {
                }
                column(FromTime;FromTime)
                {
                }
                column(ToTime;ToTime)
                {
                }
                column(ShiftCode;"Shift Code")
                {
                }
                column(AtendanceHours;"Attend Hrs.")
                {
                }
                column(RequiredHours;"Required Hrs")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Emp.SETRANGE("No.","Employee No.");
                    if Emp.FINDFIRST then
                    begin
                      EmployeeName:=Emp."Full Name";
                    end
                    else
                      EmployeeName:='';

                    HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                    HandPunch.SETRANGE("Scheduled Date","From Date");
                    HandPunch.SETRANGE("Action Type",'IN');
                    if HandPunch.FINDFIRST then
                      FromTime:=HandPunch."Real Time"
                    else
                      CLEAR(FromTime);

                    HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                    HandPunch.SETRANGE("Scheduled Date","From Date");
                    HandPunch.SETRANGE("Action Type",'OUT');
                    if HandPunch.FINDLAST then
                      ToTime:=HandPunch."Real Time"
                    else
                      CLEAR(ToTime);
                end;

                trigger OnPreDataItem();
                begin
                    // Added in order to show only Employee related to Manger - 20.04.2017 : A2+
                    HRPermission.SETRANGE("User ID",USERID);
                    if (HRPermission.FINDFIRST) and (HRPermission."Attendance Limited Access") then
                      "Employee Absence".SETFILTER("Employee Absence"."Employee Manager No",'=%1',HRPermission."Assigned Employee Code");
                    // Added in order to show only Employee related to Manger - 20.04.2017 : A2-
                end;
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

    var
        RCaptionLbl : Label 'Items by Location';
        RTotalLbl : Label 'Total';
        HandPunch : Record "Hand Punch";
        FromTime : Time;
        ToTime : Time;
        EmployeeName : Text[200];
        Emp : Record Employee;
        HRPermission : Record "HR Permissions";
}

