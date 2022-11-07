page 98126 "Job Offer"
{
    PageType = List;
    SourceTable = "Job Offer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No.";"Applicant No.")
                {
                    ApplicationArea=All;
                }
                field("Applicant Name";"Applicant Name")
                {
                    ApplicationArea=All;
                }
                field("Potential Joining Date";"Potential Joining Date")
                {
                    ApplicationArea=All;
                }
                field("Potential Offered Salary";"Potential Offered Salary")
                {
                    ApplicationArea=All;
                }
                field("Offer Validity";"Offer Validity")
                {
                    ApplicationArea=All;
                }
                field("Applicants Comments";"Applicants Comments")
                {
                    ApplicationArea=All;
                }
                field("Company Comments";"Company Comments")
                {
                    ApplicationArea=All;
                }
            }
        }
    }
}    