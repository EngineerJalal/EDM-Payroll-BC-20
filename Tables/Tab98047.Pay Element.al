table 98047 "Pay Element"
{
    DrillDownPageID = "Pay Element List";
    LookupPageID = "Pay Element List";

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;Type;Option)
        {
            OptionMembers = Addition,Deduction;

            trigger OnValidate();
            begin
                if (Type = Type::Deduction) and (Type <> xRec.Type) then
                    "Holiday Accrual" := false;
            end;
        }
        field(4;Tax;Boolean)
        {
            InitValue = true;
        }
        field(5;NI;Boolean)
        {
            InitValue = true;
        }
        field(6;Pension;Boolean)
        {
        }
        field(7;Multiplier;Decimal)
        {
            DecimalPlaces = 3:3;
            InitValue = 0;
        }
        field(8;"Use Multiplier";Boolean)
        {
        }
        field(9;"Payroll Special Code";Boolean)
        {

            trigger OnValidate();
            begin
                PayDetailLine.RESET;
                PayDetailLine.SETCURRENTKEY(Open,Type,"Pay Element Code");
                PayDetailLine.SETRANGE(Open,true);
                PayDetailLine.SETRANGE("Pay Element Code",Code);
                PayDetailLine.MODIFYALL("Payroll Special Code","Payroll Special Code");
                MODIFY;
            end;
        }
        field(10;"Posting Account";Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(11;"Holiday Accrual";Boolean)
        {

            trigger OnValidate();
            begin
                if "Holiday Accrual" and (Type = Type::Deduction) then
                    ERROR('%1 is only Available for Additions.',FIELDNAME("Holiday Accrual"));
            end;
        }
        field(12;Overtime;Boolean)
        {
        }
        field(13;"Reset to Zero";Boolean)
        {

            trigger OnValidate();
            begin
                PayDetailLine.RESET;
                PayDetailLine.SETCURRENTKEY(Open,Type,"Pay Element Code");
                PayDetailLine.SETRANGE(Open,true);
                PayDetailLine.SETRANGE("Pay Element Code",Code);
                PayDetailLine.MODIFYALL("Reset to Zero","Reset to Zero");
                MODIFY;
            end;
        }
        field(14;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(15;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(16;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(17;"Employee No. Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(18;"Total Payment";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Pay Detail Line".Amount WHERE ("Pay Element Code"=FIELD(Code),
                                                              "Payroll Date"=FIELD("Date Filter"),
                                                              "Shortcut Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                              "Shortcut Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                              "Employee No."=FIELD("Employee No. Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Affected By Working Days";Boolean)
        {

            trigger OnValidate();
            begin
                if "Affected By Attendance Days" then
                    ERROR('Choose either Working OR Attendance Days');
            end;
        }
        field(20;"Affected By Attendance Days";Boolean)
        {

            trigger OnValidate();
            begin
                if "Affected By Working Days" then
                    ERROR('Choose either Working OR Attendance Days');
            end;
        }
        field(21;"Days in  Month";Integer)
        {
        }
        field(23;"Hours in  Day";Decimal)
        {
        }
        field(24;"Posting Account (ACY)";Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(25;"Not Included in Net Pay";Boolean)
        {

            trigger OnValidate();
            begin
                if "Not Included in Net Pay" then begin
                    IsLoan := false;
                    Emploan.RESET;
                    Emploan.SETCURRENTKEY("Employee No.","Associated Pay Element");
                    Emploan.SETRANGE("Associated Pay Element",Code);
                    if Emploan.FIND('-') then
                        IsLoan := true;
                    PayParam.GET;
                    if (Code = PayParam."Basic Pay Code") or (Code = PayParam."High Cost of Living Code") or
                        (Code = PayParam."Advance on Salary") or (IsLoan) then
                        ERROR ('This Option cannot be set for this corresponding Pay Element Code.');
                end;
            end;
        }
        field(26;"Link To Pay Element on Slip";Code[10])
        {
            Description = 'MEG01.00';
            TableRelation = "Pay Element"."Code";

            trigger OnValidate();
            begin
                if "Link To Pay Element on Slip" = Code then
                    ERROR('Link To PAy Element On Slip must be different from code');
            end;
        }
        field(27;"Include In Project Cost";Boolean)
        {
        }
        field(100;"R6 No.";Code[10])
        {
            Description = 'EDM.IT';
        }
        field(101;"R5 No.";Code[10])
        {
            Description = 'EDM.IT';
        }
        field(102;"R 10 No.";Code[10])
        {
        }
        field(103;"Show in Reports";Boolean)
        {
        }
        field(104;"Payslip Description";Text[100])
        {
        }
        field(105;"Calculated Amount";Decimal)
        {
            CalcFormula = Sum("Pay Detail Line"."Calculated Amount" WHERE ("Employee No."=FIELD("Employee No. Filter"),
                                                                           "Pay Element Code"=FIELD(Code),
                                                                           "Payroll Date"=FIELD("Date Filter"),
                                                                           "Payment Category"=Field("Payment Category Filter")));
            FieldClass = FlowField;
        }
        field(106;"Order No.";Integer)
        {
        }
        field(107;"Affect Exempt Tax";Boolean)
        {
        }
        field(108;"Calculated Amount (ACY)";Decimal)
        {
            CalcFormula = Sum("Pay Detail Line"."Calculated Amount (ACY)" WHERE ("Employee No."=FIELD("Employee No. Filter"),
                                                                                 "Pay Element Code"=FIELD(Code),
                                                                                 "Payroll Date"=FIELD("Date Filter")));
            Caption = 'Calculated Amount (USD)';
            FieldClass = FlowField;
        }
        field(1000;"Posting Account Job";Code[20])
        {
            Description = 'Account Posting For Employees working on Projects';
            TableRelation = "G/L Account"."No.";
        }
        field(60000;"Payment Category";Option)
        {
            OptionMembers = " ",Supplement;
        }
        field(60001;"Affect NSSF";Boolean)
        {
        }
        field(60002;"Show in PaySlip";Boolean)
        {
        }
        field(60003;"Description in PaySlip";Text[50])
        {
        }
        field(60004;"Sub-Type";Code[10])
        {
        }
        field(60005;"Category Type";Option)
        {
            OptionCaption = '" ,Basic,Transportation,FamilySubscription-6,MedicalMotherhood-9,EOS-8.5"';
            OptionMembers = " ",Basic,Transportation,"FamilySubscription-6","MedicalMotherhood-9","EOS-8.5";
        }
        field(60006;"Accounting Classification";Option)
        {
            OptionCaption = '.,Cost';
            OptionMembers = ".",Cost;
        }
        field(60007;"Use Job";Boolean)
        {
            CaptionClass = 'Post with JOB';
        }
        field(60008;"Type Classification";Option)
        {
            OptionCaption = '" ,FIXED,VARIABLE"';
            OptionMembers = " ","FIXED",VARIABLE;
        }
        field(60009;"Affect Paid Tax";Boolean)
        {
        }
        field(60010;"Add to Special Total";Boolean)
        {
            Description = 'Added for RHU Dynamics Report Special Total';
        }
        field(60011;"Show in SKG PaySlip";Boolean)
        {
        }
        Field(60012;"Payment Category Filter";Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = ' ,Supplement'; 
            OptionMembers = " ",Supplement;
        }
        field(60013;"Bank Letter Description";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
        key(Key2;Type,"Code")
        {
        }
        key(Key3;"Order No.","Code",Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Payroll Special Code" then
            ERROR('The Selected Pay Element is Necessary for Payroll and cannot be Deleted.');

        PayDetailLine.RESET;
        PayDetailLine.SETCURRENTKEY(Open,Type,"Pay Element Code");
        PayDetailLine.SETRANGE("Pay Element Code",Code);
        if PayDetailLine.FIND('-') then
            ERROR('Pay Element cannot be Deleted : Pay Element assigned to one or more Employees');
    end;

    trigger OnModify();
    begin
        if Description <> xRec.Description then begin
            PayDetailLine.RESET;
            PayDetailLine.SETCURRENTKEY("Pay Element Code");
            PayDetailLine.SETRANGE("Pay Element Code",Code);
            if PayDetailLine.FIND('-') then
            repeat
                PayDetailLine.Description := Description;
                PayDetailLine.MODIFY;
            until PayDetailLine.NEXT = 0;
        end;
    end;

    var
        PayDetailLine : Record "Pay Detail Line";
        PayParam : Record "Payroll Parameter";
        IsLoan : Boolean;
        Emploan : Record "Employee Loan";
}