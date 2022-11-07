report 98015 "Payroll R4 -1"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll R4 -1.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
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
            column(CompanyInformation__Arabic_Name_; CompanyInformation."Arabic Name")
            {
            }
            column(CompanyInformation__Arabic_Trading_Name_; CompanyInformation."Arabic Trading Name")
            {
            }
            column(CompanyInformation__Registration_No__; CompanyInformation."Registration No.")
            {
            }
            column(No_Employee; Employee."No.")
            {
            }
            column(Employee_Employee__Arabic_Name_; Employee."Arabic Name")
            {
            }
            column(Employee_Employee__Arabic_First_Name_; Employee."Arabic First Name")
            {
            }
            column(Employee_Employee__Arabic_Middle_Name_; Employee."Arabic Middle Name")
            {
            }
            column(Employee_Employee__Arabic_Place_of_Birth_; Employee."Arabic Place of Birth")
            {
            }
            column(Employee_Employee__Arabic_Last_Name_; Employee."Arabic Last Name")
            {
            }
            column(Employee_Employee__Arabic_Mother_Name_; Employee."Arabic Mother Name")
            {
            }
            column(Employee_Employee__Arabic_Nationality_; Employee."Arabic Nationality")
            {
            }
            column(Employee_Employee__Arabic_Registeration_Place_; Employee."Arabic Registeration Place")
            {
            }
            column(Employee_Employee__Arabic_Building_; Employee."Arabic Building")
            {
            }
            column(Employee_Employee__Arabic_Street_; Employee."Arabic Street")
            {
            }
            column(Employee_Employee__Arabic_Governorate_; Employee."Arabic Governorate")
            {
            }
            column(Employee_Employee__Arabic_Elimination_; Employee."Arabic Elimination")
            {
            }
            column(Employee_Employee__Arabic_MailBox_Area_; Employee."Arabic MailBox Area")
            {
            }
            column(Employee_Employee__Arabic_Floor_; Employee."Arabic Floor")
            {
            }
            column(Employee_Employee__Arabic_Land_Area_; Employee."Arabic Land Area")
            {
            }
            column(Employee_Employee__Arabic_District_; Employee."Arabic District")
            {
            }
            column(Employee_Employee__Government_ID_No__; Employee."Government ID No.")
            {
            }
            column(Employee_Employee__Register_No__; Employee."Register No.")
            {
            }
            column(Employee_Employee__Mailbox_ID_; Employee."Mailbox ID")
            {
            }
            column(Employee_Employee__E_Mail_; Employee."E-Mail")
            {
            }
            column(Employee_Employee__No_of_Children_; Employee."No of Children")
            {
            }
            column(Employee_Employee__Arabic_City_; Employee."Arabic City")
            {
            }
            column(Employee_Employee__Phone_No__; Employee."Phone No.")
            {
            }
            column(Employee_Employee__Arabic_Land_Area__No__; Employee."Arabic Land Area  No.")
            {
            }
            column(Employee_Employee__Fax_No__; Employee."Fax No.")
            {
            }
            column(Employee_Employee__Mobile_Phone_No__; Employee."Mobile Phone No.")
            {
            }
            column(RegisterNo_Employee; Employee."Register No.")
            {
            }
            column(GovernmentIDNo_Employee; Employee."Government ID No.")
            {
            }
            column(EmployeeRelative__Personal_Register_No__; EmployeeRelative."Personal Register No.")
            {
            }
            column(Nationality; Nationality)
            {
            }
            column(Working_1_; Working[1])
            {
            }
            column(Working_2_; Working[2])
            {
            }
            column(RelativeCompanyName; RelativeCompanyName)
            {
            }
            column(Fname; Fname)
            {
            }
            column(Mname; Mname)
            {
            }
            column(Lname; Lname)
            {
            }
            column(IDNb; IDNb)
            {
            }
            column(PlaceOfBirth; PlaceOfBirth)
            {
            }
            column(MotherName; MotherName)
            {
            }
            column(RelativeFinanceNb; RelativeFinanceNb)
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
            column(EmpYearOfBirth; EmpYearOfBirth)
            {
            }
            column(EmpMonthOfBirth; EmpMonthOfBirth)
            {
            }
            column(EmpDayOfBirth; EmpDayOfBirth)
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
            column(MonthlyPay; MonthlyPay)
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
            column("Count"; COUNT)
            {
            }
            column(CompRegNo; CompRegNo)
            {
            }
            column(EmpRegNo; EmpRegNo)
            {
            }
            column(RelRegNo; RelRegNo)
            {
            }
            column(EmpFName; EmpFName)
            {
            }
            column(EmpMName; EmpMName)
            {
            }
            column(EmpLName; EmpLName)
            {
            }
            column(EmploymentDate_Employee; Employee."Employment Date")
            {
            }
            column(VAL; VAL)
            {
            }
            column(RelExempt; RelExempt)
            {
            }
            dataitem("Employee Relative"; "Employee Relative")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                column(ArabicFirstName_EmployeeRelative; "Employee Relative"."Arabic First Name")
                {
                }
                column(ArabicLastName_EmployeeRelative; "Employee Relative"."Arabic Last Name")
                {
                }
                column(Student_EmployeeRelative; "Employee Relative".Student)
                {
                }
                column(Sex_EmployeeRelative; "Employee Relative".Sex)
                {
                }
                column(SocialStatus_EmployeeRelative; "Employee Relative"."Social Status")
                {
                }
                column(BirthDate_EmployeeRelative; "Employee Relative"."Birth Date")
                {
                }
                column(RelativeCode_EmployeeRelative; "Employee Relative"."Relative Code")
                {
                }
                column(ArabicGender_EmployeeRelative; "Employee Relative"."Arabic Gender")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PayParam.GET;
                    VAL += 1;
                    "Employee Relative".CALCFIELDS("Employee Relative".Type);
                    if ("Employee Relative".Type = "Employee Relative".Type::Husband) or ("Employee Relative".Type = "Employee Relative".Type::Wife) then
                        if (((Employee.Gender = Employee.Gender::Male) and (not Employee."Spouse Secured")) or ((Employee.Gender = Employee.Gender::Female) and (Employee."Husband Paralyzed"))) then
                            RelExempt := PayParam."Tax Exempt P/Y NonWork Spouse";

                    if (Employee."Spouse Secured") and ("Employee Relative".Type = "Employee Relative".Type::Child) and ("Employee Relative"."Eligible Exempt Tax") then
                        RelExempt := PayParam."Tax Exempt P/Y Per Child" / 2;
                    if (not Employee."Spouse Secured") and ("Employee Relative".Type = "Employee Relative".Type::Child) and ("Employee Relative"."Eligible Exempt Tax") then
                        RelExempt := PayParam."Tax Exempt P/Y Per Child";
                end;

                trigger OnPreDataItem();
                begin
                    "Employee Relative".SETRANGE("Employee Relative"."Eligible Exempt Tax", true);
                end;
            }

            trigger OnAfterGetRecord();
            var
                i: Integer;
            begin
                Fname := '';
                Mname := '';
                Lname := '';
                MotherName := '';
                Nationality := '';
                PlaceOfBirth := '';
                IDNb := '';
                RelDayOfBirth := 0;
                RelMonthOfBirth := 0;
                RelYearOfBirth := 0;
                RelativeCompanyName := '';
                RelativeFinanceNb := '';
                RelativeCompanyName := '';
                RelativeFinanceNb := '';
                Working[1] := '';
                Working[2] := '';
                EmpDayOfBirth := 0;
                EmpMonthOfBirth := 0;
                EmpYearOfBirth := 0;
                EmpDateDay := 0;
                EmpDateMonth := 0;
                EmpDateYear := 0;
                GenderEmp[1] := '';
                GenderEmp[2] := '';
                SocialStatus[1] := '';
                SocialStatus[2] := '';
                SocialStatus[3] := '';
                SocialStatus[4] := '';
                ChildNo := 0;
                MonthlyPay := '';
                VAL := 0;
                RelExempt := 0;
                if Employee."Arabic First Name" <> '' then
                    EmpFName := Employee."Arabic First Name"
                else
                    EmpFName := Employee."First Name";

                if Employee."Arabic Middle Name" <> '' then
                    EmpMName := Employee."Arabic Middle Name"
                else
                    EmpMName := Employee."Middle Name";

                if Employee."Arabic Last Name" <> '' then
                    EmpLName := Employee."Arabic Last Name"
                else
                    EmpLName := Employee."Last Name";


                EmpRegNo := '';
                for i := 1 to 9 do begin
                    if COPYSTR(Employee."Register No.", i, 1) <> '' then
                        EmpRegNo := EmpRegNo + ' | ' + COPYSTR(Employee."Register No.", i, 1)
                    else
                        EmpRegNo := EmpRegNo + ' |  '
                end;

                //BirthDate
                if Employee."Birth Date" <> 0D then begin
                    EmpDayOfBirth := DATE2DMY(Employee."Birth Date", 1);
                    EmpMonthOfBirth := DATE2DMY(Employee."Birth Date", 2);
                    EmpYearOfBirth := DATE2DMY(Employee."Birth Date", 3);
                end;
                if Employee."Employment Date" <> 0D then begin
                    EmpDateDay := DATE2DMY(Employee."Employment Date", 1);
                    EmpDateMonth := DATE2DMY(Employee."Employment Date", 2);
                    EmpDateYear := DATE2DMY(Employee."Employment Date", 3);
                end;

                //Gender
                if Employee.Gender = Employee.Gender::Male then
                    GenderEmp[1] := 'x'
                else
                    GenderEmp[2] := 'x';

                //Social Status
                if Employee."Social Status" = Employee."Social Status"::Divorced then
                    SocialStatus[4] := 'x'
                else
                    if Employee."Social Status" = Employee."Social Status"::Married then
                        SocialStatus[2] := 'x'
                    else
                        if Employee."Social Status" = Employee."Social Status"::Widow then
                            SocialStatus[3] := 'x'
                        else
                            if Employee."Social Status" = Employee."Social Status"::Widow then
                                SocialStatus[1] := 'x';

                //Husband Or Wife Data
                EmployeeRelative.RESET;

                EmployeeRelative.SETRANGE(EmployeeRelative."Employee No.", Employee."No.");
                if EmployeeRelative.FINDFIRST then
                    repeat
                        EmployeeRelative.CALCFIELDS(Type);
                        if (EmployeeRelative.Type = EmployeeRelative.Type::Husband) or (EmployeeRelative.Type = EmployeeRelative.Type::Wife) then begin
                            Fname := EmployeeRelative."Arabic First Name";
                            Mname := EmployeeRelative."Arabic Middle Name";
                            Lname := EmployeeRelative."Arabic Last Name";
                            MotherName := EmployeeRelative."Arabic Mother Name";
                            Nationality := EmployeeRelative."Arabic Nationality";
                            PlaceOfBirth := EmployeeRelative."Arabic Place Of Birth";
                            IDNb := EmployeeRelative."ID No.";
                            if EmployeeRelative."Birth Date" <> 0D then begin
                                RelDayOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 1);
                                RelMonthOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 2);
                                RelYearOfBirth := DATE2DMY(EmployeeRelative."Birth Date", 3);
                            end;
                            RelativeCompanyName := EmployeeRelative."Arabic Company Name";
                            RelativeCompanyName := EmployeeRelative."Arabic Company Name";
                            RelativeFinanceNb := EmployeeRelative."Finance Register No.";
                            if EmployeeRelative.Working then
                                Working[1] := 'x'
                            else
                                Working[2] := 'x';

                            RelRegNo := '';
                            for i := 1 to 9 do begin
                                if COPYSTR(EmployeeRelative."Finance Register No.", i, 1) <> '' then
                                    RelRegNo := RelRegNo + ' | ' + COPYSTR(EmployeeRelative."Finance Register No.", i, 1)
                                else
                                    RelRegNo := RelRegNo + ' |  '
                            end;
                        end;
                    until EmployeeRelative.NEXT = 0
                else
                    for i := 1 to 9 do begin
                        RelRegNo := RelRegNo + ' |  '
                    end;
                //Number Of Child
                Employee.CALCFIELDS("No of Children");

                //Pay Freq
                if Employee."Pay Frequency" = Employee."Pay Frequency"::Monthly then
                    MonthlyPay := 'x';


                //Invoice Date
                if InvoiceDate <> 0D then begin
                    InvDay := DATE2DMY(InvoiceDate, 1);
                    InvMonth := DATE2DMY(InvoiceDate, 2);
                    InvYear := DATE2DMY(InvoiceDate, 3);
                end;
            end;

            trigger OnPreDataItem();
            begin
                Employee.SETRANGE(Declared, Employee.Declared::Declared);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    var
        i: Integer;
    begin
        CompanyInformation.GET;
        CompRegNo := '';

        for i := 1 to 9 do begin
            if COPYSTR(CompanyInformation."Registration No.", i, 1) <> '' then
                CompRegNo := CompRegNo + ' | ' + COPYSTR(CompanyInformation."Registration No.", i, 1)
            else
                CompRegNo := CompRegNo + ' |  '
        end;
    end;

    var
        Text000: Label '"أنا الموقع أدناه أشهد بصدق و صحة المعلومات التي ينطوي عليها هذا البيان "';
        CompanyInformation: Record "Company Information";
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
        BirthDate: Date;
        MonthlyPay: Text[1];
        Working: array[2] of Text[1];
        RelativeCompanyName: Text[30];
        RelativeFinanceNb: Code[20];
        RelativePersonalNb: Code[20];
        Text001: Label 'يبقى هذا النموذج في عهدة صاحب العمل و يبرز عند الطلب من قبل مراقبي ضريبة الدخل في وزارة المالية';
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
        CaptionLbl: Label 'في حال نعم اذكر الرقم';
        Caption_Control1000000101Lbl: Label '"الشهرة "';
        Caption_Control1000000102Lbl: Label 'اسم الأم و شهرتها قبل الزواج';
        Caption_Control1000000103Lbl: Label 'الجنسية';
        Caption_Control1000000104Lbl: Label 'تاريخ الولادة';
        V2CaptionLbl: Label '-2';
        V4CaptionLbl: Label '-4';
        V6CaptionLbl: Label '-6';
        V8CaptionLbl: Label '-8';
        Caption_Control1000000114Lbl: Label 'لا';
        Caption_Control1000000116Lbl: Label '"نعم "';
        Caption_Control1000000118Lbl: Label 'هل لديه رقم مالي شخصي ؟';
        EmptyStringCaptionLbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000125Lbl: Label 'تعريــــــف';
        Caption_Control1000000126Lbl: Label '"الاسم "';
        Caption_Control1000000127Lbl: Label 'اسم الأب';
        Caption_Control1000000128Lbl: Label 'الجنس';
        Caption_Control1000000129Lbl: Label 'محل الولادة';
        Caption_Control1000000131Lbl: Label 'الوضع العائلي';
        Caption_Control1000000133Lbl: Label '*';
        Caption_Control1000000134Lbl: Label '*';
        V1CaptionLbl: Label '-1';
        V3CaptionLbl: Label '-3';
        V5CaptionLbl: Label '-5';
        V7CaptionLbl: Label '-7';
        V12CaptionLbl: Label '-12';
        Caption_Control1000000145Lbl: Label 'نوع الأجر';
        Caption_Control1000000146Lbl: Label '*';
        V13CaptionLbl: Label '-13';
        Caption_Control1000000149Lbl: Label 'عدد الأولاد الذين هم';
        Caption_Control1000000150Lbl: Label 'على عاتق المستخدم';
        V14CaptionLbl: Label '-14';
        Caption_Control1000000017Lbl: Label 'ذكر';
        Caption_Control1000000019Lbl: Label 'انثى';
        Caption_Control1000000028Lbl: Label 'رقم بطاقة الهوية';
        V11CaptionLbl: Label '-11';
        Caption_Control1000000031Lbl: Label '"مكان السجل "';
        V10CaptionLbl: Label '-10';
        Caption_Control1000000034Lbl: Label 'رقم السجل';
        V9CaptionLbl: Label '-9';
        Caption_Control1000000036Lbl: Label 'مطلق';
        Caption_Control1000000038Lbl: Label '"ارمل "';
        Caption_Control1000000040Lbl: Label 'متزوج';
        Caption_Control1000000042Lbl: Label 'اعزب';
        Caption_Control1000000235Lbl: Label 'التاريخ';
        Caption_Control1000000236Lbl: Label 'التوقيع';
        Caption_Control1000000237Lbl: Label 'اسم المستخدم / الأجير';
        Caption_Control1000000239Lbl: Label 'افادة';
        Caption_Control1000000000Lbl: Label 'في المربع الناسب';
        xCaptionLbl: Label 'x';
        Caption_Control1000000002Lbl: Label '"توضع علامة "';
        Caption_Control1000000003Lbl: Label '*';
        Caption_Control1000000005Lbl: Label '-';
        e_mail_CaptionLbl: Label 'البريد الالكتروني(e-mail)';
        Caption_Control1000000093Lbl: Label 'المبنى';
        EmptyStringCaption_Control1000000094Lbl: Label 'صندوق البريد';
        Caption_Control1000000095Lbl: Label 'الشارع';
        Caption_Control1000000096Lbl: Label 'محافظة';
        Caption_Control1000000097Lbl: Label 'عنوان السكن';
        Caption_Control1000000100Lbl: Label '-ب';
        Caption_Control1000000105Lbl: Label 'في الادارات العامة';
        Caption_Control1000000106Lbl: Label 'اسم الشركة / المؤسسة';
        Caption_Control1000000107Lbl: Label 'في القطاع الخاص او في مؤسسة';
        Caption_Control1000000108Lbl: Label '-أ';
        EmptyStringCaption_Control1000000113Lbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000115Lbl: Label 'رقم التسجيل الشخصي';
        Caption_Control1000000117Lbl: Label 'هل الزوج / الزوجة يعمل ؟';
        V10Caption_Control1000000119Lbl: Label '-10';
        Caption_Control1000000120Lbl: Label 'عدد الأشخاص الذين';
        V9Caption_Control1000000121Lbl: Label '-9';
        Caption_Control1000000123Lbl: Label '**';
        Caption_Control1000000124Lbl: Label 'تاريخ الولادة';
        V7Caption_Control1000000130Lbl: Label '-7';
        Caption_Control1000000132Lbl: Label 'الجنسية';
        V5Caption_Control1000000139Lbl: Label '-5';
        Caption_Control1000000152Lbl: Label 'رقم';
        Caption_Control1000000154Lbl: Label 'العامة/المصلحة المستقلة';
        Caption_Control1000000157Lbl: Label 'يستفيدون من التنزيل العائلي';
        Caption_Control1000000158Lbl: Label 'اسم الادارة';
        Caption_Control1000000160Lbl: Label '*';
        Caption_Control1000000163Lbl: Label 'عامة / مصلحة مستقلة';
        Caption_Control1000000164Lbl: Label 'قضاء';
        Caption_Control1000000167Lbl: Label '"نعم "';
        Caption_Control1000000169Lbl: Label 'الطابق';
        Caption_Control1000000170Lbl: Label 'المنطقة';
        Caption_Control1000000176Lbl: Label 'المنطقة العقارية';
        Caption_Control1000000177Lbl: Label 'لا';
        V8Caption_Control1000000179Lbl: Label '-8';
        V6Caption_Control1000000180Lbl: Label '-6';
        Caption_Control1000000181Lbl: Label 'في حال نعم اذكر';
        Caption_Control1000000182Lbl: Label 'منطقة - بلدة';
        Caption_Control1000000183Lbl: Label 'رقم بطاقة الهوية';
        Caption_Control1000000184Lbl: Label 'محل الولادة';
        Caption_Control1000000186Lbl: Label 'اسم الأم و شهرتها قبل الزواج';
        V4Caption_Control1000000187Lbl: Label '-4';
        V3Caption_Control1000000188Lbl: Label '-3';
        Caption_Control1000000189Lbl: Label 'اسم الأب';
        Caption_Control1000000191Lbl: Label 'هاتف';
        Caption_Control1000000192Lbl: Label 'الشهرة قبل الزواج';
        V2Caption_Control1000000193Lbl: Label '-2';
        V1Caption_Control1000000195Lbl: Label '-1';
        Caption_Control1000000196Lbl: Label 'اسم الزوج / الزوجة';
        Caption_Control1000000198Lbl: Label 'معلومات خاصة بالزوج / الزوجة';
        Caption_Control1000000200Lbl: Label 'رقم التسجيل';
        EmptyStringCaption_Control1000000205Lbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000206Lbl: Label 'الحي';
        Caption_Control1000000207Lbl: Label 'فاكس';
        Caption_Control1000000208Lbl: Label 'هاتف';
        Caption_Control1000000228Lbl: Label 'رقم العقار / القسم';
        Caption_Control1000000089Lbl: Label '"الشهرة التجارية "';
        EmptyStringCaption_Control1000000085Lbl: Label '(لدى وزارة المالية)';
        Caption_Control1000000084Lbl: Label 'رقم التسجيل';
        Caption_Control1000000090Lbl: Label 'اسم الشركة / المؤسسة';
        Caption_Control1000000007Lbl: Label 'مديرية الواردات';
        Caption_Control1000000014Lbl: Label '"مديرية المالية العامة "';
        Caption_Control1000000013Lbl: Label 'وزارة الماليـــــــة';
        Caption_Control1000000006Lbl: Label 'ضريبة الرواتب و الأجور';
        Caption_Control1000000012Lbl: Label '"الجمهورية اللبنانية "';
        Caption_Control1000000011Lbl: Label '/بيان معلومات من المستخدم';
        Caption_Control1000000010Lbl: Label 'الأجير الى رب العمل';
        V4Caption_Control1000000009Lbl: Label 'ر4';
        EmptyStringCaption_Control1000000026Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000056Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000058Lbl: Label 'اليوم';
        EmptyStringCaption_Control1000000060Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000062Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000064Lbl: Label 'اليوم';
        EmptyStringCaption_Control1000000065Lbl: Label '" السنة"';
        EmptyStringCaption_Control1000000066Lbl: Label 'الشهر';
        EmptyStringCaption_Control1000000067Lbl: Label 'اليوم';
        Caption_Control1000000072Lbl: Label 'شهري';
        Caption_Control1000000074Lbl: Label 'يومي';
        Caption_Control1000000076Lbl: Label 'بالساعة';
        VAL: Integer;
        CompRegNo: Text;
        EmpRegNo: Text;
        RelRegNo: Text;
        EmpFName: Text;
        EmpMName: Text;
        EmpLName: Text;
        PayParam: Record "Payroll Parameter";
        RelExempt: Decimal;
}

