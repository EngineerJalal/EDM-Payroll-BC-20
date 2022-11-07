report 98021 "تصريح ترك اجير عمله"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/تصريح ترك اجير عمله.rdl';

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
            column(CompanyInfoArabicName;CompanyInfo."Arabic Name")
            {
            }
            column(CompanyInfoRegistrationNo;CompanyInfo."Registration No.")
            {
            }
            column(CompanyDetailedAddress;CompanyInfo."Arabic City"+'  '+CompanyInfo."Arabic Street"+'  '+CompanyInfo."Arabic Building"+'  '+CompanyInfo."Arabic Floor")
            {
            }
            column(CompanyInfoCommerciaNo;CompanyInfo."Commercial No.")
            {
            }
            column(CompanyInfoArabicComercialCity;CompanyInfo."Arabic Comercial City")
            {
            }
            column(EmployeeArabicFirstName;Employee."Arabic First Name")
            {
            }
            column(EmployeeArabicMiddleName;Employee."Arabic Middle Name")
            {
            }
            column(EmployeeArabicLastName;Employee."Arabic Last Name")
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
            column(SocialStatus5;SocialStatus[5])
            {
            }
            column(EmployeeArabicName;Employee."Arabic Name")
            {
            }
            column(EmployeeArabicJobTitle;Employee."Arabic Job Title")
            {
            }
            column(Gender1;GenderEmp[1])
            {
            }
            column(Gender2;GenderEmp[2])
            {
            }
            column(EmployeeNSSFNo;Employee."Social Security No.")
            {
            }
            column(InvoiceDate;InvoiceDate)
            {
            }
            column(CompanyInfoCompanyOwner;CompanyInfo."Company Owner")
            {
            }
            column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
            {
            }
            column(Estekala;Estekala)
            {
            }
            column(OverAge;OverAge)
            {
            }
            column(Sick;Sick)
            {
            }
            column(Marriage;Marriage)
            {
            }
            column(Death;Death)
            {
            }
            column(AnotherJob;AnotherJob)
            {
            }
            column(Migration;Migration)
            {
            }
            column(ArabicAmount;ArabicAmount[1])
            {
            }
            column(EmployeeTerminationDate;Employee."Termination Date")
            {
            }
            column(EmployeeNo;"No.")
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
                
                /*IF Employee."Grounds for Term. Code"='استقالة' THEN
                  Estekala:='X'
                ELSE
                  Estekala:='';
                */
                
                if Employee.Status = Employee.Status::Terminated then
                  Estekala:='X'
                else
                  Estekala:='';
                
                if Employee."End of Service Date" < TODAY then
                  OverAge:='X'
                else
                  OverAge :='';
                
                IF Employee."Grounds for Term. Code"='وفاة' THEN
                  Death:='X'
                else
                  Death:='';
                /*
                IF Employee."Grounds for Term. Code"='بلوغ السن' THEN
                 OverAge:='X'
                ELSE
                  OverAge:='';
                  */
                IF Employee."Grounds for Term. Code"='عجز' THEN
                  Sick:='X'
                else
                  Sick:='';
                
                IF Employee."Grounds for Term. Code"='زواج' THEN
                  Marriage:='X'
                else
                  Marriage:='';
                
                IF Employee."Grounds for Term. Code"='هجرة' THEN
                  Migration:='X'
                else
                  Migration:='';
                
                IF Employee."Grounds for Term. Code"='عمل أخر' THEN
                  AnotherJob:='X'
                else
                  AnotherJob:='';
                
                
                //ArabicAmountToText.FormatNoText(ArabicAmount,"Basic Pay",'');

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
        Text000 : Label 'تملأ المؤسسة هذه المطبوعة و ترسلها الى الصندوق الوطني للضمان الاجتماعي كلما ترك احد الاجراء المرتبطين بها عمله فيها';
        Text001 : Label '"مهما كان السبب و ذلك خلال (15) يوماً من تاريخ الترك المادة 80 فقرة 4 "';
        Text002 : Label 'تنبيه : تحت طائلة اهمال المطبوعة يجب دائماً ذكر رقم المؤسسة و رقم الأجير أو تاريخ ولادته بخط واضح و مقروء';
        CompanyInfo : Record "Company Information";
        SocialStatus : array [5] of Text[1];
        GenderEmp : array [2] of Text[1];
        InvoiceDate : Date;
        GrdTerm : Record "Grounds for Termination";
        DescTerm : Text[100];
        Estekala : Text[1];
        Death : Text[1];
        OverAge : Text[1];
        Sick : Text[1];
        Marriage : Text[1];
        AnotherJob : Text[1];
        Migration : Text[1];
        ArabicAmount : array [2] of Text[250];
}

