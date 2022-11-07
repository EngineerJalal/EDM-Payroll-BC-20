table 98054 "Pay Detail Header"
{
    // version PY1.0,EDM.HRPY1

    // PY4.1 : - fix the flowfield <Attendance Days Affected>  take value from <rouding of calculated value>


    fields
    {
        field(1;"Pay Frequency";Option)
        {
            OptionMembers = Monthly,Weekly;
        }
        field(5;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(10;"Calculation Required";Boolean)
        {
            InitValue = true;
        }
        field(11;"Payslip Printed";Boolean)
        {
        }
        field(12;"Include in Pay Cycle";Boolean)
        {
            InitValue = true;
        }
        field(20;"Payroll Group Code";Code[10])
        {
            TableRelation = "HR Payroll Group"."Code";
        }
        field(21;"Employee Name";Text[100])
        {
            FieldClass = Normal;
        }
        field(50001;"USD Exchange Rate";Decimal)
        {
            DecimalPlaces = 10:10;
        }
        field(50002;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(50003;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(50004;"User ID";Code[20])
        {
        }
        field(50005;"Working Days Affected";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Affect Work Days"=CONST(true),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('DAY'),
                                                                                "Associate Pay Element"=CONST(false),
                                                                                "Absence Transaction Type"=FILTER(<>Overtime&<>Public),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Reseted=CONST(false),
                                                                                Entitled=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006;"Attendance Days Affected";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Rounding of Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                            Type=CONST('ABSENCE'),
                                                                                            Processed=CONST(false),
                                                                                            "Affect Attendance Days"=CONST(true),
                                                                                            "Document Status"=CONST(Approved),
                                                                                            Converted=CONST(false),
                                                                                            "Unit of Measure Code"=CONST('DAY'),
                                                                                            "Associate Pay Element"=CONST(false),
                                                                                            "Absence Transaction Type"=FILTER(<>Overtime),
                                                                                            "Starting Date"=FIELD("Date Filter"),
                                                                                            Entitled=CONST(false),
                                                                                            Reseted=CONST(false),
                                                                                            "Day-Off"=CONST(false)));
            Description = 'PY4.1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007;"Overtime Hours";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Absence Transaction Type"=CONST(Overtime),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('HOUR'),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Entitled=CONST(false),
                                                                                Reseted=CONST(false),
                                                                                "Unpaid Period"=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008;"Overtime Public Holiday";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Absence Transaction Type"=CONST(Public),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('DAY'),
                                                                                "Associate Pay Element"=CONST(true),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Entitled=CONST(false),
                                                                                Reseted=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(50010;"Converted Salary";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Converted Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                               Type=CONST('ABSENCE'),
                                                                               Processed=CONST(false),
                                                                               "Document Status"=CONST(Approved),
                                                                               "Unit of Measure Code"=CONST('DAY'),
                                                                               "Associate Pay Element"=CONST(true),
                                                                               "Absence Transaction Type"=FILTER(Salary),
                                                                               "Transaction Date"=FIELD("Date Filter"),
                                                                               Reseted=CONST(false),
                                                                               Entitled=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011;"Overtime with Unpaid Hours";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Absence Transaction Type"=CONST(Overtime),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('HOUR'),
                                                                                "Associate Pay Element"=CONST(true),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Entitled=CONST(false),
                                                                                Reseted=CONST(false),
                                                                                "Unpaid Period"=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012;"Lateness Days Affected";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Affect Work Days"=CONST(true),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('DAY'),
                                                                                "Associate Pay Element"=CONST(false),
                                                                                "Absence Transaction Type"=FILTER(Lateness),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Reseted=CONST(false),
                                                                                Entitled=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013;"Days-Off Transportation";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Rounding of Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                            Type=CONST('ABSENCE'),
                                                                                            Processed=CONST(false),
                                                                                            "Document Status"=CONST(Approved),
                                                                                            "Day-Off"=CONST(true),
                                                                                            "Absence Transaction Type"=FILTER("Day-Off"),
                                                                                            "Starting Date"=FIELD("Date Filter"),
                                                                                            Reseted=CONST(false),
                                                                                            Entitled=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014;"Late/ Early Attendance (Hours)";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Affect Work Days"=CONST(true),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('HOUR'),
                                                                                "Associate Pay Element"=CONST(false),
                                                                                "Absence Transaction Type"=FILTER(<>Overtime&<>Public),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Reseted=CONST(false),
                                                                                Entitled=CONST(false)));
            Description = 'MB.0605';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015;"Overtime Days";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Absence Transaction Type"=CONST(Overtime),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('DAY'),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Entitled=CONST(false),
                                                                                Reseted=CONST(false),
                                                                                "Unpaid Period"=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016;Status;Option)
        {
            CalcFormula = Lookup(Employee.Status WHERE ("No."=FIELD("Employee No.")));
            Caption = 'Status';
            FieldClass = FlowField;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(50017;Bonus;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('06'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50018;Allowances;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('07'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50019;"Business Trip Allowance";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('08'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50020;TravelAllowance;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('09'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50021;"Other Deduction";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('12'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50022;"Food Allowance";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('80'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50023;"Clothes Allowance";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('81'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50024;"Cash Advance/Loan";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('ADVANCED'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50025;Allowance;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('ALLOWANCE'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50026;"Basic Pay";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('BASIC'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50027;Bonus2;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('BONUS'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50028;OtherDeduction;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('DEDUCTION'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50029;"End of Services";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('EOS'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50030;"Family Allowance";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('FAM_ALLOW'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50031;"Family Subscription";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('FAMSUB'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50032;"Food Allowances";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('FOOD'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50033;"Housing Allowance";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('HOUSING'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50034;"Loan Payment";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('LOAN_PAYME'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50035;"Mobile Allowance";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('MOBILE'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50036;NSSF;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('NSSF'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50037;Overtime;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('OVERTIME'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50038;"Overtime By Day";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('OVERTIMEDA'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50039;"Income Tax";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('TAX'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50040;Transportation;Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('TRANS'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(50041;"Travel Allowance";Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line".Amount WHERE ("Employee No."=FIELD("Employee No."),
                                                                 "Pay Element Code"=CONST('TRAVEL'),
                                                                 Open=CONST(true)));
            FieldClass = FlowField;
        }
        field(60000;"Active Employee";Option)
        {
            CalcFormula = Lookup(Employee.Status WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(80259;"No. of Working Days";Integer)
        {
            CalcFormula = Count("Employee Journal Line" WHERE ("Employee No."=FIELD("Employee No."),
                                                               "Absence Code Type"=FILTER("Working Day"|"Working Holiday"),
                                                               Processed=CONST(false),
                                                               "Document Status"=CONST(Approved),
                                                               Converted=CONST(false),
                                                               "Unit of Measure Code"=CONST('DAY'),
                                                               "Associate Pay Element"=CONST(false),
                                                               "Starting Date"=FIELD("Date Filter"),
                                                               Entitled=CONST(false),
                                                               Reseted=CONST(false),
                                                               "Day-Off"=CONST(false),
                                                               "Calculated Value"=FILTER(>0),
                                                               "Transaction Type"=Filter('ABS'),
                                                               "Attendance Hours"=FILTER(>0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80260;"Payroll Date";Date)
        {
            FieldClass = FlowFilter;
        }
        field(80261;"No. Of Working Days-Attendance";Integer)
        {
            CalcFormula = Count("Employee Absence" WHERE ("Employee No."=FIELD("Employee No."),
                                                          "From Date"=FIELD("Date Filter"),
                                                          Type=FILTER("Working Day"|"Sick Day"|"Working Holiday"|"Unpaid Vacation"|AL),
                                                          "Not Include in Transportation"=CONST(false),
                                                          "Attend Hrs."=FILTER(<>0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80262;"Employee Related To";Code[20])
        {
            CalcFormula = Lookup(Employee."Related to" WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
            TableRelation = Employee."No.";
        }
        field(80263;Location;Code[10])
        {
            CalcFormula = Lookup(Employee.Location WHERE ("No."=FIELD("Employee No.")));
            Caption = 'Employee Location';
            FieldClass = FlowField;
        }
        field(80264;Department;Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE ("Table ID"=CONST(5200),
                                                                                   "No."=FIELD("Employee No."),
                                                                                   "Dimension Code"=CONST('DEPARTMENT')));
            Caption = 'Employee Department';
            FieldClass = FlowField;
        }
        field(80265;Division;Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE ("Table ID"=CONST(5200),
                                                                                   "No."=FIELD("Employee No."),
                                                                                   "Dimension Code"=CONST('DIVISION')));
            Caption = 'Employee Division';
            FieldClass = FlowField;
        }
        field(80266;Branch;Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE ("Table ID"=CONST(5200),
                                                                                   "No."=FIELD("Employee No."),
                                                                                   "Dimension Code"=CONST('BRANCH')));
            Caption = 'Employee Branch';
            FieldClass = FlowField;
        }
        field(80267;"Employee Type";Option)
        {
            CalcFormula = Lookup(Employee."Employee Type" WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
            OptionCaption = 'Non declared – Engineers,Probation period,Employees,Contractual (labors 3%)';
            OptionMembers = "Non declared – Engineers","Probation period",Employees,"Contractual (labors 3%)";
        }
        field(80268;"Late Arrive Hours";Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE ("Employee No."=FIELD("Employee No."),
                                                                                Type=CONST('ABSENCE'),
                                                                                Processed=CONST(false),
                                                                                "Affect Work Days"=CONST(true),
                                                                                "Document Status"=CONST(Approved),
                                                                                Converted=CONST(false),
                                                                                "Unit of Measure Code"=CONST('HOUR'),
                                                                                "Associate Pay Element"=CONST(false),
                                                                                "Absence Transaction Type"=FILTER("Late-Arrive"),
                                                                                "Starting Date"=FIELD("Date Filter"),
                                                                                Reseted=CONST(false),
                                                                                Entitled=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        } 
        field(80269;"Business Unit";Code[10])
        {
            CalcFormula = Lookup(Employee."Business Unit" WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
            Editable = false;
        }   
        field(80270; "Skip Finance"; Boolean)
        {
        }

        field(80271; "No. Of Weekend Days"; Integer)
        {
            CalcFormula = Count("Employee Absence" WHERE("Employee No." = FIELD("Employee No."),
                                                          "From Date" = FIELD("Date Filter"),
                                                          Type = FILTER("Working Day"),
                                                          "Not Include in Transportation" = CONST(false),
                                                          "Shift Code" = FILTER('WEEKEND')));
            Editable = false;
            FieldClass = FlowField;
        }

        field(80272; "No. of Holidays"; Integer)
        {
            CalcFormula = Count("Employee Absence" WHERE("Employee No." = FIELD("Employee No."),
                                                          "From Date" = FIELD("Date Filter"),
                                                          "Cause of Absence Code" = FILTER('HOLIDAY')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80273; "Weekend days"; Integer)
        {
            CalcFormula = Count("Employee Absence" WHERE("Employee No." = FIELD("Employee No."),
                                                          "From Date" = FIELD("Date Filter"),
                                                          "Cause of Absence Code" = FILTER('WEEKEND*' | 'WEEKEND'),
                                                          "Not Include in Transportation" = CONST(false),
                                                          "Attend Hrs." = FILTER(0)));
            Editable = false;
            FieldClass = FlowField;
        }                       
    }

    keys
    {
        key(Key1;"Employee No.")
        {
        }
        key(Key2;"Payroll Group Code","Pay Frequency")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        PayDetailLine.SETRANGE("Employee No.","Employee No.");
        if PayDetailLine.FIND('-') then
          PayDetailLine.DELETEALL;
    end;

    var
        PayDetailLine : Record "Pay Detail Line";
}

