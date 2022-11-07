table 98097 "Allowance Deduction Pay Elemt"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Pay Element Code";Code[20])
        {
            TableRelation = "Pay Element".Code;
        }
        field(2;"Pay Element Name";Text[40])
        {
            CalcFormula = Lookup("Pay Element".Description WHERE (Code=FIELD("Pay Element Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Calculation Type";Option)
        {
            OptionCaption = 'Fixed Amount,Basic Pay,Total Allowances';
            OptionMembers = "Fixed Amount","Basic Pay","Total Allowances";
        }
        field(4;"Monthly Amount";Decimal)
        {
            CaptionClass = 'Total Amount';
        }
        field(5;"Daily Amount";Decimal)
        {
        }
        field(6;"Maximum Monthly Amount";Decimal)
        {
        }
        field(7;"Document No.";Code[20])
        {
            TableRelation = "Allowance Deduction Template"."Code";
        }
        field(8;"School Level";Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=FILTER("School Level"));
        }
        field(9;"No Of Working Days";Decimal)
        {
            CalcFormula = Lookup("Allowance Deduction Template"."Average Days/Month" WHERE (Code=FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(10;"Affected by Working Days";Boolean)
        {
            CalcFormula = Lookup("Allowance Deduction Template"."Affected By Attendance" WHERE (Code=FIELD("Document No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Document No.","Pay Element Code","School Level")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AllowanceDeductionTemplate : Record "Allowance Deduction Template";
        ManualResetTotal : Boolean;

    procedure UpdateMonthlyAmount();
    begin
        CALCFIELDS("Affected by Working Days","No Of Working Days");
        if "No Of Working Days" > 0 then
          "Monthly Amount" := ROUND("Daily Amount" * "No Of Working Days",0.01,'=')
        else
          "Monthly Amount" := ROUND("Daily Amount" * 30,0.01,'=');
    end;

    procedure UpdateDailyAmount();
    begin
        CALCFIELDS("Affected by Working Days","No Of Working Days");
        if "No Of Working Days" > 0 then
          "Daily Amount" := ROUND("Monthly Amount" / "No Of Working Days",0.01,'=')
        else
          "Daily Amount" := ROUND("Monthly Amount" / 30,0.01,'=');
    end;

    procedure UpdateMaxMonthlyAmount();
    begin
        CALCFIELDS("Affected by Working Days","No Of Working Days");
        if "Affected by Working Days" then
          begin
            if "No Of Working Days" > 0 then
              "Maximum Monthly Amount" := ROUND("Daily Amount" * "No Of Working Days",0.01,'=')
            else
              "Maximum Monthly Amount" := ROUND("Daily Amount" * 30,0.01,'=');
          end
        else
          "Maximum Monthly Amount" := "Monthly Amount";
    end;
}

