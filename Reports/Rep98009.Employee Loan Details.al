report 98009 "Employee Loan Details"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employee Loan Details.rdlc';

    dataset
    {
        dataitem("Employee Loan";"Employee Loan")
        {
            RequestFilterFields = "Employee No.","Date of Loan",Completed;
            column(CompanyPicture;CompanyInformation.Picture)
            {
            }
            column(Currency;Currency)
            {
            }
            column(Employee_Loan__Employee_No__;"Employee No.")
            {
            }
            column(Employee_Loan__Loan_No__;"Loan No.")
            {
            }
            column(Employee_Loan_Amount;Amount)
            {
            }
            column(Employee_Loan__Date_of_Loan_;"Date of Loan")
            {
            }
            column(Employee_Loan__Employee_Name_;"Employee Name")
            {
            }
            column(Employee_Loan__Total_Payments_Made_;"Total Payments Made")
            {
            }
            column(Employee_Loan_Purpose;Purpose)
            {
            }
            column(Employee_Loan__Employee_No__Caption;FIELDCAPTION("Employee No."))
            {
            }
            column(Employee_Loan__Loan_No__Caption;FIELDCAPTION("Loan No."))
            {
            }
            column(Employee_Loan_AmountCaption;FIELDCAPTION(Amount))
            {
            }
            column(Employee_Loan__Date_of_Loan_Caption;FIELDCAPTION("Date of Loan"))
            {
            }
            column(Employee_Loan__Employee_Name_Caption;FIELDCAPTION("Employee Name"))
            {
            }
            column(Employee_Loan__Total_Payments_Made_Caption;FIELDCAPTION("Total Payments Made"))
            {
            }
            column(Employee_Loan_PurposeCaption;FIELDCAPTION(Purpose))
            {
            }
            dataitem("Employee Loan Line";"Employee Loan Line")
            {
                DataItemLink = "Employee No."=FIELD("Employee No."),"Loan No."=FIELD("Loan No.");
                column(Employee_Loan_Line__Payment_Amount_;"Payment Amount")
                {
                }
                column(Employee_Loan_Line_Completed;Completed)
                {
                }
                column(Employee_Loan_Line__Payment_Date_;"Payment Date")
                {
                }
                column(Employee_Loan_Line__Payment_Amount_Caption;FIELDCAPTION("Payment Amount"))
                {
                }
                column(Employee_Loan_Line__Payment_Date_Caption;FIELDCAPTION("Payment Date"))
                {
                }
                column(Employee_Loan_Line_CompletedCaption;FIELDCAPTION(Completed))
                {
                }
                column(Employee_Loan_Line_ID;ID)
                {
                }
                column(Employee_Loan_Line_Employee_No_;"Employee No.")
                {
                }
                column(Employee_Loan_Line_Loan_No_;"Loan No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                GeneralLedgerSetup.GET;
                if GeneralLedgerSetup."LCY Code"='LBP' then
                   Currency := 'LL'
                else Currency := GeneralLedgerSetup."LCY Code";
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        GeneralLedgerSetup : Record "General Ledger Setup";
        Currency : Text[30];
        CompanyInformation : Record "Company Information";
        EmpLoanLine : Record "Employee Loan Line";
}

