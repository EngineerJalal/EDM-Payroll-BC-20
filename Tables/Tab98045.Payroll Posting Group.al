table 98045 "Payroll Posting Group"
{
    DrillDownPageID = "Payroll Posting Group";
    LookupPageID = "Payroll Posting Group";

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Cost of Payroll Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; "Payroll Liabilities Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Net Pay Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(7; "Cost of Payroll Account (ACY)"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(8; "Liabilities Account (ACY)"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(9; "Net Pay Account (ACY)"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(10; "Rounding Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(11; "Bank Pay Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(12; "Difference Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}