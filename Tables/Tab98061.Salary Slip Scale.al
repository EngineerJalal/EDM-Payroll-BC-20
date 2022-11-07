table 98061 "Salary Slip Scale"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"From Salary Scale";Decimal)
        {
        }
        field(2;"To Salary Scale";Decimal)
        {
        }
        field(3;"Appraisal And Deduction";Option)
        {
            OptionMembers = Deduction,"No Action",Appraisal;
        }
        field(4;"Amount ACY";Decimal)
        {
        }
        field(5;Band;Code[10])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST(Band));
        }
        field(6;Grade;Code[10])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST(Grade));
        }
        field(7;"Job Category";Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST("Job Category"));
        }
        field(8;"Job Title";Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST("Job Title"));
        }
        field(9;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"From Salary Scale","To Salary Scale",Band,Grade,"Job Category","Job Title")
        {
        }
    }

    fieldgroups
    {
    }
}

