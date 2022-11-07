report 98077 "Employee Statement Account"
{
    // version NAVW16.00.01,EDM.IT,EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Employee Statement Account.rdlc';
    Caption = 'Detail Trial Balance';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(DateFilter;DateFilter)
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(FirstName_Employee;Employee."First Name")
            {
            }
            column(MiddleName_Employee;Employee."Middle Name")
            {
            }
            column(LastName_Employee;Employee."Last Name")
            {
            }
            column(G_L_Account_No_;Employee."No.")
            {
            }
            column(G_L_Account_Date_Filter;"Date Filter")
            {
            }
            column(DateFilterDayBefore;DateFilterDayBefore)
            {
            }
            column(ShowAccountInfoFilter;ShowAccountInfoFilter)
            {
            }
            column(ShowBFBalanceFilter;ShowBFBalanceFilter)
            {
            }
            dataitem("Dimension Set Entry";"Dimension Set Entry")
            {
                DataItemLink = "Dimension Value Code"=FIELD("No.");
                DataItemLinkReference = Employee;
                PrintOnlyIfDetail = true;
                column(EmployeeDimension;EmployeeDimensionRelation)
                {
                }
                column(ShowDetails;ShowDetails)
                {
                }
                column(ShowInAdditionalCurrency;ShowInAdditionalCurrency)
                {
                }
                column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
                {
                }
                column(STRSUBSTNO_Text000_GLDateFilter_;STRSUBSTNO(Text000,GLDateFilter))
                {
                }
                /*column(CurrReport_PAGENO;CurrReport.PAGENO)
                {
                }*/
                column(COMPANYNAME;COMPANYNAME)
                {
                }
                column(USERID;USERID)
                {
                }
                column(CompanyPicture;CompanyInformation.Picture)
                {
                }
                column(CompanyName1;CompanyInfo.Name)
                {
                }
                column(CompanyAddress1;CompanyInfo.Address)
                {
                }
                column(CompanyCity1;CompanyInfo.City)
                {
                }
                column(CompanyPhone1;CompanyInfo."Phone No.")
                {
                }
                column(CompanyFax1;CompanyInfo."Fax No.")
                {
                }
                column(CompanyVATREG1;CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyEmail1;CompanyInfo."E-Mail")
                {
                }
                column(CompanyHomePage1;CompanyInfo."Home Page")
                {
                }
                column(ExcludeBalanceOnly;ExcludeBalanceOnly)
                {
                }
                column(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                {
                }
                column(PrintReversedEntries;PrintReversedEntries)
                {
                }
                column(PageGroupNo;PageGroupNo)
                {
                }
                column(PrintClosingEntries;PrintClosingEntries)
                {
                }
                column(PrintOnlyCorrections;PrintOnlyCorrections)
                {
                }
                column(G_L_Account__TABLECAPTION__________GLFilter;Employee.TABLECAPTION)
                {
                }
                column(GLFilter;GLFilter)
                {
                }
                column(EmptyString;'')
                {
                }
                column(G_L_Entry__Debit_Amount__Control33Caption;DebitLCY)
                {
                    AutoFormatType = 1;
                }
                column(G_L_Entry__Credit_Amount__Control34Caption;CreditLCY)
                {
                    AutoFormatType = 1;
                }
                column(GLBalanceCaption;BalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(GLBalanceAdditionalCaption;BalanceACY)
                {
                    AutoFormatType = 1;
                }
                column(G_L_Entry__AdditionalCredit_Amount__Control34Caption;CreditACY)
                {
                    AutoFormatType = 1;
                }
                column(G_L_Entry__AdditionalDebit_Amount__Control33Caption;DebitACY)
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account__Q_B__Description_;Employee."Full Name")
                {
                }
                column(Detail_Trial_BalanceCaption;Detail_Trial_BalanceCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(This_also_includes_G_L_accounts_that_only_have_a_balance_Caption;This_also_includes_G_L_accounts_that_only_have_a_balance_CaptionLbl)
                {
                }
                column(This_report_also_includes_closing_entries_within_the_period_Caption;This_report_also_includes_closing_entries_within_the_period_CaptionLbl)
                {
                }
                column(Only_corrections_are_included_Caption;Only_corrections_are_included_CaptionLbl)
                {
                }
                column(Net_ChangeCaption;Net_ChangeCaptionLbl)
                {
                }
                column(G_L_Entry__Posting_Date_Caption;"G/L Entry".FIELDCAPTION("Posting Date"))
                {
                }
                column(G_L_Entry__Document_No__Caption;"G/L Entry".FIELDCAPTION("Document No."))
                {
                }
                column(G_L_Entry_DescriptionCaption;"G/L Entry".FIELDCAPTION(Description))
                {
                }
                column(G_L_Entry__VAT_Amount__Control32Caption;"G/L Entry".FIELDCAPTION("VAT Amount"))
                {
                }
                column(Debit_USDCaption;Debit_USDCaptionLbl)
                {
                }
                column(Credit_USDCaption;Credit_USDCaptionLbl)
                {
                }
                column(Balance_USDCaption;Balance_USDCaptionLbl)
                {
                }
                column(G_L_Entry__Entry_No__Caption;"G/L Entry".FIELDCAPTION("Entry No."))
                {
                }
                column(Debit_LBPCaption;Debit_LBPCaptionLbl)
                {
                }
                column(Credit_LBPCaption;Credit_LBPCaptionLbl)
                {
                }
                column(Balance_LBPCaption;Balance_LBPCaptionLbl)
                {
                }
                column(TotalCal;TotalCal)
                {
                }
                column(TotalAddCal;TotalAddCal)
                {
                }
                dataitem(PageCounter;"Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number=CONST(1));
                    column(PageCounter_Number;Number)
                    {
                    }
                    column(G_L_Account___No__;Employee."No.")
                    {
                    }
                    column(G_L_Account__Name;Employee."Full Name")
                    {
                    }
                    column(StartBalanceAdditional;StartBalanceAdditional)
                    {
                        AutoFormatType = 1;
                    }
                    column(StartBalance;StartBalance)
                    {
                        AutoFormatType = 1;
                    }
                    dataitem("G/L Entry";"G/L Entry")
                    {
                        DataItemLink = "Dimension Set ID"=FIELD("Dimension Set ID");
                        DataItemLinkReference = "Dimension Set Entry";
                        DataItemTableView = SORTING("G/L Account No.","Posting Date") ORDER(Ascending);
                        RequestFilterFields = "G/L Account No.";
                        column(Day;Day)
                        {
                        }
                        column(Month;Month)
                        {
                        }
                        column(Year;Year)
                        {
                        }
                        column(EntryNo;"Entry No.")
                        {
                        }
                        column(GL_Entry_Account_No;"G/L Entry"."G/L Account No.")
                        {
                        }
                        column(G_L_Entry__VAT_Amount_;"VAT Amount")
                        {
                        }
                        column(G_L_Entry__Debit_Amount_;"Debit Amount")
                        {
                        }
                        column(G_L_Entry__Credit_Amount_;"Credit Amount")
                        {
                        }
                        column(StartBalance___Amount;StartBalance + Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(G_L_Entry__Add_Currency_Debit_Amount_;"Add.-Currency Debit Amount")
                        {
                        }
                        column(G_L_Entry__Add_Currency_Credit_Amount_;"Add.-Currency Credit Amount")
                        {
                        }
                        column(StartBalanceAdditional___AdditionalAmount;StartBalanceAdditional + "Additional-Currency Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(Posting_Date;"Posting Date")
                        {
                        }
                        column(G_L_Entry__Document_No__;"Document No.")
                        {
                        }
                        column(ExternalDocumentNumber;"G/L Entry"."External Document No.")
                        {
                        }
                        column(G_L_Entry_Description;Description)
                        {
                        }
                        column(G_L_Entry__VAT_Amount__Control32;"VAT Amount")
                        {
                        }
                        column(G_L_Entry__Debit_Amount__Control33;"Debit Amount")
                        {
                        }
                        column(G_L_Entry__Credit_Amount__Control34;"Credit Amount")
                        {
                        }
                        column(GLBalance;GLBalance)
                        {
                            AutoFormatType = 1;
                        }
                        column(G_L_Entry__Entry_No__;"Entry No.")
                        {
                        }
                        column(ClosingEntry;ClosingEntry)
                        {
                        }
                        column(GLEntryReversed;"G/L Entry".Reversed)
                        {
                        }
                        column(GLBalanceAdd;GLBalanceAdd)
                        {
                            AutoFormatType = 1;
                        }
                        column(G_L_Entry_Add_Currency__Credit_Amount__Control34;"Add.-Currency Credit Amount")
                        {
                        }
                        column(G_L_Entry_Add_Currency__Debit_Amount__Control33;"Add.-Currency Debit Amount")
                        {
                        }
                        column(G_L_Entry__VAT_Amount__Control38;"VAT Amount")
                        {
                        }
                        column(G_L_Entry__Debit_Amount__Control39;"Debit Amount")
                        {
                        }
                        column(G_L_Entry__Credit_Amount__Control40;"Credit Amount")
                        {
                        }
                        column(StartBalance___Amount_Control41;StartBalance + Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(StartBalanceAdd___AddAmount_Control41;StartBalanceAdditional + "Additional-Currency Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(G_L_Entry_Add_Currency__Credit_Amount__Control40;"G/L Entry"."Add.-Currency Credit Amount")
                        {
                        }
                        column(G_L_Entry_Add_Currency__Debit_Amount__Control39;"Add.-Currency Debit Amount")
                        {
                        }
                        column(G_L_Entry__VAT_Amount_Caption;G_L_Entry__VAT_Amount_CaptionLbl)
                        {
                        }
                        column(GLAccountName_GLEntry;"G/L Entry"."G/L Account Name")
                        {
                        }
                        column(G_L_Entry__VAT_Amount__Control38Caption;G_L_Entry__VAT_Amount__Control38CaptionLbl)
                        {
                        }
                        column(G_L_Entry_G_L_Account_No_;"G/L Account No.")
                        {
                        }
                        column(G_L_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                        {
                        }
                        column(G_L_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                        {
                        }
                        column(G_L_Entry_Business_Unit_Code;"Business Unit Code")
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            Day := DATE2DMY("Posting Date",1);
                            Month := DATE2DMY("Posting Date",2);
                            Year := DATE2DMY("Posting Date",3);
                            //
                            GLBalance := GLBalance + Amount;
                              //EDM+
                            GLBalanceAdd := GLBalanceAdd + "Additional-Currency Amount";
                            TotalCal := TotalCal + Amount;
                            TotalAddCal := TotalAddCal + "Additional-Currency Amount";
                            //EDM-
                            if PrintOnlyCorrections then
                              if not (("Debit Amount" < 0) or ("Credit Amount" < 0)) then
                                CurrReport.SKIP;
                            if not PrintReversedEntries and Reversed then
                              CurrReport.SKIP;
                            if ISSERVICETIER then begin

                              //EDM-
                              if ("Posting Date" = CLOSINGDATE("Posting Date")) and
                                 not PrintClosingEntries
                              then begin
                                "Debit Amount" := 0;
                                "Credit Amount" := 0;
                                //EDM+
                                  "Add.-Currency Debit Amount" := 0;
                                  "Add.-Currency Credit Amount" := 0;
                                //EDM-
                              end;

                              if ("Posting Date" = CLOSINGDATE("Posting Date")) then
                                ClosingEntry := true
                              else
                                ClosingEntry := false;
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            if DateMin <> 0D then
                             SETRANGE("Posting Date",DateMin,DateMax);
                        end;
                    }
                    dataitem("Integer";"Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number=CONST(1));
                        column(G_L_Account__Name_Control42;"G/L Entry"."G/L Account Name")
                        {
                        }
                        column(G_L_Entry___VAT_Amount_;"G/L Entry"."VAT Amount")
                        {
                        }
                        column(G_L_Entry___Debit_Amount_;"G/L Entry"."Debit Amount")
                        {
                        }
                        column(G_L_Entry___Credit_Amount_;"G/L Entry"."Credit Amount")
                        {
                        }
                        column(StartBalance____G_L_Entry__Amount;StartBalance + "G/L Entry".Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(G_L_Entry___Additional_Currency_Debit_Amount_;"G/L Entry"."Add.-Currency Debit Amount")
                        {
                        }
                        column(G_L_Entry___Additional_Currency_Credit_Amount_;"G/L Entry"."Add.-Currency Credit Amount")
                        {
                        }
                        column(StartBalanceAdditional____G_L_Entry__AdditionalAmount;StartBalanceAdditional+"G/L Entry"."Additional-Currency Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(SGLMain;GLMain)
                        {
                        }
                        column(SGLMainAdd;GLMainAdd)
                        {
                        }
                        column(GLBalanceFinal;GLBalance)
                        {
                        }
                        column(GLBalanceAddFinal;GLBalanceAdd)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if ("G/L Entry"."Debit Amount" = 0) and
                               ("G/L Entry"."Credit Amount" = 0) and
                                  ((StartBalance = 0) or ExcludeBalanceOnly)
                            then
                              CurrReport.SKIP;
                        end;
                    }
                }
            }

            trigger OnAfterGetRecord();
            begin

                if ISSERVICETIER then begin
                    GLEntryPage.RESET;
                    GLEntryPage.SETRANGE("Dimension Set ID","Dimension Set Entry"."Dimension Set ID");
                    //Stopped By EDM.MM //IF CurrReport.PRINTONLYIFDETAIL AND GLEntryPage.FIND('-') THEN
                    IF GLEntryPage.FIND('-') THEN
                      PageGroupNo := PageGroupNo + 1;
                end;
                StartBalance := 0;
                StartBalanceAdditional := 0;
                GLBalance := 0;
                GLBalanceAdd := 0;
                if ShowBFBalanceFilter then
                  begin
                    if (DateMin <> 0D )then
                      StartBalance := PayrollFunctions.GetEmployeeTillDateGLBalance(0D,DateFilterDayBefore,"No.",EmployeeDimensionRelation,StartBalanceAdditional);


                    GLBalance := StartBalance;
                    GLBalanceAdd := StartBalanceAdditional;
                    TotalCal := TotalCal + StartBalance;
                    TotalAddCal := TotalAddCal + StartBalanceAdditional;
                  end;

                //EDM:MChami (Send Mail)-
                //Stopped by EDM.MM if IsSendMailChecked then
                //Stopped by EDM.MM   SendMail.SendStatementAccountToEmployees(Employee,DateFilter,ShowBFBalanceFilter);
                //EDM:MChami (Send Mail)-
            end;

            trigger OnPreDataItem();
            begin
                if DateMin <> 0D then
                  DateFilterDayBefore := CALCDATE('<-1D>',DateMin);
                //IF EmployeeNoFilter <> '' THEN
                //  SETRANGE("No.",EmployeeNoFilter);
                if ISSERVICETIER then
                  PageGroupNo := 1;
                //CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;

                //EDM:MChami (Send Mail)+
                if (not IsSendMailChecked) and (EmployeeNoFilter <> '') then
                  begin
                    COPYFILTERS(EmployeeRecForMail);
                    SETRANGE("No.",EmployeeNoFilter);
                  end;
                //EDM:MChami (Send Mail)-
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per G/L Acc.';
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field(ExcludeBalanceOnly;ExcludeBalanceOnly)
                    {
                        Caption = 'Exclude G/L Accs. That Have a Balance Only';
                        MultiLine = true;
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field(PrintClosingEntries;PrintClosingEntries)
                    {
                        Caption = 'Include Closing Entries Within the Period';
                        MultiLine = true;
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field(PrintReversedEntries;PrintReversedEntries)
                    {
                        Caption = 'Include Reversed Entries';
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field(PrintOnlyCorrections;PrintOnlyCorrections)
                    {
                        Caption = 'Print Corrections Only';
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field("Show Additional Currency";ShowInAdditionalCurrency)
                    {
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field("Show Details ";ShowDetails)
                    {
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field(DateFilter;DateFilter)
                    {
                        Caption = 'Date Filter';
                        ApplicationArea=All;
                    }
                    field(ShowAccountInfoFilter;ShowAccountInfoFilter)
                    {
                        Caption = 'Show Account Info';
                        ApplicationArea=All;
                    }
                    field(ShowBFBalanceFilter;ShowBFBalanceFilter)
                    {
                        Caption = 'Show B/F Balance';
                        ApplicationArea=All;
                    }
                    field("Send Mail";IsSendMailChecked)
                    {
                        ApplicationArea=All;
                    }
                }
            }
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
        CompanyInformation.CALCFIELDS(Picture);
        GLSetup.GET;
        TotalCal := 0;
        TotalAddCal := 0;
        //EDM+
        //Author: Suzan El Charkawi
        //get employee dimension code
          case GLSetup."Employee Dimension Index" of
            GLSetup."Employee Dimension Index"::"1" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 1 Code";
            GLSetup."Employee Dimension Index"::"2" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 2 Code";
            GLSetup."Employee Dimension Index"::"3" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 3 Code";
            GLSetup."Employee Dimension Index"::"4" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 4 Code";
            GLSetup."Employee Dimension Index"::"5" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 5 Code";
            GLSetup."Employee Dimension Index"::"6" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 6 Code";
            GLSetup."Employee Dimension Index"::"7" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 7 Code";
            GLSetup."Employee Dimension Index"::"8" :
              EmployeeDimensionRelation := GLSetup."Shortcut Dimension 8 Code";
          end;

        //EDM-
    end;

    trigger OnPreReport();
    begin
        DateMin := 0D;
        DateMax := 0D;
        if DateFilter <> '' then
          begin
            Employee.RESET;
            Employee.SETFILTER("Date Filter",DateFilter);
            DateMin := Employee.GETRANGEMIN("Date Filter");
            DateMax := Employee.GETRANGEMAX("Date Filter");
          end;
        //EDM+
        GLSetup.GET;
        BalanceACY:='Balance'+' '+GLSetup."Additional Reporting Currency";
        BalanceLCY:='Balance'+' '+GLSetup."LCY Code";
        DebitACY:='Debit'+' '+GLSetup."Additional Reporting Currency";
        DebitLCY:='Debit'+' '+GLSetup."LCY Code";
        CreditACY:='Credit'+' '+GLSetup."Additional Reporting Currency";
        CreditLCY:='Credit'+' '+GLSetup."LCY Code";
        //EDM-
    end;

    var
        Text000 : Label 'Period: %1';
        GLDateFilter : Text[30];
        GLFilter : Text[250];
        GLBalance : Decimal;
        StartBalance : Decimal;
        PrintOnlyOnePerPage : Boolean;
        ExcludeBalanceOnly : Boolean;
        PrintClosingEntries : Boolean;
        PrintOnlyCorrections : Boolean;
        PrintReversedEntries : Boolean;
        PageGroupNo : Integer;
        GLEntryPage : Record "G/L Entry";
        ClosingEntry : Boolean;
        CompanyInformation : Record "Company Information";
        CompanyInfo : Record "Company Information";
        StartBalanceAdditional : Decimal;
        GLBalanceAdd : Decimal;
        BalanceACY : Text[50];
        BalanceLCY : Text[50];
        CreditACY : Text[50];
        CreditLCY : Text[50];
        DebitACY : Text[50];
        DebitLCY : Text[50];
        GLSetup : Record "General Ledger Setup";
        Detail_Trial_BalanceCaptionLbl : Label 'Detail Trial Balance';
        CurrReport_PAGENOCaptionLbl : Label 'Page';
        This_also_includes_G_L_accounts_that_only_have_a_balance_CaptionLbl : Label 'This also includes G/L accounts that only have a balance.';
        This_report_also_includes_closing_entries_within_the_period_CaptionLbl : Label 'This report also includes closing entries within the period.';
        Only_corrections_are_included_CaptionLbl : Label 'Only corrections are included.';
        Net_ChangeCaptionLbl : Label 'Net Change';
        Debit_USDCaptionLbl : Label 'Debit USD';
        Credit_USDCaptionLbl : Label 'Credit USD';
        Balance_USDCaptionLbl : Label 'Balance USD';
        Debit_LBPCaptionLbl : Label 'Debit LBP';
        Credit_LBPCaptionLbl : Label 'Credit LBP';
        Balance_LBPCaptionLbl : Label 'Balance LBP';
        G_L_Entry__VAT_Amount_CaptionLbl : Label 'Continued';
        G_L_Entry__VAT_Amount__Control38CaptionLbl : Label 'Continued';
        ShowInAdditionalCurrency : Boolean;
        ShowDetails : Boolean;
        RetentioName : Text;
        customer : Record Customer;
        vendor : Record Vendor;
        EmployeeDimensionRelation : Code[20];
        DimSetEntry : Record "Dimension Set Entry";
        FilterString : Text[250];
        "Employee No." : Code[20];
        "Show Acc. Info" : Boolean;
        "Date Filter" : Date;
        "Show B/F Balance" : Boolean;
        EmployeeRec : Record Employee;
        GLMain : Decimal;
        DateFilter : Text;
        ShowAccountInfoFilter : Boolean;
        AccountNoFilter : Code[30];
        EmployeeNoFilter : Code[20];
        ShowBFBalanceFilter : Boolean;
        GLMainAdd : Decimal;
        DimensionSetEntry : Record "Dimension Set Entry";
        TotalCal : Decimal;
        TotalAddCal : Decimal;
        ExcludeEmployeeDimensionFilter : Integer;
        DateFilterDayBefore : Date;
        PayrollFunctions : Codeunit "Payroll Functions";
        DateMin : Date;
        DateMax : Date;
        IsSendMailChecked : Boolean;
        EmployeeRecForMail : Record Employee;
        Day : Integer;
        Month : Integer;
        Year : Integer;

    procedure SetParameters(IsSendMailCheckedParam : Boolean;EmployeeNoFilterParam : Code[20];EmployeeRecForSendMailParam : Record Employee;DateFilterParam : Text;ShowBFBalanceFilterParam : Boolean);
    begin

        //EDM:MChami (Send Mail)+
        IsSendMailChecked := IsSendMailCheckedParam;
        EmployeeNoFilter := EmployeeNoFilterParam;
        EmployeeRecForMail := EmployeeRecForSendMailParam;
        DateFilter := DateFilterParam;
        ShowBFBalanceFilter := ShowBFBalanceFilterParam;
        //EDM:MChami (Send Mail)-
    end;
}

