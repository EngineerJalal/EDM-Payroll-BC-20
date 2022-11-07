page 98027 "Employee Ikama"
{
    // version SHR1.0,EDM.HRPY2

    PageType = Card;
    SourceTable = "Employee Ikama";

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
                field("Ikama No.";Rec."Ikama No.")
                {
                    ApplicationArea=All;
                }
                field("Liscence Type";Rec."Liscence Type")
                {
                    ApplicationArea=All;
                }
                field("Issue Place";Rec."Issue Place")
                {
                    ApplicationArea=All;
                }
                field("Special Notes";Rec."Special Notes")
                {
                    ApplicationArea=All;
                }
                field("Ikama Job Title";Rec."Ikama Job Title")
                {
                    ApplicationArea=All;
                }
                field("Ikama Company Responsible";Rec."Ikama Company Responsible")
                {
                    ApplicationArea=All;
                }
                field("Date From";Rec."Date From")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                            Rec."Date From Higiri":=Date2Hijre.Date2Hijri(Rec."Date From",0);
                    end;
                }
                field("Date To";Rec."Date To")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        Rec."Date To Higri":=Date2Hijre.Date2Hijri(Rec."Date To",0);
                    end;
                }
                field("Date To Higri";Rec."Date To Higri")
                {
                    Editable = true;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                            Rec."Date To":=Date2Hijre.HijriToGeo(Rec."Date To Higri");
                    end;
                }
                field("Date From Higiri";Rec."Date From Higiri")
                {
                    Editable = true;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                            Rec."Date From":=Date2Hijre.HijriToGeo(Rec."Date From Higiri");
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        Date2Hijre : Codeunit "Datetime Mgt.";
}

