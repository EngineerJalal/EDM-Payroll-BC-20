page 98060 "Pension Scheme"
{
    // version PY1.0,EDM.HRPY1

    // MEG01.0 --> MB.870 : - Drill down in Pension Scheme,listing its members
    // MEG02.00 [MB.0307] : - Add 2 new field for the new functionality of Gratification 13 month

    Caption = 'Pension Scheme';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Pension Scheme";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Scheme No.";Rec."Scheme No.")
                {
                    ApplicationArea = All;
                }
                field("Scheme Name";Rec."Scheme Name")
                {
                    ApplicationArea = All;
                }
                field("Scheme Caption";Rec."Scheme Caption")
                {
                    ApplicationArea = All;
                }
                field("Pension Type";Rec."Pension Type")
                {
                    Caption = 'Scheme Type';
                    ApplicationArea = All;
                }
                field(Type;Rec.Type)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Amount Type";Rec."Amount Type")
                {
                    ApplicationArea = All;
                }
                field("Employee Contribution %";Rec."Employee Contribution %")
                {
                    ApplicationArea = All;
                }
                field("Employer Contribution %";Rec."Employer Contribution %")
                {
                    Editable = "EmployerContribution%Editable";
                    ApplicationArea = All;
                }
                field("Maximum Monthly Contribution";Rec."Maximum Monthly Contribution")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Before Monthly Cont Date";Rec."Before Monthly Cont Date")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Before Max Monthly Cont";Rec."Before Max Monthly Cont")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Before Monthly Cont Date 2";Rec."Before Monthly Cont Date 2")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Before Max Monthly Cont 2";Rec."Before Max Monthly Cont 2")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Associated Pay Element";Rec."Associated Pay Element")
                {
                    ApplicationArea = All;
                }
                field("Maximum Applicable Age";Rec."Maximum Applicable Age")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Foreigners Ineligible";Rec."Foreigners Ineligible")
                {
                    Visible = LebanonPayLaw;
                    ApplicationArea = All;
                }
                field("Amount Type Classification";Rec."Amount Type Classification")
                {
                    ApplicationArea = All;
                }
                field("Manual Pension";Rec."Manual Pension")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("No. of Members";Rec."No. of Members")
                {
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Employee: Record Employee;
                        BirthDateFrom: Date;
                    begin
                        //MB.870+
                        PayParam.GET;
                        if "Maximum Applicable Age" > 0 then
                            BirthDateFrom := CALCDATE('-' + FORMAT("Maximum Applicable Age") + 'Y', WORKDATE);
                        Employee.SETRANGE(Status, Employee.Status::Active);
                        Employee.SETRANGE(Declared, Employee.Declared::Declared);
                        if BirthDateFrom <> 0D then
                            Employee.SETFILTER("Birth Date", '%1..', BirthDateFrom);
                        PAGE.RUN(5201, Employee);
                        //MB.870-
                    end;
                }
                field("Pension Payroll Date";Rec."Pension Payroll Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payroll Posting Group";Rec."Payroll Posting Group")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                group(Administration)
                {
                    field("Vendor No.";Rec."Vendor No.")
                    {
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field("Employee Posting Account";Rec."Employee Posting Account")
                    {
                        Caption = 'Employee Posting Acct.';
                        ApplicationArea = All;
                    }
                    field("Employer Posting Account";Rec."Employer Posting Account")
                    {
                        Caption = 'Employer Posting Acct.';
                        ApplicationArea = All;
                    }
                    field("Expense Account";Rec."Expense Account")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Project)
                {
                    Visible = false;
                    field("Employee Posting Project Acc.";Rec."Employee Posting Project Acc.")
                    {
                        ApplicationArea = All;
                    }
                    field("Employer Posting Project Acc.";Rec."Employer Posting Project Acc.")
                    {
                        ApplicationArea = All;
                    }
                    field("Expense Project Acc.";Rec."Expense Project Acc.")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Scheme")
            {
                Caption = '&Scheme';
                action("Period Setup")
                {
                    Caption = 'Period Setup';
                    RunObject = Page "Payroll Period Setup";
                    RunPageLink = "Table Name" = CONST(Pension), "Pension Scheme No." = FIELD("Scheme No.");
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            action("Recalculate No. of Members")
            {
                Caption = 'Recalculate No. of Members';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if CONFIRM('Confirm Calculate No. of Members of this pension scheme?', true) then
                        CalculateNoMember;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        PrepareFields
    end;

    trigger OnInit();
    begin
        "EmployerContribution%Editable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        PrepareFields
    end;

    trigger OnOpenPage();
    begin
        PayParam.GET;
        LebanonPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Lebanon);
        IF "Pension Type" = '' THEN BEGIN
            PensionTypes.RESET;
            PensionTypes.SETRANGE("Pension Inactive", FALSE);
            PensionTypes.SETRANGE("Pension Type", Type);
            PensionTypes.SETRANGE("Pension Labor Law", PayParam."Payroll Labor Law");
            IF PensionTypes.FINDFIRST THEN BEGIN
                VALIDATE("Pension Type", PensionTypes."Pension Code");
                MODIFY;
            END;
        END;
    end;

    var
        PayParam: Record "Payroll Parameter";
        [InDataSet]
        "EmployerContribution%Editable": Boolean;
        LebanonPayLaw: Boolean;
        PensionTypes: Record "Pension Types";

    procedure PrepareFields();
    var
        Employee: Integer;
    begin
        case "Amount Type" of
            "Amount Type"::Percentage,
          "Amount Type"::"Fixed Amount":
                "EmployerContribution%Editable" := true;
        /*"Amount Type"::"2",
        "Amount Type"::"3":
          BEGIN
            "EmployerContribution%Editable" := FALSE;
            "Employer Contribution %" := 0;
          END;*/
        end;
    end;

    procedure CalculateNoMember();
    var
        Employee: Record Employee;
        PayrollStatus: Record "Payroll Status";
        BirthDateFrom: Date;
        CountMembers: Decimal;
    begin
        PayParam.GET;
        if "Maximum Applicable Age" > 0 then
            BirthDateFrom := CALCDATE('-' + FORMAT("Maximum Applicable Age") + 'Y', WORKDATE);
        Employee.SETRANGE(Status, Employee.Status::Active);
        Employee.SETRANGE(Declared, Employee.Declared::Declared);
        if BirthDateFrom <> 0D then
            Employee.SETFILTER("Birth Date", '%1..', BirthDateFrom);
        if Employee.FIND('-') then begin
            "No. of Members" := Employee.COUNT;
            MODIFY;
        end;
    end;
}

