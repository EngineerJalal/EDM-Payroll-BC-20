report 98049 "Employees Hourly Rate"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employees Hourly Rate.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(No_Employee; Employee."No.")
            {
            }
            column(JobCategory_Employee; Employee."Job Category")
            {
            }
            column(EmploymentTypeCode_Employee; Employee."Employment Type Code")
            {
            }
            column(BasicPay_Employee; Employee."Basic Pay")
            {
            }
            column(PhoneAllowance_Employee; Employee."Phone Allowance")
            {
            }
            column(CarAllowance_Employee; Employee."Car Allowance")
            {
            }
            column(Cost_of_Living; "Cost of Living")
            {
            }
            column(HouseAllowance_Employee; Employee."House Allowance")
            {
            }
            column(TicketAllowance_Employee; Employee."Ticket Allowance")
            {
            }
            column(FoodAllowance_Employee; Employee."Food Allowance")
            {
            }
            column(OtherAllowances_Employee; Employee."Other Allowances")
            {
            }
            column(Status_Employee; Employee.Status)
            {
            }
            column(FullName_Employee; Employee."Full Name")
            {
            }
            column(Department_Employee; DepartmentName)
            {
            }
            column(BasicHourlyRate; BasicHourlyRate)
            {
            }
            column(PayHourlyRate; PayHourlyRate)
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Picture_CompanyInformation; CompanyInformation.Picture)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Employee."Employment Type Code" = '' then
                    CurrReport.SKIP;

                CALCFIELDS(Department);

                EmploymentTypeRec.SETRANGE(Code, Employee."Employment Type Code");
                if not EmploymentTypeRec.FINDFIRST then
                    CurrReport.SKIP;
                RequiredHourPerMonth := EmploymentTypeRec."Working Days Per Month" * EmploymentTypeRec."Working Hours Per Day";
                TotalAllowance := Employee."Phone Allowance" + Employee."Car Allowance" + Employee."House Allowance" + Employee."Ticket Allowance" + Employee."Food Allowance" + Employee."Other Allowances";
                //BasicHourlyRate := ROUND(Employee."Basic Pay" / RequiredHourPerMonth,0.01,'=');
                //PayHourlyRate := ROUND((Employee."Basic Pay" + TotalAllowance) / RequiredHourPerMonth,0.01,'=');

                if Employee."Hourly Rate" > 0 then
                    BasicHourlyRate := Employee."Hourly Rate"
                else
                    BasicHourlyRate := Employee."Basic Pay" / RequiredHourPerMonth;

                PayHourlyRate := (Employee."Basic Pay" + TotalAllowance) / RequiredHourPerMonth;

                // Add in order to show amount in ACY - 15.11.2016 : A2+
                if ShowInUSD then begin
                    BasicHourlyRate := ExchEquivAmountInACY(BasicHourlyRate);
                    PayHourlyRate := ExchEquivAmountInACY(PayHourlyRate);
                end;
                // Add in order to show amount in ACY - 15.11.2016 : A2-


                HumanResSetupTbt.GET();

                DepartmentVal := '';
                DepartmentName := '';
                if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Global Dimension1" then
                    DepartmentVal := Employee."Global Dimension 1 Code"
                else
                    if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Global Dimension2" then
                        DepartmentVal := Employee."Global Dimension 2 Code"
                    else
                        if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Shortcut Dimension" then
                            DepartmentVal := Employee.Department;
                if DepartmentVal <> '' then begin
                    if DimensionValue.GET('DEPARTMENT', DepartmentVal) then
                        DepartmentName := DimensionValue.Name;
                end;
            end;

            trigger OnPreDataItem();
            begin
                Employee.SETRANGE(Status, Status::Active);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("US - Dollar"; ShowInUSD)
                {
                    ApplicationArea = All;
                }
                field(ExchangeRate; ExchangeRate)
                {
                    Editable = false;
                    ApplicationArea = All;
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
        EmploymentTypeRec: Record "Employment Type";
        CompanyInformation: Record "Company Information";
        RequiredHourPerMonth: Integer;
        BasicHourlyRate: Decimal;
        PayHourlyRate: Decimal;
        TotalAllowance: Decimal;
        DimensionValue: Record "Dimension Value";
        DepartmentName: Text[60];
        DepartmentVal: Code[20];
        HumanResSetupTbt: Record "Human Resources Setup";
        ExchangeRate: Decimal;
        ShowInUSD: Boolean;
        PayrollFunction: Codeunit "Payroll Functions";
        PayParam: Record "Payroll Parameter";
        HRSetup: Record "Human Resources Setup";

    local procedure ExchEquivAmountInACY(L_AmoountInLCY: Decimal) L_AmouontInACY: Decimal;
    begin
        //Modified because the rate is set in parameter card - 15.11.2016 : A2+
        //L_AmouontInACY := L_AmoountInLCY/PayParam."ACY Currency Rate";
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
        //Modified because the rate is set in parameter card - 15.11.2016 : A2-
    end;
}

