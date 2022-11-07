report 98125 "Salary Certificate"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary Certificate.rdlc';
    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(EmployeeArabicName;"Arabic Name")
            {}
            column(ArabicNationality;"Arabic Nationality")
            {}
            column(EmploymentDate;"Employment Date")
            {}
            column(ArabicJobTitle;"Arabic Job Title")
            {}
            column(SocialSecurityNo;"Social Security No.")
            {}
            column(BasicPay;"Basic Pay")
            {}
            column(CompanyArabicName;CompanyInfo."Arabic Name")
            {}
            column(CompanyPicture;CompanyInfo.Picture)
            {}
            column(CompanyInformation;CompanyInfo."Commercial No.")
            {}
            column(RegistrationNo;CompanyInfo."Registration No.")
            {}            
            column(TransportaionAmount;TransportaionAmount)
            {}
            column(TransportaionType;TransportaionType)
            {}
            column(ReportDate;ReportDate)
            {} 
            column(PayrollDate;PayrollDate)
            {}             
            column(Recipient;Recipient)
            {} 
            column(Target;Target)
            {}    
            column(FamilyAllowmanceAmount;FamilyAllowmanceAmount)
            {}
            column(ProductionAmount;ProductionAmount)
            {}   
            column(TextVar;TextVar)  
            {} 
            column(Referance;Referance)  
            {} 
            column(Signature;Signature)  
            {}                                        
            trigger OnAfterGetRecord();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                //
                IF Gender=Gender::Male then
                    TextVar := 'لقد أعطيت هذه الإفادة بناء على طلب الموظف بهدف الحصول على'
                ELSE TextVar := 'لقد أعطيت هذه الإفادة بناء على طلب الموظفة بهدف الحصول على'; 
              /*SpecificPayElementRec.SETRANGE("Employee Category Code","Employee Category Code");
              IF SpecificPayElementRec.FINDFIRST THEN 
                begin
                    TransportaionAmount := SpecificPayElementRec.Amount;
                    IF SpecificPayElementRec."Pay Unit"=SpecificPayElementRec."Pay Unit"::Monthly then
                        TransportaionType := '(شهرياً)'  
                    ELSE IF SpecificPayElementRec."Pay Unit"=SpecificPayElementRec."Pay Unit"::Daily then
                        TransportaionType := '(عن كل يوم عمل)'  
                    ELSE TransportaionType := '';
                END;*/ 
                ReportYear := DATE2DMY(PayrollDate,3);  
                ReportMonth := DATE2DMY(PayrollDate,2);

                PayDetailRec.SETRANGE("Employee No.","No.");
                PayDetailRec.SETRANGE("Pay Element Code",'003');  
                PayDetailRec.SETRANGE("Tax Year",ReportYear);
                PayDetailRec.SETRANGE(Period,ReportMonth);
                IF PayDetailRec.FindFirst then
                    FamilyAllowmanceAmount := PayDetailRec."Calculated Amount";
                //     
                PayDetailRec.SETRANGE("Employee No.","No.");
                PayDetailRec.SETFILTER("Pay Element Code",'%1|%2|%3|%4|%5|%6|%7','114','115','118','110','105','101','016');
                PayDetailRec.SETRANGE("Tax Year",ReportYear);
                PayDetailRec.SETRANGE(Period,ReportMonth);  
                IF PayDetailRec.FindFirst then repeat
                    ProductionAmount := ProductionAmount+PayDetailRec."Calculated Amount";
                UNTIL PayDetailRec.NEXT=0                                               
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
                    field(ReportDate;ReportDate)
                    {
                        Caption = 'Report Date';
                        ApplicationArea=All;
                    }
                    field(PayrollDate;PayrollDate)
                    {
                        Caption = 'Payroll Date';
                        ApplicationArea=All;
                    }
                    field(Referance;Referance)  
                    {                        ApplicationArea=All;
} 
                    field(Signature;Signature)  
                    {                        ApplicationArea=All;
}       
                    field(Recipient;Recipient)
                    {                        ApplicationArea=All;
}
                    field(Target;Target)
                    {                        ApplicationArea=All;
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
        ReportDate : date;
        PayrollDate : date;
        ReportYear : integer;
        ReportMonth : integer;
        Recipient : Text[250];
        Target : Text[250];
        SpecificPayElementRec : Record "Specific Pay Element";
        TransportaionAmount : Decimal;
        TransportaionType : Text;
        CompanyInfo : Record "Company Information";
        PayDetailRec : Record "Pay Detail Line";
        PayDetail : Record "Pay Detail Line";
        FamilyAllowmanceAmount: Decimal;
        ProductionAmount : Decimal;
        TextVar    : Text [250];
        Referance    : Text [250];
        Signature   : Text [250];
}