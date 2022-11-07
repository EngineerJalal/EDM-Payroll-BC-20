table 98073 "Pension Types"
{
    // version EDM.HRPY1

    DrillDownPageID = "Pension Types";
    LookupPageID = "Pension Types";

    fields
    {
        field(1; "Pension Code"; Code[10])
        {
        }
        field(2; "Pension Name"; Text[50])
        {
        }
        field(3; "Pension Type"; Option)
        {
            OptionCaption = '" ,EOSIND,FAMSUB,MHOOD,VacationSalary,VacTickets,Insurance,Bonus,GOSI,GOSI-FOR,HOUSING,IQAMA,11,12,ReturnTax,ReturnMH,Net Salary,FundContribution-Basic,FundContribution-Net,Medical,Baladiyah';
            OptionMembers = " ",EOSIND,FAMSUB,MHOOD,VacationSalary,VacTickets,Insurance,Bonus,GOSI,"GOSI-FOR",HOUSING,IQAMA,"11","12",ReturnTax,ReturnMH,"Net Salary","FundContribution-Basic","FundContribution-Net","Medical","Baladiyah";
        }
        field(4; "Pension Labor Law"; Option)
        {
            OptionCaption = 'Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar';
            OptionMembers = Lebanon,Nigeria,Egypt,UAE,Iraq,Qatar;
        }
        field(5; "Amount Type Classification"; Option)
        {
            OptionCaption = '" ,FIXED,VARIABLE"';
            OptionMembers = " ","FIXED",VARIABLE;
        }
        field(6; "Formula Type"; Option)
        {
            OptionCaption = 'Percentage,Fixed Amount';
            OptionMembers = Percentage,"Fixed Amount";
        }
        field(7; "Pension Employer Percent"; Decimal)
        {
        }
        field(8; "Pension Employee Percent"; Decimal)
        {
        }
        field(9; "Pension Inactive"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Pension Code")
        {
        }
    }

    fieldgroups
    {
    }
}

