tableextension 98007 "ExtEmployee" extends Employee
{

    fields
    {
        modify("E-Mail")
        {
            CaptionML = ENU = 'E-Mail';
        }
        modify("Manager No.")
        {
            Caption = 'Supervisor No.';
        }

        modify("Company E-Mail")
        {
            Caption = 'Company E-Mail';
        }
        Modify("Middle Name")
        {
            Caption = 'Middle Name';
        }
        Modify("Mobile Phone No.")
        {
            Caption = 'Mobile No.';
        }
        modify(Extension)
        {
            Caption = 'Company Phone Extension';
        }
        modify("Employment Date")
        {
            Caption = 'Employment Date';
        }
        modify("Termination Date")
        {
            Caption = 'Termination Date';
        }
        modify("Social Security No.")
        {
            Caption = 'NSSF No.';
        }

        field(50000; "Pay Frequency"; Option)
        {
            Description = 'SHR1.0';
            OptionMembers = Monthly,Weekly;

            trigger OnValidate();
            begin
                IF "Pay Frequency" = "Pay Frequency"::Weekly THEN
                    IF (Declared = Declared::Declared) OR (Declared = Declared::"Non-NSSF") THEN
                        ERROR('The pay frequency cannot be weekly');
            end;
        }
        field(80000; Salutation; Text[10])
        {
        }
        field(80001; "Spouse Work"; Boolean)
        {
        }
        field(80002; "Arabic Name"; Text[50])
        {
            Caption = 'الإسم الثلاثي';
        }
        field(80003; "Arabic First Name"; Text[50])
        {
            Caption = 'الإسم';
            trigger OnValidate();
            begin
                "Arabic Name" := ArabicFullName;
            end;
        }
        field(80004; "Arabic Middle Name"; Text[50])
        {
            Caption = 'إسم الأب';
            trigger OnValidate();
            begin
                "Arabic Name" := ArabicFullName;
            end;
        }
        field(80005; "Arabic Last Name"; Text[50])
        {
            Caption = 'الشهرة';
            trigger OnValidate();
            begin
                "Arabic Name" := ArabicFullName;
            end;
        }
        field(80006; "Arabic Mother Name"; Text[50])
        {
            Caption = 'إسم الوالدة';
        }
        field(80007; "Arabic Place of Birth"; Text[50])
        {
            Caption = 'مكان الولادة';
        }
        field(80008; "Arabic Nationality"; Text[50])
        {
            Caption = 'الجنسية';
        }
        field(80009; "Arabic Job Title"; Text[30])
        {
            Caption = 'الوظيفة';
        }
        field(80010; "Arabic Registeration Place"; Text[50])
        {
            Caption = 'مكان السجل';
        }
        field(80011; "Arabic Governorate"; Code[30])
        {
            Caption = 'المحافظة';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST(ArabicGovernorate));
        }
        field(80012; "Arabic Elimination"; Code[30])
        {
            Caption = 'القضاء';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST(ArabicElimination));
        }
        field(80013; "Arabic District"; Text[30])
        {
            Caption = 'الحي';
        }
        field(80014; "Arabic Land Area"; Text[30])
        {
            Caption = 'المنطقة العقارية';
        }
        field(80015; "Arabic Land Area  No."; Code[20])
        {
            Caption = 'رقم العقار';
        }
        field(80016; "Mailbox ID"; Code[20])
        {
            Caption = 'رقم صندوق البريد';
        }
        field(80017; "Arabic MailBox Area"; Text[30])
        {
            Caption = 'منطقة صندوق البريد';
        }
        field(80018; "Personal Finance No."; Code[20])
        {
        }
        field(80019; Computer; Boolean)
        {
        }
        field(80020; Chair; Boolean)
        {
        }
        field(80021; Stationery; Boolean)
        {
        }
        field(80022; "Extension phone number"; Boolean)
        {
        }
        field(80023; "Email Signature"; Boolean)
        {
        }
        field(80024; "Business Cards"; Boolean)
        {
        }
        field(80025; "Network Logins"; Boolean)
        {
        }
        field(80026; "Server Access"; Boolean)
        {
        }
        field(80027; "Finger Print"; Boolean)
        {
        }
        field(80028; "Parking Lod"; Boolean)
        {
        }
        field(80029; "Individual Civil Record"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Individual Civil Record")));
            FieldClass = FlowField;
        }
        field(80030; "Family Record"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Family Record")));
            FieldClass = FlowField;
        }
        field(80031; "Employee To Staff Member"; Boolean)
        {
        }
        field(80032; "Send Welcoming Letter"; Boolean)
        {
        }
        field(80033; "Office Regular Hours"; Boolean)
        {
        }
        field(80034; "Code Of Conduct"; Boolean)
        {
        }
        field(80035; "Employee HandBook"; Boolean)
        {
        }
        field(80036; "Supervisor Evaluation Form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Supervisor Eval. Form")));
            FieldClass = FlowField;
        }
        field(80037; "Self Evaluation Form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Self Eval. Form")));
            FieldClass = FlowField;
        }
        field(80038; "Labor Office Certificat"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Labor Office Certificate")));
            FieldClass = FlowField;
        }
        field(80039; "Military Service"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Military Service")));
            Caption = 'Military Service';
            FieldClass = FlowField;
        }
        field(80040; "Residence Certificate"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Residence Cert.")));
            FieldClass = FlowField;
        }
        field(80041; "Driving Licenses"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Driving License")));
            FieldClass = FlowField;
        }
        field(80042; Others; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Others")));
            FieldClass = FlowField;
        }
        field(80043; "User ID"; Code[10])
        {
            Description = 'SHR1.0';
            TableRelation = User;
        }
        field(80044; "Def. WTD No. of Hours"; Decimal)
        {
            CalcFormula = Sum("Employment Type Schedule"."No. of Hours" WHERE("Employment Type Code" = FIELD("Employment Type Code")));
            Description = 'SHR1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80045; "Hours Worked"; Decimal)
        {
            Description = 'SHR1.0';
            Editable = false;
        }
        field(80046; "Applicant No."; Code[20])
        {
            Description = 'SHR1.0';
        }
        field(80047; "Government ID No."; Text[30])
        {
            Caption = 'Identity Card No.';
            Description = 'SHR1.0';
        }
        field(80048; "Social Status"; Option)
        {
            Description = 'SHR1.0';
            OptionMembers = Single,Married,Widow,Divorced,Separated;

            trigger OnValidate();
            begin
                if "Social Status" <> xRec."Social Status" then begin
                    if "Social Status" = "Social Status"::Divorced then
                        if ("Husband Paralyzed") or ("Spouse Secured") then
                            ERROR('First you need to Uncheck the Husband paralyzed or Spouse Secured fields.');
                    if xRec."Social Status" = xRec."Social Status"::Divorced then
                        if "Divorced Spouse Child. Resp." then
                            ERROR('First you need to Uncheck the Divorced Spouse Children Responsibility field.');
                    "Reason of Change" := '';
                end;
                HumanResSetup.GET;
                if ("Social Status" = "Social Status"::Single) and (not HumanResSetup."Allow Single with Children") and
                      ("No of Children" <> 0) then
                    ERROR('Not allowed to have Children on Single Social Status.');

                if HumanResSetup."Payroll in Use" then begin
                    "Exempt Tax" := PayrollFunction.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);
                end;
            end;
        }
        field(80049; "Religion Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Religion"));
        }
        field(80050; "First Nationality Code"; Code[10])
        {
            Description = 'SHR1.0';
            TableRelation = "Country/Region";
        }
        field(80051; "Second Nationality Code"; Code[10])
        {
            Description = 'SHR1.0';
            TableRelation = "Country/Region";
        }
        field(80052; "Vacation Code"; Code[10])
        {
            Description = 'SHR1.0';
            TableRelation = "Company Organization";
        }
        field(80053; "Employee Category Code"; Code[10])
        {
            Description = 'SHR1.0';
            TableRelation = "Employee Categories";

            trigger OnValidate();
            begin
                if "Employee Category Code" <> xRec."Employee Category Code" then begin
                    "Reason of Change" := '';
                end;
            end;
        }
        field(80054; "Job Position Code"; Code[50])
        {
            Caption = 'Job Title 2 Code';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Title"));

            trigger OnValidate();
            begin
                if "Job Position Code" <> xRec."Job Position Code" then begin
                    "Reason of Change" := '';
                end;
                HRinformation.SETRANGE(Code, "Job Position Code");
                IF HRinformation.FINDFIRST then
                    validate("Job Position", HRinformation.Description)
                ELSE
                    validate("Job Position", '')
            end;
        }
        field(80055; "Tax Status"; Option)
        {
            Description = 'SHR1.0';
            OptionMembers = NotApplied,Applied;
        }
        field(80056; "Military Status"; Option)
        {
            Description = 'SHR1.0';
            OptionMembers = "Not Applicable",Completed,"T-Exempt","Not Requested","Under Request","Under Recordation";
        }
        field(80057; "Employment Type Code"; Code[20])
        {
            Description = 'SHR1.0';
            NotBlank = false;
            TableRelation = "Employment Type";

            trigger OnValidate();
            var
                ErrFnd: Boolean;
            begin
                if "Employment Type Code" <> '' then
                    if ("Global Dimension 1 Code" = '') and ("Global Dimension 2 Code" = '') then
                        CALCFIELDS("Def. WTD No. of Hours");
                if "Employment Type Code" <> xRec."Employment Type Code" then begin
                    "Reason of Change" := '';
                end;

                RecalculatDailyRate();
            end;
        }
        field(80058; "Passport No."; Text[30])
        {
            Caption = 'Passport No';
            Description = 'SHR1.0';
        }
        field(80059; "Resident No."; Text[30])
        {
            Caption = 'Resident No';
            Description = 'SHR1.0';
        }
        field(80060; "Social Security Information"; Text[200])
        {
            Description = 'SHR1.0';
        }
        field(80061; "Employee Medical Group"; Code[10])
        {
            Description = 'SHR1.0';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Medical Group"));
        }
        field(80062; Foreigner; Option)
        {
            Description = 'SHR1.0';
            OptionMembers = " ","End of Service","Not End of Service";

            trigger OnValidate();
            begin
                if Foreigner = Foreigner::"Not End of Service" then
                    Declared := Declared::"Non-Declared"
                else
                    Declared := Declared::Declared;

                "Exempt Tax" := PayrollFunction.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);

                if Declared <> xRec.Declared then begin
                    if (Declared = Declared::Declared) and ("Declaration Date" = 0D) then
                        "Declaration Date" := WORKDATE;
                    "Reason of Change" := '';
                end;
            end;
        }
        field(80063; "BEG.YR Accrual"; Decimal)
        {
        }
        field(80064; "Applicant Exist"; Boolean)
        {
            Description = 'SHR1.0';
        }
        field(80065; "Appraisal Code"; Option)
        {
            Description = 'PY1.0';
            OptionMembers = " ",A,B,C,D;
        }
        field(80066; "Related Ex-Employees"; Integer)
        {
            CalcFormula = Count("HR Comment Line EDM" WHERE("No." = FIELD("No.")));
            Description = 'SHR1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80067; "Basic Pay"; Decimal)
        {
            Description = 'PY1.0';

            trigger OnValidate();
            begin
                HumanResSetup.GET;
                if ("Basic Pay" <> 0) and ("Basic Pay" < HumanResSetup."Minimum Salary") then
                    ERROR('Salary Should be Greater than : %1 ', HumanResSetup."Minimum Salary");
                RecalculatDailyRate();
            end;
        }
        field(80068; "Additional Sal. Currency Code"; Code[10])
        {
            Description = 'PY1.0';
            TableRelation = Currency;
        }
        field(80069; Declared; Option)
        {
            Description = 'PY1.0';
            Caption = 'Declaration Type';
            OptionMembers = " ",Declared,"Non-Declared",Contractual,"Non-NSSF";

            trigger OnValidate();
            begin
                if "Pay Frequency" = "Pay Frequency"::Weekly then
                    if (Declared = Declared::Declared) or (Declared = Declared::"Non-NSSF") then
                        ERROR('The pay frequency cannot be weekly');

                if ((Declared = Declared::"Non-Declared") or (Declared = Declared::Contractual))
                     and (Foreigner = Foreigner::"End of Service") then
                    ERROR('End of Service Foreigner Cannot be Non-Declared or Contractual.');

                if (Declared = Declared::"Non-NSSF") and (Foreigner <> Foreigner::" ") then
                    ERROR('Non-NFSS Employee is not Considered as a Foreigner.');

                "Exempt Tax" := PayrollFunction.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);

                if Declared <> xRec.Declared then begin
                    "Reason of Change" := '';

                    if (Rec.Declared = Rec.Declared::Declared) and ((xRec.Declared = xRec.Declared::"Non-Declared")
                    or (xRec.Declared = xRec.Declared::" ")) then
                        InsFilter := HRFunctions.GetActiveInsurance(WORKDATE);
                    if InsFilter <> '' then begin
                        if (Rec.Declared = Rec.Declared::Declared) and (xRec.Declared = xRec.Declared::"Non-Declared") then
                            GenInsuranceJnlLine("No.", '');
                        if (Rec.Declared = Rec.Declared::"Non-Declared") and (xRec.Declared = xRec.Declared::Declared) then begin
                            ChkOpenInsJnlLine;
                            CLEAR("Declaration Date");
                        end;
                    end;
                    IF ((Declared = Declared::"Non-Declared") OR (Declared = Declared::Contractual) OR (Declared = Declared::"Non-NSSF")) THEN
                        "NSSF Date" := 0D;
                end;
            end;
        }
        field(80070; "Resident Expiry Date"; Date)
        {
            Caption = 'Resident Expiry Date';
            Description = 'PY1.0';
        }
        field(80071; "Work Permit No."; Text[30])
        {
            Caption = 'Work Permit No';
            Description = 'PY1.0';
        }
        field(80072; "Work Permit Expiry Date"; Date)
        {
            Caption = 'Work Permit Expiry Date';
            Description = 'PY1.0';
        }
        field(80073; "Spouse Secured"; Boolean)
        {
            Caption = 'Spouse / Husband Secured';
            Description = 'PY1.0';

            trigger OnValidate();
            begin
                if "Spouse Secured" <> xRec."Spouse Secured" then begin
                    if ("Social Status" = "Social Status"::Divorced) and ("Spouse Secured") then
                        ERROR('Not Applicable on Divorced Social Status.');
                    if ("Husband Paralyzed") and ("Spouse Secured") then
                        ERROR('Husband is Paralyzed');
                    "Reason of Change" := '';
                end;
                HumanResSetup.GET;
                if HumanResSetup."Payroll in Use" then begin
                    "Exempt Tax" := PayrollFunction.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);
                end;
            end;
        }
        field(80074; "NSSF Date"; Date)
        {
        }
        field(80075; "Husband Paralyzed"; Boolean)
        {
            Caption = 'Husband Unemployed';
            trigger OnValidate();
            begin
                if "Husband Paralyzed" <> xRec."Husband Paralyzed" then begin
                    if ("Social Status" = "Social Status"::Divorced) and ("Husband Paralyzed") then
                        ERROR('Not Applicable on Divorced Social Status.');
                    "Reason of Change" := '';
                end;
                if Gender = Gender::Male then
                    ERROR('This flag can only be set for female employees');
                HumanResSetup.GET;
                if HumanResSetup."Payroll in Use" then begin
                    if "Spouse Secured" then
                        ERROR('Spouse is Secured');
                    "Exempt Tax" := PayrollFunction.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);
                end;
            end;
        }
        field(80076; "Register No."; Code[20])
        {
            Caption = 'رقم السجل';
            Description = 'PY1.0';
        }
        field(80077; "Posting Group"; Code[10])
        {
            Description = 'PY1.0';
            NotBlank = false;
            TableRelation = "Payroll Posting Group";
        }
        field(80078; "Payroll Group Code"; Code[10])
        {
            Description = 'PY1.0';
            TableRelation = "HR Payroll Group";

            trigger OnValidate();
            begin
                if (USERID <> '') and ("Payroll Group Code" <> '') then
                    PayUser.GET("Payroll Group Code", USERID);
                PayrollFunction.CreatePayDetail(Rec);
                HumanResSetup.GET;
                if HumanResSetup."Payroll in Use" then begin
                    if "Payroll Group Code" <> xRec."Payroll Group Code" then
                        PayrollFunction.ReCalcWarning(Rec, xRec);
                end;
            end;
        }
        field(80079; "Rate Indicator"; Option)
        {
            Description = 'PY1.0';
            OptionMembers = Monthly,Annual,Weekly,Hourly;
        }
        field(80080; "Payment Method"; Option)
        {
            Description = 'PY1.0';
            OptionMembers = " ",Bank,Cheque,Cash,"G/LAccount",Vendor;
        }
        field(80081; "Bank No."; Code[20])
        {
            Description = 'PY1.0';
            TableRelation = IF ("Payment Method" = FILTER("Bank")) "Bank Account" ELSE
            IF ("Payment Method" = FILTER("G/LAccount")) "G/L Account" WHERE("Direct Posting" = FILTER(true)) ELSE
            IF ("Payment Method" = FILTER("Vendor")) Vendor ELSE
            IF ("Payment Method" = FILTER("Cash")) "Bank Account" ELSE
            IF ("Payment Method" = FILTER("Cheque")) "Bank Account";
        }
        field(80082; "Bank Branch"; Text[30])
        {
            Description = 'PY1.0';
        }
        field(80083; "Emp. Bank Acc No."; Code[30])
        {
            Description = 'PY1.0';
        }
        field(80084; "Paid up to Period"; Integer)
        {
            Description = 'PY1.0';
        }
        field(80085; "Pay To Date"; Decimal)
        {
            CalcFormula = Sum("Payroll Ledger Entry"."Gross Pay" WHERE("Employee No." = FIELD("No."), "Current Year" = CONST(true)));
            Description = 'PY1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80086; "Taxable Pay To Date"; Decimal)
        {
            CalcFormula = Sum("Payroll Ledger Entry"."Taxable Pay" WHERE("Employee No." = FIELD("No."), "Current Year" = CONST(true)));
            Description = 'PY1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80087; "Tax Paid To Date"; Decimal)
        {
            CalcFormula = Sum("Payroll Ledger Entry"."Tax Paid" WHERE("Employee No." = FIELD("No."), "Current Year" = CONST(true)));
            Description = 'PY1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80088; "Outstanding Loans"; Boolean)
        {
            CalcFormula = Exist("Employee Loan" WHERE("Employee No." = FIELD("No."), Completed = CONST(false)));
            Description = 'PY1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80089; Director; Boolean)
        {
            Description = 'SHR1.0';
        }
        field(80090; "Exempt Tax"; Decimal)
        {
            Description = 'PY1.0';
            Editable = false;
            Caption = 'Total Exemption';
        }
        field(80091; Rate; Decimal)
        {
            Description = 'PY1.0';
        }
        field(80092; "Salary (ACY)"; Decimal)
        {
            Description = 'PY1.0';
            Caption = 'Salary (ACY)';

        }
        field(80093; "No of Children"; Integer)
        {
            Caption = 'No of Children declared';
            CalcFormula = Count("Employee Relative" WHERE("Employee No." = FIELD("No."), "Eligible Child" = CONST(true)));
            Description = 'PY1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80094; "Net Pay To Date"; Decimal)
        {
            CalcFormula = Sum("Payroll Ledger Entry"."Net Pay" WHERE("Employee No." = FIELD("No."), "Current Year" = CONST(true)));
            Description = 'PY1.0';
            FieldClass = FlowField;
        }
        field(80095; "Reason of Change"; Text[50])
        {
            Description = 'SHR1.0';
        }
        field(80096; "National No."; Text[30])
        {
            Caption = 'Tax No.';
        }
        field(80097; "Physical File No."; Text[30])
        {
        }
        field(80098; "Declaration Date"; Date)
        {

            trigger OnValidate();
            begin
                IF "Declaration Date" <> 0D THEN begin
                    IF (Declared = Declared::"Non-Declared") or (Declared = Declared::" ") THEN
                        ERROR('Invalid Declaration Type');
                END;
            end;
        }
        field(80099; "Recommendation Name"; Text[50])
        {
        }
        field(80100; "Recommendation Date"; Date)
        {
        }
        field(80101; "Effective Work Days"; Decimal)
        {
        }
        field(80102; "Health Card No"; Text[30])
        {
            Description = 'SHR2.0';
        }
        field(80103; "Health Card Issue Place"; Text[30])
        {
            Description = 'SHR2.0';
        }
        field(80104; "Health Card Issue Date"; Date)
        {
            Description = 'SHR2.0';
        }
        field(80105; "Health Card Expiry Date"; Date)
        {
            Description = 'SHR2.0';

            trigger OnValidate();
            begin
                if "Health Card Expiry Date" < "Health Card Issue Date" then
                    ERROR('Epxiry Date must be Greater than Issue Date');
            end;
        }
        field(80106; "Chronic Disease"; Boolean)
        {
            Description = 'SHR2.0';
        }
        field(80107; "Chronic Disease Details"; Text[30])
        {
            Description = 'SHR2.0';
        }
        field(80108; "Other Health Information"; Text[30])
        {
            Description = 'SHR2.0';
        }
        field(80109; "Previously NSSF Secured"; Boolean)
        {
            Description = 'SHR2.0';
            Caption = 'Previous Social Security Registration';
        }
        field(80110; "Passport Issue Place"; Text[30])
        {
            Caption = 'Passport Issue Place';
            Description = 'SHR2.0';
        }
        field(80111; "Passport Issue Date"; Date)
        {
            Caption = 'Passport Issue Date';
            Description = 'SHR2.0';
        }
        field(80112; "Passport Expiry Date"; Date)
        {
            Caption = 'Passport Expiry Date';
            Description = 'SHR2.0';

            trigger OnValidate();
            begin
                if "Passport Expiry Date" < "Passport Issue Date" then
                    ERROR('Epxiry Date must be Greater than Issue Date');
            end;
        }
        field(80113; IsForeigner; Boolean)
        {
            Caption = 'IsForeigner';
            Description = 'SHR2.0';
        }
        field(80114; "Resident Issue Place"; Text[30])
        {
            Caption = 'Resident Issue Place';
            Description = 'SHR2.0';
        }
        field(80115; "Resident Issue Date"; Date)
        {
            Caption = 'Resident Issue Date';
            Description = 'SHR2.0';
        }
        field(80116; "Work Permit Issue Date"; Date)
        {
            Caption = 'Work Permit Issue Date';
            Description = 'SHR2.0';
        }
        field(80117; "Work Permit Issue Place"; Text[30])
        {
            Caption = 'Work Permit Issue Place';
            Description = 'SHR2.0';
        }
        field(80118; "Blood Type"; Code[10])
        {
            Description = 'SHR2.0';
        }
        field(80119; "Company Organization No."; Code[20])
        {
            Description = 'SHR2.0';
            TableRelation = "Company Organization";

            trigger OnValidate();
            var
                EmployeeRec: Record Employee;
            begin
                if CoOrg.GET("Company Organization No.") then begin
                    if CoOrg."Organization Type" <> CoOrg."Organization Type"::Element then
                        ERROR('You must choose an Element Organization Type');
                    if CoOrg."Job Title" <> "Job Title" then
                        ERROR('Job Title for this Organization No. must match the current Employee Job Title.');
                end;

                if "Company Organization No." <> xRec."Company Organization No." then
                    "Reason of Change" := '';

                CompanyOrg.SETRANGE("No.", "Company Organization No.");
                if CompanyOrg.FINDFIRST then begin
                    if CompanyOrg."Manager Organization No." <> '' then begin
                        EmployeeRec.SETRANGE("Company Organization No.", CompanyOrg."Manager Organization No.");
                        if EmployeeRec.FINDFIRST then
                            VALIDATE("Manager No.", EmployeeRec."No.")
                        else begin
                            "Manager No." := '';
                            "Manager Name" := '';
                        end;
                    end
                    else begin
                        "Manager No." := '';
                        "Manager Name" := '';
                    end;
                end;

                CompanyOrg.SETRANGE("No.", "Company Organization No.");
                if CompanyOrg.FINDFIRST then begin
                    if CompanyOrg."Report Man. Organization No." <> '' then begin
                        EmployeeRec.SETRANGE("Company Organization No.", CompanyOrg."Report Man. Organization No.");
                        if EmployeeRec.FINDFIRST then
                            VALIDATE("Report Manager No.", EmployeeRec."No.")
                        else begin
                            "Report Manager No." := '';
                            "Report Manager Name" := '';
                        end;
                    end
                    else begin
                        "Report Manager No." := '';
                        "Report Manager Name" := '';
                    end;
                end;
            end;
        }
        field(80120; "Shift Group Code Filter"; Code[50])
        {
            Description = 'SHR2.0';
            FieldClass = FlowFilter;
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("ShiftGp"));
        }
        field(80121; "Working Shift Code Filter"; Code[10])
        {
            Description = 'SHR2.0';
            FieldClass = FlowFilter;
            TableRelation = "Employment Type Schedule"."Working Shift Code" WHERE("Table Name" = CONST("WorkShiftSched"));
        }
        field(80122; "Approved Cause of Abs. Count"; Integer)
        {
            CalcFormula = Count("Employee Journal Line" WHERE("Cause of Absence Code" = FIELD("Cause of Absence Filter"), "Document Status" = CONST("Approved"), Converted = CONST(false)));
            Description = 'SHR2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80123; "No Exempt"; Boolean)
        {
            Caption = 'No Exemption';
            Description = 'EDM 0208';

            trigger OnValidate();
            begin
                if "No Exempt" then
                    "Exempt Tax" := 0;
            end;
        }
        field(80124; "Bank No. (ACY)"; Code[20])
        {
            Description = 'PY1.0';
            TableRelation = "Bank Account";
        }
        field(80125; "Emp. Bank Acc No. (ACY)"; Code[30])
        {
            Description = 'PY1.0';
        }
        field(80126; "Pay To Date (ACY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Ledger Entry"."Gross Pay (ACY)" WHERE("Employee No." = FIELD("No."), "Current Year" = CONST(true)));
            Description = 'PY1.0';
            FieldClass = FlowField;
        }
        field(80127; "Disciplinary Action"; Boolean)
        {
            CalcFormula = Exist("Employee Disciplinary Action" WHERE("Employee No." = FIELD("No.")));
            Description = 'SHR1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80128; "Payment Method (ACY)"; Option)
        {
            Description = 'PY1.0';
            OptionMembers = " ",Bank,Cheque,Cash;
        }
        field(80129; "Mother Name"; Text[30])
        {
            Description = 'SHR1.0';
        }
        field(80130; "Divorced Spouse Child. Resp."; Boolean)
        {
            Description = 'PY1.0';
            Caption = 'Divorced Spouse Child. Resp.';
            trigger OnValidate();
            begin
                if ("Social Status" <> "Social Status"::Divorced) and "Divorced Spouse Child. Resp." then
                    ERROR('Child. Responsibility applied only on Emps having a Divorced Social Status');

                HumanResSetup.GET;
                if HumanResSetup."Payroll in Use" then begin
                    if xRec."Divorced Spouse Child. Resp." <> "Divorced Spouse Child. Resp." then begin
                        if "Divorced Spouse Child. Resp." then begin
                            if CONFIRM('All Children will be no more Eligible and Their Scholarship will be cancelled.\' +
                                        'Do you wish to Continue ?') then begin
                                EMPRelative.SETRANGE("Employee No.", "No.");
                                EMPRelative.MODIFYALL("Eligible Child", false);
                                EMPRelative.MODIFYALL("Scholarship Applicable", false);
                            end else
                                ERROR('');
                        end
                        else begin
                            if CONFIRM('All Children will be Eligible but you need to Review their allowed Scholarship.\' +
                                        'Do you wish to Continue ?') then begin
                                EMPRelative.SETRANGE("Employee No.", "No.");
                                EMPRelative.MODIFYALL("Eligible Child", true);
                                EMPRelative.SETFILTER("Scholarship Allowance", '<>0');
                                EMPRelative.MODIFYALL("Scholarship Applicable", true);
                            end else
                                ERROR('');
                        end;
                    end;
                    "Exempt Tax" := PayrollFunction.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);
                end;
            end;
        }
        field(80131; "Spouse Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(80132; "Include in Pay Cycle"; Boolean)
        {
            CalcFormula = Lookup("Pay Detail Header"."Include in Pay Cycle" WHERE("Employee No." = FIELD("No.")));
            Description = 'PY2.0';
            FieldClass = FlowField;
        }
        field(80133; "Emp. Bank Acc Name"; Text[100])
        {
            Description = 'MHK1.0';
        }
        field(80134; "Hourly Basis"; Boolean)
        {

            trigger OnValidate();
            begin
                if "Hourly Basis" then begin
                    "Basic Pay" := 0;
                    "Salary (ACY)" := 0;
                end;
            end;
        }
        field(80135; "Hourly Rate"; Decimal)
        {
        }
        field(80136; "Copy of Identification Card"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Copy of ID Card")));
            Caption = 'Identification Card';
            FieldClass = FlowField;
        }
        field(80137; "Copy of Judiciary Record"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Copy of Judiciary Record")));
            Caption = 'Judiciary Record';
            FieldClass = FlowField;
        }
        field(80138; "Copy of Employment Contract"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Copy of Employment Contract")));
            Caption = 'Employment Contract';
            FieldClass = FlowField;
        }
        field(80139; "Copy of Passport"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Copy of Passport")));
            FieldClass = FlowField;
        }
        field(80140; "Copy of Diplomas"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Copy of Diplomas")));
            Caption = 'Diploma';
            FieldClass = FlowField;
        }
        field(80141; "Curriculum Vitae"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("CV")));
            FieldClass = FlowField;
        }
        field(80142; "Letters of Recommendations"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Letters of Recommendations")));
            FieldClass = FlowField;
        }
        field(80143; "Permission to practice prof."; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Permission to practice prof.")));
            Caption = 'Permission to practice profession';
            FieldClass = FlowField;
        }
        field(80144; "Home Address Certificate"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Home Address Certificate")));
            FieldClass = FlowField;
        }
        field(80145; Building; Text[30])
        {
        }
        field(80146; Floor; Code[10])
        {
        }
        field(80147; Education; Text[30])
        {
        }
        field(80148; "Arabic City"; Code[30])
        {
            Caption = 'المنطقة';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("ArabicCity"));
        }
        field(80149; "Arabic Street"; Text[30])
        {
            Caption = 'الشارع';
        }
        field(80150; "Arabic Building"; Text[30])
        {
            Caption = 'المبنى';
        }
        field(80151; "Arabic Floor"; Code[50])
        {
            Caption = 'الطابق';
        }
        field(80152; "Attendance No."; Integer)
        {
        }
        field(80153; "Vacation Group"; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Vacation Group"));

            trigger OnValidate();
            begin
                if ("Last Vacation Date" <> 0D) and ("Vacation Group" <> '') then begin
                    HRinformation.GET(HRinformation."Table Name"::"Vacation Group", "Vacation Group");
                    "Next Vacation Date" := CALCDATE(HRinformation."Due Date", "Last Vacation Date");
                end;
            end;
        }
        field(80154; "Accommodation Type"; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("AccommodationType"));

            trigger OnValidate();
            begin
                if ("Last Accomodation paid Date" <> 0D) and ("Accommodation Type" <> '') then begin
                    HRinformation.GET(HRinformation."Table Name"::AccommodationType, "Accommodation Type");
                    "Next Accomodation paid Date" := CALCDATE(HRinformation."Due Date", "Last Accomodation paid Date");
                end;
            end;
        }
        field(80155; "Last Vacation Date"; Date)
        {

            trigger OnValidate();
            begin
                if ("Last Vacation Date" <> 0D) and ("Vacation Group" <> '') then begin
                    HRinformation.GET(HRinformation."Table Name"::"Vacation Group", "Vacation Group");
                    "Next Vacation Date" := CALCDATE(HRinformation."Due Date", "Last Vacation Date");
                end;
            end;
        }
        field(80156; "Last Accomodation paid Date"; Date)
        {

            trigger OnValidate();
            begin
                if ("Last Accomodation paid Date" <> 0D) and ("Accommodation Type" <> '') then begin
                    HRinformation.GET(HRinformation."Table Name"::AccommodationType, "Accommodation Type");
                    "Next Accomodation paid Date" := CALCDATE(HRinformation."Due Date", "Last Accomodation paid Date");
                end;
            end;
        }
        field(80157; "Next Vacation Date"; Date)
        {
            Editable = false;
        }
        field(80158; "Next Accomodation paid Date"; Date)
        {
            Editable = false;
        }
        field(80159; "Employee Picture"; BLOB)
        {
            SubType = Bitmap;
        }
        field(80160; "Labor Type"; Option)
        {
            BlankZero = true;
            OptionCaption = ',Driver,Labor';
            OptionMembers = ,Driver,Labor;
        }
        field(80161; "Employee Age"; Integer)
        {
            Description = 'EDM.IT';
            Editable = false;
        }
        field(80162; "Service Years"; Integer)
        {
            Description = 'EDM.IT';
            Editable = false;
        }
        field(80163; "End of Service Date"; Date)
        {
            Description = 'EDM.IT';
        }
        field(80164; "Commission Amount"; Decimal)
        {
            Description = 'EDM.IT';
            Caption = 'Special Allowance';
            trigger OnValidate();
            begin
                "Commission Addition" := "Commission Amount";
                "Commission Deduction" := "Commission Amount";
            end;
        }
        field(80165; "Month of Birth Date"; Integer)
        {
            BlankZero = true;
            Description = 'EDM.IT';
            Editable = false;
        }
        field(80166; "Manager Name"; Text[100])
        {
            Caption = 'Supervisor Name';
            Editable = false;
        }
        field(80167; "Report Manager No."; Code[20])
        {
            Caption = 'Reporting Manager No.';
            CaptionClass = 'Department Manager No.';
            TableRelation = Employee;

            trigger OnValidate();
            var
                Emp: Record Employee;
            begin
                Emp.SETRANGE("No.", "Report Manager No.");
                if Emp.FINDFIRST then
                    "Report Manager Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name"
                else
                    "Report Manager Name" := '';
            end;
        }
        field(80168; "Report Manager Name"; Text[100])
        {
            Caption = 'Reporting Manager Name';
            CaptionClass = 'Department Manager Name';
            Editable = false;
        }
        field(80169; "Company Organization Name"; Text[100])
        {
            CalcFormula = Lookup("Company Organization".Name WHERE("No." = FIELD("Company Organization No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80190; "Full Name"; Text[100])
        {
        }
        field(80191; "Don't Deserve Family Allowance"; Boolean)
        {
            Caption = 'Don''t Deserve Family Allowance';
        }
        field(80192; "Phone Allowance"; Decimal)
        {
        }
        field(80193; "Car Allowance"; Decimal)
        {
        }
        field(80194; AL; Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE("Employee No." = FIELD("No."), "Transaction Date" = FIELD("Date Filter"), "Cause of Absence Code" = CONST('AL')));
            FieldClass = FlowField;
        }
        field(80195; SL; Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE("Employee No." = FIELD("No."), "Transaction Date" = FIELD("Date Filter"), "Cause of Absence Code" = Filter('SKD' | 'SKL')));
            FieldClass = FlowField;
        }
        field(80196; UL; Decimal)
        {
            CalcFormula = Sum("Employee Journal Line"."Calculated Value" WHERE("Employee No." = FIELD("No."), "Transaction Date" = FIELD("Date Filter"), "Cause of Absence Code" = FILTER('AB' | 'ULNT' | 'ULT')));
            FieldClass = FlowField;
        }
        field(80197; "Commission Addition"; Decimal)
        {
            Caption = 'Insurance Benefits';
        }
        field(80198; "Commission Deduction"; Decimal)
        {
            Caption = 'Special Deductions';
        }
        field(80199; "AL Starting Date"; Date)
        {
            Caption = 'Annual Leave Start Date';
        }
        field(80200; Period; Date)
        {
        }
        field(80201; "No. of Working Days"; Integer)
        {
            CalcFormula = Count("Employee Absence" WHERE("Employee No." = FIELD("No."), "Period" = FIELD("Date Filter"), "Type" = FILTER("Working Day" | "Sick Day" | "Working Holiday" | "Unpaid Vacation" | "AL"), "Not Include in Transportation" = CONST(false), "Attend Hrs." = FILTER(<> 0)));
            FieldClass = FlowField;
        }
        field(80202; "Driving License"; Code[20])
        {
            Caption = 'Driving License No.';
        }
        field(80203; "Driving License Expiry Date"; Date)
        {
        }
        field(80204; "Driving License Type"; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("DrivingLicenseType"));
        }
        field(80205; "Emergency Contact"; Text[50])
        {
        }
        field(80206; "Emergency Phone"; Code[20])
        {
        }
        field(80207; QID; BigInteger)
        {
            NotBlank = TRUE;
        }
        field(80208; "Visa Number"; BigInteger)
        {
            NotBlank = TRUE;
        }
        field(80209; "House Allowance"; Decimal)
        {
        }
        field(80210; "Other Allowances"; Decimal)
        {
        }
        field(80211; "Food Allowance"; Decimal)
        {
        }
        field(80212; "Ticket Allowance"; Decimal)
        {
            Caption = 'Renumeration';
        }
        field(80213; Locations; Option)
        {
            OptionCaption = 'Jounieh,Marj Ayon,Nabateih,Rmeileh';
            OptionMembers = Jounieh,"Marj Ayon"," Nabateih",Rmeileh;
        }
        field(80214; "Water Compensation"; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(80215; "Cost of Living Amount"; Decimal)
        {
        }
        field(80216; "Related to"; Code[20])
        {
            Caption = 'Related to file';
            TableRelation = Employee."No.";
        }
        field(80217; "Freeze Salary"; Boolean)
        {
        }
        field(80218; Password; Text[20])
        {
        }
        field(80220; "Engineer Syndicate AL Fees"; Decimal)
        {
        }
        field(80221; "Eng Syndicate AL Pymt Date"; Date)
        {
        }
        field(80222; Band; Code[10])
        {
            Caption = 'Band';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Band"));
        }
        field(80223; Grade; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Grade"));
        }
        field(80224; "Job Category"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Category"));
        }
        field(80225; "Insurance Contribution"; Decimal)
        {
        }
        field(80226; "No of Employee Relatives"; Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE("Employee No." = FIELD("No.")));
            Description = 'PY1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80227; "Actual Service Years"; Decimal)
        {
        }
        field(80228; "Daily Rate"; Decimal)
        {
        }
        field(80229; "Position Request Form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Position Request Form")));
            FieldClass = FlowField;
        }
        field(80230; "Employment Approval Form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Employment Approval Form")));
            FieldClass = FlowField;
        }
        field(80231; "Job Application Form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Job Application Form")));
            FieldClass = FlowField;
        }
        field(80232; "Pre-Hiring Interview Sheet"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Pre-Hiring Interview Sheet")));
            FieldClass = FlowField;
        }
        field(80233; "Engineering Syndicate Card"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Eng. Syndicate Card")));
            FieldClass = FlowField;
        }
        field(80234; "Application Photos"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("App. Photos")));
            FieldClass = FlowField;
        }
        field(80235; "Employee Banking Form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Employee Banking Form")));
            FieldClass = FlowField;
        }
        field(80236; "Proxy(Wakeleh)"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Proxy(Wakeleh)")));
            FieldClass = FlowField;
        }
        field(80237; "Terms Of Employment"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Undertaking-Terms Of Employment")));
            FieldClass = FlowField;
        }
        field(80238; "last Work Permit"; Boolean)
        {
            Caption = 'Last Work Permit';
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("last Work Permit")));
            FieldClass = FlowField;
        }
        field(80239; Location; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Location"));
        }
        field(80240; "Employee Type"; Option)
        {
            OptionCaption = 'Non declared – Engineers,Probation period,Employees,Contractual (labors 3%)';
            OptionMembers = "Non declared – Engineers","Probation period",Employees,"Contractual (labors 3%)";
        }
        field(80241; Department; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("No."), "Dimension Code" = FILTER('DEPARTMENT' | 'DEPARMTNE')));
            Caption = 'Department.';
            FieldClass = FlowField;
        }
        field(80242; Division; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("No."), "Dimension Code" = CONST('DIVISION')));
            Caption = 'Employee Division';
            FieldClass = FlowField;
        }
        field(80243; Branch; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("No."), "Dimension Code" = CONST('BRANCH')));
            Caption = 'Employee Branch';
            FieldClass = FlowField;
        }
        field(80244; "Proof of Residence"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Proof of Residence")));
            FieldClass = FlowField;
        }
        field(80245; "Ministry of Finance No"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("MOF No")));
            FieldClass = FlowField;
        }
        field(80246; "Confidantiality Contract"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Confidantiality Contract")));
            FieldClass = FlowField;
        }
        field(80247; "Judiciary Record"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Judiciary Record")));
            FieldClass = FlowField;
        }
        field(80248; "Order of Engineers No"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Order of Engineers No")));
            FieldClass = FlowField;
        }
        field(80249; "Signed Contract"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Signed Contract")));
            FieldClass = FlowField;
        }
        field(80250; "Zoho ID"; Text[3])
        {
            CalcFormula = Lookup("Employee Additional Info"."Zoho Id" WHERE("Employee No." = FIELD("No.")));
            Description = 'Added for Employee Attendance Matrix';
            FieldClass = FlowField;
        }
        field(80251; "Bonus System"; Code[10])
        {
            CalcFormula = Lookup("Employee Additional Info"."Bonus System" WHERE("Employee No." = FIELD("No.")));
            Description = 'Added for Employee Journals Matrix';
            FieldClass = FlowField;
        }
        field(80252; Project; Code[20])
        {
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(5200), "No." = FIELD("No."), "Dimension Code" = FILTER('PROJECT')));
            Caption = 'Project.';
            FieldClass = FlowField;
        }
        field(80253; "Salary Raise"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Salary Raise")));
            FieldClass = FlowField;
        }
        field(80254; "English Exam"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("English Exam")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80255; "Behavioral interview"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Behavioral interview")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80256; "Technical interview"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Technical interview")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80257; "Job offer approved"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Job offer approved")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80258; "Photo passports"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Photo passports")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80259; "Judicial Records"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Judicial Records")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80260; "Original Register ID"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Original Register")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80261; "Original Family ID"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Original Family")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80262; "NSSF Certificate"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("NSSF Certificate")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80263; "Employment Verification"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Employment Verification")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80264; "Educational Verification"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Educational Verification")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80265; "Medical Examination report"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Medical Exam report")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80266; "Application form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("App. Form")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80267; "Tax declaration form"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Tax declaration form")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80268; "Written agreement"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Written agreement")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80269; "Confidentiality Letter"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Confidentiality Letter")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80270; "Employee job description"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Employee job description")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80271; "Bank Name"; Text[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Bank Name" WHERE("Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80272; "Bank SWIFT Code"; Code[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Bank SWIFT Code" WHERE("Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80273; "Bank Name (ACY)"; Text[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Bank Name (ACY)" WHERE("Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80274; "Bank SWIFT Code (ACY)"; Code[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Bank SWIFT Code (ACY)" WHERE("Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        Field(80275; "Job Title Code"; Code[50])
        {
            FieldClass = Normal;
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Job Title"));
            trigger OnValidate();
            begin
                HRinformation.SETRANGE(Code, "Job Title Code");
                IF HRinformation.FINDFIRST then
                    validate("Job Title", COPYSTR(HRinformation.Description, 1, 30))
                ELSE
                    validate("Job Title", '')
            end;

        }
        field(80276; "Emp Transfer Bank Name"; Text[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Emp Transfer Bank Name" WHERE("Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80277; "Emp Transfer Bank Name (ACY)"; Text[50])
        {
            CalcFormula = Lookup("Employee Additional Info"."Emp Transfer Bank Name (ACY)" WHERE("Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80278; "Marriage Certificate"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Marriage Certificate")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80279; "National Identity"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("National Identity")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80280; "Degree (UAE)"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Degree (UAE)")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        field(80281; "Emirates ID Copies"; Boolean)
        {
            CalcFormula = Exist("Requested Documents" WHERE("No." = FIELD("No."), "Checklist Type" = CONST("Emirates ID Copies")));
            Description = 'Added For Check list';
            FieldClass = FlowField;
        }
        Field(80282; "Job Position"; Text[50])
        {
            Caption = 'Job Title 2';
            Editable = FALSE;
        }
        field(80283; "Business Unit"; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Business Unit"));
        }
        field(80284; "Job Title Description"; text[150])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("HR Information".Description WHERE("Table Name" = CONST("Job Title"), Code = Field("Job Title Code")));
            Editable = False;
        }
        field(80285; "Last Day Present"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Machine Attendance Data"."Punch Date" where("User ID" = field("Attendance No."), "Punch Date" = field("Current Date Filter")));
        }
        field(80286; "Current Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(80287; "No. of days without trans"; Integer)
        {
            caption = 'No. of days without transportation';
            CalcFormula = Count("Employee Absence" WHERE("Employee No." = FIELD("No."), "Period" = FIELD("Date Filter"), "Type" = FILTER("Sick Day" | "Unpaid Vacation" | "Paid Vacation" | "AL"), "Shift Code" = filter(<> 'DAYOFF' & <> 'WEEKEND'), "Attend Hrs." = FILTER(0)));
            FieldClass = FlowField;
        }
        field(80288; "Emp Transfer Bank Branch"; Text[50])
        {
        }
        field(80289; "Emp. Bank Acc Arabic Name"; Text[50])
        {
        }
        field(80290; "IBAN No."; Text[100])
        {
        }
        field(80298; "Remaining Loan Amount"; Decimal)
        {
            CalcFormula = SUM("Employee Loan Line"."Payment Amount" WHERE("Employee No." = FIELD("No."), Completed = Filter(FALSE)));
            FieldClass = FlowField;
        }
        field(80301; "New Service Date"; Date)
        {
        }
        field(80318; "Previous Employment Info"; Text[250])
        {

        }
        field(80319; "Previous NSSF No."; Text[50])
        {

        }
        field(80320; "Extra Amount"; Decimal)
        {

        }
        field(80321; "Wife-Hsband Name"; Text[100])
        {
        }
        field(80322; "Wife-Hsband Father Name"; Text[100])
        {
        }
        field(80323; "Wife-Hsband Nationality"; Text[100])
        {
        }
        field(80324; "Wife-Hsband Birthdate"; Date)
        {
        }
        field(80325; "Wife-Hsband Registry No."; Text[50])
        {
        }
        field(80326; "Wife-Hsband Registry Place"; Text[50])
        {
        }
        field(80327; "Family Before Marriage"; Text[50])
        {
        }
        field(80328; "Mother Family Before Marriage"; Text[50])
        {
        }
        field(80329; "Wife-Hsband Birth Place"; Text[50])
        {
        }
        field(80330; "Wife-Hsband Card No."; Text[50])
        {
        }
        field(80331; "Wife-Hsband Working"; Boolean)
        {
        }
        field(80332; "Wife-Hsband Working Place"; Text[100])
        {
        }
        field(80333; "Wife-Hsband Registration No."; Text[50])
        {
        }
        field(80334; "Arabic Address"; Text[100])
        {
        }
        field(80335; "Birth Arabic Elimination"; Code[10])
        {
            Caption = 'قضاء الولادة';
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST(ArabicElimination));
        }
        field(80336; "Period start Date"; Date)
        {
            CalcFormula = Lookup("Payroll Status"."Period Start Date" where("Payroll Group Code" = field("Payroll Group Code")));
            FieldClass = FlowField;
        }
        field(80337; "Period End Date"; Date)
        {
            CalcFormula = Lookup("Payroll Status"."Period End Date" where("Payroll Group Code" = field("Payroll Group Code")));
            FieldClass = FlowField;
        }
        field(80338; "Employment Date Filter"; date)
        {
            FieldClass = FlowFilter;
        }
        field(80339; "Termination Date Filter"; date)
        {
            FieldClass = FlowFilter;
        }
        field(80340; "Number of Active Declared"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Employee where(Declared = field(Declared),
                                "Declaration Date" = field("Employment Date Filter"),
                                "Inactive Date" = Filter(''),
                                "Termination Date" = Filter('')
                                ));
        }
        field(80341; "Number of Terminated Declared"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Employee where(Declared = field(Declared),
                                "Declaration Date" = field("Employment Date Filter"),
                                "Termination Date" = field("Termination Date Filter")
                                ));
        }
        field(80342; "Number of Inactive Declared"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Employee where(Declared = field(Declared),
                                "Declaration Date" = field("Employment Date Filter"),
                                "Inactive Date" = field("Inactive Date Filter")
                                ));
        }
        field(80343; "Inactive Date Filter"; date)
        {
            FieldClass = FlowFilter;
        }
        field(80344; "Cost of Living"; Decimal)
        {
        }
    }
    keys
    {
        key(Key1; "Full Name")
        {
        }
    }

    procedure ArabicFullName(): Text[100];
    var
    begin
        IF "Arabic Middle Name" = '' THEN
            EXIT("Arabic First Name" + ' ' + "Arabic Last Name")
        ELSE
            EXIT("Arabic First Name" + ' ' + "Arabic Middle Name" + ' ' + "Arabic Last Name");
    end;

    procedure RecalculatDailyRate();
    var
        L_EmployType: Record "Employment Type";
        EmpAddInfo: Record "Employee Additional Info";
        ExtraSalay: Decimal;
        L_Updaterate: Boolean;
    begin

        IF "Basic Pay" <= 0 THEN
            EXIT;
        CLEAR(L_EmployType);
        IF "Employment Type Code" <> '' THEN BEGIN
            L_EmployType.SETRANGE(L_EmployType.Code, "Employment Type Code");
            IF L_EmployType.FINDFIRST THEN BEGIN
                IF (L_EmployType."Working Days Per Month" > 0) AND (L_EmployType."Working Hours Per Day" > 0) THEN BEGIN
                    IF ("Daily Rate" > 0) OR ("Hourly Rate" > 0) THEN BEGIN
                        L_Updaterate := FALSE;
                        IF AutoUpdateRate = TRUE THEN
                            L_Updaterate := TRUE
                        ELSE BEGIN
                            IF CONFIRM('Do you want to recalculate the Hourly and Daily Rates ?', FALSE) = TRUE THEN
                                L_Updaterate := TRUE;
                        END;
                        IF L_Updaterate = TRUE THEN BEGIN
                            EmpAddInfo.SETRANGE("Employee No.", "No.");
                            IF EmpAddInfo.FINDFIRST THEN
                                ExtraSalay := EmpAddInfo."Extra Salary";

                            "Daily Rate" := ROUND(("Basic Pay" + ExtraSalay) / L_EmployType."Working Days Per Month", 0.01);
                            "Hourly Rate" := ROUND(("Basic Pay" + ExtraSalay) / (L_EmployType."Working Days Per Month" * L_EmployType."Working Hours Per Day"), 0.01);
                        END;
                    END
                    ELSE BEGIN
                        "Daily Rate" := ROUND("Basic Pay" / L_EmployType."Working Days Per Month", 0.01);
                        "Hourly Rate" := ROUND("Basic Pay" / (L_EmployType."Working Days Per Month" * L_EmployType."Working Hours Per Day"), 0.01);
                    END;
                END;
            END;
        END;

    end;

    procedure GenInsuranceJnlLine(P_EmpNo: Code[20]; P_RelCode: Code[10]);
    var

    begin
        IF NOT CONFIRM('Insurance Benefit Journal Lines will be Applied on Relative(s).\' +
                       'Do you wish to Continue ?', TRUE, WORKDATE) THEN
            ERROR('');

    end;

    procedure ChkOpenInsJnlLine();
    var

    begin
        InsFilter := HRFunctions.GetActiveInsurance(WORKDATE);
        EmployeeJournals.RESET;
        EmployeeJournals.SETCURRENTKEY("Employee No.", "Type", "Processed", "Document Status");
        EmployeeJournals.SETRANGE("Employee No.", "No.");
        EmployeeJournals.SETRANGE("Document Status", EmployeeJournals."Document Status"::Opened);
        EmployeeJournals.SETFILTER("Insurance Code", InsFilter);
        IF (EmployeeJournals.FindFirst) AND (InsFilter <> '') THEN
            ERROR('There are still Insurance Benefit Journal Lines that must be approved first.');
    end;

    procedure ReverseInsuranceJnlLine(P_EmpNo: Code[20]; P_RelCode: Code[10]);
    var
        EmpJnl: Record "Employee Journal Line";
    begin
        ChkOpenInsJnlLine;
        CLEAR(TotRec);
        InsFilter := HRFunctions.GetActiveInsurance(WORKDATE);
        IF InsFilter <> '' THEN
            IF NOT CONFIRM('Approved Insurance Benefit Journal Line(s) will be Reversed. \' +
                           'Do you wish to Continue ?', TRUE) THEN
                ERROR('');
        EmployeeJournals.RESET;
        EmployeeJournals.SETCURRENTKEY("Employee No.", Type, Processed, "Document Status");
        EmployeeJournals.SETRANGE("Employee No.", P_EmpNo);
        EmployeeJournals.SETRANGE(Type, 'BENEFIT');
        EmployeeJournals.SETRANGE("Document Status", EmployeeJournals."Document Status"::Approved);
        EmployeeJournals.SETFILTER("Insurance Code", InsFilter);
        EmployeeJournals.SETRANGE(Reversed, FALSE);
        EmployeeJournals.SETRANGE("Reversed Entry No.", 0);
        IF P_RelCode <> '' THEN
            EmployeeJournals.SETRANGE("Relative Code", P_RelCode);
        IF (EmployeeJournals.FindFirst) AND (InsFilter <> '') THEN
            REPEAT
                EmpJnl.TRANSFERFIELDS(EmployeeJournals);
                EmpJnl."Starting Date" := WORKDATE;
                EmpJnl."Transaction Date" := WORKDATE;
                EmpJnl.Value := EmployeeJournals.Value * (-1);
                EmpJnl."Calculated Value" := EmpJnl.Value * (EmpJnl."Ending Date" - EmpJnl."Starting Date" + 1);
                EmpJnl."Reversed Entry No." := EmployeeJournals."Entry No.";
                EmpJnl.Processed := FALSE;
                EmpJnl."Processed Date" := 0D;
                EmpJnl."Document Status" := EmpJnl."Document Status"::Opened;
                TotRec := TotRec + 1;
                EmpJnl.INSERT(TRUE);
                EmployeeJournals.Reversed := TRUE;
                EmployeeJournals.MODIFY;
            UNTIL EmployeeJournals.NEXT = 0;

        IF TotRec <> 0 THEN
            MESSAGE('The number of Insurance Benefit Journal Lines Reversed = %1', TotRec);
    end;

    procedure SetAutoUpdateRateBoolean(IsAuto: Boolean)
    begin
        AutoUpdateRate := IsAuto;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        EmployeeJournals: Record "Employee Journal Line";
        PayUser: Record "HR Payroll User";
        PayrollFunction: Codeunit "Payroll Functions";
        SpouseExemptTax: Boolean;
        CoOrg: Record "Company Organization";
        HRFunctions: Codeunit "Human Resource Functions";
        InsFilter: Text[150];
        TotRec: Integer;
        HRinformation: Record "HR Information";
        CompanyOrg: Record "Company Organization";
        EMPRelative: Record "Employee Relative";
        AutoUpdateRate: Boolean;
        PayrollParameter: Record "Payroll Parameter";
        HRSetup: Record "Human Resources Setup";

    trigger OnAfterInsert();
    begin
        IF NOT (PayrollFunction.IsHROfficer(UserId) or PayrollFunction.IsDataEntryOfficer(Userid)) then
            error('No Permission to create new employee!');

        PayrollParameter.Get;
        IF (PayrollParameter."Payroll Labor Law" = PayrollParameter."Payroll Labor Law"::UAE) or
        (PayrollParameter."Payroll Labor Law" = PayrollParameter."Payroll Labor Law"::Qatar) then
            Declared := Declared::"Non-Declared";
    end;
}