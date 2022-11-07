page 98029 "HR Performance"
{
    // version SHR1.0,EDM.HRPY1

    PageType = Card;
    SourceTable = "HR Performance";
    SourceTableView = SORTING("No.","Table Name") WHERE("Table Name"=CONST("Performance"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";Rec."No.")
                {
                    Caption = 'Code';
                    ApplicationArea=All;
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea=All;
                }
                field("Starting Date";Rec."Starting Date")
                {
                    ApplicationArea=All;
                }
                field("No. of Days";Rec."No. of Days")
                {
                    ApplicationArea=All;
                }
                field("Max Cost";Rec."Max Cost")
                {
                    ApplicationArea=All;
                }
                field(Category;Rec.Category)
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 1 Code";Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Requested From';
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 2 Code";Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea=All;
                }
                field(Topic;Rec.Topic)
                {
                    ApplicationArea=All;
                }
                field(Audience;Rec.Audience)
                {
                    ApplicationArea=All;
                }
                field(Prerequisites;Rec.Prerequisites)
                {
                    ApplicationArea=All;
                }
                field("No. of Trainings";Rec."No. of Trainings")
                {
                    ApplicationArea=All;

                    trigger OnDrillDown();
                    var
                        Training : Record Training;
                    begin
                        Training.SETRANGE("Table Name",Training."Table Name"::Training);
                        Training.SETRANGE("No.",Rec."No.");
                        PAGE.RUNMODAL(80044,Training);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Performance)
            {
                CaptionML = ENU='Performance',
                            ENG='E&mployee';
                action("&List")
                {
                    Caption = '&List';
                    ShortCutKey = 'Shift+Ctrl+L';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        HRPerformance : Record "HR Performance";
                    begin
                        HRPerformance.SETRANGE("Table Name",HRPerformance."Table Name"::Performance);
                        PAGE.RUNMODAL(80046,HRPerformance);
                    end;
                }
                action("&Trainings")
                {
                    Caption = '&Trainings';
                    RunObject = Page Training;
                    RunPageLink = "Table Name"=CONST("Training"),"No."=FIELD("No.");
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    trigger OnClosePage();
    begin
        //
    end;
}

