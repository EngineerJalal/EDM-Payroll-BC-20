page 98091 "HR Activities Role Center"
{
    // version EDM.HRPY1

    Caption = 'Administration Setup';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            cuegroup("HR Setup")
            {
                Visible = AdministrationOfficerPermission;
                actions
                {
                    action("Human Resources Setup")
                    {
                        Visible = HROfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Human Resources Setup";
                        ApplicationArea = All;
                    }
                    action("Employee Category")
                    {
                        Visible = HROfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Employee Categories";
                        ApplicationArea = All;
                    }
                    action("HR Permissions")
                    {
                        Visible = AdministrationOfficerPermission;
                        RunObject = Page "HR Permissions";
                        ApplicationArea = All;
                    }
                    action("HR Information")
                    {
                        Visible = HROfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "HR Information";
                        ApplicationArea = All;
                    }
                    action("Grading Scale")
                    {
                        RunObject = Page "Grading Scale";
                        Visible = UseGrade and EvaluationOfficerPermission and AdministrationOfficerPermission;
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup("Payroll Setup")
            {
                Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                actions
                {
                    action("Payroll Parameter Card")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Payroll Parameter Card";
                        ApplicationArea = All;
                    }
                    action("Pay Element")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Pay Element";
                        ApplicationArea = All;
                    }
                    action("HR Payroll Group")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "HR Payroll Group";
                        ApplicationArea = All;
                    }
                    action("Payroll Posting Group")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Payroll Posting Group";
                        ApplicationArea = All;
                    }
                    action("Pension Scheme List")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Pension Scheme List";
                        ApplicationArea = All;
                    }
                    action("Payroll Element Posting")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Payroll Element Posting";
                        ApplicationArea = All;
                    }
                    action("Tax Bands")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Tax Bands";
                        ApplicationArea = All;
                    }
                    action("Payroll Status")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Payroll Status";
                        ApplicationArea = All;
                    }
                    action("End Of Service Provision")
                    {
                        Visible = UseEOSProvision and PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "EOS Provision Opening";
                        ApplicationArea = All;
                    }
                    action("Gratuity Bands")
                    {
                        Visible = GratuityBand and PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Gratuity Bands";
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup("Attendance Setup")
            {
                Visible = AttendanceOfficerPermission and AdministrationOfficerPermission;
                actions
                {
                    action("Employment Type")
                    {
                        Visible = AttendanceOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Employment Type";
                        ApplicationArea = All;
                    }
                    action("Daily Shift")
                    {
                        Visible = AttendanceOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Daily Shift";
                        ApplicationArea = All;
                    }
                    action("Cause of Attendance")
                    {
                        Visible = AttendanceOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Causes of Absence";
                        ApplicationArea = All;
                    }
                    action("Base Calendar")
                    {
                        Visible = AttendanceOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Base Calendar List N";
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup("Journals Setup")
            {
                Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                actions
                {
                    action("HR Transaction Type")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "HR Transaction Types";
                        ApplicationArea = All;
                    }
                    action("HR System Code")
                    {
                        Visible = PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "HR System Code";
                        ApplicationArea = All;
                    }
                    action("Travel per Diem Policy")
                    {
                        Visible = UseTravelPerDiemPolicy and PayrollOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Emp. Travel Per Deem Policy";
                        ApplicationArea = All;
                    }
                }
            }

            cuegroup("Check List Setup")
            {
                Visible = UseHiringCheckList and HROfficerPermission and AdministrationOfficerPermission;
                actions
                {
                    action("CheckList Items")
                    {
                        Visible = UseHiringCheckList and HROfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "CheckList Items";
                        ApplicationArea = All;
                    }
                }
            }

            cuegroup(Evaluation)
            {
                Visible = UseEvaluationSheet and EvaluationOfficerPermission and AdministrationOfficerPermission;
                actions
                {
                    action("Evaluation Item Relation")
                    {
                        Visible = UseEvaluationSheet and EvaluationOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Evaluation Item Relation";
                        ApplicationArea = All;
                    }
                    action("Evaluation Items List")
                    {
                        Visible = UseEvaluationSheet and EvaluationOfficerPermission and AdministrationOfficerPermission;
                        RunObject = Page "Evaluation Items List";
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    var
        lHRSetup: Record "Human Resources Setup";

    begin
        lHRSetup.Get();
        UseGrade := PayFunction.IsFeatureVisible('GradingSystem');
        UseEvaluationSheet := PayFunction.IsFeatureVisible('EvaluationSheet');
        UseHiringCheckList := PayFunction.IsFeatureVisible('HiringCheckList');
        UseTravelPerDiemPolicy := PayFunction.IsFeatureVisible('TravelPerDiemPolicy');
        UseEOSProvision := PayFunction.IsFeatureVisible('EOSProvision');
        PayrollParameter.Get;
        IF (PayrollParameter."Payroll Labor Law" = PayrollParameter."Payroll Labor Law"::UAE) OR
        (PayrollParameter."Payroll Labor Law" = PayrollParameter."Payroll Labor Law"::Qatar) THEN
            GratuityBand := true
        Else
            GratuityBand := false;
        //EDM.JA+
        HROfficerPermission := PayFunction.IsHROfficer(UserId);
        PayrollOfficerPermission := PayFunction.IsPayrollOfficer(UserId);
        AttendanceOfficerPermission := PayFunction.IsAttendanceOfficer(UserId);
        DataEntryOfficerPermission := PayFunction.IsDataEntryOfficer(UserId);
        RecruitmentOfficerPermission := PayFunction.IsRecruitmentOfficer(UserId);
        LeavesOfficerPermission := PayFunction.IsLeavesOfficer(UserId);
        EvaluationOfficerPermission := PayFunction.IsEvaluationOfficer(UserId);
        AdministrationOfficerPermission := PayFunction.IsAdministrationOfficer(UserId);
        //EDM.JA-        
    end;

    var
        UseGrade: Boolean;
        PayFunction: Codeunit "Payroll Functions";
        UseEvaluationSheet: Boolean;
        UseHiringCheckList: Boolean;
        useTravelPerDiemPolicy: Boolean;
        UseEOSProvision: Boolean;
        GratuityBand: Boolean;
        PayrollParameter: Record "Payroll Parameter";
        HROfficerPermission: Boolean;
        PayrollOfficerPermission: Boolean;
        AttendanceOfficerPermission: Boolean;
        DataEntryOfficerPermission: Boolean;
        RecruitmentOfficerPermission: Boolean;
        LeavesOfficerPermission: Boolean;
        EvaluationOfficerPermission: Boolean;
        AdministrationOfficerPermission: Boolean;
}