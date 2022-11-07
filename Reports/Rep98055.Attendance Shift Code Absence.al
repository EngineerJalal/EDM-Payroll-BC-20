report 98055 "Attendance Shift Code(Absence)"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Shift Code(Absence).rdlc';

    dataset
    {
        dataitem("Employee Journal Line";"Employee Journal Line")
        {
            column(TransactionType_EmployeeJournalLine;"Employee Journal Line"."Transaction Type")
            {
            }
            column(EmployeeNo_EmployeeJournalLine;"Employee Journal Line"."Employee No.")
            {
            }
            column(EntryNo_EmployeeJournalLine;"Employee Journal Line"."Entry No.")
            {
            }
            column(EmployeeStatus_EmployeeJournalLine;"Employee Journal Line"."Employee Status")
            {
            }
            column(DocumentStatus_EmployeeJournalLine;"Employee Journal Line"."Document Status")
            {
            }
            column(EndingDate_EmployeeJournalLine;"Employee Journal Line"."Ending Date")
            {
            }
            column(TransactionDate_EmployeeJournalLine;"Employee Journal Line"."Transaction Date")
            {
            }
            column(CalculatedValue_EmployeeJournalLine;"Employee Journal Line"."Calculated Value")
            {
            }
            column(CauseofAbsenceCode_EmployeeJournalLine;"Employee Journal Line"."Cause of Absence Code")
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(From_Date;FromDate)
            {
            }
            column(To_Date;ToDate)
            {
            }
            column(Shift_Code;ShiftCode)
            {
            }

            trigger OnAfterGetRecord();
            begin
                EmployeeTbt.SETRANGE("No.","Employee Journal Line"."Employee No.");
                if EmployeeTbt.FINDFIRST then
                  EmployeeName := EmployeeTbt."First Name";
            end;

            trigger OnPreDataItem();
            begin
                SETFILTER("Employee Journal Line"."Starting Date",'%1..%2',FromDate,ToDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control2)
                {
                    field(FromDate;FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea=All;
                    }
                    field(ToDate;ToDate)
                    {
                        Caption = 'To Date';
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
            FromDate := DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
            //Modified because Date is wrongly calculated - 08.04.2017 : AIM +
            //ToDate := CALCDATE('CM',WORKDATE);
            ToDate := DMY2DATE(Payrollfunction.GetLastDayinMonth(WORKDATE),DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
            //Modified because Date is wrongly calculated - 08.04.2017 : AIM -
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        if FromDate = 0D then
          ERROR('Please Fill Starting Date');
        if ToDate = 0D then
          ToDate := TODAY;
    end;

    var
        EmployeeTbt : Record Employee;
        FromDate : Date;
        ToDate : Date;
        EmployeeName : Text;
        ShiftCode : Code[10];
        Payrollfunction : Codeunit "Payroll Functions";
}

