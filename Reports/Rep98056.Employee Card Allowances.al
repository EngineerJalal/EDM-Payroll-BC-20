report 98056 "Employee Card Allowances"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employee Card Allowances.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(No_Employee; Employee."No.")
            {
            }
            column(FullName_Employee; Employee."Full Name")
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
            column(Cost_of_Living; Employee."Cost of Living")
            { }
            column(House_Allowance_Employee; Employee."House Allowance")
            {
            }
            column(EmployeeNo; EmployeeNo)
            {
            }
            column(EmployeeName; EmployeeName)
            {
            }
            column(TotalAllowances; TotalAllowances)
            {
            }
            column(BasicPayNoNSSF; BasicPayNoNSSF)
            {
            }
            column(PhoneAllowanceNoNSSF; PhoneAllowanceNoNSSF)
            {
            }
            column(CarAllowanceNoNSSF; CarAllowanceNoNSSF)
            {
            }
            column(HouseAllowanceNoNSSF; HouseAllowanceNoNSSF)
            {
            }
            column(TotalAllowancesNoNSSF; TotalAllowancesNoNSSF)
            {
            }

            trigger OnAfterGetRecord();
            begin
                BasicPayNoNSSF := 0;
                PhoneAllowanceNoNSSF := 0;
                CarAllowanceNoNSSF := 0;
                HouseAllowanceNoNSSF := 0;

                EmployeeTbt.SETRANGE("Related to", Employee."No.");
                EmployeeTbt.SETRANGE(Declared, Employee.Declared::"Non-Declared");
                if EmployeeTbt.FINDFIRST then begin
                    BasicPayNoNSSF := EmployeeTbt."Basic Pay";
                    PhoneAllowanceNoNSSF := EmployeeTbt."Phone Allowance";
                    CarAllowanceNoNSSF := EmployeeTbt."Car Allowance";
                    HouseAllowanceNoNSSF := EmployeeTbt."House Allowance";
                end;

                EmployeeTbt.RESET;
                CLEAR(EmployeeTbt);
                EmployeeTbt.SETRANGE("Related to", Employee."No.");
                EmployeeTbt.SETRANGE(Declared, Employee.Declared::Contractual);
                EmployeeTbt.SETRANGE(Declared, Employee.Declared::Declared);
                if EmployeeTbt.FINDFIRST then begin
                    Employee."Basic Pay" := EmployeeTbt."Basic Pay";
                    Employee."Phone Allowance" := EmployeeTbt."Phone Allowance";
                    Employee."Car Allowance" := EmployeeTbt."Car Allowance";
                    Employee."Cost of Living" := EmployeeTbt."Cost of Living";
                    Employee."House Allowance" := EmployeeTbt."House Allowance";
                end;

                if ShowInUSD then begin
                    BasicPayNoNSSF := ExchEquivAmountInACY(BasicPayNoNSSF);
                    PhoneAllowanceNoNSSF := ExchEquivAmountInACY(PhoneAllowanceNoNSSF);
                    CarAllowanceNoNSSF := ExchEquivAmountInACY(CarAllowanceNoNSSF);
                    HouseAllowanceNoNSSF := ExchEquivAmountInACY(HouseAllowanceNoNSSF);
                    Employee."Basic Pay" := ExchEquivAmountInACY(Employee."Basic Pay");
                    Employee."Phone Allowance" := ExchEquivAmountInACY(Employee."Phone Allowance");
                    Employee."Car Allowance" := ExchEquivAmountInACY(Employee."Car Allowance");
                    Employee."Cost of Living" := ExchEquivAmountInACY(Employee."Cost of Living");
                    Employee."House Allowance" := ExchEquivAmountInACY(Employee."House Allowance");
                end
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
                    field("Show In USD"; ShowInUSD)
                    {
                        ApplicationArea = All;
                    }
                    field("Exchange Rate"; ExchangeRate)
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            // Modified to disable Change ExchangeRate,8.11.2016 : A2+
            if PayParam.FINDFIRST then
                ExchangeRate := PayParam."ACY Currency Rate";
            // Modified to disable Change ExchangeRate,8.11.2016 : A2-
        end;
    }

    labels
    {
    }

    var
        TotalAllowances: Decimal;
        BasicPayNoNSSF: Decimal;
        PhoneAllowanceNoNSSF: Decimal;
        CarAllowanceNoNSSF: Decimal;
        HouseAllowanceNoNSSF: Decimal;
        TotalAllowancesNoNSSF: Decimal;
        BasicPay: Decimal;
        PhoneAllowances: Decimal;
        CarAllowances: Decimal;
        HouseAllowances: Decimal;
        EmployeeNo: Code[10];
        EmployeeName: Text;
        EmployeeTbt: Record Employee;
        USD_Currency: Boolean;
        ExchangeRate: Decimal;
        PayrollFunction: Codeunit "Payroll Functions";
        ShowInUSD: Boolean;
        PayParam: Record "Payroll Parameter";

    local procedure ExchEquivAmountInACY(L_AmoountInLCY: Decimal) L_AmouontInACY: Decimal;
    begin
        //Modified because the rate is set in parameter card - 08.11.2016 : A2+
        //L_AmouontInACY := L_AmoountInLCY/PayParam."ACY Currency Rate";
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
        //Modified because the rate is set in parameter card - 08.11.2016 : A2-
    end;
}

