codeunit 98008 "Human Resource Functions"
{
    // version SHR1.0,PY1.0,EDM.HRPY1

    // MEG01.0 --> MB.870 : - Add to Calendar a flag that says whether it is a ½ day or a full day,with
    //                        specific calculation of Transportation
    //             MB.871 : - Solve the problem of half day


    trigger OnRun();
    begin
    end;

    var
        Window: Dialog;
        AdditionValue: Decimal;
        BaseCalendarAddition: Record "Base Calendar Additions";
        FindAddition: Boolean;
        TotalAddition: Decimal;
        Window2: Dialog;
        HRTransTypes: Record "HR Transaction Types";
        Text000: Label 'Exporting';
        PayrollFunctions: Codeunit "Payroll Functions";

    procedure DefaultDimToDocumentDim(P_EmployeeNo: Code[20]; P_TransactionLine: Integer; P_DimCode: Code[20]; P_DimValue: Code[20]);
    var
        DefaultDimension: Record "Default Dimension";
    begin
        /*DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID",5200);
        DefaultDimension.SETRANGE("No.",P_EmployeeNo);
          IF DefaultDimension.FIND('-') THEN
          REPEAT
            DocumentDimension.INIT;
            DocumentDimension.VALIDATE("Table ID",80024);
            DocumentDimension.VALIDATE("Document No.",P_EmployeeNo);
            DocumentDimension."Line No." := P_TransactionLine;
            DocumentDimension.VALIDATE("Dimension Code",DefaultDimension."Dimension Code");
            DocumentDimension.VALIDATE("Dimension Value Code",DefaultDimension."Dimension Value Code");
            //DocumentDimension.VALIDATE("Dimension Value Code",DefaultDimension."Dimension Value Code");
            IF P_DimCode <> '' THEN
             IF NOT DocumentDimension.INSERT THEN DocumentDimension.MODIFY
            ELSE
             IF NOT DocumentDimension.INSERT(TRUE) THEN DocumentDimension.MODIFY(TRUE);
        
          UNTIL DefaultDimension.NEXT = 0; // default Dim
        
          IF P_DimCode <> '' THEN BEGIN
            DocumentDimension.SETRANGE("Table ID",80024);
            DocumentDimension.SETRANGE("Document No.",P_EmployeeNo);
            DocumentDimension.SETRANGE("Line No.",P_TransactionLine);
            DocumentDimension.SETRANGE("Dimension Code",P_DimCode);
            IF DocumentDimension.FIND('-') THEN BEGIN
              DocumentDimension."Dimension Value Code" := P_DimValue;
              DocumentDimension.MODIFY;
            END;
          END;
         */

    end;

    procedure NoofHours(T1: Time; T2: Time): Decimal;
    var
        Hours: Decimal;
    begin
        // This function calculates the no of hours passed between the 2 given times
        Hours := T2 - T1;
        Hours := Hours / 1000; // value in seconds
        Hours := Hours / 3600; // value in hours
        exit(Hours);
    end;

    procedure CalculateHour(StartTime: Time; Hours: Decimal): Time;
    var
        EndTime: Time;
        MsHours: Decimal;
    begin
        MsHours := Hours * 3600 * 1000;
        EndTime := StartTime + MsHours;
        exit(EndTime);
    end;

    procedure EmployeeFullName(Employee: Record Employee): Text[50];
    var
        Temp: Text[50];
    begin

        Temp := '';

        if Employee."First Name" <> '' then
            Temp := Temp + Employee."First Name";

        if Employee."Middle Name" <> '' then
            Temp := Temp + ' ' + Employee."Middle Name";

        if Employee."Last Name" <> '' then
            Temp := Temp + ' ' + Employee."Last Name";

        exit(Temp);
    end;

    procedure GetNonWD(P_BaseCalendarCode: Code[10]; P_StartingDate: Date; P_EndingDate: Date): Integer;
    var
        BaseCalendarChange: Record "Base Calendar Change N";
        EmploymentType: Record "Employment Type";
        LoopDate: Date;
        Day: Integer;
        NonWorkingDay: Boolean;
        NoofNonWD: Integer;
    begin
        NoofNonWD := 0;
        LoopDate := P_StartingDate;
        while LoopDate <= P_EndingDate do begin
            BaseCalendarChange.RESET;
            BaseCalendarChange.SETRANGE("Base Calendar Code", P_BaseCalendarCode);
            BaseCalendarChange.SETRANGE(Nonworking, true);
            NonWorkingDay := false;
            if BaseCalendarChange.FIND('-') then
                repeat
                    if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::"Weekly Recurring" then begin
                        Day := DATE2DWY(LoopDate, 1);
                        case Day of
                            1:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Monday then
                                    NonWorkingDay := true;
                            2:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Tuesday then
                                    NonWorkingDay := true;
                            3:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Wednesday then
                                    NonWorkingDay := true;
                            4:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Thursday then
                                    NonWorkingDay := true;
                            5:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Friday then
                                    NonWorkingDay := true;
                            6:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Saturday then
                                    NonWorkingDay := true;
                            7:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Sunday then
                                    NonWorkingDay := true;
                        end; //case
                    end else
                        if LoopDate = BaseCalendarChange.Date then
                            NonWorkingDay := true;
                until (BaseCalendarChange.NEXT = 0) or (NonWorkingDay = true); // find
            if NonWorkingDay then
                NoofNonWD := NoofNonWD + (1);
            LoopDate := LoopDate + 1;
        end; //while
        exit(NoofNonWD);
    end;

    procedure GetBasicPay(RateIndicator: Option Monthly,Annual,Weekly,Hourly; ReqSalCurCode: Code[10]; ReqSal: Decimal; PayFreq: Option Monthly,Weekly): Decimal;
    var
        GenLedgSetup: Record "General Ledger Setup";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        //NOT USED ANYMORE
        //get basic pay in LCY based on Pay Frequency
        GenLedgSetup.GET;
        if ReqSalCurCode = '' then
            ReqSalCurCode := GenLedgSetup."LCY Code";
        if ReqSalCurCode <> GenLedgSetup."LCY Code" then begin
            CurrExchRate.SETRANGE("Currency Code", ReqSalCurCode);
            if CurrExchRate.FIND('+') then
                ReqSal := ReqSal * (CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount");
        end;
        case PayFreq of
            PayFreq::Monthly:
                begin
                    case RateIndicator of
                        RateIndicator::Annual:
                            ReqSal := ReqSal / 12;
                        RateIndicator::Weekly:
                            ReqSal := ReqSal * 4;
                        RateIndicator::Hourly:
                            ReqSal := ReqSal * 8 * 30;
                    end; //end case rate ind
                end; //monthly
            PayFreq::Weekly:
                begin
                    case RateIndicator of
                        RateIndicator::Annual:
                            ReqSal := ReqSal / 52;
                        RateIndicator::Monthly:
                            ReqSal := ReqSal / 4;
                        RateIndicator::Hourly:
                            ReqSal := ReqSal * 8 * 7;
                    end; //end case rate ind
                end; // weekly
        end; // end case pay freq

        //ReqSal := ROUND(ReqSal,100,'=');
        exit(ReqSal);
    end;

    procedure InsertSystemCodes();
    var
        SysCode: Record "HR System Code";
        Loop: Integer;
    begin
        SysCode.DELETEALL;


        // Insert HR Trx.
        //nisrine
        Loop := 1;
        while Loop <= 29 do begin
            SysCode.INIT;
            case Loop of
                1:
                    SysCode.Code := 'Benefit';
                2:
                    SysCode.Code := 'Absence';
                3:
                    SysCode.Code := 'Training';
                4:
                    begin
                        SysCode.Code := 'Change Status';
                        SysCode."Affects Payroll" := true;
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                5:
                    begin
                        SysCode.Code := 'Change Global Dim1';
                        SysCode."Affects Payroll" := true;
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                6:
                    begin
                        SysCode.Code := 'Change Global Dim2';
                        SysCode."Affects Payroll" := true;
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                7:
                    SysCode.Code := 'Change Position';
                8:
                    SysCode.Code := 'Change Employment';
                9:
                    begin
                        SysCode.Code := 'Change Spouse Secured';
                        SysCode."Affects Payroll" := true;
                    end;
                10:
                    begin
                        SysCode.Code := 'Change Social Status';
                        SysCode."Affects Payroll" := true;
                    end;
                11:
                    begin
                        SysCode.Code := 'Change Husband Paralysed';
                        SysCode."Affects Payroll" := true;
                    end;
                12:
                    begin
                        SysCode.Code := 'ALL';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                13:
                    begin
                        SysCode.Code := 'Open';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                14:
                    begin
                        SysCode.Code := 'ReOpen';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                15:
                    begin
                        SysCode.Code := 'Release';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                16:
                    begin
                        SysCode.Code := 'Approve';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                17:
                    begin
                        SysCode.Code := 'Hire';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                18:
                    begin
                        SysCode.Code := 'Convert Leaves';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                19:
                    begin
                        SysCode.Code := 'Change Basic Pay';
                        SysCode."Affects Payroll" := true;
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                20:
                    begin
                        SysCode.Code := 'Change Additional Salary';
                        SysCode."Affects Payroll" := true;
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                21:
                    begin
                        SysCode.Code := 'Change Declared';
                        SysCode."Affects Payroll" := true;
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                22:
                    begin
                        SysCode.Code := 'Change Foreigner';
                        SysCode."Affects Payroll" := true;
                    end;
                23:
                    begin
                        SysCode.Code := 'Change Emp. Category';
                        SysCode."Affects Payroll" := true;
                    end;
                24:
                    begin
                        SysCode.Code := 'Change Employment Date';
                        SysCode."Affects Payroll" := true;
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                25:
                    begin
                        SysCode.Code := 'Change Job Title';
                        //EDM+ //SysCode.Split := TRUE; //EDM-
                    end;
                26:
                    begin
                        SysCode.Code := 'Swap';
                        SysCode.Category := SysCode.Category::"Function";
                    end;
                27:
                    SysCode.Code := 'Pension';
                28:
                    SysCode.Code := 'Change Organization';
                29:
                    SysCode.Code := 'Deductions';
            end; // case
            SysCode.System := true;
            SysCode.INSERT;
            Loop := Loop + 1;
        end; // loop
    end;

    procedure ChkTrxDateValidity(P_Employee: Record Employee; P_TransactionDate: Date);
    var
        Date: Record Date;
        FDateLimit: Date;
        LDateLimit: Date;
        HumanResSetup: Record "Human Resources Setup";
        PayStatus: Record "Payroll Status";
    begin
        /*HumanResSetup.GET;
        Date.RESET;
        Date.SETRANGE("Period Type",Date."Period Type"::Date);
        Date.SETFILTER("Period Start",HumanResSetup."Period Filter");
        IF Date.FIND('-') THEN
          FDateLimit := Date."Period Start";
        IF Date.FIND('+') THEN
          LDateLimit := Date."Period Start";
        IF (P_TransactionDate < FDateLimit) OR (P_TransactionDate > LDateLimit) THEN
          ERROR('Transaction Date is Out of Range. HR Period = %1',HumanResSetup."Period Filter");
        IF HumanResSetup."Payroll in Use" THEN BEGIN
          P_Employee.TESTFIELD("Payroll Group Code");
          IF PayStatus.GET(P_Employee."Payroll Group Code",P_Employee."Pay Frequency") THEN
            IF P_TransactionDate <= PayStatus."Finalized Payroll Date" THEN
              ERROR('Transaction Date is Out of Range.Last Finalized payroll Period = %1',PayStatus."Finalized Payroll Date");
          //py2.0+
          PayStatus.TESTFIELD("Starting Payroll Day");
          //py2.0-
        END; //py.in use
         */

    end;

    procedure SetPayGroupFilter(var PayGroup: Record "HR Payroll Group") FirstPayGroup: Code[10];
    var
        PayUser: Record "HR Payroll User";
        PayGroupFilter: Text[250];
        First: Boolean;
    begin
        if (USERID <> '') and (PayGroup.COUNT > 0) then begin
            PayUser.RESET;
            PayUser.SETRANGE("User Id", USERID);
            //Added in order to consider 'Hide Salary' permission on HR Payroll User - 14.09.2016 : AIM +
            if PayrollFunctions.HideSalaryFields() = true then
                PayUser.SETRANGE(PayUser."Hide Salary", false);
            //Added in order to consider 'Hide Salary' permission on HR Payroll User - 14.09.2016 : AIM -
            PayGroupFilter := '''''';
            First := true;
            if PayUser.FIND('-') then
                repeat
                    if First then begin
                        FirstPayGroup := PayUser."Payroll Group Code";
                        First := false;
                    end;
                    PayGroupFilter := PayGroupFilter + '|' + PayUser."Payroll Group Code";
                until PayUser.NEXT = 0
            else
                //ERROR('You do not have access to Payroll.');

                PayGroup.FILTERGROUP(2);
            PayGroup.SETFILTER(Code, PayGroupFilter);
            PayGroup.FILTERGROUP(0);
        end;
    end;

    procedure GetHoursFrom2Times(P_StartTime: Time; P_EndTime: Time): Decimal;
    var
        Minutes: Decimal;
        "No. of Hours": Decimal;
        TimeM: Time;
        TimeZ: Time;
    begin
        TimeM := 235959T;
        TimeZ := 000000T;
        if P_StartTime > P_EndTime then
            Minutes := (TimeM - P_StartTime) + (P_EndTime - TimeZ)
        else
            Minutes := P_EndTime - P_StartTime;
        Minutes := ROUND(Minutes / 60000, 0.01);
        "No. of Hours" := (Minutes / 60);
        "No. of Hours" := ROUND("No. of Hours", 0.01);
        exit("No. of Hours");
    end;

    procedure GetEmpWorkShift(P_EmpNo: Code[20]; P_ShiftDate: Date): Code[10];
    var
        Employee: Record Employee;
        EmployType: Record "Employment Type";
        BaseCalChg: Record "Base Calendar Change";
        T0001: Label 'No Working Shift Found for this Employee in that Day.';
        T0002: Label 'Calendar has not been assigned to the Employee Employment Type.';
        T0003: Label 'Employment Type has not been assigned to the Employee.';
    begin
        Employee.GET(P_EmpNo);
        if Employee."Employment Type Code" <> '' then begin
            EmployType.GET(Employee."Employment Type Code");
            if EmployType."Base Calendar Code" <> '' then begin
                BaseCalChg.RESET;
                BaseCalChg.SETRANGE("Base Calendar Code", EmployType."Base Calendar Code");
                BaseCalChg.SETRANGE(Date, P_ShiftDate);
                if BaseCalChg.FIND('-') then begin
                    //EDM.MG.Code Disable For UPGRADE to 2013 +
                    //IF BaseCalChg."Working Shift Code" <> '' THEN
                    //  EXIT(BaseCalChg."Working Shift Code")
                    //ELSE
                    //  ERROR(T0001);
                    //EDM.MG.Code Disable For UPGRADE to 2013 -
                end else
                    ERROR(T0001);
            end else
                ERROR(T0002);
        end else
            ERROR(T0003);
    end;

    procedure CheckDuplicateSwap(FromEmpNo: Code[20]; ToEmpNo: Code[20]; FromDate: Date; ToDate: Date; FromWorkShift: Code[20]; ToWorkShift: Code[20]);
    var
        EmployeeJournals: Record "Employee Journal Line";
    begin
        EmployeeJournals.SETCURRENTKEY("Employee No.", Type);
        EmployeeJournals.SETRANGE("Employee No.", FromEmpNo);
        EmployeeJournals.SETRANGE(Type, 'SWAP');
        if EmployeeJournals.FIND('+') then
            if EmployeeJournals."Swap To Date" > WORKDATE then
                ERROR('You cannot create multiple SWAP for the same Employee: %1', FromEmpNo);

        EmployeeJournals.SETCURRENTKEY("Employee No.", Type);
        EmployeeJournals.SETRANGE("Employee No.", ToEmpNo);
        EmployeeJournals.SETRANGE(Type, 'SWAP');
        if EmployeeJournals.FIND('+') then
            if EmployeeJournals."Swap To Date" > WORKDATE then
                ERROR('You cannot create multiple SWAP for the same Employee: %1', ToEmpNo);
    end;

    procedure GetShiftGroup(EmpTypeCode: Code[20]) EmpShiftGroup: Code[10];
    var
        EmploymentType: Record "Employment Type";
        BaseCalendar: Record "Base Calendar N";
    begin
        //EDM.MG.Code Disable For UPGRADE to 2013 +
        /*IF EmploymentType.GET(EmpTypeCode) THEN
          IF BaseCalendar.GET(EmploymentType."Base Calendar Code") THEN
            EmpShiftGroup := BaseCalendar."Shift Group Code"
          ELSE
            EmpShiftGroup := '';
         */
        //EDM.MG.Code Disable For UPGRADE to 2013 -

    end;

    procedure Indent();
    var
        CoOrg: Record "Company Organization";
        i: Integer;
        Text000: Label 'This function updates the indentation of all the Organization No. in the chart of Company Organization. \';
        Text001: Label '"All Organization No. between a Begin-Total and the matching End-Total are indented one level. "';
        Text002: Label 'The Totaling for each End-total is also updated.\\';
        Text003: Label 'Do you want to indent the chart of Company Organization?';
        Text004: Label 'Indenting the Company Organization #1##########';
        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
        CoOrgCode: array[10] of Code[20];
    begin
        if not
           CONFIRM(
             Text000 +
             Text001 +
             Text002 +
             Text003, true)
        then
            exit;

        Window.OPEN(Text004);

        with CoOrg do
            if FIND('-') then
                repeat
                    Window.UPDATE(1, "No.");

                    if "Organization Type" = "Organization Type"::"End-Total" then begin
                        if i < 1 then
                            ERROR(
                               Text005,
                              "No.");
                        Totaling := CoOrgCode[i] + '..' + "No.";
                        i := i - 1;
                    end;

                    Indentation := i;
                    MODIFY;

                    if "Organization Type" = "Organization Type"::"Begin-Total" then begin
                        i := i + 1;
                        CoOrgCode[i] := "No.";
                    end;
                until NEXT = 0;

        Window.CLOSE;
    end;

    procedure GetActiveInsurance(P_Date: Date) P_InsFilter: Text[150];
    begin
        //shr2.0
        /*InsSetup.RESET;
        IF InsSetup.FIND('-') THEN
        REPEAT
          IF (P_Date >= InsSetup."Starting Date") AND (P_Date <= InsSetup."Ending Date") THEN BEGIN
            IF P_InsFilter = '' THEN
              P_InsFilter := InsSetup.Code
            ELSE
              P_InsFilter := P_InsFilter + '|' + InsSetup.Code
          END;
        UNTIL InsSetup.NEXT = 0;
        EXIT(P_InsFilter);
        */

    end;

    procedure GetEndofMonthDate(P_Date: Date): Date;
    var
        EOMDate: Date;
    begin
        //shr2.0
        EOMDate := DMY2DATE(1, DATE2DMY(P_Date, 2), DATE2DMY(P_Date, 3));
        EOMDate := CALCDATE('1M', EOMDate) - 1;
        exit(EOMDate);
    end;

    procedure WTRConvertAAL();
    var
        TotalAAL: Decimal;
        HRSetup: Record "Human Resources Setup";
        EmployeeJournals: Record "Employee Journal Line";
        DaysHours: Decimal;
        Loop: Integer;
        LoopAAL: Decimal;
        Remainder: Decimal;
        Emp: Record Employee;
        LastAALDate: Date;
        TransactionTypes: Record "HR Transaction Types";
        CauseofAbs: Record "Cause of Absence";
    begin
        //shr2.0
        HRSetup.GET;
        DaysHours := HRSetup."Against Annual Leave Hours";
        CauseofAbs.GET(HRSetup."Annual Leave Code");
        Emp.SETFILTER("Cause of Absence Filter", '%1|%2', HRSetup."IN Against Annual Leave Code",
                                                     HRSetup."OUT Against Annual Leave Code");
        if Emp.FIND('-') then
            repeat
                Emp.CALCFIELDS("Approved Cause of Abs. Count");
                if Emp."Approved Cause of Abs. Count" <> 0 then begin
                    TotalAAL := ROUND(Emp."Approved Cause of Abs. Count", 0.01);

                    if TotalAAL >= DaysHours then
                        LoopAAL := TotalAAL mod DaysHours;

                    // Apply Against Annual Leave
                    Loop := 1;
                    while Loop <= LoopAAL do begin
                        Remainder := DaysHours;
                        EmployeeJournals.SETRANGE("Employee No.", Emp."No.");
                        EmployeeJournals.SETRANGE("Document Status", EmployeeJournals."Document Status"::Approved);
                        EmployeeJournals.SETRANGE(Converted, false);
                        EmployeeJournals.SETFILTER("Cause of Absence Code", '%1|%2', HRSetup."IN Against Annual Leave Code",
                                                            HRSetup."OUT Against Annual Leave Code");

                        if EmployeeJournals.FIND('-') then
                            repeat
                                LastAALDate := EmployeeJournals."Starting Date";
                                if EmployeeJournals."Calculated Value" <= Remainder then begin
                                    EmployeeJournals."Converted Value" := EmployeeJournals."Converted Value" + EmployeeJournals."Calculated Value";
                                    EmployeeJournals.Converted := true;
                                    Remainder := Remainder - EmployeeJournals."Calculated Value";
                                    EmployeeJournals.Value := 0;
                                    EmployeeJournals."Calculated Value" := 0;
                                end else begin
                                    EmployeeJournals.Value := EmployeeJournals.Value - Remainder;
                                    EmployeeJournals."Calculated Value" := EmployeeJournals."Calculated Value" - Remainder;
                                    EmployeeJournals."Converted Value" := EmployeeJournals."Converted Value" + Remainder;
                                    Remainder := 0;
                                end;
                                EmployeeJournals.MODIFY;
                            until (EmployeeJournals.NEXT = 0) or (Remainder = 0);

                        // Insert Against annual leave
                        EmployeeJournals.INIT;
                        EmployeeJournals."Employee No." := Emp."No.";
                        EmployeeJournals.Type := 'ABSENCE';
                        if TransactionTypes.FIND('-') then
                            repeat
                                if TransactionTypes.Type = 'ABSENCE' then
                                    EmployeeJournals."Transaction Type" := TransactionTypes.Code;
                            until TransactionTypes.NEXT = 0;
                        EmployeeJournals."Document Status" := EmployeeJournals."Document Status"::Approved;
                        EmployeeJournals."Approved By" := USERID;
                        EmployeeJournals."Approved Date" := TODAY;
                        EmployeeJournals."Transaction Date" := WORKDATE;
                        EmployeeJournals."Starting Date" := LastAALDate;
                        EmployeeJournals."Ending Date" := LastAALDate;
                        EmployeeJournals.Description := 'Convert Against Annual Leaves IN / OUT' + ' into ' + HRSetup."Annual Leave Code";
                        EmployeeJournals."Unit of Measure Code" := CauseofAbs."Unit of Measure Code";
                        EmployeeJournals.Converted := true;
                        EmployeeJournals."Cause of Absence Code" := HRSetup."Annual Leave Code";
                        EmployeeJournals."Converted Value" := DaysHours;
                        if LastAALDate <> 0D then
                            EmployeeJournals.ValidateAbsence;
                        EmployeeJournals.INSERT(true);
                        Loop += 1;
                    end; //loop aal
                end; //convert against Annual Leave
            until Emp.NEXT = 0;
    end;

    procedure GetNonAttendance(P_BaseCalendarCode: Code[10]; P_StartingDate: Date; P_EndingDate: Date): Decimal;
    var
        BaseCalendarChange: Record "Base Calendar Change N";
        EmploymentType: Record "Employment Type";
        LoopDate: Date;
        Day: Integer;
        NonWorkingDay: Boolean;
        NoofNonWD: Decimal;
    begin
        NoofNonWD := 0;
        LoopDate := P_StartingDate;
        while LoopDate <= P_EndingDate do begin
            BaseCalendarChange.RESET;
            BaseCalendarChange.SETRANGE("Base Calendar Code", P_BaseCalendarCode);
            //  BaseCalendarChange.SETRANGE(Nonworking,TRUE);
            NonWorkingDay := false;
            if BaseCalendarChange.FIND('-') then
                repeat
                    //MB.870+
                    BaseCalendarAddition."Additions Value" := 1;
                    AdditionValue := 1;
                    FindAddition := false;
                    //MB.870-
                    if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::"Weekly Recurring" then begin
                        Day := DATE2DWY(LoopDate, 1);
                        case Day of
                            1:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Monday then
                                    NonWorkingDay := true;
                            2:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Tuesday then
                                    NonWorkingDay := true;
                            3:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Wednesday then
                                    NonWorkingDay := true;
                            4:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Thursday then
                                    NonWorkingDay := true;
                            5:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Friday then
                                    NonWorkingDay := true;
                            6:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Saturday then
                                    NonWorkingDay := true;
                            7:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Sunday then
                                    NonWorkingDay := true;
                        end; //case
                    end else
                        if LoopDate = BaseCalendarChange.Date then
                            NonWorkingDay := true;
                    //MB.870+
                    //Check Additions on The base calendar
                    BaseCalendarAddition.SETRANGE("Base Calendar Code", BaseCalendarChange."Base Calendar Code");
                    BaseCalendarAddition.SETRANGE("Recurring System", BaseCalendarChange."Recurring System");
                    BaseCalendarAddition.SETRANGE(Date, BaseCalendarChange.Date);
                    BaseCalendarAddition.SETRANGE(Day, BaseCalendarChange.Day);
                    //EDM.MG.Code Disable For UPGRADE to 2013 +
                    //BaseCalendarAddition.SETRANGE("Working Shift Code",BaseCalendarChange."Working Shift Code");
                    //EDM.MG.Code Disable For UPGRADE to 2013 -
                    BaseCalendarAddition.SETRANGE("Additions Type", BaseCalendarAddition."Additions Type"::Attendance);
                    if BaseCalendarAddition.FIND('-') then begin
                        //MB.871+-
                        if BaseCalendarChange.Date <> 0D then begin
                            if BaseCalendarChange.Date = LoopDate then begin
                                AdditionValue := BaseCalendarAddition."Additions Value";
                                FindAddition := true
                            end else begin
                                AdditionValue := 1;
                                FindAddition := false
                            end;
                        end else begin
                            //MB.871+-
                            if BaseCalendarAddition.Day = Day then begin
                                AdditionValue := BaseCalendarAddition."Additions Value";
                                FindAddition := true;
                            end else begin
                                AdditionValue := 1;
                                FindAddition := false;
                            end;
                        end;
                    end else begin
                        AdditionValue := 1;
                        FindAddition := false;
                    end;
                //MB.870-
                until (BaseCalendarChange.NEXT = 0) or (NonWorkingDay = true) or (FindAddition); // find
            if NonWorkingDay then
                NoofNonWD := NoofNonWD + (1 * AdditionValue);
            LoopDate := LoopDate + 1;
        end; //while
        exit(NoofNonWD);
    end;

    procedure GetRoundingAddition(P_BaseCalendarCode: Code[10]; P_StartingDate: Date; P_EndingDate: Date): Decimal;
    var
        BaseCalendarChange: Record "Base Calendar Change N";
        EmploymentType: Record "Employment Type";
        LoopDate: Date;
        Day: Integer;
        NonWorkingDay: Boolean;
        NoofNonWD: Decimal;
    begin
        NoofNonWD := 0;
        LoopDate := P_StartingDate;
        TotalAddition := 0;
        while LoopDate <= P_EndingDate do begin
            BaseCalendarChange.RESET;
            BaseCalendarChange.SETRANGE("Base Calendar Code", P_BaseCalendarCode);
            BaseCalendarChange.SETRANGE(Date, LoopDate);
            NonWorkingDay := false;
            FindAddition := false;
            if BaseCalendarChange.FIND('-') then
                repeat
                    //MB.870+
                    BaseCalendarAddition."Additions Value" := 1;
                    AdditionValue := 1;
                    FindAddition := false;
                    //MB.870-
                    NonWorkingDay := true;
                    //MB.870+
                    //Check Additions on The base calendar
                    BaseCalendarAddition.SETRANGE("Base Calendar Code", BaseCalendarChange."Base Calendar Code");
                    BaseCalendarAddition.SETRANGE("Recurring System", BaseCalendarChange."Recurring System");
                    BaseCalendarAddition.SETRANGE(Date, BaseCalendarChange.Date);
                    BaseCalendarAddition.SETRANGE(Day, BaseCalendarChange.Day);
                    BaseCalendarAddition.SETRANGE("Working Shift Code", BaseCalendarChange."Working Shift Code");
                    BaseCalendarAddition.SETRANGE("Additions Type", BaseCalendarAddition."Additions Type"::Attendance);
                    if BaseCalendarAddition.FIND('-') then begin
                        //MB.871+-
                        if BaseCalendarChange.Date <> 0D then begin
                            if BaseCalendarChange.Date = LoopDate then begin
                                AdditionValue := BaseCalendarAddition."Additions Value";
                                FindAddition := true
                            end else begin
                                AdditionValue := 1;
                                FindAddition := false
                            end;
                        end else begin
                            //MB.871+-
                            if BaseCalendarAddition.Day = Day then begin
                                AdditionValue := BaseCalendarAddition."Additions Value";
                                FindAddition := true;
                            end else begin
                                AdditionValue := 1;
                                FindAddition := false;
                            end;
                        end;
                    end else begin
                        AdditionValue := 1;
                        FindAddition := false;
                    end;
                //MB.870-

                //MB.870-
                until (BaseCalendarChange.NEXT = 0) or (NonWorkingDay = true) or (FindAddition); // find
            if FindAddition then
                TotalAddition += AdditionValue;
            if NonWorkingDay then
                NoofNonWD := NoofNonWD + (1 * AdditionValue);
            //for recurring
            BaseCalendarChange.RESET;
            BaseCalendarChange.SETRANGE("Base Calendar Code", P_BaseCalendarCode);
            BaseCalendarChange.SETRANGE(Date, 0D);
            NonWorkingDay := false;
            if BaseCalendarChange.FIND('-') then
                repeat
                    //MB.870+
                    BaseCalendarAddition."Additions Value" := 1;
                    AdditionValue := 1;
                    FindAddition := false;
                    //MB.870-
                    if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::"Weekly Recurring" then begin
                        Day := DATE2DWY(LoopDate, 1);
                        case Day of
                            1:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Monday then
                                    NonWorkingDay := true;
                            2:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Tuesday then
                                    NonWorkingDay := true;
                            3:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Wednesday then
                                    NonWorkingDay := true;
                            4:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Thursday then
                                    NonWorkingDay := true;
                            5:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Friday then
                                    NonWorkingDay := true;
                            6:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Saturday then
                                    NonWorkingDay := true;
                            7:
                                if BaseCalendarChange.Day = BaseCalendarChange.Day::Sunday then
                                    NonWorkingDay := true;
                        end; //case
                    end else
                        if LoopDate = BaseCalendarChange.Date then
                            NonWorkingDay := true;
                    //MB.870+
                    //Check Additions on The base calendar
                    BaseCalendarAddition.SETRANGE("Base Calendar Code", BaseCalendarChange."Base Calendar Code");
                    BaseCalendarAddition.SETRANGE("Recurring System", BaseCalendarChange."Recurring System");
                    BaseCalendarAddition.SETRANGE(Date, BaseCalendarChange.Date);
                    BaseCalendarAddition.SETRANGE(Day, BaseCalendarChange.Day);
                    BaseCalendarAddition.SETRANGE("Working Shift Code", BaseCalendarChange."Working Shift Code");
                    BaseCalendarAddition.SETRANGE("Additions Type", BaseCalendarAddition."Additions Type"::Attendance);
                    if BaseCalendarAddition.FIND('-') then begin
                        //MB.871+-
                        if BaseCalendarChange.Date <> 0D then begin
                            if BaseCalendarChange.Date = LoopDate then begin
                                AdditionValue := BaseCalendarAddition."Additions Value";
                                FindAddition := true
                            end else begin
                                AdditionValue := 1;
                                FindAddition := false
                            end;
                        end else begin
                            //MB.871+-
                            if BaseCalendarAddition.Day = Day then begin
                                AdditionValue := BaseCalendarAddition."Additions Value";
                                FindAddition := true;
                            end else begin
                                AdditionValue := 1;
                                FindAddition := false;
                            end;
                        end;
                    end else begin
                        AdditionValue := 1;
                        FindAddition := false;
                    end;
                //MB.870-

                //MB.870-
                until (BaseCalendarChange.NEXT = 0) or (NonWorkingDay = true) or (FindAddition); // find
            if FindAddition then
                TotalAddition += AdditionValue;
            if NonWorkingDay then
                NoofNonWD := NoofNonWD + (1 * AdditionValue);
            LoopDate := LoopDate + 1;
        end; //while
        exit(TotalAddition);
    end;

    procedure TestPermission(pTableID: Integer; pFunction: Integer): Boolean;
    begin
        //EXIT(NOT Companypermission.GET(USERID,pTableID,pFunction))
    end;

    procedure FillLastVacAcDate();
    var
        L_EmployeeJournalLines: Record "Employee Journal Line";
        L_PaydetailsLines: Record "Pay Detail Line";
        L_Employee: Record Employee;
        L_PayParam: Record "Payroll Parameter";
        L_HRSETUP: Record "Human Resources Setup";
        NoOfRecords: Integer;
        RecordNo: Integer;
        L_Window: Dialog;
    begin
        L_PayParam.GET;
        L_HRSETUP.GET;

        L_Window.OPEN(
          'Update Vacation & Accommodation Date\\' +
          'Processing Employee:    #1########\' +
          'Number    #2######  of  #3######\' +
          '@4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        if L_Employee.FIND('-') then
            NoOfRecords := L_Employee.COUNT;
        L_Window.UPDATE(3, NoOfRecords);

        RecordNo := 0;

        repeat
            //
            L_Employee.VALIDATE("Last Accomodation paid Date", 0D);
            L_Employee.VALIDATE("Last Vacation Date", 0D);

            //Employee No.,Tax Year,Pay Frequency,Period,Pay Element Code,Recurring
            L_PaydetailsLines.SETCURRENTKEY("Employee No.", "Tax Year", "Pay Frequency", Period, "Pay Element Code", Recurring);
            L_PaydetailsLines.SETRANGE("Employee No.", L_Employee."No.");
            L_PaydetailsLines.SETRANGE("Pay Element Code", L_PayParam."Housing Allowance");
            L_PaydetailsLines.SETFILTER("Calculated Amount", '<>%1', 0);
            L_PaydetailsLines.SETRANGE(Open, false);
            if L_PaydetailsLines.FIND('+') then
                L_Employee.VALIDATE("Last Accomodation paid Date", CALCDATE('CM',
                                                               DMY2DATE(1, L_PaydetailsLines.Period, L_PaydetailsLines."Tax Year")));

            //Employee No.,Transaction Date,Entry No.
            L_EmployeeJournalLines.SETCURRENTKEY("Employee No.", "Transaction Date", "Entry No.");
            L_EmployeeJournalLines.SETRANGE("Employee No.", L_Employee."No.");
            L_EmployeeJournalLines.SETRANGE("Cause of Absence Code", L_HRSETUP."Annual Leave Code");
            L_EmployeeJournalLines.SETRANGE("Document Status", L_EmployeeJournalLines."Document Status"::Approved);
            if L_EmployeeJournalLines.FIND('+') then
                L_Employee.VALIDATE("Last Vacation Date", L_EmployeeJournalLines."Ending Date");
            //
            L_Employee.MODIFY(true);
            //
            RecordNo := RecordNo + 1;
            //
            L_Window.UPDATE(1, L_Employee."No.");
            L_Window.UPDATE(2, RecordNo);
            //
            L_Window.UPDATE(4, ROUND(RecordNo / NoOfRecords * 10000, 1));
        until L_Employee.NEXT = 0;

        L_Window.CLOSE;
    end;

    procedure ImportEmployeeBenefits(AutoApprove: Boolean; DeleteExisting: Boolean);
    var
        FileManagement: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer" temporary;
        FileName: Text[250];
        RowNo: Integer;
        L_EmployeeNo: Code[20];
        L_TransType: Code[20];
        L_TransDate: Date;
        L_Value: Decimal;
        L_EmployeeJournalLine: Record "Employee Journal Line";
        PayStatus: Record "Payroll Status";
        Employee: Record Employee;
        EmpJnlLine: Record "Employee Journal Line";
        L_NewJrnlLine: Boolean;
        L_PayGroup: Code[10];
        FromFile: Text;
        IStream: InStream;
        SheetName: Text;
        UploadedFileName: Text;
        FileMgt: Codeunit "File Management";
    begin
        PayStatus.FIND('-');
        /*IF ((DATE2DMY(PayrollPeriod,3) = DATE2DMY(PayStatus."Calculated Payroll Date",3)) AND
           (DATE2DMY(PayrollPeriod,2) < PayStatus."Last Period Calculated")) OR
           (DATE2DMY(PayrollPeriod,3) < DATE2DMY(PayStatus."Calculated Payroll Date",3)) OR
             ((PayStatus."Last Period Finalized" = PayStatus."Last Period Calculated") AND
              (DATE2DMY(PayrollPeriod,2) = PayStatus."Last Period Calculated")) THEN
            ERROR('Cannot Process a Previous Payroll Period.');*/

        //Jad: v20+
        //FileName := FileManagement.OpenFileDialog('', '', '');Coders+- // fixed
        UploadIntoStream('', '', '', FromFile, IStream);
        if FromFile <> '' then begin
            UploadedFileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBuf.SelectSheetsNameStream(IStream);
        end else
            Error('No File Found');
        ExcelBuf.Reset();
        ExcelBuf.DeleteAll();
        ExcelBuf.OpenBookStream(IStream, SheetName);
        ExcelBuf.ReadSheet();
        //Jad: v20-
        //Modified in order to set the worsheet name to default 'Sheet1' - 04.06.2016 : AIM +
        //ExcelBuf.OpenBook(FileName,'Attendance');
        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        //Modified in order to set the worsheet name to default 'Sheet1' - 04.06.2016 : AIM -
        //ExcelBuf.ReadSheet;
        RowNo := 1;

        if ExcelBuf.FINDFIRST then
            repeat
                if ExcelBuf."Row No." > RowNo then begin //2
                    if ExcelBuf."Column No." = 1 then begin
                        L_EmployeeNo := ExcelBuf."Cell Value as Text";
                        if not Employee.GET(L_EmployeeNo) then
                            ERROR('Employee %1 not found', L_EmployeeNo);
                        L_PayGroup := Employee."Payroll Group Code";
                    end;

                    if ExcelBuf."Column No." = 2 then begin
                        L_TransType := ExcelBuf."Cell Value as Text";
                        if not HRTransTypes.GET(L_TransType) then
                            ERROR('Transaction Type %1 not found', L_TransType);
                    end;

                    if ExcelBuf."Column No." = 3 then begin
                        EVALUATE(L_TransDate, COPYSTR(ExcelBuf."Cell Value as Text", 1, 8));
                        if not PayStatus.GET(L_PayGroup) then
                            ERROR('Payroll Group not found for employee %1', L_EmployeeNo);
                        //Added in order the case where the process 'Calculate Pay for all employees' is not yet performed - 23.03.2017 : AIM +
                        if L_TransDate <> PayStatus."Payroll Date" then begin
                            //Added in order the case where the process 'Calculate Pay for all employees' is not yet performed - 23.03.2017 : AIM -
                            if (L_TransDate < PayStatus."Period Start Date") or (L_TransDate > PayStatus."Period End Date") then
                                ERROR('Cannot Process Date %1 For Employee %2 . Date is not within Payroll Period ', L_TransDate, L_EmployeeNo);
                            //Added in order the case where the process 'Calculate Pay for all employees' is not yet performed - 23.03.2017 : AIM +
                        end;
                        //Added in order the case where the process 'Calculate Pay for all employees' is not yet performed - 23.03.2017 : AIM -
                    end;

                    if ExcelBuf."Column No." = 4 then begin
                        EVALUATE(L_Value, ExcelBuf."Cell Value as Text"); //COPYSTR(ExcelBuf."Cell Value as Text",1,20);
                                                                          // 09.02.2017 : A2+
                                                                          //IF L_Value <=0 THEN
                                                                          //  ERROR('Value should be > 0');
                                                                          // 09.02.2017 : A2-
                    end;
                end; //2
            until ExcelBuf.NEXT = 0;

        Window2.OPEN(
          'Employee Journal Process \\' +
          'Employee: #1########\' +
          'Date    : #2########\');

        RowNo := 1;
        L_NewJrnlLine := false;

        if ExcelBuf.FINDFIRST then
            repeat
                if ExcelBuf."Row No." > RowNo then begin  //2
                    if ExcelBuf."Column No." = 1 then
                        L_EmployeeNo := ExcelBuf."Cell Value as Text";
                    if ExcelBuf."Column No." = 2 then
                        L_TransType := ExcelBuf."Cell Value as Text";
                    if ExcelBuf."Column No." = 3 then
                        EVALUATE(L_TransDate, COPYSTR(ExcelBuf."Cell Value as Text", 1, 8));
                    if ExcelBuf."Column No." = 4 then begin
                        EVALUATE(L_Value, ExcelBuf."Cell Value as Text"); //COPYSTR(ExcelBuf."Cell Value as Text",1,20);
                        L_NewJrnlLine := true;
                    end;
                    //31.08.2017 : A2+
                    L_TransType := UPPERCASE(L_TransType);
                    //31.08.2017 : A2-
                    Window2.UPDATE(1, L_EmployeeNo);
                    Window2.UPDATE(2, L_TransDate);
                    // 09.02.2017 : A2+
                    //IF L_NewJrnlLine THEN
                    if (L_NewJrnlLine = true) and (L_Value > 0) then
                      // 09.02.2017 : A2-
                      begin
                        // Added in order to reset existing Data - 21.07.2017 : A2+
                        if DeleteExisting then begin
                            EmpJnlLine.RESET;
                            CLEAR(EmpJnlLine);
                            EmpJnlLine.SETRANGE("Employee No.", L_EmployeeNo);
                            EmpJnlLine.SETRANGE("Transaction Type", L_TransType);
                            EmpJnlLine.SETRANGE("Transaction Date", L_TransDate);
                            if EmpJnlLine.FINDFIRST then
                                EmpJnlLine.DELETEALL;
                        end;

                        EmpJnlLine.RESET;
                        CLEAR(EmpJnlLine);
                        EmpJnlLine.SETRANGE("Employee No.", L_EmployeeNo);
                        EmpJnlLine.SETRANGE("Transaction Type", L_TransType);
                        EmpJnlLine.SETRANGE("Transaction Date", L_TransDate);
                        if not EmpJnlLine.FINDFIRST then begin
                            // Added in order to reset existing Data - 21.07.2017 : A2-
                            EmpJnlLine.RESET;
                            EmpJnlLine.INIT;
                            EmpJnlLine.VALIDATE("Employee No.", L_EmployeeNo);
                            //EmpJnlLine."Entry No." := EntryNumber + 1;
                            EmpJnlLine."Transaction Type" := 'ABS';
                            EmpJnlLine.VALIDATE("Transaction Type", L_TransType);
                            EmpJnlLine."Starting Date" := L_TransDate;
                            EmpJnlLine."Ending Date" := L_TransDate;
                            // 09.02.2017 : A2+
                            //EmpJnlLine.Type:='BENEFIT';
                            // 31.08.2017 : A2+
                            //HRTransTypes.SETRANGE(Type,L_TransType);
                            HRTransTypes.SETRANGE(Code, L_TransType);
                            // 31.08.2017 : A2-
                            if HRTransTypes.FINDFIRST then
                                EmpJnlLine.Type := HRTransTypes.Type;
                            // 09.02.2017 : A2-
                            EmpJnlLine.Description := 'Transaction Imported from Excel';
                            EmpJnlLine.VALIDATE("Transaction Date", L_TransDate);
                            EmpJnlLine.Value := L_Value;
                            EmpJnlLine."Calculated Value" := L_Value;
                            // 09.02.2017 : A2+
                            //EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Approved;
                            if AutoApprove = true then begin
                                EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Approved;
                                EmpJnlLine."Approved By" := USERID;
                                EmpJnlLine."Approved Date" := WORKDATE;
                                EmpJnlLine."Released By" := USERID;
                                EmpJnlLine."Released Date" := WORKDATE;
                                EmpJnlLine."Opened By" := '';
                                EmpJnlLine."Opened Date" := 0D;
                            end
                            else begin
                                EmpJnlLine."Document Status" := EmpJnlLine."Document Status"::Opened;
                                EmpJnlLine."Opened By" := USERID;
                                EmpJnlLine."Opened Date" := WORKDATE;
                            end;
                            // 09.02.2017 : A2-
                            //EmpJnlLine."System Inserted":=TRUE;
                            EmpJnlLine.INSERT(true);
                            L_NewJrnlLine := false;
                        end
                        // Added In order to reset existing Data - 21.07.2017 : A2+
                        else
                            L_NewJrnlLine := false;
                        // Added In order to reset existing Data - 21.07.2017 : A2-
                    end;
                end;//2
            until ExcelBuf.NEXT = 0;

        Window2.CLOSE;
        MESSAGE('Your sheet was imported successfully');
        FileName := '';

    end;

    procedure ImportCreditCostCalculation(PayrollDate: Date; DeleteExisting: Boolean);
    var
        PayrollParameter: Record "Payroll Parameter";
        FileName: Text;
        FileManagement: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer";
        TotalColumns: Integer;
        TotalRows: Integer;
        i: Integer;
        RowNo: Integer;
        EmployeeNo: Code[20];
        CreditOfPTF: Decimal;
        OverloadForPTF: Decimal;
        Employee: Record Employee;
        FromFile: Text;
        IStream: InStream;
        SheetName: Text;
        UploadedFileName: Text;
        FileMgt: Codeunit "File Management";
    begin

        PayrollParameter.GET;

        //FileName := FileManagement.OpenFileDialog('', '', '');Coders+- //fixed
        //Jad: v20+
        UploadIntoStream('', '', '', FromFile, IStream);
        if FromFile <> '' then begin
            UploadedFileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBuf.SelectSheetsNameStream(IStream);
        end else
            Error('No File Found');
        ExcelBuf.Reset();
        ExcelBuf.DeleteAll();
        ExcelBuf.OpenBookStream(IStream, SheetName);
        ExcelBuf.ReadSheet();
        //Jad: v20-
        if FileName = '' then
            ERROR('You must select a file to import.');

        ExcelBuf.LOCKTABLE;

        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        //ExcelBuf.ReadSheet;

        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        if ExcelBuf.FINDLAST then
            TotalRows := ExcelBuf."Row No.";

        for i := 2 to TotalRows do begin

            EmployeeNo := '';
            CreditOfPTF := 0;
            OverloadForPTF := 0;

            if ExcelBuf.GET(i, 1) then
                EmployeeNo := ExcelBuf."Cell Value as Text";

            if (EmployeeNo <> '') and (Employee.GET(EmployeeNo)) then begin

                if ExcelBuf.GET(i, 2) then
                    EVALUATE(CreditOfPTF, ExcelBuf."Cell Value as Text");

                if ExcelBuf.GET(i, 3) then
                    EVALUATE(OverloadForPTF, ExcelBuf."Cell Value as Text");

                if (CreditOfPTF > 0) and (Employee."Hourly Rate" > 0) then
                    CreateEmpJrlLineForCreditCostCalculation(EmployeeNo, PayrollParameter."Credit of PTF Journal",
                                                            CreditOfPTF * Employee."Hourly Rate", PayrollDate, DeleteExisting);

                if (OverloadForPTF > 0) and (Employee."Hourly Rate" > 0) then
                    CreateEmpJrlLineForCreditCostCalculation(EmployeeNo, PayrollParameter."Overload for PTF Journal",
                                                            OverloadForPTF * Employee."Hourly Rate", PayrollDate, DeleteExisting);

            end;

        end;

        ExcelBuf.DELETEALL;
        MESSAGE('Import Completed.');
    end;

    local procedure CreateEmpJrlLineForCreditCostCalculation(EmployeeNo: Code[20]; TransactionType: Code[10]; ValueAmount: Decimal; PayrollDate: Date; DeleteExisting: Boolean);
    var
        EmployeeJournalLine: Record "Employee Journal Line";
        HrTransactionType: Record "HR Transaction Types";
        TypeTransactionType: Code[30];
    begin
        // Added in order to delete Exsiting Data - 20.07.2017 : A2+
        if DeleteExisting then begin
            EmployeeJournalLine.RESET;
            CLEAR(EmployeeJournalLine);
            EmployeeJournalLine.SETRANGE("Employee No.", EmployeeNo);
            EmployeeJournalLine.SETRANGE("Transaction Type", TransactionType);
            EmployeeJournalLine.SETFILTER("Transaction Date", '%1', PayrollDate);
            if EmployeeJournalLine.FINDFIRST then
                EmployeeJournalLine.DELETEALL;
        end;
        // Added in order to delete Exsiting Data - 20.07.2017 : A2-

        if HrTransactionType.GET(TransactionType) then
            TypeTransactionType := HrTransactionType.Type;

        // Added in order to delete Exsiting Data - 20.07.2017 : A2+
        EmployeeJournalLine.RESET;
        CLEAR(EmployeeJournalLine);
        EmployeeJournalLine.SETRANGE("Employee No.", EmployeeNo);
        EmployeeJournalLine.SETRANGE("Transaction Type", TransactionType);
        EmployeeJournalLine.SETFILTER("Transaction Date", '%1', PayrollDate);
        if not EmployeeJournalLine.FINDFIRST then begin
            // Added in order to delete Exsiting Data - 20.07.2017 : A2-
            EmployeeJournalLine.INIT;
            EmployeeJournalLine.VALIDATE("Transaction Type", TransactionType);
            EmployeeJournalLine.VALIDATE("Employee No.", EmployeeNo);
            EmployeeJournalLine.VALIDATE("Transaction Date", PayrollDate);
            EmployeeJournalLine.VALIDATE("System Insert", true);
            EmployeeJournalLine.VALIDATE(Type, TypeTransactionType);
            EmployeeJournalLine.VALIDATE(Value, ValueAmount);
            EmployeeJournalLine.VALIDATE("Calculated Value", ValueAmount);
            EmployeeJournalLine.VALIDATE("Opened By", USERID);
            EmployeeJournalLine.VALIDATE("Opened Date", TODAY);
            EmployeeJournalLine.VALIDATE("Released By", USERID);
            EmployeeJournalLine.VALIDATE("Released Date", TODAY);
            EmployeeJournalLine.VALIDATE("Approved By", USERID);
            EmployeeJournalLine.VALIDATE("Approved Date", TODAY);
            EmployeeJournalLine.VALIDATE(Description, 'Transaction Imported from Excel');
            EmployeeJournalLine.VALIDATE("Starting Date", PayrollDate);
            EmployeeJournalLine.VALIDATE("Ending Date", PayrollDate);
            EmployeeJournalLine.VALIDATE("Document Status", EmployeeJournalLine."Document Status"::Approved);
            EmployeeJournalLine.INSERT(true);
            // Added in order to delete Exsiting Data - 20.07.2017 : A2+
        end;
        // Added in order to delete Exsiting Data - 20.07.2017 : A2-
    end;

    procedure ImportCreditCostCalculation2(PayrollDate: Date; DeleteExisting: Boolean);
    var
        PayrollParameter: Record "Payroll Parameter";
        FileName: Text;
        FileManagement: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer";
        TotalColumns: Integer;
        TotalRows: Integer;
        i: Integer;
        RowNo: Integer;
        EmployeeNo: Code[20];
        CreditOfPTF: Decimal;
        OverloadForPTF: Decimal;
        Employee: Record Employee;
        BasicType: Option BasicPay,SalaryACY,HourlyRate,FixedAmount;
        HRSetup: Record "Human Resources Setup";
        DailyTransportation: Decimal;
        FromFile: Text;
        IStream: InStream;
        SheetName: Text;
        UploadedFileName: Text;
        FileMgt: Codeunit "File Management";
    begin
        PayrollParameter.GET;
        HRSetup.GET;
        //FileName := FileManagement.OpenFileDialog('', '', '');Coders+- //fixed
        //Jad: v20+
        UploadIntoStream('', '', '', FromFile, IStream);
        if FromFile <> '' then begin
            UploadedFileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBuf.SelectSheetsNameStream(IStream);
        end else
            Error('No File Found');
        ExcelBuf.Reset();
        ExcelBuf.DeleteAll();
        ExcelBuf.OpenBookStream(IStream, SheetName);
        ExcelBuf.ReadSheet();
        //Jad: v20-
        if FileName = '' then
            ERROR('You must select a file to import.');

        ExcelBuf.LOCKTABLE;
        // ExcelBuf.OpenBook(FileName, 'Sheet1');
        // ExcelBuf.ReadSheet;

        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        if ExcelBuf.FINDLAST then
            TotalRows := ExcelBuf."Row No.";

        for i := 2 to TotalRows do begin
            EmployeeNo := '';
            CreditOfPTF := 0;
            OverloadForPTF := 0;

            if ExcelBuf.GET(i, 1) then
                EmployeeNo := ExcelBuf."Cell Value as Text";

            if (EmployeeNo <> '') and (Employee.GET(EmployeeNo)) then begin
                if ExcelBuf.GET(i, 2) then
                    EVALUATE(CreditOfPTF, ExcelBuf."Cell Value as Text");

                if ExcelBuf.GET(i, 3) then
                    EVALUATE(OverloadForPTF, ExcelBuf."Cell Value as Text");
            end;

        end;

        ExcelBuf.DELETEALL;
        MESSAGE('Import Completed.');
    end;

    local procedure GetEmployeeDailyTransportation(EmpNo: Code[20]) Val: Decimal;
    var
        EmployeeTbt: Record Employee;
        SpecificPayElement: Record "Specific Pay Element";
    begin
        IF EmpNo = '' THEN
            EXIT;

        EmployeeTbt.SETRANGE("No.", EmpNo);
        IF EmployeeTbt.FINDFIRST THEN BEGIN
            SpecificPayElement.SETRANGE("Internal Pay Element ID", '13');
            SpecificPayElement.SETRANGE("Employee Category Code", EmployeeTbt."Employee Category Code");
            IF (SpecificPayElement.FINDFIRST) AND (SpecificPayElement."Pay Unit" = SpecificPayElement."Pay Unit"::Daily) THEN
                Val := SpecificPayElement.Amount;
        END;
    end;

    procedure ImportFlightAllwonces(PayrollDate: Date; DeleteExisting: Boolean);
    var
        UploadedFileName: Text[250];
        index: Integer;
        RowNo: Integer;
        cellFound: Boolean;
        cellValue: Text[250];
        MaxRow: Integer;
        Window: Dialog;
        ExcelBuf: Record "Excel Buffer";
        EmpTravelPerDeem: Record "Emp. Travel Per Deem Policy";
        EmpAddInfo: Record "Employee Additional Info";
        PayrollParameter: Record "Payroll Parameter";
        EmployeeJournalLine: Record "Employee Journal Line";
        HRTransactionType: Record "HR Transaction Types";
        FileName: Text[250];
        SheetName: Text[250];
        TypeTransactionType: Code[30];
        EmployeeNo: Code[20];
        TotalHrs: Decimal;
        TotalMin: Decimal;
        ValueAmount: Decimal;
        FileMgt: Codeunit "File Management";
        Text006: TextConst ENU = 'Import Excel File';
        ImportWindowTitle: TextConst ENU = 'Import Excel File';
        ExcelExtensionTok: TextConst ENU = '.xlsx';
    begin
        //Excel Format : Employee No   | Total Hrs |  Total Min   |
        //                 001         |     2     |      45      |
        PayrollParameter.Get();
        HRTransactionType.SetRange(Code, PayrollParameter."Credit of PTF Journal");
        if HRTransactionType.FindFirst then
            TypeTransactionType := HRTransactionType.Type;

        //UploadedFileName := FileMgt.UploadFile(ImportWindowTitle, ExcelExtensionTok);
        FileName := UploadedFileName;

        //SheetName := ExcelBuf.SelectSheetsName(FileName);//EDM.NED

        //ExcelBuf.OpenBook(FileName, SheetName);
        //ExcelBuf.ReadSheet;
        RowNo := 2;
        Window.OPEN('Import Process \' +
                    'Record No : #1########\');

        if ExcelBuf.FINDFIRST then
            repeat
                ExcelBuf.SETCURRENTKEY("Row No.");
                IF ExcelBuf.FINDLAST then
                    MaxRow := ExcelBuf."Row No.";
                while RowNo <= MaxRow do begin
                    index := 0;
                    EmployeeNo := '';
                    TotalHrs := 0;
                    TotalMin := 0;
                    ValueAmount := 0;
                    while index < 3 do begin
                        index := index + 1;
                        cellFound := ExcelBuf.GET(RowNo, index);
                        if cellFound then begin
                            cellValue := ExcelBuf."Cell Value as Text";
                            case index of
                                1:
                                    EVALUATE(EmployeeNo, cellValue);
                                2:
                                    EVALUATE(TotalHrs, cellValue);
                                3:
                                    EVALUATE(TotalMin, cellValue);
                            end;
                        end;
                    end;

                    Window.UPDATE(1, RowNo - 1);
                    if EmployeeNo <> '' then begin
                        EmpAddInfo.Get(EmployeeNo);
                        EmpTravelPerDeem.SetRange("Policy Code", EmpAddInfo."Travel Per Deem Policy");
                        if EmpTravelPerDeem.FindFirst then begin
                            ValueAmount := TotalHrs * EmpTravelPerDeem."Price per Hrs";
                            ValueAmount += (TotalMin) * EmpTravelPerDeem."Price per Hrs" / 60;
                            EmployeeJournalLine.Init;
                            EmployeeJournalLine.Validate("Transaction Type", PayrollParameter."Credit of PTF Journal");
                            EmployeeJournalLine.Validate("Employee No.", EmployeeNo);
                            EmployeeJournalLine.Validate("Transaction Date", PayrollDate);
                            EmployeeJournalLine.Validate("System Insert", true);
                            EmployeeJournalLine.Validate(Type, TypeTransactionType);
                            EmployeeJournalLine.Validate(Value, ValueAmount);
                            EmployeeJournalLine.Validate("Calculated Value", ValueAmount);
                            EmployeeJournalLine.Validate("Opened By", USERID);
                            EmployeeJournalLine.Validate("Opened Date", TODAY);
                            EmployeeJournalLine.Validate("Released By", USERID);
                            EmployeeJournalLine.Validate("Released Date", TODAY);
                            EmployeeJournalLine.Validate("Approved By", USERID);
                            EmployeeJournalLine.Validate("Approved Date", TODAY);
                            EmployeeJournalLine.Validate(Description, 'Transaction Imported from Excel');
                            EmployeeJournalLine.Validate("Starting Date", PayrollDate);
                            EmployeeJournalLine.Validate("Ending Date", PayrollDate);
                            EmployeeJournalLine.Validate("Document Status", EmployeeJournalLine."Document Status"::Approved);
                            EmployeeJournalLine.Insert(true);
                        end;
                    end;
                    RowNo += 1;
                end;
            until ExcelBuf.Next = 0;
        Window.CLOSE;
    end;

}

