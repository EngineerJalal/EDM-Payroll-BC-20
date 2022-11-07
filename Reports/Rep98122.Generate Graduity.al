report 98122 "Generate Graduity"
{
    ProcessingOnly = true;
    
    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = ORDER(Ascending) WHERE(Status=CONST(Active));
            RequestFilterFields = "No.";

            trigger OnPreDataItem();
            var
            lHRTransType : Record "HR Transaction Types";
            begin
                PayrollParameter.Get();
                lHRTransType.SetRange(Code,PayrollParameter."Graduity Journal");
                if lHRTransType.FindFirst then
                    TypeOfTransaction := lHRTransType.Type;
            end;

            trigger OnAfterGetRecord();
            begin
                EmployeeAdditionalInfo.Get(Employee."No.");
                ServiceYear := GetNoOfServiceYear(Employee."No.");
                IsFirstBand := true;

                GratuityBand.SetCurrentKey("From Unit");
                GratuityBand.SetRange("Contract Type",ContractType);
                if GratuityBand.FindFirst then repeat
                    if ContractType = ContractType::Unlimited then begin
                        if (GratuityBand."From Unit" <= ServiceYear) and (ServiceYear <= GratuityBand."To Unit") then 
                            Amount := Employee."Basic Pay" / 30 * ServiceYear * GratuityBand."Days Basic Salary per year";
                    end else begin
                        if IsFirstBand then begin
                            if (GratuityBand."From Unit" < ServiceYear) and (ServiceYear <= GratuityBand."To Unit") then
                                Amount := Employee."Basic Pay" / 30 * ServiceYear * GratuityBand."Days Basic Salary per year"
                            else
                                Amount := Employee."Basic Pay" / 30 * GratuityBand."To Unit" * GratuityBand."Days Basic Salary per year";
                        end else begin
                            ServiceYear -= GratuityBand."From Unit";
                            if (GratuityBand."From Unit" < ServiceYear) and (ServiceYear <= GratuityBand."To Unit") then
                                Amount += Employee."Basic Pay" / 30 * ServiceYear * GratuityBand."Days Basic Salary per year"
                            else
                                Amount += Employee."Basic Pay" / 30 * GratuityBand."To Unit" * GratuityBand."Days Basic Salary per year";                            
                        end;
                    end;

                    IsFirstBand := false;
                until GratuityBand.Next = 0;
                
                InsertEmployeeJournalLine(Employee."No.",Amount);
            end;

            trigger OnPostDataItem();
            begin
                Message('Process Done');
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
                    field("Payroll Date";PayrollDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Contract Type";ContractType)
                    {
                        ApplicationArea=All;
                    }   
                }
            }
        }
    }

    var
    EmployeeJournalLine : Record "Employee Journal Line";
    PayrollParameter : Record "Payroll Parameter";
    EmployeeAdditionalInfo : Record "Employee Additional Info";
    GratuityBand : Record "Gratuity Band";
    PayrollDate : Date;
    Amount : Decimal;
    TypeOfTransaction : Code[30];
    ServiceYear : Decimal;
    ContractType : Option Limited,Unlimited;
    IsForUAE : Boolean;
    IsFirstBand : Boolean;

    local procedure GetNoOfServiceYear(EmpNo : code[20]) Val : Decimal;
        var
        lEmployee : Record Employee;
        begin
            lEmployee.SetRange("No.",EmpNo);
            if lEmployee.FindFirst then repeat
                if (lEmployee."Termination Date" <> 0D) and (lEmployee."Employment Date" <> 0D) then
                    Val += (lEmployee."Termination Date" - lEmployee."Employment Date") / 360;
            until lEmployee.Next = 0;
        end;

    local procedure InsertEmployeeJournalLine(EmpNo : Code[20]; Value : Decimal)
    var
    lEmplJnlLine : Record "Employee Journal Line";
    begin
        lEmplJnlLine.Reset;
        lEmplJnlLine.SetRange("Employee No.",EmpNo);
        lEmplJnlLine.SetRange("Transaction Date",PayrollDate);
        lEmplJnlLine.SetRange("Transaction Type",PayrollParameter."Graduity Journal");
        if lEmplJnlLine.FindFirst then
            lEmplJnlLine.DeleteAll;

        lEmplJnlLine.Init;
        lEmplJnlLine.Validate("Transaction Type",PayrollParameter."Graduity Journal");
        lEmplJnlLine.Validate("Employee No.",EmpNo);
        lEmplJnlLine.Validate("Transaction Date",PayrollDate);
        lEmplJnlLine.Validate("System Insert",true);
        lEmplJnlLine.Validate(Type,TypeOfTransaction);
        lEmplJnlLine.Validate(Value,Value);
        lEmplJnlLine.Validate("Calculated Value",Value);
        lEmplJnlLine.Validate("Opened By",USERID);
        lEmplJnlLine.Validate("Opened Date",TODAY);
        lEmplJnlLine.Validate("Released By",USERID);
        lEmplJnlLine.Validate("Released Date",TODAY);
        lEmplJnlLine.Validate("Approved By",USERID);
        lEmplJnlLine.Validate("Approved Date",TODAY);
        lEmplJnlLine.Validate("Starting Date",PayrollDate);
        lEmplJnlLine.Validate("Ending Date",PayrollDate);
        lEmplJnlLine.Validate("Document Status",EmployeeJournalLine."Document Status"::Approved);
        lEmplJnlLine.Insert;
    end;
}
