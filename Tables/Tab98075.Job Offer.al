table 98075 "Job Offer"
{
    fields
    {
        
        field(1;"Line No.";Integer)
        {
            AutoIncrement = True;
        }
        field(2;"Applicant No.";Code[20])
        {
            TableRelation = Applicant;
        }
        field(3;"Applicant Name";text[100])
        {
            Editable = false;
        }
        field(4;"Potential Joining Date";Date)
        {
        }
        field(5;"Potential Offered Salary";Decimal)
        {
        }
        field(6;"Offer Validity";Date)
        {
            Caption = 'Offer Validity (Till Date)';
        }
        field(7;"Applicants Comments";Text[250])
        {
        }
        field(8;"Company Comments";Text[250])
        {
        }        
    }
}