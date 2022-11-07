report 98048 "Pay Slip Customized 1"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Pay Slip Customized 1.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(Name_CompanyInfo;CompanyInfoRec.Name)
            {
            }
            column(Picture_CompanyInfo;CompanyInfoRec.Picture)
            {
            }
            column(FamilyStatus_Employee;FamilyStatus)
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(FullName_Employee;Employee."Full Name")
            {
            }
            column(SocialSecurityNo_Employee;Employee."Social Security No.")
            {
            }
            column(PersonalFinanceNo_Employee;Employee."Personal Finance No.")
            {
            }
            column(PaySlipDate_Employee;PaySlipDateStr)
            {
            }
            column(PaymentMethod_Employee;PaymentMethodStr)
            {
            }
            column(PayElementsAddition1;PayElementsAdditionStr[1])
            {
            }
            column(PayElementsAddition2;PayElementsAdditionStr[2])
            {
            }
            column(PayElementsAddition3;PayElementsAdditionStr[3])
            {
            }
            column(PayElementsAddition4;PayElementsAdditionStr[4])
            {
            }
            column(PayElementsAddition5;PayElementsAdditionStr[5])
            {
            }
            column(PayElementsAddition6;PayElementsAdditionStr[6])
            {
            }
            column(PayElementsDeduction1;PayElementsDeductionStr[1])
            {
            }
            column(PayElementsDeduction2;PayElementsDeductionStr[2])
            {
            }
            column(PayElementsDeduction3;PayElementsDeductionStr[3])
            {
            }
            column(PayElementsDeduction4;PayElementsDeductionStr[4])
            {
            }
            column(PayElementsDeduction5;PayElementsDeductionStr[5])
            {
            }
            column(PayElementsDeduction6;PayElementsDeductionStr[6])
            {
            }
            column(PayElementsAddition_Amount1;PayElementsAddition_Amount[1])
            {
            }
            column(PayElementsAddition_Amount2;PayElementsAddition_Amount[2])
            {
            }
            column(PayElementsAddition_Amount3;PayElementsAddition_Amount[3])
            {
            }
            column(PayElementsAddition_Amount4;PayElementsAddition_Amount[4])
            {
            }
            column(PayElementsAddition_Amount5;PayElementsAddition_Amount[5])
            {
            }
            column(PayElementsAddition_Amount6;PayElementsAddition_Amount[6])
            {
            }
            column(PayElementsDeduction_Amount1;PayElementsDeduction_Amount[1])
            {
            }
            column(PayElementsDeduction_Amount2;PayElementsDeduction_Amount[2])
            {
            }
            column(PayElementsDeduction_Amount3;PayElementsDeduction_Amount[3])
            {
            }
            column(PayElementsDeduction_Amount4;PayElementsDeduction_Amount[4])
            {
            }
            column(PayElementsDeduction_Amount5;PayElementsDeduction_Amount[5])
            {
            }
            column(PayElementsDeduction_Amount6;PayElementsDeduction_Amount[6])
            {
            }
            column(TotalAddition;TotalAddition)
            {
            }
            column(TotalDeduction;TotalDeduction)
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(GlobalDimension3Code_Employee;Employee.Location)
            {
            }
            column(PayrollGroupName;PayrollGroupName)
            {
            }
            column(VacationBalance;VacationBalanceStr)
            {
            }
            column(HolidayBalance;HolidayBalanceStr)
            {
            }
            column(department;Department)
            {
            }

            trigger OnAfterGetRecord();
            begin
                //Clear values:
                PayElementsAddition_Amount[1] := 0;
                PayElementsAddition_Amount[2] := 0;
                PayElementsAddition_Amount[3] := 0;
                PayElementsAddition_Amount[4] := 0;
                PayElementsAddition_Amount[5] := 0;
                PayElementsAddition_Amount[6] := 0;
                PayElementsDeduction_Amount[1] := 0;
                PayElementsDeduction_Amount[2] := 0;
                PayElementsDeduction_Amount[3] := 0;
                PayElementsDeduction_Amount[4] := 0;
                PayElementsDeduction_Amount[5] := 0;
                PayElementsDeduction_Amount[6] := 0;
                PayElementsAddition[1] := '';
                PayElementsAddition[2] := '';
                PayElementsAddition[3] := '';
                PayElementsAddition[4] := '';
                PayElementsAddition[5] := '';
                PayElementsAddition[6] := '';
                PayElementsDeduction[1] := '';
                PayElementsDeduction[2] := '';
                PayElementsDeduction[3] := '';
                PayElementsDeduction[4] := '';
                PayElementsDeduction[5] := '';
                PayElementsDeduction[6] := '';
                PayElementsAdditionStr[1] := '';
                PayElementsAdditionStr[2] := '';
                PayElementsAdditionStr[3] := '';
                PayElementsAdditionStr[4] := '';
                PayElementsAdditionStr[5] := '';
                PayElementsAdditionStr[6] := '';
                PayElementsDeductionStr[1] := '';
                PayElementsDeductionStr[2] := '';
                PayElementsDeductionStr[3] := '';
                PayElementsDeductionStr[4] := '';
                PayElementsDeductionStr[5] := '';
                PayElementsDeductionStr[6] := '';
                PayElementsAdditionPriority[1] := 10000;
                PayElementsAdditionPriority[2] := 10000;
                PayElementsAdditionPriority[3] := 10000;
                PayElementsAdditionPriority[4] := 10000;
                PayElementsAdditionPriority[5] := 10000;
                PayElementsAdditionPriority[6] := 10000;
                PayElementsDeductionPriority[1] := 10000;
                PayElementsDeductionPriority[2] := 10000;
                PayElementsDeductionPriority[3] := 10000;
                PayElementsDeductionPriority[4] := 10000;
                PayElementsDeductionPriority[5] := 10000;
                PayElementsDeductionPriority[6] := 10000;

                TotalAddition := 0;
                TotalDeduction := 0;
                NetPay := 0;
                VacationBalance := 0;
                HolidayBalance := 0;
                Department := '';

                //Family Status:
                if Employee."Social Status" = Employee."Social Status"::Single then
                  FamilyStatus := 'S'
                else if Employee."Social Status" = Employee."Social Status"::Married then
                  FamilyStatus := 'M'
                else if Employee."Social Status" = Employee."Social Status"::Divorced then
                  FamilyStatus := 'D'
                else if Employee."Social Status" = Employee."Social Status"::Widow then
                  FamilyStatus := 'W';

                Employee.CALCFIELDS("No of Children");
                if Employee."No of Children" > 0 then
                  FamilyStatus := FamilyStatus + ' + ' + FORMAT(Employee."No of Children");

                //Payment Method;
                if Employee."Payment Method" = Employee."Payment Method"::Bank then
                  PaymentMethodStr := 'BACS'
                else
                  PaymentMethodStr := 'CASH';

                //Department:
                DefaultDimensionRec.SETRANGE("Table ID",5200);
                DefaultDimensionRec.SETRANGE("No.",Employee."No.");
                DefaultDimensionRec.SETRANGE("Dimension Code",'Department');
                if DefaultDimensionRec.FINDFIRST then
                  Department := DefaultDimensionRec."Dimension Value Code";

                //Payroll Group Name:
                HrPayrollGroupRec.SETRANGE(Code,Employee."Payroll Group Code");
                if HrPayrollGroupRec.FINDFIRST then
                  PayrollGroupName := HrPayrollGroupRec.Description;

                //Getting vacation balance:
                  VacationBalance := PayrollFunctions.GetEmpAbsenceEntitlementCurrentBalance(Employee."No.",VacationCauseofAbscenceCode,0D);
                  VacationBalanceStr := FORMAT(VacationBalance);

                //Getting Holiday balance:
                  HolidayBalance := PayrollFunctions.GetEmpAbsenceEntitlementCurrentBalance(Employee."No.",HolidayCode,0D);
                  HolidayBalanceStr := FORMAT(HolidayBalance);

                //Fill pay elements list (name | amount):
                PayDetailLine.SETRANGE("Employee No.",Employee."No.");
                if PayDetailLine.FINDSET then begin
                  repeat
                    PayElementRec.SETRANGE(Code,PayDetailLine."Pay Element Code");
                    if (PayElementRec.FINDFIRST) and (PayDetailLine."Calculated Amount" <> 0) then
                      if PayDetailLine.Type = PayDetailLine.Type::Addition then begin
                        AddPayElementCode(PayDetailLine."Pay Element Code",PayElementRec."Description in PaySlip",1,PayElementRec."Order No.",PayDetailLine."Calculated Amount");
                        TotalAddition += PayDetailLine."Calculated Amount";
                      end
                      else if PayDetailLine.Type = PayDetailLine.Type::Deduction then begin
                        AddPayElementCode(PayDetailLine."Pay Element Code",PayElementRec."Description in PaySlip",2,PayElementRec."Order No.",PayDetailLine."Calculated Amount");
                        TotalDeduction += PayDetailLine."Calculated Amount";
                      end;
                  until PayDetailLine.NEXT = 0;

                  PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                  PayrollLedgerEntry.SETRANGE(Period,DATE2DMY(PaySlipDate,2));
                  PayrollLedgerEntry.SETRANGE("Tax Year",DATE2DMY(PaySlipDate,3));
                  if PayrollLedgerEntry.FINDFIRST then
                    NetPay := PayrollLedgerEntry."Net Pay";
                end
                else
                  CurrReport.SKIP;
            end;

            trigger OnPreDataItem();
            var
                cnt_add : Integer;
                cnt_ded : Integer;
            begin
                Employee.SETRANGE(Employee.Status,Employee.Status::Active);
                PayDetailLine.SETRANGE(Period,DATE2DMY(PaySlipDate,2));
                PayDetailLine.SETRANGE("Tax Year",DATE2DMY(PaySlipDate,3));

                //Getting Vacation cause of absence code:
                HRSetupRec.GET;
                if HRSetupRec."Annual Leave Code" <> '' then
                  VacationCauseofAbscenceCode := HRSetupRec."Annual Leave Code"
                else
                  VacationCauseofAbscenceCode := 'AL';

                //Getting Holiday code:
                if HRSetupRec."Holiday Code" <> '' then
                  HolidayCode :=  HRSetupRec."Holiday Code"
                else
                  HolidayCode := 'HOL';

                PayElementRec.SETCURRENTKEY("Order No.",Code,Type);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(General)
                {
                    field(PaySlipDate;PaySlipDate)
                    {
                        Caption = 'Pay Slip Date';
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
        CompanyInfoRec.GET;
        CompanyInfoRec.CALCFIELDS(Picture);
        PaySlipDateStr := FORMAT(PaySlipDate,0,'<Month Text>');
        PaySlipDateStr += ' ' + FORMAT(DATE2DMY(PaySlipDate,3));
    end;

    var
        CompanyInfoRec : Record "Company Information";
        PayElementRec : Record "Pay Element";
        PayDetailLine : Record "Pay Detail Line";
        HrPayrollGroupRec : Record "HR Payroll Group";
        HRSetupRec : Record "Human Resources Setup";
        DefaultDimensionRec : Record "Default Dimension";
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        PayrollFunctions : Codeunit "Payroll Functions";
        PayElementsAddition : array [6] of Code[10];
        PayElementsAdditionPriority : array [6] of Integer;
        PayElementsDeduction : array [6] of Code[10];
        PayElementsDeductionPriority : array [6] of Integer;
        PayElementsAdditionStr : array [6] of Text[100];
        PayElementsDeductionStr : array [6] of Text[100];
        PayElementsAddition_Amount : array [6] of Decimal;
        PayElementsDeduction_Amount : array [6] of Decimal;
        TotalAddition : Decimal;
        TotalDeduction : Decimal;
        NetPay : Decimal;
        FamilyStatus : Text[6];
        PaySlipDate : Date;
        PaySlipDateStr : Text[15];
        PaymentMethodStr : Text[4];
        PayrollGroupName : Text[30];
        VacationCauseofAbscenceCode : Code[10];
        HolidayCode : Code[10];
        VacationBalance : Decimal;
        HolidayBalance : Decimal;
        VacationBalanceStr : Text;
        HolidayBalanceStr : Text;
        department : Code[20];

    local procedure AddPayElementCode("code" : Code[10];desc : Text[100];type : Integer;priority : Integer;amount : Decimal);
    var
        i : Integer;
        breaktrigger : Boolean;
    begin
        if type = 1 then begin //Addition
          //Find if this element group is already added in the list,if so add the amount on the same element group:
          repeat
            i += 1;
            if PayElementsAddition[i] <> '' then begin
              if PayElementsAdditionStr[i] = desc then begin
                if PayElementsAdditionPriority[i] > priority then begin
                  PayElementsAdditionPriority[i] := priority;
                  PayElementsAddition[i] := code;
                  PayElementsAddition_Amount[i] += amount;
                  breaktrigger := true;
                  OrderElement(i,1);
                  break;
                end
                else begin
                  PayElementsAddition_Amount[i] += amount;
                  breaktrigger := true;
                  break;
                end;
              end
            end
            else
              break;
          until i = 6;

          if not breaktrigger then begin
            i := 0;
            repeat
              i += 1;
              if PayElementsAddition[i] = '' then begin
                PayElementsAddition[i] := code;
                PayElementsAdditionStr[i] := desc;
                PayElementsAdditionPriority[i] := priority;
                PayElementsAddition_Amount[i] := amount;
                break
              end
              else if PayElementsAdditionPriority[i] > priority then begin
                if i < 6 then
                  IncrementIndex(i,1);
                PayElementsAddition[i] := code;
                PayElementsAdditionStr[i] := desc;
                PayElementsAdditionPriority[i] := priority;
                PayElementsAddition_Amount[i] := amount;
                break
              end;
            until i = 6
          end;
        end
        else begin //Deduction
          //Find if this element group is already added in the list,if so add the amount on the same element group:
          repeat
            i += 1;
            if PayElementsDeduction[i] <> '' then begin
              if PayElementsDeductionStr[i] = desc then begin
                if PayElementsDeductionPriority[i] > priority then begin
                  PayElementsDeductionPriority[i] := priority;
                  PayElementsDeduction[i] := code;
                  PayElementsDeduction_Amount[i] += amount;
                  breaktrigger := true;
                  OrderElement(i,2);
                  break
                end
                else begin
                  PayElementsDeduction_Amount[i] += amount;
                  breaktrigger := true;
                  break
                end;
              end
            end
            else
              break;
          until i = 6;

          if not breaktrigger then begin
            i := 0;
            repeat
              i += 1;
              if PayElementsDeduction[i] = '' then begin
                PayElementsDeduction[i] := code;
                PayElementsDeductionStr[i] := desc;
                PayElementsDeductionPriority[i] := priority;
                PayElementsDeduction_Amount[i] := amount;
                break
              end
              else if PayElementsDeductionPriority[i] > priority then begin
                if i < 6 then
                  IncrementIndex(i,2);
                PayElementsDeduction[i] := code;
                PayElementsDeductionStr[i] := desc;
                PayElementsDeductionPriority[i] := priority;
                PayElementsDeduction_Amount[i] := amount;
                break
              end;
            until i = 6
           end;
        end;
    end;

    local procedure IncrementIndex(startIndex : Integer;type : Integer);
    var
        i : Integer;
    begin
        //Increment the Index of all elements list (+1) starting from the given example: IncrementIndex(2,1)
        //before    after  to-add-later
        //  1  -->   1
        //  3  -->   -     <-- 2
        //  -  -->   3
        //  -  -->   -
        i := 6;
        if type = 1 then begin //Addition
          repeat
            if PayElementsAddition[i-1] <> '' then begin
              PayElementsAddition[i] := PayElementsAddition[i-1];
              PayElementsAdditionStr[i] := PayElementsAdditionStr[i-1];
              PayElementsAdditionPriority[i] := PayElementsAdditionPriority[i-1];
              PayElementsAddition_Amount[i] := PayElementsAddition_Amount[i-1]
            end;
            i := i - 1;
          until i = startIndex;
        end
        else begin //Deduction
          repeat
            if PayElementsDeduction[i-1] <> '' then begin
              PayElementsDeduction[i] := PayElementsDeduction[i-1];
              PayElementsDeductionStr[i] := PayElementsDeductionStr[i-1];
              PayElementsDeductionPriority[i] := PayElementsDeductionPriority[i-1];
              PayElementsDeduction_Amount[i] := PayElementsDeduction_Amount[i-1]
            end;
            i := i - 1;
          until i = startIndex;
        end;
    end;

    local procedure OrderElement(index : Integer;type : Integer);
    var
        i : Integer;
        "code" : Code[10];
        desc : Text[100];
        amount : Decimal;
        priority : Integer;
    begin
        i := index;
        if index > 1 then begin
          if type = 1 then begin //Addition
            repeat
              if PayElementsAddition[i] <> '' then begin
                if PayElementsAdditionPriority[i] < PayElementsAdditionPriority[i-1] then begin
                  code := PayElementsAddition[i];
                  desc := PayElementsAdditionStr[i];
                  priority := PayElementsAdditionPriority[i];
                  amount := PayElementsAddition_Amount[i];
                  PayElementsAddition[i] := PayElementsAddition[i-1];
                  PayElementsAdditionStr[i] := PayElementsAdditionStr[i-1];
                  PayElementsAdditionPriority[i] := PayElementsAdditionPriority[i-1];
                  PayElementsAddition_Amount[i] := PayElementsAddition_Amount[i-1];
                  PayElementsAddition[i-1] := code;
                  PayElementsAdditionStr[i-1] := desc;
                  PayElementsAdditionPriority[i-1] := priority;
                  PayElementsAddition_Amount[i-1] := amount;
                end
                else
                  break;
              end;
              i := i - 1;
            until i = 1;
          end
          else begin //Deduction
             repeat
              if PayElementsDeduction[i] <> '' then begin
                if PayElementsDeductionPriority[i] < PayElementsDeductionPriority[i-1] then begin
                  code := PayElementsDeduction[i];
                  desc := PayElementsDeductionStr[i];
                  priority := PayElementsDeductionPriority[i];
                  amount := PayElementsDeduction_Amount[i];
                  PayElementsDeduction[i] := PayElementsDeduction[i-1];
                  PayElementsDeductionStr[i] := PayElementsDeductionStr[i-1];
                  PayElementsDeductionPriority[i] := PayElementsDeductionPriority[i-1];
                  PayElementsDeduction_Amount[i] := PayElementsDeduction_Amount[i-1];
                  PayElementsDeduction[i-1] := code;
                  PayElementsDeductionStr[i-1] := desc;
                  PayElementsDeductionPriority[i-1] := priority;
                  PayElementsDeduction_Amount[i-1] := amount;
                end
                else
                  break;
              end;
              i := i - 1;
            until i = 1;
          end;
        end;
    end;
}

