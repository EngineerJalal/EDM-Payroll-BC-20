report 98000 "Auto Update Emp Entitlement"
{
    // version EDM.HRPY2

    ProcessingOnly = true;

    dataset
    {
        dataitem("Employee Absence Entitlement";"Employee Absence Entitlement")
        {

            trigger OnAfterGetRecord();
            var
                EntitleType : Option "Interval Basis","Yearly Basis","Employment Basis";
                EmployDate : Date;
                V : Decimal;
                IsFirstyearEntitle : Boolean;
            begin
                //IF NOT "Employee Absence Entitlement"."Auto Calculate Entitlement" THEN
                //  CurrReport.SKIP;

                if ("Employee Absence Entitlement"."From Date" = 0D) or ("Employee Absence Entitlement"."Till Date" = 0D) then
                  CurrReport.SKIP;

                if DATE2DMY("Employee Absence Entitlement"."From Date",3) <> DATE2DMY(WORKDATE,3) then
                  CurrReport.SKIP;

                "Employee Absence Entitlement".CALCFIELDS(Status);
                if "Employee Absence Entitlement".Status <> "Employee Absence Entitlement".Status::Active then
                  CurrReport.SKIP;

                //
                CALCFIELDS("AL Start Date","Employment date");
                if "Cause of Absence Code" = 'AL' then
                  begin
                    if "AL Start Date" <> 0D then
                      EmployDate := "AL Start Date"
                    else
                      EmployDate := "Employment date";
                  end
                else
                  EmployDate := "Employment date";

                //28.08.2017 +
                if (WORKDATE - EmployDate)  < 365 *2 then
                    IsFirstyearEntitle := true;
                //28.08.2017 -

                EmployDate := DMY2DATE(DATE2DMY(EmployDate,1),DATE2DMY(EmployDate,2),DATE2DMY("Till Date",3));
                //
                //28.08.2017 +
                if IsFirstyearEntitle = true then
                  begin
                //28.08.2017 -
                EntitlementTillToday := PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code",WORKDATE,0D,EntitleType::"Interval Basis",false);
                //EntitlementTillToday := PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code","Employee Absence Entitlement"."From Date","Employee Absence Entitlement"."Till Date",EntitleType::"Interval Basis",FALSE);
                "Employee Absence Entitlement".VALIDATE("Employee Absence Entitlement".Entitlement,EntitlementTillToday);
                // 31.07.2017 : A2+
                if "Employee Absence Entitlement"."First Year Entitlement" <= 0 then
                    begin
                      "Employee Absence Entitlement"."First Year Entitlement" := PayrollFunctions.GetEmpFirstYearEntitlement("Employee No.","Cause of Absence Code",WORKDATE,0D,EntitleType::"Interval Basis",false);
                      "Employee Absence Entitlement"."Year Entitlement" := "Employee Absence Entitlement".Entitlement - "Employee Absence Entitlement"."First Year Entitlement";
                    end;
                //28.08.2017 +
                "Employee Absence Entitlement"."Year Entitlement" := "Employee Absence Entitlement".Entitlement - "Employee Absence Entitlement"."First Year Entitlement";
                if "Employee Absence Entitlement"."Year Entitlement"  < 0 then
                    "Employee Absence Entitlement"."Year Entitlement" := 0;
                //28.08.2017 -

                if "Employee Absence Entitlement"."First Year Entitlement" > 0 then
                  begin
                    V := "Employee Absence Entitlement"."Till Date" - (DMY2DATE(DATE2DMY(EmployDate,1),DATE2DMY(EmployDate,2),DATE2DMY("Employee Absence Entitlement"."Till Date",3)));
                    V := ("Employee Absence Entitlement"."Year Entitlement" / 365) * V;
                    V := V + "Employee Absence Entitlement"."First Year Entitlement";
                    "Employee Absence Entitlement".VALIDATE("Employee Absence Entitlement".Entitlement,V);
                  end;
                //"Employee Absence Entitlement"."Year Entitlement" := EntitlementTillToday - "Employee Absence Entitlement"."First Year Entitlement";
                //"Employee Absence Entitlement".VALIDATE("Employee Absence Entitlement".Entitlement,"Employee Absence Entitlement"."Year Entitlement");
                //28.08.2017 +
                    end
                else
                      begin
                          V := PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code","Employee Absence Entitlement"."From Date",EmployDate -1,EntitleType::"Interval Basis",false);
                          "Employee Absence Entitlement"."Year Entitlement" := PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code",WORKDATE,0D,EntitleType::"Interval Basis",false);
                          V := V +  PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code",EmployDate ,"Employee Absence Entitlement"."Till Date",EntitleType::"Interval Basis",false);
                          V := V -  PayrollFunctions.GetEmpFirstYearEntitlement("Employee No.","Cause of Absence Code","Employee Absence Entitlement"."From Date",0D,EntitleType::"Interval Basis",false);
                          "Employee Absence Entitlement".VALIDATE("Employee Absence Entitlement".Entitlement,V);
                      end;
                //28.08.2017 -
                "Employee Absence Entitlement".MODIFY(true);
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
        PayrollFunctions : Codeunit "Payroll Functions";
        EntitlementTillToday : Decimal;
        IntervalType : Option Month,Day;
        Balance : Decimal;
        AttendanceDed : Decimal;
        AttendanceAdd : Decimal;
}

