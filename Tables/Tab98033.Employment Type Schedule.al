table 98033 "Employment Type Schedule"
{
    DrillDownPageID = "Employment Type Schedule";
    LookupPageID = "Employment Type Schedule";

    fields
    {
        field(1;"Employment Type Code";Code[20])
        {
            TableRelation = "Employment Type";
        }
        field(2;"Day of the Week";Option)
        {
            OptionMembers = Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday;
        }
        field(3;"Starting Time";Time)
        {
            trigger OnValidate();
            begin
                VALIDATE("No. of Hours");
            end;
        }
        field(4;"Ending Time";Time)
        {
            trigger OnValidate();
            begin
                VALIDATE("No. of Hours");
            end;
        }
        field(5;"No. of Hours";Decimal)
        {
            Editable = false;
            trigger OnValidate();
            begin
                IF ("Starting Time" <> 0T) AND ("Ending Time" <> 0T) THEN
                    "No. of Hours" := HRFunctions.GetHoursFrom2Times("Starting Time","Ending Time");
            end;
        }
        field(6;"Table Name";Option)
        {
            OptionMembers = StandardSched,WorkShiftSched;
        }
        field(7;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(8;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(9;"Working Shift Code";Code[10])
        {
        }
        field(10;Description;Text[30])
        {
        }
        field(11;"Project No.";Code[20])
        {
        }
        field(60000;"Shift Code";Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";

            trigger OnValidate();
            begin
                "Starting Time" := 000000T;
                "Ending Time" := 000000T;
                if "Shift Code" <> '' then begin
                    DailyShiftsTbt.SETRANGE(DailyShiftsTbt."Shift Code" ,"Shift Code");
                    if DailyShiftsTbt.FINDFIRST then begin
                        "Starting Time":= DailyShiftsTbt."From Time";
                        "Ending Time" := DailyShiftsTbt."To Time";
                    end;
                end;
                VALIDATE("No. of Hours");
            end;
        }
    }

    keys
    {
        key(Key1;"Employment Type Code","Day of the Week","Starting Time","Table Name","Working Shift Code","Global Dimension 1 Code","Global Dimension 2 Code")
        {
        }
        key(Key2;"No. of Hours")
        {
            SumIndexFields = "No. of Hours";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        ValidateEntry;
    end;

    trigger OnModify();
    begin
        ValidateEntry;
    end;

    trigger OnRename();
    begin
        ValidateEntry;
    end;

    var
        HRFunctions : Codeunit "Human Resource Functions";
        DailyShiftsTbt : Record "Daily Shifts";

    procedure ValidateEntry();
    var
        BaseCalendarLine : Record "Base Calendar Change N";
        HRSetup : Record "Human Resources Setup";
    begin
        TESTFIELD("Starting Time");
        if "Table Name" = "Table Name"::WorkShiftSched then begin
            HRSetup.GET;
            case HRSetup.Location of
                HRSetup.Location::"Global Dimension 1":
                    TESTFIELD("Global Dimension 1 Code");
                HRSetup.Location::"Global Dimension 2":
                    TESTFIELD("Global Dimension 2 Code");
                HRSetup.Location::Both: begin
                    TESTFIELD("Global Dimension 1 Code");
                    TESTFIELD("Global Dimension 2 Code");
                end;
            end; 
        end; 
    end;
}