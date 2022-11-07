page 98118 "Employees Attendance Dimension"
{
    // version EDM.HRPY2

    PageType = List;
    SourceTable = "Employees Attendance Dimension";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No";"Employee No")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Attendance No";"Attendance No")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field(Period;Period)
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Attendance Day";"Attendance Day")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Attendance Date";"Attendance Date")
                {
                    ApplicationArea=All;
                }
                field("Required Hrs";"Required Hrs")
                {
                    Editable = true;
                    Enabled = true;
                    ApplicationArea=All;
                }
                field("Attended Hrs";"Attended Hrs")
                {
                    ApplicationArea=All;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea=All;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea=All;
                }
                field("Global Dimension 1";"Global Dimension 1")
                {
                    ApplicationArea=All;
                }
                field("Global Dimension 2";"Global Dimension 2")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 3";"Shortcut Dimension 3")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 4";"Shortcut Dimension 4")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 5";"Shortcut Dimension 5")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 6";"Shortcut Dimension 6")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 7";"Shortcut Dimension 7")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 8";"Shortcut Dimension 8")
                {
                    ApplicationArea=All;
                }
                field("Line No";"Line No")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("From Time";"From Time")
                {
                    ApplicationArea=All;
                }
                field("To Time";"To Time")
                {
                    ApplicationArea=All;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea=All;
                }
                field("Created By";"Created By")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Created DateTime";"Created DateTime")
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

