page 98034 "Employee Absence Jnl."
{
    // version SHR1.0,EDM.HRPY1

    // MEG01.0 --> MB.870 : - Addition of Day-fields to the Journals (non-editable)
    //                      - hide journals of finalized period,with an option to show back old values

    AutoSplitKey = false;
    Caption = 'Attendance Journal';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = Document;
    SaveValues = false;
    SourceTable = "Employee Journal Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(EmployeeNo;EmployeeNo)
                {
                    Caption = 'Employee No.';
                    ApplicationArea=All;

                    trigger OnLookup(var Text : Text) : Boolean;
                    begin
                        //CurrForm.SAVERECORD;
                        //COMMIT;
                        //Employee."No." := Rec.GETRANGEMAX("Employee No.");
                        Employee.SETFILTER(Status,'<> Terminated');
                        if PAGE.RUNMODAL(0,Employee) = ACTION::LookupOK then begin
                          EmployeeNo := Employee."No.";
                          Rec.FILTERGROUP := 2;
                          Rec.RESET;
                          Rec.SETRANGE("Employee No.",EmployeeNo);
                          Rec.SETRANGE(Type,'ABSENCE');
                          if not ShowZeroValues then
                            Rec.SETFILTER(Value,'<>0');
                            Rec.SETFILTER("Transaction Date",HumanResSetup."Period Filter");
                          Rec.FILTERGROUP := 0;
                          if Rec.FIND('+') then;
                          if Rec.FIND('-') then;
                          if Rec.FIND('+') then;

                        end;
                        CurrPage.UPDATE(false);

                        //get emp.info header
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

                        //get emp.info header
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
                        if not ShowFinalizedValues then
                          Rec.SETRANGE(Processed,ShowFinalizedValues)
                        else
                          Rec.SETRANGE(Processed);
                        if Rec.FIND('+') then;
                        if Rec.FIND('-') then;
                        if Rec.FIND('+') then;
                        //MB.870-
                          EmployeeNoOnAfterValidate;
                    end;
                }
                field("Employee.""First Name"" + Employee.""Last Name""";Employee."First Name" + Employee."Last Name")
                {
                    Caption = 'Employee Name';
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        EmployeeFirstNameOnAfterValida;
                    end;
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
                field("<ShowZeroValues>";ShowZeroValues)
                {
                    Caption = 'Show Zero Values';
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        if not ShowZeroValues then
                          Rec.SETFILTER(Value,'<>0')
                        else
                          Rec.SETFILTER(Value,'') ;
                    end;
                }
                field("<ShowFinalizedValues>";ShowFinalizedValues)
                {
                    Caption = 'Show Lines of Finalized Period';
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //MB.870+
                        if not ShowFinalizedValues then
                          Rec.SETRANGE(Processed,ShowFinalizedValues)
                        else
                          Rec.SETRANGE(Processed);
                        //MB.870-
                          ShowFinalizedValuesOnAfterVali;
                    end;
                }
            }
            repeater(Control1)
            {
                field("Entry No.";Rec."Entry No.")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Transaction Date";Rec."Transaction Date")
                {
                    Caption = 'Trx.Date';
                    ApplicationArea=All;
                }
                field("Cause of Absence Code";Rec."Cause of Absence Code")
                {
                    Caption = 'Cause of Attendance Code';
                    ApplicationArea=All;
                }
                field("Unit of Measure Code";Rec."Unit of Measure Code")
                {
                    ApplicationArea=All;
                }
                field("Starting Date";Rec."Starting Date")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //MB.870
                        //EDM.MG.Code Disable due to Upgrade 2013
                        FromDateDay := DateTimeMgt.GetDayDate(Rec."Starting Date");
                    end;
                }
                field("DateTimeMgt.GetDayDate(""Starting Date"")";DateTimeMgt.GetDayDate(Rec."Starting Date"))
                {
                    Caption = 'Starting Day';
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Ending Date";Rec."Ending Date")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //MB.870
                        //EDM.MG.Code Disable due to Upgrade 2013
                        ToDateDay := DateTimeMgt.GetDayDate(Rec."Ending Date");
                    end;
                }
                field("DateTimeMgt.GetDayDate(""Ending Date"")";DateTimeMgt.GetDayDate(Rec."Ending Date"))
                {
                    Caption = 'Ending Day';
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Swap To Shortcut Dim 1 Code";Rec."Swap To Shortcut Dim 1 Code")
                {
                    ApplicationArea=All;
                }
                field("From Time";Rec."From Time")
                {
                    ApplicationArea=All;
                }
                field("To Time";Rec."To Time")
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 2 Code";Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 1 Code";Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea=All;
                }
                field(Value;Rec.Value)
                {
                    Caption = 'Value';
                    ApplicationArea=All;
                }
                field("Calculated Value";Rec."Calculated Value")
                {
                    ApplicationArea=All;
                }
                field(Recurring;Rec.Recurring)
                {
                    ApplicationArea=All;
                }
                field("Rounding of Calculated Value";Rec."Rounding of Calculated Value")
                {
                    ApplicationArea=All;
                }
                field("Rounding Addition";Rec."Rounding Addition")
                {
                    ApplicationArea=All;
                }
                field("More Information";Rec."More Information")
                {
                    ApplicationArea=All;
                }
                field("Absence Phone No.";Rec."Absence Phone No.")
                {
                    ApplicationArea=All;
                }
                field("Absence Address";Rec."Absence Address")
                {
                    ApplicationArea=All;
                }
                field("Document Status";Rec."Document Status")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Opened By";Rec."Opened By")
                {
                    ApplicationArea=All;
                }
                field("Released By";Rec."Released By")
                {
                    ApplicationArea=All;
                }
                field("Approved By";Rec."Approved By")
                {
                    ApplicationArea=All;
                }
                field("Opened Date";Rec."Opened Date")
                {
                    ApplicationArea=All;
                }
                field("Released Date";Rec."Released Date")
                {
                    ApplicationArea=All;
                }
                field("Approved Date";Rec."Approved Date")
                {
                    ApplicationArea=All;
                }
                field("Reseted Value";Rec."Reseted Value")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Entitled Value";Rec."Entitled Value")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Converted Value";Rec."Converted Value")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Affect Attendance Days";Rec."Affect Attendance Days")
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
            group("&Line")
            {
                Caption = '&Line';
                action("&Dimensions")
                {
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    //Stopped by EDM.MM RunPageLink = "Table ID"=CONST(17373),"Dimension Code"=FIELD("Employee No."),"Dimension Value Code"=FIELD("Entry No.");
                    ShortCutKey = 'Shift+Ctrl+D';
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
                    ApplicationArea=All;

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
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        if CONFIRM(
                          'Do you wish to Make Release for All Journal lines?')
                        then  begin
                          if Rec.FIND('-') then
                            repeat
                            if Rec."Document Status" = Rec."Document Status"::Opened then
                              DoFunction('Release');
                            until Rec.NEXT = 0;
                        end
                        else begin
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
                        end;
                        //shr2.0-
                    end;
                }
                action(Approve)
                {
                    Caption = '&Approve';
                    Image = Approve;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        //shr2.0+
                        if CONFIRM(
                          'Do you wish to Make Approve for All Journal lines?')
                        then  begin
                            if Rec.FIND('-') then
                              repeat
                                if Rec."Document Status" = Rec."Document Status"::Released then
                                DoFunction('Approve');
                              until Rec.NEXT = 0;
                        end
                        else  begin
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
                        end;
                        //shr2.0-
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        Rec.Type := 'ABSENCE';
        TransactionTypes.SETRANGE(Type,'ABSENCE');
        if TransactionTypes.FIND('-') then
          Rec."Transaction Type" := TransactionTypes.Code;
        //MB.870+
        if not ShowFinalizedValues then
          Rec.SETRANGE(Processed,ShowFinalizedValues)
        else
          Rec.SETRANGE(Processed);
        //MB.870-
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        Rec."Transaction Date" := WORKDATE;
        Rec.Type := 'ABSENCE';
        TransactionTypes.SETRANGE(Type,'ABSENCE');
        if TransactionTypes.FIND('-') then
          begin
            Rec."Transaction Type" := TransactionTypes.Code;
            Rec.Recurring := TransactionTypes.Recurring;
            //VALIDATE("Transaction Type");
          end;
    end;

    trigger OnOpenPage();
    begin
        HumanResSetup.GET;

        Rec.FILTERGROUP := 2;
        Rec.SETRANGE("Employee No.",EmployeeNo);
        Rec.SETRANGE(Type,'ABSENCE');
        if not ShowZeroValues then
          Rec.SETFILTER(Value,'<>0');
        Rec.SETFILTER("Transaction Date",HumanResSetup."Period Filter");
        Rec.FILTERGROUP := 0;
        //MB.870+
        ShowFinalizedValues := false;
        Rec.SETFILTER(Processed,'= %1',ShowFinalizedValues);
        //MB.870-
    end;

    var
        EmployeeNo : Code[20];
        Employee : Record Employee;
        LevelCode : Code[10];
        OldEmployeeNo : Code[20];
        DepartmentCode : Code[10];
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
        ShowZeroValues : Boolean;
        FromDateDay : Text[50];
        ToDateDay : Text[50];
        DateTimeMgt : Codeunit "Datetime Mgt.";
        ShowFinalizedValues : Boolean;
        PayrollFunctions : Codeunit "Payroll Functions";

    procedure DoFunction(P_Type : Text[30]);
    begin
        case P_Type of
          'ReOpen' : begin
            if Rec."Transaction Type" <> '' then begin
              if Rec."Document Status" = Rec."Document Status"::Opened then
                ERROR('Document is already Opened.');
              if Rec.Converted then
                ERROR('Cannot Re-Open a Converted Attendance Journal Line.');
              if Rec.Entitled then
                ERROR('Cannot Re-Open an Entitled Attendance Journal Line.');
              if Rec.Reseted then
                ERROR('Cannot Re-Open a Reseted Attendance Journal Line.');
              if Rec.Processed then
                ERROR('Cannot Re-Open a Processed Attendance Journal Line.');
              if Rec.Value = 0 then
                ERROR('Cannot Re-Open a Journal Line that has been Generated Automatically');
              if Rec."Converted Value" <> 0 then
                ERROR('Cannot Re-Open a Partially Converted Journal Line');
              Rec.ReOpen_Document();
            end;
          end;//reopen
          'Release' : begin
            if Rec."Transaction Type" <> '' then begin
              if Rec."Document Status" <> Rec."Document Status"::Opened then
                ERROR('Only Opened Documents Can be Released !');
              Rec.Release_Document();
            end;
          end; //release
          'Approve' : begin
            if Rec."Transaction Type" <> '' then begin
              if Rec."Document Status" <> Rec."Document Status"::Released then
                ERROR('Only Released Documents Can be Approved !');
              Rec.Approve_Document();
            end;
          end;//approve
        end; //case

        //Added in order to update totals in Employee Absence Entitlements - 04.06.2016 : AIM +
        PayrollFunctions.UpdateEmpEntitlementTotals(Rec."Transaction Date",Rec."Employee No.");
        //Added in order to update totals in Employee Absence Entitlements - 04.06.2016 : AIM -
    end;

    local procedure EmployeeNoOnAfterValidate();
    begin
        CurrPage.SAVERECORD;
        Rec.FILTERGROUP := 2;
        Rec.RESET;
        Rec.SETRANGE("Employee No.",EmployeeNo);
        Rec.SETRANGE(Type,'ABSENCE');
        if not ShowZeroValues then
          Rec.SETFILTER(Value,'<>0');
        Rec.SETFILTER("Transaction Date",HumanResSetup."Period Filter");
        Rec.FILTERGROUP := 0;
        if Rec.FIND('+') then;
        if Rec.FIND('-') then;
        if Rec.FIND('+') then;
        CurrPage.UPDATE(false);
    end;

    local procedure EmployeeFirstNameOnAfterValida();
    begin
        CurrPage.UPDATE(false);
    end;

    local procedure ShowFinalizedValuesOnAfterVali();
    begin
        CurrPage.UPDATE(false);
    end;

    local procedure CalculatedValueOnBeforeInput();
    begin
        //CurrPage."Calculated Value".UPDATEEDITABLE((NOT Converted) AND (NOT Entitled) AND (NOT Reseted) AND (Value <> 0));
    end;
}

