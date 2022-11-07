tableextension 98003 "ExtGenJournalLine" extends "Gen. Journal Line" 
{
    fields
    {
        field(95004;Inserted2;Boolean)
        {
        }
    }
    procedure CloseJournal2(AskForConfirmation : Boolean)
    var
        GLSetup: Record "General Ledger Setup";
        GenJnlRec: Record "Gen. Journal Line";
        AmountLCY: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        CloseJournalConf: TextConst ENU = 'Amount exists in Journal line,Are you sure you want to override it?';
    BEGIN           
        IF AskForConfirmation THEN 
            IF NOT CONFIRM(CloseJournalConf,FALSE) THEN
                EXIT;
                
        GLSetup.GET;
        GenJnlRec.RESET;
        GenJnlRec.SETRANGE("Journal Template Name","Journal Template Name");
        GenJnlRec.SETRANGE("Journal Batch Name","Journal Batch Name");
        GenJnlRec.SETRANGE("Document No.","Document No.");
        GenJnlRec.SETFILTER("Bal. Account No.",'=%1',''); 
        GenJnlRec.SETFILTER("Line No.",'<>%1',"Line No.");
        GenJnlRec.CALCSUMS("Amount (LCY)");
        AmountLCY := -GenJnlRec."Amount (LCY)";
        VALIDATE(Amount,CurrExchRate.ExchangeAmtFCYToFCY("Posting Date",'',"Currency Code",AmountLCY));
        VALIDATE("Amount (LCY)",AmountLCY);
        MODIFY(TRUE);
    END;
}

