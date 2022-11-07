table 98044 "Employee Dimensions"
{
    Caption = 'Employee Dimensions';
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            var
                EmployeeDimNo: Integer;
                EmployeeDimCode: Code[20];
                EmpTbt: Record Employee;
            begin
                EmpTbt.SETRANGE("No.", "Employee No.");
                if EmpTbt.FINDFIRST then begin
                    EmployeeDimNo := PayrollFunction.GetShortcutDimensionNoFromName('Employee');
                    EmployeeDimCode := '';
                    if EmpTbt."Related to" <> '' then
                        EmployeeDimCode := EmpTbt."Related to"
                    else
                        EmployeeDimCode := EmpTbt."No.";
                    "Payroll Date" := DMY2DATE(PayrollFunction.GetLastDayinMonth(WORKDATE), DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
                    "Shortcut Dimension 1 Code" := EmpTbt."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := EmpTbt."Global Dimension 2 Code";
                    Percentage := 100;
                    if EmployeeDimNo = 3 then
                        "Shortcut Dimension 3 Code" := EmployeeDimCode
                    else
                        "Shortcut Dimension 3 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue("Employee No.", 3);
                    if EmployeeDimNo = 4 then
                        "Shortcut Dimension 4 Code" := EmployeeDimCode
                    else
                        "Shortcut Dimension 4 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue("Employee No.", 4);
                    if EmployeeDimNo = 5 then
                        "Shortcut Dimension 5 Code" := EmployeeDimCode
                    else
                        "Shortcut Dimension 5 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue("Employee No.", 5);
                    if EmployeeDimNo = 6 then
                        "Shortcut Dimension 6 Code" := EmployeeDimCode
                    else
                        "Shortcut Dimension 6 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue("Employee No.", 6);
                    if EmployeeDimNo = 7 then
                        "Shortcut Dimension 7 Code" := EmployeeDimCode
                    else
                        "Shortcut Dimension 7 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue("Employee No.", 7);
                    if EmployeeDimNo = 8 then
                        "Shortcut Dimension 8 Code" := EmployeeDimCode
                    else
                        "Shortcut Dimension 8 Code" := PayrollFunction.GetEmployeeShortcutDimensionValue("Employee No.", 8);
                end;
            end;
        }
        field(2; "Payroll Date"; Date)
        {
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = false;
            TableRelation = Dimension;

            trigger OnValidate();
            begin
                if not DimMgt.CheckDim("Dimension Code") then
                    ERROR(DimMgt.GetDimErr);
            end;
        }
        field(4; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));

            trigger OnValidate();
            begin
                if not DimMgt.CheckDimValue("Dimension Code", "Dimension Value Code") then
                    ERROR(DimMgt.GetDimErr);
            end;
        }
        field(5; Percentage; Decimal)
        {
        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), "Dimension Value Type" = FILTER(Standard));
        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), "Dimension Value Type" = FILTER(Standard));
        }
        field(8; Resource; Code[20])
        {
        }
        field(9; "Employee Name"; Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), "Dimension Value Type" = FILTER(Standard));
        }
        field(11; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), "Dimension Value Type" = FILTER(Standard));
        }
        field(12; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), "Dimension Value Type" = FILTER(Standard));
        }
        field(13; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), "Dimension Value Type" = FILTER(Standard));
        }
        field(14; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), "Dimension Value Type" = FILTER(Standard));
        }
        field(15; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), "Dimension Value Type" = FILTER(Standard));
        }
        field(16; "Job No."; Code[20])
        {
            TableRelation = Job;
        }
        field(17; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Payroll Date", "Dimension Code", "Dimension Value Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code", "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code", "Job No.", "Job Task No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        L_HRSetupTbt: Record "Human Resources Setup";
    begin
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        PayrollFunction: Codeunit "Payroll Functions";

    procedure InsertEmployeeDimensionCode(EmpNo: Code[20]);
    var
        EmpTbt: Record Employee;
        Ind: Integer;
        EmpRelatedTo: Code[20];
    begin
        Ind := PayrollFunction.GetShortcutDimensionNoFromName('Employee');
        EmpTbt.SETRANGE("No.", EmpNo);

        if EmpTbt.FINDFIRST then begin
            PayrollFunction.InsertEmployeeCodeToDimensionsTable(EmpNo);
            if (EmpTbt."Related to" = '') or (EmpTbt."Related to" = EmpNo) then
                EmpRelatedTo := EmpNo
            else
                EmpRelatedTo := EmpTbt."Related to";
            if Ind = 1 then
                Rec."Shortcut Dimension 1 Code" := EmpRelatedTo
            else
                if Ind = 2 then
                    Rec."Shortcut Dimension 2 Code" := EmpRelatedTo
                else
                    if Ind = 3 then
                        Rec."Shortcut Dimension 3 Code" := EmpRelatedTo
                    else
                        if Ind = 4 then
                            Rec."Shortcut Dimension 4 Code" := EmpRelatedTo
                        else
                            if Ind = 5 then
                                Rec."Shortcut Dimension 5 Code" := EmpRelatedTo
                            else
                                if Ind = 6 then
                                    Rec."Shortcut Dimension 6 Code" := EmpRelatedTo
                                else
                                    if Ind = 7 then
                                        Rec."Shortcut Dimension 7 Code" := EmpRelatedTo
                                    else
                                        if Ind = 8 then
                                            Rec."Shortcut Dimension 8 Code" := EmpRelatedTo;
        end;
    end;
}