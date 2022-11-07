page 98125 "Probation Evaluation Sheet"
{
    PageType = List;
    SourceTable = "Probation Evaluation Sheet";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field ("Employee No.";"Employee No.")
                {
                    ApplicationArea=All;

                }  
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea=All;
                    
                }                 
                field("Evaluation Type";"Evaluation Type")
                {
                    ApplicationArea=All;

                }
                field("Evaluation Description";"Evaluation Description")
                {
                    ApplicationArea=All;

                }
                field("Evaluation Date";"Evaluation Date")
                {
                    ApplicationArea=All;

                }
                field("Evaluation Time";"Evaluation Time")
                {
                    ApplicationArea=All;

                }
                field("Evaluated By";"Evaluated By")
                {
                    ApplicationArea=All;

                }
                field("Evaluation Remarks";"Evaluation Remarks")
                {
                    ApplicationArea=All;

                }
                field("Evaluation Grade";"Evaluation Grade")
                {
                    ApplicationArea=All;

                }
                field("Evaluation Status";"Evaluation Status")
                {
                    ApplicationArea=All;

                }
                field("Next Evaluation Date";"Next Evaluation Date")
                {
                    ApplicationArea=All;

                }
                field("Next Evaluated By";"Next Evaluated By")
                {
                    ApplicationArea=All;
                    
                }               
            }
        }
    }

trigger OnOpenPage();
begin
    IsEvaluationOfficer := PayrollFunctions.IsEvaluationOfficer(UserId);
    if IsEvaluationOfficer = false then
      error('No Permission!');
end;
    var 
    IsEvaluationOfficer : Boolean;
    PayrollFunctions : Codeunit "Payroll Functions";
}

