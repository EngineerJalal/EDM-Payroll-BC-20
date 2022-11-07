table 98081 "Base Calendar N"
{
    CaptionML = ENU='Base Calendar',
                ESM='Calendario base',
                FRC='Calendrier principal',
                ENC='Base Calendar';
    DataCaptionFields = "Code",Name;
    LookupPageID = "Base Calendar List N";

    fields
    {
        field(1;"Code";Code[10])
        {
            CaptionML = ENU='Code',
                        ESM='Código',
                        FRC='Code  ',
                        ENC='Code';
            NotBlank = true;
        }
        field(2;Name;Text[30])
        {
            CaptionML = ENU='Name',
                        ESM='Nombre',
                        FRC='Nom',
                        ENC='Name';
        }
        field(3;"Customized Changes Exist";Boolean)
        {
            CaptionML = ENU='Customized Changes Exist',
                        ESM='Existen cambios personaliz.',
                        FRC='Modifications personnalisées',
                        ENC='Customized Changes Exist';
            Editable = false;
            FieldClass = Normal;
        }
        field(80000;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'SHR2.0';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(1));
        }
        field(80001;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Description = 'SHR2.0';
            TableRelation = "Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
        }
        field(80002;"Shift Group Code";Code[50])
        {
            Description = 'SHR2.0';
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST(ShiftGp));

            trigger OnValidate();
            begin
                EmployType.RESET;
                EmployType.SETRANGE("Base Calendar Code",Code);
                if EmployType.FIND('-') then
                repeat
                    EmployType.CALCFIELDS(EmployType."Standard Schedule");
                    if EmployType."Standard Schedule" then
                        ERROR('You Cannot Specify the Shift Group Code on an Employment type Calendar having a Standard Schedule Type.');
                until EmployType.NEXT = 0;
            end;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        BaseCalendarLine.RESET;
        BaseCalendarLine.SETRANGE("Base Calendar Code",Code);
        BaseCalendarLine.DELETEALL;
    end;

    var
        BaseCalendarLine : Record "Base Calendar Change N";
        Text001 : TextConst ENU='You cannot delete this record. Customized calendar changes exist for calendar code=<%1>.',ESM='No puede borrar este regist. Hay cambios en cód. calend. de calend. personaliz.=<%1>.',FRC='Vous ne pouvez pas supprimer cet enregistrement. Il existe des modifications sur le calendrier personnalisé =<%1>.',ENC='You cannot delete this record. Customized calendar changes exist for calendar code=<%1>.';
        EmployType : Record "Employment Type";
}