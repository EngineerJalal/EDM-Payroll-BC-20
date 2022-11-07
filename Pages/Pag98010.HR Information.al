page 98010 "HR Information"
{
    // version SHR1.0,EDM.HRPY1

    DataCaptionExpression = Rec.GETFILTER("Table Name");
    PageType = List;
    SourceTable = "HR Information";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if STRLEN(Rec.Code) > 30 then
                            ERROR('Code can be of maximum 30 characters');
                    end;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Table Name";Rec."Table Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Due Date";Rec."Due Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Entitlement;Rec.Entitlement)
                {
                    Visible = EntitlementVisible;
                    ApplicationArea = All;
                }
                field("Commission Type";Rec."Commission Type")
                {
                    Visible = "Commission TypeVisible";
                    ApplicationArea = All;
                }
                field("Exit Interview";Rec."Exit Interview")
                {
                    Visible = "Exit InterviewVisible";
                    ApplicationArea = All;
                }
                field("Document Path";Rec."Document Path")
                {
                    Visible = "Document PathVisible";
                    ApplicationArea = All;
                }
                field("Survey Type";Rec."Survey Type")
                {
                    Visible = "Survey TypeVisible";
                    ApplicationArea = All;
                }
                field(Classification;Rec.Classification)
                {
                    Visible = ClassificationVisible;
                    ApplicationArea = All;
                }
                field("Copy of Identification Card";Rec."Copy of Identification Card")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Judiciary Record";Rec."Copy of Judiciary Record")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Employment Contract";Rec."Copy of Employment Contract")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Passport";Rec."Copy of Passport")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Copy of Diplomas";Rec."Copy of Diplomas")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Curriculum Vitae";Rec."Curriculum Vitae")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Letters of Recommendations";Rec."Letters of Recommendations")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Permission to practice prof.";Rec."Permission to practice prof.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
    }

    trigger OnInit();
    begin
        "Sub MenuEnable" := true;
        "Medical Gp.Visible" := true;
        "Document PathVisible" := true;
        "Exit InterviewVisible" := true;
        EntitlementVisible := true;
        "Varying Preset SalaryVisible" := true;
        "Commission TypeVisible" := true;
        "Job TitleVisible" := true;
        ClassificationVisible := true;
        "Survey TypeVisible" := true;
    end;

    trigger OnOpenPage();
    begin
        VTName := Rec.GETFILTER("Table Name");
        "Survey TypeVisible" := false;
        ClassificationVisible := false;
        "Sub MenuEnable" := false;
        "Job TitleVisible" := false;
        "Commission TypeVisible" := false;
        "Varying Preset SalaryVisible" := false;
        EntitlementVisible := true;
        "Exit InterviewVisible" := true;
        "Document PathVisible" := true;
        VTName := Rec.GETFILTER("Table Name");
        if VTName <> 'AcadInstitute' then
            EntitlementVisible := false;
        if VTName <> 'Interview' then
            "Exit InterviewVisible" := false;
        if VTName <> 'Document' then
            "Document PathVisible" := false;
        if VTName <> 'Medical Group' then
            "Medical Gp.Visible" := false;
        if VTName = 'Job Title' then begin
            "Job TitleVisible" := true;
            "Commission TypeVisible" := false;
            "Varying Preset SalaryVisible" := false;
        end;
        if VTName = 'Survey' then begin
            "Survey TypeVisible" := true;
            ClassificationVisible := true;
        end;
    end;

    var
        VTName: Text[30];
        [InDataSet]
        "Survey TypeVisible": Boolean;
        [InDataSet]
        ClassificationVisible: Boolean;
        [InDataSet]
        "Job TitleVisible": Boolean;
        [InDataSet]
        "Commission TypeVisible": Boolean;
        [InDataSet]
        "Varying Preset SalaryVisible": Boolean;
        [InDataSet]
        EntitlementVisible: Boolean;
        [InDataSet]
        "Exit InterviewVisible": Boolean;
        [InDataSet]
        "Document PathVisible": Boolean;
        [InDataSet]
        "Medical Gp.Visible": Boolean;
        [InDataSet]
        "Sub MenuEnable": Boolean;
}

