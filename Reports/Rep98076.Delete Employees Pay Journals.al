report 98076 "Delete Employees Pay Journals"
{
    // version EDM.HRPY2

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {

            trigger OnAfterGetRecord();
            begin
                PayrollFunction.DeleteEmployeePayrollJournals(Employee."No.",HRTransactionType,FromDate,TillDate);
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE('Process competed');
            end;

            trigger OnPreDataItem();
            begin
                if not CONFIRM('Are you sure you want to delete Employee Journals ?',false) then
                  ERROR('');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'Option';
                group("Report Filter")
                {
                    field("Transaction Type";HRTransactionType)
                    {
                        TableRelation = "HR Transaction Types".Code WHERE (System=FILTER(false),"Associated Pay Element"=FILTER(<>''));
                        ApplicationArea=All;
                    }
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
        HRTransactionType : Code[20];
        FromDate : Date;
        TillDate : Date;
        PayrollFunction : Codeunit "Payroll Functions";
        AllowDelete : Boolean;
}

