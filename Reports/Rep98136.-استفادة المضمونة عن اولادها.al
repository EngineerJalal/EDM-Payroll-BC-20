report 98136 "استفادة المضمونة عن اولادها"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/استفادة المضمونة عن اولادها.rdl';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(EmployeeNo; Employee."No.")
            {
            }
            column(EmployeeName; Employee."Arabic Name")
            {
            }
            column(NSSFNo; "Social Security No.")
            { }
            Column(ArabicSocialStatus; ArabicSocialStatus)
            { }
            column(BasicPay; "Basic Pay")
            { }
            Column(ArabicPlaceofBirth; "Arabic Place of Birth")
            { }
            column(CompanyName; CompanyInfo."Arabic Name")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyOwner; CompanyInfo."Company Owner")
            {
            }
            column(CompanyAddress; CompanyInfo."Arabic City" + '  ' + CompanyInfo."Arabic Street" + '  ' + CompanyInfo."Arabic Building" + '  ' + CompanyInfo."Arabic Floor")
            {
            }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.")
            {
            }
            column(HusbandName; "Wife-Hsband Name")
            {
            }

            column(HusbandFatherName; "Wife-Hsband Father Name")
            {
            }

            column(HusbandFamilyName; "Family Before Marriage")
            {
            }
            column(HusbandBirthPlace; "Wife-Hsband Birth Place")
            {
            }
            column(HusbandBirthdate; "Wife-Hsband Birthdate")
            {
            }
            column(HusbandNationality; "Wife-Hsband Nationality")
            {
            }
            column(HusbandWorkingPlace; "Wife-Hsband Working Place")
            {
            }
            column(EmployeeAddress; EmployeeAddress)
            {
            }
            column(RelativeName1; RelativeName1)
            {
            }
            column(RelativeBirthday1; RelativeBirthday1)
            {
            }
            column(RelativeBirthMonth1; RelativeBirthMonth1)
            {
            }
            column(RelativeBirthYear1; RelativeBirthYear1)
            {
            }
            column(RelativeName2; RelativeName2)
            {
            }
            column(RelativeBirthday2; RelativeBirthday2)
            {
            }
            column(RelativeBirthMonth2; RelativeBirthMonth2)
            {
            }
            column(RelativeBirthYear2; RelativeBirthYear2)
            {
            }
            column(RelativeName3; RelativeName3)
            {
            }
            column(RelativeBirthday3; RelativeBirthday3)
            {
            }
            column(RelativeBirthMonth3; RelativeBirthMonth3)
            {
            }
            column(RelativeBirthYear3; RelativeBirthYear3)
            {
            }
            column(RelativeName4; RelativeName4)
            {
            }
            column(RelativeBirthday4; RelativeBirthday4)
            {
            }
            column(RelativeBirthMonth4; RelativeBirthMonth4)
            {
            }
            column(RelativeBirthYear4; RelativeBirthYear4)
            {
            }
            column(RelativeName5; RelativeName5)
            {
            }
            column(RelativeBirthday5; RelativeBirthday5)
            {
            }
            column(RelativeBirthMonth5; RelativeBirthMonth5)
            {
            }
            column(RelativeBirthYear5; RelativeBirthYear5)
            {
            }
            column(RelativeName6; RelativeName6)
            {
            }
            column(RelativeBirthday6; RelativeBirthday6)
            {
            }
            column(RelativeBirthMonth6; RelativeBirthMonth6)
            {
            }
            column(RelativeBirthYear6; RelativeBirthYear6)
            {
            }
            column(EmployeeBirthday; EmployeeBirthday)
            {
            }
            column(EmployeeBirthMonth; EmployeeBirthMonth)
            {
            }
            column(EmployeeBirthYear; EmployeeBirthYear)
            {
            }
            column(ReportDate; ReportDate)
            {
            }
            column(EmployeePlaceofBirth; "Arabic Place of Birth")
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Gender = Gender::Male then
                    CurrReport.SKIP;

                EmployeeBirthday := DATE2DMY("Birth Date", 1);
                EmployeeBirthMonth := DATE2DMY("Birth Date", 2);
                EmployeeBirthYear := DATE2DMY("Birth Date", 3);

                IF "Social Status" = "Social Status"::Divorced then
                    ArabicSocialStatus := 'مطلقة'
                ELSE
                    IF "Social Status" = "Social Status"::Married then
                        ArabicSocialStatus := 'متزوجة'
                    else
                        IF "Social Status" = "Social Status"::Single then
                            ArabicSocialStatus := 'عذباء'
                        else
                            IF "Social Status" = "Social Status"::Widow then
                                ArabicSocialStatus := 'أرملة';

                EmployeeAddress := "Arabic Governorate" + ' ، ' + "Arabic Elimination" + ' ، ' + "Arabic City" + ' ، ' + "Arabic District" + ' ، '
                                  + "Arabic Street" + ' ، ' + "Arabic Building" + ' ، ' + "Arabic Floor";

                EmployeeRelative.SETRANGE("Employee No.", "No.");
                IF EmployeeRelative.FINDFIRST THEN
                    repeat
                        IF EmployeeRelative."Relative Code" = 'CHILD1' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                RelativeName1 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                RelativeName1 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            RelativeBirthday1 := DATE2DMY(EmployeeRelative."Birth Date", 1);
                            RelativeBirthMonth1 := DATE2DMY(EmployeeRelative."Birth Date", 2);
                            RelativeBirthYear1 := DATE2DMY(EmployeeRelative."Birth Date", 3);
                        end;
                        IF EmployeeRelative."Relative Code" = 'CHILD2' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                RelativeName2 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                RelativeName2 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            RelativeBirthday2 := DATE2DMY(EmployeeRelative."Birth Date", 1);
                            RelativeBirthMonth2 := DATE2DMY(EmployeeRelative."Birth Date", 2);
                            RelativeBirthYear2 := DATE2DMY(EmployeeRelative."Birth Date", 3);
                        end;
                        IF EmployeeRelative."Relative Code" = 'CHILD3' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                RelativeName3 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                RelativeName3 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            RelativeBirthday3 := DATE2DMY(EmployeeRelative."Birth Date", 1);
                            RelativeBirthMonth3 := DATE2DMY(EmployeeRelative."Birth Date", 2);
                            RelativeBirthYear3 := DATE2DMY(EmployeeRelative."Birth Date", 3);
                        end;
                        IF EmployeeRelative."Relative Code" = 'CHILD4' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                RelativeName4 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                RelativeName4 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            RelativeBirthday4 := DATE2DMY(EmployeeRelative."Birth Date", 1);
                            RelativeBirthMonth4 := DATE2DMY(EmployeeRelative."Birth Date", 2);
                            RelativeBirthYear4 := DATE2DMY(EmployeeRelative."Birth Date", 3);
                        end;
                        IF EmployeeRelative."Relative Code" = 'CHILD5' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                RelativeName5 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                RelativeName5 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            RelativeBirthday5 := DATE2DMY(EmployeeRelative."Birth Date", 1);
                            RelativeBirthMonth5 := DATE2DMY(EmployeeRelative."Birth Date", 2);
                            RelativeBirthYear5 := DATE2DMY(EmployeeRelative."Birth Date", 3);
                        end;
                        IF EmployeeRelative."Relative Code" = 'CHILD6' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                RelativeName6 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                RelativeName6 := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            RelativeBirthday6 := DATE2DMY(EmployeeRelative."Birth Date", 1);
                            RelativeBirthMonth6 := DATE2DMY(EmployeeRelative."Birth Date", 2);
                            RelativeBirthYear6 := DATE2DMY(EmployeeRelative."Birth Date", 3);
                        end;
                    until EmployeeRelative.Next = 0;
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Date)
                {
                    field("Report Date"; ReportDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnPreReport();
    begin
        CompanyInfo.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        ArabicSocialStatus: Text[25];
        ReportDate: Date;
        EmployeeAddress: Text[250];
        EmployeeRelative: Record "Employee Relative";
        RelativeName1: Text[250];
        RelativeBirthday1: Integer;
        RelativeBirthMonth1: Integer;
        RelativeBirthYear1: Integer;
        RelativeName2: Text[250];
        RelativeBirthday2: Integer;
        RelativeBirthMonth2: Integer;
        RelativeBirthYear2: Integer;
        RelativeName3: Text[250];
        RelativeBirthday3: Integer;
        RelativeBirthMonth3: Integer;
        RelativeBirthYear3: Integer;
        RelativeName4: Text[250];
        RelativeBirthday4: Integer;
        RelativeBirthMonth4: Integer;
        RelativeBirthYear4: Integer;
        RelativeName5: Text[250];
        RelativeBirthday5: Integer;
        RelativeBirthMonth5: Integer;
        RelativeBirthYear5: Integer;
        RelativeName6: Text[250];
        RelativeBirthday6: Integer;
        RelativeBirthMonth6: Integer;
        RelativeBirthYear6: Integer;
        EmployeeBirthday: Integer;
        EmployeeBirthMonth: Integer;
        EmployeeBirthYear: Integer;
}
