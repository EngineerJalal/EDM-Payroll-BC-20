table 98031 "HR Permissions"
{
    fields
    {
        field(1; "User ID"; Code[50])
        {
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            /*trigger OnLookup();
            begin
                //UserMgt.LookupUserID("User ID");
                UserMgt.DisplayUserInformation("User ID");
            end;

            trigger OnValidate();
            var
                UserSelection: Codeunit "User Selection";
            begin
                //UserMgt.ValidateUserID("User ID");
                UserSelection.ValidateUserName("User ID");
                InsertDefaultValues();
            end;*/
        }
        field(2; "Transaction Type"; Option)
        {
            OptionMembers = ALL,Benefit,Absence,Training,Employee,Applicant;
        }
        field(3; "Function"; Code[30])
        {
            TableRelation = "HR System Code"."Code" WHERE(Category = CONST("Function"));
        }
        field(4; "User Type"; Option)
        {
            Editable = false;
            InitValue = "Windows Logins";
            OptionMembers = "Database Logins","Windows Logins";
        }
        field(5; "Access Only Employee View"; Boolean)
        {
        }
        field(6; "Assigned Employee Code"; Code[20])
        {
            TableRelation = Employee."No." WHERE(Status = CONST(Active));
        }
        field(7; "Hide Salaries"; Boolean)
        {
        }
        field(8; "Req. Approval on Salary Change"; Boolean)
        {
        }
        field(9; "Req. App. on Calculate Pay"; Boolean)
        {
        }
        field(10; "Req. App. on Finalize Pay"; Boolean)
        {
        }
        field(11; "Req. Approval on Pay Slip"; Boolean)
        {
        }
        field(12; "Attendance Limited Access"; Boolean)
        {
            Description = 'Added in order to set validation for Manger - 18.04.2017 : A2';
        }
        field(13; "Req. Approval on Loan"; Boolean)
        {
        }
        field(14; "Permission Type"; Option)
        {
            OptionMembers = General,Restricted;
            OptionCaption = 'General,Restricted';
        }
        field(15; "HR Officer"; Boolean)
        {
        }
        field(16; "Payroll Officer"; Boolean)
        {
        }
        field(17; "Attendance Officer"; Boolean)
        {
        }
        field(18; "Leaves Officer"; Boolean)
        {
        }
        field(19; "Data entry Officer"; Boolean)
        {
        }
        field(20; "Recruitment Officer"; Boolean)
        {
        }
        field(21; "Evaluation Officer"; Boolean)
        {
        }
        field(22; "Administration Officer"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "User ID", "Transaction Type", "Function")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        InsertDefaultValues();
    end;

    var
        UserMgt: Codeunit "User Management";
        UserSetupTbt: Record "User Setup";
        HumanResSetupTbt: Record "Human Resources Setup";

    local procedure InsertDefaultValues();
    begin
        Rec."Function" := 'ALL';
        Rec."Transaction Type" := Rec."Transaction Type"::ALL;
        HumanResSetupTbt.GET();
        if HumanResSetupTbt."Use System Approval" then begin
            Rec."Req. App. on Calculate Pay" := true;
            Rec."Req. App. on Finalize Pay" := true;
            Rec."Req. Approval on Pay Slip" := true;
            Rec."Req. Approval on Salary Change" := true;
        end;
        UserSetupTbt.RESET;
        CLEAR(UserSetupTbt);
        UserSetupTbt.SETRANGE(UserSetupTbt."User ID", "User ID");
        if UserSetupTbt.FINDFIRST = false then begin
            UserSetupTbt.INIT;
            UserSetupTbt."User ID" := Rec."User ID";
            UserSetupTbt."Register Time" := true;
            UserSetupTbt."Time Sheet Admin." := true;
            UserSetupTbt.INSERT;
        end;
    end;
}