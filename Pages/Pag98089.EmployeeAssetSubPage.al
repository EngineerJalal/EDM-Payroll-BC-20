page 98089 "Employee Asset Sub-Page"
{
    // version EDM.HRPY2

    Caption = 'Employee Asset';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Employee Asset";

    layout
    {
        area(content)
        {
            repeater(Control11)
            {
                field("Line No";"Line No")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Employee No";"Employee No")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Asset details";"Asset details")
                {
                    ApplicationArea=All;

                    trigger OnDrillDown();
                    begin
                        ShowDetails();
                    end;
                }
                field("Given Date";"Given Date")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Type of asset";"Type of asset")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Status;Status)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Returned Date";"Returned Date")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Attachment;Attachment)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Remarks;Remarks)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    local procedure ShowDetails();
    begin
        PAGE.RUN(PAGE::"Employee Assets List",Rec);
    end;
}

