codeunit 98009 "EDM Functions"
{
    // version SHR1.0,EDM.HRPY1

    // AB.1 150407 = Created the InsertAlertProjectManager Function
    // AB.2:080507 = added "Blanket Purchase Order" code to Generate()
    // AB.3:130507 = added "Production BOM" code to Generate()
    //             = added "Routing" code to Generate()
    //             = added a new function "InsertAlertEstimator"
    //             = added a new function "InsertAlertItem2ProductionBOM"
    // AB.4:210507 = added two alert functions for "Print Invoice" and "Generate G/L journal"

    Permissions = TableData Item=rimd,
                  TableData "Sales Header"=rimd,
                  TableData "Sales Line"=rimd,
                  TableData "Approval Entry"=rimd,
                  TableData "Dimension Set Entry"=rimd,
                  TableData "Dimension Set Tree Node"=rimd;

    trigger OnRun();
    var
        MyEmployee : Record Employee;
    begin
        /*.SETRANGE("No.",'PR16-000111');
        requestheader.FINDFIRST;
        requestheader.Status := requestheader.Status::Open;
        //requestheader."Req. Status" := requestheader."Req. Status"::Accepted;
        requestheader.MODIFY;
        */
        /*requestline.SETRANGE("Document No.",'PR000014');
        requestline.FINDFIRST;
        requestline.Assigned := FALSE;
        requestline.MODIFY;*/
        if VendorRec.FINDFIRST then
        repeat
          VendorRec.VALIDATE("Pay-to Vendor No." ,VendorRec."No.");
          VendorRec.MODIFY;
        until VendorRec.NEXT =0;
        MESSAGE(' ');

    end;

    var
        Window : Dialog;
        cust : Record Customer;
        quote : Record "Sales Header";
        salesline : Record "Sales Line";
        item : Record Item;
        NoSeriesMgt : Codeunit NoSeriesManagement;
        inventorySetup : Record "Inventory Setup";
        itemNo : Code[20];
        unitofMeasure : Record "Item Unit of Measure";
        Answer : Boolean;
        Answer1 : Boolean;
        Question : Text[100];
        Question1 : Text[100];
        Limit : Decimal;
        MyAmount : Decimal;
        MyPostedInvoice : Record "Purch. Inv. Header";
        MyPostedAmount : Decimal;
        PreviousAmount : Decimal;
        MyPurchaseHeader : Record "Purchase Header";
        Balance : Decimal;
        text000 : Label '''Your budgeted amount had exceeded the limit. Do you want to continue? ''';
        text001 : Label '''You selected %1.''';
        text002 : Label ''' Do you want to print the report?''';
        text003 : Label '''You can''''t exceed the Budgeted limit.''';
        text004 : Label ''' Please check out the sum of the line amount''';
        text005 : Label '''to equal to %1.''';
        Text026 : Label 'ZERO';
        Text027 : Label 'HUNDRED';
        Text028 : Label 'And';
        Text029 : Label '%1 results in a written number that is too long.';
        Text030 : Label '" is already applied to %1 %2 for customer %3."';
        Text031 : Label '" is already applied to %1 %2 for vendor %3."';
        Text032 : Label 'ONE';
        Text033 : Label 'TWO';
        Text034 : Label 'THREE';
        Text035 : Label 'FOUR';
        Text036 : Label 'FIVE';
        Text037 : Label 'SIX';
        Text038 : Label 'SEVEN';
        Text039 : Label 'EIGHT';
        Text040 : Label 'NINE';
        Text041 : Label 'TEN';
        Text042 : Label 'ELEVEN';
        Text043 : Label 'TWELVE';
        Text044 : Label 'THIRTEEN';
        Text045 : Label 'FOURTEEN';
        Text046 : Label 'FIFTEEN';
        Text047 : Label 'SIXTEEN';
        Text048 : Label 'SEVENTEEN';
        Text049 : Label 'EIGHTEEN';
        Text050 : Label 'NINETEEN';
        Text051 : Label 'TWENTY';
        Text052 : Label 'THIRTY';
        Text053 : Label 'FORTY';
        Text054 : Label 'FIFTY';
        Text055 : Label 'SIXTY';
        Text056 : Label 'SEVENTY';
        Text057 : Label 'EIGHTY';
        Text058 : Label 'NINETY';
        Text059 : Label 'THOUSAND';
        Text060 : Label 'MILLION';
        Text061 : Label 'BILLION';
        Series : Record "No. Series";
        line : Record "No. Series Line";
        sales : Record "Sales & Receivables Setup";
        payables : Record "Purchases & Payables Setup";
        "dimension value" : Record "Dimension Value";
        tempstr : Text[30];
        Reletionship : Record "No. Series Relationship";
        OnesText : array [20] of Text[30];
        TensText : array [10] of Text[30];
        ExponentText : array [5] of Text[30];
        MyEmployee : Record Employee;
        MyHRInformation : Record "HR Information";
        "SalesNo." : Code[20];
        "PurchNo." : Code[20];
        MyItem : Record Item;
        d : Integer;
        m : Integer;
        y : Integer;
        newdate : Integer;
        Weekday : Text[30];
        l : Integer;
        n : Integer;
        j : Integer;
        counter : Integer;
        oldval : Text[30];
        newval : Text[30];
        MyManufacturing : Record "Manufacturing Setup";
        TransReservEntries : Record "Reservation Entry";
        ProdReservEntries : Record "Reservation Entry";
        ProdOrderComp : Record "Prod. Order Component";
        mRD_GJLine : Record "Gen. Journal Line";
        Dimension : Record Dimension;
        DimMgt : Codeunit DimensionManagement;
        Employee : Record Employee;
        EmpDimensionValue : Code[20];
        RecDSE : Record "Dimension Set Entry";
        CombCounts : Integer;
        Dim : array [3] of Text[30];
        z : Integer;
        DimTreeNode : Record "Dimension Set Tree Node";
        VendorRec : Record Vendor;

    procedure FormatNoText(var NoText : array [2] of Text[80];No : Decimal;CurrencyCode : Code[10]);
    var
        PrintExponent : Boolean;
        Ones : Integer;
        Tens : Integer;
        Hundreds : Integer;
        Exponent : Integer;
        NoTextIndex : Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        //NoText[1] := '****';

        if No < 1 then
          AddToNoText(NoText,NoTextIndex,PrintExponent,Text026)
        else begin
          for Exponent := 4 downto 1 do begin
            PrintExponent := false;
            Ones := No div POWER(1000,Exponent - 1);
            Hundreds := Ones div 100;
            Tens := (Ones mod 100) div 10;
            Ones := Ones mod 10;
            if Hundreds > 0 then begin
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text027);
            end;
            if Tens >= 2 then begin
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              if Ones > 0 then
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            end else
              if (Tens * 10 + Ones) > 0 then
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            if PrintExponent and (Exponent > 1) then
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000,Exponent - 1);
          end;
        end;

        AddToNoText(NoText,NoTextIndex,PrintExponent,Text028);
        AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        if CurrencyCode <> '' then
          AddToNoText(NoText,NoTextIndex,PrintExponent,CurrencyCode);
    end;

    local procedure AddToNoText(var NoText : array [2] of Text[80];var NoTextIndex : Integer;var PrintExponent : Boolean;AddText : Text[30]);
    begin
        PrintExponent := true;

        while STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) do begin
          NoTextIndex := NoTextIndex + 1;
          if NoTextIndex > ARRAYLEN(NoText) then
            ERROR(Text029,AddText);
        end;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText,'<');
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure SetJobTitlePositions();
    begin
        MyEmployee.RESET;
        if MyEmployee.FIND('-') then
          repeat
            if not MyHRInformation.GET(MyHRInformation."Table Name"::"Job Title",MyEmployee."Job Title") then begin
              MyHRInformation.INIT;
              MyHRInformation."Table Name" := MyHRInformation."Table Name" ::"Job Title";
              MyHRInformation.Code := MyEmployee."Job Title";
              MyHRInformation.Description := MyEmployee."Job Title";
              MyHRInformation.INSERT(true);
            end;
            if not MyHRInformation.GET(MyHRInformation."Table Name"::"Job Position",MyEmployee."Job Position Code") then begin
              MyHRInformation.INIT;
              MyHRInformation."Table Name" := MyHRInformation."Table Name" ::"Job Position";
              MyHRInformation.Code := MyEmployee."Job Position Code";
              MyHRInformation.Description := MyEmployee."Job Position Code";
              MyHRInformation.INSERT(true);
            end;
          until MyEmployee.NEXT =0;
    end;

    procedure Insship(transfer : Code[20];"TableNo." : Text[30];OldValue : Text[30];Newvalue : Text[30];FormID : Integer;user : Text[30]);
    begin
         /* IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message := user+' has post-Ship '+"TableNo."+' '+transfer+' from ';
          alert.Message += OldValue+' to '+Newvalue+'.';
          alert."No." := 'Shipment '+ "TableNo.";
          alert."Form ID" := FormID;
          alert."User ID" := user;
          alert.No := transfer;
          alert."modify/post":='has posted';
          alert.processed := FALSE;
          alert.viewed := FALSE;
        
          {CASE TRUE OF
          OldValue = 'area a' :
             oldval := 'area a';
          OldValue = 'area b':
          alert."Old Value" := 7;
          OldValue = 'area c':
          alert."Old Value" := 8;
          OldValue = 'JEDDAH':
          alert."Old Value" := 9;
          OldValue = 'PROD':
          alert."Old Value" := 10;
          OldValue = 'QC':
          alert."Old Value" := 11;
          OldValue = 'transit':
          alert."Old Value" := 12;
        END;
        
          CASE TRUE OF
          Newvalue = 'area a' :
             alert."New Value" := 6;
          Newvalue = 'area b':
          alert."New Value" := 7;
          Newvalue = 'area c':
          alert."New Value" := 8;
          Newvalue = 'JEDDAH':
          alert."New Value" := 9;
          Newvalue = 'PROD':
          alert."New Value" := 10;
          Newvalue = 'QC':
          alert."New Value" := 11;
          Newvalue = 'transit':
          alert."New Value" := 12;
          END;
          }
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          alert.Message := user+' has post-Ship '+"TableNo."+' '+transfer+' from ';
          alert.Message += OldValue+' to '+Newvalue+'.';
          alert."No." := 'Shipment '+ "TableNo.";
          alert."Form ID" := FormID;
          alert."User ID" := user;
          alert.No := transfer;
          alert.processed := FALSE;
          alert.viewed := FALSE;
        
          {CASE TRUE OF
            OldValue = 'area a' :
             alert."Old Value" := 6;
            OldValue = 'area b':
            alert."Old Value" := 7;
            OldValue = 'area c':
            alert."Old Value" := 8;
            OldValue = 'JEDDAH':
            alert."Old Value" := 9;
            OldValue = 'PROD':
            alert."Old Value" := 10;
            OldValue = 'QC':
            alert."Old Value" := 11;
            OldValue = 'transit':
            alert."Old Value" := 12;
          END;
        
          CASE TRUE OF
            Newvalue = 'area a' :
             alert."New Value" := 6;
            Newvalue = 'area b':
            alert."New Value" := 7;
            Newvalue = 'area c':
            alert."New Value" := 8;
            Newvalue = 'JEDDAH':
            alert."New Value" := 9;
            Newvalue = 'PROD':
            alert."New Value" := 10;
            Newvalue = 'QC':
            alert."New Value" := 11;
            Newvalue = 'transit':
            alert."New Value" := 12;
          END;
          }
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
         */

    end;

    procedure InsertRec(transfer : Code[20];"TableNo." : Text[30];OldValue : Text[30];Newvalue : Text[30];FormID : Integer;user : Text[30]);
    begin
         /* IF alert.ISEMPTY THEN BEGIN
            counter := alert."Entry no" + 1;
            alert.INIT;
            alert."Entry no" := counter;
            alert.Message := user+' has post-Receipt '+"TableNo."+' '+transfer+' from ';
            alert.Message += OldValue+' to '+Newvalue+'.';
            alert."No." := 'Receipt '+ "TableNo.";
            alert."Form ID" := FormID;
            alert."User ID" := user;
            alert.No := transfer;
            alert.processed := FALSE;
            alert.viewed := FALSE;
        
          {
          CASE TRUE OF
          OldValue = 'area a' :
             alert."Old Value" := 6;
          OldValue = 'area b':
          alert."Old Value" := 7;
          OldValue = 'area c':
          alert."Old Value" := 8;
          OldValue = 'JEDDAH':
          alert."Old Value" := 9;
          OldValue = 'PROD':
          alert."Old Value" := 10;
          OldValue = 'QC':
          alert."Old Value" := 11;
          OldValue = 'transit':
          alert."Old Value" := 12;
        END;
        
          CASE TRUE OF
          Newvalue = 'area a' :
             alert."New Value" := 6;
          Newvalue = 'area b':
          alert."New Value" := 7;
          Newvalue = 'area c':
          alert."New Value" := 8;
          Newvalue = 'JEDDAH':
          alert."New Value" := 9;
          Newvalue = 'PROD':
          alert."New Value" := 10;
          Newvalue = 'QC':
          alert."New Value" := 11;
          Newvalue = 'transit':
          alert."New Value" := 12;
          END;
          }
            alert.Date := TODAY;
            alert.Time := TIME;
            alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message := user+' has post-Receipt '+"TableNo."+' '+transfer+' from ';
          alert.Message += OldValue+' to '+Newvalue+'.';
        
          alert."No." := 'Receipt '+ "TableNo.";
          alert."Form ID" := FormID;
          alert."User ID" := user;
          alert.No := transfer;
          alert.processed := FALSE;
          alert.viewed := FALSE;
        
          {CASE TRUE OF
            OldValue = 'area a' :
             alert."Old Value" := 6;
            OldValue = 'area b':
            alert."Old Value" := 7;
            OldValue = 'area c':
            alert."Old Value" := 8;
            OldValue = 'JEDDAH':
            alert."Old Value" := 9;
            OldValue = 'PROD':
            alert."Old Value" := 10;
            OldValue = 'QC':
            alert."Old Value" := 11;
            OldValue = 'transit':
            alert."Old Value" := 12;
          END;
        
          CASE TRUE OF
            Newvalue = 'area a' :
             alert."New Value" := 6;
            Newvalue = 'area b':
            alert."New Value" := 7;
            Newvalue = 'area c':
            alert."New Value" := 8;
            Newvalue = 'JEDDAH':
            alert."New Value" := 9;
            Newvalue = 'PROD':
            alert."New Value" := 10;
            Newvalue = 'QC':
            alert."New Value" := 11;
            Newvalue = 'transit':
            alert."New Value" := 12;
          END;
          }
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        */

    end;

    procedure InsertAlertProductionBOM(prod : Code[20];"TableNo." : Text[30];"Field" : Text[30];OldValue : Option;Newvalue : Option;FormID : Integer;user : Text[30]);
    begin
        /*  IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
        
          CASE TRUE OF
            OldValue = 0:
              oldval := 'New';
            OldValue = 1:
              oldval := 'Certified';
            OldValue = 2:
              oldval := 'Under Development';
            OldValue = 3:
              oldval := 'Closed';
          END;
        
          CASE TRUE OF
            Newvalue = 0:
              newval := 'New';
            Newvalue = 1:
              newval := 'Certified';
            Newvalue = 2:
              newval := 'Under Development';
            Newvalue = 3:
              newval := 'Closed';
          END;
        
          alert.Message:=user+' has modified '+"TableNo."+' '+prod+' from '+oldval+' to '+newval+' in field '+Field+'.';
          alert."No." := "TableNo.";
          alert."Form ID" := FormID;
          alert."User ID" := user;
          alert.No := prod;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
        
          CASE TRUE OF
            OldValue = 0:
              oldval := 'New';
            OldValue = 1:
              oldval := 'Certified';
            OldValue = 2:
              oldval := 'Under Development';
            OldValue = 3:
              oldval := 'Closed';
          END;
        
          CASE TRUE OF
            Newvalue = 0:
              newval := 'New';
            Newvalue = 1:
              newval := 'Certified';
            Newvalue = 2:
              newval := 'Under Development';
            Newvalue = 3:
              newval := 'Closed';
          END;
        
          alert.Message:=user+' has modified '+"TableNo."+' '+prod+' from '+oldval+' to '+newval+' in field '+Field+'.';
          alert."Form ID" := FormID;
          alert."No." := "TableNo.";
          alert."Bank No." := Field;
          alert."User ID" := user;
          alert.No := prod;
          alert.processed := FALSE;
          alert.viewed := FALSE;
        
          alert."No." := "TableNo.";
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
         */

    end;

    procedure InsertAlertprodorder(prodorder : Code[20];"TableNo." : Text[30];"Field" : Text[30];FormID : Integer;user : Text[30]);
    begin
         /* IF alert.ISEMPTY THEN BEGIN
            counter := alert."Entry no" + 1;
            alert.INIT;
            alert."Entry no" := counter;
            alert.Message:=user+' has created '+"TableNo."+' '+prodorder+'.';
            alert."Form ID" := FormID;
            IF "TableNo." = 'Item' THEN
               alert."No." := "TableNo." +' created'
            ELSE
              alert."No." := "TableNo.";
            alert.No := prodorder;
            alert."User ID" := user;
            alert.processed := FALSE;
            alert.viewed := FALSE;
            alert.Date := TODAY;
            alert.Time := TIME;
            alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message:=user+' has created '+"TableNo."+' '+prodorder+'.';
          alert."Form ID" := FormID;
          alert."No." := "TableNo.";
          alert."User ID" := user;
          alert.No := prodorder;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
         */

    end;

    procedure Date2Hijri(MyDate : Date;MyFormat : Integer) : Text[30];
    var
        MyValue : Integer;
    begin
        d := DATE2DMY(MyDate,1);
        m := DATE2DMY(MyDate,2);
        y := DATE2DMY(MyDate,3);

        if (y > 1582) or (y = 1582) and (m > 10) or (y = 1582) and (m = 10) and (d > 14) then
          newdate :=
           GetIntPart((1461 * (y + 4800 + GetIntPart((m-14) / 12 ))) / 4) +
           GetIntPart((367 * (m-2-12 * (GetIntPart((m-14) / 12 )))) / 12) -
           GetIntPart((3 * (GetIntPart( (y + 4900 + GetIntPart((m-14) /
           12)) / 100 ))) / 4) + d - 32075
        else
          newdate := 367 * y - GetIntPart((7 * (y + 5001 + GetIntPart((m-9) /
          7))) / 4) + GetIntPart((275 * m) / 9) + d + 1729777;
        MyValue := newdate mod 7;
        Weekday := GetWeekDay(MyValue);

        l := newdate - 1948440 + 10632;
        n := GetIntPart((l - 1) / 10631);
        l := l - 10631 * n + 354;

        j := (GetIntPart((10985 - l) / 5316)) * (GetIntPart((50 * l) / 17719)) +
         (GetIntPart(l / 5670)) * (GetIntPart((43 * l) / 15238));
        l := l - (GetIntPart((30 - j) / 15)) * (GetIntPart((17719 * j) /50)) -
         (GetIntPart(j / 16)) * (GetIntPart((15238 * j) / 43)) + 29;

        m := GetIntPart((24 * l) / 709);
        d := l - GetIntPart((709 * m) / 24);
        y := 30 * n + j - 30;

        case MyFormat of
          0 : exit (STRSUBSTNO ('%1/%2/%3',d,m,y));
          1 : exit (STRSUBSTNO ('%1 %2 %3 %4 A.H.',Weekday,d,GetLunarMonth(m),y));
        end;
    end;

    procedure GetWeekDay(Day : Integer) : Text[30];
    begin
        case Day of
        0 : exit ('Monday');
        1 : exit ('Tuesday');
        2 : exit ('Wednesday');
        3 : exit ('Thursday');
        4 : exit ('Friday');
        5 : exit ('Saturday');
        6 : exit ('Sunday');
        end;
    end;

    procedure GetLunarMonth(Month : Integer) : Text[30];
    begin
        case Month of
        1 : exit ('Muharram');
        2 : exit ('Safar');
        3 : exit ('Rabi I');
        4 : exit ('Rabi II');
        5 : exit ('Jumada I');
        6 : exit ('Jumada II');
        7 : exit ('Rajab');
        8 : exit ('Sha''ban');
        9 : exit ('Ramadan');
        10 : exit ('Shawwal');
        11 : exit ('Dhu''l-Qa''dah');
        12 : exit ('Dhu''l-Hijja');
        end;
    end;

    procedure GetIntPart(FullValue : Decimal) NewValue : Integer;
    begin
        NewValue := ROUND(FullValue,1,'<');
        exit(NewValue);
    end;

    procedure InsertAlertSalesRelease(sales : Code[20];"TableNo." : Text[30];"Field" : Text[30];OldValue : Text[30];Newvalue : Option;FormID : Integer;user : Text[30];Salesorder : Record "Sales Header");
    begin
        /*IF alert.ISEMPTY THEN BEGIN
           counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message:=user+' has released '+"TableNo."+' '+sales+'.';
          alert."Form ID" := FormID;
          alert."No." :='Release '+ "TableNo.";
          alert."User ID" := user;
          alert.No := sales;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message:=user+' has released '+"TableNo."+' '+sales+'.';
          alert."Form ID" := FormID;
          alert."No." :='Release '+ "TableNo.";
          alert."User ID" := user;
          alert.No := sales;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
         */

    end;

    procedure InsertAlertprodorderstatus(prodorder : Code[20];"TableNo." : Text[30];prodorder2 : Code[20];"Field" : Text[30];FormID : Integer;user : Text[30]);
    begin
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message:=user+' has changed status of '+"TableNo."+' '+prodorder;
          alert.Message+=' to '+Field+' '+prodorder2+'.';
          alert."Form ID" := FormID;
          alert."No." :=Field;
          alert."User ID" := user;
          alert.No := prodorder2;
          alert."Old No" := ' '+prodorder2;
          alert."in field" :=Field ;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message:=user+' has changed status of '+"TableNo."+' '+prodorder;
          alert.Message+=' to '+Field+' '+prodorder2+'.';
          alert."Form ID" := FormID;
          alert."No." :=Field;
          alert."User ID" := user;
          alert.No := prodorder2;
          alert."Old No" := ' '+prodorder2;
          alert."in field" := Field;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert."to" := ' to ';
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
         */

    end;

    procedure InsertAlertProjectManager(User : Code[20];project : Code[10];Description : Text[50]);
    begin
        //AB.1++
        /*MyEmployee.RESET;
        MyEmployee.SETRANGE(MyEmployee."No.",User);
        IF MyEmployee.FIND('-') THEN;
        IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message := User+' has been assigned as a Project Manager on Project '+project+' '+Description;
          alert."No." := 'Project Manager';
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        
        END
        ELSE BEGIN
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          alert.Message := User+' has been assigned as a Project Manager on Project '+project+' '+Description;
          alert."No." := 'Project Manager';
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        //AB.1--
        */

    end;

    procedure InsertAlertDelete(prodorder : Code[20];"TableNo." : Text[30];"Field" : Text[30];FormID : Integer;user : Text[30]);
    begin
         /* IF alert.ISEMPTY THEN BEGIN
            counter := alert."Entry no" + 1;
            alert.INIT;
            alert."Entry no" := counter;
            alert.Message:=user+' has deleted '+"TableNo."+' '+prodorder+'.';
            alert."Form ID" := FormID;
            alert."No." := "TableNo.";
            alert.No := prodorder;
            alert."User ID" := user;
            alert.processed := FALSE;
            alert.viewed := FALSE;
            alert.Date := TODAY;
            alert.Time := TIME;
            alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message:=user+' has deleted '+"TableNo."+' '+prodorder+'.';
          alert."Form ID" := FormID;
          alert."No." := "TableNo.";
        
          alert."User ID" := user;
          alert.No := prodorder;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
         */

    end;

    procedure InsertAlertEstimator(prodorder : Code[20];"TableNo." : Text[30];"Field" : Text[30];FormID : Integer;user : Text[30]);
    begin
        //AB.3++
        /*  IF alert.ISEMPTY THEN BEGIN
            counter := alert."Entry no" + 1;
            alert.INIT;
            alert."Entry no" := counter;
            alert.Message:="TableNo."+' ' +prodorder+' has been assigned to '+ user+'.';
            alert."Form ID" := FormID;
            alert."No." := "TableNo.";
            alert.No := prodorder;
            alert."User ID" := user;
            alert.processed := FALSE;
            alert.viewed := FALSE;
            alert.Date := TODAY;
            alert.Time := TIME;
            alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message:="TableNo."+' ' +prodorder+' has been assigned to '+ user+'.';
          alert."Form ID" := FormID;
          alert."No." := "TableNo.";
        
          alert."User ID" := user;
          alert.No := prodorder;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        //AB.3--
        */

    end;

    procedure InsertAlertItem2ProductionBOM(prod : Code[20];"TableNo." : Text[30];ProdRoutNo : Code[20];ProdRoutNamed : Text[30];ITemFormID : Integer;user : Text[30]);
    begin
        //AB.3++
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
        
          alert.Message:=user+' has assigned '+"TableNo."+' '+prod+' to '+ProdRoutNamed+' '+ProdRoutNo+'.';
          alert."No." := "TableNo.";
          alert."Form ID" := ITemFormID;
          alert."User ID" := user;
          alert.No := prod;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
        
          alert.Message:=user+' has assigned '+"TableNo."+' '+prod+' to '+ProdRoutNamed+' '+ProdRoutNo+'.';
          alert."Form ID" := ITemFormID;
          alert."No." := "TableNo.";
          alert."User ID" := user;
          alert.No := prod;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        //AB.3--
         */

    end;

    procedure InsertAlertPrintInvoice(prod : Code[20];"TableNo." : Text[30];PaymentNo : Code[20];SalesOrderNo : Text[30];ITemFormID : Integer;user : Text[30]);
    begin
        //AB.4++
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          IF  "TableNo." = 'Project Invoices' THEN
            alert.Message:=user+' has printed payment '+PaymentNo+' of Project '+prod+'.'
          ELSE
            alert.Message:=user+' has printed payment '+PaymentNo+' of Purchase Order '+prod+'.';
        
          alert."No." := "TableNo.";
          alert."Form ID" := ITemFormID;
          alert."User ID" := user;
          alert.No := prod;
          alert."in field" := PaymentNo;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          alert.Message:=user+' has printed payment '+PaymentNo+' of Project '+prod+'.';
          alert."Form ID" := ITemFormID;
          alert."No." := "TableNo.";
          alert."User ID" := user;
          alert.No := prod;
          alert."in field" := PaymentNo;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        //AB.4--
         */

    end;

    procedure "InsertAlertGenerateG/L"("No." : Code[20];"TableNo." : Text[30];PaymentNo : Code[20];SalesOrderNo : Text[30];ITemFormID : Integer;user : Text[30];CustNo : Code[20];ProjectNo : Code[10]);
    begin
        //AB.4++
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          IF  "TableNo." = 'Project Invoices' THEN
            alert.Message:=user+' has generated a G/L for payment '+PaymentNo+' of Project '+"No."+'.'
          ELSE
            alert.Message:=user+' has generated a G/L for payment '+PaymentNo+' of Purchase Order '+"No."+'.';
        
          alert."No." := "TableNo.";
          alert."Form ID" := ITemFormID;
          alert."User ID" := user;
          alert.No := "No.";
          alert."in field" := PaymentNo;
          alert."Bank No." := CustNo;
          alert."Old No" := ProjectNo;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END
        ELSE BEGIN
          //the alert table reaches the last record then increments the counter
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
        
          IF  "TableNo." = 'Project Invoices' THEN
            alert.Message:=user+' has generated a G/L for payment '+PaymentNo+' of Project '+"No."+'.'
          ELSE
            alert.Message:=user+' has generated a G/L for payment '+PaymentNo+' of Purchase Order '+"No."+'.';
        
          alert."Form ID" := ITemFormID;
          alert."No." :=  'Generate '+"TableNo.";
          alert."User ID" := user;
          alert.No := "No.";
          alert."in field" := PaymentNo;
          alert.processed := FALSE;
          alert.viewed := FALSE;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        //AB.4--
        */

    end;

    procedure InsertAlertApplicant(ApplicantNo : Code[20];ApplicantFullName : Text[100]);
    begin
        //AB.1++
        //MyEmployee.RESET;
        //MyEmployee.SETRANGE(MyEmployee."No.",User);
        //IF MyEmployee.FIND('-') THEN;
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message := 'New Applicant :' + ApplicantNo + ' - ' + ApplicantFullName+  ' was Successfully created';
          alert."No." := 'Applicant';
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        
        END
        ELSE BEGIN
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          alert.Message := 'New Applicant :' + ApplicantNo + ' - ' + ApplicantFullName+  ' was Successfully created';
          alert."No." := 'Applicant';
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        //AB.1--
         */

    end;

    procedure InsertAlertEmployee(EmployeeNo : Code[20];EmployeeFullName : Text[100]);
    begin
        //AB.1++
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message := 'New Employee Hired :' + EmployeeNo + ' - ' +EmployeeFullName+  ' was Successfully created';
          alert."No." := 'Employee';
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        
        END
        ELSE BEGIN
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          alert.Message := 'New Employee Hired :' + EmployeeNo + ' - ' +EmployeeFullName+  ' was Successfully created';
          alert."No." := 'Employee';
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
        */

    end;

    procedure InsertAlert(TableNo : Text[30];LocalMessage : Text[250]);
    begin
        //AB.1++
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message := LocalMessage;
          alert."No." := TableNo;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        
        END
        ELSE BEGIN
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          alert.Message := LocalMessage;
          alert."No." := TableNo;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert.INSERT;
        END;
         */

    end;

    procedure InsertAlertProjectRequest(TableNo : Text[30];LocalMessage : Text[250];ProjectNo : Code[10];EmployeeNo : Code[20];LocalDate : Date);
    begin
        //AB.1++
        /*IF alert.ISEMPTY THEN BEGIN
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter;
          alert.Message := LocalMessage;
          alert."No." := TableNo;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert."Employee No." := EmployeeNo;
          alert."Project No." := ProjectNo;
          alert."Project Date" := LocalDate;
          alert.INSERT;
        
        END
        ELSE BEGIN
          alert.FIND('+');
          counter := alert."Entry no" + 1;
          alert.INIT;
          alert."Entry no" := counter ;
          alert.Message := LocalMessage;
          alert."No." := TableNo;
          alert.Date := TODAY;
          alert.Time := TIME;
          alert."Employee No." := EmployeeNo;
          alert."Project No." := ProjectNo;
          alert."Project Date" := LocalDate;
          alert.INSERT;
        END;
         */

    end;

    procedure GetLastProjectContractLineNo(LocalVarProjectNo : Code[10];LocalVarCustomer : Code[20];LocalVarContract : Code[15];LocalVarTitleCode : Code[10];LocalVarPosCode : Code[10]) : Integer;
    begin
        /*LocalRecProjectContractLine.SETRANGE("Project No.",LocalVarProjectNo);
        LocalRecProjectContractLine.SETRANGE("Customer No.",LocalVarCustomer);
        LocalRecProjectContractLine.SETRANGE("Contract No.",LocalVarContract);
        LocalRecProjectContractLine.SETRANGE("Employee Job Title",LocalVarTitleCode);
        LocalRecProjectContractLine.SETRANGE("Employee Job Position",LocalVarPosCode);
        IF LocalRecProjectContractLine.FINDLAST THEN
          EXIT(LocalRecProjectContractLine."Line No." +1)
        ELSE
          EXIT(1);
        */

    end;

    procedure UpdateSalesLine(TWONODET : Text;ResID : Text;ProjectID : Text;UserLoc : Text) : Text[100];
    var
        SalesLine : Record "Sales Line";
        SetID : Integer;
        IntegrationMsg : Text[100];
    begin
        /*
        SalesLine.SETRANGE("Testing Work Order No",TWONODET);
        SalesLine.SETRANGE("No.",ResID);
        IF SalesLine.FINDFIRST THEN BEGIN
          IF EVALUATE(SetID,CheckCombAvail(SalesLine."Dimension Set ID",ProjectID,UserLoc)) THEN BEGIN
          SalesLine."Dimension Set ID" := SetID;
          SalesLine.MODIFY;
          EXIT('');
          END
          ELSE  BEGIN
           IntegrationMsg := CheckCombAvail(SalesLine."Dimension Set ID",ProjectID,UserLoc);
           SalesLine."Integration Message" := IntegrationMsg;
           SalesLine.MODIFY;
           EXIT(IntegrationMsg);
           END;
        END;
        */

    end;

    procedure UpdateSalesHeader(TWONODET : Text;SODate : Date;FSODate : Date);
    var
        SalesHeader : Record "Sales Header";
    begin
        /*
        SalesHeader.SETRANGE("External Document No.",TWONODET);
        IF SalesHeader.FINDFIRST THEN BEGIN
            SalesHeader."Order Date" := SODate;
            SalesHeader.TWOFinishedDate := FSODate;
            SalesHeader.MODIFY;
        END;
        */

    end;

    procedure CheckCombAvail(SetID : Integer;ProjectID : Text;UserLocation : Text) : Text[100];
    var
        DimensionSetEntry : Record "Dimension Set Entry";
        RecProject : Record "Dimension Set Entry";
        RecUserLoc : Record "Dimension Set Entry";
        NewID : Integer;
        UserLoc : Integer;
        Rec1 : array [3] of Text;
        Rec2 : array [3] of Text;
        IntMsg : Text[100];
    begin
           RecProject.INIT;
           RecProject."Dimension Code" := 'PROJECT';
           RecProject."Dimension Value Code" := ProjectID;
           RecUserLoc.INIT;
           RecUserLoc."Dimension Code" := 'AREA';
           RecUserLoc."Dimension Value Code" := UserLocation;
           if (ProjectID <> '') and (UserLocation <> '') then
            CombCounts := 4
           else if (ProjectID = '') and (UserLocation = '') then
            CombCounts := 2
           else
            CombCounts := 3;

           Rec1[1] := 'PROJECT';
           Rec1[2] := ProjectID;
           Rec2[1] := 'AREA';
           Rec2[2] := UserLocation;
           IntMsg := CheckDimension(Rec1) + CheckDimension(Rec2);
           if IntMsg <> '' then
             exit(IntMsg);
           NewID := CheckSetID(SetID,Rec1,Rec2,CombCounts);
           if (NewID <> 0) then
              exit(FORMAT(NewID))
           else
             begin
               CLEAR(DimensionSetEntry);
               if DimensionSetEntry.FINDLAST then
                 NewID := DimensionSetEntry."Dimension Set ID" + 1;
               DimensionSetEntry.LOCKTABLE;
               if ProjectID <> ''then begin
                RecProject."Dimension Set ID" := NewID;
                RecProject.INSERT(true);
                end;
                if UserLocation <> '' then begin
                RecUserLoc."Dimension Set ID" := NewID;
                RecUserLoc.INSERT(true);
                end;
                DimensionSetEntry.SETRANGE("Dimension Set ID",SetID);
                DimensionSetEntry.SETRANGE("Dimension Code",'Division');
                if DimensionSetEntry.FINDFIRST then
                begin
                  RecDSE.INIT;
                  RecDSE."Dimension Set ID" := NewID;
                  RecDSE."Dimension Code"  := DimensionSetEntry."Dimension Code";
                  RecDSE."Dimension Value Code" := DimensionSetEntry."Dimension Value Code";
                  RecDSE.INSERT(true);
                end;
                DimensionSetEntry.SETRANGE("Dimension Set ID",SetID);
                DimensionSetEntry.SETRANGE("Dimension Code",'Department');
                if DimensionSetEntry.FINDFIRST then
                begin
                  RecDSE.INIT;
                  RecDSE."Dimension Set ID" := NewID;
                  RecDSE."Dimension Code"  := DimensionSetEntry."Dimension Code";
                  RecDSE."Dimension Value Code" := DimensionSetEntry."Dimension Value Code";
                  RecDSE.INSERT(true);
                end;
                DimensionSetEntry.RESET;
                //DimSetEntry.SETFILTER("Dimension Set ID",'%1..%2',LastDimID,LastDimID+10);
                if DimensionSetEntry.FINDFIRST then
                repeat
                 DimTreeNode.SETRANGE("Dimension Value ID",DimensionSetEntry."Dimension Value ID");
                  DimTreeNode.SETRANGE("Parent Dimension Set ID",DimensionSetEntry."Dimension Set ID");
                  if not DimTreeNode.FINDFIRST then
                  begin
                   DimTreeNode.INIT;
                   DimTreeNode."Parent Dimension Set ID":=DimensionSetEntry."Dimension Set ID";
                   DimTreeNode."Dimension Value ID":=DimensionSetEntry."Dimension Value ID";
                   DimTreeNode."Dimension Set ID":=DimensionSetEntry."Dimension Set ID";
                   DimTreeNode."In Use":=true;
                   //DimTreeNode.EDM:=TRUE;
                   DimTreeNode.INSERT;
                  end;
                until DimensionSetEntry.NEXT=0;
             end;
           exit(FORMAT(NewID));
    end;

    procedure CheckSetID(SetID : Integer;Rec1 : array [3] of Text;Rec2 : array [3] of Text;CombCount : Integer) : Integer;
    var
        DimensionSetEntry : Record "Dimension Set Entry";
        SetIDArray : array [10000] of Integer;
        i : Integer;
        p : Integer;
        DimensionSetEntryStand : Record "Dimension Set Entry";
        DimensionSetEntryStandRow : Record "Dimension Set Entry";
        ArrayLastI : Integer;
        SetIDArrayLen : Integer;
        RecCount : Integer;
    begin
        //Fill Array with Set ID
        DimensionSetEntry.SETFILTER("Dimension Set ID",'<>0');
        if DimensionSetEntry.FINDFIRST then
         SetIDArray[1] := DimensionSetEntry."Dimension Set ID";
        //SetIDArrayLen := ARRAYLEN(SetIDArray,100);
        ArrayLastI := 0;
        i := 1;
        while ( (i <= 1000) and (ArrayLastI = 0)) do begin
            //IF (SetIDArray[i] = 0) AND (ArrayLastI = 0) THEN
          if  (SetIDArray[i] = 0) then
              begin
                 ArrayLastI := i;
              end;
            i := i + 1;
        end;

        if DimensionSetEntry.FINDFIRST then
          repeat
              p := 1;
              i:=1;
            while ((i <= 1000) and ( p = 1)) do begin
             if DimensionSetEntry."Dimension Set ID" = SetIDArray[i] then
                p := 0;
             i := i+1;
             end;
            if p = 1 then
              begin
                 SetIDArray[ArrayLastI] := DimensionSetEntry."Dimension Set ID";
                 ArrayLastI := ArrayLastI + 1;
              end;
        until DimensionSetEntry.NEXT = 0;
        //-----------------------
          for i := 1 to 1000 do begin
            CLEAR(DimensionSetEntry);
            DimensionSetEntry.SETRANGE("Dimension Set ID",SetIDArray[i]);
            if DimensionSetEntry.FINDSET then
              repeat
                p := 0;
                RecCount := DimensionSetEntry.COUNT;
                if  RecCount = CombCount then
                  begin
                    CLEAR(DimensionSetEntryStand);
                    DimensionSetEntryStand.SETRANGE("Dimension Set ID",DimensionSetEntry."Dimension Set ID");
                    DimensionSetEntryStand.SETRANGE("Dimension Code",'Department');
                    if DimensionSetEntryStand.FINDFIRST then begin
                      DimensionSetEntryStandRow.SETRANGE("Dimension Set ID",SetID);
                      if DimensionSetEntryStandRow.FINDFIRST then
                        begin
                          CLEAR (DimensionSetEntryStandRow);
                          DimensionSetEntryStandRow.SETRANGE("Dimension Set ID",SetID);
                          DimensionSetEntryStandRow.SETRANGE("Dimension Code",'Department');
                          if DimensionSetEntryStandRow.FINDFIRST then begin
                          if DimensionSetEntryStandRow."Dimension Value Code" = DimensionSetEntryStand."Dimension Value Code" then
                            p := p + 1;
                          end;
                        end;
                    end;
                    CLEAR(DimensionSetEntryStand);
                    DimensionSetEntryStand.SETRANGE("Dimension Set ID",DimensionSetEntry."Dimension Set ID");
                    DimensionSetEntryStand.SETRANGE("Dimension Code",'Division');
                    if DimensionSetEntryStand.FINDFIRST then begin
                      DimensionSetEntryStandRow.SETRANGE("Dimension Set ID",SetID);
                      if DimensionSetEntryStandRow.FINDFIRST then
                        begin
                          CLEAR (DimensionSetEntryStandRow);
                          DimensionSetEntryStandRow.SETRANGE("Dimension Set ID",SetID);
                          DimensionSetEntryStandRow.SETRANGE("Dimension Code",'Division');
                          if DimensionSetEntryStandRow.FINDFIRST then begin
                          if DimensionSetEntryStandRow."Dimension Value Code" = DimensionSetEntryStand."Dimension Value Code" then
                             p := p + 1;
                          end;
                      end;
                    end;
                    CLEAR(DimensionSetEntryStand);
                    DimensionSetEntryStand.SETRANGE("Dimension Set ID",DimensionSetEntry."Dimension Set ID");
                    DimensionSetEntryStand.SETRANGE("Dimension Code",Rec1[1]);
                    if DimensionSetEntryStand.FINDFIRST then begin
                    if Rec1[2] = DimensionSetEntryStand."Dimension Value Code" then
                        p := p + 1;
                    end;
                    CLEAR(DimensionSetEntryStand);
                    DimensionSetEntryStand.SETRANGE("Dimension Set ID",DimensionSetEntry."Dimension Set ID");
                    DimensionSetEntryStand.SETRANGE("Dimension Code",Rec2[1]);
                    if DimensionSetEntryStand.FINDFIRST then begin
                    if Rec2[2] = DimensionSetEntryStand."Dimension Value Code" then
                        p := p + 1;
                    end;
                    if p = CombCount then
                      exit(DimensionSetEntry."Dimension Set ID")
                  end;
              until DimensionSetEntry.NEXT = 0;
          end;
        exit(0);

        //ELSE
        // EXIT(0);
    end;

    local procedure CheckDimension(Rec : array [2] of Text[30]) : Text[100];
    var
        DimensionValue : Record "Dimension Value";
        P : Boolean;
    begin
        P := false ;
        if Rec[2] = '' then
          exit('');
        DimensionValue.SETRANGE("Dimension Code",Rec[1]);
        if DimensionValue.FINDFIRST then repeat
          if Rec[2] = DimensionValue.Code then
            P := true;
          until DimensionValue.NEXT = 0;
        if not P then
          exit('The '+Rec[1]+' Dimension('+Rec[2]+') does not exit in the System Dimensions/Dimension Value')
        else
        exit('');
    end;

    procedure UpdateSalesLine2(TWONODET : Code[20];ResourceID : Code[20]);
    var
        SalesLine : Record "Sales Line";
        SalesHeader : Record "Sales Header";
    begin
        /*
        SalesHeader.SETRANGE("External Document No.",TWONODET);
        IF SalesHeader.FINDFIRST THEN
          BEGIN
            SalesLine.SETRANGE("Document No.",SalesHeader."No.");
            SalesLine.SETRANGE("No.",ResourceID);
            IF SalesLine.FINDFIRST THEN BEGIN
              SalesLine."Testing Work Order No" := TWONODET;
              SalesLine.MODIFY;
              END;
          END;
        */

    end;

    procedure ModifyEntry(TableID : Integer;DocumnetNo : Code[20];EntryNo : Integer);
    var
        ApprovalEntry : Record "Approval Entry";
    begin
        ApprovalEntry.SETRANGE("Table ID",TableID);
        ApprovalEntry.SETRANGE("Document No.",DocumnetNo);
        ApprovalEntry.SETRANGE("Entry No.",EntryNo + 1);
        if ApprovalEntry.FINDFIRST then begin
          ApprovalEntry.Status := ApprovalEntry.Status::Open;
          ApprovalEntry.MODIFY;
          end;
    end;

    procedure DeleteReq(No : Code[20]);
    begin
        /*Reqheader.SETRANGE("No.",No);
        IF Reqheader.FINDFIRST THEN
          Reqheader.DELETE;
        Reqline.SETRANGE("Document No.",No);
        IF Reqline.FINDSET THEN
          Reqline.DELETEALL;
          */

    end;

    procedure ReleaseRequest(No : Code[20]);
    begin
        /*PRH.SETRANGE("No.",No);
        IF PRH.FINDFIRST THEN BEGIN
          PRH.Status := PRH.Status::"3";
          PRH."Req. Status" := PRH."Req. Status"::"2";
          PRH.MODIFY;
          END;
        */

    end;
}

