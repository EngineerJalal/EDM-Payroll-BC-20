table 98100 "Evaluation Items"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Code";Code[20])
        {

            trigger OnValidate();
            begin
                if Description = '' then
                  Description := Code;
            end;
        }
        field(2;Description;Text[250])
        {
        }
        field(3;"Item Type";Option)
        {
            OptionCaption = ',KPI Category,KPI Item,Evaluation interval,Evaluation period';
            OptionMembers = ,"KPI Category","KPI Item","Evaluation interval","Evaluation period";
        }
        field(4;Name;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Code","Item Type")
        {
        }
    }

    fieldgroups
    {
    }
}

