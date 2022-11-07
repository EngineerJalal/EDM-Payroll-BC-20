page 98104 "Allowance Deduction Temp Card"
{
    // version EDM.HRPY2

    Caption = 'Allowance Deduction Template';
    PageType = Card;
    Permissions = TableData "Allowance Deduction Template"=rimd;
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
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin

                        RefreshDetailsTotals(Code);
                    end;
                }
                field("Auto Generate";"Auto Generate")
                {
                    ApplicationArea=All;
                }
                field("Average Days/Month";"Average Days/Month")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin

                        RefreshDetailsTotals(Code);
                    end;
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
                part("Pay Elements";"Pay Element ListPart1")
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

    trigger OnDeleteRecord() : Boolean;
    var
        AllowPayElmt : Record "Allowance Deduction Pay Elemt";
        AllowCatg : Record "Allowance Deduction Temp Catg";
    begin
        AllowPayElmt.SETRANGE("Document No.",Code);
        if AllowPayElmt.FINDFIRST then
          AllowPayElmt.DELETEALL;

        AllowCatg.SETRANGE("Document No.",Code);
        if AllowCatg.FINDFIRST then
          AllowCatg.DELETEALL;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        // 27.07.2017 : A2+
        IsSchoolAllowance := false;
        // 27.07.2017 : A2-
    end;

    procedure RefreshDetailsTotals(RefCode : Code[20]);
    var
        AllowPayElemt : Record "Allowance Deduction Pay Elemt";
    begin
        AllowPayElemt.SETRANGE("Document No.",RefCode);
        if AllowPayElemt.FINDFIRST then
          repeat
            AllowPayElemt.CALCFIELDS("Affected by Working Days");
            if "Affected By Attendance" then
              AllowPayElemt.UpdateDailyAmount
            else
              AllowPayElemt.UpdateMonthlyAmount;
            //AllowPayElemt.VALIDATE("Monthly Amount");
            AllowPayElemt.MODIFY;
          until AllowPayElemt.NEXT = 0;
    end;
}

