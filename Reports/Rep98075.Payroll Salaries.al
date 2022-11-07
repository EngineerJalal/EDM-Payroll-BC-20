report 98075 "Payroll Salaries"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll Salaries.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(TotalSource;TotalSource)
            {
            }
            column(TaxYear;TaxYear)
            {
            }
            column(JANTotal;JANTotal)
            {
            }
            column(FEBTotal;FEBTotal)
            {
            }
            column(MARTotal;MARTotal)
            {
            }
            column(APRTotal;APRTotal)
            {
            }
            column(MAYTotal;MAYTotal)
            {
            }
            column(JUNTotal;JUNTotal)
            {
            }
            column(JULTotal;JULTotal)
            {
            }
            column(AUGTotal;AUGTotal)
            {
            }
            column(SEPTotal;SEPTotal)
            {
            }
            column(OCTTotal;OCTTotal)
            {
            }
            column(NOVTotal;NOVTotal)
            {
            }
            column(DECTotal;DECTotal)
            {
            }
            dataitem("Pay Detail Line";"Pay Detail Line")
            {
                DataItemLink = "Employee No."=FIELD("No.");
                RequestFilterFields = "Pay Element Code";
            }

            trigger OnAfterGetRecord();
            begin
                JANTotal := CalculateMonthelTotal(1);
                FEBTotal := CalculateMonthelTotal(2);
                MARTotal := CalculateMonthelTotal(3);
                APRTotal := CalculateMonthelTotal(4);
                MAYTotal := CalculateMonthelTotal(5);
                JUNTotal := CalculateMonthelTotal(6);
                JULTotal := CalculateMonthelTotal(7);
                AUGTotal := CalculateMonthelTotal(8);
                SEPTotal := CalculateMonthelTotal(9);
                OCTTotal := CalculateMonthelTotal(10);
                NOVTotal := CalculateMonthelTotal(11);
                DECTotal := CalculateMonthelTotal(12);
            end;

            trigger OnPreDataItem();
            begin
                TotalSource := "Pay Detail Line".GETFILTER("Pay Detail Line"."Pay Element Code");
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
                    field("Tax Year";TaxYear)
                    {
                        ApplicationArea=All;
                    }
                    field("Show in ACY";ShowInACY)
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
    }

    var
        PayrollFunction : Codeunit "Payroll Functions";
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        TaxYear : Integer;
        TotalSource : Text[50];
        JANTotal : Decimal;
        FEBTotal : Decimal;
        MARTotal : Decimal;
        APRTotal : Decimal;
        MAYTotal : Decimal;
        JUNTotal : Decimal;
        JULTotal : Decimal;
        AUGTotal : Decimal;
        SEPTotal : Decimal;
        OCTTotal : Decimal;
        NOVTotal : Decimal;
        DECTotal : Decimal;
        ShowInACY : Boolean;

    local procedure CalculateMonthelTotal(MonthNo : Integer) Val : Decimal;
    var
        PayrollFunction : Codeunit "Payroll Functions";
    begin
        Val := 0;
        "Pay Detail Line".RESET;
        CLEAR("Pay Detail Line");
        "Pay Detail Line".SETFILTER(Period,'=%1',MonthNo);
        "Pay Detail Line".SETRANGE("Pay Detail Line"."Employee No.",Employee."No.");
        "Pay Detail Line".SETRANGE("Pay Detail Line"."Tax Year" ,TaxYear);
        if TotalSource <> '' then
          "Pay Detail Line".SETFILTER("Pay Detail Line"."Pay Element Code",TotalSource);

        if "Pay Detail Line".FINDFIRST then
          repeat
            if "Pay Detail Line".Type = "Pay Detail Line".Type::Addition then
              Val += "Pay Detail Line"."Calculated Amount"
            else
              Val -= "Pay Detail Line"."Calculated Amount";
          until "Pay Detail Line".NEXT = 0;
        if ShowInACY then
          exit(PayrollFunction.ExchangeLCYAmountToACY(Val))
        else
          exit(Val);
    end;
}

