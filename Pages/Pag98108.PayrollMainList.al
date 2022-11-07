page 98108 "Payroll Main List"
{
    // version EDM.HRPY2

    CardPageID = "Payroll Sub Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payroll Sub Main";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Ref Code";"Ref Code")
                {
                    ApplicationArea=All;
                }
                field("Pay Date";"Pay Date")
                {
                    ApplicationArea=All;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Dynamic Payslip")
            {
                Image = "Report";
                RunObject = Report "Gen. Atten. Job Jrnl By Proj.";
                ApplicationArea=All;
            }
        }
    }
}

