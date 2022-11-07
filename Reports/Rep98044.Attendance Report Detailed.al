report 98044 "Attendance Report - Detailed"
{
    // version EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Report - Detailed.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(EmployeeNo;Employee."No.")
            {
            }
            column(EmployeeName;Employee.FullName)
            {
            }
            column(CompanyLogo;CompanyInfo.Picture)
            {
            }
            column(CompanyAddress1;CompanyAddress[1])
            {
            }
            column(CompanyAddress2;CompanyAddress[2])
            {
            }
            column(CompanyAddress3;CompanyAddress[3])
            {
            }
            column(CompanyAddress4;CompanyAddress[4])
            {
            }
            column(CompanyAddress5;CompanyAddress[5])
            {
            }
            column(CompanyAddress6;CompanyAddress[6])
            {
            }
            column(StartDate;StartDate)
            {
            }
            column(EndDate;EndDate)
            {
            }
            dataitem("Employee Absence";"Employee Absence")
            {
                DataItemLink = "Employee No."=FIELD("No.");
                RequestFilterFields = "Employment Type Code";
                column(RequiredHrs_EmployeeAbsence;"Employee Absence"."Required Hrs")
                {
                }
                column(AttendHrs_EmployeeAbsence;"Employee Absence"."Attend Hrs.")
                {
                }
                column(LateArrive_EmployeeAbsence;"Employee Absence"."Late Arrive")
                {
                }
                column(EarlyLeave_EmployeeAbsence;"Employee Absence"."Early Leave")
                {
                }
                column(EarlyArrive_EmployeeAbsence;"Employee Absence"."Early Arrive")
                {
                }
                column(LateLeave_EmployeeAbsence;"Employee Absence"."Late Leave")
                {
                }
                column(ShiftCode_EmployeeAbsence;"Employee Absence"."Shift Code")
                {
                }
                column(Remarks_EmployeeAbsence;"Employee Absence".Remarks)
                {
                }
                column(AttendanceDate_EmployeeAbsence;"Employee Absence"."From Date")
                {
                }
                column(ActualAttendHrs_EmployeeAbsence;"Employee Absence"."Actual Attend Hrs")
                {
                }
                column(Actual_Late_Arrive;"Actual Late Arrive")
                {
                }
                column(FisrtPunch;FisrtPunch)
                {
                }
                column(FirstPunchTime;FirstPunchTime)
                {
                }
                column(FirstPunchDate;FirstPunchDate)
                {
                }
                column(LastPunch;LastPunch)
                {
                }
                column(LastPunchTime;LastPunchTime)
                {
                }
                column(LastPunchDate;LastPunchDate)
                {
                }
                column(TotOT;TotOT)
                {
                }
                column(AprovedOT;AprovedOT)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    AprovedOT := "Attend Hrs." - "Required Hrs";
                    TotOT  := "Actual Attend Hrs" - "Required Hrs";

                    if AprovedOT < 0 then
                      AprovedOT := 0;
                    if TotOT  < 0 then
                      TotOT  := 0;

                    FisrtPunch := '';
                    FirstPunchDate := 0D;
                    FirstPunchTime := 0T;

                    LastPunch := '';
                    LastPunchDate := 0D;
                    LastPunchTime := 0T;

                    HandPunch.RESET;

                    HandPunch.SETFILTER("Attendnace No.",'%1',"Attendance No.");
                    //Modified in order to filter as per Scheduled Date - 04.08.2016 : AIM +
                    //HandPunch.SETFILTER("Real Date",'%1',"From Date");
                    HandPunch.SETFILTER(HandPunch."Scheduled Date",'%1',"From Date");
                    //Modified in order to filter as per Scheduled Date - 04.08.2016 : AIM -

                    if HandPunch.FINDSET then begin
                      IsFirstHandPunch := true;

                      repeat
                        if IsFirstHandPunch then begin
                          FisrtPunch := HandPunch."Action Type";
                          FirstPunchDate := HandPunch."Real Date";
                          FirstPunchTime := HandPunch."Real Time";

                          IsFirstHandPunch := false;
                        end
                        else begin
                          LastPunch := HandPunch."Action Type";
                          LastPunchDate := HandPunch."Real Date";
                          LastPunchTime := HandPunch."Real Time";
                        end
                      until HandPunch.NEXT = 0;
                    end;
                end;

                trigger OnPreDataItem();
                begin

                    SETRANGE("From Date",StartDate,EndDate);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate;StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea=All;
                    }
                    field(EndDate;EndDate)
                    {
                        Caption = 'End Date';
                        NotBlank = false;
                        ApplicationArea=All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin

            EndDate := WORKDATE;
        end;
    }

    labels
    {
        EmpCodeNo_lbl = 'Emp No #';EmpName_lbl = 'Emp Name';PunchIn_lbl = 'Punch In';PunchInTime_lbl = 'Punch In Time';PunchInDate_lbl = 'Punch In Date';PunchOut_lbl = 'Punch Out';PunchOutTime_lbl = 'Punch Out Time';PunchOutDate_lbl = 'Punch Out Date';ReqWH_lbl = 'Req. WH';AcctWH_lbl = 'Attended Hrs';Diff_lbl = 'Diff.';LateArr_lbl = 'Late Arr.';EarlyArr_lbl = 'Early Arr.';LateLeave_lbl = 'Late Leave';EarlyLeave_lbl = 'Early Leave';TotOT_lbl = 'TOT OT';ApprovedOT_lbl = 'Approved OT';StartDate_lbl = 'Start Date';EndDate_lbl = 'End Date';ShiftCode_lbl = 'Shift Code';Remarks_lbl = 'Remarks';AttendanceDate_lbl = 'Attendance Date';ActualAttendedHrs_lbl = 'Actual Attended Hrs';}

    trigger OnPreReport();
    begin

        if (StartDate = 0D) or (EndDate = 0D) then
          ERROR(BlankStartEndDateErr);

        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        FormatAddress.Company(CompanyAddress,CompanyInfo);
    end;

    var
        HandPunch : Record "Hand Punch";
        FisrtPunch : Text;
        FirstPunchDate : Date;
        FirstPunchTime : Time;
        LastPunch : Text;
        LastPunchDate : Date;
        LastPunchTime : Time;
        IsFirstHandPunch : Boolean;
        StartDate : Date;
        EndDate : Date;
        BlankStartEndDateErr : Label 'Starting date and ending date must be defined.';
        TotOT : Decimal;
        AprovedOT : Decimal;
        CompanyInfo : Record "Company Information";
        FormatAddress : Codeunit "Format Address";
        CompanyAddress : array [8] of Text;
}

