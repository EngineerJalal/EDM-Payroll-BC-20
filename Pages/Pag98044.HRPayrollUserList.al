page 98044 "HR Payroll User List"
{
    // version SHR1.0,PY1.0,EDM.HRPY1

    DataCaptionFields = "Payroll Group Code";
    Editable = false;
    PageType = List;
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
            }
        }
    }

    actions
    {
    }
}

