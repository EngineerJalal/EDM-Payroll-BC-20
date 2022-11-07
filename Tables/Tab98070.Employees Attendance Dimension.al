table 98070 "Employees Attendance Dimension"
{
    // version EDM.HRPY2


    fields
    {
        field(1; "Employee No"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(2; "Attendance No"; Integer)
        {
            CalcFormula = Lookup(Employee."Attendance No." WHERE("No." = FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(3; Period; Date)
        {
        }
        field(4; "Attendance Day"; Option)
        {
            OptionCaption = 'Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday';
            OptionMembers = Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday;
        }
        field(5; "Attendance Date"; Date)
        {

            trigger OnValidate();
            var
                AttDay: Text;
                EDMUtility: Codeunit "EDM Utility";
            begin
                AttDay := EDMUtility.GetDayDate("Attendance Date");
                case AttDay of
                    'Monday':
                        "Attendance Day" := "Attendance Day"::Monday;
                    'Tuesday':
                        "Attendance Day" := "Attendance Day"::Tuesday;
                    'Wednesday':
                        "Attendance Day" := "Attendance Day"::Wednesday;
                    'Thursday':
                        "Attendance Day" := "Attendance Day"::Thursday;
                    'Friday':
                        "Attendance Day" := "Attendance Day"::Friday;
                    'Saturday':
                        "Attendance Day" := "Attendance Day"::Saturday;
                    'Sunday':
                        "Attendance Day" := "Attendance Day"::Sunday;
                end;
            end;
        }
        field(6; "Required Hrs"; Decimal)
        {
        }
        field(7; "Attended Hrs"; Decimal)
        {

            trigger OnValidate();
            begin
                if "Required Hrs" = 0 then
                    "Required Hrs" := "Attended Hrs";
            end;
        }
        field(8; "Global Dimension 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Global Dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "Shortcut Dimension 3"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(3));
        }
        field(11; "Shortcut Dimension 4"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(4));
        }
        field(12; "Shortcut Dimension 5"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(5));
        }
        field(13; "Shortcut Dimension 6"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(6));
        }
        field(14; "Shortcut Dimension 7"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(7));
        }
        field(15; "Shortcut Dimension 8"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(8));
        }
        field(16; "Line No"; Integer)
        {
        }
        field(17; "From Time"; Time)
        {
        }
        field(18; "To Time"; Time)
        {
        }
        field(19; Remarks; Text[250])
        {
        }
        field(20; "Created By"; Code[50])
        {
        }
        field(21; "Created DateTime"; DateTime)
        {
        }
        field(22; "Job No."; Code[20])
        {
            TableRelation = Job;

            trigger OnValidate();
            var
                DimensionNo: Integer;
            begin
                DimensionNo := PayrollFunctions.GetShortcutDimensionNoFromName('PROJECT');
                case DimensionNo of
                    0:
                        ERROR(NoProjectDimension);
                    1:
                        VALIDATE("Global Dimension 1", "Job No.");
                    2:
                        VALIDATE("Global Dimension 2", "Job No.");
                    else
                        ERROR(ProjectDimensionGlobal);
                end;
            end;
        }
        field(23; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(24; "Modified By"; Code[50])
        {
        }
        field(25; "Modified DateTime"; DateTime)
        {
        }
        field(26; "Employee Name"; Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(27; "Job Title Code"; Code[50])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE("No." = FIELD("Employee No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Line No", "Employee No", "Attendance Date", Period)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //Added in order not to update in case the period is closed 04/12/2017 //EDM.EmpAttDim+
        Employee.SETRANGE("Attendance No.", "Attendance No");
        if Employee.FINDFIRST then
            if not PayrollFunctions.CanModifyAttendanceRecord("Attendance Date", Employee."No.") then
                ERROR('Record cannot be deleted. Period is closed');
        //Added in order not to update in case the period is closed 04/12/2017 //EDM.EmpAttDim-
    end;

    trigger OnInsert();
    var
        L_linenb: Integer;
        EmpTbt: Record Employee;
        EmployeeDimNo: Integer;
        EmployeeDimCode: Code[50];
    begin
        //Added in order not to update in case the period is closed 04/12/2017 //EDM.EmpAttDim+
        if ("Attendance Date" <> 0D) then begin
            Employee.SETRANGE("Attendance No.", "Attendance No");
            if Employee.FINDFIRST then
                if not PayrollFunctions.CanModifyAttendanceRecord("Attendance Date", Employee."No.") then
                    ERROR('Record cannot be inserted. Period is closed');
        end;
        //Added in order not to update in case the period is closed - 04/12/2017 //EDM.EmpAttDim-

        //Added in order to know the user who add the record - 04/12/2017 //EDM.EmpAttDim+
        "Created By" := USERID;
        "Created DateTime" := CREATEDATETIME(WORKDATE, TIME);
        "Modified By" := USERID;
        "Modified DateTime" := CREATEDATETIME(WORKDATE, TIME);
        //Added in order to know the user who add the record - 04/12/2017 //EDM.EmpAttDim-

        L_linenb := 0;
        // 16.11.2017 : A2+
        EmpAttenDim.SETRANGE("Employee No", Rec."Employee No");
        EmpAttenDim.SETRANGE(Period, Rec.Period);
        EmpAttenDim.SETRANGE("Attendance Date", Rec."Attendance Date");
        if EmpAttenDim.FINDLAST then
            L_linenb := EmpAttenDim."Line No" + 1;
        //ELSE EmpAttenDim."Line No" := 1;
        L_linenb := L_linenb + 1;
        Rec."Line No" := L_linenb;

        // 16.11.2017 : A2+

        //Added to insert default values - 10.03.2018 : AIM +
        HRSetupTbt.GET();
        EmpTbt.SETRANGE("No.", "Employee No");
        if EmpTbt.FINDFIRST then begin
            EmployeeDimNo := PayrollFunctions.GetShortcutDimensionNoFromName('Employee');
            EmployeeDimCode := '';

            if EmpTbt."Related to" <> '' then
                EmployeeDimCode := EmpTbt."Related to"
            else
                EmployeeDimCode := EmpTbt."No.";

            "Global Dimension 1" := EmpTbt."Global Dimension 1 Code";

            "Global Dimension 2" := EmpTbt."Global Dimension 2 Code";

            if EmployeeDimNo = 3 then
                "Shortcut Dimension 3" := EmployeeDimCode
            else
                "Shortcut Dimension 3" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee No", 3);
            if EmployeeDimNo = 4 then
                "Shortcut Dimension 4" := EmployeeDimCode
            else
                "Shortcut Dimension 4" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee No", 4);
            if EmployeeDimNo = 5 then
                "Shortcut Dimension 5" := EmployeeDimCode
            else
                "Shortcut Dimension 5" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee No", 5);
            if EmployeeDimNo = 6 then
                "Shortcut Dimension 6" := EmployeeDimCode
            else
                "Shortcut Dimension 6" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee No", 6);
            if EmployeeDimNo = 7 then
                "Shortcut Dimension 7" := EmployeeDimCode
            else
                "Shortcut Dimension 7" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee No", 7);
            if EmployeeDimNo = 8 then
                "Shortcut Dimension 8" := EmployeeDimCode
            else
                "Shortcut Dimension 8" := PayrollFunctions.GetEmployeeShortcutDimensionValue("Employee No", 8);
        end;
        //Added to insert default values - 10.03.2018 : AIM -
    end;

    trigger OnModify();
    begin
        //Added in order not to update in case the period is closed 04/12/2017 //EDM.EmpAttDim+
        Employee.SETRANGE("Attendance No.", "Attendance No");
        if Employee.FINDFIRST then
            if not PayrollFunctions.CanModifyAttendanceRecord("Attendance Date", Employee."No.") then
                ERROR('Record cannot be updated. Period is closed');
        //Added in order not to update in case the period is closed 04/12/2017 //EDM.EmpAttDim-

        //Added in order to know the user who add the record - 04/12/2017 //EDM.EmpAttDim+
        "Modified By" := USERID;
        "Modified DateTime" := CREATEDATETIME(WORKDATE, TIME);
        //Added in order to know the user who add the record - 04/12/2017 //EDM.EmpAttDim-
    end;

    var
        EmpAttenDim: Record "Employees Attendance Dimension";
        PayrollFunctions: Codeunit "Payroll Functions";
        NoProjectDimension: Label 'Project dimension is not specified in the General Ledger Setup.';
        ProjectDimensionGlobal: Label 'Project dimension must be set as global dimension.';
        Employee: Record Employee;
        EmpAbsence: Record "Employee Absence";
        HRSetupTbt: Record "Human Resources Setup";

    procedure SetParameter(EmpNo: Code[20]; AttenNo: Integer; AttenDate: Date; AttenPeriod: Date);
    begin
    end;
}

