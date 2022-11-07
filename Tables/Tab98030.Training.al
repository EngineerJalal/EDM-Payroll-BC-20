table 98030 "Training"
{
    fields
    {
        field(1;"No.";Code[10])
        {
            NotBlank = true;

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Training No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2;"Performance Code";Code[10])
        {
            TableRelation = "HR Performance"."No.";
        }
        field(3;"Start Date";Date)
        {
        }
        field(4;"End Date";Date)
        {

            trigger OnValidate();
            begin
                if "End Date" < "Start Date" then
                    ERROR ('End date must be greater than Start date');
            end;
        }
        field(5;"Start Time";Time)
        {
        }
        field(6;"End Time";Time)
        {

            trigger OnValidate();
            begin
                if "End Time" < "Start Time" then
                    ERROR ('End Time must be greater than Start Time');
            end;
        }
        field(7;"Is Completed";Boolean)
        {
        }
        field(8;"Is External";Boolean)
        {
        }
        field(9;Room;Text[30])
        {
        }
        field(10;Trainers;Text[100])
        {
        }
        field(11;"Company Name";Text[100])
        {
        }
        field(12;Objectives;Text[100])
        {
        }
        field(13;Evaluation;Text[100])
        {
        }
        field(14;Cost;Integer)
        {
        }
        field(15;"More Info";Text[100])
        {
        }
        field(16;"Evaluation Rate";Decimal)
        {
            CalcFormula = Average("Employee Journal Line"."Evaluation Rate" WHERE ("Training No."=FIELD("No."),"Document Status"=CONST(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"No. Series";Code[10])
        {
        }
        field(18;"Is Certificate Granted";Boolean)
        {
        }
        field(19;"Certificate Title";Text[30])
        {
        }
        field(20;"Max Attendees";Integer)
        {
        }
        field(21;Address;Text[50])
        {
        }
        field(22;"Table Name";Option)
        {
            OptionMembers = Training,Room;
        }
        field(23;"Nb. of Allowed Persons/Room";Integer)
        {
            CalcFormula = Lookup("HR Performance"."Nb. of Allowed Persons/Room" WHERE ("Table Name"=CONST("Room Type"),"No."=FIELD("Performance Code")));
            Description = 'SHR2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24;Description;Text[50])
        {
            Description = 'SHR2.0';
        }
        field(25;"Room Used By";Integer)
        {
            CalcFormula = Count("Employee Journal Line" WHERE (Type=CONST('BENEFIT'),"Room Type"=FIELD("Performance Code"),"Room No."=FIELD("No."),"Document Status"=CONST(Approved),"Exit Room"=CONST(false)));
            Description = 'SHR2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26;"No. of Employee";Integer)
        {
            CalcFormula = Count("Training Employee List" WHERE ("Training No."=FIELD("No."),"Employee No."=FILTER(<>'')));
            FieldClass = FlowField;
        }
        field(27;"Training Name";Text[250])
        {
        }
        field(28;"Audience Type";Option)
        {
            OptionCaption = 'Group of Employees,One Employee';
            OptionMembers = Group,Employee;
        }
        field(29;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(30;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."No." WHERE ("No."=FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(31;"In House";Boolean)
        {
        }
        field(32;"Number of Employees";Integer)
        {
            CalcFormula = Count("Training Employee List" WHERE ("Training No."=FIELD("No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.","Table Name","Performance Code")
        {
        }
        key(Key2;"Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        NoSeriesMgt : Codeunit NoSeriesManagement;
        HumanResSetup : Record "Human Resources Setup";
        Training : Record Training;

    procedure AssistEdit(OLDTraining : Record Training) : Boolean;
    begin
        with Training do begin
            Training := Rec;
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Training No.");
            if NoSeriesMgt.SelectSeries(HumanResSetup."Training No.",Training."No. Series","No. Series") then begin
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Training No.");
                NoSeriesMgt.SetSeries("No.");
                Rec := Training;
                exit(true);
            end;
        end;
    end;
}