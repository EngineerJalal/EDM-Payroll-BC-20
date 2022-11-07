table 98098 "Pay Details Approval"
{
    // version EDM.HRPY1


    fields
    {
        field(1;"User ID";Code[50])
        {
            TableRelation = User."User Name";
        }
        field(2;"Payroll Group Code";Code[10])
        {
            TableRelation = "HR Payroll Group"."Code";
        }
        field(3;"Payroll Date";Date)
        {
        }
        field(4;"Req. Approval on Calculate Pay";Boolean)
        {
        }
        field(5;"Req. Approval on Finalize Pay";Boolean)
        {
        }
        field(6;"Req. Approval on Pay Slip";Boolean)
        {
        }
        field(7;"Workflow Field Nb";Integer)
        {
        }
        field(8;"Workflow Calc Pay Description";Text[100])
        {
        }
        field(9;"Workflow Fin Pay Description";Text[100])
        {
        }
        field(10;"Workflow Pay Slip Description";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"User ID","Payroll Group Code","Payroll Date")
        {
        }
    }

    fieldgroups
    {
    }
}

