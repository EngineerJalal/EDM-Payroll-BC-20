page 98004 "Attendance SubForm"
{
    PageType = ListPart;
    SourceTable = "Employee Absence";
    SaveValues = true;
    SourceTableView = SORTING("From Date", "To Date") ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Day of the Week"; Rec."Day of the Week")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    Caption = 'Date';
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Shift Code"; Rec."Shift Code")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        // 21.04.2017 : A2+
                        HRPermissions.SETRANGE("User ID", USERID);
                        if (HRPermissions.FINDFIRST) and (HRPermissions."Attendance Limited Access") then begin
                            if (Rec."Actual Attend Hrs" <> 0)
                               or (Rec."Actual Early Arrive" <> 0)
                               or (Rec."Actual Early Leave" <> 0)
                               or (Rec."Actual Late Arrive" <> 0)
                               or (Rec."Actual Late Leave" <> 0) then
                                ERROR('');
                        end;
                        // 21.04.2017 : A2-
                        //Added in order to check balance - 05.11.2016 : AIM +
                        HumanResourceSetupTbt.GET();
                        if HumanResourceSetupTbt."Check Entitlement Balance" = true then begin
                            if PayrollFunctions.EmployeeHasCauseofAbsenceBalance(Rec."Employee No.", Rec."Cause of Absence Code", 1, 0D) = false then
                                MESSAGE('No Available Balance [ %1 ] !!! ', PayrollFunctions.GetEmpAbsenceEntitlementCurrentBalance(Rec."Employee No.", Rec."Cause of Absence Code", 0D));
                        end;
                        //Added in order to check balance - 05.11.2016 : AIM -
                        CurrPage.UPDATE(true);
                    end;
                }
                field("From Time"; Rec."From Time")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("To Time"; Rec."To Time")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Hand Punch Exist"; Rec."Hand Punch Exist")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Required Hrs"; Rec."Required Hrs")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Attend Hrs."; Rec."Attend Hrs.")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(Overtime; OvertimeHrs)
                {
                    Caption = 'Overtime Hrs.';
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field(Deduction; DeductionHrs)
                {
                    Caption = 'Deduction Hrs.';
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Late Arrive"; Rec."Late Arrive")
                {
                    Caption = 'Late Arrive (Minute)';
                    Editable = DisableEditingForManager;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 15.09.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 15.09.2016 : AIM -
                    end;
                }
                field("Late Leave"; Rec."Late Leave")
                {
                    Caption = 'Late Leave  (Minute)';
                    Editable = DisableEditingForManager;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 15.09.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 15.09.2016 : AIM -
                    end;
                }
                field("Early Arrive"; Rec."Early Arrive")
                {
                    Caption = 'Early Arrive  (Minute)';
                    Editable = DisableEditingForManager;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 15.09.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 15.09.2016 : AIM -
                    end;
                }
                field("Early Leave"; Rec."Early Leave")
                {
                    Caption = 'Early Leave  (Minute)';
                    Editable = DisableEditingForManager;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 15.09.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 15.09.2016 : AIM -
                    end;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 15.09.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 15.09.2016 : AIM -
                    end;
                }
                field("Actual Attend Hrs"; Rec."Actual Attend Hrs")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(ActualOvertimeHrs; ActualOvertimeHrs)
                {
                    Caption = 'Actual Overtime Hrs';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(ActualDeductionHrs; ActualDeductionHrs)
                {
                    Caption = 'Actual Deduction Hrs';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Late Arrive"; Rec."Actual Late Arrive")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Early Leave"; Rec."Actual Early Leave")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Early Arrive"; Rec."Actual Early Arrive")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Late Leave"; Rec."Actual Late Leave")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = DisableEditingForManager;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 07.11.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 07.11.2016 : AIM -
                    end;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = DisableEditingForManager;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 07.11.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 07.11.2016 : AIM -
                    end;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Portal Approval Hours"; Rec."Portal Approval Hours")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Portal Remarks"; Rec."Portal Remarks")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Attendance Sub Dimensions"; Rec."Attendance Sub Dimensions")
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
    var
        HRSetup: Record "Human Resources Setup";
        PayrollStatus: Record "Payroll Status";
        EmployeeRec: Record "Employee";
        EmploymentTypeRec: Record "Employment Type";
    begin
        HRSetup.GET;
        IF HRSetup."Seperate Attend From Payroll" THEN begin
            Rec.CALCFIELDS("Payroll Group");
            PayrollStatus.SETRANGE("Payroll Group Code", PayrollGrp);
            if PayrollStatus.FINDFIRST then
                Rec.SETRANGE(Period, PayrollStatus."Attendance Period")
        end
        ELSE BEGIN
            EmployeeRec.SetRange("No.", EmployeeNo);
            IF EmployeeRec.FindFirst then
                Rec.SETRANGE(Period, EmployeeRec.Period)
        end;
        //
    end;

    trigger OnAfterGetRecord();
    var
        HandPunch: Record "Hand Punch";
        PunchCnt: Integer;
        HRSetup: Record "Human Resources Setup";
        PayrollStatus: Record "Payroll Status";
        EmployeeRec: Record "Employee";
    begin
        //+
        TotalLate := Rec."Late Arrive" + Rec."Early Leave";
        TotalEarly := Rec."Early Arrive" + Rec."Late Leave";

        //Replaced by function RefreshOvertimeDeductionHrs() - 16.06.2016 : AIM +
        /*
        IF "Required Hrs">"Attend Hrs." THEN
          BEGIN
            DeductionHrs:="Required Hrs"-"Attend Hrs.";
            OvertimeHrs:=0;
           END
        ELSE
          BEGIN
            DeductionHrs:=0;
            OvertimeHrs:="Attend Hrs."-"Required Hrs";
          END;
        */
        RefreshOvertimeDeductionHrs();
        //Replaced by function RefreshOvertimeDeductionHrs() - 16.06.2016 : AIM -

        Rec.CALCFIELDS("Hand Punch Exist");
        // 08.12.2017 : A2+
        HandPunch.RESET;
        HandPunch.SETRANGE("Real Date", Rec."From Date");
        HandPunch.SETRANGE("Attendnace No.", Rec."Attendance No.");
        if HandPunch.FINDFIRST then
            PunchCnt := HandPunch.COUNT;
        // 08.12.2017 : A2-

        if Rec."Shift Code" = 'HOLIDAY' then
            StyleTxt := 'Strong'
        else
            if Rec."Hand Punch Exist" = false then
                StyleTxt := 'Attention'
            // 08.12.2017 : A2+
            //ELSE IF "Attend Hrs." = 0 THEN
            else
                if (Rec."Attend Hrs." = 0) or (PunchCnt mod 2 <> 0) then
                    // 08.12.2017 : A2-
                    StyleTxt := 'Ambiguous'
                else
                    StyleTxt := 'Standard';

        if Rec."Shift Code" = 'NWD' then
            StyleTxt := 'Standard';
        //-
    end;

    trigger OnInit();
    begin
        // 20.04.2017 : A2+
        DisableEditingForManager := true;
        HRPermissions.SETRANGE("User ID", USERID);
        if (HRPermissions.FINDFIRST) and (HRPermissions."Attendance Limited Access" = true) then
            DisableEditingForManager := false;
        // 20.04.2017 : A2-
    end;

    var
        TotalLate: Decimal;
        TotalEarly: Decimal;
        OvertimeHrs: Decimal;
        DeductionHrs: Decimal;
        StyleTxt: Text[50];
        ActualOvertimeHrs: Decimal;
        ActualDeductionHrs: Decimal;
        HumanResourceSetupTbt: Record "Human Resources Setup";
        PayrollFunctions: Codeunit "Payroll Functions";
        HRPermissions: Record "HR Permissions";
        DisableEditingForManager: Boolean;
    local procedure RefreshOvertimeDeductionHrs();
    begin
        //Added in order to Refresh Overtime and Deduction Hrs - 16.06.2016 : AIM +-
        DeductionHrs := 0;
        OvertimeHrs := 0;
        ActualDeductionHrs := 0;
        ActualOvertimeHrs := 0;

        if Rec."Required Hrs" > Rec."Attend Hrs." then begin
            DeductionHrs := Rec."Required Hrs" - Rec."Attend Hrs.";
            OvertimeHrs := 0;
        end
        else begin
            DeductionHrs := 0;
            OvertimeHrs := Rec."Attend Hrs." - Rec."Required Hrs";
        end;


        if Rec."Required Hrs" > Rec."Actual Attend Hrs" then begin
            ActualDeductionHrs := Rec."Required Hrs" - Rec."Actual Attend Hrs";
            ActualOvertimeHrs := 0;
        end
        else begin
            ActualDeductionHrs := 0;
            ActualOvertimeHrs := Rec."Actual Attend Hrs" - Rec."Required Hrs";
        end;
    end;

    procedure SetFilters(PEmployeNo: Code[20]; PPayrollGrp: code[10]);
    var
    begin
        EmployeeNo := PEmployeNo;
        PayrollGrp := PPayrollGrp;
    end;

    var
        EmployeeNo: code[20];
        PayrollGrp: Code[10];
}

