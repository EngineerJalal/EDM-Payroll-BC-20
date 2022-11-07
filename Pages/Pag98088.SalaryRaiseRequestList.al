page 98088 "Salary Raise Request List"
{
    // version EDM.HRPY2

    CardPageID = "Salary Raise Request";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Employee Salary History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea=All;
                }
                field("Employee No.";"Employee No.")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Employee Type";"Employee Type")
                {
                    ApplicationArea=All;
                }
                field("Salary Start Date";"Salary Start Date")
                {
                    ApplicationArea=All;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea=All;
                }
                field("Requested Date";"Requested Date")
                {
                    ApplicationArea=All;
                }
                field("Approved By";"Approved By")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Approved Date";"Approved Date")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Source Type";"Source Type")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Type of Salary";GetSalaryRaiseReqyestStatus)
                {
                    ApplicationArea=All;
                }
                field("Request Status";"Change Status")
                {
                    ApplicationArea=All;
                }
                field("Bonus System";"Bonus System")
                {
                    ApplicationArea=All;
                }
                field("Total Basic & Allowance";"TotalPay&Allow")
                {
                    ApplicationArea=All;
                }
                field("Total Related Basic & Allowance";TotalRelatedBasicAndAllowances)
                {
                    ApplicationArea=All;
                }
                field("Total Salaries";Total)
                {
                    ApplicationArea=All;
                }
                field("Current Salary";CurrentSalary)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Related Salary";RelatedSalary)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Total Current Salary";TotalCurrentSalary)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Bonus System Previous";"Bonus System Previous")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Amount In USD";"Amount In USD")
                {
                    ApplicationArea=All;
                }
                field(Comments;"Request Description")
                {
                    ApplicationArea=All;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea=All;
                }
                field("Employment Date";"Employment Date")
                {
                    ApplicationArea=All;
                }
                field("Employee Category Code";"Employee Category Code")
                {
                    ApplicationArea=All;
                }
                field("Job Position Code";"Job Position Code")
                {
                    ApplicationArea=All;
                }
                field("Employment Type Code";"Employment Type Code")
                {
                    ApplicationArea=All;
                }
                field(Declared;Declared)
                {
                    ApplicationArea=All;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea=All;
                }
                field("Payroll Group Code";"Payroll Group Code")
                {
                    ApplicationArea=All;
                }
                field("Job Categroy";"Job Categroy")
                {
                    ApplicationArea=All;
                }
                field("Last Comment";"Last Comment")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Salary Appraisal History")
            {
                Image = "Report";
                RunObject = Report "Salary Appraisal History";
                ApplicationArea=All;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        TotalRelatedBasicAndAllowances := "Basic Pay Rel" + "Car Rel" + "Phone Rel" + "House Rel" + "Ticket Rel" +"Other Rel" + "Food Rel";
        Total := "TotalPay&Allow" + TotalRelatedBasicAndAllowances;


        CurrentSalary := "Basic Previous" + "Phone Previous" + "Car Previous" + "House Previous" + "Food Previous" + "Ticket Previous" + "Other Previous";
        RelatedSalary := "Basic Pay Rel" + "Phone Rel" + "Car Rel" + "House Rel" + "Food Rel" + "Ticket Rel" + "Other Rel";
        TotalCurrentSalary := CurrentSalary + RelatedSalary;
        CALCFIELDS("Last Comment");
    end;

    trigger OnOpenPage();
    begin
        EvaluationOfficerPermission := PayrollFunctions.IsEvaluationOfficer(UserId);
        IF EvaluationOfficerPermission=false then
            Error('No Permission!');

        // 20.01.2018 : A2+
        IF PayrollFunctions.HideSalaryFields THEN
          ERROR('Access Denied');
        // 20.01.2018 : A2-

        UserRelatedEmpNo := PayrollFunctions.GetUserRelatedEmployeeNo(USERID);

        FILTERGROUP(2);
        SETFILTER("Source Type",'=%1',"Source Type"::"Raise Request");
        if UserRelatedEmpNo <> '' then
           SETFILTER("Employee No.",UserRelatedEmpNo);

        FILTERGROUP(0);
    end;

    var
        UserRelatedEmpNo : Code[20];
        PayrollFunctions : Codeunit "Payroll Functions";
        CurrentSalary : Decimal;
        RelatedSalary : Decimal;
        TotalCurrentSalary : Decimal;
        Total : Decimal;
        TotalRelatedBasicAndAllowances : Decimal;
        EvaluationOfficerPermission : Boolean;
        
}

