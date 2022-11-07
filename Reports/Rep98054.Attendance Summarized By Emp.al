report 98054 "Attendance Summarized By Emp"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Summarized By Emp.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(Employee_Name;EmployeeName)
            {
            }
            column(Total_Days;TotalDays)
            {
            }
            column(WorkingDays;WorkingDays)
            {
            }
            column(Weekend;Weekend)
            {
            }
            column(Holiday;Holiday)
            {
            }
            column(TotalWokedDays;TotalWokedDays)
            {
            }
            column(Absent;Absent)
            {
            }
            column(Unpaidleave;Unpaidleave)
            {
            }
            column(PaidLeave;PaidLeave)
            {
            }
            column(WorkedonOFFDays;WorkedonOFFDays)
            {
            }
            column(TotalRequiredHours;TotalRequiredHours)
            {
            }
            column(WorkedHours;WorkedHours)
            {
            }
            column(WorkingHours;WorkingHours)
            {
            }
            column(UnpaidLeaveHours;UnpaidLeaveHours)
            {
            }
            column(PaidLeaveHours;PaidLeaveHours)
            {
            }
            column(DeviationTime;DeviationTime)
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(ToDate;ToDate)
            {
            }
            column(DeviationTimeDecimal;DeviationTimeDecimal)
            {
            }

            trigger OnAfterGetRecord();
            begin
                TotalDays := 0D;
                WorkingDays := 0;
                Weekend := 0;
                Holiday := 0;
                TotalWokedDays := 0;
                Absent := 0;
                Unpaidleave := 0;
                PaidLeave := 0;
                WorkedonOFFDays := 0;
                TotalRequiredHoureDecimal := 0;
                WorkedHoursDecimal := 0;
                DeviationTimeDecimal := 0;
                TotalRequiredHours := '00:00';
                UnpaidLeaveHours := '00:00';
                WorkedHours := '00:00';
                PaidLeaveHours := '00:00';
                DeviationTime := '00:00';
                
                
                EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDLAST then
                 TotalDays := EmployeeAbsence."From Date";
                
                EmploymentType.SETRANGE(Code,Employee."Employment Type Code");
                if EmploymentType.FINDFIRST then
                  WorkingDays := EmploymentType."Working Days Per Month";
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'WEEKEND');
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  Weekend := Weekend + 1;
                 until EmployeeAbsence.NEXT = 0;
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  if EmployeeAbsence."Cause of Absence Code" = 'HOLIDAY' then
                   Holiday := Holiday + 1;
                 until EmployeeAbsence.NEXT = 0;
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  if EmployeeAbsence."Cause of Absence Code" = 'WD' then
                  TotalWokedDays += 1
                  else
                   if EmployeeAbsence."Cause of Absence Code" = '0.5AL' then
                    TotalWokedDays += 0.5
                  else
                   if EmployeeAbsence."Cause of Absence Code" = '0.25AL' then
                    TotalWokedDays += 0.75
                  else
                   if EmployeeAbsence."Cause of Absence Code" = '0.75AL' then
                    TotalWokedDays += 0.25;
                 until EmployeeAbsence.NEXT = 0;
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  if (EmployeeAbsence."Cause of Absence Code" = 'WD') and (EmployeeAbsence."Attend Hrs." = 0) then
                   Absent := Absent + 1;
                 until EmployeeAbsence.NEXT = 0;
                
                
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  WorkedHoursDecimal += EmployeeAbsence."Attend Hrs.";
                  if (EmployeeAbsence."Cause of Absence Code" = 'AL') then
                   begin
                    PaidLeave := PaidLeave + 1;
                    RequiredHoureALDecimal += EmployeeAbsence."Required Hrs";
                   end
                  else
                   if (EmployeeAbsence."Cause of Absence Code" = '0.5AL')  then
                    begin
                     PaidLeave := PaidLeave + 0.5;
                     RequiredHoureALDecimal += (EmployeeAbsence."Required Hrs"/2);
                    end
                  else
                   if (EmployeeAbsence."Cause of Absence Code" = '0.25AL')  then
                    begin
                     PaidLeave := PaidLeave + 0.5;
                     RequiredHoureALDecimal += (EmployeeAbsence."Required Hrs"/4);
                    end
                   else
                    if EmployeeAbsence."Cause of Absence Code" = 'UNPAID' then
                     begin
                      Unpaidleave += 1;
                      UnpaidLeaveDecimal += EmployeeAbsence."Required Hrs";
                     end
                 until EmployeeAbsence.NEXT = 0;
                PaidLeaveHours := PayrollFunction.ChangeMinutes2TimeFormat(RequiredHoureALDecimal * 60);
                WorkedHours := PayrollFunction.ChangeMinutes2TimeFormat(WorkedHoursDecimal * 60);
                UnpaidLeaveHours := PayrollFunction.ChangeMinutes2TimeFormat(UnpaidLeaveDecimal * 60);
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  if ( (EmployeeAbsence."Cause of Absence Code" = 'HOLIDAY') and (EmployeeAbsence."Attend Hrs." <> 0) )
                  or ( (EmployeeAbsence."Cause of Absence Code" = 'WEEKEND') and (EmployeeAbsence."Attend Hrs." <> 0) ) then
                   WorkedonOFFDays := WorkedonOFFDays + 1;
                 until EmployeeAbsence.NEXT = 0;
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  if EmployeeAbsence."Required Hrs" <> 0 then
                   begin
                    TotalRequiredHoureDecimal += EmployeeAbsence."Required Hrs";
                   end
                 until EmployeeAbsence.NEXT = 0;
                TotalRequiredHours := PayrollFunction.ChangeMinutes2TimeFormat(TotalRequiredHoureDecimal * 60);
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                if EmployeeAbsence.FINDFIRST then
                 repeat
                  DeviationTimeDecimal += (EmployeeAbsence."Attend Hrs." - EmployeeAbsence."Required Hrs")
                 until EmployeeAbsence.NEXT = 0;
                DeviationTime := PayrollFunction.ChangeMinutes2TimeFormat(DeviationTimeDecimal * 60);
                
                /*
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'0.5AL');
                IF EmployeeAbsence.FINDFIRST THEN
                 REPEAT
                  TotalWokedDays := TotalWokedDays + 0.5;
                 UNTIL EmployeeAbsence.NEXT = 0;
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'0.25AL');
                IF EmployeeAbsence.FINDFIRST THEN
                 REPEAT
                  TotalWokedDays := TotalWokedDays + 0.25;
                 UNTIL EmployeeAbsence.NEXT = 0;
                
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'0.75AL');
                IF EmployeeAbsence.FINDFIRST THEN
                 REPEAT
                  TotalWokedDays := TotalWokedDays + 0.75;
                 UNTIL EmployeeAbsence.NEXT = 0;
                 */
                
                /*EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                IF EmployeeAbsence.FINDFIRST THEN
                 REPEAT
                  IF EmployeeAbsence."Cause of Absence Code" = 'AL' THEN
                   TotalWokedDays += 1
                  ELSE
                   IF EmployeeAbsence."Cause of Absence Code" = '0.75AL' THEN
                    TotalWokedDays += 0.75
                  ELSE
                   IF EmployeeAbsence."Cause of Absence Code" = '0.5AL' THEN
                    TotalWokedDays += 0.5
                  ELSE
                   IF EmployeeAbsence."Cause of Absence Code" = '0.25AL' THEN
                    TotalWokedDays += 0.25;
                 UNTIL EmployeeAbsence.NEXT = 0;*/

            end;

            trigger OnPreDataItem();
            begin
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date";FromDate)
                {
                    ApplicationArea=All;
                }
                field("To Date";ToDate)
                {
                    ApplicationArea=All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            FromDate := DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
            //Modified because Date is wrongly calculated - 08.04.2017 : AIM +
            //ToDate := CALCDATE('CM',WORKDATE);
            ToDate := DMY2DATE(PayrollFunction.GetLastDayinMonth(WORKDATE),DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
            //Modified because Date is wrongly calculated - 08.04.2017 : AIM +

            //EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        /*IF FromDate = 0D THEN
          ERROR('Please Fill Starting Date');
        IF ToDate = 0D THEN
          ERROR('Please Fill Ending Date');*/

    end;

    var
        EmployeeAbsence : Record "Employee Absence";
        EmploymentType : Record "Employment Type";
        DailyShifts : Record "Daily Shifts";
        PayrollFunction : Codeunit "Payroll Functions";
        EmployeeName : Text;
        TotalDays : Date;
        WorkingDays : Integer;
        Weekend : Integer;
        Present : Decimal;
        TotalWokedDays : Decimal;
        Absent : Integer;
        PaidLeave : Decimal;
        Holiday : Integer;
        WorkingHours : Text;
        OnDutyHours : Text;
        TotalWorkedHours : Text;
        PaidLeaveHours : Text;
        DeviationTime : Text;
        AllowedBreak : Decimal;
        WorkingHoursdecimal : Decimal;
        TotalHours : Text;
        TotalHoursDecimal : Decimal;
        OverTimeDecimal : Decimal;
        WorkedonOFFDays : Decimal;
        WorkedHoursDecimal : Decimal;
        WorkedHours : Text;
        DeviationTimeDecimal : Decimal;
        TotalRequiredHoureDecimal : Decimal;
        TotalRequiredHours : Text;
        RequiredHoureALDecimal : Decimal;
        RequiredHoureAL : Text;
        Unpaidleave : Decimal;
        UnpaidLeaveHours : Text;
        FromDate : Date;
        ToDate : Date;
        UnpaidLeaveDecimal : Decimal;
        DeviationSigne : Decimal;
}

