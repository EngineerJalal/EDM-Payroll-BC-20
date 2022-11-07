report 98105 "Auto Apply Salary Raise"
{
    // version EDM.HRPY1
    ProcessingOnly = true;

    dataset
    {
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

    trigger OnPostReport();
    begin
        ApplySalaryRaise;
    end;

    var
        EmployeeSalaryHistrory: Record "Employee Salary History";
        HRSetup: Record "Human Resources Setup";
        EmpAddInfoTbt: Record "Employee Additional Info";
        EmployeeRelatedRec: Record Employee;
        PayrollFunctions: Codeunit "Payroll Functions";
        WorkingHrsPerMonth: Decimal;
        EmployeeRec: Record Employee;
        EmpTbt: Record Employee;

    local procedure ApplySalaryRaise();
    var
        WorkingHrsPerMonth: Decimal;
        HourlyRateval: Decimal;
        WorkingHrsPerDay: Decimal;
        DailyRateVal: Decimal;
    begin
        //first must check if auto apply from hr setup 2017-06-20 SC+
        HRSetup.FINDFIRST;
        IF HRSetup."Auto Apply Salary Raise" THEN BEGIN
            //loop over approved requests that are still not processed 2017-06-20 SC+
            EmployeeSalaryHistrory.RESET;
            EmployeeSalaryHistrory.SETRANGE("Change Status", EmployeeSalaryHistrory."Change Status"::Approved);
            EmployeeSalaryHistrory.SETRANGE(Processed, FALSE);
            EmployeeSalaryHistrory.SETFILTER("Salary Start Date", '<= %1', WORKDATE);
            IF EmployeeSalaryHistrory.FINDFIRST THEN BEGIN
                //2017-06-20 SC+
                EmployeeSalaryHistrory.Processed := TRUE;
                EmployeeSalaryHistrory.MODIFY;
                //2017-06-20 SC-
                // 08.03.2017 : A2+
                IF EmployeeSalaryHistrory."Hourly Rate Or Not" = FALSE THEN BEGIN
                    // 08.03.2017 : A2-
                    WorkingHrsPerMonth := PayrollFunctions.GetEmployeeMonthlyHours(EmployeeSalaryHistrory."Employee No.", '');
                    IF WorkingHrsPerMonth <= 0 THEN
                        HourlyRateval := 0
                    ELSE
                        HourlyRateval := ROUND((EmployeeSalaryHistrory."Basic Pay" + EmployeeSalaryHistrory."Basic Pay Rel") / WorkingHrsPerMonth, 0.01);
                    EmployeeSalaryHistrory."Hourly Rate" := HourlyRateval;
                    EmployeeSalaryHistrory.MODIFY;
                    // 08.03.2017 : A2+
                END
                ELSE BEGIN
                    HourlyRateval := EmployeeSalaryHistrory."Hourly Rate";
                END;
                // 08.03.2017 : A2-

                WorkingHrsPerDay := PayrollFunctions.GetEmployeeDailyHours(EmployeeSalaryHistrory."Employee No.", '');
                IF WorkingHrsPerDay <= 0 THEN
                    DailyRateVal := 0
                ELSE
                    DailyRateVal := ROUND((EmployeeSalaryHistrory."Basic Pay" + EmployeeSalaryHistrory."Basic Pay Rel") / WorkingHrsPerDay, 0.01);

                IF EmployeeSalaryHistrory."Amount In USD" = TRUE THEN BEGIN
                    HourlyRateval := ExchEquivAmountInLCY(HourlyRateval);
                    DailyRateVal := ExchEquivAmountInLCY(DailyRateVal);
                END;

                IF (EmployeeRec.GET(EmployeeSalaryHistrory."Employee No.")) AND (EmployeeSalaryHistrory."Source Type" = EmployeeSalaryHistrory."Source Type"::"Raise Request") THEN BEGIN
                    IF EmployeeSalaryHistrory."Amount In USD" = FALSE THEN BEGIN
                        EmployeeRec.VALIDATE(EmployeeRec."Basic Pay", EmployeeSalaryHistrory."Basic Pay");
                        EmployeeRec.VALIDATE(EmployeeRec."Phone Allowance", EmployeeSalaryHistrory."Phone Allowance");
                        EmployeeRec.VALIDATE(EmployeeRec."Car Allowance", EmployeeSalaryHistrory."Car Allowance");
                        EmployeeRec.VALIDATE(EmployeeRec."Cost of Living", EmployeeSalaryHistrory."Cost of Living");
                        EmployeeRec.VALIDATE(EmployeeRec."Food Allowance", EmployeeSalaryHistrory."Food Allowance");
                        EmployeeRec.VALIDATE(EmployeeRec."Ticket Allowance", EmployeeSalaryHistrory."Ticket Allowance");
                        EmployeeRec.VALIDATE(EmployeeRec."House Allowance", EmployeeSalaryHistrory."House Allowance");
                        EmployeeRec.VALIDATE(EmployeeRec."Other Allowances", EmployeeSalaryHistrory."Other Allowance");
                    END
                    ELSE BEGIN
                        EmployeeRec.VALIDATE(EmployeeRec."Basic Pay", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Basic Pay"));
                        EmployeeRec.VALIDATE(EmployeeRec."Phone Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Phone Allowance"));
                        EmployeeRec.VALIDATE(EmployeeRec."Car Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Car Allowance"));
                        EmployeeRec.VALIDATE(EmployeeRec."Cost of Living", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Cost of Living"));
                        EmployeeRec.VALIDATE(EmployeeRec."Food Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Food Allowance"));
                        EmployeeRec.VALIDATE(EmployeeRec."Ticket Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Ticket Allowance"));
                        EmployeeRec.VALIDATE(EmployeeRec."House Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."House Allowance"));
                        EmployeeRec.VALIDATE(EmployeeRec."Other Allowances", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Other Allowance"));
                    END;

                    EmployeeRec.VALIDATE(EmployeeRec."Hourly Rate", HourlyRateval);
                    EmployeeRec.VALIDATE(EmployeeRec."Daily Rate", DailyRateVal);

                    EmployeeRec.MODIFY(TRUE);

                    EmpAddInfoTbt.SETRANGE(EmpAddInfoTbt."Employee No.", EmployeeSalaryHistrory."Employee No.");
                    IF NOT EmpAddInfoTbt.FINDFIRST THEN BEGIN
                        EmpAddInfoTbt.INIT;
                        EmpAddInfoTbt."Employee No." := EmployeeSalaryHistrory."Employee No.";
                        EmpAddInfoTbt."Bonus System" := EmployeeSalaryHistrory."Bonus System";
                        EmpAddInfoTbt.INSERT;
                    END
                    ELSE BEGIN
                        EmpAddInfoTbt."Bonus System" := EmployeeSalaryHistrory."Bonus System";
                        EmpAddInfoTbt.MODIFY;
                    END;

                    EmployeeRelatedRec.SETRANGE("Related to", EmployeeRec."No.");
                    EmployeeRelatedRec.SETFILTER(EmployeeRelatedRec."No.", '<>%1', EmployeeRec."No.");
                    IF EmployeeRelatedRec.FINDFIRST THEN BEGIN
                        EmpAddInfoTbt.RESET;
                        CLEAR(EmpTbt);
                        EmpAddInfoTbt.SETRANGE(EmpAddInfoTbt."Employee No.", EmployeeRelatedRec."No.");
                        IF NOT EmpAddInfoTbt.FINDFIRST THEN BEGIN
                            EmpAddInfoTbt.INIT;
                            EmpAddInfoTbt."Employee No." := EmployeeRelatedRec."No.";
                            EmpAddInfoTbt."Bonus System" := EmployeeSalaryHistrory."Bonus System";
                            EmpAddInfoTbt.INSERT;
                        END
                        ELSE BEGIN
                            EmpAddInfoTbt."Bonus System" := EmployeeSalaryHistrory."Bonus System";
                            EmpAddInfoTbt.MODIFY;
                        END;
                        IF EmployeeSalaryHistrory."Amount In USD" = FALSE THEN BEGIN
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Basic Pay", EmployeeSalaryHistrory."Basic Pay Rel");
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Phone Allowance", EmployeeSalaryHistrory."Phone Rel");
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Car Allowance", EmployeeSalaryHistrory."Car Rel");
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Cost of Living", EmployeeSalaryHistrory."Cost of Living Rel");
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Food Allowance", EmployeeSalaryHistrory."Food Rel");
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Ticket Allowance", EmployeeSalaryHistrory."Ticket Rel");
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."House Allowance", EmployeeSalaryHistrory."House Rel");
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Other Allowances", EmployeeSalaryHistrory."Other Rel");
                        END
                        ELSE BEGIN
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Basic Pay", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Basic Pay Rel"));
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Phone Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Phone Rel"));
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Car Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Car Rel"));
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Cost of Living", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Cost of Living Rel"));
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Food Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Food Rel"));
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Ticket Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Ticket Rel"));
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."House Allowance", ExchEquivAmountInLCY(EmployeeSalaryHistrory."House Rel"));
                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Other Allowances", ExchEquivAmountInLCY(EmployeeSalaryHistrory."Other Rel"));
                        END;

                        EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Hourly Rate", HourlyRateval);
                        EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Daily Rate", DailyRateVal);
                        EmployeeRelatedRec.MODIFY(TRUE);

                    END;
                END;
            END;
        END;
    end;

    local procedure ExchEquivAmountInLCY(L_AmoountInACY: Decimal) L_AmouontInACY: Decimal;
    begin
        L_AmouontInACY := PayrollFunctions.ExchangeACYAmountToLCY(L_AmoountInACY);
        EXIT(L_AmouontInACY);
    end;
}

