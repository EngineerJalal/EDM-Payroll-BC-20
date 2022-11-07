page 98100 "Evaluation Data Main List"
{
    // version EDM.HRPY2

    Caption = 'Evaluations List';
    CardPageID = "Evaluation Data Main";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Evaluation Data Main";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea=All;
                }
                field(Date;Date)
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Evaluated By";"Evaluated By")
                {
                    ApplicationArea=All;
                }
                field(Status;Status)
                {
                    ApplicationArea=All;
                }
                field("Suggested Status";"Suggested Status")
                {
                    ApplicationArea=All;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea=All;
                }
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
                field("Evaluation Template";"Evaluation Template")
                {
                    ApplicationArea=All;
                }
                field("Evaluation Interval";"Evaluation Interval")
                {
                    ApplicationArea=All;
                }
                field("Evaluation Period";"Evaluation Period")
                {
                    ApplicationArea=All;
                }
                field("Manager No";"Manager No")
                {
                    ApplicationArea=All;
                }
                field("Employement Date";"Employement Date")
                {
                    ApplicationArea=All;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea=All;
                }
                field("Manager Name";"Manager Name")
                {
                    ApplicationArea=All;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea=All;
                }
                field("Average Score";"Average Score")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Employee Evaluation Sheet")
            {
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Employee Evaluation Sheet";
                ApplicationArea=All;
            }
            action("Evaluation Comparison Sheet")
            {
                Image = Statistics;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Evaluation Comparison Sheet";
                ApplicationArea=All;
            }
        }
    }
}

