report 98019 "تصريح عن استخدام اجير"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/تصريح عن استخدام اجير.rdl';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(Text000;Text000)
            {
            }
            column(Text001;Text001)
            {
            }
            column(Text002;Text002)
            {
            }
            column(Text003;Text003)
            {
            }
            column(Gender_2_;GenderEmp[2])
            {
            }
            column(Gender_1_;GenderEmp[1])
            {
            }
            column(EmployeeArabicFirstName;Employee."Arabic First Name")
            {
            }
            column(EmployeeArabicName;Employee."Arabic Name")
            {
            }            
            column(EmployeeArabicLastName;Employee."Arabic Last Name")
            {
            }
            column(EmployeeArabicMiddleName;Employee."Arabic Middle Name")
            {
            }
            column(EmployeeArabicMotherName;Employee."Arabic Mother Name")
            {
            }
            column(EmployeeArabicPlaceofBirth;Employee."Arabic Place of Birth")
            {
            }
            column(EmployeeBirthDate;Employee."Birth Date")
            {
            }
            column(EmployeeArabicElimination;Employee."Arabic Elimination")
            {
            }
            column(EmployeeRegisterNo;Employee."Register No.")
            {
            }
            column(SocialStatus5;SocialStatus[5])
            {
            }
            column(SocialStatus4;SocialStatus[4])
            {
            }
            column(SocialStatus3;SocialStatus[3])
            {
            }
            column(SocialStatus2;SocialStatus[2])
            {
            }
            column(SocialStatus1;SocialStatus[1])
            {
            }
            column(EmployeeArabicGovernorate;Employee."Arabic Governorate")
            {
            }
            column(EmployeeArabicCity;Employee."Arabic City")
            {
            }
            column(EmployeeArabicDistrict;Employee."Arabic District")
            {
            }
            column(EmployeeArabicStreet;Employee."Arabic Street")
            {
            }
            column(EmployeeArabicBuilding;Employee."Arabic Building")
            {
            }
            column(EmployeeArabicFloor;Employee."Arabic Floor")
            {
            }
            column(EmployeePhoneNo;Employee."Phone No.")
            {
            }
            column(EmployeeEmploymentDate;Employee."Employment Date")
            {
            }
            column(EmployeeArabicJobTitle;Employee."Arabic Job Title")
            {
            }
            column(EmployeeBasicPay;Employee."Basic Pay")
            {
            }
            column(CompanyAdressDetails;CompanyInfo."Arabic City"+'  '+CompanyInfo."Arabic Street"+'  '+CompanyInfo."Arabic Building"+'  '+CompanyInfo."Arabic Floor")
            {
            }
            column(CompanyInfoArabicComercialCity;CompanyInfo."Arabic Comercial City")
            {
            }
            column(CompanyInfoCommercialNo;CompanyInfo."Commercial No.")
            {
            }
            column(CompanyInfoArabicName;CompanyInfo."Arabic Name")
            {
            }
            column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
            {
            }
            column(MonthlyPay;MonthlyPay)
            {
            }
            column(CompanyInfoCompanyOwner;CompanyInfo."Company Owner")
            {
            }
            column(InvDate;InvDate)
            {
            }
            column(CompanyInfoRegistrationNo;CompanyInfo."Registration No.")
            {
            }
            column(WeeklyPay;WeeklyPay)
            {
            }
            column(ArabicAmount;ArabicAmount[1])
            {
            }
            column(MonthHours;MonthHours)
            {
            }
            column(ArabicName;"Arabic Name")
            {
            }
            column(Employee_No_;"No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                //Social Status
                if Employee."Social Status"=Employee."Social Status"::Divorced then
                 begin
                   SocialStatus[1]:='';
                   SocialStatus[2]:='';
                   SocialStatus[3]:='';
                   SocialStatus[4]:='x';
                 end
                else
                 if Employee."Social Status"=Employee."Social Status"::Married then
                 begin
                  SocialStatus[1]:='';
                  SocialStatus[2]:='x';
                  SocialStatus[3]:='';
                  SocialStatus[4]:='';
                  SocialStatus[5]:='';
                 end
                 else
                  if Employee."Social Status"=Employee."Social Status"::Widow then
                  begin
                    SocialStatus[1]:='';
                    SocialStatus[2]:='';
                    SocialStatus[3]:='x';
                    SocialStatus[4]:='';
                    SocialStatus[5]:='';
                  end
                  else if Employee."Social Status"=Employee."Social Status"::Separated then
                  begin
                    SocialStatus[1]:='';
                    SocialStatus[2]:='';
                    SocialStatus[3]:='';
                    SocialStatus[4]:='';
                    SocialStatus[5]:='x';
                  end
                  else
                    begin
                      SocialStatus[1]:='x';
                      SocialStatus[2]:='';
                      SocialStatus[3]:='';
                      SocialStatus[4]:='';
                      SocialStatus[5]:='';
                    end;
                //Gender
                if Employee.Gender=Employee.Gender::Female then
                 begin
                  GenderEmp[1]:='';
                  GenderEmp[2]:='x';
                 end
                else
                begin
                 GenderEmp[1]:='x';
                 GenderEmp[2]:='';
                end;


                //Pay Freq
                if Employee."Pay Frequency"=Employee."Pay Frequency"::Monthly then
                MonthlyPay:='x'
                else
                 WeeklyPay:='x';
                //ArabicAmountToText.FormatNoText(ArabicAmount,"Basic Pay",'');
                HRSetup.GET;
                MonthHours:=HRSetup."Monthly Hours";
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
                group(Control1000000001)
                {
                    Caption = 'Report Date';
                    field(InvDate;InvDate)
                    {
                        Caption = 'تاريخ التقرير';
                        ApplicationArea=All;
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
        CompanyInfo.GET;
    end;

    var
        Text000 : Label '"كل صاحب عمل يغفل التصريح عن اجرائه ضمن مهلة (15) يوماً من تاريخ الاستخدام أو يتقدم بتصاريح غير صحيحة يتعرض لعقوبات الغرامة و الحبس و ذلك عملاً باحكام "';
        Text001 : Label '" المادتين 80و 81 من قانون الضمان الاجتماعي"';
        Text002 : Label '(يجب ان تطابق المعلومات الواردة أعلاه مع اخراج القيد المرفق (افرادي للأعزب - عائلي للمتأهل)';
        Text003 : Label '"تنبيه : يهمل كل طلب غير مكتوب بخط واضح و مقروء و معلومات ناقصة "';
        CompanyInfo : Record "Company Information";
        SocialStatus : array [5] of Text[1];
        GenderEmp : array [2] of Text[1];
        MonthlyPay : Text[1];
        InvDate : Date;
        WeeklyPay : Text[1];
        ArabicAmount : array [2] of Text[250];
        MonthHours : Decimal;
        HRSetup : Record "Human Resources Setup";
        xCaptionLbl : Label 'x';
}

