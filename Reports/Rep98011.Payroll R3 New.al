report 98011 "Payroll R3 New"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll R3 New.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(Employee_Employee__Arabic_Governorate_; Employee."Arabic Governorate")
            {
            }
            column(Employee_Employee__Arabic_Building_; Employee."Arabic Building")
            {
            }
            column(Employee_Employee__Mailbox_ID_; Employee."Mailbox ID")
            {
            }
            column(Employee_Employee__Phone_No__; Employee."Phone No.")
            {
            }
            column(Employee_Employee__Arabic_Land_Area__No__; Employee."Arabic Land Area  No.")
            {
            }
            column(Employee_Employee__Arabic_Land_Area_; Employee."Arabic Land Area")
            {
            }
            column(Employee_Employee__Arabic_Street_; Employee."Arabic Street")
            {
            }
            column(Employee_Employee__Arabic_Floor_; Employee."Arabic Floor")
            {
            }
            column(Employee_Employee__Arabic_District_; Employee."Arabic District")
            {
            }
            column(Employee_Employee__Arabic_Elimination_; Employee."Arabic Elimination")
            {
            }
            column(Employee_Employee__Arabic_City_; Employee."Arabic City")
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
            column(WifeHsbandBirthday; WifeHsbandBirthday)
            {
            }
            column(WifeHsbandBirthMonth; WifeHsbandBirthMonth)
            {
            }
            column(WifeHsbandBirthYear; WifeHsbandBirthYear)
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
            column(WifeHsbandWorking; WifeHsbandWorking)
            {
            }
            column(WifeHsbandNotWorking; WifeHsbandNotWorking)
            {
            }
            column(Wife_Hsband_Working_Place; "Wife-Hsband Working Place")
            {
            }
            column(Wife_Hsband_Registration_No; "Wife-Hsband Registration No.")
            {
            }
            column(ArabicFirstName_Employee; Employee."Arabic First Name")
            {
            }
            column(MotherName_Employee; Employee."Mother Name")
            {
            }
            column(ArabicMiddleName_Employee; Employee."Arabic Middle Name")
            {
            }
            column(Floor_Employee; Employee.Floor)
            {
            }
            column(Building_Employee; Employee.Building)
            {
            }
            column(City_Employee; Employee.City)
            {
            }
            column(LastName_Employee; Employee."Last Name")
            {
            }
            column(FirstName_Employee; Employee."First Name")
            {
            }
            column(MiddleName_Employee; Employee."Middle Name")
            {
            }
            column(ArabicLastName_Employee; Employee."Arabic Last Name")
            {
            }
            column(ArabicMotherName_Employee; Employee."Arabic Mother Name")
            {
            }
            column(ArabicPlaceofBirth_Employee; Employee."Arabic Place of Birth")
            {
            }
            column(ArabicNationality_Employee; Employee."Arabic Nationality")
            {
            }
            column(FirstNationalityCode_Employee; Employee."First Nationality Code")
            {
            }
            column(ArabicJobTitle_Employee; Employee."Arabic Job Title")
            {
            }
            column(ArabicRegisterationPlace_Employee; Employee."Arabic Registeration Place")
            {
            }
            column(ArabicGovernorate_Employee; Employee."Arabic Governorate")
            {
            }
            column(ArabicElimination_Employee; Employee."Arabic Elimination")
            {
            }
            column(ArabicDistrict_Employee; Employee."Arabic District")
            {
            }
            column(ArabicLandArea_Employee; Employee."Arabic Land Area")
            {
            }
            column(ArabicLandAreaNo_Employee; Employee."Arabic Land Area  No.")
            {
            }
            column(ArabicMailBoxArea_Employee; Employee."Arabic MailBox Area")
            {
            }
            column(Sex_Employee; Employee.Gender)
            {
            }
            column(BirthDate_Employee; Employee."Birth Date")
            {
            }
            column(RegisterNo_Employee; Employee."Register No.")
            {
            }
            column(NSSFNo_Employee; Employee."Social Security No.")
            {
            }
            column(EmploymentDate_Employee; Employee."Employment Date")
            {
            }
            column(GovernmentIDNo_Employee; Employee."Government ID No.")
            {
            }
            column(ArabicStreet_Employee; Employee."Arabic Street")
            {
            }
            column(FaxNo_Employee; Employee."Fax No.")
            {
            }
            column(ArabicCity_Employee; Employee."Arabic City")
            {
            }
            column(MobilePhoneNo_Employee; Employee."Mobile Phone No.")
            {
            }
            column(PhoneNo_Employee; Employee."Phone No.")
            {
            }
            column(ArabicFloor_Employee; Employee."Arabic Floor")
            {
            }
            column(ArabicBuilding_Employee; Employee."Arabic Building")
            {
            }
            column(EMail_Employee; Employee."E-Mail")
            {
            }
            column(NoofChildren_Employee; Employee."No of Children")
            {
            }
            column(SocialStatus_Employee; Employee."Social Status")
            {
            }
            column(PersonalFinanceNo_Employee; Employee."Personal Finance No.")
            {
            }
            column(DeclarationDate_Employee; Employee."Declaration Date")
            {
            }
            column(PayFrequency_Employee; Employee."Pay Frequency")
            {
            }
            column(HourlyBasis_Employee; Employee."Hourly Basis")
            {
            }
            column(MailboxID_Employee; Employee."Mailbox ID")
            {
            }
            column(Status_Employee; Employee.Status)
            {
            }
            column(CompanyOwner_CompanyInformation; CompanyInformation."Company Owner")
            {
            }
            column(JobDescription_CompanyInformation; CompanyInformation."Job Description")
            {
            }
            column(ArabicName_CompanyInformation; CompanyInformation."Arabic Name")
            {
            }
            column(Name2_CompanyInformation; CompanyInformation."Name 2")
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(ArabicTradingName_CompanyInformation; CompanyInformation."Arabic Trading Name")
            {
            }
            column(RegistrationNo_CompanyInformation; CompanyInformation."Arabic Registration No.")
            {
            }
            column(ArabicFirstName_EmployeeRelative; AFname)
            {
            }
            column(ArabicMiddleName_EmployeeRelative; AMname)
            {
            }
            column(ArabicLastName_EmployeeRelative; ALname)
            {
            }
            column(ArabicMotherName_EmployeeRelative; AMname)
            {
            }
            column(ArabicNationality_EmployeeRelative; ANationality)
            {
            }
            column(ArabicPlaceOfBirth_EmployeeRelative; APlaceOfBirth)
            {
            }
            column(BirthDate_EmployeeRelative; BirthDate)
            {
            }
            column(Working_EmployeeRelative; Working)
            {
            }
            column(ArabicCompanyName_EmployeeRelative; ACompanyName)
            {
            }
            column(FinanceRegisterNb_EmployeeRelative; FinanceRegisterNo)
            {
            }
            column(IdNo_EmployeeRelative; IDNb)
            {
            }
            column(FirstName_EmployeRelative; Fname)
            {
            }
            column(MiddleName_EmployeeRelative; Mname)
            {
            }
            column(LastName_EmployeeRelative; Lname)
            {
            }
            column(EligibleExemptTax_EmployeeRelative; EligibleExamptTax)
            {
            }
            column(PersonalRegisterNo_EmployeeRelative; PersonalRegisterNo)
            {
            }
            column(FirstNationalityDescription; FirstNationalityDesc)
            {
            }
            column(EligibleExemptTaxNumber; EligibleExemptTaxNumber)
            {
            }
            column(AMotherName_EmployeeRelative; AMotherName)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF "Wife-Hsband Working" then begin
                    WifeHsbandWorking := 'x';
                    WifeHsbandNotWorking := '';
                end
                else begin
                    IF "Wife-Hsband Name" = '' then begin
                        WifeHsbandWorking := '';
                        WifeHsbandNotWorking := '';
                    end
                    else begin
                        WifeHsbandWorking := '';
                        WifeHsbandNotWorking := 'x';
                    end;
                end;
                //
                IF "Wife-Hsband Birthdate" <> 0D THEN begin
                    WifeHsbandBirthday := DATE2DMY("Wife-Hsband Birthdate", 1);
                    WifeHsbandBirthMonth := DATE2DMY("Wife-Hsband Birthdate", 2);
                    WifeHsbandBirthYear := DATE2DMY("Wife-Hsband Birthdate", 3);
                end
                else begin
                    WifeHsbandBirthday := 0;
                    WifeHsbandBirthMonth := 0;
                    WifeHsbandBirthYear := 0;
                end;
                //
                CountryRegion.RESET;
                CountryRegion.SETRANGE(CountryRegion.Code, Employee."First Nationality Code");
                if CountryRegion.FINDFIRST then
                    FirstNationalityDesc := CountryRegion.Name
                else
                    FirstNationalityDesc := '';

                Employee.CALCFIELDS("No of Children");

                EligibleExemptTaxNumber := 0;
                EmployeeRelative.RESET;
                EmployeeRelative.SETRANGE(EmployeeRelative."Employee No.", Employee."No.");
                repeat
                    if EmployeeRelative."Eligible Exempt Tax" then
                        EligibleExemptTaxNumber := EligibleExemptTaxNumber + 1;
                until EmployeeRelative.NEXT = 0;

                IF (("Social Status" = "Social Status"::Married) and (NOT "Spouse Secured")) OR
                ((Gender = Gender::Female) and ("Husband Paralyzed")) then
                    EligibleExemptTaxNumber := EligibleExemptTaxNumber + 1;

                EmployeeRelative.RESET;
                EmployeeRelative.SETRANGE(EmployeeRelative."Employee No.", Employee."No.");
                EmployeeRelative.SETFILTER("Relative Code", '%1|%2', 'HUSBAND', 'WIFE');
                if EmployeeRelative.FINDFIRST then begin
                    AFname := EmployeeRelative."Arabic First Name";
                    AMname := EmployeeRelative."Arabic Middle Name";
                    ALname := EmployeeRelative."Arabic Last Name";
                    AMotherName := EmployeeRelative."Arabic Mother Name";
                    ANationality := EmployeeRelative."Arabic Nationality";
                    APlaceOfBirth := EmployeeRelative."Arabic Place Of Birth";
                    BirthDate := EmployeeRelative."Birth Date";
                    Working := EmployeeRelative.Working;
                    ACompanyName := EmployeeRelative."Arabic Company Name";
                    FinanceRegisterNo := EmployeeRelative."Finance Register No.";
                    IDNb := EmployeeRelative."ID No.";
                    Fname := EmployeeRelative."First Name";
                    Lname := EmployeeRelative."Last Name";
                    Mname := EmployeeRelative."Middle Name";
                    EligibleExamptTax := EmployeeRelative."Eligible Exempt Tax";
                    PersonalRegisterNo := EmployeeRelative."Personal Register No.";
                end
                else begin
                    AFname := '';
                    AMname := '';
                    ALname := '';
                    AMotherName := '';
                    ANationality := '';
                    APlaceOfBirth := '';
                    BirthDate := 0D;
                    Working := false;
                    ACompanyName := '';
                    FinanceRegisterNo := '';
                    IDNb := '';
                    Fname := '';
                    Lname := '';
                    Mname := '';
                    EligibleExamptTax := false;
                    PersonalRegisterNo := '';
                end;
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
    begin
        CompanyInformation.GET;
    end;

    var
        CompanyInformation: Record "Company Information";
        ChildNo: Integer;
        EmployeeRelative: Record "Employee Relative";
        GenderEmp: array[2] of Text[1];
        SocialStatus: array[4] of Text[1];
        AFname: Text[30];
        Fname: Text[30];
        ALname: Text[30];
        Lname: Text[30];
        AMname: Text[30];
        Mname: Text[30];
        AMotherName: Text[30];
        ANationality: Text[30];
        IDNb: Code[12];
        APlaceOfBirth: Text[30];
        BirthDate: Date;
        MonthlyPay: Text[1];
        Working: Boolean;
        v: Boolean;
        WifeHsbandBirthday: Integer;
        WifeHsbandBirthMonth: Integer;
        WifeHsbandBirthyear: Integer;
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
        ACompanyName: Text[50];
        FinanceRegisterNo: Code[20];
        EligibleExamptTax: Boolean;
        PersonalRegisterNo: Code[20];
        CountryRegion: Record "Country/Region";
        FirstNationalityDesc: Text[30];
        EligibleExemptTaxNumber: Integer;
        HRInformation: Record "HR Information";
        WifeHsbandWorking: Text[10];
        WifeHsbandNotWorking: Text[10];
}

