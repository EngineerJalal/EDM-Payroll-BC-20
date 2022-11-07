table 98049 "Payroll Parameter"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(10; "Basic Pay Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(11; "Income Tax Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(12; "High Cost of Living Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(13; "Advance on Salary"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(14; "Day-Off Transportation"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(15; "Pension Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(16; "Holiday Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(22; "Scholarship Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(23; "Back Pay Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(24; "Prev. Period Pay Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(31; "Integrate to G/L"; Boolean)
        {
        }
        field(40; "Use 50 Notes"; Boolean)
        {
        }
        field(41; "Tax Code H Change"; Integer)
        {
        }
        field(42; "Max. Pension Age"; Integer)
        {
        }
        field(43; "Max.Scholarship Eligible Child"; Integer)
        {
        }
        field(50; "Max. Pension Eligible Child"; Integer)
        {
        }
        field(60; "Emergency Tax Code"; Text[6])
        {
        }
        field(62; "Max. Scholarship Allowance"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(63; "Default Tax Code"; Option)
        {
            OptionMembers = Emergency,"Basic Rate";
        }
        field(65; "Scottish Variable Rate"; Decimal)
        {
            MaxValue = 3;
            MinValue = -3;
        }
        field(70; "Last Tax Code Change"; Date)
        {
        }
        field(71; "Min. Scholarship Age"; Integer)
        {
        }
        field(72; "Max. Scholarship Age"; Integer)
        {
        }
        field(73; "Tax Code P Change"; Integer)
        {
        }
        field(74; "Tax Code V Change"; Integer)
        {
        }
        field(75; "Tax Code A Change"; Integer)
        {
        }
        field(76; "Tax Code J Change"; Integer)
        {
        }
        field(77; "Tax Code Y Change"; Integer)
        {
        }
        field(80; "Scholarship Period Filter"; Text[30])
        {
        }
        field(81; "Tax Office"; Text[40])
        {
            // Title = true;
        }
        field(82; "AutoPay Reference"; Text[4])
        {
        }
        field(83; "AutoPay Account"; Text[8])
        {
        }
        field(84; "Net Pay Rounding"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(86; "Small Employers Relief"; Boolean)
        {
        }
        field(87; "Tax District"; Text[30])
        {
        }
        field(90; "Permit Number"; Text[12])
        {
        }
        field(91; "Employer Code"; Text[6])
        {
        }
        field(92; "ECON Number"; Text[9])
        {
        }
        field(100; "Class 1A NIC (%)"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(101; "Car Price Limit"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(102; "Maximum Contribution"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(103; "Age Reduction (%)"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(104; "Reduction Age"; Integer)
        {
        }
        field(105; "Calculation Day"; Integer)
        {
            MaxValue = 31;
            MinValue = 1;
        }
        field(106; "Calculation Month"; Option)
        {
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(110; "Payroll Setup Performed"; Boolean)
        {
        }
        field(120; "Employee Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(121; "Integrate to Human Resources"; Boolean)
        {
        }
        field(122; "Sickness Absence Code"; Code[10])
        {
        }
        field(123; "Custody Absence Code"; Code[10])
        {
        }
        field(130; Sunday; Boolean)
        {
        }
        field(131; Monday; Boolean)
        {
        }
        field(132; Tuesday; Boolean)
        {
        }
        field(133; Wednesday; Boolean)
        {
        }
        field(134; Thursday; Boolean)
        {
        }
        field(135; Friday; Boolean)
        {
        }
        field(136; Saturday; Boolean)
        {
        }
        field(140; "Student Loan Annual Threshold"; Decimal)
        {
        }
        field(141; "Student Loan Recovery Rate (%)"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(142; "Student Loan Code"; Code[10])
        {
            TableRelation = "Pay Element"."Code";
        }
        field(143; "Tax Credit Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(144; "NI Rebate Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(50001; "Tax Exempt P/Y Single"; Decimal)
        {
        }
        field(50002; "Tax Exempt P/Y NonWork Spouse"; Decimal)
        {
        }
        field(50003; "Tax Exempt P/Y Per Child"; Decimal)
        {
        }
        field(50004; "Family Allowance Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(50005; "Mobile allowance"; Code[10])
        {
            CaptionClass = 'Phone Allowance';
            TableRelation = "Pay Element";
        }
        field(50006; "Non-Taxable Transp. Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(50007; "Payroll Logo"; BLOB)
        {
            SubType = Bitmap;
        }
        field(50008; "Retro. Family Allowance Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80014; "Mechandiser Com.Fixed Amt"; Decimal)
        {
            Description = 'PY2.0';
        }
        field(80015; "Commission Factor"; Decimal)
        {
            Description = 'PY2.0';
        }
        field(80200; "Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(80201; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Name = FIELD("Journal Batch Name"), "Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(80202; "Journal Batch Name (ACY)"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Name = FIELD("Journal Batch Name (ACY)"));
        }
        field(80203; "Rounding Precision (LCY)"; Decimal)
        {
        }
        field(80204; "Rounding Type (LCY)"; Option)
        {
            OptionMembers = Nearest,Up,Down;
        }
        field(80205; "Rounding Precision (ACY)"; Decimal)
        {
        }
        field(80206; "Rounding Type (ACY)"; Option)
        {
            OptionMembers = Nearest,Up,Down;
        }
        field(80207; "Contractual Tax Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80208; "Contractual Tax %"; Decimal)
        {
        }
        field(80209; "Summary Payroll to GL Transfer"; Boolean)
        {
        }
        field(80210; "Commission on Sales Code"; Code[10])
        {
            Description = 'PY2.0';
            TableRelation = "Pay Element";
        }
        field(80211; "Meals Code"; Code[10])
        {
            Description = 'PY2.0';
            TableRelation = "Pay Element";
        }
        field(80212; "Cashier Petty Cash Code"; Code[10])
        {
            Description = 'PY2.0';
            TableRelation = "Pay Element";
        }
        field(80213; "Porter Com. Fixed Amt"; Decimal)
        {
            Description = 'PY2.0';
        }
        field(80214; "Merhandiser Com. Fixed Amt"; Decimal)
        {
            Description = 'PY2.0';
        }
        field(80215; "Sales Commission Factor"; Decimal)
        {
            Description = 'PY2.0';
        }
        field(80216; OverTime; Code[10])
        {
            Description = 'MB.1805';
            TableRelation = "Pay Element";
        }
        field(80217; "Housing Allowance"; Code[10])
        {
            CaptionClass = 'House Allowance';
            Description = 'MB.1106';
            TableRelation = "Pay Element";
        }
        field(80218; Allowance; Code[10])
        {
            Description = 'MB.2802';
            TableRelation = "Pay Element";
        }
        field(80219; Bonus; Code[10])
        {
            Description = 'MB.2802';
            TableRelation = "Pay Element";
        }
        field(80220; Loan; Code[10])
        {
            Description = 'MB.2802';
            TableRelation = "Pay Element";
        }
        field(80221; Food; Code[10])
        {
            Description = 'EDM';
            TableRelation = "Pay Element";
        }
        field(80222; "Use Split Entries"; Boolean)
        {
        }
        field(80223; "Accounting Deduction"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80224; "Accounting Addition"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80225; "Business Trip"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80226; "Commision Addition"; Code[10])
        {
            CaptionClass = 'Insurance Benefit';
            TableRelation = "Pay Element";
        }
        field(80227; "Comission Deduction"; Code[10])
        {
            CaptionClass = 'Special Deduction';
            TableRelation = "Pay Element";
        }
        field(80228; "Car Allowance"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80308; "Journal Template Name Pay"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(80309; "Journal Batch Name Pay"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Name = FIELD("Journal Batch Name Pay"), "Journal Template Name" = FIELD("Journal Template Name Pay"));
        }
        field(80310; "Original Payroll Currency"; Code[10])
        {
            TableRelation = Currency.Code;
        }
        field(80311; "Max. Pension Not Student Age"; Integer)
        {
            Description = 'EDM';
        }
        field(80312; "Payroll NET Precision"; Decimal)
        {
        }
        field(80313; "Absence Deduction"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80314; "No Pension Retro"; Boolean)
        {
        }
        field(80315; "Discard Negative Income Tax"; Boolean)
        {
        }
        field(80316; "Employ-Termination Affect Tax"; Boolean)
        {
        }
        field(80317; "Auto Import Recurring Journals"; Boolean)
        {
        }
        field(80318; "Payroll Finalize Type"; Option)
        {
            OptionMembers = Default,"By Dimension";
        }
        field(80319; "Auto Copy Payroll Dimensions"; Boolean)
        {
        }
        field(80320; "Ticket Allowance"; Code[10])
        {
            CaptionClass = 'Renumeration';
            TableRelation = "Pay Element";
        }
        field(80321; GOSI; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80322; "Group By Dimension"; Code[10])
        {
            TableRelation = Dimension;
        }
        field(80323; "Temp Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = CONST('GENERAL'));
        }
        field(80324; "ACY Currency Rate"; Decimal)
        {
        }
        field(80325; "ACY Exchange Operation"; Option)
        {
            OptionMembers = Division,Multiplication;
        }
        field(80326; "Employee Insurance Tax Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80327; "Employer Insurance Tax Code"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80328; "Delete Temporary Posting Batch"; Boolean)
        {
        }
        field(80329; "AutoCheck Dimension Allocation"; Boolean)
        {
        }
        field(80330; "Dimension Allocation Needed"; Boolean)
        {
        }
        field(80331; "Show Pay Element with Amount 0"; Boolean)
        {
            Description = 'Added for Report "PaySlip"';
        }
        field(80332; "Disable Emp Dim Validation"; Boolean)
        {
            Description = 'Added for "Employee Dimension"';
        }
        field(80333; "Lock Payroll Date"; Boolean)
        {
            Description = 'Added for Pay Details';
        }
        field(80334; "Credit of PTF Journal"; Code[20])
        {
            TableRelation = "HR Transaction Types"."Code" WHERE("Associated Pay Element" = FILTER(<> ''), System = FILTER(false));
        }
        field(80335; "Overload for PTF Journal"; Code[20])
        {
            TableRelation = "HR Transaction Types"."Code" WHERE("Associated Pay Element" = FILTER(<> ''), System = FILTER(false));
        }
        field(80336; "Employ-Termination Affect NSSF"; Boolean)
        {
        }
        field(80337; "Budget Resouce No."; Code[20])
        {
            TableRelation = Resource."No.";
        }
        field(80338; "Retro Family Allow Addition"; Code[10])
        {
            TableRelation = "Pay Element"."Code";
        }
        field(80339; "Retro Family Allow Deduction"; Code[10])
        {
            TableRelation = "Pay Element"."Code";
        }
        field(80340; "Temp Pay Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = Filter('PAYMENT' | 'PAYMENTS'));
        }
        field(80341; "No Income Tax Retro"; Boolean)
        {
            Description = 'Added for Sub Payroll';
        }
        field(80342; "MHOOD Retro Start Date"; Date)
        {
            Description = 'Added in order to consider new law Decision (3% for employee and 8% for employer)';
        }
        field(80343; "Family Sub Retro Start Date"; Date)
        {
            Description = 'Added in order to consider new law Decision';
        }
        field(80344; "EOS Retro Start Date"; Date)
        {
            Description = 'Added in order to consider new law Decision';
        }
        field(80345; "Extra Salary"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80346; "Use Payroll ACY Rate"; Boolean)
        {
        }
        field(80347; "Water Compensation Allowance"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80348; "Production Allowance"; Code[10])
        {
            CaptionClass = 'Special Allowance';
            TableRelation = "Pay Element";
        }
        field(80349; "Payroll Labor Law"; Option)
        {
            OptionCaption = 'Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar';
            OptionMembers = Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar;

            trigger OnValidate();
            var
                UserSetup: Record "User Setup";
                CanChangePayrollLaborLaw: Boolean;
            begin
                CanChangePayrollLaborLaw := FALSE;
                IF UserSetup.GET(USERID) THEN
                    IF UserSetup."Can Change Payroll Labor Law" THEN
                        CanChangePayrollLaborLaw := TRUE;
                IF NOT CanChangePayrollLaborLaw THEN
                    ERROR('Access Denied');
                IF Rec."Payroll Labor Law" <> xRec."Payroll Labor Law" THEN
                    IF DataExistsInPayLedgEntry() THEN
                        ERROR('Cannot change Payroll Labor Law. \\Posted payroll data exists.');
                IF NOT CONFIRM('Changing the "Payroll Labor Law" will result in loss of some data.\Please backup your database before doing this.\\Proceed?', FALSE) THEN
                    ERROR('');

                CASE "Payroll Labor Law" OF
                    "Payroll Labor Law"::Lebanon:
                        BEGIN
                            "Exemption % from Taxable" := 0;
                            "Tax Exempt P/Y Single" := 7500000;
                            "Tax Exempt P/Y NonWork Spouse" := 2500000;
                            "Tax Exempt P/Y Per Child" := 500000;
                            "Contractual Tax %" := 3;
                            "Max. Pension Age" := 25;
                            "Max. Pension Eligible Child" := 5;
                            "No Income Tax Retro" := FALSE;
                            "No Pension Retro" := TRUE;
                        END;
                    "Payroll Labor Law"::Nigeria:
                        BEGIN
                            "Exemption % from Taxable" := 28;
                            "Tax Exempt P/Y Single" := 200000;
                            "Tax Exempt P/Y NonWork Spouse" := 0;
                            "Tax Exempt P/Y Per Child" := 0;
                            "Contractual Tax %" := 0;
                            "Max. Pension Age" := 99;
                            "Max. Pension Eligible Child" := 99;
                            "No Income Tax Retro" := TRUE;
                            "No Pension Retro" := TRUE;
                            ClearEmployeeDataPerLaborLaw;
                            ClearEmployeeRelativesDataPerLaborLaw;
                            ClearPensionSchemeDataPerLaborLaw;
                        END;
                    "Payroll Labor Law"::Egypt:
                        BEGIN
                            "Exemption % from Taxable" := 0;
                            "Tax Exempt P/Y Single" := 0;
                            "Tax Exempt P/Y NonWork Spouse" := 0;
                            "Tax Exempt P/Y Per Child" := 0;
                            "Contractual Tax %" := 0;
                            "Max. Pension Age" := 99;
                            "Max. Pension Eligible Child" := 99;
                            "No Income Tax Retro" := TRUE;
                            "No Pension Retro" := TRUE;
                            ClearEmployeeDataPerLaborLaw;
                            ClearEmployeeRelativesDataPerLaborLaw;
                            ClearPensionSchemeDataPerLaborLaw;
                        END;
                    "Payroll Labor Law"::UAE:
                        BEGIN
                            "Exemption % from Taxable" := 0;
                            "Tax Exempt P/Y Single" := 0;
                            "Tax Exempt P/Y NonWork Spouse" := 0;
                            "Tax Exempt P/Y Per Child" := 0;
                            "Contractual Tax %" := 0;
                            "Max. Pension Age" := 99;
                            "Max. Pension Eligible Child" := 99;
                            "No Income Tax Retro" := TRUE;
                            "No Pension Retro" := TRUE;
                            ClearEmployeeDataPerLaborLaw;
                            ClearEmployeeRelativesDataPerLaborLaw;
                            ClearPensionSchemeDataPerLaborLaw;
                        END;
                    "Payroll Labor Law"::Iraq:
                        BEGIN
                            "Exemption % from Taxable" := 0;
                            "Tax Exempt P/Y Single" := 12000000;
                            "Tax Exempt P/Y NonWork Spouse" := 0;
                            "Tax Exempt P/Y Per Child" := 0;
                            "Contractual Tax %" := 0;
                            "Max. Pension Age" := 99;
                            "Max. Pension Eligible Child" := 99;
                            "No Income Tax Retro" := TRUE;
                            "No Pension Retro" := TRUE;
                            "Discard Negative Income Tax" := TRUE;
                            ClearEmployeeDataPerLaborLaw;
                            ClearEmployeeRelativesDataPerLaborLaw;
                            ClearPensionSchemeDataPerLaborLaw;
                        END;
                    "Payroll Labor Law"::Qatar:
                        BEGIN
                            "Exemption % from Taxable" := 0;
                            "Tax Exempt P/Y Single" := 0;
                            "Tax Exempt P/Y NonWork Spouse" := 0;
                            "Tax Exempt P/Y Per Child" := 0;
                            "Contractual Tax %" := 0;
                            "Max. Pension Age" := 99;
                            "Max. Pension Eligible Child" := 99;
                            "No Income Tax Retro" := TRUE;
                            "No Pension Retro" := TRUE;
                            ClearEmployeeDataPerLaborLaw;
                            ClearEmployeeRelativesDataPerLaborLaw;
                            ClearPensionSchemeDataPerLaborLaw;
                        END;
                END;
                SetTaxBands;
                MESSAGE('Please close and reopen the Payroll Parameter Card to apply changes.');
            end;
        }
        field(80350; "Exemption % from Taxable"; Decimal)
        {
        }
        field(80351; "Enable Payment Acc. Grouping"; Boolean)
        {
        }
        field(80352; "OverTime Journal"; Code[20])
        {
            Description = 'Added For Mazzat';
            TableRelation = "HR Transaction Types".Code WHERE("Associated Pay Element" = FILTER(<> ''), System = FILTER(false));
        }
        field(80353; "Absence Journal"; Code[20])
        {
            Description = 'Added For Mazzat';
            TableRelation = "HR Transaction Types".Code WHERE("Associated Pay Element" = FILTER(<> ''), System = FILTER(false));
        }
        field(80354; "Transportation Journal"; Code[20])
        {
            Description = 'Added For Mazzat';
            TableRelation = "HR Transaction Types".Code WHERE("Associated Pay Element" = FILTER(<> ''), System = FILTER(false));
        }
        field(80355; "Late Arrive Deduction"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(80356; "Month 13 Journal"; Code[20])
        {
            TableRelation = "HR Transaction Types".Code WHERE("Associated Pay Element" = FILTER(<> ''), System = FILTER(false));
        }
        field(80357; "Graduity Journal"; Code[20])
        {
            TableRelation = "HR Transaction Types".Code WHERE("Associated Pay Element" = FILTER(<> ''), System = FILTER(false));
        }
        field(80358; "Tax Bands Decision Date"; Date)
        {
        }
        field(80359; "NSSF Precision"; Decimal)
        {
        }
        field(80360; "Month 13"; Code[10])
        {
            TableRelation = "Pay Element";
        }

        field(80361; "Income Tax Precision"; Decimal)
        {
        }
        field(80362; "Journal Batch Supplement"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Name = FIELD("Journal Batch Supplement"), "Journal Template Name" = FIELD("Journal Template Name"));
        }

        field(80363; "Journal Batch Supplement Pay"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Name = FIELD("Journal Batch Supplement Pay"), "Journal Template Name" = FIELD("Journal Template Name Pay"));
        }
        field(80364; "Temp Batch Supplement"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = CONST('GENERAL'));
        }
        field(80365; "Temp Pay Batch Supplement"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = Filter('PAYMENT' | 'PAYMENTS'));
        }
        field(80369; "Monthly ACY Currency Rate"; Decimal)
        {
        }
        field(80370; "Cost of Living"; Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(90000; "Before Monthly Cont Date"; Date)
        {

        }
        field(90001; "Before Monthly Cont Date 2"; Date)
        {

        }
        field(90002; "MHood Max Monthly Cont"; Decimal)
        {

        }
        field(90003; "MHood Before Max Monthly Cont"; Decimal)
        {

        }
        field(90004; "MHood Before Max Monthly Cont2"; Decimal)
        {

        }
        field(90005; "FSUB Max Monthly Cont"; Decimal)
        {

        }
        field(90006; "FSUB Before Max Monthly Cont"; Decimal)
        {

        }
        field(90007; "FSUB Before Max Monthly Cont2"; Decimal)
        {

        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    local procedure DataExistsInPayLedgEntry(): Boolean;
    var
        PayLedgEntry: Record "Payroll Ledger Entry";
    begin
        //PayLedgEntry.RESET;
        //PayLedgEntry.SETRANGE(Open,FALSE);
        //PayLedgEntry.SETFILTER("Posting Date",'<>%1',0D);
        IF PayLedgEntry.FINDFIRST THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    local procedure SetTaxBands();
    var
        TaxBand: Record "Tax Band";
        TaxBandNo: Integer;
    begin
        TaxBand.RESET;
        TaxBand.DELETEALL;
        TaxBandNo := 0;
        CASE "Payroll Labor Law" OF
            "Payroll Labor Law"::Lebanon:
                BEGIN
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 6000000;
                    TaxBand.VALIDATE(Rate, 2);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 9000000;
                    TaxBand.VALIDATE(Rate, 4);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 15000000;
                    TaxBand.VALIDATE(Rate, 7);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 30000000;
                    TaxBand.VALIDATE(Rate, 11);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 60000000;
                    TaxBand.VALIDATE(Rate, 15);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 99999999999.0;
                    TaxBand.VALIDATE(Rate, 20);
                    TaxBand.INSERT;
                END;
            "Payroll Labor Law"::Nigeria:
                BEGIN
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 300000;
                    TaxBand.VALIDATE(Rate, 7);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 600000;
                    TaxBand.VALIDATE(Rate, 11);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 1100000;
                    TaxBand.VALIDATE(Rate, 15);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 1600000;
                    TaxBand.VALIDATE(Rate, 19);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 3200000;
                    TaxBand.VALIDATE(Rate, 21);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 99999999999.0;
                    TaxBand.VALIDATE(Rate, 24);
                    TaxBand.INSERT;
                END;
            "Payroll Labor Law"::Egypt:
                BEGIN
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 7200;
                    TaxBand."Tax Discount %" := 0;
                    TaxBand.VALIDATE(Rate, 0);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 30000;
                    TaxBand."Tax Discount %" := 80;
                    TaxBand.VALIDATE(Rate, 10);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 45000;
                    TaxBand."Tax Discount %" := 40;
                    TaxBand.VALIDATE(Rate, 15);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 200000;
                    TaxBand."Tax Discount %" := 5;
                    TaxBand.VALIDATE(Rate, 20);
                    TaxBand.INSERT;
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 99999999999.0;
                    TaxBand."Tax Discount %" := 0;
                    TaxBand.VALIDATE(Rate, 22.5);
                    TaxBand.INSERT;
                END;
            "Payroll Labor Law"::Iraq:
                BEGIN
                    CLEAR(TaxBand);
                    TaxBand.INIT;
                    TaxBandNo += 10000;
                    TaxBand."Tax Band" := TaxBandNo;
                    TaxBand."Annual Bandwidth" := 999999999;
                    TaxBand."Tax Discount %" := 0;
                    TaxBand.VALIDATE(Rate, 5);
                    TaxBand.INSERT;
                END;
        END;
    end;

    local procedure ClearEmployeeDataPerLaborLaw();
    var
        Employee: Record Employee;
        EmpAddInfo: Record "Employee Additional Info";
    begin
        Employee.RESET;
        IF Employee.FINDFIRST THEN
            REPEAT
                Employee."NSSF Date" := Employee."Declaration Date";
                Employee."Social Security No." := '';
                Employee.IsForeigner := FALSE;
                Employee.Foreigner := Employee.Foreigner::" ";
                Employee."Don't Deserve Family Allowance" := TRUE;
                Employee."Spouse Secured" := FALSE;
                Employee."Husband Paralyzed" := FALSE;
                Employee."Exempt Tax" := 0;
                Employee."Previously NSSF Secured" := FALSE;
                Employee."Social Security Information" := '';
                Employee.MODIFY;

                IF EmpAddInfo.GET(Employee."No.") THEN BEGIN
                    EmpAddInfo."Family Allowance Retro Date" := 0D;
                    EmpAddInfo.MODIFY;
                END;
            UNTIL Employee.NEXT = 0;
    end;

    local procedure ClearEmployeeRelativesDataPerLaborLaw();
    var
        EmpRelative: Record "Employee Relative";
    begin
        EmpRelative.RESET;
        IF EmpRelative.FINDFIRST THEN
            REPEAT
                EmpRelative.Working := FALSE;
                EmpRelative.Student := EmpRelative.Student::No;
                EmpRelative."Eligible Child" := FALSE;
                EmpRelative."Eligible Exempt Tax" := FALSE;
                EmpRelative."Does not Has NSSF" := FALSE;
                EmpRelative."Permenant Disability" := EmpRelative."Permenant Disability"::No;
                EmpRelative."Registeration Start Date" := 0D;
                EmpRelative."Registeration End Date" := 0D;
                EmpRelative."ID No." := '';
                EmpRelative."Death Date" := 0D;
                EmpRelative."Relative Age" := 0;
                EmpRelative."School Level" := '';
                EmpRelative.MODIFY;
            UNTIL EmpRelative.NEXT = 0;
    end;

    local procedure ClearPensionSchemeDataPerLaborLaw();
    var
        PensionScheme: Record "Pension Scheme";
    begin
        PensionScheme.RESET;
        IF PensionScheme.FINDFIRST THEN
            REPEAT
                PensionScheme."Maximum Monthly Contribution" := 0;
                PensionScheme."Maximum Applicable Age" := 0;
                PensionScheme."Foreigners Ineligible" := FALSE;
                PensionScheme.MODIFY;
            UNTIL PensionScheme.NEXT = 0;
    end;
}