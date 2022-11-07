table 98056 "Payroll Status"
{
    // version PY1.0,EDM.HRPY1

    Permissions = ;

    fields
    {
        field(1;"Pay Frequency";Option)
        {
            OptionMembers = Monthly,Weekly;
        }
        field(10;"Last Period Calculated";Integer)
        {
        }
        field(11;"Last Period Finalized";Integer)
        {
        }
        field(12;"Payroll Date";Date)
        {
        }
        field(13;"Posting Group";Code[10])
        {
            TableRelation = "Payroll Posting Group";
        }
        field(20;"P11 (NIC) Printed";Boolean)
        {
        }
        field(22;"P11 (PAYE) Printed";Boolean)
        {
        }
        field(24;"P14/P60 Printed";Boolean)
        {
        }
        field(26;"P35 Printed";Boolean)
        {
        }
        field(30;"Current Tax Period";Integer)
        {
            InitValue = 1;
        }
        field(40;"Payroll Group Code";Code[10])
        {
            NotBlank = true;
            TableRelation = "HR Payroll Group";
        }
        field(41;"Period Start Date";Date)
        {

            trigger OnValidate();
            begin
                case "Pay Frequency" of
                  "Pay Frequency"::Weekly:
                    DateExpr := '+1W-1D';
                  "Pay Frequency"::Monthly:
                    DateExpr := '+1M-1D';
                end;
                "Period End Date" := CALCDATE(DateExpr,"Period Start Date");
            end;
        }
        field(42;"Period End Date";Date)
        {
        }
        field(45;"SSP Period Start Date";Date)
        {
        }
        field(46;"SSP Period End Date";Date)
        {
        }
        field(47;"Exchange Rate";Decimal)
        {
            DecimalPlaces = 10:10;
        }
        field(48;"Finalized Payroll Date";Date)
        {
        }
        field(49;"Calculated Payroll Date";Date)
        {
        }
        field(50;"Ending Payroll Day";Integer)
        {

            trigger OnValidate();
            begin
                if "Ending Payroll Day" < 0 then
                  ERROR('Value must be Positive.');
            end;
        }
        field(51;"Start Fiscal Period";Integer)
        {

            trigger OnValidate();
            begin
                TESTFIELD("Start Fiscal Period");
                if "Start Fiscal Period" < 0 then
                  ERROR('Value must be Positive.');
                if "Pay Frequency" = "Pay Frequency"::Monthly then
                  if "Start Fiscal Period" > 12 then
                    ERROR('Start Fiscal Year cannot be greater than 12.');

                if "Pay Frequency" = "Pay Frequency"::Weekly then
                  if "Start Fiscal Period" > 52 then
                    ERROR('Start Fiscal Year cannot be greater than 52.');
            end;
        }
        field(52;"Last Applied Scholarship Date";Date)
        {
        }
        field(53;"Old Applied Scholarship Date";Date)
        {
        }
        field(54;"Last Applied Pension Date";Date)
        {
            Description = 'PY2.0';
        }
        field(55;"Old Applied Pension Date";Date)
        {
            Description = 'PY2.0';
        }
        field(56;"Starting Payroll Day";Integer)
        {
            Description = 'PY2.0';

            trigger OnValidate();
            begin
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2+
                if AllowSeparateAttendanceInterval then
                  if "Starting Payroll Day" <> 1 then
                    ERROR('Starting Payroll Day must be 1');
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2-
            end;
        }
        field(57;"Last Applied Sales Comm. Date";Date)
        {
            Description = 'PY2.0';
        }
        field(58;"Old Applied Sales Comm. Date";Date)
        {
            Description = 'PY2.0';
        }
        field(59;"Sales Comm. Start Date";Date)
        {
            Description = 'PY2.0';
        }
        field(60;"Sales Comm. End Date";Date)
        {
            Description = 'PY2.0';
        }
        field(61;"Supplement Start Date";Date)
        {
            trigger OnValidate();
            begin
                case "Pay Frequency" of
                  "Pay Frequency"::Weekly:
                    DateExpr := '+1W-1D';
                  "Pay Frequency"::Monthly:
                    DateExpr := '+1M-1D';
                end;
                "Supplement End Date" := CALCDATE(DateExpr,"Supplement Start Date");
            end;
        }
        field(62;"Supplement End Date";Date)
        {
        }
        field(63;"Supplement Period";Integer)
        {
        }
        field(64;"Supplement Payroll Date";Date)
        {
        }
        field(60000;"Supplement Exist";Boolean)
        {
        }
        field(80001;"Days Interval";Integer)
        {
        }
        field(80002;"Week Start Day";Integer)
        {
        }
        field(80003;"Attendance Start Date";Date)
        {

            trigger OnValidate();
            begin
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2+
                if not AllowSeparateAttendanceInterval then
                  "Attendance Start Date" := 0D;
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2-
            end;
        }
        field(80004;"Attendance End Date";Date)
        {

            trigger OnValidate();
            begin
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2+
                if not AllowSeparateAttendanceInterval then
                  "Attendance End Date" := 0D;
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2-
            end;
        }
        field(80005;"Separate Attendance Interval";Boolean)
        {

            trigger OnValidate();
            begin
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2+
                if not AllowSeparateAttendanceInterval then
                  ERROR('Separate Attendance Interval feature not initializied');
                if "Pay Frequency" <> "Pay Frequency"::Monthly then
                  ERROR('Allowed only for Monthly interval');
                if "Starting Payroll Day" <> 1 then
                  ERROR('Starting Payroll Day must be 1');
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2-
            end;
        }
        field(80006;"Attendance Start Day";Integer)
        {

            trigger OnValidate();
            begin
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2+
                if not AllowSeparateAttendanceInterval then
                  "Attendance Start Day" := 1;
                // Added in order to use Separate Attendance interval - 18.09.2017 : A2-
            end;
        }
        field(80007;"Attendance Period";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Payroll Group Code","Pay Frequency")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        VFound := false;
        PayDetailHeader.SETCURRENTKEY("Payroll Group Code","Pay Frequency");
        PayDetailHeader.SETRANGE("Payroll Group Code","Payroll Group Code");
        PayDetailHeader.SETRANGE("Pay Frequency","Pay Frequency");
        if PayDetailHeader.FIND('-') then
          VFound := true;
        PayLedgE.SETCURRENTKEY("Payroll Group Code","Pay Frequency");
        PayLedgE.SETRANGE("Payroll Group Code","Payroll Group Code");
        PayLedgE.SETRANGE("Pay Frequency","Pay Frequency");
        if PayLedgE.FIND('-') then
          VFound := true;
        if VFound then
          ERROR('Cannot be Deleted. Some Employees are assigned to %1 %2',"Pay Frequency","Payroll Group Code");
    end;

    var
        DateExpr : Text[30];
        PayDetailHeader : Record "Pay Detail Header";
        VFound : Boolean;
        PayLedgE : Record "Payroll Ledger Entry";

    local procedure AllowSeparateAttendanceInterval() : Boolean;
    var
        HRSetup : Record "Human Resources Setup";
    begin
        HRSetup.GET();
        if HRSetup."Seperate Attendance Interval" then
          exit(true)
        else
          exit(false);
    end;
}

