table 98043 "Base Calendar Change N"
{
    CaptionML = ENU='Base Calendar Change',
                ESM='Cambio calendario base',
                FRC='Modific. calendrier principal',
                ENC='Base Calendar Change';
    DataCaptionFields = "Base Calendar Code";

    fields
    {
        field(1;"Base Calendar Code";Code[10])
        {
            CaptionML = ENU='Base Calendar Code',
                        ESM='Código calendario base',
                        FRC='Code calendrier principal',
                        ENC='Base Calendar Code';
            Editable = false;
        }
        field(2;"Recurring System";Option)
        {
            CaptionML = ENU='Recurring System',
                        ESM='Sistema periódico',
                        FRC='Système récurrent',
                        ENC='Recurring System';
            OptionCaptionML = ENU=' ,Annual Recurring,Weekly Recurring',
                              ESM=' ,Periódico anual,Periódico semanal',
                              FRC=' ,Abonnement annuel,Abonnement hebdomadaire',
                              ENC=' ,Annual Recurring,Weekly Recurring';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";

            trigger OnValidate();
            begin
                if "Recurring System" <> xRec."Recurring System" then
                    case "Recurring System" of
                        "Recurring System"::"Annual Recurring":
                            Day := Day::" ";
                        "Recurring System"::"Weekly Recurring":
                            Date := 0D;
                  end;
            end;
        }
        field(3;Date;Date)
        {
            CaptionML = ENU='Date',
                        ESM='Fecha',
                        FRC='Date',
                        ENC='Date';

            trigger OnValidate();
            begin
                if ("Recurring System" = "Recurring System"::" ") or
                   ("Recurring System" = "Recurring System"::"Annual Recurring")
                then
                    TESTFIELD(Date)
                else
                    TESTFIELD(Date,0D);
                UpdateDayName;
            end;
        }
        field(4;Day;Option)
        {
            CaptionML = ENU='Day',
                        ESM='Día',
                        FRC='Jour',
                        ENC='Day';
            OptionCaptionML = ENU=' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday',
                              ESM=' ,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo',
                              FRC=' ,Lundi,Mardi,Mercredi,Jeudi,Vendredi,Samedi,Dimanche',
                              ENC=' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;

            trigger OnValidate();
            begin
                if "Recurring System" = "Recurring System"::"Weekly Recurring" then
                  TESTFIELD(Day);
                UpdateDayName;
            end;
        }
        field(5;Description;Text[30])
        {
            CaptionML = ENU='Description',
                        ESM='Descripción',
                        FRC='Description',
                        ENC='Description';
        }
        field(6;Nonworking;Boolean)
        {
            CaptionML = ENU='Nonworking',
                        ESM='No laborables',
                        FRC='Jour chômé',
                        ENC='Nonworking';
            InitValue = true;
        }
        field(80000;"Working Shift Code";Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Employment Type Schedule"."Working Shift Code" WHERE ("Table Name"=CONST(WorkShiftSched));

            trigger OnValidate();
            begin
                BaseCal.GET("Base Calendar Code");
                BaseCal.TESTFIELD("Shift Group Code");
                
                HRSetup.GET;
                case HRSetup.Location of
                    HRSetup.Location::"Global Dimension 1":
                        BaseCal.TESTFIELD("Global Dimension 1 Code");
                    HRSetup.Location::"Global Dimension 2":
                        BaseCal.TESTFIELD("Global Dimension 2 Code");
                    HRSetup.Location::Both: begin
                        BaseCal.TESTFIELD("Global Dimension 1 Code");
                        BaseCal.TESTFIELD("Global Dimension 2 Code");
                    end;
                end;
            end;
        }
        field(80001;"Public Day";Boolean)
        {
            Description = 'SHR2.0';

            trigger OnValidate();
            begin
                if "Public Day" then
                    Nonworking := true;
                VALIDATE(Nonworking);
            end;
        }
        field(80002;"Exist Additions";Boolean)
        {
            CalcFormula = Exist("Base Calendar Additions" WHERE ("Base Calendar Code"=FIELD("Base Calendar Code"),
                                                                 "Recurring System"=FIELD("Recurring System"),
                                                                 Date=FIELD(Date),
                                                                 Day=FIELD(Day),
                                                                 "Working Shift Code"=FIELD("Working Shift Code")));
            Description = 'MEG01.0';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Base Calendar Code","Recurring System",Date,Day)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        CheckEntryLine;
    end;

    trigger OnModify();
    begin
        CheckEntryLine;
    end;

    trigger OnRename();
    begin
        CheckEntryLine;
    end;

    var
        BaseCal : Record "Base Calendar N";
        HRSetup : Record "Human Resources Setup";

    local procedure UpdateDayName();
    var
        DateTable : Record Date;
    begin
        if (Date > 0D) and
           ("Recurring System" = "Recurring System"::"Annual Recurring")
        then
            Day := Day::" "
        else begin
            DateTable.SETRANGE("Period Type",DateTable."Period Type"::Date);
            DateTable.SETRANGE("Period Start",Date);
            if DateTable.FINDFIRST then
                Day := DateTable."Period No.";
        end;
        if (Date = 0D) and (Day = Day::" ") then begin
            Day := xRec.Day;
            Date := xRec.Date;
        end;
        if "Recurring System" = "Recurring System"::"Annual Recurring" then
            TESTFIELD(Day,Day::" ");
    end;

    local procedure CheckEntryLine();
    begin
        case "Recurring System" of
            "Recurring System"::" ":
            begin
                TESTFIELD(Date);
                TESTFIELD(Day);
            end;
          "Recurring System"::"Annual Recurring":
            begin
                TESTFIELD(Date);
                TESTFIELD(Day,Day::" ");
            end;
          "Recurring System"::"Weekly Recurring":
            begin
                TESTFIELD(Date,0D);
                TESTFIELD(Day);
            end;
        end;
    end;
}