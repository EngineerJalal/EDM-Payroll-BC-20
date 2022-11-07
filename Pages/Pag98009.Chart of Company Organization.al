page 98009 "Chart of Company Organization"
{
    // version SHR1.0,EDM.HRPY1

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Company Organization";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                IndentationColumn = NameIndent;
                IndentationControls = "No.";
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("Organization Type"; Rec."Organization Type")
                {
                    ApplicationArea = All;
                }
                field("Manager Organization No."; Rec."Manager Organization No.")
                {
                    ApplicationArea = All;
                }
                field("Report Man. Organization No."; Rec."Report Man. Organization No.")
                {
                    ApplicationArea = All;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Max Places"; Rec."Max Places")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        MaxPlacesOnAfterValidate;
                    end;
                }
                field("Allowed Places"; Rec."Allowed Places")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Filled Places"; Rec."Filled Places")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field(VacantPlaces; VacantPlaces)
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Caption = 'Vacant Places';
                    Editable = false;
                    ApplicationArea = All;
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
                action("Indent Chart of Company Organization")
                {
                    Caption = 'Indent Chart of Company Organization';
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        HRFunctions: Codeunit "Human Resource Functions";
                    begin
                        HRFunctions.Indent;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        "No.Indent" := 0;
        VacantPlaces := Rec."Allowed Places" - Rec."Filled Places";
        NoOnFormat;
        NameOnFormat;
        AllowedPlacesOnFormat;
        FilledPlacesOnFormat;
        VacantPlacesOnFormat;
    end;

    var
        VacantPlaces: Decimal;
        [InDataSet]
        "No.Emphasize": Boolean;
        [InDataSet]
        "No.Indent": Integer;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        [InDataSet]
        "Allowed PlacesEmphasize": Boolean;
        [InDataSet]
        "Filled PlacesEmphasize": Boolean;
        [InDataSet]
        VacantPlacesEmphasize: Boolean;

    local procedure MaxPlacesOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure NoOnFormat();
    begin
        "No.Emphasize" := Rec."Organization Type" <> Rec."Organization Type"::Element;
        "No.Indent" := Rec.Indentation;
    end;

    local procedure NameOnFormat();
    begin
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Organization Type" <> Rec."Organization Type"::Element;
    end;

    local procedure AllowedPlacesOnFormat();
    begin
        if Rec.Totaling <> '' then
            "Allowed PlacesEmphasize" := true;
    end;

    local procedure FilledPlacesOnFormat();
    begin
        if Rec.Totaling <> '' then
            "Filled PlacesEmphasize" := true;
    end;

    local procedure VacantPlacesOnFormat();
    begin
        if Rec.Totaling <> '' then
            VacantPlacesEmphasize := true;
    end;
}

