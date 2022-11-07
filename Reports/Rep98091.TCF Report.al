report 98091 "TCF Report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/TCF Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(No_Employee;Employee."No.")
            {
            }
            column(PersonalFinanceNo_Employee;Employee."Personal Finance No.")
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(PreviousBasic;PreviousBasic)
            {
            }
            dataitem("Pay Detail Line";"Pay Detail Line")
            {
                DataItemLink = "Employee No."=FIELD("No.");
                column(CalculatedAmount_PayDetailLine;"Pay Detail Line"."Calculated Amount")
                {
                }

                trigger OnPreDataItem();
                begin
                    "Pay Detail Line".SETFILTER("Pay Detail Line"."Payroll Date",'%1',PayDate);
                    "Pay Detail Line".SETRANGE("Pay Detail Line"."Pay Element Code",'01');
                end;
            }

            trigger OnAfterGetRecord();
            begin
                PreviousBasic := 0;

                if (Employee."Arabic First Name" <> '') and (Employee."Arabic Last Name" <> '') then
                  EmpName := Employee."Arabic First Name" + ' ' + Employee."Arabic Last Name"
                else
                  EmpName := Employee."First Name" + ' ' + Employee."Last Name";

                if DATE2DMY(PayDate,2) = 1 then
                  begin
                    PayDetailLine.SETRANGE(Period,12);
                    PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PayDate,3) - 1);
                  end
                else
                  begin
                    PayDetailLine.SETRANGE(Period,DATE2DMY(PayDate,2) - 1);
                    PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PayDate,3));
                  end;

                PayDetailLine.SETRANGE("Employee No.",Employee."No.");
                PayDetailLine.SETRANGE("Pay Element Code",'01');
                if PayDetailLine.FINDFIRST then
                  PreviousBasic := PayDetailLine."Calculated Amount";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Filter Parameters")
                {
                    field("Payroll Date";PayDate)
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
        PreviousBasic : Decimal;
        CurrentBasic : Decimal;
        EmpName : Text[150];
        PayDate : Date;
        PayDetailLine : Record "Pay Detail Line";
}

