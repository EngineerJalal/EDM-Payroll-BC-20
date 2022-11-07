page 98064 "Pay Details"
{
    // version PY1.0,EDM.HRPY1

    // //MB3.0 : Fix Problem of Description And payroll period after finalizing old period directly
    PageType = Card;
    Permissions = TableData "Employee Loan Line" = rimd;
    SourceTable = "Pay Detail Header";
    SaveValues = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = WHERE(Status = CONST(Active));

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
                            CALCFIELDS(Status);
                            SETRANGE(Status, Status::Active);

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
                        CALCFIELDS(Status);
                        SETRANGE(Status, Status::Active);

                        SETRANGE("Payroll Group Code", PayrollGroup.Code);
                        SETRANGE("Pay Frequency", PayFreq);
                        SETRANGE("Include in Pay Cycle", true);
                        FILTERGROUP(0);
                        if not FIND('-') then;
                        PayGroup := PayrollGroup.Code;
                        GetPayStatus(false, 'CALC');
                        CurrPage.PayLines.PAGE.Set(EmpNo);
                        PayDate := PayrollFunction.GetNextPayrollDate(PayStatus."Payroll Group Code", PayStatus."Pay Frequency");

                        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
                        SetDefaultStartDate();
                        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -

                        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting+
                        SetPermissionForPayActions();
                        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting
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
                            CALCFIELDS(Status);
                            SETRANGE(Status, Status::Active);
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
                        CALCFIELDS(Status);
                        ///MESSAGE(FORMAT(Status));
                        FILTERGROUP(2);
                        SETRANGE("Payroll Group Code", PayGroup);
                        SETRANGE("Pay Frequency", PayFreq);
                        SETRANGE("Include in Pay Cycle", true);
                        SETRANGE(Status, Status::Active);
                        FILTERGROUP(0);
                        if not FIND('-') then;
                        PayGroupOnAfterValidate;
                    end;
                }
                field(PayFreq; PayFreq)
                {
                    Caption = 'Pay Frequency';
                    Enabled = false;
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
                        //py2.0+
                        //Employee.SETFILTER(Status,'=%1',Employee.Status::Active);
                        Employee.SETRANGE("Include in Pay Cycle", true);
                        //py2.0-
                        if PAGE.RUNMODAL(PAGE::"Employee List", Employee) <> ACTION::LookupOK then
                            exit;

                        EmpNo := Employee."No.";
                        EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";
                        //CurrPage.PayLines.FORM.Set(EmpNo);
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
                    Visible = false;
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
                        if PayStatus.GET(PayGroup, PayFreq) then
                            ValidateTaxPeriod(PayFreq, DATE2DMY(PayDate, 2), PayStatus);

                        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting+
                        SetPermissionForPayActions();
                        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting
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
                        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
                        if PayrollFunction.IsWeeklyPayrollGroup(PayStatus."Payroll Group Code") = false then begin
                            //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -
                            if PayStatus."Starting Payroll Day" = 0 then
                                ERROR('The "Starting Payroll Day" must be Set first,in Payroll Status Setup.');

                            if DATE2DMY(StartDate, 1) <> PayStatus."Starting Payroll Day" then
                                ERROR('The Period Start DAY must be equal to %1 as defined in Payroll Status Setup.', PayStatus."Starting Payroll Day");
                            StartDateOnAfterValidate;
                            //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
                        end
                        else begin

                        end;
                        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -
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
                field("Payslip Printed"; "Payslip Printed")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(AttendStartDate; AttendStartDate)
                {
                    Caption = 'Attendance Start Date';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(AttendEndDate; AttendEndDate)
                {
                    Caption = 'Attendance End Date';
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            part(PayLines; "Pay Detail Subform")
            {
                ApplicationArea = All;
            }
            group(Attendances)
            {
                Caption = 'Attendances';
                field("No. of Working Days"; "No. of Working Days")
                {
                    ApplicationArea = All;
                }
                field("Working Days Affected"; "Working Days Affected")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Attendance Days Affected"; "Attendance Days Affected")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Converted Salary"; "Converted Salary")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Late/ Early Attendance (Hours)"; "Late/ Early Attendance (Hours)")
                {
                    Caption = 'Absent Hours';
                    ApplicationArea = All;
                }
                field("Late Arrive Hours"; "Late Arrive Hours")
                {
                    Visible = LateArriveHoursVisibilty;
                    ApplicationArea = All;
                }
                field("No. Of Working Days-Attendance"; "No. Of Working Days-Attendance")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Overtime Hours"; "Overtime Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Overtime with Unpaid Hours"; "Overtime with Unpaid Hours")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Days-Off Transportation"; "Days-Off Transportation")
                {
                    ApplicationArea = All;
                }
                field("Lateness Days Affected"; "Lateness Days Affected")
                {
                    Caption = 'Absent Days';
                    Visible = true;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control5; "Employee Picture")
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
        area(processing)
        {
            group("Generate Payroll")
            {
                Caption = 'Generate Payroll';
                action("Calculate Pay for All Employees")
                {
                    Caption = 'Calculate Pay for All Employees';
                    Enabled = IsCalculatePayActionEnabled;
                    Image = GeneralLedger;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        PayStatus2: Record "Payroll Status";
                    begin
                        MyEmployeeJournalLine.RESET;
                        MyEmployeeJournalLine.SETRANGE(Type, 'CHANGE BASIC PAY');
                        MyEmployeeJournalLine.DELETEALL;
                        MySplitPayDetail.RESET;
                        MySplitPayDetail.DELETEALL;
                        GetPayStatus(false, 'CALC');
                        if PayStatus2.GET(PayGroup, PayFreq) then
                            ValidateTaxPeriod(PayFreq, DATE2DMY(PayDate, 2), PayStatus2);
                        if StartDate = 0D then
                            ERROR('Period Start Date must be Entered.');

                        if not CONFIRM('Do you wish to calculate Pay for period %1 of the %2 Payroll?', false, TaxPeriod, PayFreq) then
                            exit;
                        PayrollFunction.DeleteCalculatedPayrollPeriod(PayDate, PayGroup, '', true);
                        EmpCalculatePay.RUN(PayStatus);
                        EmpNo := "Employee No.";
                        GetPayStatus(true, 'CALC');
                    end;
                }
                action("Calculate Pay for Employee")
                {
                    Caption = 'Calculate Pay for Employee';
                    Enabled = IsCalculatePayActionEnabled;
                    Image = GeneralLedger;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        GetPayStatus(false, 'CALC');
                        if Employee."No." <> "Employee No." then
                            Employee.GET("Employee No.");

                        if CONFIRM(
                          'Do you wish to Calculate pay for %1 only?', false, Employee.FullName)
                        then begin
                            PayrollFunction.DeleteCalculatedPayrollPeriod(PayDate, PayGroup, EmpNo, true);
                            CalcEmpPay;
                        end;
                    end;
                }

                action("Generate Graduity")
                {
                    Caption = 'Generate Graduity';
                    RunObject = Report "Generate Graduity";
                    Image = InsertBalanceAccount;
                    visible = IsGenerateGraduityVisible;
                    ApplicationArea = All;

                }
                action(SendCalculatePayApproval)
                {
                    Caption = 'Request Payroll Calculation Approval';
                    Enabled = IsCalculatePaySendRequest;
                    Image = SendApprovalRequest;
                    Visible = ShowCalculatePayApprovalAction;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        PayrollDateStr: Text;
                    begin
                        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then
                            if PayrollFunctions.CheckCalculatePayApprovalsWorkflowEnabled(PayDetailsApproval) then begin
                                PayDetailsApproval."Workflow Field Nb" := PayDetailsApproval.FIELDNO("Req. Approval on Calculate Pay");
                                PayrollDateStr := FORMAT(PayDate, 0, '<Month Text,3> <Year4>');
                                PayDetailsApproval."Workflow Calc Pay Description" := STRSUBSTNO('Request Approval for Generating Payroll (%1: %2)', PayGroup, PayrollDateStr);
                                PayDetailsApproval.MODIFY(true);
                                PayrollFunctions.OnSendCalculatePayForApproval(PayDetailsApproval);
                            end;
                    end;
                }
                action(CancelCalculatePayApproval)
                {
                    Caption = 'Cancel Payroll Calculation Approval';
                    Enabled = IsCalculatePayCancelRequest;
                    Image = Cancel;
                    Visible = ShowCalculatePayApprovalAction;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then
                            PayrollFunctions.OnCancelCalculatePayApprovalRequest(PayDetailsApproval);
                    end;
                }
            }
            group("Audit Reports")
            {
                Caption = 'Audit Reports';
                action("Employee Card")
                {
                    Caption = 'Employee Card';
                    Image = EditLines;
                    RunObject = Page "Employee Card";
                    RunPageLink = "No." = FIELD("Employee No.");
                    ShortCutKey = 'Shift+F7';
                    Visible = false;
                    ApplicationArea = All;
                }
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
            group("Payroll Journals")
            {
                action("Payroll journals Matrix")
                {
                    Enabled = IsCalculatePayActionEnabled;
                    Image = JournalSetup;
                    RunObject = Page "Payroll Journals Matrix";
                    ApplicationArea = All;
                }
                action("Employee Journals Matrix")
                {
                    Enabled = IsCalculatePayActionEnabled;
                    Image = JournalSetup;
                    RunObject = Page "Employee Journals Matrix";
                    ApplicationArea = All;
                }
                group(Reports)
                {
                    Image = AnalysisView;
                    action(ShowSpeLines)
                    {
                        Caption = 'Show Special Lines';
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction();
                        begin
                            CurrPage.PayLines.PAGE.GETRECORD(PayDetailLine);
                            PayDetailLine.FILTERGROUP(2);
                            PayDetailLine.SETRANGE("Payroll Special Code");
                            PayDetailLine.SETRANGE(Open, true);
                            PayDetailLine.FILTERGROUP(0);
                            CurrPage.PayLines.PAGE.SETTABLEVIEW(PayDetailLine);
                        end;
                    }
                    action(HideSpeLines)
                    {
                        Caption = 'Hide Special Lines';
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction();
                        begin
                            CurrPage.PayLines.PAGE.GETRECORD(PayDetailLine);
                            PayDetailLine.FILTERGROUP(2);
                            PayDetailLine.SETRANGE("Payroll Special Code", false);
                            PayDetailLine.SETRANGE(Open, true);
                            PayDetailLine.FILTERGROUP(0);
                            CurrPage.PayLines.PAGE.SETTABLEVIEW(PayDetailLine);
                        end;
                    }
                    action("Dynamics Summary Acc Clissification")
                    {
                        Caption = 'Dynamics Summary Acc Clissification';
                        Image = "Report";
                        RunObject = Report "Dynamic Rpt-ACC Classification";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Attendance Report")
                    {
                        Image = "Report";
                        RunObject = Report "Attendance Report";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Pay Slip Customized Layout 1")
                    {
                        Image = "Report";
                        RunObject = Report "Pay Slip Customized 1";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Payroll Summary by Location")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll Summary by Location";
                        ApplicationArea = All;
                    }
                    action("Emp. Comparative Salary Rpt1")
                    {
                        Caption = 'Comparative Salary Report by location';
                        Image = "Report";
                        RunObject = Report "Comparative Salary by Location";
                        ApplicationArea = All;
                    }
                    action("Payroll Summary Report")
                    {
                        Image = "Report";
                        RunObject = Report "Payroll Summary Report";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    action("Employee Statement of Account")
                    {
                        Image = "Report";
                        RunObject = Report "Employee Statement Account";
                        ApplicationArea = All;
                    }
                    action("Salaries Comparative Report")
                    {
                        Image = CompareCost;
                        RunObject = Report "Salaries Comparative Report";
                        ApplicationArea = All;
                    }
                    action("Payroll Journals History")
                    {
                        Caption = 'Payroll Journals History';
                        Image = Journals;
                        RunObject = Report "Emp. Payroll Journals Report";
                        Visible = true;
                        ApplicationArea = All;
                    }
                    action("Salary EOS Report")
                    {
                        Image = "Report";
                        RunObject = Report "NSSF Yearly Declaration Report";
                        ApplicationArea = All;
                    }
                    action("Social Insurance")
                    {
                        Image = "Report";
                        RunObject = Report "Social Insurance";
                        ApplicationArea = All;
                    }
                    action("Employee Payroll by Period")
                    {
                        Image = "Report";
                        RunObject = Report "Salary Variance Report";
                        Visible = false;
                        ApplicationArea = All;
                    }
                    // action("Email Payslip")
                    // {
                    //     Image = "Report";
                    //     ApplicationArea = All;

                    //     trigger OnAction();
                    //     var
                    //         PayslipReport: Report "Dynamic-Payslip";
                    //     begin

                    //         PayslipReport.SetSendMail(true);
                    //         PayslipReport.RUN;
                    //     end;
                    // }
                    action("Salaries Grouped by PayGrp")
                    {
                        Image = "Report";
                        RunObject = Report "Salaries Grouped by PayGrp";
                        ApplicationArea = All;
                    }
                    group("M.O.F Reports")
                    {
                        Image = "Report";
                        action("Salary Taxes")
                        {
                            Image = "Report";
                            RunObject = Report "Salary Taxes";
                            ApplicationArea = All;
                        }
                        action("Salary Taxes Per Employee")
                        {
                            Image = "Report";
                            RunObject = Report "Salary Taxes";
                            Visible = false;
                            ApplicationArea = All;
                        }
                        action("Payroll R3")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R3 New";
                            ApplicationArea = All;
                        }
                        action("Payroll R10")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R10";
                            ApplicationArea = All;
                        }
                        action("Payroll R5")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R5";
                            ApplicationArea = All;
                        }
                        action("R6 List")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R6 List";
                            ApplicationArea = All;
                        }
                        action("Payroll R4-1")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R4 -1";
                            Visible = true;
                            ApplicationArea = All;
                        }
                        action("Payroll R4")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R4";
                            Visible = true;
                            ApplicationArea = All;
                        }
                        action("Payroll R7")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R7";
                            ApplicationArea = All;
                        }
                        action("Payroll R3-1")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll R3-1";
                            Visible = false;
                            ApplicationArea = All;
                        }
                        action("Payroll R6")
                        {
                            Image = "Report";
                            RunObject = Report "Payroll Report R6";
                            ApplicationArea = All;
                        }
                    }
                    group("NSSF Reports")
                    {
                        Caption = 'NSSF Reports';
                        Image = "Report";
                        action("Salary NSSF")
                        {
                            Image = "Report";
                            RunObject = Report "Salary NSSF 1";
                            ApplicationArea = All;
                        }
                        action("TCF Report")
                        {
                            Image = "Report";
                            RunObject = Report "TCF Report";
                            Visible = UseSchoolingSyst;
                            ApplicationArea = All;
                        }
                        action("Salary NSSF Per Employee")
                        {
                            Image = "Report";
                            RunObject = Report "Salary NSSF 1";
                            Visible = false;
                            ApplicationArea = All;
                        }
                        action("Monthly NSSF Report")
                        {
                            Image = "Report";
                            RunObject = Report "Monthly NSSF";
                            ApplicationArea = All;
                        }
                        action("Monthly Salary NSSF")
                        {
                            Image = "Report";
                            RunObject = Report "Salary NSSF 2";
                            ApplicationArea = All;
                        }
                        action("NSSF Yearly Declaration Report")
                        {
                            Image = "Report";
                            RunObject = Report "NSSF Yearly Declaration Report";
                            ApplicationArea = All;
                        }
                        action(Provision)
                        {
                            Image = "Report";
                            RunObject = Report "EOS Provision Advanced";
                            Visible = false;
                            ApplicationArea = All;
                        }
                        action("EOS Provision Report")
                        {
                            Image = "Report";
                            RunObject = Report "EOS Provision Advanced";
                            ApplicationArea = All;
                        }
                        action("تصريح عن استخدام اجير")
                        {
                            Image = "Report";
                            RunObject = Report "تصريح عن استخدام اجير";
                            ApplicationArea = All;
                        }
                        action("اعلام عن استخدام اجير")
                        {
                            Image = "Report";
                            RunObject = Report "اعلام عن استخدام اجير";
                            ApplicationArea = All;
                        }
                        action("تصريح ترك اجير عمله")
                        {
                            Image = "Report";
                            RunObject = Report "تصريح ترك اجير عمله";
                            ApplicationArea = All;
                        }
                        action("إفادة عمل")
                        {
                            Image = "Report";
                            RunObject = Report "Working Statement";
                            ApplicationArea = All;
                        }
                        action("Salary Certificate")
                        {
                            Image = "Report";
                            RunObject = Report "Salary Certificate";
                            ApplicationArea = All;
                        }
                        action("Embassy Letter")
                        {
                            Image = "Report";
                            RunObject = Report "Embassy Letter";
                            ApplicationArea = All;
                        }

                        action("اعلام عن افراد العائلة")
                        {
                            Image = "Report";
                            //RunObject = Report Report70093;
                            Visible = false;
                            ApplicationArea = All;
                        }
                        action("إفادة راتب")
                        {
                            Image = "Report";
                            RunObject = Report "إفادة راتب";
                            ApplicationArea = All;

                        }
                        action("تصريح عن الزوجة")
                        {
                            Image = "Report";
                            RunObject = Report "تصريح عن الزوجة";
                            ApplicationArea = All;

                        }
                        action("تفويض باستلام الدعوة")
                        {
                            Image = "Report";
                            RunObject = Report "تفويض باستلام الدعوة";
                            ApplicationArea = All;

                        }
                        action("افادة بالاجر او الكسب الاخير")
                        {
                            Image = "Report";
                            RunObject = Report "افادة بالاجر او الكسب الاخير";
                            ApplicationArea = All;

                        }
                        action("دعوة الى تحديد الاجور والاشتراكات")
                        {
                            Image = "Report";
                            RunObject = Report "دعوة الى تحديد الاجور";
                            ApplicationArea = All;
                        }
                        action("استفادة المضمونة عن اولادها")
                        {
                            Image = "Report";
                            RunObject = Report "استفادة المضمونة عن اولادها";
                            ApplicationArea = All;
                        }
                        action("الاستفادة عن الوالد/الوالدة")
                        {
                            Image = "Report";
                            RunObject = Report "الاستفادة عن الوالد/الوالدة";
                            ApplicationArea = All;
                        }
                        action("بلوغ السن")
                        {
                            Image = "Report";
                            ApplicationArea = All;
                            RunObject = Report "بلوغ السن";
                        }
                    }
                }
            }
            group("Test Finalize")
            {
                action("Test Finalize Pay")
                {
                    Caption = 'Test Finalize Pay';
                    Enabled = IsCalculatePayActionEnabled;
                    Image = TestFile;
                    Visible = IsFinalizePayrollAsGeneral;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        EDM: Codeunit "EDM Utility";
                    begin
                        // Added in order to manage the Finalize Code in one place - 27.07.2016 : AIM +
                        FinalizePayroll(true);
                        exit;
                        // Added in order to manage the Finalize Code in one place - 27.07.2016 : AIM -


                        GetPayStatus(false, 'FINAL');
                        if PayStatus."Last Period Calculated" = 0 then
                            ERROR('Payroll calculation has not been performed.');
                        if (PayStatus."Last Period Calculated" = PayStatus."Last Period Finalized") and
                          (DATE2DMY(PayDate, 2) = PayStatus."Last Period Finalized") then
                            ERROR('Payroll has already been Finalised.');
                        //ValidateTaxPeriod(PayFreq,TaxPeriod,PayStatus);

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
                                    if Employee2.Status = Employee2.Status::Active then
                                        CalcReqd := true;
                            until (PayDetailHeader.NEXT = 0) or (CalcReqd);
                            if CalcReqd then
                                ERROR(
                              'Finalise Pay cannot be run until pay has been Calculated for all %1 Employees.', PayFreq);
                        end;

                        if StartDate = 0D then
                            ERROR('Period Start Date must be entered.');

                        if not CONFIRM(
                          'You are about to TEST Finalize Pay.\' +
                           'Do you want to Continue?', false, PayFreq) then
                            exit;

                        FinalizeEmpPay.FinalizeEmployeePay(PayStatus, false, '');
                        //
                        //EDM.UpdateSalariesJournal;
                        //
                    end;
                }
                action("Test Finalize Pay By Dimension")
                {
                    Caption = 'Test Finalize Pay By Dimension';
                    Enabled = IsCalculatePayActionEnabled;
                    Image = TestDatabase;
                    Visible = IsFinalizePayrollByDimension;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        FinalizePayroll(true);
                    end;
                }
            }
            group("Pay Slip")
            {
                action("Dynamic Payslip")
                {
                    Caption = 'Dynamic Payslip';
                    Enabled = IsPaySlipActionEnabled;
                    Image = PayrollStatistics;
                    RunObject = Report "Dynamic Payslip";
                    ApplicationArea = All;
                }
                action(SendPaySlipApproval)
                {
                    Caption = 'Request Printing Payslips';
                    Enabled = IsPaySlipSendRequest;
                    Image = SendApprovalRequest;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = ShowPaySlipApprovalAction;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        PayrollDateStr: Text;
                    begin
                        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then
                            if PayrollFunctions.CheckPaySlipApprovalsWorkflowEnabled(PayDetailsApproval) then begin
                                PayDetailsApproval."Workflow Field Nb" := PayDetailsApproval.FIELDNO("Req. Approval on Pay Slip");
                                PayrollDateStr := FORMAT(PayDate, 0, '<Month Text,3> <Year4>');
                                PayDetailsApproval."Workflow Pay Slip Description" := STRSUBSTNO('Request Approval for printing Pay Slips (%1: %2)', PayGroup, PayrollDateStr);
                                PayDetailsApproval.MODIFY(true);
                                PayrollFunctions.OnSendPaySlipForApproval(PayDetailsApproval);
                            end;
                    end;
                }
                action(CancelPaySlipApproval)
                {
                    Caption = 'Cancel Printing Payslips';
                    Enabled = IsPaySlipCancelRequest;
                    Image = Cancel;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = ShowPaySlipApprovalAction;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then
                            PayrollFunctions.OnCancelPaySlipApprovalRequest(PayDetailsApproval);
                    end;
                }
            }
            group("Bank Payment")
            {
                action("Print-Prepare Bank Payment")
                {
                    Enabled = IsPaySlipActionEnabled;
                    Image = Payment;
                    RunObject = Report "Print-Prepare Bank Payment..";
                    ApplicationArea = All;
                }
                action("Salaries Letter")
                {
                    Enabled = IsPaySlipActionEnabled;
                    Image = Report;
                    RunObject = Report "Salaries Letter";
                    ApplicationArea = All;
                }
                //++14092020
            }
            group("Post Payroll")
            {
                action(SendFinalizePayApproval)
                {
                    Caption = 'Request Finalize Payroll Approval';
                    Enabled = IsFinalizePaySendRequest;
                    Image = SendApprovalRequest;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = ShowFinalizePayApprovalAction;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        PayrollDateStr: Text;
                    begin
                        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then
                            if PayrollFunctions.CheckFinalizePayApprovalsWorkflowEnabled(PayDetailsApproval) then begin
                                PayDetailsApproval."Workflow Field Nb" := PayDetailsApproval.FIELDNO("Req. Approval on Finalize Pay");
                                PayrollDateStr := FORMAT(PayDate, 0, '<Month Text,3> <Year4>');
                                PayDetailsApproval."Workflow Fin Pay Description" := STRSUBSTNO('Request Approval for finalizing payroll (%1: %2)', PayGroup, PayrollDateStr);
                                PayDetailsApproval.MODIFY(true);
                                PayrollFunctions.OnSendFinalizePayForApproval(PayDetailsApproval);
                            end;
                    end;
                }
                action(CancelFinalizePayApproval)
                {
                    Caption = 'Cancel Finalize Payroll Approval';
                    Enabled = IsFinalizePayCancelRequest;
                    Image = Cancel;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = ShowFinalizePayApprovalAction;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then
                            PayrollFunctions.OnCancelFinalizePayApprovalRequest(PayDetailsApproval);
                    end;
                }
                action("Finalize Pay")
                {
                    Caption = 'Finalize Pay';
                    Enabled = IsFinalizePayActionEnabled;
                    Image = Approve;
                    Visible = IsFinalizePayrollAsGeneral;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        EDM: Codeunit "EDM Utility";
                    begin
                        // Added in order to manage the Finalize Code in one place - 27.07.2016 : AIM +
                        FinalizePayroll(false);
                        // Added in order to set Status as Terminated for employee that "Payroll Start Date" < "Termination Date" < "Payroll End Date" - 06.07.2017 : A2-
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
                        // Added in order to set Status as Terminated for employee that "Payroll Start Date" < "Termination Date" < "Payroll End Date" - 06.07.2017 : A2-
                        exit;

                        // Added in order to manage the Finalize Code in one place - 27.07.2016 : AIM -
                        GetPayStatus(false, '');
                        if PayStatus."Last Period Calculated" = 0 then
                            ERROR('Payroll calculation has not been performed.');
                        if (PayStatus."Last Period Calculated" = PayStatus."Last Period Finalized") and
                            (DATE2DMY(PayDate, 2) = PayStatus."Last Period Finalized") then
                            ERROR('Payroll has already been Finalised.');
                        //ValidateTaxPeriod(PayFreq,TaxPeriod,PayStatus);

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
                                    // Modified in order to prevent conflict in case Employment Date > Payroll Date - 18.01.2016 : AIM +
                                    //IF Employee2.Status = Employee2.Status::Active THEN
                                    if (Employee2.Status = Employee2.Status::Active) and (Employee2."Employment Date" <= PayDate) then
                                        // Modified in order to prevent conflict in case Employment Date > Payroll Date - 18.01.2016 : AIM -
                                        CalcReqd := true;
                            until (PayDetailHeader.NEXT = 0) or (CalcReqd);
                            if CalcReqd then
                                ERROR(
                              'Finalise Pay cannot be run until pay has been Calculated for all %1 Employees.', PayFreq);
                        end;

                        if StartDate = 0D then
                            ERROR('Period Start Date must be entered.');

                        if not CONFIRM(
                          'You are about to Finalize Pay.\' +
                           'Do you want to Continue?', false, PayFreq) then
                            exit;

                        FinalizeEmpPay.FinalizeEmployeePay(PayStatus, true, '');
                        GetPayStatus(true, 'FINAL');
                        //
                        //EDM.UpdateSalariesJournal;
                        //
                    end;
                }
                action("Finalize Pay By Dimension")
                {
                    Caption = 'Finalize Pay By Dimension';
                    Enabled = IsFinalizePayActionEnabled;
                    Image = Approve;
                    Visible = IsFinalizePayrollByDimension;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        FinalizePayroll(false);
                        // Added in order to set Status as Terminated for employee that "Payroll Start Date" < "Termination Date" < "Payroll End Date" - 06.07.2017 : A2-
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
                        // Added in order to set Status as Terminated for employee that "Payroll Start Date" < "Termination Date" < "Payroll End Date" - 06.07.2017 : A2-
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        EmpNo := "Employee No.";

        CurrPage.PayLines.PAGE.Set(EmpNo);
        //Modified 18.09.2017 : A2+
        //SETFILTER("Date Filter",'%1..%2',StartDate,EndDate);
        if PayrollFunction.IsSeparateAttendanceInterval(PayGroup) then
            SETFILTER("Date Filter", '%1..%2', AttendStartDate, AttendEndDate)
        else
            SETFILTER("Date Filter", '%1..%2', StartDate, EndDate);
        //Modified 18.09.2017 : A2-
        CALCFIELDS("Working Days Affected", "Attendance Days Affected", "Overtime Hours", "Overtime with Unpaid Hours",
                                     "Converted Salary", "Lateness Days Affected", "Days-Off Transportation");

        Employee.GET("Employee No.");
        ExemptTax := Employee."Exempt Tax";
        EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";

        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting+
        SetPermissionForPayActions();
        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting
    end;

    trigger OnInit();
    begin
        //Modified in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM +
        /*
         //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
         IF  PayrollFunction.HideSalaryFields() = TRUE THEN
            ERROR('Permission NOT Allowed!');
         //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
         */
        if PayrollFunction.HideSalaryFields() = true then
            if PayrollFunction.GetUserPayDetailDefPayrollGroup('') = '' then
                ERROR('No Permission!');
        //Modified in order to consider 'Hide Salary' permission in HR Payroll User - 14.09.2016 : AIM -

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

        if PayParam."Payroll Finalize Type" = PayParam."Payroll Finalize Type"::"By Dimension" then begin
            IsFinalizePayrollAsGeneral := false;
            IsFinalizePayrollByDimension := true;
        end
        else begin
            IsFinalizePayrollAsGeneral := true;
            IsFinalizePayrollByDimension := false;
        end;

    end;

    trigger OnOpenPage();
    var
        LocalEmployee: Record Employee;
    begin
        PayrollOfficerPermission := PayrollFunctions.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');

        HRSetup.Get;
        PayParam.GET;
        IF PayParam."Late Arrive Deduction" <> '' then
            LateArriveHoursVisibilty := TRUE
        ELSE
            LateArriveHoursVisibilty := false;

        if (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Qatar) or
           (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::UAE) then
            IsGenerateGraduityVisible := true
        else
            IsGenerateGraduityVisible := false;

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
        GetPayStatus(false, 'CALC');

        PayDate := PayrollFunction.GetNextPayrollDate(PayStatus."Payroll Group Code", PayStatus."Pay Frequency");

        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        SetDefaultStartDate();
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -

        if LocalEmployee.GET(EmpNo) then
            EmployeeName := LocalEmployee."First Name" + ' ' + LocalEmployee."Last Name";
        OnActivateForm;

        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting+
        SetPermissionForPayActions();
        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting-
        UseSchoolingSyst := PayrollFunctions.IsFeatureVisible('ShoolingSystem');
    end;

    var
        Employee: Record Employee;
        Employee2: Record Employee;
        EmpLedgEntry: Record "Payroll Ledger Entry";
        PayParam: Record "Payroll Parameter";
        PayStatus: Record "Payroll Status";
        PayDetailHeader: Record "Pay Detail Header";
        PayDetailLine: Record "Pay Detail Line";
        PayrollGroup: Record "HR Payroll Group";
        PayUser: Record "HR Payroll User";
        HRSetup: Record "Human Resources Setup";
        EmpCalculatePay: Codeunit "Calculate Employee Pay";
        EmpFinalisePay: Codeunit "Finalize Employee Pay";
        PayrollFunction: Codeunit "Payroll Functions";
        PayGroup: Code[10];
        PayFreq: Option Monthly,Weekly;
        EmpNo: Code[20];
        TaxPeriod: Integer;
        PayDate: Date;
        PostGroup: Code[10];
        CalcReqd: Boolean;
        PayslipPrintReqd: Boolean;
        StartDate: Date;
        EndDate: Date;
        CurrExchRate: Record "Currency Exchange Rate";
        PayEmp: Record Employee;
        GenLedgSetup: Record "General Ledger Setup";
        HumanResSetup: Record "Human Resources Setup";
        ExchangeRate: Decimal;
        ExemptTax: Decimal;
        FinalizeEmpPay: Codeunit "Finalize Employee Pay";
        HRFunction: Codeunit "Human Resource Functions";
        EmployeeName: Text[65];
        MyEmployeeJournalLine: Record "Employee Journal Line";
        MySplitPayDetail: Record "Split Pay Detail Line";
        CrntEmpyNo: Code[20];
        IsFinalizePayrollAsGeneral: Boolean;
        IsFinalizePayrollByDimension: Boolean;
        FinalizeEmpPayByDimension: Codeunit "Finalize Employee Pay By Dim.";
        PayDetailsApproval: Record "Pay Details Approval";
        HRPermissions: Record "HR Permissions";
        IsCalculatePayActionEnabled: Boolean;
        IsCalculatePaySendRequest: Boolean;
        IsCalculatePayCancelRequest: Boolean;
        IsFinalizePayActionEnabled: Boolean;
        IsFinalizePaySendRequest: Boolean;
        IsFinalizePayCancelRequest: Boolean;
        IsPaySlipActionEnabled: Boolean;
        IsPaySlipSendRequest: Boolean;
        IsPaySlipCancelRequest: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ShowCalculatePayApprovalAction: Boolean;
        ShowPaySlipApprovalAction: Boolean;
        ShowFinalizePayApprovalAction: Boolean;
        DisablePayrollDateEditing: Boolean;
        AttendStartDate: Date;
        AttendEndDate: Date;
        UseSchoolingSyst: Boolean;
        PayrollFunctions: Codeunit "Payroll Functions";
        LateArriveHoursVisibilty: Boolean;
        IsGenerateGraduityVisible: Boolean;
        PayrollOfficerPermission: Boolean;

    procedure ValidateTaxPeriod(PayFrequency: Option Monthly,Weekly; CalcPeriod: Integer; PayStatusRec: Record "Payroll Status");
    var
        Maximum: Integer;
    begin
        case PayFrequency of
            PayFrequency::Weekly:
                Maximum := 52;
            PayFrequency::Monthly:
                Maximum := 12;
        end;

        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        if PayrollFunction.IsWeeklyPayrollGroup(PayStatusRec."Payroll Group Code") = false then begin
            //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -

            if (CalcPeriod < 1) or (CalcPeriod > Maximum) then
                ERROR('Payroll Period must be in range 1 to %1.', Maximum);

            if ((DATE2DMY(PayDate, 3) = DATE2DMY(PayStatus."Calculated Payroll Date", 3)) and
               (CalcPeriod < PayStatusRec."Last Period Calculated")) or
               (DATE2DMY(PayDate, 3) < DATE2DMY(PayStatus."Calculated Payroll Date", 3)) or
                 ((PayStatusRec."Last Period Finalized" = PayStatusRec."Last Period Calculated") and
                  (CalcPeriod = PayStatusRec."Last Period Calculated")) then
                ERROR('Cannot Process a Previous Payroll Period.');

            if (PayStatusRec."Last Period Finalized" <> PayStatusRec."Last Period Calculated") and
                 (CalcPeriod <> PayStatusRec."Last Period Calculated") then
                ERROR(
                  'Cannot process Period %1 until Period %2 is Finalised.',
                  CalcPeriod, PayStatusRec."Last Period Calculated");

            //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        end
        else begin
            if PayrollFunction.IsValidPayrollDate(PayStatusRec."Payroll Group Code", PayDate) = false then
                ERROR('Invalid Payroll Date');
        end;
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -
    end;

    procedure GetPayStatus(P_Modify: Boolean; P_Fct: Code[10]);
    var
        DateExpr: Text[30];
        HRSetup: Record "Human Resources Setup";
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
            //Added in order to save the Attendance Interval - 18.09.2017 : A2+
            if not PayrollFunction.IsSeparateAttendanceInterval(PayGroup) then begin
                PayStatus."Attendance Start Date" := 0D;
                PayStatus."Attendance End Date" := 0D;
            end
            else begin
                HRSetup.Get;
                IF NOT HRSetup."Seperate Attend From Payroll" THEN begin
                    PayStatus."Attendance Start Date" := AttendStartDate;
                    PayStatus."Attendance End Date" := AttendEndDate;
                end;
            end;
            //Added in order to save the Attendance Interval - 18.09.2017 : A2-
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
                //Added in order to save the Attendance Interval - 18.09.2017 : A2+
                if not PayrollFunction.IsSeparateAttendanceInterval(PayGroup) then begin
                    PayStatus."Attendance Start Date" := 0D;
                    PayStatus."Attendance End Date" := 0D;
                end
                else begin
                    HRSetup.Get;
                    IF NOT HRSetup."Seperate Attend From Payroll" THEN begin
                        PayStatus."Attendance Start Date" := AttendStartDate;
                        PayStatus."Attendance End Date" := AttendEndDate;
                    end;
                end;
                //Added in order to save the Attendance Interval - 18.09.2017 : A2-
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

    procedure CalcEmpPay();
    begin
        if StartDate = 0D then
            ERROR('Period Start Date must be Entered.');

        TaxPeriod := DATE2DMY(PayDate, 2);
        //ValidateTaxPeriod(PayFreq,TaxPeriod,PayStatus);

        Employee.GET("Employee No.");
        EmpCalculatePay.CalculateEmployeePay(Employee, PayStatus, true);

        GetPayStatus(true, 'CALC');
    end;

    local procedure PayFreqOnAfterValidate();
    begin
        GetPayStatus(false, 'CALC');
        PayDate := PayrollFunction.GetNextPayrollDate(PayStatus."Payroll Group Code", PayStatus."Pay Frequency");

        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        SetDefaultStartDate();
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -
    end;

    local procedure EmpNoOnAfterValidate();
    begin
        GET(EmpNo);
        //CurrPage.PayLines.PAGE.Set(EmpNo);
    end;

    local procedure PayGroupOnAfterValidate();
    begin
        GetPayStatus(false, 'CALC');
        CurrPage.PayLines.PAGE.Set(EmpNo);
        PayDate := PayrollFunction.GetNextPayrollDate(PayStatus."Payroll Group Code", PayStatus."Pay Frequency");
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        SetDefaultStartDate();
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -
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

        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        if PayrollFunction.IsWeeklyPayrollGroup(PayStatus."Payroll Group Code") = true then
            EndDate := StartDate + PayStatus."Days Interval";
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -

        PayStatus."Period End Date" := EndDate;
        //Added in order to save the Attendance Interval - 18.09.2017 : A2+
        if not PayrollFunction.IsSeparateAttendanceInterval(PayGroup) then begin
            PayStatus."Attendance Start Date" := 0D;
            PayStatus."Attendance End Date" := 0D;
        end
        else begin
            IF NOT HRSetup."Seperate Attend From Payroll" THEN begin
                PayStatus."Attendance Start Date" := AttendStartDate;
                PayStatus."Attendance End Date" := AttendEndDate;
            end;
        end;
        //Added in order to save the Attendance Interval - 18.09.2017 : A2-
        PayStatus.MODIFY;
    end;

    local procedure EndDateOnAfterValidate();
    begin
        PayStatus.GET(PayGroup, PayFreq);
        PayStatus."Period End Date" := EndDate;
        PayStatus.MODIFY;


        //Period Trx. warning
        if (StartDate <> 0D) and (EndDate <> 0D) then begin
            if PayStatus."Pay Frequency" = PayStatus."Pay Frequency"::Monthly then begin
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

    local procedure FinalizePayroll(IsTestFinalize: Boolean);
    var
        GenJnlLine: Record "Gen. Journal Line";
        PayParam: Record "Payroll Parameter";
    begin
        // Added in order to manage the Finalize Code in one place - 27.07.2016 : AIM +-

        if IsTestFinalize = true then
            GetPayStatus(false, 'FINAL')
        else
            GetPayStatus(false, '');

        if PayStatus."Last Period Calculated" = 0 then
            ERROR('Payroll calculation has not been performed.');
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        if PayrollFunction.IsWeeklyPayrollGroup(PayStatus."Payroll Group Code") = false then begin
            //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -

            if (PayStatus."Last Period Calculated" = PayStatus."Last Period Finalized") and
                (DATE2DMY(PayDate, 2) = PayStatus."Last Period Finalized") then
                ERROR('Payroll has already been Finalised.');

            //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        end
        else begin
            if PayrollFunction.IsValidPayrollDate(PayStatus."Payroll Group Code", PayDate) = false then
                ERROR('Weekly Payroll has already been Finalised.');
        end;
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -

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
                ERROR(
              'Finalise Pay cannot be run until pay has been Calculated for all %1 Employees. ( %2 ) ', PayFreq, Employee2."No.");
        end;

        if StartDate = 0D then
            ERROR('Period Start Date must be entered.');

        if IsTestFinalize = true then begin
            if not CONFIRM(
                             'You are about to TEST Finalize Pay.\' +
                             'Do you want to Continue?', false, PayFreq) then
                exit;
        end
        else begin
            if not CONFIRM(
                              'You are about to Finalize Pay.\' +
                              'Do you want to Continue?', false, PayFreq) then
                exit;
        end;

        //Added in order to initialize the PayParam record - 21.12.2016 : AIM +
        PayParam.GET();
        //Added in order to initialize the PayParam record - 21.12.2016 : AIM -

        if PayParam."Auto Copy Payroll Dimensions" = true then begin
            EmpCalculatePay.CopyPayrollDimensions(PayStatus."Payroll Group Code", 0D, PayStatus."Payroll Date", false);
        end;

        //Added in order to check if the allocation of dimensions is properly assigned - 21.12.2016 : AIM +
        PayDetailHeader.RESET;
        PayDetailHeader.SETRANGE("Payroll Group Code", PayGroup);
        if PayDetailHeader.FINDFIRST = true then
            repeat
                if PayrollFunction.IsValidEmployeePayrollDimension(PayDetailHeader."Employee No.", PayDate, true) = false then begin
                    ERROR('');
                    exit;
                end;
            until PayDetailHeader.NEXT = 0;
        //Added in order to check if the allocation of dimensions is properly assigned - 21.12.2016 : AIM -


        if IsFinalizePayrollByDimension then
          // 11.10.2017 : NEW MOD +
          begin
            // 11.10.2017 : NEW MOD -
            // 10.08.2017 : A2+
            //FinalizeEmpPayByDimension.FinalizeEmployeePay(PayStatus,NOT IsTestFinalize)
            FinalizeEmpPayByDimension.FinalizeEmployeePay(PayStatus, not IsTestFinalize, '', true);
            // 10.08.2017 : A2-
            // 11.10.2017 : NEW MOD +
            FinalizeEmpPayByDimension.GroupAccountWithDimension;
            FinalizeEmpPayByDimension.GroupAccountWithDimensionBal;
            IF PayParam."Enable Payment Acc. Grouping" THEN //EDM_30012018 By Tarek
                FinalizeEmpPayByDimension.GroupPaymentAccountWithDimension;
        END
        // 11.10.2017 : NEW MOD -
        else
            FinalizeEmpPay.FinalizeEmployeePay(PayStatus, not IsTestFinalize, '');
        //EDM_15092016
        // 11.10.2017 : NEW MOD +
        /*FinalizeEmpPayByDimension.GroupAccountWithDimension;
        FinalizeEmpPayByDimension.GroupAccountWithDimensionBal;
        FinalizeEmpPayByDimension.GroupPaymentAccountWithDimension;*/
        // 11.10.2017 : NEW MOD -
        //EDM_15092016

        if IsTestFinalize = false then
            GetPayStatus(true, 'FINAL');

        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM +
        if IsTestFinalize = false then
            PayrollFunction.AutoFinalizeEmployeeAttendancePeriod(PayStatus."Payroll Group Code", '');
        //Added in order to generate payroll on Weekly basis - 08.12.2016 : AIM -

        //EDM_15092016
        if IsFinalizePayrollByDimension = true then begin
            PayParam.GET;
            //Added to perform delete action as per user choice - 10.11.2016 : AIM +
            if PayParam."Delete Temporary Posting Batch" = true then begin
                //Added to perform delete action as per user choice - 10.11.2016 : AIM -
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
                //Added to perform delete action as per user choice - 10.11.2016 : AIM +
            end;
            //Added to perform delete action as per user choice - 10.11.2016 : AIM -
        end;
        //EDM_15092016
        //28.04.2017 : A2+
        if IsTestFinalize = false then begin
            UpdatePayStatusPayrollDateL();
        end;
        //28.04.2017 : A2-
        if IsTestFinalize = true then begin
            MESSAGE('TEST Finalize Process is done');
        end
        else begin
            //edm.sc+
            OnAfterFinalizePayByDimension(PayDate);
            //edm.sc-
            MESSAGE('Finalize Process is done');
        end;

    end;

    local procedure SetPermissionForPayActions();
    var
        CalcPayApproval: Boolean;
        FinPayApproval: Boolean;
        PaySlipApproval: Boolean;
    begin

        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then begin
            CalcPayApproval := PayDetailsApproval."Req. Approval on Calculate Pay";
            FinPayApproval := PayDetailsApproval."Req. Approval on Finalize Pay";
            PaySlipApproval := PayDetailsApproval."Req. Approval on Pay Slip";
        end
        else begin
            HRPermissions.SETRANGE("User ID", USERID);
            if HRPermissions.FINDFIRST then begin

                PayDetailsApproval.INIT;

                PayDetailsApproval.VALIDATE("User ID", USERID);
                PayDetailsApproval.VALIDATE("Payroll Group Code", PayGroup);
                PayDetailsApproval.VALIDATE("Payroll Date", PayDate);
                PayDetailsApproval.VALIDATE("Req. Approval on Calculate Pay", HRPermissions."Req. App. on Calculate Pay");
                PayDetailsApproval.VALIDATE("Req. Approval on Finalize Pay", HRPermissions."Req. App. on Finalize Pay");
                PayDetailsApproval.VALIDATE("Req. Approval on Pay Slip", HRPermissions."Req. Approval on Pay Slip");

                PayDetailsApproval.INSERT;

                CalcPayApproval := HRPermissions."Req. App. on Calculate Pay";
                FinPayApproval := HRPermissions."Req. App. on Finalize Pay";
                PaySlipApproval := HRPermissions."Req. Approval on Pay Slip";
            end;
        end;

        if PayDetailsApproval.GET(USERID, PayGroup, PayDate) then begin
            IsCalculatePayActionEnabled := not CalcPayApproval;

            IsCalculatePaySendRequest := (CalcPayApproval) and
                                        (not PayrollFunctions.HasOpenApprovalEntriesWithField(PayDetailsApproval.RECORDID,
                                        PayDetailsApproval.FIELDNO("Req. Approval on Calculate Pay")));

            IsCalculatePayCancelRequest := (CalcPayApproval) and
                                        (PayrollFunctions.HasOpenApprovalEntriesWithField(PayDetailsApproval.RECORDID,
                                        PayDetailsApproval.FIELDNO("Req. Approval on Calculate Pay")));

            IsFinalizePayActionEnabled := not FinPayApproval;

            IsFinalizePaySendRequest := (FinPayApproval) and
                                        (not PayrollFunctions.HasOpenApprovalEntriesWithField(PayDetailsApproval.RECORDID,
                                        PayDetailsApproval.FIELDNO("Req. Approval on Finalize Pay")));

            IsFinalizePayCancelRequest := (FinPayApproval) and
                                        (PayrollFunctions.HasOpenApprovalEntriesWithField(PayDetailsApproval.RECORDID,
                                        PayDetailsApproval.FIELDNO("Req. Approval on Finalize Pay")));

            IsPaySlipActionEnabled := not PaySlipApproval;

            IsPaySlipSendRequest := (PaySlipApproval) and
                                        (not PayrollFunctions.HasOpenApprovalEntriesWithField(PayDetailsApproval.RECORDID,
                                        PayDetailsApproval.FIELDNO("Req. Approval on Pay Slip")));

            IsPaySlipCancelRequest := (PaySlipApproval) and
                                        (PayrollFunctions.HasOpenApprovalEntriesWithField(PayDetailsApproval.RECORDID,
                                        PayDetailsApproval.FIELDNO("Req. Approval on Pay Slip")));

        end;


        //Added in order to hide approval actions as per HR Permissions setup - 26.01.2017 : AIM +
        ShowCalculatePayApprovalAction := true;
        ShowPaySlipApprovalAction := true;
        ShowFinalizePayApprovalAction := true;

        HRPermissions.RESET;
        HRPermissions.SETRANGE(HRPermissions."User ID", USERID);
        if HRPermissions.FINDFIRST then begin
            if HRPermissions."Req. App. on Calculate Pay" = false then begin
                IsCalculatePayActionEnabled := true;
                ShowCalculatePayApprovalAction := false;
            end;
            if HRPermissions."Req. App. on Finalize Pay" = false then begin
                IsFinalizePayActionEnabled := true;
                ShowFinalizePayApprovalAction := false;
            end;

            if HRPermissions."Req. Approval on Pay Slip" = false then begin
                IsPaySlipActionEnabled := true;
                ShowPaySlipApprovalAction := false;
            end;
        end;
        //Added in order to hide approval actions as per HR Permissions setup - 26.01.2017 : AIM -


        //Added in order to prevent calculating payroll after having approval or requesting approval for finalize - 02.03.2017 : AIM +
        if (ShowFinalizePayApprovalAction = true) then begin
            if (IsFinalizePayActionEnabled = true) or (IsFinalizePaySendRequest = false) then begin
                IsCalculatePayActionEnabled := false;
                IsCalculatePaySendRequest := false;
            end;
        end;
        //Added in order to prevent calculating payroll after having approval or requesting approval for finalize - 02.03.2017 : AIM -
    end;

    local procedure SetDefaultStartDate();
    var
        L_PayStatTbt: Record "Payroll Status";
    begin
        L_PayStatTbt.SETRANGE(L_PayStatTbt."Payroll Group Code", PayGroup);

        if L_PayStatTbt.FINDFIRST = false then
            exit;

        if L_PayStatTbt."Period End Date" = 0D then
            exit;
        if L_PayStatTbt."Pay Frequency" = L_PayStatTbt."Pay Frequency"::Weekly then
             //Modified in order to consider the case where payroll is generated on 15 and end of each month - 27.02.2017 : AIM +
             //StartDate :=  PayDate - L_PayStatTbt."Days Interval" + 1
             begin
            if (L_PayStatTbt."Week Start Day" = 1) and (L_PayStatTbt."Days Interval" = 15) then begin
                if DATE2DMY(PayDate, 1) = 15 then
                    StartDate := (DMY2DATE(1, DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3)))
                else
                    //corrected by abdallah on 28.02.2018 : 04:01 A2+
                    //StartDate := (DMY2DATE(15,DATE2DMY(PayDate,2) ,DATE2DMY(PayDate,3)));
                    StartDate := (DMY2DATE(16, DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3)));
                //corrected by abdallah on 28.02.2018 : 04:01 A2-
            end
            else
                StartDate := PayDate - L_PayStatTbt."Days Interval" + 1;
        end
        //Modified in order to consider the case where payroll is generated on 15 and end of each month - 27.02.2017 : AIM -
        else
            //Modified in order to set start date as 1/MM/YYYY if Monthly and Payroll Start Day is 1 - 27.02.2017 : AIM +
            //StartDate :=  CALCDATE('-1M+1D',PayDate);
            if L_PayStatTbt."Starting Payroll Day" = 1 then
                StartDate := DMY2DATE(1, DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3))
            else
                StartDate := CALCDATE('-1M+1D', PayDate);
        //Modified in order to set start date as 1/MM/YYYY if Monthly and Payroll Start Day is 1 - 27.02.2017 : AIM -
        EndDate := PayDate;

        //Added in order to set Attendance Interval - 18.09.2017 : A2+
        SetDefaultAttendanceDate();
        //Added in order to set Attendance Interval - 18.09.2017 : A2-
    end;

    local procedure UpdatePayStatusPayrollDateL();
    var
        L_PayrollStatus: Record "Payroll Status";
    begin
        L_PayrollStatus.SETRANGE("Payroll Group Code", PayGroup);
        if L_PayrollStatus.FINDFIRST then begin
            L_PayrollStatus."Payroll Date" := PayrollFunction.GetNextPayrollDate(L_PayrollStatus."Payroll Group Code", L_PayrollStatus."Pay Frequency");
            if L_PayrollStatus."Pay Frequency" = L_PayrollStatus."Pay Frequency"::Weekly then begin
                if (L_PayrollStatus."Week Start Day" = 1) and (L_PayrollStatus."Days Interval" = 15) then begin
                    if DATE2DMY(L_PayrollStatus."Payroll Date", 1) = 15 then
                        L_PayrollStatus."Period Start Date" := (DMY2DATE(1, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3)))
                    else
                        L_PayrollStatus."Period Start Date" := (DMY2DATE(15, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3)));
                end
                else
                    L_PayrollStatus."Period Start Date" := L_PayrollStatus."Payroll Date" - L_PayrollStatus."Days Interval" + 1;
            end
            else
                if L_PayrollStatus."Starting Payroll Day" = 1 then
                    L_PayrollStatus."Period Start Date" := DMY2DATE(1, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3))
                else
                    L_PayrollStatus."Period Start Date" := CALCDATE('-1M+1D', L_PayrollStatus."Payroll Date");
            L_PayrollStatus."Period End Date" := L_PayrollStatus."Payroll Date";
            //Added in order to fix Attendance Interval - 18.09.2017 : A2+
            if (not PayrollFunction.IsSeparateAttendanceInterval(PayGroup)) or (PayDate = 0D) then begin
                AttendStartDate := StartDate;
                AttendEndDate := EndDate;
            end
            else begin
                if L_PayrollStatus."Pay Frequency" = L_PayrollStatus."Pay Frequency"::Weekly then begin
                    if (L_PayrollStatus."Week Start Day" = 1) and (L_PayrollStatus."Days Interval" = 15) then begin
                        if DATE2DMY(PayDate, 1) = 15 then begin
                            AttendStartDate := DMY2DATE(1, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3));
                            AttendEndDate := DMY2DATE(15, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3));
                        end
                        else begin
                            AttendStartDate := DMY2DATE(16, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3));
                            AttendEndDate := DMY2DATE(PayrollFunction.GetLastDayinMonth(L_PayrollStatus."Payroll Date"), DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3));

                        end;
                    end
                    else begin
                        AttendStartDate := L_PayrollStatus."Payroll Date" - L_PayrollStatus."Days Interval" + 1;
                        AttendEndDate := L_PayrollStatus."Payroll Date";
                    end;
                end
                else begin
                    if L_PayrollStatus."Attendance Start Day" <= 1 then begin
                        AttendStartDate := DMY2DATE(1, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3));
                        if (DATE2DMY(L_PayrollStatus."Payroll Date", 2) = 2) AND (DATE2DMY(L_PayrollStatus."Payroll Date", 3) mod 4 = 0) then
                            AttendEndDate := DMY2DATE(29, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3))
                        else
                            if (DATE2DMY(L_PayrollStatus."Payroll Date", 2) = 2) AND (DATE2DMY(L_PayrollStatus."Payroll Date", 3) mod 4 <> 0) then
                                AttendEndDate := DMY2DATE(28, DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3))
                            else
                                AttendEndDate := DMY2DATE(PayrollFunction.GetLastDayinMonth(PayDate), DATE2DMY(L_PayrollStatus."Payroll Date", 2), DATE2DMY(L_PayrollStatus."Payroll Date", 3));
                    END
                    ELSE BEGIN
                        // Modified in order to consider first of the year - 30.01.2018 : A2+
                        //AttendStartDate := DMY2DATE(L_PayrollStatus."Attendance Start Day",DATE2DMY(L_PayrollStatus."Payroll Date",2) - 1,DATE2DMY(L_PayrollStatus."Payroll Date",3));
                        //AttendEndDate :=  AttendStartDate + 30;
                        //AttendEndDate := DMY2DATE(L_PayrollStatus."Attendance Start Day" - 1,DATE2DMY(AttendEndDate,2),DATE2DMY(AttendEndDate,3));
                        IF DATE2DMY(L_PayrollStatus."Payroll Date", 2) = 1 THEN BEGIN
                            AttendStartDate := DMY2DATE(L_PayrollStatus."Attendance Start Day", 12, DATE2DMY(L_PayrollStatus."Payroll Date", 3) - 1);
                            AttendEndDate := DMY2DATE(L_PayrollStatus."Attendance Start Day" - 1, 1, DATE2DMY(L_PayrollStatus."Payroll Date", 3));
                        END ELSE BEGIN
                            AttendStartDate := DMY2DATE(L_PayrollStatus."Attendance Start Day", DATE2DMY(L_PayrollStatus."Payroll Date", 2) - 1, DATE2DMY(L_PayrollStatus."Payroll Date", 3));
                            AttendEndDate := AttendStartDate + 30;
                            AttendEndDate := DMY2DATE(L_PayrollStatus."Attendance Start Day" - 1, DATE2DMY(AttendEndDate, 2), DATE2DMY(AttendEndDate, 3));
                        END;
                        // Modified in order to consider first of the year - 30.01.2018 : A2-
                    END;
                END;
            END;
            IF Not HRSetup."Seperate Attend From Payroll" then begin
                L_PayrollStatus."Attendance Start Date" := AttendStartDate;
                L_PayrollStatus."Attendance End Date" := AttendEndDate;
            end;
            //Added in order to fix Attendance Interval - 18.09.2017 : A2-
            L_PayrollStatus."Attendance Period" := PayrollFunctions.GetFirstDateofMonth(CalcDate('+1M', L_PayrollStatus."Attendance Period"));
            L_PayrollStatus.MODIFY;
        end;
    end;

    local procedure SetDefaultAttendanceDate();
    var
        L_PayStatTbt: Record "Payroll Status";
    begin
        L_PayStatTbt.SETRANGE(L_PayStatTbt."Payroll Group Code", PayGroup);

        if L_PayStatTbt.FINDFIRST = false then
            exit;

        if L_PayStatTbt."Period End Date" = 0D then
            exit;

        if (not PayrollFunction.IsSeparateAttendanceInterval(PayGroup)) or (PayDate = 0D) then begin
            AttendStartDate := StartDate;
            AttendEndDate := EndDate;
        end
        else begin
            if L_PayStatTbt."Pay Frequency" = L_PayStatTbt."Pay Frequency"::Weekly then begin
                if (L_PayStatTbt."Week Start Day" = 1) and (L_PayStatTbt."Days Interval" = 15) then begin
                    if DATE2DMY(PayDate, 1) = 15 then begin
                        AttendStartDate := DMY2DATE(1, DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3));
                        AttendEndDate := DMY2DATE(15, DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3));
                    end
                    else begin
                        AttendStartDate := DMY2DATE(16, DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3));
                        AttendEndDate := DMY2DATE(PayrollFunction.GetLastDayinMonth(PayDate), DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3));
                    end;
                end
                else begin
                    AttendStartDate := PayDate - L_PayStatTbt."Days Interval" + 1;
                    AttendEndDate := PayDate;
                end;
            end
            else begin
                if L_PayStatTbt."Attendance Start Day" <= 1 then begin
                    AttendStartDate := DMY2DATE(1, DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3));
                    AttendEndDate := DMY2DATE(PayrollFunction.GetLastDayinMonth(PayDate), DATE2DMY(PayDate, 2), DATE2DMY(PayDate, 3));
                END
                ELSE BEGIN
                    // Modified to solve issue of JAN - 26.12.2017 : A2+
                    //AttendStartDate := DMY2DATE(L_PayStatTbt."Attendance Start Day",DATE2DMY(PayDate,2) - 1,DATE2DMY(PayDate,3));
                    IF DATE2DMY(PayDate, 2) <> 1 THEN
                        AttendStartDate := DMY2DATE(L_PayStatTbt."Attendance Start Day", DATE2DMY(PayDate, 2) - 1, DATE2DMY(PayDate, 3))
                    ELSE
                        AttendStartDate := DMY2DATE(L_PayStatTbt."Attendance Start Day", 12, DATE2DMY(PayDate, 3));
                    // Modified to solve issue of JAN - 26.12.2017 : A2-
                    AttendEndDate := AttendStartDate + 30;
                    AttendEndDate := DMY2DATE(L_PayStatTbt."Attendance Start Day" - 1, DATE2DMY(AttendEndDate, 2), DATE2DMY(AttendEndDate, 3));
                    // 30.01.2018 : A2+
                    AttendEndDate := L_PayStatTbt."Attendance End Date";
                    AttendStartDate := L_PayStatTbt."Attendance Start Date";
                    // 30.01.2018 : A2-
                END;
            END;
        END;
    end;
    //edm.sc+
    [IntegrationEvent(false, false)]
    local procedure OnAfterFinalizePayByDimension(PayDate: Date);
    begin
    end;
    //edm.sc-
}

