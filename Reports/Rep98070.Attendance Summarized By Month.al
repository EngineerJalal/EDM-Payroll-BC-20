report 98070 "Attendance Summarized By Month"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Summarized By Month.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(AttendanceNo_Employee;Employee."Attendance No.")
            {
            }
            column(VarDepartment;VarDepartment)
            {
            }
            column(Diff;varDiff)
            {
            }
            column(RequiredHrs;VarRequiredHrs)
            {
            }
            column(ActualHrs;VarActualHrs)
            {
            }
            column(FromPeriod;FromPeriod)
            {
            }
            column(TillPeriod;TillPeriod)
            {
            }

            trigger OnAfterGetRecord();
            begin
                VarRequiredHrs := 0;
                VarActualHrs := 0;
                varDiff := 0;

                EmpAbs.SETRANGE("Employee No.",Employee."No.");
                EmpAbs.SETFILTER("From Date",'%1..%2',FromPeriod,TillPeriod);
                if EmpAbs.FINDFIRST then
                  begin
                    repeat
                      VarRequiredHrs += EmpAbs."Required Hrs";
                      VarActualHrs += EmpAbs."Attend Hrs.";
                    until EmpAbs.NEXT = 0;
                    EmpAbs.CALCFIELDS(Department);
                    DimensionValue.SETRANGE("Dimension Code",'DEPARTMENT');
                    DimensionValue.SETRANGE(Code,EmpAbs.Department);
                    if DimensionValue.FINDFIRST then
                    VarDepartment := DimensionValue.Name;
                  end;

                varDiff := VarActualHrs - VarRequiredHrs;
            end;

            trigger OnPreDataItem();
            begin
                if FromPeriod = 0D then
                  ERROR('Please enter "From period"');
                if TillPeriod = 0D then
                  ERROR('Please enter "Till period"');

                Employee.SETFILTER(Status,'%1',Employee.Status::Active);
                Employee.SETFILTER("Attendance No.",'<>%1',0);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Period";FromPeriod)
                {
                    ApplicationArea=All;
                }
                field("Till Period";TillPeriod)
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
    }

    var
        VarDepartment : Text;
        varDiff : Decimal;
        VarRequiredHrs : Decimal;
        VarActualHrs : Decimal;
        FromPeriod : Date;
        TillPeriod : Date;
        EmpAbs : Record "Employee Absence";
        AttendanceNo : Integer;
        DimensionValue : Record "Dimension Value";
}

