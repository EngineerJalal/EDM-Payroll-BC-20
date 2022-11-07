table 98094 "Evaluation Data Main"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Date;Date)
        {
        }
        field(3;"Evaluated By";Code[20])
        {
            TableRelation = Employee."No." WHERE (Status=CONST(Active));
        }
        field(4;Description;Text[250])
        {
        }
        field(5;Status;Option)
        {
            OptionCaption = 'Pass,Failed';
            OptionMembers = Pass,Failed;
        }
        field(6;"Suggested Status";Option)
        {
            OptionCaption = 'Pass,Failed';
            OptionMembers = Pass,Failed;
        }
        field(7;"Employee No";Code[20])
        {
            TableRelation = Employee."No." WHERE (Status=CONST(Active));

            trigger OnValidate();
            begin
                if Code = '' then
                  ERROR('Enter Code');

                EmpAddInfo.SETRANGE("Employee No.",Rec."Employee No");
                if EmpAddInfo.FINDFIRST then
                 "Evaluation Template" := EmpAddInfo."Evaluation Template"
                else
                   "Evaluation Template" := '';


                EvaTemplate.SETRANGE(Code,"Evaluation Template");
                if EvaTemplate.FINDFIRST then
                  "Evaluation Interval" := EvaTemplate."Evaluation Interval"
                else
                 "Evaluation Interval" := '';

                CLEAR(EvaKPI);
                EvaKPI.RESET;
                EvaKPI.SETRANGE("Evaluation Code",Code);
                if EvaKPI.FINDFIRST then
                  repeat
                    EvaKPI.DELETE;
                  until EvaKPI.NEXT = 0;

                EvaTemplateKPI.SETRANGE("Evaluation Code","Evaluation Template");
                if EvaTemplateKPI.FINDFIRST then
                  repeat
                    EvaData.INIT;
                    EvaData."Evaluation Code" := Code;
                    EvaData."KPI Category" := EvaTemplateKPI."KPI Category";
                    EvaData."KPI Item" := EvaTemplateKPI."KPI Item";
                    //EvaData."Evaluation Template" := EvaluationTemplate;
                    EvaData.INSERT;
                  until EvaTemplateKPI.NEXT = 0;
            end;
        }
        field(8;"Evaluation Comment";Text[250])
        {
        }
        field(9;"Manager Comment";Text[250])
        {
        }
        field(10;"Employee Comment";Text[250])
        {
        }
        field(11;"Evaluation Template";Code[20])
        {
            TableRelation = "Evaluation Template"."Code" WHERE ("Is Inactive"=FILTER(false));
        }
        field(12;"Evaluation Interval";Code[20])
        {
            TableRelation = "Evaluation Items"."Code" WHERE ("Item Type"=CONST("Evaluation interval"),"Code"=FIELD("Evaluation Interval"));
        }
        field(13;"Evaluation Period";Code[20])
        {
            TableRelation = "Evaluation Item Relation"."Child Code" WHERE ("Parent Item Type"=CONST("Evaluation interval"),"Child Item Type"=CONST("Evaluation period"),"Parent Code"=FIELD("Evaluation Interval"),"is Inactive"=FILTER(false));
        }
        field(14;"Manager No";Code[20])
        {
            CalcFormula = Lookup(Employee."Manager No." WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(15;"Employement Date";Date)
        {
            CalcFormula = Lookup(Employee."Employment Date" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(16;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(17;"Manager Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Manager Name" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(18;"Job Title";Code[30])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE ("No."=FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(19;"Average Score";Decimal)
        {
            CalcFormula = Average("Evaluation Data KPI".Score WHERE ("Evaluation Code"=FIELD(Code)));
            FieldClass = FlowField;
        }
        field(20;"Evaluated By Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD("Evaluated By")));
            FieldClass = FlowField;
        }
        field(21;"Evaluation Interval Name";Text[250])
        {
            CalcFormula = Lookup("Evaluation Items".Description WHERE (Code=FIELD("Evaluation Interval")));
            FieldClass = FlowField;
        }
        field(22;"Evaluation Template Name";Text[250])
        {
            CalcFormula = Lookup("Evaluation Template".Name WHERE (Code=FIELD("Evaluation Template")));
            FieldClass = FlowField;
        }
        field(23;"No. Series";Code[10])
        {
        }
        field(24;Goals1;Text[250])
        {
        }
        field(25;Expectations1;Text[250])
        {
        }
        field(26;"Req. Training Objectives 1";Text[250])
        {
        }
        field(27;"Req. Training Objectives 2";Text[250])
        {
        }
        field(28;Goals2;Text[250])
        {
        }
        field(29;Goals3;Text[250])
        {
        }
        field(30;Expectations2;Text[250])
        {
        }
        field(31;Expectations3;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Code",Date,"Employee No","Evaluation Template","Evaluation Interval","Evaluation Period")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        CLEAR(EvaKPI);
        EvaKPI.RESET;
        EvaKPI.SETRANGE("Evaluation Code",Code);
        if EvaKPI.FINDFIRST then
          repeat
            EvaKPI.DELETE;
          until EvaKPI.NEXT = 0;
    end;

    var
        EvaTemplateKPI : Record "Evaluation Template KPI";
        EmpAddInfo : Record "Employee Additional Info";
        EvaTemplate : Record "Evaluation Template";
        EvaData : Record "Evaluation Data KPI";
        EvaKPI : Record "Evaluation Data KPI";
}

