page 98046 "HR System Code"
{
    // version SHR1.0,PY1.0,EDM.HRPY1

    Editable = false;
    PageType = List;
    SourceTable = "HR System Code";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea=All;
                }
                field(System;Rec.System)
                {
                    ApplicationArea=All;
                }
                field("Affects Payroll";Rec."Affects Payroll")
                {
                    ApplicationArea=All;
                }
                field(Category;Rec.Category)
                {
                    ApplicationArea=All;
                }
                field(Split;Rec.Split)
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Insert System Codes")
                {
                    Caption = 'Insert System Codes';
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        if CONFIRM('This Will Insert All System Codes. Do you Want to Continue ?',true) then
                          HRFunction.InsertSystemCodes;
                    end;
                }
            }
        }
    }

    var
        HRFunction : Codeunit "Human Resource Functions";
}

