table 98058 "Payroll Report Selection"
{
    // version PY1.0,EDM.HRPY2


    fields
    {
        field(1;Usage;Option)
        {
            OptionMembers = Payslips,CashDenom,BankPay;
        }
        field(2;Sequence;Code[10])
        {
            Numeric = true;
        }
        field(3;"Report ID";Integer)
        {
           // TableRelation = Object.ID WHERE (Type=CONST(Report));

            trigger OnValidate();
            begin
                CALCFIELDS("Report Name");
            end;
        }
        field(4;"Report Name";Text[30])
        {   
            //CalcFormula = Lookup(Object.Name WHERE (Type=CONST(Report),
                                                  //  ID=FIELD("Report ID")));
            Editable = false;
            //FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;Usage,Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if Sequence = '' then begin
          ReportSelection2.SETRANGE(Usage,Usage);
          if ReportSelection2.FIND('+') and (ReportSelection2.Sequence <> '') then
            Sequence := INCSTR(ReportSelection2.Sequence)
          else
            Sequence := '1';
        end;
    end;

    var
        ReportSelection2 : Record "Payroll Report Selection";
}

