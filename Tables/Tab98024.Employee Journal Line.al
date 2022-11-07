table 98024 "Employee Journal Line"
{
    DrillDownPageID = "Employee Journal Line List";
    LookupPageID = "Employee Journal Line List";
    Permissions = TableData "HR System Code" = rimd;

    fields
    {
        field(1; "Transaction Type"; Code[20])
        {
            Editable = true;
            TableRelation = "HR Transaction Types".Code WHERE(System = CONST(false));
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Entry No."; Integer)
        {
        }
        field(6; "Employee Status"; Option)
        {
            OptionMembers = Active,Inactive,Terminated;
        }
        field(7; "Document Status"; Option)
        {
            Editable = true;
            OptionMembers = Opened,Released,Approved;
        }
        field(8; "Opened By"; Code[50])
        {
            Editable = false;
        }
        field(9; "Opened Date"; Date)
        {
            Editable = false;
        }
        field(10; "Released By"; Code[50])
        {
            Editable = false;
        }
        field(11; "Released Date"; Date)
        {
            Editable = false;
        }
        field(12; "Approved By"; Code[50])
        {
            Editable = false;
        }
        field(13; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(14; "Starting Date"; Date)
        {

            trigger OnValidate();
            begin
                VALIDATE(Value);
            end;
        }
        field(15; Currency; Code[10])
        {
            TableRelation = Currency;
        }
        field(16; Description; Text[50])
        {
        }
        field(17; "More Information"; Text[50])
        {
        }
        field(18; Value; Decimal)
        {
            trigger OnValidate();
            begin
                NoofNonWD := 0;
                HumanResSetup.GET;
                Employee.GET("Employee No.");
                Employee.TESTFIELD("Employment Type Code");
                EmploymentType.GET(Employee."Employment Type Code");
                "Rounding Addition" := 0;
                if TransactionTypes.GET("Transaction Type") then begin
                    case TransactionTypes.Type of
                        'ABSENCE':
                            begin
                                if not Converted then begin
                                    CauseofAbsence.GET("Cause of Absence Code");
                                    if ("Starting Date" <> 0D) and ("Ending Date" <> 0D) and ("Unit of Measure Code" = 'DAY') then begin
                                        IF ("From Time" <> 0T) AND ("To Time" <> 0T) THEN
                                            Value := HRFunctions.GetHoursFrom2Times("From Time", "To Time")
                                        else begin
                                            Value := "Ending Date" - "Starting Date" + 1;
                                            if "Absence Transaction Type" <> "Absence Transaction Type"::Overtime then begin
                                                "Rounding Addition" := HRFunctions.GetRoundingAddition(EmploymentType."Base Calendar Code",
                                                                                                        "Starting Date", "Ending Date");
                                                CauseofAbsence.GET("Cause of Absence Code");
                                                Value := (ABS(Value) - NoofNonWD);
                                            end;
                                        end;
                                    end;
                                    if ("Starting Date" <> 0D) and ("Unit of Measure Code" = 'DAY') then begin
                                        IF ("Cause of Absence Code" = '0.25AL') OR ("Cause of Absence Code" = '0.25SKD') then
                                            Value := 0.5;
                                        IF ("Cause of Absence Code" = '0.5AL') OR ("Cause of Absence Code" = '0.5SKD') then
                                            Value := 0.5;
                                        IF ("Cause of Absence Code" = '0.75AL') OR ("Cause of Absence Code" = '0.75SKD') then
                                            Value := 0.5;
                                    end;
                                    IF ("From Time" <> 0T) AND ("To Time" <> 0T) AND ("Starting Date" <> 0D) AND ("Ending Date" <> 0D) AND
                                       ("Unit of Measure Code" = 'HOUR') then begin
                                        Value := HRFunctions.GetHoursFrom2Times("From Time", "To Time");
                                        Minutes := (("Ending Date" - "Starting Date") * 1440) + (Value * 60);
                                        Value := (Minutes / 60);
                                    end;
                                    "Calculated Value" := Value;
                                    if Value <> 0 then begin
                                        if CauseofAbsence."Working Day Multiplier" <> 0 then
                                            "Calculated Value" := "Calculated Value" * CauseofAbsence."Working Day Multiplier";
                                        if CauseofAbsence."Unpaid Hours" <> 0 then begin
                                            "Calculated Value" := "Calculated Value" - CauseofAbsence."Unpaid Hours";
                                            if "Calculated Value" <= 0 then
                                                "Calculated Value" := 0;
                                        end;
                                    end;
                                end;
                                "Day-Off" := false;
                                if "Starting Date" = "Ending Date" then begin

                                    NoofNonWD := HRFunctions.GetNonAttendance(EmploymentType."Base Calendar Code", "Starting Date", "Ending Date");
                                    //Modified becuase it is causing conflict if the employee has worked in a Calendar Holiday Day (Always set as day-off) +  
                                    //if (NoofNonWD = 1) or (CauseofAbsence."Transaction Type" = CauseofAbsence."Transaction Type"::"Day-Off") then
                                    if (CauseofAbsence."Transaction Type" = CauseofAbsence."Transaction Type"::"Day-Off") then
                                        //Modified becuase it is causing conflict if the employee has worked in a Calendar Holiday Day (Always set as day-off) -
                                        "Day-Off" := true;
                                end;
                                if (HumanResSetup."Payroll in Use") and ("Starting Date" <> 0D) and ("Ending Date" <> 0D) then
                                    PayStatus.GET(Employee."Payroll Group Code", Employee."Pay Frequency");
                            end; // absence
                        'BENEFIT':
                            begin
                                ValidateBenefit();
                                if not IsPermitted then
                                    ERROR('Operation Aborted !');
                                "Calculated Value" := Value;
                            end;
                    end;
                end;
            end;
        }
        field(19; "Exam Date"; Date)
        {
        }
        field(21; "Absence Phone No."; Text[30])
        {
        }
        field(22; "Absence Address"; Text[30])
        {
        }
        field(23; "Transaction Date"; Date)
        {
            Editable = true;
        }
        field(26; "Medical Allowance Group"; Code[10])
        {
        }
        field(27; "Medical Exams Count"; Integer)
        {
            CalcFormula = Count("Employee Medical Details" WHERE("Employee No." = FIELD("Employee No."), "Entry No." = FIELD("Entry No."), "Transaction Date" = FIELD("Transaction Date"), "Medical Allowance Group" = FIELD("Medical Allowance Group"), "Medical Allowance Sub Group" = FIELD("Medical Sub Group Filter")));
            FieldClass = FlowField;
        }
        field(28; "Medical Sub Group Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Medical Allowance Sub Groups".Code;
        }
        field(29; "Cause of Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence";

            trigger OnValidate();
            begin
                if (CauseofAbsence.GET("Cause of Absence Code")) and ("Employee No." <> '') then begin
                    "Unit of Measure Code" := CauseofAbsence."Unit of Measure Code";
                    CauseofAbsence.CALCFIELDS(Entitled);
                end;
                "Starting Date" := 0D;
                "Ending Date" := 0D;
                if "Unit of Measure Code" = 'HOUR' then begin
                    "Starting Date" := TODAY;
                    "Ending Date" := TODAY;
                end;
            end;
        }
        field(30; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(32; "Ending Date"; Date)
        {

            trigger OnValidate();
            begin
                if "Ending Date" < "Starting Date" then
                    ERROR('Ending date must be greater than Starting date');

                if Type = 'ABSENCE' then begin
                    IF ("Unit of Measure Code" = 'HOUR') OR (("Unit of Measure Code" = 'DAY') AND (("From Time" <> 0T) OR ("To Time" <> 0T))) THEN
                        if "Ending Date" - "Starting Date" <> 0 then
                            ERROR('Starting Date must be equal to Ending Date');
                end;
                VALIDATE(Value);
            end;
        }
        field(33; "Training No."; Code[10])
        {
            TableRelation = Training."Performance Code" WHERE("Table Name" = CONST("Training"), "No." = FIELD("Performance Code"));
        }
        field(34; "Evaluation Rate"; Decimal)
        {
        }
        field(35; "From Time"; Time)
        {

            trigger OnValidate();
            begin
                VALIDATE(Value);
            end;
        }
        field(36; "To Time"; Time)
        {

            trigger OnValidate();
            begin
                VALIDATE(Value);
            end;
        }
        field(37; "Unit of Measure Code"; Code[10])
        {
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(38; Type; Code[30])
        {
            TableRelation = "HR System Code";
        }
        field(39; "Job Position Code"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Position"));
        }
        field(40; "Old Employee Status"; Option)
        {
            OptionMembers = Active,Inactive,Terminated;
        }
        field(41; "Old Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(42; "Old Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(43; "Old Job Position Code"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Position"));
        }
        field(45; "Performance Code"; Code[10])
        {
            TableRelation = "HR Performance";
        }
        field(46; "Old Employment Type"; Code[20])
        {
            TableRelation = "Employment Type";
        }
        field(47; "Employment Type Code"; Code[20])
        {
            TableRelation = "Employment Type";
        }
        field(48; Converted; Boolean)
        {
        }
        field(50; "Affect Work Days"; Boolean)
        {
        }
        field(51; "Affect Attendance Days"; Boolean)
        {
        }
        field(52; "Absence Transaction Type"; Option)
        {
            OptionMembers = " ",Holiday,Public,Maternity,Overtime,Starters,Leavers,Salary,Vacation,Lateness,"Day-Off","Late-Arrive";
        }
        field(53; "Associate Pay Element"; Boolean)
        {
        }
        field(56; Processed; Boolean)
        {
        }
        field(57; "Husband Paralysed"; Boolean)
        {
        }
        field(58; "Spouse Secured"; Boolean)
        {
        }
        field(59; "No of Children"; Integer)
        {
        }
        field(60; "Old No of Children"; Integer)
        {
        }
        field(61; "Social Status"; Option)
        {
            OptionMembers = Single,Married,Widow,Divorced,Separated;
        }
        field(62; "Old Social Status"; Option)
        {
            OptionMembers = Single,Married,Widow,Divorced,Separated;
        }
        field(64; "Calculated Value"; Decimal)
        {
            Editable = true;
        }
        field(65; "Old Basic Pay"; Decimal)
        {
        }
        field(66; "Old Additional Salary"; Decimal)
        {
        }
        field(67; "Basic Pay"; Decimal)
        {
        }
        field(68; "Additional Salary"; Decimal)
        {
        }
        field(69; Entitled; Boolean)
        {
        }
        field(70; Reseted; Boolean)
        {
        }
        field(71; "Entitled Value"; Decimal)
        {
        }
        field(72; "Reseted Value"; Decimal)
        {
        }
        field(73; "Converted Value"; Decimal)
        {
        }
        field(74; "Processed Date"; Date)
        {
        }
        field(75; "Unpaid Period"; Boolean)
        {
        }
        field(76; "Payroll Ledger Entry No."; Integer)
        {
        }
        field(77; "Day-Off"; Boolean)
        {
        }
        field(78; "Old Declared"; Option)
        {
            OptionMembers = " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        }
        field(79; "Old Foreigner"; Option)
        {
            OptionMembers = " ","End of Service","Not End of Service";
        }
        field(80; "Old Employee Category Code"; Code[10])
        {
            TableRelation = "Employee Categories";
        }
        field(81; Declared; Option)
        {
            OptionMembers = " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        }
        field(82; Foreigner; Option)
        {
            OptionMembers = " ","End of Service","Not End of Service";
        }
        field(83; "Employee Category Code"; Code[10])
        {
            TableRelation = "Employee Categories";
        }
        field(84; "Employment Date"; Date)
        {
        }
        field(85; "Old Employment Date"; Date)
        {
        }
        field(86; "Job Title Code"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Title"));
        }
        field(87; "Old Job Title Code"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Title"));
        }
        field(88; "Swap No."; Integer)
        {
            Description = 'SHR2.0';
        }
        field(89; "Swap Employee No."; Code[20])
        {
            Description = 'SHR2.0';
            TableRelation = Employee."No.";
        }
        field(90; "Swap From Date"; Date)
        {
            Description = 'SHR2.0';
        }
        field(91; "Swap To Date"; Date)
        {
            Description = 'SHR2.0';
        }
        field(92; "Swap From Working Shift Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Employment Type Schedule"."Working Shift Code" WHERE("Table Name" = CONST("WorkShiftSched"));
        }
        field(93; "Swap To Working Shift Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Employment Type Schedule"."Working Shift Code" WHERE("Table Name" = CONST("WorkShiftSched"));
        }
        field(94; "Swap From Shift Group Code"; Code[50])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("ShiftGp"));
        }
        field(95; "Swap To Shift Group Code"; Code[50])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("ShiftGp"));
        }
        field(96; "Pension Scheme No."; Code[10])
        {
            Description = 'PY2.0';
            TableRelation = "Pension Scheme";
        }
        field(97; "Salary Increase % / Amount"; Decimal)
        {
            Description = 'SHR2.0';
        }
        field(98; "Salary Increase Policy Date"; Date)
        {
            Description = 'SHR2.0';
        }
        field(99; "Salary Type"; Option)
        {
            Description = 'SHR2.0';
            OptionMembers = " ",Preset,Increase;
        }
        field(100; "Relative Code"; Code[10])
        {
            Description = 'SHR2.0';
        }
        field(101; Split; Boolean)
        {
            CalcFormula = Lookup("HR System Code".Split WHERE(Code = FIELD(Type)));
            FieldClass = FlowField;
        }
        field(102; "Payroll Group Code"; Code[10])
        {
            Description = 'PY2.0';
            TableRelation = "HR Payroll Group";
        }
        field(103; "Pay Frequency"; Option)
        {
            Description = 'PY2.0';
            OptionMembers = Monthly,Weekly;
        }
        field(104; "Room Type"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Performance"."No." WHERE("Table Name" = CONST("Room Type"));
        }
        field(105; "Room No."; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = Training."Performance Code" WHERE("Table Name" = CONST("Room"), "No." = FIELD("Room Type"));
        }
        field(106; "Exit Room"; Boolean)
        {
            Description = 'SHR2.0';
        }
        field(107; "Company Organization No."; Code[20])
        {
            Description = 'SHR2.0';
            TableRelation = "Company Organization";
        }
        field(108; "Old Company Organization No."; Code[20])
        {
            Description = 'SHR2.0';
            TableRelation = "Company Organization";
        }
        field(109; "Insurance Code"; Code[10])
        {
            Description = 'SHR2.0';
        }
        field(110; Reversed; Boolean)
        {
            Description = 'SHR2.0';
        }
        field(111; "Reversed Entry No."; Integer)
        {
            BlankNumbers = BlankZero;
            BlankZero = true;
            Description = 'SHR2.0';
        }
        field(112; "Swap To Shortcut Dim 1 Code"; Code[20])
        {
            Description = 'SHR2.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(113; "Swap To Shortcut Dim 2 Code"; Code[20])
        {
            Description = 'SHR2.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(114; "Swap To Base Calendar Code"; Code[10])
        {
            Description = 'SHR2.0';
        }
        field(115; "Base Calendar Code"; Code[10])
        {
            Description = 'SHR2.0';
        }
        field(116; "WTR Entry No."; Integer)
        {
            Description = 'SHR2.0';
        }
        field(80001; "Rounding of Calculated Value"; Decimal)
        {
            Description = 'PY4.1';
        }
        field(80002; "Rounding Addition"; Decimal)
        {
        }
        field(80003; "System Insert"; Boolean)
        {
        }
        field(80004; "Supplement Period"; Boolean)
        {
        }
        field(80005; "Accumulate Overtime To AL"; Boolean)
        {
        }
        field(80006; Recurring; Boolean)
        {
        }
        field(80007; "Recurring Copied"; Boolean)
        {
        }
        field(80008; "Absence Code Type"; Option)
        {
            OptionCaption = 'Unpaid Vacation,Paid Vacation,Sick Day,No Duty,Signal Absence,Holiday,Working Day,Working Holiday,Subtraction,Work Accident,Paid Day,AL';
            OptionMembers = "Unpaid Vacation","Paid Vacation","Sick Day","No Duty","Signal Absence",Holiday,"Working Day","Working Holiday",Subtraction,"Work Accident","Paid Day",AL;
            FieldClass = FlowField;
            CalcFormula = Max("Daily Shifts".Type WHERE("Cause Code" = FIELD("Cause of Absence Code")));
        }
        field(80009; "Attendance Hours"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Employee Absence"."Attend Hrs." WHERE("Employee No." = FIELD("Employee No."), "From Date" = FIELD("Starting Date")));
        }
        field(80010; "Employee Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Full Name" where("No." = Field("Employee No.")));
        }
        field(80011; "Month 13"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Entry No.")
        {
        }
        key(Key2; "Employee No.", "Transaction Date", "Medical Allowance Group", "Document Status", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Entry No.")
        {
            SumIndexFields = Value;
        }
        key(Key3; "Employee No.", "Cause of Absence Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Document Status", "Ending Date", "Affect Work Days", "Affect Attendance Days", Value, "Starting Date")
        {
            SumIndexFields = Value;
        }
        key(Key4; "Training No.", "Document Status")
        {
            SumIndexFields = "Evaluation Rate";
        }
        key(Key5; "Employee No.", "Type", "Processed", "Document Status", "Ending Date", "Affect Work Days", "Affect Attendance Days", "Absence Transaction Type", "Unit of Measure Code", "Associate Pay Element", "Transaction Date", "Starting Date", "Day-Off", "Cause of Absence Code", "Payroll Ledger Entry No.")
        {
            SumIndexFields = Value, "Calculated Value", "Converted Value", "Rounding of Calculated Value";
        }
        key(Key6; "Payroll Ledger Entry No.")
        {
        }
        key(Key7; "Employee No.", "Transaction Date", "Entry No.")
        {
        }
        key(Key8; Type, "Swap No.")
        {
        }
        key(Key9; Type, "Room Type", "Room No.", "Document Status", "Exit Room")
        {
        }
        key(Key10; "Employee No.", "Document Status", "Transaction Type", Processed, "Transaction Date")
        {
            SumIndexFields = Value, "Calculated Value", "Converted Value", "Rounding of Calculated Value";
        }
        key(Key11; "Employee No.", "Document Status", "Transaction Type", Processed, "Transaction Date", "Supplement Period")
        {
            SumIndexFields = Value, "Calculated Value", "Converted Value", "Rounding of Calculated Value";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if ("Document Status" = "Document Status"::Approved) and ("Entitled Value" > 0) then
            ERROR('Record Could Not Be Deleted.');
        EmpMedicalDetails.SETRANGE("Employee No.", "Employee No.");
        EmpMedicalDetails.SETRANGE("Entry No.", "Entry No.");
        EmpMedicalDetails.DELETEALL;
        IF UserSetup.GET(USERID) THEN begin
            IF NOT UserSetup."Allow Modify Payroll Ledger" THEN
                IsEmpJnlPeriodClosed(Rec."Employee No.", Rec."Transaction Date", Rec.Processed);
        end;
    end;

    trigger OnInsert();
    begin
        if ("Employee No." = '') or (not Employee.GET("Employee No.")) then
            ERROR('Employee Not Found : %1.', "Employee No.");
        HumanResSetup.GET;
        if "Transaction Date" = 0D then
            "Transaction Date" := WORKDATE;
        if not Entitled then
            HRFunctions.ChkTrxDateValidity(Employee, "Transaction Date");
        "Employee Status" := Employee.Status;
        "Job Position Code" := Employee."Job Position Code";
        "Employment Type Code" := Employee."Employment Type Code";
        HRTransactionTypes.GET("Transaction Type");
        if not HRTransactionTypes.System then
            IF "Employee Status" <> "Employee Status"::Active THEN
                ERROR('Operation Rejected : Employee %1 is not Active', "Employee No.");
        "Basic Pay" := Employee."Basic Pay";
        "Additional Salary" := Employee."Salary (ACY)";
        if Type = 'ABSENCE' then begin
            if ("Document Status" = "Document Status"::Opened) and (Value = 0) then
                ERROR('Cause of Absence Value must be greater than Zero !');
            GetAbsRelatedInfo;
        end;
        GetNewEntryNo();
        if "Document Status" = "Document Status"::Opened then begin
            TransactionTypes.GET("Transaction Type");
            ValidatePermissions('Open');
            case TransactionTypes.Type of
                'ABSENCE':
                    ValidateAbsence();
                'BENEFIT':
                    ValidateBenefit();
            end;
            if IsPermitted = false then
                ERROR('Operation Aborted !');
        end;
        "Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
        HRFunctions.DefaultDimToDocumentDim("Employee No.", "Entry No.", '', '');
        "Opened By" := USERID;
        "Opened Date" := TODAY;
        if "Rounding Addition" > 0 then
            "Rounding of Calculated Value" := "Calculated Value" + "Rounding Addition"
        else
            "Rounding of Calculated Value" := ROUND("Calculated Value", 1, '<');
        RoundingAddition := 0;
        IF UserSetup.GET(USERID) THEN begin
            IF NOT UserSetup."Allow Modify Payroll Ledger" THEN
                IsEmpJnlPeriodClosed(Rec."Employee No.", Rec."Transaction Date", Rec.Processed);
        end;
    end;

    trigger OnModify();
    begin
        if Type = 'ABSENCE' then begin
            if ("Document Status" = "Document Status"::Opened) and (Value = 0) then
                ERROR('Cause of Absence Value must be greater than Zero !');
            if "Cause of Absence Code" <> xRec."Cause of Absence Code" then
                GetAbsRelatedInfo;
        end;
        if "Rounding Addition" > 0 then
            "Rounding of Calculated Value" := "Calculated Value" + "Rounding Addition"
        else
            "Rounding of Calculated Value" := ROUND("Calculated Value", 1, '<');
        RoundingAddition := 0;
        IF UserSetup.GET(USERID) THEN begin
            IF NOT UserSetup."Allow Modify Payroll Ledger" THEN
                IsEmpJnlPeriodClosed(Rec."Employee No.", Rec."Transaction Date", Rec.Processed);
        end;
    end;

    trigger OnRename();
    begin
        if HRTransactionTypes.GET("Transaction Type") then begin
            if (not HRTransactionTypes.System) or
              (HRTransactionTypes.Type = 'ABSENCE') or (HRTransactionTypes.Type = 'TRAINING') then
                if (("Document Status" = "Document Status"::Released) or ("Document Status" = "Document Status"::Approved)) then
                    ERROR('Released or Approved Documents Cannot by Modified !');
        end;
    end;

    var
        MaxLineNo: Integer;
        UserSetup: Record "User Setup";
        EmployeeJournals: Record "Employee Journal Line";
        TransactionTypes: Record "HR Transaction Types";
        Employee: Record Employee;
        CauseofAbsence: Record "Cause of Absence";
        Minutes: Decimal;
        HumanResSetup: Record "Human Resources Setup";
        EmployeeAbsenceEntitle: Record "Employee Absence Entitlement";
        VExist: Boolean;
        Balance: Decimal;
        HRPermissions: Record "HR Permissions";
        IsPermitted: Boolean;
        NoofNonWD: Decimal;
        HRFunctions: Codeunit "Human Resource Functions";
        HRTransactionTypes: Record "HR Transaction Types";
        EmploymentType: Record "Employment Type";
        EmpMedicalDetails: Record "Employee Medical Details";
        PayStatus: Record "Payroll Status";
        Window: Dialog;
        RoundingAddition: Decimal;
        Payrollfunctions: Codeunit "Payroll Functions";

    procedure Release_Document();
    begin
        TransactionTypes.GET("Transaction Type");
        ValidatePermissions('Release');
        case TransactionTypes.Type of
            'ABSENCE':
                ValidateAbsence();
            'BENEFIT':
                ValidateBenefit();
        end;
        if IsPermitted = true then begin
            "Released By" := USERID;
            "Released Date" := TODAY;
            "Document Status" := "Document Status"::Released;
            MODIFY;
        end;
    end;

    procedure Approve_Document();
    begin
        TransactionTypes.GET("Transaction Type");
        ValidatePermissions('Approve');
        case TransactionTypes.Type of
            'ABSENCE':
                ValidateAbsence();
            'BENEFIT':
                ValidateBenefit();
        end;
        if IsPermitted = true then begin
            "Approved By" := USERID;
            "Approved Date" := TODAY;
            "Document Status" := "Document Status"::Approved;
            MODIFY;
        end;
    end;

    procedure ReOpen_Document();
    begin
        TransactionTypes.GET("Transaction Type");
        ValidatePermissions('ReOpen');
        if ("Document Status" = "Document Status"::Opened) or (Converted) or (Entitled) or (Reseted) or (Processed) or ("Entitled Value" > 0) then
            exit;
        "Document Status" := "Document Status"::Opened;
        MODIFY;
    end;

    procedure ValidateAbsence();
    begin
        IsPermitted := true;
        TESTFIELD("Cause of Absence Code");
        if ("Unit of Measure Code" = 'DAY') or ("Unit of Measure Code" = 'HOUR') then begin
            TESTFIELD("Starting Date");
            TESTFIELD("Ending Date");
        end;
        if "Unit of Measure Code" = 'HOUR' then begin
            TESTFIELD("From Time");
            TESTFIELD("To Time");
        end;
        VExist := false;
        EmployeeJournals.RESET;
        EmployeeJournals.SETRANGE("Employee No.", Rec."Employee No.");
        EmployeeJournals.SETRANGE(EmployeeJournals."Transaction Type", "Transaction Type");
        EmployeeJournals.SETRANGE(EmployeeJournals."Cause of Absence Code", "Cause of Absence Code");
        if EmployeeJournals.FIND('-') then
            repeat
                if EmployeeJournals."Entry No." <> "Entry No." then begin
                    if ((EmployeeJournals."Starting Date" >= "Starting Date") and
                      (EmployeeJournals."Starting Date" <= "Ending Date")) or
                      ((EmployeeJournals."Ending Date" >= "Starting Date") and
                      (EmployeeJournals."Ending Date" <= "Ending Date")) or
                      ((EmployeeJournals."Starting Date" < "Starting Date") and
                      (EmployeeJournals."Ending Date" > "Ending Date")) then
                        VExist := true;
                end; // <> current entry
            until (EmployeeJournals.NEXT = 0) or VExist;
        if VExist then
            ERROR('Selected Period Overlap with existing Employee Absence Periods : %1\' +
                    'Starting Date = %2 and Ending Date = %3', "Employee No.", "Starting Date", "Ending Date");
        Balance := 0;
        if EmployeeAbsenceEntitle.GET("Employee No.", "Cause of Absence Code") then begin
            Balance := Payrollfunctions.GetEmpAbsenceEntitlementCurrentBalance("Employee No.", "Cause of Absence Code", "Transaction Date");
            if (Balance - Value) < 0 then begin
                if not CONFIRM('Allowed Absence Days Exceeded. Max Allowed = %1. Do you Wish to Continue ?', true, Balance) then begin
                    IsPermitted := false;
                    exit;
                end;
            end;
        end; //chk limit
    end;

    procedure ValidateBenefit();
    begin
        IsPermitted := true;
        if "Medical Allowance Group" <> '' then begin
            TESTFIELD("Medical Allowance Group");
            VExist := false;
            EmployeeJournals.RESET;
            EmployeeJournals.SETRANGE("Employee No.", Rec."Employee No.");
            EmployeeJournals.SETRANGE(EmployeeJournals."Transaction Type", "Transaction Type");
            EmployeeJournals.SETRANGE("Medical Allowance Group", Rec."Medical Allowance Group");
            if EmployeeJournals.FIND('-') then
                repeat
                    if EmployeeJournals."Entry No." <> "Entry No." then
                        if ((EmployeeJournals."Starting Date" >= "Starting Date") and
                            (EmployeeJournals."Starting Date" <= "Ending Date")) or
                            ((EmployeeJournals."Ending Date" >= "Starting Date") and
                            (EmployeeJournals."Ending Date" <= "Ending Date")) or
                            ((EmployeeJournals."Starting Date" < "Starting Date") and
                            (EmployeeJournals."Ending Date" > "Ending Date")) then begin

                            VExist := true;
                        end;
                until (EmployeeJournals.NEXT = 0) or VExist;
            if VExist then
                ERROR('Selected Period Overlap with existing Employee Medical Group Periods ! ');
            Balance := 0;
            VExist := false;
        end;
    end;

    procedure ValidatePermissions(P_Type: Text[30]);
    var
        TrxType: Code[30];
    begin
        IsPermitted := false;
        HRPermissions.SETRANGE("User ID", USERID);
        if HRPermissions.FIND('-') then
            repeat
                case HRPermissions."Transaction Type" of
                    HRPermissions."Transaction Type"::ALL:
                        TrxType := 'ALL';
                    HRPermissions."Transaction Type"::Benefit:
                        TrxType := 'BENEFIT';
                    HRPermissions."Transaction Type"::Absence:
                        TrxType := 'ABSENCE';
                    HRPermissions."Transaction Type"::Training:
                        TrxType := 'TRAINING';
                end;
                if (HRPermissions."Transaction Type" = HRPermissions."Transaction Type"::ALL) then begin
                    if HRPermissions."Function" = 'ALL' then
                        IsPermitted := true
                    else begin
                        case P_Type of
                            'Open':
                                if HRPermissions."Function" = 'OPEN' then
                                    IsPermitted := true;
                            'Release':
                                if HRPermissions."Function" = 'RELEASE' then
                                    IsPermitted := true;
                            'Approve':
                                if HRPermissions."Function" = 'APPROVE' then
                                    IsPermitted := true;
                            'ReOpen':
                                if HRPermissions."Function" = 'REOPEN' then
                                    IsPermitted := true;
                        end; // end case fct1
                    end; // trx:all- fct:all/specific
                end
                else begin
                    if TrxType = TransactionTypes.Type then begin
                        if HRPermissions."Function" = 'ALL' then
                            IsPermitted := true
                    end
                    else begin
                        case P_Type of
                            'Open':
                                if HRPermissions."Function" = 'OPEN' then
                                    IsPermitted := true;
                            'Release':
                                if HRPermissions."Function" = 'RELEASE' then
                                    IsPermitted := true;
                            'Approve':
                                if HRPermissions."Function" = 'APPROVE' then
                                    IsPermitted := true;
                            'ReOpen':
                                if HRPermissions."Function" = 'REOPEN' then
                                    IsPermitted := true;
                        end;
                    end;
                end;
            until HRPermissions.NEXT = 0;

        if IsPermitted = false then
            ERROR('User Has no Permission To Execute This Operation !');
    end;

    procedure GetNewEntryNo();
    begin
        MaxLineNo := 0;
        EmployeeJournals.RESET;
        EmployeeJournals.SETRANGE("Employee No.", Rec."Employee No.");
        if EmployeeJournals.FIND('+') then
            MaxLineNo := EmployeeJournals."Entry No.";
        EmployeeJournals.RESET;
        "Entry No." := MaxLineNo + 1;
    end;

    procedure GetAbsRelatedInfo();
    var
        L_EmpAbsenceTbt: Record "Employee Absence";
        L_EmpAttended: Boolean;
    begin
        CauseofAbsence.GET("Cause of Absence Code");
        "Affect Work Days" := CauseofAbsence."Affect Work Days";
        //"Affect Attendance Days" := CauseofAbsence."Affect Attendance Days";
        //EDM+
        IF CauseofAbsence."Consider Punch" = FALSE THEN
            "Affect Attendance Days" := CauseofAbsence."Affect Attendance Days"
        ELSE BEGIN
            L_EmpAbsenceTbt.SETRANGE(L_EmpAbsenceTbt."Employee No.", "Employee No.");
            L_EmpAbsenceTbt.SETRANGE(L_EmpAbsenceTbt."From Date", "Starting Date");
            IF L_EmpAbsenceTbt.FINDFIRST = TRUE THEN
                IF L_EmpAbsenceTbt."Attend Hrs." > 0 THEN
                    L_EmpAttended := TRUE;
            IF L_EmpAttended = TRUE THEN
                "Affect Attendance Days" := FALSE
            ELSE
                "Affect Attendance Days" := TRUE;
        END;
        //EDM-
        "Absence Transaction Type" := CauseofAbsence."Transaction Type";
        if CauseofAbsence."Associated Pay Element" <> '' then
            "Associate Pay Element" := true;
        if CauseofAbsence."Unpaid Hours" <> 0 then
            "Unpaid Period" := true;
    end;

    local procedure IsEmpJnlPeriodClosed(EmpNo: Code[20]; TransDate: Date; Process: Boolean);
    var
        Employee: Record Employee;
        PayStatus: Record "Payroll Status";
    begin
        Employee.SETRANGE("No.", EmpNo);
        if Employee.FINDFIRST then begin
            PayStatus.SETRANGE("Payroll Group Code", Employee."Payroll Group Code");
            if PayStatus.FINDFIRST then begin
                if (TransDate > PayStatus."Payroll Date")
                    or (TransDate < DMY2DATE(1, DATE2DMY(PayStatus."Payroll Date", 2), DATE2DMY(PayStatus."Payroll Date", 3)))
                    or (Process) then
                    ERROR('Period already closed');
            end;
        end;
    end;
}