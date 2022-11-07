table 98059 "Evaluation Template"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Name;Text[50])
        {
        }
        field(3;Description;Text[250])
        {
        }
        field(4;"Is Inactive";Boolean)
        {
        }
        field(5;"Evaluation Interval";Code[20])
        {
            TableRelation = "Evaluation Items"."Code" WHERE ("Item Type"=CONST("Evaluation interval"));
        }
        field(6;"Creation User Id";Text[50])
        {
        }
        field(7;"Creation DateTime";DateTime)
        {
        }
        field(8;"Modified User Id";Text[50])
        {
        }
        field(9;"Modified DateTime";DateTime)
        {
        }
        field(10;"Evaluation Interval Name";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("Evaluation Interval")));
            FieldClass = FlowField;
        }
        field(11;"Pass Score";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if CONFIRM('Are you sure you want to delete this record?',false) = false then
          exit;

        EvalDataMaintbt.SETRANGE(EvalDataMaintbt."Evaluation Template",Rec.Code);
        if EvalDataMaintbt.FINDFIRST then
          ERROR('Deleting this record is not allowed');

        CLEAR(EvaTemp);
        EvaTemp.RESET;
        EvaTemp.SETRANGE("Evaluation Code",Code);

        if EvaTemp.FINDFIRST then
          repeat
            EvaTemp.DELETE;
          until EvaTemp.NEXT = 0;
    end;

    trigger OnInsert();
    begin
        "Creation User Id" := USERID;
        "Creation DateTime" := CREATEDATETIME(SYSTEM.TODAY,SYSTEM.TIME);
        "Modified User Id" := USERID;
        "Modified DateTime" := CREATEDATETIME(SYSTEM.TODAY,SYSTEM.TIME);
    end;

    trigger OnModify();
    begin
        "Modified User Id" := USERID;
        "Modified DateTime" := CREATEDATETIME(SYSTEM.TODAY,SYSTEM.TIME);
    end;

    var
        EvaTemp : Record "Evaluation Template KPI";
        EvalDataMaintbt : Record "Evaluation Data Main";
}

