table 98014 "HR Information"
{
    DrillDownPageID = "HR Information";
    LookupPageID = "HR Information";

    fields
    {
        field(1;"Code";Code[50])
        {
            NotBlank = true;
        }
        field(2;Description;Text[150])
        {
        }
        field(3;"Table Name";Option)
        {
            Description = 'SHR2.0';
            OptionCaption = 'AcadDegree,AcadSpecialty,AcadInstitute,Job Title,Job Position,Competency,Document,Performance,Interview,Disciplinary,Medical Group,Work Accident,Injured Part,ShiftGp,Religion,Survey,SurveyTP,SBU,Vacation Group,AccommodationType,ArabicGovernorate,ArabicElimination,ArabicCity,Band,Grade,Job Category,DrivingLicenseType,Location,Work Location,Bonus System,Type of Asset,School Level,InterviewPhase,Travel Per Deem Policy,Evaluation Type,Type of Offense,Business Unit';
            OptionMembers = AcadDegree,AcadSpecialty,AcadInstitute,"Job Title","Job Position",Competency,Document,Performance,Interview,Disciplinary,"Medical Group","Work Accident","Injured Part",ShiftGp,Religion,Survey,SurveyTP,SBU,"Vacation Group",AccommodationType,ArabicGovernorate,ArabicElimination,ArabicCity,Band,Grade,"Job Category",DrivingLicenseType,Location,"Work Location","Bonus System","Type of Asset","School Level",InterviewPhase,"Travel Per Deem Policy","Evaluation Type","Type of Offense","Business Unit";
        }
        field(4;Entitlement;Decimal)
        {
        }
        field(5;"Exit Interview";Boolean)
        {
        }
        field(6;"Document Path";Text[200])
        {
        }
        field(7;"Daily Sales";Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(8;"Effective Work Days";Decimal)
        {
        }
        field(9;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(10;"Commission Type";Option)
        {
            OptionMembers = " ",Specific,All,Porter,Merchandiser;
        }
        field(11;Classification;Option)
        {
            Description = 'SHR2.0';
            OptionMembers = Applicant,Employee;
        }
        field(12;"Table Name Filter";Option)
        {
            Description = 'SHR2.0';
            FieldClass = FlowFilter;
            OptionMembers = Employee,"Alternative Address","Employee Qualification","Employee Relative","Employee Absence","Misc. Article Information","Confidential Information",Applicant,"Contract Agreement","Applicant Interview","Employee Interview",ExEmp,SurveyQ,SurveyQApp,SurveyQEmp;
        }
        field(13;"Survey Type";Code[50])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("SurveyTP"));
        }
        field(14;"No. Filter";Code[20])
        {
            Description = 'SHR2.0';
            FieldClass = FlowFilter;
        }
        field(15;"Quest Filled";Boolean)
        {
            Description = 'SHR2.0';
            Editable = false;
            Enabled = false;
            FieldClass = Normal;
        }
        field(16;"Varying Preset Salary";Boolean)
        {
            Description = 'SHR2.0';
            Editable = false;
            FieldClass = Normal;
        }
        field(17;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            Description = 'PY2.0';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(18;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            Description = 'PY2.0';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(100;"Due Date";DateFormula)
        {
        }
        field(80213;"Copy of Identification Card";Boolean)
        {
            InitValue = true;
        }
        field(80214;"Copy of Judiciary Record";Boolean)
        {
            InitValue = true;
        }
        field(80215;"Copy of Employment Contract";Boolean)
        {
            InitValue = true;
        }
        field(80216;"Copy of Passport";Boolean)
        {
            InitValue = true;
        }
        field(80217;"Copy of Diplomas";Boolean)
        {
            InitValue = true;
        }
        field(80218;"Curriculum Vitae";Boolean)
        {
            InitValue = true;
        }
        field(80219;"Letters of Recommendations";Boolean)
        {
            InitValue = true;
        }
        field(80220;"Permission to practice prof.";Boolean)
        {
            InitValue = true;
        }
        field(80221;"Signed Copy of Company code";Boolean)
        {
            InitValue = true;
        }
    }

    keys
    {
        key(Key1;"Table Name","Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Description)
        {
        }
    }
}