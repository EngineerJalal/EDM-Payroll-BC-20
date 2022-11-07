report 98034 "Copy Employee Dimensions"
{
    // version EDM.HRPY1

    ProcessingOnly = true;

    dataset
    {
        dataitem("Employee Dimensions";"Employee Dimensions")
        {
            RequestFilterFields = "Payroll Date";

            trigger OnAfterGetRecord();
            begin

                if NewDate = 0D then
                    exit;

                EmpDimension.SETRANGE("Employee No.","Employee No.");
                EmpDimension.SETRANGE("Payroll Date",NewDate);

                EmpDimension.SETRANGE("Dimension Code","Dimension Code");
                EmpDimension.SETRANGE("Dimension Value Code","Dimension Value Code");
                EmpDimension.SETRANGE("Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 3 Code","Shortcut Dimension 3 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 4 Code","Shortcut Dimension 4 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 5 Code","Shortcut Dimension 5 Code");
                // 14.02.2018 : A2+
                EmpDimension.SETRANGE("Shortcut Dimension 6 Code","Shortcut Dimension 6 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 7 Code","Shortcut Dimension 7 Code");
                EmpDimension.SETRANGE("Shortcut Dimension 8 Code","Shortcut Dimension 8 Code");
                // 14.02.2018 : A2-
                EmpDimension.SETRANGE(Resource,Resource);


                if EmpDimension.FINDFIRST = false then
                  begin
                       EmpDimension.INIT;
                       EmpDimension."Employee No."   := "Employee No.";
                       EmpDimension."Payroll Date" := NewDate;
                       EmpDimension."Dimension Code" :=  "Dimension Code";
                       EmpDimension."Dimension Value Code" :=  "Dimension Value Code";
                       EmpDimension.Percentage :=  Percentage;
                       EmpDimension."Shortcut Dimension 1 Code" :=  "Shortcut Dimension 1 Code";
                       EmpDimension."Shortcut Dimension 2 Code" :=  "Shortcut Dimension 2 Code";
                       EmpDimension."Employee Name" :=  "Employee Name";
                       EmpDimension."Shortcut Dimension 3 Code" :=  "Shortcut Dimension 3 Code";
                       EmpDimension."Shortcut Dimension 4 Code" :=  "Shortcut Dimension 4 Code";
                       EmpDimension."Shortcut Dimension 5 Code" :=  "Shortcut Dimension 5 Code";
                       // 14.02.2018 : A2+
                       EmpDimension."Shortcut Dimension 6 Code" := "Shortcut Dimension 6 Code";
                       EmpDimension."Shortcut Dimension 7 Code" := "Shortcut Dimension 7 Code";
                       EmpDimension."Shortcut Dimension 8 Code" := "Shortcut Dimension 8 Code";
                       // 14.02.2018 : A2-
                       EmpDimension.Resource :=  Resource;

                       EmpDimension.INSERT(true);

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
                group(Control2)
                {
                    field(CopyToDate;NewDate)
                    {
                        Caption = 'Copy to Date';
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
        NewDate : Date;
        EmpDimension : Record "Employee Dimensions";
}

