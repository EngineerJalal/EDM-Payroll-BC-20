report 98069 "Monthly NSSF"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Monthly NSSF.rdl';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(Year; Year)
            {
            }
            column(Month; Month)
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemTableView = WHERE(Declared = CONST(Declared));
                RequestFilterFields = "No.";
                column(NumberOfEmployees; NumberOfEmployees)
                {
                }
                column(TaxablePay; TaxablePay)
                {
                }
                column(EOSI85; "EOSI8.5%")
                {
                }
                column(SalaryMotherhoodMax; SalaryMotherhoodMax)
                {
                }
                column(NSSF2; "NSSF2%")
                {
                }
                column(NSSF7; "NSSF7%")
                {
                }
                column(FamilySubscriptionMax; FamilySubscriptionMax)
                {
                }
                column(FamilyCompensation; FamilyCompensation)
                {
                }
                column(FamilyAllowancePaid; FamilyAllowancePaid)
                {
                }
                column(Total; Total)
                {
                }
                column(ToBePaid; ToBePaid)
                {
                }
                column(RoundedEOSI85; "RoundedEOSI8.5%")
                {
                }
                column(RoundedSalaryMotherhoodMax; RoundedSalaryMotherhoodMax)
                {
                }
                column(RoundedNSSF2; "RoundedNSSF2%")
                {
                }
                column(RoundedNSSF7; "RoundedNSSF7%")
                {
                }
                column(RoundedFamilySubscriptionMax; RoundedFamilySubscriptionMax)
                {
                }
                column(RoundedFamilyCompensation; RoundedFamilyCompensation)
                {
                }
                column(RoundedFamilyAllowancePaid; RoundedFamilyAllowancePaid)
                {
                }
                column(RoundedTotal; RoundedTotal)
                {
                }
                column(RoundedToBePaid; RoundedToBePaid)
                {
                }
                column(TotalNumberOfEmployees; TotalNumberOfEmployees)
                {
                }
                column(TotalTaxablePay; TotalTaxablePay)
                {
                }
                column(TotalSalaryMotherhoodMax; TotalSalaryMotherhoodMax)
                {
                }
                column(TotalRoundedSalaryMotherhoodMax; TotalRoundedSalaryMotherhoodMax)
                {
                }
                column(TotalFamilySubscriptionMax; TotalFamilySubscriptionMax)
                {
                }
                column(TotalRoundedFamilySubscriptionMax; TotalRoundedFamilySubscriptionMax)
                {
                }
                column(TotalNSSF2; "TotalNSSF2%")
                {
                }
                column(TotalNSSF7; "TotalNSSF7%")
                {
                }
                column(TotalRoundedNSSF2; "TotalRoundedNSSF2%")
                {
                }
                column(TotalRoundedNSSF7; "TotalRoundedNSSF7%")
                {
                }
                column(TotalEOSI85; "TotalEOSI8.5%")
                {
                }
                column(TotalRoundedEOSI85; "TotalRoundedEOSI8.5%")
                {
                }
                column(TotalFamilyCompensation; TotalFamilyCompensation)
                {
                }
                column(TotalRoundedFamilyCompensation; TotalRoundedFamilyCompensation)
                {
                }
                column(TotalFamilyAllowancePaid; TotalFamilyAllowancePaid)
                {
                }
                column(TotalRoundedFamilyAllowancePaid; TotalRoundedFamilyAllowancePaid)
                {
                }
                column(Total2; Total2)
                {
                }
                column(RoundedTotal2; RoundedTotal2)
                {
                }
                column(TotalToBePaid; TotalToBePaid)
                {
                }
                column(TotalRoundedToBePaid; TotalRoundedToBePaid)
                {
                }
                column(NoOfEmpSubjectToEOS; NoOfEmpSubjectToEOS)
                {
                }
                column(NoOfEmpSubjectToFAMSUB; NoOfEmpSubjectToFAMSUB)
                {
                }
                column(NoOfEmpSubjectToMHOOD; NoOfEmpSubjectToMHOOD)
                {
                }
                column(SalaryEOS; SalaryEOS)
                {
                }
                column(TotalEOS; TotalEOS)
                {
                }
                column(MHoodCeilingCaption; MHoodCeilingCaption)
                {
                }
                column(FSUBCeilingCaption; FSUBCeilingCaption)
                {
                }
                trigger OnAfterGetRecord();
                begin
                    RoundedFamilyAllowancePaid := 0;
                    // 02.01.2019 : A2+
                    NoOfEmpSubjectToEOS := 0;
                    NoOfEmpSubjectToFAMSUB := 0;
                    NoOfEmpSubjectToMHOOD := 0;
                    PayDetailLine.RESET;
                    PayDetailLine.SETRANGE("Employee No.", Employee."No.");
                    PayDetailLine.SETRANGE("Payroll Date", DMY2DATE(1, Month, Year), CALCDATE('<CM>', DMY2DATE(1, Month, Year)));
                    if PayDetailLine.FINDFIRST then begin
                        PayElement.Get(PayDetailLine."Pay Element Code");
                        case PayElement."Category Type" of
                            PayElement."Category Type"::"EOS-8.5":
                                NoOfEmpSubjectToEOS += 1;
                            PayElement."Category Type"::"FamilySubscription-6":
                                NoOfEmpSubjectToFAMSUB += 1;
                            PayElement."Category Type"::"MedicalMotherhood-9":
                                NoOfEmpSubjectToMHOOD += 1;
                        end;
                    end;
                    // 02.01.2019 : A2-
                    //
                    PayParm.GET;
                    IF FromDate < PayParm."Before Monthly Cont Date" THEN BEGIN
                        MHoodCeilingCaption := PayParm."MHood Before Max Monthly Cont";
                        FSUBCeilingCaption := PayParm."FSUB Before Max Monthly Cont";
                    end
                    ELSE
                        IF (FromDate >= PayParm."Before Monthly Cont Date") AND (FromDate < PayParm."Before Monthly Cont Date 2") THEN BEGIN
                            MHoodCeilingCaption := PayParm."MHood Before Max Monthly Cont2";
                            FSUBCeilingCaption := PayParm."FSUB Before Max Monthly Cont2";
                        end
                        ELSE BEGIN
                            MHoodCeilingCaption := PayParm."MHood Max Monthly Cont";
                            FSUBCeilingCaption := PayParm."FSUB Max Monthly Cont";
                        END;
                    //
                    PayLedgerEntry.RESET;
                    PayLedgerEntry.SETRANGE("Payroll Date", DMY2DATE(1, Month, Year), CALCDATE('<CM>', DMY2DATE(1, Month, Year)));
                    PayLedgerEntry.SETRANGE("Employee No.", Employee."No.");
                    PayLedgerEntry.SETRANGE("Sub Payroll Code", '');
                    IF PayLedgerEntry.FINDFIRST THEN
                        REPEAT
                            NumberOfEmployees += 1;
                            TotalNumberOfEmployees += 1;
                        UNTIL PayLedgerEntry.NEXT = 0;

                    PayLedgerEntry.RESET;
                    PayLedgerEntry.SETRANGE("Payroll Date", DMY2DATE(1, Month, Year), CALCDATE('<CM>', DMY2DATE(1, Month, Year)));
                    PayLedgerEntry.SETRANGE("Employee No.", Employee."No.");
                    IF PayLedgerEntry.FINDFIRST THEN
                        REPEAT
                            TaxablePay += PayLedgerEntry."Total Salary for NSSF";
                            TotalTaxablePay += PayLedgerEntry."Total Salary for NSSF";
                            PayParm.GET;
                            IF PayLedgerEntry."Payroll Date" < PayParm."Before Monthly Cont Date" THEN BEGIN
                                MHoodCeiling := PayParm."MHood Before Max Monthly Cont";
                                FSUBCeiling := PayParm."FSUB Before Max Monthly Cont";
                            end
                            ELSE
                                IF (PayLedgerEntry."Payroll Date" >= PayParm."Before Monthly Cont Date") AND (PayLedgerEntry."Payroll Date" < PayParm."Before Monthly Cont Date 2") THEN BEGIN
                                    MHoodCeiling := PayParm."MHood Before Max Monthly Cont2";
                                    FSUBCeiling := PayParm."FSUB Before Max Monthly Cont2";
                                end
                                ELSE BEGIN
                                    MHoodCeiling := PayParm."MHood Max Monthly Cont";
                                    FSUBCeiling := PayParm."FSUB Max Monthly Cont";
                                END;
                            IF (Employee."Termination Date" = 0D) OR (Employee."Termination Date" > CALCDATE('<CM>', DMY2DATE(1, Month, Year))) THEN BEGIN
                                IF PayLedgerEntry."Total Salary for NSSF" > MHoodCeiling THEN BEGIN
                                    SalaryMotherhoodMax := SalaryMotherhoodMax + MHoodCeiling;
                                    TotalSalaryMotherhoodMax += MHoodCeiling;
                                END ELSE BEGIN
                                    SalaryMotherhoodMax := SalaryMotherhoodMax + PayLedgerEntry."Total Salary for NSSF";
                                    TotalSalaryMotherhoodMax += PayLedgerEntry."Total Salary for NSSF";
                                END;
                            END ELSE BEGIN
                                IF (DMY2DATE(1, Month, Year) <= Employee."Termination Date") AND (Employee."Termination Date" <= CALCDATE('<CM>', DMY2DATE(1, Month, Year))) THEN BEGIN
                                    IF PayParm."Employ-Termination Affect NSSF" THEN BEGIN
                                        IF PayLedgerEntry."Total Salary for NSSF" > ((Employee."Termination Date" - DMY2DATE(1, Month, Year) + 1) / PayFunction.GetDaysInMonth(Month, Year)) * MHoodCeiling THEN BEGIN
                                            SalaryMotherhoodMax := SalaryMotherhoodMax + ((Employee."Termination Date" - DMY2DATE(1, Month, Year) + 1) / PayFunction.GetDaysInMonth(Month, Year)) * MHoodCeiling;
                                            TotalSalaryMotherhoodMax += ((Employee."Termination Date" - DMY2DATE(1, Month, Year) + 1) / PayFunction.GetDaysInMonth(Month, Year)) * MHoodCeiling;
                                        END ELSE BEGIN
                                            SalaryMotherhoodMax := SalaryMotherhoodMax + PayLedgerEntry."Total Salary for NSSF";
                                            TotalSalaryMotherhoodMax += PayLedgerEntry."Total Salary for NSSF";
                                        END
                                    END ELSE BEGIN
                                        IF PayLedgerEntry."Total Salary for NSSF" > MHoodCeiling THEN BEGIN
                                            SalaryMotherhoodMax := SalaryMotherhoodMax + MHoodCeiling;
                                            TotalSalaryMotherhoodMax += MHoodCeiling;
                                        END ELSE BEGIN
                                            SalaryMotherhoodMax := SalaryMotherhoodMax + PayLedgerEntry."Total Salary for NSSF";
                                            TotalSalaryMotherhoodMax += PayLedgerEntry."Total Salary for NSSF";
                                        END;
                                    END;
                                END
                            END;
                            RoundedSalaryMotherhoodMax := ROUND(SalaryMotherhoodMax, 1000, '>');

                            IF (Employee."Termination Date" = 0D) OR (Employee."Termination Date" > CALCDATE('<CM>', DMY2DATE(1, Month, Year))) THEN BEGIN
                                IF PayLedgerEntry."Total Salary for NSSF" > FSUBCeiling THEN BEGIN
                                    FamilySubscriptionMax := FamilySubscriptionMax + FSUBCeiling;
                                    TotalFamilySubscriptionMax += FSUBCeiling;
                                END ELSE BEGIN
                                    FamilySubscriptionMax := FamilySubscriptionMax + PayLedgerEntry."Total Salary for NSSF";
                                    TotalFamilySubscriptionMax += PayLedgerEntry."Total Salary for NSSF";
                                END;
                            END ELSE BEGIN
                                IF (DMY2DATE(1, Month, Year) <= Employee."Termination Date") AND (Employee."Termination Date" <= CALCDATE('<CM>', DMY2DATE(1, Month, Year))) THEN BEGIN
                                    IF PayParm."Employ-Termination Affect NSSF" THEN BEGIN
                                        IF PayLedgerEntry."Total Salary for NSSF" > ((Employee."Termination Date" - DMY2DATE(1, Month, Year) + 1) / PayFunction.GetDaysInMonth(Month, Year)) * FSUBCeiling THEN BEGIN
                                            FamilySubscriptionMax := FamilySubscriptionMax + ((Employee."Termination Date" - DMY2DATE(1, Month, Year) + 1) / PayFunction.GetDaysInMonth(Month, Year)) * FSUBCeiling;
                                            TotalFamilySubscriptionMax += ((Employee."Termination Date" - DMY2DATE(1, Month, Year) + 1) / PayFunction.GetDaysInMonth(Month, Year)) * FSUBCeiling;
                                        END ELSE BEGIN
                                            FamilySubscriptionMax := FamilySubscriptionMax + PayLedgerEntry."Total Salary for NSSF";
                                            TotalFamilySubscriptionMax += PayLedgerEntry."Total Salary for NSSF";
                                        END
                                    END ELSE BEGIN
                                        IF PayLedgerEntry."Total Salary for NSSF" > FSUBCeiling THEN BEGIN
                                            FamilySubscriptionMax := FamilySubscriptionMax + FSUBCeiling;
                                            TotalFamilySubscriptionMax += FSUBCeiling;
                                        END ELSE BEGIN
                                            FamilySubscriptionMax := FamilySubscriptionMax + PayLedgerEntry."Total Salary for NSSF";
                                            TotalFamilySubscriptionMax += PayLedgerEntry."Total Salary for NSSF";
                                        END;
                                    END;
                                END
                            END;

                            RoundedFamilySubscriptionMax := ROUND(FamilySubscriptionMax, 1000, '>');
                            PayDetailLine.RESET;
                            PayDetailLine.SETRANGE("Employee No.", PayLedgerEntry."Employee No.");
                            PayDetailLine.SETRANGE("Payroll Date", DMY2DATE(1, Month, Year), CALCDATE('<CM>', DMY2DATE(1, Month, Year)));
                            IF PayDetailLine.FINDFIRST THEN
                                REPEAT
                                    PayElement.Get(PayDetailLine."Pay Element Code");
                                    //Emp 2% and 7%
                                    IF PayElement."Category Type" = PayElement."Category Type"::"MedicalMotherhood-9" THEN BEGIN
                                        "NSSF2%" += PayDetailLine."Calculated Amount";
                                        "TotalNSSF2%" += PayDetailLine."Calculated Amount";//20.03.2018 : A2+-
                                        "NSSF7%" += PayDetailLine."Employer Amount";
                                        "TotalNSSF7%" += PayDetailLine."Employer Amount";//20.03.2018 : A2+-
                                        "RoundedNSSF2%" := ROUND("NSSF2%", 1000, '>');
                                        "RoundedNSSF7%" := ROUND("NSSF7%", 1000, '>');
                                    END;

                                    //EOS 8.5%
                                    IF PayElement."Category Type" = PayElement."Category Type"::"EOS-8.5" THEN BEGIN
                                        "EOSI8.5%" += PayDetailLine."Employer Amount";
                                        "TotalEOSI8.5%" += PayDetailLine."Employer Amount";//20.03.2018 : A2+-
                                        "RoundedEOSI8.5%" := ROUND("EOSI8.5%", 1000, '>');
                                        IF PayDetailLine."Employer Amount" <> 0 THEN BEGIN
                                            SalaryEOS += PayLedgerEntry."Total Salary for NSSF";
                                            TotalEOS += PayLedgerEntry."Total Salary for NSSF";
                                        END;
                                    END;

                                    //Family Subscription
                                    IF PayElement."Category Type" = PayElement."Category Type"::"FamilySubscription-6" THEN BEGIN
                                        FamilyCompensation += PayDetailLine."Employer Amount";
                                        TotalFamilyCompensation += PayDetailLine."Employer Amount";//20.03.2018 : A2+-
                                        RoundedFamilyCompensation := ROUND(FamilyCompensation, 1000, '>');
                                    END;

                                    //FamilyAllowance
                                    IF PayDetailLine."Pay Element Code" = PayParm."Family Allowance Code" THEN BEGIN
                                        FamilyAllowancePaid += PayDetailLine."Calculated Amount";
                                        TotalFamilyAllowancePaid += PayDetailLine."Calculated Amount";//20.03.2018 : A2+-
                                        RoundedFamilyAllowancePaid := ROUND(FamilyAllowancePaid, 1000, '>');
                                    END;
                                UNTIL PayDetailLine.NEXT = 0;

                            Total2 := "TotalNSSF2%" + "TotalNSSF7%" + "TotalEOSI8.5%" + TotalFamilyCompensation;//20.03.2018 : A2+-
                            TotalToBePaid := (Total2 - TotalFamilyAllowancePaid);//20.03.2018 : A2+-
                        UNTIL PayLedgerEntry.NEXT = 0;

                    Total := "NSSF2%" + "NSSF7%" + "EOSI8.5%" + FamilyCompensation;
                    RoundedTotal := ROUND(Total, 1000, '>');
                    ToBePaid := Total - FamilyAllowancePaid;
                    RoundedToBePaid := ROUND(ToBePaid, 1000, '>');
                end;

                trigger OnPostDataItem();
                begin
                    TotalRoundedSalaryMotherhoodMax += RoundedSalaryMotherhoodMax;
                    "TotalRoundedNSSF2%" += "RoundedNSSF2%";
                    "TotalRoundedNSSF7%" += "RoundedNSSF7%";
                    TotalRoundedFamilySubscriptionMax += RoundedFamilySubscriptionMax;
                    "TotalRoundedEOSI8.5%" += "RoundedEOSI8.5%";
                    TotalRoundedFamilyCompensation += RoundedFamilyCompensation;
                    TotalRoundedToBePaid += RoundedToBePaid;
                    TotalRoundedFamilyAllowancePaid += RoundedFamilyAllowancePaid;
                    RoundedTotal2 += RoundedTotal;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if Month = 12 then begin
                    Month := 1;
                    Year += 1;
                end else
                    Month += 1;
                InitVariables;
            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                Month := DATE2DMY(FromDate, 2) - 1;
                Year := DATE2DMY(FromDate, 3);
                Integer.SETRANGE(Number, DATE2DMY(FromDate, 2), CalculateNumberOfMonths + DATE2DMY(FromDate, 2) - 1);
                PayParm.GET;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            ToDate := CALCDATE('+1M-1D', FromDate);
                        end;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if ToDate < FromDate then
                                ERROR('To Date Must be Greater than From Date');
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportHeader = 'Monthly NSSF TAXES';
    }

    trigger OnPreReport();
    begin

        if (FromDate = 0D) or (ToDate = 0D) then
            ERROR('You must select from date and to date');
    end;

    var
        NumberOfEmployees: Integer;
        "EOSI8.5%": Decimal;
        SalaryMotherhoodMax: Decimal;
        "NSSF2%": Decimal;
        "NSSF7%": Decimal;
        FamilySubscriptionMax: Decimal;
        FamilyCompensation: Decimal;
        FamilyAllowancePaid: Decimal;
        PayParm: Record "Payroll Parameter";
        PayDetailLine: Record "Pay Detail Line";
        PayLedgerEntry: Record "Payroll Ledger Entry";
        FromDate: Date;
        ToDate: Date;
        Year: Integer;
        Month: Integer;
        CompanyInfo: Record "Company Information";
        TaxablePay: Decimal;
        "RoundedEOSI8.5%": Decimal;
        RoundedSalaryMotherhoodMax: Decimal;
        "RoundedNSSF2%": Decimal;
        "RoundedNSSF7%": Decimal;
        RoundedFamilySubscriptionMax: Decimal;
        RoundedFamilyCompensation: Decimal;
        Total: Decimal;
        RoundedTotal: Decimal;
        ToBePaid: Decimal;
        RoundedToBePaid: Decimal;
        RoundedFamilyAllowancePaid: Decimal;
        TotalNumberOfEmployees: Integer;
        TotalTaxablePay: Decimal;
        TotalSalaryMotherhoodMax: Decimal;
        TotalRoundedSalaryMotherhoodMax: Decimal;
        TotalFamilySubscriptionMax: Decimal;
        TotalRoundedFamilySubscriptionMax: Decimal;
        "TotalNSSF2%": Decimal;
        "TotalNSSF7%": Decimal;
        "TotalRoundedNSSF2%": Decimal;
        "TotalRoundedNSSF7%": Decimal;
        "TotalEOSI8.5%": Decimal;
        "TotalRoundedEOSI8.5%": Decimal;
        TotalFamilyCompensation: Decimal;
        TotalRoundedFamilyCompensation: Decimal;
        TotalFamilyAllowancePaid: Decimal;
        TotalRoundedFamilyAllowancePaid: Decimal;
        Total2: Decimal;
        RoundedTotal2: Decimal;
        TotalToBePaid: Decimal;
        TotalRoundedToBePaid: Decimal;
        PayElement: Record "Pay Element";
        NoOfEmpSubjectToEOS: Integer;
        NoOfEmpSubjectToFAMSUB: Integer;
        NoOfEmpSubjectToMHOOD: Integer;
        PayFunction: Codeunit "Payroll Functions";
        SalaryEOS: Decimal;
        TotalEOS: Decimal;
        MHoodCeilingCaption: Decimal;
        FSUBCeilingCaption: Decimal;
        MHoodCeiling: Decimal;
        FSUBCeiling: Decimal;

    local procedure InitVariables();
    begin
        NumberOfEmployees := 0;
        TaxablePay := 0;
        "NSSF2%" := 0;
        "NSSF7%" := 0;
        "EOSI8.5%" := 0;
        FamilyCompensation := 0;
        FamilyAllowancePaid := 0;
        FamilySubscriptionMax := 0;
        SalaryMotherhoodMax := 0;
        RoundedSalaryMotherhoodMax := 0;
        RoundedFamilySubscriptionMax := 0;
        "RoundedNSSF2%" := 0;
        "RoundedNSSF7%" := 0;
        "RoundedEOSI8.5%" := 0;
        RoundedFamilyCompensation := 0;
        Total := 0;
        RoundedTotal := 0;
        ToBePaid := 0;
        RoundedToBePaid := 0;
        SalaryEOS := 0;
        MHoodCeilingCaption := 0;
        FSUBCeilingCaption := 0;
        MHoodCeiling := 0;
        FSUBCeiling := 0;
    end;

    local procedure CalculateNumberOfMonths() CountMonths: Integer;
    begin
        CountMonths := DATE2DMY(ToDate, 2) - DATE2DMY(FromDate, 2) + 1;
        CountMonths += (DATE2DMY(ToDate, 3) - DATE2DMY(FromDate, 3)) * 12;
        exit(CountMonths);
    end;
}

