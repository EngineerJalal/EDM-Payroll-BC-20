page 98070 "Human Resource Activities"
{
    // version NAVW16.00,NAVNA6.00,SHR RC,EDM.HRPY1

    CaptionML = ENU = 'Activities';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(content)
        {
            cuegroup("Human Resources")
            {
                Caption = 'Human Resources';
                Visible = HROfficerPermission or PayrollOfficerPermission or DataEntryOfficerPermission or RecruitmentOfficerPermission;
                field("Birth Dates"; Rec."Birth Dates")
                {
                    Visible = HROfficerPermission;
                    ApplicationArea = All;
                }
                field("New Employees"; Rec."New Employees")
                {
                    Visible = HROfficerPermission;
                    ApplicationArea = All;
                }
                field(Leavers; Rec.Leavers)
                {
                    Visible = HROfficerPermission;
                    ApplicationArea = All;
                }
                field("MOF Declartion"; Rec."MOF Declartion")
                {
                    Visible = HROfficerPermission;
                    ApplicationArea = All;
                }
                field("NSSF Declartion"; Rec."NSSF Declartion")
                {
                    Visible = HROfficerPermission;
                    ApplicationArea = All;
                }
                field("Employee Loan"; Rec."Employee Loan")
                {
                    Visible = PayrollOfficerPermission;
                    ApplicationArea = All;
                }
                field("Probation Date"; Rec."Probation Date")
                {
                    Visible = HROfficerPermission;
                    ApplicationArea = All;
                }
                field("Employee Over 64"; Rec."Employee Over 64")
                {
                    Visible = HROfficerPermission;
                    ApplicationArea = All;
                }
            }
            cuegroup("")
            {
                field("Driving Lisence"; Rec."Driving Lisence")
                {
                    Visible = HROfficerPermission or DataEntryOfficerPermission;
                    ApplicationArea = All;
                }
                field("Passport Valid Date"; Rec."Passport Valid Date")
                {
                    Visible = HROfficerPermission or DataEntryOfficerPermission;
                    ApplicationArea = All;
                }
                field("Work Residency Valid Date"; Rec."Work Residency Valid Date")
                {
                    Visible = HROfficerPermission or DataEntryOfficerPermission;
                    ApplicationArea = All;
                }
                field("Work Permit Valid Date"; Rec."Work Permit Valid Date")
                {
                    Visible = HROfficerPermission or DataEntryOfficerPermission;
                    ApplicationArea = All;
                }
                field("Eng Syndicate AL Pymt Date"; Rec."Eng Syndicate AL Pymt Date")
                {
                    Visible = false;//Visible = EM-TECH and(HROfficerPermission or DataEntryOfficerPermission);                    ApplicationArea=All;                    ApplicationArea=All;

                    ApplicationArea = All;

                }
                field("Insurance Expiry Date"; Rec."Insurance Expiry Date")
                {
                    Visible = false;//Visible = HROfficerPermission or DataEntryOfficerPermission;                    ApplicationArea=All;                    ApplicationArea=All;

                    ApplicationArea = All;

                }
                field("Contracts Termination Date"; Rec."Contracts Termination Date")
                {
                    Visible = HROfficerPermission or DataEntryOfficerPermission;
                    ApplicationArea = All;
                }
                field("Visa Expiry Date"; Rec."Visa Expiry Date")
                {
                    Visible = HROfficerPermission or DataEntryOfficerPermission;
                    ApplicationArea = All;
                }
                field("TECOM Expiry Date"; Rec."TECOM Expiry Date")
                {
                    visible = (UAETecom) and (HROfficerPermission or DataEntryOfficerPermission);
                    ApplicationArea = All;
                }
            }
            cuegroup("EmployeeAbsent")
            {
                Caption = 'Employee Absent';
                visible = AttendanceOfficerPermission or LeavesOfficerPermission;

                field("Employees Absent"; Rec."Employees Absent")
                {
                    Caption = 'Absent Employees';
                    Visible = AttendanceOfficerPermission;
                    ApplicationArea = All;
                }
            }
            cuegroup(Journals)
            {
                Caption = 'Journals';
                visible = PayrollOfficerPermission;
                field("Open Journals"; Rec."Open Journals")
                {
                    Visible = PayrollOfficerPermission;
                    ApplicationArea = All;
                }
                field("Released Journals"; Rec."Released Journals")
                {
                    Visible = false;//PayrollOfficerPermissions                    ApplicationArea=All;                    ApplicationArea=All;                    ApplicationArea=Basic;

                    ApplicationArea = All;

                }
                field("Approval Entries"; Rec."Approval Entries")
                {
                    DrillDownPageID = "Approval Entries";
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            cuegroup("Lists")
            {
                Caption = 'Lists';
                Visible = HROfficerPermission or PayrollOfficerPermission or DataEntryOfficerPermission or RecruitmentOfficerPermission;
                actions
                {
                    action("Employees List")
                    {
                        Visible = HROfficerPermission or DataEntryOfficerPermission or PayrollOfficerPermission;
                        RunObject = Page "Employee List";
                        ApplicationArea = All;
                    }
                    action("Active Employees List")
                    {
                        Visible = HROfficerPermission or DataEntryOfficerPermission or PayrollOfficerPermission;
                        RunObject = Page "Employee List";
                        RunPageView = WHERE("Status" = FILTER(Active));
                        ApplicationArea = All;
                    }
                    action("Applicants List")
                    {
                        Visible = RecruitmentOfficerPermission;
                        RunObject = Page "Applicant List";
                        ApplicationArea = All;
                    }
                    action("Employees List By Type")
                    {
                        RunObject = Page "Employee List by Type";
                        Visible = false; // Megaprefab and HROfficerPermission or DataEntryOfficerPermission;                        ApplicationArea=All;                        ApplicationArea=All;                        ApplicationArea=Basic;

                        ApplicationArea = All;


                    }
                    action("Salary Raise Request List")
                    {
                        RunObject = Page "Salary Raise Request List";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Employee Salary History")
                    {
                        RunObject = Page "Employee Salary History";
                        ApplicationArea = All;
                    }
                    action("Employees Grade")
                    {
                        RunObject = Page "Employees Grade";
                        Visible = UseGrade and (EvaluationOfficerPermission);
                        ApplicationArea = All;

                    }
                }
            }

            cuegroup(Attendance)
            {
                Caption = 'Attendance';
                visible = AttendanceOfficerPermission or LeavesOfficerPermission;

                actions
                {
                    action("Attendance View List")
                    {
                        Visible = AttendanceOfficerPermission;
                        RunObject = Page "Attendance List";
                        ApplicationArea = All;
                    }
                    action("Leave Request List")
                    {
                        Visible = LeavesOfficerPermission;
                        RunObject = Page "Leave Request List";
                        ApplicationArea = All;
                    }
                    action("Employees Absence Entitlements")
                    {
                        Visible = LeavesOfficerPermission;
                        RunObject = Page "Employee Absence Entitlement";
                        ApplicationArea = All;
                    }
                    action("Employee Absence Journal")
                    {
                        Caption = 'Employee Absence Journal';
                        Visible = AttendanceOfficerPermission;
                        RunObject = Page "Employee Absence Jnl.";
                        ApplicationArea = All;

                    }
                    action("Scheduling System List")
                    {
                        RunObject = Page "Scheduling System List";
                        Visible = (UseSchoolingSystem) and (AttendanceOfficerPermission);
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup(Payroll)
            {
                Caption = 'Payroll';
                visible = PayrollOfficerPermission;
                field("Request To Approve"; Rec."Request To Approve")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                actions
                {
                    action("Pay Details")
                    {
                        Caption = 'Payroll Details';
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = false;
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Pay Details";
                        ApplicationArea = All;

                    }
                    action("Pay Details Supplement")
                    {
                        Caption = 'Payroll Supplement';
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = false;
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Pay Details Supplement";
                        ApplicationArea = All;

                    }
                    action("Loan List")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Loan List";
                        ApplicationArea = All;
                    }
                    action("Employees Dimensions")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Employee Dimensions";
                        ApplicationArea = All;
                    }
                    action("Print - Prepare Bank Statement")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Report "Print-Prepare Bank Payment..";
                        ApplicationArea = All;
                    }
                    action("Export Employees Bank Transfer File")
                    {
                        Caption = 'Export Employees Bank Transfer File';
                        Visible = PayrollOfficerPermission;
                        RunObject = Report "Print-Prepare Bank Payment..2";
                        ApplicationArea = All;
                    }
                    action("Pay Details History")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Pay Detail List";
                        ApplicationArea = All;
                    }
                    action("Payroll Ledger Entries")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Payroll Ledger Entries";
                        ApplicationArea = All;
                    }
                    action("Sub-Payroll Details")
                    {
                        Visible = UseSubPayroll and PayrollOfficerPermission;
                        RunObject = Page "Payroll Main List";
                        ApplicationArea = All;
                    }
                    action("School Allowances List")
                    {
                        Visible = UseMultipleAllowances and HROfficerPermission;
                        RunObject = Page "School Allowance List";
                        ApplicationArea = All;
                    }
                    action("Benefits / Deductions Packages")
                    {
                        Visible = UseMultipleAllowances and HROfficerPermission;
                        RunObject = Page "Allowance Deduction Temp List";
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup(Journal)
            {
                Caption = 'Journals';
                visible = PayrollOfficerPermission;
                actions
                {
                    action("Employees Journals Matrix")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Employee Journals Matrix";
                        ApplicationArea = All;
                    }
                    action("Payroll Journals Matrix")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Payroll Journals Matrix";
                        ApplicationArea = All;
                    }
                    action("Import Journals from excel")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Report "Import Benefits";
                        ApplicationArea = All;
                    }
                    action("Import Recurring Journals")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Report "HR Import Recurring Journals";
                        ApplicationArea = All;
                    }
                    action("Benefit Journals")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Employee Benefit Jnl.";
                        ApplicationArea = All;
                    }
                    action("Deduction Journals")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Employee Deduction Jnl.";
                        ApplicationArea = All;
                    }

                    action("Employee Journal Line")
                    {
                        Visible = PayrollOfficerPermission;
                        RunObject = Page "Employee Journal Line List";
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup(Evaluation)
            {
                Visible = UseEvaluationSheet and EvaluationOfficerPermission;
                actions
                {
                    action("Evaluation List")
                    {
                        Visible = EvaluationOfficerPermission;
                        RunObject = Page "Evaluation Data Main List";
                        ApplicationArea = All;
                    }
                    action("Evaluation Template List")
                    {
                        Visible = EvaluationOfficerPermission;
                        RunObject = Page "Evaluation Template List";
                        ApplicationArea = All;
                    }
                }
            }
            cuegroup(Training)
            {
                Visible = EvaluationOfficerPermission;
                actions
                {
                    action("Training List")
                    {
                        Visible = EvaluationOfficerPermission;
                        RunObject = Page "Training List";
                        ApplicationArea = All;
                    }
                    action("Performance List")
                    {
                        Visible = EvaluationOfficerPermission;
                        RunObject = Page "Performance List";
                        ApplicationArea = All;
                    }
                    action("Training Journal")
                    {
                        Visible = EvaluationOfficerPermission;
                        RunObject = Page "Employment Type Schedule";
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
    begin

        HRSetup.GET;
        Rec.RESET;
        if not Rec.GET then begin
            Rec.INIT;
            Rec.INSERT;
        end;

        Rec.SETFILTER("Due Date Filter", '<=%1', CALCDATE(HRSetup."Due Date Formula", WORKDATE));
        Rec.SETFILTER("Overdue Date Filter", '<%1', CALCDATE(HRSetup."Due Date Formula", WORKDATE));
        Rec.SETFILTER("Probation Date Filter", '%1..%2', CALCDATE('-3M', WORKDATE), CALCDATE('-1W', WORKDATE));
        Rec.SETFILTER("Month Filter", '=%1', DATE2DMY(WORKDATE, 2));
        Rec.SETFILTER("Eng Synd Date Filter", '=%1', WORKDATE);
        Rec.SETFILTER("Insurance Expiry Date Filter", '=%1', WORKDATE);
        Rec.SETFILTER("MOF Declaration Date Filter", '%1..%2', CALCDATE('-1W', WORKDATE), WORKDATE);
        Rec.SETFILTER("NSSF Declaration Date Filter", '%1..%2', CALCDATE('-1W', WORKDATE), WORKDATE);
        Rec.SETFILTER("Passport Month Filter", '%1..%2', DATE2DMY(WORKDATE, 2) - 1, DATE2DMY(WORKDATE, 2) + 2);
        Rec.SETFILTER("Passport Year Filter", '=%1', DATE2DMY(WORKDATE, 3));
        Rec.SETFILTER("Work Permit Month Filter", '=%1', DATE2DMY(WORKDATE, 2));
        Rec.SETFILTER("Work Permit Year Filter", '=%1', DATE2DMY(WORKDATE, 3));
        Rec.SETFILTER("Work Residency Month Filter", '%1..%2', DATE2DMY(WORKDATE, 2) - 1, DATE2DMY(WORKDATE, 2) + 2);
        Rec.SETFILTER("Work Residency Year Filter", '=%1', DATE2DMY(WORKDATE, 3));
        Rec.SETFILTER("Employment Date Filter", '>=%1', CALCDATE('<-3M>', WORKDATE));
        Rec.SETFILTER("Termination Date Filter", '%1..%2', CALCDATE('<-CM>', WORKDATE), CALCDATE('<CM>', WORKDATE));
        Rec.SETFILTER("Visa Expiry Date Filter", '%1..%2', CALCDATE('<-1M>', WORKDATE), CALCDATE('<+2M>', WORKDATE));
        Rec.SETFILTER("TECOM Expiry Date Filter", '%1..%2', WORKDATE, CALCDATE('<+2M>', WORKDATE));
        Rec.SetFilter("End Of Service Filter", '<=%1', WorkDate);
        Rec.SetFilter("Driving Lisence Expiry Filter", '%1..%2', CALCDATE('<-1M>', WORKDATE), CALCDATE('<+2M>', WORKDATE));
        Rec.SetFilter("Employee Absence Filter", '<=%1', WorkDate);//20190118:A2+-
        Rec."User ID" := USERID;
        Rec.MODIFY;
        UseGrade := PayFunction.IsFeatureVisible('GradingSystem');
        UseSchoolingSystem := PayFunction.IsFeatureVisible('ShoolingSystem');
        UseEvaluationSheet := PayFunction.IsFeatureVisible('EvaluationSheet');
        UseSubPayroll := PayFunction.IsFeatureVisible('SubPayroll');
        UseMultipleAllowances := PayFunction.IsFeatureVisible('AllowDed');
        //UAE Tecom EDM.JA+
        PayParam.Get;
        IF PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::"UAE" then
            UAETecom := true
        else
            UAETecom := false;
        //UAE Tecom EDM.JA-
        //EDM.JA+
        HROfficerPermission := PayFunction.IsHROfficer(UserId);
        PayrollOfficerPermission := PayFunction.IsPayrollOfficer(UserId);
        AttendanceOfficerPermission := PayFunction.IsAttendanceOfficer(UserId);
        DataEntryOfficerPermission := PayFunction.IsDataEntryOfficer(UserId);
        RecruitmentOfficerPermission := PayFunction.IsRecruitmentOfficer(UserId);
        LeavesOfficerPermission := PayFunction.IsLeavesOfficer(UserId);
        EvaluationOfficerPermission := PayFunction.IsEvaluationOfficer(UserId);
        //EDM.JA-
    end;

    var
        HRSetup: Record "Human Resources Setup";
        "HR Function": Codeunit "Human Resource Functions";
        EmployeeAbsent: Integer;
        UseGrade: Boolean;
        PayFunction: Codeunit "Payroll Functions";
        UseSchoolingSystem: Boolean;
        UseEvaluationSheet: Boolean;
        UseSubPayroll: Boolean;
        UseMultipleAllowances: Boolean;
        PayParam: Record "Payroll Parameter";
        UAETecom: Boolean;
        HROfficerPermission: Boolean;
        PayrollOfficerPermission: Boolean;
        AttendanceOfficerPermission: Boolean;
        DataEntryOfficerPermission: Boolean;
        RecruitmentOfficerPermission: Boolean;
        LeavesOfficerPermission: Boolean;
        EvaluationOfficerPermission: Boolean;
}