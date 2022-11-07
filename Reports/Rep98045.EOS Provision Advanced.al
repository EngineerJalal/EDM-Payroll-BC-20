report 98045 "EOS Provision Advanced"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/EOS Provision Advanced.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.","Global Dimension 1 Code";

            column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
            {
            }
            column(CompanyFax;CompanyInfo."Fax No.")
            {
            }
            column(CompanyHomePage;CompanyInfo."Home Page")
            {
            }
            column(CompanyPhone;CompanyInfo."Phone No.")
            {
            }
            column(CompanyAddress;CompanyInfo.Address)
            {
            }
            column(CompanyName;CompanyInfo.Name)
            {
            }
            column(CompanyPic;CompanyInformation.Picture)
            {
            }
            column(RevenueCaption1;RevenueCaption1)
            {
            }
            column(RevenueCaption2;RevenueCaption2)
            {
            }
            column(RevenueCaption3;RevenueCaption3)
            {
            }
            column(RevenueCaption4;RevenueCaption4)
            {
            }
            column(RevenueCaption5;RevenueCaption5)
            {
            }
            column(RevenueCaption6;RevenueCaption6)
            {
            }
            column(RevenueCaption7;RevenueCaption7)
            {
            }
            column(AccumulatedASOfCaption;AccumulatedASOfCaption)
            {
            }
            column(EOSPensionCaption;EOSPensionCaption)
            {
            }
            column(AccPreviousYearsCaption;AccPreviousYearsCaption)
            {
            }
            column(NumberOfMonthsCaption;NumberOfMonthsCaption)
            {
            }
            column(EOSCaption;EOSCaption)
            {
            }
            column(ProvisionCaption;ProvisionCaption)
            {
            }
            column(Employee__Payroll_Group_Code_;"Payroll Group Code")
            {
            }
            column(Employee__Pay_Frequency_;"Pay Frequency")
            {
            }
            column(Employee__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(Employee__No__;"No.")
            {
            }
            column(Employee__First_Name_;"First Name")
            {
            }
            column(Employee__Middle_Name_;"Middle Name")
            {
            }
            column(Employee__Last_Name_;"Last Name")
            {
            }
            column(Employee__Employment_Date_;"Employment Date")
            {
            }
            column(Employee__Global_Dimension_1_Code__Control37;"Global Dimension 1 Code")
            {
            }
            column(Employee__Termination_Date_;"Termination Date")
            {
            }
            column(AccPrevYear;AccPrevYear)
            {
            }
            column(Revenue1;Revenue1)
            {
            }
            column(Revenue3;Revenue3)
            {
            }
            column(Revenue4;Revenue4)
            {
            }
            column(Revenue5;Revenue5)
            {
            }
            column(Revenue6;Revenue6)
            {
            }
            column(Revenue7;Revenue7)
            {
            }
            column(AccumulatedASOf;AccumulatedASOf)
            {
            }
            column(EOSPension;EOSPension)
            {
            }
            column(DateCalcProvision;DateCalcProvision)
            {
            }
            column(NumberOfMonths;NumberOfMonths)
            {
            }
            column(AverageYearly;AverageYearly)
            {
            }
            column(EOS;EOS)
            {
            }
            column(Provision;Provision)
            {
            }
            column(Revenue2;Revenue2)
            {
            }
            column(AsOfDate;AsOfDate)
            {
            }
            column(NewPageGroup;NewPageGroup)
            {
            }
            column(NewPageGroup1;NewPageGroup1)
            {
            }
            column(EmployeeCaption;EmployeeCaptionLbl)
            {
            }
            column(Employee__No__Caption;FIELDCAPTION("No."))
            {
            }
            column(Employee__First_Name_Caption;FIELDCAPTION("First Name"))
            {
            }
            column(Employee__Middle_Name_Caption;FIELDCAPTION("Middle Name"))
            {
            }
            column(Employee__Last_Name_Caption;FIELDCAPTION("Last Name"))
            {
            }
            column(Employee__Employment_Date_Caption;FIELDCAPTION("Employment Date"))
            {
            }
            column(Employee__Global_Dimension_1_Name_Caption;Employee__Global_Dimension_1_Name_CaptionLbl)
            {
            }
            column(Employee__Global_Dimension_1_Code__Control37Caption;FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(Employee__Termination_Date_Caption;FIELDCAPTION("Termination Date"))
            {
            }
            column(Employee__Payroll_Group_Code_Caption;FIELDCAPTION("Payroll Group Code"))
            {
            }
            column(Employee__Pay_Frequency_Caption;FIELDCAPTION("Pay Frequency"))
            {
            }
            column(Employee__Global_Dimension_1_Code_Caption;FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(UndeclaredAccumulatedASOfCaption;UndeclaredAccumulatedASOfCaption)
            {
            }
            column(UndeclaredEOSPensionCaption;UndeclaredEOSPensionCaption)
            {
            }
            column(UndeclaredEOSCaption;UndeclaredEOSCaption)
            {
            }
            column(UndeclaredProvisionCaption;UndeclaredProvisionCaption)
            {
            }
            column(UndeclaredAccumulatedASOf;UndeclaredAccumulatedASOf)
            {
            }
            column(UndeclaredEOSPension;UndeclaredEOSPension)
            {
            }
            column(UndeclaredEOS;UndeclaredEOS)
            {
            }
            column(UndeclaredProvision;UndeclaredProvision)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Employee."Employee Age" > 64 then
                    NewPageGroup := true
                else
                     NewPageGroup := false;
                
                if (Employee.Status=Employee.Status::Terminated) then begin
                    if (FORMAT(Employee."Termination Date")<>'') then begin
                        if (DATE2DMY(Employee."Termination Date",3)<DATE2DMY(AsOfDate,3)) then
                            NewPageGroup1 := true
                        else
                            NewPageGroup1 := false;
                    end else
                        NewPageGroup1 := false;
                end else
                    NewPageGroup1 := false;
                
                Revenue7:=CalculateYearlySalary("No.",DMY2DATE(1,1,DATE2DMY(AsOfDate,3)),AsOfDate);
                Revenue6:=CalculateYearlySalary("No.",DMY2DATE(1,1,DATE2DMY(CALCDATE('-1Y',AsOfDate),3)),DMY2DATE(31,12,DATE2DMY(CALCDATE('-1Y',AsOfDate),3)));
                Revenue5:=CalculateYearlySalary("No.",DMY2DATE(1,1,DATE2DMY(CALCDATE('-2Y',AsOfDate),3)),DMY2DATE(31,12,DATE2DMY(CALCDATE('-2Y',AsOfDate),3)));
                Revenue4:=CalculateYearlySalary("No.",DMY2DATE(1,1,DATE2DMY(CALCDATE('-3Y',AsOfDate),3)),DMY2DATE(31,12,DATE2DMY(CALCDATE('-3Y',AsOfDate),3)));
                Revenue3:=CalculateYearlySalary("No.",DMY2DATE(1,1,DATE2DMY(CALCDATE('-4Y',AsOfDate),3)),DMY2DATE(31,12,DATE2DMY(CALCDATE('-4Y',AsOfDate),3)));
                Revenue2:=CalculateYearlySalary("No.",DMY2DATE(1,1,DATE2DMY(CALCDATE('-5Y',AsOfDate),3)),DMY2DATE(31,12,DATE2DMY(CALCDATE('-5Y',AsOfDate),3)));
                Revenue1:=CalculateYearlySalary("No.",DMY2DATE(1,1,DATE2DMY(CALCDATE('-6Y',AsOfDate),3)),DMY2DATE(31,12,DATE2DMY(CALCDATE('-6Y',AsOfDate),3)));
                
                AccPrevYear:=CalculatePreviuosYearlySalary("No.",
                DMY2DATE(31,12,DATE2DMY(CALCDATE('-7Y',AsOfDate),3)));
                
                AccumulatedASOf:=Revenue1+Revenue2+Revenue3+Revenue4+Revenue5+Revenue6+Revenue7+AccPrevYear;
                
                UndeclaredRevenue := CalculateUndeclaredLastYearSalary("No.",DMY2DATE(1,1,DATE2DMY(AsOfDate,3)),AsOfDate);
                UndeclaredAccumulatedASOf := CalculateUndeclaredPreviuosYearSalary("No.",AsOfDate);
                
                if "Employee Age" <= 64 then begin
                    EOSPension:=(AccumulatedASOf * 8.5) / 100;
                    UndeclaredEOSPension := (UndeclaredAccumulatedASOf * 8.5) / 100;
                end else begin
                    EOSPension:=0;
                    UndeclaredEOSPension := 0;
                end;
                
                if (FORMAT("Employment Date")<> '') then begin
                    if FORMAT("Termination Date") <>'' then begin
                        if "Termination Date">AsOfDate then begin
                            NumberOfMonths:=((AsOfDate-"Employment Date")/365)*12;
                            DateCalcProvision:=AsOfDate;
                        end else begin
                            NumberOfMonths:=(("Termination Date"-"Employment Date")/365)*12;
                            DateCalcProvision:="Termination Date";
                        end;
                    end else begin
                        NumberOfMonths:=((AsOfDate-"Employment Date")/365)*12;
                        DateCalcProvision:=AsOfDate;
                    end;
                end;
                
                if FORMAT("Termination Date") <>'' then begin
                    if "Termination Date">AsOfDate then begin
                        AverageYearly:=Revenue7/12;
                        UndeclaredAverageYearly := UndeclaredRevenue/12;
                    end else begin
                        AverageYearly:=Revenue7/(12-(12-(DATE2DMY("Termination Date",2))));
                        UndeclaredAverageYearly := UndeclaredRevenue/(12-(12-(DATE2DMY("Termination Date",2))));
                    end;
                end else
                    AverageYearly:=Revenue7/12;
                
                
                EOS := (AverageYearly * NumberOfMonths) * 0.085;
                UndeclaredEOS := (UndeclaredAverageYearly * NumberOfMonths) * 0.085;
                
                Provision := EOS - EOSPension;
                UndeclaredProvision := UndeclaredEOS - UndeclaredEOSPension;
                
                RevenueCaption7:='Revenue '+FORMAT(DATE2DMY(AsOfDate,3));
                RevenueCaption6:='Revenue '+FORMAT(DATE2DMY(CALCDATE('-1Y',AsOfDate),3));
                RevenueCaption5:='Revenue '+FORMAT(DATE2DMY(CALCDATE('-2Y',AsOfDate),3));
                RevenueCaption4:='Revenue '+FORMAT(DATE2DMY(CALCDATE('-3Y',AsOfDate),3));
                RevenueCaption3:='Revenue '+FORMAT(DATE2DMY(CALCDATE('-4Y',AsOfDate),3));
                RevenueCaption2:='Revenue '+FORMAT(DATE2DMY(CALCDATE('-5Y',AsOfDate),3));
                RevenueCaption1:='Revenue '+FORMAT(DATE2DMY(CALCDATE('-6Y',AsOfDate),3));
                AccumulatedASOfCaption:='Accumulated AS OF '+ FORMAT(AsOfDate);
                EOSPensionCaption:='EOS pension (8.5%) '+FORMAT(AsOfDate);
                AccPreviousYearsCaption:='Accumulated '+FORMAT(DATE2DMY(CALCDATE('-7Y',AsOfDate),3));
                NumberOfMonthsCaption:='Nbr.of months '+ FORMAT(AsOfDate);
                EOSCaption:='EOS as per average '+FORMAT(AsOfDate);
                ProvisionCaption:='Provision '+FORMAT(AsOfDate);
                UndeclaredAccumulatedASOfCaption:='Other Accumulated AS OF '+ FORMAT(AsOfDate);
                UndeclaredEOSPensionCaption:='Other EOS pension (8.5%) '+FORMAT(AsOfDate);
                UndeclaredEOSCaption:='Other EOS '+FORMAT(AsOfDate);
                UndeclaredProvisionCaption:='Other Provision '+FORMAT(AsOfDate);
            end;

            trigger OnPreDataItem();
            begin
                LastFieldNo := FIELDNO("Global Dimension 1 Code");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Date Filter")
                {
                    Caption = 'Date Filter';
                    field(AsOfDate;AsOfDate)
                    {
                        Caption = 'As Of Date';
                        ApplicationArea=All;
                    }
                }
            }
        }
    }

    trigger OnInitReport();
    begin
        if PayrollFunction.HideSalaryFields() then
            ERROR('Permission NOT Allowed!');
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
        CompanyInfo.GET;
    end;

    var
        LastFieldNo : Integer;
        AsOfDate : Date;
        AccumulatedASOf : Decimal;
        EOSPension : Decimal;
        DateCalcProvision : Date;
        NumberOfMonths : Decimal;
        AverageYearly : Decimal;
        EOS : Decimal;
        Provision : Decimal;
        Revenue1 : Decimal;
        Revenue2 : Decimal;
        Revenue3 : Decimal;
        Revenue4 : Decimal;
        Revenue5 : Decimal;
        Revenue6 : Decimal;
        Revenue7 : Decimal;
        AccPrevYear : Decimal;
        RevenueCaption1 : Text[50];
        RevenueCaption2 : Text[50];
        RevenueCaption3 : Text[50];
        RevenueCaption4 : Text[50];
        RevenueCaption5 : Text[50];
        RevenueCaption6 : Text[50];
        RevenueCaption7 : Text[50];
        AccumulatedASOfCaption : Text[50];
        EOSPensionCaption : Text[50];
        AccPreviousYearsCaption : Text[50];
        NumberOfMonthsCaption : Text[50];
        EOSCaption : Text[50];
        ProvisionCaption : Text[50];
        CompanyInfo : Record "Company Information";
        CompanyInformation : Record "Company Information";
        NewPageGroup : Boolean;
        NewPageGroup1 : Boolean;
        EmployeeCaptionLbl : Label 'Employee';
        Employee__Global_Dimension_1_Name_CaptionLbl : Label 'Label35';
        PayrollFunction : Codeunit "Payroll Functions";
        UndeclaredRevenue : Decimal;
        UndeclaredAccumulatedASOf : Decimal;
        UndeclaredEOSPension : Decimal;
        UndeclaredProvision : Decimal;
        UndeclaredEOS : Decimal;
        UndeclaredAverageYearly : Decimal;
        UndeclaredAccumulatedASOfCaption : Text;
        UndeclaredEOSPensionCaption : Text;
        UndeclaredEOSCaption : Text;
        UndeclaredProvisionCaption : Text;

    procedure CalculateYearlySalary(EmployeeNo : Code[20];FromDate : Date;ToDate : Date) BasicTax : Decimal;
    var
        PayrollLedgerEntryRec : Record "Payroll Ledger Entry";
    begin
        PayrollLedgerEntryRec.RESET;
        BasicTax := 0;
        PayrollLedgerEntryRec.SETRANGE("Employee No.",EmployeeNo);
        PayrollLedgerEntryRec.SETFILTER("Payroll Date",'%1..%2',FromDate,ToDate);
        if PayrollLedgerEntryRec.FINDFIRST then repeat
            BasicTax += PayrollLedgerEntryRec."Total Salary for NSSF";
        until PayrollLedgerEntryRec.NEXT = 0;

        exit(BasicTax);
    end;

    procedure CalculatePreviuosYearlySalary(EmployeeNo : Code[20];ToDate : Date) BasicTax : Decimal;
    var
        PayrollLedgerEntryRec : Record "Payroll Ledger Entry";
    begin
        PayrollLedgerEntryRec.RESET;
        BasicTax := 0;
        PayrollLedgerEntryRec.SETRANGE("Employee No.",EmployeeNo);
        PayrollLedgerEntryRec.SETFILTER("Payroll Date",'<=%1',ToDate);
        if PayrollLedgerEntryRec.FINDFIRST then repeat
          BasicTax += PayrollLedgerEntryRec."Total Salary for NSSF";
        until PayrollLedgerEntryRec.NEXT=0;

        exit(BasicTax);
    end;

    procedure CalculateUndeclaredLastYearSalary(EmployeeNo : Code[20];FromDate : Date;ToDate : Date) BasicTax : Decimal;
    var
        PayrollLedgerEntryRec : Record "Payroll Ledger Entry";
    begin
        PayrollLedgerEntryRec.RESET;
        BasicTax := 0;
        PayrollLedgerEntryRec.SETRANGE("Employee No.",EmployeeNo);
        PayrollLedgerEntryRec.SETFILTER("Payroll Date",'%1..%2',FromDate,ToDate);
        if PayrollLedgerEntryRec.FINDFIRST then repeat
            if PayrollLedgerEntryRec."Net Pay" - PayrollLedgerEntryRec."Taxable Pay" > 0 then
                BasicTax += (PayrollLedgerEntryRec."Net Pay" - PayrollLedgerEntryRec."Taxable Pay");
        until PayrollLedgerEntryRec.NEXT = 0;

        exit(BasicTax);
    end;

    procedure CalculateUndeclaredPreviuosYearSalary(EmployeeNo : Code[20];ToDate : Date) BasicTax : Decimal;
    var
        PayrollLedgerEntryRec : Record "Payroll Ledger Entry";
    begin
        PayrollLedgerEntryRec.RESET;
        BasicTax := 0;
        PayrollLedgerEntryRec.SETRANGE("Employee No.",EmployeeNo);
        PayrollLedgerEntryRec.SETFILTER("Payroll Date",'<=%1',ToDate);
        if PayrollLedgerEntryRec.FINDFIRST then repeat
          if PayrollLedgerEntryRec."Net Pay" - PayrollLedgerEntryRec."Taxable Pay" > 0 then
            BasicTax += (PayrollLedgerEntryRec."Net Pay" - PayrollLedgerEntryRec."Taxable Pay");
        until PayrollLedgerEntryRec.NEXT = 0;

        exit(BasicTax);
    end;
}

