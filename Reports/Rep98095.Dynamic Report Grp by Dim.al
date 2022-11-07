report 98095 "Dynamic Report Grp by Dim"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Dynamic Report Grp by Dim.rdlc';

    dataset
    {
        dataitem("Payroll Ledger Entry"; "Payroll Ledger Entry")
        {
            RequestFilterFields = "Employee No.", "Payroll Group Code";
            column(EmployeeNo_PayrollLedgerEntry; "Employee No.")
            {
            }
            column(FirstName_PayrollLedgerEntry; "First Name")
            {
            }
            column(LastName_PayrollLedgerEntry; "Last Name")
            {
            }
            column(NetPay_PayrollLedgerEntry; "Net Pay")
            {
            }
            column(NetPay; NetPay)
            {
            }
            column(FreePay; FreePay)
            {
            }
            column(TotalNetPay; TotalNetPay)
            {
            }
            column(DimensionValueCode; DimensionValueCode)
            {
            }
            column(DimensionValueName; DimensionValueName)
            {
            }
            column(GroupBy; GroupBy)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(TillDate; TillDate)
            {
            }
            column(Cnt; Cnt)
            {
            }
            column(EmploymentDate; EmploymentDate)
            {
            }
            column(TerminationDate; TerminationDate)
            {
            }
            column(GrandTotalDeduction; GrandTotalDeduction)
            {
            }
            column(GrandTotalAddition; GrandTotalAddition)
            {
            }
            column(TAdditions; TAdditions)
            {
            }
            column(TDeductions; TDeductions)
            {
            }
            dataitem("Pay Element"; "Pay Element")
            {
                DataItemLink = "Date Filter" = FIELD("Payroll Date"),
                               "Employee No. Filter" = FIELD("Employee No.");
                DataItemTableView = SORTING("Order No.", Code, Type)
                                    ORDER(Ascending)
                                    WHERE("Calculated Amount" = FILTER(<> 0));
                column(Code_PayElement; Code)
                {
                }
                column(Description_PayElement; Description)
                {
                }
                column(ShowinReports_PayElement; "Show in Reports")
                {
                }
                column(CalculatedAmount_PayElement; "Calculated Amount")
                {
                }
                column(OrderNo_PayElement; "Order No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    i += 1;
                    Cnt := "Pay Element".COUNT;

                    IF i = Cnt THEN BEGIN
                        PaylLedgerEntry.SETRANGE("Payroll Date", "Payroll Ledger Entry"."Payroll Date");
                        PaylLedgerEntry.SETRANGE("Employee No.", "Payroll Ledger Entry"."Employee No.");
                        IF PaylLedgerEntry.FINDFIRST THEN
                            REPEAT
                                NetPay := PaylLedgerEntry."Net Pay";
                                FreePay := PaylLedgerEntry."Free Pay";
                            UNTIL PaylLedgerEntry.NEXT = 0;
                    END;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                DimensionValueCode := '';
                DimensionValueName := '';
                NetPay := 0;
                TotalNetPay := 0;
                EmploymentDate := 0D;
                TerminationDate := 0D;
                FreePay := 0;
                i := 0;

                DefaultDimension.SETRANGE("Table ID", 5200);
                DefaultDimension.SETRANGE("No.", "Payroll Ledger Entry"."Employee No.");
                DefaultDimension.SETRANGE("Dimension Code", GroupBy);
                IF DefaultDimension.FINDFIRST THEN
                    DimensionValueCode := DefaultDimension."Dimension Value Code";

                DimensionValue.SETRANGE(Code, DefaultDimension."Dimension Value Code");
                DimensionValue.SETRANGE("Dimension Code", GroupBy);
                IF DimensionValue.FINDFIRST THEN
                    DimensionValueName := DimensionValue.Name;

                Employee.GET("Payroll Ledger Entry"."Employee No.");
                EmploymentDate := Employee."Employment Date";
                TerminationDate := Employee."Termination Date";
                //
                TAdditions := 0;
                TDeductions := 0;
                PayDetailLine.RESET;
                PayDetailLine.CalcFields("Payment Category");
                PayDetailLine.SETRANGE("Payment Category", "Payment Category");
                PayDetailLine.SETRANGE("Payroll Date", "Payroll Date");
                PayDetailLine.SETRANGE("Employee No.", "Employee No.");
                if PayDetailLine.FINDFIRST then
                    repeat
                        if PayDetailLine.Type = PayDetailLine.Type::Addition then
                            TAdditions += PayDetailLine."Calculated Amount"
                        else
                            TDeductions += PayDetailLine."Calculated Amount";
                    until PayDetailLine.NEXT = 0;
                //
                /*PayDetailLineRec.RESET;
                PayDetailLineRec.CalcFields("Payment Category");
                PayDetailLineRec.SETRANGE("Payment Category","Payment Category");
                PayDetailLineRec.SETRANGE("Employee No.","Employee No.");
                PayDetailLineRec.SETRANGE("Payroll Date","Payroll Date"); 
                PayDetailLineRec.SETRANGE(Type,PayDetailLineRec.Type::Addition);  
                PayDetailLineRec.SETRANGE("Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
                PayDetailLineRec.SETRANGE("Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
                IF PayDetailLineRec.FINDFIRST THEN repeat
                    GrandTotalAddition := GrandTotalAddition+PayDetailLineRec."Calculated Amount";
                UNTIL PayDetailLineRec.NEXt=0;  

                PayDetailLineRec.RESET;
                PayDetailLineRec.CalcFields("Payment Category");
                PayDetailLineRec.SETRANGE("Payment Category","Payment Category");
                PayDetailLineRec.SETRANGE("Employee No.","Employee No.");
                PayDetailLineRec.SETRANGE("Payroll Date","Payroll Date"); 
                PayDetailLineRec.SETRANGE(Type,PayDetailLineRec.Type::Deduction);  
                PayDetailLineRec.SETRANGE("Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
                PayDetailLineRec.SETRANGE("Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
                IF PayDetailLineRec.FINDFIRST THEN repeat
                    GrandTotalDeduction := GrandTotalDeduction+PayDetailLineRec."Calculated Amount";
                UNTIL PayDetailLineRec.NEXt=0;*/
            end;

            trigger OnPreDataItem();
            begin
                "Payroll Ledger Entry".SETRANGE("Payroll Ledger Entry"."Payroll Date", FromDate, TillDate);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Request Parameter")
                {
                    field("Group By"; GroupBy)
                    {
                        TableRelation = Dimension.Code WHERE("Dimension No." = FILTER(1 | 2));
                        ApplicationArea = All;

                    }
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            TillDate := CALCDATE('+1M-1D', FromDate);
                        end;
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

    labels
    {
    }

    var
        FromDate: Date;
        TillDate: Date;
        GroupBy: Code[10];
        DimensionValue: Record "Dimension Value";
        DimensionValueCode: Code[20];
        DimensionValueName: Text[50];
        DefaultDimension: Record "Default Dimension";
        NetPay: Decimal;
        TotalNetPay: Decimal;
        PaylLedgerEntry: Record "Payroll Ledger Entry";
        Cnt: Integer;
        i: Integer;
        EmploymentDate: Date;
        TerminationDate: Date;
        Employee: Record Employee;
        FreePay: Decimal;
        TAdditions: Decimal;
        TDeductions: Decimal;
        GrandTotalAddition: Decimal;
        GrandTotalDeduction: Decimal;
        PayDetailLine: Record "Pay Detail Line";
        PayDetailLineRec: Record "Pay Detail Line";
}

