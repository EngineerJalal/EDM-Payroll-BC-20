report 98020 "اعلام عن استخدام اجير"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/اعلام عن استخدام اجير.rdl';

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
            column(CompanyInfoArabicName;CompanyInfo."Arabic Name")
            {
            }
            column(CompanyInfoRegistrationNo;CompanyInfo."Registration No.")
            {
            }
            column(CompanyInfoArabicComercialCity;CompanyInfo."Arabic Comercial City")
            {
            }
            column(CompanyInfoCommercialNo;CompanyInfo."Commercial No.")
            {
            }
            column(CompanyAddressDetails;CompanyInfo."Arabic City"+'  '+CompanyInfo."Arabic Street"+'  '+CompanyInfo."Arabic Building"+'  '+CompanyInfo."Arabic Floor")
            {
            }
            column(EmployeeArabicFirstName;Employee."Arabic First Name")
            {
            }
            column(EmployeeArabicLastName;Employee."Arabic Last Name")
            {
            }
            column(EmployeeNSSFNo;Employee."Social Security No.")
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
            column(EmployeeRegisterNo;Employee."Register No.")
            {
            }
            column(EmployeeArabicNationality;Employee."Arabic Nationality")
            {
            }
            column(EmployeeArabicName;Employee."Arabic Name")
            {
            }
            column(Gender2;GenderEmp[2])
            {
            }
            column(Gender1;GenderEmp[1])
            {
            }
            column(EmployeeArabicJobTitle;Employee."Arabic Job Title")
            {
            }
            column(EmployeeBasicPay;Employee."Basic Pay")
            {
            }
            column(MonthlyPay;MonthlyPay)
            {
            }
            column(EmployeeNSSFDate;Employee."NSSF Date")
            {
            }
            column(CompanyInfoCompanyOwner;CompanyInfo."Company Owner")
            {
            }
            column(InvoiceDate;InvoiceDate)
            {
            }
            column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
            {
            }
            column(WeeklyPay;WeeklyPay)
            {
            }
            column(LastCompany;LastCompany)
            {
            }
            column(HasAnotherJob;HasAnotherJob)
            {
            }
            column(DontHAsAnotherJob;DontHAsAnotherJob)
            {
            }
            column(MonthHours;MonthHours)
            {
            }
            column(EmployeeNo;"No.")
            {
            }
            trigger OnAfterGetRecord();
            begin
                HRSetup.GET;
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


                //IF Employee."Month of Birth Date" THEN
                //  HasAnotherJob:='x'
                //ELSE
                //    DontHAsAnotherJob:='';



                EmpHistory.SETRANGE(EmpHistory."No.","No.");
                if EmpHistory.FINDFIRST then
                  LastCompany:=EmpHistory.Company
                else
                  LastCompany:='';
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
                group(Control1000000002)
                {
                    Caption = 'Report Date';
                    field(InvoiceDate;InvoiceDate)
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
        Text000 : Label '"تملأ هذه المطبوعة و ترسل الى الصندوق الوطني الاجتماعي كلما استخدمت المؤسسة اجيراً جديداً سبق ان جرى تسجيله في الصندوق و ذلك ضمن مهلة 15 يوماً من تاريخ الاستخدام "';
        Text001 : Label 'تنبيه : يهمل كل اعلام غير مرفق باخراج قيد فردي للعازب و عائلي للمتأهل و غير مكتوب بخط واضح و مقروء و اذا كانت المعلومات ناقصة';
        CompanyInfo : Record "Company Information";
        SocialStatus : array [5] of Text[1];
        GenderEmp : array [2] of Text[1];
        MonthlyPay : Text[1];
        WeeklyPay : Text[1];
        InvoiceDate : Date;
        HRSetup : Record "Human Resources Setup";
        HasAnotherJob : Text[1];
        DontHAsAnotherJob : Text[1];
        EmpHistory : Record "Employment History";
        LastCompany : Text[100];
        MonthHours : Decimal;
}

