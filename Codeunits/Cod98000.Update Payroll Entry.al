codeunit 98000 "Update Payroll Entry"
{
    // version EDM.HRPY1


    trigger OnRun();
    begin
        GLEntry.SETRANGE(GLEntry."Posting Date",CALCDATE('31/01/2016'));
    end;

    var
        GLEntry : Record "G/L Entry";
}

