table 98053 "Employee Loan"
{
    // version PY1.0,EDM.HRPY1

    DrillDownPageID = "Loan List";
    LookupPageID = "Loan List";
    Permissions = TableData "Employee Loan Line" = rimd;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                //EDM+
                Employee.SETRANGE("No.", "Employee No.");
                if Employee.FINDFIRST then
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name"
                else
                    "Employee Name" := '';
                //EDM-
            end;
        }
        field(2; "Loan No."; Code[10])
        {
            NotBlank = true;

            trigger OnValidate();
            begin
                // add in order to fix duplicat Loan No. - 28.04.2017 : A2+
                EmpLoan.RESET;
                CLEAR(EmpLoan);
                if EmpLoan.FINDFIRST then
                    repeat
                        if Rec."Loan No." = EmpLoan."Loan No." then
                            ERROR('Loan No. already exist');
                    until EmpLoan.NEXT = 0;
                // add in order to fix duplicat Loan No. - 28.04.2017 : A2-
                //EDM.IT+
                if "Loan No." <> xRec."Loan No." then begin
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Loan No.");
                end;
                //EDM.IT-
            end;
        }
        field(10; Purpose; Text[30])
        {
            //Title = true;
        }
        field(11; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                VALIDATE("No. of Payments");
            end;
        }
        field(12; "No. of Payments"; Integer)
        {

            trigger OnValidate();
            begin
                if "No. of Payments" = 0 then
                    exit;

                //Added in order to modify the no of payments without deleting Loan details - 02.08.2016 : AIM +
                if CONFIRM('Reset Loan Details???', false) = false then
                    exit;
                //Added in order to modify the no of payments without deleting Loan details - 02.08.2016 : AIM -

                Payment := ROUND(Amount / "No. of Payments", 0.01);
                "Final Payment" := Amount - (Payment * ("No. of Payments" - 1));
                VALIDATE(Payment);


                //EDM.IT+
                IF "Monthly Amount" = 0 then begin
                    EmployeeLoanLine.SETRANGE("Employee No.", "Employee No.");
                    EmployeeLoanLine.SETRANGE("Loan No.", "Loan No.");
                    EmployeeLoanLine.SETRANGE(Completed, false);
                    if EmployeeLoanLine.FINDFIRST then
                        repeat
                            EmployeeLoanLine.DELETE(true);
                        until EmployeeLoanLine.NEXT = 0;

                    EmployeeLoanLine.SETRANGE("Employee No.", "Employee No.");
                    EmployeeLoanLine.SETRANGE("Loan No.", "Loan No.");
                    EmployeeLoanLine.SETRANGE(Completed, true);
                    if EmployeeLoanLine.FINDLAST then begin
                        i := EmployeeLoanLine."Payment Number";
                        PayDate := CALCDATE('+1M', EmployeeLoanLine."Payment Date");
                    end
                    else begin
                        i := 0;
                        PayDate := "Date of Loan";
                    end;
                    EmployeeLoanLine.RESET;
                    if "No. of Payments" <> 0 then
                        repeat
                            i := i + 1;
                            if EmployeeLoanLine.FINDLAST then
                                Identity := EmployeeLoanLine.ID
                            else
                                Identity := 0;
                            EmployeeLoanLine.INIT;
                            EmployeeLoanLine.ID := Identity + 1;
                            EmployeeLoanLine."Employee No." := "Employee No.";
                            EmployeeLoanLine."Loan No." := "Loan No.";
                            EmployeeLoanLine."Payment Number" := i;
                            EmployeeLoanLine."Payment Amount" := Amount / "No. of Payments";
                            // Added in order to Show Amount in ACY - 24.02.2017 : A2+
                            PayParam.GET;
                            IF PayParam."ACY Currency Rate" <> 0 then
                                EmployeeLoanLine."Amount (ACY)" := (Amount / "No. of Payments") / PayParam."ACY Currency Rate";
                            // Added in order to Show Amount in ACY - 24.02.2017 : A2+
                            EmployeeLoanLine."Payment Date" := PayDate;
                            PayDate := CALCDATE('+1M', PayDate);
                            EmployeeLoanLine.INSERT(true);
                        until i = "No. of Payments";
                end;
                //EDM.IT-
            end;
        }
        field(13; Payment; Decimal)
        {
            Editable = false;

            trigger OnValidate();
            var
                ExceedSalary: Boolean;
                Salary: Decimal;
                Curr: Text[5];
            begin
                PayEmp.GET("Employee No.");
                if "In Additional Currency" then begin
                    Salary := PayEmp."Salary (ACY)";
                    Curr := '(ACY)';
                    if Salary < Payment then
                        ExceedSalary := true;
                end else begin
                    Salary := PayEmp."Basic Pay";
                    Curr := '(LCY)';
                    if PayEmp."Basic Pay" < Payment then
                        ExceedSalary := true;
                end;
                if ExceedSalary then
                    if not CONFIRM('The Payment to be done exceeds Salary %1 : %2', true, Curr, Salary) then
                        ERROR('');
            end;
        }
        field(14; "Final Payment"; Decimal)
        {
            Editable = false;
        }
        field(15; "No. of Payments Made"; Integer)
        {
            Editable = false;
        }
        field(16; "Total Payments Made"; Decimal)
        {
            Editable = true;
        }
        field(17; Type; Option)
        {
            OptionMembers = "Reducing Balance","Accumulating Balance";
        }
        field(20; Completed; Boolean)
        {
        }
        field(30; "Payroll Group Code"; Code[10])
        {
            TableRelation = "HR Payroll Group";
        }
        field(31; "Associated Pay Element"; Code[10])
        {
            TableRelation = "Pay Element";

            trigger OnValidate();
            begin
                /*IF "Associated Pay Element" <> '' THEN BEGIN
                  EmpLoan.SETRANGE("Employee No.",Rec."Employee No.");
                  IF EmpLoan.FIND('-') THEN
                    REPEAT
                      IF (EmpLoan."Loan No." <> "Loan No.") AND (EmpLoan.Completed = FALSE) AND
                         (EmpLoan."Associated Pay Element" = "Associated Pay Element") THEN
                        ERROR('Cannot Associate same Pay Element on 2 Uncompleted Employee Loans');
                    UNTIL EmpLoan.NEXT = 0;
                  PayE.GET("Associated Pay Element");
                  IF NOT PayE."Payroll Special Code" THEN
                    ERROR('The Associated Pay Element must be a Payroll Special Code !');
                END;
                 */

            end;
        }
        field(32; "Additional Currency"; Boolean)
        {
        }
        field(33; "In Additional Currency"; Boolean)
        {
        }
        field(34; "Varying Loan"; Boolean)
        {
        }
        field(35; "Balance Account No"; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(63; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(64; "Employee Name"; Text[100])
        {
        }
        field(50001; "Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50002; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Name = FIELD("Journal Batch Name"), "Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(50003; "Date of Loan"; Date)
        {
            Description = 'MB.2305';

            trigger OnValidate();
            begin
                //EDM+
                if "Granted Date" > "Date of Loan" then
                    ERROR('Granted Date must be less than or equal Date of Loan');
                //EDM-
            end;
        }
        field(50004; "Granted Date"; Date)
        {
            Description = 'EDM';
        }
        field(50005; "No. Series"; Code[10])
        {
            Description = 'EDM';
        }
        field(50006; "Employee Loan Line Payments"; Decimal)
        {
            CalcFormula = Sum("Employee Loan".Payment WHERE("Employee No." = FIELD("Employee No."),
                                                             "Loan No." = FIELD("Loan No."),
                                                             Completed = CONST(true)));
            FieldClass = FlowField;
        }
        field(50007; "Amount (ACY)"; Decimal)
        {
            Description = 'Added Show Amount in ACY in "Employee Loan"';

            trigger OnValidate();
            begin
                //Exchange amount - 28.02.2017 : A2+
                PayParam.GET;
                if PayParam."ACY Exchange Operation" = PayParam."ACY Exchange Operation"::Division then begin
                    IF PayParam."ACY Currency Rate" <> 0 then
                        VALIDATE(Amount, ROUND("Amount (ACY)" * PayParam."ACY Currency Rate", 0.01))
                end
                else begin
                    if PayParam."ACY Currency Rate" > 0 then
                        VALIDATE(Amount, ROUND("Amount (ACY)" / PayParam."ACY Currency Rate", 0.01));
                end;
                //Exchange Amount - 28.02.2017 : A2-
            end;
        }
        field(50008; "Requested By"; Code[50])
        {
            Description = 'EDM:LoanApprovalWorkFlow sc';
        }
        field(50009; "Remaining Balance"; Decimal)
        {
            Description = 'Added to show remaining loan amount';
            Editable = false;
        }
        field(50010; "Approved Date"; Date)
        {
            Description = 'EDM:LoanApprovalWorkFlow sc';
        }
        field(50011; "Approved By"; Code[50])
        {
            Description = 'EDM:LoanApprovalWorkFlow sc';
        }
        field(50012; "Approval Comments"; Text[50])
        {
            Description = 'EDM:LoanApprovalWorkFlow sc';
        }
        field(50013; "Request ID"; Integer)
        {
            Description = 'EDM:LoanApprovalWorkFlow sc';
        }
        field(50014; "Change Status"; Option)
        {
            Description = 'EDM:LoanApprovalWorkFlow sc';
            OptionCaption = 'Approved,Pending,Rejected,Not Started';
            OptionMembers = Approved,Pending,Rejected,"Not Started";

            trigger OnValidate();
            var
                ApprovalEntry: Record "Approval Entry";
            begin
                //sc+ 2017-07-24
                IF (("Change Status" = "Change Status"::Approved) OR ("Change Status" = "Change Status"::Rejected))
                  AND (PayrollFunctions.CheckSalaryRaiseApprovalSystem) THEN BEGIN
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Employee Loan");
                    ApprovalEntry.SETRANGE("Record ID to Approve", RECORDID);
                    ApprovalEntry.SETFILTER("Approver ID", USERID);
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        IF "Change Status" = "Change Status"::Approved THEN
                            ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Approved)
                        ELSE
                            ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Rejected);
                        ApprovalEntry.MODIFY(TRUE);
                    END;
                END;
                //sc- 2017-07-24
            end;
        }
        field(50015; "Loan Endging Date"; Date)
        {
        }
        field(50016; "Remaining Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Employee Loan Line"."Payment Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                           "Loan No." = FIELD("Loan No."),
                                                                           "Completed" = FILTER(false)));
            Editable = False;
        }
        field(50017; "Monthly Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Loan No.")
        {
        }
        key(Key2; "Payroll Group Code")
        {
        }
        key(Key3; "Employee No.", "Associated Pay Element")
        {
        }
        key(Key4; "Employee No.", Completed)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        // Modified in order to set validation on delete record - 28.04.2017 : A2+
        //IF ("No. of Payments Made" <> 0) AND  ("Total Payments Made" <> Amount) THEN
        //  ERROR('Loan is still active.');
        if IsLoanLineCompleted(Rec."Loan No.") = true then
            ERROR('Loan is still active.');
        // Modified in order to set validation on delete record - 28.04.2017 : A2-
        //EDM.IT+
        EmployeeLoanLine.SETRANGE("Employee No.", "Employee No.");
        EmployeeLoanLine.SETRANGE("Loan No.", "Loan No.");
        if EmployeeLoanLine.FINDFIRST then
            repeat
                EmployeeLoanLine.DELETE;
            until EmployeeLoanLine.NEXT = 0;
        //EDM.IT-
    end;

    trigger OnInsert();
    begin
        PayEmp.RESET;
        if PayEmp.GET("Employee No.") then
            "Payroll Group Code" := PayEmp."Payroll Group Code";
    end;

    trigger OnModify();
    begin
        if PayDetailHeader.GET("Employee No.") then begin
            PayDetailHeader."Calculation Required" := true;
            PayDetailHeader.MODIFY;
        end;
    end;

    var
        PayEmp: Record Employee;
        PayDetailHeader: Record "Pay Detail Header";
        EmpLoan: Record "Employee Loan";
        PayE: Record "Pay Element";
        Employee: Record Employee;
        EmployeeLoanLine: Record "Employee Loan Line";
        i: Integer;
        Identity: Integer;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeLoan: Record "Employee Loan";
        PayDate: Date;
        PayParam: Record "Payroll Parameter";
        PayrollFunctions: Codeunit "Payroll Functions";

    procedure AssistEdit(OldLoan: Record "Employee Loan"): Boolean;
    begin
        //EDM+
        with EmployeeLoan do begin
            EmployeeLoan := Rec;
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Loan No.");
            if NoSeriesMgt.SelectSeries(HumanResSetup."Loan No.", OldLoan."No. Series", "No. Series") then begin
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Loan No.");
                NoSeriesMgt.SetSeries("Loan No.");
                Rec := EmployeeLoan;
                exit(true);
            end;
        end;
        //EDM-
    end;

    local procedure IsLoanLineCompleted(LoanNo: Code[10]): Boolean;
    var
        L_EmpLoanLine: Record "Employee Loan Line";
    begin
        L_EmpLoanLine.SETRANGE("Loan No.", LoanNo);
        if L_EmpLoanLine.FINDFIRST then
            repeat
                if L_EmpLoanLine.Completed = true then
                    exit(true);
            until L_EmpLoanLine.NEXT = 0;
        exit(false);
    end;

    procedure GetLastComment() LastComment: Text[80];
    var
        ApprovalCommentLine: Record "Approval Comment Line";
    begin
        //sc+ 2017-07-24
        ApprovalCommentLine.RESET;
        ApprovalCommentLine.SETRANGE("Table ID", DATABASE::"Employee Loan");
        ApprovalCommentLine.SETRANGE("Record ID to Approve", RECORDID);
        IF ApprovalCommentLine.FINDLAST THEN
            LastComment := ApprovalCommentLine.Comment;
        EXIT(LastComment);
        //sc-
    end;
}

