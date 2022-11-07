report 98051 "Employees Cost-Hrs Per Project"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employees Cost-Hrs Per Project.rdlc';

    dataset
    {
        dataitem("Employee Absence";"Employee Absence")
        {
            DataItemTableView = WHERE("Cause of Absence Code"=CONST('WD'));
            RequestFilterFields = "From Date","To Date";
            column(Group_EmployeeAbsence;Group)
            {
            }
            column(EmployeeNo_EmployeeAbsence;"Employee Absence"."Employee No.")
            {
            }
            column(DepartmentName_EmployeeAbsence;DepartementName)
            {
            }
            column(DivisionName_EmployeeAbsence;DivisionName)
            {
            }
            column(ProjectName_EmployeeAbsence;ProjectName)
            {
            }
            column(AttendHrs_EmployeeAbsence;"Employee Absence"."Attend Hrs.")
            {
            }
            column(CostByHours_EmployeeAbsence;CostByHours)
            {
            }
            column(Name_CompanyInformation;CompanyInformation.Name)
            {
            }
            column(Picture_CompanyInformation;CompanyInformation.Picture)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if ("Employee Absence"."Attendance No." <> 0) and ("Employee Absence".Period <> 0D) and ("Employee Absence"."Employment Type Code" <> '') then
                   CurrReport.SKIP;

                HumanResSetupTbt.GET();

                Employee1.RESET;
                DimensionValue.RESET;
                DepartementName := '';
                DivisionName := '';
                ProjectName := '';
                CostByHours := 0;
                RequiredHourPerMonth := 0;
                BasicHourlyRate := 0;
                Group := '';

                CALCFIELDS("Project Code","Job Category",Department,"Division Code","Employee Manager No","Employment Type Code");

                if "Employee Absence"."Employment Type Code" = '' then
                   CurrReport.SKIP;

                EmploymentTypeRec.SETRANGE(Code,"Employee Absence"."Employment Type Code");
                if not EmploymentTypeRec.FINDFIRST then
                   CurrReport.SKIP;


                ProjectVal := '';
                ProjectName := '';

                if HumanResSetupTbt."Project Dimension Type" = HumanResSetupTbt."Project Dimension Type"::"Global Dimension1" then
                  ProjectVal := "Employee Absence"."Global Dimension 1 Code"
                else if HumanResSetupTbt."Project Dimension Type" = HumanResSetupTbt."Project Dimension Type"::"Global Dimension2" then
                  ProjectVal := "Employee Absence"."Global Dimension 2 Code"
                else if HumanResSetupTbt."Project Dimension Type" = HumanResSetupTbt."Project Dimension Type"::"Shortcut Dimension" then
                  ProjectVal := "Employee Absence"."Project Code";
                if ProjectVal <> '' then
                  begin
                    if DimensionValue.GET('PROJECT',ProjectVal) then
                       ProjectName := DimensionValue.Name;
                  end;


                DepartmentVal  := '';
                DepartementName := '';
                if HumanResSetupTbt."Department Dimension Type"  = HumanResSetupTbt."Department Dimension Type"::"Global Dimension1" then
                  DepartmentVal := "Employee Absence"."Global Dimension 1 Code"
                else if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Global Dimension2" then
                  DepartmentVal := "Employee Absence"."Global Dimension 2 Code"
                else if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Shortcut Dimension" then
                  DepartmentVal := "Employee Absence".Department;
                if DepartmentVal <> '' then
                  begin
                    if DimensionValue.GET('DEPARTMENT',DepartmentVal) then
                       DepartementName := DimensionValue.Name;
                  end;


                DivisionVal  := '';
                DivisionName := '';
                if HumanResSetupTbt."Division Dimension Type"  = HumanResSetupTbt."Division Dimension Type"::"Global Dimension1" then
                  DivisionVal := "Employee Absence"."Global Dimension 1 Code"
                else if HumanResSetupTbt."Division Dimension Type" = HumanResSetupTbt."Division Dimension Type"::"Global Dimension2" then
                  DivisionVal := "Employee Absence"."Global Dimension 2 Code"
                else if HumanResSetupTbt."Division Dimension Type" = HumanResSetupTbt."Division Dimension Type"::"Shortcut Dimension" then
                  DivisionVal := "Employee Absence"."Division Code";
                if DivisionVal <> '' then
                  begin
                    if DimensionValue.GET('DIVISION',DivisionVal) then
                       DivisionName := DimensionValue.Name;
                  end;


                Employee.GET("Employee Absence"."Employee No.");
                if Employee."Hourly Rate" <> 0 then
                    CostByHours := Employee."Hourly Rate" * "Employee Absence"."Attend Hrs."
                else
                  begin
                      RequiredHourPerMonth := EmploymentTypeRec."Working Days Per Month" * EmploymentTypeRec."Working Hours Per Day";
                      BasicHourlyRate := Employee."Basic Pay" / RequiredHourPerMonth;
                      CostByHours := BasicHourlyRate * "Employee Absence"."Attend Hrs.";
                    end;
                if "Employee Absence"."Employee Manager No" <> '' then
                  begin
                      Employee1.GET("Employee Absence"."Employee Manager No");
                      Group := Employee1."No." + ' : ' + Employee1."Full Name";
                    end;

                CostByHours := ROUND(CostByHours,0.01);

                // add in order to shoe amount in ACY - 15.11.2016 : A2+
                if ShowInUSD then
                  CostByHours := ExchEquivAmountInACY(CostByHours);
                // add in order to shoe amount in ACY - 15.11.2016 : A2-
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("US - Dollar";ShowInUSD)
                {
                    ApplicationArea=All;
                }
                field(ExchangeRate;ExchangeRate)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            // Modified to disable Change ExchangeRate,15.11.2016 : A2+
              if PayParam.FINDFIRST then
              ExchangeRate := PayParam."ACY Currency Rate";
            // Modified to disable Change ExchangeRate,15.11.2016 : A2-
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation : Record "Company Information";
        EmploymentTypeRec : Record "Employment Type";
        Employee : Record Employee;
        Employee1 : Record Employee;
        DefaultDimension : Record "Default Dimension";
        DimensionValue : Record "Dimension Value";
        DepartementName : Text[100];
        DivisionName : Text[100];
        ProjectName : Text[100];
        AttendHours : Decimal;
        CostByHours : Decimal;
        JobCategoryName : Text[100];
        RequiredHourPerMonth : Integer;
        BasicHourlyRate : Decimal;
        TotalAllowance : Decimal;
        "Group" : Text[50];
        ProjectVal : Code[20];
        DepartmentVal : Code[20];
        DivisionVal : Code[20];
        HumanResSetupTbt : Record "Human Resources Setup";
        PayrollFunction : Codeunit "Payroll Functions";
        ExchangeRate : Decimal;
        PayParam : Record "Payroll Parameter";
        ShowInUSD : Boolean;

    local procedure ExchEquivAmountInACY(L_AmoountInLCY : Decimal) L_AmouontInACY : Decimal;
    begin
        //Modified because the rate is set in parameter card - 08.11.2016 : A2+
        //L_AmouontInACY := L_AmoountInLCY/PayParam."ACY Currency Rate";
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
        //Modified because the rate is set in parameter card - 08.11.2016 : A2-
    end;
}

