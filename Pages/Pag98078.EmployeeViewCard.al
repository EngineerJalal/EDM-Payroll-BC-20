page 98078 "Employee View Card"
{
    // version NAVW13.00;SHR1.0;PY1.0,EDM.HRPY1

    Caption = 'Employee View Card';
    DeleteAllowed = false;
    Editable = true;
    LinksAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = Employee;
    SourceTableTemporary = false;
    SourceTableView = SORTING("No.");

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = IsEmpNoEditable;
                    ShowMandatory = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea=All;

                    trigger OnAssistEdit();
                    begin
                        //IF AssistEdit(xRec) THEN
                        //  CurrPage.UPDATE;
                    end;

                    trigger OnValidate();
                    begin

                        //Added in order to limit the size of the employee No. in order to reserve space in related tables for other fields - 27.07.2016 : AIM +
                        if STRLEN("No.") > 10 then
                            ERROR('Code can be of maximum 10 characters');
                        //Added in order to limit the size of the employee No. in order to reserve space in related tables for other fields - 27.07.2016 : AIM -

                        SetPageFilterOnFieldValidate;
                    end;
                }
                field("First Name"; "First Name")
                {
                    ShowMandatory = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetPageFilterOnFieldValidate;
                    end;
                }
                field("Middle Name"; "Middle Name")
                {
                    Caption = 'Middle Name';
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field("Last Name"; "Last Name")
                {
                    ShowMandatory = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetPageFilterOnFieldValidate;
                    end;
                }
                field("Full Name"; "Full Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Birth Date"; "Birth Date")
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field(Gender; Gender)
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field("Social Status"; "Social Status")
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field("No of Employee Relatives"; "No of Employee Relatives")
                {
                    ApplicationArea=All;
                }
                field("First Nationality Code"; "First Nationality Code")
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field("Second Nationality Code"; "Second Nationality Code")
                {
                    ApplicationArea=All;
                }
            }
            group("Arabic Info")
            {
                Caption = 'Arabic Info';
                field("Arabic First Name"; "Arabic First Name")
                {
                    Caption = 'الإسم';
                    ApplicationArea=All;
                }
                field("Arabic Middle Name"; "Arabic Middle Name")
                {
                    Caption = 'إسم الأب';
                    ApplicationArea=All;
                }
                field("Arabic Last Name"; "Arabic Last Name")
                {
                    Caption = 'الشهرة';
                    ApplicationArea=All;
                }
                field("Arabic Mother Name"; "Arabic Mother Name")
                {
                    Caption = 'اسم الوالدة';
                    ApplicationArea=All;
                }
                field("Arabic Name"; "Arabic Name")
                {
                    Caption = 'الإسم الثلاثي';
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Arabic Place of Birth"; "Arabic Place of Birth")
                {
                    Caption = 'مكان الولادة';
                    ApplicationArea=All;
                }
                field("Arabic Nationality"; "Arabic Nationality")
                {
                    Caption = 'الجنسية';
                    ApplicationArea=All;
                }
                field("Arabic Governorate"; "Arabic Governorate")
                {
                    Caption = 'المحافظة';
                    ApplicationArea=All;
                }
                field("Arabic Elimination"; "Arabic Elimination")
                {
                    Caption = 'القضاء';
                    ApplicationArea=All;
                }
                field("Arabic City"; "Arabic City")
                {
                    Caption = 'المنطقة';
                    ApplicationArea=All;
                }
                field("Arabic District"; "Arabic District")
                {
                    Caption = 'الحي';
                    ApplicationArea=All;
                }
                field("Arabic Street"; "Arabic Street")
                {
                    Caption = 'الشارع';
                    ApplicationArea=All;
                }
                field("Arabic Building"; "Arabic Building")
                {
                    Caption = 'المبنى';
                    ApplicationArea=All;
                }
                field("Arabic Floor"; "Arabic Floor")
                {
                    Caption = 'الطابق';
                    ApplicationArea=All;
                }
                field("Arabic Land Area"; "Arabic Land Area")
                {
                    Caption = 'المنطقة العقارية';
                    ApplicationArea=All;
                }
                field("Arabic Land Area  No."; "Arabic Land Area  No.")
                {
                    Caption = 'رقم العقار';
                    ApplicationArea=All;
                }
                field("Mailbox ID"; "Mailbox ID")
                {
                    Caption = 'رقم صندوق البريد';
                    ApplicationArea=All;
                }
                field("Arabic MailBox Area"; "Arabic MailBox Area")
                {
                    Caption = 'منطقة صندوق البريد';
                    ApplicationArea=All;
                }
                field("Register No."; "Register No.")
                {
                    Caption = 'رقم السجل';
                    ApplicationArea=All;
                }
                field("Arabic Registeration Place"; "Arabic Registeration Place")
                {
                    Caption = 'مكان السجل';
                    ApplicationArea=All;
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field("Driving License"; "Driving License")
                {
                    Caption = 'Driving License No.';
                    ApplicationArea=All;
                }
                field("Driving License Type"; "Driving License Type")
                {
                    ApplicationArea=All;
                }
                field("Driving License Expiry Date"; "Driving License Expiry Date")
                {
                    ApplicationArea=All;
                }
            }
            group(Health)
            {
                Caption = 'Health';
                field("Chronic Disease"; "Chronic Disease")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        if "Chronic Disease" then
                            "Chronic Disease DetailsEnable" := true
                        else
                            "Chronic Disease DetailsEnable" := false;
                    end;
                }
                field("Chronic Disease Details"; "Chronic Disease Details")
                {
                    Enabled = "Chronic Disease DetailsEnable";
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
                action("Page Employee Relatives1")
                {
                    Caption = '&Relatives';
                    Image = Relatives;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin

                        EmpRelativeTbt.SETRANGE(EmpRelativeTbt."Employee No.", "No.");
                        PAGE.RUN(80317, EmpRelativeTbt);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin

        LastFinalisePay := 0D;
        PayLedgEntry.SETRANGE("Employee No.", "No.");
        PayLedgEntry.SETFILTER("Posting Date", '<>%1', 0D);
        if PayLedgEntry.FIND('+') then
            LastFinalisePay := PayLedgEntry."Posting Date";

        if "Chronic Disease" then
            "Chronic Disease DetailsEnable" := true
        else
            "Chronic Disease DetailsEnable" := false;

        if IsForeigner then begin
            "Resident No.Enable" := true;
            "Resident Issue PlaceEnable" := true;
            "Resident Issue DateEnable" := true;
            "Resident Expiry DateEnable" := true;
            "Work Permit No.Enable" := true;
            "Work Permit Expiry DateEnable" := true;
            "Work Permit Issue DateEnable" := true;
            "Work Permit Issue PlaceEnable" := true
        end else begin
            "Resident No.Enable" := false;
            "Resident Issue PlaceEnable" := false;
            "Resident Issue DateEnable" := false;
            "Resident Expiry DateEnable" := false;
            "Work Permit No.Enable" := false;
            "Work Permit Expiry DateEnable" := false;
            "Work Permit Issue DateEnable" := false;
            "Work Permit Issue PlaceEnable" := false;
        end;
        if ("Last Vacation Date" <> 0D) and ("Vacation Group" <> '') then begin
            HRinformation.GET(HRinformation."Table Name"::"Vacation Group", "Vacation Group");
            "Next Vaction Date" := CALCDATE(HRinformation."Due Date", "Last Vacation Date");
        end;

        if ("Last Accomodation paid Date" <> 0D) and ("Accommodation Type" <> '') then begin
            HRinformation.GET(HRinformation."Table Name"::AccommodationType, "Accommodation Type");
            "Next Accom. Payment Date" := CALCDATE(HRinformation."Due Date", "Last Accomodation paid Date");
        end;


        //EDM.IT+
        //Add new count for Requested Documents
        RequestedDocument.RESET;
        RequestedDocument.SETRANGE("No.", "No.");
        if RequestedDocument.FIND('-') then
            NoOfDocuments := RequestedDocument.COUNT
        else
            NoOfDocuments := 0;


        //EDM+
        HumanResSetup.GET;
        if HumanResSetup."Payroll in Use" then begin
            if "No Exempt" = false then
                "Exempt Tax" := PayrollFunctions.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE)
            else
                "Exempt Tax" := 0;
        end;
        //EDM-

        //Added in order to refresh value when using Next button on 15.04.2016 - AIM +
        "TotalPay&allow" := CaluclateTotalAllowances();
        //Added in order to refresh value when using Next button on 15.04.2016 - AIM -

        //Added in order to update Service Years - 19.08.2016 : AIM +
        PayrollFunctions.CalculateServiceYears(Rec);
        //Added in order to update Service Years - 19.08.2016 : AIM -
    end;

    trigger OnClosePage();
    begin
        //Added in order to prevent error message - 18.10.2016 : AIM +
        if "No." <> '' then begin
            //Added in order to prevent error message - 18.10.2016 : AIM -
            //EDM+
            HumanResSetup.GET;
            if HumanResSetup."Payroll in Use" then begin
                if "No Exempt" = false then
                    "Exempt Tax" := PayrollFunctions.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE)
                else
                    "Exempt Tax" := 0;
                MODIFY;
            end;
            //EDM-
            //Added in order to prevent error message - 18.10.2016 : AIM +
        end;
        //Added in order to prevent error message - 18.10.2016 : AIM -
    end;

    trigger OnInit();
    begin
        "Work Permit Issue PlaceEnable" := true;
        "Work Permit Issue DateEnable" := true;
        "Work Permit Expiry DateEnable" := true;
        "Work Permit No.Enable" := true;
        "Resident Expiry DateEnable" := true;
        "Resident Issue DateEnable" := true;
        "Resident Issue PlaceEnable" := true;
        "Resident No.Enable" := true;

        "Chronic Disease DetailsEnable" := true;
        // based on User,filter on payroll group code
        if USERID <> '' then begin
            HRFunction.SetPayGroupFilter(PayGroup);
            PayGroup.FILTERGROUP(2);
            FILTERGROUP(2);
            SETFILTER("Payroll Group Code", PayGroup.GETFILTER(Code));
            FILTERGROUP(0);
            PayGroup.FILTERGROUP(0);
        end;

        UserRelatedEmpNo := PayrollFunctions.GetUserRelatedEmployeeNo(USERID);
        if UserRelatedEmpNo = '' then
            UserRelatedEmpNo := '...';

        FILTERGROUP(2);
        SETFILTER("No.", UserRelatedEmpNo);
        FILTERGROUP(0);
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin

        //Added in order to stop the buttons 'Previous / Next' - 04.10.2016 : AIM +
        exit;
        //Added in order to stop the buttons 'Previous / Next' - 04.10.2016 : AIM -
    end;

    trigger OnOpenPage();
    begin
        //Added for checking if user is allowed to access the employee card - 14.09.2016 : AIM +
        if PayrollFunctions.CanUserAccessEmployeeCard('', "No.") = false then
            ERROR('User does not have permission to access this card');
        //Added for checking if user is allowed to access the employee card - 14.09.2016 : AIM -

        //Modified in order to make salary permission by Payroll Group - 14.09.2016 : AIM +
        /*
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        ShowSalaryFld := NOT PayrollFunction.HideSalaryFields();
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
        */
        ShowSalaryFld := PayrollFunctions.CanUserAccessEmployeeSalary('', "No.");
        //Modified in order to make salary permission by Payroll Group - 14.09.2016 : AIM -




        //EDM.IT+
        /*IF UserSetup.GET(USERID) THEN
        BEGIN
          IF UserSetup."Show Salary" THEN
            ShowBasic:=TRUE
          ELSE
            ShowBasic:=FALSE;
        END
        ELSE
          ShowBasic:=FALSE;*/
        //Added in order to update Service Years - 19.08.2016 : AIM +
        PayrollFunctions.CalculateServiceYears(Rec);
        //Added in order to update Service Years - 19.08.2016 : AIM -
        //Added on 09.04.2016 - AIM +
        "TotalPay&allow" := CaluclateTotalAllowances();
        CurrPage.UPDATE;
        //Added on 09.04.2016 - AIM -
        ShowBasic := true;
        //EDM.IT-


        HumanResSetup.GET;
        if HumanResSetup."Employee No. Format Type" = HumanResSetup."Employee No. Format Type"::"[First Name] + [Last Name]" then
            IsEmpNoEditable := false;

        //Added in order to insert an empty record for Employee Additional Info - 18.11.2016 : AIM +
        PayrollFunctions.InsertDefaultEmployeeAdditionalInfoRecord("No.");
        //Added in order to insert an empty record for Employee Additional Info - 18.11.2016 : AIM -
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        //Added in order to set "Related to" as "No." if not assigned - 26.03.2016 : AIM +
        if "Related to" = '' then
            "Related to" := "No.";
        //Added in order to set "Related to" as "No." if not assigned - 26.03.2016 : AIM +

        //Added in order to assign default Web password - 23.06.2016 : AIM +
        if Password = '' then
            Password := "No.";
        //Added in order to assign default Web password - 23.06.2016 : AIM -

        //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM +
        HumanResSetup.RESET;
        HumanResSetup.GET();
        if HumanResSetup."Disable Data Entry Validation" = false then begin
            //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM -
            //Added in order to perform validations and allow the user close the employee file in case it is opened by mistake - 15.04.2016 : AIM +
            if ("First Name" <> '') or ("Middle Name" <> '') or ("Last Name" <> '') then begin
                TESTFIELD("First Name");
                TESTFIELD("Birth Date");
                TESTFIELD(Gender);
                TESTFIELD("Employment Date");
                TESTFIELD("Employment Type Code");
                TESTFIELD(Declared);
                TESTFIELD("Posting Group");
                TESTFIELD("Payroll Group Code");
                TESTFIELD("Employee Category Code");
            end
            //Added in order to perform validations and allow the user close the employee file in case it is opened by mistake - 15.04.2016 : AIM -
            //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM +
        end;
        //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM -

        //Added for validation on termination and Inactive date - 15.09.2016 : AIM +
        if "No." <> '' then begin
            if (Status = Status::Terminated) then begin
                if "Termination Date" = 0D then
                    ERROR('Enter Termination Date');
            end;
            if (Status = Status::Inactive) then begin
                if "Inactive Date" = 0D then
                    ERROR('Enter Inactive Date');
            end;
        end;
        //Added for validation on termination and Inactive date - 15.09.2016 : AIM -
    end;

    var
        Mail: Codeunit Mail;
        EmployeeJournals: Record "Employee Journal Line";
        EmploymentType: Record "Employment Type";
        HRFunction: Codeunit "Human Resource Functions";
        PayGroup: Record "HR Payroll Group";
        ExemptTax: Decimal;
        HumanResSetup: Record "Human Resources Setup";
        LastFinalisePay: Date;
        PayLedgEntry: Record "Payroll Ledger Entry";
        ExEmp: Record "HR Comment Line EDM";
        ChangeDimReason: Text[50];
        SurveyEmp: Record "HR Information";
        [InDataSet]
        "Chronic Disease DetailsEnable": Boolean;
        [InDataSet]
        "Resident No.Enable": Boolean;
        [InDataSet]
        "Resident Issue PlaceEnable": Boolean;
        [InDataSet]
        "Resident Issue DateEnable": Boolean;
        [InDataSet]
        "Resident Expiry DateEnable": Boolean;
        [InDataSet]
        "Work Permit No.Enable": Boolean;
        [InDataSet]
        "Work Permit Expiry DateEnable": Boolean;
        [InDataSet]
        "Work Permit Issue DateEnable": Boolean;
        [InDataSet]
        "Work Permit Issue PlaceEnable": Boolean;
        Text19015020: Label '*';
        Text19055759: Label 'Name';
        Text19080001: Label '*';
        Text19080002: Label '*';
        Text19080003: Label '*';
        Text19080004: Label '*';
        Text19080005: Label '*';
        Text19011380: Label 'Address';
        Text19080006: Label '*';
        Text19022216: Label 'Passport';
        Text19076066: Label 'Personal Details';
        Text19080007: Label '*';
        Text19080008: Label '*';
        Text19080009: Label '*';
        Text19080010: Label '*';
        Text19080011: Label '*';
        Text19080012: Label '*';
        Text19080013: Label '*';
        Text19060342: Label 'Job Details';
        Text19015574: Label 'Alt. Address';
        Text19080014: Label '*';
        Text19080015: Label '*';
        Text19080016: Label '*';
        Text19080017: Label '*';
        Text19080018: Label '*';
        Text19080019: Label '*';
        Text19080020: Label '*';
        Text19080021: Label '*';
        Text19080022: Label '*';
        Text19080023: Label '*';
        Text19080024: Label '*';
        Text19080025: Label '*';
        Text19080026: Label '*';
        Text19080027: Label '*';
        Text19080028: Label '*';
        Text19027318: Label '* Mandatory Fields';
        PayLedgerEntry: Record "Payroll Ledger Entry";
        PayDetailLine: Record "Pay Detail Line";
        PayrollStatus: Record "Payroll Status";
        PayrollFunctions: Codeunit "Payroll Functions";
        SpouseExemptTax: Boolean;
        PayDetailHeader: Record "Pay Detail Header";
        "Next Vaction Date": Date;
        "Next Accom. Payment Date": Date;
        HRinformation: Record "HR Information";
        UserSetup: Record "User Setup";
        [InDataSet]
        ShowBasic: Boolean;
        NoOfDocuments: Integer;
        RequestedDocument: Record "Requested Documents";
        "TotalPay&allow": Decimal;
        ShowSalaryFld: Boolean;
        IsEmpNoEditable: Boolean;
        EmployeePerm: Record Employee;
        EmpRelativeTbt: Record "Employee Relative";
        UserRelatedEmpNo: Code[20];

    local procedure CaluclateTotalAllowances(): Decimal;
    var
        V: Decimal;
    begin
        V := 0;
        V := V + "Basic Pay";
        V := V + "Phone Allowance";
        V := V + "Car Allowance";
        V := V + "House Allowance";
        V := V + "Other Allowances";
        V := V + "Food Allowance";
        V := V + "Ticket Allowance";

        exit(V);
    end;

    local procedure InsertEmployeeInfoFromRelatedFile(EmpNo: Code[20]; RelatedFile: Code[20]; ShowWarningMsg: Boolean);
    var
        RelatedFileTbt: Record Employee;
        EmpRelativesTbt: Record "Employee Relative";
        EmpQualificationsTbt: Record "Employee Qualification";
        EmpAcademicHistTbt: Record "Academic History";
        EmpLangSkillsTbt: Record "Language Skills";
        EmpCompSkillsTbt: Record "Employee Computer Skills";
        EmpDocTbt: Record "Requested Documents";
        RelRelativesTbt: Record "Employee Relative";
        RelQualificationsTbt: Record "Employee Qualification";
        RelAcademicHistTbt: Record "Academic History";
        RelLangSkillsTbt: Record "Language Skills";
        RelCompSkillsTbt: Record "Employee Computer Skills";
        RelDocTbt: Record "Requested Documents";
    begin
        if RelatedFile = '' then
            exit;

        if ShowWarningMsg = true then begin
            if CONFIRM('Are you sure you want to import data from employee %1', false, "Related to") = false then
                exit;
            if EmpNo = '' then
                ERROR('Enter Employee No.');

        end
        else begin
            if EmpNo = '' then
                exit;
        end;

        RelatedFileTbt.SETRANGE("No.", RelatedFile);
        if RelatedFileTbt.FINDFIRST then begin
            Rec.TRANSFERFIELDS(RelatedFileTbt, false);
            Rec."No." := EmpNo;
            Rec."Related to" := RelatedFile;
            Rec.Status := Rec.Status::Active;
            Rec."Termination Date" := 0D;
            Rec."Grounds for Term. Code" := '';
            Rec."Inactive Date" := 0D;
            Rec."Cause of Inactivity Code" := '';
            Rec."Declaration Date" := 0D;
            Rec."NSSF Date" := 0D;
            Rec."AL Starting Date" := 0D;
            Rec.Period := 0D;
            Rec."Employment Date" := WORKDATE;
            Rec.VALIDATE("Employment Date");
        end
        else
            exit;

        //********************************************************************

        EmpRelativesTbt.SETRANGE(EmpRelativesTbt."Employee No.", EmpNo);
        if EmpRelativesTbt.FINDFIRST then
            repeat
                EmpRelativesTbt.DELETE;
            until EmpRelativesTbt.NEXT = 0;

        RelRelativesTbt.SETRANGE(RelRelativesTbt."Employee No.", RelatedFile);
        if RelRelativesTbt.FINDFIRST then
            repeat
                EmpRelativesTbt.INIT;
                EmpRelativesTbt.TRANSFERFIELDS(RelRelativesTbt);
                EmpRelativesTbt."Employee No." := EmpNo;
                EmpRelativesTbt.INSERT;
            until RelRelativesTbt.NEXT = 0;

        //********************************************************************

        EmpQualificationsTbt.SETRANGE(EmpQualificationsTbt."Employee No.", EmpNo);
        if EmpQualificationsTbt.FINDFIRST then
            repeat
                EmpQualificationsTbt.DELETE;
            until EmpQualificationsTbt.NEXT = 0;

        RelQualificationsTbt.SETRANGE(RelQualificationsTbt."Employee No.", RelatedFile);
        if RelQualificationsTbt.FINDFIRST then
            repeat
                EmpQualificationsTbt.INIT;
                EmpQualificationsTbt.TRANSFERFIELDS(RelQualificationsTbt);
                EmpQualificationsTbt."Employee No." := EmpNo;
                EmpQualificationsTbt.INSERT;
            until RelQualificationsTbt.NEXT = 0;

        //********************************************************************


        EmpAcademicHistTbt.SETRANGE(EmpAcademicHistTbt."No.", EmpNo);
        EmpAcademicHistTbt.SETRANGE(EmpAcademicHistTbt."Table Name", EmpAcademicHistTbt."Table Name"::Employee);
        if EmpAcademicHistTbt.FINDFIRST then
            repeat
                EmpAcademicHistTbt.DELETE;
            until EmpAcademicHistTbt.NEXT = 0;

        RelAcademicHistTbt.SETRANGE(RelAcademicHistTbt."No.", RelatedFile);
        RelAcademicHistTbt.SETRANGE(RelAcademicHistTbt."Table Name", RelAcademicHistTbt."Table Name"::Employee);
        if RelAcademicHistTbt.FINDFIRST then
            repeat
                EmpAcademicHistTbt.INIT;
                EmpAcademicHistTbt.TRANSFERFIELDS(RelAcademicHistTbt);
                EmpAcademicHistTbt."No." := EmpNo;
                EmpAcademicHistTbt.INSERT;
            until RelAcademicHistTbt.NEXT = 0;

        //********************************************************************

        EmpLangSkillsTbt.SETRANGE(EmpLangSkillsTbt."No.", EmpNo);
        EmpLangSkillsTbt.SETRANGE(EmpLangSkillsTbt."Table Name", EmpLangSkillsTbt."Table Name"::Employee);
        if EmpLangSkillsTbt.FINDFIRST then
            repeat
                EmpLangSkillsTbt.DELETE;
            until EmpLangSkillsTbt.NEXT = 0;

        RelLangSkillsTbt.SETRANGE(RelLangSkillsTbt."No.", RelatedFile);
        RelLangSkillsTbt.SETRANGE(RelLangSkillsTbt."Table Name", RelLangSkillsTbt."Table Name"::Employee);
        if RelLangSkillsTbt.FINDFIRST then
            repeat
                EmpLangSkillsTbt.INIT;
                EmpLangSkillsTbt.TRANSFERFIELDS(RelLangSkillsTbt);
                EmpLangSkillsTbt."No." := EmpNo;
                EmpLangSkillsTbt.INSERT;
            until RelLangSkillsTbt.NEXT = 0;

        //********************************************************************

        EmpCompSkillsTbt.SETRANGE(EmpCompSkillsTbt."Employee No.", EmpNo);
        if EmpCompSkillsTbt.FINDFIRST then
            repeat
                EmpCompSkillsTbt.DELETE;
            until EmpCompSkillsTbt.NEXT = 0;

        RelCompSkillsTbt.SETRANGE(RelCompSkillsTbt."Employee No.", RelatedFile);
        if RelCompSkillsTbt.FINDFIRST then
            repeat
                EmpCompSkillsTbt.INIT;
                EmpCompSkillsTbt.TRANSFERFIELDS(RelCompSkillsTbt);
                EmpCompSkillsTbt."Employee No." := EmpNo;
                EmpCompSkillsTbt.INSERT;
            until RelCompSkillsTbt.NEXT = 0;

        //********************************************************************

        EmpDocTbt.SETRANGE(EmpDocTbt."No.", EmpNo);
        EmpDocTbt.SETRANGE(EmpDocTbt."Table Name", EmpDocTbt."Table Name"::Employee);
        if EmpDocTbt.FINDFIRST then
            repeat
                EmpDocTbt.DELETE;
            until EmpDocTbt.NEXT = 0;

        RelDocTbt.SETRANGE(RelDocTbt."No.", RelatedFile);
        RelDocTbt.SETRANGE(RelDocTbt."Table Name", RelDocTbt."Table Name"::Employee);
        if RelDocTbt.FINDFIRST then
            repeat
                EmpDocTbt.INIT;
                EmpDocTbt.TRANSFERFIELDS(RelDocTbt);
                EmpDocTbt."No." := EmpNo;
                EmpDocTbt.INSERT;
            until RelDocTbt.NEXT = 0;


        //********************************************************************
    end;

    local procedure SetPageFilterOnFieldValidate();
    begin
        FILTERGROUP(2);
        SETFILTER("No.", "No.");
        FILTERGROUP(0);
    end;

    local procedure DisableClosePageWithoutEnterRequiredFields();
    begin
        HumanResSetup.RESET;
        HumanResSetup.GET();
        if HumanResSetup."Disable Data Entry Validation" = false then begin
            if ("First Name" <> '') or ("Middle Name" <> '') or ("Last Name" <> '') then begin
                TESTFIELD("First Name");
                TESTFIELD("Middle Name");
                TESTFIELD("Last Name");
                TESTFIELD("Birth Date");
                TESTFIELD(Gender);
                TESTFIELD("First Nationality Code");
                /*       TESTFIELD("Arabic First Name");
                        TESTFIELD("Arabic Middle Name");
                        TESTFIELD("Arabic Last Name");
                        TESTFIELD("Arabic Mother Name");
                        TESTFIELD("Arabic Name");
                        TESTFIELD("Arabic Place of Birth");
                        TESTFIELD("Arabic Nationality");
                        TESTFIELD("Arabic Governorate");
                        TESTFIELD("Arabic Elimination");
                        TESTFIELD("Arabic City");
                        TESTFIELD("Arabic District");
                        TESTFIELD("Arabic Street");
                        TESTFIELD("Arabic Building");
                        TESTFIELD("Arabic Floor");
                        TESTFIELD("Arabic Land Area");
                        TESTFIELD("Arabic Land Area  No.");
                        TESTFIELD("Mailbox ID");
                        TESTFIELD("Arabic MailBox Area");
                        TESTFIELD("Register No.");
                        TESTFIELD("Arabic Registeration Place");
                */

            end;
        end;

    end;
}

