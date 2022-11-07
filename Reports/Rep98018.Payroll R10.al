report 98018 "Payroll R10"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll R10.rdl';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Text000; Text000)
            {
            }
            column(Text001; Text001)
            {
            }
            column(VarSalary; VarSalary)
            {
            }
            column(VarBenefit; VarBenefit)
            {
            }
            column(VarPaid; VarPaid)
            {
            }
            column(VarAllow; VarAllow)
            {
            }
            column(VarOthers; VarOthers)
            {
            }
            column(VarNetPay; VarNetPay)
            {
            }
            column(VarTotalSal; VarTotalSal)
            {
            }
            column(VarTrans; VarTransportation)
            {
            }
            column(VarIncomeTax; VarIncomeTax)
            {
            }
            column(VarAdmSalary; VarAdmSalary)
            {
            }
            column(VarAdmBenefit; VarAdmBenefit)
            {
            }
            column(VarAdmPaid; VarAdmPaid)
            {
            }
            column(VarAdmTransportation_Control1000000073; VarAdmTransportation)
            {
            }
            column(VarAdmAllow; VarAdmAllow)
            {
            }
            column(VarAdmOthers; VarAdmOthers)
            {
            }
            column(VarAdmNetPay; VarAdmNetPay)
            {
            }
            column(VarAdmIncomeTax; VarAdmIncomeTax)
            {
            }
            column(VarSalaries; VarTotalSal)
            {
            }
            column(VarIncomeTax_Control1000000081; VarIncomeTax)
            {
            }
            column(VarRoundedIncome; VarRoundedIncome)
            {
            }
            column(Company_Information__Company_Information___Arabic_Governorate_; "Company Information"."Arabic Governorate")
            {
            }
            column(Company_Information__Company_Information___Arabic_Elimination_; "Company Information"."Arabic Elimination")
            {
            }
            column(Company_Information__Company_Information___Arabic_City_; "Company Information"."Arabic City")
            {
            }
            column(Company_Information__Company_Information___Arabic_Street_; "Company Information"."Arabic Street")
            {
            }
            column(Company_Information__Company_Information___Arabic_Land_Area__No__; "Company Information"."Arabic Land Area  No.")
            {
            }
            column(Company_Information__Company_Information___Arabic_Floor_; "Company Information"."Arabic Floor")
            {
            }
            column(Company_Information__Company_Information___Fax_No__; "Company Information"."Fax No.")
            {
            }
            column(Company_Information__Company_Information___Arabic_District_; "Company Information"."Arabic District")
            {
            }
            column(Company_Information__Company_Information___Arabic_Land_Area__Control1000000092; "Company Information"."Arabic Land Area")
            {
            }
            column(Company_Information__Company_Information___Arabic_Building_; "Company Information"."Arabic Building")
            {
            }
            column(Company_Information__Company_Information___Phone_No__; "Company Information"."Phone No.")
            {
            }
            column(Company_Information__Company_Information___Phone_No__2_; "Company Information"."Phone No. 2")
            {
            }
            column(Company_Information__Company_Information___Mailbox_ID_; "Company Information"."Mailbox ID")
            {
            }
            column(Company_Information__Company_Information___Arabic_MailBox_Area_; "Company Information"."Arabic MailBox Area")
            {
            }
            column(Company_Information__Company_Information___E_Mail_; "Company Information"."E-Mail")
            {
            }
            column(Company_Information__Company_Information___Arabic_Governorate__Control1000000099; "Company Information"."Arabic Governorate")
            {
            }
            column(Company_Information__Company_Information___Arabic_Elimination__Control1000000100; "Company Information"."Arabic Elimination")
            {
            }
            column(Company_Information__Company_Information___Arabic_City__Control1000000101; "Company Information"."Arabic City")
            {
            }
            column(Company_Information__Company_Information___Arabic_Street__Control1000000102; "Company Information"."Arabic Street")
            {
            }
            column(Company_Information__Company_Information___Arabic_Land_Area__No___Control1000000103; "Company Information"."Arabic Land Area  No.")
            {
            }
            column(Company_Information__Company_Information___Arabic_Floor__Control1000000104; "Company Information"."Arabic Floor")
            {
            }
            column(Company_Information__Company_Information___Fax_No___Control1000000105; "Company Information"."Fax No.")
            {
            }
            column(Company_Information__Company_Information___Mailbox_ID__Control1000000106; "Company Information"."Mailbox ID")
            {
            }
            column(Company_Information__Company_Information___E_Mail__Control1000000107; "Company Information"."E-Mail")
            {
            }
            column(Company_Information__Company_Information___Arabic_MailBox_Area__Control1000000108; "Company Information"."Arabic MailBox Area")
            {
            }
            column(Company_Information__Company_Information___Phone_No__2__Control1000000109; "Company Information"."Phone No. 2")
            {
            }
            column(Company_Information__Company_Information___Phone_No___Control1000000110; "Company Information"."Phone No.")
            {
            }
            column(Company_Information__Company_Information___Arabic_Building__Control1000000111; "Company Information"."Arabic Building")
            {
            }
            column(Company_Information__Company_Information___Arabic_Land_Area__Control1000000112; "Company Information"."Arabic Land Area")
            {
            }
            column(Company_Information__Company_Information___Arabic_District__Control1000000113; "Company Information"."Arabic District")
            {
            }
            column(Company_Information__Company_Information___Registration_No__; "Company Information"."Arabic Registration No.")
            {
            }
            column(Company_Information__Company_Information___Arabic_Trading_Name_; "Company Information"."Arabic Trading Name")
            {
            }
            column(CompanyArabicName_; "Company Information"."Arabic Name")
            {
            }
            column(FromDay; FromDay)
            {
            }
            column(FromMonth; FromMonth)
            {
            }
            column(FromYear; FromYear)
            {
            }
            column(TDay; TDay)
            {
            }
            column(ToMonth; ToMonth)
            {
            }
            column(ToYear; ToYear)
            {
            }
            column(CompToYear; CompToYear)
            {
            }
            column(CompToMonth; CompToMonth)
            {
            }
            column(CompToDay; CompToDay)
            {
            }
            column(CompFromYear; CompFromYear)
            {
            }
            column(CompFromMonth; CompFromMonth)
            {
            }
            column(CompFromDay; CompFromDay)
            {
            }
            column(CompanyOwner; "Company Owner")
            {
            }
            column(OwnerPhoneNo; "Owner Phone No.")
            {
            }
            column(OwnerJob; "Job Description")
            {
            }
            column(OwnerFaxNo; "Fax No.")
            {
            }
            column(OwnerFinanceNo; "Owner Finance No.")
            {
            }
            column(VarFExemp; VarFaExemp)
            {
            }
            column(VarEmpNo; VarEmpNo)
            {
            }
            column(V70Caption; V70CaptionLbl)
            {
            }
            column(V80Caption; V80CaptionLbl)
            {
            }
            column(V90Caption; V90CaptionLbl)
            {
            }
            column(V150Caption; V150CaptionLbl)
            {
            }
            column(V160Caption; V160CaptionLbl)
            {
            }
            column(V180Caption; V180CaptionLbl)
            {
            }
            column(V170Caption; V170CaptionLbl)
            {
            }
            column(V190Caption; V190CaptionLbl)
            {
            }
            column(V140Caption; V140CaptionLbl)
            {
            }
            column(V130Caption; V130CaptionLbl)
            {
            }
            column(V120Caption; V120CaptionLbl)
            {
            }
            column(V110Caption; V110CaptionLbl)
            {
            }
            column(V100Caption; V100CaptionLbl)
            {
            }
            column(V250Caption; V250CaptionLbl)
            {
            }
            column(V240Caption; V240CaptionLbl)
            {
            }
            column(V300Caption; V300CaptionLbl)
            {
            }
            column(V290Caption; V290CaptionLbl)
            {
            }
            column(V280Caption; V280CaptionLbl)
            {
            }
            column(V270Caption; V270CaptionLbl)
            {
            }
            column(V260Caption; V260CaptionLbl)
            {
            }
            column(Caption; CaptionLbl)
            {
            }
            column(V5Caption; V5CaptionLbl)
            {
            }
            column(Company_Information_Primary_Key; "Primary Key")
            {
            }
            column(NoOfEmployee; NoOfEmployee)
            {
            }
            column(NoOfAdmin; NoOfAdmin)
            {
            }
            column(NoOfContractual; NoOfContractual)
            {
            }
            column(Date1; Date1)
            {
            }
            column(Date2; Date2)
            {
            }
            column(Date3; Date3)
            {
            }
            column(Date4; Date4)
            {
            }
            column(VarEmployee100; VarEmployee100)
            {
            }
            column(VarEmployee110; VarEmployee110)
            {
            }
            column(VarEmployee120; VarEmployee120)
            {
            }
            column(VarEmployee130; VarEmployee130)
            {
            }
            column(VarEmployee140; VarEmployee140)
            {
            }
            column(VarEmployee150; VarEmployee150)
            {
            }
            column(VarEmployee160; VarEmployee160)
            {
            }
            column(VarEmployee170; VarEmployee170)
            {
            }
            column(VarEmployee180; VarEmployee180)
            {
            }
            column(VarEmployee190; VarEmployee190)
            {
            }
            column(VarAdmin100; VarAdmin100)
            {
            }
            column(VarAdmin110; VarAdmin110)
            {
            }
            column(VarAdmin120; VarAdmin120)
            {
            }
            column(VarAdmin130; VarAdmin130)
            {
            }
            column(VarAdmin140; VarAdmin140)
            {
            }
            column(VarAdmin150; VarAdmin150)
            {
            }
            column(VarAdmin160; VarAdmin160)
            {
            }
            column(VarAdmin170; VarAdmin170)
            {
            }
            column(VarAdmin180; VarAdmin180)
            {
            }
            column(VarAdmin190; VarAdmin190)
            {
            }
            column(VarContr240; VarContr240)
            {
            }
            column(VarContr250; VarContr250)
            {
            }
            column(VarAmount251; VarAmount251)
            {
            }
            column(VarAmount260; VarAmount260)
            {
            }
            column(AmountQ1; AmountQ1)
            {
            }
            column(AmountQ2; AmountQ2)
            {
            }
            column(AmountQ3; AmountQ3)
            {
            }
            column(AmountQ4; AmountQ4)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompFromDay := 1;
                CompFromMonth := 1;
                CompFromYear := DATE2DMY(VarStDate, 3);
                CompToDay := 31;
                CompToMonth := 12;
                CompToYear := DATE2DMY(VarEndDate, 3);

                FromDay := DATE2DMY(VarStDate, 1);
                FromMonth := DATE2DMY(VarStDate, 2);
                FromYear := DATE2DMY(VarStDate, 3);
                TDay := DATE2DMY(VarEndDate, 1);
                ToMonth := DATE2DMY(VarEndDate, 2);
                ToYear := DATE2DMY(VarEndDate, 3);
                VarYear := DATE2DMY(VarStDate, 3);

                Date1 := DMY2DATE(31, 3, DATE2DMY(VarStDate, 3));
                Date2 := DMY2DATE(30, 6, DATE2DMY(VarStDate, 3));
                Date3 := DMY2DATE(30, 9, DATE2DMY(VarStDate, 3));
                Date4 := DMY2DATE(31, 12, DATE2DMY(VarStDate, 3));

                NoOfAdmin := 0;
                NoOfContractual := 0;
                NoOfEmployee := 0;

                //EmpTbt.SETRANGE(Declared,EmpTbt.Declared::Declared);
                EmpTbt.RESET;
                EmpTbt.SETFILTER(Declared, '%1|%2', EmpTbt.Declared::Declared, EmpTbt.Declared::"Non-NSSF");
                if EmpTbt.FINDFIRST then
                    repeat
                        if ((EmpTbt."Termination Date" <> 0D) and (EmpTbt."Termination Date" < VarStDate)) OR
                            ((EmpTbt."Inactive Date" <> 0D) and (EmpTbt."Inactive Date" < VarStDate)) then begin
                            NoOfAdmin := NoOfAdmin;
                            NoOfEmployee := NoOfEmployee;
                        end else begin
                            PayrollGroup.RESET;
                            CLEAR(PayrollGroup);
                            PayrollGroup.SETRANGE(Code, EmpTbt."Payroll Group Code");
                            if PayrollGroup.FINDFIRST then begin
                                if PayrollGroup."R5 Groups" = PayrollGroup."R5 Groups"::Administration then
                                    NoOfAdmin += 1
                                else begin
                                    IF (EmpTbt."Employment Date" <= VarEndDate) and (EmpTbt."Declaration Date" <= VarEndDate) then
                                        NoOfEmployee += 1;
                                end;
                            end;
                        end;
                    until EmpTbt.NEXT = 0;

                EmpTbt.RESET;
                CLEAR(EmpTbt);
                EmpTbt.SETRANGE(Declared, EmpTbt.Declared::Contractual);
                if EmpTbt.FINDFIRST then
                    repeat
                        if (EmpTbt."Termination Date" <> 0D) and (EmpTbt."Termination Date" < VarStDate) then
                            NoOfContractual := NoOfContractual
                        else
                            NoOfContractual += 1;
                    until EmpTbt.NEXT = 0;

                PayDetailLine.RESET;
                CLEAR(PayDetailLine);
                PayDetailLine.SETFILTER("Payroll Date", '%1..%2', VarStDate, VarEndDate);
                if PayDetailLine.FINDFIRST then
                    repeat
                        VarAmount := 0;
                        VarAdmAmount := 0;
                        if PayDetailLine.Type = PayDetailLine.Type::Addition then begin
                            PayDetailLine.CALCFIELDS("R5 Group");
                            if PayDetailLine."R5 Group" = PayDetailLine."R5 Group"::Employee then
                                VarAmount := VarAmount + PayDetailLine."Calculated Amount"
                            else
                                VarAdmAmount := VarAdmAmount + PayDetailLine."Calculated Amount";
                        end else begin
                            if PayDetailLine."R5 Group" = PayDetailLine."R5 Group"::Employee then
                                VarAmount := VarAmount - PayDetailLine."Calculated Amount"
                            else
                                VarAdmAmount := VarAdmAmount - PayDetailLine."Calculated Amount";
                        end;

                        PayElement.RESET;
                        CLEAR(PayElement);
                        PayElement.SETRANGE(Code, PayDetailLine."Pay Element Code");
                        if PayElement.FINDFIRST then begin
                            // Modified - 20180411:A2+
                            Emp.RESET;
                            CLEAR(Emp);
                            Emp.SETRANGE("No.", PayDetailLine."Employee No.");
                            if ((Emp.FINDFIRST) and ((Emp.Declared = Emp.Declared::Declared) OR (Emp.Declared = Emp.Declared::"Non-NSSF"))) then begin
                                // Modified - 20180411:A2-
                                if STRPOS(PayElement."R 10 No.", '100') <> 0 then begin
                                    VarEmployee100 += VarAmount;
                                    VarAdmin100 += VarAdmAmount;
                                end;

                                if STRPOS(PayElement."R 10 No.", '110') <> 0 then begin
                                    VarEmployee110 += VarAmount;
                                    VarAdmin110 += VarAdmAmount;
                                end;

                                if STRPOS(PayElement."R 10 No.", '130') <> 0 then begin
                                    VarEmployee130 += VarAmount;
                                    VarAdmin130 += VarAdmAmount;
                                end;

                                if STRPOS(PayElement."R 10 No.", '140') <> 0 then begin
                                    VarEmployee140 += VarAmount;
                                    VarAdmin140 += VarAdmAmount;
                                end;

                                if STRPOS(PayElement."R 10 No.", '150') <> 0 then begin
                                    VarEmployee150 += VarAmount;
                                    VarAdmin150 += VarAdmAmount;
                                end;
                                // Modified - 20180411:A2+
                            end;
                            // Modified - 20180411:A2-
                        end;
                    until PayDetailLine.NEXT = 0;
                //
                VarAdmin170 := 0;
                PayLedgerEntry.RESET;
                CLEAR(PayLedgerEntry);
                PayLedgerEntry.SETFILTER("Payroll Date", '%1..%2', VarStDate, VarEndDate);
                PayLedgerEntry.SETFILTER(Declared, '%1|%2', PayLedgerEntry.Declared::Declared, PayLedgerEntry.Declared::"Non-NSSF");
                PayLedgerEntry.SETRANGE("Payment Category", PayLedgerEntry."Payment Category"::" ");
                if PayLedgerEntry.FINDFIRST then
                    repeat
                        PayrollGroup.SETRANGE(Code, PayLedgerEntry."Payroll Group Code");
                        if PayrollGroup.FINDFIRST then begin
                            if PayrollGroup."R5 Groups" = PayrollGroup."R5 Groups"::Employee then
                                VarEmployee170 += PayLedgerEntry."Free Pay"
                            else
                                VarAdmin170 += PayLedgerEntry."Free Pay";
                        end;
                    until PayLedgerEntry.NEXT = 0;
                //
                PayLedgerEntry.RESET;
                CLEAR(PayLedgerEntry);
                PayLedgerEntry.SETFILTER("Payroll Date", '%1..%2', VarStDate, VarEndDate);
                PayLedgerEntry.SETFILTER(Declared, '%1|%2', PayLedgerEntry.Declared::Declared, PayLedgerEntry.Declared::"Non-NSSF");
                if PayLedgerEntry.FINDFIRST then
                    repeat
                        PayrollGroup.SETRANGE(Code, PayLedgerEntry."Payroll Group Code");
                        if PayrollGroup.FINDFIRST then begin
                            if PayrollGroup."R5 Groups" = PayrollGroup."R5 Groups"::Employee then
                                VarEmployee180 := VarEmployee180 + (PayLedgerEntry."Taxable Pay")
                            else
                                VarAdmin180 := VarAdmin180 + (PayLedgerEntry."Taxable Pay");
                        end;
                    until PayLedgerEntry.NEXT = 0;

                VarAdmin120 := VarAdmin100 + VarAdmin110;
                VarEmployee120 := VarEmployee100 + VarEmployee110;

                VarAdmin160 := VarAdmin120 - VarAdmin130 - VarAdmin140 - VarAdmin150;
                VarEmployee160 := VarEmployee120 - VarEmployee130 - VarEmployee140 - VarEmployee150;

                //Disabled due to wrong equation - 14.02.2018 : AIM+
                /*VarAdmin180 := VarAdmin160 - VarAdmin170;
                VarEmployee180 := VarEmployee160 - VarEmployee170;
                */
                //Disabled due to wrong equation - 14.02.2018 : AIM-

                VarContr240 := 0;
                PayDetailLine.RESET;
                CLEAR(PayDetailLine);
                PayDetailLine.SETFILTER("Payroll Date", '%1..%2', VarStDate, VarEndDate);
                PayDetailLine.SETRANGE(Taxable, true);
                if PayDetailLine.FINDFIRST then
                    repeat
                        EmpTbt.SETRANGE("No.", PayDetailLine."Employee No.");
                        if EmpTbt.FINDFIRST then begin
                            if EmpTbt.Declared = EmpTbt.Declared::Contractual then
                              //Disabled due to wrong equation - 14.02.2018 : AIM+
                              begin
                                //VarContr240 := VarContr240 + PayDetailLine."Calculated Amount";
                                if PayDetailLine.Type = PayDetailLine.Type::Deduction then
                                    VarContr240 := VarContr240 - PayDetailLine."Calculated Amount"
                                else
                                    VarContr240 := VarContr240 + PayDetailLine."Calculated Amount";
                            end;
                            //Disabled due to wrong equation - 14.02.2018 : AIM-
                        end;
                    until PayDetailLine.NEXT = 0;

                PayLedgerEntry.RESET;
                CLEAR(PayLedgerEntry);
                PayLedgerEntry.SETFILTER("Payroll Date", '%1..%2', VarStDate, VarEndDate);
                //Added to consider exclude contractual - 12.04.2018 : AIM +
                PayLedgerEntry.SETFILTER(Declared, '%1|%2', PayLedgerEntry.Declared::Declared, PayLedgerEntry.Declared::"Non-NSSF");
                //Added to consider exclude contractual - 12.04.2018 : AIM -
                if PayLedgerEntry.FINDFIRST then
                    repeat
                        PayrollGroup.SETRANGE(Code, PayLedgerEntry."Payroll Group Code");
                        if PayrollGroup.FINDFIRST then
                            if PayrollGroup."R5 Groups" = PayrollGroup."R5 Groups"::Employee then
                                VarEmployee190 += PayLedgerEntry."Tax Paid"
                            else
                                VarAdmin190 += PayLedgerEntry."Tax Paid";
                    until PayLedgerEntry.NEXT = 0;

                // Modified - 20180411:A2+
                /*PayLedgerEntry.RESET;
                CLEAR(PayLedgerEntry);
                PayLedgerEntry.SETFILTER("Payroll Date",'%1..%2',VarStDate,VarEndDate);
                IF PayLedgerEntry.FINDFIRST THEN
                  REPEAT
                    EmpTbt.SETRANGE("No.",PayLedgerEntry."Employee No.");
                    IF EmpTbt.FINDFIRST THEN
                      IF EmpTbt.Declared = EmpTbt.Declared::Contractual THEN
                        VarContr250 := VarContr250 + PayLedgerEntry."Tax Paid";
                  UNTIL PayLedgerEntry.NEXT = 0;*/
                PayLedgerEntry.RESET;
                CLEAR(PayLedgerEntry);
                PayLedgerEntry.SETFILTER("Payroll Date", '%1..%2', VarStDate, VarEndDate);
                PayLedgerEntry.SETRANGE(Declared, PayLedgerEntry.Declared::Contractual);
                if PayLedgerEntry.FINDFIRST then
                    repeat
                        VarContr250 += PayLedgerEntry."Tax Paid";
                    until PayLedgerEntry.NEXT = 0;
                // Modified - 20180411:A2-

                VarAmount251 := VarAmount251 + VarAdmin180 + VarEmployee180 + VarContr240;
                VarAmount260 := VarAmount260 + VarAdmin190 + VarEmployee190 + VarContr250;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                // Caption = 'control';
                group(Date)
                {
                    Caption = 'Date';
                    field("From Date"; VarStDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;
                    }
                    field("To Date"; VarEndDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;
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
    }

    trigger OnInitReport();
    begin
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if PayrollFunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    var
        Text000: Label 'ÜÔƒ ƒÒÓ×ÏÌ ÜºÔƒÕ Ü¼Õº á¡ºÏ × ¡Ñí ƒÒÓÌÒ×Óƒó ƒÒóÙ ÙÔß×Ù ÌÒÙÕƒ Õ¿ƒ ƒÒó¡ÙÑ';
        Text001: Label '"ÙóÓ óáÒÙÍ ƒÒ¼ª¡ ƒÒßáÙÌÙ Ü× ƒÒÓÌÔ×Ù ÎÙ ÓÑÒ ƒÒƒÏƒÓí ƒÒÓªóƒ ƒÒ¿Ù Ù¡Ñ ÌÔÕ ÒÒƒºƒí ƒÒÊÙáÙí Ò¿ƒ ÙñØ ƒÒƒÔóáƒÕ ƒÒØ ƒÑÐƒÓ ƒÒÓƒºóÙÔ 27 × 28 ÓÔ ÏƒÔ×Ô ƒÒƒñƒÿó ƒÒÊÙáÙí ÏÓ 44 óƒÙª 11-11-2008 "';
        FromDate: Date;
        ToDate: Date;
        PayWorkSheet: Record "Pay Detail Line";
        PayWorkSheetAdmin: Record "Pay Detail Line";
        PayElement: Record "Pay Element";
        PayLedgerEntry: Record "Payroll Ledger Entry";
        vYear: Integer;
        VarClcEX: Decimal;
        VarClcFEx: Decimal;
        VarYear: Integer;
        VarEmplNo: Integer;
        VarMonthly: Text[2];
        VarDaily: Text[2];
        VarHour: Text[2];
        VarSingle: Text[2];
        VarMarried: Text[2];
        VarWidowed: Text[2];
        VarDivorced: Text[2];
        VarStDate: Date;
        VarEndDate: Date;
        VarFExemp: Integer;
        VarSalary: Decimal;
        VarAdmSalary: Decimal;
        VarAdmRep: Decimal;
        VarRep: Decimal;
        VarBonus: Decimal;
        VarAdmBonus: Decimal;
        VarFAllow: Decimal;
        VarAdmFAAllow: Decimal;
        VarTransportation: Decimal;
        VarAdmTransportation: Decimal;
        VarAdmCar: Decimal;
        VarCar: Decimal;
        VarHouse: Decimal;
        VarAdmHouse: Decimal;
        VarFood: Decimal;
        VarAdmFood: Decimal;
        VarClothing: Decimal;
        VarAdmClothing: Decimal;
        VarAdmAllow: Decimal;
        VarAllow: Decimal;
        VarAdmInsur: Decimal;
        VarInsur: Decimal;
        VarAdmScholar: Decimal;
        VarScholar: Decimal;
        VarAdmMared: Decimal;
        VarMared: Decimal;
        VarAdmBirth: Decimal;
        VarBirth: Decimal;
        VarAdmMedAllow: Decimal;
        VarMedAllow: Decimal;
        VarAdmDeathAllow: Decimal;
        VarDeathAllow: Decimal;
        VarAdmOtherAllow: Decimal;
        VarOtherAllow: Decimal;
        VarAdmTotalIn: Decimal;
        VarTotalIn: Decimal;
        VarAdmTotalEx: Decimal;
        VarTotalEx: Decimal;
        VarAdmTotalAp: Decimal;
        VarTotalAp: Decimal;
        VarFaExemp: Decimal;
        VarOtherExemp: Decimal;
        VarIncome: Decimal;
        VarTax: Decimal;
        VarEmplLineNo: Integer;
        VarBlDate: Date;
        VarRegNo: Text[100];
        VarFor1: Integer;
        VarRegNoCo: Text[100];
        VarFPeriod: Date;
        VarAmount: Decimal;
        VarAdmAmount: Decimal;
        VarDayST: Integer;
        VarDayET: Integer;
        DN: Decimal;
        Precision: Decimal;
        Larger: Text[30];
        VarTotalExemp: Decimal;
        PayParam: Record "Payroll Parameter";
        SpecPayElement: Record "Specific Pay Element";
        WifeEntitle: Decimal;
        PayrollGroup: Record "HR Payroll Group";
        VarSumSalTrans: Decimal;
        VarOthers: Decimal;
        VarAdmOthers: Decimal;
        VarPure: Decimal;
        VarAdmPure: Decimal;
        VarFamilyAllow: Decimal;
        VarAdmFamilyAllow: Decimal;
        VarSalaries: Decimal;
        VarAdmSalaries: Decimal;
        VarIncomeTax: Decimal;
        VarAdmIncomeTax: Decimal;
        VarAdmSumSalTrans: Decimal;
        FromDay: Integer;
        FromMonth: Integer;
        FromYear: Integer;
        TDay: Integer;
        ToMonth: Integer;
        ToYear: Integer;
        HrSetup: Record "Human Resources Setup";
        CompFromDate: Date;
        CompToDate: Date;
        CompFromDay: Integer;
        CompFromMonth: Integer;
        CompFromYear: Integer;
        CompToDay: Integer;
        CompToMonth: Integer;
        CompToYear: Integer;
        VarAdmBenefit: Decimal;
        VarBenefit: Decimal;
        VarPaid: Decimal;
        VarAdmPaid: Decimal;
        VarNetPay: Decimal;
        VarAdmNetPay: Decimal;
        VarTotalSal: Decimal;
        VarAdmTotalSal: Decimal;
        VarRoundedIncome: Decimal;
        Emp: Record Employee;
        VarEmpNo: Integer;
        "ÌÔ×ƒÔ_ƒÒÓ_Ð__ƒÒ_Ù_ÙCaptionLbl": Label 'ÌÔ×ƒÔ ƒÒÓÐ¬ ƒÒÙ½Ù';
        "Ó_ƒÎË_CaptionLbl": Label 'ÓÑƒÎËí';
        "ÏÊƒ_CaptionLbl": Label 'ÏÊƒÿ';
        "ÓÔßÏ_____Ò__CaptionLbl": Label 'ÓÔßÏí - áÒºí';
        "ƒÒ_ƒ_ÌCaptionLbl": Label 'ƒÒ¼ƒÌ';
        "ÏÓ_ƒÒÌÏƒ____ƒÒÏ_ÓCaptionLbl": Label 'ÏÓ ƒÒÌÏƒ / ƒÒÏ½Ó';
        "ƒÒ_ÙCaptionLbl": Label 'ƒÒÑÙ';
        "ƒÒÓÔßÏ__ƒÒÌÏƒ_Ù_CaptionLbl": Label 'ƒÒÓÔßÏí ƒÒÌÏƒÙí';
        "ƒÒÓ_ÔØCaptionLbl": Label 'ƒÒÓáÔØ';
        "Õƒ_ÎCaptionLbl": Label 'ÕƒóÎ';
        "ƒÒßƒ_ÏCaptionLbl": Label 'ƒÒßƒáÏ';
        "Õƒ_ÎCaption_Control1000000198Lbl": Label 'ÕƒóÎ';
        "ÎƒÐ_CaptionLbl": Label 'ÎƒÐ½';
        "ƒÒÓÔßÏ_CaptionLbl": Label 'ƒÒÓÔßÏí';
        "ÏÓCaptionLbl": Label 'ÏÓ';
        "Ô_×Ï_ƒÒ__Ù_CaptionLbl": Label '¡Ôº×Ï ƒÒáÙº';
        "ƒÒ__Ù__ƒÒƒÒÐ__×ÔÙ_e_mail_CaptionLbl": Label 'ƒÒáÙº ƒÒƒÒÐó×ÔÙ(e-mail)';
        "Ó_Ò_ƒÒƒÏƒÓ__ƒÒÓ__ƒ__ÒÒ__ÒÙÍCaptionLbl": Label '* ÓÑÒ ƒÒƒÏƒÓí ƒÒÓªóƒ ÒÒóáÒÙÍ';
        "Ó_ƒÎË_Caption_Control1000000205Lbl": Label 'ÓÑƒÎËí';
        "ÏÊƒ_Caption_Control1000000206Lbl": Label 'ÏÊƒÿ';
        "ÓÔßÏ_____Ò__Caption_Control1000000207Lbl": Label 'ÓÔßÏí - áÒºí';
        "ƒÒ_ƒ_ÌCaption_Control1000000208Lbl": Label 'ƒÒ¼ƒÌ';
        "ÏÓ_ƒÒÌÏƒ____ƒÒÏ_ÓCaption_Control1000000209Lbl": Label 'ÏÓ ƒÒÌÏƒ / ƒÒÏ½Ó';
        "ƒÒßƒ_ÏCaption_Control1000000210Lbl": Label 'ƒÒßƒáÏ';
        "ƒÒÓÔßÏ__ƒÒÌÏƒ_Ù_Caption_Control1000000211Lbl": Label 'ƒÒÓÔßÏí ƒÒÌÏƒÙí';
        "ƒÒ_ÙCaption_Control1000000212Lbl": Label 'ƒÒÑÙ';
        "ƒÒÓ_ÔØCaption_Control1000000213Lbl": Label 'ƒÒÓáÔØ';
        "Õƒ_ÎCaption_Control1000000214Lbl": Label 'ÕƒóÎ';
        "Õƒ_ÎCaption_Control1000000215Lbl": Label 'ÕƒóÎ';
        "ÎƒÐ_Caption_Control1000000216Lbl": Label 'ÎƒÐ½';
        "ƒÒÓÔßÏ_Caption_Control1000000217Lbl": Label 'ƒÒÓÔßÏí';
        "ÏÓCaption_Control1000000218Lbl": Label 'ÏÓ';
        "Ô_×Ï_ƒÒ__Ù_Caption_Control1000000219Lbl": Label '¡Ôº×Ï ƒÒáÙº';
        "ƒÒ__Ù__ƒÒƒÒÐ__×ÔÙ_e_mail_Caption_Control1000000220Lbl": Label 'ƒÒáÙº ƒÒƒÒÐó×ÔÙ(e-mail)';
        "ÎƒÐ_Caption_Control1000000229Lbl": Label 'ÎƒÐ½';
        "Õƒ_ÎCaption_Control1000000234Lbl": Label 'ÕƒóÎ';
        "Ò_Ø_×_ƒ___ƒÒÓƒÒÙ__CaptionLbl": Label '(ÒºØ ×¬ƒí ƒÒÓƒÒÙí)';
        "ÏÓ_ƒÒ___ÙÒCaptionLbl": Label 'ÏÓ ƒÒó½ñÙÒ';
        "ƒÒƒ_Ó_ƒÒÐƒÓÒCaptionLbl": Label 'ƒÒƒ½Ó ƒÒÐƒÓÒ';
        "ƒÒƒ_Ó_ƒÒÐƒÓÒCaption_Control1000000225Lbl": Label 'ƒÒƒ½Ó ƒÒÐƒÓÒ';
        "ÏÓ_ƒÒ___ÙÒCaption_Control1000000227Lbl": Label 'ÏÓ ƒÒó½ñÙÒ';
        "Õƒ_ÎCaption_Control1000000231Lbl": Label 'ÕƒóÎ';
        "Ò_Ø_×_ƒ___ƒÒÓƒÒÙ__Caption_Control1000000226Lbl": Label '(ÒºØ ×¬ƒí ƒÒÓƒÒÙí)';
        "ÎƒÐ_Caption_Control1000000230Lbl": Label 'ÎƒÐ½';
        "ƒÒ____ƒÒ_Ù__ƒÕÓ____ÊÙ__ƒÒ___Ù_CaptionLbl": Label 'ƒÒ¼ª¡ ƒÒ¿Ù ½ƒÕÓ áóÑÊÙ ƒÒó¡ÙÑ';
        "ƒÒ____ƒÒÓÐÒÎ____ÒÍ_ƒÒ__Ù_CaptionLbl": Label 'ƒÒ¼ª¡ ƒÒÓÐÒÎ áóáÒÍ ƒÒáÙº';
        "ÒÒÎ____ƒÒÓ____ÌÔÕƒCaptionLbl": Label 'ÒÒÎóí ƒÒÓ¡Ñ ÌÔÕƒ';
        "Ì___ƒÒÓ____ÓÙÔ_×_ƒÒÜ__ƒ_CaptionLbl": Label 'Ìºº ƒÒÓ½óªºÓÙÔ × ƒÒÜñƒÿ';
        "Ü_×_ƒ±_ÓÏß×Ì_CaptionLbl": Label 'Üñ×ƒ± ÓÏß×Ìí';
        "Ì___ƒÒÌÓƒÒ_ƒÒ_ÙÔ_Ù_ÏƒÊ×ÔCaptionLbl": Label 'Ìºº ƒÒÌÓƒÒ ƒÒ¿ÙÔ ÙóÏƒÊ×Ô';
        "Ì____Ù__×_ÜÌÊƒ__Ó_Ò__ƒÒƒ_ƒ__CaptionLbl": Label 'Ìºº Ù½ × ÜÌÊƒÿ ÓñÒ½ ƒÒƒºƒí';
        V70CaptionLbl: Label '70';
        V80CaptionLbl: Label '80';
        V90CaptionLbl: Label '90';
        V150CaptionLbl: Label '150';
        V160CaptionLbl: Label '160';
        V180CaptionLbl: Label '180';
        V170CaptionLbl: Label '170';
        V190CaptionLbl: Label '190';
        "Ì×ÙÊƒ___Ó_ÙÒCaptionLbl": Label 'óÌ×ÙÊƒó óÓúÙÒ';
        "Ô_ÙÒƒ__Ü__ØCaptionLbl": Label 'óÔ¬ÙÒƒó ÜªØ';
        "ƒÒÓ_ƒÒÍ_ƒÒ_ƒÎÙ__CaptionLbl": Label '"ƒÒÓáƒÒÍ ƒÒ¡ƒÎÙí "';
        "ƒÒ_Ô_ÙÒ_ƒÒÌƒÒÙCaptionLbl": Label 'ƒÒóÔ¬ÙÒ ƒÒÌƒÒÙ';
        "ÒÒÊ_Ù__CaptionLbl": Label 'ÒÒÊÙáí';
        "ƒÒÊ_Ù___ƒÒÓ_×___CaptionLbl": Label 'ƒÒÊÙáí ƒÒÓó×ñáí';
        V140CaptionLbl: Label '140';
        "ƒÒ_×ƒ___×_ƒÒÜ_×__ƒÒ_ƒÊÌ_CaptionLbl": Label 'ƒÒ×ƒóá × ƒÒÜñ× ƒÒªƒÊÌí';
        "Ì×ÙÊƒ__ÔÏÒ_×_ƒÔ_ÏƒÒCaptionLbl": Label 'óÌ×ÙÊƒó ÔÏÒ × ƒÔóÏƒÒ';
        V130CaptionLbl: Label '130';
        "Ó_Ó×Ì_ƒÒÓ___ƒÒÍ_ƒÒÓ_Î×Ì_CaptionLbl": Label 'ÓñÓ×Ì ƒÒÓáòòƒÒÍ ƒÒÓºÎ×Ìí';
        V120CaptionLbl: Label '120';
        "ƒÒÓÔƒÎÌ_ƒÒÔÏ_Ù__×_ƒÒÌÙÔÙ_CaptionLbl": Label 'ƒÒÓÔƒÎÌ ƒÒÔÏºÙí × ƒÒÌÙÔÙí';
        V110CaptionLbl: Label '110';
        "ÙÔ_ÒCaptionLbl": Label 'ÙÔ¬Ò';
        "ƒÒ_×ƒ___×_ÓÒ_Ïƒ_______ÕƒCaptionLbl": Label 'ƒÒ×ƒóá × ÓÒÑÏƒóòòòòòòÕƒ';
        V100CaptionLbl: Label '100';
        "Ù__×_ÜÌÊƒ__Ó_Ò__ƒÒƒ_ƒ____1CaptionLbl": Label '(Ù½ × ÜÌÊƒÿ ÓñÒ½ ƒÒƒºƒí (1';
        "Ê_Ù___ƒÒ_ƒ__ƒÒ_ƒÔÙCaptionLbl": Label 'ÊÙáí ƒÒáƒá ƒÒúƒÔÙ';
        "ƒÒÓ____Ó×Ô_×_ƒÒÜ__ƒ__2CaptionLbl": Label '(ƒÒÓ½óªºÓ×Ô × ƒÒÜñƒÿ(2';
        V250CaptionLbl: Label '250';
        "ƒÒÊ_Ù___ÌÒØ_ƒÒÜ_×__ƒÒÓÏß×Ì_CaptionLbl": Label 'ƒÒÊÙáí ÌÒØ ƒÒÜñ× ƒÒÓÏß×Ìí';
        "ƒÒÓ_ƒÒÍ_ƒÒÓ_Î×Ì__ÐÜ_×__ÓÏß×Ì_CaptionLbl": Label 'ƒÒÓáƒÒÍ ƒÒÓºÎ×Ìí ÐÜñ× ÓÏß×Ìí';
        V240CaptionLbl: Label '240';
        "Ü_×__ÓÏß×Ì_CaptionLbl": Label 'Üñ× ÓÏß×Ìí';
        "ƒÒ__Ù__ƒÒÓ_×___ƒ____ƒ_ÕCaptionLbl": Label 'ƒÒÓáÒÍ ƒÒƒñÓƒÒÙ ƒÒ×ƒñá ºÎÌÕ';
        V300CaptionLbl: Label '300';
        V290CaptionLbl: Label '290';
        "Í_ƒÓƒ__ƒÒ___ÙÒCaptionLbl": Label 'ÍƒÓƒó ƒÒóÑ¡ÙÒ';
        V280CaptionLbl: Label '280';
        "Í_ƒÓƒ__ƒÒ__ÏÏCaptionLbl": Label 'ÍƒÓƒó ƒÒóÑÏÏ';
        V270CaptionLbl: Label '270';
        "ƒ_ÓƒÒÙ_ƒÒÊ_Ù___ƒÒÓ_×___CaptionLbl": Label 'ƒñÓƒÒÙ ƒÒÊÙáí ƒÒÓó×ñáí';
        V260CaptionLbl: Label '260';
        "ƒÒ_ƒÊÌ_ÒÒÊ_Ù__CaptionLbl": Label 'ƒÒªƒÊÌ ÒÒÊÙáí';
        "ƒ_ÓƒÒÙ_ƒÒ_×ƒ___×_ƒÒÜ_×_CaptionLbl": Label 'ƒñÓƒÒÙ ƒÒ×ƒóá × ƒÒÜñ×';
        "ƒÒ_×ÏÙÌCaptionLbl": Label 'ƒÒó×ÏÙÌ';
        "ƒÒ_Î_CaptionLbl": Label 'ƒÒ¡Îí';
        "ƒÎƒ__CaptionLbl": Label 'ƒÎƒºí';
        "ƒÒƒ_Ó_CaptionLbl": Label '"ƒÒƒ½Ó "';
        "ƒÒ_ƒ_Ù_Caption_Control1000000303Lbl": Label 'ƒÒóƒÙª';
        CaptionLbl: Label '"(*) "';
        "ƒÒ_Ô_CaptionLbl": Label '" ƒÒ½Ôí"';
        "ƒÒ_Õ_CaptionLbl": Label 'ƒÒ¼Õ';
        "ƒÒÙ×ÓCaptionLbl": Label 'ƒÒÙ×Ó';
        "Ó_Ù_Ù__ƒÒ×ƒ__ƒ_CaptionLbl": Label 'ÓºÙÙí ƒÒ×ƒºƒó';
        "Ê_Ù___ƒÒ_×ƒ___×_ƒÒÜ_×_CaptionLbl": Label 'ÊÙáí ƒÒ×ƒóá × ƒÒÜñ×';
        "Ó_Ù_Ù__ƒÒÓƒÒÙ__ƒÒÌƒÓ__CaptionLbl": Label '"ÓºÙÙí ƒÒÓƒÒÙí ƒÒÌƒÓí "';
        "×_ƒ___ƒÒÓƒÒÙ________CaptionLbl": Label '×¬ƒí ƒÒÓƒÒÙòòòòòòòí';
        "Ù___Ô×Ù_ÌÔ_Ê_Ù__CaptionLbl": Label 'ó¡ÙÑ ½Ô×Ù ÌÔ ÊÙáí';
        "ƒÒ_ÓÕ×_Ù__ƒÒÒ_ÔƒÔÙ__CaptionLbl": Label '"ƒÒñÓÕ×Ùí ƒÒÒáÔƒÔÙí "';
        "ƒÒ__Ò_ÌÒØ_ƒÒ_×ƒ___×_ƒÒÜ_×_CaptionLbl": Label 'ƒÒºªÒ ÌÒØ ƒÒ×ƒóá × ƒÒÜñ×';
        V5CaptionLbl: Label '5';
        "ƒÒ_Õ___ƒÒ__ƒ_Ù__CaptionLbl": Label '"ƒÒ¼Õí ƒÒóñƒÙí "';
        "Ò_Ø_×_ƒ___ƒÒÓƒÒÙ__Caption_Control1000000129Lbl": Label '(ÒºØ ×¬ƒí ƒÒÓƒÒÙí)';
        "ÏÓ_ƒÒ___ÙÒCaption_Control1000000132Lbl": Label 'ÏÓ ƒÒó½ñÙÒ';
        "ÌÔ_ƒÒÎ________CaptionLbl": Label 'ÌÔ ƒÒÎóòòòòòí';
        "ƒ_Ó_ƒÒ__Ð____ƒÒÓ____CaptionLbl": Label 'ƒ½Ó ƒÒ¼Ðí / ƒÒÓ¢½½í';
        "ƒÒ_Ô__ƒÒÓƒÒÙ_______CaptionLbl": Label 'ƒÒ½Ôí ƒÒÓƒÒÙòòòòòòí';
        "ÓÔCaptionLbl": Label 'ÓÔ';
        "ÓÔCaption_Control1000000140Lbl": Label 'ÓÔ';
        "ƒÒÙ×ÓCaption_Control1000000141Lbl": Label 'ƒÒÙ×Ó';
        "ƒÒÙ×ÓCaption_Control1000000142Lbl": Label 'ƒÒÙ×Ó';
        "ƒÒ_Õ_Caption_Control1000000145Lbl": Label 'ƒÒ¼Õ';
        "ƒÒ_Õ_Caption_Control1000000146Lbl": Label 'ƒÒ¼Õ';
        "ƒÒ_Ô_Caption_Control1000000149Lbl": Label '" ƒÒ½Ôí"';
        "ƒÒ_Ô_Caption_Control1000000150Lbl": Label '" ƒÒ½Ôí"';
        "ƒÒØCaptionLbl": Label 'ƒÒØ';
        "ƒÒØCaption_Control1000000156Lbl": Label 'ƒÒØ';
        "ƒÒÙ×ÓCaption_Control1000000157Lbl": Label 'ƒÒÙ×Ó';
        "ƒÒÙ×ÓCaption_Control1000000158Lbl": Label 'ƒÒÙ×Ó';
        "ƒÒ_Õ_Caption_Control1000000161Lbl": Label 'ƒÒ¼Õ';
        "ƒÒ_Õ_Caption_Control1000000162Lbl": Label 'ƒÒ¼Õ';
        "ƒÒ_Ô_Caption_Control1000000165Lbl": Label '" ƒÒ½Ôí"';
        "ƒÒ_Ô_Caption_Control1000000166Lbl": Label '" ƒÒ½Ôí"';
        "ƒÒ_Õ___ƒÒ__ƒ_Ù__Caption1Lbl": Label 'ÓÓúÒ ƒÒ¼Ðí : ƒÒƒ½Ó';
        "ƒÒ_Õ___ƒÒ__ƒ_Ù__Caption2Lbl": Label 'ƒÒ¡Îí';
        "ƒÒ_Õ___ƒÒ__ƒ_Ù__Caption3Lbl": Label 'ÕƒóÎ';
        VarTaxablePay: Decimal;
        PayrollFunction: Codeunit "Payroll Functions";
        NoOfEmployee: Integer;
        NoOfAdmin: Integer;
        EmpTbt: Record Employee;
        NoOfContractual: Integer;
        Date1: Date;
        Date2: Date;
        Date3: Date;
        Date4: Date;
        VarAdmin100: Decimal;
        VarAdmin110: Decimal;
        VarAdmin120: Decimal;
        VarAdmin130: Decimal;
        VarAdmin140: Decimal;
        VarAdmin150: Decimal;
        VarAdmin160: Decimal;
        VarAdmin170: Decimal;
        VarAdmin180: Decimal;
        VarAdmin190: Decimal;
        VarEmployee100: Decimal;
        VarEmployee110: Decimal;
        VarEmployee120: Decimal;
        VarEmployee130: Decimal;
        VarEmployee140: Decimal;
        VarEmployee150: Decimal;
        VarEmployee160: Decimal;
        VarEmployee170: Decimal;
        VarEmployee180: Decimal;
        VarEmployee190: Decimal;
        PayDetailLine: Record "Pay Detail Line";
        VarContr240: Decimal;
        VarContr250: Decimal;
        VarAmount251: Decimal;
        VarAmount260: Decimal;
        AmountQ1: Decimal;
        AmountQ2: Decimal;
        AmountQ3: Decimal;
        AmountQ4: Decimal;
}

