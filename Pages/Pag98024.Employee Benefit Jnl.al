page 98024 "Employee Benefit Jnl."
{
    // version SHR1.0,EDM.HRPY1

    // MEG01.0 --> MB.870 : - Addition of Day-fields to the Journals (non-editable)

    AutoSplitKey = false;
    Caption = 'Benefit Journal';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = Card;
    SaveValues = false;
    SourceTable = "Employee Journal Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("EmployeeNo"; EmployeeNo)
                {
                    Caption = 'Employee No.';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        CurrPage.SAVERECORD;
                        COMMIT;
                        Employee."No." := Rec.GETRANGEMAX("Employee No.");
                        Employee.SETFILTER(Status, '<> Terminated');
                        if PAGE.RUNMODAL(0, Employee) = ACTION::LookupOK then begin
                            EmployeeNo := Employee."No.";
                            Rec.FILTERGROUP := 2;
                            Rec.SETRANGE("Employee No.", EmployeeNo);
                            Rec.SETRANGE(Type, 'BENEFIT');
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
                field("Employee.""First Name"" + ' ' + Employee.""Last Name"""; Employee."First Name" + ' ' + Employee."Last Name")
                {
                    Caption = 'Employee Name';
                    ApplicationArea = All;
                }
                field(PayGroupCode; PayGroupCode)
                {
                    Caption = 'HR Payroll Group Code';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(LevelCode; LevelCode)
                {
                    Caption = 'Employee Category Code';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(GlobalDim1; GlobalDim1)
                {
                    CaptionClass = '1,2,1';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(GlobalDim2; GlobalDim2)
                {
                    CaptionClass = '1,2,2';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Caption = 'Status';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(EmploymentTypeCode; EmploymentTypeCode)
                {
                    Caption = 'Employment Type';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(EmploymentDate; EmploymentDate)
                {
                    Caption = 'Employment Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("<JobTitle>"; JobTitle)
                {
                    Caption = 'Job Title';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(JobPosition; JobPosition)
                {
                    Caption = 'Job Position';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            repeater(TableBoxLines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    Caption = 'Trx.Date';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Caption = 'Trx.Type';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        //EDM+
                        TransactionTypes.SETRANGE(Type, 'BENEFIT');
                        if PAGE.RUNMODAL(PAGE::"HR Transaction Types", TransactionTypes) = ACTION::LookupOK then
                            Rec."Transaction Type" := TransactionTypes.Code;
                        Rec.Recurring := TransactionTypes.Recurring;
                        //EDM-
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Insurance Code"; Rec."Insurance Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Relative Code"; Rec."Relative Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        EmpRel: Record "Employee Relative";
                    begin
                        EmpRel.SETRANGE("Employee No.", Rec."Employee No.");
                        if PAGE.RUNMODAL(80076, EmpRel) = ACTION::LookupOK then
                            Rec."Relative Code" := EmpRel."Relative Code";
                    end;
                }
                field("Medical Allowance Group"; Rec."Medical Allowance Group")
                {
                    Caption = 'Med.Group';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Medical Exams Count"; Rec."Medical Exams Count")
                {
                    Caption = 'Exams';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Exam Date"; Rec."Exam Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    NotBlank = false;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //MB.870
                        FromDateDay := DateTimeMgt.GetDayDate(Rec."Starting Date");
                    end;
                }
                field("DateTimeMgt.GetDayDate(""Starting Date"")"; DateTimeMgt.GetDayDate(Rec."Starting Date"))
                {
                    Caption = 'Starting Day';
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //MB.870
                        ToDateDay := DateTimeMgt.GetDayDate(Rec."Ending Date");
                    end;
                }
                field("DateTimeMgt.GetDayDate(""Ending Date"")"; DateTimeMgt.GetDayDate(Rec."Ending Date"))
                {
                    Caption = 'Ending Day';
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    Caption = 'Value';
                    ApplicationArea = All;
                }
                field("Calculated Value"; Rec."Calculated Value")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }
                field("Room Type"; Rec."Room Type")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        HRPerformance: Record "HR Performance";
                    begin
                        HRPerformance.SETRANGE("Table Name", HRPerformance."Table Name"::"Room Type");
                        if PAGE.RUNMODAL(80046, HRPerformance) = ACTION::LookupOK then
                            Rec."Room Type" := HRPerformance."No.";
                    end;
                }
                field("Room No."; Rec."Room No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Training: Record Training;
                    begin
                        Training.SETRANGE("Table Name", Training."Table Name"::Room);
                        Training.SETRANGE("No.", Rec."Room Type");
                        if PAGE.RUNMODAL(80044, Training) = ACTION::LookupOK then
                            Rec."Room No." := Training."Performance Code";
                    end;
                }
                field("Exit Room"; Rec."Exit Room")
                {
                    ApplicationArea = All;
                }
                field("More Information"; Rec."More Information")
                {
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document Status"; Rec."Document Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Opened By"; Rec."Opened By")
                {
                    ApplicationArea = All;
                }
                field("Released By"; Rec."Released By")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                }
                field("Opened Date"; Rec."Opened Date")
                {
                    ApplicationArea = All;
                }
                field("Released Date"; Rec."Released Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Supplement Period"; Rec."Supplement Period")
                {
                    ApplicationArea = All;
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
                    RunPageLink = "No." = FIELD("Employee No.");
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;
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
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        Rec.MARKEDONLY(true);
                        if Rec.FIND('-') then begin
                            repeat
                                DoFunction('ReOpen');
                            until Rec.NEXT = 0;
                            Rec.MARKEDONLY(false);
                        end else begin
                            Rec.MARKEDONLY(false);
                            DoFunction('ReOpen');
                        end;
                        Rec.CLEARMARKS;
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
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        Rec.MARKEDONLY(true);
                        if Rec.FIND('-') then begin
                            repeat
                                DoFunction('Release');
                            until Rec.NEXT = 0;
                            Rec.MARKEDONLY(false);
                        end else begin
                            Rec.MARKEDONLY(false);
                            DoFunction('Release');
                        end;
                        Rec.CLEARMARKS;
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
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        Rec.MARKEDONLY(true);
                        if Rec.FIND('-') then begin
                            repeat
                                DoFunction('Approve');
                            until Rec.NEXT = 0;
                            Rec.MARKEDONLY(false);
                        end else begin
                            Rec.MARKEDONLY(false);
                            DoFunction('Approve');
                        end;
                        Rec.CLEARMARKS;
                        //shr2.0-
                    end;
                }
                action("Release & Approve")
                {
                    Caption = 'Release & Approve';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        Rec.MARKEDONLY(true);
                        if Rec.FIND('-') then begin
                            repeat
                                DoFunction('Release');
                                DoFunction('Approve');
                            until Rec.NEXT = 0;
                            Rec.MARKEDONLY(false);
                        end else begin
                            Rec.MARKEDONLY(false);
                            DoFunction('Release');
                            DoFunction('Approve');
                        end;
                        Rec.CLEARMARKS;
                        //shr2.0-
                    end;
                }
            }
        }
    }

    trigger OnInit();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if PayrollFunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if TransactionTypes.GET(Rec."Transaction Type") then
            Rec.Type := TransactionTypes.Type;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        if TransactionTypes.GET(Rec."Transaction Type") then
            Rec.Type := TransactionTypes.Type;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec."Transaction Date" := WORKDATE;
        Rec.Type := 'BENEFIT';
        Rec.GetNewEntryNo();
    end;

    trigger OnOpenPage();
    begin
        HumanResSetup.GET;

        Rec.FILTERGROUP := 2;
        Rec.SETRANGE("Employee No.", EmployeeNo);
        Rec.SETRANGE(Type, 'BENEFIT');
        Rec.SETFILTER("Transaction Date", HumanResSetup."Period Filter");
        Rec.FILTERGROUP := 0;

        //Added in order to show only Non-Processed Records - 24.08.2016 : AIM +
        ShowFinalizedValues := false;
        Rec.SETFILTER(Processed, '= %1', ShowFinalizedValues);
        //Added in order to show only Non-Processed Records - 24.08.2016 : AIM -
    end;

    var
        EmployeeNo: Code[20];
        Employee: Record Employee;
        LevelCode: Code[10];
        OldEmployeeNo: Code[20];
        EmploymentTypeCode: Code[20];
        Status: Option Active,Inactive,Terminated;
        FirstName: Text[30];
        LastName: Text[30];
        JobTitle: Text[50];
        JobPosition: Text[50];
        EmploymentDate: Date;
        TransactionTypes: Record "HR Transaction Types";
        GlobalDim1: Code[20];
        GlobalDim2: Code[20];
        PayGroupCode: Code[10];
        HumanResSetup: Record "Human Resources Setup";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        FromDateDay: Text[50];
        ToDateDay: Text[50];
        PayrollFunction: Codeunit "Payroll Functions";
        ShowFinalizedValues: Boolean;

    procedure DoFunction(P_Type: Text[30]);
    begin
        case P_Type of
            'ReOpen':
                begin
                    if Rec."Transaction Type" <> '' then begin
                        if Rec."Document Status" = Rec."Document Status"::Opened then
                            ERROR('Document is already Opened.');
                        if Rec.Processed then
                            ERROR('Cannot Re-Open a Processed Benefit Journal Line.');
                        Rec.ReOpen_Document();
                    end;
                end;//reopen
            'Release':
                begin
                    if Rec."Transaction Type" <> '' then begin
                        if Rec."Document Status" <> Rec."Document Status"::Opened then
                            ERROR('Only Opened Documents Can be Released !');
                        Rec.Release_Document();
                    end;
                end; //release
            'Approve':
                begin
                    if Rec."Transaction Type" <> '' then begin
                        if Rec."Document Status" <> Rec."Document Status"::Released then
                            ERROR('Only Released Documents Can be Approved !');
                        Rec.Approve_Document();
                    end;
                end;//approve
        end; //case
    end;

    local procedure EmployeeNoOnAfterValidate();
    begin
        CurrPage.SAVERECORD;
        Rec.FILTERGROUP := 2;
        Rec.SETRANGE("Employee No.", EmployeeNo);
        Rec.SETRANGE(Type, 'BENEFIT');
        Rec.FILTERGROUP := 0;
        if Rec.FIND('-') then;
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

