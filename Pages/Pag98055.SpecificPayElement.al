page 98055 "Specific Pay Element"
{
    // version PY1.0,EDM.HRPY1

    // PY3.0 : Add Pay Unit on the form

    AutoSplitKey = true;
    DataCaptionFields = "Internal Pay Element ID";
    DelayedInsert = false;
    PageType = Card;
    SourceTable = "Specific Pay Element";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Pay Element Code";"Pay Element Code")
                {
                    ApplicationArea=All;
                }
                field("Internal Pay Element ID";"Internal Pay Element ID")
                {
                    ApplicationArea=All;
                }
                field("Pay Element Name";"Pay Element Name")
                {
                    ApplicationArea=All;
                }
                field("Employee Category Code";"Employee Category Code")
                {
                    ApplicationArea=All;
                }
                field("Affected By Presence";"Affected By Presence")
                {
                    ApplicationArea=All;
                }
                field("Pay Unit";"Pay Unit")
                {
                    ApplicationArea=All;
                }
                field("% Basic Pay";"% Basic Pay")
                {
                    ApplicationArea=All;
                }
                field(Amount;Amount)
                {
                    ApplicationArea=All;
                }
                field("Amount (ACY)";"Amount (ACY)")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Wife Entitlement";"Wife Entitlement")
                {
                    ApplicationArea=All;
                }
                field("Per Children Entitlement";"Per Children Entitlement")
                {
                    ApplicationArea=All;
                }
                field("Per Diem Amount";"Per Diem Amount")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Maturity Period";"Maturity Period")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Splited;Splited)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }
    
    var
        PayDetailLine : Record "Pay Detail Line";
        PayrollFunction : Codeunit "Payroll Functions";
        Employee : Record Employee;
        Pay : Integer;
        PayDetailHeader : Record "Pay Detail Header";
        Window : Dialog;
}

