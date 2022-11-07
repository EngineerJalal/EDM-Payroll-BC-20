report 98116 "Salaries Grouped by PayGrp"
{
    RDLCLayout = 'Reports Layouts/Salary Grouped by Pay Grp.rdlc';
    dataset
    {
        dataitem("Payroll Ledger Entry"; "Payroll Ledger Entry")
        {
            RequestFilterFields = "Employee No.", "Payroll Group Code";

            column(Employee_No_; "Employee No.")
            {
            }
            column(First_Name; "First Name")
            {
            }
            column(Last_Name; "Last Name")
            {
            }
            column(Payroll_Group_Code; "Payroll Group Code")
            {
            }
            column(BusinessUnit; BusinessUnit)
            {
            }
            column(NetPay; NetPay)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(TillDate; TillDate)
            {
            }
            dataitem("Pay Element"; "Pay Element")
            {
                DataItemTableView = SORTING("Order No.", Code, Type) ORDER(Ascending) WHERE("Calculated Amount" = FILTER(<> 0));
                DataItemLink = "Date Filter" = FIELD("Payroll Date"), "Employee No. Filter" = FIELD("Employee No.");
                column(Code; Code)
                {
                }
                column(Description; Description)
                {
                }
                column(Show_in_Reports; "Show in Reports")
                {
                }
                column(Calculated_Amount; "Calculated Amount")
                {
                }
                column(Order_No_; "Order No.")
                {
                }
                trigger OnAfterGetRecord();
                begin
                    i += 1;
                    Cnt := "Pay Element".COUNT;

                    if i = Cnt then begin
                        PayLedgerEntry.SETRANGE("Payroll Date", FromDate, TillDate);
                        PayLedgerEntry.SETRANGE("Employee No.", "Payroll Ledger Entry"."Employee No.");
                        if PayLedgerEntry.FINDFIRST then
                            repeat
                                NetPay := PayLedgerEntry."Net Pay";
                            until PayLedgerEntry.NEXT = 0;
                    end;
                end;
            }
            trigger OnPreDataItem();
            begin
                SetRange("Payroll Date", FromDate, TillDate);
            end;

            trigger OnAfterGetRecord();
            begin
                NetPay := 0;
                i := 0;
                Employee.Get("Employee No.");
                BusinessUnit := Employee."Job Title Code";
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Report Parameter")
                {
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Till Date"; TillDate)
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

    var
        PayLedgerEntry: Record "Payroll Ledger Entry";
        Employee: Record Employee;
        FromDate: Date;
        TillDate: Date;
        NetPay: Decimal;
        i: Integer;
        Cnt: Integer;
        //BusinessUnit: Code[20];//Changed by EDM.AI
        BusinessUnit: Code[30];
}

