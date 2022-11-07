report 98072 "Salary NSSF 2"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary NSSF 2.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.","Payroll Group Code","Employee Category Code","Posting Group",Status,Declared;
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ReferenceDate;ReferenceDate)
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(SocialSecurityNo_Employee;Employee."Social Security No.")
            {
            }
            column(NSSFDate_Employee;Employee."NSSF Date")
            {
            }
            column(BasicSalary;BasicSalary)
            {
            }
            column(NoOfEmployedYears;NoOfEmployedYears)
            {
            }
            column(PaidEOS85;"PaidEOS8.5%")
            {
            }

            trigger OnAfterGetRecord();
            begin
                BasicSalary := CalcLastBasicSalary(Employee);
                NoOfEmployedYears := ROUND(CalcNoOfEmployedYears(Employee),0.01,'=');
                "PaidEOS8.5%" := CalcPaidEOS(Employee);
            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ReferenceDate;ReferenceDate)
                    {
                        Caption = 'Reference Date';
                        ApplicationArea=All;
                    }
                    field(Versus;Versus)
                    {
                        ApplicationArea=All;
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
        ReportHeader = 'EOS Salary';}

    trigger OnInitReport();
    begin
        if  Payrollfunction.HideSalaryFields() then
           ERROR('Permission NOT Allowed!');
    end;

    trigger OnPreReport();
    begin
        if ReferenceDate = 0D then
          ERROR('You must select Reference Date');
    end;

    var
        ReferenceDate : Date;
        BasicSalary : Decimal;
        NoOfEmployedYears : Decimal;
        "PaidEOS8.5%" : Decimal;
        CompanyInfo : Record "Company Information";
        Versus : Option "Employment Date","NSSF Date";
        Payrollfunction : Codeunit "Payroll Functions";
        MHOODSalary : Decimal;

    local procedure CalcLastBasicSalary(EmployeeRec : Record Employee) Result : Decimal;
    var
        PayDetailLine : Record "Pay Detail Line";
        PayElement : Record "Pay Element";
        PayrollDate : Date;
    begin
        if (EmployeeRec."Employment Date" = 0D) or (EmployeeRec."Employment Date" > ReferenceDate) then
          exit(0);

        PayDetailLine.SETCURRENTKEY("Payroll Date");
        PayDetailLine.RESET;
        PayDetailLine.SETRANGE("Employee No.",EmployeeRec."No.");

        if Versus = Versus::"Employment Date" then
          PayDetailLine.SETRANGE("Payroll Date",EmployeeRec."Employment Date",ReferenceDate)
        else
          PayDetailLine.SETRANGE("Payroll Date",EmployeeRec."NSSF Date",ReferenceDate);

        if PayDetailLine.FINDLAST then begin
            PayrollDate := PayDetailLine."Payroll Date";
            PayDetailLine.RESET;
            PayDetailLine.SETRANGE("Employee No.",EmployeeRec."No.");
            PayDetailLine.SETRANGE("Payroll Date",PayrollDate);

            if PayDetailLine.FINDFIRST then repeat
                PayElement.RESET;
                PayElement.SETRANGE(Code,PayDetailLine."Pay Element Code");
                PayElement.SETRANGE("Category Type",PayElement."Category Type"::Basic);
                if PayElement.FINDFIRST then
                    Result += PayDetailLine."Calculated Amount";
            until PayDetailLine.NEXT = 0;
        end else
            Result := EmployeeRec."Basic Pay";

        exit(Result);
    end;

    local procedure CalcPaidEOS(EmployeeRec : Record Employee) Result : Decimal;
    var
        PayDetailLine : Record "Pay Detail Line";
        PayElement : Record "Pay Element";
        PayrollDate : Date;
    begin
        if (EmployeeRec."Employment Date" = 0D) or (EmployeeRec."Employment Date" > ReferenceDate) then
          exit(0);

        PayDetailLine.RESET;
        PayDetailLine.SETRANGE("Employee No.",EmployeeRec."No.");
        PayDetailLine.SETRANGE("Payroll Date",EmployeeRec."Employment Date",ReferenceDate);
        if PayDetailLine.FINDFIRST then repeat
            PayElement.RESET;
            PayElement.SETRANGE(Code,PayDetailLine."Pay Element Code");
            PayElement.SETRANGE("Category Type",PayElement."Category Type"::"EOS-8.5");
            if PayElement.FINDFIRST then
                Result += PayDetailLine."Employer Amount";
        until PayDetailLine.NEXT = 0;

        exit(Result);
    end;

    local procedure CalcNoOfEmployedYears(EmployeeRec : Record Employee) : Decimal;
    var
        NoEmployedDays : Decimal;
    begin

        if (EmployeeRec."Employment Date" = 0D) or (EmployeeRec."Employment Date" > ReferenceDate) then
          exit(0);

        NoEmployedDays := ReferenceDate - EmployeeRec."Employment Date";
        exit(NoEmployedDays / 365);
    end;
}

