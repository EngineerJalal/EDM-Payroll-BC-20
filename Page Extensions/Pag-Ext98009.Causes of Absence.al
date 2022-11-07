pageextension 98009 "ExtCausesofAbsence" extends "Causes of Absence"
{

    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Working Day Multiplier"; Rec."Working Day Multiplier")
            {
                Caption = 'Working Day Multiplier';
                ApplicationArea=All;
            }
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea=All;
            }
            field(Vacation; Rec.Vacation)
            {
                ApplicationArea=All;
            }
            field("Affect Work Days"; Rec."Affect Work Days")
            {
                ApplicationArea=All;
            }
            field("Affect Attendance Days"; Rec."Affect Attendance Days")
            {
                ApplicationArea=All;
            }
            field("Associated Pay Element"; Rec."Associated Pay Element")
            {
                ApplicationArea=All;
            }
            field("Unpaid Hours"; Rec."Unpaid Hours")
            {
                Visible = false;
                ApplicationArea=All;
            }
            field(Convertible; Rec.Convertible)
            {
                ApplicationArea=All;
            }
            field("Show in Web Leave Request"; Rec."Show in Web Leave Request")
            {
                Visible = false;
                ApplicationArea=All;
            }
            field("Category Type"; Rec."Category Type")
            {
                ApplicationArea=All;
            }
            field("Zoho Code"; Rec."Zoho Code")
            {
                Visible = false;
                ApplicationArea=All;
            }
            field("Not Use"; Rec."Not Use")
            {
                ApplicationArea=All;
            }
            field("Request Category Type"; Rec."Request Category Type")
            {
                ApplicationArea=All;
            }
            field("Portal Leave Sub-Type"; Rec."Portal Leave Sub-Type")
            {
                ApplicationArea=All;
            }
            field("Allow Negative Bal-Portal"; Rec."Allow Negative Bal-Portal")
            {
                ApplicationArea=All;
            }
            field("Portal Grace Period"; Rec."Portal Grace Period")
            {
                ApplicationArea=All;
            }
            field("Portal Planned Period"; Rec."Portal Planned Period")
            {
                ApplicationArea=All;
            }
            field("Consider Punch"; Rec."Consider Punch")
            {
                Visible = False;
                ApplicationArea=All;
            }
        }
    }
    actions
    {
        addlast(Navigation)
        {
            action("Absence Entitlement")
            {
                Caption = 'Bands';
                Image = Template;
                RunObject = Page "Absence Entitlement";
                RunPageLink = "Cause of Absence Code" = FIELD(Code);
                ApplicationArea=All;
            }
        }
    }
}