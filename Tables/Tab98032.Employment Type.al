table 98032 "Employment Type"
{
    DrillDownPageID = "Employment Type";
    LookupPageID = "Employment Type";
    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
            trigger OnValidate();
            begin
                EVALUATE("Period Type", '1D');
            end;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; Type; Option)
        {
            OptionMembers = " ",Contract,Casual,"Full Time","Part Time";
        }
        field(4; "Base Calendar Code"; Code[10])
        {
            NotBlank = false;
            TableRelation = "Base Calendar N".Code;
        }
        field(5; "Working Days Per Month"; Integer)
        {
            trigger OnValidate();
            begin
                RecalculatDailyRate();
            end;
        }
        field(6; "Working Hours Per Day"; Decimal)
        {
            trigger OnValidate();
            begin
                RecalculatDailyRate();
            end;
        }
        field(7; "Standard Schedule"; Boolean)
        {
            CalcFormula = Exist("Employment Type Schedule" WHERE("Table Name" = CONST(StandardSched), "Employment Type Code" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "No. of Working Days"; Decimal)
        {
        }
        field(9; "Shift Code"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(10; "Overtime Unpaid Hours"; Decimal)
        {
        }
        field(11; "Overtime Rate"; Decimal)
        {
        }
        field(12; "Absence Deduction Rate"; Decimal)
        {
        }
        field(13; "Absence Tolerance Hours"; Decimal)
        {
        }
        field(14; "Period Type"; DateFormula)
        {
        }
        field(80001; "Working Hours"; Decimal)
        {
            CalcFormula = Sum("Employment Type Schedule"."No. of Hours" WHERE("Employment Type Code" = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(80002; "Working Days"; Integer)
        {
            CalcFormula = Count("Employment Type Schedule" WHERE("Employment Type Code" = FIELD(Code), "No. of Hours" = FILTER(> 0)));
            FieldClass = FlowField;
        }
        field(80003; "Max Allowed Overtime Per Day"; Decimal)
        {
        }
        field(80004; "Early Arrive Not Allowed"; Boolean)
        {
        }
        field(80005; "Late Leave Not Allowed"; Boolean)
        {
        }
        field(80006; "Use Daily Shift Rates"; Boolean)
        {
        }
        field(80007; "Use Hourly Rate"; Boolean)
        {
        }
        field(80008; "Penalize Late Arrive"; Boolean)
        {
        }
        field(80009; "Auto fix missing punch"; Boolean)
        {
        }
        field(80010; "Missing Punch In Penalty Hrs"; Decimal)
        {
        }
        field(80011; "Missing Punch Out Penalty Hrs"; Decimal)
        {
        }
        field(80012; "Punch In Time Ceil"; Time)
        {
        }
        field(80013; "First Last Punch Only"; Boolean)
        {
        }
        field(80014; "Ignore Payroll Posting"; Boolean)
        {
            Description = 'Added in order to generate attendance to specific Employment type - 18.04.2017 : A2';
        }
        field(80015; "Manual Finalize"; Boolean)
        {
            Description = 'Added in order to finalize attendance and add one month to period in employee card for specific employment type - 18.04.2017 : A2';
        }
        field(80016; "Use Daily Shift Tolerance"; Boolean)
        {
        }
        field(80017; "Max Monthly Paid Overtime"; Decimal)
        {

            trigger OnValidate();
            begin
                EVALUATE(PeriodType, '1M');
                if (PeriodType <> "Period Type") and ("Max Monthly Paid Overtime" > 0) then
                    ERROR('Applicable only for Monthly Period Type');
            end;
        }
        field(80018; "Late Arrive Base Time"; Time)
        {
        }
        field(80019; "Late Arrive Policy"; Option)
        {
            OptionMembers = "Interval Penalty","Day Count Penalty";
            OptionCaption = 'Interval Penalty,Day Count Penalty';
        }
        field(80020; "Late Arrive Cummulative Days"; Integer)
        {

        }

        field(80021; "Late Arrive Penalty Days"; Decimal)
        {

        }
        field(80022; "Manual schedule"; Boolean)
        {
        }

    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        EmploymentTypeSchedule.SETRANGE("Employment Type Code", Code);
        EmploymentTypeSchedule.SETFILTER("Table Name", 'StandardSched');
        EmploymentTypeSchedule.DELETEALL;
    end;

    procedure RecalculatDailyRate();
    var
        EmployeeRec: Record Employee;
        EmpAddInfoRec: Record "Employee Additional Info";
        ExtraSalay: Decimal;
        L_Updaterate: Boolean;
        HRSetup: Record "Human Resources Setup";
    begin
        CLEAR(EmployeeRec);
        EmployeeRec.SETRANGE("Employment Type Code", Code);
        EmployeeRec.SETRANGE(Status, EmployeeRec.Status::Active);
        IF EmployeeRec.FINDFIRST THEN
            Repeat
                IF ("Working Days Per Month" > 0) AND ("Working Hours Per Day" > 0) THEN BEGIN
                    IF (EmployeeRec."Daily Rate" > 0) OR (EmployeeRec."Hourly Rate" > 0) THEN BEGIN
                        EmpAddInfoRec.RESET;
                        EmpAddInfoRec.SETRANGE("Employee No.", EmployeeRec."No.");
                        IF EmpAddInfoRec.FINDFIRST THEN
                            ExtraSalay := EmpAddInfoRec."Extra Salary";

                        EmployeeRec."Daily Rate" := ROUND((EmployeeRec."Basic Pay" + ExtraSalay) / "Working Days Per Month", 0.01);
                        EmployeeRec."Hourly Rate" := ROUND((EmployeeRec."Basic Pay" + ExtraSalay) / ("Working Days Per Month" * "Working Hours Per Day"), 0.01);
                        EmployeeRec.MODIFY;
                    end
                    ELSE BEGIN
                        EmployeeRec."Daily Rate" := ROUND(EmployeeRec."Basic Pay" / "Working Days Per Month", 0.01);
                        EmployeeRec."Hourly Rate" := ROUND(EmployeeRec."Basic Pay" / ("Working Days Per Month" * "Working Hours Per Day"), 0.01);
                        EmployeeRec.MODIFY;
                    END;
                end;
            Until EmployeeRec.NEXT = 0;
    end;

    var
        EmploymentTypeSchedule: Record "Employment Type Schedule";
        PeriodType: DateFormula;
}