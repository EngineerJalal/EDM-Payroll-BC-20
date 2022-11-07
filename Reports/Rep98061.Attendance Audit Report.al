report 98061 "Attendance Audit report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Audit report.rdlc';

    dataset
    {
        dataitem(Header;"Integer")
        {
            MaxIteration = 1;
            column(CompanyLogo;CompanyInfoRec.Picture)
            {
            }
            column(CompanyName1;CompanyName1)
            {
            }
            column(CompanyRowInformations;CompanyRowInformations)
            {
            }
            column(ReportName_CaptionLbl;ReportName_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompanyName1 :=  CompanyInfoRec.Name;
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE(Number,1,1);
            end;
        }
        dataitem(Employee;Employee)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.";
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(FirstName_Employee;Employee."First Name")
            {
            }
            column(MiddleName_Employee;Employee."Middle Name")
            {
            }
            column(LastName_Employee;Employee."Last Name")
            {
            }
            column(WDVar;WDVar)
            {
            }
            column(DOVar;DOVar)
            {
            }
            column(ALVar;ALVar)
            {
            }
            column(PLVar;PLVar)
            {
            }
            column(SLVar;SLVar)
            {
            }
            column(TRVar;TRVar)
            {
            }
            column(ADVar;ADVar)
            {
            }
            dataitem("Employee Absence";"Employee Absence")
            {
                DataItemLink = "Employee No."=FIELD("No.");
                column(EmployeeAbsence_EmployeeNo;"Employee Absence"."Employee No.")
                {
                }
                column(Sum_RequiredHrs;Sum_RequiredHrsVar)
                {
                }
                column(Sum_AttendedHrs;Sum_AttendedHrsVar)
                {
                }
                column(Sum_ActualAttendedHrs;Sum_ActualAttendedHrsVar)
                {
                }
                column(TotalDays;TotalDaysVar)
                {
                }
                column(DailyShiftsCode;DailyShiftsCode)
                {
                }
                column(CauseCode;CauseCode)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if  FromTotalDaysFilter <>  0 then
                      if  TotalDaysVar  < FromTotalDaysFilter then
                        CurrReport.SKIP;

                    if  ToTotalDaysFilter <>  0 then
                      if  TotalDaysVar  > ToTotalDaysFilter then
                        CurrReport.SKIP;

                    if  FromVarianceFilter  <>  0 then
                      if  (Sum_AttendedHrsVar - Sum_RequiredHrsVar)  < FromVarianceFilter  then
                      CurrReport.SKIP;

                    if  ToVarianceFilter  <>  0 then
                      if  (Sum_AttendedHrsVar - Sum_RequiredHrsVar)  > ToVarianceFilter  then
                      CurrReport.SKIP;

                    if  FromVarianceAsPunchFilter <>  0 then
                      if  (Sum_ActualAttendedHrsVar - Sum_RequiredHrsVar) < FromVarianceAsPunchFilter then
                        CurrReport.SKIP;

                    if  ToVarianceAsPunchFilter <>  0 then
                      if  (Sum_ActualAttendedHrsVar - Sum_RequiredHrsVar) > ToVarianceAsPunchFilter then
                        CurrReport.SKIP;

                    DailyShiftsCode           :=  "Employee Absence"."Shift Code";
                    case DailyShiftsCode  of
                      'AL','0.25AL','0.5AL','0.75AL' :  DailyShiftsCode    :=  'AL';
                      'SKD','0.25SKD','0.5SKD','0.75SKD','SKL','0.25SKL','0.5SKL','0.75SKL'  : DailyShiftsCode :=  'SL';
                      else
                        DailyShiftsCode       := "Employee Absence"."Shift Code";
                    end;

                    DailyShiftsRec.SETRANGE(DailyShiftsRec."Shift Code","Employee Absence"."Shift Code");
                    if  DailyShiftsRec.FINDFIRST  then
                      CauseCode :=  DailyShiftsRec."Cause Code";
                    case CauseCode  of
                      'AL','0.25AL','0.5AL','0.75AL' :  CauseCode    :=  'AL';
                      'SKD','0.25SKD','0.5SKD','0.75SKD','SKL','0.25SKL','0.5SKL','0.75SKL'  : CauseCode :=  'SL';
                      else
                        CauseCode       := DailyShiftsRec."Cause Code";
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    //BetweenFromDate :=  DMY2DATE(15,DATE2DMY(PeriodFilter,2),DATE2DMY(PeriodFilter,3));
                    //BetweenToDate   :=  DMY2DATE(DATE2DMY(CALCDATE('+1M-1D',BetweenFromDate),1),DATE2DMY(PeriodFilter,2),DATE2DMY(PeriodFilter,3));

                    "Employee Absence".SETCURRENTKEY("From Date");
                    "Employee Absence".SETRANGE("Employee Absence"."From Date",FromDateFilter,ToDateFilter);
                    //"Employee Absence".SETFILTER("Employee Absence".Period,'%1..%2',FromDateFilter,ToDateFilter);
                    "Employee Absence".CALCSUMS("Required Hrs");
                    Sum_RequiredHrsVar  :=  "Employee Absence"."Required Hrs";
                    "Employee Absence".CALCSUMS("Attend Hrs.");
                    Sum_AttendedHrsVar  :=  "Employee Absence"."Attend Hrs.";
                    "Employee Absence".CALCSUMS("Actual Attend Hrs");
                    Sum_ActualAttendedHrsVar  :=  "Employee Absence"."Actual Attend Hrs";
                    TotalDaysVar        :=  "Employee Absence".COUNT;
                end;
            }

            trigger OnAfterGetRecord();
            var
                EmployeeAbsence : Record "Employee Absence";
            begin
                WDVar := 0;
                DOVar := 0;
                ALVar := 0;
                PLVar := 0;
                SLVar := 0;
                TRVar := 0;
                ADVar := 0;
                HolidayVar := 0;

                //WD
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'WD');
                if EmployeeAbsence.FINDFIRST then
                  WDVar := EmployeeAbsence.COUNT;

                //DO
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'DO');
                if EmployeeAbsence.FINDFIRST then
                  DOVar := EmployeeAbsence.COUNT;

                //AL
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'AL');
                if EmployeeAbsence.FINDFIRST then
                  ALVar := EmployeeAbsence.COUNT;

                //SL
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETFILTER("Cause of Absence Code",'%1|%2','SKD','SKL');
                if EmployeeAbsence.FINDFIRST then
                  SLVar := EmployeeAbsence.COUNT;

                //PL
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'PL');
                if EmployeeAbsence.FINDFIRST then
                  PLVar := EmployeeAbsence.COUNT;

                //TR
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'TR');
                if EmployeeAbsence.FINDFIRST then
                  TRVar := EmployeeAbsence.COUNT;

                //AD
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'AD');
                if EmployeeAbsence.FINDFIRST then
                  ADVar := EmployeeAbsence.COUNT;

                //Holiday
                EmployeeAbsence.RESET;
                CLEAR(EmployeeAbsence);
                EmployeeAbsence.SETRANGE("Employee No.",Employee."No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDateFilter,ToDateFilter);
                EmployeeAbsence.SETRANGE("Cause of Absence Code",'HOLIDAY');
                if EmployeeAbsence.FINDFIRST then
                  HolidayVar := EmployeeAbsence.COUNT;
            end;

            trigger OnPreDataItem();
            begin
                Employee.SETFILTER(Status,'%1',Employee.Status::Active);
                /*
                IF  EmployeeCodeFilter <>  ''  THEN
                  BEGIN
                    SETRANGE("No.",EmployeeCodeFilter);
                  END;
                
                IF  EmployeeFullNameFilter <>  ''  THEN
                  BEGIN
                    SETRANGE("Full Name",EmployeeFullNameFilter);
                  END;
                */
                
                //  BEGIN EDM Abdelwahab Bodon 08-12-2016
                    HRPermission.SETRANGE("User ID",USERID);
                    if HRPermission.FINDFIRST then
                      if HRPermission."Assigned Employee Code" <> '' then
                        SETRANGE("Manager No.",HRPermission."Assigned Employee Code");
                
                //  END

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(General)
                {
                    Caption = 'General';
                    field(FromDateFilter;FromDateFilter)
                    {
                        Caption = 'From Date';
                        ApplicationArea=All;
                    }
                    field(ToDateFilter;ToDateFilter)
                    {
                        Caption = 'To Date';
                        ApplicationArea=All;
                    }
                    field(FromVarianceFilter;FromVarianceFilter)
                    {
                        Caption = 'From Variance';
                        ApplicationArea=All;
                    }
                    field(ToVarianceFilter;ToVarianceFilter)
                    {
                        Caption = 'To Variance';
                        ApplicationArea=All;
                    }
                    field(FromVarianceAsPunchFilter;FromVarianceAsPunchFilter)
                    {
                        Caption = 'From Variance As Punch';
                        ApplicationArea=All;
                    }
                    field(ToVarianceAsPunchFilter;ToVarianceAsPunchFilter)
                    {
                        Caption = 'To From Variance As Punch';
                        ApplicationArea=All;
                    }
                    field(FromTotalDaysFilter;FromTotalDaysFilter)
                    {
                        Caption = 'From Total Days';
                        ApplicationArea=All;
                    }
                    field(ToTotalDaysFilter;ToTotalDaysFilter)
                    {
                        Caption = 'To Total Days';
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

    trigger OnInitReport();
    begin
        CompanyInfoRec.GET;
        CompanyInfoRec.CALCFIELDS(CompanyInfoRec.Picture);

        //PeriodFilter    := CALCDATE('-1D',DMY2DATE(1,DATE2DMY(TODAY,2),DATE2DMY(TODAY,3)));
        FromDateFilter  := CALCDATE('-1M',DMY2DATE(1,DATE2DMY(TODAY,2),DATE2DMY(TODAY,3)));
        ToDateFilter    := CALCDATE('-1D',DMY2DATE(1,DATE2DMY(TODAY,2),DATE2DMY(TODAY,3)));
    end;

    trigger OnPreReport();
    begin
        if FromDateFilter = 0D  then
          ERROR('Period Filter Date is Required');

        IF FromDateFilter IN [0D,0D] THEN
          ERROR('Period Filter Date is Required');

        if ToDateFilter = 0D  then
          ERROR('Period Filter Date is Required');

        IF ToDateFilter IN [0D,0D] THEN
          ERROR('Period Filter Date is Required');
    end;

    var
        CompanyInfoRec : Record "Company Information";
        RequiredHrsVar : Decimal;
        AttendedHrsVar : Decimal;
        ActualAttendedHrsVar : Decimal;
        Sum_RequiredHrsVar : Decimal;
        Sum_AttendedHrsVar : Decimal;
        Sum_ActualAttendedHrsVar : Decimal;
        TotalDaysVar : Integer;
        PeriodFilter : Date;
        FromDateFilter : Date;
        ToDateFilter : Date;
        BetweenFromDate : Date;
        BetweenToDate : Date;
        EmployeeCodeFilter : Code[20];
        EmployeeFullNameFilter : Text[100];
        FromVarianceFilter : Decimal;
        ToVarianceFilter : Decimal;
        FromVarianceAsPunchFilter : Decimal;
        ToVarianceAsPunchFilter : Decimal;
        FromTotalDaysFilter : Integer;
        ToTotalDaysFilter : Integer;
        DailyShiftsCode : Code[10];
        DailyShiftsRec : Record "Daily Shifts";
        CauseCode : Code[20];
        ReportName_CaptionLbl : Label 'Attendance Audit report';
        CompanyRowInformations : Label 'Jal El-Dib,Beirut,Lebanon,phone +961.4.722229,POBox 60-488 Jal El dib ,Metn,Lebanon';
        CompanyName1 : Text[50];
        HRPermission : Record "HR Permissions";
        WDVar : Integer;
        DOVar : Integer;
        ALVar : Integer;
        PLVar : Integer;
        SLVar : Integer;
        TRVar : Integer;
        ADVar : Integer;
        HolidayVar : Integer;
}

