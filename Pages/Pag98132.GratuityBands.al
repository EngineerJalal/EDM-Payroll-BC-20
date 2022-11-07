page 98132 "Gratuity Bands"
{
    PageType = List;
    SourceTable = "Gratuity Band";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
               field("Contract Type";"Contract Type")
               {                   ApplicationArea=All;
}
               field("From Unit";"From Unit")
               {                   ApplicationArea=All;
}
               field("To Unit";"To Unit")
               {                   ApplicationArea=All;
}
               field("Days Basic Salary per year";"Days Basic Salary per year")
               {                   ApplicationArea=All;
}
            }
        }
    }
}