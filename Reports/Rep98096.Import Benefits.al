report 98096 "Import Benefits"
{
    // version EDM.IT - ASuhail,EDM.HRPY1

    Caption = 'Import Journals From Excel';
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
                field("Payroll Period"; PayrollPeriod)
                {
                    ApplicationArea = All;
                }
                field("Auto Approve"; AutoApprove)
                {
                    ApplicationArea = All;
                }
                field("Delete Existing"; DeleteExisting)
                {
                    ApplicationArea = All;
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

    trigger OnInitReport();
    begin
        PayrollOfficerPermission := PayrollFunctions.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission = false then
            Error('No Permission!');

        if PayrollFunctions.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
    end;

    trigger OnPostReport();
    var
        HumanResourceSetup: record "Human Resources Setup";
    begin
        PayrollFunctions.ImportEmployeeBenefits(AutoApprove, DeleteExisting);
        Message('Proccess Done');
    end;

    var
        PayrollPeriod: Date;
        PayrollFunctions: Codeunit "Payroll Functions";
        AutoApprove: Boolean;
        DeleteExisting: Boolean;
        PayrollOfficerPermission: Boolean;

}