page 98135 "Imported Schedule"
{

    Caption = 'Imported Schedule';
    PageType = List;
    SourceTable = "Import Schedule from Excel";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee No."; "Employee No.")
                {
                    TableRelation = Employee."No.";
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = FALSE;
                    ApplicationArea = All;
                }
                field("Day 1"; "Day 1")
                {
                    ApplicationArea = All;
                }
                field("Day 2"; "Day 2")
                {
                    ApplicationArea = All;
                }
                field("Day 3"; "Day 3")
                {
                    ApplicationArea = All;
                }
                field("Day 4"; "Day 4")
                {
                    ApplicationArea = All;
                }
                field("Day 5"; "Day 5")
                {
                    ApplicationArea = All;
                }
                field("Day 6"; "Day 6")
                {
                    ApplicationArea = All;
                }
                field("Day 7"; "Day 7")
                {
                    ApplicationArea = All;
                }
                field("Day 8"; "Day 8")
                {
                    ApplicationArea = All;
                }
                field("Day 9"; "Day 9")
                {
                    ApplicationArea = All;
                }
                field("Day 10"; "Day 10")
                {
                    ApplicationArea = All;
                }
                field("Day 11"; "Day 11")
                {
                    ApplicationArea = All;
                }
                field("Day 12"; "Day 12")
                {
                    ApplicationArea = All;
                }
                field("Day 13"; "Day 13")
                {
                    ApplicationArea = All;
                }
                field("Day 14"; "Day 14")
                {
                    ApplicationArea = All;
                }
                field("Day 15"; "Day 15")
                {
                    ApplicationArea = All;
                }
                field("Day 16"; "Day 16")
                {
                    ApplicationArea = All;
                }
                field("Day 17"; "Day 17")
                {
                    ApplicationArea = All;
                }
                field("Day 18"; "Day 18")
                {
                    ApplicationArea = All;
                }
                field("Day 19"; "Day 19")
                {
                    ApplicationArea = All;
                }
                field("Day 20"; "Day 20")
                {
                    ApplicationArea = All;
                }
                field("Day 21"; "Day 21")
                {
                    ApplicationArea = All;
                }
                field("Day 22"; "Day 22")
                {
                    ApplicationArea = All;
                }
                field("Day 23"; "Day 23")
                {
                    ApplicationArea = All;
                }
                field("Day 24"; "Day 24")
                {
                    ApplicationArea = All;
                }
                field("Day 25"; "Day 25")
                {
                    ApplicationArea = All;
                }
                field("Day 26"; "Day 26")
                {
                    ApplicationArea = All;
                }
                field("Day 27"; "Day 27")
                {
                    ApplicationArea = All;
                }
                field("Day 28"; "Day 28")
                {
                    ApplicationArea = All;
                }
                field("Day 29"; "Day 29")
                {
                    ApplicationArea = All;
                }
                field("Day 30"; "Day 30")
                {
                    ApplicationArea = All;
                }
                field("Day 31"; "Day 31")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin

    end;

    var
        PayrollStatus: Record "Payroll Status";
}
