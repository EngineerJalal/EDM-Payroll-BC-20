report 98033 "Payroll Summary Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll Summary Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = WHERE("Payroll Group Code"=FILTER(<>'DRIVERS'));
            column(SalaryBasic;SalaryBasic)
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(ToDate;ToDate)
            {
            }
            column(CompanyPicture;CompanyInformation.Picture)
            {
            }
            column(CompanyName;CompanyInfo.Name)
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(EmpStatus;Employee.Status)
            {
            }
            column(TaxableEarning;TaxableEarning)
            {
            }
            column(WorkingDays;WorkingDays)
            {
            }
            column(GrossSalary;GrossSalary)
            {
            }
            column(Rebates;Rebates)
            {
            }
            column(TaxableAmount;TaxableAmount)
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(BasicPay;BasicPay)
            {
            }
            column(Transportation;Transportation)
            {
            }
            column(FamilyAllowance;FamilyAllowance)
            {
            }
            column(Overtime;Overtime)
            {
            }
            column(Bonus;Bonus)
            {
            }
            column(Allowance;Allowance)
            {
            }
            column(BusinessTripAllowance;BusinessTripAllowance)
            {
            }
            column(ScholarShip;ScholarShip)
            {
            }
            column(NSSF;NSSF)
            {
            }
            column(IncomeTax;IncomeTax)
            {
            }
            column(OtherDeduction;OtherDeduction)
            {
            }
            column(VariableTransportation;VariableTransportation)
            {
            }
            column(PhoneAllowance;PhoneAllowance)
            {
            }
            column(AdditionalDisbursment;AdditionalDisbursment)
            {
            }
            column(Commission;Commission)
            {
            }
            column(CommissionDeduction;CommissionDeduction)
            {
            }
            column(CommissionAddition;CommissionAddition)
            {
            }
            column(TaxableDeductions;TaxableDeductions)
            {
            }
            column(CashLoan;CashLoan)
            {
            }
            column(CashPayment;CashPayment)
            {
            }
            column(FamilySubscription;FamilySubscription)
            {
            }
            column(EOS;EOS)
            {
            }
            column(Medical;Medical)
            {
            }
            column(HCL;HCL)
            {
            }
            column(AbsenceDeduction;AbsenceDeduction)
            {
            }
            column(OT;OT)
            {
            }
            column(Rounding;Rounding)
            {
            }
            column(OtherTaxableIncome;OtherTaxableIncome)
            {
            }
            column(MarriageAllowance;MarriageAllowance)
            {
            }
            column(DeductionTransportation;DeductionTransportation)
            {
            }
            column(SchoolAllowance;SchoolAllowance)
            {
            }
            column(Month13;Month13)
            {
            }
            column(Housing;Housing)
            {
            }
            column(Hourly;Hourly)
            {
            }
            column(Renumeration;Renumeration)
            {
            }
            column(SchoolAllowanceDeduction;SchoolAllowanceDeduction)
            {
            }
            column(NetPAYACY;NetPayACY)
            {
            }
            column(Medical7;Medical7)
            {
            }
            column(AdminFees;AdminFees)
            {
            }
            column(Activity;Employee."Global Dimension 1 Code")
            {
            }
            column(Project;Employee."Global Dimension 2 Code")
            {
            }
            column(IsUSDChecked;USD_Currency)
            {
            }
            column(Currency;Currency)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Employee.Status= Employee.Status::Terminated then
                begin
                  if (Employee."Termination Date" < FromDate) then
                    CurrReport.SKIP;
                end;

                if (Employee."Employment Date">ToDate) then
                  CurrReport.SKIP;

                AdminFees:=0;
                SalaryBasic:=0;
                CommissionDeduction:=0;
                CommissionAddition:=0;
                SchoolAllowance :=0;
                SchoolAllowanceDeduction:=0;
                NetPay :=0;
                NetPayACY:=0;
                BasicPay :=0;
                Transportation  :=0;
                FamilyAllowance :=0;
                Overtime   :=0;
                Bonus      :=0;
                Allowance  :=0;
                BusinessTripAllowance :=0;
                ScholarShip   :=0;
                NSSF      :=0;
                IncomeTax:=0;
                OtherDeduction:=0;
                Renumeration:=0;
                VariableTransportation:=0;
                PhoneAllowance   :=0;
                AdditionalDisbursment:=0;
                Commission  :=0;
                TaxableDeductions  :=0;
                CashLoan            :=0;
                CashPayment         :=0;
                FamilySubscription  :=0;
                EOS                 :=0;
                Medical             :=0;
                HCL                 :=0;
                AbsenceDeduction    :=0;
                OT                  :=0;
                OtherTaxableIncome  :=0;
                MarriageAllowance   :=0;
                DeductionTransportation:=0;
                SchoolAllowance        :=0;
                Month13                :=0;
                Housing        :=0;
                Hourly          :=0;
                //EDM_26082015
                TaxableEarning := 0;
                WorkingDays :=0;
                TaxableLeavesic :=0;
                TaxableAmount :=0;
                Rebates     :=0;
                Medical7  :=0;
                GrossSalary:=0;
                //EDM_26082015
                PayDetailLine.SETRANGE("Employee No.","No.");
                PayDetailLine.SETFILTER("Payroll Date",'%1..%2',FromDate,ToDate);
                if PayDetailLine.FINDFIRST then
                repeat
                 if PayDetailLine."Pay Element Code"='01' then
                 begin
                  BasicPay:=BasicPay+PayDetailLine."Calculated Amount";
                 end
                 else if PayDetailLine."Pay Element Code"='02' then
                 begin
                  Transportation:=Transportation+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='03' then
                 begin
                  FamilyAllowance:=FamilyAllowance+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='04' then
                 begin
                  Hourly:=Hourly+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='05' then
                 begin
                  Overtime:=Overtime+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='06' then
                 begin
                  Housing:=Housing+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='07' then
                 begin
                  Allowance:=Allowance+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='08' then
                 begin
                  BusinessTripAllowance:=BusinessTripAllowance+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='09' then
                 begin
                  ScholarShip:=ScholarShip+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='86' then
                 begin
                  NSSF:=NSSF+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='11' then
                 begin
                  IncomeTax:=IncomeTax+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='12' then
                 begin
                  OtherDeduction:=OtherDeduction+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='13' then
                 begin
                  VariableTransportation:=VariableTransportation+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='14' then
                 begin
                  Month13:=Month13+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='15' then
                 begin
                  PhoneAllowance :=PhoneAllowance+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='16' then
                 begin
                  AdditionalDisbursment :=AdditionalDisbursment+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='17' then
                 begin
                  Commission :=Commission+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='17-01' then
                 begin
                  CommissionAddition :=CommissionAddition+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='17-02' then
                 begin
                  CommissionDeduction :=CommissionDeduction+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='18' then
                 begin
                  Bonus :=Bonus+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='19' then
                 begin
                  OtherTaxableIncome :=OtherTaxableIncome+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='21' then
                 begin
                  TaxableDeductions :=TaxableDeductions+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='22' then
                 begin
                  FamilyAllowance :=FamilyAllowance+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='22-01' then
                 begin
                  FamilyAllowance :=FamilyAllowance-PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='23' then
                 begin
                  Transportation :=Transportation-PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='24' then
                 begin
                  MarriageAllowance :=MarriageAllowance+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='25' then
                 begin
                    SchoolAllowance:=SchoolAllowance+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='25-01' then
                 begin
                    SchoolAllowanceDeduction:=SchoolAllowanceDeduction+PayDetailLine."Calculated Amount";


                 end else if PayDetailLine."Pay Element Code"='28' then
                 begin
                    AdminFees:=AdminFees+PayDetailLine."Employer Amount";
                 end
                 else if PayDetailLine."Pay Element Code"='26' then
                 begin
                    Renumeration:=Renumeration+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='82' then
                 begin
                  CashLoan :=CashLoan+PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='83' then
                 begin
                  CashPayment :=CashPayment+PayDetailLine."Calculated Amount";
                 end;
                 if PayDetailLine."Pay Element Code"='84' then
                 begin
                  FamilySubscription:=FamilySubscription+PayDetailLine."Employer Amount";
                 end else if PayDetailLine."Pay Element Code"='85' then
                 begin
                  EOS:=EOS+PayDetailLine."Employer Amount";
                 end else if PayDetailLine."Pay Element Code"='86' then
                 begin
                  Medical:=Medical+PayDetailLine."Calculated Amount";
                  Medical7:=Medical7+PayDetailLine."Employer Amount";
                 end else if PayDetailLine."Pay Element Code"='87' then
                 begin
                  HCL:= HCL + PayDetailLine."Calculated Amount";
                 end else if PayDetailLine."Pay Element Code"='88' then
                 begin
                  AbsenceDeduction:=AbsenceDeduction+PayDetailLine."Calculated Amount";
                 end;
                until PayDetailLine.NEXT=0;

                PayrollLedgerEntry.SETRANGE("Employee No.","No.");
                PayrollLedgerEntry.SETFILTER("Payroll Date",'%1..%2',FromDate,ToDate);
                if PayrollLedgerEntry.FINDFIRST then
                begin
                repeat
                  SalaryBasic:=SalaryBasic+"Basic Pay";
                  Rounding:=Rounding+PayrollLedgerEntry.Rounding;
                  NetPay:=NetPay+PayrollLedgerEntry."Net Pay"  ;
                  NetPayACY:=ROUND(NetPay/1507.5,1,'=');
                  //EDM_26082015
                  TaxableEarning := TaxableEarning + PayrollLedgerEntry."Taxable Allowances";
                  WorkingDays := WorkingDays+PayrollLedgerEntry."Working Days";
                  GrossSalary := GrossSalary + PayrollLedgerEntry."Gross Pay";
                  Rebates := Rebates + PayrollLedgerEntry."Free Pay";
                  TaxableAmount := TaxableAmount + PayrollLedgerEntry."Taxable Pay";
                  //EDM_26082015
                until PayrollLedgerEntry.NEXT=0;
                end else
                begin
                  NetPayACY:=0;
                  SalaryBasic:=0;
                  NetPay:=0;
                  Rounding:=0;
                end;

                if USD_Currency then begin
                    Currency := 'USD';

                    BasicPay:=BasicPay / USD_Currency_Rate;
                    Transportation:=Transportation / USD_Currency_Rate;
                    FamilyAllowance:=FamilyAllowance / USD_Currency_Rate;
                    Hourly:=Hourly / USD_Currency_Rate;
                    Overtime:=Overtime / USD_Currency_Rate;
                    Housing:=Housing / USD_Currency_Rate;
                    Allowance:=Allowance / USD_Currency_Rate;
                    BusinessTripAllowance:=BusinessTripAllowance / USD_Currency_Rate;
                    ScholarShip:=ScholarShip / USD_Currency_Rate;
                    NSSF:=NSSF / USD_Currency_Rate;
                    IncomeTax:=IncomeTax / USD_Currency_Rate;
                    OtherDeduction:=OtherDeduction / USD_Currency_Rate;
                    VariableTransportation:=VariableTransportation / USD_Currency_Rate;
                    Month13:=Month13 / USD_Currency_Rate;
                    PhoneAllowance :=PhoneAllowance / USD_Currency_Rate;
                    AdditionalDisbursment :=AdditionalDisbursment / USD_Currency_Rate;
                    Commission :=Commission / USD_Currency_Rate;
                    CommissionAddition :=CommissionAddition / USD_Currency_Rate;
                    CommissionDeduction :=CommissionDeduction / USD_Currency_Rate;
                    Bonus :=Bonus / USD_Currency_Rate;
                    OtherTaxableIncome :=OtherTaxableIncome / USD_Currency_Rate;
                    TaxableDeductions :=TaxableDeductions / USD_Currency_Rate;
                    FamilyAllowance :=FamilyAllowance / USD_Currency_Rate;
                    FamilyAllowance :=FamilyAllowance / USD_Currency_Rate;
                    Transportation :=Transportation / USD_Currency_Rate;
                    MarriageAllowance :=MarriageAllowance / USD_Currency_Rate;
                    SchoolAllowance:=SchoolAllowance / USD_Currency_Rate;
                    SchoolAllowanceDeduction:=SchoolAllowanceDeduction / USD_Currency_Rate;
                    AdminFees:=AdminFees / USD_Currency_Rate;
                    Renumeration:=Renumeration / USD_Currency_Rate;
                    CashLoan :=CashLoan / USD_Currency_Rate;
                    CashPayment :=CashPayment / USD_Currency_Rate;
                    FamilySubscription:=FamilySubscription / USD_Currency_Rate;
                    EOS:=EOS / USD_Currency_Rate;
                    Medical:=Medical / USD_Currency_Rate;
                    Medical7:=Medical7 / USD_Currency_Rate;
                    HCL:= HCL / USD_Currency_Rate;
                    AbsenceDeduction:=AbsenceDeduction / USD_Currency_Rate;

                    SalaryBasic:=SalaryBasic / USD_Currency_Rate;
                    Rounding:=Rounding / USD_Currency_Rate;
                    NetPay:=NetPay / USD_Currency_Rate;
                    NetPayACY:=ROUND(NetPay,1,'=');
                    TaxableEarning := TaxableEarning / USD_Currency_Rate;
                    GrossSalary := GrossSalary / USD_Currency_Rate;
                    Rebates := Rebates / USD_Currency_Rate;
                    TaxableAmount := TaxableAmount / USD_Currency_Rate;

                    end
                else begin
                    Currency := 'LBP';
                    NetPayACY:=ROUND(NetPay/1507.5,1,'=');
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Group Filter")
                {
                    field("From Date";FromDate)
                    {
                        ApplicationArea=All;

                        trigger OnValidate();
                        begin
                            ToDate:=CALCDATE('+1M-1D',FromDate);
                        end;
                    }
                    field("To Date";ToDate)
                    {
                        ApplicationArea=All;
                    }
                    field("USD Currency";USD_Currency)
                    {
                        ApplicationArea=All;
                    }
                    field("USD Currency Rate";USD_Currency_Rate)
                    {
                        Editable = USD_Currency;
                        Enabled = true;
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

    trigger OnPreReport();
    begin

        if USD_Currency then begin
          if USD_Currency_Rate = 0 then
             ERROR(UsdCurRate_ShouldNotZero_Text);
        end;

        CompanyInfo.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        LastFieldNo : Integer;
        FooterPrinted : Boolean;
        UserSetup : Record "User Setup";
        FromDate : Date;
        ToDate : Date;
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        NetPay : Decimal;
        PayDetailLine : Record "Pay Detail Line";
        BasicPay : Decimal;
        Transportation : Decimal;
        FamilyAllowance : Decimal;
        Overtime : Decimal;
        Bonus : Decimal;
        Allowance : Decimal;
        BusinessTripAllowance : Decimal;
        ScholarShip : Decimal;
        NSSF : Decimal;
        IncomeTax : Decimal;
        OtherDeduction : Decimal;
        VariableTransportation : Decimal;
        PhoneAllowance : Decimal;
        AdditionalDisbursment : Decimal;
        Commission : Decimal;
        TaxableLeavesic : Decimal;
        TaxableDeductions : Decimal;
        CashLoan : Decimal;
        CashPayment : Decimal;
        FamilySubscription : Decimal;
        EOS : Decimal;
        Medical : Decimal;
        HCL : Decimal;
        AbsenceDeduction : Decimal;
        OT : Decimal;
        CompanyInformation : Record "Company Information";
        CompanyInfo : Record "Company Information";
        Rounding : Decimal;
        NewPageGroup : Boolean;
        OtherTaxableIncome : Decimal;
        MarriageAllowance : Decimal;
        DeductionTransportation : Decimal;
        SchoolAllowance : Decimal;
        Month13 : Decimal;
        Housing : Decimal;
        Hourly : Decimal;
        CommissionDeduction : Decimal;
        CommissionAddition : Decimal;
        Renumeration : Decimal;
        SalaryBasic : Decimal;
        SchoolAllowanceDeduction : Decimal;
        NetPayACY : Decimal;
        TaxableEarning : Decimal;
        WorkingDays : Decimal;
        GrossSalary : Decimal;
        Rebates : Decimal;
        TaxableAmount : Decimal;
        Medical7 : Decimal;
        AdminFees : Decimal;
        [InDataSet]
        USD_Currency : Boolean;
        USD_Currency_Rate : Decimal;
        Currency : Text;
        UsdCurRate_ShouldNotZero_Text : Label 'USD Currency Rate Should be greather than Zero';
}

