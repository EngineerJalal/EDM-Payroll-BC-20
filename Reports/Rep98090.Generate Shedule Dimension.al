report 98090 "Generate Shedule Dimension"
{
    // version EDM.HRPY2

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            dataitem("Employees Attendance Dimension"; "Employees Attendance Dimension")
            {
                DataItemLink = "Employee No" = FIELD("No.");

                trigger OnAfterGetRecord();
                var
                    EmpDimension: Record "Employee Dimensions";
                    L_EmpAttendDimTbt: Record "Employees Attendance Dimension";
                begin
                    //10.03.2018 : AIM +
                    RunningAttHrs := 0;
                    L_EmpAttendDimTbt.SETRANGE(L_EmpAttendDimTbt."Employee No", "Employees Attendance Dimension"."Employee No");
                    L_EmpAttendDimTbt.SETFILTER(L_EmpAttendDimTbt."Attendance Date", '%1..%2', FAttDate, TAttDate);
                    L_EmpAttendDimTbt.SETRANGE("Global Dimension 1", "Employees Attendance Dimension"."Global Dimension 1");
                    L_EmpAttendDimTbt.SETRANGE("Global Dimension 2", "Employees Attendance Dimension"."Global Dimension 2");
                    L_EmpAttendDimTbt.SETRANGE("Shortcut Dimension 3", "Employees Attendance Dimension"."Shortcut Dimension 3");
                    L_EmpAttendDimTbt.SETRANGE("Shortcut Dimension 4", "Employees Attendance Dimension"."Shortcut Dimension 4");
                    L_EmpAttendDimTbt.SETRANGE("Shortcut Dimension 5", "Employees Attendance Dimension"."Shortcut Dimension 5");
                    L_EmpAttendDimTbt.SETRANGE("Shortcut Dimension 6", "Employees Attendance Dimension"."Shortcut Dimension 6");
                    L_EmpAttendDimTbt.SETRANGE("Shortcut Dimension 7", "Employees Attendance Dimension"."Shortcut Dimension 7");
                    L_EmpAttendDimTbt.SETRANGE("Shortcut Dimension 8", "Employees Attendance Dimension"."Shortcut Dimension 8");
                    L_EmpAttendDimTbt.SETRANGE("Job No.", "Employees Attendance Dimension"."Job No.");
                    L_EmpAttendDimTbt.SETRANGE("Job Task No.", "Employees Attendance Dimension"."Job Task No.");
                    if L_EmpAttendDimTbt.FINDFIRST then
                        repeat
                            RunningAttHrs := RunningAttHrs + L_EmpAttendDimTbt."Attended Hrs";
                        until L_EmpAttendDimTbt.NEXT = 0;
                    //10.03.2018 : AIM -
                    EmpDimension.SETRANGE("Employee No.", "Employees Attendance Dimension"."Employee No");
                    EmpDimension.SETRANGE("Payroll Date", TAttDate);
                    EmpDimension.SETRANGE("Shortcut Dimension 1 Code", "Employees Attendance Dimension"."Global Dimension 1");
                    EmpDimension.SETRANGE("Shortcut Dimension 2 Code", "Employees Attendance Dimension"."Global Dimension 2");
                    EmpDimension.SETRANGE("Shortcut Dimension 3 Code", "Employees Attendance Dimension"."Shortcut Dimension 3");
                    EmpDimension.SETRANGE("Shortcut Dimension 4 Code", "Employees Attendance Dimension"."Shortcut Dimension 4");
                    EmpDimension.SETRANGE("Shortcut Dimension 5 Code", "Employees Attendance Dimension"."Shortcut Dimension 5");
                    EmpDimension.SETRANGE("Shortcut Dimension 6 Code", "Employees Attendance Dimension"."Shortcut Dimension 6");
                    EmpDimension.SETRANGE("Shortcut Dimension 7 Code", "Employees Attendance Dimension"."Shortcut Dimension 7");
                    EmpDimension.SETRANGE("Shortcut Dimension 8 Code", "Employees Attendance Dimension"."Shortcut Dimension 8");
                    // 08.03.2018 : A2+
                    EmpDimension.SETRANGE("Job No.", "Employees Attendance Dimension"."Job No.");
                    EmpDimension.SETRANGE("Job Task No.", "Employees Attendance Dimension"."Job Task No.");
                    // 08.03.2018 : A2-
                    if not EmpDimension.FINDFIRST then begin
                        EmpDimension.INIT;
                        EmpDimension.VALIDATE("Employee No.", "Employees Attendance Dimension"."Employee No");
                        EmpDimension.VALIDATE("Payroll Date", TAttDate);
                        /*// 08.03.2018 : A2+
                        //EmpDimension.VALIDATE(Percentage,("Employees Attendance Dimension"."Attended Hrs" / TotalAttHrs) * 100);
                        IF ("Employees Attendance Dimension"."Attended Hrs" / TotalAttHrs) * 100 < 100 THEN
                          EmpDimension.VALIDATE(Percentage,("Employees Attendance Dimension"."Attended Hrs" / TotalAttHrs) * 100)
                        ELSE
                          EmpDimension.VALIDATE(Percentage,100);
                        // 08.03.2018 : A2-
                        */
                        EmpDimension.VALIDATE(Percentage, ROUND((RunningAttHrs / TotalAttHrs) * 100, 0.01));

                        EmpDimension.VALIDATE("Shortcut Dimension 1 Code", "Employees Attendance Dimension"."Global Dimension 1");
                        EmpDimension.VALIDATE("Shortcut Dimension 2 Code", "Employees Attendance Dimension"."Global Dimension 2");
                        EmpDimension.VALIDATE("Shortcut Dimension 3 Code", "Employees Attendance Dimension"."Shortcut Dimension 3");
                        EmpDimension.VALIDATE("Shortcut Dimension 4 Code", "Employees Attendance Dimension"."Shortcut Dimension 4");
                        EmpDimension.VALIDATE("Shortcut Dimension 5 Code", "Employees Attendance Dimension"."Shortcut Dimension 5");
                        EmpDimension.VALIDATE("Shortcut Dimension 6 Code", "Employees Attendance Dimension"."Shortcut Dimension 6");
                        EmpDimension.VALIDATE("Shortcut Dimension 7 Code", "Employees Attendance Dimension"."Shortcut Dimension 7");
                        EmpDimension.VALIDATE("Shortcut Dimension 8 Code", "Employees Attendance Dimension"."Shortcut Dimension 8");
                        // 08.03.2018 : A2+
                        EmpDimension.VALIDATE("Job No.", "Employees Attendance Dimension"."Job No.");
                        EmpDimension.VALIDATE("Job Task No.", "Employees Attendance Dimension"."Job Task No.");
                        // 08.03.2018 : A2-
                        EmpDimension.INSERT;
                    end
                    else begin
                        // 08.03.2018 : A2+
                        /*//EmpDimension.VALIDATE(Percentage,ROUND(EmpDimension.Percentage,0.01,'=') + ROUND((("Employees Attendance Dimension"."Attended Hrs" / TotalAttHrs) * 100),0.01,'='));
                        IF ROUND(EmpDimension.Percentage,0.01,'=') + ROUND((("Employees Attendance Dimension"."Attended Hrs" / TotalAttHrs) * 100),0.01,'=') < 100 THEN
                          EmpDimension.VALIDATE(Percentage,ROUND(EmpDimension.Percentage,0.01,'=') + ROUND((("Employees Attendance Dimension"."Attended Hrs" / TotalAttHrs) * 100),0.01,'='))
                        ELSE
                          EmpDimension.VALIDATE(Percentage,100);
                          */
                        EmpDimension.VALIDATE(Percentage, ROUND(((RunningAttHrs / TotalAttHrs) * 100), 0.01, '='));
                        // 08.03.2018 : A2-
                        EmpDimension.MODIFY;
                    end;

                end;

                trigger OnPostDataItem();
                var
                    EmpDim: Record "Employee Dimensions";
                begin

                    exit;
                    /*EmpDim.SETRANGE("Employee No.","Employees Attendance Dimension"."Employee No");
                    EmpDim.SETRANGE("Payroll Date",TAttDate);
                    IF EmpDim.FINDFIRST THEN
                    BEGIN
                      REPEAT
                        TotalPerc += EmpDim.Percentage;
                      UNTIL EmpDim.NEXT = 0;
                    END ELSE
                      CurrReport.SKIP;
                    
                    IF TotalPerc < 100 THEN
                    BEGIN
                      EmpDim.RESET;
                      CLEAR(EmpDim);
                      EmpDim.SETRANGE("Employee No.","Employees Attendance Dimension"."Employee No");
                      EmpDim.SETRANGE("Payroll Date",TAttDate);
                      CASE DimNo OF
                        3:
                          BEGIN
                            EmpDim.SETRANGE("Shortcut Dimension 1 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 2 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 3 Code","Employees Attendance Dimension"."Employee No");
                            EmpDim.SETRANGE("Shortcut Dimension 4 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 5 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 6 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 7 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 8 Code",'');
                          END;
                        4:
                          BEGIN
                            EmpDim.SETRANGE("Shortcut Dimension 1 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 2 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 3 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 4 Code","Employees Attendance Dimension"."Employee No");
                            EmpDim.SETRANGE("Shortcut Dimension 5 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 6 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 7 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 8 Code",'');
                          END;
                        5:
                          BEGIN
                            EmpDim.SETRANGE("Shortcut Dimension 1 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 2 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 3 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 4 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 5 Code","Employees Attendance Dimension"."Employee No");
                            EmpDim.SETRANGE("Shortcut Dimension 6 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 7 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 8 Code",'');
                          END;
                        6:
                          BEGIN
                            EmpDim.SETRANGE("Shortcut Dimension 1 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 2 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 3 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 4 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 5 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 6 Code","Employees Attendance Dimension"."Employee No");
                            EmpDim.SETRANGE("Shortcut Dimension 7 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 8 Code",'');
                          END;
                        7:
                          BEGIN
                            EmpDim.SETRANGE("Shortcut Dimension 1 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 2 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 3 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 4 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 5 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 6 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 7 Code","Employees Attendance Dimension"."Employee No");
                            EmpDim.SETRANGE("Shortcut Dimension 8 Code",'');
                          END;
                        8:
                          BEGIN
                            EmpDim.SETRANGE("Shortcut Dimension 1 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 2 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 3 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 4 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 5 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 6 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 7 Code",'');
                            EmpDim.SETRANGE("Shortcut Dimension 8 Code","Employees Attendance Dimension"."Employee No");
                          END;
                      END;
                    
                      IF NOT EmpDim.FINDFIRST THEN
                        BEGIN
                          EmpDim.INIT;
                          EmpDim.VALIDATE("Employee No.","Employees Attendance Dimension"."Employee No");
                          EmpDim.VALIDATE("Payroll Date",TAttDate);
                          EmpDim.VALIDATE(Percentage,ROUND((100 - TotalPerc),0.01,'='));
                    
                          CASE DimNo OF
                            1:
                              EmpDim.VALIDATE("Shortcut Dimension 1 Code","Employees Attendance Dimension"."Employee No");
                            2:
                              EmpDim.VALIDATE("Shortcut Dimension 2 Code","Employees Attendance Dimension"."Employee No");
                            3:
                              EmpDim.VALIDATE("Shortcut Dimension 3 Code","Employees Attendance Dimension"."Employee No");
                            4:
                              EmpDim.VALIDATE("Shortcut Dimension 4 Code","Employees Attendance Dimension"."Employee No");
                            5:
                              EmpDim.VALIDATE("Shortcut Dimension 5 Code","Employees Attendance Dimension"."Employee No");
                            6:
                              EmpDim.VALIDATE("Shortcut Dimension 6 Code","Employees Attendance Dimension"."Employee No");
                            7:
                              EmpDim.VALIDATE("Shortcut Dimension 7 Code","Employees Attendance Dimension"."Employee No");
                            8:
                              EmpDim.VALIDATE("Shortcut Dimension 8 Code","Employees Attendance Dimension"."Employee No");
                          END;
                    
                          EmpDim.INSERT
                        END
                      ELSE
                        BEGIN
                          EmpDim.VALIDATE(Percentage,ROUND(100 - TotalPerc + EmpDim.Percentage,0.001,'>'));
                          EmpDim.MODIFY;
                        END;
                    END;
                    */

                end;

                trigger OnPreDataItem();
                begin
                    "Employees Attendance Dimension".SETFILTER("Employees Attendance Dimension"."Attendance Date", '%1..%2', FAttDate, TAttDate);
                    //08.03.2018 : A2+
                    "Employees Attendance Dimension".SETFILTER("Employees Attendance Dimension"."Attended Hrs", '<>%1', 0)
                    //08.03.2018 : A2-
                end;
            }

            trigger OnAfterGetRecord();
            var
                EmpDim: Record "Employee Dimensions";
                EmpAttDim: Record "Employees Attendance Dimension";
                EmpAbs: Record "Employee Absence";
            begin
                FixEmployeeAttendanceDimensionsRecords(Employee."No.", FAttDate, TAttDate);
                TotalAttHrs := 0;
                TotalPerc := 0;

                RunningAttHrs := 0; //10.03.2018 : AIM +

                if Employee.Status <> Employee.Status::Active then
                    CurrReport.SKIP;

                if Employee.Period = 0D then CurrReport.SKIP;

                if TAttDate < Employee.Period then
                    CurrReport.SKIP;

                if TAttDate - Employee.Period > 31 then
                    CurrReport.SKIP;

                //Modified to read from Attendance Dimension - 10.03.2018 : AIM +
                /*EmpAbs.SETRANGE("Employee No.",Employee."No.");
                EmpAbs.SETFILTER("From Date",'%1..%2',FAttDate,TAttDate);
                IF EmpAbs.FINDFIRST THEN
                  REPEAT
                    TotalAttHrs += EmpAbs."Attend Hrs.";
                  UNTIL EmpAbs.NEXT = 0;
                  */
                EmpAttDim.SETRANGE(EmpAttDim."Employee No", Employee."No.");
                EmpAttDim.SETFILTER(EmpAttDim."Attendance Date", '%1..%2', FAttDate, TAttDate);
                if EmpAttDim.FINDFIRST then
                    repeat
                        TotalAttHrs += EmpAttDim."Attended Hrs";
                    until EmpAttDim.NEXT = 0;
                if TotalAttHrs <= 0 then
                    CurrReport.SKIP;
                //Modified to read from Attendance Dimension - 10.03.2018 : AIM -

                EmpDim.SETRANGE("Employee No.", Employee."No.");
                EmpDim.SETRANGE("Payroll Date", TAttDate);
                if EmpDim.FINDFIRST then
                    CurrReport.SKIP;

            end;

            trigger OnPreDataItem();
            begin
                DimNo := PayFunction.GetShortcutDimensionNoFromName('EMPLOYEE');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Requested Parameter")
                {
                    field("Period Start Date"; FAttDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Period End Date"; TAttDate)
                    {
                        ApplicationArea = All;
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

    var
        PayDate: Date;
        PayFunction: Codeunit "Payroll Functions";
        TotalAttHrs: Decimal;
        FAttDate: Date;
        TAttDate: Date;
        TotalPerc: Decimal;
        DimNo: Integer;
        RunningAttHrs: Decimal;
        HRSetupTbt: Record "Human Resources Setup";

    local procedure FixEmployeeAttendanceDimensionsRecords(EmpNo: Code[50]; FDate: Date; TDate: Date);
    var
        L_EmpAttDimTbt: Record "Employees Attendance Dimension";
        L_EmployeeDimNo: Integer;
        L_ProjectDimNo: Integer;
    begin
        HRSetupTbt.RESET;
        HRSetupTbt.GET();
        L_EmployeeDimNo := PayFunction.GetShortcutDimensionNoFromName('Employee');
        L_ProjectDimNo := PayFunction.GetShortcutDimensionNoFromName('PROJECT');
        L_EmpAttDimTbt.SETRANGE(L_EmpAttDimTbt."Employee No", EmpNo);
        L_EmpAttDimTbt.SETFILTER(L_EmpAttDimTbt."Attendance Date", '%1..%2', FDate, TDate);
        if L_EmpAttDimTbt.FINDFIRST then
            repeat
                if L_EmployeeDimNo = 3 then
                    L_EmpAttDimTbt."Shortcut Dimension 3" := L_EmpAttDimTbt."Employee No"
                else
                    if L_EmployeeDimNo = 4 then
                        L_EmpAttDimTbt."Shortcut Dimension 4" := L_EmpAttDimTbt."Employee No"
                    else
                        if L_EmployeeDimNo = 5 then
                            L_EmpAttDimTbt."Shortcut Dimension 5" := L_EmpAttDimTbt."Employee No"
                        else
                            if L_EmployeeDimNo = 6 then
                                L_EmpAttDimTbt."Shortcut Dimension 6" := L_EmpAttDimTbt."Employee No"
                            else
                                if L_EmployeeDimNo = 7 then
                                    L_EmpAttDimTbt."Shortcut Dimension 7" := L_EmpAttDimTbt."Employee No"
                                else
                                    if L_EmployeeDimNo = 8 then
                                        L_EmpAttDimTbt."Shortcut Dimension 8" := L_EmpAttDimTbt."Employee No";

                if L_EmpAttDimTbt."Job No." <> '' then begin
                    if L_ProjectDimNo = 3 then
                        L_EmpAttDimTbt."Shortcut Dimension 3" := L_EmpAttDimTbt."Job No."
                    else
                        if L_ProjectDimNo = 4 then
                            L_EmpAttDimTbt."Shortcut Dimension 4" := L_EmpAttDimTbt."Job No."
                        else
                            if L_ProjectDimNo = 5 then
                                L_EmpAttDimTbt."Shortcut Dimension 5" := L_EmpAttDimTbt."Job No."
                            else
                                if L_ProjectDimNo = 6 then
                                    L_EmpAttDimTbt."Shortcut Dimension 6" := L_EmpAttDimTbt."Job No."
                                else
                                    if L_ProjectDimNo = 7 then
                                        L_EmpAttDimTbt."Shortcut Dimension 7" := L_EmpAttDimTbt."Job No."
                                    else
                                        if L_ProjectDimNo = 8 then
                                            L_EmpAttDimTbt."Shortcut Dimension 8" := L_EmpAttDimTbt."Job No.";
                end;
                L_EmpAttDimTbt.MODIFY;
            until L_EmpAttDimTbt.NEXT = 0;
    end;
}

