table 98051 "Pension Scheme"
{
    DataCaptionFields = "Scheme No.", "Scheme Name";
    DrillDownPageID = "Pension Scheme List";
    LookupPageID = "Pension Scheme List";

    fields
    {
        field(1; "Scheme No."; Code[10])
        {
            NotBlank = true;
        }
        field(10; "Scheme Name"; Text[30])
        {
        }
        field(11; "Amount Type"; Option)
        {
            OptionMembers = Percentage,"Fixed Amount";
        }
        field(12; "Employee Contribution %"; Decimal)
        {
        }
        field(13; "Employer Contribution %"; Decimal)
        {
        }
        field(14; "Tax Relief"; Boolean)
        {
            InitValue = true;
        }
        field(20; "Employee Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(30; "Employer Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(40; "No. of Members"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(1000; "Employee Posting Project Acc."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(1001; "Employer Posting Project Acc."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(1002; "Expense Project Acc."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50001; "Maximum Monthly Contribution"; Decimal)
        {
        }
        field(50002; "Foreigners Ineligible"; Boolean)
        {
        }
        field(50003; "Expense Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50004; Type; Option)
        {
            OptionCaption = '" ,EOSIND,FAMSUB,MHOOD,VacationSalary,VacTickets,Insurance,Bonus,GOSI,GOSI-FOR,HOUSING,IQAMA,11,12,ReturnTax,ReturnMH,Net Salary,FundContribution-Basic,FundContribution-Net,Medical,Baladiyah';
            OptionMembers = " ",EOSIND,FAMSUB,MHOOD,VacationSalary,VacTickets,Insurance,Bonus,GOSI,"GOSI-FOR",HOUSING,IQAMA,"11","12",ReturnTax,ReturnMH,"Net Salary","FundContribution-Basic","FundContribution-Net","Medical","Baladiyah";
        }
        field(50005; "Associated Pay Element"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(50006; "Prorata Amount in Termination"; Boolean)
        {
            Description = 'Meg02.00';
        }
        field(80201; "Maximum Applicable Age"; Integer)
        {
        }
        field(80202; "Manual Pension"; Boolean)
        {
            Description = 'MEG01.00';

            trigger OnValidate();
            begin
                if PensionScheme."Manual Pension" = false then
                    "Pension Payroll Date" := 0D;
            end;
        }
        field(80203; "Pension Payroll Date"; Date)
        {
            Description = 'MEG01.00';

            trigger OnValidate();
            begin
                if PensionScheme."Manual Pension" = true then
                    ERROR('you cannot modify Date');
            end;
        }
        field(80204; "Payroll Posting Group"; Code[20])
        {
            TableRelation = "Payroll Posting Group";
        }
        field(80205; "Vendor No."; Code[10])
        {
            TableRelation = Vendor;
        }
        field(80206; "Pension Type"; Code[10])
        {
            TableRelation = "Pension Types"."Pension Code" WHERE("Pension Labor Law" = FIELD("System Payroll Labor Law"));

            trigger OnValidate();
            begin
                IF PensionType.GET("Pension Type") THEN BEGIN
                    Type := PensionType."Pension Type";
                    "Amount Type Classification" := PensionType."Amount Type Classification";
                    "Employer Contribution %" := PensionType."Pension Employer Percent";
                    "Employee Contribution %" := PensionType."Pension Employee Percent";
                    "Amount Type" := PensionType."Formula Type";
                END;
            end;

            trigger OnLookup();
            begin
                PayParam.GET;
                PensionType.RESET;
                FilterGroup(2);
                PensionType.SETRANGE("Pension Labor Law", PayParam."Payroll Labor Law");
                FilterGroup(0);
                PensionType.SETRANGE("Pension Inactive", FALSE);
                IF PensionType.FINDSET THEN;

                CLEAR(PensionTypesList);
                PensionTypesList.SETTABLEVIEW(PensionType);
                PensionTypesList.LOOKUPMODE(TRUE);
                IF PensionTypesList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    PensionTypesList.SETSELECTIONFILTER(PensionType);

                    IF PensionType.FINDFIRST THEN
                        VALIDATE("Pension Type", PensionType."Pension Code");
                END;
            end;
        }
        field(80207; "Amount Type Classification"; Option)
        {
            OptionCaption = '" ,FIXED,VARIABLE"';
            OptionMembers = " ","FIXED",VARIABLE;
        }
        field(80208; "Scheme Caption"; Text[50])
        {
        }
        field(80209; "Pension Type Labor Law"; Option)
        {
            FieldClass = FlowField;
            OptionCaption = 'Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar';
            OptionMembers = Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar;
            CalcFormula = Lookup("Pension Types"."Pension Labor Law" WHERE("Pension Code" = FIELD("Pension Type")));
        }
        field(80210; "System Payroll Labor Law"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Payroll Parameter"."Payroll Labor Law");
            OptionCaption = 'Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar';
            OptionMembers = Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar;
        }
        field(90000; "Before Monthly Cont Date"; Date)
        {

        }
        field(90001; "Before Max Monthly Cont"; Decimal)
        {

        }

        field(90002; "Before Monthly Cont Date 2"; Date)
        {

        }
        field(90003; "Before Max Monthly Cont 2"; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; "Scheme No.")
        {
        }
        key(Key2; "Associated Pay Element", Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin

        if ((Type = Type::EOSIND) or (Type = Type::MHOOD) or (Type = Type::FAMSUB)) and
           (("Employee Contribution %" = 0) and ("Employer Contribution %" = 0)) then
            ERROR('Contribution Percentage must be defined.');
    end;

    trigger OnModify();
    begin
        if ((Type = Type::EOSIND) or (Type = Type::MHOOD) or (Type = Type::FAMSUB)) and
           (("Employee Contribution %" = 0) and ("Employer Contribution %" = 0)) then
            ERROR('Contribution Percentage must be defined.');
    end;

    var
        PensionScheme: Record "Pension Scheme";
        PensionType: Record "Pension Types";
        PayParam: Record "Payroll Parameter";
        PensionTypesList: Page "Pension Types";
}