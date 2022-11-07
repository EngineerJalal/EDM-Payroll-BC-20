report 98035 "Generate Emp Absence Entitle"
{
    // version EDM.HRPY1

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                if AbsEntitlementCode = '' then
                  ERROR ('Enter Absence Entitlement Code') ;
                
                //Modified in order to generate entitlement on yearly basis or employment basis - 17.01.2017 : AIM +
                /*IF Fdate = 0D THEN
                  ERROR('Enter From Date');
                
                IF TDate = 0D THEN
                  ERROR('Enter Till Date');
                PayrollFunctions.AutoGenerateEmpAbsenceEntitlementRecord( "No.",AbsEntitlementCode,Fdate,TDate);
                */
                if Opt = Opt::"Interval Basis" then
                  begin
                    if (Fdate = 0D)  or (TDate = 0D) then
                       ERROR('Specify a valid Date Interval');
                
                    PayrollFunctions.AutoGenerateEmpAbsenceEntitlementRecord( "No.",AbsEntitlementCode,Fdate,TDate)
                  end
                else if Opt = Opt::"Employment Basis" then
                  begin
                    if (Fdate = 0D)  or (TDate = 0D) then
                       ERROR('Specify a valid Year Interval');
                    if (DATE2DMY(Fdate,1) <> 1) and (DATE2DMY(Fdate,2) <> 1) and (DATE2DMY(TDate,1) <> 31) and (DATE2DMY(TDate,2) <> 12) and (DATE2DMY(Fdate,3) <> DATE2DMY(TDate,3)) then
                       ERROR ('The date interval should cover a whole year');
                    PayrollFunctions.AutoGenerateEmpAbsenceEntitlementRecordAdvanced("No.",AbsEntitlementCode,DATE2DMY(Fdate,3),EntitleType::EmploymentBasis,false);
                  end
                else if Opt = Opt::"Yearly Basis" then
                  begin
                    if (Fdate = 0D)  or (TDate = 0D) then
                       ERROR('Specify a valid Year Interval');
                    if (DATE2DMY(Fdate,1) <> 1) and (DATE2DMY(Fdate,2) <> 1) and (DATE2DMY(TDate,1) <> 31) and (DATE2DMY(TDate,2) <> 12) and (DATE2DMY(Fdate,3) <> DATE2DMY(TDate,3)) then
                       ERROR ('The date interval should cover a whole year');
                    PayrollFunctions.AutoGenerateEmpAbsenceEntitlementRecordAdvanced("No.",AbsEntitlementCode,DATE2DMY(Fdate,3) ,EntitleType::YearlyBasis,false);
                  end;
                
                //Modified in order to generate entitlement on yearly basis or employment basis - 17.01.2017 : AIM -

            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Control2)
                {
                    field(AbsenceEntitlementCode;AbsEntitlementCode)
                    {
                        Caption = 'Absence Entitlement Code';
                        TableRelation = "Cause of Absence".Code WHERE ("Not Use"=FILTER(false));
                        Visible = true;
                        ApplicationArea=All;
                    }
                    field("Generation Type";Opt)
                    {
                        OptionCaption = 'Interval Basis,Yearly Basis,Employment Basis';
                        Visible = false;
                        ApplicationArea=All;

                        trigger OnValidate();
                        begin
                            /*IF Opt <> Opt::"Interval Basis" THEN
                              ShowDates := FALSE
                            ELSE
                              ShowDates := TRUE;
                              */
                            RequestOptionsPage.UPDATE;

                        end;
                    }
                    field(FromDate;Fdate)
                    {
                        Caption = 'From Date';
                        Visible = ShowDates;
                        ApplicationArea=All;

                        trigger OnValidate();
                        begin
                            if Fdate <> 0D then
                              TDate := CALCDATE('1Y',Fdate) - 1
                            else
                              TDate := 0D;
                        end;
                    }
                    field(ToDate;TDate)
                    {
                        Caption = 'Till Date';
                        Visible = ShowDates;
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
            ShowDates := true;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin

        //Added in order to assign defaut values - 09.04.2016 : AIM +
        Fdate := DMY2DATE(1,1,DATE2DMY(WORKDATE,3));
        TDate := DMY2DATE(31,12,DATE2DMY(WORKDATE,3));
        //Added in order to assign defaut values - 09.04.2016 : AIM -

        HRSetup.GET();
        if HRSetup."Entitlement Generation Type" = HRSetup."Entitlement Generation Type"::"Employment Basis" then
          Opt := Opt::"Employment Basis"
        else if HRSetup."Entitlement Generation Type" = HRSetup."Entitlement Generation Type"::"Interval Basis" then
          Opt := Opt::"Interval Basis"
        else if HRSetup."Entitlement Generation Type" = HRSetup."Entitlement Generation Type"::"Yearly Basis" then
          Opt := Opt::"Yearly Basis";
    end;

    var
        AbsEntitlementCode : Code[10];
        Fdate : Date;
        TDate : Date;
        PayrollFunctions : Codeunit "Payroll Functions";
        [InDataSet]
        ShowDates : Boolean;
        Opt : Option "Interval Basis","Yearly Basis","Employment Basis";
        EntitleType : Option YearlyBasis,EmploymentBasis;
        HRSetup : Record "Human Resources Setup";
}

