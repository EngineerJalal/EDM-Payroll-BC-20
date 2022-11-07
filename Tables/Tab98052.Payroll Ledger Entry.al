table 98052 "Payroll Ledger Entry"
{
    // version PY1.0,EDM.HRPY1

    // VIP2.00.07  Vorsprung Systems Development Ltd
    //             Added new fields  37 - "Employee NI Rebate"
    //                               38 - "Employee Net NI"
    //                               57 - "Employer Net NI"
    //                              104 - "Earnings up to E'er Threshold"
    //             Renamed field 101 to "Earnings up to E'ee Threshold"
    //             Added field 33 - "Student Loan Deduction"
    //             Added field 110 - "Tax Credit"
    // 
    // VIP2.00.08  Vorsprung Systems Development Ltd
    //             Added Employer Net NI as a SumIndexField for Department/Company Totals report.
    // 
    // VIP2.00.11  Vorsprung Business Systems Ltd
    //             Added "Earnings up to ET" to replace "Earnings up to E'ee Threshold" and
    //             "Earnings up to E'er Threshold".

    DrillDownPageID = "Payroll Ledger Entries";
    LookupPageID = "Payroll Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(6; "Document No."; Code[20])
        {
        }
        field(7; Description; Text[20])
        {
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
        }
        field(20; "Gross Pay"; Decimal)
        {
        }
        field(21; "Taxable Pay"; Decimal)
        {
        }
        field(22; "Scholarship Pay"; Decimal)
        {
        }
        field(30; "Tax Paid"; Decimal)
        {
        }
        field(31; "Scholarship Pay (ACY)"; Decimal)
        {
        }
        field(32; "Employee Pension"; Decimal)
        {
        }
        field(33; "Student Loan Deduction"; Decimal)
        {
        }
        field(34; "Net Pay"; Decimal)
        {
        }
        field(35; Rounding; Decimal)
        {
        }
        field(36; "Adjusted Net Pay"; Decimal)
        {
        }
        field(37; "HCL Pay"; Decimal)
        {
        }
        field(38; "HCL Pay (ACY)"; Decimal)
        {
        }
        field(40; "Free Pay"; Decimal)
        {
        }
        field(41; "Sales Commission Pay"; Decimal)
        {
        }
        field(42; "Sales Commission Pay (ACY)"; Decimal)
        {
        }
        field(43; "1a Earnings"; Decimal)
        {
        }
        field(44; "C Out Earnings"; Decimal)
        {
        }
        field(45; "C Out Contributions"; Decimal)
        {
        }
        field(50; "Employer NIC"; Decimal)
        {
        }
        field(51; "Employer Pension"; Decimal)
        {
        }
        field(52; "NI Holiday Value"; Decimal)
        {
        }
        field(53; "NI Holiday"; Boolean)
        {
        }
        field(54; "Class 1A NIC Car"; Decimal)
        {
        }
        field(55; "Class 1A NIC Fuel"; Decimal)
        {
        }
        field(56; "Employer NI Rebate"; Decimal)
        {
        }
        field(57; "Employer Net NI"; Decimal)
        {
        }
        field(60; Hours; Decimal)
        {
        }
        field(61; Overtime; Decimal)
        {
        }
        field(62; "Periods to Advance"; Integer)
        {
        }
        field(63; "Holiday Days"; Decimal)
        {
        }
        field(70; "Net Pay (ACY)"; Decimal)
        {
        }
        field(71; SMP; Decimal)
        {
        }
        field(72; "SMP Reclaim"; Decimal)
        {
        }
        field(73; "SMP Compensation"; Decimal)
        {
        }
        field(80; "Pay Frequency"; Option)
        {
            OptionMembers = Monthly,Weekly;
        }
        field(81; "Exempt Tax"; Decimal)
        {
        }
        field(82; "NI Letter"; Option)
        {
            OptionMembers = ,A,B,C,D,E,"C Out",F,G,S,X;
        }
        field(83; "Tax Year"; Integer)
        {
        }
        field(84; Period; Integer)
        {
        }
        field(85; "Payment Method"; Option)
        {
            OptionMembers = " ",Bank,Cheque,Cash;
        }
        field(86; "Cheque Printed"; Boolean)
        {
        }
        field(87; "Contract Type"; Option)
        {
            OptionMembers = " ","Daily Basis";
        }
        field(88; "SCON No."; Text[8])
        {
        }
        field(90; Open; Boolean)
        {
        }
        field(91; "Current Year"; Boolean)
        {
        }
        field(95; "Payroll Group Code"; Code[10])
        {
            TableRelation = "HR Payroll Group"."Code";
        }
        field(100; "Earnings up to LEL"; Decimal)
        {
        }
        field(101; "Earnings up to E'ee Threshold"; Decimal)
        {
        }
        field(102; "Earnings up to UEL"; Decimal)
        {
        }
        field(103; "Earnings over UEL"; Decimal)
        {
        }
        field(104; "Earnings up to E'er Threshold"; Decimal)
        {
        }
        field(105; "Earnings up to ET"; Decimal)
        {
        }
        field(110; "Tax Credit"; Decimal)
        {
        }
        field(50001; "Exchange Rate"; Decimal)
        {
            DecimalPlaces = 10 : 10;
        }
        field(50002; "Provisional Employer Contrib."; Decimal)
        {
        }
        field(50003; "Basic Salary"; Decimal)
        {
        }
        field(50004; "Taxable Allowances"; Decimal)
        {
        }
        field(50005; "Non-Taxable Deductions"; Decimal)
        {
        }
        field(50006; "Family Allowance"; Decimal)
        {
        }
        field(50007; "Non-Taxable Allowances"; Decimal)
        {
        }
        field(50008; "Overtime Pay"; Decimal)
        {
        }
        field(50009; "Employer Family Subscription"; Decimal)
        {
        }
        field(50010; "Employer EOSIND"; Decimal)
        {
        }
        field(50011; "Employer Motherhood"; Decimal)
        {
        }
        field(50012; "Salary (ACY)"; Decimal)
        {
        }
        field(50013; "Working Days Absence Pay"; Decimal)
        {
        }
        field(50014; "Employee Loan"; Decimal)
        {
        }
        field(50015; "Extra Tax Tpn Rebate"; Decimal)
        {
        }
        field(50016; "Taxable Deductions"; Decimal)
        {
        }
        field(80200; "Public Overtime"; Decimal)
        {
        }
        field(80201; "Public Overtime Pay"; Decimal)
        {
        }
        field(80202; "Working Days Absence"; Decimal)
        {
        }
        field(80203; "Attendance Days Absence"; Decimal)
        {
        }
        field(80204; "Attendance Days Absence Pay"; Decimal)
        {
        }
        field(80205; "Payroll Date"; Date)
        {
        }
        field(80206; "Gross Pay (ACY)"; Decimal)
        {
        }
        field(80207; "Allowances (ACY)"; Decimal)
        {
        }
        field(80208; "Deductions (ACY)"; Decimal)
        {
        }
        field(80209; "Employee Loan (ACY)"; Decimal)
        {
        }
        field(80210; "Converted Salary"; Decimal)
        {
        }
        field(80211; "Converted Salary Pay"; Decimal)
        {
        }
        field(80212; "Converted Salary Pay (ACY)"; Decimal)
        {
        }
        field(80213; "Public Overtime Pay (ACY)"; Decimal)
        {
        }
        field(80214; "Overtime Pay (ACY)"; Decimal)
        {
        }
        field(80215; "Working Days Absence Pay (ACY)"; Decimal)
        {
        }
        field(80216; "Tax Paid (ACY)"; Decimal)
        {
        }
        field(80217; "Attendance Days Abs Pay (ACY)"; Decimal)
        {
        }
        field(80218; "Period Start Date"; Date)
        {
        }
        field(80219; "Period End Date"; Date)
        {
        }
        field(80220; "Lateness Days Abs."; Decimal)
        {
        }
        field(80221; "Lateness Days Abs. Pay"; Decimal)
        {
        }
        field(80222; "Lateness Days Abs. Pay (ACY)"; Decimal)
        {
        }
        field(80223; "Vacation Balance"; Decimal)
        {
        }
        field(80224; "Outstanding Loan"; Decimal)
        {
        }
        field(80225; "Outstanding Loan (ACY)"; Decimal)
        {
        }
        field(80226; "Employment Type Code"; Code[20])
        {
            TableRelation = "Employment Type";
        }
        field(80227; "Social Status"; Option)
        {
            OptionMembers = Single,Married,Widow,Divorced,Separated;
        }
        field(80228; "Spouse Secured"; Boolean)
        {
        }
        field(80229; "Husband Paralysed"; Boolean)
        {
            CaptionClass = 'Husband Unemployed';
        }
        field(80230; Foreigner; Option)
        {
            OptionMembers = " ","End of Service","Not End of Service";
        }
        field(80231; Declared; Option)
        {
            OptionMembers = " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        }
        field(80232; "Eligible Children Count"; Integer)
        {
        }
        field(80233; "First Name"; Text[30])
        {
        }
        field(80234; "Last Name"; Text[30])
        {
        }
        field(80235; "Spouse Exempt Tax"; Boolean)
        {
        }
        field(80236; "Emp. Bank Acc No."; Code[50])
        {
            Description = 'PY1.0';
        }
        field(80237; "Emp. Bank Acc No. (ACY)"; Code[30])
        {
        }
        field(80238; "Bank No."; Code[20])
        {
            Description = 'PY1.0';
            TableRelation = "Bank Account";
        }
        field(80239; "Bank No. (ACY)"; Code[20])
        {
            Description = 'PY1.0';
            TableRelation = "Bank Account";
        }
        field(80240; "Payment Method (ACY)"; Option)
        {
            OptionMembers = Bank,Cheque,Cash;
        }
        field(80241; "Job Title"; Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST("Job Title"));
        }
        field(80242; "Job Position Code"; Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST("Job Position"));
        }
        field(80243; "Commission Type"; Option)
        {
            Description = 'PY2.0';
            OptionMembers = " ",Specific,All,Porter,Merchandiser;
        }
        field(80244; "Total Working Days"; Integer)
        {
            Description = 'PY2.0';
        }
        field(80245; "Late/ Early Attendance (Hours)"; Decimal)
        {
            Description = 'MB.0605';
        }
        field(80246; "Late Attendance (Hours)"; Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE("Employee No." = FIELD("Employee No."),
                                                                                Type = CONST('ABSENCE'),
                                                                                Processed = CONST(true),
                                                                                "Affect Work Days" = CONST(true),
                                                                                "Document Status" = CONST(Approved),
                                                                                Converted = CONST(false),
                                                                                "Unit of Measure Code" = CONST('HOUR'),
                                                                                "Associate Pay Element" = CONST(false),
                                                                                "Absence Transaction Type" = FILTER(<> Overtime & <> Public),
                                                                                "Payroll Ledger Entry No." = FIELD("Entry No."),
                                                                                Reseted = CONST(false),
                                                                                Entitled = CONST(false),
                                                                                "Cause of Absence Code" = CONST('LATENESS')));
            Description = 'MB.0406';
            FieldClass = FlowField;
        }
        field(80247; "Early Attendance (Hours)"; Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE("Employee No." = FIELD("Employee No."),
                                                                                Type = CONST('ABSENCE'),
                                                                                Processed = CONST(true),
                                                                                "Affect Work Days" = CONST(true),
                                                                                "Document Status" = CONST(Approved),
                                                                                Converted = CONST(false),
                                                                                "Unit of Measure Code" = CONST('HOUR'),
                                                                                "Associate Pay Element" = CONST(false),
                                                                                "Payroll Ledger Entry No." = FIELD("Entry No."),
                                                                                "Absence Transaction Type" = FILTER(<> Overtime & <> Public),
                                                                                Reseted = CONST(false),
                                                                                Entitled = CONST(false),
                                                                                "Cause of Absence Code" = CONST('EDA')));
            Description = 'MB.0406';
            FieldClass = FlowField;
        }
        field(80248; "Late/ Early Hours Pay"; Decimal)
        {
            Description = 'MB.2306';
        }
        field(80249; "Income Tax Retro"; Decimal)
        {
            Description = 'EDM.IT';
        }
        field(80250; "Income Tax"; Decimal)
        {
            Description = 'EDM.IT';
        }
        field(80251; "Family Allowance Retroactive"; Decimal)
        {
            Description = 'EDM.IT';
        }
        field(80252; "Exemt Tax Retroactive"; Decimal)
        {
            Description = 'EDM.IT';
        }
        field(80258; "Posting Group"; Code[30])
        {
            CalcFormula = Lookup(Employee."Posting Group" WHERE("No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80259; "Working Days"; Decimal)
        {
        }
        field(80260; "Payment Category"; Option)
        {
            OptionMembers = " ",Supplement;
        }
        field(80261; "Total Salary for NSSF"; Decimal)
        {
        }
        field(80262; Bonus; Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = CONST('18')));
            Description = '18';
            FieldClass = FlowField;
        }
        field(80263; Transportation; Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = CONST('02')));
            Description = '02';
            FieldClass = FlowField;
        }
        field(80264; "Variabe Transportation"; Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = CONST('13')));
            Description = '13';
            FieldClass = FlowField;
        }
        field(80265; "School Allowance"; Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = CONST('25')));
            Description = '25';
            FieldClass = FlowField;
        }
        field(80266; "Medical  motherhood"; Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = CONST('86')));
            Description = '86';
            FieldClass = FlowField;
        }
        field(80267; "Employee Related To"; Code[20])
        {
            CalcFormula = Lookup(Employee."Related to" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
            TableRelation = Employee."No.";
        }
        field(80268; "Employee Manager No"; Code[20])
        {
            CalcFormula = Max(Employee."Manager No." WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80269; Location; Code[10])
        {
            CalcFormula = Lookup(Employee.Location WHERE("No." = FIELD("Employee No.")));
            Caption = 'Employee Location';
            FieldClass = FlowField;
        }
        field(80270; Department; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200),
                                                                                   "No." = FIELD("Employee No."),
                                                                                   "Dimension Code" = CONST('DEPARTMENT')));
            Caption = 'Employee Department';
            FieldClass = FlowField;
        }
        field(80271; Division; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200),
                                                                                   "No." = FIELD("Employee No."),
                                                                                   "Dimension Code" = CONST('DIVISION')));
            Caption = 'Employee Division';
            FieldClass = FlowField;
        }
        field(80272; Branch; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200),
                                                                                   "No." = FIELD("Employee No."),
                                                                                   "Dimension Code" = CONST('BRANCH')));
            Caption = 'Employee Branch';
            FieldClass = FlowField;
        }
        field(80273; "Employee Type"; Option)
        {
            CalcFormula = Lookup(Employee."Employee Type" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
            OptionCaption = 'Non declared – Engineers,Probation period,Employees,Contractual (labors 3%)';
            OptionMembers = "Non declared – Engineers","Probation period",Employees,"Contractual (labors 3%)";
        }
        field(80274; "Sub Payroll Code"; Code[20])
        {
        }
        field(80275; "Emp Transfer Bank Name"; Text[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Emp Transfer Bank Name" WHERE("Employee No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80276; "Emp Transfer Bank Name (ACY)"; Text[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Emp Transfer Bank Name (ACY)" WHERE("Employee No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80277; "Emp Bank Acc Name"; Text[100])
        {
            CalcFormula = Lookup(Employee."Emp. Bank Acc Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80278; "Job Description"; Text[150])
        {
            CalcFormula = Lookup("HR Information".Description WHERE(Code = FIELD("Job Title"), "Table Name" = FILTER("Job Title")));
            FieldClass = FlowField;
        }
        field(80279; "Business Unit"; Code[10])
        {
            CalcFormula = Lookup(Employee."Business Unit" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(80280; "Emp Transfer Bank Branch"; Text[50])
        {
            CalcFormula = Lookup(Employee."Emp Transfer Bank Branch" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80281; "Bank Branch"; Text[30])
        {
            CalcFormula = Lookup(Employee."Bank Branch" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80282; "Emp. Bank Acc Arabic Name"; Text[50])
        {
            CalcFormula = Lookup(Employee."Emp. Bank Acc Arabic Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80283; "Full Name"; Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        Field(80284; "Address"; Text[100])
        {
            CalcFormula = Lookup(Employee."Address" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80285; Floor; Code[10])
        {
            CalcFormula = Lookup(Employee."Floor" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80286; Building; Text[30])
        {
            CalcFormula = Lookup(Employee."Building" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80287; "Bank No"; Code[20])
        {
            CalcFormula = Lookup(Employee."Bank No." WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80288; "Bank No (ACY)"; Code[20])
        {
            CalcFormula = Lookup(Employee."Bank No. (ACY)" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80289; "IBAN No"; Text[100])
        {
            CalcFormula = Lookup("Employee"."IBAN No." WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80290; "Total Net Pay"; Decimal)
        {
            CalcFormula = SUM("Payroll Ledger Entry"."Net Pay" WHERE("Employee No." = FIELD("Employee No."),
                                                                      "Payroll Date" = FIELD("Payroll Date"),
                                                                      "Payment Category" = field("Payment Category")));
            FieldClass = FlowField;
        }
        field(80291; "Total Addition"; Decimal)
        {
            CalcFormula = SUM("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                         "Payroll Date" = FIELD("Payroll Date"),
                                                                         "Payment Category" = field("Payment Category"),
                                                                         Type = Filter(Addition)));
            FieldClass = FlowField;
        }
        field(80292; "Total Deduction"; Decimal)
        {
            CalcFormula = SUM("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                         "Payroll Date" = FIELD("Payroll Date"),
                                                                         "Payment Category" = field("Payment Category"),
                                                                         Type = Filter(Deduction)));
            FieldClass = FlowField;
        }
        field(80293; "Paid EOS"; Boolean)
        {
        }
        field(80294; "Manual Transportation"; Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = Filter('045'),
                                                                              Declared = filter(Declared)));
            FieldClass = FlowField;
        }
        field(80295; "Salary Absence Deduction"; Decimal)
        {
            CalcFormula = Lookup("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = Filter('010'),
                                                                              Declared = filter(Declared)));
            FieldClass = FlowField;
        }
        field(80296; "Family Allowance Retro Add"; Decimal)
        {
            CalcFormula = sum("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = Filter('021' | '047'),
                                                                              Declared = filter(Declared)));
            FieldClass = FlowField;
        }
        field(80297; "Family Allowance Retro Ded"; Decimal)
        {
            CalcFormula = sum("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = Filter('022'),
                                                                              Declared = filter(Declared)));
            FieldClass = FlowField;
        }
        field(80298; NSSF; Decimal)
        {
            CalcFormula = sum("Pay Detail Line"."Calculated Amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                              "Payroll Date" = FIELD("Payroll Date"),
                                                                              "Pay Element Code" = Filter('032'),
                                                                              Declared = filter(Declared)));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Employee No.", Open)
        {
        }
        key(Key3; "Employee No.", "Current Year", Open)
        {
            SumIndexFields = "Gross Pay", "Taxable Pay", "Net Pay", "Tax Paid", "Net Pay (ACY)", "Employee Pension", "Employer Pension", "Gross Pay (ACY)";
        }
        key(Key4; "Document No.", "Posting Date", "Payroll Date")
        {
        }
        key(Key5; "Payroll Group Code", "Current Year", "Pay Frequency", Period)
        {
        }
        key(Key6; "Employee No.", "Document No.")
        {
        }
        key(Key7; "Payroll Group Code", "Pay Frequency", "Current Year")
        {
        }
        key(Key8; "Employee No.", "Posting Date", "Period Start Date", "Period End Date")
        {
        }
        key(Key9; "Payroll Group Code", "Pay Frequency", "Shortcut Dimension 1 Code", "Employee No.", "Current Year")
        {
        }
        key(Key10; "Payroll Group Code", "Pay Frequency", "Shortcut Dimension 1 Code", Open, "Posting Date")
        {
        }
        key(Key11; "Payroll Group Code", "Pay Frequency", "Shortcut Dimension 1 Code", "Payment Method", "Employee No.", Open)
        {
        }
        key(Key12; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Employee No.", "Posting Date", "Payroll Date")
        {
        }
        key(Key13; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "First Name", "Posting Date", "Payroll Date")
        {
        }
        key(Key14; "Tax Year", "Posting Date", "Employee No.")
        {
        }
        key(Key15; "First Name")
        {
        }
        key(Key16; "Payment Method")
        {
        }
        key(Key17; "Employee No.", "Tax Year", "Period End Date", Open)
        {
            SumIndexFields = "Employee Pension", "Employer Pension", "Taxable Pay", "Employer EOSIND", "Employer Family Subscription", "Employer Motherhood";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Document No." = 'STARTUP' then begin
            PayLedgEntry.RESET;
            PayLedgEntry.SETCURRENTKEY("Employee No.", Open);
            PayLedgEntry.SETRANGE("Employee No.", "Employee No.");
            PayLedgEntry.SETRANGE(Open, false);
            PayLedgEntry.SETFILTER("Document No.", '<>%1', 'STARTUP');
            if PayLedgEntry.FIND('-') then
                ERROR('You cannot delete Startup Information if an employee has been paid.');
        end;
        IF NOT Open THEN
            ERROR('Closed payroll Ledgers can not be deleted');
    end;

    trigger OnInsert();
    begin
        //MAA+
        //IF PayLedgEntry."Payment Method"=PayLedgEntry."Payment Method"::Cash THEN BEGIN
        //ISBank:=TRUE;
        //END;
    end;

    var
        PayLedgEntry: Record "Payroll Ledger Entry";
}

