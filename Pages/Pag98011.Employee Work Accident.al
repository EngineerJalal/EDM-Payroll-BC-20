page 98011 "Employee Work Accident"
{
    // version SHR1.0,EDM.HRPY1

    PageType = Card;
    SourceTable = "Employee Work Accidents";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Employee No.";Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Date;Rec.Date)
                {
                    ApplicationArea=All;
                }
                field("Accident Code";Rec."Accident Code")
                {
                    ApplicationArea=All;
                }
                field("Injured Part Code";Rec."Injured Part Code")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Reason;Rec.Reason)
                {
                    ApplicationArea=All;
                }
                field(Severity;Rec.Severity)
                {
                    ApplicationArea=All;
                }
                field("Hospital Name";Rec."Hospital Name")
                {
                    ApplicationArea=All;
                }
                field("Rest Period";Rec."Rest Period")
                {
                    ApplicationArea=All;
                }
                field("Declaration No.";Rec."Declaration No.")
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

