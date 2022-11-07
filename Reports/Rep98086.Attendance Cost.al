report 98086 "Attendance Cost"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Cost.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(No_Employee; Employee."No.")
            {
            }
            column(FullName_Employee; Employee."Full Name")
            {
            }
            column(DailyRate; DailyRate)
            {
            }
            column(FPeriod; FPeriod)
            {
            }
            column(TPeriod; TPeriod)
            {
            }
            dataitem("Employee Absence"; "Employee Absence")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                column(CauseofAbsenceCode_EmployeeAbsence; "Employee Absence"."Cause of Absence Code")
                {
                }

                trigger OnPreDataItem();
                begin
                    "Employee Absence".SETFILTER("Employee Absence"."From Date", '%1..%2', FPeriod, TPeriod);
                    "Employee Absence".SETFILTER("Employee Absence".Type, '%1|%2|%3|%4|%5', "Employee Absence".Type::AL, "Employee Absence".Type::"Sick Day",
                                                 "Employee Absence".Type::"Unpaid Vacation", "Employee Absence".Type::"Work Accident", "Employee Absence".Type::"Paid Vacation");
                end;
            }

            trigger OnAfterGetRecord();
            begin
                DailyRate := 0;

                if Employee."Daily Rate" <> 0 then
                    DailyRate := Employee."Daily Rate"
                else begin
                    EmploymentType.RESET;
                    EmploymentType.SETRANGE(Code, Employee."Employment Type Code");
                    if EmploymentType.FINDFIRST then
                        if EmploymentType."Working Days Per Month" <> 0 then//EDM.AI
                            DailyRate := Employee."Basic Pay" / EmploymentType."Working Days Per Month";
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
                group("Report Filter")
                {
                    field("From Date"; FPeriod)
                    {
                        ApplicationArea = All;
                    }
                    field("Till Date"; TPeriod)
                    {
                        ApplicationArea = All;
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
        FPeriod: Date;
        TPeriod: Date;
        DailyRate: Decimal;
        EmploymentType: Record "Employment Type";
}

