page 98103 "Allowance Deduction Temp List"
{
    // version EDM.HRPY2

    Caption = 'Allowance Deduction Template';
    CardPageID = "Allowance Deduction Temp Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Allowance Deduction Template"=rimd;
    SourceTable = "Allowance Deduction Template";
    SourceTableView = WHERE(IsSchoolAllowance=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea=All;
                }
                field(Name;Name)
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("Valid From";"Valid From")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Till Date";"Till Date")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field(Inactive;Inactive)
                {
                    ApplicationArea=All;
                }
                field("Applied by";"Applied by")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Declare Type";"Declare Type")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Maximum Children";"Maximum Children")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Affected By Attendance";"Affected By Attendance")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Auto Generate";"Auto Generate")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Average Days/Month";"Average Days/Month")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            //Caption = 'Reports';
            action("Allowance Deduction Utility")
            {
                Image = CalculateBalanceAccount;
                                                    ApplicationArea=All;

                trigger OnAction();
                var
                    AllowDedUtility : Report "Allowance Deduction Utility";
                begin
                    AllowDedUtility.SetParameter(false);
                    AllowDedUtility.RUN;
                end;
            }
        }
    }
}

