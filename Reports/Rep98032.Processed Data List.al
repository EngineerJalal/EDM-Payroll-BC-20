report 98032 "Processed Data List.."
{
    // version PY1.0,EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Processed Data List...rdlc';

    dataset
    {
        dataitem("Temporary Payroll Table";"Temporary Payroll Table")
        {
            DataItemTableView = SORTING("Program Code","User ID","Line No.",Type,"Employee No.","General Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
            column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
            {
            }
            column(USERID;USERID)
            {
            }
            /*column(CurrReport_PAGENO;CurrReport.PAGENO)
            {
            }*/
            column(Processed_Data_List_For________Program_Code_;'Processed Data List For : ' + "Program Code")
            {
            }
            column(CompanyInfo_Name;CompanyInfo.Name)
            {
            }
            column(Temporary_Payroll_Table__Employee_No__;"Employee No.")
            {
            }
            column(Temporary_Payroll_Table_Amount;Amount)
            {
                DecimalPlaces = 0:0;
            }
            column(Temporary_Payroll_Table__Amount__ACY__;"Amount (ACY)")
            {
                DecimalPlaces = 0:0;
            }
            column(Temporary_Payroll_Table__Extra_Amount_;"Extra Amount")
            {
                DecimalPlaces = 0:0;
            }
            column(Temporary_Payroll_Table__Extra_Amount__ACY__;"Extra Amount (ACY)")
            {
                DecimalPlaces = 0:0;
            }
            column(Employee__First_Name__________Employee__Last_Name_;Employee."First Name" + ' ' + Employee."Last Name")
            {
            }
            column(NewAmountACY;NewAmountACY)
            {
                DecimalPlaces = 0:0;
            }
            column(NewAmount;NewAmount)
            {
                DecimalPlaces = 0:0;
            }
            column(NewAmountACY_Control1000000031;NewAmountACY)
            {
                DecimalPlaces = 0:0;
            }
            column(NewAmount_Control1000000033;NewAmount)
            {
                DecimalPlaces = 0:0;
            }
            column(Temporary_Payroll_Table__Extra_Amount__ACY___Control1000000035;"Extra Amount (ACY)")
            {
                DecimalPlaces = 0:0;
            }
            column(Temporary_Payroll_Table__Extra_Amount__Control1000000037;"Extra Amount")
            {
                DecimalPlaces = 0:0;
            }
            column(Temporary_Payroll_Table__Amount__ACY___Control1000000039;"Amount (ACY)")
            {
                DecimalPlaces = 0:0;
            }
            column(Temporary_Payroll_Table_Amount_Control1000000041;Amount)
            {
                DecimalPlaces = 0:0;
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(New_Amt_ACYCaption;New_Amt_ACYCaptionLbl)
            {
            }
            column(New_Amt_Caption;New_Amt_CaptionLbl)
            {
            }
            column(Extra_Amt_ACYCaption;Extra_Amt_ACYCaptionLbl)
            {
            }
            column(Extra_Amt_Caption;Extra_Amt_CaptionLbl)
            {
            }
            column(Amt_ACYCaption;Amt_ACYCaptionLbl)
            {
            }
            column(Amt_Caption;Amt_CaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Temporary_Payroll_Table__Employee_No__Caption;FIELDCAPTION("Employee No."))
            {
            }
            column(T_O_T_A_L_Caption;T_O_T_A_L_CaptionLbl)
            {
            }
            column(Temporary_Payroll_Table_Program_Code;"Program Code")
            {
            }
            column(Temporary_Payroll_Table_User_ID;"User ID")
            {
            }
            column(Temporary_Payroll_Table_Line_No_;"Line No.")
            {
            }
            column(Temporary_Payroll_Table_Type;Type)
            {
            }
            column(Temporary_Payroll_Table_General_Code;"General Code")
            {
            }
            column(Temporary_Payroll_Table_Shortcut_Dimension_1_Code;"Shortcut Dimension 1 Code")
            {
            }
            column(Temporary_Payroll_Table_Shortcut_Dimension_2_Code;"Shortcut Dimension 2 Code")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Employee.GET("Employee No.");

                NewAmount := Amount + "Extra Amount";
                NewAmountACY := "Amount (ACY)" + "Extra Amount (ACY)";
            end;

            trigger OnPreDataItem();
            begin
                //CurrReport.CREATETOTALS(NewAmount,NewAmountACY);
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

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
    end;

    var
        PayEmp : Record Employee;
        PayGroup : Record "HR Payroll Group";
        PayrollFunction : Codeunit "Payroll Functions";
        ShowErrorCount : Boolean;
        ErrorCount : Integer;
        PayGroupFilter : Text[30];
        PayFreqFilter : Text[30];
        CompanyInfo : Record "Company Information";
        Employee : Record Employee;
        NewAmount : Decimal;
        NewAmountACY : Decimal;
        CurrReport_PAGENOCaptionLbl : Label 'Page';
        New_Amt_ACYCaptionLbl : Label 'New Amt.ACY';
        New_Amt_CaptionLbl : Label 'New.Amt.';
        Extra_Amt_ACYCaptionLbl : Label 'Extra Amt.ACY';
        Extra_Amt_CaptionLbl : Label 'Extra Amt.';
        Amt_ACYCaptionLbl : Label 'Amt.ACY';
        Amt_CaptionLbl : Label 'Amt.';
        NameCaptionLbl : Label 'Name';
        T_O_T_A_L_CaptionLbl : Label '"T O T A L "';
}

