page 98045 "HR Payroll Group List"
{
    // version SHR1.0,PY1.0,EDM.HRPY1

    CardPageID = "HR Payroll Group";
    Editable = false;
    PageType = List;
    SourceTable = "HR Payroll Group";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field("Employees Assigned";Rec."Employees Assigned")
                {
                    ApplicationArea=All;
                }
                field("Users Assigned";Rec."Users Assigned")
                {
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
        /*IF USERID <> '' THEN
          HRFunction.SetPayGroupFilter(Rec);*/

    end;

    var
        HRFunction : Codeunit "Human Resource Functions";
}

