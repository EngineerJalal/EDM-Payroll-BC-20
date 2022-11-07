report 98030 "Print-Prepare Bank Payment.."
{
  DefaultLayout = RDLC;
  RDLCLayout = 'Reports Layouts/Print-Prepare Bank Payment...rdlc';

  dataset
  {
    dataitem("Payroll Ledger Entry";"Payroll Ledger Entry")
    {
      DataItemTableView = SORTING("Entry No.");
      RequestFilterFields = "Payroll Group Code","Bank No.","Bank No. (ACY)";

      column(BankAcct;BankAcct)
      {}
      column(EmpAccNo;EmpAccNo)
      {}
      column(EmpNetPay;EmpNetPay)
      {}
      column(EmpBankName;EmpBankName)
      {}
      column(NoRec;NoRec)
      {}
      column(BankName;BankName)
      {}
      column(CurrencyCode;CurrCode)
      {}
      column(BankAdd;BankAdd)
      {}
      column(PayrollDate;PayrollDate)
      {}
      column(ValueDate;ValueDate)
      {}
      column(EmpTransferBankName;EmpTransferBankName)
      {}
      column(SwiftCode;SwiftCode)
      {}
      column(BankAccNo;BankAccNo)
      {}
      column(BankBranchNo;BankBranchNo)
      {}      
      column(Signature;Signature)
      {}
      column(Remark;Remark)
      {}
      column(EmpBankBranch;EmpBankBranch)
      {}      
      column(BankIBAN;BankIBAN)
      {}    
      column(CompanyName;CompanyName)
      {}            
      trigger OnPreDataItem();
      begin
        FILTERGROUP(2);
        PayGroup.FILTERGROUP(2);
        SETFILTER("Payroll Group Code",PayGroup.GETFILTER(Code));
        PayGroup.FILTERGROUP(0);
        FILTERGROUP(0);
        CompanyInfo.GET;
        SETRANGE("Payroll Date",PayrollDate);
      end;

      trigger OnAfterGetRecord();
      begin
        HumanResSetup.GET;
        IF HumanResSetup.CUSTIND<>'' THEN
          CUST := HumanResSetup.CUSTIND;

        NoRec += 1;
        Employee.Get("Payroll Ledger Entry"."Employee No.");

        EmpAddInfo.Reset;
        EmpAddInfo.SetRange("Employee No.","Payroll Ledger Entry"."Employee No.");
        if EmpAddInfo.FindFirst then begin
          EmpTransferBankName := EmpAddInfo."Emp Transfer Bank Name";
          if ShowAmountACY then 
            SwiftCode := EmpAddInfo."Bank SWIFT Code (ACY)"
          else 
            SwiftCode := EmpAddInfo."Bank SWIFT Code";             
        end;

        EmpRec.Reset;
        EmpRec.SetRange("No.","Payroll Ledger Entry"."Employee No.");
        if EmpRec.FindFirst then 
          EmpBankBranch := EmpRec."Bank Branch";
          

        if Employee."Payment Method" <> Employee."Payment Method"::Bank then
          CurrReport.SKIP;

        if Employee."Emp. Bank Acc Name" = '' then
          EmpBankName := Employee."Full Name"
        else
          EmpBankName := Employee."Emp. Bank Acc Name";

        if ShowAmountACY then
          BankAcct := Employee."Bank No. (ACY)"
        else
          BankAcct := Employee."Bank No.";
        
        CLEAR(BankAcc);
        BankAcc.SETRANGE("No.",BankAcct);
        if BankAcc.FINDFIRST then begin
          if BankAcc."Currency Code" = '' then begin
            BankName := BankAcc.Name;
            CurrCode := GenLedgSetup."Local Currency Symbol";
            BankAdd := BankAcc.Address;
            BankAccNo := BankAcc."Bank Account No.";
            BankBranchNo := BankAcc."Bank Branch No.";
            BankIBAN := BankAcc.IBAN;
          end else begin
            BankName := BankAcc.Name;
            CurrCode := BankAcc."Currency Code";
            BankAdd := BankAcc.Address;
            BankAccNo := BankAcc."Bank Account No.";
            BankBranchNo := BankAcc."Bank Branch No.";
            BankIBAN := BankAcc.IBAN;
          end
        end;

        if ShowAmountACY then begin
          EmpAccNo := Employee."Emp. Bank Acc No. (ACY)";
          EmpNetPay := ExchEquivAmountInACY("Payroll Ledger Entry"."Net Pay");
        end else begin
          EmpAccNo := Employee."Emp. Bank Acc No.";
          EmpNetPay := "Payroll Ledger Entry"."Net Pay";
        end;
      end;
    }
  }

  requestpage
  {
    layout
    {
      area(content)
      {
        group(Requirments)
        {
          Caption = 'Requirments';
          field(PayrollDate;PayrollDate)
          {
            Caption = 'Payroll Date';
              ApplicationArea=All;
          }
          field(ValueDate;ValueDate)
          {
            Caption = 'Value Date';
              ApplicationArea=All;
          }  
          field(Signature;Signature)
          {
            MultiLine = true;
              ApplicationArea=All;
          }        
          field(ShowAmountACY;ShowAmountACY)
          {
            Caption = 'Show Amount in ACY';
              ApplicationArea=All;
          }
        }
      }
    }
    Trigger OnOpenPage();
    BEGIN
      ValueDate := WorkDate;
    END;
  }

  trigger OnInitReport();
  begin
    if  PayrollFunction.HideSalaryFields() = true then
      ERROR('Permission NOT Allowed!');

    if USERID <> '' then
      HRFunction.SetPayGroupFilter(PayGroup);
  end;

  trigger OnPreReport();
  begin
    if PayrollDate = 0D then
      ERROR('Payroll Date must be entered');

    HumanResSetup.GET();
    GenLedgSetup.Get();
  end;

  var
      BankAcc : Record "Bank Account";
      PayGroup : Record "HR Payroll Group";
      EmpAddInfo : Record "Employee Additional Info";
      CompanyInfo : Record "Company Information";
      EmpRec : Record Employee;
      PayrollFunction : Codeunit "Payroll Functions";
      BankAcct : Code[20];
      CurrCode : Code[10];
      PayrollDate : Date;
      HumanResSetup : Record "Human Resources Setup";
      GenLedgSetup : Record "General Ledger Setup";
      CurShort : Text[30];
      EmpAccNo : Code[30];
      EmpNetPay : Decimal;
      NoRec : Integer;
      HRFunction : Codeunit "Human Resource Functions";
      EmpBankName : Text[100];
      BankName : Text[50];
      Employee : Record Employee;
      BankAdd : Text;
      ShowAmountACY : Boolean;
      ValueDate : Date;
      EmpTransferBankName : Text[250];
      SwiftCode : Code[50];
      Signature : Text[250];
      Remark : Text[250];
      ShowRemark : Boolean;
      CUST : Text [50];
      EmpBankBranch : Text [30];
      BankAccNo : Text [30];
      BankBranchNo : Text [20];    
      BankIBAN : Code [50]; 

  local procedure ExchEquivAmountInACY(L_AmoountInLCY : Decimal) L_AmouontInACY : Decimal;
  begin
    L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
    exit(L_AmouontInACY);
  end;
}

