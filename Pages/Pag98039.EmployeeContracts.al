page 98039 "Employee Contracts"
{
    // version SHR1.0,EDM.HRPY1

    DataCaptionFields = "Employee No.";
    PageType = Card;
    SourceTable = "Employee Contracts";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Employment Contract Code"; "Employment Contract Code")
                {
                    ApplicationArea = All;
                }
                field("Valid From"; "Valid From")
                {
                    ApplicationArea = All;
                }
                field("Valid To"; "Valid To")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Contract Termination Date"; "Termination Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ontract")
            {
                Caption = 'C&ontract';
                action(Agreement)
                {
                    ApplicationArea = All;
                    /* Stopped By EDM.MM
                    Caption = 'Agreement';
                    RunObject = Page "HR Comment Sheet EDM";
                    RunPageLink = "Table Name"=CONST(8),"No."=FIELD("Employee No."),"Alternative Address Code"=FIELD("Employment Contract Code");
                    */
                }
            }
        }
    }
}

