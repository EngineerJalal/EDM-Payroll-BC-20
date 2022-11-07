page 98096 "Evaluation Data Main"
{
    // version EDM.HRPY2

    PageType = Card;
    SourceTable = "Evaluation Data Main";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea=All;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        /*EmpAddInfo.SETRANGE("Employee No.",Rec."Employee No");
                        IF EmpAddInfo.FINDFIRST THEN
                        EvaluationTemplate := EmpAddInfo."Evaluation Template";
                        "Evaluation Template" := EvaluationTemplate;
                        
                        EvaTemplateKPI.SETRANGE("Evaluation Code",EvaluationTemplate);
                        IF EvaTemplateKPI.FINDFIRST THEN
                          REPEAT
                            EvaData.INIT;
                            EvaData."Evaluation Code" := Code;
                            EvaData."KPI Category" := EvaTemplateKPI."KPI Category";
                            EvaData."KPI Item" := EvaTemplateKPI."KPI Item";
                            EvaData."Evaluation Template" := EvaluationTemplate;
                            EvaData.INSERT;
                          UNTIL EvaTemplateKPI.NEXT = 0;
                        CurrPage.UPDATE;
                        
                        EvaTemplate.RESET;
                        CLEAR(EvaTemplate);
                        EvaTemplate.SETRANGE(Code,"Evaluation Template");
                        IF EvaTemplate.FINDFIRST THEN
                          BEGIN
                            //EvaTemplate.CALCFIELDS("Evaluation Interval Name");
                            "Evaluation Interval" := EvaTemplate."Evaluation Interval Name";
                          END
                        */
                        CurrPage.UPDATE;

                    end;
                }
                field("Employee Name";"Employee Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Job Title";"Job Title")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Employement Date";"Employement Date")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Manager No";"Manager No")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Manager Name";"Manager Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
            group("Evaluation Info")
            {
                field("Evaluation Date";Date)
                {
                    ApplicationArea=All;
                }
                field("Evaluation Template Name";"Evaluation Template Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Evaluation Interval Name";"Evaluation Interval Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Evaluation Period";"Evaluation Period")
                {
                    ApplicationArea=All;
                }
                field("Evaluated By";"Evaluated By")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //CurrPage.UPDATE;
                    end;
                }
                field("Evaluated By Name";"Evaluated By Name")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Evaluation Score";"Average Score")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Evaluation Status";Status)
                {
                    ApplicationArea=All;
                }
                field("Evaluation Suggested Status";"Suggested Status")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
            part("Evaluation Data KPI";"Evaluation Data KPI")
            {
                ShowFilter = false;
                SubPageLink = "Evaluation Code"=FIELD(Code);
                UpdatePropagation = Both;
                ApplicationArea=All;
            }
            group("Evaluation Comments")
            {
                Caption = 'Evaluation Comments';
                field("Evaluation Comment";"Evaluation Comment")
                {
                    ApplicationArea=All;
                }
                field("Manager Comment";"Manager Comment")
                {
                    ApplicationArea=All;
                }
                field("Employee Comment";"Employee Comment")
                {
                    ApplicationArea=All;
                }
                field(Goals1;Goals1)
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field(Goals2;Goals2)
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field(Goals3;Goals3)
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field(Expectations1;Expectations1)
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field(Expectations2;Expectations2)
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field(Expectations3;Expectations3)
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field("Req. Training Objectives 1";"Req. Training Objectives 1")
                {
                    ShowMandatory = true;
                    ApplicationArea=All;
                }
                field("Req. Training Objectives 2";"Req. Training Objectives 2")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
        EvaTemplate.SETRANGE(Code,"Evaluation Template");
        if EvaTemplate.FINDFIRST then
          if "Average Score" >= EvaTemplate."Pass Score" then
            "Suggested Status" := "Suggested Status"::Pass
          else "Suggested Status" := "Suggested Status"::Failed;
    end;

    trigger OnQueryClosePage(CloseAction : Action) : Boolean;
    begin
        // 28.01.2017 : A2 +
        if "Employee No" <> '' then
          begin
            TESTFIELD(Description);
            TESTFIELD(Date);
            TESTFIELD("Evaluation Period");
            TESTFIELD("Evaluated By");
            TESTFIELD("Evaluation Comment");
            TESTFIELD("Manager Comment");
            TESTFIELD("Employee Comment");
            TESTFIELD(Expectations1);
            TESTFIELD(Expectations2);
            TESTFIELD(Expectations3);
            TESTFIELD(Goals1);
            TESTFIELD(Goals2);
            TESTFIELD(Goals3);
            TESTFIELD("Req. Training Objectives 1");
          end;
        // 28.01.2017 : A2 -
    end;

    var
        EvaTemplateKPI : Record "Evaluation Template KPI";
        EmpAddInfo : Record "Employee Additional Info";
        EvaData : Record "Evaluation Data KPI";
        EvaluationTemplate : Code[20];
        EvaTemplate : Record "Evaluation Template";
        EvaDataMainTbt : Record "Evaluation Data Main";
}

