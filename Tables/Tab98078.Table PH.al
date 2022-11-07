table 98078 "Table PH"
{
    /*
    Feature               |   Description
    ----------------------------------------------------------
    SubPayroll            |   SubPayroll
    Allowance Deduction   |   AllowDed
    Hiring Check List     |   HiringCheckList
    Schooling System      |   ShoolingSystem
    Grading System        |   GradingSystem
    Evaulation            |   EvaluationSheet
    Salary Raise          |   SalryRaise
    Resources Concept     |   ResourcesConcept  
    Travel Per Diem Policy|   TravelPerDiemPolicy 
    EOS Provision         |   EOSProvision
    */
    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement=True;
        }
        field(2;Description;Text[250])
        {
        }
    }
}