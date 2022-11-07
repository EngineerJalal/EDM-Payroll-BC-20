report 98064 "Employee Evaluation Sheet"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employee Evaluation Sheet.rdlc';

    dataset
    {
        dataitem("Evaluation Data Main";"Evaluation Data Main")
        {
            RequestFilterFields = "Employee No",Date,Status,"Evaluation Template","Evaluation Interval","Evaluation Period";
            column(Code_EvaluationDataMain;"Evaluation Data Main".Code)
            {
            }
            column(Date_EvaluationDataMain;"Evaluation Data Main".Date)
            {
            }
            column(EvaluatedBy_EvaluationDataMain;"Evaluation Data Main"."Evaluated By")
            {
            }
            column(Description_EvaluationDataMain;"Evaluation Data Main".Description)
            {
            }
            column(Status_EvaluationDataMain;"Evaluation Data Main".Status)
            {
            }
            column(SuggestedStatus_EvaluationDataMain;"Evaluation Data Main"."Suggested Status")
            {
            }
            column(EmployeeNo_EvaluationDataMain;"Evaluation Data Main"."Employee No")
            {
            }
            column(EvaluationComment_EvaluationDataMain;"Evaluation Data Main"."Evaluation Comment")
            {
            }
            column(ManagerComment_EvaluationDataMain;"Evaluation Data Main"."Manager Comment")
            {
            }
            column(EmployeeComment_EvaluationDataMain;"Evaluation Data Main"."Employee Comment")
            {
            }
            column(EvaluationTemplate_EvaluationDataMain;"Evaluation Data Main"."Evaluation Template")
            {
            }
            column(EvaluationInterval_EvaluationDataMain;"Evaluation Data Main"."Evaluation Interval")
            {
            }
            column(EvaluationPeriod_EvaluationDataMain;"Evaluation Data Main"."Evaluation Period")
            {
            }
            column(ManagerNo_EvaluationDataMain;"Evaluation Data Main"."Manager No")
            {
            }
            column(EmployementDate_EvaluationDataMain;"Evaluation Data Main"."Employement Date")
            {
            }
            column(EmployeeName_EvaluationDataMain;"Evaluation Data Main"."Employee Name")
            {
            }
            column(ManagerName_EvaluationDataMain;"Evaluation Data Main"."Manager Name")
            {
            }
            column(JobTitle_EvaluationDataMain;"Evaluation Data Main"."Job Title")
            {
            }
            column(AverageScore_EvaluationDataMain;"Evaluation Data Main"."Average Score")
            {
            }
            column(EvaluatedByName_EvaluationDataMain;"Evaluation Data Main"."Evaluated By Name")
            {
            }
            column(GetScoreRange;GetScoreRange)
            {
            }
            dataitem("Evaluation Data KPI";"Evaluation Data KPI")
            {
                DataItemLink = "Evaluation Code"=FIELD(Code);
                RequestFilterFields = "KPI Category","KPI Item";
                column(EvaluationCode_EvaluationDataKPI;"Evaluation Data KPI"."Evaluation Code")
                {
                }
                column(Score_EvaluationDataKPI;"Evaluation Data KPI".Score)
                {
                }
                column(KPICategoryName_EvaluationDataKPI;"Evaluation Data KPI"."KPI Category Name")
                {
                }
                column(KPIItemName_EvaluationDataKPI;"Evaluation Data KPI"."KPI Item Name")
                {
                }
                column(Comments_EvaluationDataKPI;"Evaluation Data KPI".Comments)
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

    procedure GetScoreRange() ScoreRange : Text;
    var
        EvaTemKPItbt : Record "Evaluation Template KPI";
        EvaMaintbt : Record "Evaluation Data Main";
    begin
        EvaMaintbt.SETRANGE(Code,"Evaluation Data KPI"."Evaluation Code");
        if EvaMaintbt.FINDFIRST then
          begin
            EvaTemKPItbt.SETRANGE("Evaluation Code",EvaMaintbt."Evaluation Template");
            EvaTemKPItbt.SETRANGE("KPI Category","Evaluation Data KPI"."KPI Category");
            EvaTemKPItbt.SETRANGE("KPI Item","Evaluation Data KPI"."KPI Item");
            if EvaTemKPItbt.FINDFIRST then
              exit(FORMAT(EvaTemKPItbt."Min Evaluation Score") + ' - ' + FORMAT(EvaTemKPItbt."Max Evaluation Score"));
          end;
          exit('-');
    end;
}

