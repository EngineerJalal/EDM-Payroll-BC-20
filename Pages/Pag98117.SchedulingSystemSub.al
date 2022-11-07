page 98117 "Scheduling System Sub"
{
    // version EDM.HRPY2

    PageType = ListPart;
    SourceTable = "Scheduling System Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No";"Line No")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Week Day";"Week Day")
                {
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
                field(Hours;Hours)
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
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    begin
        "Schedule Type" := "Schedule Type"::Teaching;
    end;
}

