table 98062 "Evaluation Data KPI"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Evaluation Code";Code[20])
        {
            TableRelation = "Evaluation Data Main"."Code" WHERE (Code=FIELD("Evaluation Code"));
        }
        field(2;"KPI Category";Code[20])
        {
        }
        field(3;"KPI Item";Code[20])
        {
        }
        field(4;Score;Decimal)
        {

            trigger OnValidate();
            begin
                EvalMainTbt.SETRANGE(EvalMainTbt.Code,Rec."Evaluation Code");
                if EvalMainTbt.FINDFIRST then
                  begin
                      TemplateKPI.SETRANGE("KPI Category","KPI Category");
                      TemplateKPI.SETRANGE("KPI Item","KPI Item");
                      TemplateKPI.SETRANGE("Evaluation Code",EvalMainTbt."Evaluation Template");
                      if TemplateKPI.FINDFIRST then
                        if (Score < TemplateKPI."Min Evaluation Score") or (Score > TemplateKPI."Max Evaluation Score")  then
                          ERROR('Invalid Score');
                  end;
            end;
        }
        field(5;"KPI Category Name";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Category")));
            FieldClass = FlowField;
        }
        field(6;"KPI Item Name";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Item")));
            FieldClass = FlowField;
        }
        field(7;Comments;Text[250])
        {
        }
        field(8;"KPI Category Description";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Category")));
            FieldClass = FlowField;
        }
        field(9;"KPI Item Description";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("KPI Item")));
            FieldClass = FlowField;
        }
        field(10;"KPI Score Range Definition";Text[250])
        {
            CalcFormula = Lookup("Evaluation Template KPI"."KPI Score Range Definition" WHERE ("KPI Category"=FIELD("KPI Category"),
                                                                                               "KPI Item"=FIELD("KPI Item")));
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

    var
        TemplateKPI : Record "Evaluation Template KPI";
        EvalMainTbt : Record "Evaluation Data Main";

    procedure GetScoreRange() ScoreRange : Text;
    var
        EvaTemKPItbt : Record "Evaluation Template KPI";
        EvaMaintbt : Record "Evaluation Data Main";
    begin
        EvaMaintbt.SETRANGE(Code,Rec."Evaluation Code");
        if EvaMaintbt.FINDFIRST then
          begin
            EvaTemKPItbt.SETRANGE("Evaluation Code",EvaMaintbt."Evaluation Template");
            EvaTemKPItbt.SETRANGE("KPI Category","KPI Category");
            EvaTemKPItbt.SETRANGE("KPI Item","KPI Item");
            if EvaTemKPItbt.FINDFIRST then
              exit(FORMAT(EvaTemKPItbt."Min Evaluation Score") + ' - ' + FORMAT(EvaTemKPItbt."Max Evaluation Score"));
          end;
          exit('-');
    end;
}

