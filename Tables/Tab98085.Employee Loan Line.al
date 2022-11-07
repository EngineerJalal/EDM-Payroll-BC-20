table 98085 "Employee Loan Line"
{
    // version EDM.HRPY1

    Permissions = TableData "Employee Loan Line"=rimd;

    fields
    {
        field(1;"Employee No.";Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(2;"Loan No.";Code[10])
        {
            Editable = false;
            NotBlank = true;
        }
        field(3;"Payment Number";Integer)
        {
            Editable = false;
        }
        field(4;"Payment Amount";Decimal)
        {
            Editable = true;

            trigger OnValidate();
            var
                ExceedSalary : Boolean;
                Salary : Decimal;
                Curr : Text[5];
            begin
                if Completed then
                  ERROR(Text0001);
            end;
        }
        field(5;Completed;Boolean)
        {
            Editable = true;
        }
        field(6;ID;Integer)
        {
            AutoIncrement = false;
            Editable = true;
        }
        field(7;"Payment Date";Date)
        {

            trigger OnValidate();
            begin
                IF Completed THEN
                ERROR(Text0001)
                ELSE BEGIN
                    P_Date:="Payment Date";
                    EmpLoanLine.SETRANGE("Loan No.","Loan No.");
                    EmpLoanLine.SETRANGE("Employee No.","Employee No.");
                    EmpLoanLine.SETRANGE(Completed,FALSE);
                    IF EmpLoanLine.FINDFIRST THEN
                    REPEAT
                        IF EmpLoanLine."Payment Number">="Payment Number" THEN BEGIN
                        EmpLoanLine."Payment Date":= P_Date;
                        P_Date:=CALCDATE('+1M',P_Date);
                        EmpLoanLine.MODIFY;
                        END;
                    UNTIL EmpLoanLine.NEXT=0;
                END;
            end;
        }
        field(8;DOL;Date)
        {
            CalcFormula = Lookup("Employee Loan"."Date of Loan" WHERE ("Employee No."=FIELD("Employee No."),
                                                                       "Loan No."=FIELD("Loan No.")));
            FieldClass = FlowField;
        }
        field(9;"Set as Completed";Boolean)
        {
        }
        field(10;"Modified By";Code[50])
        {
            Editable = false;
        }
        field(11;"Modification Date";Date)
        {
            Editable = false;
        }
        field(12;"Amount (ACY)";Decimal)
        {
            Description = 'Added for Mega Prefab in Order to show Amount in ACY only';
        }
        field(13;"Change Status";Option)
        {
            Description = 'EDM.LoanApprovalSystem';
            FieldClass = FlowField;
            OptionMembers = Approved,Pending,Rejected,"Not Started";
            CalcFormula = Lookup("Employee Loan"."Change Status" WHERE ("Employee No."=FIELD("Employee No."),"Loan No."=FIELD("Loan No.")));
        }
    }

    keys
    {
        key(Key1;ID,"Employee No.","Loan No.")
        {
        }
        key(Key2;"Employee No.","Loan No.",Completed)
        {
            SumIndexFields = "Payment Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        "Modified By":=USERID;
        "Modification Date":=WORKDATE;
    end;

    var
        PayEmp : Record Employee;
        PayDetailHeader : Record "Pay Detail Header";
        EmpLoan : Record "Employee Loan";
        PayE : Record "Pay Element";
        Employee : Record Employee;
        EmpLoanLine : Record "Employee Loan Line";
        P_Date : Date;
        Text0001 : Label 'You Cannot Modify Paid Loan';
}

