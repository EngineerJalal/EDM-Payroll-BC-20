report 98092 "Salary Variance Report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary Variance Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(CompInfo_Name;CompInfo.Name)
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(PayrollSalary;PayrollSalary)
            {
            }
            column(PreviousSalary;PreviousSalary)
            {
            }
            column(OldestSalary;OldestSalary)
            {
            }
            column(JobTitleName;JobTitleName)
            {
            }
            column(PayDate;PayDate)
            {
            }
            column(PreviousDate;PreviousDate)
            {
            }
            column(OldestDate;OldestDate)
            {
            }
            column(ShowRec;ShowRec)
            {
            }
            column(EmpDepartment;EmpDepartment)
            {
            }
            dataitem("Pay Detail Line";"Pay Detail Line")
            {
                DataItemLink = "Employee No."=FIELD("No.");
                RequestFilterFields = "Pay Element Code";
            }

            trigger OnAfterGetRecord();
            begin
                PreviousSalary := 0;
                PayrollSalary := 0;
                OldestSalary := 0;
                EmpDepartment := '';
                JobTitleName := '';

                PayrollSalary := GetPayrollSalary();
                PreviousSalary := GetPreviousSalary();
                OldestSalary := GetOldestSalary();

                if (PayrollSalary - PreviousSalary = 0) and (PreviousSalary - OldestSalary = 0) and (not ShowRec) then
                  CurrReport.SKIP;

                DefDim.SETRANGE("Dimension Code",'DEPARTMENT');
                DefDim.SETRANGE("No.",Employee."No.");
                if DefDim.FINDFIRST then
                  begin
                    DimValue.SETRANGE("Dimension Code",'DEPARTMENT');
                    DimValue.SETRANGE(Code,DefDim."Dimension Value Code");
                    if DimValue.FINDFIRST then
                      EmpDepartment := DimValue.Name;
                  end;

                HRInformation.SETRANGE("Table Name",HRInformation."Table Name"::"Job Title");
                HRInformation.SETRANGE(Code,Employee."Job Title");
                if HRInformation.FINDFIRST then
                  JobTitleName := HRInformation.Description;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Report Parameter")
                {
                    field("Payroll Date";PayDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Show Salary With Variance Zero";ShowRec)
                    {
                        ApplicationArea=All;
                    }
                    field("Show in ACY";ShowInACY)
                    {
                        ApplicationArea=All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            ShowRec := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompInfo.GET();

        if DATE2DMY(PayDate,2) = 1 then
          begin
            PreviousDate := DMY2DATE(31,12,DATE2DMY(PayDate,3) - 1);
            OldestDate := DMY2DATE(30,11,DATE2DMY(PayDate,3) - 1);
          end
        else
          begin
            PreviousDate := DMY2DATE(PayFunction.GetLastDayinMonth(DMY2DATE(1,DATE2DMY(PayDate,2) - 1,DATE2DMY(PayDate,3))),DATE2DMY(PayDate,2) - 1,DATE2DMY(PayDate,3));
            if DATE2DMY(PayDate,2) = 2 then
              OldestDate := DMY2DATE(31,12,DATE2DMY(PayDate,3) - 1)
            else
              OldestDate := DMY2DATE(PayFunction.GetLastDayinMonth(DMY2DATE(1,DATE2DMY(PayDate,2) - 2,DATE2DMY(PayDate,3))),DATE2DMY(PayDate,2) - 2,DATE2DMY(PayDate,3));
          end;

        PayCodeFilter := "Pay Detail Line".GETFILTER("Pay Detail Line"."Pay Element Code");
    end;

    var
        PayFunction : Codeunit "Payroll Functions";
        CompInfo : Record "Company Information";
        JobTitleName : Text[100];
        PayDate : Date;
        PayrollSalary : Decimal;
        PreviousDate : Date;
        ShowRec : Boolean;
        DefDim : Record "Default Dimension";
        EmpDepartment : Text[50];
        PayCodeFilter : Code[10];
        PreviousSalary : Decimal;
        OldestSalary : Decimal;
        OldestDate : Date;
        DimValue : Record "Dimension Value";
        HRInformation : Record "HR Information";
        ShowInACY : Boolean;

    local procedure GetPreviousSalary() PrevSalary : Decimal;
    var
        PayDetailLine : Record "Pay Detail Line";
    begin
        if DATE2DMY(PayDate,2) = 1 then
          begin
            PayDetailLine.SETRANGE(Period,12);
            PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PayDate,3) - 1);
          end
        else
          begin
            PayDetailLine.SETRANGE(Period,DATE2DMY(PayDate,2) - 1);
            PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PayDate,3));
          end;

        PayDetailLine.SETRANGE("Employee No.",Employee."No.");
        if PayCodeFilter <> '' then
          PayDetailLine.SETFILTER("Pay Element Code",PayCodeFilter);

        if PayDetailLine.FINDFIRST then
          repeat
            case PayDetailLine.Type of
              PayDetailLine.Type::Addition :
                PrevSalary += PayDetailLine."Calculated Amount";
              PayDetailLine.Type::Deduction :
                PrevSalary -= PayDetailLine."Calculated Amount";
            end;
          until PayDetailLine.NEXT = 0;

        IF ShowInACY THEN
          PrevSalary := PayFunction.ExchangeLCYAmountToACY(PrevSalary);

        exit(PrevSalary)
    end;

    local procedure GetOldestSalary() OldSalary : Decimal;
    var
        PayDetailLine : Record "Pay Detail Line";
    begin
        CASE DATE2DMY(PayDate,2) OF
          1:
            begin
              PayDetailLine.SETRANGE(Period,11);
              PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PayDate,3) - 1);
            end;
          2:
            begin
              PayDetailLine.SETRANGE(Period,12);
              PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PayDate,3) - 1);
            end;
          3,4,5,6,7,8,9,10,11,12:
            begin
              PayDetailLine.SETRANGE(Period,DATE2DMY(PayDate,2) - 2);
              PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PayDate,3));
            end;
        end;

        PayDetailLine.SETRANGE("Employee No.",Employee."No.");
        if PayCodeFilter <> '' then
          PayDetailLine.SETFILTER("Pay Element Code",PayCodeFilter);

        if PayDetailLine.FINDFIRST then
          repeat
            case PayDetailLine.Type of
              PayDetailLine.Type::Addition :
                OldSalary += PayDetailLine."Calculated Amount";
              PayDetailLine.Type::Deduction :
                OldSalary -= PayDetailLine."Calculated Amount";
            end;
          until PayDetailLine.NEXT = 0;

        IF ShowInACY THEN
          OldSalary := PayFunction.ExchangeLCYAmountToACY(OldSalary);

        exit(OldSalary)
    end;

    local procedure GetPayrollSalary() PaySalary : Decimal;
    var
        PayDetailLine : Record "Pay Detail Line";
    begin
        PayDetailLine.SETFILTER("Payroll Date",'%1',PayDate);
        PayDetailLine.SETRANGE("Employee No.",Employee."No.");
        if PayCodeFilter <> '' then
          PayDetailLine.SETFILTER("Pay Element Code",PayCodeFilter);

        if PayDetailLine.FINDFIRST then
          repeat
            case PayDetailLine.Type of
              PayDetailLine.Type::Addition :
                PaySalary += PayDetailLine."Calculated Amount";
              PayDetailLine.Type::Deduction :
                PaySalary -= PayDetailLine."Calculated Amount";
            end;
          until PayDetailLine.NEXT = 0;

        IF ShowInACY THEN
          PaySalary := PayFunction.ExchangeLCYAmountToACY(PaySalary);

        exit(PaySalary)
    end;
}

