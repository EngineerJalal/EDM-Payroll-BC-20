tableextension 98005 "ExtGeneralLedgerSetup" extends "General Ledger Setup" 
{

    fields
    {
        field(96025;"Employee Dimension Index";Option)
        {
            Description = 'EDM.Employee Statement Report; used to indicate dimension index where to found';
            OptionMembers = "1","2","3","4","5","6","7","8";
        }
    }
}

