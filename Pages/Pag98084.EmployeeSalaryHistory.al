page 98084 "Employee Salary History"
{
    // version EDM.HRPY1

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Employee Salary History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Location; Location)
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Modified Date"; "Modified Date")
                {
                    ApplicationArea = All;
                }
                field("Modified Time"; "Modified Time")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Basic Pay"; "Basic Pay")
                {
                    ApplicationArea = All;
                }
                field("Basic Previous"; "Basic Previous")
                {
                    ApplicationArea = All;
                }
                field("Cost of Living"; "Cost of Living")
                {
                    ApplicationArea = All;
                }
                field("Cost of Living Previous"; "Cost of Living Previous")
                {
                    ApplicationArea = All;
                }
                field("Phone Allowance"; "Phone Allowance")
                {
                    ApplicationArea = All;
                }
                field("Phone Previous"; "Phone Previous")
                {
                    ApplicationArea = All;
                }
                field("Car Allowance"; "Car Allowance")
                {
                    ApplicationArea = All;
                }
                field("Car Previous"; "Car Previous")
                {
                    ApplicationArea = All;
                }
                field("House Allowance"; "House Allowance")
                {
                    ApplicationArea = All;
                }
                field("House Previous"; "House Previous")
                {
                    ApplicationArea = All;
                }
                field("Food Allowance"; "Food Allowance")
                {
                    ApplicationArea = All;
                }
                field("Food Previous"; "Food Previous")
                {
                    ApplicationArea = All;
                }
                field("Ticket Allowance"; "Ticket Allowance")
                {
                    ApplicationArea = All;
                }
                field("Ticket Previous"; "Ticket Previous")
                {
                    ApplicationArea = All;
                }
                field("Other Allowance"; "Other Allowance")
                {
                    ApplicationArea = All;
                }
                field("Other Previous"; "Other Previous")
                {
                    ApplicationArea = All;
                }
                field("TotalPay&Allow"; "TotalPay&Allow")
                {
                    ApplicationArea = All;
                }
                field("Total Previous"; "Total Previous")
                {
                    ApplicationArea = All;
                }
                field("Modified By"; "Modified By")
                {
                    ApplicationArea = All;
                }
                field("Change Status"; "Change Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Salary History Report")
            {
                RunObject = Report "Employee Salary History";
                ApplicationArea = All;
            }
        }
    }

    trigger OnInit();
    begin
        UserRelatedEmpNo := PayrollFunction.GetUserRelatedEmployeeNo(USERID);
        if UserRelatedEmpNo = '' then
            UserRelatedEmpNo := '...';

        FILTERGROUP(2);
        SETFILTER("Employee No.", UserRelatedEmpNo);
        FILTERGROUP(0);
    end;

    trigger OnOpenPage();
    var
        HRPermission: Record "HR Permissions";
    begin
        // 30.06.2017 : A2+
        HRPermission.SETRANGE("User ID", USERID);
        if HRPermission.FINDFIRST and HRPermission."Hide Salaries" then
            ERROR('You do not have permission')
        // 30.06.2017 : A2-
    end;

    var
        PayrollFunction: Codeunit "Payroll Functions";
        UserRelatedEmpNo: Code[20];
}

