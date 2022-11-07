report 98005 "Attendance Report Old"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Report Old.rdlc';

    dataset
    {
        dataitem(Date;Date)
        {
            DataItemTableView = SORTING("Period Type","Period Start") ORDER(Ascending);
            RequestFilterFields = "Period Start";
            column(PeriodDate;"Period Start")
            {
            }
            column(Name;DayName)
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
                column(DifferenceText;DifferenceText)
                {
                }
                column(WorkingDays;WorkingDays)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Emp.SETRANGE("No.","Employee No.");
                    Emp.SETRANGE("Date Filter",DMY2DATE(1,DATE2DMY(Date."Period Start",2),DATE2DMY(Date."Period Start",3)),
                    CALCDATE('+1M-3D',DMY2DATE(1,DATE2DMY(Date."Period Start",2),DATE2DMY(Date."Period Start",3))));
                    if Emp.FINDFIRST then
                    begin
                      EmployeeName:=Emp."Full Name";
                      Emp.CALCFIELDS("No. of Working Days");
                      WorkingDays:=Emp."No. of Working Days";
                      if Emp.Status<>Emp.Status::Active then
                        CurrReport.SKIP;
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

                    if (FORMAT(FromTime)='AL') or (FORMAT(ToTime)='ML') or (FORMAT(ToTime)='SICK')
                    or (FORMAT(FromTime)='PL') or (FORMAT(ToTime)='BADAL') then
                    begin
                      CLEAR(FromTime);
                      CLEAR(ToTime);
                    end;

                    if (FORMAT(FromTime)<>'') and (FORMAT(ToTime)<>'') then
                    begin
                      TimeDifference:=HRFunctions.GetHoursFrom2Times(FromTime,ToTime);
                      DifferenceText:=GetTextTime(TimeDifference);
                    end
                    else
                    begin
                      TimeDifference:=0;
                      DifferenceText:=GetTextTime(TimeDifference);
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                DayName:=COPYSTR("Period Name",1,3);
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
        RCaptionLbl : Label 'Items by Location';
        RTotalLbl : Label 'Total';
        HandPunch : Record "Hand Punch";
        FromTime : Time;
        ToTime : Time;
        EmployeeName : Text[200];
        Emp : Record Employee;
        TimeDifference : Decimal;
        DifferenceText : Text[30];
        HRFunctions : Codeunit "Human Resource Functions";
        WorkingDays : Decimal;
        DayName : Text[30];

    procedure GetTextTime(LocalTime : Decimal) : Text[30];
    var
        LocalInteger : Integer;
        LocalDecimalPart : Decimal;
        TextTime : Text[30];
        IntegerText : Text[30];
        DecimalText : Text[30];
        GlobalIntegerPart : Integer;
        GlobalDecimalPart : Integer;
    begin
        GlobalIntegerPart := LocalTime div 1;
        GlobalDecimalPart := ((LocalTime - GlobalIntegerPart) * 60) div 1;
        if GlobalIntegerPart < 10 then
          IntegerText := '0' + FORMAT(GlobalIntegerPart)
        else
          IntegerText := FORMAT(GlobalIntegerPart);
        if GlobalDecimalPart < 10 then
          DecimalText := '0' + FORMAT(GlobalDecimalPart)
        else
          DecimalText := FORMAT(GlobalDecimalPart);
        TextTime :=IntegerText +':'+DecimalText;
        exit(TextTime);
    end;
}

