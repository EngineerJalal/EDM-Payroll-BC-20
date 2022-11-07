table 98074 "Probation Evaluation Sheet"
{
    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement = True;
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(3;"Evaluation Type";Code[20])
        {
            TableRelation = "HR Information".Code where ("Table Name" = CONST ("Evaluation Type"));
        }
        field(4;"Evaluation Description";Text[250])
        {
            FieldClass = FlowField; 
            CalcFormula = Lookup ("HR Information".Description WHERE (Code = FIELD ("Evaluation Type")));
            Editable = False;          
        }
        field(5;"Evaluation Date";Date)
        {

        }
        field(6;"Evaluation Time";Time)
        {

        }        
        field(7;"Evaluated By";Code[20])
        {
            TableRelation = Employee;
        }
        field(8;"Evaluation Remarks";Text[250])
        {

        }     
        field(9;"Evaluation Grade";Decimal)
        {

        }
        field(10;"Evaluation Status";Option)
        {
            OptionCaption = 'Pending,In progress,Done';
            OptionMembers = Pending,"In progress",Done;
        }

        field(11;"Next Evaluation Date";Date)
        {

        }
        field(12;"Next Evaluated By";Code[20])
        {
            TableRelation = Employee;
        } 
        field(13;"Employee Name";text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (Employee."Full Name" where ("No." = field ("Employee No.")));
            Editable = false;
        }
    }
}    