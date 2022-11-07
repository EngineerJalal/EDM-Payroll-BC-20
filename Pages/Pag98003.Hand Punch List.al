page 98003 "Hand Punch List"
{
    // version EDM.HRPY1

    PageType = List;
    SourceTable = "Hand Punch";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Attendnace No."; Rec."Attendnace No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Date Time"; Rec."Date Time")
                {
                    ApplicationArea = All;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                }
                field("Real Date"; Rec."Real Date")
                {
                    ApplicationArea = All;
                }
                field("Real Time"; Rec."Real Time")
                {
                    ApplicationArea = All;
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                }
                field("Modification Date"; Rec."Modification Date")
                {
                    ApplicationArea = All;
                }
                field("Scheduled Date"; Rec."Scheduled Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnModifyRecord(): Boolean;
    begin
        Rec."Modified By" := USERID;
        Rec."Modification Date" := WORKDATE;
        Rec.Modify;
        //CurrPage.Update();//NED+-
    end;
}

