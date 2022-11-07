table 98063 "Employee Salary History"
{
    // version EDM.HRPY1

    LookupPageID = "Salary Raise Request";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate();
            begin
                if ("Source Type" = "Source Type"::"Raise Request") and ("Change Status" = "Change Status"::"Not Started") then begin
                    EmpAddInfoTbt.Get("Employee No.");
                    EmpTbt.RESET;
                    CLEAR(EmpTbt);
                    EmpTbt.SETRANGE("No.", "Employee No.");
                    if EmpTbt.FINDFIRST then begin
                        "Basic Previous" := EmpTbt."Basic Pay";
                        "Phone Previous" := EmpTbt."Phone Allowance";
                        "Car Previous" := EmpTbt."Car Allowance";
                        "Cost of Living Previous" := EmpTbt."Cost of Living";
                        "House Previous" := EmpTbt."House Allowance";
                        "Ticket Previous" := EmpTbt."Ticket Allowance";
                        "Food Previous" := EmpTbt."Food Allowance";
                        "Other Previous" := EmpTbt."Other Allowances";
                        "Extra Salary Previous" := EmpAddInfoTbt."Extra Salary";//20181220:A2+
                        "Basic Pay" := EmpTbt."Basic Pay";
                        "Phone Allowance" := EmpTbt."Phone Allowance";
                        "Car Allowance" := EmpTbt."Car Allowance";
                        "Cost of Living" := EmpTbt."Cost of Living";
                        "House Allowance" := EmpTbt."House Allowance";
                        "Ticket Allowance" := EmpTbt."Ticket Allowance";
                        "Food Allowance" := EmpTbt."Food Allowance";
                        "Other Allowance" := EmpTbt."Other Allowances";
                        "Extra Salary" := EmpAddInfoTbt."Extra Salary";//20181220:A2+
                    end;
                    "Change Status" := "Change Status"::"Not Started";
                    "Source Type" := "Source Type"::"Raise Request";
                    "Requested By" := USERID;
                    "Requested Date" := WORKDATE;
                    "Modified Date" := WORKDATE;
                    "Modified Time" := SYSTEM.TIME;
                    "Modified By" := USERID;
                    //RENAME( "Request ID","Employee No.","Modified Date","Modified Time");

                    EmpTbt.RESET;
                    CLEAR(EmpTbt);
                    EmpTbt.SETRANGE("Related to", "Employee No.");
                    EmpTbt.SETFILTER(EmpTbt."No.", '<>%1', "Employee No.");
                    if EmpTbt.FINDFIRST then begin
                        "Basic Pay Rel" := EmpTbt."Basic Pay";
                        "Phone Rel" := EmpTbt."Phone Allowance";
                        "Car Rel" := EmpTbt."Car Allowance";
                        "Cost of Living Rel" := EmpTbt."Cost of Living";
                        "House Rel" := EmpTbt."House Allowance";
                        "Ticket Rel" := EmpTbt."Ticket Allowance";
                        "Food Rel" := EmpTbt."Food Allowance";
                        "Other Rel" := EmpTbt."Other Allowances";
                        "Extra Salary Related" := EmpAddInfoTbt."Extra Salary";//20181221:A2+-

                        "Basic Pay Rel Previous" := EmpTbt."Basic Pay";
                        "Phone Rel Previous" := EmpTbt."Phone Allowance";
                        "Car Rel Previous" := EmpTbt."Car Allowance";
                        "Cost of Living Rel Previous" := EmpTbt."Cost of Living";
                        "House Rel Previous" := EmpTbt."House Allowance";
                        "Ticket Rel Previous" := EmpTbt."Ticket Allowance";
                        "Food Rel Previous" := EmpTbt."Food Allowance";
                        "Other Rel Previous" := EmpTbt."Other Allowances";
                        "Extra Salary Rel Previous" := EmpAddInfoTbt."Extra Salary";//20181221:A2+- 
                    end;
                    "Bonus System" := EmpAddInfoTbt."Bonus System";
                end;
            end;
        }
        field(2; "Modified Date"; Date)
        {
        }
        field(3; "Modified Time"; Time)
        {
        }
        field(4; "Source Type"; Option)
        {
            OptionCaption = 'Auto-Save,Raise Request,Salary Change';
            OptionMembers = "Auto-Save","Raise Request","Salary Change";
        }
        field(5; "Basic Pay"; Decimal)
        {
            trigger OnValidate();
            var
                HumanResSetup: Record "Human Resources Setup";
                BasicPay: Decimal;
            begin
                //2017-06-21 SC+
                if "Amount In USD" then
                    BasicPay := PayrollFunctions.ExchangeACYAmountToLCY("Basic Pay")
                else
                    BasicPay := "Basic Pay";
                HumanResSetup.GET;
                if (BasicPay <> 0) and (BasicPay < HumanResSetup."Minimum Salary") then
                    ERROR('Salary Should be Greater than : %1 ', HumanResSetup."Minimum Salary");
                //2017-06-21 SC-
                // 08.03.2017 : A2+
                "Hourly Rate" := GetDefaultHourlyRate();
                // 08.03.2017 : A2-
            end;
        }
        field(6; "Phone Allowance"; Decimal)
        {
        }
        field(7; "Car Allowance"; Decimal)
        {
        }
        field(8; "House Allowance"; Decimal)
        {
        }
        field(9; "Food Allowance"; Decimal)
        {
        }
        field(10; "Ticket Allowance"; Decimal)
        {
        }
        field(11; "Other Allowance"; Decimal)
        {
        }
        field(12; "TotalPay&Allow"; Decimal)
        {
        }
        field(13; Location; Code[10])
        {
            CalcFormula = Lookup(Employee.Location WHERE("No." = FIELD("Employee No.")));
            Editable = true;
            FieldClass = FlowField;
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST(Location));
        }
        field(14; "Basic Previous"; Decimal)
        {
        }
        field(15; "Phone Previous"; Decimal)
        {
        }
        field(16; "Car Previous"; Decimal)
        {
        }
        field(17; "House Previous"; Decimal)
        {
        }
        field(18; "Food Previous"; Decimal)
        {
        }
        field(19; "Ticket Previous"; Decimal)
        {
        }
        field(20; "Other Previous"; Decimal)
        {
        }
        field(21; "Modified By"; Code[50])
        {
        }
        field(22; "Change Status"; Option)
        {
            OptionCaption = 'Approved,Pending,Rejected,Not Started';
            OptionMembers = Approved,Pending,Rejected,"Not Started";

            trigger OnValidate();
            var
                WorkingHrsPerMonth: Decimal;
                HourlyRateval: Decimal;
                WorkingHrsPerDay: Decimal;
                DailyRateVal: Decimal;
                HRSetup: Record "Human Resources Setup";
            begin
                HRSetup.FINDFIRST;
                if not HRSetup."Auto Apply Salary Raise" then
                    case "Change Status" of
                        "Change Status"::Approved:
                            begin
                                if not "Hourly Rate Or Not" then begin
                                    WorkingHrsPerMonth := PayrollFunctions.GetEmployeeMonthlyHours("Employee No.", '');
                                    if WorkingHrsPerMonth <= 0 then
                                        HourlyRateval := 0
                                    else
                                        HourlyRateval := ROUND(("Basic Pay" + "Basic Pay Rel") / WorkingHrsPerMonth, 0.01);
                                    "Hourly Rate" := HourlyRateval;
                                end else
                                    HourlyRateval := "Hourly Rate";

                                WorkingHrsPerDay := PayrollFunctions.GetEmployeeDailyHours("Employee No.", '');
                                if WorkingHrsPerDay <= 0 then
                                    DailyRateVal := 0
                                else
                                    DailyRateVal := ROUND(("Basic Pay" + "Basic Pay Rel") / WorkingHrsPerDay, 0.01);

                                if "Amount In USD" then begin
                                    HourlyRateval := ExchEquivAmountInLCY(HourlyRateval);
                                    DailyRateVal := ExchEquivAmountInLCY(DailyRateVal);
                                end;

                                if (EmployeeRec.GET("Employee No.")) and ("Source Type" = "Source Type"::"Raise Request") then begin
                                    if not "Amount In USD" then begin
                                        EmployeeRec.VALIDATE(EmployeeRec."Basic Pay", "Basic Pay");
                                        EmployeeRec.VALIDATE(EmployeeRec."Phone Allowance", "Phone Allowance");
                                        EmployeeRec.VALIDATE(EmployeeRec."Car Allowance", "Car Allowance");
                                        EmployeeRec.VALIDATE(EmployeeRec."Cost of Living", "Cost of Living");
                                        EmployeeRec.VALIDATE(EmployeeRec."Food Allowance", "Food Allowance");
                                        EmployeeRec.VALIDATE(EmployeeRec."Ticket Allowance", "Ticket Allowance");
                                        EmployeeRec.VALIDATE(EmployeeRec."House Allowance", "House Allowance");
                                        EmployeeRec.VALIDATE(EmployeeRec."Other Allowances", "Other Allowance");
                                    end else begin
                                        EmployeeRec.VALIDATE(EmployeeRec."Basic Pay", ExchEquivAmountInLCY("Basic Pay"));
                                        EmployeeRec.VALIDATE(EmployeeRec."Phone Allowance", ExchEquivAmountInLCY("Phone Allowance"));
                                        EmployeeRec.VALIDATE(EmployeeRec."Car Allowance", ExchEquivAmountInLCY("Car Allowance"));
                                        EmployeeRec.VALIDATE(EmployeeRec."Cost of Living", ExchEquivAmountInLCY("Cost of Living"));
                                        EmployeeRec.VALIDATE(EmployeeRec."Food Allowance", ExchEquivAmountInLCY("Food Allowance"));
                                        EmployeeRec.VALIDATE(EmployeeRec."Ticket Allowance", ExchEquivAmountInLCY("Ticket Allowance"));
                                        EmployeeRec.VALIDATE(EmployeeRec."House Allowance", ExchEquivAmountInLCY("House Allowance"));
                                        EmployeeRec.VALIDATE(EmployeeRec."Other Allowances", ExchEquivAmountInLCY("Other Allowance"));
                                    end;

                                    EmployeeRec.VALIDATE(EmployeeRec."Hourly Rate", HourlyRateval);
                                    EmployeeRec.VALIDATE(EmployeeRec."Daily Rate", DailyRateVal);
                                    EmployeeRec.MODIFY(true);

                                    EmpAddInfoTbt.SETRANGE(EmpAddInfoTbt."Employee No.", "Employee No.");
                                    if not EmpAddInfoTbt.FINDFIRST then begin
                                        EmpAddInfoTbt.INIT;
                                        EmpAddInfoTbt."Employee No." := "Employee No.";
                                        EmpAddInfoTbt."Bonus System" := "Bonus System";
                                        EmpAddInfoTbt."Extra Salary" := "Extra Salary";//20181221:A2+-
                                        EmpAddInfoTbt.INSERT;
                                    end else begin
                                        EmpAddInfoTbt."Bonus System" := "Bonus System";
                                        EmpAddInfoTbt."Extra Salary" := "Extra Salary";//20181221:A2+-
                                        EmpAddInfoTbt.MODIFY;
                                    end;

                                    EmployeeRelatedRec.SETRANGE("Related to", EmployeeRec."No.");
                                    EmployeeRelatedRec.SETFILTER(EmployeeRelatedRec."No.", '<>%1', EmployeeRec."No.");
                                    if EmployeeRelatedRec.FINDFIRST then begin
                                        EmpAddInfoTbt.RESET;
                                        CLEAR(EmpTbt);
                                        EmpAddInfoTbt.SETRANGE(EmpAddInfoTbt."Employee No.", EmployeeRelatedRec."No.");
                                        if not EmpAddInfoTbt.FINDFIRST then begin
                                            EmpAddInfoTbt.INIT;
                                            EmpAddInfoTbt."Employee No." := EmployeeRelatedRec."No.";
                                            EmpAddInfoTbt."Bonus System" := "Bonus System";
                                            EmpAddInfoTbt."Extra Salary" := "Extra Salary";//20181221:A2+-
                                            EmpAddInfoTbt.INSERT;
                                        end else begin
                                            EmpAddInfoTbt."Bonus System" := "Bonus System";
                                            EmpAddInfoTbt."Extra Salary" := "Extra Salary";//20181221:A2+-
                                            EmpAddInfoTbt.MODIFY;
                                        end;

                                        if not "Amount In USD" then begin
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Basic Pay", "Basic Pay Rel");
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Phone Allowance", "Phone Rel");
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Car Allowance", "Car Rel");
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Cost of Living", "Cost of Living Rel");
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Food Allowance", "Food Rel");
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Ticket Allowance", "Ticket Rel");
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."House Allowance", "House Rel");
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Other Allowances", "Other Rel");
                                        end else begin
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Basic Pay", ExchEquivAmountInLCY("Basic Pay Rel"));
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Phone Allowance", ExchEquivAmountInLCY("Phone Rel"));
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Car Allowance", ExchEquivAmountInLCY("Car Rel"));
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Cost of Living", ExchEquivAmountInLCY("Cost of Living Rel"));
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Food Allowance", ExchEquivAmountInLCY("Food Rel"));
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Ticket Allowance", ExchEquivAmountInLCY("Ticket Rel"));
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."House Allowance", ExchEquivAmountInLCY("House Rel"));
                                            EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Other Allowances", ExchEquivAmountInLCY("Other Rel"));
                                        end;

                                        EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Hourly Rate", HourlyRateval);
                                        EmployeeRelatedRec.VALIDATE(EmployeeRelatedRec."Daily Rate", DailyRateVal);
                                        EmployeeRelatedRec.MODIFY(true);
                                    end;
                                end;
                                Processed := true;
                            end;
                    end;
            end;
        }
        field(23; "Employee Name"; Text[200])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(24; "Total Previous"; Decimal)
        {
        }
        field(25; "Insurence Previous"; Decimal)
        {
        }
        field(26; "Insurence Contribution"; Decimal)
        {
        }
        field(27; "Requested Date"; Date)
        {
        }
        field(28; "Request Description"; Text[100])
        {
        }
        field(29; "Request Attachment"; Text[3])
        {
        }
        field(30; "Bonus System"; Code[10])
        {
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST("Bonus System"));
        }
        field(31; "Bonus System Previous"; Code[10])
        {
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST("Bonus System"));
        }
        field(32; "Requested By"; Code[50])
        {
        }
        field(33; "Approved Date"; Date)
        {
        }
        field(34; "Approved By"; Code[50])
        {
        }
        field(35; "Approval Comments"; Text[50])
        {
        }
        field(36; "Request ID"; Integer)
        {
            AutoIncrement = true;
        }
        field(37; "Salary Start Date"; Date)
        {
        }
        field(38; "Basic Pay Rel"; Decimal)
        {

            trigger OnValidate();
            begin
                "Hourly Rate" := GetDefaultHourlyRate();
            end;
        }
        field(39; "Phone Rel"; Decimal)
        {
        }
        field(40; "Car Rel"; Decimal)
        {
        }
        field(41; "House Rel"; Decimal)
        {
        }
        field(42; "Food Rel"; Decimal)
        {
        }
        field(43; "Ticket Rel"; Decimal)
        {
        }
        field(44; "Other Rel"; Decimal)
        {
        }
        field(45; "Amount In USD"; Boolean)
        {
        }
        field(46; "Basic Pay Rel Previous"; Decimal)
        {
        }
        field(47; "Phone Rel Previous"; Decimal)
        {
        }
        field(48; "Car Rel Previous"; Decimal)
        {
        }
        field(49; "House Rel Previous"; Decimal)
        {
        }
        field(50; "Food Rel Previous"; Decimal)
        {
        }
        field(51; "Ticket Rel Previous"; Decimal)
        {
        }
        field(52; "Other Rel Previous"; Decimal)
        {
        }
        field(53; "Employee Type"; Option)
        {
            CalcFormula = Lookup(Employee."Employee Type" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
            OptionCaption = 'Non declared – Engineers,Probation period,Employees,Contractual (labors 3%)';
            OptionMembers = "Non declared – Engineers","Probation period",Employees,"Contractual (labors 3%)";
        }
        field(54; "Hourly Rate Or Not"; Boolean)
        {

            trigger OnValidate();
            begin
                "Basic Pay" := 0;
                "Basic Pay Rel" := 0;
                "Hourly Rate" := GetDefaultHourlyRate();
            end;
        }
        field(55; "Hourly Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                "Basic Pay" := GetCalculatedBasicSalary("Hourly Rate");
            end;
        }
        field(56; "Job Title"; Code[50])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(57; "Employment Date"; Date)
        {
            CalcFormula = Lookup(Employee."Employment Date" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(58; "Employee Category Code"; Code[10])
        {
            CalcFormula = Lookup(Employee."Employee Category Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(59; "Job Position Code"; Code[50])
        {
            CalcFormula = Lookup(Employee."Job Position Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(60; "Employment Type Code"; Code[20])
        {
            CalcFormula = Lookup(Employee."Employment Type Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(61; Declared; Option)
        {
            CalcFormula = Lookup(Employee.Declared WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
            OptionMembers = " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        }
        field(62; "Posting Group"; Code[10])
        {
            CalcFormula = Lookup(Employee."Posting Group" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(63; "Payroll Group Code"; Code[10])
        {
            CalcFormula = Lookup(Employee."Payroll Group Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(64; "Job Categroy"; Code[10])
        {
            CalcFormula = Lookup(Employee."Job Category" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(66; "Last Comment"; Text[30])
        {
            CalcFormula = Lookup(Employee."No." WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(67; Processed; Boolean)
        {
            Description = 'EDM: to tell if it is applied by the system';
        }
        field(68; "Extra Salary"; Decimal)
        {
        }
        field(69; "Extra Salary Previous"; Decimal)
        {
        }
        field(70; "Extra Salary Related"; Decimal)
        {
        }
        field(71; "Extra Salary Rel Previous"; Decimal)
        {
        }
        field(72; "Cost of Living"; Decimal)
        {
        }
        field(73; "Cost of Living Rel"; Decimal)
        {
        }
        field(74; "Cost of Living Previous"; Decimal)
        {
        }
        field(75; "Cost of Living Rel Previous"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Request ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin

        if ("Change Status" = "Change Status"::Approved) or ("Change Status" = "Change Status"::Rejected) then
            ERROR('You cannot delete this record');

        if "Change Status" = "Change Status"::Pending then begin
            ApprovalEntryRec.SETRANGE("Record ID to Approve", RECORDID);
            ApprovalEntryRec.SETRANGE(Status, ApprovalEntryRec.Status::Open);
            if ApprovalEntryRec.FINDFIRST then
                ApprovalEntryRec.DELETEALL;
        end;
    end;

    trigger OnModify();
    begin
        "Modified By" := USERID;
        "Modified Date" := WORKDATE;
        "Modified Time" := SYSTEM.TIME;
    end;

    var
        EmployeeRec: Record Employee;
        EmpAddInfoTbt: Record "Employee Additional Info";
        EmpTbt: Record Employee;
        CurrentSalary: Decimal;
        AddEmployeeNo: Code[20];
        EmployeeRelatedRec: Record Employee;
        PayrollFunctions: Codeunit "Payroll Functions";
        ApprovalEntryRec: Record "Approval Entry";
        WorkingHrsPerMonth: Decimal;

    procedure UpdateCurrentSalary();
    begin
    end;

    local procedure ExchEquivAmountInACY(L_AmoountInLCY: Decimal) L_AmouontInACY: Decimal;
    begin
        L_AmouontInACY := PayrollFunctions.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
    end;

    local procedure ExchEquivAmountInLCY(L_AmoountInACY: Decimal) L_AmouontInACY: Decimal;
    begin
        L_AmouontInACY := PayrollFunctions.ExchangeACYAmountToLCY(L_AmoountInACY);
        exit(L_AmouontInACY);
    end;

    procedure GetSalaryRaiseReqyestStatus() RaiseTVal: Text;
    var
        RID: Integer;
    begin
        RID := GetLastSalaryRequesID(Rec."Employee No.");
        if RID > 0 then begin
            if RID = Rec."Request ID" then begin
                exit('Current Salary');
            end
            else begin
                if Rec."Change Status" = Rec."Change Status"::Approved then
                    exit('Previous');
            end;
        end;


        if "Change Status" = "Change Status"::Approved then
            RaiseTVal := 'Previous'

        else
            if (("Change Status" = "Change Status"::"Not Started") and ("Salary Start Date" > SYSTEM.TODAY)) then
                RaiseTVal := 'Raise Request' //'Schedule Raise Request'
            else
                if "Change Status" = "Change Status"::Rejected then
                    RaiseTVal := 'Canceled'
                else
                    if "Change Status" = "Change Status"::Pending then
                        RaiseTVal := 'Raise Request'
                    else
                        RaiseTVal := 'Raise Request';
    end;

    local procedure GetLastSalaryRequesID(EmpNo: Code[20]) LID: Integer;
    var
        SalHistoryTbt: Record "Employee Salary History";
    begin
        SalHistoryTbt.SETCURRENTKEY("Employee No.", "Approved Date", "Salary Start Date");
        SalHistoryTbt.SETRANGE(SalHistoryTbt."Employee No.", EmpNo);
        SalHistoryTbt.SETRANGE(SalHistoryTbt."Change Status", SalHistoryTbt."Change Status"::Approved);
        //SalHistoryTbt.SETfilter(salhistorytbt."Approved Date" ,'<>%1',0D);
        if SalHistoryTbt.FINDLAST() then
            exit(SalHistoryTbt."Request ID");

        exit(0);
    end;

    local procedure GetDefaultHourlyRate() V: Decimal;
    var
        WorkingHrsPerMonth: Decimal;
        HRSetup: Record "Human Resources Setup";
    begin
        WorkingHrsPerMonth := PayrollFunctions.GetEmployeeMonthlyHours("Employee No.", '');
        if WorkingHrsPerMonth <= 0 then
            V := 0
        else
            V := ROUND(("Basic Pay" + "Basic Pay Rel") / WorkingHrsPerMonth, 0.01);
        exit(V);
    end;

    local procedure GetCalculatedBasicSalary(HourRate: Decimal) V: Decimal;
    var
        WorkingHrsPerMonth: Decimal;
        HRSetup: Record "Human Resources Setup";
    begin
        WorkingHrsPerMonth := PayrollFunctions.GetEmployeeMonthlyHours("Employee No.", '');

        V := ROUND(HourRate * WorkingHrsPerMonth, 0.01);
        exit(V);
    end;

    procedure GetLastComment() LastComment: Text[80];
    var
        ApprovalCommentLine: Record "Approval Comment Line";
    begin
        ApprovalCommentLine.RESET;
        ApprovalCommentLine.SETRANGE("Table ID", 80232);
        ApprovalCommentLine.SETRANGE("Record ID to Approve", RECORDID);
        if ApprovalCommentLine.FINDLAST then
            LastComment := ApprovalCommentLine.Comment;
        exit(LastComment);
    end;
}

