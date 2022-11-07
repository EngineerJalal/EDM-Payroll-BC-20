page 98018 "Employee Categories"
{
    // version SHR1.0,EDM.HRPY1

    PageType = List;
    SourceTable = "Employee Categories";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field("Additional Description";Rec."Additional Description")
                {
                    ApplicationArea=All;
                }
                field("Employee Type";Rec."Employee Type")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Total Employees";Rec."Total Employees")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Update All Absences";Rec."Update All Absences")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Use Grading System";Rec."Use Grading System")
                {
                    Visible = UseGrade;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Emp.Categ.")
            {
                Caption = 'Emp.Categ.';
                Visible = false;
            }
        }
    }

    trigger OnOpenPage();
    begin
        // 13.10.2017 : A2+
        UseGrade := PayFunction.IsFeatureVisible('GradingSystem');
        // 13.10.2017 : A2-
    end;

    var
        UseGrade : Boolean;
        PayFunction : Codeunit "Payroll Functions";
}

