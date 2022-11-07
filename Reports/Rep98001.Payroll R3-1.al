report 98001 "Payroll R3-1"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts//Payroll R3-1.rdl';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Owner; "Company Owner")
            {
            }
            column(ArabicName; "Arabic Name")
            {
            }
            column(TradingName; "Arabic Trading Name")
            {
            }
            column(RegistrationNo; "Registration No.")
            {
            }
            column(ArabicRegistrationNo; "Arabic Registration No.")
            {
            }
            column(ArabicBuilding; "Arabic Building")
            {
            }
            column(ArabicStreet; "Arabic Street")
            {
            }
            column(ArabicGovernorate; "Arabic Governorate")
            {
            }
            column(ArabicElimination; "Arabic Elimination")
            {
            }
            column(ArabicFloor; "Arabic Floor")
            {
            }
            column(LandArea; "Arabic Land Area")
            {
            }
            column(LandAreaNo; "Arabic Land Area  No.")
            {
            }
            column(City; "Arabic City")
            {
            }
            column(MailboxID; "Mailbox ID")
            {
            }
            column(MailBoxArea; "Arabic MailBox Area")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(ArabicDistrict; "Arabic District")
            {
            }
            column(FaxNo; "Fax No.")
            {
            }
            column(CPhoneNo2; "Phone No. 2")
            {
            }
            column(JobDescription; "Job Description")
            {
            }
            column(ReportDate; ReportDate)
            { }
            column(NumberofOrder; NumberofOrder)
            { }
            column(EMail; "E-Mail")
            { }
            column(Reportday; Reportday)
            { }
            column(ReportMonth; ReportMonth)
            { }
            column(ReportYear; ReportYear)
            { }
            trigger OnAfterGetRecord()
            begin
                Reportday := DATE2DMY(ReportDate, 1);
                ReportMonth := DATE2DMY(ReportDate, 2);
                ReportYear := DATE2DMY(ReportDate, 3);
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
                    field(NumberofOrder; NumberofOrder)
                    {
                        Caption = 'عدد طلبات تسجيل المستخدمين';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    var
        ReportDate: Date;
        NumberofOrder: Integer;
        Reportday: Integer;
        ReportMonth: Integer;
        ReportYear: Integer;
}

