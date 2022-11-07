report 98078 "Import Credit Cost Calculation"
{
    // version EDM.HRPY2

    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Payroll Date"; PayrollDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Delete Existing"; DeleteExisting)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            // Added in order to delete Exsiting Data - 20.07.2017 : A2+
            DeleteExisting := true;
            // Added in order to delete Exsiting Data - 20.07.2017 : A2-
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin

        if PayrollFunctions.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
    end;

    trigger OnPostReport();
    var
        HRSetup: Record "Human Resources Setup";
    begin
        HumanResourceFunctions.ImportCreditCostCalculation(PayrollDate, DeleteExisting);

    end;

    trigger OnPreReport();
    begin

        if PayrollDate = 0D then
            ERROR('You must select a payroll date!');
    end;

    var
        HumanResourceFunctions: Codeunit "Human Resource Functions";
        PayrollDate: Date;
        PayrollFunctions: Codeunit "Payroll Functions";
        DeleteExisting: Boolean;
}

