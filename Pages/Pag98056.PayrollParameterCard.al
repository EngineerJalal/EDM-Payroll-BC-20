page 98056 "Payroll Parameter Card"
{
    // version PY1.0,EDM.HRPY1

    // MEG01.00 : add new field on the form of hospitalization

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Payroll Parameter";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Integrate to G/L"; Rec."Integrate to G/L")
                {
                    ApplicationArea = All;
                }
                field("Payroll Labor Law"; Rec."Payroll Labor Law")
                {
                    ApplicationArea = All;
                }
                field("Tax Exempt P/Y Single"; Rec."Tax Exempt P/Y Single")
                {
                    Visible = NigeriaPayLaw OR LebanonPayLaw OR IraqPayLaw OR EgyptPayLaw;
                    ApplicationArea = All;
                }
                field("Tax Exempt P/Y NonWork Spouse"; Rec."Tax Exempt P/Y NonWork Spouse")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Tax Exempt P/Y Per Child"; Rec."Tax Exempt P/Y Per Child")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Exemption % from Taxable"; Rec."Exemption % from Taxable")
                {
                    Visible = NigeriaPayLaw;
                    ApplicationArea = All;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name (ACY)"; Rec."Journal Batch Name (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Supplement"; Rec."Journal Batch Supplement")
                {
                    ApplicationArea = All;
                }
                field("Enable Payment Acc. Grouping"; Rec."Enable Payment Acc. Grouping")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name Pay"; Rec."Journal Template Name Pay")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name Pay"; Rec."Journal Batch Name Pay")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Supplement Pay"; Rec."Journal Batch Supplement Pay")
                {
                    ApplicationArea = All;
                }
                field("Contractual Tax %"; Rec."Contractual Tax %")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Max. Pension Age"; Rec."Max. Pension Age")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Max. Pension Eligible Child"; Rec."Max. Pension Eligible Child")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Rounding Precision (LCY)"; Rec."Rounding Precision (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Rounding Type (LCY)"; Rec."Rounding Type (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Rounding Precision (ACY)"; Rec."Rounding Precision (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Rounding Type (ACY)"; Rec."Rounding Type (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Summary Payroll to GL Transfer"; Rec."Summary Payroll to GL Transfer")
                {
                    ApplicationArea = All;
                }
                field("Original Payroll Currency"; Rec."Original Payroll Currency")
                {
                    ApplicationArea = All;
                }
                field("No Income Tax Retro"; Rec."No Income Tax Retro")
                {
                    ApplicationArea = All;
                }
                field("No Pension Retro"; Rec."No Pension Retro")
                {
                    Caption = 'No Pension Retroactive';
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Discard Negative Income Tax"; Rec."Discard Negative Income Tax")
                {
                    ApplicationArea = All;
                }
                field("Tax Bands Decision Date"; Rec."Tax Bands Decision Date")
                {
                    ApplicationArea = All;
                }
                field("Payroll NET Precision"; Rec."Payroll NET Precision")
                {
                    Caption = 'Payroll [NET PAY] Precision';
                    ApplicationArea = All;
                }
                field("NSSF Precision"; Rec."NSSF Precision")
                {
                    ApplicationArea = All;
                }
                field("Income Tax Precision"; Rec."Income Tax Precision")
                {
                    ApplicationArea = All;
                }
                field("Employ-Termination Affect Tax"; Rec."Employ-Termination Affect Tax")
                {
                    Caption = 'Employment-Termination Dates Affect Income Tax';
                    ApplicationArea = All;
                }
                field("Employ-Termination Affect NSSF"; Rec."Employ-Termination Affect NSSF")
                {
                    ApplicationArea = All;
                }
                field("Auto Import Recurring Journals"; Rec."Auto Import Recurring Journals")
                {
                    ApplicationArea = All;
                }
                field("Payroll Finalize Type"; Rec."Payroll Finalize Type")
                {
                    ApplicationArea = All;
                }
                field("Group By Dimension"; Rec."Group By Dimension")
                {
                    Caption = 'Group Posting By Dimension';
                    ApplicationArea = All;
                }
                field("Temp Batch Name"; Rec."Temp Batch Name")
                {
                    Caption = 'Payroll Temporary Posting Batch';
                    ApplicationArea = All;
                }
                field("Temp Batch Supplement"; Rec."Temp Batch Supplement")
                {
                    Caption = 'Supplement Temporary Posting Batch';
                    ApplicationArea = All;
                }
                field("Temp Pay Batch Name"; Rec."Temp Pay Batch Name")
                {
                    Caption = 'Payment Temporary Batch';
                    ApplicationArea = All;
                }
                field("Temp Pay Batch Supplement"; Rec."Temp Pay Batch Supplement")
                {
                    Caption = 'Supplement Temporary Batch';
                    ApplicationArea = All;
                }
                field("Delete Temporary Posting Batch"; Rec."Delete Temporary Posting Batch")
                {
                    ApplicationArea = All;
                }
                field("Auto Copy Payroll Dimensions"; Rec."Auto Copy Payroll Dimensions")
                {
                    ApplicationArea = All;
                }
                field("ACY Currency Rate"; Rec."ACY Currency Rate")
                {
                    ApplicationArea = All;
                }
                field("Monthly ACY Currency Rate"; Rec."Monthly ACY Currency Rate")
                {
                    ApplicationArea = All;
                }
                field("ACY Exchange Operation"; Rec."ACY Exchange Operation")
                {
                    ApplicationArea = All;
                }
                field("Use Payroll ACY Rate"; Rec."Use Payroll ACY Rate")
                {
                    ApplicationArea = All;
                }
                field("Show Pay Element with Amount 0"; Rec."Show Pay Element with Amount 0")
                {
                    ApplicationArea = All;
                }
                field("Disable Emp Dimension Validation"; Rec."Disable Emp Dim Validation")
                {
                    ApplicationArea = All;
                }
                field("Lock Payroll Date"; Rec."Lock Payroll Date")
                {
                    ApplicationArea = All;
                }
                field("Budget Resouce No."; Rec."Budget Resouce No.")
                {
                    ApplicationArea = All;
                }
                field("MHOOD Retro Start Date"; Rec."MHOOD Retro Start Date")
                {
                    ApplicationArea = All;
                }
                field("Family Sub Retro Start Date"; Rec."Family Sub Retro Start Date")
                {
                    ApplicationArea = All;
                }
                field("EOS Retro Start Date"; Rec."EOS Retro Start Date")
                {
                    ApplicationArea = All;
                }
            }
            group("Pay Element Codes")
            {
                Caption = 'Pay Element Codes';
                field("Basic Pay Code"; Rec."Basic Pay Code")
                {
                    ApplicationArea = All;
                }
                field("Cost of Living"; Rec."Cost of Living")
                {
                    ApplicationArea = All;

                }
                field("Non-Taxable Transp. Code"; Rec."Non-Taxable Transp. Code")
                {
                    Caption = 'Transportation';
                    ApplicationArea = All;
                }
                field("Family Allowance Code"; Rec."Family Allowance Code")
                {
                    ApplicationArea = All;
                }
                field("Income Tax Code"; Rec."Income Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Advance on Salary"; Rec."Advance on Salary")
                {
                    ApplicationArea = All;
                }
                field(Loan; Rec.Loan)
                {
                    ApplicationArea = All;
                }
                field(OverTime; Rec.OverTime)
                {
                    ApplicationArea = All;
                }
                field("Absence Deduction"; Rec."Absence Deduction")
                {
                    ApplicationArea = All;
                }
                field("Late Arrive Deduction"; Rec."Late Arrive Deduction")
                {
                    ApplicationArea = All;
                }
                field("Accounting Deduction"; Rec."Accounting Deduction")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Retro Family Allow Addition"; Rec."Retro Family Allow Addition")
                {
                    ApplicationArea = All;
                }
                field("Retro Family Allow Deduction"; Rec."Retro Family Allow Deduction")
                {
                    ApplicationArea = All;
                }
                field(Bonus; Rec.Bonus)
                {
                    ApplicationArea = All;
                }
            }
            group("Employee Monthly Pay Elements")
            {
                Caption = 'Employee Monthly Pay Elements';
                field("Extra Salary"; Rec."Extra Salary")
                {
                    ApplicationArea = All;
                }
                field("Mobile allowance"; Rec."Mobile allowance")
                {
                    Caption = 'Mobile allowance';
                    ApplicationArea = All;
                }
                field("Car Allowance"; Rec."Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("Housing Allowance"; Rec."Housing Allowance")
                {
                    ApplicationArea = All;
                }
                field(Food; Rec.Food)
                {
                    Caption = 'Food Allowance';
                    ApplicationArea = All;
                }
                field("Ticket Allowance"; Rec."Ticket Allowance")
                {
                    ApplicationArea = All;
                }
                field("Production Allowance"; Rec."Production Allowance")
                {
                    Caption = 'Special Amount';
                    ApplicationArea = All;
                }
                field("Commision Addition"; Rec."Commision Addition")
                {
                    Caption = 'Insurance Benefit';
                    ApplicationArea = All;
                }
                field("High Cost of Living Code"; Rec."High Cost of Living Code")
                {
                    CaptionClass = 'High Cost of Living';
                    ApplicationArea = All;
                }
                field(Allowance; Rec.Allowance)
                {
                    Caption = 'Other Allowance';
                    ApplicationArea = All;
                }
                field("Water Compensation Allowance"; Rec."Water Compensation Allowance")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Comission Deduction"; Rec."Comission Deduction")
                {
                    Caption = 'Special Deduction';
                    ApplicationArea = All;
                }
                field("Employee Insurance Tax Code"; Rec."Employee Insurance Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Employer Insurance Tax Code"; Rec."Employer Insurance Tax Code")
                {
                    ApplicationArea = All;
                }
            }
            group("Payroll Journals")
            {
                Caption = 'Payroll Journals';
                field("Credit of PTF Journal"; Rec."Credit of PTF Journal")
                {
                    ApplicationArea = All;
                }
                field("Overload for PTF Journal"; Rec."Overload for PTF Journal")
                {
                    ApplicationArea = All;
                }
                field("Month 13 Journal"; Rec."Month 13 Journal")
                {
                    ApplicationArea = All;
                }
                field("Month 13"; Rec."Month 13")
                {
                    ApplicationArea = All;
                }
            }
            group(Scholarship)
            {
                Caption = 'Scholarship';
                Visible = false;
                field("Scholarship Period Filter"; Rec."Scholarship Period Filter")
                {
                    ApplicationArea = All;
                }
                field("Scholarship Code"; Rec."Scholarship Code")
                {
                    ApplicationArea = All;
                }
                field("Min. Scholarship Age"; Rec."Min. Scholarship Age")
                {
                    ApplicationArea = All;
                }
                field("Max. Scholarship Age"; Rec."Max. Scholarship Age")
                {
                    ApplicationArea = All;
                }
                field("Max.Scholarship Eligible Child"; Rec."Max.Scholarship Eligible Child")
                {
                    ApplicationArea = All;
                }
                field("Max. Scholarship Allowance"; Rec."Max. Scholarship Allowance")
                {
                    ApplicationArea = All;
                }
            }
            group("Sales Commission")
            {
                Caption = 'Sales Commission';
                Visible = false;
                field("Sales Commission Factor"; Rec."Sales Commission Factor")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = All;
                }
                field("Porter Com. Fixed Amt"; Rec."Porter Com. Fixed Amt")
                {
                    ApplicationArea = All;
                }
                field("Merhandiser Com. Fixed Amt"; Rec."Merhandiser Com. Fixed Amt")
                {
                    ApplicationArea = All;
                }
            }
            group(Picture)
            {
                Caption = 'Picture';
                Visible = false;
                field("Payroll Logo"; Rec."Payroll Logo")
                {
                    ApplicationArea = All;
                }
            }
            group("NSSF")
            {
                field("Before Monthly Cont Date"; Rec."Before Monthly Cont Date")
                {
                    ApplicationArea = All;
                }
                field("Before Monthly Cont Date 2"; Rec."Before Monthly Cont Date 2")
                {
                    ApplicationArea = All;
                }
                field("MHood Max Monthly Cont"; Rec."MHood Max Monthly Cont")
                {
                    ApplicationArea = All;
                }
                field("MHood Before Max Monthly Cont"; Rec."MHood Before Max Monthly Cont")
                {
                    ApplicationArea = All;
                }
                field("MHood Before Max Monthly Cont2"; Rec."MHood Before Max Monthly Cont2")
                {
                    ApplicationArea = All;
                }
                field("FSUB Max Monthly Cont"; Rec."FSUB Max Monthly Cont")
                {
                    ApplicationArea = All;
                }
                field("FSUB Before Max Monthly Cont"; Rec."FSUB Before Max Monthly Cont")
                {
                    ApplicationArea = All;
                }
                field("FSUB Before Max Monthly Cont2"; Rec."FSUB Before Max Monthly Cont2")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        RESET;
        if not GET then begin
            INIT;
            INSERT;
        end;

        SetVisibleFields;
    end;

    var
        PictureExists: Boolean;
        Text001: Label 'Do you want to replace the existing picture?';
        Text002: Label 'Do you want to delete the picture?';
        EgyptPayLaw: Boolean;
        NigeriaPayLaw: Boolean;
        LebanonPayLaw: Boolean;
        IraqPayLaw: Boolean;
        QatarPayLaw: Boolean;
        UAEPayLaw: Boolean;
        HRSetup: Record "Human Resources Setup";

    local procedure SetVisibleFields();
    begin
        LebanonPayLaw := (Rec."Payroll Labor Law" = Rec."Payroll Labor Law"::Lebanon);
        NigeriaPayLaw := (Rec."Payroll Labor Law" = Rec."Payroll Labor Law"::Nigeria);
        EgyptPayLaw := (Rec."Payroll Labor Law" = Rec."Payroll Labor Law"::Egypt);
        IraqPayLaw := (Rec."Payroll Labor Law" = Rec."Payroll Labor Law"::Iraq);
        QatarPayLaw := (Rec."Payroll Labor Law" = Rec."Payroll Labor Law"::Qatar);
        UAEPayLaw := (Rec."Payroll Labor Law" = Rec."Payroll Labor Law"::UAE);
    end;
}