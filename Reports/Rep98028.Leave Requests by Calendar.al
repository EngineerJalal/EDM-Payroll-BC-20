report 98028 "Leave Requests by Calendar"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Leave Requests by Calendar.rdlc';

    dataset
    {
        dataitem(Date;Date)
        {
            DataItemTableView = SORTING("Period Type","Period Start") ORDER(Ascending);
            RequestFilterFields = "Period Start";
            column(PeriodDate;Date."Period Start")
            {
            }
            column(IsHideDay;gIsHideDay)
            {
            }
            column(FilterDate;gFilterDate)
            {
            }
            column(CompanyLogo;gCompanyInfo.Picture)
            {
            }
            column(CompanyAddress1;gCompanyAddress[1])
            {
            }
            column(CompanyAddress2;gCompanyAddress[2])
            {
            }
            column(CompanyAddress3;gCompanyAddress[3])
            {
            }
            column(CompanyAddress4;gCompanyAddress[4])
            {
            }
            column(CompanyAddress5;gCompanyAddress[5])
            {
            }
            column(CompanyAddress6;gCompanyAddress[6])
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(ToDate;ToDate)
            {
            }
            dataitem("Leave Request";"Leave Request")
            {
                DataItemTableView = SORTING("Employee No.","From Date") ORDER(Ascending);
                RequestFilterFields = "Employee No.";
                column(EmployeeNo;"Leave Request"."Employee No.")
                {
                }
                column(EmployeeName;gEmployeeName)
                {
                }
                column(DailyFromToTime;gDailyFromToTime)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    if "Leave Request"."Employee No." = '' then
                      CurrReport.SKIP;

                    if not gEmployee.GET("Employee No.") then
                      CurrReport.SKIP;

                    gDailyFromToTime := GetLeaveTimeOfDay();

                    if gDailyFromToTime = '' then
                      CurrReport.SKIP;

                    gIsHideDay := false;
                    gEmployeeName := gEmployee."Full Name";
                end;

                trigger OnPreDataItem();
                begin

                    SETFILTER("To Date",'>=%1',Date."Period Start");
                    SETFILTER("Leave Request".Status,'=%1|%2',"Leave Request".Status::Open,"Leave Request".Status::Generated);
                end;
            }

            trigger OnAfterGetRecord();
            begin

                //IF Date.GETFILTER(Date."Period Start") = '' THEN
                //  ERROR('please specify period start');

                gFilterDate := Date.GETFILTER(Date."Period Start");
                gIsHideDay := true;

                if FromDate = 0D then
                  FromDate := DMY2DATE(1,1,DATE2DMY(WORKDATE,3));
                if ToDate = 0D then
                  ToDate := WORKDATE;
                Date.SETFILTER("Period Start",'%1..%2',FromDate,ToDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Report")
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
        ReportTitle_lbl = 'Leave Request Report';EmployeeCode_lbl = 'Employee Code';EmployeeName_lbl = 'Employee Name';}

    trigger OnInitReport();
    begin
        IncludeWeekend := true;
    end;

    trigger OnPreReport();
    begin

        gCompanyInfo.GET;
        gCompanyInfo.CALCFIELDS(gCompanyInfo.Picture);
        gFormatAddress.Company(gCompanyAddress,gCompanyInfo);
    end;

    var
        gEmployee : Record Employee;
        gEmployeeName : Text;
        gCompanyInfo : Record "Company Information";
        gFormatAddress : Codeunit "Format Address";
        gCompanyAddress : array [8] of Text;
        gIsHideDay : Boolean;
        gDailyFromToTime : Text;
        gFilterDate : Text;
        FromDate : Date;
        ToDate : Date;
        IncludeWeekend : Boolean;

    local procedure GetLeaveTimeOfDay() result : Text;
    var
        lFromTime : Time;
        lToTime : Time;
        EmpTypeSched : Record "Employment Type Schedule";
        DayOfTheWeek : Integer;
    begin

        if gEmployee."Employment Type Code" <> '' then
          begin

            if Date."Period No." = 7 then
              DayOfTheWeek := 0
            else
              DayOfTheWeek := Date."Period No.";

            EmpTypeSched.SETRANGE("Employment Type Code",gEmployee."Employment Type Code");

            //EmpTypeSched.SETRANGE("Day of the Week",DayOfTheWeek);

            if EmpTypeSched.FINDFIRST then
              begin
                if (EmpTypeSched."No. of Hours" = 0) and (IncludeWeekend = false) then
                  result := ''
                else
                  begin
                    if Date."Period Start" = "Leave Request"."From Date" then
                      lFromTime := "Leave Request"."From Time"
                    else if (Date."Period Start" > "Leave Request"."From Date") and (Date."Period Start" <= "Leave Request"."To Date") then
                      lFromTime := EmpTypeSched."Starting Time";

                    if Date."Period Start" = "Leave Request"."To Date" then
                      lToTime := "Leave Request"."To Time"
                    else if (Date."Period Start" >= "Leave Request"."From Date") and (Date."Period Start" < "Leave Request"."To Date") then
                      lToTime := EmpTypeSched."Ending Time";

                    IF (lFromTime <> 0T) AND (lToTime <> 0T) THEN
                      result := STRSUBSTNO('%1 (%2-%3)' ,"Leave Request"."Leave Type",lFromTime,lToTime)
                    else
                      result := '';
                  end;

              end;

          end;

        exit(result);
    end;
}

