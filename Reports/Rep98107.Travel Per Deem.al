report 98107 "Travel Per Deem"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Travel Per Deem.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.","Payroll Group Code";
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(EmploymentDate_Employee;Employee."Employment Date")
            {
            }
            column(BasicPay_Employee;Employee."Basic Pay")
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(TillDate;TillDate)
            {
            }
            column(EmpTravelCode;EmpTravelCode)
            {
            }
            column(EmpTravelName;EmpTravelName)
            {
            }
            column(PerDeemPerc;PerDeemPerc)
            {
            }
            column(PerDeemAmt;PerDeemAmt)
            {
            }
            column(TravelDays;TravelDays)
            {
            }
            column(ServiceYear;ServiceYear)
            {
            }

            trigger OnAfterGetRecord();
            begin
                ServiceYear := 0;
                PerDeemPerc := 0;
                PerDeemAmt := 0;
                TravelDays := 0;

                ServiceYear := (WORKDATE - Employee."Employment Date") / 360;

                HRSetup.GET();
                EmpAbsence.SETRANGE("Shift Code",HRSetup."Travel Per Deem Shift Code");
                EmpAbsence.SETRANGE("From Date",FromDate,TillDate);
                EmpAbsence.SETRANGE("Employee No.",Employee."No.");
                IF EmpAbsence.FINDFIRST THEN
                  TravelDays := EmpAbsence.COUNT;

                EmployeeAdditionalInfo.GET(Employee."No.");
                EmpTravelPerDeem.SETRANGE("Policy Code",EmployeeAdditionalInfo."Travel Per Deem Policy");
                IF EmpTravelPerDeem.FINDFIRST THEN
                REPEAT
                  IF (EmpTravelPerDeem."Employment Years (From)" <= ServiceYear) AND (ServiceYear <= EmpTravelPerDeem."Employment Years (To)") THEN
                  BEGIN
                    PerDeemPerc := EmpTravelPerDeem."Employment Years (To)";
                    PerDeemAmt := Employee."Basic Pay" * EmpTravelPerDeem."Per Deem % Of Basic Salary" / 100;
                  END;
                UNTIL EmpTravelPerDeem.NEXT = 0;
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
                    field("From Date";FromDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Till Date";TillDate)
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
    }

    var
        FromDate : Date;
        TillDate : Date;
        EmployeeAdditionalInfo : Record "Employee Additional Info";
        EmpTravelPerDeem : Record "Emp. Travel Per Deem Policy";
        EmpTravelCode : Code[20];
        EmpTravelName : Text[150];
        EmployeeAbsence : Record "Employee Absence";
        PerDeemPerc : Decimal;
        PerDeemAmt : Decimal;
        TravelDays : Decimal;
        ServiceYear : Decimal;
        HRSetup : Record "Human Resources Setup";
        EmpAbsence : Record "Employee Absence";
}

