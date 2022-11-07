table 98048 "Specific Pay Element"
{
    DataCaptionFields = "Internal Pay Element ID";
    fields
    {
        field(1;"Pay Element Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;"Pay Element Name";Text[250])
        {
        }
        field(3;"Internal Pay Element ID";Code[10])
        {
            TableRelation = "Pay Element";
        }
        field(4;"Employee Category Code";Code[10])
        {
            TableRelation = "Employee Categories";

            trigger OnValidate();
            begin
                RecalSpePayWarning;
            end;
        }
        field(5;Amount;Decimal)
        {
            trigger OnValidate();
            begin
                "% Basic Pay" := 0;
                RecalSpePayWarning;
            end;
        }
        field(6;"Wife Entitlement";Decimal)
        {

            trigger OnValidate();
            begin
                RecalSpePayWarning;
            end;
        }
        field(7;"Per Children Entitlement";Decimal)
        {

            trigger OnValidate();
            begin
                RecalSpePayWarning;
            end;
        }
        field(8;"Line No.";Integer)
        {
        }
        field(9;"Employee Level Dependent";Boolean)
        {
            Enabled = false;
        }
        field(10;"Amount (ACY)";Decimal)
        {

            trigger OnValidate();
            begin
                RecalSpePayWarning;
            end;
        }
        field(11;"Maturity Period";DateFormula)
        {
            Description = 'PY2.0';
        }
        field(12;"Affected By Presence";Boolean)
        {
            Description = 'PY2.0';
        }
        field(13;"Pay Unit";Option)
        {
            Description = 'PY3.0';
            OptionCaption = 'Monthly,Daily,Hourly';
            OptionMembers = Monthly,Daily,Hourly;
        }
        field(14;Splited;Boolean)
        {
            Description = 'PY3.0';
        }
        field(15;"% Basic Pay";Decimal)
        {
            Description = 'MB.2602';

            trigger OnValidate();
            begin
                Amount := 0;
                RecalSpePayWarning;
            end;
        }
        field(16;"Per Diem Amount";Decimal)
        {
        }
        field(17;"Per Diem Amount (ACY)";Decimal)
        {
        }
        field(18;"Per Diem %";Decimal)
        {
        }
        field(19;"Travel Allowance %";Decimal)
        {
        }
        field(20;"Travel Allowance Amount";Decimal)
        {
        }
        field(21;"Travel Allowance amount (ACY)";Decimal)
        {
        }
        field(90001;"Water Compensation";Boolean)
        {
            Description = 'EDM.IT';
        }
        field(90002;"Cost of Living";Boolean)
        {
            Description = 'EDM.IT';
        }
    }

    keys
    {
        key(Key1;"Pay Element Code","Internal Pay Element ID","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        RecalSpePayWarning;
    end;

    var
        PayDetailLine : Record "Pay Detail Line";
    procedure RecalSpePayWarning();
    begin
        PayDetailLine.RESET;
        PayDetailLine.SETCURRENTKEY(Open,Type,"Pay Element Code");
        PayDetailLine.SETRANGE(Open,true);
        PayDetailLine.SETRANGE("Pay Element Code","Internal Pay Element ID");
        if PayDetailLine.FIND('-') then begin
            if not CONFIRM('ReCalculation Function on Pay Details is Required . Do you want to Continue ?',true) then
                ERROR('Operation Aborted !');
        end;
    end;
}