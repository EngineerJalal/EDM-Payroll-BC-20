table 98026 "Employee Medical Details"
{

    fields
    {
        field(1;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(2;"Medical Allowance Group";Code[10])
        {
        }
        field(3;"Medical Allowance Sub Group";Code[10])
        {
            NotBlank = true;
            TableRelation = "Medical Allowance Sub Groups"."Code" WHERE ("Medical Allowance Group"=FIELD("Medical Allowance Group"));

            trigger OnValidate();
            begin
                MedicalAllowSubGroup.GET("Medical Allowance Group","Medical Allowance Sub Group");
                Description := MedicalAllowSubGroup.Description;
            end;
        }
        field(4;Description;Text[30])
        {
        }
        field(5;"Transaction Date";Date)
        {
        }
        field(6;"Exam Date";Date)
        {
        }
        field(7;"Entry No.";Integer)
        {
        }
        field(8;"Line No.";Integer)
        {
        }
        field(9;Information;Text[200])
        {
        }
        field(10;Result;Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Entry No.","Transaction Date","Medical Allowance Group","Medical Allowance Sub Group")
        {
        }
    }

    fieldgroups
    {
    }

    var
        MedicalAllowSubGroup : Record "Medical Allowance Sub Groups";
}