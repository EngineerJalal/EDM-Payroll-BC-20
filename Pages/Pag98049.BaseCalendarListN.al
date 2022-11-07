page 98049 "Base Calendar List N"
{
    // version NAVW17.00,EDM.HRPY1

    Caption = 'Base Calendar List';
    CardPageID = "Base Calendar Card N";
    Editable = false;
    PageType = List;
    Permissions = TableData "Base Calendar N"=rimd;
    SourceTable = "Base Calendar N";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Rec.Code)
                {
                    Caption = 'Code';
                    ApplicationArea=All;
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea=All;
                }
                field("Customized Changes Exist";Rec."Customized Changes Exist")
                {
                    Caption = 'Customized Changes Exist';
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
        area(navigation)
        {
            group("&Base Calendar")
            {
                Caption = '&Base Calendar';
                Image = Calendar;
                action("&Where-Used List")
                {
                    Caption = '&Where-Used List';
                    Image = Track;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        WhereUsedList : Page "Where-Used Base Calendar";
                        CalendarMgmt : Codeunit "Calendar Management";
                    begin
                        CalendarMgmt.CreateWhereUsedEntries(Rec.Code);
                        WhereUsedList.RUNMODAL;
                        CLEAR(WhereUsedList);
                    end;
                }
                separator("-")
                {
                    Caption = '-';
                }
                action("&Base Calendar Changes")
                {
                    Caption = '&Base Calendar Changes';
                    Image = Change;
                    RunObject = Page "Base Calendar Change List N";
                    RunPageLink = "Base Calendar Code"=FIELD(Code);
                    ApplicationArea=All;
                }
            }
        }
    }

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;
}

