table 98072 "Emp. Travel Per Deem Policy"
{
    // version EDM.HRPY2

    LookupPageID = "Pension Scheme List";

    fields
    {
        field(1;"Policy Code";Code[20])
        {
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Travel Per Deem Policy"));
        }
        field(2;"Employment Years (From)";Integer)
        {
        }
        field(3;"Employment Years (To)";Integer)
        {
        }
        field(4;"Job Category";Code[10])
        {
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Job Category"));
        }
        field(5;"Per Deem % Of Basic Salary";Decimal)
        {
        }
        field(6;"Price per Hrs";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Policy Code","Employment Years (From)","Employment Years (To)","Job Category")
        {
        }
    }

    fieldgroups
    {
    }
}

