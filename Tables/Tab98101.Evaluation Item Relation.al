table 98101 "Evaluation Item Relation"
{
    // version EDM.HRPY2


    fields
    {
        field(1; "Parent Item Type"; Option)
        {
            OptionCaption = ',KPI Category,KPI Item,Evaluation interval,Evaluation period';
            OptionMembers = ,"KPI Category","KPI Item","Evaluation interval","Evaluation period";

            trigger OnValidate();
            begin
                IsValidRelation;
            end;
        }
        field(2; "Parent Code"; Code[20])
        {
            TableRelation = "Evaluation Items"."Code" WHERE("Item Type" = FIELD("Parent Item Type"));
        }
        field(3; "Parent Name"; Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE(Code = FIELD("Parent Code")));
            FieldClass = FlowField;
        }
        field(4; "Child Item Type"; Option)
        {
            OptionCaption = ',KPI Category,KPI Item,Evaluation interval,Evaluation period';
            OptionMembers = ,"KPI Category","KPI Item","Evaluation interval","Evaluation period";

            trigger OnValidate();
            begin
                IsValidRelation;
            end;
        }
        field(5; "Child Code"; Code[20])
        {
            TableRelation = "Evaluation Items"."Code" WHERE("Item Type" = FIELD("Child Item Type"));
        }
        field(6; "Child Name"; Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE(Code = FIELD("Child Code")));
            FieldClass = FlowField;
        }
        field(7; "is Inactive"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Parent Item Type", "Parent Code", "Child Item Type", "Child Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Child Code", "Child Name", "Parent Code", "Parent Name")
        {
        }
    }

    procedure IsValidRelation();
    begin
        if (FORMAT("Parent Item Type") = '') or (FORMAT("Child Item Type") = '') or (FORMAT("Parent Item Type") = '0') or (FORMAT("Child Item Type") = '0') then
            exit;

        if "Child Item Type" = "Parent Item Type" then
            ERROR('"Parent Item Type" and "Child Item Type" cannot have same Type');

        if ("Parent Item Type" = "Parent Item Type"::"KPI Category") and ("Child Item Type" <> "Child Item Type"::"KPI Item") then
            ERROR('The [Child Item Type] must be ["KPI Item"]');

        if ("Parent Item Type" <> "Parent Item Type"::"KPI Category") and ("Child Item Type" = "Child Item Type"::"KPI Item") then
            ERROR('The [Parent Item Type] must be ["KPI Category"]');

        if ("Parent Item Type" = "Parent Item Type"::"Evaluation interval") and ("Child Item Type" <> "Child Item Type"::"Evaluation period") then
            ERROR('The [Child Item Type] must be ["Evaluation period"]');

        if ("Parent Item Type" <> "Parent Item Type"::"Evaluation interval") and ("Child Item Type" = "Child Item Type"::"Evaluation period") then
            ERROR('The [Parent Item Type] must be ["Evaluation interval"]');

        if ("Parent Item Type" = "Parent Item Type"::"KPI Item") and (("Child Item Type" = "Child Item Type"::"Evaluation period") or ("Child Item Type" = "Child Item Type"::"Evaluation interval")
             or ("Child Item Type" = "Child Item Type"::"KPI Category")) then
            ERROR('Invalid Relation');

        if ("Parent Item Type" = "Parent Item Type"::"Evaluation period") and (("Child Item Type" = "Child Item Type"::"KPI Category") or ("Child Item Type" = "Child Item Type"::"KPI Item")
            or ("Child Item Type" = "Child Item Type"::"Evaluation interval")) then
            ERROR('Invalid Relation');
    end;
}

