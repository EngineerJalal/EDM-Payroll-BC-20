tableextension 98011 "ExtEmployeeAbsence" extends "Employee Absence"
{
    fields
    {
        modify("From Date")
        {
            CaptionML = ENU = 'Attendance Date';
        }

        field(80000; Period; Date)
        {
        }
        field(80001; Type; Option)
        {
            OptionCaption = 'Unpaid Vacation,Paid Vacation,Sick Day,No Duty,Signal Absence,Holiday,Working Day,Working Holiday,Subtraction,Work Accident,Paid Day,AL';
            OptionMembers = "Unpaid Vacation","Paid Vacation","Sick Day","No Duty","Signal Absence",Holiday,"Working Day","Working Holiday",Subtraction,"Work Accident","Paid Day",AL;

            trigger OnValidate();
            var
                PayElement: Record "Pay Element";
            begin
                ValidateCause;
            end;
        }
        field(80002; "Shift Code"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";

            trigger OnValidate();
            begin
                DailyShift.GET("Shift Code");
                "From Time" := DailyShift."From Time";
                "To Time" := DailyShift."To Time";
                "Break" := DailyShift."Break";
                Tolerance := DailyShift.Tolerance;
                VALIDATE("Cause of Absence Code", DailyShift."Cause Code");
                VALIDATE(Type, DailyShift.Type);
                if ("Required Hrs" = 0) and ("Attend Hrs." > 0) then begin
                    if CONFIRM('Reset Related Info?', true) = true then begin
                        "Attend Hrs." := 0;
                        HandPunch.SETRANGE("Attendnace No.", "Attendance No.");
                        HandPunch.SETRANGE("Real Date", "From Date");
                        if HandPunch.FINDFIRST then
                            repeat
                                HandPunch.DELETE;
                            until HandPunch.NEXT = 0;
                    end;
                end;
                IF ("Shift Code" = '0.25AL') OR ("Shift Code" = '0.25AL*') OR ("Shift Code" = '0.25SKD') OR ("Shift Code" = '0.25SKD*') OR ("Shift Code" = '0.25SKL') OR ("Shift Code" = '0.25SKL*') then begin
                    Quantity := 0.25;
                    "Quantity (Base)" := 0.25;
                end;
                IF ("Shift Code" = '0.5AL') OR ("Shift Code" = '0.5AL*') OR ("Shift Code" = '0.5SKD') OR ("Shift Code" = '0.5SKD*') OR ("Shift Code" = '0.5SKL') OR ("Shift Code" = '0.5SKL*') then begin
                    Quantity := 0.5;
                    "Quantity (Base)" := 0.5;
                end;
                IF ("Shift Code" = '0.75AL') OR ("Shift Code" = '0.75AL*') OR ("Shift Code" = '0.75SKD') OR ("Shift Code" = '0.75SKD*') OR ("Shift Code" = '0.75SKL') OR ("Shift Code" = '0.75SKL*') then begin
                    Quantity := 0.75;
                    "Quantity (Base)" := 0.75;
                end;
                IF "Shift Code" = '0.5HOLIDAY' then begin
                    Quantity := 0.5;
                    "Quantity (Base)" := 0.5;
                end;
                IF (xRec."Shift Code" <> '') and (Rec."Shift Code" <> xRec."Shift Code") then begin
                    RefreshLeavesAttendance();
                    RefreshWeekendLeaveArrive();
                end;
            end;
        }
        field(80003; "From Time"; Time)
        {

            trigger OnValidate();
            begin
                ValidateCause;
            end;
        }
        field(80004; "To Time"; Time)
        {

            trigger OnValidate();
            begin
                ValidateCause;
            end;
        }
        field(80005; "Break"; Time)
        {
        }
        field(80006; Tolerance; Decimal)
        {
        }
        field(80007; "Required Hrs"; Decimal)
        {

            trigger OnValidate();
            begin
                if (STRPOS(UPPERCASE(Rec."Shift Code"), UPPERCASE('AL')) > 0) or (STRPOS(UPPERCASE(Rec."Shift Code"), UPPERCASE('CL')) > 0) or (STRPOS(UPPERCASE(Rec."Shift Code"), UPPERCASE('SKD')) > 0)
                or (STRPOS(UPPERCASE(Rec."Shift Code"), UPPERCASE('SKL')) > 0) then begin
                    if Rec."Attend Hrs." <> Rec."Required Hrs" then begin
                        HRSetup.GET;
                        IF HRSetup."Auto Reset leave Attend Hrs" THEN
                            Rec."Attend Hrs." := Rec."Required Hrs";
                    end;

                end;
            end;
        }
        field(80008; "Attend Hrs."; Decimal)
        {
            Description = 'Approved Attended Hrs';

            trigger OnValidate();
            begin
                /*if (STRPOS (UPPERCASE (Rec."Shift Code") ,UPPERCASE('AL')) > 0) or (STRPOS (UPPERCASE (Rec."Shift Code") ,UPPERCASE('CL')) > 0) or (STRPOS (UPPERCASE (Rec."Shift Code") ,UPPERCASE('SKD')) > 0)  then begin
                    if  Rec."Attend Hrs." <>  Rec."Required Hrs" then
                        Rec."Attend Hrs." :=  Rec."Required Hrs";
                end;*/
                IF (xRec."Attend Hrs." <> 0) and (xRec."Attend Hrs." <> Rec."Attend Hrs.") then begin
                    IF Rec."Attend Hrs." = Rec."Required Hrs" then begin
                        Rec."Late Arrive" := 0;
                        Rec."Actual Late Arrive" := 0;
                        Rec."Early Leave" := 0;
                        Rec."Actual Early Leave" := 0;
                        Rec."Early Arrive" := 0;
                        Rec."Actual Early Arrive" := 0;
                        Rec."Late Leave" := 0;
                        Rec."Actual Late Leave" := 0;
                    end;
                    RefreshWeekendLeaveArrive();
                    RefreshLeavesAttendance();
                    IF "Attend Hrs." > "Required Hrs" then begin
                        "Late Leave" := ("Attend Hrs." - "Required Hrs") * 60;
                        "Early Leave" := 0;
                        Rec.Modify;
                    end;
                    IF (xRec."Attend Hrs." > Rec."Attend Hrs.") and (Rec."Attend Hrs." < "Required Hrs") then begin
                        "Early Leave" := ("Required Hrs" - Rec."Attend Hrs.")*60;
                        "Late Leave" := 0;
                        Rec.Modify;
                    end;
                end;
            end;
        }
        field(80009; Closed; Boolean)
        {
        }
        field(80010; "Late Arrive"; Decimal)
        {
            Description = 'Approved Late Arrive';
        }
        field(80011; "Early Leave"; Decimal)
        {
            Description = 'Approved Early Leave';
        }
        field(80012; "Employment Type Code"; Code[20])
        {
            CalcFormula = Lookup(Employee."Employment Type Code" WHERE("No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Employment Type";
        }
        field(80013; "Day of the Week"; Option)
        {
            OptionMembers = Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday;
        }
        field(80014; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = true;
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(80015; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = true;
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(80016; "Early Arrive"; Decimal)
        {
            Description = 'Approved Early Arrive';
        }
        field(80017; "Late Leave"; Decimal)
        {
            Description = 'Approved Late Leave';
        }
        field(80018; "Invalid Log"; Boolean)
        {
        }
        field(80019; "Hand Punch Exist"; Boolean)
        {
            CalcFormula = Exist("Hand Punch" WHERE("Attendnace No." = FIELD("Attendance No."), "Scheduled Date" = FIELD("From Date")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup();
            var
                HRPermissions: Record "HR Permissions";
            begin
                HRPermissions.SETRANGE("User ID", USERID);
                if (HRPermissions.FINDFIRST) and (HRPermissions."Attendance Limited Access") then
                    ERROR('');
            end;
        }
        field(80020; "Attendance No."; Integer)
        {
        }
        field(80021; "Not Include in Transportation"; Boolean)
        {
        }
        field(80022; Remarks; Text[100])
        {
        }
        field(80023; "Actual Attend Hrs"; Decimal)
        {
            Description = 'Attend Hrs as per hand punch - Non editable';
        }
        field(80024; "Actual Late Arrive"; Decimal)
        {
            Description = 'Late Arrive as per hand punch - Non editable';
        }
        field(80025; "Actual Early Leave"; Decimal)
        {
            Description = 'Early Leave as per hand punch - Non editable';
        }
        field(80026; "Actual Early Arrive"; Decimal)
        {
            Description = 'Early Arrive as per hand punch - Non editable';
        }
        field(80027; "Actual Late Leave"; Decimal)
        {
            Description = 'Late Leave as per hand punch - Non editable';
        }
        field(80028; "Employee Name"; Text[100])
        {
            CalcFormula = Max(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80029; "Employee Category"; Code[10])
        {
            CalcFormula = Max(Employee."Employee Category Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80030; "Employment Type"; Code[20])
        {
            CalcFormula = Max(Employee."Employment Type Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80031; "Payroll Group"; Code[10])
        {
            CalcFormula = Max(Employee."Payroll Group Code" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80032; "Employee Manager No"; Code[20])
        {
            CalcFormula = Max(Employee."Manager No." WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80033; "Employee Dimension1"; Code[20])
        {
            CalcFormula = Max(Employee."Global Dimension 1 Code" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Global Dimension 1';
            FieldClass = FlowField;
        }
        field(80034; "Employee Dimension2"; Code[20])
        {
            CalcFormula = Max(Employee."Global Dimension 2 Code" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Global Dimension 2';
            FieldClass = FlowField;
        }
        field(80035; "Employee Status"; Option)
        {
            FieldClass = FlowField;
            OptionMembers = Active,Inactive,Terminated;
            CalcFormula = Max(Employee.Status WHERE("No." = FIELD("Employee No.")));
        }
        field(80036; "Web Attend HRs"; Decimal)
        {
        }
        field(80037; "Web Modify Date"; DateTime)
        {
        }
        field(80038; "Project Code"; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("Employee No."), "Dimension Code" = CONST('PROJECT')));
            Caption = 'Employee Project';
            FieldClass = FlowField;
        }
        field(80039; Location; Code[10])
        {
            CalcFormula = Lookup(Employee.Location WHERE("No." = FIELD("Employee No.")));
            Caption = 'Employee Location';
            FieldClass = FlowField;
        }
        field(80040; Department; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("Employee No."), "Dimension Code" = CONST('DEPARTMENT')));
            Caption = 'Employee Department';
            FieldClass = FlowField;
        }
        field(80041; "Job Category"; Code[10])
        {
            CalcFormula = Max(Employee."Job Category" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(80042; "Division Code"; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("Employee No."), "Dimension Code" = CONST('DIVISION')));
            Caption = 'Employee Division';
            FieldClass = FlowField;
        }
        field(80043; Branch; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("Employee No."), "Dimension Code" = CONST('BRANCH')));
            Caption = 'Employee Branch';
            FieldClass = FlowField;
        }
        field(80044; "ZOHO ID"; Text[3])
        {
            CalcFormula = Lookup("Employee Additional Info"."Zoho Id" WHERE("Employee No." = FIELD("Employee No.")));
            Description = 'Added for Employee Attendance View';
            FieldClass = FlowField;
        }
        field(80045; "Inserted By"; Code[50])
        {
        }
        field(80046; "Modified By"; Code[50])
        {
        }
        field(80047; "Portal Approval Hours"; Decimal)
        {
            CalcFormula = Lookup("Leave Request"."Hours Value" WHERE("Employee No." = FIELD("Employee No."), "From Date" = FIELD("From Date"), "Request Type" = FILTER("Overtime")));
            FieldClass = FlowField;
        }
        field(80048; "Portal Remarks"; Text[250])
        {
            CalcFormula = Lookup("Leave Request".Remark WHERE("Employee No." = FIELD("Employee No."), "From Date" = FIELD("From Date"), "Request Type" = FILTER("Overtime")));
            FieldClass = FlowField;
        }
        field(80049; "Attendance Sub Dimensions"; Boolean)
        {
            CalcFormula = Exist("Employees Attendance Dimension" WHERE("Employee No" = FIELD("Employee No."), "Attendance No" = FIELD("Attendance No."), Period = FIELD(Period), "Attendance Date" = FIELD("From Date")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup();
            begin
                OpenEmpAttendSubDimPage("Employee No.", "Attendance No.", Period, "From Date");
            end;
        }
    }
    procedure ValidateCause();
    var
        Employee: Record Employee;
    begin
        Employee.RESET;
        Employee.SETRANGE(Employee."No.", "Employee No.");
        IF Employee.FINDFIRST THEN
            CASE Type OF
                Type::"Unpaid Vacation":
                    BEGIN
                        VALIDATE("Required Hrs", 0);
                        Quantity := 1;
                    END;
                Type::Subtraction:
                    BEGIN
                        VALIDATE("Required Hrs", 0);
                        Quantity := 1;
                    END;
                Type::"Paid Vacation":
                    BEGIN
                        Quantity := 1;
                        VALIDATE("Required Hrs", CalcTime("From Time", "To Time"));
                    END;
                Type::"Sick Day":
                    BEGIN
                        VALIDATE("Required Hrs", CalcTime("From Time", "To Time"));
                        Quantity := 1;
                    END;
                Type::"Work Accident":
                    BEGIN
                        VALIDATE("Required Hrs", CalcTime("From Time", "To Time"));
                        Quantity := 1;
                    END;
                Type::"No Duty":
                    BEGIN
                        VALIDATE("Required Hrs", 0);
                        Quantity := 1;
                    END;
                Type::"Signal Absence":
                    BEGIN
                        VALIDATE("Required Hrs", 0);
                        Quantity := 1;
                    END;
                Type::Holiday:
                    BEGIN
                        VALIDATE("Required Hrs", 0);
                        Quantity := 1;
                    END;
                Type::"Working Day":
                    BEGIN
                        VALIDATE("Required Hrs", CalcTime("From Time", "To Time"));
                        Quantity := 1;
                    END;
                Type::"Working Holiday":
                    BEGIN
                        VALIDATE("Required Hrs", CalcTime("From Time", "To Time"));
                        Quantity := 1;
                    END;
            END;
    end;

    procedure CalcTime(ParFromTime: Time; ParToTime: Time) ReTQty: Decimal;
    begin
        IF ParFromTime = ParToTime THEN
            ReTQty := 0
        ELSE BEGIN
            IF (ParFromTime = 0T) AND (ParToTime = 0T) THEN
                EXIT;
            EVALUATE(VarBTime, '00:00:00');
            EVALUATE(VarETime, '23:59:59');
            IF ParFromTime < ParToTime THEN BEGIN
                ReTQty := (ParToTime - ParFromTime) / 3600000;
                IF ReTQty > 20 THEN
                    ReTQty := 24 - ReTQty;
            END
            ELSE BEGIN
                ReTQty := (VarETime - ParFromTime);
                ReTQty := ReTQty + (ParToTime - VarBTime);
                ReTQty := ReTQty / 3600000;

                IF ReTQty > 20 THEN
                    ReTQty := 24 - ReTQty;
            END;
        END;
    end;

    procedure OpenHandPunchPage(EmpNo: Code[20]; EmpAttendNo: Integer; AttendPeriod: Date; AttendDate: Date);
    var
        HandPunch: Record "Hand Punch";
        KyStr: Text;
        HandPunchList: Page "Hand Punch List";

    begin
        HandPunch.SETRANGE("Attendnace No.", EmpAttendNo);
        HandPunch.SETRANGE("Scheduled Date", AttendDate);
        //PAGE.RUNMODAL(PAGE::"Hand Punch List", HandPunch);
        HandPunchList.SetTableView(HandPunch);
        HandPunchList.RUN;

        KyStr := 'ACT-';
        IF PayrollFunctions.CanModifyAttendanceRecord("From Date", "Employee No.") THEN BEGIN
            IF CONFIRM('Update Attended Hours', TRUE) THEN
                KyStr := KyStr + 'ALL';

            PayrollFunctions.FixEmployeeDailyAttendanceHours(EmpNo, AttendPeriod, AttendDate, TRUE, KyStr);
        END;
    end;

    procedure OpenEmpAttendSubDimPage(EmpNo: Code[20]; EmpAttendNo: Integer; AttendPeriod: Date; AttendDate: Date);
    var
        KyStr: Text;
        L_AttendSubDim: Record "Employees Attendance Dimension";
        AttendHrs: Decimal;
        EmpAbs: Record "Employee Absence";
        EmployeesAttendanceDimension: Page "Employees Attendance Dimension";
    begin
        L_AttendSubDim.SETRANGE(L_AttendSubDim."Employee No", EmpNo);
        L_AttendSubDim.SETRANGE(L_AttendSubDim.Period, AttendPeriod);
        L_AttendSubDim.SETRANGE(L_AttendSubDim."Attendance No", EmpAttendNo);
        L_AttendSubDim.SETRANGE(L_AttendSubDim."Attendance Date", AttendDate);
        L_AttendSubDim.SetParameter(EmpNo, EmpAttendNo, AttendDate, AttendPeriod);
        EmployeesAttendanceDimension.SetTableView(L_AttendSubDim);
        EmployeesAttendanceDimension.RUN;
        //PAGE.RUNMODAL(PAGE::"Employees Attendance Dimension", L_AttendSubDim);

        IF PayrollFunctions.CanModifyAttendanceRecord("From Date", "Employee No.") THEN BEGIN
            IF CONFIRM('Update Attended Hours', FALSE) THEN BEGIN
                AttendHrs := 0;
                L_AttendSubDim.RESET;
                CLEAR(L_AttendSubDim);
                L_AttendSubDim.SETRANGE("Employee No", EmpNo);
                L_AttendSubDim.SETRANGE(Period, AttendPeriod);
                L_AttendSubDim.SETRANGE("Attendance No", EmpAttendNo);
                L_AttendSubDim.SETRANGE("Attendance Date", AttendDate);
                IF L_AttendSubDim.FINDFIRST THEN
                    REPEAT
                        AttendHrs += L_AttendSubDim."Attended Hrs";
                    UNTIL L_AttendSubDim.NEXT = 0;

                EmpAbs.SETRANGE("Employee No.", EmpNo);
                EmpAbs.SETRANGE("Attendance No.", EmpAttendNo);
                EmpAbs.SETRANGE(Period, AttendPeriod);
                EmpAbs.SETRANGE("From Date", AttendDate);
                IF EmpAbs.FINDFIRST THEN BEGIN
                    EmpAbs."Attend Hrs." := AttendHrs;
                    EmpAbs.MODIFY;
                END;
            END;
        END;
    end;

    local procedure RefreshWeekendLeaveArrive();
    var
        Emp: Record Employee;
        EmploymentTypeRec: Record "Employment Type";
        HRSetup: Record "Human Resources Setup";
    begin
        IF (Rec."Shift Code" = 'WEEKEND') OR (Rec."Shift Code" = 'WEEKEND*') OR (Rec."Shift Code" = 'LOCKDOWN') then begin
            Rec."Late Arrive" := 0;
            Rec."Actual Late Arrive" := 0;
            Rec."Early Leave" := 0;
            Rec."Actual Early Leave" := 0;
            if Emp.FINDFIRST then begin
                if Emp."Employment Type Code" <> '' then begin
                    EmploymentTypeRec.SETRANGE(EmploymentTypeRec.Code, Emp."Employment Type Code");
                    if EmploymentTypeRec.FINDFIRST then begin
                        if EmploymentTypeRec."Early Arrive Not Allowed" then begin
                            Rec."Early Arrive" := 0;
                            Rec."Actual Early Arrive" := 0;
                        end;
                    end;
                end;
            end;
        end;
        IF Rec."Shift Code" = 'HOLIDAY' then begin
            Rec."Late Arrive" := 0;
            Rec."Actual Late Arrive" := 0;
            Rec."Early Leave" := 0;
            Rec."Actual Early Leave" := 0;
            Rec."Late Leave" := Rec."Attend Hrs." * 60;
            IF Emp.GET("Employee No.") then begin
                if Emp."Employment Type Code" <> '' then begin
                    EmploymentTypeRec.SETRANGE(EmploymentTypeRec.Code, Emp."Employment Type Code");
                    if EmploymentTypeRec.FINDFIRST then begin
                        if EmploymentTypeRec."Early Arrive Not Allowed" then begin
                            Rec."Early Arrive" := 0;
                            Rec."Actual Early Arrive" := 0;
                        end;
                    end;
                end;
            end;
        end;
        HRSetup.Get;
        IF Rec."Shift Code" = HRSetup.Deduction then begin
            Rec."Late Arrive" := 0;
            Rec."Actual Late Arrive" := 0;
            Rec."Early Leave" := 0;
            Rec."Actual Early Leave" := 0;
            Rec."Late Leave" := 0;
            Rec."Early Arrive" := 0;
            Rec."Actual Early Arrive" := 0;
            Rec."Attend Hrs." := 0;
            Rec.Modify();
        end;
    end;

    local procedure RefreshLeavesAttendance();
    var
        Emp: Record Employee;
        EmploymentTypeRec: Record "Employment Type";
    begin
        IF (Rec."Shift Code" = '0.25AL') OR (Rec."Shift Code" = '0.5AL') OR (Rec."Shift Code" = '0.75AL') OR
           (Rec."Shift Code" = '0.25AL*') OR (Rec."Shift Code" = '0.5AL*') OR (Rec."Shift Code" = '0.75AL*') OR
           (Rec."Shift Code" = '0.25SKD') OR (Rec."Shift Code" = '0.5SKD') OR (Rec."Shift Code" = '0.75SKD') OR
           (Rec."Shift Code" = '0.25SKD*') OR (Rec."Shift Code" = '0.5SKD*') OR (Rec."Shift Code" = '0.75SKD*') OR
           (Rec."Shift Code" = '0.25SKL') OR (Rec."Shift Code" = '0.5SKL') OR (Rec."Shift Code" = '0.75SKL') OR
           (Rec."Shift Code" = '0.25SKL*') OR (Rec."Shift Code" = '0.5SKL*') OR (Rec."Shift Code" = '0.75SKL*') then begin
            Rec."Attend Hrs." := Rec."Required Hrs";
            Rec."Late Arrive" := 0;
            Rec."Actual Late Arrive" := 0;
            Rec."Early Leave" := 0;
            Rec."Actual Early Leave" := 0;
            if Emp.FINDFIRST then begin
                if Emp."Employment Type Code" <> '' then begin
                    EmploymentTypeRec.SETRANGE(EmploymentTypeRec.Code, Emp."Employment Type Code");
                    if EmploymentTypeRec.FINDFIRST then begin
                        if EmploymentTypeRec."Early Arrive Not Allowed" then begin
                            Rec."Early Arrive" := 0;
                            Rec."Actual Early Arrive" := 0;
                        end;
                    end;
                end;
            end;
        end;
    end;

    var
        DailyShift: Record "Daily Shifts";
        VarBTime: Time;
        VarETime: Time;
        PayrollFunctions: Codeunit "Payroll Functions";
        HandPunch: Record "Hand Punch";
        HRSetup: Record "Human Resources Setup";
        KyStr: Text;
}