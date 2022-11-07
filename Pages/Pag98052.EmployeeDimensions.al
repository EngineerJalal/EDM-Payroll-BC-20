page 98052 "Employee Dimensions"
{
    // version EDM.HRPY1

    PageType = List;
    SourceTable = "Employee Dimensions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    TableRelation = Employee;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added in order to insert by default the dimensions as per the employee card - 04.04.2017 : AIM +
                        EmpTbt.SETRANGE("No.", Rec."Employee No.");
                        if EmpTbt.FINDFIRST then begin
                            EmployeeDimNo := PayrollFunction.GetShortcutDimensionNoFromName('Employee');
                            EmployeeDimCode := '';

                            if EmpTbt."Related to" <> '' then
                                EmployeeDimCode := EmpTbt."Related to"
                            else
                                EmployeeDimCode := EmpTbt."No.";

                            Rec."Payroll Date" := DMY2DATE(PayrollFunction.GetLastDayinMonth(WORKDATE), DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
                            Rec."Shortcut Dimension 1 Code" := EmpTbt."Global Dimension 1 Code";
                            Rec."Shortcut Dimension 2 Code" := EmpTbt."Global Dimension 2 Code";
                            Rec.Percentage := 100;

                            if EmployeeDimNo = 3 then
                                Rec."Shortcut Dimension 3 Code" := EmployeeDimCode
                            else
                                Rec."Shortcut Dimension 3 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue(Rec."Employee No.", 3);
                            if EmployeeDimNo = 4 then
                                Rec."Shortcut Dimension 4 Code" := EmployeeDimCode
                            else
                                Rec."Shortcut Dimension 4 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue(Rec."Employee No.", 4);
                            if EmployeeDimNo = 5 then
                                Rec."Shortcut Dimension 5 Code" := EmployeeDimCode
                            else
                                Rec."Shortcut Dimension 5 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue(Rec."Employee No.", 5);
                            if EmployeeDimNo = 6 then
                                Rec."Shortcut Dimension 6 Code" := EmployeeDimCode
                            else
                                Rec."Shortcut Dimension 6 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue(Rec."Employee No.", 6);
                            if EmployeeDimNo = 7 then
                                Rec."Shortcut Dimension 7 Code" := EmployeeDimCode
                            else
                                Rec."Shortcut Dimension 7 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue(Rec."Employee No.", 7);
                            if EmployeeDimNo = 8 then
                                Rec."Shortcut Dimension 8 Code" := EmployeeDimCode
                            else
                                Rec."Shortcut Dimension 8 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue(Rec."Employee No.", 8);
                        end;
                        //Added in order to insert by default the dimensions as per the employee card - 04.04.2017 : AIM -
                    end;
                }

                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Payroll Date"; Rec."Payroll Date")
                {
                    ApplicationArea = All;
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Value Code"; Rec."Dimension Value Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = '"""Shortcut Dimension 1 Code"""';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Copy Employee Dimensions")
            {
                Image = Copy;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Report "Copy Employee Dimensions";
                ApplicationArea = All;
            }
            action("Generate Dimensions from attendance")
            {
                Caption = 'Generate Payroll Dimensions';
                Image = GetEntries;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;
                RunObject = Report "Generate Dimension from Attend";
                Visible = true;
                ApplicationArea = All;
            }
            action("Copy Employee Dimensions To New Employee")
            {
                Image = Copy;
                ApplicationArea = All;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction();
                var
                    EmployeeDimension: Record "Employee Dimensions";
                begin
                    EmployeeDimension.RESET;
                    EmployeeDimension.SETRANGE("Employee No.", Rec."Employee No.");
                    EmployeeDimension.SETRANGE("Payroll Date", Rec."Payroll Date");
                    REPORT.RUN(17464, TRUE, FALSE, EmployeeDimension);
                end;
            }
            action("Generate from Attendance Sub Dimensions")
            {
                Caption = 'Generate from Attendance Sub Dimensions';
                Image = ApplyTemplate;
                RunObject = Report "Generate Shedule Dimension";
                ApplicationArea = All;

                trigger OnAction();
                var
                    SchedSyst: Record "Scheduling System";
                    SchedSystLine: Record "Scheduling System Line";
                    PayFunction: Codeunit "Payroll Functions";
                begin
                end;
            }
            action(aa)
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                var
                    EmployeesAttendanceDimension: Record "Employees Attendance Dimension";
                begin
                    /*IF EmployeesAttendanceDimension.FINDFIRST THEN
                    REPEAT
                      EmployeesAttendanceDimension."Shortcut Dimension 4" := EmployeesAttendanceDimension."Employee No";
                      EmployeesAttendanceDimension.MODIFY;
                    UNTIL EmployeesAttendanceDimension.NEXT = 0;*/

                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        //Addedn order to check if Distribution is properly done - 23.01.2017 : AIM +
        CheckDimensionDistribution();
        //Addedn order to check if Distribution is properly done - 23.01.2017 : AIM -

        // Add in order to added validation on closing Employee Dimension - 31.01.2017 : A2 +
        PayrollParameter.GET;
        if not PayrollParameter."Disable Emp Dim Validation" then begin
            if Rec.FINDFIRST then
                repeat
                    if GetTotalPercentage(Rec."Employee No.", Rec."Payroll Date") <> 100 then
                        ERROR('The Percentage of Employee %1 is not 100', Rec."Employee No.");
                until Rec.NEXT = 0;
        end;
        exit(true);
        // Add in order to added validation on closing Employee Dimension - 31.01.2017 : A2 -
    end;

    trigger OnOpenPage();
    begin
        PayrollOfficerPermission := PayrollFunction.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');
    end;

    var
        CalcEmpPay: Codeunit "Calculate Employee Pay";
        PayrollFunction: Codeunit "Payroll Functions";
        PayrollParameter: Record "Payroll Parameter";
        HumanResourcesSetup: Record "Human Resources Setup";
        EmpTbt: Record Employee;
        EmployeeDimCode: Code[20];
        EmployeeDimNo: Integer;
        PayrollOfficerPermission: Boolean;

    local procedure CheckDimensionDistribution();
    begin
        if Rec.FINDFIRST() then
            repeat
                if PayrollFunction.IsValidEmployeePayrollDimension(Rec."Employee No.", Rec."Payroll Date", true) = false then
                    ERROR('');
            until Rec.NEXT = 0;
    end;

    local procedure GetTotalPercentage("EmpNo.": Code[20]; Payrolldate: Date) Val: Decimal;
    var
        EmpDim: Record "Employee Dimensions";
    begin
        Val := 0;
        EmpDim.SETRANGE("Employee No.", "EmpNo.");
        EmpDim.SETRANGE("Payroll Date", Payrolldate);
        if EmpDim.FINDFIRST then
            repeat
                Val := Val + EmpDim.Percentage
            until EmpDim.NEXT = 0;
        exit(Val);
    end;
}

