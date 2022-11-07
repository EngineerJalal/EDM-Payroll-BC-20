codeunit 98010 "Payroll Subscribers"
{
    // version EDM.HRPY1


    trigger OnRun();
    begin
    end;

    var
        HRSetup: Record "Human Resources Setup";
        HumanResSetup: Record "Human Resources Setup";
        PayrollFunctions: Codeunit "Payroll Functions";
        EmployeeAddInfo: Record "Employee Additional Info";
        EmployeeJournals: Record "Employee Journal Line";
        PayDetailHeader: Record "Pay Detail Header";
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        PayDetailLine: Record "Pay Detail Line";
        Loan: Record "Employee Loan";
        DimValue: Record "Dimension Value";
        HRConfidentialCommentLine: Record "HR Confidential Comment Line";
        EmployeeContracts: Record "Employee Contracts";
        EmpDiscipActions: Record "Employee Disciplinary Action";
        AcademicHistory: Record "Academic History";
        LanguageSkills: Record "Language Skills";
        EmployeeDocuments: Record "Requested Documents";
        Resource: Record Resource;
        Employee: Record Employee;
        EmploymentType: Record "Employment Type";
        BaseCalendarChange: Record "Base Calendar Change N";
        EmploymentTypeSchedule: Record "Employment Type Schedule";
        CauseOfAbsence: Record "Cause of Absence";
        SpouseExemptTax: Boolean;
        HRPayrollUser: Record "HR Payroll User";
        EmployeeLoan: Record "Employee Loan";
        SurveyEmp: Record "HR Information";
        PayrollStatus: Record "Payroll Status";
        HRFunction: Codeunit "Human Resource Functions";
        SalaryRaiseSendForApprovalEventDescTxt: Label 'Approval for a Salary Raise Request is needed.';
        SalaryRaiseApprovalRequestCancelEventDescTxt: Label 'The approval for the Salary Raise Request is canceled.';
        CalculatePaySendForApprovalEventDescTxt: Label 'Approval of a Calculate Pay is requested.';
        CalculatePayApprovalRequestCancelEventDescTxt: Label 'An approval request for a Calculate Pay is canceled.';
        FinalizePaySendForApprovalEventDescTxt: Label 'Approval of a Finalize Pay is requested.';
        FinalizePayApprovalRequestCancelEventDescTxt: Label 'An approval request for a Finalize Pay is canceled.';
        PaySlipSendForApprovalEventDescTxt: Label 'Approval of a Pay Slip is requested.';
        PaySlipApprovalRequestCancelEventDescTxt: Label 'An approval request for a Pay Slip is canceled.';

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterInsertEvent', '', false, false)]
    local procedure EmployeeOnAfterInsert(var Rec: Record Employee; RunTrigger: Boolean);
    begin
        HRPayrollUser.RESET;
        HRPayrollUser.SETRANGE("Payroll Group Code", Rec."Payroll Group Code");
        HRPayrollUser.SETRANGE("User Id", USERID);
        if HRPayrollUser.FINDFIRST then
            if HRPayrollUser."Disable Delete Emp Rec" = true then
                ERROR('You do not have permission to delete record')
            else
                if PayrollFunctions.IsEmployeeCodeUsed(Rec."No.") then
                    ERROR('Cannot process deleting,Record is already used')
                else
                    if not CONFIRM('Are you sure you want to delete this record', false) then
                        ERROR('');

        HumanResSetup.GET();
        if (HumanResSetup."Auto Assign Attendance No") and (Rec."Attendance No." = 0) then
            Rec."Attendance No." := PayrollFunctions.GetNewAttendanceNo();

        if not EmployeeAddInfo.GET(Rec."No.") then begin
            EmployeeAddInfo.INIT;
            EmployeeAddInfo."Employee No." := Rec."No.";
            EmployeeAddInfo.INSERT;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure EmployeeOnBeforeDelete(var Rec: Record Employee; RunTrigger: Boolean);
    var
        HRPayrollUserTbt: Record "HR Payroll User";

    begin
        HRPayrollUserTbt.SETRANGE("Payroll Group Code", Rec."Payroll Group Code");
        HRPayrollUserTbt.SETRANGE("User Id", USERID);
        IF HRPayrollUserTbt.FINDFIRST THEN
            IF HRPayrollUserTbt."Disable Delete Emp Rec" = TRUE THEN
                ERROR('You do not have permission to delete record');

        EmployeeJournals.RESET;
        EmployeeJournals.SETRANGE("Employee No.", Rec."No.");
        if EmployeeJournals.FINDFIRST then
            ERROR('Deletion Failed : Employee Journal Line Exist');

        // PY1.0
        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            Rec.CALCFIELDS("Pay To Date", "Taxable Pay To Date", "Tax Paid To Date");
            if (Rec."Pay To Date" <> 0) or (Rec."Taxable Pay To Date" <> 0) or (Rec."Tax Paid To Date" <> 0) then
                ERROR('Deletion Failed : Payroll Ledger Entry Exist');

            //Modified in order to prevent error message  - 23.01.2017 : AIM +
            PayDetailHeader.SETRANGE("Employee No.", Rec."No.");
            if PayDetailHeader.FINDFIRST = true then
                PayDetailHeader.DELETE;
            //Added in order to prevent error message - 23.01.2017 : AIM -

            PayDetailLine.RESET;
            PayDetailLine.SETCURRENTKEY("Employee No.", Open);
            PayDetailLine.SETRANGE("Employee No.", Rec."No.");
            PayDetailLine.SETRANGE(Open, true);
            PayDetailLine.DELETEALL;

            Loan.RESET;
            Loan.SETRANGE("Employee No.", Rec."No.");
            Loan.DELETEALL;
        end; // pay. in use - Delete

        if DimValue.GET('EMPLOYEE', Rec."No.") then
            DimValue.DELETE(true);

        HRConfidentialCommentLine.SETRANGE("No.", Rec."No.");
        HRConfidentialCommentLine.DELETEALL;

        EmployeeContracts.SETRANGE("Employee No.", Rec."No.");
        EmployeeContracts.DELETEALL;

        EmpDiscipActions.SETRANGE("Employee No.", Rec."No.");
        EmpDiscipActions.DELETEALL;

        AcademicHistory.SETRANGE("Table Name", AcademicHistory."Table Name"::Employee);
        AcademicHistory.SETRANGE("No.", Rec."No.");
        AcademicHistory.DELETEALL;

        LanguageSkills.SETRANGE("Table Name", LanguageSkills."Table Name"::Employee);
        LanguageSkills.SETRANGE("No.", Rec."No.");
        LanguageSkills.DELETEALL;

        EmployeeDocuments.SETRANGE("No.", Rec."No.");
        EmployeeDocuments.DELETEALL;

        if EmployeeAddInfo.GET(Rec."No.") then
            EmployeeAddInfo.DELETE;

        HRPayrollUserTbt.SETRANGE("Payroll Group Code", Rec."Payroll Group Code");
        HRPayrollUserTbt.SETRANGE("User Id", USERID);
        IF HRPayrollUserTbt.FINDFIRST THEN
            IF HRPayrollUserTbt."Disable Delete Emp Rec" THEN
                ERROR('You do not have permission to delete record')
            ELSE
                IF NOT CONFIRM('Are you sure you want to delete this record', FALSE) THEN
                    ERROR('');
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterRenameEvent', '', false, false)]
    local procedure EmployeeOnAfterRename(var Rec: Record Employee; var xRec: Record Employee; RunTrigger: Boolean);
    begin
        if DimValue.GET('EMPLOYEE', xRec."No.") then
            DimValue.RENAME('EMPLOYEE', Rec."No.");

        //Add Employee No to Table Employee Add Info (Change No. 02) - 07.11.2016 : MCHAMI +
        if EmployeeAddInfo.GET(xRec."No.") then
            EmployeeAddInfo.RENAME(Rec."No.")
        else begin
            EmployeeAddInfo.INIT;
            EmployeeAddInfo."Employee No." := Rec."No.";
            EmployeeAddInfo.INSERT;
        end;
        //Add Employee No to Table Employee Add Info (Change No. 02) - 07.11.2016 : MCHAMI -
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'First Name', false, false)]
    local procedure EmployeeOnAfterValidateFirstName(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        PayrollFunctions.UpdateEmployeeNo(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Middle Name', false, false)]
    local procedure EmployeeOnAfterValidateMiddleName(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        Rec."Full Name" := Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name";
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Last Name', false, false)]
    local procedure EmployeeOnAfterValidateLastName(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        PayrollFunctions.UpdateEmployeeNo(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Job Title', false, false)]
    local procedure EmployeeOnAfterValidateJobTitle(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        if Rec."Job Title" <> xRec."Job Title" then
            Rec."Reason of Change" := '';

        if Resource.GET(Rec."Resource No.") then begin
            Resource."Job Title" := Rec."Job Title";
            Resource.MODIFY;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Birth Date', false, false)]
    local procedure EmployeeOnAfterValidateBirthDate(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        //EDM+
        Rec."Employee Age" := DATE2DMY(TODAY, 3) - DATE2DMY(Rec."Birth Date", 3);
        if DATE2DMY(TODAY, 2) < DATE2DMY(Rec."Birth Date", 2) then
            Rec."Employee Age" := Rec."Employee Age" - 1;
        if (DATE2DMY(TODAY, 2) = DATE2DMY(Rec."Birth Date", 2)) and (DATE2DMY(TODAY, 1) < DATE2DMY(Rec."Birth Date", 1)) then
            Rec."Employee Age" := Rec."Employee Age" - 1;
        Rec."End of Service Date" := CALCDATE('+64Y', Rec."Birth Date");
        //EDM-
        Rec."Month of Birth Date" := DATE2DMY(Rec."Birth Date", 2);
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Manager No.', false, false)]
    local procedure EmployeeOnAfterValidateManagerNo(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        //EDM+
        Employee.SETRANGE("No.", Rec."Manager No.");
        if Employee.FINDFIRST then
            Rec."Manager Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name"
        else
            Rec."Manager Name" := '';
        //EDM-
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Emplymt. Contract Code', false, false)]
    local procedure EmployeeOnAfterValidateEmploymentContractCode(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        // SHR1.0
        if EmploymentType.GET(Rec."Employment Type Code") then begin
            if (EmploymentType.Type <> EmploymentType.Type::Contract) and (Rec."Emplymt. Contract Code" <> '') then
                ERROR('Employment Type is not a Contract');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Employment Date', false, false)]
    local procedure EmployeeOnAfterValidateEmploymentDate(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        if Rec."Employment Date" <> xRec."Employment Date" then begin
            Rec."Reason of Change" := '';
            Rec.VALIDATE("Job Title");
        end; //employ.dt

        PayrollFunctions.CalculateServiceYears(Rec);

        // Add in order to set Declared Date as Eploymenet Date - 06.07.2017 : A2+
        if (Rec."Declaration Date" <> 0D) or (Rec."NSSF Date" <> 0D) then
            if CONFIRM('Do you want to change "Declaration Date" and "NSSF Date"', false) then begin
                Rec."Declaration Date" := Rec."Employment Date";
                Rec."NSSF Date" := Rec."Employment Date";
            end;

        // Added in order to auto insert Declaration date and NSSF date as Employment date - 06.11.2017 : A2+
        if (Rec."Declaration Date" = 0D) and (Rec."NSSF Date" = 0D) then begin
            Rec."Declaration Date" := Rec."Employment Date";
            Rec."NSSF Date" := Rec."Employment Date";
        end;
        // Added in order to auto insert Declaration date and NSSF date as Employment date - 06.11.2017 : A2-
        // Add in order to set Declared Date as Eploymenet Date - 06.07.2017 : A2-
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure EmployeeOnAfterValidateStatus(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        // SHR1.0
        if Rec.Status <> xRec.Status then begin
            Rec."Reason of Change" := '';

            case Rec.Status of
                Rec.Status::Inactive:
                    Rec."Inactive Date" := WORKDATE;
                Rec.Status::Terminated:
                    begin
                        Loan.SETRANGE("Employee No.", Rec."No.");
                        Loan.SETRANGE(Completed, false);
                        if Loan.FINDFIRST then
                            ERROR('First you Need to Close all related pending Loans. Operation Aborted.');
                    end; //terminated
            end; //end case statement
        end; //spe.status
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Global Dimension 1 Code', false, false)]
    local procedure EmployeeOnAfterValidateGlobalDimension1(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        Rec."Reason of Change" := '';
        Rec.MODIFY;

        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            PayrollFunctions.UpdatePayDetail(false, Rec, xRec);
            if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then
                PayrollFunctions.ReCalcWarning(Rec, xRec);
        end;

        if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then
            Rec.VALIDATE("Job Title");
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Global Dimension 2 Code', false, false)]
    local procedure EmployeeOnAfterValidateGlobalDimension2(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        Rec."Reason of Change" := '';
        Rec.MODIFY;

        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            PayrollFunctions.UpdatePayDetail(false, Rec, xRec);
            if Rec."Global Dimension 2 Code" <> xRec."Global Dimension 2 Code" then
                PayrollFunctions.ReCalcWarning(Rec, xRec);
        end;

        if Rec."Global Dimension 2 Code" <> xRec."Global Dimension 2 Code" then
            Rec.VALIDATE("Job Title");
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Related to', false, false)]
    local procedure EmployeeOnAfterValidateRelatedTo(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    begin
        PayrollFunctions.InsertEmployeeInfoFromRelatedFile(Rec, Rec."No.", Rec."Related to", true);
    end;

    [EventSubscriber(ObjectType::Table, 5205, 'OnBeforeInsertEvent', '', false, false)]
    local procedure EmpRelativeOnBeforeInsert(var Rec: Record "Employee Relative"; RunTrigger: Boolean);
    begin
        PayrollFunctions.ChkRelCodeUnique(Rec, Rec, 'I'); //shr2.0

        Rec.CALCFIELDS(Type);
    end;

    [EventSubscriber(ObjectType::Table, 5205, 'OnBeforeModifyEvent', '', false, false)]
    local procedure EmpRelativeOnBeforeModify(var Rec: Record "Employee Relative"; var xRec: Record "Employee Relative"; RunTrigger: Boolean);
    begin
        PayrollFunctions.ChkRelCodeUnique(Rec, xRec, 'M'); //shr2.0

        HumanResSetup.GET;

        if (Rec."Relative Code" <> xRec."Relative Code") and ((xRec."Eligible Child") or (Rec."Eligible Child")) then
            if not CONFIRM('ReCalculation Function on Pay Details is Required.\\Do you want to Continue ?', true) then
                ERROR('Operation Aborted !');

        if HumanResSetup."Payroll in Use" then begin
            Employee.GET(Rec."Employee No.");
            if (Employee."Social Status" = Employee."Social Status"::Divorced) and
              (Employee."Divorced Spouse Child. Resp.") and
              ((Rec."Eligible Child") or (Rec."Scholarship Applicable")) then
                ERROR('Cannot be applied on Divorced Social Status with Spouse Child Responsibility.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5205, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure EmpRelativeOnBeforeDelete(var Rec: Record "Employee Relative"; RunTrigger: Boolean);
    var
        HRCommentLine: Record "HR Comment Line EDM";
    begin

        PayrollFunctions.RecalSpePayWarning;

        //shr2.0+
        //Employee.ReverseInsuranceJnlLine(Rec."Employee No.",Rec."Relative Code");
        //shr2.0-
    end;

    [EventSubscriber(ObjectType::Table, 5205, 'OnAfterValidateEvent', 'Relative Code', false, false)]
    local procedure EmpRelativeOnAfterValidateRelativeCode(var Rec: Record "Employee Relative"; var xRec: Record "Employee Relative"; CurrFieldNo: Integer);
    var
        Relative: Record Relative;
    begin
        if Relative.GET(Rec."Relative Code") then begin
            Employee.GET(Rec."Employee No.");
            if Relative.Type = Relative.Type::Child then
                Rec."Eligible Child" := true
            else
                Rec."Eligible Child" := false;
            if Relative.Type = Relative.Type::Mother then
                Rec."First Name" := Employee."Mother Name";
        end;

        //EDM+
        if (Rec.Type = Rec.Type::Wife) or (Rec."Relative Code" = 'FEMME') then begin
            Rec."Social Status" := Rec."Social Status"::Married;
            Rec."Arabic Gender" := 1;
            Rec.Student := Rec.Student::No;
        end;

        if (Rec.Type = Rec.Type::Husband) or (Rec."Relative Code" = 'MARI') then begin
            Rec."Social Status" := Rec."Social Status"::Married;
            Rec."Arabic Gender" := 0;
            Rec.Student := Rec.Student::No;
        end;

        if (Rec.Type = Rec.Type::Mother) then begin
            Rec."Social Status" := Rec."Social Status"::Married;
            Rec."Arabic Gender" := 1;
            Rec.Student := Rec.Student::No;
        end;
        if (Rec.Type = Rec.Type::Father) then begin
            Rec."Social Status" := Rec."Social Status"::Married;
            Rec."Arabic Gender" := 0;
            Rec.Student := Rec.Student::No;
        end;
        //EDM-
    end;

    [EventSubscriber(ObjectType::Table, 5205, 'OnAfterValidateEvent', 'Birth Date', false, false)]
    local procedure EmpRelativeOnAfterValidateBirthDate(var Rec: Record "Employee Relative"; var xRec: Record "Employee Relative"; CurrFieldNo: Integer);
    begin
        PayrollFunctions.RecalSpePayWarning;

        //EDM+
        Rec."Relative Age" := DATE2DMY(TODAY, 3) - DATE2DMY(Rec."Birth Date", 3);
        if DATE2DMY(TODAY, 2) < DATE2DMY(Rec."Birth Date", 2) then
            Rec."Relative Age" := Rec."Relative Age" - 1;
        if (DATE2DMY(TODAY, 2) = DATE2DMY(Rec."Birth Date", 2)) and (DATE2DMY(TODAY, 1) < DATE2DMY(Rec."Birth Date", 1)) then
            Rec."Relative Age" := Rec."Relative Age" - 1;
        //EDM-
    end;

    [EventSubscriber(ObjectType::Table, 5205, 'OnAfterValidateEvent', 'Sex', false, false)]
    local procedure EmpRelativeOnAfterValidateSex(var Rec: Record "Employee Relative"; var xRec: Record "Employee Relative"; CurrFieldNo: Integer);
    begin
        IF Rec.Sex = Rec.Sex::Male THEN
            Rec."Arabic Gender" := Rec."Arabic Gender"::"ذكر"
        ELSE
            Rec."Arabic Gender" := Rec."Arabic Gender"::"أنثى";
    end;

    [EventSubscriber(ObjectType::Table, 5206, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure CauseOfAbsenceOnBeforeDelete(var Rec: Record "Cause of Absence"; RunTrigger: Boolean);
    var
        AbsenceEntitle: Record "Absence Entitlement";
        EmpAbsEntitle: Record "Employee Absence Entitlement";
    begin
        EmpAbsEntitle.SETRANGE("Cause of Absence Code", Rec.Code);
        if EmpAbsEntitle.FINDFIRST then
            ERROR('Cannot Delete an Entitled Cause of Absence !');

        EmployeeJournals.SETRANGE("Cause of Absence Code", Rec.Code);
        if EmployeeJournals.FINDFIRST then
            ERROR('Cannot be Deleted: Journal Lines Exists');

        AbsenceEntitle.SETRANGE("Cause of Absence Code", Rec.Code);
        AbsenceEntitle.DELETEALL;
    end;

    [EventSubscriber(ObjectType::Table, 5207, 'OnAfterInsertEvent', '', false, false)]
    local procedure EmpAbsenceOnAfterInsert(var Rec: Record "Employee Absence"; RunTrigger: Boolean);
    var
        EmployeeAbsence: Record "Employee Absence";
    begin
        CLEAR(Employee);
        Employee.SETRANGE("No.", Rec."Employee No.");
        if Employee.FINDFIRST then begin
            if Employee."Global Dimension 1 Code" <> '' then
                Rec."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
            if Employee."Global Dimension 2 Code" <> '' then
                Rec."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5207, 'OnBeforeModifyEvent', '', false, false)]
    local procedure EmpAbsenceOnBeforeModify(var Rec: Record "Employee Absence"; var xRec: Record "Employee Absence"; RunTrigger: Boolean);
    var
        UserSetup: Record "User Setup";
    begin
        IF UserSetup.GET(USERID) THEN begin
            IF Not UserSetup."Allow Modify Payroll Ledger" THEN begin
                if not PayrollFunctions.CanModifyAttendanceRecord(Rec."From Date", Rec."Employee No.") then
                    ERROR('Modify is not allowed for this record');
            end;
        end;
        Rec."Modified By" := USERID;
    end;

    [EventSubscriber(ObjectType::Table, 5207, 'OnAfterValidateEvent', 'Employee No.', false, false)]
    local procedure EmpAbsenceOnAfterValidateEmployeeNo(var Rec: Record "Employee Absence"; var xRec: Record "Employee Absence"; CurrFieldNo: Integer);
    begin
        //Added because an error appear when open the page in case Employee No is empty - 27.12.2016 : A2 +
        //IF Rec."Employee No." = '' THEN // Commented as The IF statement in next statement was added. Before it was not included
        //  EXIT;
        //Added because an error appear when open the page in case Employee No is empty - 27.12.2016 : A2 -

        if Employee.GET(Rec."Employee No.") then
            Rec."Attendance No." := Employee."Attendance No.";
    end;

    [EventSubscriber(ObjectType::Table, 5207, 'OnAfterValidateEvent', 'From Date', false, false)]
    local procedure EmpAbsenceOnAfterValidateFromDate(var Rec: Record "Employee Absence"; var xRec: Record "Employee Absence"; CurrFieldNo: Integer);
    begin
        if DATE2DWY(Rec."From Date", 1) = 0 then
            Rec."Day of the Week" := Rec."Day of the Week"::Sunday
        else
            if DATE2DWY(Rec."From Date", 1) = 1 then
                Rec."Day of the Week" := Rec."Day of the Week"::Monday
            else
                if DATE2DWY(Rec."From Date", 1) = 2 then
                    Rec."Day of the Week" := Rec."Day of the Week"::Tuesday
                else
                    if DATE2DWY(Rec."From Date", 1) = 3 then
                        Rec."Day of the Week" := Rec."Day of the Week"::Wednesday
                    else
                        if DATE2DWY(Rec."From Date", 1) = 4 then
                            Rec."Day of the Week" := Rec."Day of the Week"::Thursday
                        else
                            if DATE2DWY(Rec."From Date", 1) = 5 then
                                Rec."Day of the Week" := Rec."Day of the Week"::Friday
                            else
                                if DATE2DWY(Rec."From Date", 1) = 6 then
                                    Rec."Day of the Week" := Rec."Day of the Week"::Saturday;
    end;

    [EventSubscriber(ObjectType::Table, 5207, 'OnAfterValidateEvent', 'To Date', false, false)]
    local procedure EmpAbsenceOnAfterValidateToDate(var Rec: Record "Employee Absence"; var xRec: Record "Employee Absence"; CurrFieldNo: Integer);
    begin
        HRSetup.Get;
        IF NOT HRSetup."Manual Schedule" then begin
            Rec.CALCFIELDS("Employment Type Code");
            EmploymentTypeSchedule.SETRANGE("Employment Type Code", Rec."Employment Type Code");
            EmploymentTypeSchedule.SETRANGE("Day of the Week", Rec."Day of the Week");
            if EmploymentTypeSchedule.FINDFIRST then
                Rec.VALIDATE("Shift Code", EmploymentTypeSchedule."Shift Code");

            Rec.CALCFIELDS("Employment Type Code");
            EmploymentType.SETRANGE(Code, Rec."Employment Type Code");
            if EmploymentType.FINDFIRST then begin
                BaseCalendarChange.SETRANGE("Base Calendar Code", EmploymentType."Base Calendar Code");
                BaseCalendarChange.SETRANGE(Date, Rec."From Date");
                if BaseCalendarChange.FINDFIRST then
                    if BaseCalendarChange.Nonworking then
                        Rec.VALIDATE("Shift Code", 'HOLIDAY');
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5207, 'OnAfterValidateEvent', 'Cause of Absence Code', false, false)]
    local procedure EmpAbsenceOnAfterValidateCauseOfAbsenceCode(var Rec: Record "Employee Absence"; var xRec: Record "Employee Absence"; CurrFieldNo: Integer);
    begin
        CauseOfAbsence.GET(Rec."Cause of Absence Code");
        Rec.VALIDATE(Type, CauseOfAbsence.Type);
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnOpenPageEvent', '', false, false)]
    local procedure EmployeeCardOnOpenPage(var Rec: Record Employee);
    var
        OpenEmployeesCardPageErr: Text;
    begin
        OpenEmployeesCardPageErr := PayrollFunctions.CanOpenEmployeesCardPage(USERID);
        if OpenEmployeesCardPageErr <> '' then begin
            ERROR(OpenEmployeesCardPageErr);
        end;

        //InitializeAddtionalInfoVariables();
        PayrollFunctions.GetEmployeeSalaryInfoBeforeChange(Rec);

        if not PayrollFunctions.CanUserAccessEmployeeCard('', Rec."No.") then
            ERROR('User does not have permission to access this card');

        // Set Visibility Variables based on PayParam

        PayrollFunctions.CalculateServiceYears(Rec);
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnClosePageEvent', '', false, false)]
    local procedure EmployeeCardOnClosePage(var Rec: Record Employee);
    begin
        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            if not Rec."No Exempt" then
                Rec."Exempt Tax" := PayrollFunctions.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE)
            else
                Rec."Exempt Tax" := 0;
            Rec.MODIFY;
        end;
        PayrollFunctions.GetEmployeeSalaryInfoBeforeChange(Rec);
        PayrollFunctions.SaveEmployeeSalaryHistory(Rec);
        PayrollFunctions.SaveEmpDimension(Rec);
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure EmployeeCardOnAfterGetRecord(var Rec: Record Employee);
    begin
        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            if not Rec."No Exempt" then
                Rec."Exempt Tax" := PayrollFunctions.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE)
            else
                Rec."Exempt Tax" := 0;
        end;

        PayrollFunctions.CalculateServiceYears(Rec);
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnQueryClosePageEvent', '', false, false)]
    local procedure EmployeeCardOnQueryClosePage(var Rec: Record Employee; var AllowClose: Boolean);
    var
        PayrollFunctions: Codeunit "Payroll Functions";
        IsHROfficer: Boolean;
        IsDataEntryOfficer: Boolean;
        IsPayrollOfficer: Boolean;
        IsEvaluationOfficer: Boolean;
        IsRecruitmentOfficer: Boolean;
        IsAttendanceOfficer: Boolean;
    begin
        IsHROfficer := PayrollFunctions.IsHROfficer(UserId);
        IsDataEntryOfficer := PayrollFunctions.IsDataEntryOfficer(Userid);
        IsPayrollOfficer := PayrollFunctions.IsPayrollOfficer(Userid);
        IsEvaluationOfficer := PayrollFunctions.IsEvaluationOfficer(UserId);
        IsRecruitmentOfficer := PayrollFunctions.IsRecruitmentOfficer(UserId);
        IsAttendanceOfficer := PayrollFunctions.IsAttendanceOfficer(UserId);

        if (Rec."Related to" = '') and (Rec."No." <> '') then
            Rec."Related to" := Rec."No.";

        HumanResSetup.RESET;
        HumanResSetup.GET();
        if not HumanResSetup."Disable Data Entry Validation" then begin
            if Rec.Status = Rec.Status::Active Then begin
                if (Rec."First Name" <> '') or (Rec."Middle Name" <> '') or (Rec."Last Name" <> '') then begin
                    Rec.TESTFIELD("First Name");
                    Rec.TESTFIELD("Last Name");
                    Rec.TESTFIELD("Birth Date");
                    Rec.TESTFIELD(Gender);
                    Rec.TESTFIELD("Employment Date");
                    Rec.TESTFIELD("Job Title Code");

                    if IsHROfficer then begin
                        Rec.TESTFIELD("Employee Category Code");
                    end;
                    if IsHROfficer or IsAttendanceOfficer then begin
                        Rec.TESTFIELD("Employment Type Code");
                        rec.TestField("Period");
                    end;
                    if IsPayrollOfficer then begin
                        Rec.TESTFIELD(Declared);
                        Rec.TESTFIELD("Posting Group");
                        Rec.TESTFIELD("Payroll Group Code");
                        if (rec.Declared = rec.Declared::Declared) or (rec.Declared = rec.Declared::"Non-NSSF") then
                            rec.TestField("Declaration Date");
                        if (rec.Declared = rec.Declared::Declared) then
                            rec.TestField("NSSF Date");
                        rec.TestField("Basic Pay");
                        if rec."Payment Method" = rec."Payment Method"::Bank then begin
                            rec.TestField("Bank No.");
                            rec.TestField("Emp. Bank Acc No.");
                        end;
                        if rec."Payment Method (ACY)" = rec."Payment Method (ACY)"::Bank then begin
                            rec.TestField("Bank No. (ACY)");
                            rec.TestField("Emp. Bank Acc No. (ACY)");
                        end;
                    end;
                end
            end;
        end;

        if Rec."No." <> '' then begin
            if (Rec.Status = Rec.Status::Terminated) then
                Rec.TESTFIELD("Termination Date");
            if (Rec.Status = Rec.Status::Inactive) then
                Rec.TESTFIELD("Inactive Date");
        end;

        PayrollFunctions.InsertEmployeeCodeToDimensionsTable(Rec."No.");
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', 'Journal', false, false)]
    local procedure EmployeeCardOnAfterActionJournal(var Rec: Record Employee);
    begin
        EmployeeJournals.RESET;
        EmployeeJournals.SETRANGE("Employee No.", Rec."No.");
        PAGE.RUN(0, EmployeeJournals);
    end;

    local procedure EmployeeCardOnAfterActionLoan(var Rec: Record Employee);
    begin
        EmployeeLoan.RESET;
        EmployeeLoan.SETRANGE(EmployeeLoan."Employee No.", Rec."No.");
        EmployeeLoan.SETRANGE(EmployeeLoan.Completed, false);

        if not EmployeeLoan.FINDFIRST then begin
            EmployeeLoan.INIT;
            EmployeeLoan."Employee No." := Rec."No.";
            EmployeeLoan.INSERT;
        end;
        PAGE.RUN(PAGE::"Loan Card", EmployeeLoan);
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', 'Survey', false, false)]
    local procedure EmployeeCardOnAfterActionSurvey(var Rec: Record Employee);
    begin
        SurveyEmp.RESET;
        SurveyEmp.SETRANGE("Table Name", SurveyEmp."Table Name"::Survey);
        SurveyEmp.SETRANGE(Classification, SurveyEmp.Classification::Employee);
        SurveyEmp.SETFILTER("No. Filter", Rec."No.");
        SurveyEmp.SETFILTER("Table Name Filter", '%1', SurveyEmp."Table Name Filter"::SurveyQEmp);
        PAGE.RUN(80079, SurveyEmp);
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', 'Related Employees Files', false, false)]
    local procedure EmployeeCardOnAfterActionRelatedEmployeesFiles(var Rec: Record Employee);
    var
        EmployeeList: Page "Employee List";
    begin
        Employee.SETRANGE(Employee."Related to", Rec."Related to");
        if Employee.FINDFIRST then begin
            EmployeeList.SETTABLEVIEW(Employee);
            EmployeeList.RUN;
        end else
            MESSAGE('No Related files');
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', 'Convert Leaves', false, false)]
    local procedure EmployeeCardOnAfterActionConvertLeaves(var Rec: Record Employee);
    var
        ConvertLeaves: Report "Convert Attendance..";
    begin
        ConvertLeaves.GetMainNo(Rec."No.");
        ConvertLeaves.RUN;
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', 'Create Pay Details', false, false)]
    local procedure EmployeeCardOnAfterActionCreatePayDetails(var Rec: Record Employee);
    begin
        // PY1.0 prepare pay detail for new employee
        //SHR9.0+
        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            PayDetailLine.SETRANGE("Employee No.", Rec."No.");
            PayDetailLine.SETRANGE(Open, true);
            if not PayDetailLine.FINDFIRST then begin
                if PayrollStatus.GET(Rec."Payroll Group Code") then
                    if Rec."Employment Date" <= PayrollStatus."Period Start Date" then begin
                        Rec."Exempt Tax" := PayrollFunctions.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);
                        PayrollFunctions.CreatePayDetail(Rec);
                    end;
            end;
        end; // pay. in use - Insert
        //SHR9.0-
    end;

    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', 'Delete Pay Details', false, false)]
    local procedure EmployeeCardOnAfterActionDeletePayDetails(var Rec: Record Employee);
    begin
        PayDetailHeader.RESET;
        PayDetailHeader.SETRANGE("Employee No.", Rec."No.");
        PayDetailHeader.DELETEALL;
        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.SETRANGE("Employee No.", Rec."No.");
        PayDetailLine.DELETEALL;
        PayrollLedgerEntry.SETRANGE(Open, true);
        PayrollLedgerEntry.SETRANGE("Employee No.", Rec."No.");
        PayrollLedgerEntry.DELETEALL;
        MESSAGE('DONE');
    end;

    [EventSubscriber(ObjectType::Page, 5201, 'OnOpenPageEvent', '', false, false)]
    local procedure EmployeeListOnOpenPage(var Rec: Record Employee);
    var
        OpenEmployeesCardPageErr: Text;
    begin
        OpenEmployeesCardPageErr := PayrollFunctions.CanOpenEmployeesCardPage(USERID);
        if OpenEmployeesCardPageErr <> '' then
            ERROR(OpenEmployeesCardPageErr);
    end;

    [EventSubscriber(ObjectType::Page, 5233, 'OnAfterActionEvent', 'Insert System Codes', false, false)]
    local procedure HRSetupCardOnAfterActionInsertSystemCodes(var Rec: Record "Human Resources Setup");
    begin
        if CONFIRM('This Will Insert All System Codes. Do you Want to Continue ?', true) then
            HRFunction.InsertSystemCodes;
    end;

    [EventSubscriber(ObjectType::Page, 5233, 'OnAfterActionEvent', 'Create Pay Details', false, false)]
    local procedure HRSetupCardOnAfterActionCreatePayDetails(var Rec: Record "Human Resources Setup");
    begin
        HumanResSetup.GET;
        Employee.SETRANGE(Status, Employee.Status::Active);
        if HumanResSetup."Payroll in Use" then begin
            if Employee.FIND('-') then
                repeat
                    PayDetailLine.SETRANGE("Employee No.", Employee."No.");
                    PayDetailLine.SETRANGE(Open, true);
                    if not PayDetailLine.FIND('-') then begin
                        Employee."Exempt Tax" := PayrollFunctions.CalculateTaxCode(Employee, false, SpouseExemptTax, WORKDATE);
                        PayrollFunctions.CreatePayDetail(Employee);
                    end;
                until Employee.NEXT = 0;
        end; // pay. in use - Insert
    end;

    [EventSubscriber(ObjectType::Page, 5233, 'OnAfterActionEvent', 'Delete All Pay Details', false, false)]
    local procedure HRSetupCardOnAfterActionDeletePayDetails(var Rec: Record "Human Resources Setup");
    begin
        PayDetailHeader.RESET;
        PayDetailHeader.DELETEALL;
        PayDetailLine.SETRANGE(Open, true);
        PayDetailLine.DELETEALL;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure WorkflowEventHandlingOnAddWorkflowEventsToLibrary();
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        //Approval Cycle for Employee Salary History  27.11.2016: MChami EDM.Contracting+
        /*WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnSendSalaryRaiseForApprovalCode,DATABASE::"Employee Salary History",
          SalaryRaiseSendForApprovalEventDescTxt,0,FALSE);
        WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnCancelSalaryRaiseApprovalRequestCode,DATABASE::"Employee Salary History",
          SalaryRaiseApprovalRequestCancelEventDescTxt,0,FALSE);
        //Approval Cycle for Employee Salary History  27.11.2016: MChami EDM.Contracting-
        
        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting+
        
        WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnSendCalculatePayForApprovalCode,DATABASE::"Pay Details Approval",
          CalculatePaySendForApprovalEventDescTxt,0,FALSE);
        WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnCancelCalculatePayApprovalRequestCode,DATABASE::"Pay Details Approval",
          CalculatePayApprovalRequestCancelEventDescTxt,0,FALSE);
        
        WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnSendFinalizePayForApprovalCode,DATABASE::"Pay Details Approval",
          FinalizePaySendForApprovalEventDescTxt,0,FALSE);
        WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnCancelFinalizePayApprovalRequestCode,DATABASE::"Pay Details Approval",
          FinalizePayApprovalRequestCancelEventDescTxt,0,FALSE);
        
        WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnSendPaySlipForApprovalCode,DATABASE::"Pay Details Approval",
          PaySlipSendForApprovalEventDescTxt,0,FALSE);
        WorkflowEventHandling.AddEventToLibrary(PayrollFunctions.RunWorkflowOnCancelPaySlipApprovalRequestCode,DATABASE::"Pay Details Approval",
          PaySlipApprovalRequestCancelEventDescTxt,0,FALSE);
        //Approval Cycle for Pay Details Buttons -  05.12.2016: MChami EDM.Contracting-
        */

    end;

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure WorkflowResponseHandlingOnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128]);
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        /*CASE ResponseFunctionName OF
          PayrollFunctions.SetStatusToPendingApprovalCode:
            BEGIN
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SetStatusToPendingApprovalCode,PayrollFunctions.RunWorkflowOnSendSalaryRaiseForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SetStatusToPendingApprovalCode,PayrollFunctions.RunWorkflowOnSendCalculatePayForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SetStatusToPendingApprovalCode,PayrollFunctions.RunWorkflowOnSendFinalizePayForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SetStatusToPendingApprovalCode,PayrollFunctions.RunWorkflowOnSendPaySlipForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SetStatusToPendingApprovalCode,PayrollFunctions.RunWorkflowOnSendLoanForApprovalCode);
            END;
          PayrollFunctions.CreateApprovalRequestsCode:
            BEGIN
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CreateApprovalRequestsCode,PayrollFunctions.RunWorkflowOnSendSalaryRaiseForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CreateApprovalRequestsCode,PayrollFunctions.RunWorkflowOnSendCalculatePayForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CreateApprovalRequestsCode,PayrollFunctions.RunWorkflowOnSendFinalizePayForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CreateApprovalRequestsCode,PayrollFunctions.RunWorkflowOnSendPaySlipForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CreateApprovalRequestsCode,PayrollFunctions.RunWorkflowOnSendLoanForApprovalCode);
            END;
          PayrollFunctions.SendApprovalRequestForApprovalCode:
            BEGIN
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SendApprovalRequestForApprovalCode,PayrollFunctions.RunWorkflowOnSendSalaryRaiseForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SendApprovalRequestForApprovalCode,PayrollFunctions.RunWorkflowOnSendCalculatePayForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SendApprovalRequestForApprovalCode,PayrollFunctions.RunWorkflowOnSendFinalizePayForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SendApprovalRequestForApprovalCode,PayrollFunctions.RunWorkflowOnSendPaySlipForApprovalCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.SendApprovalRequestForApprovalCode,PayrollFunctions.RunWorkflowOnSendLoanForApprovalCode);
            END;
          PayrollFunctions.OpenDocumentCode:
            BEGIN
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.OpenDocumentCode,PayrollFunctions.RunWorkflowOnCancelSalaryRaiseApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.OpenDocumentCode,PayrollFunctions.RunWorkflowOnCancelCalculatePayApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.OpenDocumentCode,PayrollFunctions.RunWorkflowOnCancelFinalizePayApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.OpenDocumentCode,PayrollFunctions.RunWorkflowOnCancelPaySlipApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.OpenDocumentCode,PayrollFunctions.RunWorkflowOnCancelLoanApprovalRequestCode);
            END;
          PayrollFunctions.CancelAllApprovalRequestsCode:
            BEGIN
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CancelAllApprovalRequestsCode,PayrollFunctions.RunWorkflowOnCancelSalaryRaiseApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CancelAllApprovalRequestsCode,PayrollFunctions.RunWorkflowOnCancelCalculatePayApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CancelAllApprovalRequestsCode,PayrollFunctions.RunWorkflowOnCancelFinalizePayApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CancelAllApprovalRequestsCode,PayrollFunctions.RunWorkflowOnCancelPaySlipApprovalRequestCode);
              WorkflowResponseHandling.AddResponsePredecessor(PayrollFunctions.CancelAllApprovalRequestsCode,PayrollFunctions.RunWorkflowOnCancelLoanApprovalRequestCode);
            END;
        END;
        */

    end;
    /* Stopped By EDM.MM
        [EventSubscriber(ObjectType::Codeunit,1521,'OnReleaseDocument','',false,false)]
        local procedure WorkflowResponseHandlingOnReleaseDocument(var RecRef : RecordRef;UnsupportedRecordTypeErr : Text);
        begin
            /*CASE RecRef.NUMBER OF
              DATABASE::"Approval Entry":
                BEGIN
                  //Approval Cycle for Employee Salary History  27.11.2016: MChami EDM.Contracting+
                  ApprovalFieldNumber := ApprovalEntry."Approval Field Number";
                  //Approval Cycle for Employee Salary History  27.11.2016: MChami EDM.Contracting-

                  //Comments Approval Cycle for Employee Salary History  28.12.2016: MChami EDM.Contracting+
                  WorkflowStepInstanceID := ApprovalEntry."Workflow Step Instance ID";
                  //Comments Approval Cycle for Employee Salary History  28.12.2016: MChami EDM.Contracting-
                END;
              //Approval Cycle for Employee Salary History  27.11.2016: MChami EDM.Contracting+
              DATABASE::"Employee Salary History":
                ApproveSalaryRaise(Variant);
              DATABASE::"Pay Details Approval":
                ApprovePayDetail(Variant);
              //Approval Cycle for Employee Salary History  27.11.2016: MChami EDM.Contracting-
              //approval cycle for employee loan 2017-06 SC+
              DATABASE::"Employee Loan":
              ApproveLoan(Variant);
              //approval cycle for employee loan 2017-06 SC-
              ELSE
            END;*/

    // Stopped By EDM.MM end;

    [EventSubscriber(ObjectType::Page, 98001, 'OnAfterActionEvent', 'Hire', false, false)]
    local procedure ApplicantCardOnAfterActionHire(var Rec: Record Applicant);
    var
        EmployeeNo: Code[20];
        Applicant: Record Applicant;
    begin
        IF NOT CONFIRM('Are you sure you want to hire the applicant?', FALSE) THEN
            EXIT;

        EmployeeNo := Rec.HireTheApplicant(Rec."Employee No.");
        IF EmployeeNo <> 'ERROR' THEN BEGIN
            Applicant := Rec;
            Applicant."Employee No." := EmployeeNo;
            Applicant.Status := Applicant.Status::Hired;
            Applicant."Last Date Modified" := WORKDATE;
            Applicant."Application Phase" := Applicant."Application Phase"::Employed; // Added to auto set the phase to 'Employed' - 30.04.2018 : AIM +-
            Rec := Applicant;
            MESSAGE('The Current Applicant Hired');
        END;

    end;

    [EventSubscriber(ObjectType::Page, 98125, 'OnNewRecordEvent', '', false, false)]
    local procedure PobationEvaluationOnNewRecord(var Rec: Record "Probation Evaluation Sheet");
    var
        Test: Text;
    begin
        Test := Rec.GetFilter("Employee No.");
        if Test <> '' then
            Evaluate(Rec."Employee No.", Test);
    end;

    [EventSubscriber(ObjectType::Page, 98128, 'OnNewRecordEvent', '', false, false)]
    local procedure ITCheckListOnNewRecord(var Rec: Record "Check List");
    var
        Test: Text;
    begin
        Test := Rec.GetFilter("Employee No.");
        if Test <> '' then
            Evaluate(Rec."Employee No.", Test);
    end;

    [EventSubscriber(ObjectType::Page, 98127, 'OnNewRecordEvent', '', false, false)]
    local procedure NewHireCheckListOnNewRecord(var Rec: Record "Check List");
    var
        Test: Text;
    begin
        Test := Rec.GetFilter("Employee No.");
        if Test <> '' then
            Evaluate(Rec."Employee No.", Test);
    end;

    [EventSubscriber(ObjectType::Page, 98126, 'OnNewRecordEvent', '', false, false)]
    local procedure JobOfferOnNewRecord(var Rec: Record "Job Offer");
    var
        Test: Text;
        Applicant: Record Applicant;
    begin
        Test := Rec.GetFilter("Applicant No.");
        if Test <> '' then
            Evaluate(Rec."Applicant No.", Test);
    end;

    [EventSubscriber(ObjectType::Page, 98126, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure JobOfferApplicantNameOnAfterGetRecordEvent(var Rec: Record "Job Offer");
    var
        Applicant: Record Applicant;
    begin
        Applicant.SETFILTER("No.", Rec."Applicant No.");
        IF Applicant.FINDFIRST then begin
            IF Applicant."Middle Name" = '' then
                Rec."Applicant Name" := Applicant."First Name" + '' + Applicant."Last Name"
            ELSE
                Rec."Applicant Name" := Applicant."First Name" + '' + Applicant."Middle Name" + '' + Applicant."Last Name";
        END;
    end;

    [EventSubscriber(ObjectType::Page, 98003, 'OnQueryClosePageEvent', '', false, false)]

    local procedure HandPunchListOnQueryClosePage(var Rec: Record "Hand Punch"; var AllowClose: Boolean);
    var
        PayrollFunctions: Codeunit "Payroll Functions";
        KyStr: Text;
    begin
        Rec.CALCFIELDS("Employee No.", Period);
        KyStr := 'ACT-';
        IF PayrollFunctions.CanModifyAttendanceRecord(Rec."Real Date", Rec."Employee No.") THEN BEGIN
            IF CONFIRM('Update Attended Hours', TRUE) THEN
                KyStr := KyStr + 'ALL';
            PayrollFunctions.FixEmployeeDailyAttendanceHours(Rec."Employee No.", Rec.Period, Rec."Scheduled Date", TRUE, KyStr);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 98007, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventHandPunch(var Rec: Record "Hand Punch"; RunTrigger: Boolean);
    var
        PayrollFunctions: Codeunit "Payroll Functions";
        KyStr: Text;
        CompanyInfo: Record "Company Information";
    begin
        KyStr := 'ACT-';
        IF PayrollFunctions.CanModifyAttendanceRecord(Rec."Real Date", Rec."Employee No.") THEN BEGIN
            KyStr := KyStr + 'ALL';
            PayrollFunctions.FixEmployeeDailyAttendanceHours(Rec."Employee No.", Rec.Period, Rec."Scheduled Date", TRUE, KyStr);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 370, 'OnBeforeParseCellValue', '', false, false)]
    local procedure OnBeforeParseCellValue(var ExcelBuffer: Record "Excel Buffer"; var Value: Text; var FormatString: Text; var IsHandled: Boolean)
    var
        Decimal: Decimal;
    begin

        IsHandled := true;


        ExcelBuffer.NumberFormat := CopyStr(FormatString, 1, 30);

        if FormatString = '@' then begin
            ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
            ExcelBuffer."Cell Value as Text" := CopyStr(Value, 1, MaxStrLen(ExcelBuffer."Cell Value as Text"));
            exit;
        end;

        Evaluate(Decimal, Value);

        IF (STRPOS(FormatString, ':') <> 0) AND (((STRPOS(FormatString, 'y') <> 0) OR
            (STRPOS(FormatString, 'm') <> 0) OR
            (STRPOS(FormatString, 'd') <> 0)) AND
        (STRPOS(FormatString, 'Red') = 0)) THEN BEGIN
            ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Date;
            ExcelBuffer."Cell Value as Text" := FORMAT(ExcelBuffer.ConvertDateTimeDecimalToDateTime(Decimal));
            EXIT;
        END;

        if StrPos(FormatString, ':') <> 0 then begin
            // Excel Time is stored in OADate format
            ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Time;
            ExcelBuffer."Cell Value as Text" := Format(DT2Time(ExcelBuffer.ConvertDateTimeDecimalToDateTime(Decimal)));
            exit;
        end;

        if ((StrPos(FormatString, 'y') <> 0) or
            (StrPos(FormatString, 'm') <> 0) or
            (StrPos(FormatString, 'd') <> 0)) and
           (StrPos(FormatString, 'Red') = 0)
        then begin
            ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Date;
            ExcelBuffer."Cell Value as Text" := Format(DT2Date(ExcelBuffer.ConvertDateTimeDecimalToDateTime(Decimal)));
            exit;
        end;

        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Number;
        ExcelBuffer."Cell Value as Text" := Format(Round(Decimal, 0.000001), 0, 1);
    end;
}