report 98093 "Gen. Atten. Job Jrnl By Proj."
{
    // version EDM.HRPY2

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {

            trigger OnAfterGetRecord();
            begin
                if Employee."Resource No." = '' then
                  ResourceNo := HRSetup."Def. Job Resource No."
                else
                  ResourceNo := Employee."Resource No.";
                HourlyRate := ROUND(GetEmployeeHourlyRate);
                EmpAttendanceDim.RESET;
                EmpAttendanceDim.SETFILTER("Attendance Date",'>=%1',FromDate);
                EmpAttendanceDim.SETFILTER("Attendance Date",'<=%1',ToDate);
                EmpAttendanceDim.SETRANGE("Employee No",Employee."No.");
                if EmpAttendanceDim.FINDFIRST then
                repeat
                  JobNo := EmpAttendanceDim."Job No.";
                  JobJnlLine.RESET;
                  JobJnlLine.SETRANGE("Posting Date",EmpAttendanceDim."Attendance Date");
                  JobJnlLine.SETRANGE("Job No.",JobNo);
                  JobJnlLine.SETRANGE("Job Task No.",EmpAttendanceDim."Job Task No.");
                  JobJnlLine.SETRANGE("No.",ResourceNo);
                  JobJnlLine.SETRANGE("Unit Price",HourlyRate);
                  if not JobJnlLine.FINDFIRST then
                  begin
                    CLEAR(JobJnlLine);
                    JobJnlLine.INIT;
                    JobJnlLine.VALIDATE("Journal Template Name",HRSetup."Job Journal Template");
                    JobJnlLine.VALIDATE("Journal Batch Name",HRSetup."Job Journal Batch");
                    LineNo += 10000;
                    JobJnlLine.VALIDATE("Line No.",LineNo);
                    JobJnlLine.VALIDATE("Line Type",HRSetup."Job Line Type");
                    JobJnlLine.VALIDATE("Posting Date",EmpAttendanceDim."Attendance Date");
                    JobJnlLine.VALIDATE("Document No.",FORMAT(JobJnlLine."Posting Date",9,'D<Year4><Month,2><Day,2>'));
                    JobJnlLine.VALIDATE("Job No.",JobNo);
                    JobJnlLine.VALIDATE("Job Task No.",EmpAttendanceDim."Job Task No.");
                    JobJnlLine.VALIDATE(Type,JobJnlLine.Type::Resource);
                    //IF EmployeeRec.GET(EmpAttendanceDim."Employee No") THEN
                    //  IF EmployeeRec."Resource No." = '' THEN
                    //    JobJnlLine.VALIDATE("No.",HRSetup."Def. Job Resource No.")
                    //  ELSE
                    //    JobJnlLine.VALIDATE("No.",EmployeeRec."Resource No.");
                    JobJnlLine.VALIDATE("No.",ResourceNo);
                    JobJnlLine.VALIDATE("Unit Cost",HourlyRate);
                    JobJnlLine.VALIDATE("Unit Price",HourlyRate);
                    DimensionNo := PayrollFunctions.GetShortcutDimensionNoFromName('PROJECT');
                    case DimensionNo of
                      0:
                        ;
                      1:
                        JobJnlLine.VALIDATE("Shortcut Dimension 1 Code",JobNo);
                      2:
                        JobJnlLine.VALIDATE("Shortcut Dimension 2 Code",JobNo);
                      else
                        ERROR(ProjectDimensionGlobal);
                    end;
                    DimensionNo := PayrollFunctions.GetShortcutDimensionNoFromName('SOURCE');
                    SourceCode := HRSetup."Job Source Code";
                    case DimensionNo of
                      0:
                        ;
                      1:
                        JobJnlLine.VALIDATE("Shortcut Dimension 1 Code",SourceCode);
                      2:
                        JobJnlLine.VALIDATE("Shortcut Dimension 2 Code",SourceCode);
                      3:
                        DimMgt.ValidateShortcutDimValues(3,SourceCode,JobJnlLine."Dimension Set ID");
                      4:
                        DimMgt.ValidateShortcutDimValues(4,SourceCode,JobJnlLine."Dimension Set ID");
                      5:
                        DimMgt.ValidateShortcutDimValues(5,SourceCode,JobJnlLine."Dimension Set ID");
                      6:
                        DimMgt.ValidateShortcutDimValues(6,SourceCode,JobJnlLine."Dimension Set ID");
                      7:
                        DimMgt.ValidateShortcutDimValues(7,SourceCode,JobJnlLine."Dimension Set ID");
                      8:
                        DimMgt.ValidateShortcutDimValues(8,SourceCode,JobJnlLine."Dimension Set ID");
                    end;
                    JobJnlLine.VALIDATE("Gen. Bus. Posting Group",HRSetup."Def. Gen. Bus. Posting Group");
                    JobJnlLine.VALIDATE("Gen. Prod. Posting Group",HRSetup."Def. Gen. Prod. Posting Group");
                    JobJnlLine.INSERT(true);
                  end;
                  JobJnlLine.VALIDATE(Quantity,JobJnlLine.Quantity + EmpAttendanceDim."Attended Hrs");
                  JobJnlLine.MODIFY;
                until EmpAttendanceDim.NEXT = 0;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE('Process Done');
            end;

            trigger OnPreDataItem();
            begin
                HRSetup.GET;
                HRSetup.TESTFIELD("Job Journal Template");
                HRSetup.TESTFIELD("Job Journal Batch");
                HRSetup.TESTFIELD("Job Source Code");
                HRSetup.TESTFIELD("Def. Job Resource No.");
                HRSetup.TESTFIELD("Job Resource UOM");
                HRSetup.TESTFIELD("Def. Gen. Bus. Posting Group");
                HRSetup.TESTFIELD("Def. Gen. Prod. Posting Group");

                JobJnlLine.RESET;
                JobJnlLine.SETRANGE("Journal Template Name",HRSetup."Job Journal Template");
                JobJnlLine.SETRANGE("Journal Batch Name",HRSetup."Job Journal Batch");
                if JobJnlLine.FINDLAST then
                  if CONFIRM('Job Journal Batch "' + HRSetup."Job Journal Batch" + '" already has records.\\Are you sure you want to continue?',false) then
                    LineNo := JobJnlLine."Line No."
                  else
                    CurrReport.QUIT;

                //JobJnlBatch.GET(HRSetup."Job Journal Template",HRSetup."Job Journal Batch");
                //DocumentNo := NoSeriesMgt.TryGetNextNo(JobJnlBatch."No. Series","Posting Date");

                if FromDate = 0D then
                  ERROR('From Date must be specified.');
                if ToDate = 0D then
                  ERROR('To Date must be specified.');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FromDate;FromDate)
                {
                    Caption = 'From Date';
                    ApplicationArea=All;
                }
                field(ToDate;ToDate)
                {
                    Caption = 'To Date';
                    ApplicationArea=All;
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

    var
        FromDate : Date;
        ToDate : Date;
        JobJnlLine : Record "Job Journal Line";
        HRSetup : Record "Human Resources Setup";
        LineNo : Integer;
        EmpAttendanceDim : Record "Employees Attendance Dimension";
        HourlyRate : Decimal;
        DocumentNo : Code[20];
        EmployeeRec : Record Employee;
        DimensionNo : Integer;
        PayrollFunctions : Codeunit "Payroll Functions";
        NoProjectDimension : Label 'Project dimension is not specified in the General Ledger Setup.';
        ProjectDimensionGlobal : Label 'Project dimension must be set as global dimension.';
        DimMgt : Codeunit DimensionManagement;
        JobNo : Code[20];
        SourceCode : Code[20];
        ResourceNo : Code[20];
        BasicType : Option BasicPay,SalaryACY,HourlyRate,FixedAmount;
        EmpTotal : Decimal;
        EmpCount : Integer;

    local procedure GetEmployeeHourlyRate() EmpHrRate : Decimal;
    var
        ResourceNo : Code[20];
        Employee2 : Record Employee;
    begin
        //IF Employee2.GET(EmployeeNo) THEN
          ResourceNo := Employee."Resource No.";

        Employee2.RESET;
        Employee2.COPYFILTERS(Employee);
        Employee2.SETRANGE("Resource No.",ResourceNo);
        if Employee2.FINDFIRST then
        begin
          if HRSetup."Job Hourly Rate Calculation" = HRSetup."Job Hourly Rate Calculation"::"Employee Rate" then
            EmpHrRate := EmployeeHourlyRate(Employee2."No.",Employee2."Hourly Rate")
          else if HRSetup."Job Hourly Rate Calculation" = HRSetup."Job Hourly Rate Calculation"::Average then begin
            repeat
              EmpTotal += EmployeeHourlyRate(Employee2."No.",Employee2."Hourly Rate");
              EmpCount += 1;
            until Employee2.NEXT = 0;
            EmpHrRate := EmpTotal/EmpCount;
          end;

          exit(EmpHrRate);
        end;

        exit(0);
    end;

    local procedure EmployeeHourlyRate(EmployeeNo : Code[20];EmpHourlyRate : Decimal) : Decimal;
    begin
        if (PayrollFunctions.IsScheduleUseEmployeeCardHourlyRate(EmployeeNo)) and (EmpHourlyRate > 0) then
            exit(PayrollFunctions.GetEmployeeBasicHourlyRate(EmployeeNo,'',BasicType::HourlyRate,0))
        else
            exit(PayrollFunctions.GetEmployeeBasicHourlyRate(EmployeeNo,'',BasicType::BasicPay,0));
    end;
}

