table 98013 "Employee Ikama"
{
    fields
    {
        field(1;"Employee No.";Code[20])
        {
        }
        field(2;"Ikama No.";Code[30])
        {
        }
        field(3;"Issue Place";Text[50])
        {
        }
        field(4;"Date From";Date)
        {
        }
        field(5;"Date To";Date)
        {
        }
        field(6;"Special Notes";Text[100])
        {
        }
        field(7;"Ikama Job Title";Text[50])
        {
            TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Job Title"));
        }
        field(8;"Ikama Company Responsible";Text[50])
        {
        }
        field(9;"Date From Higiri";Text[30])
        {
            Editable = false;
        }
        field(10;"Date To Higri";Text[30])
        {
            Editable = false;
        }
        field(11;"Liscence Type";Option)
        {
            OptionCaption = 'IKAMA,Driver License,Health Card';
            OptionMembers = IKAMA,"Driver License","Health Card";
        }
        field(50;Status;Option)
        {
            FieldClass = FlowField;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
            CalcFormula = Lookup(Employee.Status WHERE ("No."=FIELD("Employee No.")));
        }
        field(51;"Employee Exist";Boolean)
        {
            CalcFormula = Exist(Employee WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Employee No.","Ikama No.","Date From","Date To","Liscence Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeIkama.SETRANGE("Employee No.","Employee No.");
        EmployeeIkama.SETFILTER("Ikama No.",'<> %1',"Ikama No.");
        if EmployeeIkama.FIND('-') then
            if not CONFIRM('The old Ikama No. was different,Confirm new Ikama No.',true) then
                ERROR('Informations Not Saved');

        EmployeeIkama.SETFILTER("Ikama No.",'= %1',"Ikama No.");
        if EmployeeIkama.FIND('+') then begin
          "Date From" := CALCDATE('+1D',EmployeeIkama."Date To");
          "Date To" := CALCDATE('+1Y',"Date From");
        end 
        else begin
            if ("Date From" = 0D) then
                "Date From" := TODAY;
            if "Date To" = 0D then
                "Date To" := CALCDATE('+1Y',TODAY);
        end;
    end;

    var
        EmployeeIkama : Record "Employee Ikama";
}