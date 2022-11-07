report 98071 "NSSF Yearly Declaration Report"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/NSSF Yearly Declaration Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.";
            column(No_Employee;Employee."No.")
            {
            }
            column(A_EndOfService_January;A_EndOfService[1])
            {
            }
            column(A_EndOfService_February;A_EndOfService[2])
            {
            }
            column(A_EndOfService_March;A_EndOfService[3])
            {
            }
            column(A_EndOfService_April;A_EndOfService[4])
            {
            }
            column(A_EndOfService_May;A_EndOfService[5])
            {
            }
            column(A_EndOfService_June;A_EndOfService[6])
            {
            }
            column(A_EndOfService_July;A_EndOfService[7])
            {
            }
            column(A_EndOfService_August;A_EndOfService[8])
            {
            }
            column(A_EndOfService_September;A_EndOfService[9])
            {
            }
            column(A_EndOfService_October;A_EndOfService[10])
            {
            }
            column(A_EndOfService_November;A_EndOfService[11])
            {
            }
            column(A_EndOfService_December;A_EndOfService[12])
            {
            }
            column(B_FamilyCompensation_January;B_FamilyCompensation[1])
            {
            }
            column(B_FamilyCompensation_February;B_FamilyCompensation[2])
            {
            }
            column(B_FamilyCompensation_March;B_FamilyCompensation[3])
            {
            }
            column(B_FamilyCompensation_April;B_FamilyCompensation[4])
            {
            }
            column(B_FamilyCompensation_May;B_FamilyCompensation[5])
            {
            }
            column(B_FamilyCompensation_June;B_FamilyCompensation[6])
            {
            }
            column(B_FamilyCompensation_July;B_FamilyCompensation[7])
            {
            }
            column(B_FamilyCompensation_August;B_FamilyCompensation[8])
            {
            }
            column(B_FamilyCompensation_September;B_FamilyCompensation[9])
            {
            }
            column(B_FamilyCompensation_October;B_FamilyCompensation[10])
            {
            }
            column(B_FamilyCompensation_November;B_FamilyCompensation[11])
            {
            }
            column(B_FamilyCompensation_December;B_FamilyCompensation[12])
            {
            }
            column(C_IllnessAndMotherhood_January;C_IllnessAndMotherhood[1])
            {
            }
            column(C_IllnessAndMotherhood_February;C_IllnessAndMotherhood[2])
            {
            }
            column(C_IllnessAndMotherhood_March;C_IllnessAndMotherhood[3])
            {
            }
            column(C_IllnessAndMotherhood_April;C_IllnessAndMotherhood[4])
            {
            }
            column(C_IllnessAndMotherhood_May;C_IllnessAndMotherhood[5])
            {
            }
            column(C_IllnessAndMotherhood_June;C_IllnessAndMotherhood[6])
            {
            }
            column(C_IllnessAndMotherhood_July;C_IllnessAndMotherhood[7])
            {
            }
            column(C_IllnessAndMotherhood_August;C_IllnessAndMotherhood[8])
            {
            }
            column(C_IllnessAndMotherhood_September;C_IllnessAndMotherhood[9])
            {
            }
            column(C_IllnessAndMotherhood_October;C_IllnessAndMotherhood[10])
            {
            }
            column(C_IllnessAndMotherhood_November;C_IllnessAndMotherhood[11])
            {
            }
            column(C_IllnessAndMotherhood_December;C_IllnessAndMotherhood[12])
            {
            }
            column(D_EndOfService;D_EndOfService)
            {
            }
            column(E_FamilyCompensation;E_FamilyCompensation)
            {
            }
            column(F_IllnessAndMotherhood;F_IllnessAndMotherhood)
            {
            }
            column(G_EndOfService;G_EndOfService)
            {
            }
            column(H_FamilyCompensation;H_FamilyCompensation)
            {
            }
            column(I_IllnessAndMotherhood;I_IllnessAndMotherhood)
            {
            }
            column(J_EndOfService;J_EndOfService)
            {
            }
            column(K_FamilyCompensation;K_FamilyCompensation)
            {
            }
            column(L_IllnessAndMotherhood;L_IllnessAndMotherhood)
            {
            }
            column(M_EndOfService;M_EndOfService)
            {
            }
            column(N_FamilyCompensation;N_FamilyCompensation)
            {
            }
            column(O_IllnessAndMotherhood;O_IllnessAndMotherhood)
            {
            }
            column(P_EndOfService;P_EndOfService)
            {
            }
            column(Q_FamilyCompensation;Q_FamilyCompensation)
            {
            }
            column(R_IllnessAndMotherhood;R_IllnessAndMotherhood)
            {
            }
            column(SumPQR;SumPQR)
            {
            }
            dataitem(Header;"Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                MaxIteration = 1;
                column(Logo;CompanyInfo.Picture)
                {
                }
                column(EmployeeNoCaption;EmployeeNoCaption)
                {
                }
                column(YearFilterCaption;YearFilterCaption)
                {
                }
                column(YearFilterVar;YearFilterVar)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
              PensionSchemeRec.RESET;
              PensionSchemeRec.SETRANGE(Type,PensionSchemeRec.Type::FAMSUB);
              PensionSchemeRec.SETRANGE("Payroll Posting Group",Employee."Posting Group");
              if PensionSchemeRec.FINDFIRST then
                FAMSUB_MaxMonthContribution := PensionSchemeRec."Maximum Monthly Contribution";

              PensionSchemeRec.RESET;
              PensionSchemeRec.SETRANGE(Type,PensionSchemeRec.Type::MHOOD);
              PensionSchemeRec.SETRANGE("Payroll Posting Group",Employee."Posting Group");
              if  PensionSchemeRec.FINDFIRST  then
                MHOOD_MaxMonthContribution := PensionSchemeRec."Maximum Monthly Contribution";

              PayrollLedgerEntryRec.RESET;
              PayrollLedgerEntryRec.SETRANGE(Declared,Declared::Declared);
              PayrollLedgerEntryRec.SETRANGE("Employee No.",Employee."No.");
              PayrollLedgerEntryRec.SETRANGE("Tax Year",YearFilterVar);

              IndividualAnnualSalarySum :=  0;
              PayrollLedgerEntryRec.SETCURRENTKEY(Period);
              for I := 1 to 12 do begin
                PayrollLedgerEntryRec.SETRANGE(Period,I);
                PayrollLedgerEntryRec.CALCSUMS("Total Salary for NSSF");
                IndividualAnnualSalarySum += PayrollLedgerEntryRec."Total Salary for NSSF";
                A_EndOfService[I] += PayrollLedgerEntryRec."Total Salary for NSSF";
                D_EndOfService += PayrollLedgerEntryRec."Total Salary for NSSF";
                G_EndOfService += PayrollLedgerEntryRec."Total Salary for NSSF";

                if FAMSUB_MaxMonthContribution <> 0 then begin
                  if FAMSUB_MaxMonthContribution < PayrollLedgerEntryRec."Total Salary for NSSF" then begin
                    B_FamilyCompensation[I] += FAMSUB_MaxMonthContribution;
                    E_FamilyCompensation += FAMSUB_MaxMonthContribution;
                  end else begin
                    B_FamilyCompensation[I] += PayrollLedgerEntryRec."Total Salary for NSSF";
                    E_FamilyCompensation += PayrollLedgerEntryRec."Total Salary for NSSF";
                  end;
                end else begin
                  B_FamilyCompensation[I] += PayrollLedgerEntryRec."Total Salary for NSSF";
                  E_FamilyCompensation  += PayrollLedgerEntryRec."Total Salary for NSSF";
                end;

                if MHOOD_MaxMonthContribution <> 0 then begin
                  if MHOOD_MaxMonthContribution < PayrollLedgerEntryRec."Total Salary for NSSF" then begin
                    C_IllnessAndMotherhood[I] += MHOOD_MaxMonthContribution;
                    F_IllnessAndMotherhood += MHOOD_MaxMonthContribution;
                  end else begin
                    C_IllnessAndMotherhood[I] += PayrollLedgerEntryRec."Total Salary for NSSF";
                    F_IllnessAndMotherhood += PayrollLedgerEntryRec."Total Salary for NSSF";
                  end;
                end else begin
                  C_IllnessAndMotherhood[I] += PayrollLedgerEntryRec."Total Salary for NSSF";
                  F_IllnessAndMotherhood    += PayrollLedgerEntryRec."Total Salary for NSSF";
                end;
              end;

                if GetMaxMonthlyContributionFAMSUBForDeclaredEmployees(Employee."No.") < IndividualAnnualSalarySum then
                  H_FamilyCompensation += GetMaxMonthlyContributionFAMSUBForDeclaredEmployees(Employee."No.")
                else
                  H_FamilyCompensation += IndividualAnnualSalarySum;

                if GetMaxMonthlyContributionMHOODForDeclaredEmployees(Employee."No.") < IndividualAnnualSalarySum then
                  I_IllnessAndMotherhood += GetMaxMonthlyContributionMHOODForDeclaredEmployees(Employee."No.")
                else
                  I_IllnessAndMotherhood += IndividualAnnualSalarySum;

                J_EndOfService := D_EndOfService;
                K_FamilyCompensation := E_FamilyCompensation;
                L_IllnessAndMotherhood := F_IllnessAndMotherhood;

                M_EndOfService := G_EndOfService - J_EndOfService;
                N_FamilyCompensation := H_FamilyCompensation - K_FamilyCompensation;
                O_IllnessAndMotherhood := I_IllnessAndMotherhood - L_IllnessAndMotherhood;

                P_EndOfService := ROUND(M_EndOfService * 0.085,1,'=');
                Q_FamilyCompensation := ROUND(N_FamilyCompensation * 0.06,1,'=');
                R_IllnessAndMotherhood := ROUND(O_IllnessAndMotherhood * 0.11,1,'=');
                SumPQR := P_EndOfService + Q_FamilyCompensation + R_IllnessAndMotherhood;
            end;

            trigger OnPreDataItem();
            begin
              D_EndOfService  :=  0;
              E_FamilyCompensation  :=  0;
              F_IllnessAndMotherhood  :=  0;
              G_EndOfService  :=  0;
              H_FamilyCompensation  :=  0;
              I_IllnessAndMotherhood  :=  0;
              J_EndOfService  :=  0;
              K_FamilyCompensation  :=  0;
              L_IllnessAndMotherhood  :=  0;
              M_EndOfService  :=  0;
              N_FamilyCompensation  :=  0;
              O_IllnessAndMotherhood  :=  0;
              P_EndOfService  :=  0;
              Q_FamilyCompensation  :=  0;
              R_IllnessAndMotherhood  :=  0;
              SumPQR  :=  0;
              FAMSUB_MaxMonthContribution := 0;
              MHOOD_MaxMonthContribution := 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field("<YearFilterVar>";YearFilterVar)
                {
                    Caption = 'Year';
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

    trigger OnInitReport();
    begin
      YearFilterVar := DATE2DMY(TODAY,3);
    end;

    trigger OnPreReport();
    begin
        if YearFilterVar = 0 then
          ERROR('You must enter valid Year filter');

        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo : Record "Company Information";
        YearFilterVar : Integer;
        A_EndOfService : array [12] of Decimal;
        B_FamilyCompensation : array [12] of Decimal;
        C_IllnessAndMotherhood : array [12] of Decimal;
        D_EndOfService : Decimal;
        E_FamilyCompensation : Decimal;
        F_IllnessAndMotherhood : Decimal;
        G_EndOfService : Decimal;
        H_FamilyCompensation : Decimal;
        I_IllnessAndMotherhood : Decimal;
        J_EndOfService : Decimal;
        K_FamilyCompensation : Decimal;
        L_IllnessAndMotherhood : Decimal;
        M_EndOfService : Decimal;
        N_FamilyCompensation : Decimal;
        O_IllnessAndMotherhood : Decimal;
        P_EndOfService : Decimal;
        Q_FamilyCompensation : Decimal;
        R_IllnessAndMotherhood : Decimal;
        SumPQR : Decimal;
        PayrollLedgerEntryRec : Record "Payroll Ledger Entry";
        PensionSchemeRec : Record "Pension Scheme";
        I : Integer;
        EmployeeNoCaption : Label 'Employee No.:';
        YearFilterCaption : Label 'Year:';
        FAMSUB_MaxMonthContribution : Decimal;
        MHOOD_MaxMonthContribution : Decimal;
        IndividualAnnualSalarySum : Decimal;

    local procedure GetMaxMonthlyContributionFAMSUBForDeclaredEmployees(EmployeeNo : Code[20]) FAMSUB_max : Decimal;
    var
        NoOfMonth : Integer;
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        PensionScheme : Record "Pension Scheme";
        MaxMonthlyContribution : Decimal;
    begin
        FAMSUB_max := 0;
        NoOfMonth := 0;

        PayrollLedgerEntry.SETRANGE("Employee No.",EmployeeNo);
        PayrollLedgerEntry.SETRANGE("Tax Year",YearFilterVar);
        if PayrollLedgerEntry.FINDFIRST then
          NoOfMonth += PayrollLedgerEntry.COUNT;

        PensionScheme.RESET;
        CLEAR(PensionScheme);
        PensionScheme.SETRANGE("Payroll Posting Group",Employee."Posting Group");
        PensionScheme.SETRANGE(Type,PensionScheme.Type::FAMSUB);
        if PensionScheme.FINDFIRST then
          MaxMonthlyContribution := PensionScheme."Maximum Monthly Contribution";

        FAMSUB_max += NoOfMonth * MaxMonthlyContribution;
        exit(FAMSUB_max);
    end;

    local procedure GetMaxMonthlyContributionMHOODForDeclaredEmployees(EmployeeNo : Code[20]) MHOOD_max : Decimal;
    var
        NoOfMonth : Integer;
        PayrollLedgerEntry : Record "Payroll Ledger Entry";
        PensionScheme : Record "Pension Scheme";
        MaxMonthlyContribution : Decimal;
    begin
        MHOOD_max := 0;
        NoOfMonth := 0;

        PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
        PayrollLedgerEntry.SETRANGE("Tax Year",YearFilterVar);
        if PayrollLedgerEntry.FINDFIRST then
          NoOfMonth += PayrollLedgerEntry.COUNT;

        PensionScheme.RESET;
        CLEAR(PensionScheme);
        PensionScheme.SETRANGE("Payroll Posting Group",Employee."Posting Group");
        PensionScheme.SETRANGE(Type,PensionScheme.Type::MHOOD);
        if PensionScheme.FINDFIRST then
          MaxMonthlyContribution := PensionScheme."Maximum Monthly Contribution";

        MHOOD_max += NoOfMonth * MaxMonthlyContribution;
        exit(MHOOD_max);
    end;
}

