pageextension 98005 "ExtEmployeeCard" extends "Employee Card"
{

    layout
    {
        modify(General)
        {
            visible = false;
        }
        modify("Address & Contact")
        {
            visible = false;
        }
        modify(Administration)
        {
            visible = false;
        }
        modify(Personal)
        {
            visible = false;
        }
        modify(Payments)
        {
            visible = false;
        }

        addafter(Personal)
        {
            group(General1)
            {
                Caption = 'General';
                Editable = GeneralEditable;
                field("<No.1>"; Rec."No.")
                {
                    ShowMandatory = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        IF Rec.AssistEdit THEN
                            CurrPage.UPDATE;
                    end;

                    trigger OnValidate();
                    begin
                        if STRLEN(Rec."No.") > 10 then
                            ERROR('Code can be of maximum 10 characters');
                    end;
                }
                field("<First Name1>"; Rec."First Name")
                {
                    ShowMandatory = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("<Middle Name1>"; Rec."Middle Name")
                {
                    ApplicationArea = All;

                }
                field("<Last Name1>"; Rec."Last Name")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Mother Name"; Rec."Mother Name")
                {
                    ApplicationArea = All;
                }
                field("<Birth Date1>"; Rec."Birth Date")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Gender1; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field("Social Status"; Rec."Social Status")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("No of Employee Relatives"; Rec."No of Employee Relatives")
                {
                    ApplicationArea = All;
                }
                field("No of Children"; Rec."No of Children")
                {
                    ApplicationArea = All;
                }
                field("First Nationality Code"; Rec."First Nationality Code")
                {
                    ApplicationArea = All;
                }
                field("Second Nationality Code"; Rec."Second Nationality Code")
                {
                    ApplicationArea = All;
                }
                field("<Initials1>"; Rec.Initials)
                {
                    ApplicationArea = All;
                }
                field("<Search Name1>"; Rec."Search Name")
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
            }
            group("Address & Contact1")
            {
                Caption = 'Address & Contact';
                Editable = GeneralEditable;
                field("<Mobile Phone No.1>"; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field("<Phone No.1>"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("<E-Mail1>"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("<Address1>"; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field(Building; Rec.Building)
                {
                    ApplicationArea = All;
                }
                field(Floor; Rec.Floor)
                {
                    ApplicationArea = All;
                }
                field("<Address 21>"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("Emergency Contact"; Rec."Emergency Contact")
                {
                    ApplicationArea = All;
                }
                field("Emergency Phone"; Rec."Emergency Phone")
                {
                    ApplicationArea = All;
                }

                field("<Company E-Mail1>"; Rec."Company E-Mail")
                {
                    ApplicationArea = All;
                }
                field("<Extension1>"; Rec.Extension)
                {
                    ApplicationArea = All;
                }

            }
            group(Administration1)
            {
                Caption = 'Administration';
                Editable = GeneralEditable;
                Visible = GeneralEditable;
                field("Employee Category Code"; Rec."Employee Category Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        ShowHideGradeSystem();
                    end;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                }
                field("Applicant No."; Rec."Applicant No.")
                {
                    ApplicationArea = All;
                }
                field("Disciplinary Action"; Rec."Disciplinary Action")
                {
                    ApplicationArea = All;
                }
                field("Labor Type"; Rec."Labor Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }


                field("<Last Date Modified1>"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field("<Resource No.1>"; Rec."Resource No.")
                {
                    Visible = UseResourceConcept;//For Yamen (Attendance by project)                    ApplicationArea=All;Rec.                   ApplicationArea=All;

                    ApplicationArea = All;

                }
                field("Related to"; Rec."Related to")
                {
                    ApplicationArea = All;
                }
            }
            group("Employment Info")
            {
                Editable = GeneralEditable;
                field("<Employment Date1>"; Rec."Employment Date")
                {
                    Editable = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Employment Type Code"; Rec."Employment Type Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Def. WTD No. of Hours"; Rec."Def. WTD No. of Hours")
                {
                    ApplicationArea = All;
                }
                field("Service Years"; Rec."Service Years")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Actual Service Years"; Rec."Actual Service Years")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("End of Service Date"; Rec."End of Service Date")
                {
                    ApplicationArea = All;
                }
                field("<Status1>"; Rec.Status)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("<Termination Date1>"; Rec."Termination Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("<Grounds for Term. Code1>"; Rec."Grounds for Term. Code")
                {
                    ApplicationArea = All;
                }
                field("<Inactive Date1>"; Rec."Inactive Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("<Cause of Inactivity Code1>"; Rec."Cause of Inactivity Code")
                {
                    ApplicationArea = All;
                }
                field("Attendance No."; Rec."Attendance No.")
                {
                    ApplicationArea = All;
                }
                field("AL Starting Date"; Rec."AL Starting Date")
                {
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
            group("Position Info")
            {
                Editable = GeneralEditable;
                field("Job Category"; Rec."Job Category")
                {
                    ApplicationArea = All;
                }
                field("Job Title Code"; Rec."Job Title Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Job Title Description"; Rec."Job Title Description")
                {
                    ApplicationArea = All;
                }
                field("Job Position Code"; Rec."Job Position Code")
                {
                    ApplicationArea = All;
                }
                field("Job Position"; Rec."Job Position")
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Manager No."; Rec."Manager No.")
                {
                    ApplicationArea = All;
                }
                field("Manager Name"; Rec."Manager Name")
                {
                    ApplicationArea = All;
                }
                field("Report Manager No."; Rec."Report Manager No.")
                {
                    ApplicationArea = All;
                }
                field("Report Manager Name"; Rec."Report Manager Name")
                {
                    ApplicationArea = All;
                }
                field("Company Organization No."; Rec."Company Organization No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Company Organization Name"; Rec."Company Organization Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

            }
            group(Finance1)
            {
                Caption = 'Finance';
                Visible = IsHROfficer or IsPayrollofficer;
                Editable = IsPayrollOfficer;
                field("Pay Frequency"; Rec."Pay Frequency")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("HR Payroll Group Code"; Rec."Payroll Group Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Declared; Rec.Declared)
                {
                    ShowMandatory = true;
                    Visible = LebanonPayLaw or NigeriaPayLaw or EgyptPaylaw or IraqPayLaw;
                    ApplicationArea = All;
                }
                field("Declare Date"; Rec."Declaration Date")
                {
                    ShowMandatory = true;
                    Visible = LebanonPayLaw or NigeriaPayLaw or EgyptPaylaw or IraqPayLaw;
                    ApplicationArea = All;
                }
                field("Personal Finance No."; Rec."Personal Finance No.")
                {
                    ApplicationArea = All;
                }
                field("NSSF Date"; Rec."NSSF Date")
                {
                    ShowMandatory = true;
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("<Social Security No.1>"; Rec."Social Security No.")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field(IsForeigner; Rec.IsForeigner)
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Foreigner; Rec.Foreigner)
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("No Exempt"; Rec."No Exempt")
                {
                    Visible = LebanonPayLaw or NigeriaPayLaw or EgyptPaylaw or IraqPayLaw;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("<DoesNotDeserveFamilyAllowance>"; Rec."Don't Deserve Family Allowance")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Spouse Secured"; Rec."Spouse Secured")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Husband Paralyzed"; Rec."Husband Paralyzed")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Divorced Spouse Child. Resp."; Rec."Divorced Spouse Child. Resp.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Exempt Tax"; Rec."Exempt Tax")
                {
                    Visible = LebanonPayLaw Or IraqPayLaw;
                    ApplicationArea = All;
                }
                field("PayrollFunctions.GetEmployeeLastFinalizedPayDate(Rec)"; PayrollFunctions.GetEmployeeLastFinalizedPayDate(Rec))
                {
                    Caption = 'Last Finalized Pay Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Family Allowance Retro Date"; FamAllowRetroDate)
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CLEAR(EmpAddInfoTbt);
                        EmpAddInfoTbt.RESET;
                        EmpAddInfoTbt.SETRANGE("Employee No.", Rec."No.");
                        if EmpAddInfoTbt.FINDFIRST then begin
                            EmpAddInfoTbt."Family Allowance Retro Date" := FamAllowRetroDate;
                            EmpAddInfoTbt.MODIFY;
                        end
                        else begin
                            EmpAddInfoTbt.INIT;
                            EmpAddInfoTbt."Employee No." := Rec."No.";
                            EmpAddInfoTbt."Family Allowance Retro Date" := FamAllowRetroDate;
                            EmpAddInfoTbt.INSERT;
                        end;
                    end;
                }
                field("Previously NSSF Secured"; Rec."Previously NSSF Secured")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Social Security Information"; Rec."Social Security Information")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
            }
            group("Grading System Info")
            {
                Visible = UseGrade;
                Editable = IsHROfficer or IsPayrollOfficer;
                field("Grade Code"; GradeCode)
                {
                    TableRelation = "Grading Scale"."Grade Code" WHERE("Employee Category" = FIELD("Employee Category Code"));
                    ApplicationArea = All;

                    trigger OnValidate();
                    var
                        GradingScale: Record "Grading Scale";
                        EmpGradeHistory: Record "Employee Grading History";
                        PeriodType: DateFormula;
                    begin
                        if not PayrollFunctions.IsGradeValueValid(GradeCode, Rec."Employee Category Code") then
                            ERROR('Invalid Grade Code');

                        if CONFIRM('Are you sure you want update salaries', false) then begin
                            GradingScale.SETRANGE("Employee Category", Rec."Employee Category Code");
                            GradingScale.SETRANGE("Grade Code", GradeCode);
                            if GradingScale.FINDFIRST then begin
                                Rec.VALIDATE("Basic Pay", GradingScale."Grade Basic Salary");
                                Rec.VALIDATE("Cost of Living Amount", GradingScale."Grade Cost of Living");
                            end;
                            EmpGradeHistory.INIT;
                            if EmpGradeHistory.FINDLAST then
                                EmpGradeHistory."Primery Key" += 1
                            else
                                EmpGradeHistory."Primery Key" := 1;

                            EmpGradeHistory.VALIDATE("Employee No", Rec."No.");
                            EmpGradeHistory.VALIDATE("Previous Basic Pay", xRec."Basic Pay");
                            EmpGradeHistory.VALIDATE("Previous Grade", xRecGrade);
                            EmpGradeHistory.VALIDATE("Previous Grade Category", xRec."Employee Category Code");
                            EmpGradeHistory.VALIDATE("Previous HCL", xRec."Cost of Living Amount");
                            EmpGradeHistory.VALIDATE("Previous Last Grading Date", xRecLastGradeDate);
                            EmpGradeHistory.VALIDATE("Previous Next Grading Date", xRecNextGradeDate);
                            EmpGradeHistory.VALIDATE("Basic Pay", GradingScale."Grade Basic Salary");
                            EmpGradeHistory.VALIDATE(HCL, GradingScale."Grade Cost of Living");
                            EmpGradeHistory.VALIDATE("Grade Category", Rec."Employee Category Code");
                            EmpGradeHistory.VALIDATE(Grade, GradeCode);
                            EmpGradeHistory.VALIDATE("Last Grading Date", xRecNextGradeDate);
                            EmpGradeHistory."Created By" := USERID;
                            EmpGradeHistory."Created DateTime" := CREATEDATETIME(WORKDATE, TIME);
                            EmpGradeHistory.VALIDATE("Is Temp", false);

                            EVALUATE(PeriodType, '1M');
                            if (GradingScale."Grade Interval Type" = PeriodType) and (LastGradingDate <> 0D) then
                                EmpGradeHistory."Next grading Date" := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>', LastGradingDate);

                            EVALUATE(PeriodType, '1Y');
                            if (GradingScale."Grade Interval Type" = PeriodType) and (LastGradingDate <> 0D) then
                                EmpGradeHistory."Next grading Date" := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>', LastGradingDate);

                            EmpGradeHistory.INSERT;
                        end
                        else
                            ERROR('');

                        GradingScale.SETRANGE("Grade Code", GradeCode);
                        GradingScale.SETRANGE("Employee Category", Rec."Employee Category Code");
                        if GradingScale.FINDFIRST then begin
                            EVALUATE(PeriodType, '1M');
                            if (GradingScale."Grade Interval Type" = PeriodType) and (LastGradingDate <> 0D) then
                                NextGradingDate := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>', LastGradingDate);
                            EVALUATE(PeriodType, '1Y');
                            if (GradingScale."Grade Interval Type" = PeriodType) and (LastGradingDate <> 0D) then
                                NextGradingDate := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'Y>', LastGradingDate);
                        end;
                        CurrPage.UPDATE;
                    end;
                }
                field("Last Grading Date"; LastGradingDate)
                {
                    Caption = 'Last Graded Date';
                    ApplicationArea = All;
                    trigger OnValidate();
                    var
                        GradingScale: Record "Grading Scale";
                        PeriodType: DateFormula;
                        EmpGradeHistory: Record "Employee Grading History";
                        EmpGradeHistory2: Record "Employee Grading History";
                    begin
                        GradingScale.SETRANGE("Grade Code", GradeCode);
                        GradingScale.SETRANGE("Employee Category", Rec."Employee Category Code");
                        if GradingScale.FINDFIRST then begin
                            EVALUATE(PeriodType, '1M');
                            if (GradingScale."Grade Interval Type" = PeriodType) and (LastGradingDate <> 0D) then
                                NextGradingDate := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>', LastGradingDate);
                            EVALUATE(PeriodType, '1Y');
                            if (GradingScale."Grade Interval Type" = PeriodType) and (LastGradingDate <> 0D) then
                                NextGradingDate := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'Y>', LastGradingDate);
                        end;

                        if ChangeFromCard then begin
                            EmpGradeHistory.INIT;
                            if EmpGradeHistory.FINDLAST then
                                EmpGradeHistory."Primery Key" += 1
                            else
                                EmpGradeHistory."Primery Key" := 1;

                            EmpGradeHistory.VALIDATE("Employee No", Rec."No.");
                            EmpGradeHistory.VALIDATE("Previous Basic Pay", xRec."Basic Pay");
                            EmpGradeHistory.VALIDATE("Previous Grade", xRecGrade);
                            EmpGradeHistory.VALIDATE("Previous Grade Category", xRec."Employee Category Code");
                            EmpGradeHistory.VALIDATE("Previous HCL", xRec."Cost of Living Amount");
                            EmpGradeHistory.VALIDATE("Previous Last Grading Date", xRecLastGradeDate);
                            EmpGradeHistory.VALIDATE("Previous Next Grading Date", xRecNextGradeDate);
                            EmpGradeHistory.VALIDATE("Basic Pay", Rec."Basic Pay");
                            EmpGradeHistory.VALIDATE(HCL, Rec."Cost of Living Amount");
                            EmpGradeHistory.VALIDATE("Grade Category", Rec."Employee Category Code");
                            EmpGradeHistory.VALIDATE(Grade, GradeCode);
                            EmpGradeHistory.VALIDATE("Last Grading Date", LastGradingDate);
                            EmpGradeHistory.VALIDATE("Next grading Date", NextGradingDate);
                            EmpGradeHistory."Created By" := USERID;
                            EmpGradeHistory."Created DateTime" := CREATEDATETIME(WORKDATE, TIME);
                            EmpGradeHistory.VALIDATE("Is Temp", false);

                            EmpGradeHistory.INSERT;
                        end;
                    end;
                }
                field("Next Grading Date"; NextGradingDate)
                {
                    Caption = 'Next Grading Date';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Salary Info")
            {
                Visible = IsHROfficer or IsPayrollOfficer or IsEvaluationOfficer;
                Editable = IsPayrollOfficer or IsHROfficer;

                field("Basic Pay"; Rec."Basic Pay")
                {
                    Editable = IsEditible;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Cost of Living"; Rec."Cost of Living")
                {
                    ApplicationArea = All;
                }
                field("Extra Salary"; ExtraSalary)
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Deduct Absence From Salary"; DeductAbsenceFromSalary)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Salary (ACY)"; Rec."Salary (ACY)")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("PayrollFunctions.CaluclateTotalAllowances(Rec,ExtraSalary)"; PayrollFunctions.CaluclateTotalAllowances(Rec, ExtraSalary))
                {
                    Caption = 'Total Basic + allowances';
                    Editable = false;
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Hourly Basis"; Rec."Hourly Basis")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Hourly Rate"; Rec."Hourly Rate")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Daily Rate"; Rec."Daily Rate")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Freeze Salary"; Rec."Freeze Salary")
                {
                    ApplicationArea = All;
                }
                field("Reason of Change"; Rec."Reason of Change")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            group("Fixed Allowances - Deductions")
            {
                Visible = (ShowSalaryFld) and (IsHROfficer or IsPayrollOfficer or IsEvaluationOfficer);
                Editable = IsPayrollOfficer;
                field("Phone Allowance"; Rec."Phone Allowance")
                {
                    Visible = IsPhoneAllVisible;
                    ApplicationArea = All;
                }
                field("Car Allowance"; Rec."Car Allowance")
                {
                    Visible = IsCarAllVisible;
                    ApplicationArea = All;
                }
                field("House Allowance"; Rec."House Allowance")
                {
                    Visible = IsHouseAllVisible;
                    ApplicationArea = All;
                }
                field("Food Allowance"; Rec."Food Allowance")
                {
                    Visible = IsFoodAllVisible;
                    ApplicationArea = All;
                }
                field("Ticket Allowance"; Rec."Ticket Allowance")
                {
                    Visible = IsTicketAllVisible;
                    ApplicationArea = All;
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                    Visible = IsCommissionAmntVisible;
                    ApplicationArea = All;
                }
                field("Commission Addition"; Rec."Commission Addition")
                {
                    Visible = IsCommissionAmntVisible;
                    ApplicationArea = All;
                }
                field("Cost of Living Amount"; Rec."Cost of Living Amount")
                {
                    Editable = IsEditible;
                    Visible = IsHCLVisible;
                    ApplicationArea = All;
                }
                field("Other Allowances"; Rec."Other Allowances")
                {
                    Visible = IsOtherAllVisible;
                    ApplicationArea = All;
                }
                field("Commission Deduction"; Rec."Commission Deduction")
                {
                    Visible = IsCommissionDedVisible;
                    ApplicationArea = All;
                }
                field("Insurance Contribution"; Rec."Insurance Contribution")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Water Compensation"; Rec."Water Compensation")
                {
                    Visible = IsWaterCompVisible;
                    ApplicationArea = All;
                }
                field("Travel PerDeem Policy"; TravelPerDeemPolicy)
                {
                    Visible = UseTravelPerDiemPolicy;
                    Caption = 'Travel Per Deem Policy';
                    TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Travel Per Deem Policy"));
                    ApplicationArea = All;
                }
            }
            group("Payment Info")
            {
                Visible = (ShowSalaryFld) and (IsHROfficer or IsPayrollOfficer);
                Editable = IsPayrollOfficer;
                field("Payment Method"; Rec."Payment Method")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Bank No."; Rec."Bank No.")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Bank SWIFT Code"; BankSwiftCode)
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc No."; Rec."Emp. Bank Acc No.")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc Name"; Rec."Emp. Bank Acc Name")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc Arabic Name"; Rec."Emp. Bank Acc Arabic Name")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Bank Branch"; Rec."Bank Branch")
                {
                    ApplicationArea = All;
                }
                field("Emp. Transfer Bank Name"; TransferBankName)
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp Transfer Bank Branch"; Rec."Emp Transfer Bank Branch")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("IBAN No."; Rec."IBAN No.")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Payment Method (ACY)"; Rec."Payment Method (ACY)")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Bank No. (ACY)"; Rec."Bank No. (ACY)")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field("Emp. Bank Acc No. (ACY)"; Rec."Emp. Bank Acc No. (ACY)")
                {
                    Visible = ShowSalaryFld;
                    ApplicationArea = All;
                }
                field(TrustFundAgent; TrustFundAgent)
                {
                    Caption = 'Trust Fund Agent';
                    Visible = NigeriaPayLaw;
                    ApplicationArea = All;
                }
                field(TrustFundNumber; TrustFundNumber)
                {
                    Caption = 'Trust Fund Number';
                    Visible = NigeriaPayLaw;
                    ApplicationArea = All;
                }
                field("Employee Posting Group1"; Rec."Employee Posting Group")
                {
                    Caption = 'Employee Posting Group';
                    ApplicationArea = All;
                }
            }
            group(Passport)
            {
                Caption = 'Passport';
                Editable = GeneralEditable;
                Visible = IsHROfficer or IsDataEntryOfficer;
                field("Passport No."; Rec."Passport No.")
                {
                    ApplicationArea = All;
                }
                field("Passport Issue Place"; Rec."Passport Issue Place")
                {
                    ApplicationArea = All;
                }
                field("Passport Issue Date"; Rec."Passport Issue Date")
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (Rec."Passport Expiry Date" <= Rec."Passport Issue Date") and (Rec."Passport Expiry Date" <> 0D) then
                            Error('Passport Expiry Date must be grater than Passport Issue Date');
                    end;
                }
                field("Passport Expiry Date"; Rec."Passport Expiry Date")
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (Rec."Passport Expiry Date" <= Rec."Passport Issue Date") and (Rec."Passport Issue Date" <> 0D) then
                            Error('Passport Expiry Date must be grater than Passport Issue Date');
                    end;
                }
                field("Visa Number"; Rec."Visa Number")
                {
                    ApplicationArea = All;
                }
                field("Visa Issue Date"; VisaIssueDate)
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (VisaExpiryDate <= VisaIssueDate) and (VisaExpiryDate <> 0D) then
                            Error('Visa Expiry Date must be grater than Visa Issue Date');
                    end;
                }
                field("Visa Expiry Date"; VisaExpiryDate)
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (VisaExpiryDate <= VisaIssueDate) and (VisaIssueDate <> 0D) then
                            Error('Visa Expiry Date must be grater than Visa Issue Date');
                    end;
                }
                field("Resident No."; Rec."Resident No.")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;
                }
                field("Resident Issue Place"; Rec."Resident Issue Place")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;
                }
                field("Resident Issue Date"; Rec."Resident Issue Date")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (Rec."Resident Expiry Date" <= Rec."Resident Issue Date") and (Rec."Resident Expiry Date" <> 0D) then
                            Error('Resident Expiry Date must be grater than Resident Issue Date');
                    end;
                }
                field("Resident Expiry Date"; Rec."Resident Expiry Date")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (Rec."Resident Expiry Date" <= Rec."Resident Issue Date") and (Rec."Resident Issue Date" <> 0D) then
                            Error('Resident Expiry Date must be grater than Resident Issue Date');
                    end;
                }
                field("Work Permit No."; Rec."Work Permit No.")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;
                }
                field("Work Permit Issue Place"; Rec."Work Permit Issue Place")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;
                }
                field("Work Permit Issue Date"; Rec."Work Permit Issue Date")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (Rec."Work Permit Expiry Date" <= Rec."Work Permit Issue Date") and (Rec."Work Permit Expiry Date" <> 0D) then
                            Error('Work Permit Expiry Date must be grater than Work Permit Issue Date');
                    end;
                }
                field("Work Permit Expiry Date"; Rec."Work Permit Expiry Date")
                {
                    Enabled = IsForeignerEnabled;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        IF (Rec."Work Permit Expiry Date" <= Rec."Work Permit Issue Date") and (Rec."Work Permit Issue Date" <> 0D) then
                            Error('Work Permit Expiry Date must be grater than Work Permit Issue Date');
                    end;
                }
                field(QID; Rec.QID)
                {
                    visible = QatarQID;
                    ApplicationArea = All;
                }
                field("TECOM ID"; TECOMID)
                {
                    visible = UAETecom;
                    ApplicationArea = All;
                }

                field("TECOM Issue Date"; TECOMIssueDate)
                {
                    visible = UAETecom;
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (TECOMExpiryDate <= TECOMIssueDate) and (TECOMExpiryDate <> 0D) then
                            Error('TECOM Expiry Date must be grater than TECOM Issue Date');
                    end;
                }
                field("TECOM Expiry Date"; TECOMExpiryDate)
                {
                    visible = UAETecom;
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        IF (TECOMExpiryDate <= TECOMIssueDate) and (TECOMIssueDate <> 0D) then
                            Error('TECOM Expiry Date must be grater than TECOM Issue Date');
                    end;
                }
            }
            group("Documents Checklist")
            {
                Caption = 'Documents Checklist';
                Editable = GeneralEditable;
                Visible = IsHROfficer or IsDataEntryOfficer;
                field(RequestedDocuments; PayrollFunctions.GetEmployeeNumberOfDocuments(Rec."No."))
                {
                    Caption = 'No. of Documents';
                    Editable = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    var
                        RequestedDocument: Record "Requested Documents";
                    begin
                        RequestedDocument.RESET;
                        RequestedDocument.SETRANGE("No.", Rec."No.");
                        if RequestedDocument.FINDSET then;
                        //PAGE.RUNMODAL(PAGE::"Requested Documents",RequestedDocument);
                    end;
                }
                field("Copy of Identification Card"; Rec."Copy of Identification Card")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Copy of Judiciary Record"; Rec."Copy of Judiciary Record")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Copy of Employment Contract"; Rec."Copy of Employment Contract")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Copy of Passport"; Rec."Copy of Passport")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Copy of Diplomas"; Rec."Copy of Diplomas")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Curriculum Vitae"; Rec."Curriculum Vitae")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Letters of Recommendations"; Rec."Letters of Recommendations")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Permission to practice prof."; Rec."Permission to practice prof.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Home Address Certificate"; Rec."Home Address Certificate")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Individual Civil Record"; Rec."Individual Civil Record")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Family Record"; Rec."Family Record")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Supervisor Evaluation Form"; Rec."Supervisor Evaluation Form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Self Evaluation Form"; Rec."Self Evaluation Form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Labor Office Certificat"; Rec."Labor Office Certificat")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Military Service"; Rec."Military Service")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Residence Certificate"; Rec."Residence Certificate")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Driving Licenses"; Rec."Driving Licenses")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Position Request Form"; Rec."Position Request Form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employment Approval Form"; Rec."Employment Approval Form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Job Application Form"; Rec."Job Application Form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Pre-Hiring Interview Sheet"; Rec."Pre-Hiring Interview Sheet")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Engineering Syndicate Card"; Rec."Engineering Syndicate Card")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Application Photos"; Rec."Application Photos")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Banking Form"; Rec."Employee Banking Form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Proxy(Wakeleh)"; Rec."Proxy(Wakeleh)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Terms Of Employment"; Rec."Terms Of Employment")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("last Work Permit"; Rec."last Work Permit")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Salary Raise"; Rec."Salary Raise")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Others; Rec.Others)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("English Exam"; Rec."English Exam")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Behavioral interview"; Rec."Behavioral interview")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Technical interview"; Rec."Technical interview")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Job offer approved"; Rec."Job offer approved")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Photo passports"; Rec."Photo passports")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Judicial Records"; Rec."Judicial Records")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Original Register ID"; Rec."Original Register ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Original Family ID"; Rec."Original Family ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NSSF Certificate"; Rec."NSSF Certificate")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employment Verification"; Rec."Employment Verification")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Educational Verification"; Rec."Educational Verification")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Medical Examination report"; Rec."Medical Examination report")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Application form"; Rec."Application form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Tax declaration form"; Rec."Tax declaration form")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Written agreement"; Rec."Written agreement")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Confidentiality Letter"; Rec."Confidentiality Letter")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee job description"; Rec."Employee job description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Marriage Certificate"; Rec."Marriage Certificate")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                Field("National Identity"; Rec."National Identity")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                Field("Degree (UAE)"; Rec."Degree (UAE)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                Field("Emirates ID Copies"; Rec."Emirates ID Copies")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Hiring Check List")
            {
                Editable = GeneralEditable;
                Visible = IsHROfficer or IsDataEntryOfficer;
                field(Computer; Rec.Computer)
                {
                    ApplicationArea = All;
                }
                field(Chair; Rec.Chair)
                {
                    ApplicationArea = All;
                }
                field(Stationery; Rec.Stationery)
                {
                    ApplicationArea = All;
                }
                field("Extension phone number"; Rec."Extension phone number")
                {
                    ApplicationArea = All;
                }
                field("Email Signature"; Rec."Email Signature")
                {
                    ApplicationArea = All;
                }
                field("Business Cards"; Rec."Business Cards")
                {
                    ApplicationArea = All;
                }
                field("Network Logins"; Rec."Network Logins")
                {
                    ApplicationArea = All;
                }
                field("Server Access"; Rec."Server Access")
                {
                    ApplicationArea = All;
                }
                field("Office Regular Hours"; Rec."Office Regular Hours")
                {
                    ApplicationArea = All;
                }
                field("Code Of Conduct"; Rec."Code Of Conduct")
                {
                    ApplicationArea = All;
                }
                field("Employee HandBook"; Rec."Employee HandBook")
                {
                    ApplicationArea = All;
                }
                field("Finger Print"; Rec."Finger Print")
                {
                    ApplicationArea = All;
                }
                field("Parking Lod"; Rec."Parking Lod")
                {
                    ApplicationArea = All;
                }
                field("Employee To Staff Member"; Rec."Employee To Staff Member")
                {
                    ApplicationArea = All;
                }
                field("Send Welcoming Letter"; Rec."Send Welcoming Letter")
                {
                    ApplicationArea = All;
                }
            }
            group(Personal1)
            {
                Caption = 'Personal';
                Editable = GeneralEditable;
                Visible = IsHROfficer or IsDataEntryOfficer;
                field("Government ID No."; Rec."Government ID No.")
                {
                    ApplicationArea = All;
                }
                field("Driving License"; Rec."Driving License")
                {
                    ApplicationArea = All;
                }
                field("Driving License Type"; Rec."Driving License Type")
                {
                    ApplicationArea = All;
                }
                field("Driving License Expiry Date"; Rec."Driving License Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("National No."; Rec."National No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Recommendation Date"; Rec."Recommendation Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Recommendation Name"; Rec."Recommendation Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            group(Health)
            {
                Caption = 'Health';
                Editable = GeneralEditable;
                Visible = IsHROfficer or IsDataEntryOfficer;
                field("Health Card No"; Rec."Health Card No")
                {
                    ApplicationArea = All;
                }
                field("Health Insurance Company"; Rec."Health Card Issue Place")
                {
                    Caption = 'Health Insurance Company';
                    ApplicationArea = All;
                }
                field("Health Card Issue Date"; Rec."Health Card Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Health Card Expiry Date"; Rec."Health Card Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Blood Type"; Rec."Blood Type")
                {
                    ApplicationArea = All;
                }
                field("Chronic Disease"; Rec."Chronic Disease")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.update;
                    end;
                }
                field("Chronic Disease Details"; Rec."Chronic Disease Details")
                {
                    Enabled = ChronicDiseaseEnabled;
                    ApplicationArea = All;
                }
                field("Other Health Information"; Rec."Other Health Information")
                {
                    ApplicationArea = All;
                }
                field(LifeInsurancePremium; LifeInsurancePremium)
                {
                    Caption = 'Yearly Life Insurance Premium';
                    Visible = NigeriaPayLaw;
                    ApplicationArea = All;
                }
            }
            group("Arabic Info")
            {
                Caption = 'Arabic Info';
                Visible = IsHROfficer or IsDataEntryOfficer or IsPayrollOfficer;
                editable = IsHROfficer or IsDataEntryOfficer;
                field("Arabic First Name"; Rec."Arabic First Name")
                {
                    ApplicationArea = All;
                }
                field("Arabic Middle Name"; Rec."Arabic Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Arabic Last Name"; Rec."Arabic Last Name")
                {
                    ApplicationArea = All;
                }
                field("Arabic Mother Name"; Rec."Arabic Mother Name")
                {
                    ApplicationArea = All;
                }
                field("Arabic Name"; Rec."Arabic Name")
                {
                    ApplicationArea = All;
                }

                field("Arabic Job Title"; Rec."Arabic Job Title")
                {
                    ApplicationArea = All;
                }
                field("Arabic Place of Birth"; Rec."Arabic Place of Birth")
                {
                    ApplicationArea = All;
                }
                field("Arabic Nationality"; Rec."Arabic Nationality")
                {
                    ApplicationArea = All;
                }
                field("Arabic Governorate"; Rec."Arabic Governorate")
                {
                    ApplicationArea = All;
                }
                field("Arabic Elimination"; Rec."Arabic Elimination")
                {
                    ApplicationArea = All;
                }
                field("Arabic City"; Rec."Arabic City")
                {
                    ApplicationArea = All;
                }
                field("Arabic District"; Rec."Arabic District")
                {
                    ApplicationArea = All;
                }
                field("Arabic Street"; Rec."Arabic Street")
                {
                    ApplicationArea = All;
                }
                field("Arabic Building"; Rec."Arabic Building")
                {
                    ApplicationArea = All;
                }
                field("Arabic Floor"; Rec."Arabic Floor")
                {
                    ApplicationArea = All;
                }
                field("Arabic Land Area"; Rec."Arabic Land Area")
                {
                    ApplicationArea = All;
                }
                field("Arabic Land Area  No."; Rec."Arabic Land Area  No.")
                {
                    ApplicationArea = All;
                }
                field("Mailbox ID"; Rec."Mailbox ID")
                {
                    ApplicationArea = All;
                }
                field("Arabic MailBox Area"; Rec."Arabic MailBox Area")
                {
                    ApplicationArea = All;
                }
                field("Register No."; Rec."Register No.")
                {
                    ApplicationArea = All;
                }
                field("Arabic Registeration Place"; Rec."Arabic Registeration Place")
                {
                    ApplicationArea = All;
                }
            }
            group("WifeHusband Info")
            {
                Caption = 'Wife/Husband Info';
                Visible = IsHROfficer or IsDataEntryOfficer or IsPayrollOfficer;
                editable = IsHROfficer or IsDataEntryOfficer;
                field("Wife-Hsband Name"; "Wife-Hsband Name")
                {
                    Caption = 'اسم الزوج / الزوجة';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Father Name"; "Wife-Hsband Father Name")
                {
                    Caption = 'اسم الأب';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Nationality"; "Wife-Hsband Nationality")
                {
                    Caption = 'الجنسية';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Birthdate"; "Wife-Hsband Birthdate")
                {
                    Caption = 'تاريخ الولادة';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Registry No."; "Wife-Hsband Registry No.")
                {
                    Caption = 'رقم السجل';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Registry Place"; "Wife-Hsband Registry Place")
                {
                    Caption = 'مكان السجل';
                    ApplicationArea = All;
                }
                field("Family Before Marriage"; "Family Before Marriage")
                {
                    Caption = 'الشهرة قبل الزواج';
                    ApplicationArea = All;
                }
                field("Mother Family Before Marriage"; "Mother Family Before Marriage")
                {
                    Caption = 'إسم الأم و شهرتها قبل الزواج';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Birth Place"; "Wife-Hsband Birth Place")
                {
                    Caption = 'محل الــولادة';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Card No."; "Wife-Hsband Card No.")
                {
                    Caption = 'رقم بطاقة الهوية';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Working"; "Wife-Hsband Working")
                {
                    Caption = 'هل الزوج / الزوجة يعمل؟';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Working Place"; "Wife-Hsband Working Place")
                {
                    Caption = 'عمل الزوج / الزوجة';
                    ApplicationArea = All;
                }
                field("Wife-Hsband Registration No."; "Wife-Hsband Registration No.")
                {
                    Caption = '(لدى وزارة المالية)رقم التسجيل';
                    ApplicationArea = All;
                }
            }
            group(Evaluation)
            {
                visible = IsEvaluationOfficer;
                Editable = IsEvaluationOfficer;

                field("Evaluation Template"; EvaluationTemplateVar)
                {
                    Visible = IsEvaluationOfficer and UseEvaluationSheet;
                    TableRelation = "Evaluation Template".Code;
                    ApplicationArea = All;
                }

                field(Band; Rec.Band)
                {
                    visible = IsEvaluationOfficer;
                    ApplicationArea = All;
                }
                field(Grade; Rec.Grade)
                {
                    visible = IsEvaluationOfficer;
                    ApplicationArea = All;
                }
            }
            group(Other)
            {
                Visible = false;
                field("Engineer Syndicate AL Fees"; Rec."Engineer Syndicate AL Fees")
                {
                    ApplicationArea = All;
                }
                field("Eng Syndicate AL Pymt Date"; Rec."Eng Syndicate AL Pymt Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        Modify("Co&mments")
        {
            Visible = false;
        }
        Modify("&Picture")
        {
            Visible = false;
        }
        Modify("&Relatives")
        {
            Visible = false;
        }
        Modify("Mi&sc. Article Information")
        {
            Visible = false;
        }
        Modify("Ledger E&ntries")
        {
            Visible = false;
        }
        Modify("&Confidential Information")
        {
            Visible = false;
        }
        Modify("Q&ualifications")
        {
            Visible = false;
        }
        Modify("A&bsences")
        {
            Visible = false;
        }
        Modify("Absences by Ca&tegories")
        {
            Visible = false;
        }
        Modify("Misc. Articles &Overview")
        {
            Visible = false;
        }
        Modify("Co&nfidential Info. Overview")
        {
            Visible = false;
        }
        modify(Dimensions)
        {
            Visible = false;
        }
        modify(AlternativeAddresses)
        {
            Visible = false;
        }
        addafter("E&mployee")
        {
            group(Finance)
            {
                Caption = 'Finance';
                action(Attendances)
                {
                    Visible = false;
                    Caption = 'Attendances';
                    Image = AbsenceCalendar;
                    RunObject = Page "Employee Absence Entitlement";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Annual Leave")
                {
                    Visible = false;
                    Caption = 'Annual Leaves';
                    Image = AbsenceCategory;
                    RunObject = Page "Employee Absence Entitlement";
                    RunPageLink = "Employee No." = FIELD("No."), "Cause of Absence Code" = CONST('AL');
                    ApplicationArea = All;
                }
                action("Sick Leave")
                {
                    Visible = false;
                    Caption = 'Sick Leaves';
                    Image = AbsenceCategory;
                    RunObject = Page "Employee Absence Entitlement";
                    RunPageLink = "Employee No." = FIELD("No."), "Cause of Absence Code" = Filter('SKD' | 'SKL');
                    ApplicationArea = All;
                }
                action("Absences Overview")
                {
                    Visible = false;
                    Caption = 'Absence Overview';
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Journal)
                {
                    Visible = false;
                    Caption = 'Journal';
                    Image = Journals;
                    ApplicationArea = All;
                }
                action("Payroll Ledger Entries")
                {
                    Visible = false;
                    Caption = 'Payroll Ledger Entries';
                    Image = LedgerEntries;
                    RunObject = Page "Payroll Ledger Entries";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Employee Salary Raise History")
                {
                    Visible = false;
                    Caption = 'Employee Salary Raise History';
                    RunObject = Page "Salary Raise Request List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Employee Salary History")
                {
                    Visible = false;
                    Caption = 'Employee Salary History';
                    RunObject = Page "Employee Salary History";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
            group(Employee)
            {
                Caption = 'Employee';
                action(Comments)
                {
                    Caption = 'Comments';
                    visible = IsHROfficer;
                    Image = ViewComments;
                    RunObject = Page "HR Comment Sheet EDM";
                    RunPageLink = "Table Name" = CONST("Employee"), "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Objectives)
                {
                    Caption = 'Objectives';
                    Visible = false;
                    ApplicationArea = All;
                }
                action(Dimension)
                {
                    Caption = 'Dimension';
                    Image = Dimensions;
                    visible = IsHROfficer or IsPayrollOfficer;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(5200), "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Picture)
                {
                    Caption = 'Picture';
                    visible = IsHROfficer or IsDataEntryOfficer;
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Alternative Address List")
                {
                    Caption = 'Alternative Addresses';
                    Image = AlternativeAddress;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action(Relatives)
                {
                    Caption = 'Relatives';
                    Image = Relatives;
                    visible = IsPayrollOfficer or IsHROfficer or IsDataEntryOfficer;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Misc. Article Information")
                {
                    Caption = 'Misc. Article Information';
                    visible = IsHROfficer;
                    Image = Info;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Confidential Information")
                {
                    Caption = 'Confidential Information';
                    visible = IsHROfficer;
                    Image = Info;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Disciplinary Actions")
                {
                    Caption = 'Disciplinary Actions';
                    visible = IsHROfficer;
                    Image = DocumentsMaturity;
                    RunObject = Page "Employee Disciplinary Action";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Qualifications)
                {
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    visible = IsHROfficer or IsDataEntryOfficer;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Requested Documents")
                {
                    Caption = 'Documents';
                    visible = IsHROfficer or IsDataEntryOfficer;
                    Image = Documents;
                    RunObject = Page "Requested Documents";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Academic History")
                {
                    Caption = 'Academic History';
                    visible = IsHROfficer or IsDataEntryOfficer;
                    Image = History;
                    RunObject = Page "Academic History";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Language Skills")
                {
                    Caption = 'Language Skills';
                    visible = IsHROfficer or IsDataEntryOfficer;
                    Image = Language;
                    RunObject = Page "Language Skills";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    ApplicationArea = All;
                }

                action(Interview)
                {
                    Caption = 'Interviews';
                    visible = IsRecruitmentOfficer;
                    Image = Notes;
                    RunObject = Page "Human Resource Interview Sheet";
                    RunPageLink = "Table Name" = CONST(Employee), "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Survey)
                {
                    Caption = 'Survey';
                    Visible = false;
                    ApplicationArea = All;
                }
                action(Contracts)
                {
                    Caption = 'Contracts';
                    visible = IsHROfficer;
                    Image = Answers;
                    RunObject = Page "Employee Contracts";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Work Accident")
                {
                    Caption = 'Work Accidents';
                    visible = IsHROfficer;
                    Image = WorkCenter;
                    RunObject = Page "Employee Work Accident";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Misc. Articles Overview")
                {
                    Caption = 'Misc. Articles Overview';
                    RunObject = Page "Misc. Articles Overview";
                    Visible = IsHROfficer;
                    ApplicationArea = All;
                }
                action("Confidential Info. Overview")
                {
                    Caption = 'Confidential Info. Overview';
                    RunObject = Page "Confidential Info. Overview";
                    Visible = IsHROfficer;
                    ApplicationArea = All;
                }
                action("Computer Skills")
                {
                    Caption = 'Computer Skills';
                    visible = IsHROfficer or IsDataEntryOfficer;
                    Image = Skills;
                    RunObject = Page "Employee Computer Skills";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Employee Assets")
                {
                    Image = Tools;
                    visible = IsHROfficer or IsDataEntryOfficer;
                    RunObject = Page "Employee Assets List";
                    RunPageLink = "Employee No" = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Probation Evaluation Sheet")
                {
                    Image = Evaluate;
                    visible = IsEvaluationOfficer;
                    RunObject = Page "Probation Evaluation Sheet";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("New Hire Check List")
                {
                    Visible = UseHiringCheckList and IsHROfficer;
                    Image = CheckList;
                    RunObject = Page "New Hire Check List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("IT Check List")
                {
                    Visible = UseHiringCheckList and IsHROfficer;
                    Image = CheckList;
                    RunObject = Page "IT Check List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
            action(Ikama)
            {
                Caption = 'Ikama';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Employee Ikama";
                RunPageLink = "Employee No." = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
            action("Convert Leaves")
            {
                CaptionML = ENU = 'Convert Leaves',
                            ENG = '&List';
                Visible = false;
                ApplicationArea = All;
            }
        }
        addlast(Processing)
        {
            group(Functions)
            {
                caption = 'Functions';
                action("Delete Pay Details")
                {
                    Caption = 'Delete Pay Details';
                    visible = IsHROfficer or IsPayrollOfficer;
                    Image = Delete;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        PayDetailHeader: Record "Pay Detail Header";
                    begin
                    end;
                }
                action("Create Pay Details")
                {
                    Caption = 'Create Pay Details';
                    visible = IsHROfficer or IsPayrollOfficer;
                    Image = CreateDocument;
                    ApplicationArea = All;
                }
                action("Related Employees Files")
                {
                    Visible = false;
                    Caption = 'Related Employees Files';
                    Image = FileContract;
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        HumanResSetup: Record "Human Resources Setup";
        ShowSalaryFld: Boolean;
        EvaluationTemplateVar: Code[20];
        EmpAddInfoTbt: Record "Employee Additional Info";
        FamAllowRetroDate: Date;
        IsPhoneAllVisible: Boolean;
        IsCarAllVisible: Boolean;
        IsHouseAllVisible: Boolean;
        IsTicketAllVisible: Boolean;
        IsFoodAllVisible: Boolean;
        IsOtherAllVisible: Boolean;
        ExtraSalary: Decimal;
        VisaExpiryDate: date;
        VisaIssueDate: date;
        TECOMID: Code[50];
        TECOMExpiryDate: date;
        TECOMIssueDate: date;
        GradeCode: Code[10];
        LastGradingDate: Date;
        NextGradingDate: Date;
        UseGrade: Boolean;
        IsEditible: Boolean;
        xRecGrade: Code[10];
        xRecLastGradeDate: Date;
        xRecNextGradeDate: Date;
        ChangeFromCard: Boolean;
        UseResourceConcept: Boolean;
        HRSetup: Record "Human Resources Setup";
        DeductAbsenceFromSalary: Boolean;
        PayrollFunctions: Codeunit "Payroll Functions";
        TravelPerDeemPolicy: Code[20];
        LifeInsurancePremium: Decimal;
        TrustFundAgent: Text[50];
        TrustFundNumber: Text[50];
        NigeriaPayLaw: Boolean;
        PayParam: Record "Payroll Parameter";
        LebanonPayLaw: Boolean;
        IsCommissionAmntVisible: Boolean;
        IsCommissionAddVisible: Boolean;
        IsCommissionDedVisible: Boolean;
        IsWaterCompVisible: Boolean;
        IsHCLVisible: Boolean;
        BankName: Text;
        BankSwiftCode: Code[50];
        BankNameACY: Text;
        BankSwiftCodeACY: Code[50];
        IBANNo: Text[30];
        TransferBankName: text[50];
        TransferBankNameACY: text[50];
        UseHiringCheckList: Boolean;
        PayFunction: Codeunit "Payroll Functions";
        UAETecom: Boolean;
        QatarQID: Boolean;
        UseTravelPerDiemPolicy: Boolean;
        GeneralEditable: Boolean;
        IsHROfficer: Boolean;
        IsDataEntryOfficer: Boolean;
        IsPayrollOfficer: Boolean;
        IsEvaluationOfficer: Boolean;

        IsRecruitmentOfficer: Boolean;

        UseEvaluationSheet: Boolean;
        IraqPayLaw: Boolean;
        UAEPayLaw: Boolean;
        QatarPayLaw: Boolean;
        EgyptPayLaw: Boolean;
        EmploeeAdditionalInfoRec: Record "Employee Additional Info";
        IsForeignerEnabled: Boolean;
        ChronicDiseaseEnabled: Boolean;

    trigger OnOpenPage();
    begin
        IsHROfficer := PayrollFunctions.IsHROfficer(UserId);
        IsDataEntryOfficer := PayrollFunctions.IsDataEntryOfficer(Userid);
        IsPayrollOfficer := PayrollFunctions.IsPayrollOfficer(Userid);
        IsEvaluationOfficer := PayrollFunctions.IsEvaluationOfficer(UserId);
        IsRecruitmentOfficer := PayrollFunctions.IsRecruitmentOfficer(UserId);
        UseEvaluationSheet := PayFunction.IsFeatureVisible('EvaluationSheet');
        IF NOT (IsHROfficer or IsDataEntryOfficer or IsPayrollOfficer or IsEvaluationOfficer) then
            error('No Permission!');

        IF IsHROfficer or IsDataEntryOfficer then
            GeneralEditable := true;
        //
        InitializeAddtionalInfoVariables();
        PayParam.GET;
        NigeriaPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Nigeria);
        LebanonPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Lebanon);
        IraqPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Iraq);
        UAEPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::UAE);
        QatarPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Qatar);
        EgyptPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Egypt);
        ShowSalaryFld := PayrollFunctions.CanUserAccessEmployeeSalary('', Rec."No.");
        IF ShowSalaryFld = TRUE THEN BEGIN
            IF PayParam."Mobile allowance" <> '' THEN
                IsPhoneAllVisible := TRUE;
            IF PayParam."Car Allowance" <> '' THEN
                IsCarAllVisible := TRUE;
            IF PayParam."Housing Allowance" <> '' THEN
                IsHouseAllVisible := TRUE;
            IF PayParam."Ticket Allowance" <> '' THEN
                IsTicketAllVisible := TRUE;
            IF PayParam.Food <> '' THEN
                IsFoodAllVisible := TRUE;
            IF PayParam."Production Allowance" <> '' THEN
                IsCommissionAmntVisible := TRUE;
            IF PayParam."Commision Addition" <> '' THEN
                IsCommissionAddVisible := TRUE;
            IF PayParam."Comission Deduction" <> '' THEN
                IsCommissionDedVisible := TRUE;
            IF PayParam."Water Compensation Allowance" <> '' THEN
                IsWaterCompVisible := TRUE;
            IF PayParam."High Cost of Living Code" <> '' THEN
                IsHCLVisible := TRUE;
            IF PayParam.Allowance <> '' THEN
                IsOtherAllVisible := TRUE;
        END;
        ShowHideGradeSystem();
        UseResourceConcept := PayFunction.IsFeatureVisible('ResourcesConcept');
        UseHiringCheckList := PayFunction.IsFeatureVisible('HiringCheckList');
        UseTravelPerDiemPolicy := PayFunction.IsFeatureVisible('TravelPerDiemPolicy');
        //UAE Tecom EDM.JA+
        PayParam.Get;
        IF PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::"UAE" then
            UAETecom := true
        else
            UAETecom := false;
        //UAE Tecom EDM.JA-
        //Qatar QID EDM.JA+
        PayParam.Get;
        IF PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Qatar then
            QatarQID := true
        else
            QatarQID := false;
        //Qatar QID EDM.JA-
    end;

    trigger OnClosePage();
    begin
        SaveEmpAddInfo();
    end;

    trigger OnAfterGetRecord();
    begin
        IF NOT PayrollFunctions.CanUserAccessEmployeeCard('', Rec."No.") THEN
            ERROR('User does not have permission to access this payroll group');
        ShowSalaryFld := PayrollFunctions.CanUserAccessEmployeeSalary('', Rec."No.");
        IsForeignerEnabled := Rec.IsForeigner;
        ChronicDiseaseEnabled := Rec."Chronic Disease";

    end;

    local procedure InitializeAddtionalInfoVariables();
    begin
        EmpAddInfoTbt.RESET;
        CLEAR(EmpAddInfoTbt);
        EmpAddInfoTbt.SETRANGE("Employee No.", Rec."No.");
        if EmpAddInfoTbt.FINDFIRST then begin
            EvaluationTemplateVar := EmpAddInfoTbt."Evaluation Template";
            FamAllowRetroDate := EmpAddInfoTbt."Family Allowance Retro Date";
            ExtraSalary := EmpAddInfoTbt."Extra Salary";
            VisaExpiryDate := EmpAddInfoTbt."Visa Expiry Date";
            VisaIssueDate := EmpAddInfoTbt."Visa Issue Date";
            TECOMID := EmpAddInfoTbt."TECOM ID";
            TECOMExpiryDate := EmpAddInfoTbt."TECOM Expiry Date";
            TECOMIssuedate := EmpAddInfoTbt."TECOM Issue Date";
            IBANNo := Rec.IBAN;
            DeductAbsenceFromSalary := EmpAddInfoTbt."Deduct Absence From Salary";//edm.sc+-
            TravelPerDeemPolicy := EmpAddInfoTbt."Travel Per Deem Policy";//EDM.TarekH+-
            LifeInsurancePremium := EmpAddInfoTbt."Life Insurance Premium";//EDM.TarekH+-
            TrustFundAgent := EmpAddInfoTbt."Trust Fund Agent";//EDM.TarekH+-
            TrustFundNumber := EmpAddInfoTbt."Trust Fund Number";//EDM.TarekH+-
            BankName := EmpAddInfoTbt."Bank Name";//EDM.TarekH+-
            BankSwiftCode := EmpAddInfoTbt."Bank SWIFT Code";//EDM.TarekH+-
            BankNameACY := EmpAddInfoTbt."Bank Name (ACY)";//EDM.TarekH+-
            BankSwiftCodeACY := EmpAddInfoTbt."Bank SWIFT Code (ACY)";//EDM.TarekH+-
            IBANNo := EmpAddInfoTbt."IBAN No";
            TransferBankName := EmpAddInfoTbt."Emp Transfer Bank Name";
            TransferBankNameACY := EmpAddInfoTbt."Emp Transfer Bank Name (ACY)";
        END;
    end;

    local procedure SaveEmpAddInfo();
    var
        EmployeeAddInfo: Record "Employee Additional Info";
    begin
        CLEAR(EmployeeAddInfo);
        EmployeeAddInfo.RESET;
        EmployeeAddInfo.SETRANGE("Employee No.", Rec."No.");
        if EmployeeAddInfo.FINDFIRST then begin
            if Rec."Work Permit Expiry Date" <> 0D then begin
                EmployeeAddInfo."Work Permit Valid Until" := Rec."Work Permit Expiry Date";
                EmployeeAddInfo."Work Permit Month Filter" := DATE2DMY(Rec."Work Permit Expiry Date", 2);
                EmployeeAddInfo."Work Permit Year Filter" := DATE2DMY(Rec."Work Permit Expiry Date", 3);
            end;
            if Rec."Passport Expiry Date" <> 0D then begin
                EmployeeAddInfo."Passport Valid Until" := Rec."Passport Expiry Date";
                EmployeeAddInfo."Passport Month Filter" := DATE2DMY(Rec."Passport Expiry Date", 2);
                EmployeeAddInfo."Passport Year Filter" := DATE2DMY(Rec."Passport Expiry Date", 3);
            end;
            if Rec."Resident Expiry Date" <> 0D then begin
                EmployeeAddInfo."Work Residency Valid Until" := Rec."Resident Expiry Date";
                EmployeeAddInfo."Work Residency Month Filter" := DATE2DMY(Rec."Resident Expiry Date", 2);
                EmployeeAddInfo."Work Residency Year Filter" := DATE2DMY(Rec."Resident Expiry Date", 3);
            end;
            EmployeeAddInfo."Evaluation Template" := EvaluationTemplateVar;
            EmployeeAddInfo."Extra Salary" := ExtraSalary;
            EmployeeAddInfo."Visa Expiry Date" := VisaExpiryDate;
            EmployeeAddInfo."Visa Issue Date" := VisaIssueDate;
            EmployeeAddInfo."TECOM ID" := TECOMID;
            EmployeeAddInfo."TECOM Expiry Date" := TECOMExpiryDate;
            EmployeeAddInfo."TECOM Issue Date" := TECOMIssuedate;
            EmployeeAddInfo."Deduct Absence From Salary" := DeductAbsenceFromSalary;//edm.sc+-
            EmployeeAddInfo."Travel Per Deem Policy" := TravelPerDeemPolicy;//EDM.TarekH+-
            EmployeeAddInfo."Life Insurance Premium" := LifeInsurancePremium;//EDM.TarekH+-
            EmployeeAddInfo."Trust Fund Agent" := TrustFundAgent;//EDM.TarekH+-
            EmployeeAddInfo."Trust Fund Number" := TrustFundNumber;//EDM.TarekH+-
            EmployeeAddInfo."Bank Name" := BankName;//EDM.TarekH+-
            EmployeeAddInfo."Bank SWIFT Code" := BankSwiftCode;//EDM.TarekH+-
            EmployeeAddInfo."Bank Name (ACY)" := BankNameACY;//EDM.TarekH+-
            EmployeeAddInfo."Bank SWIFT Code (ACY)" := BankSwiftCodeACY;//EDM.TarekH+-
            EmployeeAddInfo."IBAN No" := IBANNo;
            EmployeeAddInfo."Emp Transfer Bank Name" := TransferBankName;
            EmployeeAddInfo."Emp Transfer Bank Name (ACY)" := TransferBankNameACY;
            EmployeeAddInfo.MODIFY;
        end
        else begin
            EmployeeAddInfo.INIT;
            EmployeeAddInfo."Employee No." := Rec."No.";
            if Rec."Work Permit Expiry Date" <> 0D then begin
                EmployeeAddInfo."Work Permit Valid Until" := Rec."Work Permit Expiry Date";
                EmployeeAddInfo."Work Permit Month Filter" := DATE2DMY(Rec."Work Permit Expiry Date", 2);
                EmployeeAddInfo."Work Permit Year Filter" := DATE2DMY(Rec."Work Permit Expiry Date", 3);
            end;
            if Rec."Passport Expiry Date" <> 0D then begin
                EmployeeAddInfo."Passport Valid Until" := Rec."Passport Expiry Date";
                EmployeeAddInfo."Passport Month Filter" := DATE2DMY(Rec."Passport Expiry Date", 2);
                EmployeeAddInfo."Passport Year Filter" := DATE2DMY(Rec."Passport Expiry Date", 3);
            end;
            if Rec."Resident Expiry Date" <> 0D then begin
                EmployeeAddInfo."Work Residency Valid Until" := Rec."Resident Expiry Date";
                EmployeeAddInfo."Work Residency Month Filter" := DATE2DMY(Rec."Resident Expiry Date", 2);
                EmployeeAddInfo."Work Residency Year Filter" := DATE2DMY(Rec."Resident Expiry Date", 3);
            end;
            EmployeeAddInfo."Evaluation Template" := EvaluationTemplateVar;
            EmployeeAddInfo."Extra Salary" := ExtraSalary;
            EmployeeAddInfo."Visa Expiry Date" := VisaExpiryDate;
            EmployeeAddInfo."Visa Issue Date" := VisaIssueDate;
            EmployeeAddInfo."TECOM ID" := TECOMID;
            EmployeeAddInfo."TECOM Expiry Date" := TECOMExpiryDate;
            EmployeeAddInfo."TECOM Issue Date" := TECOMIssuedate;
            EmployeeAddInfo."Deduct Absence From Salary" := DeductAbsenceFromSalary;//edm.sc+-
            EmployeeAddInfo."Travel Per Deem Policy" := TravelPerDeemPolicy;//EDM.TarekH+-
            EmployeeAddInfo."Life Insurance Premium" := LifeInsurancePremium;//EDM.TarekH+-
            EmployeeAddInfo."Trust Fund Agent" := TrustFundAgent;//EDM.TarekH+-
            EmployeeAddInfo."Trust Fund Number" := TrustFundNumber;//EDM.TarekH+-
            EmployeeAddInfo."Bank Name" := BankName;//EDM.TarekH+-
            EmployeeAddInfo."Bank SWIFT Code" := BankSwiftCode;//EDM.TarekH+-
            EmployeeAddInfo."Bank Name (ACY)" := BankNameACY;//EDM.TarekH+-
            EmployeeAddInfo."Bank SWIFT Code (ACY)" := BankSwiftCodeACY;//EDM.TarekH+-
            EmployeeAddInfo."IBAN No" := IBANNo;
            EmployeeAddInfo."Emp Transfer Bank Name" := TransferBankName;
            EmployeeAddInfo."Emp Transfer Bank Name (ACY)" := TransferBankNameACY;
            EmployeeAddInfo.INSERT;
        end;
    end;

    local procedure ShowHideGradeSystem();
    begin
        UseGrade := false;
        IsEditible := true;
        if PayrollFunctions.UseGradingSystem() then
            UseGrade := PayrollFunctions.IsEmployeeCategoryUseGradingSystem(Rec."Employee Category Code");
        if UseGrade then
            UseGrade := not PayrollFunctions.HideSalaryFields();
        if UseGrade then
            UseGrade := PayrollFunctions.CanUserAccessEmployeeSalary('', Rec."No.");

        if UseGrade then
            IsEditible := false;
        xRecGrade := GradeCode;
        xRecLastGradeDate := LastGradingDate;
        xRecNextGradeDate := NextGradingDate;
        ChangeFromCard := true;
    end;

    procedure GetDecimalString(a: Record "Employee"; b: Integer; c: Integer): Text
    var
    begin
        exit(format(a));
    end;
}