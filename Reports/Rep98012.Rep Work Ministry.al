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
                  ArabicGender:='??'
                else
                  if Employee.Gender=Employee.Gender::Female then
                   ArabicGender:='??'
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
        MinistryCaptionLbl : TextConst ENU='?????????????????? ?????????????????? ?????????? ??????????',ENG='Employee';
        "??__????_????_??CaptionLbl" : Label '?????? ???? ????????';
        "????_??_??_CaptionLbl" : Label '??????????????';
        "????_??_??_CaptionLbl" : Label '??????????????';
        "??????_??????_??????_??_CaptionLbl" : Label '?????? ?????? ????????????';
        "V2_??????__CaptionLbl" : Label '(2)??????????';
        "??_??____????_??????????CaptionLbl" : Label '?????????? ???????? ??????????';
        "??_??_??????_??_CaptionLbl" : Label '?????? ????????????';
        "??????_??_CaptionLbl" : Label '????????????';
        "??????????_CaptionLbl" : Label '????????????';
        "??????_??????_CaptionLbl" : Label '????????????????';
        "????_????__??CaptionLbl" : Label '?????? ??????????';
        "??????__??_????__??????____??????_??_??_CaptionLbl" : Label '???????? ???????????? ???????????????????? ????????';
        "??_??????____CaptionLbl" : Label '?????? ??????????????';
        "??__??___??????____CaptionLbl" : Label '?????? ???????? ??????????????';
        "????__??????____CaptionLbl" : Label '" ??????  ??????????????"';
        "??????????????CaptionLbl" : Label '??????????????';
        "??????_??????????CaptionLbl" : Label '?????? ??????????';
        "??????_??????_Caption_Control1000000039Lbl" : Label '????????????????';
        "????_????????_??CaptionLbl" : Label '?????? ????????????';
        "????_??????__??_??CaptionLbl" : Label '?????? ????????????????';
        "??_??__????_??_??????????_____??___??_??_??????_??_????___??___??????????_CaptionLbl" : Label '(?????????? ???????? ?????????????? (???????? ?????? ?????????? ???? ?????????? ????????????';
        "????__??___??????____????CaptionLbl" : Label '?????? ???????? ??????????????????';
        "??_??____??_??????????CaptionLbl" : Label '?????????? ?????? ??????????';
        "????????_??????_??_CaptionLbl" : Label '?????????? ????????????';
        "??????_????_CaptionLbl" : Label '??????????????';
        "??_??___??_????_????????__CaptionLbl" : Label '"?????????? ?????????? ?????????? "';
        "????????__??___??????____CaptionLbl" : Label '?????????? ???????? ??????????????';
        "??__??_????_????__CaptionLbl" : Label '???????? ??????????????';
        "??___??????_??????__??????___????????????_??_??__????___??_??????_??????????_????_??__????????_????__??_????CaptionLbl" : Label '?????? ?????? ???????? ?????????? ???????????? ???????? ???? ?????? ?????? ?????????? ???? ?????????????? ???? ??????????';
        V1_CaptionLbl : Label '(1)';
        V2_CaptionLbl : Label '(2)';
}

