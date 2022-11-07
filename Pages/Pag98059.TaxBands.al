page 98059 "Tax Bands"
{
    // version PY1.0,EDM.HRPY1

    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Tax Band";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Annual Bandwidth";"Annual Bandwidth")
                {
                    ApplicationArea=All;
                }
                field(Rate;Rate)
                {
                    ApplicationArea=All;
                }
                field("Tax Discount %";"Tax Discount %")
                {
                    Visible = EgyptLaborLaw;
                    ApplicationArea=All;
                }
                field("Date";"Date")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        PayParam.GET;
        EgyptLaborLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Egypt);
    end;

    var
        PayParam : Record "Payroll Parameter";
        EgyptLaborLaw : Boolean;
}

