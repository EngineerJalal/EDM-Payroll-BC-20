report 98119 "افادة بالاجر او الكسب الاخير"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/افادة بالاجر او الكسب الاخير.rdlc';
    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(CompanyArabicName;CompanyInfoRec."Arabic Name")
            {}
            column(CompanyRegistrationNo;CompanyInfoRec."Registration No.")
            {}
            column(CompanyAddress;CompanyInfoRec."Arabic City"+'  '+CompanyInfoRec."Arabic Street"+'  '+CompanyInfoRec."Arabic Building"+'  '+CompanyInfoRec."Arabic Floor")
            {}
            column(CompanyPhoneNo;CompanyInfoRec."Phone No.")
            {}
            column(CompanyEMail;CompanyInfoRec."E-Mail")
            {}
            column(ArabicName;"Arabic Name")
            {}
            column(NSSFDate;"NSSF Date")
            {}
            column(TerminationDate;"Termination Date")
            {}            
            column(NSSFNo;"Social Security No.")
            {}        
            column(EmployeeNo;"No.")
            {}                 
            column(MonthlyPay;MonthlyPay)
            {}
            column(Text000;Text000)
            {}
            column(Text001;Text001)
            {}
            column(Text002;Text002)
            {}
            column(Text003;Text003)
            {}  
            column(ArabicAmount;ArabicAmount[1])       
            {}                           
            trigger OnAfterGetRecord();
            begin
                EmpAddInfoRec.SETRANGE("Employee No.","No.");
                if EmpAddInfoRec.FindFirst then begin 
                    PayrollParameterRec.GET;
                    PayElementRec.SETFILTER(Code,PayrollParameterRec."Extra Salary");
                    IF PayElementRec.FINDFIRST THEN begin
                        if PayElementRec."Affect NSSF" then
                            MonthlyPay := "Basic Pay"+EmpAddInfoRec."Extra Salary"
                        else
                            MonthlyPay := "Basic Pay";
                    end;
                end;
                EDMUtility.FormatNoText(ArabicAmount,MonthlyPay,'');
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
                    field(ReportDate;ReportDate)
                    {
                        Caption = 'تاريخ التقرير';
                        ApplicationArea=All;
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
        CompanyInfoRec : Record "Company Information";
        PayrollParameterRec : Record "Payroll Parameter";
        PayElementRec : Record "Pay Element";
        EmpAddInfoRec : Record "Employee Additional Info";
        ReportDate : Date;
        MonthlyPay : Decimal;
        EDMUtility : Codeunit "EDM Utility";
        ArabicAmount : array[2] of Text[250];
        Text000 : Label 'في المربع المناسب X ضع علامة';
        Text001 : label 'ان الاجر او الكسب الذي يتخذ اساساً لحساب تعويض نهاية الخدمة يشتمل على مجموع الدخل الناتج عن العمل بما فيه جميع العناصر واللواحق واياً كان';
        Text002 : Label '. شكل او طبيعة هذا الاجر او الكسب . المواد( 9 - 51 - 68 ) من قانون الضمان الاجتماعي';
        Text003 : Label '. اشطب العبارة غير المناسبة';
}