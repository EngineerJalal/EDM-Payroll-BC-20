page 98031 "Training List"
{
    // version SHR1.0,EDM.HRPY1

    CardPageID = Training;
    Editable = false;
    PageType = List;
    SourceTable = Training;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea=All;
                }
                field("Performance Code";Rec."Performance Code")
                {
                    ApplicationArea=All;
                }
                field("Start Date";Rec."Start Date")
                {
                    ApplicationArea=All;
                }
                field("End Date";Rec."End Date")
                {
                    ApplicationArea=All;
                }
                field("Start Time";Rec."Start Time")
                {
                    ApplicationArea=All;
                }
                field("End Time";Rec."End Time")
                {
                    ApplicationArea=All;
                }
                field("Is Completed";Rec."Is Completed")
                {
                    ApplicationArea=All;
                }
                field("Is External";Rec."Is External")
                {
                    ApplicationArea=All;
                }
                field(Room;Rec.Room)
                {
                    ApplicationArea=All;
                }
                field(Trainers;Rec.Trainers)
                {
                    ApplicationArea=All;
                }
                field("Company Name";Rec."Company Name")
                {
                    ApplicationArea=All;
                }
                field(Objectives;Rec.Objectives)
                {
                    Caption = 'Subject';
                    ApplicationArea=All;
                }
                field(Evaluation;Rec.Evaluation)
                {
                    ApplicationArea=All;
                }
                field("Evaluation Rate";Rec."Evaluation Rate")
                {
                    ApplicationArea=All;
                }
                field(Cost;Rec.Cost)
                {
                    ApplicationArea=All;
                }
                field("More Info";Rec."More Info")
                {
                    ApplicationArea=All;
                }
                field("Is Certificate Granted";Rec."Is Certificate Granted")
                {
                    ApplicationArea=All;
                }
                field("Certificate Title";Rec."Certificate Title")
                {
                    ApplicationArea=All;
                }
                field("Max Attendees";Rec."Max Attendees")
                {
                    ApplicationArea=All;
                }
                field("No. Series";Rec."No. Series")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(View)
            {
                Caption = 'View';
                Visible = false;
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        Training : Record Training;
                    begin
                        if Rec."Table Name" = Rec."Table Name"::Training then begin
                          Training.SETRANGE("Table Name",Training."Table Name"::Training);
                          Training.SETRANGE("No.",Rec."No.");
                          Training.SETRANGE(Training."Performance Code",Rec."Performance Code");
                          //FORM.RUNMODAL(80043,Training);
                        end;
                        if Rec."Table Name" = Rec."Table Name"::Room then begin
                          Training.SETRANGE("Table Name",Training."Table Name"::Room);
                          Training.SETRANGE("No.",Rec."No.");
                          Training.SETRANGE(Training."Performance Code",Rec."Performance Code");
                           // FORM.RUNMODAL(80035,Training);
                        end;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Plan Annual Training")
            {
                Caption = 'Plan Annual Training';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Plan Annual Training";
                ApplicationArea=All;
            }
        }
    }
    trigger OnOpenPage();
    begin
        EvaluationOfficerPermission := PayrollFunctions.IsEvaluationOfficer(UserId);
        IF EvaluationOfficerPermission=false then
            Error('No Permission!');
    end;
    var
    EvaluationOfficerPermission : Boolean;
    PayrollFunctions : Codeunit "Payroll Functions";
}

