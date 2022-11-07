page 98041 "Employee Swaped Days"
{
    // version SHR1.0,EDM.HRPY2

    Editable = false;
    PageType = Card;
    SourceTable = "Employee Journal Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Swap No.";"Swap No.")
                {
                    ApplicationArea=All;
                }
                field("Swap Employee No.";"Swap Employee No.")
                {
                    ApplicationArea=All;
                }
                field("Swap From Date";"Swap From Date")
                {
                    ApplicationArea=All;
                }
                field("Swap To Date";"Swap To Date")
                {
                    ApplicationArea=All;
                }
                field("Swap From Working Shift Code";"Swap From Working Shift Code")
                {
                    ApplicationArea=All;
                }
                field("Swap To Working Shift Code";"Swap To Working Shift Code")
                {
                    ApplicationArea=All;
                }
                field("Swap From Shift Group Code";"Swap From Shift Group Code")
                {
                    ApplicationArea=All;
                }
                field("Swap To Shift Group Code";"Swap To Shift Group Code")
                {
                    ApplicationArea=All;
                }
                field("Swap To Shortcut Dim 1 Code";"Swap To Shortcut Dim 1 Code")
                {
                    ApplicationArea=All;
                }
                field("Swap To Shortcut Dim 2 Code";"Swap To Shortcut Dim 2 Code")
                {
                    ApplicationArea=All;
                }
                field("Swap To Base Calendar Code";"Swap To Base Calendar Code")
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

