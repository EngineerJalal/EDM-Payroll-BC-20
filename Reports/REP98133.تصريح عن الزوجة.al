report 98133 "تصريح عن الزوجة"
{
    // version EDM.IT

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/تصريح عن الزوجة.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(Name_; Employee."Arabic Name")
            {
            }
            column(MotherName; Employee."Arabic Mother Name")
            {
            }
            column(MiddleName; Employee."Arabic Middle Name")
            {
            }
            column(ERegisterNo; Employee."Register No.")
            {
            }
            column(CompanyName; CompanyInfo."Arabic Name")
            {
            }
            column(CompanyAddress; CompanyInfo."Arabic City" + '  ' + CompanyInfo."Arabic Street" + '  ' + CompanyInfo."Arabic Building" + '  ' + CompanyInfo."Arabic Floor")
            {
            }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.")
            {
            }
            column(RelFullName; RelFullName)
            {
            }
            column(RelDayBirth; RelDayBirth)
            {
            }
            column(RelMonthBirth; RelMonthBirth)
            {
            }
            column(RelYearBirth; RelYearBirth)
            {
            }
            column(Working_1_; Working[1])
            {
            }
            column(Working_2_; Working[2])
            {
            }
            column(Job; Job)
            {
            }
            column(NSSFNo; Employee."Social Security No.")
            {
            }
            column(CompanyOwner; CompanyInfo."Company Owner")
            {
            }
            column(InvoiceDate; InvoiceDate)
            {
            }
            column(EmployeeNo; "No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Gender = Gender::Female then
                    CurrReport.SKIP;

                EmployeeRelative.SETRANGE(EmployeeRelative."Employee No.", Employee."No.");
                EmployeeRelative.SETRANGE(EmployeeRelative.Type, EmployeeRelative.Type::Wife);
                IF EmployeeRelative.FINDFIRST THEN BEGIN
                    RelDayBirth := DATE2DMY(EmployeeRelative."Birth Date", 1);
                    RelMonthBirth := DATE2DMY(EmployeeRelative."Birth Date", 2);
                    RelYearBirth := DATE2DMY(EmployeeRelative."Birth Date", 3);
                END
                ELSE BEGIN
                    RelFullName := '';
                    RelDayBirth := 0;
                    RelMonthBirth := 0;
                    RelYearBirth := 0;
                    Working[1] := '';
                    Working[2] := '';
                    Job := '';
                END;
                IF "Wife-Hsband Father Name" = '' then
                    RelFullName := "Wife-Hsband Name" + ' ' + "Family Before Marriage"
                else
                    RelFullName := "Wife-Hsband Name" + ' ' + "Wife-Hsband Father Name" + ' ' + "Family Before Marriage";
                Job := "Wife-Hsband Working Place";

                IF "Wife-Hsband Working" THEN
                    Working[1] := 'x'
                ELSE
                    Working[2] := 'x';
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Report Date")
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
        CompanyInfo.GET;
    end;

    var
        EmployeeRelative: Record "Employee Relative";
        CompanyInfo: Record "Company Information";
        RelDayBirth: Integer;
        RelMonthBirth: Integer;
        RelYearBirth: Integer;
        Job: Text[30];
        Working: array[2] of Text[1];
        RelFullName: Text[100];
        InvoiceDate: Date;
}

