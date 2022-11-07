page 98120 "Pension Types"
{
    // version EDM.HRPY1

    PageType = List;
    SourceTable = "Pension Types";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pension Code";"Pension Code")
                {
                    ApplicationArea=All;
                }
                field("Pension Name";"Pension Name")
                {
                    ApplicationArea=All;
                }
                field("Pension Type";"Pension Type")
                {
                    ApplicationArea=All;
                }
                field("Pension Labor Law";"Pension Labor Law")
                {
                    ApplicationArea=All;
                }
                field("Amount Type Classification";"Amount Type Classification")
                {
                    ApplicationArea=All;
                }
                field("Formula Type";"Formula Type")
                {
                    ApplicationArea=All;
                }
                field("Pension Employer Percent";"Pension Employer Percent")
                {
                    ApplicationArea=All;
                }
                field("Pension Employee Percent";"Pension Employee Percent")
                {
                    ApplicationArea=All;
                }
                field("Pension Inactive";"Pension Inactive")
                {
                    ApplicationArea=All;
                }
            }
        }
    }
    trigger OnOpenPage();
    begin 
        FilterGroup(2);
        PayrollParameter.Get;
        Rec.SetRange("Pension Labor Law",PayrollParameter."Payroll Labor Law");
        FilterGroup(0);
    end;

    var
    PayrollParameter :Record "Payroll Parameter";
}

