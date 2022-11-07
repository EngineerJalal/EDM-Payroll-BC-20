report 98123 "Social Insurance"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Social Insurance.rdlc';
    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(No_;"No.")
            {}
            column(EmployeeName;EmployeeName)
            {}
            column(FixedSalary;FixedSalary)
            {}         
            column(VariableSalary;VariableSalary)
            {}        
            column(VariableSalary11;VariableSalary11)
            {}
            column(FixedSalary14;FixedSalary14)       
            {}          
            column(FixedSalary26;FixedSalary26)       
            {}
            column(VariableSalary24;VariableSalary24)       
            {} 

            trigger OnAfterGetRecord();
            begin
                ResetVariable();

                IF Employee."Arabic Name" <> '' THEN
                    EmployeeName := Employee."Arabic Name"
                ELSE 
                    EmployeeName := Employee."Full Name";
                
                PayDetailLine.SETRANGE("Employee No.","No.");
                PayDetailLine.SETRANGE("Payroll Date",FromDate,ToDate);
                IF PayDetailLine.FINDFIRST THEN BEGIN 
                REPEAT
                    CASE PayDetailLine."Pay Element Code" OF 
                    '045': FixedSalary += PayDetailLine."Calculated Amount";
                    '046': VariableSalary += PayDetailLine."Calculated Amount";
                    '043': 
                        BEGIN
                            FixedSalary14 += PayDetailLine."Calculated Amount";
                            FixedSalary26 += PayDetailLine."Employer Amount";
                        END;
                    '044':
                        BEGIN
                            VariableSalary11 += PayDetailLine."Calculated Amount";
                            VariableSalary24 += PayDetailLine."Employer Amount";
                        END; 
                    END;
                UNTIL PayDetailLine.NEXT=0;
                END ELSE CurrReport.SKIP;
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
                    field("From Date";FromDate)
                    {                        ApplicationArea=All;
}
                    field("To Date";ToDate)
                    {                        ApplicationArea=All;
}                    
                }
            }
        }
    }

    trigger OnPreReport();
    begin

    end;

    var
        PayDetailLine :	Record	"Pay Detail Line";
        FromDate : Date;
        ToDate : Date;
        EmployeeName : Text[250];
        FixedSalary : Decimal;
        VariableSalary : Decimal;
        FixedSalary14 : Decimal;
        VariableSalary11 : Decimal;
        FixedSalary26 : Decimal;
        VariableSalary24 : Decimal;

        local procedure ResetVariable()
        var
        begin
            FixedSalary := 0;
            VariableSalary := 0;
            FixedSalary14 := 0;
            FixedSalary26 := 0;
            VariableSalary11 := 0;
            VariableSalary24 := 0;
        end;
}