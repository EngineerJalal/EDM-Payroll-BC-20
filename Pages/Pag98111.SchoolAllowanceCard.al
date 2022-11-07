page 98111 "School Allowance Card"
{
    // version EDM.HRPY2

    Caption = 'School Allowance Card';
    PageType = Card;
    SourceTable = "Allowance Deduction Template";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea=All;
                }
                field(Name;Name)
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Valid From";"Valid From")
                {
                    ApplicationArea=All;
                }
                field("Till Date";"Till Date")
                {
                    ApplicationArea=All;
                }
                field(Inactive;Inactive)
                {
                    ApplicationArea=All;
                }
            }
            group(Properties)
            {
                field("Applied by";"Applied by")
                {
                    Caption = 'Applied To';
                    ApplicationArea=All;
                }
                field("Declare Type";"Declare Type")
                {
                    ApplicationArea=All;
                }
                field("Maximum Children";"Maximum Children")
                {
                    ApplicationArea=All;
                }
                field("Affected By Attendance";"Affected By Attendance")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Auto Generate";"Auto Generate")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Average Days/Month";"Average Days/Month")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Apply to Period Day";"Apply to Period Day")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Apply to Period Month";"Apply to Period Month")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
            group(Lines)
            {
                part("Pay Elements";"School Allow Pay Element")
                {
                    Caption = 'Pay Elements';
                    SubPageLink = "Document No."=FIELD(Code);
                    ApplicationArea=All;
                }
                part("Apply to Category";"Categories ListPart")
                {
                    Caption = 'Apply to Category';
                    SubPageLink = "Document No."=FIELD(Code);
                    ApplicationArea=All;
                }
            }
            group("Allocation Per Month")
            {
                Caption = 'Allocation Per Month';
                field(JAN;JAN)
                {
                    ApplicationArea=All;
                }
                field(FEB;FEB)
                {
                    ApplicationArea=All;
                }
                field(MAR;MAR)
                {
                    ApplicationArea=All;
                }
                field(APR;APR)
                {
                    ApplicationArea=All;
                }
                field(MAY;MAY)
                {
                    ApplicationArea=All;
                }
                field(JUN;JUN)
                {
                    ApplicationArea=All;
                }
                field(JUL;JUL)
                {
                    ApplicationArea=All;
                }
                field(AUG;AUG)
                {
                    ApplicationArea=All;
                }
                field(SEP;SEP)
                {
                    ApplicationArea=All;
                }
                field(OCT;OCT)
                {
                    ApplicationArea=All;
                }
                field(NOV;NOV)
                {
                    ApplicationArea=All;
                }
                field(DEC;DEC)
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        IsSchoolAllowance := true;
        "Applied by" := "Applied by"::Child;
        "Maximum Children" := 5;
    end;
}

