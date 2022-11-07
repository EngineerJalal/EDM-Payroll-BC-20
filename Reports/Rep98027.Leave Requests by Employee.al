report 98027 "Leave Requests by Employee"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Leave Requests by Employee.rdlc';

    dataset
    {
        dataitem("Leave Request";"Leave Request")
        {
            DataItemTableView = SORTING("Employee No.","From Date") ORDER(Ascending);
            RequestFilterFields = "Employee No.";
            column(EmployeeNo;"Leave Request"."Employee No.")
            {
            }
            column(EmployeeName;gEmployeeName)
            {
            }
            column(EmploymentDate;gEmploymentDate)
            {
            }
            column(Balance;gBalance)
            {
            }
            column(LeaveType;"Leave Request"."Leave Type")
            {
            }
            column(LR_Date;"Leave Request"."From Date")
            {
            }
            column(DaysValue;"Leave Request"."Days Value")
            {
            }
            column(IsTaken;gIsTaken)
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
                column(StartDate;gStartDate)
                {
                }
                column(EndDate;gEndDate)
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

                gIsTaken := false;

                gEmployee.GET("Employee No.");
                gEmployeeName := gEmployee."Full Name";
                gEmploymentDate := gEmployee."Employment Date";

                if "Leave Request"."To Date" < TODAY then
                  gIsTaken := true;

                gBalance := gPayrollFuctionsCodeUnit.GetEmpAbsenceEntitlementCurrentBalance("Employee No.","Leave Type",0D);
            end;

            trigger OnPreDataItem();
            begin

                SETRANGE("From Date",gStartDate,gEndDate);
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
                    Caption = 'Options';
                    field(StartDate;gStartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea=All;
                    }
                    field(EndDate;gEndDate)
                    {
                        Caption = 'End Date';
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

            gEndDate := WORKDATE;
        end;
    }

    labels
    {
        ReportTitle_lbl = 'Leave Request Report';StartDate_lbl = 'Start Date';EndDate_lbl = 'End Date';EmployeeCode_lbl = 'Employee Code';EmployeeName_lbl = 'Employee Name';LR_Type_lbl = 'Leave Request Type';EmploymentDate_lbl = 'Employment Date';LR_Balance_lbl = 'Leave Request Balance';LR_Date_lbl = 'Leave Date';Nb_Days_lbl = 'Nb Days';}

    trigger OnPreReport();
    begin

        if (gStartDate = 0D) or (gEndDate = 0D) then
          ERROR(BlankStartEndDateErr);
    end;

    var
        gEmployee : Record Employee;
        gEmployeeName : Text;
        gEmploymentDate : Date;
        gBalance : Decimal;
        gNbDays : Decimal;
        gIsTaken : Boolean;
        gStartDate : Date;
        gEndDate : Date;
        BlankStartEndDateErr : Label 'Starting date and ending date must be defined.';
        gCompanyInfo : Record "Company Information";
        gFormatAddress : Codeunit "Format Address";
        gCompanyAddress : array [8] of Text;
        gPayrollFuctionsCodeUnit : Codeunit "Payroll Functions";
}

