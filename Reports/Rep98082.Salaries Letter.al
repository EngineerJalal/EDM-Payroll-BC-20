report 98082 "Salaries Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salaries Letter.rdlc';

    dataset
    {
        dataitem("Payroll Ledger Entry";"Payroll Ledger Entry")
        {
            column(AccountNo;AccNo)
            {
            }
            column(TotalNetPay;TotalNetPay)
            {
            }
            column(NetPay;"Net Pay")
            {
            }
            column(AmountTextVar;AmountTextVar[1])
            {
            }
            column(PayrollDate;PayDate)
            {
            }
            column(BankNo;BankNo)
            {
            }
            column(BankName;BankName)
            {
            }
            column(BankContact;BankContact)
            {
            }
            column(BankCurrency;BankCurrency)
            {
            }
            column(BankAddress;BankAddress)
            {
            }
            column(ValueDate;ValueDate)
            {
            }
            column(CompanyName;CompanyName)
            {
            }
            column(Signature;Signature)
            {
            }
            column(SalaryTransferForm;SalaryTransferForm)
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(EmpBankTransferName;EmpBankTransferName)
            {
            }
            column(EmpBankAccNo;EmpBankAccNo)
            {
            }
            column(EmpIBAN;EmpIBAN)
            {
            }
            column(EmpBankSwiftCode;EmpBankSwiftCode)
            {
            }
            trigger OnPreDataItem();
            begin
                "Payroll Ledger Entry".SETRANGE("Payroll Ledger Entry"."Payroll Date",PayDate);
                "Payroll Ledger Entry".SETRANGE("Payroll Ledger Entry"."Bank No.",BankNo); 
            end;

            trigger OnAfterGetRecord();
            begin
                EmployeeAddInfoRec.Get("Payroll Ledger Entry"."Employee No.");
                EmployeeRec.Get("Payroll Ledger Entry"."Employee No.");
                BankAcc.SETRANGE("No.",BankNo);
                if BankAcc.FINDFIRST then begin
                    BankName := BankAcc.Name;
                    BankContact := BankAcc.Contact;
                    BankAddress := BankAcc.Address;
                    AccNo := BankAcc."Bank Account No.";
                    if BankAcc."Currency Code" = '' then
                    begin
                        GLSetup.GET;
                        BankCurrency := GLSetup."LCY Code";         
                    end else
                        BankCurrency := BankAcc."Currency Code";
                end;

                EmpName := EmployeeRec."Full Name";
                EmpBankAccNo := EmployeeRec."Emp. Bank Acc No.";
                EmpBankTransferName := EmployeeAddInfoRec."Emp Transfer Bank Name";
                EmpIBAN := EmployeeAddInfoRec."IBAN No";
                EmpBankSwiftCode := EmployeeAddInfoRec."Bank SWIFT Code";

                if NOT SalaryTransferForm then begin
                    if EmployeeAddInfoRec."Bank SWIFT Code" <> '' then
                        CurrReport.Skip;
                end else begin
                    if EmployeeAddInfoRec."Bank SWIFT Code" = '' then
                        CurrReport.Skip;
                end;

                TotalNetPay += ROUND("Payroll Ledger Entry"."Net Pay",1,'=');
                AmountToText.FormatNoText( AmountTextVar,TotalNetPay,BankAcc."Currency Code");

            end;
        }
    }

    requestpage
    {
        SaveValues = TRUE;
        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Payroll Date";PayDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Value Date";ValueDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Bank No";BankNo)
                    {
                        TableRelation = "Bank Account"."No.";
                        ApplicationArea=All;
                    }
                    field(Signature;Signature)
                    {
                        MultiLine = TRUE;
                        ApplicationArea=All;
                    }
                    field("Salary Transfer Form";SalaryTransferForm)
                    {
                        ApplicationArea=All;
                    }
                }
            }
        }
        trigger OnOpenPage();
        begin
            ValueDate := WorkDate;
        end;
    }

    trigger OnPreReport();
    begin
        if PayDate = 0D then
          ERROR('Payroll Date must not be empty');
        if BankNo = '' then
          ERROR('Bank No must not be empty');

        CompanyInfo.GET;
        CompanyName := CompanyInfo.Name + ' ' + CompanyInfo."Name 2";
    end;

    var
        PayDate : Date;
        BankNo : Code[20];
        AccNo : Code[50];
        TotalNetPay : Decimal;
        BankName : Text[150];
        BankAcc : Record "Bank Account";
        BankContact : Text[50];
        BankAddress : Text[50];
        BankCurrency : Code[10];
        AmountToText : Codeunit "Amount to Text Payroll";
        ValueDate : Date;
        AmountTextVar : array [5] of Text[250];
        GLSetup : Record "General Ledger Setup";
        CompanyInfo : Record "Company Information";
        Signature : Text[150];
        CompanyName : Text[250];
        SalaryTransferForm : Boolean;
        EmployeeAddInfoRec : Record "Employee Additional Info";
        EmployeeRec : Record Employee;
        EmpName : text[150]; 
        EmpBankTransferName : Text[50];
        EmpBankAccNo : Code[30];
        EmpIBAN : text[30];
        EmpBankSwiftCode : Code[50];
}