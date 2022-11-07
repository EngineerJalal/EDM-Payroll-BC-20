report 98126 "Embassy Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Embassy Letter.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(EmployeeName; "Full Name")
            { }
            column(NationalityName; NationalityName)
            { }
            column(EmploymentDate; "Employment Date")
            { }
            column(JobTitle; "Job Title Description")
            { }
            column(SocialSecurityNo; "Social Security No.")
            { }
            column(BasicPay; "Basic Pay")
            { }
            column(CompanyName; CompanyInfo."English Name")
            { }
            column(CompanyPicture; CompanyInfo.Picture)
            { }
            column(CompanyCommercialNo; CompanyInfo."Commercial No.")
            { }
            column(TransportaionAmount; TransportaionAmount)
            { }
            column(TransportaionType; TransportaionType)
            { }
            column(ReportDate; ReportDate)
            { }
            column(PayrollDate; PayrollDate)
            { }
            column(Target; Target)
            { }
            column(FamilyAllowmanceAmount; FamilyAllowmanceAmount)
            { }
            column(ProductionAmount; ProductionAmount)
            { }
            column(TextVar; TextVar)
            { }
            column(Referance; Reference)
            { }
            column(AddressTo; AddressTo)
            { }
            column(Signature; Signature)
            { }
            trigger OnAfterGetRecord();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                //
                CountryRec.SETRANGE(Code, "First Nationality Code");
                IF CountryRec.FINDFIRST then
                    NationalityName := CountryRec.Name;
                //
                IF Gender = Gender::Male then
                    TextVar := 'Mr.' + ' ' + "Full Name"
                ELSE
                    TextVar := 'Mrs.' + ' ' + "Full Name";

                ReportYear := DATE2DMY(PayrollDate, 3);
                ReportMonth := DATE2DMY(PayrollDate, 2);

                PayDetailRec.SETRANGE("Employee No.", "No.");
                PayDetailRec.SETRANGE("Pay Element Code", '003');
                PayDetailRec.SETRANGE("Tax Year", ReportYear);
                PayDetailRec.SETRANGE(Period, ReportMonth);
                IF PayDetailRec.FindFirst then
                    FamilyAllowmanceAmount := PayDetailRec."Calculated Amount";
                //     
                PayDetailRec.SETRANGE("Employee No.", "No.");
                PayDetailRec.SETFILTER("Pay Element Code", '%1|%2|%3|%4|%5|%6|%7', '114', '115', '118', '110', '105', '101', '016');
                PayDetailRec.SETRANGE("Tax Year", ReportYear);
                PayDetailRec.SETRANGE(Period, ReportMonth);
                IF PayDetailRec.FindFirst then
                    repeat
                        ProductionAmount := ProductionAmount + PayDetailRec."Calculated Amount";
                    UNTIL PayDetailRec.NEXT = 0;
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(control)
                {
                    field(ReportDate; ReportDate)
                    {
                        Caption = 'Report Date';
                        ApplicationArea = All;
                    }
                    field(PayrollDate; PayrollDate)
                    {
                        Caption = 'Payroll Date';
                        ApplicationArea = All;
                    }
                    field(Reference; Reference)
                    {
                        MultiLine = true;
                        ApplicationArea = All;
                    }
                    field(AddressTo; AddressTo)
                    {
                        Caption = 'Address To';
                        MultiLine = true;
                        ApplicationArea = All;
                    }
                    field(Signature; Signature)
                    {
                        ApplicationArea = All;
                    }
                    field(Target; Target)
                    {
                        MultiLine = true;
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
        }
    }
    trigger OnPreReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        ReportDate: date;
        PayrollDate: date;
        ReportYear: integer;
        ReportMonth: integer;
        Recipient: Text[250];
        Target: Text[250];
        SpecificPayElementRec: Record "Specific Pay Element";
        TransportaionAmount: Decimal;
        TransportaionType: Text;
        CompanyInfo: Record "Company Information";
        PayDetailRec: Record "Pay Detail Line";
        PayDetail: Record "Pay Detail Line";
        FamilyAllowmanceAmount: Decimal;
        ProductionAmount: Decimal;
        TextVar: Text[250];
        Reference: Text[250];
        Signature: Text[250];
        AddressTo: Text[250];
        NationalityName: Text[50];
        CountryRec: Record "Country/Region";
}