page 98022 "HR Transaction Types"
{
    // version SHR1.0,EDM.HRPY1

    PageType = List;
    SourceTable = "HR Transaction Types";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin

                        // 30.06.2017 : A2+
                        Rec.Description := Rec.Code;
                        Rec.System := false;
                        // 30.06.2017 : A2-
                    end;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea=All;
                }
                field(Type;Rec.Type)
                {
                    TableRelation = "HR System Code".Code where (Code=FILTER('BENEFIT'|'DEDUCTIONS'));
                    ApplicationArea=All;
                }
                field("Associated Pay Element";Rec."Associated Pay Element")
                {
                    ApplicationArea=All;
                }
                field(Recurring;Rec.Recurring)
                {
                    ApplicationArea=All;
                }
                field(System;Rec.System)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Calculation Type";Rec."Calculation Type")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Payroll Group Code";Rec."Payroll Group Code")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Employee Category";Rec."Employee Category")
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

    trigger OnOpenPage();
    begin

        // 30.06.2017 : A2+
        Rec.SETFILTER (System,'%1',false);
        Rec.SETFILTER(Type,'%1|%2','BENEFIT','DEDUCTIONS');
        // 30.06.2017 : A2-
    end;
}

