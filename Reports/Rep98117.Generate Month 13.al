report 98117 "Generate Month 13"
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
                lHRTransType.SetRange(Code,PayrollParameter."Month 13 Journal");
                if lHRTransType.FindFirst then
                    TypeOfTransaction := lHRTransType.Type;
            end;

            trigger OnAfterGetRecord();
            begin
                EmployeeJournalLine.Reset;
                EmployeeJournalLine.SetRange("Employee No.",Employee."No.");
                EmployeeJournalLine.SetRange("Transaction Type",PayrollParameter."Month 13 Journal");
                EmployeeJournalLine.SetRange("Transaction Date",DMY2Date(01,01,Date2DMY(PayrollDate,3)),DMY2Date(31,12,Date2DMY(PayrollDate,3)));
                if EmployeeJournalLine.FindFirst then
                    CurrReport.Skip;
            
                EmployeeAdditionalInfo.Get(Employee."No.");

                Amount := ((Employee."Basic Pay" + EmployeeAdditionalInfo."Extra Salary")* GetNoOfMonth(Employee."No.",PayrollDate))/12;   
                InsertEmployeeJournalLine(Employee."No.",Amount);
            end;

            trigger OnPostDataItem();
            begin
                Message('Month 13 has been generated');
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
                    field("Reference Date";PayrollDate)
                    {
                        ApplicationArea=All;
                    }
                }
            }
        }
    }

    var
    PayrollDate : Date;
    EmployeeJournalLine : Record "Employee Journal Line";
    PayrollParameter : Record "Payroll Parameter";
    EntryNo : integer;
    Amount : Decimal;
    TypeOfTransaction : Code[30];
    EmployeeAdditionalInfo : Record "Employee Additional Info";
    local procedure GetNoOfMonth(EmpNo : code[20]; PayDate : date) M : Decimal;
        var
        lEmployee : Record Employee;
        begin
            lEmployee.Get(EmpNo);
            /*if lEmployee."Termination Date" = 0D then begin
                if lEmployee."Employment Date" <= DMY2Date(01,01,Date2DMY(PayDate,3)) then
                    M := Date2DMY(lEmployee."Employment Date",2);
                if lEmployee."Employment Date" >= PayDate then
                    M := 0;
                if (DMY2Date(01,01,Date2DMY(PayDate,3)) < lEmployee."Employment Date") and (lEmployee."Employment Date" < PayDate) then
                    M := Date2DMY(PayDate,2) - Date2DMY(lEmployee."Employment Date",2) + 1;
            end else begin
                if (lEmployee."Employment Date" < DMY2Date(01,01,Date2DMY(PayDate,3))) and (lEmployee."Termination Date" < PayDate) then
                    M := Date2DMY(lEmployee."Termination Date",2)
                else if (lEmployee."Employment Date" < DMY2Date(01,01,Date2DMY(PayDate,3))) and (lEmployee."Termination Date" > PayDate) then
                    M := Date2DMY(PayDate,2)
                else if (DMY2Date(01,01,Date2DMY(PayDate,3)) < lEmployee."Employment Date") and (lEmployee."Termination Date" > PayDate) then
                    M := Date2DMY(lEmployee."Employment Date",2) - Date2DMY(PayDate,2) + 1
                else if (DMY2Date(01,01,Date2DMY(PayDate,3)) < lEmployee."Employment Date") and (lEmployee."Termination Date" < PayDate) then
                    M := Date2DMY(lEmployee."Employment Date",2) - Date2DMY(lEmployee."Termination Date",2) + 1
                else 
                    M := 0;
            end;*/
            if lEmployee."Termination Date" = 0D then begin
                if lEmployee."Employment Date" <= DMY2Date(01,01,Date2DMY(PayDate,3)) then
                    M := 12;
                if lEmployee."Employment Date" >= PayDate then
                    M := 0;
                if (DMY2Date(01,01,Date2DMY(PayDate,3)) < lEmployee."Employment Date") and (lEmployee."Employment Date" < PayDate) then
                    M := (12-Date2DMY(lEmployee."Employment Date",2)+1); 
            end
        end;

    local procedure InsertEmployeeJournalLine(EmpNo : Code[20]; Value : Decimal)
    var
    lEmplJnlLine : Record "Employee Journal Line";
    begin
        lEmplJnlLine.RESET;
        lEmplJnlLine.SETRANGE("Employee No.",EmpNo);
        lEmplJnlLine.SETRANGE("Transaction Date",PayrollDate);
        lEmplJnlLine.SETRANGE("Transaction Type",PayrollParameter."Month 13 Journal");
        IF NOT lEmplJnlLine.FINDFIRST THEN
        BEGIN
            EntryNo := 0;
            lEmplJnlLine.RESET;
            lEmplJnlLine.SETRANGE("Employee No.",EmpNo);
            IF lEmplJnlLine.FINDLAST THEN
                EntryNo := lEmplJnlLine."Entry No.";
            
            CLEAR(lEmplJnlLine);
            lEmplJnlLine.Init;
            lEmplJnlLine.Validate("Transaction Type",PayrollParameter."Month 13 Journal");
            lEmplJnlLine.Validate("Employee No.",EmpNo);
            lEmplJnlLine."Entry No." := EntryNo + 1;
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
            lEmplJnlLine.Validate(Description,'Month 13 Allowance');
            lEmplJnlLine.Validate("Month 13",True);
            lEmplJnlLine.Validate("Document Status",EmployeeJournalLine."Document Status"::Approved);
            lEmplJnlLine.Insert;
        end;
    end;
}

