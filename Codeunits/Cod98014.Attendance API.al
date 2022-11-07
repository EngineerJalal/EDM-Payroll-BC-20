codeunit 98014 "Attendance API"
{
    // version EDM.HRPY2


    trigger OnRun();
    begin
    end;

    var
        PayrollFunctions : Codeunit "Payroll Functions";

    procedure CheckAccessPermission() : Boolean;
    begin

        exit(true);
    end;

    procedure GenerateAttendance(EmployeeNo : Code[20];TransactionDate : DateTime;TransactionTime : DateTime;ActionType : Text) : Boolean;
    var
        TempHandPunchRec : Record "Temp Hand Punch";
        Employee : Record Employee;
    begin

        if(not Employee.GET(EmployeeNo)) or (TransactionTime = 0DT) then
          exit(false);

        TempHandPunchRec.INIT;

        TempHandPunchRec.VALIDATE("Attendnace No.",Employee."Attendance No.");
        TempHandPunchRec.VALIDATE("Employee Name",Employee."First Name" + ' ' + Employee."Last Name");
        TempHandPunchRec.VALIDATE("Transaction Date",TransactionDate);
        TempHandPunchRec.VALIDATE("Transaction Time",TransactionTime);
        TempHandPunchRec.VALIDATE("Action Type",ActionType);

        exit(TempHandPunchRec.INSERT(true));
    end;

    procedure GenerateLeaveRequest("Employee No" : Code[20];"Requested By" : Code[20];"Alternative Employee No" : Code[20];"Demand Date" : DateTime;"From Date" : DateTime;"To Date" : DateTime;Reason : Text[500];"Leave Type" : Text;Remark : Text[500];"Number Days" : Decimal;"Approval Status" : Integer) ObjectCreated : Boolean;
    var
        LeaveRequest : Record "Leave Request";
        CauseOfAbsence : Record "Cause of Absence";
        CauseOfAbsenceCode : Code[10];
    begin

        if "Approval Status" <> 1 then
          exit(false);

        Reason := COPYSTR(Reason,1,250);
        Remark := COPYSTR(Remark,1,250);

        CauseOfAbsence.SETRANGE("Zoho Code","Leave Type");
        if CauseOfAbsence.FINDFIRST then
          CauseOfAbsenceCode := CauseOfAbsence.Code;

        LeaveRequest.SETRANGE("Employee No.","Employee No");
        LeaveRequest.SETRANGE("From Date",DT2DATE("From Date"));
        LeaveRequest.SETRANGE("To Date",DT2DATE("To Date"));
        LeaveRequest.SETRANGE("Leave Type",CauseOfAbsenceCode);

        if LeaveRequest.FINDFIRST then
          exit(false);

        if "Demand Date" = 0DT then
          "Demand Date" := "From Date";

        LeaveRequest.INIT;

        LeaveRequest.VALIDATE("Employee No.","Employee No");
        LeaveRequest.VALIDATE("Requested By","Requested By");
        LeaveRequest.VALIDATE("Alternative Employee No.","Alternative Employee No");
        LeaveRequest.VALIDATE("Leave Type",CauseOfAbsenceCode);
        LeaveRequest.VALIDATE(Reason,Reason);
        LeaveRequest.VALIDATE(Remark,Remark);

        LeaveRequest.VALIDATE("Demand Date",DT2DATE("Demand Date"));
        LeaveRequest.VALIDATE("From Date",DT2DATE("From Date"));
        LeaveRequest.VALIDATE("From Time",DT2TIME("From Date"));
        LeaveRequest.VALIDATE("To Date",DT2DATE("To Date"));
        LeaveRequest.VALIDATE("To Time",DT2TIME("To Date"));
        LeaveRequest.VALIDATE("Days Value","Number Days");

        exit(LeaveRequest.INSERT(true));
    end;

    procedure InsertAPIHandPunches(EmpNo : Code[20]);
    var
        TempHandPunch : Record "Temp Hand Punch";
        HandPunch : Record "Hand Punch";
        EmpTBT : Record Employee;
        EmpAttendanceNo : Integer;
    begin

        //EmpNo := PayrollFunctions.CheckIfAttendanceNoExists(EmpAttendanceNo) ;

        if EmpNo = '' then
          exit;

        EmpTBT.SETRANGE(EmpTBT."No.",EmpNo);
        if EmpTBT.FINDFIRST = false then
          exit;

        EmpAttendanceNo := EmpTBT."Attendance No.";

        if PayrollFunctions.CanModifyAttendancePeriod(EmpNo,EmpTBT.Period ,true ,false ,false ,false  ) = true then
            begin

                TempHandPunch.SETRANGE(Status,TempHandPunch.Status::Active);
                TempHandPunch.SETRANGE(TempHandPunch."Attendnace No.",EmpAttendanceNo);

                if TempHandPunch.FINDFIRST then
                repeat

                      HandPunch.SETRANGE("Attendnace No.",TempHandPunch."Attendnace No.");
                      HandPunch.SETRANGE("Date Time",CREATEDATETIME(DT2DATE(TempHandPunch."Transaction Date"),DT2TIME(TempHandPunch."Transaction Time"))) ;
                      HandPunch.SETRANGE("Action Type",TempHandPunch."Action Type");

                      if HandPunch.FINDFIRST then
                          begin
                          end
                      else
                          begin
                            HandPunch.INIT;
                            HandPunch."Attendnace No.":=TempHandPunch."Attendnace No.";
                            HandPunch.VALIDATE("Date Time",CREATEDATETIME(DT2DATE(TempHandPunch."Transaction Date") ,DT2TIME(TempHandPunch."Transaction Time")));

                            HandPunch."Employee Name":=TempHandPunch."Employee Name";
                            HandPunch."Action Type":=TempHandPunch."Action Type";

                            HandPunch."Scheduled Date" := PayrollFunctions.FixPunchScheduledDate(EmpNo, HandPunch."Real Date" ,HandPunch."Real Time");
                              if HandPunch."Scheduled Date" = 0D then
                                HandPunch."Scheduled Date" := HandPunch."Real Date";

                            if HandPunch."Action Type" = '' then
                                  HandPunch."Action Type" := 'IN';

                            HandPunch."Modified By" :=  COPYSTR(USERID,1,49);
                            HandPunch."Modification Date" := WORKDATE;

                            HandPunch.INSERT;

                          end;

                until TempHandPunch.NEXT=0;

                  //Disabled because it is added at 'Add Schedule' utility - 24.03.2017 : AIM +
                  //PayrollFunctions.ValidateEmployeeAttendanceHolidays(EmpNo ,EmpTBT.Period );
                  //Disabled because it is added at 'Add Schedule' utility - 24.03.2017 : AIM -
                  PayrollFunctions.CheckEmployeeAttendance(EmpNo,EmpTBT.Period );
                  PayrollFunctions.FixEmployeeDailyAttendanceHours(EmpNo ,EmpTBT.Period ,0D ,true ,'A0-LA-EL-EA-LL');
            end;
    end;
}

