report 98029 "Convert Attendance.."
{
    // version SHR1.0,EDM.HRPY2

    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        DaysHours := 1;
        TrxDate := WORKDATE;
    end;

    trigger OnPostReport();
    begin
        Employee.GET(EmployeeNo);

        if not IsOvertime then begin
          Loop := 1;
          while Loop <= 2 do begin
            InitEmpJnl;
            if Loop = 1 then begin
              EmployeeJournals."Cause of Absence Code" := FromCauseofAbsence;
              EmployeeJournals.Value := DaysHours;
              EmployeeJournals."Calculated Value" := EmployeeJournals.Value;
            end // loop1
            else
            if Loop = 2 then begin
              EmployeeJournals."Cause of Absence Code" := ToCauseofAbsence;
              EmployeeJournals."Converted Value" := DaysHours * Multiplier;
              if EmployeeAbsenceEntitle.GET(EmployeeNo,ToCauseofAbsence) then begin
                EmployeeAbsenceEntitle.Entitlement := EmployeeAbsenceEntitle.Entitlement + EmployeeJournals."Converted Value";
                EmployeeAbsenceEntitle.MODIFY;
              end;
            end; // loop2
            if StartingDate <> 0D then
              EmployeeJournals.ValidateAbsence;
            EmployeeJournals.INSERT(true);
            Loop := Loop + 1;
          end; // loop
        end else
          ApplyAgainstOvertime;
    end;

    trigger OnPreReport();
    begin
        if EmployeeNo = '' then
          ERROR('Employee No. must be Filled in.');

        if FromCauseofAbsence = '' then
          ERROR(Text000);

        if ToCauseofAbsence = '' then
          ERROR(Text001);

        if Multiplier <= 0 then
          ERROR(Text005);

        if DaysHours = 0 then
            ERROR(Text007);

        if TrxDate = 0D then
          ERROR('You must fill in the Transaction Date field.');
    end;

    var
        Multiplier : Decimal;
        FromCauseofAbsence : Code[10];
        ToCauseofAbsence : Code[10];
        Text000 : Label 'You must fill in the FROM Cause of Absence  field.';
        Text001 : Label 'You must fill in the TO Cause of Absence  field.';
        Balance : Decimal;
        EmployeeAbsenceEntitle : Record "Employee Absence Entitlement";
        VExist : Boolean;
        EmployeeNo : Code[20];
        Text002 : Label 'Conversion Failed : No Balance Found for the FROM Cause of Absence.';
        Text003 : Label 'Conversion Failed :The FROM Cause of Absence not Entitled for Selected Employee.';
        Text004 : Label 'Conversion Failed :The TO Cause of Absence Should be Entitled / Convertible.';
        Text005 : Label 'Multiplier Must be Greater Than Zero.';
        Text006 : Label '"TO and FROM Cause of Absence Must Differ. "';
        Loop : Integer;
        EmployeeJournals : Record "Employee Journal Line";
        DaysHours : Decimal;
        Text007 : Label 'You must fill in the No. of Days.';
        TransactionTypes : Record "HR Transaction Types";
        CauseofAbsence : Record "Cause of Absence";
        PayElement : Record "Pay Element";
        Text010 : Label 'The FROM Cause of Absence is not Convertible.';
        Employee : Record Employee;
        StartingDate : Date;
        EndingDate : Date;
        MoreInfo : Text[30];
        TrxDate : Date;
        HRFunctions : Codeunit "Human Resource Functions";
        FromUOM : Code[10];
        IsOvertime : Boolean;
        TotalOvertime : Decimal;
        FromTime : Time;
        ToTime : Time;
        Remainder : Decimal;
        OvertimeNotApproved : Boolean;

    procedure InitEmpJnl();
    begin
        EmployeeJournals.INIT;
        EmployeeJournals."Employee No." := EmployeeNo;
        EmployeeJournals.Type := 'ABSENCE';
        if TransactionTypes.FIND('-') then
        repeat
          if TransactionTypes.Type = 'ABSENCE' then
            EmployeeJournals."Transaction Type" := TransactionTypes.Code;
        until TransactionTypes.NEXT = 0;
        EmployeeJournals."Document Status" := EmployeeJournals."Document Status"::Approved;
        EmployeeJournals."Approved By" := USERID;
        EmployeeJournals."Approved Date" := TODAY;
        EmployeeJournals."Transaction Date" := TrxDate;
        EmployeeJournals."Starting Date" := StartingDate;
        EmployeeJournals."Ending Date" := EndingDate;
        EmployeeJournals."From Time" := FromTime;
        EmployeeJournals."To Time" := ToTime;
        EmployeeJournals.Description := 'Convert ' + FromCauseofAbsence + ' into ' + ToCauseofAbsence;
        EmployeeJournals."More Information" := MoreInfo;
        EmployeeJournals."Unit of Measure Code" := CauseofAbsence."Unit of Measure Code";
        EmployeeJournals.Converted := true;
    end;

    procedure ApplyAgainstOvertime();
    begin
        OvertimeNotApproved := false;
        TotalOvertime := 0;
        EmployeeJournals.SETRANGE("Employee No.",EmployeeNo);
        EmployeeJournals.SETRANGE(Processed,false);
        EmployeeJournals.SETRANGE("Absence Transaction Type",EmployeeJournals."Absence Transaction Type"::Overtime);
        if EmployeeJournals.FIND('-') then
          repeat
            TotalOvertime := TotalOvertime + ROUND(EmployeeJournals."Calculated Value",0.01);
            if EmployeeJournals."Document Status" <> EmployeeJournals."Document Status"::Approved then
              OvertimeNotApproved := true;
          until (EmployeeJournals.NEXT = 0) or (OvertimeNotApproved)
        else
          ERROR('Employee has no Existing Overtime Journal Lines');

        if (DaysHours > TotalOvertime) then
          ERROR('Overtime(s) to be Converted exceed existing Overtime(s) Journal Lines = %1',TotalOvertime);
        if OvertimeNotApproved then
          ERROR('There is still Overtime Employee Journal Line(s) not Approved Yet');

        // Apply Against Overtime
        Remainder := DaysHours;
        if EmployeeJournals.FIND('-') then
          repeat
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

        // Insert Against Overtime
        InitEmpJnl;
        EmployeeJournals."Cause of Absence Code" := ToCauseofAbsence;
        EmployeeJournals."Converted Value" := DaysHours * Multiplier;
        if StartingDate <> 0D then
          EmployeeJournals.ValidateAbsence;
        EmployeeJournals.INSERT(true);
    end;

    procedure GetMainNo(P_MainEmpNo : Code[20]);
    begin
        EmployeeNo := P_MainEmpNo;
    end;
}

