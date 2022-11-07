table 98007 "Hand Punch"
{
    DrillDownPageID = "Hand Punch List";
    LookupPageID = "Hand Punch List";

    fields
    {
        field(1; "Attendnace No."; Integer)
        {
            trigger OnValidate();
            begin
                Employee.SETRANGE("Attendance No.", "Attendnace No.");
                if Employee.FINDFIRST then
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Last Name";
            end;
        }
        field(2; "Employee Name"; Text[100])
        {
        }
        field(3; "Date Time"; DateTime)
        {
            trigger OnValidate();
            begin
                "Real Date" := DT2DATE("Date Time");
                Employee.SETRANGE("Attendance No.", "Attendnace No.");
                if Employee.FINDFIRST then begin
                    if not PayrollFunctions.CanModifyAttendanceRecord("Real Date", Employee."No.") then
                        ERROR('Record cannot be updated. Period is closed');
                end;
                "Real Time" := DT2TIME("Date Time");
                "Scheduled Date" := DT2DATE("Date Time");
                if "Action Type" = '' then
                    "Action Type" := 'IN';
            end;
        }
        field(4; "Action Type"; Text[30])
        {
            trigger OnValidate();
            begin
                if "Action Type" <> '' then
                    "Action Type" := UPPERCASE("Action Type");
            end;
        }
        field(5; "Real Date"; Date)
        {
            trigger OnValidate();
            begin
                Employee.SETRANGE("Attendance No.", "Attendnace No.");
                if Employee.FINDFIRST then
                    if not PayrollFunctions.CanModifyAttendanceRecord("Real Date", Employee."No.") then
                        ERROR('Record cannot be updated. Period is closed');
            end;
        }
        field(6; "Real Time"; Time)
        {
            trigger OnValidate();
            begin
                Employee.SETRANGE("Attendance No.", "Attendnace No.");
                if Employee.FINDFIRST then begin
                    if (not PayrollFunctions.CanModifyAttendanceRecord("Real Date", Employee."No.")) and ("Real Date" <> 0D) then
                        ERROR('Record cannot be updated. Period is closed');
                    if (not PayrollFunctions.CanModifyAttendanceRecord("Scheduled Date", Employee."No.")) and ("Scheduled Date" <> 0D) then
                        ERROR('Record cannot be updated. Period is closed');
                end;
                "Date Time" := CREATEDATETIME("Real Date", "Real Time");
                "Scheduled Date" := "Real Date";
                if "Action Type" = '' then
                    "Action Type" := 'IN';
            end;
        }
        field(7; "Modified By"; Code[50])
        {
            Editable = false;
        }
        field(8; "Modification Date"; Date)
        {
            Editable = false;
        }
        field(9; checked; Boolean)
        {
        }
        field(10; "Scheduled Date"; Date)
        {

            trigger OnValidate();
            begin
                Employee.SETRANGE("Attendance No.", "Attendnace No.");
                if Employee.FINDFIRST then
                    if not PayrollFunctions.CanModifyAttendanceRecord("Scheduled Date", Employee."No.") then
                        ERROR('Record cannot be updated. Period is closed');
            end;
        }
        field(11; "Special In Out"; Boolean)
        {
        }
        field(12; "Created By"; Code[50])
        {
        }
        field(13; "Created DateTime"; DateTime)
        {
        }
        field(14; "Employee No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Employee."No." WHERE("Attendance No." = FIELD("Attendnace No.")));
        }
        field(15; Period; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Employee Absence".Period WHERE("Attendance No." = FIELD("Attendnace No."), "From Date" = field("Scheduled Date")));
        }
    }
    keys
    {
        key(Key1; "Attendnace No.", "Date Time", "Real Date", "Real Time", "Action Type")
        {
        }
        key(Key2; "Attendnace No.", "Action Type", "Real Date", "Real Time")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Real Date" <> 0D then begin
            Employee.SETRANGE("Attendance No.", "Attendnace No.");
            if Employee.FINDFIRST then
                if not PayrollFunctions.CanModifyAttendanceRecord("Real Date", Employee."No.") then
                    ERROR('Record cannot be deleted. Period is closed');
        end;
    end;

    trigger OnInsert();
    begin
        if ("Real Date" <> 0D) then begin
            Employee.SETRANGE("Attendance No.", "Attendnace No.");
            if Employee.FINDFIRST then
                if not PayrollFunctions.CanModifyAttendanceRecord("Real Date", Employee."No.") then
                    ERROR('Record cannot be inserted. Period is closed');
        end;
        "Modified By" := USERID;
        "Modification Date" := WORKDATE;
        "Created By" := USERID;
        "Created DateTime" := CREATEDATETIME(WORKDATE, TIME);
    end;

    trigger OnModify();
    begin
        Employee.SETRANGE("Attendance No.", "Attendnace No.");
        if Employee.FINDFIRST then
            if not PayrollFunctions.CanModifyAttendanceRecord("Real Date", Employee."No.") then
                ERROR('Record cannot be updated. Period is closed');
        "Modified By" := USERID;
        "Modification Date" := WORKDATE;
        Rec.Modify;
    end;

    var
        Employee: Record Employee;
        PayrollFunctions: Codeunit "Payroll Functions";
}