page 98065 "Pay Detail Subform"
{
    // version PY1.0,EDM.HRPY1

    PageType = CardPart;
    SourceTable = "Pay Detail Line";
    SourceTableView = SORTING("Payroll Group Code","Employee No.",Open,Type,"Pay Element Code") WHERE(Open=CONST(true));

    layout
    {
        area(content)
        {
            repeater(PayEntry)
            {
                field("Payroll Group Code";"Payroll Group Code")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Employee No.";"Employee No.")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Split Entries";"Split Entries")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Efective Nb. of Days";"Efective Nb. of Days")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Pay Element Code";"Pay Element Code")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        PayElement.GET("Pay Element Code");
                        if (xRec."Pay Element Code" = PayParam."Basic Pay Code") and
                           (PayParam."Basic Pay Code" <> '') and                               // VIP2.00.01
                           ("Pay Element Code" <> xRec."Pay Element Code")
                        then
                          ERROR('You cannot rename the %1 pay element.',xRec.Description);

                        if (PayElement."Payroll Special Code") or
                           ("Pay Element Code" = PayParam."Basic Pay Code")
                        then
                          ERROR('You cannot add %1 as a pay element.',PayElement.Description);

                        PayDetailLine.RESET;
                        PayDetailLine.SETCURRENTKEY("Employee No.",Open,Type,"Pay Element Code");
                        PayDetailLine.SETRANGE("Employee No.","Employee No.");
                        PayDetailLine.SETRANGE(Open,true);
                        PayDetailLine.SETRANGE("Pay Element Code","Pay Element Code");
                        if PayDetailLine.FIND('-') then
                          ERROR('The record already exists.');
                    end;
                }
                field("Payroll Date";"Payroll Date")
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Type;Type)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Amount;Amount)
                {
                    ApplicationArea=All;
                }
                field("Calculated Amount";"Calculated Amount")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Amount (ACY)";"Amount (ACY)")
                {
                    DecimalPlaces = 2:2;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Calculated Amount (ACY)";"Calculated Amount (ACY)")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Employer Amount";"Employer Amount")
                {
                    ApplicationArea=All;
                }
                field(Recurring;Recurring)
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        if (not Recurring) and ("Pay Element Code" = PayParam."Basic Pay Code") then
                          ERROR('%1 must be a recurring pay component.',Description);
                    end;
                }
                field(Explanation;Explanation)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Exempt Tax Retro";"Exempt Tax Retro")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit();
    begin
        /*IF USERID <> '' THEN BEGIN
          HRFunction.SetPayGroupFilter(PayGroup);
          PayGroup.FILTERGROUP(2);
          FILTERGROUP(2);
          SETFILTER("Payroll Group Code",PayGroup.GETFILTER(Code));
          FILTERGROUP(0);
          PayGroup.FILTERGROUP(0);
        END;*/
        
        PayParam.GET;

    end;

    trigger OnModifyRecord() : Boolean;
    begin
        if "Pay Element Code" <> xRec."Pay Element Code" then
          if not CONFIRM('Overwrite Existing Pay Detail?') then
            exit;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        "Manual Pay Line" := true;
    end;

    trigger OnOpenPage();
    begin
        //FILTERGROUP(2);
        //SETRANGE("Payroll Special Code",FALSE);
        ///FILTERGROUP(0);
    end;

    var
        PayDetailLine : Record "Pay Detail Line";
        PayParam : Record "Payroll Parameter";
        PayStatus : Record "Payroll Status";
        PayElement : Record "Pay Element";
        PayGroup : Record "HR Payroll Group";
        HRFunction : Codeunit "Human Resource Functions";
        CalcEmpPay : Codeunit "Calculate Employee Pay";
        OldPeriodsToAdvance : Integer;
        TaxPeriod : Integer;
        HourlyRate : Decimal;
        GrossPay : Decimal;
        TaxPaid : Decimal;
        NIPaid : Decimal;
        Pension : Decimal;
        NetPay : Decimal;
        ActionType : Option Insert,Modify,Delete;

    procedure Set(EmpNo : Code[20]);
    begin
        SETRANGE("Employee No.",EmpNo);
        CurrPage.UPDATE;
    end;

    local procedure RecurringOnActivate();
    begin
        //CurrForm.Recurring.UPDATEEDITABLE(NOT "Payroll Special Code");
        //CurrPage.Recurring.UPDATEEDITABLE("Manual Pay Line");
    end;

    local procedure PayElementCodeOnBeforeInput();
    begin
        //CurrPage."Pay Element Code".UPDATEEDITABLE("Manual Pay Line");
        //CurrForm."Pay Element Code".UPDATEEDITABLE(NOT "Payroll Special Code");
    end;

    local procedure AmountOnBeforeInput();
    begin
        //CurrPage.Amount.UPDATEEDITABLE("Manual Pay Line");
    end;

    local procedure AmountACYOnBeforeInput();
    begin
        //CurrPage."Amount (ACY)".UPDATEEDITABLE("Manual Pay Line");
    end;

    local procedure EmployerAmountOnBeforeInput();
    begin
        //CurrPage."Employer Amount".UPDATEEDITABLE("Manual Pay Line");
    end;

    local procedure ExplanationOnBeforeInput();
    begin
        //CurrPage.Explanation.UPDATEEDITABLE("Manual Pay Line");
    end;
}

