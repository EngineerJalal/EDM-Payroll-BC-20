table 98002 "EOS Provision Opening"
{
    fields
    {
        field(1;"Line No";Integer)
        {
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(3;"EOS Tax Year";Integer)
        {
        }
        field(4;"EOS Date";Date)
        {
        }
        field(5;"EOS Amount";Decimal)
        {
        }
    }
    trigger OnInsert();
    var
        EOSProvision : Record "EOS Provision Opening";
        LastNo : Integer;
    begin
        IF EOSProvision.FINDLAST then
            LastNo := EOSProvision."Line No" + 1
        else
            LastNo := 1;

        "Line No" := LastNo;
    end;
}