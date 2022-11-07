page 98054 "Pay Element"
{
    // version PY1.0,EDM.HRPY1

    PageType = List;
    SourceTable = "Pay Element";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        // 26.07.2017 : A2+
                        Rec."Show in PaySlip" := true;
                        Rec."Show in Reports" := true;
                        Rec."Payslip Description" := Rec.Description;
                        Rec."Description in PaySlip" := Rec.Description;
                        // 26.07.2017 : A2-
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Tax; Rec.Tax)
                {
                    Caption = 'Affect Income Tax';
                    ApplicationArea = All;
                }
                field("Affect NSSF"; Rec."Affect NSSF")
                {
                    ApplicationArea = All;
                }
                field("Payroll Special Code"; Rec."Payroll Special Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Affected By Working Days"; Rec."Affected By Working Days")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Affected By Attendance Days"; Rec."Affected By Attendance Days")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Show in Reports"; Rec."Show in Reports")
                {
                    Caption = 'Show in Dynamic Report';
                    ApplicationArea = All;
                }
                field("Payslip Description"; Rec."Payslip Description")
                {
                    Caption = 'Description in Dynamic Report';
                    ApplicationArea = All;
                }
                field("Show in PaySlip"; Rec."Show in PaySlip")
                {
                    Caption = 'Show in Dynamic Payslip';
                    ApplicationArea = All;
                }
                field("Description in PaySlip"; Rec."Description in PaySlip")
                {
                    Caption = 'Description in Dynamic PaySlip';
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    Caption = 'Order Sequence in Dynamic Report';
                    ApplicationArea = All;
                }
                field("R6 No."; Rec."R6 No.")
                {
                    Visible = LebanonLaborLaw;
                    ApplicationArea = All;
                }
                field("R5 No."; Rec."R5 No.")
                {
                    Visible = LebanonLaborLaw;
                    ApplicationArea = All;
                }
                field("R 10 No."; Rec."R 10 No.")
                {
                    Visible = LebanonLaborLaw;
                    ApplicationArea = All;
                }
                field("Calculated Amount"; Rec."Calculated Amount")
                {
                    ApplicationArea = All;
                }
                field("Days in  Month"; Rec."Days in  Month")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Multiplier; Rec.Multiplier)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Hours in  Day"; Rec."Hours in  Day")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Affect Exempt Tax"; Rec."Affect Exempt Tax")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Posting Account"; Rec."Posting Account")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Posting Account Job"; Rec."Posting Account Job")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Not Included in Net Pay"; Rec."Not Included in Net Pay")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Accounting Classification"; Rec."Accounting Classification")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Category Type"; Rec."Category Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Use Job"; Rec."Use Job")
                {
                    ApplicationArea = All;
                }
                field("Type Classification"; Rec."Type Classification")
                {
                    ApplicationArea = All;
                }
                field("Payment Category"; Rec."Payment Category")
                {
                    ApplicationArea = All;
                }
                field("Bank Letter Description"; "Bank Letter Description")
                {
                    ApplicationArea = All;
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
                    Image = CalculateCost;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Specific Pay Element";
                    RunPageLink = "Internal Pay Element ID" = FIELD(Code);
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if PayrollFunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        // 26.07.2017 : A2+
        Rec."Payroll Special Code" := true;
        // 26.07.2017 : A2-
    end;

    trigger OnOpenPage();
    begin
        PayParam.GET;
        LebanonLaborLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Lebanon);
    end;

    var
        PayrollFunction: Codeunit "Payroll Functions";
        LebanonLaborLaw: Boolean;
        PayParam: Record "Payroll Parameter";
        SKGVisibility: Boolean;
        HRSetup: Record "Human Resources Setup";
}

