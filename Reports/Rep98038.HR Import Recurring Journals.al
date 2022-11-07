report 98038 "HR Import Recurring Journals"
{
    // version SHR1.0,EDM.HRPY1

    Caption = 'Import Recurring Payroll Journals';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = SORTING("No.") WHERE(Status=CONST(Active));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin

                HRTransTypeTBT.SETRANGE(HRTransTypeTBT.Recurring ,true);
                HRTransTypeTBT.SETFILTER(HRTransTypeTBT.Type,'<>%1','ABSENCE');

                if HRTransType <> '' then
                   HRTransTypeTBT.SETRANGE(HRTransTypeTBT.Code,HRTransType);
                if HRTransTypeTBT.FINDFIRST() then
                   repeat
                           if Employee."Payroll Group Code" = PayrollGroup then
                    PayrollFunctions.ImportRecurringPayrollJournalsFromPreviousPeriod(PayrollGroup,Employee."No.",HRTransTypeTBT.Code,
                                                                                      CheckRecurringInJournals,FDate,TDate,JournalDate,UpdateExisting,AutoApprove);
                   until HRTransTypeTBT.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control2)
                {
                    field(HRTransType;HRTransType)
                    {
                        Caption = 'HR Transaction Type';
                        TableRelation = "HR Transaction Types" WHERE (Recurring=CONST(true));
                        ApplicationArea=All;
                    }
                    field(FDate;FDate)
                    {
                        Caption = 'Import From Date';
                        ApplicationArea=All;
                    }
                    field(TDate;TDate)
                    {
                        Caption = 'Import Till Date';
                        ApplicationArea=All;
                    }
                    field(PayrollGroup;PayrollGroup)
                    {
                        Caption = 'Payroll Group';
                        TableRelation = "HR Payroll Group".Code;
                        ApplicationArea=All;

                        trigger OnValidate();
                        begin
                            if PayrollGroup <> '' then
                              begin
                                  PayStatus.GET(PayrollGroup);
                                  JournalDate := PayrollFunctions.GetNextPayrollDate(PayStatus."Payroll Group Code",PayStatus."Pay Frequency");
                               end
                            else
                             JournalDate := 0D;
                        end;
                    }
                    field(JournalDate;JournalDate)
                    {
                        Caption = 'New Journal Date';
                        ApplicationArea=All;
                    }
                    field(UpdateExisting;UpdateExisting)
                    {
                        Caption = 'Update Existing Data';
                        ApplicationArea=All;
                    }
                    field("Auto Approve";AutoApprove)
                    {
                        ApplicationArea=All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            UpdateExisting := false;
            // 15.03.2017 : AIM +
            if DATE2DMY(WORKDATE,2) <> 1 then
            begin
               FDate := DMY2DATE(1,DATE2DMY(WORKDATE,2) - 1 ,DATE2DMY(WORKDATE,3)) ;
               TDate := DMY2DATE(PayrollFunctions.GetLastDayinMonth(FDate) ,DATE2DMY(WORKDATE,2) - 1,DATE2DMY(WORKDATE,3));
            end
            else begin
                //Modified to fix DEC-YY and JAN-YY+1 - 23.01.2019 : AIM +
                //FDate := DMY2DATE(1,DATE2DMY(WORKDATE,2) - 1 ,DATE2DMY(WORKDATE,3) - 1);
                //TDate := DMY2DATE(PayrollFunctions.GetLastDayinMonth(FDate) ,DATE2DMY(WORKDATE,2) - 1,DATE2DMY(WORKDATE,3)-1);
                FDate := DMY2DATE(1,12 ,DATE2DMY(WORKDATE,3) - 1);
                TDate := DMY2DATE(PayrollFunctions.GetLastDayinMonth(FDate) ,12,DATE2DMY(WORKDATE,3)-1);
                //Modified to fix DEC-YY and JAN-YY+1 - 23.01.2019 : AIM -
            end;
            JournalDate := DMY2DATE(PayrollFunctions.GetLastDayinMonth(WORKDATE) ,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
            // 15.03.2017 : AIM -
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        //Added in order to show/ Hide salary fields - 14.09.2016 : AIM +
        if  PayrollFunctions.HideSalaryFields() = true then
            ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 14.09.2016 : AIM -
    end;

    trigger OnPreReport();
    begin
        if (FDate = 0D ) or (TDate = 0D) then
          ERROR('Specify Date Interval to import from!!');

        if (PayrollGroup = '') then
          ERROR('Specify Payroll Group');

        if (JournalDate = 0D) then
          ERROR('Specify Journals Date');

        if UpdateExisting = true then
          if CONFIRM('Are you sure you want to update existing records?',false) = false then
            UpdateExisting := false ;
    end;

    var
        Window : Dialog;
        HRTransType : Code[20];
        PayrollFunctions : Codeunit "Payroll Functions";
        EmpNo : Code[20];
        CheckRecurringInJournals : Boolean;
        HRTransTypeTBT : Record "HR Transaction Types";
        FDate : Date;
        TDate : Date;
        PayrollGroup : Code[10];
        JournalDate : Date;
        PayStatus : Record "Payroll Status";
        UpdateExisting : Boolean;
        AutoApprove : Boolean;
}

