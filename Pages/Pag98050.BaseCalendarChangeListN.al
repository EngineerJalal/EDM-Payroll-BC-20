page 98050 "Base Calendar Change List N"
{
    // version NAVW16.00.01,EDM.HRPY1

    Caption = 'Base Calendar Change List';
    DataCaptionFields = "Base Calendar Code";
    Editable = true;
    PageType = List;
    SourceTable = "Base Calendar Change N";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Base Calendar Code";Rec."Base Calendar Code")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Recurring System";Rec."Recurring System")
                {
                    Caption = 'Recurring System';
                    ApplicationArea=All;
                }
                field(Date;Rec.Date)
                {
                    ApplicationArea=All;
                }
                field(Day;Rec.Day)
                {
                    ApplicationArea=All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field(Nonworking;Rec.Nonworking)
                {
                    Caption = 'Nonworking';
                    ApplicationArea=All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
                ApplicationArea=All;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
                ApplicationArea=All;
            }
        }
    }

    actions
    {
    }
}

