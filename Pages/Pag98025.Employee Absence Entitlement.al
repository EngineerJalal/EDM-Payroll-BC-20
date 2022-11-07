page 98025 "Employee Absence Entitlement"
{
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    RefreshOnActivate = false;
    SourceTable = "Employee Absence Entitlement";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unit of Measure"; UnitofMeasure)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Till Date"; Rec."Till Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Entitlement; Rec.Entitlement)
                {
                    Editable = true;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CalculateEntitlementTillToday();
                    end;
                }
                field("Entitlement Till Today"; EntitlementTillToday)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Allowed Till Today"; AllowedTillToday)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transfer from Previous Year"; Rec."Transfer from Previous Year")
                {
                    ApplicationArea = All;
                }
                field("Manual Additions"; Rec."Manual Additions")
                {
                    ApplicationArea = All;
                }
                field(Taken; Rec.Taken)
                {
                    ApplicationArea = All;
                }
                field("Manual Deductions"; Rec."Manual Deductions")
                {
                    ApplicationArea = All;
                }
                field("Attendance Additions"; Rec."Attendance Additions")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attendance Deductions"; Rec."Attendance Deductions")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field(FlowFieldCalc; FlowFieldCalc)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Allowed Till End Of Month"; AllowedTillEndOfMonth)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("First Year Entitlement"; Rec."First Year Entitlement")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Year Entitlement"; Rec."Year Entitlement")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employment date"; Rec."Employment date")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("AL Start Date"; Rec."AL Start Date")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Auto Generate Employees Entitlement")
            {
                Caption = 'Auto Generate Employees Entitlement';
                Image = GeneralPostingSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Generate Emp Absence Entitle";
                ApplicationArea = All;
            }
            action("Refresh Totals")
            {
                ApplicationArea = All;
                trigger OnAction();
                var
                    HRSetupRec: Record "Human Resources Setup";
                    EmployeeAbsenceEntitlementALRec: Record "Employee Absence Entitlement";
                    EmployeeAbsenceEntitlementSundayRec: Record "Employee Absence Entitlement";
                    EmployeeAbsenceEntitlementHolidayRec: Record "Employee Absence Entitlement";
                begin
                    /*if Rec.FINDFIRST then
                        repeat
                            Rec."Attendance Additions" := PayrollFunctions.GetEmpAssignedOvertimeToALEntitlement(Rec."Employee No.", Rec."Cause of Absence Code", Rec."From Date", Rec."Till Date");
                            Rec."Attendance Deductions" := PayrollFunctions.GetEmpAssignedAbsenceToALEntitlement(Rec."Employee No.", Rec."Cause of Absence Code", Rec."From Date", Rec."Till Date");
                            Rec.Taken := PayrollFunctions.GetEmpTakenAbsenceEntitlement(Rec."Employee No.", Rec."Cause of Absence Code", Rec."From Date", Rec."Till Date", false);
                            Rec.MODIFY;
                        until Rec.NEXT = 0;*/
                    HRSetupRec.GEt;
                    EmployeeAbsenceEntitlementALRec.RESET;
                    EmployeeAbsenceEntitlementALRec.SETFILTER("Cause of Absence Code", '%1|%2', HRSetupRec."Annual Leave Code", HRSetupRec."Sick Leave Code");
                    EmployeeAbsenceEntitlementALRec.SETFILTER("From Date", '>=%1', Rec."From Date");
                    EmployeeAbsenceEntitlementALRec.SETFILTER("Till Date", '<=%1', Rec."Till Date");
                    if EmployeeAbsenceEntitlementALRec.FINDFIRST then
                        repeat
                            EmployeeAbsenceEntitlementALRec."Attendance Additions" := PayrollFunctions.GetEmpAssignedOvertimeToALEntitlement(EmployeeAbsenceEntitlementALRec."Employee No.", EmployeeAbsenceEntitlementALRec."Cause of Absence Code", EmployeeAbsenceEntitlementALRec."From Date", EmployeeAbsenceEntitlementALRec."Till Date");
                            EmployeeAbsenceEntitlementALRec."Attendance Deductions" := PayrollFunctions.GetEmpAssignedAbsenceToALEntitlement(EmployeeAbsenceEntitlementALRec."Employee No.", EmployeeAbsenceEntitlementALRec."Cause of Absence Code", EmployeeAbsenceEntitlementALRec."From Date", EmployeeAbsenceEntitlementALRec."Till Date");
                            EmployeeAbsenceEntitlementALRec.Taken := PayrollFunctions.GetEmpTakenAbsenceEntitlement(EmployeeAbsenceEntitlementALRec."Employee No.", EmployeeAbsenceEntitlementALRec."Cause of Absence Code", EmployeeAbsenceEntitlementALRec."From Date", EmployeeAbsenceEntitlementALRec."Till Date", false);
                            EmployeeAbsenceEntitlementALRec.MODIFY;
                        until EmployeeAbsenceEntitlementALRec.NEXT = 0;
                    //
                    HRSetupRec.GEt;
                    EmployeeAbsenceEntitlementSundayRec.Reset;
                    EmployeeAbsenceEntitlementSundayRec.SETRANGE("Cause of Absence Code", HRSetupRec."Sunday Leave Code");
                    EmployeeAbsenceEntitlementSundayRec.SETFILTER("From Date", '>=%1', Rec."From Date");
                    EmployeeAbsenceEntitlementSundayRec.SETFILTER("Till Date", '<=%1', Rec."Till Date");
                    if EmployeeAbsenceEntitlementSundayRec.FindFirst then
                        repeat
                            EmployeeAbsenceEntitlementSundayRec."Attendance Additions" := PayrollFunctions.GetSundaysToALEntitlement(EmployeeAbsenceEntitlementSundayRec."Employee No.", HRSetupRec."Sunday Leave Code", EmployeeAbsenceEntitlementSundayRec."From Date", EmployeeAbsenceEntitlementSundayRec."Till Date");
                            //EmployeeAbsenceEntitlementSundayRec."Attendance Deductions" :=  PayrollFunctions.GetSundaysAbsenceToALEntitlement(EmployeeAbsenceEntitlementSundayRec."Employee No.",HRSetupRec."Sunday Leave Code", EmployeeAbsenceEntitlementSundayRec."From Date", EmployeeAbsenceEntitlementSundayRec."Till Date");   
                            EmployeeAbsenceEntitlementSundayRec.Taken := PayrollFunctions.GetEmpTakenAbsenceEntitlement(EmployeeAbsenceEntitlementSundayRec."Employee No.", HRSetupRec."Sunday Leave Code", EmployeeAbsenceEntitlementSundayRec."From Date", EmployeeAbsenceEntitlementSundayRec."Till Date", false);
                            EmployeeAbsenceEntitlementSundayRec.MODIFY;
                        until EmployeeAbsenceEntitlementSundayRec.NEXT = 0;
                    //
                    HRSetupRec.GEt;
                    EmployeeAbsenceEntitlementHolidayRec.RESET;
                    EmployeeAbsenceEntitlementHolidayRec.SETRANGE("Cause of Absence Code", HRSetupRec."Holiday Leave Code");
                    EmployeeAbsenceEntitlementHolidayRec.SETFILTER("From Date", '>=%1', Rec."From Date");
                    EmployeeAbsenceEntitlementHolidayRec.SETFILTER("Till Date", '<=%1', Rec."Till Date");
                    if EmployeeAbsenceEntitlementHolidayRec.FindFirst then
                        repeat
                            EmployeeAbsenceEntitlementHolidayRec."Attendance Additions" := PayrollFunctions.GetHolidaysToALEntitlement(EmployeeAbsenceEntitlementHolidayRec."Employee No.", HRSetupRec."Holiday Leave Code", EmployeeAbsenceEntitlementHolidayRec."From Date", EmployeeAbsenceEntitlementHolidayRec."Till Date");
                            //EmployeeAbsenceEntitlementHolidayRec."Attendance Deductions" :=  PayrollFunctions.GetHolidayssAbsenceToALEntitlement(EmployeeAbsenceEntitlementHolidayRec."Employee No.",HRSetupRec."Holiday Leave Code", EmployeeAbsenceEntitlementHolidayRec."From Date", EmployeeAbsenceEntitlementHolidayRec."Till Date");   
                            EmployeeAbsenceEntitlementHolidayRec.Taken := PayrollFunctions.GetEmpTakenAbsenceEntitlement(EmployeeAbsenceEntitlementHolidayRec."Employee No.", HRSetupRec."Holiday Leave Code", EmployeeAbsenceEntitlementHolidayRec."From Date", EmployeeAbsenceEntitlementHolidayRec."Till Date", false);
                            EmployeeAbsenceEntitlementHolidayRec.MODIFY;
                        until EmployeeAbsenceEntitlementHolidayRec.NEXT = 0;
                end;
            }
            action("Auto Update Emp Entitlement")
            {
                RunObject = Report "Auto Update Emp Entitlement";
                Visible = ShowAction;
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CauseofAbsence.GET(Rec."Cause of Absence Code");
        UnitofMeasure := CauseofAbsence."Unit of Measure Code";
        FlowFieldCalc := false;
        EmployeeJournals.SETRANGE("Employee No.", Rec."Employee No.");
        EmployeeJournals.SETRANGE("Cause of Absence Code", Rec."Cause of Absence Code");
        EmployeeJournals.SETRANGE("Document Status", EmployeeJournals."Document Status"::Approved);
        EmployeeJournals.SETFILTER(Value, '<>0');
        if EmployeeJournals.FindFirst then
            FlowFieldCalc := true;

        Balance := (Rec."Transfer from Previous Year" + Rec.Entitlement + Rec."Manual Additions" + Rec."Attendance Additions") - (Rec."Manual Deductions" + Rec."Attendance Deductions");
        Balance := Balance - Rec.Taken;
        if Rec."Till Date" > WORKDATE then begin
            CalculateEntitlementTillToday();
            if Rec.Entitlement = 0 then
                EntitlementTillToday := PayrollFunctions.GetDefaultEntitlementTillDate(Rec."Employee No.", Rec."Cause of Absence Code", Rec."From Date", WORKDATE, IntervalType::Day, true);

            AllowedTillToday := (EntitlementTillToday + ((Rec."Transfer from Previous Year" + Rec."Manual Additions" + Rec."Attendance Additions") - (Rec."Manual Deductions" + Rec."Attendance Deductions" + Rec.Taken)));
        end else begin
            EntitlementTillToday := 0;
            AllowedTillToday := 0;
        end;
        TakenOnFormat;
    end;

    trigger OnOpenPage();
    begin
        LeavesOfficerPermission := PayrollFunctions.IsLeavesOfficer(UserId);
        IF not LeavesOfficerPermission then
            Error('No Permission!');
        //EDM+ 08-12-2020
        HRSetupTbt.GET;
        IF HRSetupTbt."Generate Monthly Entitlement" then begin
            Rec.CALCFIELDS("Period Start Date", "Period End Date");
            Rec.SETFILTER("From Date", '>=%1', "Period Start Date");
            Rec.SETFILTER("Till Date", '<=%1', "Period End Date");
        end
        ELSE BEGIN
            //EDM- 08-12-2020
            Rec.SETFILTER("From Date", '<=%1', WORKDATE);
            Rec.SETFILTER("Till Date", '>=%1', WORKDATE);
        END;
        HRSetupTbt.GET;
        if HRSetupTbt."Auto Calculate Entitlement" then
            ShowAction := false
        else
            ShowAction := true;
    end;

    var
        Balance: Decimal;
        UnitofMeasure: Code[10];
        CauseofAbsence: Record "Cause of Absence";
        FlowFieldCalc: Boolean;
        EmployeeJournals: Record "Employee Journal Line";
        PayrollFunctions: Codeunit "Payroll Functions";
        AllowedTillToday: Decimal;
        IntervalType: Option Month,Day;
        EntitlementTillToday: Decimal;
        HRSetupTbt: Record "Human Resources Setup";
        ShowAction: Boolean;
        AllowedTillEndOfMonth: Decimal;
        LeavesOfficerPermission: Boolean;

    local procedure TakenOnFormat();
    begin
        if FlowFieldCalc then;
    end;

    procedure CalculateEntitlementTillToday();
    var
        L_HRSetupTbt: Record "Human Resources Setup";
        L_Fdate: Date;
        L_TDate: Date;
    begin
        L_HRSetupTbt.GET();
        Rec.CALCFIELDS("Employment date", "Termination Date", "Inactive Date");

        L_Fdate := Rec."From Date";
        L_TDate := Rec."Till Date";

        if L_HRSetupTbt."Entitlement Generation Type" = L_HRSetupTbt."Entitlement Generation Type"::"Yearly Basis" then begin
            if (Rec."Employment date" <> 0D) and (Rec."Employment date" > L_Fdate) and (Rec."Employment date" <= L_TDate) then
                L_Fdate := Rec."Employment date";
        end else
            L_Fdate := Rec."From Date";

        if (Rec."Termination Date" <> 0D) then begin
            if (Rec."Termination Date" >= L_Fdate) and (Rec."Termination Date" < L_TDate) then
                L_TDate := Rec."Termination Date";
        end else
            if (Rec."Inactive Date" <> 0D) then begin
                if (Rec."Inactive Date" >= L_Fdate) and (Rec."Inactive Date" < L_TDate) then
                    L_TDate := Rec."Inactive Date";
            end;

        if (L_Fdate = 0D) or (L_TDate = 0D) then
            EntitlementTillToday := 0
        else begin
            if WORKDATE >= L_TDate then
                EntitlementTillToday := 0
            else begin
                if WORKDATE > L_Fdate then
                    EntitlementTillToday := ROUND((((WORKDATE - L_Fdate) + 1) * Rec.Entitlement) / (L_TDate - L_Fdate), 0.01)
                else
                    EntitlementTillToday := 0;
            end;
        end;

        RefreshTotals();
    end;

    local procedure RefreshTotals();
    var
        EmployDate: Date;
        DaysNo: Integer;
        DaysTillToday: Integer;
        Employee: Record Employee;
        AbsEntitlement: Record "Absence Entitlement";
        V: Decimal;
        IsFirstyearEntitle: Boolean;
        EntitleType: Option "Interval Basis","Yearly Basis","Employment Basis";
        L_HRSetupTbt: Record "Human Resources Setup";
        L_Tdate: Date;
    begin
        L_HRSetupTbt.GET();
        Rec.CALCFIELDS("AL Start Date", "Employment date", "Termination Date", "Inactive Date");
        if Rec."Cause of Absence Code" = 'AL' then begin
            if Rec."AL Start Date" <> 0D then
                EmployDate := Rec."AL Start Date"
            else
                EmployDate := Rec."Employment date";
        end else
            EmployDate := Rec."Employment date";

        //if (WORKDATE - EmployDate)  < 365 * 2 then
        /*if (WORKDATE - EmployDate)  < 365 then
          IsFirstyearEntitle := true;*/

        L_Tdate := WORKDATE;
        if L_HRSetupTbt."Entitlement Generation Type" = L_HRSetupTbt."Entitlement Generation Type"::"Yearly Basis" then
            EmployDate := DMY2DATE(DATE2DMY(EmployDate, 1), DATE2DMY(EmployDate, 2), DATE2DMY(WORKDATE, 3))
        else
            EmployDate := Rec."From Date";

        if (Rec."Termination Date" <> 0D) then begin
            if (Rec."Termination Date" >= Rec."From Date") and (Rec."Termination Date" < L_Tdate) then
                L_Tdate := Rec."Termination Date";
        end else
            if (Rec."Inactive Date" <> 0D) then begin
                if (Rec."Inactive Date" >= Rec."From Date") and (Rec."Inactive Date" < L_Tdate) then
                    L_Tdate := Rec."Inactive Date";
            end;

        if L_Tdate < WORKDATE then begin
            EntitlementTillToday := 0;
            AllowedTillEndOfMonth := 0;
        end else begin
            if IsFirstyearEntitle then begin
                V := ((Rec."Year Entitlement" / 12)) / (365 / 12);
                AllowedTillEndOfMonth := ROUND(((DMY2DATE(PayrollFunctions.GetDaysInMonth(DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)) - EmployDate) + 1) * (V), 0.01)
                                          + ((Rec."Transfer from Previous Year" + Rec."Manual Additions" + Rec."Attendance Additions") - (Rec."Manual Deductions" + Rec."Attendance Deductions" + Rec.Taken));

                AllowedTillEndOfMonth := AllowedTillEndOfMonth + Rec."First Year Entitlement";
                if Rec."First Year Entitlement" > 0 then begin
                    DaysNo := (DMY2DATE(PayrollFunctions.GetDaysInMonth(DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)) - EmployDate) + 1;
                    DaysTillToday := WORKDATE - EmployDate + 1;
                end else begin
                    DaysNo := (DMY2DATE(PayrollFunctions.GetDaysInMonth(DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)) - Rec."From Date") + 1;
                    DaysTillToday := (WORKDATE - Rec."From Date") + 1;
                end;

                if Rec."Year Entitlement" > 0 then begin
                    AllowedTillEndOfMonth := (Rec."Year Entitlement" / 365) * DaysNo;
                    EntitlementTillToday := (Rec."Year Entitlement" / 365) * DaysTillToday;
                end else begin
                    AllowedTillEndOfMonth := (Rec.Entitlement / 365) * DaysNo;
                    EntitlementTillToday := (Rec.Entitlement / 365) * DaysTillToday;
                end;

                EntitlementTillToday := EntitlementTillToday + Rec."First Year Entitlement";
                AllowedTillEndOfMonth := AllowedTillEndOfMonth + Rec."First Year Entitlement";
            end else begin
                //20190311:A2+
                //EntitlementTillToday := PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code","From Date",EmployDate ,EntitleType::"Interval Basis",FALSE);
                //EntitlementTillToday := EntitlementTillToday + PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code",EmployDate   ,WORKDATE,EntitleType::"Interval Basis",FALSE);
                //IF EmployDate < WORKDATE THEN BEGIN
                //  EntitlementTillToday := PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code","From Date",EmployDate ,EntitleType::"Interval Basis",FALSE);
                //  EntitlementTillToday := EntitlementTillToday + PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code",EmployDate   ,WORKDATE,EntitleType::"Interval Basis",FALSE);
                //END ELSE
                // EntitlementTillToday := PayrollFunctions.GetEmpAbsenceEntitlementValue("Employee No.","Cause of Absence Code","From Date",WORKDATE,EntitleType::"Interval Basis",FALSE);    

                IF WORKDATE >= Rec."Till Date" THEN
                    EntitlementTillToday := 0
                ELSE BEGIN
                    if Rec."AL Start Date" <> 0D then
                        EmployDate := Rec."AL Start Date"
                    else
                        EmployDate := Rec."Employment date";

                    if EmployDate < Rec."From Date" then
                        EmployDate := Rec."From Date";

                    IF WORKDATE > EmployDate THEN BEGIN
                        EntitlementTillToday := ROUND((((WORKDATE - EmployDate) + 1) * Rec.Entitlement) / (Rec."Till Date" - EmployDate + 1), 0.01);
                    END ELSE
                        EntitlementTillToday := 0;
                END;
                //20190311:A2-
                EntitlementTillToday := EntitlementTillToday - PayrollFunctions.GetEmpFirstYearEntitlement(Rec."Employee No.", Rec."Cause of Absence Code", Rec."From Date", 0D, EntitleType::"Interval Basis", false);
                AllowedTillEndOfMonth := PayrollFunctions.GetEmpAbsenceEntitlementValue(Rec."Employee No.", Rec."Cause of Absence Code", Rec."From Date", EmployDate, EntitleType::"Interval Basis", false);
                AllowedTillEndOfMonth := AllowedTillEndOfMonth + PayrollFunctions.GetEmpAbsenceEntitlementValue(Rec."Employee No.", Rec."Cause of Absence Code", EmployDate, DMY2DATE(PayrollFunctions.GetDaysInMonth(DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), EntitleType::"Interval Basis", false);
                AllowedTillEndOfMonth := AllowedTillEndOfMonth - PayrollFunctions.GetEmpFirstYearEntitlement(Rec."Employee No.", Rec."Cause of Absence Code", Rec."From Date", 0D, EntitleType::"Interval Basis", false);
            end;
        end;

        AllowedTillEndOfMonth := AllowedTillEndOfMonth + ((Rec."Transfer from Previous Year" + Rec."Manual Additions") - (Rec."Manual Deductions" + Rec.Taken));
        AllowedTillToday := EntitlementTillToday + ((Rec."Transfer from Previous Year" + Rec."Manual Additions") - (Rec."Manual Deductions" + Rec.Taken));
        Balance := (Rec."Transfer from Previous Year" + Rec.Entitlement + Rec."Manual Additions" + Rec."Attendance Additions") - (Rec."Manual Deductions" + Rec."Attendance Deductions");
        Balance := Balance - Rec.Taken;
    end;
}

