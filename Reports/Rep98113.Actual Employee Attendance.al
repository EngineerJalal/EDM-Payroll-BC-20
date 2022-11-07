report 98113 "Actual Employee Attendance"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Actual Employee Attendance.rdlc';

    dataset
    {
        dataitem("Employee Absence";"Employee Absence")
        {
            RequestFilterFields = "Employee No.";
            column(PunchNo;PunchNo)
            {
            }
            column(StartDate;StartDate)
            {
            }
            column(EndDate;EndDate)
            {
            }
            column(Employee_No_;"Employee No.")
            {
            }
            column(Employee_Name;"Employee Name")
            {
            }
            column(From_Date;"From Date")
            {
            }
            column(Shift_Code;"Shift Code")
            {
            }
            column(Attend_Hrs_;"Attend Hrs.")
            {
            }
            column(Required_Hrs;"Required Hrs")
            {
            }
            column(Late_Arrive;"Late Arrive")
            { 
            }
            column(Actual_Attend_Hrs;"Actual Attend Hrs")
            {
            }
            column(Actual_Early_Arrive;"Actual Early Arrive")
            { 
            }
            column(Actual_Early_Leave;"Actual Early Leave")
            {
            }
            column(Actual_Late_Arrive;"Actual Late Arrive")
            {
            }            
            column(Actual_Late_Leave;"Actual Late Leave")
            {
            }   
            column(DifferanceTimeFormatVar;DifferanceTimeFormatVar)
            {
            }
            column(TotalActAttHours;TotalActAttHours) 
            {
            }            
            column(TotalActEarlyArrive;TotalActEarlyArrive) 
            {
            }            
            column(TotalActEarlyLeave;TotalActEarlyLeave) 
            {
            }            
            column(TotalActLateArrive;TotalActLateArrive)
            {
            }            
            column(TotalActLateLeave;TotalActLateLeave)
            {
            }            
            column(TotalAttHours;TotalAttHours) 
            {
            }            
            column(TotalLateArrive;TotalLateArrive)
            {
            }            
            column(TotalReqHours;TotalReqHours)
            {
            }         
            column(TotalDifferanceTimeFormatVar;TotalDifferanceTimeFormatVar)
            {
            }           
            dataitem("Hand Punch";"Hand Punch")
            {
                DataItemLink = "Attendnace No." = field("Attendance No."),"Real Date" = field ("From Date");               
                column(Real_Time;"Real Time")
                {
                }
                column(Action_Type;"Action Type")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PunchNo := INCSTR(PunchNo);
                    HandPunchCnt := "Hand Punch".Count;
                    I += 1;

                    if "Attendnace No." = 0 then 
                        CurrReport.Skip;

                    IF (I = HandPunchCnt) OR (HandPunchCnt = 0) THEN BEGIN
                        EmployeeAbsence.SETRANGE("Employee No.","Employee Absence"."Employee No.");
                        EmployeeAbsence.SETRANGE("From Date","Employee Absence"."From Date");
                    end;
                end;

                trigger OnPreDataItem();
                begin

                end;
            }
            trigger OnPreDataItem();
            begin
                "Employee Absence".SetRange("From Date",StartDate,EndDate);
            end;

            trigger OnAfterGetRecord();
            var
                myInt : Integer;
            begin
                PunchNo := 'IN000';
                I := 0;

                ResetVariable();  

                IF "Employee Absence"."Attend Hrs." - "Employee Absence"."Required Hrs" >= 0 THEN
                    DifferanceTimeFormatVar := ConvertToTimeFormat(("Employee Absence"."Attend Hrs." - "Employee Absence"."Required Hrs") * 3600000)
                ELSE
                    DifferanceTimeFormatVar := '- ' + ConvertToTimeFormat(ABS(("Employee Absence"."Attend Hrs." - "Employee Absence"."Required Hrs") * 3600000));
               
                EmployeeAbsence.Reset;
                EmployeeAbsence.SETRANGE("Employee No.","Employee Absence"."Employee No.");
                EmployeeAbsence.SETRANGE("From Date",StartDate,EndDate);
                IF EmployeeAbsence.FindFirst THEN repeat
                    TotalActAttHours += EmployeeAbsence."Actual Attend Hrs";
                    TotalActEarlyArrive += EmployeeAbsence."Actual Early Arrive";
                    TotalActEarlyLeave += EmployeeAbsence."Actual Early Leave";
                    TotalActLateArrive += EmployeeAbsence."Actual Late Arrive";
                    TotalActLateLeave += EmployeeAbsence."Actual Late Leave";
                    TotalAttHours += EmployeeAbsence."Attend Hrs.";
                    TotalLateArrive += EmployeeAbsence."Late Arrive";
                    TotalReqHours += EmployeeAbsence."Required Hrs";

                    IF EmployeeAbsence."Attend Hrs." - EmployeeAbsence."Required Hrs" >= 0 THEN
                        TotalDifferance += EmployeeAbsence."Attend Hrs." - EmployeeAbsence."Required Hrs"
                    else TotalDifferance -= EmployeeAbsence."Required Hrs" - EmployeeAbsence."Attend Hrs.";

                    if TotalDifferance >= 0 then
                        TotalDifferanceTimeFormatVar := ConvertToTimeFormat(TotalDifferance * 3600000)
                    else TotalDifferanceTimeFormatVar := '-' + ConvertToTimeFormat(ABS(TotalDifferance) * 3600000);
                until EmployeeAbsence.Next = 0;
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

        end;
    }

    trigger OnPreReport();
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
          ERROR(BlankStartEndDateErr);
    end;

    local procedure ConvertToTimeFormat(Diff : Decimal) Val : Text
    var
        DiffMinutes : Decimal;
        H : Decimal;
        M : Decimal;
    begin
        H := 0;
        M := 0;

        DiffMinutes :=  Diff / 60000;
        H := DiffMinutes DIV 60;
        DiffMinutes := DiffMinutes - (H * 60);

        IF DiffMinutes > 0 THEN
        M := ROUND(DiffMinutes,1,'>');

        IF H <= 9 THEN
        Val := '0' + FORMAT(H)
        ELSE
        Val := FORMAT(H);

        IF M <= 9 THEN
        Val := Val + ':' + '0' + FORMAT(M)
        ELSE
        Val := Val + ':' + FORMAT(M);

        EXIT (Val);
    end;

    local procedure ResetVariable()
    begin
        TotalActAttHours := 0;
        TotalActEarlyArrive := 0;
        TotalActEarlyLeave := 0;
        TotalActLateArrive := 0;
        TotalActLateLeave := 0;
        TotalAttHours := 0;
        TotalDifferance := 0;
        TotalDifferanceTimeFormatVar := '';
        TotalLateArrive := 0;
        TotalReqHours := 0;
    end;

    var
        EmployeeAbsence : Record "Employee Absence";
        StartDate : Date;
        EndDate : Date;
        PunchNo : Code [20];
        HandPunchCnt : Integer;
        I : Integer;
        Differance : Decimal;
        DifferanceTimeFormatVar : text[50];
        TotalDifferanceTimeFormatVar : text[50];
        TotalReqHours : Decimal;
        TotalAttHours : Decimal;
        TotalActAttHours : Decimal;
        TotalLateArrive : Decimal;
        TotalActLateArrive : Decimal;
        TotalActEarlyArrive : Decimal;
        TotalActLateLeave : Decimal;
        TotalActEarlyLeave : Decimal;  
        TotalDifferance : Decimal;                           
        BlankStartEndDateErr : Label 'Starting date and ending date must be defined.';
}

