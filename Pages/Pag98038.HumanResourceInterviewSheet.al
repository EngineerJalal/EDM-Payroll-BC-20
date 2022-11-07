page 98038 "Human Resource Interview Sheet"
{
    // version SHR1.0,EDM.HRPY1

    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionExpression = Caption(Rec);
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = Card;
    SourceTable = "HR Comment Line EDM";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    ApplicationArea=All;
                }
                field(Date; Date)
                {
                    ApplicationArea=All;
                }
                field("Interviewer Name"; "Interviewer Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Interview Phase"; "Interview Phase")
                {
                    ApplicationArea=All;
                }
                field("Interview Phase Name"; "Interview Phase Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Description; Description)
                {
                    ApplicationArea=All;
                }
                field("Interviewer No."; "Interviewer No.")
                {
                    ApplicationArea=All;
                }
                field("Interview Grade"; "Interview Grade")
                {
                    Caption = 'Grade';
                    ApplicationArea=All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea=All;
                }
                field("Next Phase"; "Next Phase")
                {
                    ApplicationArea=All;
                }
                field("Next Phase Name"; "Next Phase Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Next Interview Date"; "Next Interview Date")
                {
                    ApplicationArea=All;
                }
                field("Next Interviewer No."; "Next Interviewer No.")
                {
                    ApplicationArea=All;
                }
                field("Next Interviewer Name"; "Next Interviewer Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Code"; Code)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Document Code"; "Document Code")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("File Type"; "File Type")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("File Name"; "File Name")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&View File")
                {
                    Caption = '&View File';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        HRInfo: Record "HR Information";
                        DocPath: Text[60];
                    //HRWordFile : Automation "'{00020905-0000-0000-C000-000000000046}' 8.2:'{000209FF-0000-0000-C000-000000000046}':''{00020905-0000-0000-C000-000000000046}' 8.2'.Application";
                    //HRExcelFile : Automation "'{00020813-0000-0000-C000-000000000046}' 1.4:'{00024500-0000-0000-C000-000000000046}':''{00020813-0000-0000-C000-000000000046}' 1.4'.Application";
                    begin
                        /*TESTFIELD("File Name");
                        TESTFIELD("File Type");
                        HRInfo.GET(HRInfo."Table Name"::Document,"Document Code");
                        HRInfo.TESTFIELD("Document Path");
                        DocPath := HRInfo."Document Path" + '\' + "File Name";
                        CASE "File Type" OF
                          "File Type"::"1" : BEGIN
                            IF ISCLEAR(HRWordFile) THEN
                              CREATE(HRWordFile,FALSE);
                            HRWordFile.Documents.Open2002(DocPath);
                            HRWordFile.ActiveWindow.WindowState := 1; //Maximize Window
                            HRWordFile.Visible := TRUE;
                            CLEAR(HRWordFile);
                          END;
                          "File Type"::"2" : BEGIN
                            IF ISCLEAR(HRExcelFile) THEN
                              CREATE(HRExcelFile,FALSE);
                            HRExcelFile.Workbooks.Open(DocPath);
                            HRExcelFile.ActiveWindow.WindowState := 1; //Maximize Window
                            HRExcelFile.Visible := TRUE;
                            CLEAR(HRExcelFile);
                          END;
                          ELSE
                            HYPERLINK(DocPath);
                        END; //case
                        */

                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine;
    end;

    var
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        EmployeeQualification: Record "Employee Qualification";
        EmployeeRelative: Record "Employee Relative";
        MiscArticleInfo: Record "Misc. Article Information";
        ConfidentialInfo: Record "Confidential Information";
        Applicant: Record Applicant;
        EmploymentContract: Record "Employment Contract";

    procedure Caption(HRCommentLine: Record "HR Comment Line EDM"): Text[110];
    begin

        CASE HRCommentLine."Table Name" OF
            HRCommentLine."Table Name"::Applicant:
                IF Applicant.GET(HRCommentLine."No.") THEN
                    EXIT(HRCommentLine."No." + ' ' + Applicant.FullName + ' ' + 'Interviews');

            HRCommentLine."Table Name"::Employee:
                IF Employee.GET(HRCommentLine."No.") THEN
                    EXIT(HRCommentLine."No." + ' ' + Employee.FullName + ' ' + 'Interviews');

        END;
        EXIT('untitled');
    end;
}

