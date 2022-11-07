report 98124 "Working Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Working Statement.rdlc';
    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(StartDate;StartDate)
            {}
            column(CompanyOwnerName;CompanyOwnerName)
            {}
            column(CompanyInformation;CompanyInformation."Commercial No.")
            {}
            column(RegistrationNo;CompanyInformation."Registration No.")
            {}
            column(SocialSecurityNo;"Social Security No.")
            {}
            column(EmployeeName;EmployeeName)
            {}
            column(WorkingDateVar1;WorkingDate1)
            {} 
            column(WorkingDateVar2;WorkingDate2)
            {} 
            column(WorkingDateVar3;WorkingDate3)
            {} 
            column(WorkingDateVar4;WorkingDate4)
            {} 
            column(WorkingDateVar5;WorkingDate5)
            {} 
            column(WorkingDateVar6;WorkingDate6)
            {} 
            column(WorkingDateVar7;WorkingDate7)
            {}   
            column(NoOfWDText1;NoOfWDText1)
            {} 
            column(NoOfWDText2;NoOfWDText2)
            {} 
            column(NoOfWDText3;NoOfWDText3)
            {} 
            column(NoOfWDText4;NoOfWDText4)
            {} 
            column(NoOfWDText5;NoOfWDText5)
            {} 
            column(NoOfWDText6;NoOfWDText6)
            {} 
            column(NoOfWDText7;NoOfWDText7)
            {}     
            column(WorkingPeriod;WorkingPeriod) 
            {}    
            column(StartDateVar1;StartDate1)
            {}
            column(StartDateVar2;StartDate2)
            {}      
            column(StartDateVar3;StartDate3)
            {}      
            column(StartDateVar4;StartDate4)
            {}
            column(StartDateVar5;StartDate5)
            {}      
            column(StartDateVar6;StartDate6)
            {}  
            column(EndDateVar1;EndDate1)
            {}
            column(EndDateVar2;EndDate2)
            {}      
            column(EndDateVar3;EndDate3)
            {}      
            column(EndDateVar4;EndDate4)
            {}
            column(EndDateVar5;EndDate5)   
            {}      
            column(EndDateVar6;EndDate6)
            {}    
            column(Signature;Signature)
            {}
            trigger OnAfterGetRecord();
            begin
                ResetVar();                
                IF Employee."Arabic Name" <> '' THEN
                    EmployeeName := Employee."Arabic Name"
                ELSE
                    EmployeeName := Employee."Full Name";  
                //
                PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                PayrollLedgerEntry.SETRANGE("Payroll Date",PayrollFunctions.GetFirstDateofMonth(StartDate),PayrollFunctions.GetLastDateofMonth(StartDate));
                IF PayrollLedgerEntry.FINDFIRST then
                    BEGIN
                        PayrollLedgerEntry.SETRANGE("Payroll Date",DMY2DATE(1,DATE2DMY(CALCDATE('<-6M>',StartDate),2),DATE2DMY(CALCDATE('<-6M>',StartDate),3)),StartDate);
                        PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                        IF PayrollLedgerEntry.FINDFIRST THEN REPEAT 
                            i += 1;
                            CASE i OF 
                            1:
                            BEGIN
                                WorkingDate1 := PayrollFunctions.GetMonthName(PayrollLedgerEntry."Payroll Date",MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(PayrollLedgerEntry."Payroll Date",3));
                                StartDate1 := PayrollFunctions.GetFirstDateofMonth(PayrollLedgerEntry."Payroll Date");
                                EndDate1 := PayrollFunctions.GetLastDateofMonth(PayrollLedgerEntry."Payroll Date"); 
                            END;
                            2: 
                            BEGIN
                                WorkingDate2 := PayrollFunctions.GetMonthName(PayrollLedgerEntry."Payroll Date",MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(PayrollLedgerEntry."Payroll Date",3));
                                StartDate2 := PayrollFunctions.GetFirstDateofMonth(PayrollLedgerEntry."Payroll Date");
                                EndDate2 := PayrollFunctions.GetLastDateofMonth(PayrollLedgerEntry."Payroll Date"); 
                            END;
                            3: 
                            BEGIN
                                WorkingDate3 := PayrollFunctions.GetMonthName(PayrollLedgerEntry."Payroll Date",MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(PayrollLedgerEntry."Payroll Date",3));
                                StartDate3 := PayrollFunctions.GetFirstDateofMonth(PayrollLedgerEntry."Payroll Date");
                                EndDate3 := PayrollFunctions.GetLastDateofMonth(PayrollLedgerEntry."Payroll Date"); 
                            END;
                            4: 
                            BEGIN
                                WorkingDate4 := PayrollFunctions.GetMonthName(PayrollLedgerEntry."Payroll Date",MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(PayrollLedgerEntry."Payroll Date",3));
                                StartDate4 := PayrollFunctions.GetFirstDateofMonth(PayrollLedgerEntry."Payroll Date");
                                EndDate4 := PayrollFunctions.GetLastDateofMonth(PayrollLedgerEntry."Payroll Date"); 
                            END;
                            5: 
                            BEGIN
                                WorkingDate5 := PayrollFunctions.GetMonthName(PayrollLedgerEntry."Payroll Date",MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(PayrollLedgerEntry."Payroll Date",3));
                                StartDate5 := PayrollFunctions.GetFirstDateofMonth(PayrollLedgerEntry."Payroll Date");
                                EndDate5 := PayrollFunctions.GetLastDateofMonth(PayrollLedgerEntry."Payroll Date"); 
                            END;
                            6: 
                            BEGIN
                                WorkingDate6 := PayrollFunctions.GetMonthName(PayrollLedgerEntry."Payroll Date",MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(PayrollLedgerEntry."Payroll Date",3));
                                StartDate6 := PayrollFunctions.GetFirstDateofMonth(PayrollLedgerEntry."Payroll Date");
                                EndDate6 := PayrollFunctions.GetLastDateofMonth(PayrollLedgerEntry."Payroll Date");
                            END;
                            END;
                        UNTIL PayrollLedgerEntry.NEXT=0;
                        WorkingPeriod := 'ستة أشهر';
                    END
                    ELSE begin
                        PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                        PayrollLedgerEntry.SETFILTER("Payroll Date",'%1..%2',PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-5M>',StartDate)),PayrollFunctions.GetLastDateofMonth(CALCDATE('<-5M>',StartDate)));
                        IF PayrollLedgerEntry.FINDFIRST THEN BEGIN 
                            WorkingDate1 := PayrollFunctions.GetMonthName(CALCDATE('<-5M>',StartDate),MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(CALCDATE('<-5M>',StartDate),3));
                            StartDate1 := PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-5M>',StartDate));
                            EndDate1 := PayrollFunctions.GetLastDateofMonth(CALCDATE('<-5M>',StartDate));
                        END;
                        PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                        PayrollLedgerEntry.SETFILTER("Payroll Date",'%1..%2',PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-4M>',StartDate)),PayrollFunctions.GetLastDateofMonth(CALCDATE('<-4M>',StartDate)));
                        IF PayrollLedgerEntry.FINDFIRST THEN BEGIN 
                            WorkingDate2 := PayrollFunctions.GetMonthName(CALCDATE('<-4M>',StartDate),MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(CALCDATE('<-4M>',StartDate),3));
                            StartDate2 := PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-4M>',StartDate));
                            EndDate2 := PayrollFunctions.GetLastDateofMonth(CALCDATE('<-4M>',StartDate)); 
                        END;                 
                        PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                        PayrollLedgerEntry.SETFILTER("Payroll Date",'%1..%2',PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-3M>',StartDate)),PayrollFunctions.GetLastDateofMonth(CALCDATE('<-3M>',StartDate)));
                        IF PayrollLedgerEntry.FINDFIRST THEN BEGIN 
                            WorkingDate3 := PayrollFunctions.GetMonthName(CALCDATE('<-3M>',StartDate),MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(CALCDATE('<-3M>',StartDate),3));
                            StartDate3 := PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-3M>',StartDate));
                            EndDate3:= PayrollFunctions.GetLastDateofMonth(CALCDATE('<-3M>',StartDate)); 
                        END;
                        PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                        PayrollLedgerEntry.SETFILTER("Payroll Date",'%1..%2',PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-2M>',StartDate)),PayrollFunctions.GetLastDateofMonth(CALCDATE('<-2M>',StartDate)));
                        IF PayrollLedgerEntry.FINDFIRST THEN BEGIN 
                            WorkingDate4 := PayrollFunctions.GetMonthName(CALCDATE('<-2M>',StartDate),MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(CALCDATE('<-2M>',StartDate),3));
                            StartDate4 := PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-2M>',StartDate));
                            EndDate4 := PayrollFunctions.GetLastDateofMonth(CALCDATE('<-2M>',StartDate)); 
                        END;
                        PayrollLedgerEntry.SETRANGE("Employee No.",Employee."No.");
                        PayrollLedgerEntry.SETFILTER("Payroll Date",'%1..%2',PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-1M>',StartDate)),PayrollFunctions.GetLastDateofMonth(CALCDATE('<-1M>',StartDate)));
                        IF PayrollLedgerEntry.FINDFIRST THEN BEGIN 
                            WorkingDate5 := PayrollFunctions.GetMonthName(CALCDATE('<-1M>',StartDate),MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(CALCDATE('<-1M>',StartDate),3));
                            StartDate5 := PayrollFunctions.GetFirstDateofMonth(CALCDATE('<-1M>',StartDate));
                            EndDate5 := PayrollFunctions.GetLastDateofMonth(CALCDATE('<-1M>',StartDate)); 
                        END;    
                        WorkingDate6 := PayrollFunctions.GetMonthName(StartDate,MonthLanguage::AR) + ' ' + FORMAT(DATE2DMY(StartDate,3));
                        StartDate6 := PayrollFunctions.GetFirstDateofMonth(StartDate);
                        if DATE2DMY(StartDate,1)=DATE2DMY(PayrollFunctions.GetLastDateofMonth(StartDate),1) THEN   
                            EndDate6 := PayrollFunctions.GetLastDateofMonth(StartDate) 
                        else EndDate6 := DMY2DATE(DATE2DMY(StartDate,1),DATE2DMY(StartDate,2),DATE2DMY(StartDate,3));   
                        //
                        IF (WorkingDate1='') AND (WorkingDate2='') AND (WorkingDate3='') AND (WorkingDate4='') AND (WorkingDate5='') and (WorkingDate6<>'') THEN
                            WorkingPeriod := 'شـهر'   
                        ELSE IF (WorkingDate1='') AND (WorkingDate2='') AND (WorkingDate3='') AND (WorkingDate4='') AND (WorkingDate5<>'') and (WorkingDate6<>'') THEN
                            WorkingPeriod := 'شـهرين'
                        ELSE IF (WorkingDate1='') AND (WorkingDate2='') AND (WorkingDate3='') AND (WorkingDate4<>'') AND (WorkingDate5<>'') and (WorkingDate6<>'') THEN
                            WorkingPeriod := 'ثلاثة أشهر'   
                        ELSE IF (WorkingDate1='') AND (WorkingDate2='') AND (WorkingDate3<>'') AND (WorkingDate4<>'') AND (WorkingDate5<>'') and (WorkingDate6<>'') THEN
                            WorkingPeriod := 'أربعة أشهر'    
                        ELSE IF (WorkingDate1='') AND (WorkingDate2<>'') AND (WorkingDate3<>'') AND (WorkingDate4<>'') AND (WorkingDate5<>'') and (WorkingDate6<>'') THEN
                            WorkingPeriod := 'خمسة أشهر' 
                        ELSE   WorkingPeriod := 'ستة أشهر';
                        //  
                        IF WorkingDate1<>'' then
                            WorkingDate1 := WorkingDate1
                        ELSE IF (WorkingDate1='') and (WorkingDate2<>'') then
                        WorkingDate1 := WorkingDate2  
                        ELSE IF (WorkingDate1='') and (WorkingDate2='') and (WorkingDate3<>'') then
                            WorkingDate1 := WorkingDate3            
                        ELSE IF (WorkingDate1='') and (WorkingDate2='') and (WorkingDate3='') and (WorkingDate4<>'') then                                                  
                            WorkingDate1 := WorkingDate4 
                        ELSE IF (WorkingDate1='') and (WorkingDate2='') and (WorkingDate3='') 
                            and (WorkingDate4='') and (WorkingDate5<>'')then
                            WorkingDate1 := WorkingDate5  
                        ELSE IF (WorkingDate1='') and (WorkingDate2='') and (WorkingDate3='') 
                            and (WorkingDate4='') and (WorkingDate5='') and (WorkingDate6<>'') then
                            WorkingDate1 := WorkingDate6;
                        //
                        IF (WorkingDate1<>'') and (WorkingDate2<>'') then
                        WorkingDate2 := WorkingDate2  
                        ELSE IF (WorkingDate1<>'') and (WorkingDate2='') and (WorkingDate3<>'') 
                            and (WorkingDate1<>WorkingDate3) then
                            WorkingDate2 := WorkingDate3            
                        ELSE IF (WorkingDate1<>'') and (WorkingDate2='') and (WorkingDate3='') and (WorkingDate4<>'') 
                            and (WorkingDate1<>WorkingDate4) then                                                  
                            WorkingDate2 := WorkingDate4 
                        ELSE IF (WorkingDate1<>'') and (WorkingDate2='') and (WorkingDate3='') 
                            and (WorkingDate1=WorkingDate4) and (WorkingDate5<>'') then
                            WorkingDate2 := WorkingDate5  
                        ELSE IF (WorkingDate1<>'') and (WorkingDate2='') and (WorkingDate3='') 
                            and ((WorkingDate1=WorkingDate4) OR (WorkingDate1=WorkingDate5)) and (WorkingDate6<>'') 
                            and (WorkingDate1<>WorkingDate6) then
                            WorkingDate2 := WorkingDate6;
                        //
                        IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3<>'') then
                            WorkingDate3 := WorkingDate3            
                        ELSE IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3='') and (WorkingDate4<>'') 
                            and (WorkingDate1<>WorkingDate4) and (WorkingDate2<>WorkingDate4) then                                                  
                            WorkingDate3 := WorkingDate4 
                        ELSE IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3='') and (WorkingDate4<>'')  
                            and (WorkingDate1=WorkingDate4) and (WorkingDate5<>'') and (WorkingDate2<>WorkingDate5) then
                            WorkingDate3 := WorkingDate5  
                        ELSE IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3='') 
                            and (WorkingDate1=WorkingDate4) and (WorkingDate2=WorkingDate5)
                            and (WorkingDate6<>'') 
                            then
                            WorkingDate3:= WorkingDate6;
                        //                         
                        IF (WorkingDate1=WorkingDate4) or (WorkingDate2=WorkingDate4) or (WorkingDate3=WorkingDate4) then
                            WorkingDate4 := ''
                        ELSE BEGIN
                            IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3<>'') and (WorkingDate4<>'') then                                                  
                                WorkingDate4 := WorkingDate4 
                            ELSE IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3<>'') 
                                and (WorkingDate4='') and (WorkingDate5<>'') and (WorkingDate1<>WorkingDate5)
                                and (WorkingDate2<>WorkingDate5) and (WorkingDate3<>WorkingDate5) then
                                WorkingDate4 := WorkingDate5  
                            ELSE IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3<>'') 
                                and (WorkingDate4='') and (WorkingDate5='') and (WorkingDate6<>'') and (WorkingDate1<>WorkingDate6)
                                and (WorkingDate2<>WorkingDate6) and (WorkingDate3<>WorkingDate6) then            
                                WorkingDate4 := WorkingDate6 
                        END;      
                        //
                        IF (WorkingDate1=WorkingDate5) or (WorkingDate2=WorkingDate5) or (WorkingDate3=WorkingDate5) then
                            WorkingDate5 := ''
                        ELSE BEGIN
                            IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3<>'') 
                                and (WorkingDate4<>'') and (WorkingDate5<>'') then
                                WorkingDate5 := WorkingDate5  
                            ELSE IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3<>'') 
                                and (WorkingDate4<>'') and (WorkingDate5='') and (WorkingDate6<>'') 
                                and (WorkingDate1<>WorkingDate6) and (WorkingDate2<>WorkingDate6) 
                                and (WorkingDate3<>WorkingDate6) and (WorkingDate4<>WorkingDate6) then
                                WorkingDate5 := WorkingDate6
                        END;
                        //                       
                        IF (WorkingDate1=WorkingDate6) or (WorkingDate2=WorkingDate6) or (WorkingDate3=WorkingDate6) then
                            WorkingDate6 := ''
                        ELSE BEGIN
                            IF (WorkingDate1<>'') and (WorkingDate2<>'') and (WorkingDate3<>'') 
                                and (WorkingDate4<>'') and (WorkingDate5<>'') and (WorkingDate6<>'') then
                                WorkingDate6 := WorkingDate6  
                        END;
                        //   
                        IF StartDate1<>0D then
                            StartDate1 := StartDate1
                        ELSE IF (StartDate1=0D) and (StartDate2<>0D) then
                            StartDate1 := StartDate2  
                        ELSE IF (StartDate1=0D) and (StartDate2=0D) and (StartDate3<>0D) then
                            StartDate1 := StartDate3            
                        ELSE IF (StartDate1=0D) and (StartDate2=0D) and (StartDate3=0D) and (StartDate4<>0D) then                                                  
                            StartDate1 := StartDate4 
                        ELSE IF (StartDate1=0D) and (StartDate2=0D) and (StartDate3=0D) 
                            and (StartDate4=0D) and (StartDate5<>0D)then
                            StartDate1 := StartDate5  
                        ELSE IF (StartDate1=0D) and (StartDate2=0D) and (StartDate3=0D) 
                            and (StartDate4=0D) and (StartDate5=0D) and (StartDate6<>0D) then
                            StartDate1 := StartDate6;
                        //
                        IF (StartDate1<>0D) and (StartDate2<>0D) then
                            StartDate2 := StartDate2  
                        ELSE IF (StartDate1<>0D) and (StartDate2=0D) and (StartDate3<>0D) 
                            and (StartDate1<>StartDate3) then
                            StartDate2 := StartDate3            
                        ELSE IF (StartDate1<>0D) and (StartDate2=0D) and (StartDate3=0D) and (StartDate4<>0D) 
                            and (StartDate1<>StartDate4) then                                                  
                            StartDate2 := StartDate4 
                        ELSE IF (StartDate1<>0D) and (StartDate2=0D) and (StartDate3=0D) 
                            and (StartDate1=StartDate4) and (StartDate5<>0D) then
                            StartDate2 := StartDate5  
                        ELSE IF (StartDate1<>0D) and (StartDate2=0D) and (StartDate3=0D) 
                            and ((StartDate1=StartDate4) OR (StartDate1=StartDate5)) and (StartDate6<>0D) 
                            and (StartDate1<>StartDate6) then
                            StartDate2 := StartDate6;
                        //
                        IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3<>0D) then
                            StartDate3 := StartDate3            
                        ELSE IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3=0D) and (StartDate4<>0D) 
                            and (StartDate1<>StartDate4) and (StartDate2<>StartDate4) then                                                  
                            StartDate3 := StartDate4 
                        ELSE IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3=0D) and (StartDate4<>0D)  
                            and (StartDate1=StartDate4) and (StartDate5<>0D) and (StartDate2<>StartDate5) then
                            StartDate3 := StartDate5  
                        ELSE IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3=0D) 
                            and (StartDate1=StartDate4) and (StartDate2=StartDate5)
                            and (StartDate6<>0D) 
                                then
                            StartDate3:= StartDate6;
                        //
                        IF (StartDate1=StartDate4) or (StartDate2=StartDate4) or (StartDate3=StartDate4) then
                            StartDate4 := 0D  
                        ELSE BEGIN
                            IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3<>0D) and (StartDate4<>0D) then                                                  
                                StartDate4 := StartDate4 
                            ELSE IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3<>0D) 
                                and (StartDate4=0D) and (StartDate5<>0D) and (StartDate1<>StartDate5)
                                and (StartDate2<>StartDate5) and (StartDate3<>StartDate5) then
                                StartDate4 := StartDate5  
                            ELSE IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3<>0D) 
                                and (StartDate4=0D) and (StartDate5=0D) and (StartDate6<>0D) and (StartDate1<>StartDate6)
                                and (StartDate2<>StartDate6) and (StartDate3<>StartDate6) then            
                                StartDate4 := StartDate6 
                        END;      
                        //
                        IF (StartDate1=StartDate5) or (StartDate2=StartDate5) or (StartDate3=StartDate5) then
                            StartDate5 := 0D 
                        ELSE BEGIN
                            IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3<>0D) 
                                and (StartDate4<>0D) and (StartDate5<>0D) then
                                StartDate5 := StartDate5  
                            ELSE IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3<>0D) 
                                and (StartDate4<>0D) and (StartDate5=0D) and (StartDate6<>0D) 
                                and (StartDate1<>StartDate6) and (StartDate2<>StartDate6) 
                                and (StartDate3<>StartDate6) and (StartDate4<>StartDate6) then
                                StartDate5 := StartDate6
                        END;
                        //
                        IF (StartDate1=StartDate6) or (StartDate2=StartDate6) or (StartDate3=StartDate6) then
                            StartDate6 := 0D
                        ELSE BEGIN
                            IF (StartDate1<>0D) and (StartDate2<>0D) and (StartDate3<>0D) 
                                and (StartDate4<>0D) and (StartDate5<>0D) and (StartDate6<>0D) then
                                StartDate6 := StartDate6  
                        END;
                        IF EndDate1<>0D then
                            EndDate1 := EndDate1
                        ELSE IF (EndDate1=0D) and (EndDate2<>0D) then
                            EndDate1 := EndDate2  
                        ELSE IF (EndDate1=0D) and (EndDate2=0D) and (EndDate3<>0D) then
                            EndDate1 := EndDate3            
                        ELSE IF (EndDate1=0D) and (EndDate2=0D) and (EndDate3=0D) and (EndDate4<>0D) then                                                  
                            EndDate1 := EndDate4 
                        ELSE IF (EndDate1=0D) and (EndDate2=0D) and (EndDate3=0D) 
                            and (EndDate4=0D) and (EndDate5<>0D)then
                            EndDate1 := EndDate5  
                        ELSE IF (EndDate1=0D) and (EndDate2=0D) and (EndDate3=0D) 
                            and (EndDate4=0D) and (EndDate5=0D) and (EndDate6<>0D) then
                            EndDate1 := EndDate6;
                        //
                        IF (EndDate1<>0D) and (EndDate2<>0D) then
                            EndDate2 := EndDate2  
                        ELSE IF (EndDate1<>0D) and (EndDate2=0D) and (EndDate3<>0D) 
                            and (EndDate1<>EndDate3) then
                            EndDate2 := EndDate3            
                        ELSE IF (EndDate1<>0D) and (EndDate2=0D) and (EndDate3=0D) and (EndDate4<>0D) 
                            and (EndDate1<>EndDate4) then                                                  
                            EndDate2 := EndDate4 
                        ELSE IF (EndDate1<>0D) and (EndDate2=0D) and (EndDate3=0D) 
                            and (EndDate1=EndDate4) and (EndDate5<>0D) then
                            EndDate2 := EndDate5  
                        ELSE IF (EndDate1<>0D) and (EndDate2=0D) and (EndDate3=0D) 
                            and ((EndDate1=EndDate4) OR (EndDate1=EndDate5)) and (EndDate6<>0D) 
                            and (EndDate1<>EndDate6) then
                            EndDate2 := EndDate6;
                        //
                        IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3<>0D) then
                            EndDate3 := EndDate3            
                        ELSE IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3=0D) and (EndDate4<>0D) 
                            and (EndDate1<>EndDate4) and (EndDate2<>EndDate4) then                                                  
                            EndDate3 := EndDate4 
                        ELSE IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3=0D) and (EndDate4<>0D)  
                            and (EndDate1=EndDate4) and (EndDate5<>0D) and (EndDate2<>EndDate5) then
                            EndDate3 := EndDate5  
                        ELSE IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3=0D) 
                            and (EndDate1=EndDate4) and (EndDate2=EndDate5)
                            and (EndDate6<>0D) 
                                then
                            EndDate3:= EndDate6;
                        //  
                        IF (EndDate1=EndDate4) or (EndDate2=EndDate4) or (EndDate3=EndDate4) then
                            EndDate4 := 0D
                        ELSE BEGIN
                            IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3<>0D) and (EndDate4<>0D) then                                                  
                                EndDate4 := EndDate4 
                            ELSE IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3<>0D) 
                                and (EndDate4=0D) and (EndDate5<>0D) and (EndDate1<>EndDate5)
                                and (EndDate2<>EndDate5) and (EndDate3<>EndDate5) then
                                EndDate4 := EndDate5  
                            ELSE IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3<>0D) 
                                and (EndDate4=0D) and (EndDate5=0D) and (EndDate6<>0D) and (EndDate1<>EndDate6)
                                and (EndDate2<>EndDate6) and (EndDate3<>EndDate6) then            
                                EndDate4 := EndDate6 
                        END;      
                        //
                        IF (EndDate1=EndDate5) or (EndDate2=EndDate5) or (EndDate3=EndDate5) then
                            EndDate5 := 0D
                        ELSE BEGIN
                            IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3<>0D) 
                                and (EndDate4<>0D) and (EndDate5<>0D) then
                                EndDate5 := EndDate5  
                            ELSE IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3<>0D) 
                                and (EndDate4<>0D) and (EndDate5=0D) and (EndDate6<>0D) 
                                and (EndDate1<>EndDate6) and (EndDate2<>EndDate6) 
                                and (EndDate3<>EndDate6) and (EndDate4<>EndDate6) then
                                EndDate5 := EndDate6
                        END;
                        //
                        IF (EndDate1=EndDate6) or (EndDate2=EndDate6) or (EndDate3=EndDate6) then
                            EndDate6 := 0D
                        ELSE BEGIN
                            IF (EndDate1<>0D) and (EndDate2<>0D) and (EndDate3<>0D) 
                                and (EndDate4<>0D) and (EndDate5<>0D) and (EndDate6<>0D) then
                                EndDate6 := EndDate6  
                        END;                            
                    End;
                /*NoOfWDText1 := TransferNumberToName(DATE2DMY(EndDate1,1));
                NoOfWDText2 := TransferNumberToName(DATE2DMY(EndDate2,1));
                NoOfWDText3 := TransferNumberToName(DATE2DMY(EndDate3,1));
                NoOfWDText4 := TransferNumberToName(DATE2DMY(EndDate4,1));
                NoOfWDText5 := TransferNumberToName(DATE2DMY(EndDate5,1));
                NoOfWDText6 := 'لغاية تاريخـه'*/
            end;      
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
               // Caption = 'control';
                group(Date)
                {
                    
                    field("Start Date";StartDate)
                    {
                        Caption = 'Start Date';
                                              ApplicationArea=All;
                    }
                    Field(Signature;Signature)
                    {                        ApplicationArea=All;
}

                }
            }
        }
    }
    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        IF CompanyInformation."Arabic Name" <> '' THEN
            CompanyOwnerName := CompanyInformation."Arabic Name"
        ELSE
            CompanyOwnerName := CompanyInformation.Name;
    end;
    var
        CompanyInformation	: Record "Company Information";	
        PayrollFunctions : Codeunit	"Payroll Functions";	
        PayrollLedgerEntry : Record	"Payroll Ledger Entry";	
        CompanyOwnerName : Text [250];		
        EmployeeName : Text	[250];
        EmployeeNSSFNo : Code [50];
        StartDate : Date;		
        Signature  : Text	[250];
        WorkingDate1 : Text	[250];		
        WorkingDate2 : Text	[250];		
        WorkingDate3 : Text	[250];		
        WorkingDate4 : Text	[250];		
        WorkingDate5 : Text	[250];		
        WorkingDate6 : Text	[250];		
        WorkingDate7 : Text	[250];		
        NoOfWDText1 : Text	[250];		
        NoOfWDText2 : Text	[250];		
        NoOfWDText3 : Text	[250];		
        NoOfWDText4 : Text	[250];		
        NoOfWDText5 : Text	[250];		
        NoOfWDText6 : Text	[250];		
        NoOfWDText7 : Text	[250];	
        WorkingPeriod : Text [50];

        i : integer;
        MonthLanguage : Option EN,AR;
        StartDate1 : Date;		
        StartDate2 : Date;		
        StartDate3 : Date;		
        StartDate4 : Date;		
        StartDate5 : Date;		
        StartDate6 : Date;		
        StartDate7 : Date;		
        EndDate1 : Date;		
        EndDate2 : Date;		
        EndDate3 : Date;		
        EndDate4 : Date;	
        EndDate5 : Date;		
        EndDate6 : Date;		
        EndDate7 : Date;				
    local procedure ResetVar()
    var
    begin
        i := 0;
    end;

    local procedure TransferNumberToName(No : integer) val: text [100]
    var
    begin
        IF No=28 then 
            Val := 'ثمانية و عشرون يوما'
        ELSE  IF No=29 then
            Val := 'تسعة و عشرون يوما'
        ELSE    IF No=30 then
            val := 'ثلاثون يوما'
        ELSE    IF No=31 then 
            Val := 'واحد و ثلاثون يوما'
        ELSE  Val := '';       
        EXIT(Val)
    END;
}