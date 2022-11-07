page 98131 "EOS Provision Opening"
{
    PageType = List;
    SourceTable = "EOS Provision Opening";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
               field("Employee No.";"Employee No.")
               {                   ApplicationArea=All;
}
               field("EOS Tax Year";"EOS Tax Year")
               {                   ApplicationArea=All;
}
               field("EOS Amount";"EOS Amount")
               {                   ApplicationArea=All;
}
            }
        }
    }
}