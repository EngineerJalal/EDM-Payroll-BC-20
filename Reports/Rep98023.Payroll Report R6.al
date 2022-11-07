report 98023 "Payroll Report R6"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll Report R6.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.") WHERE(Declared = FILTER('Declared'));
            RequestFilterFields = "No.";
            column(CompanyInfo__Arabic_Name_; CompanyInfo."Arabic Name")
            {
            }
            column(CompanyInfo__Arabic_Trading_Name_; CompanyInfo."Arabic Trading Name")
            {
            }
            column(VarYear; VarYear)
            {
            }
            column(VarEmplNo; VarEmplNo)
            {
            }
            column(Employee__Arabic_First_Name_; Employee."Arabic First Name")
            {
            }
            column(Employee__Arabic_Middle_Name_; "Arabic Middle Name")
            {
            }
            column(Employee__Arabic_Last_Name_; "Arabic Last Name")
            {
            }
            column(Employee__Arabic_Job_Title_; "Arabic Job Title")
            {
            }
            column(VarMonthly; VarMonthly)
            {
            }
            column(VarDaily; VarDaily)
            {
            }
            column(VarHour; VarHour)
            {
            }
            column(VarSingle; VarSingle)
            {
            }
            column(VarMarried; VarMarried)
            {
            }
            column(VarWidowed; VarWidowed)
            {
            }
            column(VarDivorced; VarDivorced)
            {
            }
            column(VarStDate; VarStDay)
            {
            }
            column(VarFExemp; EligibleNumber)
            {
            }
            column(Employee__Arabic_Governorate_; "Arabic Governorate")
            {
            }
            column(Employee__Arabic_Elimination_; Employee."Arabic Elimination")
            {
            }
            column(Employee__Arabic_Building_; "Arabic Building")
            {
            }
            column(Employee_Floor; Floor)
            {
            }
            column(Employee__Mailbox_ID_; "Mailbox ID")
            {
            }
            column(Employee__Phone_No__; "Phone No.")
            {
            }
            column(Employee__Mobile_Phone_No__; "Mobile Phone No.")
            {
            }
            column(Employee__E_Mail_; "E-Mail")
            {
            }
            column(VarSalary; VarSalary)
            {
            }
            column(VarSalary_Control1000000006; VarSalary)
            {
            }
            column(VarBonus; VarBonus)
            {
            }
            column(VarWAllow; VarWAllow)
            {
            }
            column(VarCar; VarCar)
            {
            }
            column(VarFood; VarFood)
            {
            }
            column(VarAllow; VarAllow)
            {
            }
            column(VarScholar; VarScholar)
            {
            }
            column(VarBirth; VarBirth)
            {
            }
            column(VarDeathAllow; VarDeathAllow)
            {
            }
            column(VarTotalIn; VarTotalIn)
            {
            }
            column(VarTotalExemp; VarTotalExemp)
            {
            }
            column(VarIncome; VarIncome)
            {
            }
            column(VarTax; VarTax)
            {
            }
            column(VarRep; VarRep)
            {
            }
            column(VarFAllow; VarFAllow)
            {
            }
            column(VarTransportation; VarTransportation)
            {
            }
            column(VarHouse; VarHouse)
            {
            }
            column(VarClothing; VarClothing)
            {
            }
            column(VarInsur; VarInsur)
            {
            }
            column(VarMared; VarMared)
            {
            }
            column(VarMedAllow; VarMedAllow)
            {
            }
            column(VarOtherAllow; VarOtherAllow)
            {
            }
            column(VarBonus_Control1000000060; VarBonus)
            {
            }
            column(VarWAllow_Control1000000061; VarWAllow)
            {
            }
            column(VarCar_Control1000000062; VarCar)
            {
            }
            column(VarFood_Control1000000063; VarFood)
            {
            }
            column(VarAllow_Control1000000064; VarAllow)
            {
            }
            column(VarScholar_Control1000000065; VarScholar)
            {
            }
            column(VarBirth_Control1000000066; VarBirth)
            {
            }
            column(VarDeathAllow_Control1000000067; VarDeathAllow)
            {
            }
            column(VarTotalAp; VarTotalAp)
            {
            }
            column(VarRep_Control1000000069; VarRep)
            {
            }
            column(VarFAllow_Control1000000070; VarFAllow)
            {
            }
            column(VarTransportation_Control1000000071; VarTransportation)
            {
            }
            column(VarHouse_Control1000000072; VarHouse)
            {
            }
            column(VarClothing_Control1000000073; VarClothing)
            {
            }
            column(VarInsur_Control1000000074; VarInsur)
            {
            }
            column(VarMared_Control1000000075; VarMared)
            {
            }
            column(VarMedAllow_Control1000000076; VarMedAllow)
            {
            }
            column(VarOtherAllow_Control1000000077; VarOtherAllow)
            {
            }
            column(VarTotalEx; VarTotalEx)
            {
            }
            column(VarEmplLineNo; VarEmplLineNo)
            {
            }
            column(VarEmplNo_Control1000000080; VarEmplNo)
            {
            }
            column(Employee__No_of_Eligible_Children_; "No of Children")
            {
            }
            column(Employee__Arabic_City_; "Arabic City")
            {
            }
            column(Employee__Arabic_District_; "Arabic District")
            {
            }
            column(VarStMonth; VarStMonth)
            {
            }
            column(VarStYear; VarStYear)
            {
            }
            column(VarEndYear; VarEndYear)
            {
            }
            column(VarEndMonth; VarEndMonth)
            {
            }
            column(VarEndDay; VarEndDay)
            {
            }
            column(VarSeparated; VarSeparated)
            {
            }
            column(Employee__Mobile_Fax_No__; Employee."Fax No.")
            {
            }
            column(Employee__Arabic_Street_; Employee."Arabic Street")
            {
            }
            column(Employee__Mailbox_Area_; Employee."Arabic MailBox Area")
            {
            }
            column(Employee__Arabic_Elimination; Employee."Arabic Elimination")
            {
            }
            column(VarRegNo; Employee."Personal Finance No.")
            {
            }
            column(VarRegNoCo; CompanyInfo."Arabic Registration No.")
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000009; EmptyStringCaption_Control1000000009Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000008; EmptyStringCaption_Control1000000008Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000007; EmptyStringCaption_Control1000000007Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000011; EmptyStringCaption_Control1000000011Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000012; EmptyStringCaption_Control1000000012Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000208; EmptyStringCaption_Control1000000208Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000209; EmptyStringCaption_Control1000000209Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000210; EmptyStringCaption_Control1000000210Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000211; EmptyStringCaption_Control1000000211Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000212; EmptyStringCaption_Control1000000212Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000213; EmptyStringCaption_Control1000000213Lbl)
            {
            }
            column(V6Caption; V6CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000333; EmptyStringCaption_Control1000000333Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000334; EmptyStringCaption_Control1000000334Lbl)
            {
            }
            column(V360Caption; V360CaptionLbl)
            {
            }
            column(V350Caption; V350CaptionLbl)
            {
            }
            column(V340Caption; V340CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000339; EmptyStringCaption_Control1000000339Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000340; EmptyStringCaption_Control1000000340Lbl)
            {
            }
            column(V330Caption; V330CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000342; EmptyStringCaption_Control1000000342Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000345; EmptyStringCaption_Control1000000345Lbl)
            {
            }
            column(V310Caption; V310CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000350; EmptyStringCaption_Control1000000350Lbl)
            {
            }
            column(V300Caption; V300CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000355; EmptyStringCaption_Control1000000355Lbl)
            {
            }
            column(V260Caption; V260CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000360; EmptyStringCaption_Control1000000360Lbl)
            {
            }
            column(V250Caption; V250CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000365; EmptyStringCaption_Control1000000365Lbl)
            {
            }
            column(V240Caption; V240CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000370; EmptyStringCaption_Control1000000370Lbl)
            {
            }
            column(V230Caption; V230CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000376; EmptyStringCaption_Control1000000376Lbl)
            {
            }
            column(V220Caption; V220CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000381; EmptyStringCaption_Control1000000381Lbl)
            {
            }
            column(V210Caption; V210CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000386; EmptyStringCaption_Control1000000386Lbl)
            {
            }
            column(V200Caption; V200CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000391; EmptyStringCaption_Control1000000391Lbl)
            {
            }
            column(V190Caption; V190CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000407; EmptyStringCaption_Control1000000407Lbl)
            {
            }
            column(V180Caption; V180CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000413; EmptyStringCaption_Control1000000413Lbl)
            {
            }
            column(V170Caption; V170CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000423; EmptyStringCaption_Control1000000423Lbl)
            {
            }
            column(V160Caption; V160CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000425; EmptyStringCaption_Control1000000425Lbl)
            {
            }
            column(V150Caption; V150CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000431; EmptyStringCaption_Control1000000431Lbl)
            {
            }
            column(V140Caption; V140CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000437; EmptyStringCaption_Control1000000437Lbl)
            {
            }
            column(V130Caption; V130CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000443; EmptyStringCaption_Control1000000443Lbl)
            {
            }
            column(V120Caption; V120CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000449; EmptyStringCaption_Control1000000449Lbl)
            {
            }
            column(V110Caption; V110CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000455; EmptyStringCaption_Control1000000455Lbl)
            {
            }
            column(V100Caption; V100CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000461; EmptyStringCaption_Control1000000461Lbl)
            {
            }
            column(V1_Caption; V1_CaptionLbl)
            {
            }
            column(V2_Caption; V2_CaptionLbl)
            {
            }
            column(V3_Caption; V3_CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000465; EmptyStringCaption_Control1000000465Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000466; EmptyStringCaption_Control1000000466Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000467; EmptyStringCaption_Control1000000467Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000468; EmptyStringCaption_Control1000000468Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000469; EmptyStringCaption_Control1000000469Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000471; EmptyStringCaption_Control1000000471Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000472; EmptyStringCaption_Control1000000472Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000473; EmptyStringCaption_Control1000000473Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000474; EmptyStringCaption_Control1000000474Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000475; EmptyStringCaption_Control1000000475Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000476; EmptyStringCaption_Control1000000476Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000477; EmptyStringCaption_Control1000000477Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000478; EmptyStringCaption_Control1000000478Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000479; EmptyStringCaption_Control1000000479Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000480; EmptyStringCaption_Control1000000480Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000481; EmptyStringCaption_Control1000000481Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000484; EmptyStringCaption_Control1000000484Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000485; EmptyStringCaption_Control1000000485Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000486; EmptyStringCaption_Control1000000486Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000487; EmptyStringCaption_Control1000000487Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000488; EmptyStringCaption_Control1000000488Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000489; EmptyStringCaption_Control1000000489Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000490; EmptyStringCaption_Control1000000490Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000491; EmptyStringCaption_Control1000000491Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000492; EmptyStringCaption_Control1000000492Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000493; EmptyStringCaption_Control1000000493Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000498; EmptyStringCaption_Control1000000498Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000499; EmptyStringCaption_Control1000000499Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000500; EmptyStringCaption_Control1000000500Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000501; EmptyStringCaption_Control1000000501Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000502; EmptyStringCaption_Control1000000502Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000503; EmptyStringCaption_Control1000000503Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000507; EmptyStringCaption_Control1000000507Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000508; EmptyStringCaption_Control1000000508Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000509; EmptyStringCaption_Control1000000509Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000510; EmptyStringCaption_Control1000000510Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000511; EmptyStringCaption_Control1000000511Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000512; EmptyStringCaption_Control1000000512Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000099; EmptyStringCaption_Control1000000099Lbl)
            {
            }
            column(XCaption; XCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000078; EmptyStringCaption_Control1000000078Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000082; EmptyStringCaption_Control1000000082Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000083; EmptyStringCaption_Control1000000083Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000084; EmptyStringCaption_Control1000000084Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000086; EmptyStringCaption_Control1000000086Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000088; EmptyStringCaption_Control1000000088Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000090; EmptyStringCaption_Control1000000090Lbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                VarSingle := '';
                VarMarried := '';
                VarDivorced := '';
                VarWidowed := '';
                VarSeparated := '';

                IF Employee.Gender = Employee.Gender::Male then begin
                    if not Employee."Spouse Secured" then
                        EligibleNumber := Employee."No of Children" + 1
                    else
                        EligibleNumber := Employee."No of Children";
                end
                else
                    EligibleNumber := Employee."No of Children";
                //    
                PayParam.GET;
                VarYear := DATE2DMY(VarFPeriod, 3);
                VarStDate := VarFPeriod;

                VarEndDate := CALCDATE('+12M-1D', VarStDate);

                IF ("Termination Date" <> 0D) and ("Termination Date" >= VarStDate) and ("Termination Date" <= VarEndDate) then
                    VarEndDate := "Termination Date";

                Employee.SETFILTER(Employee."Termination Date", '>' + FORMAT(VarStDate) + '|%1', VarBlDate);
                Employee.SETFILTER(Employee."Declaration Date", '<' + FORMAT(VarEndDate));

                //IF (Employee."End of Service Date">=VarStDate)AND(Employee."End of Service Date"<=VarEndDate) THEN
                //  VarEndDate:=Employee."End of Service Date";

                if (Employee."Declaration Date" >= VarStDate) and (Employee."Declaration Date" <= VarEndDate) then
                    VarStDate := Employee."Declaration Date";


                //
                if Employee.Status = Employee.Status::Terminated then begin
                    if (Employee."Termination Date" < VarStDate) then
                        CurrReport.SKIP;
                end;
                //
                VarEmplLineNo := VarEmplLineNo + 1;

                //IF (Employee."End of Service Date"<=VarEndDate) AND((Employee."End of Service Date">=VarStDate)) THEN
                //  VarEndDate:=Employee."End of Service Date";
                VarMonthly := '';
                VarDaily := '';
                VarHour := '';
                VarSingle := '';
                VarMarried := '';
                VarWidowed := '';
                VarFExemp := 0;
                VarTotalExemp := 0;
                VarTax := 0;
                VarOtherExemp := 0;
                VarFaExemp := 0;
                VarTotalAp := 0;
                VarTotalEx := 0;
                VarTotalIn := 0;
                VarOtherAllow := 0;
                VarDeathAllow := 0;
                VarMedAllow := 0;
                VarBirth := 0;
                VarMared := 0;
                VarScholar := 0;
                VarInsur := 0;
                VarAllow := 0;
                VarClothing := 0;
                VarFood := 0;
                VarHouse := 0;
                VarCar := 0;
                VarTransportation := 0;
                VarWAllow := 0;
                VarFAllow := 0;
                VarBonus := 0;
                VarRep := 0;
                VarSalary := 0;
                CompanyInfo.GET;
                VarMonthly := 'X';

                /*RecEmployee.SETFILTER(RecEmployee."Declaration Date", '< 01/01/' + FORMAT(VarYear + 1));
                RecEmployee.SETFILTER(RecEmployee."Termination Date", '> 01/01/' + FORMAT(VarYear) + '|%1', 0D);
                RecEmployee.SETFILTER(Declared, '%1', RecEmployee.Declared::Declared);
                if RecEmployee.FINDSET then
                    VarEmplNo := RecEmployee.COUNT;*/
                //
                /*
                RecEmployee.RESET;
                RecEmployee.SETFILTER(Declared, '%1', RecEmployee.Declared::Declared);
                if RecEmployee.FINDSET then
                    repeat
                        IF ("Declaration Date" <= DMY2DATE(31, 12, DATE2DWY(VarFPeriod, 3))) and ("Termination Date" = 0D) and ("Inactive Date" = 0D) then
                            NumberofActiveDeclared += 1;
                    until RecEmployee.Next() = 0;*/
                RecEmployeeActive.RESET;
                RecEmployeeActive.SETFILTER(Declared, '%1', RecEmployeeActive.Declared::Declared);
                RecEmployeeActive.SETFILTER("Employment Date Filter", '<=%1', DMY2DATE(31, 12, VarYear));
                RecEmployeeActive.setfilter("Termination Date", '%1', 0D);
                RecEmployeeActive.SetFilter("Inactive Date", '%1', 0D);
                IF RecEmployeeActive.FINDFIRST then begin
                    RecEmployeeActive.CALCFIELDS("Number of Active Declared");
                    NumberofActiveDeclared := RecEmployeeActive."Number of Active Declared";
                end;
                //
                RecEmployeeTerminated.RESET;
                RecEmployeeTerminated.SETFILTER(Declared, '%1', RecEmployeeTerminated.Declared::Declared);
                RecEmployeeTerminated.SETFILTER("Employment Date Filter", '<=%1', DMY2DATE(31, 12, VarYear));
                RecEmployeeTerminated.SETFILTER("Termination Date Filter", '>=%1', DMY2DATE(1, 1, VarYear));
                IF RecEmployeeTerminated.FINDFIRST then begin
                    RecEmployeeTerminated.CALCFIELDS("Number of Terminated Declared");
                    NumberofTerminatedDeclared := RecEmployeeTerminated."Number of Terminated Declared";
                end;
                //
                RecEmployeeInactive.RESET;
                RecEmployeeInactive.SETFILTER(Declared, '%1', RecEmployeeInactive.Declared::Declared);
                RecEmployeeInactive.SETFILTER("Employment Date Filter", '<=%1', DMY2DATE(31, 12, VarYear));
                RecEmployeeInactive.SETFILTER("Inactive Date Filter", '>=%1', DMY2DATE(1, 1, VarYear));
                IF RecEmployeeInactive.FINDFIRST then begin
                    RecEmployeeInactive.CALCFIELDS("Number of Inactive Declared");
                    NumberofInactiveDeclared := RecEmployeeInactive."Number of Inactive Declared";
                end;
                //
                VarEmplNo := NumberofActiveDeclared + NumberofInactiveDeclared + NumberofTerminatedDeclared;

                case Employee."Social Status" of
                    Employee."Social Status"::Single:
                        VarSingle := 'X';
                    Employee."Social Status"::Married:
                        VarMarried := 'X';
                    Employee."Social Status"::Divorced:
                        VarDivorced := 'X';
                    Employee."Social Status"::Widow:
                        VarWidowed := 'X';
                    Employee."Social Status"::Separated:
                        VarSeparated := 'X';
                end;

                if PayElement.FIND('-') then
                    if PayElement."R6 No." <> '' then
                        repeat
                            VarAmount := 0;

                            //PayWorkSheet.SETRANGE(Open,FALSE);
                            PayWorkSheet.SETRANGE("Employee No.", Employee."No.");
                            PayWorkSheet.SETRANGE("Tax Year", VarYear);
                            PayWorkSheet.SETRANGE(Period, DATE2DMY(VarStDate, 2), DATE2DMY(VarEndDate, 2));
                            PayWorkSheet.SETRANGE("Pay Element Code", PayElement.Code);

                            if PayWorkSheet.FINDSET then
                                repeat
                                    if PayWorkSheet.Type = PayWorkSheet.Type::Addition then
                                        VarAmount := VarAmount + PayWorkSheet."Calculated Amount"
                                    else
                                        VarAmount := VarAmount - PayWorkSheet."Calculated Amount";
                                until PayWorkSheet.NEXT = 0;

                            case PayElement."R6 No." of
                                '100':
                                    begin
                                        VarSalary := VarSalary + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '110':
                                    begin
                                        VarRep := VarRep + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '120':
                                    begin
                                        VarBonus := VarBonus + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '130':
                                    begin
                                        VarFAllow := VarFAllow + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalEx := VarTotalEx + VarAmount;
                                    end;
                                '140':
                                    begin
                                        VarWAllow := VarWAllow + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalEx := VarTotalEx + VarAmount;
                                    end;
                                '150':
                                    begin
                                        VarTransportation := VarTransportation + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalEx := VarTotalEx + VarAmount;
                                    end;
                                '160':
                                    begin
                                        VarCar := VarCar + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '170':
                                    begin
                                        VarHouse := VarHouse + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '180':
                                    begin
                                        VarFood := VarFood + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalEx := VarTotalEx + VarAmount;
                                    end;
                                '190':
                                    begin
                                        VarClothing := VarClothing + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '200':
                                    begin
                                        VarAllow := VarAllow + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalEx := VarTotalEx + VarAmount;
                                    end;
                                '210':
                                    begin
                                        VarInsur := VarInsur + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '220':
                                    begin
                                        VarScholar := VarScholar + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalEx := VarTotalEx + VarAmount;
                                    end;
                                '230':
                                    begin
                                        VarMared := VarMared + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '240':
                                    begin
                                        VarBirth := VarBirth + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '250':
                                    begin
                                        VarMedAllow := VarMedAllow + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '260':
                                    begin
                                        VarDeathAllow := VarDeathAllow + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '300':
                                    begin
                                        VarOtherAllow := VarOtherAllow + VarAmount;
                                        VarTotalIn := VarTotalIn + VarAmount;
                                        VarTotalAp := VarTotalAp + VarAmount;
                                    end;
                                '360':
                                    begin
                                        VarTax := VarTax + (VarAmount * -1);
                                        DN := VarTax;
                                        //Precision:=1000;
                                        //Larger:='>';
                                        //VarTax:=ROUND(VarTax,Precision,Larger);
                                    end;
                            end;

                        until PayElement.NEXT = 0;



                VarWAllow := 0;
                PayLedgerEntry.SETRANGE(PayLedgerEntry."Employee No.", Employee."No.");
                PayLedgerEntry.SETRANGE(Declared, PayLedgerEntry.Declared::Declared);
                PayLedgerEntry.SETRANGE("Tax Year", VarYear);
                PayLedgerEntry.SETRANGE(Period, DATE2DMY(VarStDate, 2), DATE2DMY(VarEndDate, 2));
                PayLedgerEntry.SETFILTER("Payment Category", '%1', PayLedgerEntry."Payment Category"::" ");
                if PayLedgerEntry.FIND('-') then
                    repeat
                        VarTotalExemp := VarTotalExemp + PayLedgerEntry."Free Pay";
                        VarFaExemp := VarFaExemp + PayLedgerEntry."Free Pay";
                        if (PayLedgerEntry."Family Allowance" >= 60000) and (Employee.Gender = Employee.Gender::Male) then begin
                            //if not PayLedgerEntry."Spouse Secured" then                     
                            //VarWAllow:=VarWAllow+60000; 
                            VarWAllow += PayLedgerEntry."Family Allowance" - PayLedgerEntry."Eligible Children Count" * 33000;
                        end;
                    until PayLedgerEntry.NEXT = 0;


                if VarTotalAp < VarFaExemp then begin
                    VarTotalExemp := VarTotalAp;
                    VarFaExemp := VarTotalAp;

                end;

                VarIncome := VarTotalAp - (VarFaExemp + VarOtherExemp);


                VarStDay := DATE2DMY(VarStDate, 1);
                VarStMonth := DATE2DMY(VarStDate, 2);
                VarStYear := DATE2DMY(VarStDate, 3);

                VarEndDay := DATE2DMY(VarEndDate, 1);
                VarEndMonth := DATE2DMY(VarEndDate, 2);
                VarEndYear := DATE2DMY(VarEndDate, 3);
            end;

            trigger OnPreDataItem();
            begin
                //EDM+
                /*UserSetup.SETRANGE("User ID",USERID);
                IF UserSetup.FINDFIRST THEN BEGIN
                 IF UserSetup."Show Salary"=TRUE THEN
                 BEGIN
                 END
                 ELSE
                  ERROR('You don''t have permision');
                END
                ELSE
                  ERROR('You don''t have permision');
                *///EDM-

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'control';
                group(Control1000000001)
                {
                    field("Starting Period"; VarFPeriod)
                    {
                        Caption = 'Starting Period';
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
        if Payrollfunction.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    trigger OnPreReport();
    begin
        VarEmplLineNo := 0;
    end;

    var
        WifeEntitle: Decimal;
        SpecPayElement: Record "Specific Pay Element";
        RecEmployee: Record Employee;
        RecEmployeeActive: Record Employee;
        RecEmployeeInactive: Record Employee;
        RecEmployeeTerminated: Record Employee;
        PayElement: Record "Pay Element";
        PayWorkSheet: Record "Pay Detail Line";
        EmplRelative: Record "Employee Relative";
        PayLedgerEntry: Record "Payroll Ledger Entry";
        CompanyInfo: Record "Company Information";
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
        VarSeparated: Text[2];
        VarStDate: Date;
        VarEndDate: Date;
        VarFExemp: Integer;
        VarSalary: Decimal;
        VarRep: Decimal;
        VarBonus: Decimal;
        VarFAllow: Decimal;
        VarWAllow: Decimal;
        VarTransportation: Decimal;
        VarCar: Decimal;
        VarHouse: Decimal;
        VarFood: Decimal;
        VarClothing: Decimal;
        VarAllow: Decimal;
        VarInsur: Decimal;
        VarScholar: Decimal;
        VarMared: Decimal;
        VarBirth: Decimal;
        VarMedAllow: Decimal;
        VarDeathAllow: Decimal;
        VarOtherAllow: Decimal;
        VarTotalIn: Decimal;
        VarTotalEx: Decimal;
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
        VarDayST: Integer;
        VarDayET: Integer;
        DN: Decimal;
        Precision: Decimal;
        Larger: Text[30];
        VarTotalExemp: Decimal;
        PayParam: Record "Payroll Parameter";
        VarStDay: Integer;
        VarStMonth: Integer;
        VarStYear: Integer;
        VarEndDay: Integer;
        VarEndMonth: Integer;
        VarEndYear: Integer;
        EligibleNumber: Integer;
        UserSetup: Record "User Setup";
        EmptyStringCaptionLbl: Label '(لدى وزارة المالية)';
        EmptyStringCaption_Control1000000009Lbl: Label 'رقم التسجيل';
        EmptyStringCaption_Control1000000008Lbl: Label 'الشهرة التجارية';
        EmptyStringCaption_Control1000000007Lbl: Label 'إسم الشركة/المؤسسة';
        EmptyStringCaption_Control1000000011Lbl: Label 'عن اعمال سنة';
        EmptyStringCaption_Control1000000012Lbl: Label 'عدد الاجراء/المستخدمين';
        EmptyStringCaption_Control1000000208Lbl: Label 'مديرية الواردات - ضريبة الرواتب والاجور';
        EmptyStringCaption_Control1000000209Lbl: Label 'مديرية المالية العامة';
        EmptyStringCaption_Control1000000210Lbl: Label 'وزارة المالية';
        EmptyStringCaption_Control1000000211Lbl: Label 'الجمهورية اللبنانية';
        EmptyStringCaption_Control1000000212Lbl: Label 'المستخدم / الاجير';
        EmptyStringCaption_Control1000000213Lbl: Label 'كشف سنوي افرادي باجمالي ايرادات';
        V6CaptionLbl: Label 'ر6';
        EmptyStringCaption_Control1000000333Lbl: Label 'صافي الايرادات';
        EmptyStringCaption_Control1000000334Lbl: Label 'الضريبة السنوية المتوجبة';
        V360CaptionLbl: Label '360';
        V350CaptionLbl: Label '350';
        V340CaptionLbl: Label '340';
        EmptyStringCaption_Control1000000339Lbl: Label 'تنزيلات اخرى';
        EmptyStringCaption_Control1000000340Lbl: Label 'تنزيل عائلي';
        V330CaptionLbl: Label '330';
        EmptyStringCaption_Control1000000342Lbl: Label '": ينزل "';
        EmptyStringCaption_Control1000000345Lbl: Label 'المجموع';
        V310CaptionLbl: Label '310';
        EmptyStringCaption_Control1000000350Lbl: Label 'منح وتقديمات اخرى';
        V300CaptionLbl: Label '300';
        EmptyStringCaption_Control1000000355Lbl: Label 'مساعدات وفاة';
        V260CaptionLbl: Label '260';
        EmptyStringCaption_Control1000000360Lbl: Label 'مساعدات مرضية';
        V250CaptionLbl: Label '250';
        EmptyStringCaption_Control1000000365Lbl: Label 'منح ولادة';
        V240CaptionLbl: Label '240';
        EmptyStringCaption_Control1000000370Lbl: Label 'منح زواج';
        V230CaptionLbl: Label '230';
        EmptyStringCaption_Control1000000376Lbl: Label 'منح تعليم';
        V220CaptionLbl: Label '220';
        EmptyStringCaption_Control1000000381Lbl: Label 'تامينات صحية على انواعها';
        V210CaptionLbl: Label '210';
        EmptyStringCaption_Control1000000386Lbl: Label 'تعويض صندوق';
        V200CaptionLbl: Label '200';
        EmptyStringCaption_Control1000000391Lbl: Label 'بدل ملبس';
        V190CaptionLbl: Label '190';
        EmptyStringCaption_Control1000000407Lbl: Label 'بدل طعام';
        V180CaptionLbl: Label '180';
        EmptyStringCaption_Control1000000413Lbl: Label 'بدل سكن';
        V170CaptionLbl: Label '170';
        EmptyStringCaption_Control1000000423Lbl: Label 'بدل سيارة';
        V160CaptionLbl: Label '160';
        EmptyStringCaption_Control1000000425Lbl: Label 'تعويض  نقل وانتقال';
        V150CaptionLbl: Label '150';
        EmptyStringCaption_Control1000000431Lbl: Label 'تعويض عائلي عن الاولاد';
        V140CaptionLbl: Label '140';
        EmptyStringCaption_Control1000000437Lbl: Label 'تعويض عائلي عن الزوجة';
        V130CaptionLbl: Label '130';
        EmptyStringCaption_Control1000000443Lbl: Label 'مكافأت وعمولات وساعات اضافية';
        V120CaptionLbl: Label '120';
        EmptyStringCaption_Control1000000449Lbl: Label 'بدل تمثيل';
        V110CaptionLbl: Label '110';
        EmptyStringCaption_Control1000000455Lbl: Label 'الراتب الاساسي/الاجور اليومية';
        V100CaptionLbl: Label '100';
        EmptyStringCaption_Control1000000461Lbl: Label 'الشرح';
        V1_CaptionLbl: Label '(1)';
        V2_CaptionLbl: Label '(2)';
        V3_CaptionLbl: Label '(3)';
        EmptyStringCaption_Control1000000465Lbl: Label 'اجمالي الايردات';
        EmptyStringCaption_Control1000000466Lbl: Label 'الايردات غير الخاضعة للضريبة';
        EmptyStringCaption_Control1000000467Lbl: Label 'الايردات الخاضعة للضريبة';
        EmptyStringCaption_Control1000000468Lbl: Label 'البريد الالكتروني';
        EmptyStringCaption_Control1000000469Lbl: Label 'صندوق البريد : رقم';
        EmptyStringCaption_Control1000000471Lbl: Label 'المبنى';
        EmptyStringCaption_Control1000000472Lbl: Label 'الطابق';
        EmptyStringCaption_Control1000000473Lbl: Label 'فاكس';
        EmptyStringCaption_Control1000000474Lbl: Label 'الحي';
        EmptyStringCaption_Control1000000475Lbl: Label 'الشارع';
        EmptyStringCaption_Control1000000476Lbl: Label 'هاتف';
        EmptyStringCaption_Control1000000477Lbl: Label 'هاتف';
        EmptyStringCaption_Control1000000478Lbl: Label 'محافظة';
        EmptyStringCaption_Control1000000479Lbl: Label 'قضاء';
        EmptyStringCaption_Control1000000480Lbl: Label 'منطقة - بلدة';
        EmptyStringCaption_Control1000000481Lbl: Label '"عنوان المستخدم/الاجير "';
        EmptyStringCaption_Control1000000484Lbl: Label 'عدد ايام العمل للمستفيد من التنزيل اليومي';
        EmptyStringCaption_Control1000000485Lbl: Label 'مدة العمل من';
        EmptyStringCaption_Control1000000486Lbl: Label 'إلى';
        EmptyStringCaption_Control1000000487Lbl: Label '* الوضع العائلي';
        EmptyStringCaption_Control1000000488Lbl: Label 'اعزب';
        EmptyStringCaption_Control1000000489Lbl: Label 'متزوج';
        EmptyStringCaption_Control1000000490Lbl: Label 'ارمل';
        EmptyStringCaption_Control1000000491Lbl: Label 'مطلق';
        EmptyStringCaption_Control1000000492Lbl: Label 'عدد الاولاد';
        EmptyStringCaption_Control1000000493Lbl: Label '** عدد الاشخاص الذين يستفيدون من التنزيل العائلي';
        EmptyStringCaption_Control1000000498Lbl: Label '(لدى وزارة المالية)';
        EmptyStringCaption_Control1000000499Lbl: Label 'رقم التسجيل الشخصي';
        EmptyStringCaption_Control1000000500Lbl: Label 'نوع العمل';
        EmptyStringCaption_Control1000000501Lbl: Label '"* نوع الاجر "';
        EmptyStringCaption_Control1000000502Lbl: Label 'شهري';
        EmptyStringCaption_Control1000000503Lbl: Label 'يومي';
        EmptyStringCaption_Control1000000507Lbl: Label '" بالساعة"';
        EmptyStringCaption_Control1000000508Lbl: Label 'اسم الاجير/المستخدم';
        EmptyStringCaption_Control1000000509Lbl: Label 'اسم الاب';
        EmptyStringCaption_Control1000000510Lbl: Label 'الشهرة';
        EmptyStringCaption_Control1000000511Lbl: Label 'عدد الاجراء/المستخدمين المدخلين';
        EmptyStringCaption_Control1000000512Lbl: Label 'من';
        EmptyStringCaption_Control1000000099Lbl: Label 'توضع علامة   في المربع المناسب *';
        XCaptionLbl: Label 'X';
        EmptyStringCaption_Control1000000078Lbl: Label 'العدد يشمل الزوجة في حال كانت لا تعمل والاولاد الذين هم على عاتق المستخدم / الاجير **';
        EmptyStringCaption_Control1000000082Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000083Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000084Lbl: Label 'اليوم';
        EmptyStringCaption_Control1000000086Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000088Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000090Lbl: Label 'اليوم';
        Payrollfunction: Codeunit "Payroll Functions";
        PayrollGroup: Record "HR Payroll Group";
        NumberofActiveDeclared: integer;
        NumberofTerminatedDeclared: integer;
        NumberofInActiveDeclared: integer;

}

