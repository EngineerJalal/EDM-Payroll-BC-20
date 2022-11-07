page 98043 "HR Payroll User"
{
    // version SHR1.0;PY1.0,EDM.HRPY1

    DataCaptionFields = "Payroll Group Code";
    PageType = List;
    Permissions = TableData "HR Payroll User"=rimd;
    SourceTable = "HR Payroll User";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("User Type";"User Type")
                {
                    ApplicationArea=All;
                }
                field("User Id";"User Id")
                {
                    ApplicationArea=All;
                }
                field(Name;Name)
                {
                    ApplicationArea=All;
                }
                field("Hide Salary";"Hide Salary")
                {
                    ApplicationArea=All;
                }
                field("Disable Delete Emp Rec";"Disable Delete Emp Rec")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

