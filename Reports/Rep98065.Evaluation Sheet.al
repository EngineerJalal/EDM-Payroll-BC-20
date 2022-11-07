report 98065 "Evaluation Sheet"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Evaluation Sheet.rdlc';

    dataset
    {
        dataitem("Evaluation Template";"Evaluation Template")
        {
            column(Code_EvaluationTemplate;"Evaluation Template".Code)
            {
            }
            column(Name_EvaluationTemplate;"Evaluation Template".Name)
            {
            }
            column(Description_EvaluationTemplate;"Evaluation Template".Description)
            {
            }
            column(EvaluationInterval_EvaluationTemplate;"Evaluation Template"."Evaluation Interval")
            {
            }
            column(PassScore_EvaluationTemplate;"Evaluation Template"."Pass Score")
            {
            }
            column(EvaluationIntervalName_EvaluationTemplate;"Evaluation Template"."Evaluation Interval Name")
            {
            }
            dataitem("Evaluation Template KPI";"Evaluation Template KPI")
            {
                DataItemLink = "Evaluation Code"=FIELD(Code);
                column(KPICategory_EvaluationTemplateKPI;"Evaluation Template KPI"."KPI Category")
                {
                }
                column(KPIItem_EvaluationTemplateKPI;"Evaluation Template KPI"."KPI Item")
                {
                }
                column(MinEvaluationScore_EvaluationTemplateKPI;"Evaluation Template KPI"."Min Evaluation Score")
                {
                }
                column(MaxEvaluationScore_EvaluationTemplateKPI;"Evaluation Template KPI"."Max Evaluation Score")
                {
                }
                column(Comments_EvaluationTemplateKPI;"Evaluation Template KPI".Comments)
                {
                }
                column(KPICategoryName_EvaluationTemplateKPI;"Evaluation Template KPI"."KPI Category Name")
                {
                }
                column(KPIItemName_EvaluationTemplateKPI;"Evaluation Template KPI"."KPI Item Name")
                {
                }
                column(KPIScoreRangeDefinition_EvaluationTemplateKPI;"Evaluation Template KPI"."KPI Score Range Definition")
                {
                }
                column(KPICategoryDescription_EvaluationTemplateKPI;"Evaluation Template KPI"."KPI Category Description")
                {
                }
                column(KPIItemDescription_EvaluationTemplateKPI;"Evaluation Template KPI"."KPI Item Description")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        EvaItem : Record "Evaluation Items";
}

