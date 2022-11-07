table 98093 "Evaluation Template KPI"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Evaluation Code";Code[20])
        {
            TableRelation = "Evaluation Template"."Code" WHERE (Code=FIELD("Evaluation Code"));
        }
        field(2;"KPI Category";Code[20])
        {
            TableRelation = "Evaluation Items"."Code" WHERE ("Item Type"=CONST("KPI Category"));
        }
        field(3;"KPI Item";Code[20])
        {
            TableRelation = "Evaluation Item Relation"."Child Code" WHERE ("Parent Item Type"=CONST("KPI Category"),"Parent Code"=FIELD("KPI Category"));
        }
        field(4;"Min Evaluation Score";Integer)
        {
        }
        field(5;"Max Evaluation Score";Integer)
        {
        }
        field(6;Comments;Text[250])
        {
        }
        field(7;"KPI Category Name";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Category")));
            FieldClass = FlowField;
        }
        field(8;"KPI Item Name";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Item")));
            FieldClass = FlowField;
        }
        field(9;"KPI Score Range Definition";Text[250])
        {
        }
        field(10;"KPI Category Description";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Category")));
            FieldClass = FlowField;
        }
        field(11;"KPI Item Description";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Item")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Evaluation Code","KPI Category","KPI Item")
        {
        }
    }

    fieldgroups
    {
    }
}

