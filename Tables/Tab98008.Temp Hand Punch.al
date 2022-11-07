table 98008 "Temp Hand Punch"
{
    fields
    {
        field(1;"Attendnace No.";Integer)
        {
        }
        field(2;"Employee Name";Text[100])
        {
        }
        field(3;"Transaction Date";DateTime)
        {
        }
        field(4;"Transaction Time";DateTime)
        {
        }
        field(5;"Action Type";Code[20])
        {
        }
        field(6;ID;Integer)
        {
        }
        field(7;Status;Option)
        {
            FieldClass = FlowField;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
            CalcFormula = Min(Employee.Status WHERE ("Attendance No."=FIELD("Attendnace No.")));
            Caption = 'Status';
        }
        field(8;"Transaction Time2";Time)
        {
        }
        field(9;"Job Time IN";Time)
        {
            Description = 'EDM.EmpAttDim';
        }
        field(10;"Job Time OUT";Time)
        {
            Description = 'EDM.EmpAttDim';
        }
        field(11;"Job Number Of Hours";Decimal)
        {
            Description = 'EDM.EmpAttDim';
        }
        field(12;"Job No.";Code[20])
        {
            Description = 'EDM.EmpAttDim';
        }
        field(13;"Job Task No.";Code[20])
        {
            Description = 'EDM.EmpAttDim';
        }
        field(14;"Batching Plant";Code[20])
        {
            Description = 'EDM.EmpAttDim';
        }
        field(15;"Trans Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Attendnace No.","Employee Name","Transaction Date","Transaction Time","Action Type","Transaction Time2","Job Time IN","Job Time OUT","Job Number Of Hours","Job No.","Job Task No.","Batching Plant")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert();
    begin
        "Trans Date" := DT2DATE("Transaction Date");
    end;
}