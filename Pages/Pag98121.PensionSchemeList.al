page 98121 "Pension Scheme List"
{
    // version EDM.HRPY1

    CardPageID = "Pension Scheme";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Pension Scheme";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Scheme No.";"Scheme No.")
                {
                    ApplicationArea=All;
                }
                field("Scheme Name";"Scheme Name")
                {
                    ApplicationArea=All;
                }
                field("Pension Type";"Pension Type")
                {
                    Caption = 'Scheme Type';
                    ApplicationArea=All;
                }
                field(Type;Type)
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Amount Type";"Amount Type")
                {
                    ApplicationArea=All;
                }
                field("Employee Contribution %";"Employee Contribution %")
                {
                    ApplicationArea=All;
                }
                field("Employer Contribution %";"Employer Contribution %")
                {
                    ApplicationArea=All;
                }
                field("No. of Members";"No. of Members")
                {
                    ApplicationArea=All;
                }
                field("Amount Type Classification";"Amount Type Classification")
                {
                    ApplicationArea=All;
                }
                field("Employee Posting Account";"Employee Posting Account")
                {
                    ApplicationArea=All;
                }
                field("Employer Posting Account";"Employer Posting Account")
                {
                    ApplicationArea=All;
                }
                field("Expense Account";"Expense Account")
                {
                    ApplicationArea=All;
                }
                field("Payroll Posting Group";"Payroll Posting Group")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Calculate No. of Members")
                {
                    Caption = 'Calculate No. of Members';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        IF CONFIRM('Confirm Calculate No. of Members of pension scheme: %1 ?',TRUE,"Scheme Name") THEN
                          CalculateNoMember("Scheme No.");
                    end;
                }
                action("Calculate All No. of Members")
                {
                    Caption = 'Calculate All No. of Members';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        PensionScheme : Record "Pension Scheme";
                    begin
                        IF CONFIRM('Confirm Calculate No. of Members For all Pensions Scheme?',TRUE) THEN
                          IF PensionScheme.FIND('-')  THEN
                            REPEAT
                              CalculateNoMember(PensionScheme."Scheme No.");
                            UNTIL PensionScheme.NEXT = 0
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        FilterGroup(2);
        PayParam.GET;
        CALCFIELDS("Pension Type Labor Law");
        SETRANGE("Pension Type Labor Law",PayParam."Payroll Labor Law");
        FilterGroup(0);
        //
        PayrollOfficerPermission := PayrollFunctions.IsPayrollOfficer(UserId);
        IF PayrollOfficerPermission=false then
            Error('No Permission!');
    end;

    var
        PayParam : Record "Payroll Parameter";
        PayrollFunctions : Codeunit "Payroll Functions";
        PayrollOfficerPermission : Boolean;

    procedure CalculateNoMember(PensionNo : Code[10]);
    var
        Employee : Record Employee;
        PayrollStatus : Record "Payroll Status";
        PayParam : Record "Payroll Parameter";
        BirthDateFrom : Date;
        CountMembers : Decimal;
        PensionScheme2 : Record "Pension Scheme";
    begin
        PayParam.GET;
        IF PensionScheme2.GET(PensionNo) THEN BEGIN
          IF PensionScheme2."Maximum Applicable Age" > 0 THEN
            BirthDateFrom := CALCDATE('-' + FORMAT(PensionScheme2."Maximum Applicable Age") + 'Y',WORKDATE);
          Employee.SETRANGE(Status,Employee.Status::Active);
          Employee.SETRANGE(Declared,Employee.Declared::Declared);
          IF BirthDateFrom <> 0D THEN
            Employee.SETFILTER("Birth Date",'%1..',BirthDateFrom);
          IF Employee.FIND('-') THEN BEGIN
            PensionScheme2."No. of Members" := Employee.COUNT;
            PensionScheme2.MODIFY;
          END;
        END;
    end;
}

