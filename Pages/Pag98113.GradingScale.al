page 98113 "Grading Scale"
{
    // version EDM.PYPS1,EDM.HRPY2

    SourceTable = "Grading Scale";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Category";"Employee Category")
                {
                    ApplicationArea=All;
                }
                field("Employee Category Name";"Employee Category Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Grade Code";"Grade Code")
                {
                    ApplicationArea=All;
                }
                field("Grade Amount";"Grade Amount")
                {
                    ApplicationArea=All;
                }
                field("Grade Basic Salary";"Grade Basic Salary")
                {
                    ApplicationArea=All;
                }
                field("Grade Cost of Living";"Grade Cost of Living")
                {
                    ApplicationArea=All;
                }
                field("Grade Description";"Grade Description")
                {
                    ApplicationArea=All;
                }
                field("Grade Sequence";"Grade Sequence")
                {
                    ApplicationArea=All;
                }
                field("Grade Update Interval";"Grade Update Interval")
                {
                    ApplicationArea=All;
                }
                field("Grade Interval Type";"Grade Interval Type")
                {
                    ApplicationArea=All;
                }
                field("Grade Effective Date";"Grade Effective Date")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Is Inactive";"Is Inactive")
                {
                    Visible = false;
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
        if not PayrollFunctions.UseGradingSystem then
          CurrPage.CLOSE;

        if PayrollFunctions.HideSalaryFields() then
          ERROR('You do not have permission');
    end;

    trigger OnQueryClosePage(CloseAction : Action) : Boolean;
    begin
        if Rec.FINDFIRST then repeat
            TESTFIELD("Employee Category");
            TESTFIELD("Grade Code");
            TESTFIELD("Grade Basic Salary");
            TESTFIELD("Grade Sequence");
            TESTFIELD("Grade Interval Type");
            TESTFIELD("Grade Effective Date");
            TESTFIELD("Grade Update Interval");
        until Rec.NEXT = 0;
        exit(true)
    end;

    var
        PayrollFunctions : Codeunit "Payroll Functions";
}

