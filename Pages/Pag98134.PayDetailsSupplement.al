page 98134 "Pay Details Supplement"
{
    // version PY1.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SaveValues = false;
    SourceTable = "Pay Detail Header";
    SourceTableView = WHERE("Active Employee" = CONST(Active));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PayGroup; PayGroup)
                {
                    Caption = 'Payroll Group';
                    Lookup = true;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        if PAGE.RUNMODAL(0, PayrollGroup) <> ACTION::LookupOK then
                            exit;

                        with PayDetailHeader do begin
                            RESET;
                            SETCURRENTKEY("Payroll Group Code", "Pay Frequency");
                            CALCFIELDS("Active Employee");
                            SETRANGE("Active Employee", "Active Employee"::"Active");

                            SETRANGE("Payroll Group Code", PayrollGroup.Code);
                            SETRANGE("Pay Frequency", PayFreq);
                            SETRANGE("Include in Pay Cycle", true);
                            if not FIND('-') then begin
                                SETRANGE("Pay Frequency");
                                if not FIND('-') then
                                    ERROR('There are no employees in payroll group %1.', PayrollGroup.Code);
                                PayFreq := "Pay Frequency";
                            end;
                        end;

                        RESET;
                        FILTERGROUP(2);
                        CALCFIELDS("Active Employee");
                        SETRANGE("Active Employee", "Active Employee"::"Active");

                        SETRANGE("Payroll Group Code", PayrollGroup.Code);
                        SETRANGE("Pay Frequency", PayFreq);
                        SETRANGE("Include in Pay Cycle", true);
                        FILTERGROUP(0);
                        if not FIND('-') then;
                        PayGroup := PayrollGroup.Code;
                        GetPayStatus(false, 'CALC');
                        CurrPage.PayLines.PAGE.Set(EmpNo);

                        PayStatus.SETRANGE("Payroll Group Code", "Payroll Group Code");
                        PayStatus.SETRANGE("Pay Frequency", "Pay Frequency");
                        if PayStatus.FINDFIRST then
                            PayDate := PayStatus."Supplement Payroll Date";
                    end;

                    trigger OnValidate();
                    begin
                        if USERID <> '' then
                            if not PayUser.GET(PayGroup, USERID) then
                                ERROR('Invalid payroll group.');

                        ///MESSAGE(FORMAT(Status));

                        if PayrollGroup.Code <> PayGroup then
                            if not PayrollGroup.GET(PayGroup) then
                                ERROR('Invalid payroll group.');

                        ////MESSAGE(FORMAT(Status));

                        with PayDetailHeader do begin
                            RESET;
                            SETCURRENTKEY("Payroll Group Code", "Pay Frequency");
                            CALCFIELDS("Active Employee");
                            SETRANGE("Active Employee", "Active Employee"::"Active");
                            SETRANGE("Payroll Group Code", PayGroup);
                            SETRANGE("Pay Frequency", PayFreq);
                            SETRANGE("Include in Pay Cycle", true);
                            if not FIND('-') then begin
                                SETRANGE("Pay Frequency");
                                if not FIND('-') then
                                    ERROR('There are no employees in payroll group %1.', PayGroup);
                                PayFreq := "Pay Frequency";
                            end;
                        end;

                        RESET;
                        CALCFIELDS("Active Employee");
                        ///MESSAGE(FORMAT(Status));
                        FILTERGROUP(2);
                        SETRANGE("Payroll Group Code", PayGroup);
                        SETRANGE("Pay Frequency", PayFreq);
                        SETRANGE("Include in Pay Cycle", true);
                        SETRANGE("Active Employee", "Active Employee"::"Active");
                        FILTERGROUP(0);
                        if not FIND('-') then;
                        PayGroupOnAfterValidate;
                    end;
                }
                field(PayFreq; PayFreq)
                {
                    Caption = 'Pay Frequency';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        PayDetailHeader.RESET;
                        PayDetailHeader.SETCURRENTKEY("Payroll Group Code", "Pay Frequency");
                        PayDetailHeader.SETRANGE("Payroll Group Code", PayGroup);
                        PayDetailHeader.SETRANGE("Pay Frequency", PayFreq);
                        PayDetailHeader.SETRANGE("Include in Pay Cycle", true);
                        if not PayDetailHeader.FIND('-') then
                            ERROR('There are no %1 paid employees.', PayFreq);


                        FILTERGROUP(2);
                        SETRANGE("Payroll Group Code", PayGroup);
                        SETRANGE("Pay Frequency", PayFreq);
                        SETRANGE("Include in Pay Cycle", true);
                        FILTERGROUP(0);
                        FIND('-');
                        PayFreqOnAfterValidate;
                    end;
                }
                field(EmpNo; EmpNo)
                {
                    Caption = 'Employee No.';
                    Lookup = true;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Employee.RESET;
                        Employee.SETCURRENTKEY("Payroll Group Code", "Pay Frequency", "Global Dimension 1 Code");
                        Employee.SETRANGE("Payroll Group Code", PayGroup);
                        Employee.SETRANGE("Pay Frequency", PayFreq);
                        Employee.SETRANGE("Include in Pay Cycle", true);
                        if PAGE.RUNMODAL(PAGE::"Employee List", Employee) <> ACTION::LookupOK then
                            exit;

                        EmpNo := Employee."No.";
                        EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";
                        EmpNoOnAfterValidate;
                    end;

                    trigger OnValidate();
                    var
                        LocalEmpolyee: Record Employee;
                    begin
                        if not GET(EmpNo) then
                            ERROR('The Employee does not Exist within the Filters.');
                        if not "Include in Pay Cycle" then
                            ERROR('The Employee does not exist within the Filters.');
                        if LocalEmpolyee.GET(EmpNo) then
                            EmployeeName := LocalEmpolyee."First Name" + ' ' + LocalEmpolyee."Last Name";
                        EmpNoOnAfterValidate;
                    end;
                }
                field(EmployeeName; EmployeeName)
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    ApplicationArea = All;
                }

                field(ExchangeRate; ExchangeRate)
                {
                    Caption = 'Exchange Rate';
                    DecimalPlaces = 2 : 2;
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        ExchangeRateOnAfterValidate;
                    end;
                }
                field(PayDate; PayDate)
                {
                    Caption = 'Payroll Date';
                    Editable = DisablePayrollDateEditing;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if not CONFIRM('Are you sure you want to change Payroll Date?', false) then
                            ERROR('');
                        //IF PayStatus.GET(PayGroup,PayFreq) THEN
                        //  ValidateTaxPeriod(PayFreq,DATE2DMY(PayDate,2),PayStatus);
                    end;
                }
                field(StartDate; StartDate)
                {
                    Caption = 'Period Start Date';
                    Editable = DisablePayrollDateEditing;
                    NotBlank = true;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if PayStatus."Period Start Date" <> 0D then
                            if not CONFIRM('Are you sure you want to change the Period Start Date?', false) then
                                ERROR('');

                        if PayStatus."Starting Payroll Day" = 0 then
                            ERROR('The "Starting Payroll Day" must be Set first,in Payroll Status Setup.');

                        if DATE2DMY(StartDate, 1) <> PayStatus."Starting Payroll Day" then
                            ERROR('The Period Start DAY must be equal to %1 as defined in Payroll Status Setup.', PayStatus."Starting Payroll Day");
                        StartDateOnAfterValidate;
                    end;
                }
                field(EndDate; EndDate)
                {
                    Caption = 'Period End Date';
                    Editable = DisablePayrollDateEditing;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        EndDateOnAfterValidate;
                    end;
                }
                field("Calculation Required"; "Calculation Required")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

            }
            part(PayLines; "Pay Detail Subform")
            {
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            part(Control1000000015; "Employee Picture")
            {
                SubPageLink = "No." = FIELD("Employee No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(Processing)
        {
            group("Month 13")
            {
                action("Generate Month 13")
                {
                    Caption = 'Generate Month 13';
                    RunObject = Report "Generate Month 13";
                    Image = Insert;
                    ApplicationArea = All;
                }

            }
            group("Generate Payroll")
            {
                Caption = 'Generate Payroll';
                action("Calculate Pay for &Employee")
                {
                    Caption = 'Calculate Pay for &Employee';
                    Image = GeneralLedger;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        GetPayStatus(false, 'CALC');
                        if Employee."No." <> "Employee No." then
                            Employee.GET("Employee No.");

                        if CONFIRM(
                          'Do you wish to Calculate pay for %1 only?', false, Employee.FullName)
                        then
                            CalcEmpPay;
                    end;
                }
                action("Calculate Pay")
                {
                    Caption = 'Calculate Pay for All &Employees';
                    Image = GeneralLedger;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        PayStatus2: Record "Payroll Status";
                    begin

                        GetPayStatusSupplement(false, 'CALC');
                        //IF PayStatus2.GET(PayGroup,PayFreq) THEN   //MB3.0+-
                        //  ValidateTaxPeriod(PayFreq,DATE2DMY(PayDate,2),PayStatus2);  //MB3.0+-
                        if StartDate = 0D then
                            ERROR('Period Start Date must be Entered.');

                        if not CONFIRM(
                          'Do you wish to calculate Pay for period %1 of the %2 Payroll?',
                          false, TaxPeriod, PayFreq)
                        then
                            exit;
                        //MESSAGE("Employee No.");
                        EmpCalculatePay.RUN(PayStatus);
                        //message("Employee No.");
                        EmpNo := "Employee No.";
                        GetPayStatus(true, 'CALC');
                    end;
                }
            }
            group("TEST Finalize")
            {
                Caption = 'TEST Finalize';
                action("TEST Finalize Pay")
                {
                    Caption = 'TEST Finalize Pay';
                    Image = TestDatabase;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        //EDM.JA+
                        FinalizePayroll(true);
                        //EDM.JA-
                    end;
                }
            }
            group("Audit Reports")
            {
                Caption = 'Audit Reports';
                action("Dynamic Report")
                {
                    Image = Report2;
                    RunObject = Report "Dynamic Summary";
                    ApplicationArea = All;
                }
                action("Dynamic Summary List")
                {
                    Image = Report2;
                    RunObject = Report "Dynamic Summary List";
                    ApplicationArea = All;
                }
                action("Dynamic Report Grp by Dim")
                {
                    Image = TaxDetail;
                    RunObject = Report "Dynamic Report Grp by Dim";
                    ApplicationArea = All;
                }
            }
            group("Reports")
            {
                action("PaySlip")
                {
                    Caption = 'Supplement Payslip';
                    Image = Report;
                    RunObject = Report "Supplement Payslip";
                    ApplicationArea = All;
                }

            }
            group("FinalizePay")
            {
                Caption = 'Finalize Pay';
                action("Finalize Pay")
                {
                    Caption = 'Finalize Pay';
                    Image = Approve;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        FinalizePayroll(false);
                        Employee.RESET;
                        CLEAR(Employee);
                        Employee.SETRANGE("Payroll Group Code", PayGroup);
                        Employee.SETRANGE(Status, Employee.Status::Active);
                        Employee.SETFILTER("Termination Date", '<>%1', 0D);
                        if Employee.FINDFIRST then
                            repeat
                                if (StartDate <= Employee."Termination Date") and (Employee."Termination Date" <= EndDate) then begin
                                    Employee.Status := Employee.Status::Terminated;
                                    Employee.MODIFY;
                                end;
                            until Employee.NEXT = 0;
                    end;
                }
            }
        }

    }

    trigger OnAfterGetRecord();
    begin
        EmpNo := "Employee No.";

        CurrPage.PayLines.PAGE.Set(EmpNo);

        SETFILTER("Date Filter", '%1..%2', StartDate, EndDate);
        Employee.GET("Employee No.");
        ExemptTax := Employee."Exempt Tax";
        EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";
    end;

    trigger OnInit();
    begin
        if PayrollFunction.HideSalaryFields() = true then
            if PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' then
                ERROR('No Permission!');
        if USERID <> '' then begin
            HRFunction.SetPayGroupFilter(PayrollGroup);
            PayrollGroup.FILTERGROUP(2);
            FILTERGROUP(2);
            SETFILTER("Payroll Group Code", PayrollGroup.GETFILTER(Code));
            FILTERGROUP(0);
            PayrollGroup.FILTERGROUP(0);
        end;

        CALCFIELDS(Status);
        SETFILTER(Status, '=%1', Status::Active);
        PayParam.GET;
        //EMD.JA+
        if PayParam."Payroll Finalize Type" = PayParam."Payroll Finalize Type"::"By Dimension" then begin
            IsFinalizePayrollAsGeneral := false;
            IsFinalizePayrollByDimension := true;
        end
        else begin
            IsFinalizePayrollAsGeneral := true;
            IsFinalizePayrollByDimension := false;
        end;
        //EDM.JA-
    end;

    trigger OnOpenPage();
    var
        LocalEmployee: Record Employee;
    begin
        PayrollOfficerPermission := PayrollFunction.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');
        //EDM+
        IF PayrollFunction.HideSalaryFields THEN
            ERROR('Access Denied');

        if PayParam."Lock Payroll Date" then
            DisablePayrollDateEditing := false
        else
            DisablePayrollDateEditing := true;

        SETFILTER("Payroll Group Code", PayrollGroup.GETFILTER(Code));

        if EmpNo <> '' then
            if not GET(EmpNo) then
                EmpNo := ''
            else
                if (USERID <> '') and ("Payroll Group Code" <> '') and (not PayUser.GET("Payroll Group Code", USERID)) then
                    EmpNo := ''
                else
                    if not "Include in Pay Cycle" then
                        EmpNo := '';

        if EmpNo <> '' then begin
            PayGroup := "Payroll Group Code";
            PayFreq := "Pay Frequency";
        end;

        if EmpNo = '' then
            if FIND('-') then begin
                PayGroup := "Payroll Group Code";
                PayFreq := "Pay Frequency";
                EmpNo := "Employee No.";
            end else
                ERROR('There are no Employees Set Up.');

        PayStatus.SETRANGE("Payroll Group Code", "Payroll Group Code");
        PayStatus.SETRANGE("Pay Frequency", "Pay Frequency");
        if PayStatus.FINDFIRST then begin
            PayDate := PayStatus."Supplement Payroll Date";
            StartDate := PayStatus."Supplement Start Date";
            EndDate := PayStatus."Supplement End Date";
        end;

        if PayDate = 0D then
            PayDate := WORKDATE;

        GenLedgSetup.GET;
        HumanResSetup.GET;
        if HumanResSetup."Additional Currency Code" <> '' then begin
            CurrExchRate.SETRANGE("Currency Code", HumanResSetup."Additional Currency Code");
            if CurrExchRate.FIND('+') then
                ExchangeRate := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
        end else
            ExchangeRate := 1;
        GetPayStatusSupplement(false, 'CALC');

        if LocalEmployee.GET(EmpNo) then
            EmployeeName := LocalEmployee."First Name" + ' ' + LocalEmployee."Last Name";
        OnActivateForm;

        PayStatus.SETRANGE("Payroll Group Code", "Payroll Group Code");
        PayStatus.SETRANGE("Pay Frequency", "Pay Frequency");
        if PayStatus.FINDFIRST then
            PayDate := PayStatus."Supplement Payroll Date";

    end;

    local procedure FinalizePayroll(IsTestFinalize: Boolean);
    var
        GenJnlLine: Record "Gen. Journal Line";
        PayParam: Record "Payroll Parameter";
    begin
        GetPayStatusSupplement(false, '');

        PayDetailHeader.RESET;
        PayDetailHeader.SETCURRENTKEY("Payroll Group Code", "Pay Frequency");
        PayDetailHeader.SETRANGE("Payroll Group Code", PayGroup);
        PayDetailHeader.SETRANGE("Pay Frequency", PayFreq);
        PayDetailHeader.SETRANGE("Calculation Required", true);
        PayDetailHeader.SETRANGE("Include in Pay Cycle", true);
        if PayDetailHeader.FIND('-') then begin
            CalcReqd := false;
            Employee2.RESET;
            repeat
                if Employee2.GET(PayDetailHeader."Employee No.") then
                    if (Employee2.Status = Employee2.Status::Active) and (Employee2."Employment Date" <= PayDate) then
                        CalcReqd := true;
            until (PayDetailHeader.NEXT = 0) or (CalcReqd);
            if CalcReqd then
                ERROR('Finalise Pay cannot be run until pay has been Calculated for all %1 Employees. ( %2 ) ', PayFreq, Employee2."No.");
        end;

        if StartDate = 0D then
            ERROR('Period Start Date must be entered.');

        if IsTestFinalize = true then begin
            if not CONFIRM('You are about to TEST Finalize Pay.\' + 'Do you want to Continue?', false, PayFreq) then
                exit;
        end
        else begin
            if not CONFIRM('You are about to Finalize Pay.\' + 'Do you want to Continue?', false, PayFreq) then
                exit;
        end;
        PayParam.GET();

        PayDetailHeader.RESET;
        PayDetailHeader.SETRANGE("Payroll Group Code", PayGroup);
        if PayDetailHeader.FINDFIRST = true then
            repeat
                if PayrollFunction.IsValidEmployeePayrollDimension(PayDetailHeader."Employee No.", PayDate, true) = false then begin
                    ERROR('');
                    exit;
                end;
            until PayDetailHeader.NEXT = 0;

        if IsFinalizePayrollByDimension then begin
            FinalizeSupplementPay.FinalizeEmployeePay(PayStatus, not IsTestFinalize, '', true);
            FinalizeSupplementPay.GroupAccountWithDimension;
            FinalizeSupplementPay.GroupAccountWithDimensionBal;
            IF PayParam."Enable Payment Acc. Grouping" THEN
                FinalizeSupplementPay.GroupPaymentAccountWithDimension;
        END
        else
            FinalizeEmpPay.FinalizeEmployeePay(PayStatus, not IsTestFinalize, '');

        if IsTestFinalize = false then
            GetPayStatus(true, 'FINAL');

        if IsTestFinalize = false then
            PayrollFunction.AutoFinalizeEmployeeAttendancePeriod(PayStatus."Payroll Group Code", '');

        if IsFinalizePayrollByDimension = true then begin
            PayParam.GET;
            if PayParam."Delete Temporary Posting Batch" = true then begin
                GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", PayParam."Journal Template Name");
                GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", PayParam."Temp Batch Name");
                if GenJnlLine.FINDFIRST then
                    repeat
                        GenJnlLine.DELETE;
                    until GenJnlLine.NEXT = 0;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", PayParam."Journal Template Name Pay");
                GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", PayParam."Temp Pay Batch Name");
                if GenJnlLine.FINDFIRST then
                    repeat
                        GenJnlLine.DELETE;
                    until GenJnlLine.NEXT = 0;
            end;
        end;
        if IsTestFinalize = true then begin
            MESSAGE('TEST Finalize Process is done');
        end
        else begin
            MESSAGE('Finalize Process is done');
        end;
    end;

    procedure GetPayStatus(P_Modify: Boolean; P_Fct: Code[10]);
    var
        DateExpr: Text[30];
    begin
        HumanResSetup.GET;
        if PayGroup = '' then
            exit;
        PayStatus.RESET;
        if not PayStatus.GET(PayGroup, PayFreq) then begin
            PayStatus.INIT;
            PayStatus."Payroll Group Code" := PayGroup;
            PayStatus."Pay Frequency" := PayFreq;
            PayStatus."Payroll Date" := TODAY;
            PayStatus."Period Start Date" := StartDate;
            PayStatus."Period End Date" := EndDate;
            if HumanResSetup."Additional Currency Code" <> '' then begin
                CurrExchRate.SETRANGE("Currency Code", HumanResSetup."Additional Currency Code");
                if CurrExchRate.FIND('+') then
                    ExchangeRate := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
            end else
                ExchangeRate := 1;
            PayStatus."Exchange Rate" := ExchangeRate;
            DateExpr := '-1M';
            PayStatus."Calculated Payroll Date" := CALCDATE(DateExpr, TODAY);
            PayStatus."Finalized Payroll Date" := CALCDATE(DateExpr, TODAY);
            PayStatus.INSERT;
        end else begin
            PayStatus."Current Tax Period" := DATE2DMY(PayDate, 2);
            PayStatus."Payroll Date" := PayDate;
            PayStatus."Posting Group" := PostGroup;
            PayStatus."Period Start Date" := StartDate;
            PayStatus."Period End Date" := EndDate;
            PayStatus."Exchange Rate" := ExchangeRate;
            if P_Modify = true then begin
                if P_Fct = 'CALC' then begin
                    PayStatus."Calculated Payroll Date" := PayDate;
                    PayStatus."Last Period Calculated" := DATE2DMY(PayDate, 2);
                end else
                    if P_Fct = 'FINAL' then begin
                        PayStatus."Finalized Payroll Date" := PayDate;
                        PayStatus."Last Period Finalized" := DATE2DMY(PayDate, 2);
                    end;
                PayStatus.MODIFY;
            end;
        end;

        TaxPeriod := DATE2DMY(PayDate, 2);
        PostGroup := PayStatus."Posting Group";

        //message(EmpNo);
        if EmpNo = '' then
            FINDFIRST;
        EmpNo := "Employee No.";

        FILTERGROUP(2);
        SETRANGE("Payroll Group Code", PayGroup);
        SETRANGE("Pay Frequency", PayFreq);
        SETRANGE("Include in Pay Cycle", true);
        FILTERGROUP(0);

        //CurrPage.PayLines.FORM.Set(EmpNo);
        CurrPage.UPDATE(false);
    end;

    procedure CalcEmpPay();
    begin
        if StartDate = 0D then
            ERROR('Period Start Date must be Entered.');

        TaxPeriod := DATE2DMY(PayDate, 2);
        //ValidateTaxPeriod(PayFreq,TaxPeriod,PayStatus);

        Employee.GET("Employee No.");
        EmpCalculatePay.CalculateEmployeePay(Employee, PayStatus, true);

        GetPayStatusSupplement(true, 'CALC');
    end;

    local procedure PayFreqOnAfterValidate();
    begin
        GetPayStatus(false, 'CALC');
        PayStatus.SETRANGE("Payroll Group Code", "Payroll Group Code");
        PayStatus.SETRANGE("Pay Frequency", "Pay Frequency");
        if PayStatus.FINDFIRST then
            PayDate := PayStatus."Supplement Payroll Date";

        //PayDate := PayrollFunction.GetNextPayrollDate(PayStatus."Payroll Group Code",PayStatus."Pay Frequency");
    end;

    local procedure EmpNoOnAfterValidate();
    begin
        GET(EmpNo);
        //CurrPage.PayLines.PAGE.Set(EmpNo);
    end;

    local procedure PayGroupOnAfterValidate();
    begin
        GetPayStatus(false, 'CALC');
        //CurrPage.PayLines.PAGE.Set(EmpNo);

        PayStatus.SETRANGE("Payroll Group Code", "Payroll Group Code");
        PayStatus.SETRANGE("Pay Frequency", "Pay Frequency");
        if PayStatus.FINDFIRST then
            PayDate := PayStatus."Supplement Payroll Date";

        //PayDate := PayrollFunction.GetNextPayrollDate(PayStatus."Payroll Group Code",PayStatus."Pay Frequency");
    end;

    local procedure StartDateOnAfterValidate();
    var
        DateExpr: Text[30];
    begin

        if StartDate = 0D then
            ERROR('Period Start Date must be Specified.')
        else begin
            case PayFreq of
                PayFreq::Weekly:
                    DateExpr := '+1W-1D';
                PayFreq::Monthly:
                    DateExpr := '+1M-1D';
            end;
            EndDate := CALCDATE(DateExpr, StartDate);
        end;

        PayStatus.GET(PayGroup, PayFreq);
        PayStatus."Period Start Date" := StartDate;
        PayStatus."Period End Date" := EndDate;
        PayStatus.MODIFY;
    end;

    local procedure EndDateOnAfterValidate();
    begin
        PayStatus.GET(PayGroup, PayFreq);
        PayStatus."Period End Date" := EndDate;
        PayStatus.MODIFY;


        //Period Trx. warning
        if (StartDate <> 0D) and (EndDate <> 0D) then begin
            if PayStatus."Pay Frequency" = PayStatus."Pay Frequency"::"Monthly" then begin
                if ((PayStatus."Ending Payroll Day" <> 0) and
                  (DATE2DMY(EndDate, 1) > PayStatus."Ending Payroll Day") and
                  (DATE2DMY(EndDate, 2) = DATE2DMY(StartDate, 2)))
                 or
                 ((PayStatus."Ending Payroll Day" <> 0) and (DATE2DMY(EndDate, 2) > DATE2DMY(StartDate, 2) + 1))
                 or
                 ((PayStatus."Ending Payroll Day" <> 0) and (DATE2DMY(EndDate, 2) = DATE2DMY(StartDate, 2) + 1) and
                   ((DATE2DMY(StartDate, 1) <= PayStatus."Ending Payroll Day") or
                    (DATE2DMY(EndDate, 1) > PayStatus."Ending Payroll Day")))
                 or
                 ((PayStatus."Ending Payroll Day" = 0) and (DATE2DMY(StartDate, 2) <> DATE2DMY(EndDate, 2))) then
                    if not CONFIRM('The Period End Date Exceeded the Payroll Frequency.\' +
'Finalize Day Frequency = %1.\' +
'Do you wish to Continue ?', true, PayStatus."Ending Payroll Day") then
                        ERROR('');
            end;// monthly
        end; //trx.period
    end;

    local procedure ExchangeRateOnAfterValidate();
    begin
        PayStatus.GET(PayGroup, PayFreq);
        PayStatus."Exchange Rate" := ExchangeRate;
        PayStatus.MODIFY;
    end;

    local procedure ExemptTaxOnAfterValidate();
    begin
        GetPayStatus(false, 'CALC');
    end;

    local procedure OnActivateForm();
    begin
        GET(EmpNo);
    end;

    procedure GetPayStatusSupplement(P_Modify: Boolean; P_Fct: Code[10]);
    var
        DateExpr: Text[30];
    begin
        HumanResSetup.GET;
        if PayGroup = '' then
            exit;
        PayStatus.RESET;
        if not PayStatus.GET(PayGroup, PayFreq) then begin
            PayStatus.INIT;
            PayStatus."Payroll Group Code" := PayGroup;
            PayStatus."Pay Frequency" := PayFreq;
            PayStatus."Supplement Payroll Date" := PayDate;
            PayStatus."Supplement Start Date" := StartDate;
            PayStatus."Supplement End Date" := EndDate;
            PayStatus."Supplement Period" := DATE2DMY(PayDate, 2);
            if HumanResSetup."Additional Currency Code" <> '' then begin
                CurrExchRate.SETRANGE("Currency Code", HumanResSetup."Additional Currency Code");
                if CurrExchRate.FIND('+') then
                    ExchangeRate := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
            end else
                ExchangeRate := 1;
            PayStatus."Exchange Rate" := ExchangeRate;
            DateExpr := '-1M';
            PayStatus."Supplement Payroll Date" := CALCDATE(DateExpr, TODAY);
            PayStatus."Supplement Payroll Date" := CALCDATE(DateExpr, TODAY);
            PayStatus.INSERT;
        end else begin
            PayStatus."Current Tax Period" := DATE2DMY(PayDate, 2);
            PayStatus."Supplement Payroll Date" := PayDate;
            PayStatus."Posting Group" := PostGroup;
            PayStatus."Supplement Start Date" := StartDate;
            PayStatus."Supplement End Date" := EndDate;
            PayStatus."Supplement Period" := DATE2DMY(PayDate, 2);
            PayStatus."Exchange Rate" := ExchangeRate;
            if P_Modify = true then begin
                if P_Fct = 'CALC' then begin
                    PayStatus."Supplement Payroll Date" := PayDate;
                    PayStatus."Supplement Period" := DATE2DMY(PayDate, 2);
                end else
                    if P_Fct = 'FINAL' then begin
                        PayStatus."Supplement Payroll Date" := PayDate;
                        PayStatus."Supplement Period" := DATE2DMY(PayDate, 2);
                    end;
                PayStatus.MODIFY;
            end;
        end;

        TaxPeriod := DATE2DMY(PayDate, 2);
        PostGroup := PayStatus."Posting Group";

        //message(EmpNo);
        if EmpNo = '' then
            FIND('-');
        EmpNo := "Employee No.";

        FILTERGROUP(2);
        SETRANGE("Payroll Group Code", PayGroup);
        SETRANGE("Pay Frequency", PayFreq);
        SETRANGE("Include in Pay Cycle", true);
        FILTERGROUP(0);

        //CurrPage.PayLines.FORM.Set(EmpNo);
        CurrPage.UPDATE(false);
    end;

    var
        Employee: Record Employee;
        Employee2: Record Employee;
        PayParam: Record "Payroll Parameter";
        PayStatus: Record "Payroll Status";
        PayDetailHeader: Record "Pay Detail Header";
        PayDetailLine: Record "Pay Detail Line";
        PayrollGroup: Record "HR Payroll Group";
        PayUser: Record "HR Payroll User";
        EmpCalculatePay: Codeunit "Calculate Supplement";
        PayrollFunction: Codeunit "Payroll Functions";
        PayGroup: Code[10];
        PayFreq: Option Monthly,Weekly;
        DisablePayrollDateEditing: Boolean;
        EmpNo: Code[20];
        TaxPeriod: Integer;

        PayDate: Date;
        PostGroup: Code[10];
        CalcReqd: Boolean;
        PayslipPrintReqd: Boolean;
        StartDate: Date;
        EndDate: Date;
        CurrExchRate: Record "Currency Exchange Rate";
        GenLedgSetup: Record "General Ledger Setup";
        HumanResSetup: Record "Human Resources Setup";
        ExchangeRate: Decimal;
        ExemptTax: Decimal;
        FinalizeSupplementPay: Codeunit "Finalize Supplement";
        FinalizeEmpPay: Codeunit "Finalize Employee Pay";
        HRFunction: Codeunit "Human Resource Functions";
        EmployeeName: Text[65];
        PayrollOfficerPermission: Boolean;
        IsFinalizePayrollAsGeneral: Boolean;
        IsFinalizePayrollByDimension: Boolean;

        HRSetup: Record "Human Resources Setup";
}

