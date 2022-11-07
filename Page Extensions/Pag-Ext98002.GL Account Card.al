pageextension 98002 "ExtGLAccountCard" extends "G/L Account Card"
{

    layout
    {
        addafter("Omit Default Descr. in Jnl.")
        {
            field("Exclude from Employee Stmt"; Rec."Exclude from Employee Stmt")
            {
                ApplicationArea = All;
            }
        }
    }
}

