page 98048 "Base Calendar Card N"
{
    // version NAVW17.00,EDM.HRPY1

    Caption = 'Base Calendar Card';
    PageType = ListPlus;
    Permissions = TableData "Base Calendar N"=rimd;
    SourceTable = "Base Calendar N";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                    Visible = false;
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
                        CalendarMgt : Codeunit "Calendar Management";
                    begin
                        CalendarMgt.CreateWhereUsedEntries(Rec.Code);
                        WhereUsedList.RUNMODAL;
                        CLEAR(WhereUsedList);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Maintain Base Calendar Changes")
                {
                    Caption = '&Maintain Base Calendar Changes';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Base Calendar Change List N";
                    RunPageLink = "Base Calendar Code"=FIELD(Code);
                    ApplicationArea=All;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //CurrPage.BaseCalendarEntries.PAGE.SetCalendarCode(Code);
    end;
}

