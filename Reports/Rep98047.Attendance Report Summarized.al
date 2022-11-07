report 98047 "Attendance Report - Summarized"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Report - Summarized.rdlc';

    dataset
    {
        dataitem("Employee Absence";"Employee Absence")
        {
            column(RequiredHrs_EmployeeAbsence;"Employee Absence"."Required Hrs")
            {
            }
            column(AttendHrs_EmployeeAbsence;"Employee Absence"."Attend Hrs.")
            {
            }
            column(EntryNo_EmployeeAbsence;"Employee Absence"."Entry No.")
            {
            }
            column(FromDate_EmployeeAbsence;"Employee Absence"."From Date")
            {
            }
            column(CauseofAbsenceCode_EmployeeAbsence;"Employee Absence"."Cause of Absence Code")
            {
            }
            column(FromTime_EmployeeAbsence;"Employee Absence"."From Time")
            {
            }
            column(ToTime_EmployeeAbsence;"Employee Absence"."To Time")
            {
            }
            column(Break_EmployeeAbsence;"Employee Absence"."Break")
            {
            }
            column(EmployeeNo_EmployeeAbsence;"Employee Absence"."Employee No.")
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(Over_Deviation_Time;OverDeviationTime)
            {
            }
            column(Working_Hours;WorkingHours)
            {
            }
            column(Type_EmployeeAbsence;"Employee Absence".Type)
            {
            }
            column(TotalTime;TotalTime)
            {
            }
            column(OverDeviationTimeSigne;OverDeviationTimeSigne)
            {
            }
            column(AllowedBreak;AllowedBreak)
            {
            }
            column(ShiftCode_EmployeeAbsence;"Employee Absence"."Shift Code")
            {
            }
            column(First_In;FirstIn)
            {
            }
            column(Last_Out;LastOut)
            {
            }

            trigger OnAfterGetRecord();
            begin

                //Added in order to filter by employeeNoFilter - 01.12.2016 : AIM +
                if (IsSendMailChecked = true ) and (EmployeeNoFilter <> '') then
                  begin
                    if ("Employee Absence"."Employee No." <> EmployeeNoFilter) then
                      CurrReport.SKIP;
                  end;
                //Added in order to filter by employeeNoFilter - 01.12.2016 : AIM -


                AllowedBreak :=  0;
                TotalTime := '00:00';
                OverDeviationTime := '00:00';
                OverDeviationTimeSigne := 0;
                WorkingHoursdecimal  := 0;
                WorkingHours := '00:00';
                FirstIn := 0T;
                LastOut := 0T;

                Employee.SETRANGE("No.","Employee Absence"."Employee No.");
                if Employee.FINDFIRST then
                EmployeeName := Employee."First Name" + Employee."Last Name";

                TotalTime := PayrollFunction.ChangeMinutes2TimeFormat("Employee Absence"."Attend Hrs." * 60);
                OverDeviationTime := PayrollFunction.ChangeMinutes2TimeFormat(("Employee Absence"."Required Hrs" - "Employee Absence"."Attend Hrs.") * 60);
                OverDeviationTimeSigne := "Employee Absence"."Attend Hrs." - "Employee Absence"."Required Hrs";

                DailyShift.SETRANGE("Shift Code","Employee Absence"."Shift Code");
                if DailyShift.FINDFIRST then
                  begin
                   AllowedBreak := DailyShift."Allowed Break Minute"/60;
                   if "Employee Absence"."Attend Hrs." > 0 then
                      begin
                        WorkingHoursdecimal := "Employee Absence"."Attend Hrs." - AllowedBreak;
                        WorkingHours := PayrollFunction.ChangeMinutes2TimeFormat(WorkingHoursdecimal * 60);
                      end
                   else
                     WorkingHours := '00:00';

                  end;


                Employee.SETRANGE("No.","Employee Absence"."Employee No.");
                HandPunch.SETRANGE("Attendnace No.","Employee Absence"."Attendance No.");
                HandPunch.SETRANGE("Scheduled Date","Employee Absence"."From Date");
                if HandPunch.FINDFIRST then
                  FirstIn := HandPunch."Real Time";


                HandPunch.RESET;
                CLEAR(HandPunch);
                Employee.SETRANGE("No.","Employee Absence"."Employee No.");
                HandPunch.SETRANGE("Attendnace No.","Employee Absence"."Attendance No.");
                HandPunch.SETRANGE("Scheduled Date","Employee Absence"."From Date");
                if HandPunch.FINDLAST then
                  LastOut := HandPunch."Real Time";

                //Added in order to send Absent Days by email to the employees - 02.12.2016 : AIM +
                //Stopped by EDM.MM if IsSendMailChecked then
                  //Stopped by EDM.MM SendMail.SendAbsentDaysToEmployees(Employee."No.","Employee Absence"."From Date","Employee Absence"."From Date");
                //Added in order to send Absent Days by email to the employees - 02.12.2016 : AIM -
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE("From Date",StartDate,EndDate);
                //Added in order to filter by employeeNoFilter - 01.12.2016 : AIM +
                if (IsSendMailChecked = true ) and (EmployeeNoFilter <> '') then
                  begin
                    SETRANGE("Employee Absence"."Employee No.",EmployeeNoFilter)  ;

                  end;
                //Added in order to filter by employeeNoFilter - 01.12.2016 : AIM -

                //CurrReport.NEWPAGEPERRECORD := true;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate;StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea=All;
                    }
                    field(EndDate;EndDate)
                    {
                        Caption = 'End Date';
                        NotBlank = false;
                        ApplicationArea=All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            StartDate := DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
            //Modified because Date is wrongly calculated - 08.04.2017 : AIM +
            //EndDate := CALCDATE('CM',WORKDATE);
            EndDate := DMY2DATE(PayrollFunction.GetLastDayinMonth(WORKDATE),DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
            //Modified because Date is wrongly calculated - 08.04.2017 : AIM +
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
          ERROR(BlankStartEndDateErr);
    end;

    var
        WorkingHours : Text;
        OverDeviationTime : Text;
        EmployeeName : Text;
        Employee : Record Employee;
        TotalTime : Text;
        PayrollFunction : Codeunit "Payroll Functions";
        OverDeviationTimeSigne : Decimal;
        EmploymentTypeSchedule : Record "Employment Type Schedule";
        DailyShift : Record "Daily Shifts";
        AllowedBreak : Decimal;
        WorkingHoursdecimal : Decimal;
        HandPunch : Record "Hand Punch";
        FirstIn : Time;
        LastOut : Time;
        WorkingHoursTime : Time;
        StartDate : Date;
        EndDate : Date;
        BlankStartEndDateErr : Label 'Starting date and ending date must be defined.';
        IsSendMailChecked : Boolean;
        EmployeeNoFilter : Code[20];

    procedure SetParameters(IsSendMailCheckedParam : Boolean;FromDateParam : Date;ToDateParam : Date;EmployeeNoFilterParam : Code[20]);
    begin

        IsSendMailChecked := IsSendMailCheckedParam;
        StartDate := FromDateParam;
        EndDate := ToDateParam;
        EmployeeNoFilter := EmployeeNoFilterParam;
    end;
}

