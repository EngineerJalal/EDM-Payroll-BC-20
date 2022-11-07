report 98114 "Dynamic Report grp by dep"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Dynamic Report grp by dep.rdlc';

    dataset
    {
        dataitem("Payroll Ledger Entry";"Payroll Ledger Entry")
        {
            RequestFilterFields = "Employee No.","Payroll Group Code","Payment Category";
            column(EmployeeNo;"Employee No.")
            {
            }
            column(FirstName;"First Name")
            {
            }
            column(LastName;"Last Name")
            {
            }
            column(NetPayPayrollLedgerEntry;"Net Pay")
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(FreePay;FreePay)
            {
            }
            column(TotalNetPay;TotalNetPay)
            {
            }   
            column(DimensionValueCode;DimensionValueCode)
            {
            }     
            column(DimensionValueName;DimensionValueName)
            {
            } 
            column(GroupBy;GroupBy)
            {
            }   
            column(FromDate;FromDate)
            {
            }     
            column(TillDate;TillDate)
            {
            }  
            column(Cnt;Cnt)
            {
            }   
            column(EmploymentDate;EmploymentDate)
            {
            }     
            column(TerminationDate;TerminationDate)
            {
            }                                                               
            dataitem("Pay Element";"Pay Element")
            {
                DataItemLink = "Date Filter" = field("Payroll Date"),"Employee No. Filter" = field("Employee No.");
                column(PayElementCode;Code)
                {
                }
                column(PayElementDescription;Description)
                {
                }
                column(ShowinReports;"Show in Reports")
                {
                }
                column(CalculatedAmount;"Calculated Amount")
                {
                }
                column(OrderNo;"Order No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    i += 1;
                    Cnt := "Pay Element".COUNT;

                    IF i = Cnt THEN
                    BEGIN
                    PaylLedgerEntryRec.SETRANGE("Payment Category","Payment Category");
                    PaylLedgerEntryRec.SETRANGE("Payroll Date","Payroll Ledger Entry"."Payroll Date");
                    PaylLedgerEntryRec.SETRANGE("Employee No.","Payroll Ledger Entry"."Employee No.");
                    IF PaylLedgerEntryRec.FINDFIRST THEN
                    REPEAT
                        NetPay := PaylLedgerEntryRec."Net Pay";
                        FreePay := PaylLedgerEntryRec."Free Pay";
                    UNTIL PaylLedgerEntryRec.NEXT = 0;
                    END;
                end;
            }
            trigger OnPreDataItem();
            begin
               "Payroll Ledger Entry".SETRANGE("Payroll Date",FromDate,TillDate); 
            end;

            trigger OnAfterGetRecord();
            begin
                DimensionValueCode := '';
                DimensionValueName := '';
                NetPay := 0;
                TotalNetPay:= 0;
                EmploymentDate := 0D;
                TerminationDate := 0D;
                FreePay := 0;
                i := 0;

                DefaultDimensionRec.SETRANGE("Table ID",5200);
                DefaultDimensionRec.SETRANGE("No.","Payroll Ledger Entry"."Employee No.");
                DefaultDimensionRec.SETRANGE("Dimension Code",GroupBy);
                IF DefaultDimensionRec.FINDFIRST THEN
                DimensionValueCode := DefaultDimensionRec."Dimension Value Code";

                DimensionValueRec.SETRANGE(Code,DefaultDimensionRec."Dimension Value Code");
                DimensionValueRec.SETRANGE("Dimension Code",GroupBy);
                IF DimensionValueRec.FINDFIRST THEN
                DimensionValueName := DimensionValueRec.Name;

                EmployeeRec.GET("Payroll Ledger Entry"."Employee No.");
                EmploymentDate := EmployeeRec."Employment Date";
                TerminationDate := EmployeeRec."Termination Date";                
            end;
            
        }
    }
    var
    FromDate : Date;
    TillDate : Date;
    GroupBy : Code[10];
    DimensionValueRec : Record "Dimension Value";
    DimensionValueCode : Code[20];
    DimensionValueName : Text[50];
    DefaultDimensionRec : Record "Default Dimension";
    NetPay : Decimal;
    TotalNetPay : Decimal;
    PaylLedgerEntryRec : Record "Payroll Ledger Entry";
    Cnt : integer;
    i : integer;
    EmploymentDate : Date;
    TerminationDate : Date;
    EmployeeRec : Record Employee;
    FreePay : Decimal;
}