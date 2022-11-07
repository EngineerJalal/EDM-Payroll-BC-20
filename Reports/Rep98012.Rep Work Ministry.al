report 98012 "Rep Work Ministry"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Rep Work Ministry.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = SORTING("No.") WHERE("Labor Type"=FILTER(<>Driver));
            RequestFilterFields = "No.";
            column(ArabicDistrict;Employee."Arabic Registeration Place")
            {
            }
            column(ArabicGender;ArabicGender)
            {
            }
            column(COMPANYAddress;CompanyInformation."Arabic Building")
            {
            }
            column(COMPANYArabicElimination;CompanyInformation."Arabic Governorate")
            {
            }
            column(COMPANYNAME;CompanyInformation."Arabic Name")
            {
            }
            column(COMPANYOwner;CompanyInformation."Company Owner")
            {
            }
            column(COMPANYPhoneNo;CompanyInformation."Phone No.")
            {
            }
            column(COMPANYREGISTERNO;CompanyInformation."VAT Registration No.")
            {
            }
            column(Employee__Arabic_Nationality_;"Arabic Nationality")
            {
            }
            column(Employee__Basic_Pay_;"Basic Pay")
            {
            }
            column(Employee__Birth_Date_;"Birth Date")
            {
            }
            column(Employee__High_Cost_of_Living_;"Accommodation Type")
            {
            }
            column(Employee_Employee__Arabic_Elimination__Control1;Employee."Arabic Elimination")
            {
            }
            column(Employee_Employee__Arabic_Job_Title_;Employee."Arabic Job Title")
            {
            }
            column(Employee_Employee__Employment_Date_;Employee."Employment Date")
            {
            }
            column(Employee_Employee__Register_No__;Employee."Register No.")
            {
            }
            column(Employee_Employee__Termination_Date_;Employee."Termination Date")
            {
            }
            column(Employee_No_;"No.")
            {
            }
            column(Governate;Employee."Arabic Governorate")
            {
            }
            column(MinistryCaption;MinistryCaptionLbl)
            {
            }
            column(VarDate;VarDate)
            {
            }
            column(VarFullName;VarFullName)
            {
            }
            column(VarLineNo;VarLineNo)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Employee.Status= Employee.Status::Terminated then
                begin
                  if (Employee."Termination Date" < VarDate) then
                    CurrReport.SKIP;
                end;


                VarFullName:=Employee."Arabic Name";
                if Employee.Gender=Employee.Gender::Male then
                  ArabicGender:='ذ'
                else
                  if Employee.Gender=Employee.Gender::Female then
                   ArabicGender:='أ'
                  else
                    ArabicGender:='';
                VarLineNo:=VarLineNo+1;
            end;

            trigger OnPreDataItem();
            begin
                //EDM+
                /*UserSetup.SETRANGE("User ID",USERID);
                IF UserSetup.FINDFIRST THEN BEGIN
                 IF UserSetup."Show Salary"=TRUE THEN
                 BEGIN
                  IF UserSetup."Payroll Group Code"<>'' THEN
                  BEGIN
                    FILTERGROUP(2);
                    SETFILTER("Payroll Group Code",'%1',UserSetup."Payroll Group Code");
                  END
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
                //Caption = 'Filter';
                group("Date Filter")
                {
                    Caption = 'Date Filter';
                    field(VarDate;VarDate)
                    {
                        Caption = 'Date';
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
        CompanyInformation.GET;
    end;

    var
        VarFullName : Text[150];
        VarLineNo : Integer;
        VarDate : Date;
        ArabicGender : Text[20];
        UserSetup : Record "User Setup";
        CompanyInformation : Record "Company Information";
        MinistryCaptionLbl : TextConst ENU='الجمهورية اللبنانية وزارة العمل',ENG='Employee';
        "ك__او_ان_ىCaptionLbl" : Label 'ذكر او انثى';
        "ال_ن_ي_CaptionLbl" : Label 'الجنسية';
        "ال_ا_ي_CaptionLbl" : Label 'التاريخ';
        "نوع_عمل_الا_ي_CaptionLbl" : Label 'نوع عمل الاجير';
        "V2_الا__CaptionLbl" : Label '(2)الاجر';
        "ا_ي____ول_العملCaptionLbl" : Label 'تاريخ دخول العمل';
        "ا_م_الا_ي_CaptionLbl" : Label 'اسم الاجير';
        "الق_ي_CaptionLbl" : Label 'القرية';
        "القضا_CaptionLbl" : Label 'القضاء';
        "الم_افظ_CaptionLbl" : Label 'المحافظة';
        "قم_ال__لCaptionLbl" : Label 'رقم السجل';
        "يان__ا_ما__الم____مين_ل_ن_CaptionLbl" : Label 'بيان باسماء المستخدمين لسنة';
        "م_الم____CaptionLbl" : Label 'إسم المؤسسة';
        "م__ا___الم____CaptionLbl" : Label 'إسم صاحب المؤسسة';
        "قم__الم____CaptionLbl" : Label '" رقم  المؤسسة"';
        "العنوانCaptionLbl" : Label 'العنوان';
        "نوع_العملCaptionLbl" : Label 'نوع العمل';
        "الم_افظ_Caption_Control1000000039Lbl" : Label 'المحافظة';
        "قم_الها_فCaptionLbl" : Label 'رقم الهاتف';
        "قم_الم__ل_لCaptionLbl" : Label 'رقم المتسلسل';
        "ا_ي__وم_ل_الولا_____و___ط_ق_الا_ل_عن___ك___الهوي_CaptionLbl" : Label '(تاريخ ومحل الولادة (صورة طبق الاصل عن تذكرة الهوية';
        "قم__ف___الا____امCaptionLbl" : Label 'رقم دفتر الاستخدام';
        "ا_ي____ك_العملCaptionLbl" : Label 'تاريخ ترك العمل';
        "وقيع_الا_ي_CaptionLbl" : Label 'توقيع الاجير';
        "ملا_ظا_CaptionLbl" : Label 'ملاحظات';
        "ا_ي___ق_يم_الطل__CaptionLbl" : Label '"تاريخ تقديم الطلب "';
        "وقيع__ا___الم____CaptionLbl" : Label 'توقيع صاحب المؤسسة';
        "ي__ك_لل_ائ__CaptionLbl" : Label 'يترك للدائرة';
        "ي___وضع_قيم__الا___الكامل_و_ك__ما___ا_كان_يوميا_او_ا__وعيا_او__ه_ياCaptionLbl" : Label 'يجب وضع قيمة الاجر الكامل وذكر ما إذا كان يوميا او اسبوعيا او شهريا';
        V1_CaptionLbl : Label '(1)';
        V2_CaptionLbl : Label '(2)';
}

