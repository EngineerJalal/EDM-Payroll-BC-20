table 98023 "Employee Absence Entitlement"
{
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Cause of Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(3; Entitlement; Decimal)
        {
            Editable = true;
            FieldClass = Normal;
        }
        field(4; Taken; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(5; "First Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'First Name';
            FieldClass = FlowField;
        }
        field(6; "Middle Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Middle Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Middle Name';
            FieldClass = FlowField;
        }
        field(7; "Last Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Last Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Last Name';
            FieldClass = FlowField;
        }
        field(80; "From Date"; Date)
        {
        }
        field(81; "Till Date"; Date)
        {
        }
        field(82; "Manual Deductions"; Decimal)
        {
        }
        field(83; "Manual Additions"; Decimal)
        {
        }
        field(84; "Transfer from Previous Year"; Decimal)
        {
        }
        field(85; Remarks; Text[250])
        {
        }
        field(86; "Attendance Additions"; Decimal)
        {
        }
        field(87; "Attendance Deductions"; Decimal)
        {
        }
        field(88; "Attendance No."; Integer)
        {
            CalcFormula = Lookup(Employee."Attendance No." WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(89; "Payroll Group"; Code[10])
        {
            CalcFormula = Lookup(Employee."Payroll Group Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(90; "Employment Type"; Code[20])
        {
            CalcFormula = Lookup(Employee."Employment Type Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(91; "ZOHO ID"; Code[10])
        {
            CalcFormula = Lookup("Employee Additional Info"."Zoho Id" WHERE("Employee No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(92; "Employee Category"; Code[10])
        {
            CalcFormula = Lookup(Employee."Employee Category Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(93; Department; Code[10])
        {
        }
        field(94; "Auto Calculate Entitlement"; Boolean)
        {
        }
        field(95; Status; Option)
        {
            FieldClass = FlowField;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
            CalcFormula = Lookup(Employee.Status WHERE("No." = FIELD("Employee No.")));
        }
        field(96; "First Year Entitlement"; Decimal)
        {
        }
        field(97; "Year Entitlement"; Decimal)
        {
        }
        field(98; "Employment date"; Date)
        {
            CalcFormula = Lookup(Employee."Employment Date" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(99; "AL Start Date"; Date)
        {
            CalcFormula = Lookup(Employee."AL Starting Date" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(100; "Scheduled Leave Request"; Decimal)
        {
            CalcFormula = Sum("Leave Request"."Days Value" WHERE("Employee No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(101; "Termination Date"; Date)
        {
            CalcFormula = Lookup(Employee."Termination Date" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(102; "Inactive Date"; Date)
        {
            CalcFormula = Lookup(Employee."Inactive Date" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(103; "Period start Date"; Date)
        {
            CalcFormula = Lookup("Payroll Status"."Period Start Date");
            FieldClass = FlowField;
        }
        field(104; "Period End Date"; Date)
        {
            CalcFormula = Lookup("Payroll Status"."Period End Date");
            FieldClass = FlowField;
        }
        field(105; "Company E-Mail"; Text[80])
        {
            CalcFormula = Lookup(Employee."Company E-Mail");
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Cause of Absence Code", "From Date", "Till Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        EmployeeJournals.SETRANGE("Employee No.", Rec."Employee No.");
        EmployeeJournals.SETRANGE("Cause of Absence Code", Rec."Cause of Absence Code");
        EmployeeJournals.SETFILTER("Starting Date", '%1..%2', "From Date", "Till Date");
        EmployeeJournals.SETFILTER("Ending Date", '%1..%2', "From Date", "Till Date");
    end;

    trigger OnInsert();
    var
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.GET;
        if HRSetup."Auto Calculate Entitlement" then
            "Auto Calculate Entitlement" := true
        else
            "Auto Calculate Entitlement" := false;
    end;

    var
        EmployeeJournals: Record "Employee Journal Line";
}