report 98053 "Comparative Salary by Location"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Comparative Salary by Location.rdlc';

    dataset
    {
        dataitem("Payroll Ledger Entry";"Payroll Ledger Entry")
        {
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(EmployeeNo_PayrollLedgerEntry;Employee."No.")
            {
            }
            column(NetPayFrom_PayrollLedgerEntry;NetPay_From)
            {
            }
            column(NetPayTo_PayrollLedgerEntry;NetPay_To)
            {
            }
            column(Difference_PayrollLedgerEntry;Difference)
            {
            }
            column(FromDate_Employee;FromDate)
            {
            }
            column(ToDate_Employee;ToDate)
            {
            }
            column(Location_PayrollLedgerEntry;LocationName)
            {
            }
            column(Group_PayrollLedgerEntry;Group)
            {
            }
            column(Name_Company;CompanyInformation.Name)
            {
            }
            column(Picture_Company;CompanyInformation.Picture)
            {
            }

            trigger OnAfterGetRecord();
            begin
                HRInformation.RESET;
                NetPay_From := 0;
                NetPay_To := 0;
                Difference := 0;
                LocationName := '';
                CALCFIELDS(Location,"Employee Manager No");

                PayrollLedgerEntryRec.SETRANGE("Employee No.","Payroll Ledger Entry"."Employee No.");

                Employee.SETRANGE("No.","Payroll Ledger Entry"."Employee No.");
                Employee.FINDFIRST;
                HRInformation.SETRANGE(HRInformation.Code,"Payroll Ledger Entry".Location);
                if HRInformation.FINDFIRST then
                  LocationName := HRInformation.Description;

                //IF "Payroll Ledger Entry".Period = FromPeriod THEN
                    NetPay_To := "Payroll Ledger Entry"."Net Pay";
                //ELSE IF "Payroll Ledger Entry".Period  = ToPeriod THEN
                  if PayrollLedgerEntryRec.FINDFIRST then
                    NetPay_From := PayrollLedgerEntryRec."Net Pay";
                //Difference Net Pay
                  Difference := NetPay_To - NetPay_From;

                if "Payroll Ledger Entry"."Employee Manager No" <> '' then
                    begin
                      Employee1.GET("Payroll Ledger Entry"."Employee Manager No");
                      Group := Employee1."No." + ' : ' + Employee1."Full Name";
                    end;

                // Add in order to show amount in ACY - 15.11.2016 : A2+
                if ShowInUSD then
                  begin
                    NetPay_From := ExchEquivAmountInACY(NetPay_From);
                    NetPay_To := ExchEquivAmountInACY(NetPay_To);
                    Difference := NetPay_To - NetPay_From;
                  end
                // Add in order to show amount in ACY - 15.11.2016 : A2+
            end;

            trigger OnPreDataItem();
            begin
                "Payroll Ledger Entry".SETRANGE(Period,ToPeriod);
                PayrollLedgerEntryRec.SETRANGE(Period,FromPeriod);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Filter Group")
                {
                    field("Reference Date";ToDate)
                    {
                        ApplicationArea=All;
                    }
                    field("US - Dollar";ShowInUSD)
                    {
                        ApplicationArea=All;
                    }
                    field(ExchangeRate;ExchangeRate)
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
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

    trigger OnPreReport();
    begin
        FromDate := CALCDATE('<-1M>',ToDate);
        FromPeriod := DATE2DMY(FromDate,2);
        ToPeriod := DATE2DMY(ToDate,2);

        //"Payroll Ledger Entry".SETFILTER(Period,'%1|%2',FromPeriod,ToPeriod);
    end;

    var
        CompanyInformation : Record "Company Information";
        PayrollLedgerEntryRec : Record "Payroll Ledger Entry";
        Employee : Record Employee;
        Employee1 : Record Employee;
        HRInformation : Record "HR Information";
        FromDate : Date;
        ToDate : Date;
        Difference : Decimal;
        NetPay_From : Decimal;
        NetPay_To : Decimal;
        FromPeriod : Integer;
        ToPeriod : Integer;
        LocationName : Text[100];
        Group : Text[50];
        ExchangeRate : Decimal;
        ShowInUSD : Boolean;
        PayrollFunction : Codeunit "Payroll Functions";
        PayParam : Record "Payroll Parameter";

    local procedure ExchEquivAmountInACY(L_AmoountInLCY : Decimal) L_AmouontInACY : Decimal;
    begin
        //Modified because the rate is set in parameter card - 08.11.2016 : A2+
        //L_AmouontInACY := L_AmoountInLCY/PayParam."ACY Currency Rate";
        L_AmouontInACY := PayrollFunction.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
        //Modified because the rate is set in parameter card - 08.11.2016 : A2-
    end;
}

