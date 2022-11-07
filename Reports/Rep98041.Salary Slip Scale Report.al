report 98041 "Salary Slip Scale Report"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Salary Slip Scale Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(FullName;Employee."Full Name")
            {
            }
            column(AverageSalary;AverageSalary)
            {
            }
            column(AverageHours;AverageHours)
            {
            }
            column(ScaleRate;ScaleRate)
            {
            }
            column(SuggestedApraisalDeduction;SuggestedApraisalDeduction)
            {
            }
            column(SuggestedAmount;SuggestedAmount)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number=CONST(1));
                column(CompanyLogo;gCompanyInfo.Picture)
                {
                }
                column(CompanyAddress1;gCompanyAddress[1])
                {
                }
                column(CompanyAddress2;gCompanyAddress[2])
                {
                }
                column(CompanyAddress3;gCompanyAddress[3])
                {
                }
                column(CompanyAddress4;gCompanyAddress[4])
                {
                }
                column(CompanyAddress5;gCompanyAddress[5])
                {
                }
                column(CompanyAddress6;gCompanyAddress[6])
                {
                }
                column(FromDate;FromDate)
                {
                }
                column(ToDate;ToDate)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    gCompanyInfo.GET;
                    gCompanyInfo.CALCFIELDS(gCompanyInfo.Picture);
                    gFormatAddress.Company(gCompanyAddress,gCompanyInfo);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                
                TotalSalary := 0;
                TotalAttendHours := 0;
                ScaleRate := 0;
                AverageSalary := 0;
                AverageHours := 0;
                SuggestedApraisalDeduction := '';
                SuggestedAmount := 0;
                
                // get all payroll ledger entry of employee between 2 dates
                PayrollLedgerEntry.RESET;
                PayrollLedgerEntry.SETRANGE("Employee No.","No.");
                PayrollLedgerEntry.SETFILTER("Payroll Date",'%1..%2',FromDate,ToDate);
                
                if PayrollLedgerEntry.FINDFIRST then
                begin
                repeat
                  TotalSalary := TotalSalary + PayrollLedgerEntry."Basic Salary";
                until PayrollLedgerEntry.NEXT=0;
                end;
                
                // get all attendance of employee between 2 dates
                EmployeeAbsence.RESET;
                EmployeeAbsence.SETRANGE("Employee No.","No.");
                EmployeeAbsence.SETFILTER("From Date",'%1..%2',FromDate,ToDate);
                
                if EmployeeAbsence.FINDFIRST then
                begin
                  repeat
                    TotalAttendHours := TotalAttendHours + EmployeeAbsence."Attend Hrs.";
                  until EmployeeAbsence.NEXT=0;
                end;
                
                if TotalAttendHours > 0 then
                  ScaleRate := ROUND(TotalSalary / TotalAttendHours,0.01);
                
                
                if PayrollLedgerEntry.COUNT > 0 then
                  AverageSalary := ROUND(TotalSalary / PayrollLedgerEntry.COUNT,0.01);
                
                if PayrollFunction.GetEmployeeMonthlyHours("No.",'') > 0 then
                  AverageHours  := ROUND(AverageSalary / PayrollFunction.GetEmployeeMonthlyHours("No.",''),0.01);
                /*
                IF EmployeeAbsence.COUNT <> 0 THEN
                  AverageHours := TotalAttendHours / EmployeeAbsence.COUNT;
                  */
                
                // get salary slip scale of employee
                SalarySlipScale.RESET;
                SalarySlipScale.SETFILTER("From Salary Scale",'<%1',ScaleRate);
                SalarySlipScale.SETFILTER("To Salary Scale",'>%1',ScaleRate);
                SalarySlipScale.SETRANGE(SalarySlipScale.Band,Employee.Band);
                SalarySlipScale.SETRANGE(SalarySlipScale.Grade,Employee.Grade);
                SalarySlipScale.SETRANGE(SalarySlipScale."Job Category",Employee."Job Category");
                SalarySlipScale.SETRANGE(SalarySlipScale."Job Title",Employee."Job Title");
                
                if SalarySlipScale.FINDFIRST then begin
                  SuggestedApraisalDeduction := FORMAT(SalarySlipScale."Appraisal And Deduction");
                  SuggestedAmount := SalarySlipScale.Amount;
                end;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FromDate;FromDate)
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin

                        ToDate:=CALCDATE('+1M-1D',FromDate);
                    end;
                }
                field(ToDate;ToDate)
                {
                    ApplicationArea=All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle_lbl = 'Salary Slip Report';FromDate_lbl = 'From Date';ToDate_lbl = 'To Date';EmployeeName_lbl = 'Employee Name';AverageSalary_lbl = 'Average Salary';AverageRateHour_lbl = 'Average Rate/Hour';CalculateScaleRate_lbl = 'Calculate Scale Rate';SuggestedAppraisalDeduction_lbl = 'Suggested Appraisal/Deduction';SuggestedAmount_lbl = 'Suggested Amount';}

    trigger OnInitReport();
    begin
        //Added in order to show/ Hide salary fields - 05.07.2016 : AIM +
        if  PayrollFunction.HideSalaryFields() = true then
           ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 05.07.2016 : AIM -
    end;

    trigger OnPreReport();
    begin

        if (FromDate = 0D) or (ToDate = 0D) then
          ERROR(BlankStartEndDateErr);
    end;

    var
        FromDate : Date;
        ToDate : Date;
        TotalSalary : Decimal;
        TotalAttendHours : Decimal;
        ScaleRate : Decimal;
        AverageSalary : Decimal;
        AverageHours : Decimal;
        SuggestedApraisalDeduction : Text;
        SuggestedAmount : Decimal;
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        EmployeeAbsence : Record "Employee Absence";
        SalarySlipScale : Record "Salary Slip Scale";
        gCompanyInfo : Record "Company Information";
        gFormatAddress : Codeunit "Format Address";
        gCompanyAddress : array [8] of Text;
        BlankStartEndDateErr : Label 'Starting date and ending date must be defined.';
        PayrollFunction : Codeunit "Payroll Functions";
}

