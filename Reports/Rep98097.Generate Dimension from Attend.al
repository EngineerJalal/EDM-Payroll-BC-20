report 98097 "Generate Dimension from Attend"
{
    // version EDM.HRPY1

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            dataitem("Employee Absence";"Employee Absence")
            {
                DataItemLink = "Employee No."=FIELD("No.");

                trigger OnAfterGetRecord();
                begin

                    if "Employee Absence"."Global Dimension 1 Code" <> '' then
                      Dim1Value := "Employee Absence"."Global Dimension 1 Code"
                    else
                      Dim1Value := Employee."Global Dimension 1 Code";
                    if "Employee Absence"."Global Dimension 2 Code" <> '' then
                      Dim2Value := "Employee Absence"."Global Dimension 2 Code"
                    else
                      Dim2Value := Employee."Global Dimension 2 Code";

                    EmployeeMonthlyAttendHours := GetEmployeeMonthlyAttendHours("Employee Absence"."Employee No.");
                    if EmployeeMonthlyAttendHours <= 0 then
                      CurrReport.SKIP;

                    if "Employee Absence"."Attend Hrs." <= 0 then
                      CurrReport.SKIP;


                    EmployeeDimensions.RESET;
                    CLEAR(EmployeeDimensions);
                    EmployeeDimensions.SETRANGE(EmployeeDimensions."Employee No.","Employee Absence"."Employee No.");
                    // 29.09.2017 : A2+
                    //EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",CALCDATE('CM',PayrollDate));
                    //EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",PayrollDate);
                    EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",TDate);
                    // 29.09.2017 : A2-

                    if Dim1Value <> '' then // Added to prevent filter if Dim1 has no value - 10.03.2018 : AIM +-
                       EmployeeDimensions.SETRANGE(EmployeeDimensions."Shortcut Dimension 1 Code",Dim1Value);
                    if Dim2Value <> '' then // Added to prevent filter if Dim2 has no value - 10.03.2018 : AIM +-
                       EmployeeDimensions.SETRANGE(EmployeeDimensions."Shortcut Dimension 2 Code",Dim2Value);

                    if not EmployeeDimensions.FINDFIRST then
                      begin
                        EmployeeDimensions.INIT;
                        EmployeeDimensions."Employee No." := "Employee Absence"."Employee No.";
                        // 29.09.2017 : A2+
                        //EmployeeDimensions."Payroll Date" := CALCDATE('CM',PayrollDate);
                        //EmployeeDimensions."Payroll Date" := PayrollDate;
                        EmployeeDimensions."Payroll Date" := TDate;
                        // 29.09.2017 : A2-
                        EmployeeDimensions."Shortcut Dimension 1 Code" := Dim1Value;
                        EmployeeDimensions."Shortcut Dimension 2 Code" := Dim2Value;

                        EmployeeDimensions.Percentage := ("Employee Absence"."Attend Hrs." * 100) / EmployeeMonthlyAttendHours;

                        if EmployeeDimNo = 3 then
                          EmployeeDimensions."Shortcut Dimension 3 Code" := EmployeeDimCode
                        else
                          EmployeeDimensions."Shortcut Dimension 3 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee Absence"."Employee No.",3);
                        if EmployeeDimNo = 4 then
                          EmployeeDimensions."Shortcut Dimension 4 Code" := EmployeeDimCode
                        else
                          EmployeeDimensions."Shortcut Dimension 4 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee Absence"."Employee No.",4);
                        if EmployeeDimNo = 5 then
                          EmployeeDimensions."Shortcut Dimension 5 Code" := EmployeeDimCode
                        else
                          EmployeeDimensions."Shortcut Dimension 5 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee Absence"."Employee No.",5);
                        if EmployeeDimNo = 6 then
                          EmployeeDimensions."Shortcut Dimension 6 Code" := EmployeeDimCode
                        else
                          EmployeeDimensions."Shortcut Dimension 6 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee Absence"."Employee No.",6);
                        //Added in order to consider dimensions 7 & 8 - 22.03.2017 : AIM +
                        if EmployeeDimNo = 7 then
                          EmployeeDimensions."Shortcut Dimension 7 Code" := EmployeeDimCode
                        else
                          EmployeeDimensions."Shortcut Dimension 7 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee Absence"."Employee No.",7);
                        if EmployeeDimNo = 8 then
                          EmployeeDimensions."Shortcut Dimension 8 Code" := EmployeeDimCode
                        else
                          EmployeeDimensions."Shortcut Dimension 8 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee Absence"."Employee No.",8);
                        //Added in order to consider dimensions 7 & 8 - 22.03.2017 : AIM -
                        //Modified to consider code in EmployeeDimensions.OnInsert - 10.03.2018 : AIM +
                        //EmployeeDimensions.INSERT;
                        EmployeeDimensions.INSERT(true);
                        //Modified to consider code in EmployeeDimensions.OnInsert - 10.03.2018 : AIM -
                      end
                    else
                      begin
                        EmployeeDimensions.Percentage := (((EmployeeDimensions.Percentage * EmployeeMonthlyAttendHours) / 100 + "Employee Absence"."Attend Hrs.")
                                                        * 100) / EmployeeMonthlyAttendHours;
                        EmployeeDimensions.MODIFY;
                      end;
                end;

                trigger OnPreDataItem();
                begin
                    // 29.09.2017 : A2+
                    //"Employee Absence".SETFILTER("From Date",'%1..%2',DMY2DATE(1,DATE2DMY(PayrollDate,2),DATE2DMY(PayrollDate,3)),
                    //                              DMY2DATE(DATE2DMY(CALCDATE('CM',PayrollDate),1),DATE2DMY(PayrollDate,2),DATE2DMY(PayrollDate,3)));
                    //"Employee Absence".SETFILTER("From Date",'%1..%2',DMY2DATE(1,DATE2DMY(PayrollDate,2),DATE2DMY(PayrollDate,3)),
                    //                              DMY2DATE(DATE2DMY(PayrollDate,1),DATE2DMY(PayrollDate,2),DATE2DMY(PayrollDate,3)));
                    "Employee Absence".SETFILTER("From Date",'%1..%2',FDate,TDate);
                    // 29.09.2017 : A2-
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if Employee.Status <> Employee.Status::Active then
                  CurrReport.SKIP;

                if Employee.Period = 0D then CurrReport.SKIP;

                //IF PayrollDate < Employee.Period THEN
                if TDate < Employee.Period then
                  CurrReport.SKIP;

                //IF PayrollDate - Employee.Period > 31 THEN
                if TDate - Employee.Period > 31 then
                  CurrReport.SKIP;

                EmployeeDimensions.RESET;
                CLEAR(EmployeeDimensions);
                EmployeeDimensions.SETRANGE(EmployeeDimensions."Employee No.",Employee."No.");
                // 29.09.2017 : A2+
                //EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",CALCDATE('CM',PayrollDate));
                //EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",PayrollDate);
                EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",TDate);
                // 29.09.2017 : A2-
                if EmployeeDimensions.FINDFIRST then
                 CurrReport.SKIP;


                EmployeeDimNo := PayrollFunctions.GetShortcutDimensionNoFromName('Employee');
                EmployeeDimCode := '';

                if Employee."Related to" <> '' then
                  EmployeeDimCode := Employee."Related to"
                else
                  EmployeeDimCode := Employee."No.";

                if IgnoreEmployeesWithNoAttendance = false then
                    //InsertDimensionForEmpWithNoAttend(PayrollDate);
                    InsertDimensionForEmpWithNoAttend(TDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Period Start Date";FDate)
                {
                    ApplicationArea=All;
                }
                field("Period End Date";TDate)
                {
                    ApplicationArea=All;
                }
                field("Ignore Emp With No Attendance";IgnoreEmployeesWithNoAttendance)
                {
                    ApplicationArea=All;
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
        
        /*IF PayrollDate = 0D THEN
          ERROR('Please Select Date');*/
        if (FDate = 0D) or (TDate = 0D) then
          ERROR('Please Select Date');

    end;

    var
        PayrollDate : Date;
        EmployeeDimensions : Record "Employee Dimensions";
        EmployeeMonthlyAttendHours : Decimal;
        PayrollFunctions : Codeunit "Payroll Functions";
        Dim1Value : Code[20];
        Dim2Value : Code[20];
        EmployeeDimNo : Integer;
        EmpDimValue : Code[20];
        EmployeeDimCode : Code[20];
        IgnoreEmployeesWithNoAttendance : Boolean;
        EmpAbsTbt : Record "Employee Absence";
        FDate : Date;
        TDate : Date;

    local procedure GetEmployeeMonthlyAttendHours(EmployeeNo : Code[20]) Result : Decimal;
    var
        EmployeeAbsence_Local : Record "Employee Absence";
    begin


        EmployeeAbsence_Local.RESET;
        EmployeeAbsence_Local.SETRANGE(EmployeeAbsence_Local."Employee No.",EmployeeNo);

        if Employee.Period <> 0D then
          EmployeeAbsence_Local.SETRANGE(Period,Employee.Period)
        else
          exit(0);


        if not EmployeeAbsence_Local.FIND('-') then
          exit(0);

        repeat
          Result := Result + EmployeeAbsence_Local."Attend Hrs.";
        until EmployeeAbsence_Local.NEXT = 0;

        exit(Result);
    end;

    local procedure InsertDimensionForEmpWithNoAttend(DimDate : Date);
    begin

        if DimDate < Employee.Period then
          CurrReport.SKIP;

        if DimDate - Employee.Period > 31 then
          CurrReport.SKIP;

        EmpAbsTbt.SETRANGE(EmpAbsTbt."Employee No.",Employee."No.");
        EmpAbsTbt.SETRANGE(EmpAbsTbt.Period,Employee.Period);
        if EmpAbsTbt.FINDFIRST = false then
         begin

              Dim1Value := Employee."Global Dimension 1 Code";
              Dim2Value := Employee."Global Dimension 2 Code";

              EmployeeDimensions.RESET;
              CLEAR(EmployeeDimensions);

              EmployeeDimensions.SETRANGE(EmployeeDimensions."Employee No.",Employee."No.");
              // 29.09.2017 : A2+
              //EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",CALCDATE('CM',PayrollDate));
              //EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",PayrollDate);
              EmployeeDimensions.SETRANGE(EmployeeDimensions."Payroll Date",TDate);
              // 29.09.2017 : A2-
              if Dim1Value <> '' then // Added to prevent filter if Dim1 has no value - 10.03.2018 : AIM +-
                 EmployeeDimensions.SETRANGE(EmployeeDimensions."Shortcut Dimension 1 Code",Dim1Value);
              if Dim2Value <> '' then // Added to prevent filter if Dim2 has no value - 10.03.2018 : AIM +-
                 EmployeeDimensions.SETRANGE(EmployeeDimensions."Shortcut Dimension 2 Code",Dim2Value);

              if not EmployeeDimensions.FINDFIRST then
                begin
                  EmployeeDimensions.INIT;
                  EmployeeDimensions."Employee No." := Employee."No.";
                  // 29.09.2017 : A2+
                  //EmployeeDimensions."Payroll Date" := CALCDATE('CM',PayrollDate);
                  //EmployeeDimensions."Payroll Date" := PayrollDate;
                  EmployeeDimensions."Payroll Date" := TDate;
                  // 29.09.2017 : A2-
                  EmployeeDimensions."Shortcut Dimension 1 Code" := Dim1Value;
                  EmployeeDimensions."Shortcut Dimension 2 Code" := Dim2Value;
                  EmployeeDimensions.Percentage := 100;

                  if EmployeeDimNo = 3 then
                    EmployeeDimensions."Shortcut Dimension 3 Code" := EmployeeDimCode
                  else
                    EmployeeDimensions."Shortcut Dimension 3 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue(Employee."No.",3);
                  if EmployeeDimNo = 4 then
                    EmployeeDimensions."Shortcut Dimension 4 Code" := EmployeeDimCode
                  else
                    EmployeeDimensions."Shortcut Dimension 4 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue(Employee."No.",4);
                  if EmployeeDimNo = 5 then
                    EmployeeDimensions."Shortcut Dimension 5 Code" := EmployeeDimCode
                  else
                    EmployeeDimensions."Shortcut Dimension 5 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue(Employee."No.",5);
                  if EmployeeDimNo = 6 then
                    EmployeeDimensions."Shortcut Dimension 6 Code" := EmployeeDimCode
                  else
                    EmployeeDimensions."Shortcut Dimension 6 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue(Employee."No.",6);
                  //Added in order to consider dimensions 7 & 8 - 22.03.2017 : AIM +
                  if EmployeeDimNo = 7 then
                    EmployeeDimensions."Shortcut Dimension 7 Code" := EmployeeDimCode
                  else
                    EmployeeDimensions."Shortcut Dimension 7 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue(Employee."No.",7);
                  if EmployeeDimNo = 8 then
                    EmployeeDimensions."Shortcut Dimension 8 Code" := EmployeeDimCode
                  else
                    EmployeeDimensions."Shortcut Dimension 8 Code" := PayrollFunctions.GetEmployeeShortcutDimensionValue(Employee."No.",8);
                  //Added in order to consider dimensions 7 & 8 - 22.03.2017 : AIM -
                  //Modified to consider code in EmployeeDimensions.OnInsert - 10.03.2018 : AIM +
                  //EmployeeDimensions.INSERT;
                  EmployeeDimensions.INSERT(true);
                  //Modified to consider code in EmployeeDimensions.OnInsert - 10.03.2018 : AIM -
                end;
          end;
    end;
}

