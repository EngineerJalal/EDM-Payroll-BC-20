table 98088 "HR Comment Line EDM"
{
    Caption = 'Human Resource Comment Line EDM';
    DataCaptionFields = "No.";
    DrillDownPageID = 5223;
    LookupPageID = 5223;

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            //OptionCaption = 'Employee,Alternative Address,Employee Qualification,Employee Relative,Employee Absence,Misc. Article Information,Confidential Information';
            OptionCaptionML = ENU = 'Employee,Alternative Address,Employee Qualification,Employee Relative,Employee Absence,Misc. Article Information,Confidential Information,Applicant';
            OptionMembers = Employee,"Alternative Address","Employee Qualification","Employee Relative","Employee Absence","Misc. Article Information","Confidential Information",Applicant;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table Name" = CONST(Employee)) Employee."No."
            ELSE
            IF ("Table Name" = CONST("Alternative Address")) "Alternative Address"."Employee No."
            ELSE
            IF ("Table Name" = CONST("Employee Qualification")) "Employee Qualification"."Employee No."
            ELSE
            IF ("Table Name" = CONST("Misc. Article Information")) "Misc. Article Information"."Employee No."
            ELSE
            IF ("Table Name" = CONST("Confidential Information")) "Confidential Information"."Employee No."
            ELSE
            IF ("Table Name" = CONST("Employee Absence")) "Employee Absence"."Employee No."
            ELSE
            IF ("Table Name" = CONST("Employee Relative")) "Employee Relative"."Employee No.";
        }
        field(3; "Table Line No."; Integer)
        {
            Caption = 'Table Line No.';
        }
        field(4; "Alternative Address Code"; Code[10])
        {
            Caption = 'Alternative Address Code';
            TableRelation = IF ("Table Name" = CONST("Alternative Address")) "Alternative Address".Code WHERE("Employee No." = FIELD("No."));
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; Date; Date)
        {
            Caption = 'Date';
        }
        field(8; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(9; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(80000; "Interviewer No."; Code[20])
        {
            Description = 'SHR1.0';
            TableRelation = Employee."No.";
        }
        field(80001; "Interview Grade"; Option)
        {
            Description = 'SHR1.0';
            OptionMembers = " ",A,B,C,D;
        }
        field(80002; "Document Code"; Code[50])
        {
            Description = 'SHR2.0';
            NotBlank = true;
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Document"));

            trigger OnValidate();
            begin
                Description := "Document Code";
            end;
        }
        field(80003; Description; Text[30])
        {
            Description = 'SHR2.0';
        }
        field(80004; "File Type"; Option)
        {
            Description = 'SHR2.0';
            OptionMembers = " ",Word,Excel,pdf,Image;
        }
        field(80005; "File Name"; Text[30])
        {
            Description = 'SHR2.0';

            trigger OnValidate();
            begin
                if STRPOS("File Name", '.') = 0 then begin
                    case "File Type" of
                        "File Type"::Word:
                            "File Name" := "File Name" + '.doc';
                        "File Type"::Excel:
                            "File Name" := "File Name" + '.xls';
                        "File Type"::pdf:
                            "File Name" := "File Name" + '.pdf';
                    end;
                end;
            end;
        }
        field(80006; "Next Phase"; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("InterviewPhase"));
        }
        field(80007; "Interview Phase"; Code[10])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("InterviewPhase"));
        }
        field(80008; "Next Interviewer No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(80009; "Interviewer Name"; Text[100])
        {
            CalcFormula = Lookup (Employee."Full Name" WHERE("No." = FIELD("Interviewer No.")));
            FieldClass = FlowField;
        }
        field(80010; "Next Interviewer Name"; Text[100])
        {
            CalcFormula = Lookup (Employee."Full Name" WHERE("No." = FIELD("Next Interviewer No.")));
            FieldClass = FlowField;
        }
        field(80011; "Interview Phase Name"; Text[150])
        {
            CalcFormula = Lookup ("HR Information".Description WHERE(Code = FIELD("Interview Phase"), "Table Name" = CONST("InterviewPhase")));
            FieldClass = FlowField;
        }
        field(80012; "Next Phase Name"; Text[150])
        {
            CalcFormula = Lookup ("HR Information".Description WHERE(Code = FIELD("Next Phase"), "Table Name" = CONST("InterviewPhase")));
            FieldClass = FlowField;
        }
        field(80013; "Next Interview Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Table Name", "No.", "Table Line No.", "Alternative Address Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine()
    var
        HumanResCommentLine: Record "HR Comment Line EDM";
    begin
        HumanResCommentLine := Rec;
        HumanResCommentLine.SETRECFILTER;
        HumanResCommentLine.SETRANGE("Line No.");
        HumanResCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT HumanResCommentLine.FINDFIRST THEN
            Date := WORKDATE;

        OnAfterSetUpNewLine(Rec, HumanResCommentLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetUpNewLine(var HumanResourceCommentLineRec: Record "HR Comment Line EDM"; var HumanResourceCommentLineFilter: Record "HR Comment Line EDM")
    begin
    end;
}

