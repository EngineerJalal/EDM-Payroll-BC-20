page 98090 "HR Comment Sheet EDM"
{
    // version NAVW111.00

    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionExpression = Caption(Rec);
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "HR Comment Line EDM";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Date; Date)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the date the comment was created.';
                }
                field(Comment; Comment)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the comment itself.';
                }
                field(Code; Code)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a code for the comment.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine;
    end;

    var
        Text000: Label 'untitled';
        Employee: Record "Employee";
        EmployeeAbsence: Record "Employee Absence";
        EmployeeQualification: Record "Employee Qualification";
        EmployeeRelative: Record "Employee Relative";
        MiscArticleInfo: Record "Misc. Article Information";
        ConfidentialInfo: Record "Confidential Information";

    local procedure Caption(HRCommentLine: Record "HR Comment Line EDM"): Text[110];
    begin
        CASE HRCommentLine."Table Name" OF
            HRCommentLine."Table Name"::"Employee Absence":
                IF EmployeeAbsence.GET(HRCommentLine."Table Line No.") THEN BEGIN
                    Employee.GET(EmployeeAbsence."Employee No.");
                    EXIT(
                      Employee."No." + ' ' + Employee.FullName + ' ' +
                      EmployeeAbsence."Cause of Absence Code" + ' ' +
                      FORMAT(EmployeeAbsence."From Date"));
                END;
            HRCommentLine."Table Name"::Employee:
                IF Employee.GET(HRCommentLine."No.") THEN
                    EXIT(HRCommentLine."No." + ' ' + Employee.FullName);
            HRCommentLine."Table Name"::"Alternative Address":
                IF Employee.GET(HRCommentLine."No.") THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      HRCommentLine."Alternative Address Code");
            HRCommentLine."Table Name"::"Employee Qualification":
                IF EmployeeQualification.GET(HRCommentLine."No.", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      EmployeeQualification."Qualification Code");
            HRCommentLine."Table Name"::"Employee Relative":
                IF EmployeeRelative.GET(HRCommentLine."No.", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      EmployeeRelative."Relative Code");
            HRCommentLine."Table Name"::"Misc. Article Information":
                IF MiscArticleInfo.GET(
                     HRCommentLine."No.", HRCommentLine."Alternative Address Code", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      MiscArticleInfo."Misc. Article Code");
            HRCommentLine."Table Name"::"Confidential Information":
                IF ConfidentialInfo.GET(HRCommentLine."No.", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      ConfidentialInfo."Confidential Code");
        END;
        EXIT(Text000);
    end;
}

