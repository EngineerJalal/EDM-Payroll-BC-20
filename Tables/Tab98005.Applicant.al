table 98005 Applicant
{

    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    DrillDownPageID = "Applicant List";
    LookupPageID = "Applicant List";

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Applicant Nos.");
                    "No. Series" := HumanResSetup."Applicant Nos.";
                end;
            end;
        }
        field(2; "First Name"; Text[30])
        {
        }
        field(3; "Middle Name"; Text[30])
        {
        }
        field(4; "Last Name"; Text[30])
        {
        }
        field(5; Initials; Text[30])
        {

            trigger OnValidate();
            begin
                if ("Search Name" = UPPERCASE(xRec.Initials)) or ("Search Name" = '') then
                    "Search Name" := Initials;
            end;
        }
        field(6; "Job Title"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Title"));
        }
        field(7; "Search Name"; Code[30])
        {
        }
        field(8; Address; Text[200])
        {
        }
        field(9; "Address 2"; Text[30])
        {
        }
        field(10; City; Text[30])
        {
        }
        field(11; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                if PostCode.GET("Post Code") then
                    City := PostCode.City;
            end;
        }
        field(12; County; Text[30])
        {
        }
        field(13; "Phone No."; Text[30])
        {
        }
        field(14; "Mobile Phone No."; Text[30])
        {
        }
        field(15; "E-Mail"; Text[80])
        {
        }
        field(19; Picture; BLOB)
        {
            ObsoleteState = Removed;
            SubType = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
        }
        field(24; Sex; Option)
        {
            Caption = 'Gender';
            OptionCaption = '" ,Female,Male"';
            OptionMembers = " ",Female,Male;
        }
        field(25; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(31; Status; Option)
        {
            OptionMembers = Idle,"Not Offered",Hired,Rejected,"Not Qualified",Waiting,"Potential Candidate";

            trigger OnValidate();
            begin
                if (Status = Status::Hired) then
                    ERROR('Invalid Value : Status connot be Changed to "Hired"');
            end;
        }
        field(36; "Department Code"; Code[10])
        {
        }
        field(40; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(50; "Company E-Mail"; Text[80])
        {
        }
        field(51; "Available From"; Date)
        {
        }
        field(52; "Requested Salary"; Decimal)
        {
        }
        field(53; "Requested Salary Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(56; "Religion Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Religion"));
        }
        field(57; "User ID"; Code[30])
        {
            Description = 'HR';
            TableRelation = User;
        }
        field(58; "Social Status"; Option)
        {
            OptionMembers = Single,Married,Widow,Divorced,Separated;
        }
        field(59; "Government ID No"; Text[30])
        {
        }
        field(61; "Military Status"; Option)
        {
            OptionMembers = "Not Applicable",Completed,"T-Exempt","Not Requested","Under Request","Under Recordation";
        }
        field(62; "First Nationality Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(63; "Second Nationality Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(64; "Health Card No"; Text[30])
        {
        }
        field(65; "Health Card Issue Place"; Text[30])
        {
        }
        field(66; "Health Card Issue Date"; Date)
        {
        }
        field(67; "Health Card Expiry Date"; Date)
        {

            trigger OnValidate();
            begin
                if "Health Card Expiry Date" < "Health Card Issue Date" then
                    ERROR('Epxiry Date must be Greater than Issue Date');
            end;
        }
        field(68; "Chronic Disease"; Boolean)
        {
        }
        field(69; "Chronic Disease Details"; Text[30])
        {
        }
        field(70; "Other Health Information"; Text[30])
        {
        }
        field(71; "Passport No."; Text[30])
        {
        }
        field(72; "Passport Issue Place"; Text[30])
        {
        }
        field(73; "Passport Issue Date"; Date)
        {
        }
        field(74; "Passport Expiry Date"; Date)
        {

            trigger OnValidate();
            begin
                if "Passport Expiry Date" < "Passport Issue Date" then
                    ERROR('Epxiry Date must be Greater than Issue Date');
            end;
        }
        field(75; IsForeigner; Boolean)
        {
        }
        field(76; "Resident No."; Text[30])
        {
        }
        field(77; "Resident Issue Place"; Text[30])
        {
        }
        field(78; "Resident Issue Date"; Date)
        {
        }
        field(79; "Resident Expiry Date"; Date)
        {

            trigger OnValidate();
            begin
                if "Resident Expiry Date" < "Resident Issue Date" then
                    ERROR('Epxiry Date must be Greater than Issue Date');
            end;
        }
        field(80; "Applied For"; Code[50])
        {
            Editable = true;
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Title"));
        }
        field(81; "Job Position Code"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Position"));
        }
        field(82; "Hired Date"; Date)
        {
            CaptionClass = 'Joining Date';
        }
        field(83; "Vacation Code"; Code[10])
        {
            TableRelation = "Company Organization";
        }
        field(84; "Employee Category Code"; Code[10])
        {
            TableRelation = "Employee Categories";
        }
        field(85; "Agreed Salary"; Decimal)
        {

            trigger OnValidate();
            begin
                HumanResSetup.GET;
                if "Agreed Salary" < HumanResSetup."Minimum Salary" then
                    ERROR('Salary Should not be Less than : %1 ', HumanResSetup."Minimum Salary");
            end;
        }
        field(86; "Agreed Salary Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(88; "Employee No."; Code[20])
        {
            Editable = true;

            trigger OnValidate();
            begin
                HumanResSetup.GET;
                if HumanResSetup."Employee Nos." <> '' then begin
                    NoSeries.GET(HumanResSetup."Employee Nos.");
                    if (not NoSeries."Manual Nos.") and ("Employee No." <> '') then
                        ERROR('No.Series for Employees is not Manual');
                end;
            end;
        }
        field(89; "Dimensions Hired For"; Integer)
        {
            CalcFormula = Count("HR Dimensions" WHERE("Table ID" = CONST(17353), "No." = FIELD("No."), Type = CONST("Hired For")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(91; "Experienced Years"; Integer)
        {
        }
        field(92; "Graduation Information"; Text[100])
        {
        }
        field(93; "Previously NSSF Secured"; Boolean)
        {
        }
        field(95; "Work Permit No."; Text[30])
        {
            Description = 'PY1.0';
        }
        field(96; "Work Permit Expiry Date"; Date)
        {
            Description = 'PY1.0';
        }
        field(97; "Payroll Group Code"; Code[10])
        {
            Description = 'SHR1.0;PY1.0';
            TableRelation = "HR Payroll Group";

            trigger OnValidate();
            begin
                if (USERID <> '') and ("Payroll Group Code" <> '') then
                    PayUser.GET("Payroll Group Code", USERID);
            end;
        }
        field(98; "Requested Rate Indicator"; Option)
        {
            Description = 'PY1.0';
            OptionMembers = Monthly,Annual,Weekly,Hourly;
        }
        field(99; "Pay Frequency"; Option)
        {
            OptionMembers = Monthly,Weekly;

            trigger OnValidate();
            begin
                if "Pay Frequency" <> "Pay Frequency"::Monthly then
                    ERROR('The %1 Pay Frequency need to be Set Up', "Pay Frequency");
            end;
        }
        field(100; "No of Children"; Integer)
        {
            CalcFormula = Count("Applicant Relative" WHERE("Applicant No." = FIELD("No."), "Eligible Child" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(80000; Comment; Boolean)
        {
            CalcFormula = Exist("HR Comment Line EDM" WHERE("Table Name" = CONST("Applicant"), "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80001; "Mother Name"; Text[30])
        {
        }
        field(80002; "Application No."; Integer)
        {
        }
        field(80003; "National No."; Text[30])
        {
        }
        field(80004; "Physical File No."; Text[30])
        {
            CaptionClass = 'Application Ref. Code';
        }
        field(80005; "Arabic Name"; Text[50])
        {
        }
        field(80006; "Recommendation Name"; Text[50])
        {
        }
        field(80007; "Recommendation Date"; Date)
        {
        }
        field(80008; "Blood Type"; Code[10])
        {
            Description = 'SHR2.0';
        }
        field(80009; "Work Permit Issue Date"; Date)
        {
            Description = 'SHR2.0';
        }
        field(80010; "Work Permit Issue Place"; Text[30])
        {
            Description = 'SHR2.0';
        }
        field(80011; "Applicant Picture"; BLOB)
        {
            ObsoleteState = Removed;
        }
        field(80012; "Application Status"; Option)
        {
            OptionCaption = 'Saved,Submitted';
            OptionMembers = Saved,Submitted;
        }
        field(80013; "Place of Birth"; Text[30])
        {
        }
        field(80014; "Preferred Work Schedule"; Text[30])
        {
        }
        field(80015; Weight; Text[30])
        {
        }
        field(80016; Length; Text[30])
        {
        }
        field(80017; Locations; Option)
        {
            OptionCaption = 'Jounieh,Marj Ayon,Nabateih,Rmeileh';
            OptionMembers = Jounieh,"Marj Ayon"," Nabateih",Rmeileh;
        }
        field(80018; "Personal Finance No."; Code[20])
        {
        }
        field(80019; "Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
        }
        field(80022; "Employment Date"; Date)
        {
            CalcFormula = Min(Employee."Employment Date" WHERE("Applicant No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80023; "Termination Date"; Date)
        {
            CalcFormula = Max(Employee."Termination Date" WHERE("Applicant No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80024; "Termination Reason"; Code[10])
        {
            CalcFormula = Max(Employee."Grounds for Term. Code" WHERE("Applicant No." = FIELD("No.")));
            FieldClass = FlowField;
            TableRelation = "Grounds for Termination";
        }
        field(80025; "Is Employed"; Boolean)
        {
            CalcFormula = Exist(Employee WHERE("Applicant No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80026; "Application Phase"; Option)
        {
            OptionCaption = 'Idle,Received,InProgress,Interviewed,Employed,Rejected,Future Employment,Ignored';
            OptionMembers = Idle,Received,InProgress,Interviewed,Employed,Rejected,"Future Employment",Ignored;
        }
        field(80027; "Matching Employee No"; Code[20])
        {
            CalcFormula = Min(Employee."No." WHERE("Applicant No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80028; "Notice Period"; Integer)
        {
            CaptionClass = 'Notice Period (Days)';
        }
        field(80029; "First Interview Date"; Date)
        {
            CalcFormula = Min("HR Comment Line EDM".Date WHERE("Table Name" = FILTER("Applicant"), "No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80030; "Next Interview Date"; Date)
        {
            CalcFormula = Max("HR Comment Line EDM"."Next Interview Date" WHERE("Table Name" = FILTER("Applicant"), "No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80031; "Latest Interview Date"; Date)
        {
            CalcFormula = Max("HR Comment Line EDM".Date WHERE("Table Name" = FILTER("Applicant"), "No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80032; "Latest Academic Graduate Date"; Date)
        {
            CalcFormula = Max("Academic History"."To Date" WHERE("Table Name" = CONST(Applicant), "No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80033; "Application Date"; Date)
        {
        }
        field(90040; Department; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(17353), "No." = FIELD("No."), "Dimension Code" = FILTER('DEPARTMENT' | 'DEPARMTNE')));
            Caption = 'Department.';
            FieldClass = FlowField;
        }
        field(90041; Division; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(17353), "No." = FIELD("No."), "Dimension Code" = CONST('DIVISION')));
            Caption = 'Employee Division';
            FieldClass = FlowField;
        }
        field(90042; Branch; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(17353), "No." = FIELD("No."), "Dimension Code" = CONST('BRANCH')));
            Caption = 'Employee Branch';
            FieldClass = FlowField;
        }
        field(90043; Project; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(17353), "No." = FIELD("No."), "Dimension Code" = FILTER('PROJECT')));
            Caption = 'Project.';
            FieldClass = FlowField;
        }
        field(90044; Location; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Location"));
        }
        field(90045; "Job Category"; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Category"));
        }
        field(90046; "Employment Type Code"; Code[20])
        {
            Description = 'SHR1.0';
            NotBlank = false;
            TableRelation = "Employment Type";
        }
        field(90047; Picture2; Media)
        {

        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Search Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if (xRec.Status = Status::Hired) then
            ERROR('Hired Applicant cannot be Deleted');

        HRConfidentialComments.SETRANGE("Applicant No.", "No.");
        HRConfidentialComments.DELETEALL;

        HRConfidentialCommentLine.SETRANGE("No.", "No.");
        HRConfidentialCommentLine.DELETEALL;

        AcademicHistory.SETRANGE("Table Name", AcademicHistory."Table Name"::Applicant);
        AcademicHistory.SETRANGE("No.", "No.");
        AcademicHistory.DELETEALL;

        EmploymentHistory.SETRANGE("No.", "No.");
        EmploymentHistory.DELETEALL;

        LanguageSkills.SETRANGE("No.", "No.");
        LanguageSkills.DELETEALL;

        HumanResComments.SETRANGE("No.", "No.");
        HumanResComments.DELETEALL;

        HRDimensions.SETRANGE("No.", "No.");
        HRDimensions.DELETEALL;

        ARelative.SETRANGE("Applicant No.", "No.");
        ARelative.DELETEALL;
    end;

    trigger OnInsert();
    begin
        if "No." = '' then begin
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Applicant Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Applicant Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "Creation Date" := TODAY;
        AitsCodeUnit.InsertAlertApplicant("No.", "First Name" + ' ' + "Last Name");
    end;

    trigger OnModify();
    begin
        if (xRec.Status = Status::Hired) then
            ERROR('Hired Applicant cannot be Modified');

        "Last Date Modified" := TODAY;
        "User ID" := USERID;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
        "User ID" := USERID;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        PostCode: Record "Post Code";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Applicant: Record Applicant;
        HRConfidentialComments: Record "HR Confidential Comments";
        AcademicHistory: Record "Academic History";
        EmploymentHistory: Record "Employment History";
        LanguageSkills: Record "Language Skills";
        HumanResComments: Record "HR Comment Line EDM";
        Employee: Record Employee;
        NoSeries: Record "No. Series";
        ConfidentialInformation: Record "Confidential Information";
        EmployeeNo: Code[20];
        HRConfidentialCommentLine: Record "HR Confidential Comment Line";
        HRConfidentialCommentLine2: Record "HR Confidential Comment Line";
        HumanResComments2: Record "HR Comment Line EDM";
        HRDimensions: Record "HR Dimensions";
        DefaultDimension: Record "Default Dimension";
        HRFunctions: Codeunit "Human Resource Functions";
        PayUser: Record "HR Payroll User";
        ARelative: Record "Applicant Relative";
        ERelative: Record "Employee Relative";
        AcademicHistory2: Record "Academic History";
        EmploymentHistory2: Record "Employment History";
        LanguageSkills2: Record "Language Skills";
        ReqDoc: Record "Requested Documents";
        ReqDoc2: Record "Requested Documents";
        HRInfo: Record "HR Information";
        AitsCodeUnit: Codeunit "EDM Functions";
        PayrollFunction: Codeunit "Payroll Functions";

    procedure AssistEdit(OldApplicant: Record Applicant): Boolean;
    begin
        with Applicant do begin
            Applicant := Rec;
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Applicant Nos.");
            if NoSeriesMgt.SelectSeries(HumanResSetup."Applicant Nos.", OldApplicant."No. Series", "No. Series") then begin
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Applicant Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := Applicant;
                exit(true);
            end;
        end;
    end;

    procedure FullName(): Text[100];
    begin
        if "Middle Name" = '' then
            exit("First Name" + ' ' + "Last Name")
        else
            exit("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    procedure HireTheApplicant(P_EmployeeNo: Code[20]): Code[20];
    var
        EmpTBT: Record Employee;
        MinNo: Code[50];
        MaxNo: Code[50];
        ApplicantDefaultDim: Record "Default Dimension";
        L_PayrollStatusTbt: Record "Payroll Status";
        L_PayDetailLinetbt: Record "Pay Detail Line";
        L_SpouseExempTax: Boolean;
    begin
        if Status = Status::Hired then
            ERROR('Applicant Already Hired !');

        TESTFIELD("Hired Date");
        TESTFIELD("Employee Category Code");
        TESTFIELD("Employment Type Code");
        TESTFIELD("Job Title");
        TESTFIELD("Payroll Group Code");

        EmployeeNo := "Employee No.";

        Employee.INIT;
        HumanResSetup.GET;

        if EmployeeNo <> '' then begin
            CLEAR(EmpTBT);
            EmpTBT.SETCURRENTKEY("No.");
            EmpTBT.SETRANGE("No.", EmployeeNo);
            if EmpTBT.FINDFIRST then
                ERROR('The employee Nb. %1 already exists', EmployeeNo);
        end
        else begin
            if HumanResSetup."Employee Nos." <> '' then begin
                NoSeries.GET(HumanResSetup."Employee Nos.");
                if NoSeries."Default Nos." then
                    NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.", xRec."No. Series", 0D, EmployeeNo, "No. Series");
            end
            else begin
                EmpTBT.SETCURRENTKEY("No.");
                if EmpTBT.FINDFIRST then
                    MinNo := EmpTBT."No.";
                if EmpTBT.FINDLAST then
                    MaxNo := EmpTBT."No.";
                if (MinNo = '') or (MaxNo = '') then
                    EmployeeNo := '00000000'
                else begin
                    CLEAR(EmpTBT);
                    EmpTBT.SETFILTER(EmpTBT."No.", '%1..%2', MinNo, MaxNo);
                    EmployeeNo := EmpTBT.GETRANGEMAX(EmpTBT."No.");
                end;
                if EmployeeNo = '' then
                    EmployeeNo := '00000000';
                EmployeeNo := INCSTR(EmployeeNo);
            end;
        end;
        if EmployeeNo = '' then
            ERROR('Employee No. cannot be null');
        CLEAR(EmpTBT);
        EmpTBT.SETCURRENTKEY("No.");
        EmpTBT.SETRANGE("No.", EmployeeNo);
        if EmpTBT.FINDFIRST then
            ERROR('The employee Nb. %1 already exists', EmployeeNo);

        Employee."No." := EmployeeNo;
        Employee."Applicant No." := "No.";
        Employee."First Name" := "First Name";
        Employee."Middle Name" := "Middle Name";
        Employee."Mother Name" := "Mother Name";
        Employee."Last Name" := "Last Name";
        Employee."Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
        Employee."Search Name" := "Search Name";
        Employee.VALIDATE(Initials, Initials);
        Employee."Job Title" := "Job Title";
        Employee.Address := Address;
        if City <> '' then
            Employee.Address := Employee.Address + ',' + City;
        if County <> '' then
            Employee.Address := Employee.Address + ',' + County;

        Employee."Address 2" := "Address 2";
        Employee.City := City;
        Employee.VALIDATE("Post Code", "Post Code");
        Employee.County := County;
        Employee."Phone No." := "Phone No.";
        Employee."Mobile Phone No." := "Mobile Phone No.";
        Employee."E-Mail" := "E-Mail";
        Employee."Company E-Mail" := "Company E-Mail";
        if IsForeigner then begin
            Employee.Foreigner := Employee.Foreigner::"Not End of Service";
            Employee.Declared := Employee.Declared::"Non-Declared";
        end
        else begin
            Employee.Foreigner := Employee.Foreigner::" ";
            Employee.Declared := Employee.Declared::"Non-Declared";
        end;
        Employee.VALIDATE("Birth Date", "Birth Date");
        CALCFIELDS(Picture2);
        Employee.Image := Picture2;
        Employee.Gender := Sex;
        Employee."Employment Date" := "Hired Date";
        Employee.Status := Employee.Status::Active;
        Employee."No. Series" := HumanResSetup."Employee Nos.";
        Employee."Government ID No." := "Government ID No";
        Employee."Social Status" := "Social Status";
        Employee."No of Children" := "No of Children";
        Employee."Religion Code" := "Religion Code";
        Employee."First Nationality Code" := "First Nationality Code";
        Employee."Second Nationality Code" := "Second Nationality Code";
        Employee."Vacation Code" := "Vacation Code";
        Employee."Employee Category Code" := "Employee Category Code";
        Employee."Job Title" := "Job Title";
        Employee."Job Position Code" := "Job Position Code";
        Employee."Military Status" := "Military Status";
        Employee."Health Card No" := "Health Card No";
        Employee."Health Card Issue Place" := "Health Card Issue Place";
        Employee."Health Card Issue Date" := "Health Card Issue Date";
        Employee."Health Card Expiry Date" := "Health Card Expiry Date";
        Employee."Chronic Disease" := "Chronic Disease";
        Employee."Chronic Disease Details" := "Chronic Disease Details";
        Employee."Other Health Information" := "Other Health Information";
        Employee."Previously NSSF Secured" := "Previously NSSF Secured";
        Employee."Passport No." := "Passport No.";
        Employee."Passport Issue Place" := "Passport Issue Place";
        Employee."Passport Issue Date" := "Passport Issue Date";
        Employee."Passport Expiry Date" := "Passport Expiry Date";
        Employee.IsForeigner := IsForeigner;
        Employee."Resident No." := "Resident No.";
        Employee."Resident Issue Place" := "Resident Issue Place";
        Employee."Resident Issue Date" := "Resident Issue Date";
        Employee."Work Permit No." := "Work Permit No.";
        Employee."Work Permit Issue Date" := "Work Permit Issue Date";
        Employee."Work Permit Issue Place" := "Work Permit Issue Place";
        Employee."Blood Type" := "Blood Type";
        Employee."Work Permit Expiry Date" := "Work Permit Expiry Date";
        Employee."Applicant Exist" := true;
        Employee."Pay Frequency" := Employee."Pay Frequency"::Monthly;
        Employee."Basic Pay" := "Agreed Salary";
        Employee."Resident Expiry Date" := "Resident Expiry Date";
        Employee."Payroll Group Code" := "Payroll Group Code";
        Employee."National No." := "National No.";
        Employee."Recommendation Name" := "Recommendation Name";
        Employee."Recommendation Date" := "Recommendation Date";
        Employee."Arabic Name" := "Arabic Name";
        Employee.Location := Location;
        Employee."Job Category" := "Job Category";
        Employee.VALIDATE("Employment Type Code", "Employment Type Code");
        Employee.INSERT(true);
        ApplicantDefaultDim.RESET;
        CLEAR(ApplicantDefaultDim);
        ApplicantDefaultDim.SETRANGE("No.", Rec."No.");
        ApplicantDefaultDim.SETRANGE("Table ID", 60000);
        IF ApplicantDefaultDim.FINDFIRST THEN
            REPEAT
                DefaultDimension.INIT;
                DefaultDimension.VALIDATE("Table ID", 5200);
                DefaultDimension.VALIDATE("No.", EmployeeNo);
                DefaultDimension.VALIDATE("Dimension Code", ApplicantDefaultDim."Dimension Code");
                DefaultDimension.VALIDATE("Dimension Value Code", ApplicantDefaultDim."Dimension Value Code");
                DefaultDimension.INSERT(TRUE);
            UNTIL ApplicantDefaultDim.NEXT = 0;

        HRFunctions.DefaultDimToDocumentDim(EmployeeNo, 1, '', '');
        with HRConfidentialComments do begin
            SETRANGE("Applicant No.", "No.");
            if FindFirst then
                repeat
                    ConfidentialInformation.INIT;
                    ConfidentialInformation."Employee No." := EmployeeNo;
                    ConfidentialInformation."Confidential Code" := "Confidential Code";
                    ConfidentialInformation.Description := Description;
                    ConfidentialInformation."Line No." := "Line No.";
                    ConfidentialInformation.INSERT(true);
                until NEXT = 0;
        end;
        with HRConfidentialCommentLine do begin
            SETRANGE("Table Name", "Table Name"::"Confidential Information");
            SETRANGE("No.", Rec."No.");
            if FindFirst then
                repeat
                    HRConfidentialCommentLine2.INIT;
                    HRConfidentialCommentLine2.TRANSFERFIELDS(HRConfidentialCommentLine);
                    HRConfidentialCommentLine2."Table Name" := HRConfidentialCommentLine2."Table Name"::"Confidential Information";
                    HRConfidentialCommentLine2."No." := EmployeeNo;
                    HRConfidentialCommentLine2.INSERT(true);
                until NEXT = 0;
        end;
        with HumanResComments do begin
            SETRANGE("Table Name", "Table Name"::Applicant);
            SETRANGE("No.", Rec."No.");
            if FindFirst then
                repeat
                    HumanResComments2.INIT;
                    HumanResComments2.TRANSFERFIELDS(HumanResComments);
                    HumanResComments2."Table Name" := HumanResComments2."Table Name"::Employee;
                    HumanResComments2."No." := EmployeeNo;
                    HumanResComments2.INSERT(true);
                until NEXT = 0;
        end;
        with ARelative do begin
            SETRANGE("Applicant No.", "No.");
            if FindFirst then
                repeat
                    ERelative.INIT;
                    ERelative.TRANSFERFIELDS(ARelative);
                    ERelative."Employee No." := EmployeeNo;
                    ERelative.INSERT(true);
                until NEXT = 0;
        end;
        with AcademicHistory do begin
            SETRANGE("Table Name", "Table Name"::Applicant);
            SETRANGE("No.", Rec."No.");
            if FindFirst then
                repeat
                    AcademicHistory2.INIT;
                    AcademicHistory2.TRANSFERFIELDS(AcademicHistory);
                    AcademicHistory2."Table Name" := AcademicHistory2."Table Name"::Employee;
                    AcademicHistory2."No." := EmployeeNo;
                    AcademicHistory2.INSERT(true);
                until NEXT = 0;
        end;
        with EmploymentHistory do begin
            SETRANGE("Table Name", "Table Name"::Applicant);
            SETRANGE("No.", Rec."No.");
            if FindFirst then
                repeat
                    EmploymentHistory2.INIT;
                    EmploymentHistory2.TRANSFERFIELDS(EmploymentHistory);
                    EmploymentHistory2."Table Name" := EmploymentHistory2."Table Name"::Employee;
                    EmploymentHistory2."No." := EmployeeNo;
                    EmploymentHistory2.INSERT(true);
                until NEXT = 0;
        end;
        with ReqDoc do begin
            SETRANGE("Table Name", "Table Name"::Applicant);
            SETRANGE("No.", Rec."No.");
            if FindFirst then
                repeat
                    ReqDoc2.INIT;
                    ReqDoc2.TRANSFERFIELDS(ReqDoc);
                    ReqDoc2."Table Name" := ReqDoc2."Table Name"::Employee;
                    ReqDoc2."No." := EmployeeNo;
                    ReqDoc2.INSERT(true);
                until NEXT = 0;
        end;
        with LanguageSkills do begin
            SETRANGE("Table Name", "Table Name"::Applicant);
            SETRANGE("No.", Rec."No.");
            if FindFirst then
                repeat
                    LanguageSkills2.INIT;
                    LanguageSkills2.TRANSFERFIELDS(LanguageSkills);
                    LanguageSkills2."Table Name" := LanguageSkills2."Table Name"::Employee;
                    LanguageSkills2."No." := EmployeeNo;
                    LanguageSkills2.INSERT(true);
                until NEXT = 0;
        end;
        HumanResSetup.GET;
        IF HumanResSetup."Payroll in Use" THEN BEGIN
            L_PayDetailLinetbt.SETRANGE("Employee No.", EmployeeNo);
            L_PayDetailLinetbt.SETRANGE(Open, TRUE);
            IF NOT L_PayDetailLinetbt.FINDFIRST THEN BEGIN
                EmpTBT.RESET;
                CLEAR(EmpTBT);
                EmpTBT.SETRANGE(EmpTBT."No.", EmployeeNo);
                IF EmpTBT.FINDFIRST THEN BEGIN
                    IF L_PayrollStatusTbt.GET(EmpTBT."Payroll Group Code") THEN BEGIN
                        IF EmpTBT."Employment Date" <= L_PayrollStatusTbt."Period Start Date" THEN BEGIN
                            EmpTBT."Exempt Tax" := PayrollFunction.CalculateTaxCode(EmpTBT, FALSE, L_SpouseExempTax, WORKDATE);
                            EmpTBT.MODIFY(TRUE);
                            PayrollFunction.CreatePayDetail(EmpTBT);
                        END;
                    END;
                END;
            END;
        END;
        exit(EmployeeNo);
    end;

    procedure ValidatePermissions(P_Type: Text[30]);
    var
        IsPermitted: Boolean;
        HRPermissions: Record "HR Permissions";
    begin
        IsPermitted := false;
        HRPermissions.SETRANGE("User ID", USERID);
        if HRPermissions.FINDFIRST then
            repeat
                if (HRPermissions."Transaction Type" = HRPermissions."Transaction Type"::ALL) then begin
                    if HRPermissions."Function" = 'ALL' then
                        IsPermitted := true
                    else begin
                        case P_Type of
                            'Hire':
                                if HRPermissions."Function" = 'HIRE' then
                                    IsPermitted := true
                        end;
                    end;
                end
                else begin
                    if HRPermissions."Transaction Type" = HRPermissions."Transaction Type"::Applicant then begin
                        if HRPermissions."Function" = 'ALL' then
                            IsPermitted := true
                    END
                    else begin
                        case P_Type of
                            'Hire':
                                if HRPermissions."Function" = 'HIRE' then
                                    IsPermitted := true;
                        End;
                    end
                end;
            until HRPermissions.NEXT = 0;

        if IsPermitted = false then
            ERROR('User Has no Permission To Execute This Function !');
    end;

    procedure EmploymentIntervalDays() L_Interval: Decimal;
    var
        L_EmpNo: Code[20];
        L_EmployDate: Date;
        L_TermDate: Date;
    begin
        L_EmployDate := WORKDATE;
        L_TermDate := WORKDATE;
        CALCFIELDS("Matching Employee No");

        L_EmpNo := "Employee No.";
        IF L_EmpNo = '' THEN
            L_EmpNo := "Matching Employee No";

        CALCFIELDS("Employment Date");
        IF "Employment Date" <> 0D THEN
            L_EmployDate := "Employment Date";

        CALCFIELDS("Termination Date");
        IF "Termination Date" <> 0D THEN
            L_TermDate := "Termination Date";
        L_Interval := (L_TermDate - L_EmployDate);
        EXIT(L_Interval);
    end;

    procedure EmploymentIntervalMonths() L_Interval: Decimal;
    begin
        L_Interval := ROUND(EmploymentIntervalYears * 12, 0.01, '=');
        EXIT(L_Interval);
    end;

    procedure EmploymentIntervalYears() L_interval: Decimal;
    begin
        L_interval := ROUND(EmploymentIntervalDays / 365, 0.01, '=');
        EXIT(L_interval);
    end;

    procedure EmployeeProfileNo() L_EmpNo: Code[20];
    begin
        IF "Employee No." <> '' THEN
            L_EmpNo := "Employee No."
        ELSE BEGIN
            CALCFIELDS("Matching Employee No");
            L_EmpNo := "Matching Employee No";
        END;
        EXIT(L_EmpNo);
    end;

    procedure ApplicantAge() L_Age: Integer;
    begin
        IF "Birth Date" = 0D THEN
            L_Age := 0
        ELSE BEGIN
            L_Age := ROUND((WORKDATE - "Birth Date") / 365, 1, '<');
        END;
        EXIT(L_Age);
    end;

    procedure JoiningIntervalDays() L_Interval: Integer;
    begin
        L_Interval := 0;
        CALCFIELDS("Employment Date");
        IF "Employment Date" = 0D THEN BEGIN
            IF "Hired Date" = 0D THEN
                L_Interval := 0
            ELSE
                L_Interval := "Hired Date" - WORKDATE;
        END;
        EXIT(L_Interval);
    end;

    procedure FirstInterviewPhaseName() L_Phase: Text;
    var
        L_HRCommentLine: Record "HR Comment Line EDM";
    begin
        L_Phase := '';
        CALCFIELDS("First Interview Date");
        IF "First Interview Date" <> 0D THEN BEGIN
            L_HRCommentLine.SETRANGE(L_HRCommentLine.Date, "First Interview Date");
            IF L_HRCommentLine.FINDFIRST THEN BEGIN
                L_HRCommentLine.CALCFIELDS(L_HRCommentLine."Interview Phase Name");
                L_Phase := L_HRCommentLine."Interview Phase Name";
            END;
        END;
        EXIT(L_Phase);
    end;

    procedure LatestInterviewPhaseName() L_Phase: Text;
    var
        L_HRCommentLine: Record "HR Comment Line EDM";
    begin
        L_Phase := '';
        CALCFIELDS("Latest Interview Date");
        IF "Latest Interview Date" <> 0D THEN BEGIN
            L_HRCommentLine.SETRANGE(L_HRCommentLine.Date, "Latest Interview Date");
            IF L_HRCommentLine.FINDFIRST THEN BEGIN
                L_HRCommentLine.CALCFIELDS(L_HRCommentLine."Interview Phase Name");
                L_Phase := L_HRCommentLine."Interview Phase Name";
            END;
        END;
        EXIT(L_Phase);
    end;

    procedure NextInterviewPhaseName() L_Phase: Text;
    var
        L_HRCommentLine: Record "HR Comment Line EDM";
    begin
        L_Phase := '';
        CALCFIELDS("Next Interview Date");
        IF "Next Interview Date" <> 0D THEN BEGIN
            IF "Next Interview Date" > "Latest Interview Date" THEN BEGIN
                L_HRCommentLine.SETRANGE(L_HRCommentLine."Next Interview Date", "Next Interview Date");
                IF L_HRCommentLine.FINDFIRST THEN BEGIN
                    L_HRCommentLine.CALCFIELDS(L_HRCommentLine."Next Phase Name");
                    L_Phase := L_HRCommentLine."Next Phase Name";
                END;
            END
            ELSE
                L_Phase := 'N/A';
        END;
        EXIT(L_Phase);
    end;

    procedure FirstInterviewerName() L_FullName: Text;
    var
        L_HRCommentLine: Record "HR Comment Line EDM";
    begin
        L_FullName := '';
        CALCFIELDS("First Interview Date");
        IF "First Interview Date" <> 0D THEN BEGIN
            L_HRCommentLine.SETRANGE(L_HRCommentLine.Date, "First Interview Date");
            IF L_HRCommentLine.FINDFIRST THEN BEGIN
                L_HRCommentLine.CALCFIELDS(L_HRCommentLine."Interviewer Name");
                L_FullName := L_HRCommentLine."Interviewer Name";
            END;
        END;
        EXIT(L_FullName);
    end;

    procedure LatestInterviewerName() L_FullName: Text;
    var
        L_HRCommentLine: Record "HR Comment Line EDM";
    begin
        L_FullName := '';
        CALCFIELDS("Latest Interview Date");
        IF "Latest Interview Date" <> 0D THEN BEGIN
            L_HRCommentLine.SETRANGE(L_HRCommentLine.Date, "Latest Interview Date");
            IF L_HRCommentLine.FINDFIRST THEN BEGIN
                L_HRCommentLine.CALCFIELDS(L_HRCommentLine."Interviewer Name");
                L_FullName := L_HRCommentLine."Interviewer Name";
            END;
        END;
        EXIT(L_FullName);
    end;

    procedure NextInterviewerName() L_FullName: Text;
    var
        L_HRCommentLine: Record "HR Comment Line EDM";
    begin
        L_FullName := '';
        CALCFIELDS("Next Interview Date");
        IF "Next Interview Date" <> 0D THEN BEGIN
            IF "Next Interview Date" > "Latest Interview Date" THEN BEGIN
                L_HRCommentLine.SETRANGE(L_HRCommentLine."Next Interview Date", "Next Interview Date");
                IF L_HRCommentLine.FINDFIRST THEN BEGIN
                    L_HRCommentLine.CALCFIELDS(L_HRCommentLine."Next Interviewer Name");
                    L_FullName := L_HRCommentLine."Next Interviewer Name";
                END;
            END
            ELSE
                L_FullName := 'N/A';
        END;
        EXIT(L_FullName);
    end;

    procedure InterviewProcessDurationDays() L_Interval: Integer;
    begin
        CALCFIELDS("First Interview Date");
        CALCFIELDS("Latest Interview Date");
        L_Interval := 0;
        IF ("First Interview Date" <> 0D) AND ("Latest Interview Date" <> 0D) THEN
            L_Interval := "Latest Interview Date" - "First Interview Date";
        EXIT(L_Interval);
    end;

    procedure LatestAcademicDegreeName() L_Name: Text;
    var
        L_AcademicTbt: Record "Academic History";
    begin
        L_Name := '';
        CALCFIELDS("Latest Academic Graduate Date");
        IF "Latest Academic Graduate Date" <> 0D THEN BEGIN
            L_AcademicTbt.SETRANGE(L_AcademicTbt."To Date", "Latest Academic Graduate Date");
            IF L_AcademicTbt.FINDLAST() THEN BEGIN
                L_AcademicTbt.CALCFIELDS(L_AcademicTbt."Degree Name");
                L_Name := L_AcademicTbt."Degree Name";
            END;
        END;
        EXIT(L_Name);
    end;

    procedure LatestAcademicSpecialityName() L_Name: Text;
    var
        L_AcademicTbt: Record "Academic History";
    begin
        L_Name := '';
        CALCFIELDS("Latest Academic Graduate Date");
        IF "Latest Academic Graduate Date" <> 0D THEN BEGIN
            L_AcademicTbt.SETRANGE(L_AcademicTbt."To Date", "Latest Academic Graduate Date");
            IF L_AcademicTbt.FINDLAST() THEN BEGIN
                L_AcademicTbt.CALCFIELDS(L_AcademicTbt."Speciality Name");
                L_Name := L_AcademicTbt."Speciality Name";
            END;
        END;
        EXIT(L_Name);
    end;

    procedure LatestAcademicStudySinceDuration() L_Interval: Decimal;
    var
        L_AcademicTbt: Record "Academic History";
    begin
        L_Interval := 0;
        CALCFIELDS("Latest Academic Graduate Date");
        IF "Latest Academic Graduate Date" <> 0D THEN
            L_Interval := ROUND((WORKDATE - "Latest Academic Graduate Date") / 365, 0.01, '=');
        EXIT(L_Interval);
    end;

    procedure LatestAcademicInstituteTypeName() L_Name: Text;
    var
        L_AcademicTbt: Record "Academic History";
    begin
        L_Name := '';
        CALCFIELDS("Latest Academic Graduate Date");
        IF "Latest Academic Graduate Date" <> 0D THEN BEGIN
            L_AcademicTbt.SETRANGE(L_AcademicTbt."To Date", "Latest Academic Graduate Date");
            IF L_AcademicTbt.FINDLAST() THEN BEGIN
                IF L_AcademicTbt."Institute Type" = L_AcademicTbt."Institute Type"::College THEN
                    L_Name := 'College'
                ELSE
                    IF L_AcademicTbt."Institute Type" = L_AcademicTbt."Institute Type"::School THEN
                        L_Name := 'School'
                    ELSE
                        IF L_AcademicTbt."Institute Type" = L_AcademicTbt."Institute Type"::Training THEN
                            L_Name := 'Training'
                        ELSE
                            IF L_AcademicTbt."Institute Type" = L_AcademicTbt."Institute Type"::University THEN
                                L_Name := 'University'
                            ELSE
                                L_Name := '';
            END;
        END;
        EXIT(L_Name);
    end;

    procedure LatestInterviewComments() L_Comment: Text;
    var
        L_HRCommentLine: Record "HR Comment Line EDM";
    begin
        L_Comment := '';
        CALCFIELDS("Latest Interview Date");
        IF "Latest Interview Date" <> 0D THEN BEGIN
            L_HRCommentLine.SETRANGE(L_HRCommentLine.Date, "Latest Interview Date");
            IF L_HRCommentLine.FINDFIRST THEN
                L_Comment := L_HRCommentLine.Comment;
        END;
        EXIT(L_Comment);
    end;

    procedure GetLastOfferApplicantComment() Val: Text;
    var
        JobOffer: Record "Job Offer";
    begin
        JobOffer.SETFILTER("Applicant No.", "No.");
        IF JobOffer.FindLast then
            EXIT(JobOffer."Applicants Comments");
    end;

    procedure GetLastOfferCompanyComment() Val: Text;
    var
        JobOffer: Record "Job Offer";
    begin
        JobOffer.SETFILTER("Applicant No.", "No.");
        IF JobOffer.FindLast then
            EXIT(JobOffer."Company Comments");
    end;

    procedure GetLastOfferSentDate() Val: Date;
    var
        JobOffer: Record "Job Offer";
    begin
        JobOffer.SETFILTER("Applicant No.", "No.");
        IF JobOffer.FindLast then
            EXIT(JobOffer."Offer Validity");
    end;
}