report 98112 "Copy Empl. Dim. To New Empl."
{
    // version EDM.HRPY1

    ProcessingOnly = true;

    dataset
    {
        dataitem("Employee Dimensions";"Employee Dimensions")
        {
            RequestFilterFields = "Employee No.","Payroll Date";

            trigger OnAfterGetRecord();
            begin

                IF NewEmployee = '' THEN
                    EXIT;

                EmpDimension.SETRANGE("Employee No.",NewEmployee);
                EmpDimension.SETRANGE("Payroll Date","Payroll Date");

                EmpDimension.SETRANGE("Dimension Code","Dimension Code");
                EmpDimension.SETRANGE("Dimension Value Code","Dimension Value Code");
                EmpDimension.SETRANGE("Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 3 Code","Shortcut Dimension 3 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 4 Code","Shortcut Dimension 4 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 5 Code","Shortcut Dimension 5 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 6 Code","Shortcut Dimension 6 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 7 Code","Shortcut Dimension 7 Code");
                //EmpDimension.SETRANGE("Shortcut Dimension 8 Code","Shortcut Dimension 8 Code");
                EmpDimension.SETRANGE(Resource,Resource);


                IF EmpDimension.FINDFIRST = FALSE THEN
                  BEGIN
                    EmpDimension.INIT;
                    EmpDimension.VALIDATE("Employee No.",NewEmployee);
                    EmpDimension."Payroll Date" := "Payroll Date";
                    EmpDimension."Dimension Code" :=  "Dimension Code";
                    EmpDimension."Dimension Value Code" :=  "Dimension Value Code";
                    EmpDimension.Percentage :=  Percentage;
                    EmpDimension."Shortcut Dimension 1 Code" :=  "Shortcut Dimension 1 Code";
                    EmpDimension."Shortcut Dimension 2 Code" :=  "Shortcut Dimension 2 Code";
                    Employee.GET(NewEmployee);
                    EmpDimension."Employee Name" :=  Employee."Full Name";
                    EmpDimension."Shortcut Dimension 3 Code" :=  "Shortcut Dimension 3 Code";
                    EmpDimension."Shortcut Dimension 4 Code" :=  "Shortcut Dimension 4 Code";
                    EmpDimension."Shortcut Dimension 5 Code" :=  "Shortcut Dimension 5 Code";
                    EmpDimension."Shortcut Dimension 6 Code" :=  "Shortcut Dimension 6 Code";
                    EmpDimension."Shortcut Dimension 7 Code" :=  "Shortcut Dimension 7 Code";
                    //EmpDimension."Shortcut Dimension 8 Code" :=  "Shortcut Dimension 8 Code";
                    EmpDimension.Resource :=  Resource;

                    EmpDimension.INSERT(TRUE);

                  END;
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
                    field(CopyToEmployee;NewEmployee)
                    {
                        Caption = 'Copy To Employee';
                        TableRelation = Employee;
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
        NewEmployee : Code[20];
        EmpDimension : Record "Employee Dimensions";
        Employee : Record Employee;
}

