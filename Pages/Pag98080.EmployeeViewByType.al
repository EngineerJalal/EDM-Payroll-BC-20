page 98080 "Employee View By Type"
{
    // version EDM.HRPY2

    Caption = 'Employee Card';
    Editable = true;
    PageType = Card;
    SourceTable = Employee;
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
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        //IF AssistEdit(xRec) THEN
                        //  CurrPage.UPDATE;
                    end;

                    trigger OnValidate();
                    begin

                        //Added in order to limit the size of the employee No. in order to reserve space in related tables for other fields - 27.07.2016 : AIM +
                        if STRLEN("No.") > 20 then
                            ERROR('Code can be of maximum 20 characters');
                        //Added in order to limit the size of the employee No. in order to reserve space in related tables for other fields - 27.07.2016 : AIM -
                    end;
                }
                field("Employee Type"; "Employee Type")
                {
                    ShowMandatory = true;
                    ToolTip = 'Legal designation,affects layout only';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        // Added in order to not show fields updated in employee related file - 08.03.2017 : A2+
                        if ((Rec."Related to" <> '') and (Rec."Related to" <> Rec."No.")) then begin
                            IsVisibleEmpRelatedFields := true;
                            IsVisibleEmpTypeEmployees := false;
                            IsVisibleEmpTypeNotLabors := false;
                            EmpTbt.RESET;
                            CLEAR(EmpTbt);
                            EmpTbt.SETRANGE("Related to", Rec."No.");
                            if not EmpTbt.FINDFIRST then
                                IsVisibleEmpRelatedFields := false
                            else begin
                                if (Rec."Employee Type" = Rec."Employee Type"::Employees) then
                                    IsVisibleEmpTypeEmployees := true;
                                if Rec."Employee Type" <> Rec."Employee Type"::"Contractual (labors 3%)" then
                                    IsVisibleEmpTypeNotLabors := true;

                            end;
                        end
                        else
                            if Rec."No." = Rec."Related to" then begin
                                IsVisibleEmpRelatedFields := true;
                                if (Rec."Employee Type" = Rec."Employee Type"::Employees) then
                                    IsVisibleEmpTypeEmployees := true;
                                if Rec."Employee Type" <> Rec."Employee Type"::"Contractual (labors 3%)" then
                                    IsVisibleEmpTypeNotLabors := true;
                            end;
                        // Added in order to not show fields updated in employee related file - 08.03.2017 : A2-
                    end;
                }
                field("First Name"; "First Name")
                {
                    ShowMandatory = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    Caption = 'Middle Name';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    ShowMandatory = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Full Name"; "Full Name")
                {
                    Editable = false;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Birth Date"; "Birth Date")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Social Status"; "Social Status")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                group(Control20)
                {
                    Visible = ("Employee Type" = "Employee Type"::Employees) OR ("Employee Type" = "Employee Type"::"Probation period");
                    field("No of Children"; "No of Children")
                    {
                        ApplicationArea = All;
                    }
                }
                field("First Nationality Code"; "First Nationality Code")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Second Nationality Code"; "Second Nationality Code")
                {
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Related to"; "Related to")
                {
                    Caption = 'Related to file';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        RelatedToVar := "Related to";
                        InsertEmployeeInfoFromRelatedFile("No.", "Related to", true);
                        //Disabled in order not to reassign code in case 'Import msg = false' : 06.03.2017 AIM+
                        //UpdateEmployeeNo();
                        //Disabled in order not to reassign code in case 'Import msg = false' : 06.03.2017 AIM-
                        "Related to" := RelatedToVar;
                        Rec.MODIFY;
                    end;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                Visible = IsVisibleEmpRelatedFields;
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    Caption = 'Mobile No.';
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Emergency Contact"; "Emergency Contact")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Emergency Phone"; "Emergency Phone")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field(Extension; Extension)
                {
                    Caption = 'Company Phone Extension';
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                field(Status; Status)
                {
                    ShowMandatory = true;
                    ToolTip = 'Inactive: Hide from current pay detail,Terminated: Quit company';
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    Caption = 'Employment Date';
                    Editable = true;
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        // Add in order to auto set "Al Starting date" and "Period" as "Employment Date" - 16.12.2016 : A2+
                        "AL Starting Date" := "Employment Date";
                        Period := DMY2DATE(1, DATE2DMY("Employment Date", 2), DATE2DMY("Employment Date", 3));
                        Rec.MODIFY;
                        // Add in order to auto set "Al Starting date" and "Period" as "Employment Date" - 16.12.2016 : A2-
                    end;
                }
                field("Employee Category Code"; "Employee Category Code")
                {
                    Caption = 'Employee Category';
                    ShowMandatory = true;
                    ToolTip = 'Internal company designation,Affects leave entitlements and fixed monthly allowanced in pay elements';
                    ApplicationArea = All;
                }
                field("Service Years"; "Service Years")
                {
                    ShowMandatory = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Actual Service Years"; "Actual Service Years")
                {
                    Caption = 'Service Years';
                    Editable = false;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Employment Type Code"; "Employment Type Code")
                {
                    Caption = 'Schedule Type';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Def. WTD No. of Hours"; "Def. WTD No. of Hours")
                {
                    Caption = 'Required Hours / Week';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Attendance No."; "Attendance No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(ZOHOIDVar; ZOHOIDVar)
                {
                    Caption = 'ZOHO ID';
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CLEAR(EmpAddInfoTbt);
                        EmpAddInfoTbt.RESET;
                        EmpAddInfoTbt.SETRANGE("Employee No.", "No.");
                        if EmpAddInfoTbt.FINDFIRST then begin
                            EmpAddInfoTbt."Zoho Id" := ZOHOIDVar;
                            EmpAddInfoTbt.MODIFY;
                        end
                        else begin
                            EmpAddInfoTbt.INIT;
                            EmpAddInfoTbt."Employee No." := "No.";
                            EmpAddInfoTbt."Zoho Id" := ZOHOIDVar;
                            EmpAddInfoTbt.INSERT;
                        end;
                    end;
                }
                field("AL Starting Date"; "AL Starting Date")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Job Position Code"; "Job Position Code")
                {
                    Caption = 'Job Title 2';
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field(Band; Band)
                {
                    Caption = 'Employee Level';
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ShowMandatory = false;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field(Department; DepartmentVar)
                {
                    ShowMandatory = true;
                    TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(3));
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        // Add in order to auto insert record in 'Default Dimension' - 19.12.2016 : A2 +
                        PayrollFunctions.SaveEmployeeDimensionValue("No.", 'Department', DepartmentVar);
                        // Add in order to auto insert record in 'Default Dimension' - 19.12.2016 : A2 -
                    end;
                }
                field("Disciplinary Action"; "Disciplinary Action")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Company Organization No."; "Company Organization No.")
                {
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Manager No."; "Manager No.")
                {
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Manager Name"; "Manager Name")
                {
                    ShowMandatory = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Report Manager No."; "Report Manager No.")
                {
                    Caption = 'Reporting Manager No.';
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("Report Manager Name"; "Report Manager Name")
                {
                    Caption = 'Reporting Manager Name';
                    ShowMandatory = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Termination Date"; "Termination Date")
                {
                    Caption = 'Termination Date';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Grounds for Term. Code"; "Grounds for Term. Code")
                {
                    Caption = 'Grounds for Termination';
                    ApplicationArea = All;
                }
                group(Control21)
                {
                    Visible = "Employee Type" = "Employee Type"::Employees;
                    field("End of Service Date"; "End of Service Date")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                }
                field("Inactive Date"; "Inactive Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Cause of Inactivity Code"; "Cause of Inactivity Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Finance)
            {
                Caption = 'Finance';
                Visible = ShowBasic;
                field(Period; Period)
                {
                    ShowMandatory = true;
                    Visible = IsVisibleEmpRelatedFields;
                    ApplicationArea = All;
                }
                field("HR Payroll Group Code"; "Payroll Group Code")
                {
                    Caption = 'Payroll Group';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Declared; Declared)
                {
                    Caption = 'Status';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                group(Control52)
                {
                    Visible = "Employee Type" = "Employee Type"::"Non declared – Engineers";
                    field("MOF Reg No"; MOFRegNoVar)
                    {
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            //24.02.2017 : A2+
                            CLEAR(EmpAddInfoTbt);
                            EmpAddInfoTbt.RESET;
                            EmpAddInfoTbt.SETRANGE("Employee No.", "No.");
                            if EmpAddInfoTbt.FINDFIRST then begin
                                EmpAddInfoTbt."MOF Reg No" := MOFRegNoVar;
                                EmpAddInfoTbt.MODIFY;
                            end
                            else begin
                                EmpAddInfoTbt.INIT;
                                EmpAddInfoTbt."Employee No." := "No.";
                                EmpAddInfoTbt."MOF Reg No" := MOFRegNoVar;
                                EmpAddInfoTbt.INSERT;
                            end;
                            //24.02.2017 : A2-
                        end;
                    }
                }
                group(Control24)
                {
                    Visible = ("Employee Type" = "Employee Type"::Employees) OR ("Employee Type" = "Employee Type"::"Contractual (labors 3%)");
                    field("Declare Date"; "Declaration Date")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                }
                group(Control28)
                {
                    Visible = "Employee Type" = "Employee Type"::Employees;
                    field("Personal Finance No."; "Personal Finance No.")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("NSSF Date"; "NSSF Date")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("Social Security No."; "Social Security No.")
                    {
                        Caption = 'NSSF No.';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field(IsForeigner; IsForeigner)
                    {
                        Caption = 'IsForeigner';
                        ShowMandatory = true;
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
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
                        end;
                    }
                    field(Foreigner; Foreigner)
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("No Exempt"; "No Exempt")
                    {
                        Caption = 'No Exemption';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("Don't Deserve Family Allowance"; "Don't Deserve Family Allowance")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("Spouse Secured"; "Spouse Secured")
                    {
                        Caption = 'Spouse / Husband Secured';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("Husband Paralyzed"; "Husband Paralyzed")
                    {
                        Caption = 'Husband Paralyzed';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("Divorced Spouse Child. Resp."; "Divorced Spouse Child. Resp.")
                    {
                        Caption = 'Divorced Spouse Child. Resp.';
                        ShowMandatory = true;
                        Visible = false;
                        ApplicationArea = All;
                    }
                }
                field("Basic Pay"; "Basic Pay")
                {
                    Editable = DisableSalaryField;
                    ShowMandatory = true;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added on 09.04.2016 - AIM +
                        "TotalPay&allow" := CaluclateTotalAllowances();
                        CurrPage.UPDATE;
                        //Added on 09.04.2016 - AIM -
                    end;
                }
                field("Hourly Rate"; "Hourly Rate")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Phone Allowance"; "Phone Allowance")
                {
                    Editable = DisableSalaryField;
                    ShowMandatory = true;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added on 09.04.2016 - AIM +
                        "TotalPay&allow" := CaluclateTotalAllowances();
                        CurrPage.UPDATE;
                        //Added on 09.04.2016 - AIM -
                    end;
                }
                field("Car Allowance"; "Car Allowance")
                {
                    Editable = DisableSalaryField;
                    ShowMandatory = true;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added on 09.04.2016 - AIM +
                        "TotalPay&allow" := CaluclateTotalAllowances();
                        CurrPage.UPDATE;
                        //Added on 09.04.2016 - AIM -
                    end;
                }
                field("House Allowance"; "House Allowance")
                {
                    Editable = DisableSalaryField;
                    ShowMandatory = true;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added on 09.04.2016 - AIM +
                        "TotalPay&allow" := CaluclateTotalAllowances();
                        CurrPage.UPDATE;
                        //Added on 09.04.2016 - AIM -
                    end;
                }
                field("Other Allowances"; "Other Allowances")
                {
                    ShowMandatory = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //Added on 09.04.2016 - AIM +
                        "TotalPay&allow" := CaluclateTotalAllowances();
                        CurrPage.UPDATE;
                        //Added on 09.04.2016 - AIM -
                    end;
                }
                field("TotalPay&allow"; "TotalPay&allow")
                {
                    Caption = 'Total Basic + allowances';
                    Editable = false;
                    ShowMandatory = true;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                group(Control48)
                {
                    Visible = true;
                    field(BonusSystemVar; BonusSystemVar)
                    {
                        Caption = 'Bonus System';
                        Editable = DisableSalaryField;
                        TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST("Bonus System"));
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            CLEAR(EmpAddInfoTbt);
                            EmpAddInfoTbt.RESET;
                            EmpAddInfoTbt.SETRANGE("Employee No.", "No.");
                            if EmpAddInfoTbt.FINDFIRST then begin
                                EmpAddInfoTbt."Bonus System" := BonusSystemVar;
                                EmpAddInfoTbt.MODIFY;
                            end
                            else begin
                                EmpAddInfoTbt.INIT;
                                EmpAddInfoTbt."Employee No." := "No.";
                                EmpAddInfoTbt."Bonus System" := BonusSystemVar;
                                EmpAddInfoTbt.INSERT;
                            end;
                        end;
                    }
                }
                group(Control31)
                {
                    Visible = "Employee Type" = "Employee Type"::"Non declared – Engineers";
                    field("Engineer Syndicate AL Fees"; "Engineer Syndicate AL Fees")
                    {
                        Visible = IsVisibleEmpRelatedFields;
                        ApplicationArea = All;
                    }
                    field("Eng Syndicate AL Pymt Date"; "Eng Syndicate AL Pymt Date")
                    {
                        Visible = IsVisibleEmpRelatedFields;
                        ApplicationArea = All;
                    }
                }
                group(Control25)
                {
                    Visible = "Employee Type" = "Employee Type"::Employees;
                    field("Insurance Contribution"; "Insurance Contribution")
                    {
                        ShowMandatory = true;
                        Visible = ShowSalaryFld;
                        ApplicationArea = All;
                    }
                }
                field("Pay Frequency"; "Pay Frequency")
                {
                    ShowMandatory = true;
                    ToolTip = 'Use weekly for employees who are not paid on monthly basis';
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Payment Method"; "Payment Method")
                {
                    ShowMandatory = true;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Bank No."; "Bank No.")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc Name"; "Emp. Bank Acc Name")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc No."; "Emp. Bank Acc No.")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                group(Control27)
                {
                    Visible = "Employee Type" = "Employee Type"::Employees;
                    field("Freeze Salary"; "Freeze Salary")
                    {
                        ShowMandatory = true;
                        ToolTip = 'To hide from pay slip report';
                        ApplicationArea = All;
                    }
                    field("Exempt Tax"; "Exempt Tax")
                    {
                        Caption = 'Total Exemption';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                Visible = IsVisibleEmpTypeNotLabors;
                field("Driving License"; "Driving License")
                {
                    Caption = 'Driving License No.';
                    ApplicationArea = All;
                }
                field("Driving License Type"; "Driving License Type")
                {
                    ApplicationArea = All;
                }
                field("Driving License Expiry Date"; "Driving License Expiry Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Health)
            {
                Caption = 'Health';
                Visible = IsVisibleEmpTypeNotLabors;
                field("Chronic Disease"; "Chronic Disease")
                {
                    ApplicationArea = All;

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
                    ApplicationArea = All;
                }
            }
            group("Hiring Checklist")
            {
                Caption = 'Hiring Checklist';
                Visible = "Employee Type" <> "Employee Type"::"Contractual (labors 3%)";
                field(NoOfDocuments; NoOfDocuments)
                {
                    Caption = 'No. of Documents';
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        PAGE.RUNMODAL(PAGE::"Requested Documents", RequestedDocument);
                    end;
                }
                field("Copy of Employment Contract"; "Copy of Employment Contract")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Confidantiality Contract"; "Confidantiality Contract")
                {
                    Caption = 'Confidentiality Contract';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Copy of Identification Card"; "Copy of Identification Card")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Copy of Judiciary Record"; "Copy of Judiciary Record")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Family Record"; "Family Record")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Proof of Residence"; "Proof of Residence")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Copy of Diplomas"; "Copy of Diplomas")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Driving Licenses"; "Driving Licenses")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Signed Contract"; "Signed Contract")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Passport"; "Copy of Passport")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Individual Civil Record"; "Individual Civil Record")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                group(Control11)
                {
                    Visible = "Employee Type" = "Employee Type"::"Non declared – Engineers";
                    field("Permission to practice prof."; "Permission to practice prof.")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Ministry of Finance No"; "Ministry of Finance No")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Order of Engineers No"; "Order of Engineers No")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                }
                field(Computer; Computer)
                {
                    ApplicationArea = All;
                }
                field(Chair; Chair)
                {
                    ApplicationArea = All;
                }
                field(Stationery; Stationery)
                {
                    ApplicationArea = All;
                }
                field("Extension phone number"; "Extension phone number")
                {
                    ApplicationArea = All;
                }
                field("Email Signature"; "Email Signature")
                {
                    ApplicationArea = All;
                }
                field("Business Cards"; "Business Cards")
                {
                    ApplicationArea = All;
                }
                field("Network Logins"; "Network Logins")
                {
                    ApplicationArea = All;
                }
                field("Server Access"; "Server Access")
                {
                    ApplicationArea = All;
                }
                field("Office Regular Hours"; "Office Regular Hours")
                {
                    ApplicationArea = All;
                }
                field("Code Of Conduct"; "Code Of Conduct")
                {
                    ApplicationArea = All;
                }
                field("Employee HandBook"; "Employee HandBook")
                {
                    ApplicationArea = All;
                }
                field("Finger Print"; "Finger Print")
                {
                    ApplicationArea = All;
                }
                field("Parking Lod"; "Parking Lod")
                {
                    Caption = 'Parking Lot';
                    ApplicationArea = All;
                }
                field("Employee To Staff Member"; "Employee To Staff Member")
                {
                    ApplicationArea = All;
                }
                field("Send Welcoming Letter"; "Send Welcoming Letter")
                {
                    ApplicationArea = All;
                }
            }
            group("Arabic Info")
            {
                Caption = 'Arabic Info';
                Visible = IsVisibleEmpTypeEmployees;
                field("Arabic First Name"; "Arabic First Name")
                {
                    Caption = 'الإسم';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Middle Name"; "Arabic Middle Name")
                {
                    Caption = 'إسم الأب';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Last Name"; "Arabic Last Name")
                {
                    Caption = 'الشهرة';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Mother Name"; "Arabic Mother Name")
                {
                    Caption = 'إسم الوالدة';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Name"; "Arabic Name")
                {
                    Caption = 'الإسم الثلاثي';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Place of Birth"; "Arabic Place of Birth")
                {
                    Caption = 'مكان الولادة';
                    ShowMandatory = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Arabic Nationality"; "Arabic Nationality")
                {
                    Caption = 'الجنسية';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Governorate"; "Arabic Governorate")
                {
                    Caption = 'المحافظة';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Elimination"; "Arabic Elimination")
                {
                    Caption = 'القضاء';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic City"; "Arabic City")
                {
                    Caption = 'المنطقة';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic District"; "Arabic District")
                {
                    Caption = 'الحي';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Street"; "Arabic Street")
                {
                    Caption = 'الشارع';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Building"; "Arabic Building")
                {
                    Caption = 'المبنى';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Floor"; "Arabic Floor")
                {
                    Caption = 'الطابق';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Land Area"; "Arabic Land Area")
                {
                    Caption = 'المنطقة العقارية';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Land Area  No."; "Arabic Land Area  No.")
                {
                    Caption = 'رقم العقار';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Mailbox ID"; "Mailbox ID")
                {
                    Caption = 'رقم صندوق البريد';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic MailBox Area"; "Arabic MailBox Area")
                {
                    Caption = 'منطقة صندوق البريد';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Register No."; "Register No.")
                {
                    Caption = 'رقم السجل';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Arabic Registeration Place"; "Arabic Registeration Place")
                {
                    Caption = 'مكان السجل';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
            part("Labor Official Documents"; "Employee Attachments Subform")
            {
                Caption = 'Labor Official Documents';
                SubPageLink = "Employee No." = FIELD("No.");
                Visible = "Employee Type" = "Employee Type"::"Contractual (labors 3%)";
                ApplicationArea = All;
            }
            part("Employee Add Info"; "Employee Add Info Subform")
            {
                Caption = 'Employee Add Info';
                ShowFilter = false;
                SubPageLink = "Employee No." = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            part(Control1000000000; "Employee Picture")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            part("Employee Asset"; "Employee Asset Sub-Page")
            {
                SubPageLink = "Employee No" = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Finance")
            {
                Caption = '&Finance';
                action("&Medical Allowances")
                {
                    Caption = '&Medical Allowances';
                    //RunObject = Page Page80029;
                    //RunPageLink = Field1=FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Attendances")
                {
                    Caption = '&Attendances';
                    RunObject = Page "Employee Absence Entitlement";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Annual Leaves")
                {
                    Caption = 'Annual Leaves';
                    RunObject = Page "Employee Absence Entitlement";
                    RunPageLink = "Employee No." = FIELD("No."), "Cause of Absence Code" = CONST('AL');
                    ApplicationArea = All;
                }
                action("Sick Leaves")
                {
                    Caption = 'Sick Leaves';
                    RunObject = Page "Employee Absence Entitlement";
                    RunPageLink = "Employee No." = FIELD("No."), "Cause of Absence Code" = Filter('SKD' | 'SKL');
                    ApplicationArea = All;
                }
                separator(Separator1000000089)
                {
                }
                action("&Medical Allowance Overview")
                {
                    Caption = '&Medical Allowance Overview';
                    //RunObject = Page Page80051;
                    //RunPageLink = Field1=FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Absence Overview")
                {
                    Caption = '&Absence Overview';
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Journal")
                {
                    Caption = '&Journal';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        EmployeeJournals.SETRANGE("Employee No.", "No.");
                        PAGE.RUN(0, EmployeeJournals);
                    end;
                }
                separator(Separator1000000115)
                {
                }
                action("Payroll Ledger E&ntries")
                {
                    Caption = 'Payroll Ledger E&ntries';
                    RunObject = Page "Payroll Ledger Entries";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("L&oan")
                {
                    Caption = 'L&oan';
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        EmployeeLoan: Record "Employee Loan";
                    begin
                        EmployeeLoan.SETRANGE(EmployeeLoan."Employee No.", "No.");
                        EmployeeLoan.SETRANGE(EmployeeLoan.Completed, false);

                        if EmployeeLoan.FIND('-') then
                            PAGE.RUN(PAGE::"Loan Card", EmployeeLoan)
                        else begin
                            EmployeeLoan.INIT;
                            EmployeeLoan."Employee No." := "No.";
                            //EmployeeLoan."Loan No.":= ;
                            EmployeeLoan.INSERT;
                            PAGE.RUN(PAGE::"Loan Card", EmployeeLoan);
                        end;
                    end;
                }
            }
            group("E&mployee")
            {
                Caption = 'E&mployee';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "HR Comment Sheet EDM";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(5200), "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;
                }
                action(Objectives)
                {
                    //RunObject = Page Page90002;
                    //RunPageLink = Field6=FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("&Alternative Addresses")
                {
                    Caption = '&Alternative Addresses';
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Relatives")
                {
                    Caption = '&Relatives';
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Confidential Information")
                {
                    Caption = '&Confidential Information';
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Disciplinary Action")
                {
                    Caption = '&Disciplinary Action';
                    RunObject = Page "Employee Disciplinary Action";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Q&ualifications")
                {
                    Caption = 'Q&ualifications';
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Working Time Information")
                {
                    Caption = '&Working Time Information';
                    //RunObject = Page Page17391;
                    //RunPageLink = Field10=FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Documents")
                {
                    Caption = '&Documents';
                    RunObject = Page "Requested Documents";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Evaluations)
                {
                    Caption = 'Evaluations';
                    RunObject = Page "Requested Documents Evaluation";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No."), "Checklist Type" = FILTER("Supervisor Eval. Form" | "Self Eval. Form");
                    ApplicationArea = All;
                }
                action("&Academic History")
                {
                    Caption = '&Academic History';
                    RunObject = Page "Academic History";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Language &skills")
                {
                    Caption = 'Language &skills';
                    RunObject = Page "Language Skills";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Competencies")
                {
                    Caption = '&Competencies';
                    //RunObject = Page Page17382;
                    //RunPageLink = Field1=FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Interviews")
                {
                    Caption = '&Interviews';
                    RunObject = Page "Human Resource Interview Sheet";
                    //RunPageLink = "Table Name"=CONST(10),"No."=FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Survey")
                {
                    Caption = '&Survey';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        SurveyEmp.SETRANGE("Table Name", SurveyEmp."Table Name"::Survey);
                        SurveyEmp.SETRANGE(Classification, SurveyEmp.Classification::Employee);
                        SurveyEmp.SETFILTER("No. Filter", "No.");
                        SurveyEmp.SETFILTER("Table Name Filter", '%1', SurveyEmp."Table Name Filter"::SurveyQEmp);
                        PAGE.RUN(80079, SurveyEmp);
                    end;
                }
                action("C&ontracts")
                {
                    Caption = 'C&ontracts';
                    Image = Answers;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Employee Contracts";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("&Work Accidents")
                {
                    Caption = '&Work Accidents';
                    RunObject = Page "Employee Work Accident";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Swaped Days")
                {
                    Caption = 'Swaped Days';
                    RunObject = Page "Employee Swaped Days";
                    RunPageLink = "Employee No." = FIELD("No."), "Transaction Type" = CONST('SWAP'), "Swap No." = FILTER(> 0);
                    Visible = false;
                    ApplicationArea = All;
                }
                separator(Separator23)
                {
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    RunObject = Page "Misc. Articles Overview";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Co&nfidential Info. Overview")
                {
                    Caption = 'Co&nfidential Info. Overview';
                    RunObject = Page "Confidential Info. Overview";
                    Visible = false;
                    ApplicationArea = All;
                }
                separator(Separator1000000272)
                {
                }
                action("Job Description")
                {
                    Caption = 'Job Description';
                    ApplicationArea = All;
                    //RunObject = Page Page17400;
                    //RunPageLink = Field1=FIELD("Job Position Code");
                }
                action("Computer Skills")
                {
                    Caption = 'Computer Skills';
                    ApplicationArea = All;
                    //RunObject = Page Page17402;
                    //RunPageLink = Field1=FIELD("No.");
                }
                action("Employee Assets")
                {
                    RunObject = Page "Employee Assets List";
                    RunPageLink = "Employee No" = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            action("&Ikama")
            {
                Caption = '&Ikama';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Employee Ikama";
                RunPageLink = "Employee No." = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
            action("Related Employees Files")
            {
                Caption = 'Related Employees Files';
                ApplicationArea = All;

                trigger OnAction();
                var
                    EmployeeList: Page "Employee List";
                    Employee: Record Employee;
                begin
                    //Modified in order to get the records that have the same "Related to" value - 26.03.2016 : AIM +
                    //Employee.SETRANGE(Employee."Related to","No.");
                    Employee.SETRANGE(Employee."Related to", "Related to");
                    //Modified in order to get the records that have the same "Related to" value - 26.03.2016 : AIM -

                    if Employee.FINDFIRST then begin
                        EmployeeList.SETTABLEVIEW(Employee);
                        EmployeeList.RUN;
                    end else
                        MESSAGE('No Related files');
                end;
            }
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            ENG = 'E&mployee';
                action("&Convert Leaves")
                {
                    CaptionML = ENU = '&Convert Leaves',
                                ENG = '&List';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        ConvertLeaves: Report "Convert Attendance..";
                    begin
                        ConvertLeaves.GetMainNo("No.");
                        ConvertLeaves.RUN;
                    end;
                }
                separator(Separator1000000013)
                {
                }
                action("<Action1000000024>")
                {
                    Caption = 'Create Pay Details';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        // PY1.0 prepare pay detail for new employee
                        //SHR9.0+
                        HumanResSetup.GET;
                        if HumanResSetup."Payroll in Use" then begin
                            PayDetailLine.SETRANGE("Employee No.", "No.");
                            PayDetailLine.SETRANGE(Open, true);
                            if not PayDetailLine.FIND('-') then begin
                                if PayrollStatus.GET("Payroll Group Code") then
                                    if "Employment Date" <= PayrollStatus."Period Start Date" then begin
                                        "Exempt Tax" := PayrollFunctions.CalculateTaxCode(Rec, false, SpouseExemptTax, WORKDATE);
                                        PayrollFunctions.CreatePayDetail(Rec);
                                    end;
                            end;
                        end; // pay. in use - Insert
                        //SHR9.0-
                    end;
                }
                action("<Action1000000033>")
                {
                    Caption = 'Delete Pay Details';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        PayDetailHeader.RESET;
                        PayDetailHeader.SETRANGE("Employee No.", "No.");
                        PayDetailHeader.DELETEALL;
                        PayDetailLine.SETRANGE(Open, true);
                        PayDetailLine.SETRANGE("Employee No.", "No.");
                        PayDetailLine.DELETEALL;
                        PayrollLedgerEntry.SETRANGE(Open, true);
                        PayrollLedgerEntry.SETRANGE("Employee No.", "No.");
                        PayrollLedgerEntry.DELETEALL;
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
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        // 03.03.2017 : A2+
        EmployeeCardModified := true;
        // 03.03.2017 : A2-
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        i: Integer;
    begin
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin

        //Added in order to stop the buttons 'Previous / Next' - 04.10.2016 : AIM +
        exit;
        //Added in order to stop the buttons 'Previous / Next' - 04.10.2016 : AIM -
    end;

    trigger OnOpenPage();
    begin
        // 03.03.2017 : A2+
        EmployeeCardModified := false;
        // 03.03.2017 : A2-

        // Added in order to not show fields updated in employee related file - 08.03.2017 : A2+
        if ((Rec."Related to" <> '') and (Rec."Related to" <> Rec."No.")) then begin
            IsVisibleEmpRelatedFields := true;
            IsVisibleEmpTypeEmployees := false;
            IsVisibleEmpTypeNotLabors := false;
            EmpTbt.RESET;
            CLEAR(EmpTbt);
            EmpTbt.SETRANGE("Related to", Rec."No.");
            if not EmpTbt.FINDFIRST then
                IsVisibleEmpRelatedFields := false
            else begin
                if (Rec."Employee Type" = Rec."Employee Type"::Employees) then
                    IsVisibleEmpTypeEmployees := true;
                if Rec."Employee Type" <> Rec."Employee Type"::"Contractual (labors 3%)" then
                    IsVisibleEmpTypeNotLabors := true;

            end;
        end
        else
            if Rec."No." = Rec."Related to" then begin
                IsVisibleEmpRelatedFields := true;
                if (Rec."Employee Type" = Rec."Employee Type"::Employees) then
                    IsVisibleEmpTypeEmployees := true;
                if Rec."Employee Type" <> Rec."Employee Type"::"Contractual (labors 3%)" then
                    IsVisibleEmpTypeNotLabors := true;
            end;
        // Added in order to not show fields updated in employee related file - 08.03.2017 : A2-

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

        // Add in order to show additinal fields beside employee fields - 28.11.2016 : AIM +
        InitializeAddtionalInfoVariables();
        // Add in order to show additinal fields beside employee fields - 28.11.2016 : AIM -

        // Add in order to Disable salary fields - 30.11.2016 : A2 +
        DisableSalaryField := not DisableSalaryFields("User ID");
        // Add in order to Disable salary fields - 30.11.2016 : A2 -
        // Add in order to get Department Value - 19.12.2016 : A2+
        DepartmentVar := PayrollFunctions.GetEmployeeDimensionValue("No.", 'Department');
        // Add in order to get Department Value - 19.12.2016 : A2-
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

        //Added in order to Enable / Disable Entry Validation by parameter - 24.11.2016 : A2 +
        DisableDataEntryValidation();
        //Added in order to Enable / Disable Entry Validation by parameter - 24.11.2016 : A2 -

        /*
        //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM +
        HumanResSetup.RESET;
        HumanResSetup.GET();
        IF HumanResSetup."Disable Data Entry Validation" = FALSE THEN
          BEGIN
            //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM -
              //Added in order to perform validations and allow the user close the employee file in case it is opened by mistake - 15.04.2016 : AIM +
              IF ("First Name" <> '') OR ("Middle Name" <> '') OR ("Last Name" <> '') THEN
                BEGIN
                  TESTFIELD("First Name");
                  TESTFIELD("Birth Date");
                  TESTFIELD(Sex);
                  TESTFIELD("Employment Date");
                  TESTFIELD("Employment Type Code");
                  TESTFIELD(Declared);
                  TESTFIELD("Posting Group");
                  TESTFIELD("Payroll Group Code");
                  TESTFIELD("Employee Category Code");
              END
              //Added in order to perform validations and allow the user close the employee file in case it is opened by mistake - 15.04.2016 : AIM -
        //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM +
          END;
        //Added in order to Enable / Disable Entry Validation by parameter - 22.06.2016 : AIM -
        */

        //Added for validation on termination and Inactive date - 15.09.2016 : AIM +
        if "No." <> '' then begin
            if (Status = Status::Terminated) then begin
                if "Termination Date" = 0D then
                    ERROR('Enter Termination Date');
                // 24.02.2017 : A2+
                if "Grounds for Term. Code" = '' then
                    ERROR('Enter Grounds for Termination');
                // 24.02.2017 : A2-
            end;
            if (Status = Status::Inactive) then begin
                if "Inactive Date" = 0D then
                    ERROR('Enter Inactive Date');
            end;
            // Added for validation on "bank No.","Employee Acc Name" and "Employee Acc No." - 06.03.2017 : A2+
            if "Payment Method" = "Payment Method"::Bank then begin
                VALIDATE("Bank No.");
                VALIDATE("Emp. Bank Acc No.");
                VALIDATE("Emp. Bank Acc Name");
            end;
            // Added for validation on "bank No.","Employee Acc Name" and "Employee Acc No." - 06.03.2017 : A2-
        end;
        //Added for validation on termination and Inactive date - 15.09.2016 : AIM -

        //Added in order to insert employee code if it does not exist as well as update employee name in Dimensions Table - 23.01.2017 : AIM +
        PayrollFunctions.InsertEmployeeCodeToDimensionsTable(Rec."No.");
        //Added in order to insert employee code if it does not exist as well as update employee name in Dimensions Table - 23.01.2017 : AIM -
        // 03.03.2017 : A2+
        InsertCompanyToDimensionsTable("No.");
        AutoUpdateEmployeeRelatedCard();
        // 03.03.2017 : A2-

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

        PayrollLedgerEntry: Record "Payroll Ledger Entry";
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
        BonusSystemVar: Code[10];
        EmpAddInfoTbt: Record "Employee Additional Info";
        ZOHOIDVar: Text[10];
        HRPermission: Record "HR Permissions";
        DisableSalaryField: Boolean;
        EmpTbt: Record Employee;
        DepartmentVar: Code[20];
        DefaultDimension: Record "Default Dimension";
        RelatedToVar: Code[20];
        DisableEditing: Boolean;
        MOFRegNoVar: Text[20];
        EmployeeCardModified: Boolean;
        IsVisibleEmpRelatedFields: Boolean;
        IsVisibleEmpTypeEmployees: Boolean;
        IsVisibleEmpTypeNotLabors: Boolean;

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
            //Rec."AL Starting Date" := 0D;
            Rec.Period := 0D;
            //Rec."Employment Date" := WORKDATE;
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
        //Added in order not to reassign code in case 'Import msg = false' : 06.03.2017 AIM+
        PayrollFunctions.UpdateEmployeeNo(Rec);
        //Added in order not to reassign code in case 'Import msg = false' : 06.03.2017 AIM-
    end;

    local procedure DisableDataEntryValidation();
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
                TESTFIELD("Mobile Phone No.");
                //TESTFIELD("Phone No.");
                TESTFIELD(Address);
                TESTFIELD("Emergency Contact");
                TESTFIELD("Emergency Phone");
                //TESTFIELD(Extension);
                TESTFIELD(Status);
                TESTFIELD("Employment Date");
                TESTFIELD("Employee Category Code");
                TESTFIELD("Employment Type Code");
                TESTFIELD("Attendance No.");
                TESTFIELD("AL Starting Date");
                TESTFIELD("Job Title");
                TESTFIELD("Job Position Code");
                TESTFIELD(Band);
                //TESTFIELD("Global Dimension 1 Code");
                // 23.1.2017 - A2+
                TESTFIELD("Global Dimension 2 Code");
                // 23.1.2017 - A2+
                TESTFIELD(Period);
                TESTFIELD("Payroll Group Code");
                TESTFIELD("Posting Group");
                TESTFIELD(Declared);
                TESTFIELD("Basic Pay");
                //Disabled 22.03.2017 : AIM +
                /*TESTFIELD("Bank No.");
                TESTFIELD("Emp. Bank Acc No.");
                TESTFIELD("Emp. Bank Acc Name");
                */
                //Disabled 22.03.2017 : AIM -
                if ZOHOIDVar = '' then
                    ERROR('Enter ZOHO ID');
                if DepartmentVar = '' then
                    ERROR('Enter Department');

                if "Employee Type" = "Employee Type"::Employees then begin
                    TESTFIELD("Declaration Date");
                    TESTFIELD("Personal Finance No.");
                    TESTFIELD("NSSF Date");
                    TESTFIELD("Social Security No.");
                    TESTFIELD(Foreigner);
                    TESTFIELD("Arabic First Name");
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
                end;
                //Added for validation on payment method::Bank - 16.12.2016 : A2+
                if "Payment Method" = "Payment Method"::Bank then begin
                    TESTFIELD("Bank No.");
                    TESTFIELD("Emp. Bank Acc No.");
                end;
                //Added for validation on payment method::Bank - 16.12.2016 : A2-

            end;
        end;

    end;

    local procedure InitializeAddtionalInfoVariables();
    begin
        EmpAddInfoTbt.RESET;
        CLEAR(EmpAddInfoTbt);
        EmpAddInfoTbt.SETRANGE("Employee No.", "No.");
        if EmpAddInfoTbt.FINDFIRST then begin
            BonusSystemVar := EmpAddInfoTbt."Bonus System";
            ZOHOIDVar := EmpAddInfoTbt."Zoho Id";
            //24.02.2017 : A2+
            MOFRegNoVar := EmpAddInfoTbt."MOF Reg No";
            //24.02.2017 : A2-
        end;
    end;

    local procedure DisableSalaryFields(PayUserID: Code[50]) DisableFld: Boolean;
    var
        EmpTBT: Record Employee;
        HRPayUserTbt: Record "HR Payroll User";
        UserSetupTbt: Record "User Setup";
    begin
        DisableFld := false;

        if PayUserID = '' then
            PayUserID := USERID;

        HRPermission.SETRANGE(HRPermission."User ID", USERID);
        if HRPermission.FINDFIRST then
            exit(HRPermission."Req. Approval on Salary Change")
        else
            exit(false);

        if HRPermission."Req. Approval on Salary Change" = false then
            exit(false)
        else
            DisableFld := true;
    end;

    local procedure AutoUpdateEmployeeRelatedCard();
    var
        EmpTbt: Record Employee;
        EmpAddInfoTbt: Record "Employee Additional Info";
        DefaultDimTbt: Record "Default Dimension";
        RelatedDiffDimTbt: Record "Default Dimension";
        HRSetup: Record "Human Resources Setup";
    begin

        if EmployeeCardModified = false then
            exit;

        HRSetup.GET;
        if (HRSetup."Auto Update Emp Related") and (Status = Status::Active) then begin
            EmpTbt.SETRANGE(Status, EmpTbt.Status::Active);
            EmpTbt.SETRANGE("Related to", Rec."No.");
            EmpTbt.SETFILTER("No.", '<>%1', Rec."No.");
            if EmpTbt.FINDFIRST then
                repeat
                begin
                    EmpTbt."Birth Date" := Rec."Birth Date";
                    EmpTbt.Gender := Rec.Gender;
                    EmpTbt."Social Status" := Rec."Social Status";
                    EmpTbt."First Nationality Code" := Rec."First Nationality Code";
                    EmpTbt."Second Nationality Code" := Rec."Second Nationality Code";
                    EmpTbt."Mobile Phone No." := Rec."Mobile Phone No.";
                    EmpTbt."Phone No." := Rec."Phone No.";
                    EmpTbt.Address := Rec.Address;
                    EmpTbt."Address 2" := Rec."Address 2";
                    EmpTbt."Emergency Contact" := Rec."Emergency Contact";
                    EmpTbt."Emergency Phone" := "Emergency Phone";
                    EmpTbt.Extension := Rec.Extension;
                    EmpTbt."Employment Date" := Rec."Employment Date";
                    EmpTbt."Job Title" := Rec."Job Title";
                    EmpTbt."Job Position Code" := Rec."Job Position Code";
                    EmpTbt.Band := Rec.Band;
                    EmpTbt."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                    EmpTbt."Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
                    EmpTbt."Company Organization No." := Rec."Company Organization No.";
                    EmpTbt."Manager No." := Rec."Manager No.";
                    EmpTbt."Report Manager No." := Rec."Report Manager No.";
                    EmpTbt.Period := Rec.Period;
                    EmpTbt."Driving License" := Rec."Driving License";
                    EmpTbt."Driving License Type" := Rec."Driving License Type";
                    EmpTbt."Driving License Expiry Date" := Rec."Driving License Expiry Date";
                    EmpTbt."Engineer Syndicate AL Fees" := Rec."Engineer Syndicate AL Fees";
                    EmpTbt."Eng Syndicate AL Pymt Date" := Rec."Eng Syndicate AL Pymt Date";
                    EmpTbt."Chronic Disease" := Rec."Chronic Disease";
                    EmpTbt."Chronic Disease Details" := Rec."Chronic Disease Details";
                    EmpTbt."Arabic First Name" := Rec."Arabic First Name";
                    EmpTbt."Arabic Middle Name" := Rec."Arabic Middle Name";
                    EmpTbt."Arabic Last Name" := Rec."Arabic Last Name";
                    EmpTbt."Arabic Mother Name" := Rec."Arabic Mother Name";
                    EmpTbt."Arabic Name" := Rec."Arabic Name";
                    EmpTbt."Arabic Nationality" := Rec."Arabic Nationality";
                    EmpTbt."Arabic Governorate" := Rec."Arabic Governorate";
                    EmpTbt."Arabic Elimination" := Rec."Arabic Elimination";
                    EmpTbt."Arabic City" := Rec."Arabic City";
                    EmpTbt."Arabic District" := Rec."Arabic District";
                    EmpTbt."Arabic Street" := Rec."Arabic Street";
                    EmpTbt."Arabic Building" := Rec."Arabic Building";
                    EmpTbt."Arabic Floor" := Rec."Arabic Floor";
                    EmpTbt."Arabic Land Area" := Rec."Arabic Land Area";
                    EmpTbt."Arabic Land Area  No." := Rec."Arabic Land Area  No.";
                    EmpTbt."Mailbox ID" := Rec."Mailbox ID";
                    EmpTbt."Arabic MailBox Area" := Rec."Arabic MailBox Area";
                    EmpTbt."Register No." := Rec."Register No.";
                    EmpTbt."Arabic Registeration Place" := Rec."Arabic Registeration Place";
                    EmpTbt."End of Service Date" := Rec."End of Service Date";
                    EmpTbt.MODIFY(true);

                    EmpAddInfoTbt.SETRANGE("Employee No.", EmpTbt."No.");
                    if EmpAddInfoTbt.FINDFIRST then begin
                        EmpAddInfoTbt."Company Department" := DepartmentVar;
                        EmpAddInfoTbt.MODIFY(true);
                    end;
                    DefaultDimTbt.RESET;
                    DefaultDimTbt.SETRANGE("No.", Rec."No.");
                    DefaultDimTbt.SETRANGE("Table ID", 5200);
                    if DefaultDimTbt.FINDFIRST then
                        repeat
                        begin
                            if UPPERCASE(DefaultDimTbt."Dimension Code") <> UPPERCASE('COMPANY') then begin
                                RelatedDiffDimTbt.SETRANGE("No.", EmpTbt."No.");
                                RelatedDiffDimTbt.SETRANGE("Table ID", 5200);
                                RelatedDiffDimTbt.SETRANGE(RelatedDiffDimTbt."Dimension Code", DefaultDimTbt."Dimension Code");
                                if RelatedDiffDimTbt.FINDFIRST then begin
                                    RelatedDiffDimTbt."Dimension Value Code" := DefaultDimTbt."Dimension Value Code";
                                    RelatedDiffDimTbt.MODIFY(true);
                                end
                                else begin
                                    RelatedDiffDimTbt.INIT;
                                    RelatedDiffDimTbt.TRANSFERFIELDS(DefaultDimTbt);
                                    RelatedDiffDimTbt."No." := EmpTbt."No.";
                                    RelatedDiffDimTbt.INSERT(true);
                                end;
                            end;
                        end;
                        until DefaultDimTbt.NEXT = 0;
                end;
                until EmpTbt.NEXT = 0;
        end
        else
            if (Status = Status::Terminated) then begin
                EmpTbt.SETRANGE(Status, EmpTbt.Status::Active);
                EmpTbt.SETRANGE("Related to", Rec."No.");
                EmpTbt.SETFILTER("No.", '<>%1', Rec."No.");
                if EmpTbt.FINDFIRST then
                    repeat
                    begin
                        EmpTbt.Status := EmpTbt.Status::Terminated;
                        EmpTbt."Termination Date" := Rec."Termination Date";
                        EmpTbt."Grounds for Term. Code" := Rec."Grounds for Term. Code";
                        EmpTbt.MODIFY(true);
                    end;
                    until EmpTbt.NEXT = 0;
            end;
    end;

    local procedure InsertCompanyToDimensionsTable(EmpNo: Code[20]);
    var
        EmpTBT: Record Employee;
        DimensionsTbt: Record Dimension;
        DimValuesTbt: Record "Dimension Value";
        CompDimensionCode: Text;
        EmpDimCode: Code[20];
        DefaultDimension: Record "Default Dimension";
    begin
        DefaultDimension.RESET;
        CLEAR(DefaultDimension);
        DefaultDimension.SETRANGE("No.", EmpNo);
        DefaultDimension.SETRANGE("Dimension Code", 'COMPANY');
        if not DefaultDimension.FINDFIRST then begin
            if Declared <> Declared::"Non-Declared" then begin
                DefaultDimension.INIT;
                DefaultDimension."Table ID" := 5200;
                DefaultDimension."No." := EmpNo;
                DefaultDimension."Dimension Code" := 'COMPANY';
                DefaultDimension."Dimension Value Code" := 'OFF';
                DefaultDimension.INSERT;
            end
            else
                exit
        end
        else
            if Declared = Declared::"Non-Declared" then begin
                DefaultDimension."Dimension Value Code" := '';
                DefaultDimension.MODIFY
            end
            else begin
                DefaultDimension."Dimension Value Code" := 'OFF';
                DefaultDimension.MODIFY
            end;
    end;
}

