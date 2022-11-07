codeunit 98004 "EDM Web Portal"
{/*
  trigger OnRun();
  begin
  end;

  procedure CreateLeaveRequest("Request Type" : Option Leave,Overtime,EarlyLeave,EarlyArrive,LateArrive;"Leave Request No" : Code[20];"Employee No" : Code[20];"Requested By" : Code[20];"Alternative Employee No" : Code[20];"Demand Date" : DateTime;"From Date" : DateTime;"To Date" : DateTime;Reason : Text[100];"Leave Type" : Code[10];Remark : Text[100];"Number Days" : Decimal;Hours : Decimal) Result : Boolean;
  var
      lLeaveRequest : Record "Leave Request";
  begin
    lLeaveRequest.RESET;
    lLeaveRequest.SETCURRENTKEY("Request Type","Employee No.","Leave Request No.");
    lLeaveRequest.SETCURRENTKEY("Employee No.","Leave Request No.");
    lLeaveRequest.SETRANGE(lLeaveRequest."Request Type","Request Type");
    lLeaveRequest.SETRANGE(lLeaveRequest."Employee No.","Employee No");
    lLeaveRequest.SETRANGE(lLeaveRequest."Leave Request No.","Leave Request No");

    if not lLeaveRequest.FINDFIRST then begin
      lLeaveRequest.INIT;
      lLeaveRequest."Request Type" := "Request Type";
      lLeaveRequest."Employee No." := "Employee No";
      lLeaveRequest."Leave Request No." := "Leave Request No";
      lLeaveRequest.INSERT;
    end;

    lLeaveRequest."Employee No." := "Employee No";
    lLeaveRequest."Requested By" := "Requested By";
    lLeaveRequest."Alternative Employee No." := "Alternative Employee No";
    lLeaveRequest."Leave Type" := "Leave Type";
    lLeaveRequest.Reason := Reason;
    lLeaveRequest.Remark := Remark;
    lLeaveRequest."Demand Date" := DT2DATE("Demand Date");
    lLeaveRequest."From Date" := DT2DATE("From Date");
    lLeaveRequest."From Time" := DT2TIME("From Date");
    lLeaveRequest."To Date" := DT2DATE("To Date");
    lLeaveRequest."To Time" := DT2TIME("To Date");
    lLeaveRequest."Days Value" := "Number Days";
    lLeaveRequest."Hours Value" := Hours;
    Result := lLeaveRequest.MODIFY;

    exit(Result);
  end;

  procedure GenrateEmpJrnlFromLeaveRequest();
  var
    lEmpJrnlLine : Record "Employee Journal Line";
    lLeaveRequest : Record "Leave Request";
    lPayStatus : Record "Payroll Status";
    lEmployee : Record Employee;
    lPayEndDate : Date;
    lPayrollFunctions : Codeunit "Payroll Functions";
  begin
    lLeaveRequest.RESET;
    lLeaveRequest.SETRANGE(lLeaveRequest.Status,lLeaveRequest.Status::Open);
    if lLeaveRequest.FindFirst then repeat
      if (lLeaveRequest."Days Value" > 0) then begin
        if lEmployee.GET(lLeaveRequest."Employee No.") then
          if lPayStatus.GET(lEmployee."Payroll Group Code") then begin
            lPayEndDate := lPayrollFunctions.GetPeriodEndDate(lPayStatus);
            if (lLeaveRequest."From Date" > lPayStatus."Finalized Payroll Date") and 
               (lLeaveRequest."From Date" <= lPayEndDate) then begin
              lEmpJrnlLine.INIT;
              lEmpJrnlLine.VALIDATE("Employee No." ,lLeaveRequest."Employee No.");
              lEmpJrnlLine."Transaction Type":='ABS';
              lEmpJrnlLine.VALIDATE("Cause of Absence Code",lLeaveRequest."Leave Type");
              lEmpJrnlLine."Transaction Date" := lLeaveRequest."From Date";
              lEmpJrnlLine."Starting Date":= lLeaveRequest."From Date";
              lEmpJrnlLine."Ending Date"  := lLeaveRequest."To Date";
              lEmpJrnlLine.Type:='ABSENCE';
              lEmpJrnlLine.Description:= lLeaveRequest.Reason;
              lEmpJrnlLine.Value:= lLeaveRequest."Days Value";
              lEmpJrnlLine."Calculated Value":= lLeaveRequest."Days Value";
              lEmpJrnlLine."Document Status":= lEmpJrnlLine."Document Status"::Approved;
              lEmpJrnlLine.INSERT(true);
            end;
          end;
      end;
    until lLeaveRequest.NEXT = 0;
  end;

  procedure GenerateDynamicPayslipReport(EmployeeNo : Code[20];FromDate : Date;ToDate : Date) : Text;
  var
    DynamicPayslipReport : Report "Dynamic Payslip";
    FileManagement : Codeunit "File Management";
    ServerAttachmentFilePath : Text;
    HRSetup : Record "Human Resources Setup";
    DynamicPayslipWeb : Report "Web Payslip";
  begin
    HRSetup.GET();
    if HRSetup."Web Temp Path" <> '' then
      ServerAttachmentFilePath := FORMAT(HRSetup."Web Temp Path") + '\SLT' + FORMAT(CONVERTSTR(FORMAT(EmployeeNo),'-','9')) + '.pdf'
    else
      ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

    DynamicPayslipWeb.SetWebParameters(EmployeeNo,FromDate,ToDate);
    DynamicPayslipWeb.SAVEASPDF(ServerAttachmentFilePath);
    CLEAR(DynamicPayslipWeb);

    if not EXISTS(ServerAttachmentFilePath) then
      exit('');

    exit(ServerAttachmentFilePath);
  end;

  procedure GeneratePurchaseRequestNo() : Code[20];
  var
    PurchaseSetup : Record "Purchases & Payables Setup";
    NoSeriesMgt : Codeunit NoSeriesManagement;
  begin
    /*
    PurchaseSetup.GET;
    PurchaseSetup.TESTFIELD(PurchaseSetup."Purchase Request Nos.");
    EXIT(NoSeriesMgt.GetNextNo(PurchaseSetup."Purchase Request Nos.",WORKDATE,TRUE));
    */
  //end;
/*
  procedure CreatePurchaseRequest(PRNo : Code[20];PRDate : Date;PRStatus : Integer;PRRequester : Code[50];GlobalDim1 : Code[20];GlobalDim2 : Code[20];PRCurrency : Code[10];PRApproverId : Code[50];TypeofRequest : Integer) : Boolean;
  begin
    /*
    PurchaseRequestHeader.SETRANGE("No.",PRNo);
    IF NOT PurchaseRequestHeader.FINDFIRST THEN BEGIN
      PurchaseRequestHeader.INIT;
      PurchaseRequestHeader.VALIDATE("No.",PRNo);
      PurchaseRequestHeader.INSERT(TRUE);
    END;
    
    PurchaseRequestHeader.SetPortalVariables;
    
    PurchaseRequestHeader.VALIDATE(Date,PRDate);
    PurchaseRequestHeader.VALIDATE(Status,PRStatus);
    PurchaseRequestHeader.VALIDATE(Requester,PRRequester);
    PurchaseRequestHeader.VALIDATE("Global Dimension 1 Code",GlobalDim1);
    PurchaseRequestHeader.VALIDATE("Global Dimension 2 Code",GlobalDim2);
    PurchaseRequestHeader.VALIDATE("Currency Code",PRCurrency);
    PurchaseRequestHeader.VALIDATE("Approver ID",PRApproverId);
    PurchaseRequestHeader.VALIDATE("Type Of Request",TypeofRequest);
    
    EXIT(PurchaseRequestHeader.MODIFY(TRUE));*/
  //end;

  procedure CreatePurchaseRequestLine(DocumentNo : Code[20];LineNo : Integer;ItemCategory : Code[20];LineDescription : Text[50];UnitOfMeasure : Code[10];Qty : Decimal;Cost : Decimal;LineRemark : Text[50];GlobalDim1 : Code[20];GlobalDim2 : Code[20];LineReason : Text[50];ShortcutDim3 : Code[20];ShortcutDim4 : Code[20];ShortcutDim5 : Code[20];ShortcutDim6 : Code[20];ShortcutDim7 : Code[20];ShortcutDim8 : Code[20]) : Boolean;
  var
      OnEditMode : Boolean;
  begin
    /*IF LineNo = -1 THEN BEGIN
      PurchaseRequestLine.SETRANGE("Document No.",DocumentNo);
      IF PurchaseRequestLine.FINDLAST THEN
        LineNo := PurchaseRequestLine."Line No." + 1
      ELSE
        LineNo := 0;
    
      PurchaseRequestLine.RESET;
      PurchaseRequestLine.INIT;
      PurchaseRequestLine.VALIDATE("Document No.",DocumentNo);
      PurchaseRequestLine.VALIDATE("Line No.",LineNo);
      PurchaseRequestLine.INSERT(TRUE);
    END
    ELSE BEGIN
      PurchaseRequestLine.SETRANGE("Document No.",DocumentNo);
      PurchaseRequestLine.SETRANGE("Line No.",LineNo);
    
      IF NOT PurchaseRequestLine.FINDFIRST THEN
        EXIT(FALSE);
    END;
    
    PurchaseRequestLine.VALIDATE("Unit of Measure Code",UnitOfMeasure);
    //PurchaseRequestLine.VALIDATE("Budget Item Category",ItemCategory);
    PurchaseRequestLine.VALIDATE(Description,LineDescription);
    PurchaseRequestLine.VALIDATE(Quantity,Qty);
    PurchaseRequestLine.VALIDATE("Expected unit cost",Cost);
    PurchaseRequestLine.VALIDATE(Remark,LineRemark);
    //PurchaseRequestLine.VALIDATE("Shortcut Dimension 1 Code",GlobalDim1);
    //PurchaseRequestLine.VALIDATE("Shortcut Dimension 2 Code",GlobalDim2);
    PurchaseRequestLine.VALIDATE(Reason,LineReason);
    PurchaseRequestLine.VALIDATE("Shortcut Dimension 3 Code",ShortcutDim3);
    PurchaseRequestLine.VALIDATE("Shortcut Dimension 4 Code",ShortcutDim4);
    PurchaseRequestLine.VALIDATE("Shortcut Dimension 5 Code",ShortcutDim5);
    PurchaseRequestLine.VALIDATE("Shortcut Dimension 6 Code",ShortcutDim6);
    PurchaseRequestLine.VALIDATE("Shortcut Dimension 7 Code",ShortcutDim7);
    PurchaseRequestLine.VALIDATE("Shortcut Dimension 8 Code",ShortcutDim8);
    
    EXIT(PurchaseRequestLine.MODIFY(TRUE));*/
  end;

  procedure DeletePurchaseRequest(PRNo : Code[20]) : Boolean;
  begin
    /*
    IF PurchaseRequestHeader.GET(PRNo) THEN
      EXIT(PurchaseRequestHeader.DELETE(TRUE));
    */
  end;

  procedure DeletePurchaseRequestLine(PRNo : Code[20];LineNo : Integer) : Boolean;
  begin
    /*
    IF PurchaseRequestLine.GET(PRNo,LineNo) THEN
      EXIT(PurchaseRequestLine.DELETE(TRUE));
    */
  end;

  procedure SendPRApprovalRequest(PRNo : Code[20]) : Boolean;
  var
      WorkflowManagment : Codeunit "Workflow Management";
  begin
    /*
    IF PurchaseRequestHeader.GET(PRNo) THEN
      BEGIN
        PurchaseRequestHeader.TESTFIELD(Status,PurchaseRequestHeader.Status::Open);
        PurchaseRequestLine.SETRANGE("Document No.",PRNo);
        IF NOT PurchaseRequestLine.FINDFIRST THEN
          ERROR('You have to enter your request description in the purchase request line to send approval request');
    
        WorkflowManagment.HandleEvent(UPPERCASE('SendApprovalReq'),PurchaseRequestHeader);
        EXIT(TRUE);
      END;
    */
  end;

  procedure CreateRecordLink(PurchaseRequestNo : Code[20];Description : Text;URL : Text;CompanyName : Text;UserID : Text) : Text;
  var
      RecordLink : Record "Record Link";
      LinkId : Integer;
  begin
    /*
    IF NOT PurchaseRequest.GET(PurchaseRequestNo) THEN
      EXIT('Does not exist Purchase Request with No: ' + PurchaseRequestNo);
    
    IF RecordLink.FINDLAST THEN
      LinkId := RecordLink."Link ID" + 1;
    
    RecordLink.INIT;
    RecordLink."Link ID" := LinkId;
    RecordLink."Record ID" := PurchaseRequest.RECORDID;
    RecordLink.URL1 := URL;
    RecordLink.Description := Description;
    RecordLink.Type := RecordLink.Type::Link;
    RecordLink.Company := CompanyName;
    RecordLink."User ID" := UserID;
    
    IF RecordLink.INSERT(TRUE) THEN
      EXIT('Success')
    ELSE
      EXIT('Failed');
    */
  end;

  procedure GetUploadFolderPath() : Text;
  var
    PurchaseSetup : Record "Purchases & Payables Setup";
  begin
    //PurchaseSetup.GET;
    //EXIT(PurchaseSetup."Web Portal Upload Path");
  end;

  procedure DeleteRecordLink(LinkID : Integer) : Boolean;
  var
    RecordLink : Record "Record Link";
  begin
    if RecordLink.GET(LinkID) then
      exit(RecordLink.DELETE(true));
  end;

  procedure CheckNAVConnection() : Boolean;
  begin
    exit(true);
  end;

  procedure GetEntitlementTillToday(EmployeeNo : Code[20];LeaveType : Code[10];FromDate : Date) V : Decimal;
  var
  PayrollFunctions : Codeunit "Payroll Functions";
  IntervalType : Option Month,Day;
  EmployeeAbsenceEntitlement : Record "Employee Absence Entitlement";
  Employee : Record Employee;

  begin
    Employee.Get(EmployeeNo);
    EmployeeAbsenceEntitlement.SETCURRENTKEY("Till Date");
    EmployeeAbsenceEntitlement.SETRANGE("Employee No.",EmployeeNo);
    EmployeeAbsenceEntitlement.SETRANGE("Cause of Absence Code",LeaveType);
    IF EmployeeAbsenceEntitlement.FINDLAST THEN BEGIN
      FromDate := EmployeeAbsenceEntitlement."From Date";
      IF WORKDATE >= EmployeeAbsenceEntitlement."Till Date" THEN
        EXIT(0)
      ELSE BEGIN
        if Employee."AL Starting Date" <> 0D then
          FromDate := Employee."AL Starting Date"
        else 
          FromDate := Employee."Employment Date";

        if FromDate < EmployeeAbsenceEntitlement."From Date" then
          FromDate := EmployeeAbsenceEntitlement."From Date";
IF WORKDATE > FromDate THEN BEGIN
          V := ROUND((((WORKDATE - FromDate) + 1) * EmployeeAbsenceEntitlement.Entitlement ) / 
                    (EmployeeAbsenceEntitlement."Till Date" - FromDate + 1),0.01);
          V += EmployeeAbsenceEntitlement."Transfer from Previous Year" + EmployeeAbsenceEntitlement."Manual Additions" + EmployeeAbsenceEntitlement."Attendance Additions" - 
              EmployeeAbsenceEntitlement."Manual Deductions" - EmployeeAbsenceEntitlement.Taken - EmployeeAbsenceEntitlement."Attendance Deductions";
          EXIT(V);
        END ELSE EXIT(0);
      END;
    END;   
  end;
}