page 98021 "Applicant Picture"
{
    // version SHR1.0,EDM.HRPY1

    PageType = Card;
    SourceTable = Applicant;

    layout
    {
        area(content)
        {
            field(Picture;Rec.Picture2)
            {
                ApplicationArea=All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Picture")
            {
                Caption = '&Picture';
                action(Import)
                {
                    Caption = 'Import';
                    Ellipsis = true;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        /*PictureExists := Picture.HASVALUE;
                        IF Picture.IMPORT('*.bmp',TRUE) = '' THEN
                          EXIT;
                        IF PictureExists THEN
                          IF NOT CONFIRM('Do you want to replace the existing picture of %1 %2?',FALSE,TABLENAME,"No.") THEN
                            EXIT;
                        CurrPage.SAVERECORD;
                        */

                    end;
                }
                action("E&xport")
                {
                    Caption = 'E&xport';
                    Ellipsis = true;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        /*IF Picture.HASVALUE THEN
                          Picture.EXPORT('*.bmp',TRUE);
                          */

                    end;
                }
                action(Delete)
                {
                    Caption = 'Delete';
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        /*IF Picture.HASVALUE THEN
                          IF CONFIRM('Do you want to delete the picture of %1 %2?',FALSE,TABLENAME,"No.") THEN BEGIN
                            CLEAR(Picture);
                            CurrPage.SAVERECORD;
                          END;
                          */

                    end;
                }
            }
        }
    }

    var
        PictureExists : Boolean;
}

