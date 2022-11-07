page 98072 "Employee Deduction Jnl."
{
    // version PY1.0,EDM.HRPY1

    // MEG01.0 --> MB.870 : - Addition of Day-fields to the Journals (non-editable)

    AutoSplitKey = false;
    Caption = 'Deduction Journal';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SaveValues = false;
    SourceTable = "Employee Journal Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(EmployeeNo; EmployeeNo)
                {
                    Caption = 'Employee Np.';
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
                            Rec.SETRANGE(Type, 'DEDUCTIONS');
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
                    Caption = 'Payroll Group Code';
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
                    Caption = 'Employment Type Code';
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
                field("Entry No."; "Entry No.")
                {
                    Caption = 'Entry No.';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    Caption = 'Transaction Date';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Caption = 'Trx.Type';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        //EDM+
                        TransactionTypes.SETRANGE(Type, 'DEDUCTIONS');
                        if PAGE.RUNMODAL(PAGE::"HR Transaction Types", TransactionTypes) = ACTION::LookupOK then begin
                            "Transaction Type" := TransactionTypes.Code;
                            Recurring := TransactionTypes.Recurring;
                        end
                        //EDM-
                    end;
                }
                field(Description; Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(Value; Value)
                {
                    Caption = 'Value';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //EDM+
                        "Calculated Value" := Value;
                        //EDM-
                    end;
                }
                field("Calculated Value"; "Calculated Value")
                {
                    ApplicationArea = All;
                }
                field(Recurring; Recurring)
                {
                    ApplicationArea = All;
                }
                field("Document Status"; "Document Status")
                {
                    Caption = 'Document Status';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Opened By"; "Opened By")
                {
                    Caption = 'Opened By';
                    ApplicationArea = All;
                }
                field("Released By"; "Released By")
                {
                    Caption = 'Released By';
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    Caption = 'Approved By';
                    ApplicationArea = All;
                }
                field("Opened Date"; "Opened Date")
                {
                    Caption = 'Opened Date';
                    ApplicationArea = All;
                }
                field("Released Date"; "Released Date")
                {
                    Caption = 'Released Date';
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    Caption = 'Approved Date';
                    ApplicationArea = All;
                }
                field("Supplement Period"; "Supplement Period")
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
                    ApplicationArea = All;

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
                    ApplicationArea = All;

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
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

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

    trigger OnInit();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if PayrollFunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if TransactionTypes.GET("Transaction Type") then
            Type := TransactionTypes.Type;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        if TransactionTypes.GET("Transaction Type") then
            Type := TransactionTypes.Type;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Transaction Date" := WORKDATE;
        Type := 'DEDUCTIONS';
        GetNewEntryNo();
    end;

    trigger OnOpenPage();
    begin
        HumanResSetup.GET;

        FILTERGROUP := 2;
        SETRANGE("Employee No.", EmployeeNo);
        SETRANGE(Type, 'DEDUCTIONS');
        SETFILTER("Transaction Date", HumanResSetup."Period Filter");
        FILTERGROUP := 0;
        ShowFinalizedValues := false;
        SETFILTER(Processed, '= %1', ShowFinalizedValues);
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
                    if "Transaction Type" <> '' then begin
                        if "Document Status" = "Document Status"::Opened then
                            ERROR('Document is already Opened.');
                        if Processed then
                            ERROR('Cannot Re-Open a Processed DEDUCTIONS Journal Line.');
                        ReOpen_Document();
                    end;
                end;//reopen
            'Release':
                begin
                    if "Transaction Type" <> '' then begin
                        if "Document Status" <> "Document Status"::Opened then
                            ERROR('Only Opened Documents Can be Released !');
                        Release_Document();
                    end;
                end; //release
            'Approve':
                begin
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
        SETRANGE("Employee No.", EmployeeNo);
        SETRANGE(Type, 'DEDUCTIONS');
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

