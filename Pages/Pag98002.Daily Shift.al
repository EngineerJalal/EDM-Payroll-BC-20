page 98002 "Daily Shift"
{
    // version EDM.HRPY1

    PageType = List;
    SourceTable = "Daily Shifts";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Shift Code";Rec."Shift Code")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //Added in order to insert default values - 16.06.2016 : AIM +
                        if Rec."Shift Code" <> '' then
                          begin
                            Rec.Type := DailyShiftTbt.Type::"Working Day";
                            CauseofAbsenceTbt.SETRANGE(CauseofAbsenceTbt.Code,'WD');
                            if CauseofAbsenceTbt.FINDFIRST then
                              Rec."Cause Code" := 'WD';
                          end;
                        //Added in order to insert default values - 16.06.2016 : AIM -
                    end;
                }
                field("From Time";Rec."From Time")
                {
                    ApplicationArea=All;
                }
                field("To Time";Rec."To Time")
                {
                    ApplicationArea=All;
                }
                field("Force Lunch Break";Rec."Force Lunch Break")
                {
                    ApplicationArea=All;
                }
                field("Lunch Break Start time";Rec."Lunch Break Start time")
                {
                    ApplicationArea=All;
                }
                field("Allowed Break Minute";Rec."Allowed Break Minute")
                {
                    Caption = 'Allowed Break / Minute';
                    ApplicationArea=All;
                }
                field("Cause Code";Rec."Cause Code")
                {
                    ApplicationArea=All;
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea=All;
                }
                field(Tolerance;Rec.Tolerance)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Break";Rec."Break")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Overtime Rate";Rec."Overtime Rate")
                {
                    ApplicationArea=All;
                }
                field("Absence Deduction Rate";Rec."Absence Deduction Rate")
                {
                    ApplicationArea=All;
                }
                field("Unpaid Overtime Hrs";Rec."Unpaid Overtime Hrs")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    var
        DailyShiftTbt : Record "Daily Shifts";
        CauseofAbsenceTbt : Record "Cause of Absence";
        HRFunctions : Codeunit "Human Resource Functions";
}

