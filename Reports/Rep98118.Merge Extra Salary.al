report 98118 "Merge Extra Salary"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = ORDER(Ascending) WHERE(Status=CONST(Active));
            RequestFilterFields = "No.","Payroll Group Code";

            trigger OnPreDataItem();
            var
            begin

            end;

            trigger OnAfterGetRecord();
            var
            begin
                GEmployee.SetRange("No.",Employee."No.");
                if GEmployee.FindFirst then begin
                    GEmployeeAdditionalInfo.SetRange("Employee No.",Employee."No.");
                    if GEmployeeAdditionalInfo.FindFirst then begin
                        GEmployee."Basic Pay" := GEmployee."Basic Pay"+GEmployeeAdditionalInfo."Extra Salary";
                        GEmployee.Modify;
                    end;
                end;
                //
                GEmployeeAdditionalInfo.SetRange("Employee No.","No.");
                if GEmployeeAdditionalInfo.FindFirst then begin  
                    GEmployeeAdditionalInfo."Extra Salary":=0;  
                    GEmployeeAdditionalInfo.Modify;  
                end;     
                Message('Extra Salary Has been Merged');  
            end;
        }
    }

    var
    GEmployeeAdditionalInfo : Record "Employee Additional Info";
    GEmployee : Record Employee;
}

