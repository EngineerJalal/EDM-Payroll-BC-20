report 98025 "Update Attendance"
{
    // version EDM.HRPY1

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = WHERE(Status=CONST(Active));
            RequestFilterFields = "No.",Period;

            trigger OnAfterGetRecord();
            begin
                RecNo:=RecNo+1;
                Window.UPDATE(2,ROUND(RecNo / TotalRecNo * 10000,1));
                Window.UPDATE(1,Employee."No.");
                
                // The part Code-1 is replaced by the current function in order to prevent code redundancy - 30.12.2015 : AIM +
                PayrollFunctions.UpdateEmployeeAttendance("No.",Period  ) ;
                // The part Code-1 is replaced by the current function in order to prevent code redundancy - 30.12.2015 : AIM -
                
                /* // Code-1  Commented - 30.12.2015 : AIM +
                EmpAbs.SETRANGE("Employee No.","No.");
                EmpAbs.SETRANGE(Period,Period);
                //EmpAbs.SETRANGE("Invalid Log",FALSE);
                IF EmpAbs.FINDFIRST THEN
                REPEAT
                  EmpAbs.VALIDATE("Employee No.",EmpAbs."Employee No.");
                  EmpAbs.MODIFY;
                  CLEAR(VarStartTime);
                  CLEAR(VarEndTime);
                  CLEAR(VarExpectedTo);
                  CLEAR(VarExpectedFrom);
                
                  HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                  HandPunch.SETRANGE("Scheduled Date",EmpAbs."From Date");
                  HandPunch.SETRANGE("Action Type",'IN');
                  IF HandPunch.FINDFIRST THEN
                  BEGIN
                    VarStartTime:=HandPunch."Real Time";
                  END;
                
                  DiffTime:=0;
                  HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                  HandPunch.SETRANGE("Scheduled Date",EmpAbs."From Date");
                  HandPunch.SETRANGE("Action Type",'OUT');
                  IF HandPunch.FINDLAST THEN
                  BEGIN
                    VarEndTime:=HandPunch."Real Time";
                  END;
                  //+Attend Hour
                  IF (VarStartTime<>0T)AND(VarEndTime<>0T) THEN
                    EmpAbs.VALIDATE("Attend Hrs.",EmpAbs.CalcTime(VarStartTime,VarEndTime));
                  //-
                  EmpAbs."Late Arrive":=0;
                EmpAbs."Early Leave" :=0;
                EmpAbs."Early Arrive"  :=0;
                EmpAbs."Late Leave":=0;
                EmpAbs.MODIFY;
                  VarExpectedFrom:=EmpAbs."From Time";
                  VarExpectedTo:=EmpAbs."To Time";
                
                  IF (FORMAT(VarExpectedFrom)<>'') AND (FORMAT(VarExpectedTo)<>'') AND (FORMAT(VarStartTime)<>'')
                  AND (FORMAT(VarEndTime)<>'')THEN
                  BEGIN
                    IF VarExpectedFrom>VarStartTime THEN
                    BEGIN
                      EmpAbs.VALIDATE("Early Arrive",EmpAbs.CalcTime(VarStartTime,VarExpectedFrom)*60);
                    END
                    ELSE
                    BEGIN
                      EmpAbs.VALIDATE("Late Arrive",EmpAbs.CalcTime(VarExpectedFrom,VarStartTime)*60);
                    END;
                
                    IF VarExpectedTo<VarEndTime THEN
                    BEGIN
                      EmpAbs.VALIDATE("Late Leave",(EmpAbs.CalcTime(VarExpectedTo,VarEndTime))*60);
                    END
                    ELSE
                    BEGIN
                        EmpAbs.VALIDATE("Early Leave",EmpAbs.CalcTime(VarEndTime,VarExpectedTo)*60);
                    END;
                  END;
                  EmpAbs.MODIFY;
                UNTIL EmpAbs.NEXT=0;
                HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                IF HandPunch.FINDFIRST THEN
                REPEAT
                  HandPunch.checked:=FALSE;
                  HandPunch.MODIFY;
                UNTIL HandPunch.NEXT=0;
                */ // Code-1  Commented - 30.12.2015 : AIM -

            end;

            trigger OnPreDataItem();
            begin

                Window.OPEN(Text002+Text001);
                TotalRecNo:=Employee.COUNT;
            end;
        }
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

    var
        EmpAbs : Record "Employee Absence";
        Window : Dialog;
        RecNo : Integer;
        Text001 : Label 'Imported @2@@@@@@@@@@@@@@@@@@@@@@@@@\';
        Text002 : Label 'Employee #1########################\\';
        TotalRecNo : Integer;
        HandPunch : Record "Hand Punch";
        VarTime : Time;
        VarDate : Date;
        VarStartTime : Time;
        VarEndTime : Time;
        VarExpectedFrom : Time;
        VarExpectedTo : Time;
        Found : Boolean;
        DiffTime : Decimal;
        EDMUtility : Codeunit "EDM Utility";
        PayrollFunctions : Codeunit "Payroll Functions";
}

