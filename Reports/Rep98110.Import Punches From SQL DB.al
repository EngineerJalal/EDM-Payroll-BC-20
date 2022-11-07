report 98110 "Import Punches From SQL DB"
{
    // version EDM.HRPY1

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = WHERE(Status=CONST(Active),"Attendance No."=FILTER(<>0),"Employment Type Code"=FILTER(<>''),Period=FILTER(<>''),"Employment Date"=FILTER(<>''));
            RequestFilterFields = "No.","Payroll Group Code","Employment Type Code";

            trigger OnAfterGetRecord();
            begin
                ImportEmpAttendanceFromSQL();
                ValidateEmpAttendanceFromSQL(Employee."No.");
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE('Import Finished Successfully.');
            end;

            trigger OnPreDataItem();
            begin
                //Employee.FILTERGROUP(2);
                Employee.SETFILTER("Full Name",'<>%1','');
                Employee.SETFILTER("Attendance No.",'<>%1',0);
                Employee.SETFILTER(Period,'<>%1',0D);
                Employee.SETFILTER("Employment Date",'<>%1',0D);
                Employee.SETFILTER("Employment Type Code",'<>%1','');
                Employee.SETFILTER(Status,'=%1',Employee.Status::Active);
                Employee.COPYFILTERS(Employee3);
                //Employee.FILTERGROUP(0);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(ReportParam)
                {
                    Caption = 'Report Parameters';
                    field(FDate;FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea=All;
                    }
                    field(TDate;ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea=All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        FromDate : Date;
        ToDate : Date;
        Employee3 : Record Employee;

    procedure SetParameters(var Employee1 : Record Employee);
    begin
        Employee3.COPYFILTERS(Employee1);
    end;

    procedure ImportEmpAttendanceFromSQL() IsImported : Boolean;
    var
        Text006 : TextConst ENU='Import Excel File',ESM='Importar fich. Excel',FRC='Importer fichier Excel',ENC='Import Excel File';
        TempHandPunch : Record "Temp Hand Punch";
        AttendanceData : Record "Machine Attendance Data";
    begin
        /*TempHandPunch.RESET;
        TempHandPunch.DELETEALL;*/
        
        IF (Employee."Attendance No." <= 0) OR (Employee."Full Name" = '') OR (Employee.Period = 0D) OR (Employee."Employment Date" = 0D)
            OR (Employee."Employment Type Code" = '') OR (Employee.Status <> Employee.Status::Active)
         THEN
          CurrReport.SKIP;
        
        CLEAR(TempHandPunch);
        TempHandPunch.SETRANGE(TempHandPunch."Attendnace No.",Employee."Attendance No.");
        TempHandPunch.DELETEALL;
        
        AttendanceData.RESET;
        AttendanceData.SETRANGE("Punch Date",FromDate,ToDate);
        AttendanceData.SETRANGE("User ID",Employee."Attendance No.");
        IF AttendanceData.FINDFIRST THEN
        REPEAT
          CLEAR(TempHandPunch);
          TempHandPunch.INIT;
          TempHandPunch."Attendnace No." := AttendanceData."User ID";
          TempHandPunch."Employee Name" := Employee."Full Name";
          TempHandPunch."Transaction Date" := AttendanceData."Punch Date Time";
          TempHandPunch."Transaction Time2" := AttendanceData."Punch Time";
          TempHandPunch."Action Type" := AttendanceData."Punch Type";
          TempHandPunch.Status := Employee.Status;
          TempHandPunch.INSERT
        UNTIL AttendanceData.NEXT = 0;
        
        EXIT(TRUE);

    end;

    procedure ValidateEmpAttendanceFromSQL(EmployeeNo : Code[20]) IsImported : Boolean;
    var
        UploadedFileName : Text[100];
        TableNo : Integer;
        index : Integer;
        RowNo : Integer;
        RecRef : RecordRef;
        FieldRef : FieldRef;
        cellFound : Boolean;
        i_value : Integer;
        dec_value : Decimal;
        dat_value : Date;
        tim_value : Time;
        b_value : Boolean;
        bi_value : BigInteger;
        //bin_value : Binary[200];
        dattim_value : DateTime;
        datform_value : DateFormula;
        cellValue : Text[262];
        cellValue2 : Text[262];
        J : Integer;
        headerName : Text[50];
        NoOfRecords : Integer;
        Window : Dialog;
        FileName : Text[250];
        SheetName : Text[250];
        ColCount : Integer;
        FileMgt : Codeunit "File Management";
        TxtM : Text;
        TxtD : Text;
        TxtY : Text;
        TxtT : Text;
        Text006 : TextConst ENU='Import Excel File',ESM='Importar fich. Excel',FRC='Importer fichier Excel',ENC='Import Excel File';
        rInd : Integer;
        AttendanceNo : Integer;
        EmpName : Text[100];
        TransDate : DateTime;
        TimeIn : Time;
        TimeOut : Time;
        InitDate : Date;
        NoOfHours : Integer;
        ProjectDim : Text[100];
        BOQ : Text[100];
        LastAttendanceNo : Integer;
        TempHandPunch : Record "Temp Hand Punch";
        MaxRow : Integer;
        LineNo : Integer;
        EmpAbsence : Record "Employee Absence";
        PayrollFunction : Codeunit "Payroll Functions";
        HandPunch : Record "Hand Punch";
        SeparateAttendanceInterval : Boolean;
        PayrollStatus : Record "Payroll Status";
    begin
        LineNo := 0;
        TempHandPunch.RESET;
        TempHandPunch.SETRANGE(Status,TempHandPunch.Status::Active);
        TempHandPunch.SETFILTER("Attendnace No.",'>%1',0);
        IF TempHandPunch.FINDFIRST THEN
        REPEAT
          IF Employee.GET(EmployeeNo) THEN
          BEGIN
            IF (PayrollFunction.CheckIfAttendanceNoExists(TempHandPunch."Attendnace No.") <> '')
              AND (PayrollFunction.CanModifyAttendancePeriod(Employee."No.",Employee.Period,TRUE,FALSE,FALSE,FALSE))
              AND (NOT PayrollFunction.AttendanceRecManuallyModified(Employee."No.",DT2DATE(TempHandPunch."Transaction Date"))) THEN
            BEGIN
              HandPunch.INIT;
              HandPunch."Attendnace No.":=TempHandPunch."Attendnace No.";
              HandPunch.VALIDATE("Date Time",CREATEDATETIME(DT2DATE(TempHandPunch."Transaction Date"),TempHandPunch."Transaction Time2"));
              HandPunch."Employee Name":=TempHandPunch."Employee Name";
              HandPunch."Action Type":=TempHandPunch."Action Type";
              HandPunch."Scheduled Date" := PayrollFunction.FixPunchScheduledDate(EmployeeNo,HandPunch."Real Date",HandPunch."Real Time");
              IF HandPunch."Scheduled Date" = 0D THEN
                HandPunch."Scheduled Date" := HandPunch."Real Date";
              IF HandPunch."Action Type" = '' THEN
                HandPunch."Action Type" := 'IN';
              HandPunch."Modified By" :=  COPYSTR(USERID,1,49);
              HandPunch."Modification Date" := WORKDATE;

              SeparateAttendanceInterval := PayrollFunction.IsSeparateAttendanceInterval(Employee."Payroll Group Code");
              IF NOT SeparateAttendanceInterval THEN
              BEGIN
                IF Employee.Period <= HandPunch."Real Date" THEN
                    HandPunch.INSERT;
              END ELSE BEGIN
                PayrollStatus.SETRANGE("Payroll Group Code",Employee."Payroll Group Code");
                IF PayrollStatus.FINDFIRST THEN
                BEGIN
                  IF (PayrollStatus."Separate Attendance Interval") AND
                     (PayrollStatus."Attendance Start Date" <> 0D) AND
                     (PayrollStatus."Attendance End Date" <> 0D) AND
                     (DATE2DMY(PayrollStatus."Payroll Date",2) = DATE2DMY(PayrollStatus."Attendance End Date",2)) AND
                     (DATE2DMY(PayrollStatus."Payroll Date",3) = DATE2DMY(PayrollStatus."Attendance End Date",3)) THEN
                       IF (HandPunch."Real Date" >=  PayrollStatus."Attendance Start Date") AND
                          (HandPunch."Real Date" <= PayrollStatus."Attendance End Date") THEN
                            HandPunch.INSERT;
                END;
              END;
            END;
          END;
        UNTIL TempHandPunch.NEXT = 0;

        TempHandPunch.DELETEALL;
        PayrollFunction.FixEmployeeDailyAttendanceHours(EmployeeNo,Employee.Period,0D,TRUE,'A0-LA-EL-EA-LL');
    end;
}

