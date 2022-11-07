report 98014 "Payroll R3"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll R3.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(Employee_Employee__Arabic_Middle_Name_; Employee."Arabic Middle Name")
            {
            }
            column(Employee_Employee__Arabic_Last_Name_; Employee."Arabic Last Name")
            {
            }
            column(Employee_Employee__Arabic_Mother_Name_; Employee."Arabic Mother Name")
            {
            }
            column(Employee_Employee__Arabic_First_Name_; Employee."Arabic First Name")
            {
            }
            column(Employee_Employee__Arabic_Nationality_; Employee."Arabic Nationality")
            {
            }
            column(Employee_Employee__Arabic_Place_of_Birth_; Employee."Arabic Place of Birth")
            {
            }
            column(Employee_Employee__Register_No__; Employee."Register No.")
            {
            }
            column(EmpDayOfBirth; EmpDayOfBirth)
            {
            }
            column(Employee_Employee__Government_ID_No__; Employee."Government ID No.")
            {
            }
            column(Employee_Employee__NSSF_No__; Employee."Social Security No.")
            {
            }
            column(ChildNo; ChildNo)
            {
            }
            column(GenderEmp_1_; GenderEmp[1])
            {
            }
            column(GenderEmp_2_; GenderEmp[2])
            {
            }
            column(SocialStatus_1_; SocialStatus[1])
            {
            }
            column(SocialStatus_2_; SocialStatus[2])
            {
            }
            column(SocialStatus_3_; SocialStatus[3])
            {
            }
            column(SocialStatus_4_; SocialStatus[4])
            {
            }
            column(Employee_Employee__Arabic_Registeration_Place_; Employee."Arabic Registeration Place")
            {
            }
            column(MonthlyPay; MonthlyPay)
            {
            }
            column(Employee_Employee__No_of_Children_; Employee."No of Children")
            {
            }
            column(IDNb; IDNb)
            {
            }
            column(Nationality; Nationality)
            {
            }
            column(PlaceOfBirth; PlaceOfBirth)
            {
            }
            column(MotherName; MotherName)
            {
            }
            column(Mname; Mname)
            {
            }
            column(Lname; Lname)
            {
            }
            column(Fname; Fname)
            {
            }
            column(Employee_Employee__E_Mail_; Employee."E-Mail")
            {
            }
            column(Employee_Employee__Arabic_MailBox_Area_; Employee."Arabic MailBox Area")
            {
            }
            column(Employee_Employee__Fax_No__; Employee."Fax No.")
            {
            }
            column(Employee_Employee__Phone_No__; Employee."Phone No.")
            {
            }
            column(Employee_Employee__Mobile_Phone_No__; Employee."Mobile Phone No.")
            {
            }
            column(Employee_Employee__Arabic_Floor_; Employee."Arabic Floor")
            {
            }
            column(Employee_Employee__Arabic_Building_; Employee."Arabic Building")
            {
            }
            column(Employee_Employee__Mailbox_ID_; Employee."Mailbox ID")
            {
            }
            column(Employee_Employee__Arabic_Street_; Employee."Arabic Street")
            {
            }
            column(Employee_Employee__Arabic_Land_Area_; Employee."Arabic Land Area")
            {
            }
            column(Employee_Employee__Arabic_Land_Area__No__; Employee."Arabic Land Area  No.")
            {
            }
            column(Employee_Employee__Arabic_Governorate_; Employee."Arabic Governorate")
            {
            }
            column(Employee_Employee__Arabic_Elimination_; Employee."Arabic Elimination")
            {
            }
            column(Employee_Employee__Arabic_City_; Employee."Arabic City")
            {
            }
            column(Employee_Employee__Arabic_District_; Employee."Arabic District")
            {
            }
            column(Text001; Text001)
            {
            }
            column(Text000; Text000)
            {
            }
            column(Text002; Text002)
            {
            }
            column(Text006; Text006)
            {
            }
            column(Text005; Text005)
            {
            }
            column(Text004; Text004)
            {
            }
            column(Working_1_; Working[1])
            {
            }
            column(Working_2_; Working[2])
            {
            }
            column(RelativeFinanceNb; RelativeFinanceNb)
            {
            }
            column(RelativeCompanyName; RelativeCompanyName)
            {
            }
            column(EmployeeRelative__Personal_Register_No__; EmployeeRelative."Personal Register No.")
            {
            }
            column(CompanyInformation__Arabic_Trading_Name_; CompanyInformation."Arabic Trading Name")
            {
            }
            column(CompanyInformation__Arabic_Name_; CompanyInformation."Arabic Name")
            {
            }
            column(CompanyInformation__Registration_No__; CompanyInformation."Registration No.")
            {
            }
            column(HaveNb_2_; HaveNb[2])
            {
            }
            column(HaveNb_1_; HaveNb[1])
            {
            }
            column(Employee_Employee__Personal_Finance_No__; Employee."Personal Finance No.")
            {
            }
            column(EmpMonthOfBirth; EmpMonthOfBirth)
            {
            }
            column(EmpYearOfBirth; EmpYearOfBirth)
            {
            }
            column(RelYearOfBirth; RelYearOfBirth)
            {
            }
            column(RelMonthOfBirth; RelMonthOfBirth)
            {
            }
            column(RelDayOfBirth; RelDayOfBirth)
            {
            }
            column(EmpDateYear; EmpDateYear)
            {
            }
            column(EmpDateMonth; EmpDateMonth)
            {
            }
            column(EmpDateDay; EmpDateDay)
            {
            }
            column(CompanyInformation__Company_Owner_; CompanyInformation."Company Owner")
            {
            }
            column(CompanyInformation__Job_Description_; CompanyInformation."Job Description")
            {
            }
            column(InvYear; InvYear)
            {
            }
            column(InvMonth; InvMonth)
            {
            }
            column(InvDay; InvDay)
            {
            }
            column(Caption; CaptionLbl)
            {
            }
            column(V14Caption; V14CaptionLbl)
            {
            }
            column(Caption_Control1000000184; Caption_Control1000000184Lbl)
            {
            }
            column(Caption_Control1000000185; Caption_Control1000000185Lbl)
            {
            }
            column(Caption_Control1000000186; Caption_Control1000000186Lbl)
            {
            }
            column(Caption_Control1000000187; Caption_Control1000000187Lbl)
            {
            }
            column(Caption_Control1000000188; Caption_Control1000000188Lbl)
            {
            }
            column(V12Caption; V12CaptionLbl)
            {
            }
            column(Caption_Control1000000190; Caption_Control1000000190Lbl)
            {
            }
            column(Caption_Control1000000191; Caption_Control1000000191Lbl)
            {
            }
            column(V9Caption; V9CaptionLbl)
            {
            }
            column(V10Caption; V10CaptionLbl)
            {
            }
            column(Caption_Control1000000194; Caption_Control1000000194Lbl)
            {
            }
            column(Caption_Control1000000195; Caption_Control1000000195Lbl)
            {
            }
            column(V7Caption; V7CaptionLbl)
            {
            }
            column(V8Caption; V8CaptionLbl)
            {
            }
            column(V11Caption; V11CaptionLbl)
            {
            }
            column(V13Caption; V13CaptionLbl)
            {
            }
            column(V15Caption; V15CaptionLbl)
            {
            }
            column(V16Caption; V16CaptionLbl)
            {
            }
            column(Caption_Control1000000202; Caption_Control1000000202Lbl)
            {
            }
            column(Caption_Control1000000203; Caption_Control1000000203Lbl)
            {
            }
            column(Caption_Control1000000204; Caption_Control1000000204Lbl)
            {
            }
            column(Caption_Control1000000205; Caption_Control1000000205Lbl)
            {
            }
            column(V5Caption; V5CaptionLbl)
            {
            }
            column(V6Caption; V6CaptionLbl)
            {
            }
            column(Caption_Control1000000208; Caption_Control1000000208Lbl)
            {
            }
            column(Caption_Control1000000209; Caption_Control1000000209Lbl)
            {
            }
            column(V4Caption; V4CaptionLbl)
            {
            }
            column(V3Caption; V3CaptionLbl)
            {
            }
            column(Caption_Control1000000212; Caption_Control1000000212Lbl)
            {
            }
            column(Caption_Control1000000213; Caption_Control1000000213Lbl)
            {
            }
            column(V1Caption; V1CaptionLbl)
            {
            }
            column(V2Caption; V2CaptionLbl)
            {
            }
            column(Caption_Control1000000216; Caption_Control1000000216Lbl)
            {
            }
            column(Caption_Control1000000218; Caption_Control1000000218Lbl)
            {
            }
            column(Caption_Control1000000219; Caption_Control1000000219Lbl)
            {
            }
            column(Caption_Control1000000220; Caption_Control1000000220Lbl)
            {
            }
            column(Caption_Control1000000221; Caption_Control1000000221Lbl)
            {
            }
            column(Caption_Control1000000222; Caption_Control1000000222Lbl)
            {
            }
            column(Caption_Control1000000223; Caption_Control1000000223Lbl)
            {
            }
            column(Caption_Control1000000224; Caption_Control1000000224Lbl)
            {
            }
            column(Caption_Control1000000225; Caption_Control1000000225Lbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(Caption_Control1000000227; Caption_Control1000000227Lbl)
            {
            }
            column(Caption_Control1000000228; Caption_Control1000000228Lbl)
            {
            }
            column(Caption_Control1000000013; Caption_Control1000000013Lbl)
            {
            }
            column(Caption_Control1000000014; Caption_Control1000000014Lbl)
            {
            }
            column(Caption_Control1000000016; Caption_Control1000000016Lbl)
            {
            }
            column(Caption_Control1000000019; Caption_Control1000000019Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000331; EmptyStringCaption_Control1000000331Lbl)
            {
            }
            column(Caption_Control1000000332; Caption_Control1000000332Lbl)
            {
            }
            column(Caption_Control1000000333; Caption_Control1000000333Lbl)
            {
            }
            column(Caption_Control1000000334; Caption_Control1000000334Lbl)
            {
            }
            column(Caption_Control1000000336; Caption_Control1000000336Lbl)
            {
            }
            column(Caption_Control1000000337; Caption_Control1000000337Lbl)
            {
            }
            column(Caption_Control1000000339; Caption_Control1000000339Lbl)
            {
            }
            column(Caption_Control1000000341; Caption_Control1000000341Lbl)
            {
            }
            column(Caption_Control1000000342; Caption_Control1000000342Lbl)
            {
            }
            column(Caption_Control1000000343; Caption_Control1000000343Lbl)
            {
            }
            column(Caption_Control1000000344; Caption_Control1000000344Lbl)
            {
            }
            column(Caption_Control1000000345; Caption_Control1000000345Lbl)
            {
            }
            column(V8Caption_Control1000000347; V8Caption_Control1000000347Lbl)
            {
            }
            column(Caption_Control1000000348; Caption_Control1000000348Lbl)
            {
            }
            column(Caption_Control1000000350; Caption_Control1000000350Lbl)
            {
            }
            column(Caption_Control1000000351; Caption_Control1000000351Lbl)
            {
            }
            column(Caption_Control1000000352; Caption_Control1000000352Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000353; EmptyStringCaption_Control1000000353Lbl)
            {
            }
            column(Caption_Control1000000354; Caption_Control1000000354Lbl)
            {
            }
            column(Caption_Control1000000355; Caption_Control1000000355Lbl)
            {
            }
            column(Caption_Control1000000357; Caption_Control1000000357Lbl)
            {
            }
            column(V6Caption_Control1000000358; V6Caption_Control1000000358Lbl)
            {
            }
            column(Caption_Control1000000359; Caption_Control1000000359Lbl)
            {
            }
            column(V5Caption_Control1000000361; V5Caption_Control1000000361Lbl)
            {
            }
            column(V7Caption_Control1000000362; V7Caption_Control1000000362Lbl)
            {
            }
            column(V9Caption_Control1000000363; V9Caption_Control1000000363Lbl)
            {
            }
            column(V10Caption_Control1000000364; V10Caption_Control1000000364Lbl)
            {
            }
            column(Caption_Control1000000366; Caption_Control1000000366Lbl)
            {
            }
            column(V4Caption_Control1000000367; V4Caption_Control1000000367Lbl)
            {
            }
            column(V3Caption_Control1000000368; V3Caption_Control1000000368Lbl)
            {
            }
            column(Caption_Control1000000369; Caption_Control1000000369Lbl)
            {
            }
            column(Caption_Control1000000371; Caption_Control1000000371Lbl)
            {
            }
            column(Caption_Control1000000372; Caption_Control1000000372Lbl)
            {
            }
            column(Caption_Control1000000374; Caption_Control1000000374Lbl)
            {
            }
            column(V2Caption_Control1000000375; V2Caption_Control1000000375Lbl)
            {
            }
            column(V1Caption_Control1000000377; V1Caption_Control1000000377Lbl)
            {
            }
            column(Caption_Control1000000378; Caption_Control1000000378Lbl)
            {
            }
            column(Caption_Control1000000379; Caption_Control1000000379Lbl)
            {
            }
            column(Caption_Control1000000381; Caption_Control1000000381Lbl)
            {
            }
            column(Caption_Control1000000384; Caption_Control1000000384Lbl)
            {
            }
            column(Caption_Control1000000385; Caption_Control1000000385Lbl)
            {
            }
            column(Caption_Control1000000386; Caption_Control1000000386Lbl)
            {
            }
            column(Caption_Control1000000387; Caption_Control1000000387Lbl)
            {
            }
            column(Caption_Control1000000393; Caption_Control1000000393Lbl)
            {
            }
            column(Caption_Control1000000394; Caption_Control1000000394Lbl)
            {
            }
            column(e_mail_Caption; e_mail_CaptionLbl)
            {
            }
            column(Caption_Control1000000399; Caption_Control1000000399Lbl)
            {
            }
            column(Caption_Control1000000400; Caption_Control1000000400Lbl)
            {
            }
            column(Caption_Control1000000401; Caption_Control1000000401Lbl)
            {
            }
            column(Caption_Control1000000402; Caption_Control1000000402Lbl)
            {
            }
            column(Caption_Control1000000407; Caption_Control1000000407Lbl)
            {
            }
            column(Caption_Control1000000408; Caption_Control1000000408Lbl)
            {
            }
            column(Caption_Control1000000409; Caption_Control1000000409Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000410; EmptyStringCaption_Control1000000410Lbl)
            {
            }
            column(Caption_Control1000000411; Caption_Control1000000411Lbl)
            {
            }
            column(Caption_Control1000000412; Caption_Control1000000412Lbl)
            {
            }
            column(Caption_Control1000000431; Caption_Control1000000431Lbl)
            {
            }
            column(Caption_Control1000000432; Caption_Control1000000432Lbl)
            {
            }
            column(Caption_Control1000000433; Caption_Control1000000433Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000435; EmptyStringCaption_Control1000000435Lbl)
            {
            }
            column(Caption_Control1000000440; Caption_Control1000000440Lbl)
            {
            }
            column(Caption_Control1000000441; Caption_Control1000000441Lbl)
            {
            }
            column(Caption_Control1000000442; Caption_Control1000000442Lbl)
            {
            }
            column(Caption_Control1000000443; Caption_Control1000000443Lbl)
            {
            }
            column(Caption_Control1000000444; Caption_Control1000000444Lbl)
            {
            }
            column(Caption_Control1000000448; Caption_Control1000000448Lbl)
            {
            }
            column(xCaption; xCaptionLbl)
            {
            }
            column(Caption_Control1000000450; Caption_Control1000000450Lbl)
            {
            }
            column(Caption_Control1000000451; Caption_Control1000000451Lbl)
            {
            }
            column(Caption_Control1000000452; Caption_Control1000000452Lbl)
            {
            }
            column(Caption_Control1000000453; Caption_Control1000000453Lbl)
            {
            }
            column(Caption_Control1000000454; Caption_Control1000000454Lbl)
            {
            }
            column(Caption_Control1000000007; Caption_Control1000000007Lbl)
            {
            }
            column(Caption_Control1000000015; Caption_Control1000000015Lbl)
            {
            }
            column(V3Caption_Control1000000017; V3Caption_Control1000000017Lbl)
            {
            }
            column(Caption_Control1000000018; Caption_Control1000000018Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000022; EmptyStringCaption_Control1000000022Lbl)
            {
            }
            column(Caption_Control1000000023; Caption_Control1000000023Lbl)
            {
            }
            column(Caption_Control1000000024; Caption_Control1000000024Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000025; EmptyStringCaption_Control1000000025Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000026; EmptyStringCaption_Control1000000026Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000027; EmptyStringCaption_Control1000000027Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000028; EmptyStringCaption_Control1000000028Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000031; EmptyStringCaption_Control1000000031Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000057; EmptyStringCaption_Control1000000057Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000058; EmptyStringCaption_Control1000000058Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000063; EmptyStringCaption_Control1000000063Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000064; EmptyStringCaption_Control1000000064Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000074; EmptyStringCaption_Control1000000074Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000077; EmptyStringCaption_Control1000000077Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000078; EmptyStringCaption_Control1000000078Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000079; EmptyStringCaption_Control1000000079Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000030; EmptyStringCaption_Control1000000030Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000044; EmptyStringCaption_Control1000000044Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000059; EmptyStringCaption_Control1000000059Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000060; EmptyStringCaption_Control1000000060Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000061; EmptyStringCaption_Control1000000061Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000062; EmptyStringCaption_Control1000000062Lbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(Wife_Hsband_Name; "Wife-Hsband Name")
            {
            }
            column("Wife_Hsband_Father_Name"; "Wife-Hsband Father Name")
            {
            }
            column("Wife_Hsband_Nationality"; "Wife-Hsband Nationality")
            {
            }
            column("Wife_Hsband_Birthdate"; "Wife-Hsband Birthdate")
            {
            }
            column("Wife_Hsband_Registry_No"; "Wife-Hsband Registry No.")
            {
            }
            column("Wife_Hsband_Registry_Place"; "Wife-Hsband Registry Place")
            {
            }
            column("Family_Before_Marriage"; "Family Before Marriage")
            {
            }
            column("Mother_Family_Before_Marriage"; "Mother Family Before Marriage")
            {
            }
            column("Wife_Hsband_Birth_Place"; "Wife-Hsband Birth Place")
            {
            }
            column("Wife_Hsband_Card_No"; "Wife-Hsband Card No.")
            {
            }
            column("Wife_Hsband_Working"; "Wife-Hsband Working")
            {
            }
            column("Wife_Hsband_Working_Place"; "Wife-Hsband Working Place")
            {
            }
            column(Wife_Hsband_Registration_No; "Wife-Hsband Registration No.")
            {
            }
            trigger OnAfterGetRecord();
            begin
                //BirthDate
                if Employee."Birth Date" <> 0D then begin
                    EmpDayOfBirth := DATE2DMY(Employee."Birth Date", 1);
                    EmpMonthOfBirth := DATE2DMY(Employee."Birth Date", 2);
                    EmpYearOfBirth := DATE2DMY(Employee."Birth Date", 3);
                end;
                if Employee."NSSF Date" <> 0D then begin
                    EmpDateDay := DATE2DMY(Employee."NSSF Date", 1);
                    EmpDateMonth := DATE2DMY(Employee."NSSF Date", 2);
                    EmpDateYear := DATE2DMY(Employee."NSSF Date", 3);
                end;

                //Finance No
                if Employee."Personal Finance No." <> '' then
                    HaveNb[1] := 'x'
                else
                    HaveNb[2] := 'x';
                //Gender
                if Employee.Gender = Employee.Gender::Female then begin
                    GenderEmp[1] := '';
                    GenderEmp[2] := 'x';
                end
                else begin
                    GenderEmp[1] := 'x';
                    GenderEmp[2] := '';
                end;

                //Social Status
                if Employee."Social Status" = Employee."Social Status"::Divorced then begin
                    SocialStatus[1] := '';
                    SocialStatus[2] := '';
                    SocialStatus[3] := '';
                    SocialStatus[4] := 'x';
                end
                else
                    if Employee."Social Status" = Employee."Social Status"::Married then begin
                        SocialStatus[1] := '';
                        SocialStatus[2] := 'x';
                        SocialStatus[3] := '';
                        SocialStatus[4] := '';
                    end
                    else
                        if Employee."Social Status" = Employee."Social Status"::Widow then begin
                            SocialStatus[1] := '';
                            SocialStatus[2] := '';
                            SocialStatus[3] := 'x';
                            SocialStatus[4] := '';
                        end
                        else begin
                            SocialStatus[1] := 'x';
                            SocialStatus[2] := '';
                            SocialStatus[3] := '';
                            SocialStatus[4] := '';
                        end;

                //Husband Or Wife Data
                EmployeeRelative.RESET;
                EmployeeRelative.SETRANGE(EmployeeRelative."Employee No.", Employee."No.");
                if EmployeeRelative.FINDFIRST then begin
                    repeat
                        EmployeeRelative.CALCFIELDS(Type);
                        if EmployeeRelative.Type = EmployeeRelative.Type::Husband then begin
                            Fname := EmployeeRelative."Arabic First Name";
                            Mname := EmployeeRelative."Arabic Middle Name";
                            Lname := EmployeeRelative."Arabic Last Name";
                            MotherName := EmployeeRelative."Arabic Mother Name";
                            Nationality := EmployeeRelative."Arabic Nationality";
                            PlaceOfBirth := EmployeeRelative."Arabic Place Of Birth";
                            IDNb := EmployeeRelative."ID No.";
                            //BirthDate:=EmployeeRelative."Birth Date";
                            if EmployeeRelative."Birth Date" <> 0D then begin
                                RelDayOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 1);
                                RelMonthOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 2);
                                RelYearOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 3);
                            end;
                            RelativeCompanyName := EmployeeRelative."Arabic Company Name";
                            RelativeFinanceNb := EmployeeRelative."Finance Register No.";
                            if EmployeeRelative.Working then begin
                                Working[1] := 'x';
                                Working[2] := '';
                            end
                            else begin
                                Working[1] := '';
                                Working[2] := 'x';
                            end;
                        end
                        else
                            if EmployeeRelative.Type = EmployeeRelative.Type::Wife then begin
                                Fname := EmployeeRelative."Arabic First Name";
                                Mname := EmployeeRelative."Arabic Middle Name";
                                Lname := EmployeeRelative."Arabic Last Name";
                                MotherName := EmployeeRelative."Arabic Mother Name";
                                Nationality := EmployeeRelative."Arabic Nationality";
                                PlaceOfBirth := EmployeeRelative."Arabic Place Of Birth";
                                IDNb := EmployeeRelative."ID No.";
                                // BirthDate:=EmployeeRelative."Birth Date";
                                if EmployeeRelative."Birth Date" <> 0D then begin
                                    RelDayOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 1);
                                    RelMonthOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 2);
                                    RelYearOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 3);
                                end;

                                RelativeCompanyName := EmployeeRelative."Arabic Company Name";
                                RelativeFinanceNb := EmployeeRelative."Finance Register No.";
                                RelativePersonalNb := EmployeeRelative."Personal Register No.";
                                if EmployeeRelative.Working then begin
                                    Working[1] := 'x';
                                    Working[2] := '';
                                end
                                else begin
                                    Working[1] := '';
                                    Working[2] := 'x';
                                end;
                            end
                    //END
                    until EmployeeRelative.NEXT = 0;
                    /*
                    ELSE
                    BEGIN
                      Fname:='';
                      Mname:='';
                      Lname:='';
                      MotherName:='';
                      Nationality:='';
                      PlaceOfBirth:='';
                      IDNb:='';
                     // BirthDate:=EmployeeRelative."Birth Date";
                      RelDayOfBirth :=0;
                      RelMonthOfBirth:=0;
                      RelYearOfBirth:=0;
                      RelativeCompanyName:='';
                      RelativeFinanceNb:='';
                      RelativePersonalNb:='';
                      Working[1]:='';
                      Working[2]:='';
                       */
                end;

                //Number Of Child
                EmployeeRelative.RESET;
                EmployeeRelative.SETRANGE(EmployeeRelative."Employee No.", Employee."No.");
                if EmployeeRelative.FINDFIRST then begin
                    repeat
                        EmployeeRelative.CALCFIELDS(Type);
                        if EmployeeRelative."Employee No." = Employee."No." then begin
                            if EmployeeRelative.Type = EmployeeRelative.Type::Child then begin
                                ChildNo := ChildNo + 1;
                            end
                        end;
                    until EmployeeRelative.NEXT = 0;
                end
                else
                    ChildNo := 0;

                EmployeeRelative.RESET;



                //Pay Freq
                if Employee."Pay Frequency" = Employee."Pay Frequency"::Monthly then
                    MonthlyPay := 'x';


                //Invoice Date
                InvDay := DATE2DMY(InvoiceDate, 1);
                InvMonth := DATE2DMY(InvoiceDate, 2);
                InvYear := DATE2DMY(InvoiceDate, 3);

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'Report Date';
                group(Control1000000002)
                {
                    Caption = 'Report Date';
                    field(InvoiceDate; InvoiceDate)
                    {
                        Caption = 'تاريخ التقرير';
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

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
    end;

    var
        Text000: Label '"أنا الموقع أدناه افيد بأن هذه المعلومات هي مطابقة لتلك المدونة "';
        Text001: Label '"في بيان المعلومات لدى المستخدم / الأجير الى صاحب العمل "';
        Text002: Label 'الرقم المالي الشخصي للمستخدم/الأجير';
        CompanyInformation: Record "Company Information";
        Text003: Label '"توضع علامة "';
        Text004: Label 'في حال تغيير عنوان السكن يرجى تعبئة نموزج تعديل معلومات أفراد - م5';
        Text005: Label 'يستعمل هذا النموذج لتسجيل المستخدمين و الأجراء الذين ليس لديهم رقم  مالي شخصي لدى وزارة المالية و يقدم لدى الدائرة المالية المختصة';
        Text006: Label 'يرفق بهذا الطلب صورة عن اخراج قيد عائلي للأجير المتزوج أو صورة عن بطاقة الهوية أو اخراج قيد افرادي للعازب';
        ChildNo: Integer;
        EmployeeRelative: Record "Employee Relative";
        GenderEmp: array[2] of Text[1];
        SocialStatus: array[4] of Text[1];
        Fname: Text[30];
        Lname: Text[30];
        Mname: Text[30];
        MotherName: Text[30];
        Nationality: Text[30];
        IDNb: Code[12];
        PlaceOfBirth: Text[30];
        MonthlyPay: Text[1];
        Working: array[2] of Text[1];
        RelativeCompanyName: Text[30];
        RelativeFinanceNb: Code[20];
        RelativePersonalNb: Code[20];
        HaveNb: array[2] of Text[1];
        EmpDayOfBirth: Integer;
        EmpMonthOfBirth: Integer;
        EmpYearOfBirth: Integer;
        RelDayOfBirth: Integer;
        RelMonthOfBirth: Integer;
        RelYearOfBirth: Integer;
        EmpDateDay: Integer;
        EmpDateMonth: Integer;
        EmpDateYear: Integer;
        InvoiceDate: Date;
        InvDay: Integer;
        InvMonth: Integer;
        InvYear: Integer;
        CaptionLbl: Label 'تاريخ ابتداء العمل';
        V14CaptionLbl: Label '-14';
        Caption_Control1000000184Lbl: Label 'الوضع العائلي';
        Caption_Control1000000185Lbl: Label 'اعزب';
        Caption_Control1000000186Lbl: Label 'متزوج';
        Caption_Control1000000187Lbl: Label '"ارمل "';
        Caption_Control1000000188Lbl: Label 'مطلق';
        V12CaptionLbl: Label '-12';
        Caption_Control1000000190Lbl: Label 'رقم السجل';
        Caption_Control1000000191Lbl: Label '"مكان السجل "';
        V9CaptionLbl: Label '-9';
        V10CaptionLbl: Label '-10';
        Caption_Control1000000194Lbl: Label 'محل الولادة';
        Caption_Control1000000195Lbl: Label 'تاريخ الولادة';
        V7CaptionLbl: Label '-7';
        V8CaptionLbl: Label '-8';
        V11CaptionLbl: Label '-11';
        V13CaptionLbl: Label '-13';
        V15CaptionLbl: Label '-15';
        V16CaptionLbl: Label '-16';
        Caption_Control1000000202Lbl: Label 'الجنس';
        Caption_Control1000000203Lbl: Label 'ذكر';
        Caption_Control1000000204Lbl: Label 'انثى';
        Caption_Control1000000205Lbl: Label 'الجنسية';
        V5CaptionLbl: Label '-5';
        V6CaptionLbl: Label '-6';
        Caption_Control1000000208Lbl: Label 'اسم الأب';
        Caption_Control1000000209Lbl: Label 'اسم الأم و شهرتها قبل الزواج';
        V4CaptionLbl: Label '-4';
        V3CaptionLbl: Label '-3';
        Caption_Control1000000212Lbl: Label '"الاسم "';
        Caption_Control1000000213Lbl: Label '"الشهرة "';
        V1CaptionLbl: Label '-1';
        V2CaptionLbl: Label '-2';
        Caption_Control1000000216Lbl: Label 'رقم بطاقة الهوية';
        Caption_Control1000000218Lbl: Label 'رقم الضمان الاجتماعي';
        Caption_Control1000000219Lbl: Label 'نوع الأجر';
        Caption_Control1000000220Lbl: Label 'شهري';
        Caption_Control1000000221Lbl: Label 'يومي';
        Caption_Control1000000222Lbl: Label 'بالساعة';
        Caption_Control1000000223Lbl: Label '"نعم "';
        Caption_Control1000000224Lbl: Label 'لا';
        Caption_Control1000000225Lbl: Label 'في حال نعم اذكر الرقم';
        EmptyStringCaptionLbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000227Lbl: Label 'تعـــــريف المستخدم / الأجير';
        Caption_Control1000000228Lbl: Label 'هل لديه رقم مالي شخصي ؟';
        Caption_Control1000000013Lbl: Label 'عدد الأولاد';
        Caption_Control1000000014Lbl: Label '*';
        Caption_Control1000000016Lbl: Label '*';
        Caption_Control1000000019Lbl: Label '*';
        EmptyStringCaption_Control1000000331Lbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000332Lbl: Label 'رقم التسجيل';
        Caption_Control1000000333Lbl: Label 'عامة / مصلحة مستقلة';
        Caption_Control1000000334Lbl: Label '"نعم "';
        Caption_Control1000000336Lbl: Label 'لا';
        Caption_Control1000000337Lbl: Label 'في حال نعم اذكر';
        Caption_Control1000000339Lbl: Label 'يستفيدون من التنزيل العائلي';
        Caption_Control1000000341Lbl: Label 'العامة/المصلحة المستقلة';
        Caption_Control1000000342Lbl: Label 'اسم الادارة';
        Caption_Control1000000343Lbl: Label 'في القطاع الخاص او في مؤسسة';
        Caption_Control1000000344Lbl: Label 'هل الزوج / الزوجة يعمل ؟';
        Caption_Control1000000345Lbl: Label '*';
        V8Caption_Control1000000347Lbl: Label '-8';
        Caption_Control1000000348Lbl: Label 'رقم بطاقة الهوية';
        Caption_Control1000000350Lbl: Label 'تاريخ الولادة';
        Caption_Control1000000351Lbl: Label 'عدد الأشخاص الذين';
        Caption_Control1000000352Lbl: Label 'رقم التسجيل الشخصي';
        EmptyStringCaption_Control1000000353Lbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000354Lbl: Label 'اسم الشركة / المؤسسة';
        Caption_Control1000000355Lbl: Label 'في الادارات العامة';
        Caption_Control1000000357Lbl: Label 'الجنسية';
        V6Caption_Control1000000358Lbl: Label '-6';
        Caption_Control1000000359Lbl: Label 'محل الولادة';
        V5Caption_Control1000000361Lbl: Label '-5';
        V7Caption_Control1000000362Lbl: Label '-7';
        V9Caption_Control1000000363Lbl: Label '-9';
        V10Caption_Control1000000364Lbl: Label '-10';
        Caption_Control1000000366Lbl: Label 'اسم الأم و شهرتها قبل الزواج';
        V4Caption_Control1000000367Lbl: Label '-4';
        V3Caption_Control1000000368Lbl: Label '-3';
        Caption_Control1000000369Lbl: Label 'اسم الأب';
        Caption_Control1000000371Lbl: Label '-أ';
        Caption_Control1000000372Lbl: Label '-ب';
        Caption_Control1000000374Lbl: Label 'الشهرة قبل الزواج';
        V2Caption_Control1000000375Lbl: Label '-2';
        V1Caption_Control1000000377Lbl: Label '-1';
        Caption_Control1000000378Lbl: Label 'اسم الزوج / الزوجة';
        Caption_Control1000000379Lbl: Label 'معلومات خاصة بالزوج / الزوجة';
        Caption_Control1000000381Lbl: Label 'فاكس';
        Caption_Control1000000384Lbl: Label 'الطابق';
        Caption_Control1000000385Lbl: Label 'هاتف';
        Caption_Control1000000386Lbl: Label 'هاتف';
        Caption_Control1000000387Lbl: Label 'المنطقة';
        Caption_Control1000000393Lbl: Label 'المنطقة العقارية';
        Caption_Control1000000394Lbl: Label 'رقم العقار / القسم';
        e_mail_CaptionLbl: Label 'البريد الالكتروني(e-mail)';
        Caption_Control1000000399Lbl: Label 'رقم';
        Caption_Control1000000400Lbl: Label 'قضاء';
        Caption_Control1000000401Lbl: Label 'منطقة - بلدة';
        Caption_Control1000000402Lbl: Label 'الحي';
        Caption_Control1000000407Lbl: Label 'محافظة';
        Caption_Control1000000408Lbl: Label 'الشارع';
        Caption_Control1000000409Lbl: Label 'المبنى';
        EmptyStringCaption_Control1000000410Lbl: Label 'صندوق البريد';
        Caption_Control1000000411Lbl: Label 'عنوان السكن';
        Caption_Control1000000412Lbl: Label '**';
        Caption_Control1000000431Lbl: Label 'أو سبب رفض التسجيل';
        Caption_Control1000000432Lbl: Label 'التاريخ';
        Caption_Control1000000433Lbl: Label 'تاريخ التسجيل';
        EmptyStringCaption_Control1000000435Lbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000440Lbl: Label 'افادة';
        Caption_Control1000000441Lbl: Label 'خاص بالادارة';
        Caption_Control1000000442Lbl: Label 'اسم صاحب العمل';
        Caption_Control1000000443Lbl: Label 'الصفة';
        Caption_Control1000000444Lbl: Label 'التوقيع';
        Caption_Control1000000448Lbl: Label 'في المربع المناسب';
        xCaptionLbl: Label 'x';
        Caption_Control1000000450Lbl: Label '"توضع علامة "';
        Caption_Control1000000451Lbl: Label '**';
        Caption_Control1000000452Lbl: Label '-';
        Caption_Control1000000453Lbl: Label '-';
        Caption_Control1000000454Lbl: Label '*';
        Caption_Control1000000007Lbl: Label '"الشهرة التجارية "';
        Caption_Control1000000015Lbl: Label 'مستخدم / أجير جديد';
        V3Caption_Control1000000017Lbl: Label 'ر 3';
        Caption_Control1000000018Lbl: Label '"طلب تســـــــجيل "';
        EmptyStringCaption_Control1000000022Lbl: Label 'مديرية الواردات - ضريبة الرواتب والاجور';
        Caption_Control1000000023Lbl: Label 'اسم الشركة / المؤسسة';
        Caption_Control1000000024Lbl: Label 'رقم تسجيل الشركة / المؤسسة';
        EmptyStringCaption_Control1000000025Lbl: Label 'مديرية المالية العامة';
        EmptyStringCaption_Control1000000026Lbl: Label 'وزارة المالية';
        EmptyStringCaption_Control1000000027Lbl: Label 'الجمهورية اللبنانية';
        EmptyStringCaption_Control1000000028Lbl: Label '(لدى وزارة المالية)';
        EmptyStringCaption_Control1000000031Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000057Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000058Lbl: Label 'اليوم';
        EmptyStringCaption_Control1000000063Lbl: Label 'اليوم';
        EmptyStringCaption_Control1000000064Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000074Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000077Lbl: Label 'اليوم';
        EmptyStringCaption_Control1000000078Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000079Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000030Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000044Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000059Lbl: Label 'اليوم';
        EmptyStringCaption_Control1000000060Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000061Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000062Lbl: Label 'اليوم';
}

