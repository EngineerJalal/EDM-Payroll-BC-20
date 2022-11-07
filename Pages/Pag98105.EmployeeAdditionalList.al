page 98105 "Employee Additional List"
{
    PageType = List;
    SourceTable = "Employee Additional Info";
    Editable = FALSE;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea=All;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea=All;
                }
                field("Work Permit Valid Until";"Work Permit Valid Until")
                {
                    ApplicationArea=All;
                }
                field("Insurance Valid Until";"Insurance Valid Until")
                {
                    ApplicationArea=All;
                }
                field("Passport Valid Until";"Passport Valid Until")
                {
                    ApplicationArea=All;
                }
                field("Visa Expiry Date";"Visa Expiry Date")
                {
                    ApplicationArea=All;
                }
                field("TECOM Expiry Date";"TECOM Expiry Date")
                {
                    visible = UAETecom;
                    ApplicationArea=All;
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        //UAE Tecom EDM.JA+
        PayParam.Get;
        IF PayParam."Payroll Labor Law"=PayParam."Payroll Labor Law"::"UAE" then
            UAETecom := true
        else UAETecom := false;
        //UAE Tecom EDM.JA-
    end;        
    
    var
    PayParam : Record "Payroll Parameter";
    UAETecom : Boolean;
}

