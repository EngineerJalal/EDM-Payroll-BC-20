pageextension 98008 "ExtEmployeeRelatives" extends "Employee Relatives"
{
    layout
    {
        modify(Comment)
        {
            Visible = false;
        }
        addafter(Comment)
        {
            field(Type; Rec.Type)
            {
                Editable = false;
                Visible = false;
                ApplicationArea=All;
            }
            field("Last Name"; Rec."Last Name")
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Employee Full Name"; Rec."Employee Full Name")
            {
                Visible = false;
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field(Sex; Rec.Sex)
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
                trigger OnValidate()
                begin
                    IF Sex=Sex::Male then
                        VALIDATE("Arabic Gender","Arabic Gender"::"ذكر")
                    ELSE VALIDATE("Arabic Gender","Arabic Gender"::"أنثى");
                end;
            }
            field("Social Status"; Rec."Social Status")
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field(Working; Rec.Working)
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field(Student; Rec.Student)
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Eligible Child"; Rec."Eligible Child")
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Eligible Exempt Tax"; Rec."Eligible Exempt Tax")
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Does not Has NSSF"; Rec."Does not Has NSSF")
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Permenant Disability"; Rec."Permenant Disability")
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Arabic Gender"; Rec."Arabic Gender")
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }            
            field("Arabic First Name"; Rec."Arabic First Name")
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Arabic Middle Name"; Rec."Arabic Middle Name")
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Arabic Last Name"; Rec."Arabic Last Name")
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Arabic Mother Name"; Rec."Arabic Mother Name")
            {
                Visible = false;
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Arabic Nationality"; Rec."Arabic Nationality")
            {
                Visible = false;
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Arabic Place Of Birth"; Rec."Arabic Place Of Birth")
            {
                Visible = false;
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Arabic Job Title"; Rec."Arabic Job Title")
            {
                Visible = false;
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Arabic Company Name"; Rec."Arabic Company Name")
            {
                Visible = false;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Finance Register No."; Rec."Finance Register No.")
            {
                Visible = false;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Personal Register No."; Rec."Personal Register No.")
            {
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Registeration Start Date"; Rec."Registeration Start Date")
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("Registeration End Date"; Rec."Registeration End Date")
            {
                Visible = LebanonPayLaw;
                Editable = IsPayrollOfficer;
                ApplicationArea=All;
            }
            field("ID No."; Rec."ID No.")
            {
                Visible = LebanonPayLaw;
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Death Date"; Rec."Death Date")
            {
                Visible = LebanonPayLaw;
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Academic Institute Code"; Rec."Academic Institute Code")
            {
                Editable = IsHROfficer or IsDataEntryOfficer;
                ApplicationArea=All;
            }
            field("Relative Age"; Rec."Relative Age")
            {
                Visible = LebanonPayLaw;
                ApplicationArea=All;
            }
            field("School Level"; Rec."School Level")
            {
                Visible = LebanonPayLaw and UseSchoolingSystem;
                Editable = IsHROfficer;
                ApplicationArea=All;
            }
        }
    }

    var
        LebanonPayLaw: Boolean;
        PayParam: Record "Payroll Parameter";
        IsHROfficer: Boolean;
        IsDataEntryOfficer: Boolean;
        IsPayrollOfficer: Boolean;
        IsEvaluationOfficer: Boolean;

        IsRecruitmentOfficer: Boolean;
        PayrollFunctions: Codeunit "Payroll Functions";
        UseSchoolingSystem: Boolean;

    trigger OnOpenPage();
    begin
        PayParam.GET;
        LebanonPayLaw := (PayParam."Payroll Labor Law" = PayParam."Payroll Labor Law"::Lebanon);
        IsHROfficer := PayrollFunctions.IsHROfficer(UserId);
        IsDataEntryOfficer := PayrollFunctions.IsDataEntryOfficer(Userid);
        IsPayrollOfficer := PayrollFunctions.IsPayrollOfficer(Userid);
        IsEvaluationOfficer := PayrollFunctions.IsEvaluationOfficer(UserId);
        IsRecruitmentOfficer := PayrollFunctions.IsRecruitmentOfficer(UserId);
        UseSchoolingSystem := PayrollFunctions.IsFeatureVisible('ShoolingSystem');
        IF NOT (IsHROfficer or IsDataEntryOfficer or IsPayrollOfficer) then
            error('No Permission!');
    end;
}