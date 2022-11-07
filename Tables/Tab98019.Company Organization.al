table 98019 "Company Organization"
{

    DataCaptionFields = "No.",Name;
    DrillDownPageID = "Chart of Company Organization";
    LookupPageID = "Chart of Company Organization";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2;Name;Text[100])
        {
            Caption = 'Name';

            trigger OnValidate();
            begin
                if ("Search Name" = UPPERCASE(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3;"Search Name";Code[100])
        {
            Caption = 'Search Name';
        }
        field(4;"Organization Type";Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'Element,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Element,Heading,Total,"Begin-Total","End-Total";

            trigger OnValidate();
            var
                GLEntry : Record "G/L Entry";
                GLBudgetEntry : Record "G/L Budget Entry";
            begin
                if "Job Title" <> '' then
                    if CONFIRM('Job Title will be reset,do you wish to Continue?',true) then begin
                        "Job Title" := '';
                        "Allowed Places" := 0;
                end else
                    ERROR('');
            end;
        }
        field(19;Indentation;Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(26;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(34;Totaling;Text[250])
        {
            Caption = 'Totaling';
            TableRelation = "Company Organization";
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                if not ("Organization Type" in ["Organization Type"::Total,"Organization Type"::"End-Total"]) then
                    FIELDERROR("Organization Type");
            end;
        }
        field(35;"Job Title";Text[50])
        {
            Caption = 'Job Title';
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Job Title"));

            trigger OnValidate();
            var
                ErrFnd : Boolean;
                PresetBasicPay : Decimal;
                LastEntryNo : Integer;
            begin
                if "Organization Type" <> "Organization Type"::Element then
                    ERROR('Account Type must be Element');
            end;
        }
        field(36;"Allowed Places";Decimal)
        {
            CalcFormula = Sum("Company Organization"."Max Places" WHERE ("No."=FIELD("No."),"No."=FIELD(FILTER(Totaling))));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate();
            begin
                if "Organization Type" <> "Organization Type"::Element then
                    ERROR('Account Type must be Element');
            end;
        }
        field(37;"Filled Places";Integer)
        {
            CalcFormula = Count(Employee WHERE ("Company Organization No."=FIELD("No."),"Company Organization No."=FIELD(FILTER(Totaling))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;"Max Places";Decimal)
        {
        }
        field(40;"Manager Organization No.";Code[20])
        {
            TableRelation = "Company Organization";
        }
        field(41;"Report Man. Organization No.";Code[20])
        {
            TableRelation = "Company Organization";
        }
        field(42;"Manager Organization Name";Text[100])
        {
            CalcFormula = Lookup("Company Organization".Name WHERE ("No."=FIELD("Manager Organization No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(43;"Report Man. Organization Name";Text[100])
        {
            CalcFormula = Lookup("Company Organization".Name WHERE ("No."=FIELD("Report Man. Organization No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            SumIndexFields = "Max Places";
        }
        key(Key2;"Search Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
        if "Organization Type" = "Organization Type"::Element then
            TESTFIELD("Job Title");
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
    end;
}