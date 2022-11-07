table 98029 "HR Performance"
{

    fields
    {
        field(1;"No.";Code[10])
        {
            NotBlank = true;
        }
        field(2;Name;Text[100])
        {
        }
        field(3;"No. of Days";Integer)
        {
        }
        field(4;"Max Cost";Integer)
        {
        }
        field(5;Category;Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST(Performance));
        }
        field(6;Topic;Text[100])
        {
        }
        field(7;Audience;Text[100])
        {
        }
        field(8;Prerequisites;Text[100])
        {
        }
        field(9;"No. Series";Code[10])
        {
        }
        field(10;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(11;"No. of Trainings";Integer)
        {
            CalcFormula = Count(Training WHERE ("No."=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Starting Date";Date)
        {
        }
        field(13;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(14;"Table Name";Option)
        {
            Description = 'SHR2.0';
            OptionMembers = Performance,"Room Type";
        }
        field(15;"Nb. of Allowed Persons/Room";Integer)
        {
            Description = 'SHR2.0';
        }
        field(16;"Used Places";Integer)
        {
            CalcFormula = Count("Employee Journal Line" WHERE (Type=CONST('BENEFIT'),"Room Type"=FIELD("No."),"Document Status"=CONST(Approved),"Exit Room"=CONST(false)));
            Description = 'SHR2.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Nb. of Rooms";Integer)
        {
            CalcFormula = Count(Training WHERE ("Table Name"=CONST(Room),"No."=FIELD("No.")));
            Description = 'SHR2.0';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.","Table Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Table Name" = "Table Name"::Performance then begin
            Training.SETRANGE("Table Name",Training."Table Name"::Training);
            Training.SETRANGE("No.","No.");
            if Training.COUNT <> 0 then
                ERROR('Performance cannot be Deleted. Related Trainings Exist.');
        end;
        if "Table Name" = "Table Name"::"Room Type" then begin
            Training.SETRANGE("Table Name",Training."Table Name"::Room);
            Training.SETRANGE("No.","No.");
            if Training.COUNT <> 0 then
                ERROR('Room Type cannot be Deleted. Related Rooms Exist.');
        end;
    end;

    var
        Training : Record Training;
}