page 98008 "Employee Loan SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = ListPart;
    Permissions = TableData "Employee Loan Line"=rimd;
    SourceTable = "Employee Loan Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Loan No.";Rec."Loan No.")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Payment Number";Rec."Payment Number")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Payment Amount";Rec."Payment Amount")
                {
                    ApplicationArea=All;
                    trigger OnValidate();
                    begin
                        //IF Completed THEN
                        //  ERROR(Text001);

                        //Added in order to have validations - 03.08.2016 : AIM +
                        if Rec.Completed = true then

                          ERROR ('Modification not allowed');


                        if Rec."Payment Number" <= 0 then
                          begin
                            LoanLineTbt.SETRANGE(LoanLineTbt."Loan No.",Rec."Loan No.");
                            if LoanLineTbt.FINDLAST then
                              Rec."Payment Number" := LoanLineTbt."Payment Number" + 1
                            else
                               Rec."Payment Number" := 1;
                          end;
                        if Rec."Payment Number" <= 0 then
                          ERROR ('Enter Payment Number')
                        else
                           begin
                             EmpLoanTbt.SETRANGE(EmpLoanTbt."Loan No.",Rec."Loan No.");
                             if EmpLoanTbt.FINDFIRST then
                               begin
                                  if Rec."Payment Number" > EmpLoanTbt."No. of Payments" then
                                    ERROR ('Invalid Payment No. It exceeds the total number of payments ( %1 ) !!!' , EmpLoanTbt."No. of Payments");
                               end;
                           end;
                        //Added in order to have validations - 03.08.2016 : AIM -
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2+
                        PayParam.GET;
                        Rec."Amount (ACY)" := Rec."Payment Amount" / PayParam."ACY Currency Rate";
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2-

                        CurrPage.UPDATE;
                    end;
                }
                field("Payment Amount (ACY)";Rec."Amount (ACY)")
                {
                    ApplicationArea=All;
                    trigger OnValidate();
                    begin
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2+
                        PayParam.GET;
                        Rec."Payment Amount" := Rec."Amount (ACY)" * PayParam."ACY Currency Rate";
                        CurrPage.UPDATE;
                        // Added in order to Show Amount in ACY - 24.02.2017 : A2-
                    end;
                }
                field("Payment Date";Rec."Payment Date")
                {
                    ApplicationArea=All;
                    trigger OnValidate();
                    begin
                        //CurrPage.UPDATE;
                        //Added in order to have validations - 03.08.2016 : AIM +
                        if Rec.Completed = true then
                          ERROR ('Modification not allowed');
                        //Added in order to have validations - 03.08.2016 : AIM -
                        CurrPage.UPDATE;
                    end;
                }
                field(Completed;Rec.Completed)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Set as Completed";Rec."Set as Completed")
                {
                    ApplicationArea=All;
                    trigger OnValidate();
                    begin
                        //Added in order to allow modifying the 'Completed' flag - 02.08.2016 : AIM +

                        if Rec."Payment Date" = 0D then
                          ERROR ('Enter Payment Date!!');

                        LoanPayMonth := DATE2DMY(Rec."Payment Date",2);
                        LoanPayYear := DATE2DMY(Rec."Payment Date",3);
                        PayDetailLineTBT.SETRANGE(PayDetailLineTBT."Loan No.",Rec."Loan No.");
                        PayDetailLineTBT.SETRANGE(PayDetailLineTBT."Tax Year",LoanPayYear);
                        PayDetailLineTBT.SETRANGE(PayDetailLineTBT.Period,LoanPayMonth);
                        PayDetailLineTBT.SETRANGE(PayDetailLineTBT."Employee No.",Rec."Employee No.");
                        if PayDetailLineTBT.FINDFIRST then
                          begin
                                 ERROR('Modification is not allowed');
                          end
                        else
                          Rec.Completed := Rec."Set as Completed";
                        CurrPage.UPDATE;
                        //Added in order to allow modifying the 'Completed' flag - 02.08.2016 : AIM -
                    end;
                }
                field("Modified By";Rec."Modified By")
                {
                    ApplicationArea=All;
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Modification Date";Rec."Modification Date")
                {
                    ApplicationArea=All;
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        Text001 : Label 'You cann''t modify paid loan';
        LoanLineTbt : Record "Employee Loan Line";
        EmpLoanTbt : Record "Employee Loan";
        PayDetailLineTBT : Record "Pay Detail Line";
        LoanPayYear : Integer;
        LoanPayMonth : Integer;
        PayParam : Record "Payroll Parameter";

        trigger OnNewRecord(BelowxRec : Boolean);
        var
            EmployeeLoanLine : Record "Employee Loan Line";
            LastNo : Integer;
        begin
            EmployeeLoanLine.Reset;
            EmployeeLoanLine.SetCurrentKey(ID);
            if EmployeeLoanLine.FindLast then
                LastNo := EmployeeLoanLine.ID + 1
            else
                LastNo := 1;

            Rec.ID := LastNo;
        end;          
}