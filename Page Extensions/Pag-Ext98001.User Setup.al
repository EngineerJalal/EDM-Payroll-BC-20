pageextension 98001 "ExtUserSetup" extends "User Setup"
{

    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Allow Access Pay Status Page"; Rec."Allow Access Pay Status Page")
            {
                ApplicationArea=All;
            }
            field("Can Change Payroll Labor Law"; Rec."Can Change Payroll Labor Law")
            {
                ApplicationArea=All;
            }
            field("Allow Modify Payroll Ledger";Rec."Allow Modify Payroll Ledger")
            {
                ApplicationArea=All;
                
            }
        }
    }
}

