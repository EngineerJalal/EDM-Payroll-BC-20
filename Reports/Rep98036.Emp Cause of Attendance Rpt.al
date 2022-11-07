report 98036 "Emp. Cause of Attendance Rpt"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Emp. Cause of Attendance Rpt.rdlc';

    dataset
    {
        dataitem("Employee Journal Line";"Employee Journal Line")
        {
            RequestFilterFields = "Employee No.";
            column(TransactionType_EmployeeJournalLine;"Employee Journal Line"."Transaction Type")
            {
                ////IncludeCaption = true;
            }
            column(EmployeeNo_EmployeeJournalLine;"Employee Journal Line"."Employee No.")
            {
                //IncludeCaption = true;
            }
            column(EntryNo_EmployeeJournalLine;"Employee Journal Line"."Entry No.")
            {
                //IncludeCaption = true;
            }
            column(EmployeeStatus_EmployeeJournalLine;"Employee Journal Line"."Employee Status")
            {
                //IncludeCaption = true;
            }
            column(DocumentStatus_EmployeeJournalLine;"Employee Journal Line"."Document Status")
            {
                //IncludeCaption = true;
            }
            column(OpenedBy_EmployeeJournalLine;"Employee Journal Line"."Opened By")
            {
                //IncludeCaption = true;
            }
            column(OpenedDate_EmployeeJournalLine;"Employee Journal Line"."Opened Date")
            {
                //IncludeCaption = true;
            }
            column(ReleasedBy_EmployeeJournalLine;"Employee Journal Line"."Released By")
            {
                //IncludeCaption = true;
            }
            column(ReleasedDate_EmployeeJournalLine;"Employee Journal Line"."Released Date")
            {
                //IncludeCaption = true;
            }
            column(ApprovedBy_EmployeeJournalLine;"Employee Journal Line"."Approved By")
            {
                //IncludeCaption = true;
            }
            column(ApprovedDate_EmployeeJournalLine;"Employee Journal Line"."Approved Date")
            {
                //IncludeCaption = true;
            }
            column(StartingDate_EmployeeJournalLine;"Employee Journal Line"."Starting Date")
            {
                //IncludeCaption = true;
            }
            column(Currency_EmployeeJournalLine;"Employee Journal Line".Currency)
            {
                //IncludeCaption = true;
            }
            column(Description_EmployeeJournalLine;"Employee Journal Line".Description)
            {
                //IncludeCaption = true;
            }
            column(MoreInformation_EmployeeJournalLine;"Employee Journal Line"."More Information")
            {
                //IncludeCaption = true;
            }
            column(Value_EmployeeJournalLine;"Employee Journal Line".Value)
            {
                //IncludeCaption = true;
            }
            column(ExamDate_EmployeeJournalLine;"Employee Journal Line"."Exam Date")
            {
                //IncludeCaption = true;
            }
            column(AbsencePhoneNo_EmployeeJournalLine;"Employee Journal Line"."Absence Phone No.")
            {
                //IncludeCaption = true;
            }
            column(AbsenceAddress_EmployeeJournalLine;"Employee Journal Line"."Absence Address")
            {
                //IncludeCaption = true;
            }
            column(TransactionDate_EmployeeJournalLine;"Employee Journal Line"."Transaction Date")
            {
                //IncludeCaption = true;
            }
            column(MedicalAllowanceGroup_EmployeeJournalLine;"Employee Journal Line"."Medical Allowance Group")
            {
                //IncludeCaption = true;
            }
            column(MedicalExamsCount_EmployeeJournalLine;"Employee Journal Line"."Medical Exams Count")
            {
                //IncludeCaption = true;
            }
            column(MedicalSubGroupFilter_EmployeeJournalLine;"Employee Journal Line"."Medical Sub Group Filter")
            {
                //IncludeCaption = true;
            }
            column(CauseofAbsenceCode_EmployeeJournalLine;"Employee Journal Line"."Cause of Absence Code")
            {
                //IncludeCaption = true;
            }
            column(ShortcutDimension1Code_EmployeeJournalLine;"Employee Journal Line"."Shortcut Dimension 1 Code")
            {
                //IncludeCaption = true;
            }
            column(ShortcutDimension2Code_EmployeeJournalLine;"Employee Journal Line"."Shortcut Dimension 2 Code")
            {
                //IncludeCaption = true;
            }
            column(EndingDate_EmployeeJournalLine;"Employee Journal Line"."Ending Date")
            {
                //IncludeCaption = true;
            }
            column(TrainingNo_EmployeeJournalLine;"Employee Journal Line"."Training No.")
            {
                //IncludeCaption = true;
            }
            column(EvaluationRate_EmployeeJournalLine;"Employee Journal Line"."Evaluation Rate")
            {
                //IncludeCaption = true;
            }
            column(FromTime_EmployeeJournalLine;"Employee Journal Line"."From Time")
            {
                //IncludeCaption = true;
            }
            column(ToTime_EmployeeJournalLine;"Employee Journal Line"."To Time")
            {
                //IncludeCaption = true;
            }
            column(UnitofMeasureCode_EmployeeJournalLine;"Employee Journal Line"."Unit of Measure Code")
            {
                //IncludeCaption = true;
            }
            column(Type_EmployeeJournalLine;"Employee Journal Line".Type)
            {
                //IncludeCaption = true;
            }
            column(JobPositionCode_EmployeeJournalLine;"Employee Journal Line"."Job Position Code")
            {
                //IncludeCaption = true;
            }
            column(OldEmployeeStatus_EmployeeJournalLine;"Employee Journal Line"."Old Employee Status")
            {
                //IncludeCaption = true;
            }
            column(OldShortcutDimension1Code_EmployeeJournalLine;"Employee Journal Line"."Old Shortcut Dimension 1 Code")
            {
                //IncludeCaption = true;
            }
            column(OldShortcutDimension2Code_EmployeeJournalLine;"Employee Journal Line"."Old Shortcut Dimension 2 Code")
            {
                //IncludeCaption = true;
            }
            column(OldJobPositionCode_EmployeeJournalLine;"Employee Journal Line"."Old Job Position Code")
            {
                //IncludeCaption = true;
            }
            column(PerformanceCode_EmployeeJournalLine;"Employee Journal Line"."Performance Code")
            {
                //IncludeCaption = true;
            }
            column(OldEmploymentType_EmployeeJournalLine;"Employee Journal Line"."Old Employment Type")
            {
                //IncludeCaption = true;
            }
            column(EmploymentTypeCode_EmployeeJournalLine;"Employee Journal Line"."Employment Type Code")
            {
                //IncludeCaption = true;
            }
            column(Converted_EmployeeJournalLine;"Employee Journal Line".Converted)
            {
                //IncludeCaption = true;
            }
            column(AffectWorkDays_EmployeeJournalLine;"Employee Journal Line"."Affect Work Days")
            {
                //IncludeCaption = true;
            }
            column(AffectAttendanceDays_EmployeeJournalLine;"Employee Journal Line"."Affect Attendance Days")
            {
                //IncludeCaption = true;
            }
            column(AbsenceTransactionType_EmployeeJournalLine;"Employee Journal Line"."Absence Transaction Type")
            {
                //IncludeCaption = true;
            }
            column(AssociatePayElement_EmployeeJournalLine;"Employee Journal Line"."Associate Pay Element")
            {
                //IncludeCaption = true;
            }
            column(Processed_EmployeeJournalLine;"Employee Journal Line".Processed)
            {
                //IncludeCaption = true;
            }
            column(HusbandParalysed_EmployeeJournalLine;"Employee Journal Line"."Husband Paralysed")
            {
                //IncludeCaption = true;
            }
            column(SpouseSecured_EmployeeJournalLine;"Employee Journal Line"."Spouse Secured")
            {
                //IncludeCaption = true;
            }
            column(NoofChildren_EmployeeJournalLine;"Employee Journal Line"."No of Children")
            {
                //IncludeCaption = true;
            }
            column(OldNoofChildren_EmployeeJournalLine;"Employee Journal Line"."Old No of Children")
            {
                //IncludeCaption = true;
            }
            column(SocialStatus_EmployeeJournalLine;"Employee Journal Line"."Social Status")
            {
                //IncludeCaption = true;
            }
            column(OldSocialStatus_EmployeeJournalLine;"Employee Journal Line"."Old Social Status")
            {
                //IncludeCaption = true;
            }
            column(CalculatedValue_EmployeeJournalLine;"Employee Journal Line"."Calculated Value")
            {
                //IncludeCaption = true;
            }
            column(OldBasicPay_EmployeeJournalLine;"Employee Journal Line"."Old Basic Pay")
            {
                //IncludeCaption = true;
            }
            column(OldAdditionalSalary_EmployeeJournalLine;"Employee Journal Line"."Old Additional Salary")
            {
                //IncludeCaption = true;
            }
            column(BasicPay_EmployeeJournalLine;"Employee Journal Line"."Basic Pay")
            {
                //IncludeCaption = true;
            }
            column(AdditionalSalary_EmployeeJournalLine;"Employee Journal Line"."Additional Salary")
            {
                //IncludeCaption = true;
            }
            column(Entitled_EmployeeJournalLine;"Employee Journal Line".Entitled)
            {
                //IncludeCaption = true;
            }
            column(Reseted_EmployeeJournalLine;"Employee Journal Line".Reseted)
            {
                //IncludeCaption = true;
            }
            column(EntitledValue_EmployeeJournalLine;"Employee Journal Line"."Entitled Value")
            {
                //IncludeCaption = true;
            }
            column(ResetedValue_EmployeeJournalLine;"Employee Journal Line"."Reseted Value")
            {
                //IncludeCaption = true;
            }
            column(ConvertedValue_EmployeeJournalLine;"Employee Journal Line"."Converted Value")
            {
                //IncludeCaption = true;
            }
            column(ProcessedDate_EmployeeJournalLine;"Employee Journal Line"."Processed Date")
            {
                //IncludeCaption = true;
            }
            column(UnpaidPeriod_EmployeeJournalLine;"Employee Journal Line"."Unpaid Period")
            {
                //IncludeCaption = true;
            }
            column(PayrollLedgerEntryNo_EmployeeJournalLine;"Employee Journal Line"."Payroll Ledger Entry No.")
            {
                //IncludeCaption = true;
            }
            column(DayOff_EmployeeJournalLine;"Employee Journal Line"."Day-Off")
            {
                //IncludeCaption = true;
            }
            column(OldDeclared_EmployeeJournalLine;"Employee Journal Line"."Old Declared")
            {
                //IncludeCaption = true;
            }
            column(OldForeigner_EmployeeJournalLine;"Employee Journal Line"."Old Foreigner")
            {
                //IncludeCaption = true;
            }
            column(OldEmployeeCategoryCode_EmployeeJournalLine;"Employee Journal Line"."Old Employee Category Code")
            {
                //IncludeCaption = true;
            }
            column(Declared_EmployeeJournalLine;"Employee Journal Line".Declared)
            {
                //IncludeCaption = true;
            }
            column(Foreigner_EmployeeJournalLine;"Employee Journal Line".Foreigner)
            {
                //IncludeCaption = true;
            }
            column(EmployeeCategoryCode_EmployeeJournalLine;"Employee Journal Line"."Employee Category Code")
            {
                //IncludeCaption = true;
            }
            column(EmploymentDate_EmployeeJournalLine;"Employee Journal Line"."Employment Date")
            {
                //IncludeCaption = true;
            }
            column(OldEmploymentDate_EmployeeJournalLine;"Employee Journal Line"."Old Employment Date")
            {
                //IncludeCaption = true;
            }
            column(JobTitleCode_EmployeeJournalLine;"Employee Journal Line"."Job Title Code")
            {
                //IncludeCaption = true;
            }
            column(OldJobTitleCode_EmployeeJournalLine;"Employee Journal Line"."Old Job Title Code")
            {
                //IncludeCaption = true;
            }
            column(SwapNo_EmployeeJournalLine;"Employee Journal Line"."Swap No.")
            {
                //IncludeCaption = true;
            }
            column(SwapEmployeeNo_EmployeeJournalLine;"Employee Journal Line"."Swap Employee No.")
            {
                //IncludeCaption = true;
            }
            column(SwapFromDate_EmployeeJournalLine;"Employee Journal Line"."Swap From Date")
            {
                //IncludeCaption = true;
            }
            column(SwapToDate_EmployeeJournalLine;"Employee Journal Line"."Swap To Date")
            {
                //IncludeCaption = true;
            }
            column(SwapFromWorkingShiftCode_EmployeeJournalLine;"Employee Journal Line"."Swap From Working Shift Code")
            {
                //IncludeCaption = true;
            }
            column(SwapToWorkingShiftCode_EmployeeJournalLine;"Employee Journal Line"."Swap To Working Shift Code")
            {
                //IncludeCaption = true;
            }
            column(SwapFromShiftGroupCode_EmployeeJournalLine;"Employee Journal Line"."Swap From Shift Group Code")
            {
                //IncludeCaption = true;
            }
            column(SwapToShiftGroupCode_EmployeeJournalLine;"Employee Journal Line"."Swap To Shift Group Code")
            {
                //IncludeCaption = true;
            }
            column(PensionSchemeNo_EmployeeJournalLine;"Employee Journal Line"."Pension Scheme No.")
            {
                //IncludeCaption = true;
            }
            column(SalaryIncreaseAmount_EmployeeJournalLine;"Employee Journal Line"."Salary Increase % / Amount")
            {
                //IncludeCaption = true;
            }
            column(SalaryIncreasePolicyDate_EmployeeJournalLine;"Employee Journal Line"."Salary Increase Policy Date")
            {
                //IncludeCaption = true;
            }
            column(SalaryType_EmployeeJournalLine;"Employee Journal Line"."Salary Type")
            {
                //IncludeCaption = true;
            }
            column(RelativeCode_EmployeeJournalLine;"Employee Journal Line"."Relative Code")
            {
                //IncludeCaption = true;
            }
            column(Split_EmployeeJournalLine;"Employee Journal Line".Split)
            {
                //IncludeCaption = true;
            }
            column(PayrollGroupCode_EmployeeJournalLine;"Employee Journal Line"."Payroll Group Code")
            {
                //IncludeCaption = true;
            }
            column(PayFrequency_EmployeeJournalLine;"Employee Journal Line"."Pay Frequency")
            {
                //IncludeCaption = true;
            }
            column(RoomType_EmployeeJournalLine;"Employee Journal Line"."Room Type")
            {
                //IncludeCaption = true;
            }
            column(RoomNo_EmployeeJournalLine;"Employee Journal Line"."Room No.")
            {
                //IncludeCaption = true;
            }
            column(ExitRoom_EmployeeJournalLine;"Employee Journal Line"."Exit Room")
            {
                //IncludeCaption = true;
            }
            column(CompanyOrganizationNo_EmployeeJournalLine;"Employee Journal Line"."Company Organization No.")
            {
                //IncludeCaption = true;
            }
            column(OldCompanyOrganizationNo_EmployeeJournalLine;"Employee Journal Line"."Old Company Organization No.")
            {
                //IncludeCaption = true;
            }
            column(InsuranceCode_EmployeeJournalLine;"Employee Journal Line"."Insurance Code")
            {
                //IncludeCaption = true;
            }
            column(Reversed_EmployeeJournalLine;"Employee Journal Line".Reversed)
            {
                //IncludeCaption = true;
            }
            column(ReversedEntryNo_EmployeeJournalLine;"Employee Journal Line"."Reversed Entry No.")
            {
                //IncludeCaption = true;
            }
            column(SwapToShortcutDim1Code_EmployeeJournalLine;"Employee Journal Line"."Swap To Shortcut Dim 1 Code")
            {
                //IncludeCaption = true;
            }
            column(SwapToShortcutDim2Code_EmployeeJournalLine;"Employee Journal Line"."Swap To Shortcut Dim 2 Code")
            {
                //IncludeCaption = true;
            }
            column(SwapToBaseCalendarCode_EmployeeJournalLine;"Employee Journal Line"."Swap To Base Calendar Code")
            {
                //IncludeCaption = true;
            }
            column(BaseCalendarCode_EmployeeJournalLine;"Employee Journal Line"."Base Calendar Code")
            {
                //IncludeCaption = true;
            }
            column(WTREntryNo_EmployeeJournalLine;"Employee Journal Line"."WTR Entry No.")
            {
                //IncludeCaption = true;
            }
            column(RoundingofCalculatedValue_EmployeeJournalLine;"Employee Journal Line"."Rounding of Calculated Value")
            {
                //IncludeCaption = true;
            }
            column(RoundingAddition_EmployeeJournalLine;"Employee Journal Line"."Rounding Addition")
            {
                //IncludeCaption = true;
            }
            column(SystemInsert_EmployeeJournalLine;"Employee Journal Line"."System Insert")
            {
                //IncludeCaption = true;
            }
            column(SupplementPeriod_EmployeeJournalLine;"Employee Journal Line"."Supplement Period")
            {
                //IncludeCaption = true;
            }
            column(FilterStat;Status)
            {
            }
            column(FilterCOA;FilterCOA)
            {
            }
            column(FDateFilter;FromDate)
            {
            }
            column(TDateFilter;TDateFilter)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if "Employee Journal Line"."Cause of Absence Code" = '' then
                  CurrReport.SKIP;
                SETFILTER("Employee Journal Line"."Transaction Type",'ABS');
                SETFILTER("Document Status",FORMAT(Status));
                if (FromDate <> 0D) and (ToDate <> 0D) then
                  SETRANGE("Transaction Date",FromDate,ToDate);
                if FromDate = 0D then
                  ERROR('You have to set the Date Filter');
                if ToDate = 0D then begin
                  SETRANGE("Transaction Date",FromDate,TODAY);
                  //ToDate := TODAY;
                  end;
                if CauseOfAbs <> '' then begin
                  if "Employee Journal Line"."Cause of Absence Code" <> CauseOfAbs then
                    CurrReport.SKIP;
                  end;
                if "Transaction Date" < FromDate then
                  CurrReport.SKIP;
                /*IF CauseOfAbs = '' THEN
                  CauseOfAbs := 'All';*/

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
                        Caption = 'Cause Of Absence';
                        TableRelation = "Cause of Absence".Code;
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
        if ToDate = 0D then
          TDateFilter := TODAY
        else
          TDateFilter := ToDate;
        if CauseOfAbs = '' then
          FilterCOA := 'All'
        else
          FilterCOA := CauseOfAbs;
    end;

    var
        Status : Option Approved,Released,Opened;
        CauseOfAbs : Code[20];
        FromDate : Date;
        ToDate : Date;
        FilterStat : Text[30];
        FilterCOA : Text[30];
        FDateFilter : Text[30];
        TDateFilter : Date;
}

