table 98001 "Gratuity Band"
{
    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Contract Type";Option )
        {
            OptionMembers = Limited,Unlimited;
        }
        field(3;"From Unit";Decimal)
        {
        }
        field(4;"To Unit";Decimal)
        {
        }
        field(5;"Days Basic Salary per year";Integer)
        {
        }
    }
}