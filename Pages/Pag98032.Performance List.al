page 98032 "Performance List"
{
    // version SHR1.0,EDM.HRPY2

    Caption = '..';
    DataCaptionExpression = Rec.GETFILTER("Table Name");
    PageType = List;
    SourceTable = "HR Performance";

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
                field(Name;Rec.Name)
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
                field("No. Series";Rec."No. Series")
                {
                    ApplicationArea=All;
                }
                field("Shortcut Dimension 1 Code";Rec."Shortcut Dimension 1 Code")
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
                Visible = true;
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        HRPerformance : Record "HR Performance";
                    begin
                        if Rec."Table Name" = Rec."Table Name"::Performance then begin
                          HRPerformance.SETRANGE("Table Name",HRPerformance."Table Name"::Performance);
                          HRPerformance.SETRANGE(HRPerformance."No.",Rec."No.");
                          PAGE.RUNMODAL(80042,HRPerformance);
                        end;
                        if Rec."Table Name" = Rec."Table Name"::"Room Type" then begin
                          HRPerformance.SETRANGE("Table Name",HRPerformance."Table Name"::"Room Type");
                          HRPerformance.SETRANGE(HRPerformance."No.",Rec."No.");
                          PAGE.RUNMODAL(80022,HRPerformance);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;
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

