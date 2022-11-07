report 98037 "Emp. Payroll Journals Report"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Emp. Payroll Journals Report.rdlc';

    dataset
    {
        dataitem("Employee Journal Line";"Employee Journal Line")
        {
            RequestFilterFields = "Employee No.";
            column(TransactionType_EmployeeJournalLine;"Employee Journal Line"."Transaction Type")
            {
            }
            column(EmployeeNo_EmployeeJournalLine;"Employee Journal Line"."Employee No.")
            {
            }
            column(EntryNo_EmployeeJournalLine;"Employee Journal Line"."Entry No.")
            {
            }
            column(EmployeeStatus_EmployeeJournalLine;"Employee Journal Line"."Employee Status")
            {
            }
            column(DocumentStatus_EmployeeJournalLine;"Employee Journal Line"."Document Status")
            {
            }
            column(OpenedBy_EmployeeJournalLine;"Employee Journal Line"."Opened By")
            {
            }
            column(OpenedDate_EmployeeJournalLine;"Employee Journal Line"."Opened Date")
            {
            }
            column(ReleasedBy_EmployeeJournalLine;"Employee Journal Line"."Released By")
            {
            }
            column(ReleasedDate_EmployeeJournalLine;"Employee Journal Line"."Released Date")
            {
            }
            column(ApprovedBy_EmployeeJournalLine;"Employee Journal Line"."Approved By")
            {
            }
            column(ApprovedDate_EmployeeJournalLine;"Employee Journal Line"."Approved Date")
            {
            }
            column(StartingDate_EmployeeJournalLine;"Employee Journal Line"."Starting Date")
            {
            }
            column(Currency_EmployeeJournalLine;"Employee Journal Line".Currency)
            {
            }
            column(Description_EmployeeJournalLine;"Employee Journal Line".Description)
            {
            }
            column(MoreInformation_EmployeeJournalLine;"Employee Journal Line"."More Information")
            {
            }
            column(Value_EmployeeJournalLine;"Employee Journal Line".Value)
            {
            }
            column(ExamDate_EmployeeJournalLine;"Employee Journal Line"."Exam Date")
            {
            }
            column(AbsencePhoneNo_EmployeeJournalLine;"Employee Journal Line"."Absence Phone No.")
            {
            }
            column(AbsenceAddress_EmployeeJournalLine;"Employee Journal Line"."Absence Address")
            {
            }
            column(TransactionDate_EmployeeJournalLine;"Employee Journal Line"."Transaction Date")
            {
            }
            column(MedicalAllowanceGroup_EmployeeJournalLine;"Employee Journal Line"."Medical Allowance Group")
            {
            }
            column(MedicalExamsCount_EmployeeJournalLine;"Employee Journal Line"."Medical Exams Count")
            {
            }
            column(MedicalSubGroupFilter_EmployeeJournalLine;"Employee Journal Line"."Medical Sub Group Filter")
            {
            }
            column(CauseofAbsenceCode_EmployeeJournalLine;"Employee Journal Line"."Cause of Absence Code")
            {
            }
            column(ShortcutDimension1Code_EmployeeJournalLine;"Employee Journal Line"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_EmployeeJournalLine;"Employee Journal Line"."Shortcut Dimension 2 Code")
            {
            }
            column(EndingDate_EmployeeJournalLine;"Employee Journal Line"."Ending Date")
            {
            }
            column(TrainingNo_EmployeeJournalLine;"Employee Journal Line"."Training No.")
            {
            }
            column(EvaluationRate_EmployeeJournalLine;"Employee Journal Line"."Evaluation Rate")
            {
            }
            column(FromTime_EmployeeJournalLine;"Employee Journal Line"."From Time")
            {
            }
            column(ToTime_EmployeeJournalLine;"Employee Journal Line"."To Time")
            {
            }
            column(UnitofMeasureCode_EmployeeJournalLine;"Employee Journal Line"."Unit of Measure Code")
            {
            }
            column(Type_EmployeeJournalLine;"Employee Journal Line".Type)
            {
            }
            column(JobPositionCode_EmployeeJournalLine;"Employee Journal Line"."Job Position Code")
            {
            }
            column(OldEmployeeStatus_EmployeeJournalLine;"Employee Journal Line"."Old Employee Status")
            {
            }
            column(OldShortcutDimension1Code_EmployeeJournalLine;"Employee Journal Line"."Old Shortcut Dimension 1 Code")
            {
            }
            column(OldShortcutDimension2Code_EmployeeJournalLine;"Employee Journal Line"."Old Shortcut Dimension 2 Code")
            {
            }
            column(OldJobPositionCode_EmployeeJournalLine;"Employee Journal Line"."Old Job Position Code")
            {
            }
            column(PerformanceCode_EmployeeJournalLine;"Employee Journal Line"."Performance Code")
            {
            }
            column(OldEmploymentType_EmployeeJournalLine;"Employee Journal Line"."Old Employment Type")
            {
            }
            column(EmploymentTypeCode_EmployeeJournalLine;"Employee Journal Line"."Employment Type Code")
            {
            }
            column(Converted_EmployeeJournalLine;"Employee Journal Line".Converted)
            {
            }
            column(AffectWorkDays_EmployeeJournalLine;"Employee Journal Line"."Affect Work Days")
            {
            }
            column(AffectAttendanceDays_EmployeeJournalLine;"Employee Journal Line"."Affect Attendance Days")
            {
            }
            column(AbsenceTransactionType_EmployeeJournalLine;"Employee Journal Line"."Absence Transaction Type")
            {
            }
            column(AssociatePayElement_EmployeeJournalLine;"Employee Journal Line"."Associate Pay Element")
            {
            }
            column(Processed_EmployeeJournalLine;"Employee Journal Line".Processed)
            {
            }
            column(HusbandParalysed_EmployeeJournalLine;"Employee Journal Line"."Husband Paralysed")
            {
            }
            column(SpouseSecured_EmployeeJournalLine;"Employee Journal Line"."Spouse Secured")
            {
            }
            column(NoofChildren_EmployeeJournalLine;"Employee Journal Line"."No of Children")
            {
            }
            column(OldNoofChildren_EmployeeJournalLine;"Employee Journal Line"."Old No of Children")
            {
            }
            column(SocialStatus_EmployeeJournalLine;"Employee Journal Line"."Social Status")
            {
            }
            column(OldSocialStatus_EmployeeJournalLine;"Employee Journal Line"."Old Social Status")
            {
            }
            column(CalculatedValue_EmployeeJournalLine;"Employee Journal Line"."Calculated Value")
            {
            }
            column(OldBasicPay_EmployeeJournalLine;"Employee Journal Line"."Old Basic Pay")
            {
            }
            column(OldAdditionalSalary_EmployeeJournalLine;"Employee Journal Line"."Old Additional Salary")
            {
            }
            column(BasicPay_EmployeeJournalLine;"Employee Journal Line"."Basic Pay")
            {
            }
            column(AdditionalSalary_EmployeeJournalLine;"Employee Journal Line"."Additional Salary")
            {
            }
            column(Entitled_EmployeeJournalLine;"Employee Journal Line".Entitled)
            {
            }
            column(Reseted_EmployeeJournalLine;"Employee Journal Line".Reseted)
            {
            }
            column(V6_EmployeeJournalLine;"Employee Journal Line"."Entitled Value")
            {
            }
            column(ResetedValue_EmployeeJournalLine;"Employee Journal Line"."Reseted Value")
            {
            }
            column(ConvertedValue_EmployeeJournalLine;"Employee Journal Line"."Converted Value")
            {
            }
            column(ProcessedDate_EmployeeJournalLine;"Employee Journal Line"."Processed Date")
            {
            }
            column(UnpaidPeriod_EmployeeJournalLine;"Employee Journal Line"."Unpaid Period")
            {
            }
            column(PayrollLedgerEntryNo_EmployeeJournalLine;"Employee Journal Line"."Payroll Ledger Entry No.")
            {
            }
            column(DayOff_EmployeeJournalLine;"Employee Journal Line"."Day-Off")
            {
            }
            column(OldDeclared_EmployeeJournalLine;"Employee Journal Line"."Old Declared")
            {
            }
            column(OldForeigner_EmployeeJournalLine;"Employee Journal Line"."Old Foreigner")
            {
            }
            column(OldEmployeeCategoryCode_EmployeeJournalLine;"Employee Journal Line"."Old Employee Category Code")
            {
            }
            column(Declared_EmployeeJournalLine;"Employee Journal Line".Declared)
            {
            }
            column(Foreigner_EmployeeJournalLine;"Employee Journal Line".Foreigner)
            {
            }
            column(EmployeeCategoryCode_EmployeeJournalLine;"Employee Journal Line"."Employee Category Code")
            {
            }
            column(EmploymentDate_EmployeeJournalLine;"Employee Journal Line"."Employment Date")
            {
            }
            column(OldEmploymentDate_EmployeeJournalLine;"Employee Journal Line"."Old Employment Date")
            {
            }
            column(JobTitleCode_EmployeeJournalLine;"Employee Journal Line"."Job Title Code")
            {
            }
            column(OldJobTitleCode_EmployeeJournalLine;"Employee Journal Line"."Old Job Title Code")
            {
            }
            column(SwapNo_EmployeeJournalLine;"Employee Journal Line"."Swap No.")
            {
            }
            column(SwapEmployeeNo_EmployeeJournalLine;"Employee Journal Line"."Swap Employee No.")
            {
            }
            column(SwapFromDate_EmployeeJournalLine;"Employee Journal Line"."Swap From Date")
            {
            }
            column(SwapToDate_EmployeeJournalLine;"Employee Journal Line"."Swap To Date")
            {
            }
            column(SwapFromWorkingShiftCode_EmployeeJournalLine;"Employee Journal Line"."Swap From Working Shift Code")
            {
            }
            column(SwapToWorkingShiftCode_EmployeeJournalLine;"Employee Journal Line"."Swap To Working Shift Code")
            {
            }
            column(SwapFromShiftGroupCode_EmployeeJournalLine;"Employee Journal Line"."Swap From Shift Group Code")
            {
            }
            column(SwapToShiftGroupCode_EmployeeJournalLine;"Employee Journal Line"."Swap To Shift Group Code")
            {
            }
            column(PensionSchemeNo_EmployeeJournalLine;"Employee Journal Line"."Pension Scheme No.")
            {
            }
            column(SalaryIncreaseAmount_EmployeeJournalLine;"Employee Journal Line"."Salary Increase % / Amount")
            {
            }
            column(SalaryIncreasePolicyDate_EmployeeJournalLine;"Employee Journal Line"."Salary Increase Policy Date")
            {
            }
            column(SalaryType_EmployeeJournalLine;"Employee Journal Line"."Salary Type")
            {
            }
            column(RelativeCode_EmployeeJournalLine;"Employee Journal Line"."Relative Code")
            {
            }
            column(Split_EmployeeJournalLine;"Employee Journal Line".Split)
            {
            }
            column(PayrollGroupCode_EmployeeJournalLine;"Employee Journal Line"."Payroll Group Code")
            {
            }
            column(PayFrequency_EmployeeJournalLine;"Employee Journal Line"."Pay Frequency")
            {
            }
            column(RoomType_EmployeeJournalLine;"Employee Journal Line"."Room Type")
            {
            }
            column(RoomNo_EmployeeJournalLine;"Employee Journal Line"."Room No.")
            {
            }
            column(ExitRoom_EmployeeJournalLine;"Employee Journal Line"."Exit Room")
            {
            }
            column(CompanyOrganizationNo_EmployeeJournalLine;"Employee Journal Line"."Company Organization No.")
            {
            }
            column(OldCompanyOrganizationNo_EmployeeJournalLine;"Employee Journal Line"."Old Company Organization No.")
            {
            }
            column(InsuranceCode_EmployeeJournalLine;"Employee Journal Line"."Insurance Code")
            {
            }
            column(Reversed_EmployeeJournalLine;"Employee Journal Line".Reversed)
            {
            }
            column(ReversedEntryNo_EmployeeJournalLine;"Employee Journal Line"."Reversed Entry No.")
            {
            }
            column(SwapToShortcutDim1Code_EmployeeJournalLine;"Employee Journal Line"."Swap To Shortcut Dim 1 Code")
            {
            }
            column(SwapToShortcutDim2Code_EmployeeJournalLine;"Employee Journal Line"."Swap To Shortcut Dim 2 Code")
            {
            }
            column(SwapToBaseCalendarCode_EmployeeJournalLine;"Employee Journal Line"."Swap To Base Calendar Code")
            {
            }
            column(BaseCalendarCode_EmployeeJournalLine;"Employee Journal Line"."Base Calendar Code")
            {
            }
            column(WTREntryNo_EmployeeJournalLine;"Employee Journal Line"."WTR Entry No.")
            {
            }
            column(RoundingofCalculatedValue_EmployeeJournalLine;"Employee Journal Line"."Rounding of Calculated Value")
            {
            }
            column(RoundingAddition_EmployeeJournalLine;"Employee Journal Line"."Rounding Addition")
            {
            }
            column(SystemInsert_EmployeeJournalLine;"Employee Journal Line"."System Insert")
            {
            }
            column(SupplementPeriod_EmployeeJournalLine;"Employee Journal Line"."Supplement Period")
            {
            }
            column(benifit;benifit)
            {
            }
            column(deduct;deduct)
            {
            }
            column(EmpFilter;EmpFilter)
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(transType;transType)
            {
            }
            column(TransDesc;TransDesc)
            {
            }

            trigger OnAfterGetRecord();
            begin
                EmpFilter := GETFILTER("Employee No.");
                if EmpFilter <> '' then begin
                  employee.SETRANGE("No.",EmpFilter);
                  if employee.FINDFIRST then
                    EmpName := employee."Full Name";
                  end;
                if CauseOfAbs <> '' then
                 SETFILTER("Transaction Type",CauseOfAbs);
                if transType <> '' then
                  SETFILTER(Type,transType);
                SETFILTER("Employee Journal Line".Type,'BENEFIT|DEDUCTIONS');
                SETFILTER("Employee Journal Line"."Document Status",FORMAT(Status));
                if (FromDate <> 0D) and (ToDate <> 0D) then
                  SETRANGE("Transaction Date",FromDate,ToDate);
                if FromDate = 0D then
                  ERROR('You have to set the Date Filter');
                if ToDate = 0D then
                  SETRANGE("Transaction Date",FromDate,TODAY);
                /*IF CauseOfAbs <> '' THEN BEGIN
                  IF "Employee Journal Line"."Cause of Absence Code" <> CauseOfAbs THEN
                    CurrReport.SKIP;
                  END;*/
                if "Transaction Date" < FromDate then
                  CurrReport.SKIP;
                  if (Type <> 'BENEFIT') and (Type <> 'DEDUCTIONS') then
                    CurrReport.SKIP;
                  if Type = 'BENEFIT' then begin
                    benifit := "Employee Journal Line".Value;
                    deduct := 0;
                    Totalben += benifit;
                    end
                 else if Type = 'DEDUCTIONS' then begin
                    deduct := (-1)*"Employee Journal Line".Value;
                    benifit := 0;
                    Totalded += deduct;
                    end;
                CLEAR(HRTransType);
                HRTransType.SETRANGE(Code,"Transaction Type");
                if HRTransType.FINDFIRST then
                TransDesc := HRTransType.Description;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Requested)
                {
                    Caption = 'Requested';
                    field(Status;Status)
                    {
                        Caption = 'Document Status';
                        ApplicationArea=All;
                    }
                    field(CauseOfAbs;CauseOfAbs)
                    {
                        Caption = 'Tran. Type';
                        TableRelation = "HR Transaction Types".Code WHERE (System=CONST(false));
                        ApplicationArea=All;
                    }
                    field(FromDate;FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea=All;
                        //DateFormula = true;
                    }
                    field(ToDate;ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea=All;
                    }
                    field(transType;transType)
                    {
                        Caption = 'Type';
                        TableRelation = "HR System Code" WHERE ("Code"=FILTER('BENEFIT'|'DEDUCTIONS'));
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
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM +
        if  PayrollFunction.HideSalaryFields() = true then
           ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 13.05.2016 : AIM -
    end;

    var
        Status : Option Approved,Released,Opened;
        CauseOfAbs : Code[20];
        FromDate : Date;
        ToDate : Date;
        SumBenifit : Decimal;
        SumDeduction : Decimal;
        predate : Date;
        benifit : Decimal;
        deduct : Decimal;
        Totalded : Decimal;
        Totalben : Decimal;
        EmpFilter : Text[30];
        EmpName : Text[50];
        employee : Record Employee;
        transType : Code[20];
        HRTransType : Record "HR Transaction Types";
        TransDesc : Text;
        PayrollFunction : Codeunit "Payroll Functions";
}

