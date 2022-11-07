table 98055 "Pay Detail Line"
{
    // version PY1.0,EDM.HRPY1

    // SHR9.0 : change second key --> add sumindex (employer amount)

    DataCaptionFields = Explanation;
    DrillDownPageID = "Pay Detail List";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(5; "Tax Year"; Integer)
        {
        }
        field(6; Period; Integer)
        {
        }
        field(10; "Pay Element Code"; Code[10])
        {
            TableRelation = "Pay Element";

            trigger OnValidate();
            begin
                PayParam.GET;
                Employee.GET("Employee No.");
                PayElement.GET("Pay Element Code");
                "Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
                "Pay Frequency" := Employee."Pay Frequency";
                "Payroll Group Code" := Employee."Payroll Group Code";
                Description := PayElement.Description;
                Type := PayElement.Type;
                "Payroll Special Code" := PayElement."Payroll Special Code";
                Open := true;
                PayrollFunctions.GetSpePayAmount("Pay Element Code", Employee, Rec);
            end;
        }
        field(11; Description; Text[30])
        {
        }
        field(12; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                if "Manual Pay Line" = true then
                    "Calculated Amount" := Amount;
            end;
        }
        field(13; Hours; Decimal)
        {
        }
        field(14; Rate; Decimal)
        {
        }
        field(18; "Periods to Advance"; Integer)
        {
            MinValue = 0;
        }
        field(19; Type; Option)
        {
            OptionMembers = Addition,Deduction;
        }
        field(20; Recurring; Boolean)
        {
        }
        field(21; "Holiday Days"; Decimal)
        {
        }
        field(22; "Payroll Special Code"; Boolean)
        {
        }
        field(30; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Pay Frequency"; Option)
        {
            OptionMembers = Monthly,Weekly;
        }
        field(32; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
        }
        field(40; Reference; Code[10])
        {
        }
        field(41; "Employer Amount"; Decimal)
        {
        }
        field(50; "Project Code"; Code[10])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Dimension Code" = CONST('CC'));
        }
        field(60; Open; Boolean)
        {
        }
        field(70; "Payroll Date"; Date)
        {
        }
        field(75; "Payroll Group Code"; Code[10])
        {
            TableRelation = "HR Payroll Group"."Code";
        }
        field(80; "Reset to Zero"; Boolean)
        {
        }
        field(50001; "Amount (ACY)"; Decimal)
        {

            trigger OnValidate();
            begin
                if "Manual Pay Line" = true then
                    "Calculated Amount (ACY)" := "Amount (ACY)";
            end;
        }
        field(50002; "USD Employer Amount"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Exchange Rate"; Decimal)
        {
            Editable = false;
        }
        field(50004; "USD Rate"; Decimal)
        {
        }
        field(50005; "Provisional Employer Contrib."; Decimal)
        {
        }
        field(50006; "Calculated Amount"; Decimal)
        {
        }
        field(50007; "Calculated Amount (ACY)"; Decimal)
        {
        }
        field(50008; "Associate Pay Element"; Boolean)
        {
        }
        field(50009; "R5 Group"; Option)
        {
            CalcFormula = Lookup("HR Payroll Group"."R5 Groups" WHERE(Code = FIELD("Payroll Group Code")));
            FieldClass = FlowField;
            OptionCaption = 'Employee,Administration';
            OptionMembers = Employee,Administration;
        }
        field(50010; "Employer Amount (ACY)"; Decimal)
        {
            Caption = 'Employer Amount (USD)';
            Editable = false;
        }
        field(80200; "Manual Pay Line"; Boolean)
        {
        }
        field(80202; "Payroll Ledger Entry No."; Integer)
        {
        }
        field(80203; Retrieved; Boolean)
        {
        }
        field(80204; "Not Included in Net Pay"; Boolean)
        {
        }
        field(80205; Explanation; Text[100])
        {
        }
        field(80206; "Split Entries"; Integer)
        {
            CalcFormula = Count("Split Pay Detail Line" WHERE("Pay Detail Line No." = FIELD("Line No."),
                                                               "Employee No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80207; "Efective Nb. of Days"; Decimal)
        {
            Description = 'PY2.0';
        }
        field(80208; "Total Sales Com. Work Days"; Decimal)
        {
            Description = 'PY2.0';
        }
        field(80209; "Loan No."; Code[20])
        {
            Description = 'EDM.IT';
        }
        field(80210; Taxable; Boolean)
        {
            CalcFormula = Lookup("Pay Element".Tax WHERE(Code = FIELD("Pay Element Code")));
            Description = 'EDM.IT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80212; "Posting Account No."; Code[50])
        {
            CalcFormula = Lookup("Pay Element"."Posting Account" WHERE(Code = FIELD("Pay Element Code")));
            Description = 'EDM.IT';
            FieldClass = FlowField;
        }
        field(80213; "Employer Account"; Code[50])
        {
            CalcFormula = Lookup("Pension Scheme"."Expense Account" WHERE("Associated Pay Element" = FIELD("Pay Element Code")));
            Description = 'EDM.IT';
            FieldClass = FlowField;
        }
        field(80214; "Exempt Tax Retro"; Decimal)
        {
            CaptionML = ENU = 'Exempt Tax Retro',
                        ENG = 'اعفاء ضريبي رجعي';
        }
        field(80215; "Employee Type"; Option)
        {
            CalcFormula = Lookup(Employee."Employee Type" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
            OptionCaption = 'Non declared – Engineers,Probation period,Employees,Contractual (labors 3%)';
            OptionMembers = "Non declared – Engineers","Probation period",Employees,"Contractual (labors 3%)";
        }
        field(80216; "Sub Payroll Code"; Code[20])
        {
        }
        Field(80217; "Payment Category"; Option)
        {
            CalcFormula = Lookup("Payroll Ledger Entry"."Payment Category" WHERE("Entry No." = FIELD("Payroll Ledger Entry No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Supplement';
            OptionMembers = " ",Supplement;
        }
        Field(80218; Declared; Option)
        {
            CalcFormula = Lookup("Payroll Ledger Entry".Declared WHERE("Entry No." = FIELD("Payroll Ledger Entry No."),
                                                                        "Employee No." = field("Employee No."),
                                                                        "Tax Year" = field("Tax Year"),
                                                                        Period = field(Period)));
            FieldClass = FlowField;
            OptionMembers = " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        }
        field(80219; "Not Included in NetPay"; Boolean)
        {
            CalcFormula = Lookup("Pay Element"."Not Included in Net Pay" WHERE(Code = FIELD("Pay Element Code")));
            Description = 'EDM.IT';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Line No.")
        {
        }
        key(Key2; "Employee No.", Open, Type, "Pay Element Code")
        {
            SumIndexFields = "Employer Amount";
        }
        key(Key3; "Employee No.", "Tax Year", "Pay Frequency", Period, "Pay Element Code", Recurring)
        {
        }
        key(Key4; Open, Type, "Pay Element Code")
        {
            SumIndexFields = Amount, Hours;
        }
        key(Key5; "Pay Element Code", Reference, "Employee No.", "Tax Year", "Payroll Group Code", "Pay Frequency", Period)
        {
        }
        key(Key6; "Pay Element Code", "Payroll Date", "Shortcut Dimension 1 Code", "Project Code", "Employee No.")
        {
            SumIndexFields = Amount;
        }
        key(Key7; "Employee No.", "Payroll Date", Type, Open)
        {
        }
        key(Key8; "Payroll Group Code", "Employee No.", Open, Type, "Pay Element Code")
        {
        }
        key(Key9; Open, "Payroll Group Code", "Pay Frequency", "Shortcut Dimension 1 Code", Type, "Pay Element Code")
        {
        }
        key(Key10; "Employee No.", "Pay Element Code", "Shortcut Dimension 1 Code", "Project Code", "Payroll Date")
        {
            SumIndexFields = Amount;
        }
        key(Key11; "Shortcut Dimension 1 Code")
        {
        }
        key(Key12; "Payroll Ledger Entry No.", "Pay Element Code", "Not Included in Net Pay")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        /*PayParam.GET;
        IF ("Pay Element Code" = PayParam."Basic Pay Code") OR ("Payroll Special Code") OR
            ("Manual Pay Line" = FALSE) THEN
          ERROR('You cannot Delete the %1 Pay Element.',Description);
        
        ReCalcWarning(GlobalActionType::Delete);
        */
        IF NOT Open THEN
            ERROR('Closed payroll details can not be deleted');
    end;

    trigger OnInsert();
    begin
        PayDetailLine.RESET;
        PayDetailLine.SETRANGE("Employee No.", "Employee No.");
        if PayDetailLine.FIND('+') then begin
            "Line No." := PayDetailLine."Line No." + 1;
            "Payroll Group Code" := PayDetailLine."Payroll Group Code";
            "Payroll Date" := PayDetailLine."Payroll Date";
        end
        else
            "Line No." := 1;

        Open := true;
        ReCalcWarning(GlobalActionType::Insert);
    end;

    trigger OnModify();
    begin
        ReCalcWarning(GlobalActionType::Modify);
    end;

    var
        PayDetailLine: Record "Pay Detail Line";
        PayParam: Record "Payroll Parameter";
        GlobalActionType: Option Insert,Modify,Delete;
        Employee: Record Employee;
        PayElement: Record "Pay Element";
        SpecPayElement: Record "Specific Pay Element";
        PayrollFunctions: Codeunit "Payroll Functions";

    procedure ReCalcWarning(ActionType: Option Insert,Modify,Delete);
    var
        PayDetailHeader: Record "Pay Detail Header";
        PayStatus: Record "Payroll Status";
    begin
        // Add in order to allow insert Sub Payroll Pay Detail Line - 15.05.2017 : A2+
        if Rec."Sub Payroll Code" <> '' then exit;
        // Add in order to allow insert Sub Payroll Pay Detail Line - 15.05.2017 : A2-
        if not PayDetailHeader.GET("Employee No.") then
            exit;
        if PayDetailHeader."Calculation Required" then
            exit;

        PayStatus.RESET;
        PayStatus.GET("Payroll Group Code", "Pay Frequency");

        /*CASE ActionType OF
          ActionType::Insert:
            MESSAGE(
              'The current period has not been finalised.\' +
              'Re-calculation is required after inserting pay details.');
          ActionType::Modify,ActionType::Delete:
            IF NOT CONFIRM(
              'The current period has not been finalised.\' +
              'Re-calculation is required after modifying pay details.\\' +
              'Do you want to continue?',FALSE)
            THEN
              ERROR('Changes were not saved.');
        END;*/

        PayDetailHeader."Calculation Required" := true;
        PayDetailHeader."Payslip Printed" := false;
        PayDetailHeader.MODIFY;

    end;
}

