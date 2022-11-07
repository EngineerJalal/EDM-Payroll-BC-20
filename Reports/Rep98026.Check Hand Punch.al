report 98026 "Check Hand Punch"
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
                PayrollFunctions.CheckEmployeeAttendance("No.",Period )
                // The part Code-1 is replaced by the current function in order to prevent code redundancy - 30.12.2015 : AIM -
                
                /* // Code-1  Commented - 30.12.2015 : AIM +
                EmpAbs.SETRANGE("Employee No.","No.");
                EmpAbs.SETRANGE(Period,Period);
                IF EmpAbs.FINDFIRST THEN
                REPEAT
                  EmpAbs.VALIDATE("Employee No.",EmpAbs."Employee No.");
                  EmpAbs.MODIFY;
                  HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                  HandPunch.SETRANGE("Real Date",EmpAbs."From Date");
                  HandPunch.SETRANGE("Action Type",'IN');
                  IF HandPunch.FINDFIRST THEN
                  BEGIN
                    HandPunch."Scheduled Date":=EmpAbs."From Date";
                    HandPunch.MODIFY;
                  END
                  ELSE
                  BEGIN
                    EmpAbs."Invalid Log":=TRUE;
                    EmpAbs.MODIFY;
                  END;
                
                  HandPunch.SETCURRENTKEY("Attendnace No.","Action Type","Real Time","Real Date");
                  HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                  HandPunch.SETRANGE("Real Date",EmpAbs."From Date");
                  HandPunch.SETRANGE("Action Type",'OUT');
                  IF HandPunch.FINDLAST THEN
                  BEGIN
                    IF FORMAT(HandPunch."Scheduled Date")='' THEN
                    BEGIN
                      HandPunch."Scheduled Date":=EmpAbs."From Date";
                      HandPunch.MODIFY;
                    END;
                  END
                  ELSE
                  BEGIN
                    HandPunch.SETRANGE("Attendnace No.","Attendance No.");
                    HandPunch.SETRANGE("Real Date",CALCDATE('+1D',EmpAbs."From Date"));
                    HandPunch.SETRANGE("Action Type",'OUT');
                    IF HandPunch.FINDFIRST THEN
                    BEGIN
                      HandPunchRec.SETCURRENTKEY("Attendnace No.","Action Type","Real Time","Real Date");
                      HandPunchRec.SETRANGE("Attendnace No.","Attendance No.");
                      HandPunchRec.SETRANGE("Real Date",CALCDATE('+1D',EmpAbs."From Date"));
                      HandPunchRec.SETRANGE("Action Type",'IN');
                      IF HandPunchRec.FINDFIRST THEN
                      BEGIN
                        IF HandPunchRec."Real Time">HandPunch."Real Time" THEN
                        BEGIN
                          HandPunch."Scheduled Date":=EmpAbs."From Date";
                          HandPunch.MODIFY;
                        END;
                      END
                      ELSE
                      BEGIN
                        EmpAbs."Invalid Log":=TRUE;
                        EmpAbs.MODIFY;
                      END;
                    END;
                  END;
                
                  EmpAbs.MODIFY;
                UNTIL EmpAbs.NEXT=0;
                  */    // Code-1  Commented - 30.12.2015 : AIM -

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
        HandPunchRec : Record "Hand Punch";
        EDMUtility : Codeunit "EDM Utility";
        PayrollFunctions : Codeunit "Payroll Functions";
}

