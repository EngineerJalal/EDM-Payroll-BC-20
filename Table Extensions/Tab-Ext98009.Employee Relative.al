tableextension 98009 "ExtEmployeeRelative" extends "Employee Relative"
{

    fields
    {
        field(80000; "Arabic First Name"; Text[30])
        {
        }
        field(80001; "Arabic Middle Name"; Text[30])
        {
        }
        field(80003; "Arabic Last Name"; Text[30])
        {
        }
        field(80004; "Arabic Mother Name"; Text[30])
        {
        }
        field(80005; "Arabic Nationality"; Text[30])
        {
        }
        field(80006; "Arabic Place Of Birth"; Text[30])
        {
        }
        field(80007; "ID No."; Code[12])
        {
        }
        field(80008; "Finance Register No."; Code[20])
        {
        }
        field(80009; "Arabic Company Name"; Text[30])
        {
        }
        field(80010; "Personal Register No."; Code[20])
        {
        }
        field(80011; "Arabic Gender"; Option)
        {
            OptionCaption = 'ذكر,أنثى';
            OptionMembers = "ذكر","أنثى";
        }
        field(80012; "Arabic Job Title"; Text[30])
        {
        }
        field(80013; "Social Status"; Option)
        {
            OptionMembers = Single,Married,Widow,Divorced,Separated,Engaged;
        }
        field(80014; Student; Option)
        {
            OptionMembers = Yes,No;

            trigger OnValidate();
            begin
                if Working then
                    ERROR('Working is checked');
            end;
        }
        field(80015; "Permenant Disability"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(80016; "Death Date"; Date)
        {
        }
        field(80017; Working; Boolean)
        {
            Description = 'PY1.0';

            trigger OnValidate();
            begin
                PayrollFunctions.RecalSpePayWarning;
            end;
        }
        field(80018; "Eligible Child"; Boolean)
        {
            Description = 'PY1.0';

            trigger OnValidate();
            begin
                HumanResSetup.GET;
                Employee.GET("Employee No.");
                if Employee."Social Status" = Employee."Social Status"::Single then begin
                    if (not HumanResSetup."Allow Single with Children") and ("Eligible Child") then
                        ERROR('Not allowed to have Children on Single Social Status.');
                end;
                if Relative.GET("Relative Code") then
                    if (Relative.Type <> Relative.Type::Child) and ("Eligible Child") then
                        ERROR('The Relative is not a Child');

                PayrollFunctions.RecalSpePayWarning;
            end;
        }
        field(80019; "Academic Institute Code"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("AcadInstitute"));

            trigger OnValidate();
            begin
                if Relative.GET("Relative Code") then
                    if Relative.Type <> Relative.Type::Child then
                        ERROR('Scholarship is applicable on Children Only');

                if AcademicInfo.GET(AcademicInfo."Table Name"::AcadInstitute, "Academic Institute Code") then
                    "Scholarship Allowance" := AcademicInfo.Entitlement
                else
                    "Scholarship Allowance" := 0;
            end;
        }
        field(80020; "Scholarship Allowance"; Decimal)
        {

            trigger OnValidate();
            begin
                Rec.TestField("Academic Institute Code");
                HumanResSetup.GET;
                if (HumanResSetup."Payroll in Use") and ("Scholarship Applicable") then
                    CheckScholarRules;
            end;
        }
        field(80021; "Scholarship Applicable"; Boolean)
        {

            trigger OnValidate();
            begin
                Rec.TestField("Academic Institute Code");
                if ("Scholarship Applicable") and (not "Eligible Child") then
                    ERROR('Scholarship must be applied on Eligible Children !');
                HumanResSetup.GET;
                if (HumanResSetup."Payroll in Use") and ("Scholarship Applicable") then
                    CheckScholarRules;
                if "Scholarship Applicable" then begin
                    Employee.GET("Employee No.");
                    if Employee."Spouse Employee No." <> '' then begin
                        if not ValidSpouseEmpRel(Employee."Spouse Employee No.", true) then
                            ERROR(Text002 + ' %1.', Employee."Spouse Employee No.");
                    end;
                end;
            end;
        }
        field(80022; "Insurance Applicable"; Boolean)
        {
            Description = 'SHR2.0';

            trigger OnValidate();
            begin
                Rec.TestField("Relative Code");
                Employee.GET("Employee No.");
                if (Employee.Declared = Employee.Declared::Declared) and (Employee.Status = Employee.Status::Active) then begin
                    if "Insurance Applicable" then begin
                        if Employee."Spouse Employee No." <> '' then begin
                            CALCFIELDS(Type);
                            if Type = Type::Child then begin
                                if not ValidSpouseEmpRel(Employee."Spouse Employee No.", false) then
                                    ERROR(Text001 + ' %1.', Employee."Spouse Employee No.");
                            end
                            else
                                ERROR(Text001 + ' %1', Employee."Spouse Employee No.");
                        end;
                        EmpRelative.RESET;
                        EmpRelative.SETRANGE("Employee No.", "Employee No.");
                        EmpRelative.SETRANGE("Relative Code", "Relative Code");
                        if EmpRelative.FindFirst then
                            Employee.GenInsuranceJnlLine("Employee No.", "Relative Code")
                        else
                            ERROR('Relative must be Created First');
                    end
                    else
                        Employee.ReverseInsuranceJnlLine("Employee No.", "Relative Code");
                end;
            end;
        }
        field(80023; Type; Option)
        {
            CalcFormula = Lookup (Relative.Type WHERE(Code = FIELD("Relative Code")));
            Description = 'SHR2.0';
            FieldClass = FlowField;
            OptionMembers = " ",Child,Wife,Husband,Mother,Father,Brother,Sister;
        }
        field(80024; "Relative Age"; Integer)
        {
            Editable = false;
        }
        field(80025; "NSSF Registration Date"; Date)
        {
        }
        field(80026; "Registeration Start Date"; Date)
        {
            Description = 'EDM.IT';
        }
        field(80027; "Registeration End Date"; Date)
        {
            Description = 'EDM.IT';
        }
        field(80028; "Does not Has NSSF"; Boolean)
        {
        }
        field(80029; "Employee Full Name"; Text[150])
        {
            CalcFormula = Lookup (Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80030; "Eligible Exempt Tax"; Boolean)
        {

            trigger OnValidate();
            begin
                HumanResSetup.GET;
                Employee.GET("Employee No.");
                if Employee."Social Status" = Employee."Social Status"::Single then begin
                    if (not HumanResSetup."Allow Single with Children") and ("Eligible Child") then
                        ERROR('Not allowed to have Children on Single Social Status.');
                end;
                if Relative.GET("Relative Code") then
                    if (Relative.Type <> Relative.Type::Child) and ("Eligible Child") then
                        ERROR('The Relative is not a Child');

                PayrollFunctions.RecalSpePayWarning;
            end;
        }
        field(80031; Sex; Option)
        {
            Caption = 'Gender';
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(80032; "School Level"; Code[50])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = FILTER("School Level"));
        }
    }

    trigger OnBeforeDelete();
    begin
        HRCommentLine.SETRANGE("Table Name", HRCommentLine."Table Name"::"Employee Relative");
        HRCommentLine.SETRANGE("No.", Rec."Employee No.");
        HRCommentLine.DELETEALL;
    END;

    procedure CheckScholarRules();
    var
        ScholarCount: integer;
        ScholarAmt: decimal;

    begin
        PayParam.GET;
        EmpRelative.RESET;
        EmpRelative.SETRANGE("Employee No.", "Employee No.");
        EmpRelative.SETRANGE("Scholarship Applicable", TRUE);
        EmpRelative.SETFILTER("Line No.", '<>%1', "Line No.");
        IF EmpRelative.FindFirst THEN
            REPEAT
                ScholarCount := ScholarCount + 1;
                ScholarAmt := ScholarAmt + EmpRelative."Scholarship Allowance";
            UNTIL EmpRelative.NEXT = 0;
        IF (ScholarCount + 1) > PayParam."Max.Scholarship Eligible Child" THEN
            ERROR('Scholarship Child. exceeded.The Max.Scholarsip Eligible Child. = %1', PayParam."Max.Scholarship Eligible Child");
        IF (ScholarAmt + "Scholarship Allowance") > PayParam."Max. Scholarship Allowance" THEN
            ERROR('Scholarship allowance exceeded. The Max.Scholarsip = %1', ROUND(PayParam."Max. Scholarship Allowance", 1));
    end;

    procedure ValidSpouseEmpRel(P_EmpNo: Code[20]; P_IsScholarship: Boolean): Boolean;
    begin
        EmpRelative.RESET;
        EmpRelative.SETRANGE("Employee No.", P_EmpNo);
        EmpRelative.SETRANGE("Relative Code", "Relative Code");
        IF EmpRelative.FindFirst THEN BEGIN
            IF P_IsScholarship THEN BEGIN
                IF NOT EmpRelative."Scholarship Applicable" THEN
                    EXIT(TRUE);
            END
            ELSE
                IF NOT EmpRelative."Insurance Applicable" THEN
                    EXIT(TRUE);
        END
        ELSE
            EXIT(TRUE);
    end;

    var
        PayParam: Record "Payroll Parameter";
        PayDetailLine: Record "Pay Detail Line";
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        AcademicInfo: Record "HR Information";
        EmpRelative: Record "Employee Relative";
        Relative: Record Relative;
        HRCommentLine: Record "HR Comment Line EDM";
        Text001: Label 'Insurance already applied on Spouse Employee#';
        Text002: Label 'Scholarship already applied on Spouse Employee#';
        PayrollFunctions: Codeunit "Payroll Functions";
}