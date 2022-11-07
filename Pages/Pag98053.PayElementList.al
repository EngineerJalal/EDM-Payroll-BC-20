page 98053 "Pay Element List"
{
    // version PY1.0,EDM.HRPY1

    Editable = true;
    PageType = List;
    SourceTable = "Pay Element";

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
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea=All;
                }
                field(Tax;Rec.Tax)
                {
                    ApplicationArea=All;
                }
                field("Affected By Working Days";Rec."Affected By Working Days")
                {
                    ApplicationArea=All;
                }
                field("Affected By Attendance Days";Rec."Affected By Attendance Days")
                {
                    ApplicationArea=All;
                }
                field("Link To Pay Element on Slip";Rec."Link To Pay Element on Slip")
                {
                    ApplicationArea=All;
                }
                field("Payroll Special Code";Rec."Payroll Special Code")
                {
                    ApplicationArea=All;
                }
                field("Holiday Accrual";Rec."Holiday Accrual")
                {
                    ApplicationArea=All;
                }
                field("Not Included in Net Pay";Rec."Not Included in Net Pay")
                {
                    ApplicationArea=All;
                }
                field("Days in  Month";Rec."Days in  Month")
                {
                    ApplicationArea=All;
                }
                field("Hours in  Day";Rec."Hours in  Day")
                {
                    ApplicationArea=All;
                }
                field("Posting Account";Rec."Posting Account")
                {
                    ApplicationArea=All;
                }
                field("Posting Account (ACY)";Rec."Posting Account (ACY)")
                {
                    ApplicationArea=All;
                }
                field("Show in Reports";Rec."Show in Reports")
                {
                    ApplicationArea=All;
                }
                field("Payslip Description";Rec."Payslip Description")
                {
                    ApplicationArea=All;
                }
                field("Calculated Amount";Rec."Calculated Amount")
                {
                    ApplicationArea=All;
                }
                field("Order No.";Rec."Order No.")
                {
                    ApplicationArea=All;
                }
                field("Affect Exempt Tax";Rec."Affect Exempt Tax")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Element")
            {
                Caption = '&Element';
                action("Specific &Calculation")
                {
                    Caption = 'Specific &Calculation';
                    RunObject = Page "Specific Pay Element";
                    RunPageLink = "Internal Pay Element ID"=FIELD(Code);
                    ApplicationArea=All;
                }
            }
        }
    }
}

