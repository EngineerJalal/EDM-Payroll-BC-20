table 98095 "Employee Attendance - Web"
{
    // version EDM.HRPY1


    fields
    {
        field(1;EmpNo;Code[20])
        {
            CaptionClass = 'Employee No.';
            Editable = true;
            TableRelation = Employee."No.";
        }
        field(2;"Attend Date";Date)
        {
            CaptionClass = 'Attendance Date';
        }
        field(3;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(4;"Attend Hrs";Decimal)
        {
            CaptionClass = 'Attend Hrs - Web';
            Editable = true;
        }
        field(5;Remarks;Text[100])
        {
            Editable = true;
        }
        field(6;"Is Imported";Boolean)
        {
        }
        field(7;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD(EmpNo)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Manager No";Code[20])
        {
            CalcFormula = Lookup(Employee."Manager No." WHERE ("No."=FIELD(EmpNo)));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Employee."No.";
        }
        field(9;"Reporting Manager No";Code[20])
        {
            CalcFormula = Lookup(Employee."Report Manager No." WHERE ("No."=FIELD(EmpNo)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Employee Dimension 1";Code[20])
        {
            CalcFormula = Lookup(Employee."Global Dimension 1 Code" WHERE ("No."=FIELD(EmpNo)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Employee Dimension 2";Code[20])
        {
            CalcFormula = Lookup(Employee."Global Dimension 2 Code" WHERE ("No."=FIELD(EmpNo)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;Project;Code[20])
        {
            CalcFormula = Max("Default Dimension"."Dimension Value Code" WHERE ("Dimension Code"=CONST('PROJECT')));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Dimension Value"."Code" WHERE ("Dimension Code"=CONST('PROJECT'));
        }
        field(13;Branch;Code[20])
        {
            CalcFormula = Max("Default Dimension"."Dimension Value Code" WHERE ("Dimension Code"=CONST('BRANCH')));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Dimension Value"."Code" WHERE ("Dimension Code"=CONST('BRANCH'));
        }
        field(14;Department;Code[20])
        {
            CalcFormula = Max("Default Dimension"."Dimension Value Code" WHERE ("Dimension Code"=CONST('DEPARTMENT')));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Dimension Value"."Code" WHERE ("Dimension Code"=CONST('DEPARTMENT'));
        }
        field(15;"Approved Hours";Decimal)
        {
        }
        field(16;"Approval Comments";Text[100])
        {
        }
        field(17;"Is Approved";Boolean)
        {

            trigger OnValidate();
            begin
                if "Is Approved" = true then
                  begin
                    "Approved Hours" := "Attend Hrs";
                  end
                else
                  begin
                    "Approved Hours" := 0;
                    "Approval Comments" := '';
                  end;
            end;
        }
        field(18;"Required Hours";Decimal)
        {
            CalcFormula = Sum("Employee Absence"."Required Hrs" WHERE ("Employee No."=FIELD(EmpNo),
                                                                       "From Date"=FIELD("Attend Date")));
            FieldClass = FlowField;
        }
        field(19;"Modified By";Code[50])
        {
            Editable = false;
        }
        field(20;"Modified Date";Date)
        {
            Editable = false;
        }
        field(21;"Modified Time";Time)
        {
        }
    }

    keys
    {
        key(Key1;EmpNo,"Attend Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "Modified By" := USERID;
        "Modified Date" := WORKDATE;
        "Modified Time" := SYSTEM.TIME;
    end;

    trigger OnModify();
    begin
        if "Is Imported" = true then
          ERROR ('Record is imported. Modification not allowed');

        "Modified By" := USERID;
        "Modified Date" := WORKDATE;
        "Modified Time" := SYSTEM.TIME;
    end;
}

