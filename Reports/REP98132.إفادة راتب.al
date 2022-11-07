report 98132 "إفادة راتب"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/إفادة راتب.rdl';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(CompanyArabicName; CompanyInfoRec."Arabic Name")
            { }
            column(CompanyRegistrationNo; CompanyInfoRec."Registration No.")
            { }
            column(ArabicName; "Arabic Name")
            { }
            column(EmployementDate; "Declaration Date")
            { }
            column(NSSFNo; "Social Security No.")
            { }
            column(BasicPay; "Basic Pay")
            { }
            column(Gender; Gender)
            { }
            column(ArabicAmount; ArabicAmount[1])
            { }

            column(EmployeeNo; "No.")
            { }
            column(ReportDate; ReportDate)
            { }


            trigger OnAfterGetRecord();
            begin
                EDMUtility.FormatNoText(ArabicAmount, "Basic Pay", 'LBP');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Control1000000002)
                {
                    Caption = 'Report Date';
                    field(ReportDate; ReportDate)
                    {
                        Caption = 'تاريخ التقرير';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        CompanyInfoRec.GET;
    end;

    var
        CompanyInfoRec: Record "Company Information";
        ReportDate: Date;
        EDMUtility: Codeunit "EDM Utility";
        ArabicAmount: array[2] of Text[250];
}