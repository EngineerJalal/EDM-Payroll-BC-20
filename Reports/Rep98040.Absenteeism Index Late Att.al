report 98040 "Absenteeism Index - Late Att"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Absenteeism Index - Late Att.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "Employee Category Code";
            column(Absenteeism_Index;AbsenteeismIndex)
            {
            }
            column(Late_Attendance_Alert;LateAttendanceAlert)
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName;Employee.FullName)
            {
            }
            column(From_Date;FromDate)
            {
            }
            column(To_Date;ToDate)
            {
            }
            column(Abs_Index_CaptionLbl;AbsenteeismIndexCaptionLbl)
            {
            }
            column(Late_Attnd_Alert_CaptionLbl;LateAttendanceAlertCaptionLbl)
            {
            }
            column(Report_Header_Caption_Lbl;Report_Header_Caption_Lbl)
            {
            }
            column(Emp_Category_CaptionLbl;EmpCategoryCaptionLbl)
            {
            }
            column(From_Date_CaptionLbl;FromDateCaptionLbl)
            {
            }
            column(To_Date_CaptionLbl;ToDateCaptionLbl)
            {
            }
            column(Emp_Category_Code;Employee."Employee Category Code")
            {
            }

            trigger OnAfterGetRecord();
            var
                lDeduction : Decimal;
                lLateArriveHour : Decimal;
                Direction : Label '<';
                lAttendAlert : Decimal;
                lAbsentIndex : Decimal;
            begin
                if Employee.Status= Employee.Status::Inactive then
                begin
                  if (Employee."Inactive Date" < FromDate) then
                    CurrReport.SKIP;
                end;
                if Employee.Status= Employee.Status::Terminated then
                begin
                  if (Employee."Termination Date" < FromDate) then
                    CurrReport.SKIP;
                end;

                if (Employee."Employment Date">ToDate) then
                  CurrReport.SKIP;
                //Added in order to hide employee record in case 'Freeze Salary' is true - 09.04.2016 : AIM +
                if Employee."Freeze Salary" = true then
                  CurrReport.SKIP;
                //Added in order to hide employee record in case 'Freeze Salary' is true - 09.04.2016 : AIM -
                if Employee.Status= Employee.Status::Terminated then
                begin
                  if (Employee."Termination Date" < FromDate) then
                    CurrReport.SKIP;
                end;

                AbsenteeismIndex :=0;
                LateAttendanceAlert :=0;
                TotalLateAttendHours :=0;
                TotalRequiredHours :=0;
                TotalDeduction :=0;

                gEmpAbsence.RESET;
                gEmpAbsence.SETRANGE(gEmpAbsence."Employee No.",Employee."No.");
                gEmpAbsence.SETFILTER(gEmpAbsence."From Date",'%1..%2',FromDate,ToDate);

                if gEmpAbsence.FIND('-') then
                repeat
                if gEmpAbsence."Late Arrive" <> 0 then
                  begin
                    lLateArriveHour := gEmpAbsence."Late Arrive" / 60;
                  end
                  else
                  begin
                  lLateArriveHour := 0;
                  end;
                TotalLateAttendHours := TotalLateAttendHours + lLateArriveHour;
                TotalRequiredHours := TotalRequiredHours + gEmpAbsence."Required Hrs";
                if gEmpAbsence."Required Hrs" > gEmpAbsence."Attend Hrs." then
                  begin
                    lDeduction := gEmpAbsence."Required Hrs" - gEmpAbsence."Attend Hrs.";
                    TotalDeduction := TotalDeduction + lDeduction;

                  end
                  else
                  begin
                  lDeduction :=0;
                  end;
                until gEmpAbsence.NEXT = 0;
                //MESSAGE('The TotalRequiredHours is: %1 AND the TotalLateAttendHours is : %2 AND The TotalDeduction is : %3' ,TotalRequiredHours,TotalLateAttendHours,TotalDeduction);
                if TotalRequiredHours <> 0 then
                  begin
                    lAbsentIndex := TotalLateAttendHours / TotalRequiredHours;
                    AbsenteeismIndex := ROUND(lAbsentIndex,0.001,Direction);
                  end
                  else
                  begin
                    AbsenteeismIndex := 0;
                  end;
                if TotalRequiredHours <> 0 then
                  begin
                  lAttendAlert := TotalDeduction / TotalRequiredHours;
                  LateAttendanceAlert := ROUND(lAttendAlert,0.001,Direction);
                  end
                  else
                  begin
                  LateAttendanceAlert := 0;
                  end;
                //AbsenteeismIndex := TotalLateAttendHours / TotalRequiredHours;
                //LateAttendanceAlert := TotalDeduction / TotalRequiredHours;
            end;

            trigger OnPreDataItem();
            begin
                //Employee.SETFILTER("Date Filter",'%1..%2',FromDate,ToDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Group Filter")
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
        //AbsenceFilter := "Employee Absence".GETFILTERS;
    end;

    var
        gEmpAbsence : Record "Employee Absence";
        gEmployeeCategories : Record "Employee Categories";
        AbsenteeismIndex : Decimal;
        LateAttendanceAlert : Decimal;
        TotalLateAttendHours : Decimal;
        TotalRequiredHours : Decimal;
        FromDateCaptionLbl : Label 'From Date :';
        ToDateCaptionLbl : Label 'To Date :';
        AbsenceFilter : Text;
        LastFieldNo : Integer;
        FromDate : Date;
        ToDate : Date;
        TotalDeduction : Decimal;
        Report_Header_Caption_Lbl : Label 'Absenteeism Index and Late Attendance Alert Report';
        AbsenteeismIndexCaptionLbl : Label 'Absenteeism Index :';
        LateAttendanceAlertCaptionLbl : Label 'Late Attendance Alert :';
        EmpCategoryCaptionLbl : Label 'Employee Category :';
        EmpFullame : Code[10];
}

