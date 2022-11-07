report 98137 "الاستفادة عن الوالد/الوالدة"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/الاستفادة عن الوالد الوالدة.rdl';
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
            column(BasicPay; "Basic Pay")
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
            column(MobileNo; "Mobile Phone No.")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(ArabicElimination; "Arabic Elimination")
            {
            }
            column(ArabicCity; "Arabic City")
            {
            }
            column(ArabicStreet; "Arabic Street")
            {
            }
            column(ArabicBuilding; "Arabic Building")
            {
            }
            column(ArabicFloor; "Arabic Floor")
            {
            }
            column(ArabicDistrict; "Arabic District")
            {
            }
            column(ReportCaption; ReportCaption)
            {
            }
            column(FatherName; FatherName)
            {
            }
            column(FatherBirthdate; FatherBirthdate)
            {
            }
            column(MotherName; MotherName)
            {
            }
            column(MotherBirthdate; MotherBirthdate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF ReportRelative = ReportRelative::" " then
                    ERROR('Specify the relative (Father Or Mother)');

                IF ReportRelative = ReportRelative::" " then
                    ReportCaption := ''
                else
                    IF ReportRelative = ReportRelative::FATHER then
                        ReportCaption := 'الوالد'
                    else
                        ReportCaption := 'الوالدة';

                EmployeeRelative.SETRANGE("Employee No.", "No.");
                IF EmployeeRelative.FINDFIRST THEN
                    repeat
                        IF EmployeeRelative."Relative Code" = 'FATHER' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                FatherName := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                FatherName := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            FatherBirthdate := EmployeeRelative."Birth Date";
                        end;
                        IF EmployeeRelative."Relative Code" = 'MOTHER' then begin
                            IF EmployeeRelative."Arabic Middle Name" = '' then
                                MotherName := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Last Name"
                            ELSE
                                MotherName := EmployeeRelative."Arabic First Name" + ' ' + EmployeeRelative."Arabic Middle Name" + ' ' + EmployeeRelative."Arabic Last Name";
                            MotherBirthdate := EmployeeRelative."Birth Date";
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
                group(Filters)
                {
                    field("Report Date"; ReportDate)
                    {
                        ApplicationArea = All;
                    }
                    field(Relative; ReportRelative)
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
        ReportDate: Date;
        EmployeeRelative: Record "Employee Relative";
        FatherName: Text[250];
        FatherBirthdate: date;
        MotherName: Text[250];
        MotherBirthdate: date;
        ReportRelative: Option " ",FATHER,MOTHER;
        ReportCaption: Text[20];
}