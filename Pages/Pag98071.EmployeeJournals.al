page 98071 "Employee Journals"
{
    // version SHR1.0,EDM.HRPY1

    // MEG01.0 --> MB.870 : - Addition of Day-fields to the Journals (non-editable)

    AutoSplitKey = true;
    Caption = 'Benefit Journal';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Employee Journal Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(EmployeeNo;EmployeeNo)
                {
                    Caption = 'Employee No.';
                    ApplicationArea=All;

                    trigger OnLookup(var Text : Text) : Boolean;
                    begin
                        CurrPage.SAVERECORD;
                        COMMIT;
                        Employee."No." := Rec.GETRANGEMAX("Employee No.");
                        Employee.SETFILTER(Status,'<> Terminated');
                        if PAGE.RUNMODAL(0,Employee) = ACTION::LookupOK then begin
                          EmployeeNo := Employee."No.";
                          Rec.FILTERGROUP := 2;
                          Rec.SETRANGE("Employee No.",EmployeeNo);
                          Rec.SETRANGE(Type,'BENEFIT');
                          Rec.FILTERGROUP := 0;
                          if Rec.FIND('-') then;
                        end;
                        CurrPage.UPDATE(false);

                        // get emp.info header
                        if EmployeeNo <> OldEmployeeNo then begin
                          LevelCode := '';
                          if Employee.GET(EmployeeNo) then begin
                            LevelCode := Employee."Employee Category Code";
                            GlobalDim1 := Employee."Global Dimension 1 Code";
                            GlobalDim2 := Employee."Global Dimension 2 Code";
                            Status := Employee.Status;
                            EmploymentTypeCode := Employee."Employment Type Code";
                            FirstName := Employee."First Name";
                            LastName := Employee."Last Name";
                            JobTitle := Employee."Job Title";
                            JobPosition := Employee."Job Position Code";
                            EmploymentDate := Employee."Employment Date";
                            PayGroupCode := Employee."Payroll Group Code";
                          end;
                          OldEmployeeNo := EmployeeNo;
                        end;
                    end;

                    trigger OnValidate();
                    begin
                        Employee.GET(EmployeeNo);
                          EmployeeNoOnAfterValidate;
                    end;
                }
                field("Entry No.";"Entry No.")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Employee.""First Name"" + ' ' + Employee.""Last Name""";Employee."First Name" + ' ' + Employee."Last Name")
                {
                    Caption = 'Employee Name';
                    ApplicationArea=All;
                }
                field(PayGroupCode;PayGroupCode)
                {
                    Caption = 'HR Payroll Group Code';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(LevelCode;LevelCode)
                {
                    Caption = 'Employee Category Code';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(GlobalDim1;GlobalDim1)
                {
                    CaptionClass = '1,2,1';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(GlobalDim2;GlobalDim2)
                {
                    CaptionClass = '1,2,2';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Status;Status)
                {
                    Caption = 'Status';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(EmploymentTypeCode;EmploymentTypeCode)
                {
                    Caption = 'Employment Type';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(EmploymentDate;EmploymentDate)
                {
                    Caption = 'Employment Date';
                    Editable = false;
                    ApplicationArea=All;
                }
                field("<JobTitle>";JobTitle)
                {
                    Caption = 'Job Title';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(JobPosition;JobPosition)
                {
                    Caption = 'Job Position';
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Transaction Date";"Transaction Date")
                {
                    Caption = 'Trx.Date';
                    Editable = true;
                    ApplicationArea=All;
                }
                field("Transaction Type";"Transaction Type")
                {
                    Caption = 'Trx.Type';
                    ApplicationArea=All;

                    trigger OnLookup(var Text : Text) : Boolean;
                    begin
                        //EDM+
                        TransactionTypes.SETRANGE(Type,'BENEFIT');
                        if PAGE.RUNMODAL(PAGE::"HR Transaction Types",TransactionTypes)=ACTION::LookupOK then
                        "Transaction Type":=TransactionTypes.Code;
                        //EDM-
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Insurance Code";"Insurance Code")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Relative Code";"Relative Code")
                {
                    Editable = false;
                    ApplicationArea=All;

                    trigger OnLookup(var Text : Text) : Boolean;
                    var
                        EmpRel : Record "Employee Relative";
                    begin
                        EmpRel.SETRANGE("Employee No.","Employee No.");
                        if PAGE.RUNMODAL(80076,EmpRel) = ACTION::LookupOK then
                          "Relative Code" := EmpRel."Relative Code";
                    end;
                }
                field("Medical Allowance Group";"Medical Allowance Group")
                {
                    Caption = 'Med.Group';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Medical Exams Count";"Medical Exams Count")
                {
                    Caption = 'Exams';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Exam Date";"Exam Date")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Starting Date";"Starting Date")
                {
                    NotBlank = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //MB.870
                        FromDateDay := DateTimeMgt.GetDayDate("Starting Date");
                    end;
                }
                field("DateTimeMgt.GetDayDate(""Starting Date"")";DateTimeMgt.GetDayDate("Starting Date"))
                {
                    Caption = 'Starting Day';
                    ApplicationArea=All;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //MB.870
                        ToDateDay := DateTimeMgt.GetDayDate("Ending Date");
                    end;
                }
                field("DateTimeMgt.GetDayDate(""Ending Date"")";DateTimeMgt.GetDayDate("Ending Date"))
                {
                    Caption = 'Ending Day';
                    ApplicationArea=All;
                }
                field(Value;Value)
                {
                    Caption = 'Value';
                    ApplicationArea=All;
                }
                field("Calculated Value";"Calculated Value")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Currency;Currency)
                {
                    ApplicationArea=All;
                }
                field("Room Type";"Room Type")
                {
                    ApplicationArea=All;

                    trigger OnLookup(var Text : Text) : Boolean;
                    var
                        HRPerformance : Record "HR Performance";
                    begin
                        HRPerformance.SETRANGE("Table Name",HRPerformance."Table Name"::"Room Type");
                        if PAGE.RUNMODAL(80046,HRPerformance) = ACTION::LookupOK then
                          "Room Type" := HRPerformance."No.";
                    end;
                }
                field("Room No.";"Room No.")
                {
                    ApplicationArea=All;

                    trigger OnLookup(var Text : Text) : Boolean;
                    var
                        Training : Record Training;
                    begin
                        Training.SETRANGE("Table Name",Training."Table Name"::Room);
                        Training.SETRANGE("No.","Room Type");
                        if PAGE.RUNMODAL(80044,Training) = ACTION::LookupOK then
                          "Room No." := Training."Performance Code";
                    end;
                }
                field("Exit Room";"Exit Room")
                {
                    ApplicationArea=All;
                }
                field("More Information";"More Information")
                {
                    ApplicationArea=All;
                }
                field(Reversed;Reversed)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Reversed Entry No.";"Reversed Entry No.")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Processed;Processed)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Document Status";"Document Status")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Opened By";"Opened By")
                {
                    ApplicationArea=All;
                }
                field("Released By";"Released By")
                {
                    ApplicationArea=All;
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea=All;
                }
                field("Opened Date";"Opened Date")
                {
                    ApplicationArea=All;
                }
                field("Released Date";"Released Date")
                {
                    ApplicationArea=All;
                }
                field("Approved Date";"Approved Date")
                {
                    ApplicationArea=All;
                }
                field("Supplement Period";"Supplement Period")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Employee Card";
                    RunPageLink = "No."=FIELD("Employee No.");
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea=All;
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(ReOpen)
                {
                    Caption = 'Re&Open';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        MARKEDONLY(true);
                        if FIND('-') then begin
                          repeat
                            DoFunction('ReOpen');
                          until NEXT = 0;
                          MARKEDONLY(false);
                        end else begin
                          MARKEDONLY(false);
                          DoFunction('ReOpen');
                        end;
                        CLEARMARKS;
                        //shr2.0-
                    end;
                }
                action(Release)
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        MARKEDONLY(true);
                        if FIND('-') then begin
                          repeat
                            DoFunction('Release');
                          until NEXT = 0;
                          MARKEDONLY(false);
                        end else begin
                          MARKEDONLY(false);
                          DoFunction('Release');
                        end;
                        CLEARMARKS;
                        //shr2.0-
                    end;
                }
                action(Approve)
                {
                    Caption = '&Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        MARKEDONLY(true);
                        if FIND('-') then begin
                          repeat
                            DoFunction('Approve');
                          until NEXT = 0;
                          MARKEDONLY(false);
                        end else begin
                          MARKEDONLY(false);
                          DoFunction('Approve');
                        end;
                        CLEARMARKS;
                        //shr2.0-
                    end;
                }
                action("Release & Approve")
                {
                    Caption = 'Release & Approve';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        MARKEDONLY(true);
                        if FIND('-') then begin
                          repeat
                            DoFunction('Release');
                            DoFunction('Approve');
                          until NEXT = 0;
                          MARKEDONLY(false);
                        end else begin
                          MARKEDONLY(false);
                          DoFunction('Release');
                          DoFunction('Approve');
                        end;
                        CLEARMARKS;
                        //shr2.0-
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    begin
        if TransactionTypes.GET("Transaction Type") then
          Type := TransactionTypes.Type;
    end;

    trigger OnModifyRecord() : Boolean;
    begin
        if TransactionTypes.GET("Transaction Type") then
          Type := TransactionTypes.Type;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        "Transaction Date" := WORKDATE;
        Type := 'BENEFIT';
        GetNewEntryNo();
    end;

    trigger OnOpenPage();
    begin
        HumanResSetup.GET;

        FILTERGROUP := 2;
        SETRANGE("Employee No.",EmployeeNo);
        SETRANGE(Type,'BENEFIT');
        SETFILTER("Transaction Date",HumanResSetup."Period Filter");
        FILTERGROUP := 0;
    end;

    var
        EmployeeNo : Code[20];
        Employee : Record Employee;
        LevelCode : Code[10];
        OldEmployeeNo : Code[20];
        EmploymentTypeCode : Code[20];
        Status : Option Active,Inactive,Terminated;
        FirstName : Text[30];
        LastName : Text[30];
        JobTitle : Text[50];
        JobPosition : Text[50];
        EmploymentDate : Date;
        TransactionTypes : Record "HR Transaction Types";
        GlobalDim1 : Code[20];
        GlobalDim2 : Code[20];
        PayGroupCode : Code[10];
        HumanResSetup : Record "Human Resources Setup";
        DateTimeMgt : Codeunit "Datetime Mgt.";
        FromDateDay : Text[50];
        ToDateDay : Text[50];

    procedure DoFunction(P_Type : Text[30]);
    begin
        case P_Type of
          'ReOpen' : begin
            if "Transaction Type" <> '' then begin
              if "Document Status" = "Document Status"::Opened then
                ERROR('Document is already Opened.');
              if Processed then
                ERROR('Cannot Re-Open a Processed Benefit Journal Line.');
              ReOpen_Document();
            end;
          end;//reopen
          'Release' : begin
            if "Transaction Type" <> '' then begin
              if "Document Status" <> "Document Status"::Opened then
                ERROR('Only Opened Documents Can be Released !');
              Release_Document();
            end;
          end; //release
          'Approve' : begin
            if "Transaction Type" <> '' then begin
              if "Document Status" <> "Document Status"::Released then
                ERROR('Only Released Documents Can be Approved !');
              Approve_Document();
            end;
          end;//approve
        end; //case
    end;

    local procedure EmployeeNoOnAfterValidate();
    begin
        CurrPage.SAVERECORD;
        FILTERGROUP := 2;
        SETRANGE("Employee No.",EmployeeNo);
        SETRANGE(Type,'BENEFIT');
        FILTERGROUP := 0;
        if FIND('-') then;
        CurrPage.UPDATE(false);
    end;

    local procedure TransactionTypeOnBeforeInput();
    begin
        //shr2.0+
        /*IF TransactionTypes.GET("Transaction Type") THEN
          CurrPage."Transaction Type".UPDATEEDITABLE(NOT TransactionTypes.System);*/
        //shr2.0-

    end;
}

