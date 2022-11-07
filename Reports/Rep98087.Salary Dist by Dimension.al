report 98087 "Salary Dist by Dimension"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary Dist by Dimension.rdlc';

    dataset
    {
        dataitem("Payroll Ledger Entry";"Payroll Ledger Entry")
        {
            column(EmployeeNo_PayrollLedgerEntry;"Payroll Ledger Entry"."Employee No.")
            {
            }
            column(NetPay_PayrollLedgerEntry;"Payroll Ledger Entry"."Net Pay")
            {
            }
            column(FirstName_PayrollLedgerEntry;"Payroll Ledger Entry"."First Name")
            {
            }
            column(LastName_PayrollLedgerEntry;"Payroll Ledger Entry"."Last Name")
            {
            }
            column(PayrollDate_PayrollLedgerEntry;"Payroll Ledger Entry"."Payroll Date")
            {
            }
            column(PayrollDate;PayrollDate)
            {
            }
            column(Dimension1;Dimension[1])
            {
            }
            column(Dimension2;Dimension[2])
            {
            }
            column(Dimension3;Dimension[3])
            {
            }
            column(Dimension4;Dimension[4])
            {
            }
            column(Dimension5;Dimension[5])
            {
            }
            column(Dimension6;Dimension[6])
            {
            }
            column(Dimension7;Dimension[7])
            {
            }
            column(Dimension8;Dimension[8])
            {
            }
            dataitem("Employee Dimensions";"Employee Dimensions")
            {
                DataItemLink = "Employee No."=FIELD("Employee No."),"Payroll Date"=FIELD("Payroll Date");
                column(Percentage_EmployeeDimensions;"Employee Dimensions".Percentage)
                {
                }
                column(ShortcutDimension1Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 2 Code")
                {
                }
                column(ShortcutDimension3Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 3 Code")
                {
                }
                column(ShortcutDimension4Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 4 Code")
                {
                }
                column(ShortcutDimension5Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 5 Code")
                {
                }
                column(ShortcutDimension6Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 6 Code")
                {
                }
                column(ShortcutDimension7Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 7 Code")
                {
                }
                column(ShortcutDimension8Code_EmployeeDimensions;"Employee Dimensions"."Shortcut Dimension 8 Code")
                {
                }

                trigger OnPreDataItem();
                begin
                    if PayrollDate <> 0D then
                      "Employee Dimensions".SETFILTER("Employee Dimensions"."Payroll Date",'%1',PayrollDate);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                for i := 1 to 8 do
                  begin
                    Dimension[i] := GetEmployeeShortcutDimensionValue(i);
                  end;
            end;

            trigger OnPreDataItem();
            begin
                if PayrollDate <> 0D then
                  "Payroll Ledger Entry".SETFILTER("Payroll Ledger Entry"."Payroll Date",'%1',PayrollDate);
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
                    field("Payroll Date";PayrollDate)
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

    trigger OnPreReport();
    begin
        //IF PayrollDate = 0D THEN
    end;

    var
        PayrollDate : Date;
        PayFunction : Codeunit "Payroll Functions";
        Dimension : array [8] of Code[20];
        i : Integer;

    local procedure GetEmployeeShortcutDimensionValue(DimNo : Integer) DimVal : Code[20];
    var
        GenLedgerTbt : Record "General Ledger Setup";
        EmpCardDimensionTbt : Record "Default Dimension";
        DimensionN : Code[20];
    begin
        GenLedgerTbt.GET();
        case DimNo
          of
            1 : DimensionN := GenLedgerTbt."Global Dimension 1 Code";
            2 : DimensionN := GenLedgerTbt."Global Dimension 2 Code";
            3 : DimensionN := GenLedgerTbt."Shortcut Dimension 3 Code";
            4 : DimensionN := GenLedgerTbt."Shortcut Dimension 4 Code";
            5 : DimensionN := GenLedgerTbt."Shortcut Dimension 5 Code";
            6 : DimensionN := GenLedgerTbt."Shortcut Dimension 6 Code";
            7 : DimensionN := GenLedgerTbt."Shortcut Dimension 7 Code";
            8 : DimensionN := GenLedgerTbt."Shortcut Dimension 8 Code";
          end;
        exit(DimensionN);
    end;
}

