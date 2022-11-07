table 98069 "Scheduling System Line"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Document No";Code[20])
        {
        }
        field(2;"Line No";Integer)
        {
            AutoIncrement = true;
        }
        field(3;"Employee No";Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate();
            begin
                SetEmployeeDimension();
            end;
        }
        field(4;"Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE ("No."=FIELD("Employee No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Week Day";Option)
        {
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(6;"From Time";Time)
        {

            trigger OnValidate();
            begin
                if ("From Time" <> 000000T) and ("To Time" <> 000000T) then
                  VALIDATE(Hours,("To Time" - "From Time") / 3600000);
            end;
        }
        field(7;"To Time";Time)
        {

            trigger OnValidate();
            begin
                if ("From Time" <> 000000T) and ("To Time" <> 000000T) then
                  VALIDATE(Hours,("To Time" - "From Time") / 3600000);
            end;
        }
        field(8;Hours;Decimal)
        {
        }
        field(9;"Global Dimension 1";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(10;"Global Dimension 2";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(11;"Shortcut Dimension 3";Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(3));
        }
        field(12;"Shortcut Dimension 4";Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(4));
        }
        field(13;"Shortcut Dimension 5";Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(5));
        }
        field(14;"Shortcut Dimension 6";Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(6));
        }
        field(15;"Shortcut Dimension 7";Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(7));
        }
        field(16;"Shortcut Dimension 8";Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(8));
        }
        field(17;"Schedule Type";Option)
        {
            OptionMembers = Teaching;
        }
    }

    keys
    {
        key(Key1;"Document No","Line No","Employee No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayFunction : Codeunit "Payroll Functions";

    procedure SetEmployeeDimension();
    var
        DimNo : Integer;
    begin
        DimNo := PayFunction.GetShortcutDimensionNoFromName('EMPLOYEE');
        case DimNo of
          1:
            "Global Dimension 1" := "Employee No";
          2:
            "Global Dimension 2" := "Employee No";
          3:
            "Shortcut Dimension 3" := "Employee No";
          4:
            "Shortcut Dimension 4" := "Employee No";
          5:
            "Shortcut Dimension 5" := "Employee No";
          6:
            "Shortcut Dimension 6" := "Employee No";
          7:
            "Shortcut Dimension 7" := "Employee No";
          8:
            "Shortcut Dimension 8" := "Employee No";
        end;
    end;
}

