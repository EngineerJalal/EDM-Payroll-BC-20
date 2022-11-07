codeunit 98003 "Datetime Mgt."
{
    trigger OnRun();
    begin
    end;

    var
        d : Integer;
        m : Integer;
        y : Integer;
        newDate : Decimal;
        WeekDay : Text[30];
        l : Integer;
        n : Integer;
        j : Integer;

    procedure Datetime(Date : Date;Time : Time) : Decimal;
    begin
        if (Date = 0D) then
          exit(0);

        IF Time = 0T THEN
          EXIT((Date-0D) * 86.4)
        ELSE
          EXIT(((Date-0D) * 86.4) + (Time - 0T)/1000000);
    end;

    procedure Datetime2Time(Datetime : Decimal) : Time;
    begin
        if Datetime = 0 then
          EXIT(0T);
        exit(0T + (Datetime mod 86.4) * 1000000);
    end;

    procedure Datetime2Date(Datetime : Decimal) : Date;
    begin
        if Datetime = 0 then
          exit(0D);
        EXIT(0D + ROUND(Datetime/86.4,1,'<'));
    end;

    procedure Datetime2Text(Datetime : Decimal) : Text[260];
    begin
        if Datetime = 0 then
          exit('')
        else
          exit(STRSUBSTNO('%1 %2',Datetime2Date(Datetime),Datetime2Time(Datetime)));
    end;

    procedure Text2Datetime(Text : Text[260]) : Decimal;
    var
        Pos : Integer;
        Date : Date;
        Time : Time;
    begin
        Text := DELCHR(Text,'<>',' ');
        if STRLEN(Text) = 0 then
          exit(0);

        Pos := STRPOS(Text,' ');
        if Pos = 0 then
          Pos := STRPOS(Text,'+');
        if Pos > 0 then begin
          EVALUATE(Date,COPYSTR(Text,1,Pos - 1));
          EVALUATE(Time,COPYSTR(Text,Pos + 1));
        end else begin
          EVALUATE(Date,Text);
          Time := 000000T;
        end;

        exit(Datetime(Date,Time));
    end;

    procedure GetDayDate(CurDate : Date) : Text[50];
    begin
        //MB.870+-
        if CurDate <> 0D then
          CASE DATE2DWY(CurDate,1) OF
            1:
              exit('Monday');
            2:
              exit('Tuesday');
            3:
              exit('Wednesday');
            4:
              exit('Thursday');
            5:
              exit('Friday');
            6:
              exit('Saturday');
            7:
              exit('Sunday');
          end;
    end;

    procedure Date2Hijri(Date : Date;Format : Integer) : Text[80];
    begin
        d := DATE2DMY(Date,1);
        m := DATE2DMY(Date,2);
        y := DATE2DMY(Date,3);

        if (y > 1582) or (y = 1582) and (m > 10) or (y = 1582) and (m = 10)
        and (d > 14) then
        newDate :=
        ROUND((1461 * (y + 4800 + ROUND((m-14) / 12 ,1,'<'))) / 4,1,'<') +
        ROUND((367 * (m-2-12 * (ROUND((m-14) / 12 ,1,'<')))) / 12,1,'<') -
        ROUND((3 * (ROUND( (y + 4900 + ROUND((m-14) /
        12,1,'<')) / 100 ))) / 4,1,'<') + d - 32075
        else
        newDate := 367 * y - ROUND((7 * (y + 5001 + ROUND((m-9) /
        7,1,'<'))) / 4,1,'<') +
        ROUND((275 * m) / 9,1,'<') + d + 1729777;

        WeekDay := GetWeekday(newDate mod 7);

        l := newDate - 1948440 + 10632;
        n := ROUND((l - 1) / 10631,1,'<');
        l := l - 10631 * n + 354;

        j := (ROUND((10985 - l) / 5316,1,'<')) * (ROUND((50 * l) / 17719,1,'<')) +
        (ROUND(l / 5670,1,'<')) * (ROUND((43 * l) / 15238,1,'<'));
        l := l - (ROUND((30 - j) / 15,1,'<')) * (ROUND((17719 * j) /50,1,'<')) -
        (ROUND(j / 16,1,'<')) * (ROUND((15238 * j) / 43,1,'<')) + 29;

        m := ROUND((24 * l) / 709,1,'<');
        d := l - ROUND((709 * m) / 24,1,'<');
        y := 30 * n + j - 30;

         case Format of
        0 : exit (STRSUBSTNO ('%1/%2/%3',d,m,y));
        1 : exit (STRSUBSTNO ('%1 %2 %3 %4 A.H.',WeekDay,d,GetLunarMonth(m),y));
        end;
    end;

    procedure GetWeekday(Day : Integer) : Text[30];
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

    procedure HijriToGeo(P_Hijri : Text[20]) : Date;
    var
        DateCtr : Date;
        Loop : Integer;
        HijriDate : Text[30];
    begin
        if P_Hijri = '' then exit(0D);
        DateCtr:= DMY2Date(1,1,2000);
        HijriDate:= '';

        repeat
          HijriDate:=  Date2Hijri(DateCtr,0);

          if HijriDate <> P_Hijri then
            DateCtr:=CALCDATE('+1D',DateCtr);
          Loop+=1;
        until (HijriDate = P_Hijri) or (Loop=10000);

        if Loop=10000 then ERROR('Hijri Date Format is wrong.') ; //EXIT(0D);

        exit(DateCtr)
    end;
}

