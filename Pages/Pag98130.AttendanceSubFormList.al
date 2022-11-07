page 98130 "Attendance SubForm List"
{
    PageType = List;
    SourceTable = "Employee Absence";
    SaveValues = true;
    SourceTableView = SORTING("From Date", "To Date") ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Day of the Week"; "Day of the Week")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("From Date"; "From Date")
                {
                    Caption = 'Date';
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Shift Code"; "Shift Code")
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
                            if PayrollFunctions.EmployeeHasCauseofAbsenceBalance("Employee No.", "Cause of Absence Code", 1, 0D) = false then
                                MESSAGE('No Available Balance [ %1 ] !!! ', PayrollFunctions.GetEmpAbsenceEntitlementCurrentBalance("Employee No.", "Cause of Absence Code", 0D));
                        end;
                        //Added in order to check balance - 05.11.2016 : AIM -
                        CurrPage.UPDATE(true);
                    end;
                }
                field("From Time"; "From Time")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("To Time"; "To Time")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Hand Punch Exist"; "Hand Punch Exist")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Required Hrs"; "Required Hrs")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Attend Hrs."; "Attend Hrs.")
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
                field("Late Arrive"; "Late Arrive")
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
                field("Late Leave"; "Late Leave")
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
                field("Early Arrive"; "Early Arrive")
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
                field("Early Leave"; "Early Leave")
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
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to save the cell value - 15.09.2016 : AIM +
                        CurrPage.UPDATE;
                        //Added in order to save the cell value - 15.09.2016 : AIM -
                    end;
                }
                field("Actual Attend Hrs"; "Actual Attend Hrs")
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
                field("Actual Late Arrive"; "Actual Late Arrive")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Early Leave"; "Actual Early Leave")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Early Arrive"; "Actual Early Arrive")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Late Leave"; "Actual Late Leave")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
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
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
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
                field(Type; Type)
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field("Cause of Absence Code"; "Cause of Absence Code")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                }
                field(Period; Period)
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("To Date"; "To Date")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Portal Approval Hours"; "Portal Approval Hours")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Portal Remarks"; "Portal Remarks")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Attendance Sub Dimensions"; "Attendance Sub Dimensions")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    var
        HandPunch: Record "Hand Punch";
        PunchCnt: Integer;
    begin
        //+
        TotalLate := "Late Arrive" + "Early Leave";
        TotalEarly := "Early Arrive" + "Late Leave";

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

        CALCFIELDS("Hand Punch Exist");
        // 08.12.2017 : A2+
        HandPunch.RESET;
        HandPunch.SETRANGE("Real Date", Rec."From Date");
        HandPunch.SETRANGE("Attendnace No.", Rec."Attendance No.");
        if HandPunch.FINDFIRST then
            PunchCnt := HandPunch.COUNT;
        // 08.12.2017 : A2-

        if "Shift Code" = 'HOLIDAY' then
            StyleTxt := 'Strong'
        else
            if "Hand Punch Exist" = false then
                StyleTxt := 'Attention'
            // 08.12.2017 : A2+
            //ELSE IF "Attend Hrs." = 0 THEN
            else
                if ("Attend Hrs." = 0) or (PunchCnt mod 2 <> 0) then
                    // 08.12.2017 : A2-
                    StyleTxt := 'Ambiguous'
                else
                    StyleTxt := 'Standard';

        if "Shift Code" = 'NWD' then
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

        if "Required Hrs" > "Attend Hrs." then begin
            DeductionHrs := "Required Hrs" - "Attend Hrs.";
            OvertimeHrs := 0;
        end
        else begin
            DeductionHrs := 0;
            OvertimeHrs := "Attend Hrs." - "Required Hrs";
        end;


        if "Required Hrs" > "Actual Attend Hrs" then begin
            ActualDeductionHrs := "Required Hrs" - "Actual Attend Hrs";
            ActualOvertimeHrs := 0;
        end
        else begin
            ActualDeductionHrs := 0;
            ActualOvertimeHrs := "Actual Attend Hrs" - "Required Hrs";
        end;
    end;
}

