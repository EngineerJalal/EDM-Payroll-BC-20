codeunit 98015 "EDM Utility"
{
    // version EDM.IT,EDM.HRPY1

    // //
    // Developer: Ibrahim Turjman
    // Company: EDM
    // Description: Functions
    // //
    // FormatNoText(Text80 Dim 2,1450542270,'Currency Code');

    Permissions = TableData "G/L Entry" = imd,
                  TableData "Cust. Ledger Entry" = imd,
                  TableData "Item Ledger Entry" = imd,
                  TableData "Sales Header" = m,
                  TableData "Sales Line" = m,
                  TableData "Purchase Line" = imd,
                  TableData "Invoice Post. Buffer" = imd,
                  TableData "Vendor Posting Group" = imd,
                  TableData "Inventory Posting Group" = imd,
                  TableData "Sales Shipment Header" = imd,
                  TableData "Sales Shipment Line" = imd,
                  TableData "Sales Invoice Header" = imd,
                  TableData "Sales Invoice Line" = imd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = imd,
                  TableData "Purch. Rcpt. Header" = imd,
                  TableData "Purch. Rcpt. Line" = imd,
                  TableData "Purch. Inv. Header" = imd,
                  TableData "Purch. Inv. Line" = imd,
                  TableData "Purch. Cr. Memo Hdr." = imd,
                  TableData "Purch. Cr. Memo Line" = imd,
                  TableData "Drop Shpt. Post. Buffer" = imd,
                  TableData "VAT Entry" = imd,
                  TableData "Bank Account Ledger Entry" = imd,
                  //TableData TableData357=imd,
                  //TableData TableData359=imd,
                  TableData "Detailed Cust. Ledg. Entry" = imd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd,
                  TableData Employee = rimd,
                  TableData "Value Entry" = rm,
                  TableData "Item Entry Relation" = ri,
                  TableData "Value Entry Relation" = rid,
                  TableData "Return Shipment Header" = imd,
                  TableData "Return Shipment Line" = imd;

    trigger OnRun();
    var
        EmployeeJrnl: Record "Employee Journal Line";
        ReservationEntry: Record "Reservation Entry";
    begin
        Employee.FINDFIRST;
        repeat
            if Employee.Declared = Employee.Declared::Declared then begin
                Employee."Declaration Date" := Employee."Employment Date";
                Employee."NSSF Date" := Employee."Employment Date";
                Employee.MODIFY;
            end;
        until Employee.NEXT = 0;
        MESSAGE(' ');
    end;

    var
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        TxtAmnt: array[2] of Text[100];
        HundredsText: array[10] of Text[30];
        Flag: Boolean;
        Test: Boolean;
        FlagM: Boolean;
        TestM: Boolean;
        Curr: Code[50];
        Emp: Record Employee;
        d: Integer;
        m: Integer;
        y: Integer;
        newDate: Decimal;
        WeekDay: Text[30];
        l: Integer;
        n: Integer;
        j: Integer;
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        UploadedFileName: Text[1024];
        Employee: Record Employee;
        PayrollFunction: Codeunit "Payroll Functions";
        PayLedger: Record "Payroll Ledger Entry";
        GenJournal: Record "Gen. Journal Line";
        ExcelImport: Codeunit "Excel Importer";
        Text026: Label 'صفر';
        Text027: Label 'مائة';
        Text028: Label 'و';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label '" is already applied to %1 %2 for customer %3."';
        Text031: Label '" is already applied to %1 %2 for vendor %3."';
        Text032: Label 'واحد';
        Text033: Label 'اثنان';
        Text034: Label 'ثلاثة';
        Text035: Label 'اربعة';
        Text036: Label 'خمسة';
        Text037: Label 'ستة';
        Text038: Label 'سبعة';
        Text039: Label 'ثمانية';
        Text040: Label '"تسعة "';
        Text041: Label 'عشرة';
        Text042: Label 'احد عشر';
        Text043: Label 'اثنا عشر';
        Text044: Label 'ثلاثة عشر';
        Text045: Label 'اربعة عشر';
        Text046: Label 'خمسة عشر';
        Text047: Label 'ستة عشر';
        Text048: Label 'سبعة عشر';
        Text049: Label 'ثمانية عشر';
        Text050: Label 'تسعة عشر';
        Text051: Label 'عشرون';
        Text052: Label 'ثلاثون';
        Text053: Label 'اربعون';
        Text054: Label 'خمسون';
        Text055: Label 'ستون';
        Text056: Label 'سبعون';
        Text057: Label 'ثمانون';
        Text058: Label 'تسعون';
        Text059: Label 'الف';
        Text060: Label 'مليون';
        Text061: Label 'بليون';
        Text100: Label 'مائة';
        Text200: Label 'مائتان';
        Text300: Label 'ثلاثمائة';
        Text400: Label 'أربعمائة';
        Text500: Label 'خمسمائة';
        Text600: Label 'ستمائة';
        Text700: Label 'سبعمائة';
        Text800: Label 'ثمانمائة';
        Text900: Label 'تسعمائة';
        Text2000: Label 'الفان';
        Text062: Label 'الاف';
        Textt063: Label 'مليونان';
        Text064: Label 'ملايين';
        TextDollar: Label 'دولار اميركي';
        TextLira: Label 'ليرة لبنانية';
        Text003: Label 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
        Text004: Label 'Microsoft Excel Files (*.xl*)|*.xl*|All Files (*.*)|*.*';
        Text005: Label 'Word Documents (*.doc)|*.doc|All Files (*.*)|*.*';
        Text006: Label 'XML files (*.xml)|*.xml|All Files (*.*)|*.*';
        Text007: Label 'HTM files (*.htm)|*.htm|All Files (*.*)|*.*';
        Text008: Label 'XML Schema Files (*.xsd)|*.xsd|All Files (*.*)|*.*';
        Text009: Label 'XSL Transform Files(*.xslt)|*.xslt|All Files (*.*)|*.*';
        Text010: TextConst ENU = 'Imported from Excel ', ESM = 'Importado de Excel ', FRC = 'Importé d''Excel ', ENC = 'Imported from Excel ';
        Text011: TextConst ENU = 'Import Excel File', ESM = 'Importar fich. Excel', FRC = 'Importer fichier Excel', ENC = 'Import Excel File';
        IFLAG: Boolean;
        TFLAG: Boolean;
        FFlag: Boolean;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[30]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Thousands: Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        //NoText[1] := '****';
        IFLAG := false;
        TFLAG := false;
        FFlag := false;

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Flag := false;
                Test := false;
                FlagM := false;
                TestM := false;

                Ones := No div POWER(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, HundredsText[Hundreds]);
                    if (Tens <> 0) or (Ones <> 0) then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                end;
                if Tens >= 2 then
                    if Ones > 0 then begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                    end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                end else begin
                    if (Tens * 10 + Ones) > 0 then begin
                        if (Tens * 10 + Ones) > 10 then begin
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                        end
                        else
                            if (Tens * 10 + Ones) = 1 then begin
                                if Exponent > 1 then begin
                                    PrintExponent := true;
                                end
                                else
                                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                            end
                            else
                                if Tens * 10 + Ones = 2 then begin
                                    if Exponent > 1 then begin
                                        PrintExponent := true;
                                        Flag := true;
                                        FlagM := true;
                                    end
                                    else
                                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                                end
                                else
                                    if (Tens * 10 + Ones) > 2 then begin
                                        if (Tens * 10 + Ones) < 11 then begin
                                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                                            Test := true;
                                            TestM := true;
                                            PrintExponent := true;
                                        end;
                                    end
                    end
                end;
                if PrintExponent and (Exponent > 1) then begin
                    if Exponent = 2 then begin
                        if Flag = true then begin
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text2000);
                            if No mod 100 <> 0 then
                                AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                        end
                        else
                            if Test = true then begin
                                AddToNoText(NoText, NoTextIndex, PrintExponent, Text062);
                                if No mod 100 <> 0 then
                                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                            end
                            else begin
                                AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                                //IF No MOD 100 <>0 THEN
                                IF (No MOD 100 <> 0)
                                  OR (No MOD 1000 = 100)
                                  OR (No MOD 1000 = 200)
                                  OR (No MOD 1000 = 300)
                                  OR (No MOD 1000 = 400)
                                  OR (No MOD 1000 = 500)
                                  OR (No MOD 1000 = 600)
                                  OR (No MOD 1000 = 700)
                                  OR (No MOD 1000 = 800)
                                  OR (No MOD 1000 = 900)
                              THEN
                                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                            end;
                    end else
                        if Exponent = 3 then begin
                            if FlagM = true then begin
                                AddToNoText(NoText, NoTextIndex, PrintExponent, Textt063);
                                if (No mod 10000 <> 0) or (No mod 100000 <> 0) or (No mod 1000000 <> 0) then
                                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                            end
                            else
                                if TestM = true then begin
                                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text064);
                                    if (No mod 10000 <> 0) or (No mod 100000 <> 0) or (No mod 1000000 <> 0) then
                                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                                end
                                else begin
                                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                                    if (No mod 10000 <> 0) or (No mod 100000 <> 0) or (No mod 1000000 <> 0) then
                                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                                end;
                        end
                        else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                end;
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
        end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        IF No <> 0 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        if CurrencyCode <> '' then begin
            if CurrencyCode = 'USD' then
                Curr := ' ' + TextDollar
            else
                if CurrencyCode = 'LBP' then
                    Curr := ' ' + TextLira
        end
        else
            //Curr:=' '+TextLira;
            Curr := CurrencyCode;
        AddToNoText(NoText, NoTextIndex, PrintExponent, Curr);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := true;

        while STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ARRAYLEN(NoText) then
                ERROR(Text029, AddText);
        end;
        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
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

        HundredsText[1] := Text100;
        HundredsText[2] := Text200;
        HundredsText[3] := Text300;
        HundredsText[4] := Text400;
        HundredsText[5] := Text500;
        HundredsText[6] := Text600;
        HundredsText[7] := Text700;
        HundredsText[8] := Text800;
        HundredsText[9] := Text900;


        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure Datetime(Date: Date; Time: Time): Decimal;
    begin
        if (Date = 0D) then
            exit(0);

        IF Time = 0T THEN
            EXIT((Date - 0D) * 86.4)
        ELSE
            EXIT(((Date - 0D) * 86.4) + (Time - 0T) / 1000000);
    end;

    procedure Datetime2Time(Datetime: Decimal): Time;
    begin
        if Datetime = 0 then
            EXIT(0T);
        exit(000000T + (Datetime mod 86.4) * 1000000);
    end;

    procedure Datetime2Date(Datetime: Decimal): Date;
    begin
        if Datetime = 0 then
            exit(0D);
        EXIT(0D + ROUND(Datetime / 86.4, 1, '<'));
    end;

    procedure Datetime2Text(Datetime: Decimal): Text[260];
    begin
        if Datetime = 0 then
            exit('')
        else
            exit(STRSUBSTNO('%1 %2', Datetime2Date(Datetime), Datetime2Time(Datetime)));
    end;

    procedure Text2Datetime(Text: Text[260]): Decimal;
    var
        Pos: Integer;
        Date: Date;
        Time: Time;
    begin
        Text := DELCHR(Text, '<>', ' ');
        if STRLEN(Text) = 0 then
            exit(0);

        Pos := STRPOS(Text, ' ');
        if Pos = 0 then
            Pos := STRPOS(Text, '+');
        if Pos > 0 then begin
            EVALUATE(Date, COPYSTR(Text, 1, Pos - 1));
            EVALUATE(Time, COPYSTR(Text, Pos + 1));
        end else begin
            EVALUATE(Date, Text);
            Time := 000000T;
        end;

        exit(Datetime(Date, Time));
    end;

    procedure GetDayDate(CurDate: Date): Text[50];
    begin
        //MB.870+-
        IF CurDate <> 0D THEN
            CASE DATE2DWY(CurDate, 1) OF
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

    procedure Date2Hijri(Date: Date; Format: Integer): Text[80];
    begin
        d := DATE2DMY(Date, 1);
        m := DATE2DMY(Date, 2);
        y := DATE2DMY(Date, 3);

        if (y > 1582) or (y = 1582) and (m > 10) or (y = 1582) and (m = 10)
        and (d > 14) then
            newDate :=
            ROUND((1461 * (y + 4800 + ROUND((m - 14) / 12, 1, '<'))) / 4, 1, '<') +
            ROUND((367 * (m - 2 - 12 * (ROUND((m - 14) / 12, 1, '<')))) / 12, 1, '<') -
            ROUND((3 * (ROUND((y + 4900 + ROUND((m - 14) /
            12, 1, '<')) / 100))) / 4, 1, '<') + d - 32075
        else
            newDate := 367 * y - ROUND((7 * (y + 5001 + ROUND((m - 9) /
            7, 1, '<'))) / 4, 1, '<') +
            ROUND((275 * m) / 9, 1, '<') + d + 1729777;

        WeekDay := GetWeekday(newDate mod 7);

        l := newDate - 1948440 + 10632;
        n := ROUND((l - 1) / 10631, 1, '<');
        l := l - 10631 * n + 354;

        j := (ROUND((10985 - l) / 5316, 1, '<')) * (ROUND((50 * l) / 17719, 1, '<')) +
        (ROUND(l / 5670, 1, '<')) * (ROUND((43 * l) / 15238, 1, '<'));
        l := l - (ROUND((30 - j) / 15, 1, '<')) * (ROUND((17719 * j) / 50, 1, '<')) -
        (ROUND(j / 16, 1, '<')) * (ROUND((15238 * j) / 43, 1, '<')) + 29;

        m := ROUND((24 * l) / 709, 1, '<');
        d := l - ROUND((709 * m) / 24, 1, '<');
        y := 30 * n + j - 30;

        case Format of
            0:
                exit(STRSUBSTNO('%1/%2/%3', d, m, y));
            1:
                exit(STRSUBSTNO('%1 %2 %3 %4 A.H.', WeekDay, d, GetLunarMonth(m), y));
        end;
    end;

    procedure GetWeekday(Day: Integer): Text[30];
    begin
        case Day of
            0:
                exit('Monday');
            1:
                exit('Tuesday');
            2:
                exit('Wednesday');
            3:
                exit('Thursday');
            4:
                exit('Friday');
            5:
                exit('Saturday');
            6:
                exit('Sunday');
        end;
    end;

    procedure GetLunarMonth(Month: Integer): Text[30];
    begin
        case Month of
            1:
                exit('Muharram');
            2:
                exit('Safar');
            3:
                exit('Rabi I');
            4:
                exit('Rabi II');
            5:
                exit('Jumada I');
            6:
                exit('Jumada II');
            7:
                exit('Rajab');
            8:
                exit('Sha''ban');
            9:
                exit('Ramadan');
            10:
                exit('Shawwal');
            11:
                exit('Dhu''l-Qa''dah');
            12:
                exit('Dhu''l-Hijja');
        end;
    end;

    procedure HijriToGeo(P_Hijri: Text[20]): Date;
    var
        DateCtr: Date;
        Loop: Integer;
        HijriDate: Text[30];
    begin
        if P_Hijri = '' then exit(0D);
        DateCtr := DMY2Date(1, 1, 2000);
        HijriDate := '';

        repeat
            HijriDate := Date2Hijri(DateCtr, 0);

            if HijriDate <> P_Hijri then
                DateCtr := CALCDATE('+1D', DateCtr);
            Loop += 1;
        until (HijriDate = P_Hijri) or (Loop = 10000);

        if Loop = 10000 then ERROR('Hijri Date Format is wrong.'); //EXIT(0D);

        exit(DateCtr)
    end;

    procedure OpenFile(WindowTitle: Text[50]; DefaultFileName: Text[1024]; DefaultFileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt; FilterString: Text[250]; "Action": Option Open,Save): Text[260];
    begin
    end;
    /* //Stopped By EDM.MM
    var
        CommonDialogControl : OCX "{F9043C85-F6F2-101A-A3C9-08002B2F49FB}:'Microsoft Common Dialog Control,version 6.0'";
        "Filter" : Text[255];
    begin
        IF DefaultFileType = DefaultFileType::Custom THEN BEGIN
          GetDefaultFileType(DefaultFileName,DefaultFileType);
          Filter := FilterString;
        end else
          Filter := GetFilterString(DefaultFileType);

        CommonDialogControl.MaxFileSize := 2048;
        CommonDialogControl.FileName := DefaultFileName;
        CommonDialogControl.DialogTitle := WindowTitle;
        CommonDialogControl.Filter := Filter;
        CommonDialogControl.InitDir := DefaultFileName;

        if Action = Action::Open then
          CommonDialogControl.ShowOpen
        else
          CommonDialogControl.ShowSave;
        EXIT(CommonDialogControl.FileName);
    end;
    */
    procedure OpenFileWithName(DefaultFileName: Text[1024]): Text[260];
    var
        DefaultFileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt;
        FilterString: Text[250];
        "Action": Option Open,Save;
    begin
        GetDefaultFileType(DefaultFileName, DefaultFileType);
        if DefaultFileType = DefaultFileType::Custom then
            FilterString := Text003;

        exit(OpenFile('', DefaultFileName, DefaultFileType, FilterString, Action::Open));
    end;

    local procedure GetDefaultFileType(DefaultFileName: Text[1024]; var DefaultFileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt);
    begin
        case true of
            CheckFileNameForFileType(DefaultFileName, '.DOC'):
                DefaultFileType := DefaultFileType::Word;
            CheckFileNameForFileType(DefaultFileName, '.XLS'):
                DefaultFileType := DefaultFileType::Excel;
            CheckFileNameForFileType(DefaultFileName, '.TXT'):
                DefaultFileType := DefaultFileType::Custom;
            CheckFileNameForFileType(DefaultFileName, '.XML'):
                DefaultFileType := DefaultFileType::Xml;
            CheckFileNameForFileType(DefaultFileName, '.HTM'):
                DefaultFileType := DefaultFileType::Htm;
            CheckFileNameForFileType(DefaultFileName, '.XSD'):
                DefaultFileType := DefaultFileType::Xsd;
            CheckFileNameForFileType(DefaultFileName, '.XSLT'):
                DefaultFileType := DefaultFileType::Xslt;
            else
                DefaultFileType := DefaultFileType::Custom;
        end;
    end;

    local procedure CheckFileNameForFileType(DefaultFileName: Text[1024]; FileExtension: Text[5]): Boolean;
    var
        Position: Integer;
    begin
        Position := STRPOS(UPPERCASE(DefaultFileName), FileExtension);
        exit((Position > 0) and (Position - 1 = STRLEN(DefaultFileName) - STRLEN(FileExtension)));
    end;

    procedure GetFilterString(FileType: Option " ",Text,Excel,Word,Custom,Xml,Htm,Xsd,Xslt): Text[255];
    begin
        case FileType of
            FileType::Text:
                exit(Text003);
            FileType::Excel:
                exit(Text004);
            FileType::Word:
                exit(Text005);
            FileType::Xml:
                exit(Text006);
            FileType::Htm:
                exit(Text007);
            FileType::Xsd:
                exit(Text008);
            FileType::Xslt:
                exit(Text009);
            FileType::Custom:
                exit('');
        end;
    end;

    procedure ImportEmployeeJournalLine(JournalType: Option Absence,Benefit,Deductions);
    var
        index: Integer;
        RowNo: Integer;
        "Employee No.": Text[30];
        "Transaction Date": DateTime;
        InsertRow: Boolean;
        EmployeeJournalLine: Record "Employee Journal Line";
        Type: Code[30];
        Value: Decimal;
        Description: Text[50];
    begin
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;
        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        //ExcelBuf.ReadSheet;
        RowNo := 2;
        index := 0;
        if ExcelBuf.FIND('-') then begin
            repeat
                if ExcelBuf."Row No." = RowNo then begin
                    if ExcelBuf."Column No." = 1 then begin
                        EVALUATE("Employee No.", ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 2 then begin
                        EVALUATE("Transaction Date", ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 3 then begin
                        EVALUATE(Type, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 4 then begin
                        EVALUATE(Description, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 5 then begin
                        EVALUATE(Value, ExcelBuf."Cell Value as Text");
                        InsertRow := true;
                    end;

                    if InsertRow then begin
                        index := index + 1;
                        EmployeeJournalLine.INIT;
                        EmployeeJournalLine.VALIDATE("Employee No.", "Employee No.");
                        if JournalType = 0 then begin
                            EmployeeJournalLine.VALIDATE("Transaction Type", 'ABS');
                            EmployeeJournalLine.VALIDATE("Cause of Absence Code", Type);
                            EmployeeJournalLine."From Time" := DT2TIME("Transaction Date");
                            EmployeeJournalLine."To Time" := DT2TIME("Transaction Date");
                            EmployeeJournalLine."Starting Date" := DT2DATE("Transaction Date");
                            EmployeeJournalLine."Ending Date" := DT2DATE("Transaction Date");
                            EmployeeJournalLine.Type := 'ABSENCE';
                        end
                        else
                            EmployeeJournalLine.VALIDATE("Transaction Type", Type);
                        EmployeeJournalLine.Description := Description;
                        EmployeeJournalLine.VALIDATE("Transaction Date", DT2DATE("Transaction Date"));
                        if JournalType = 1 then
                            EmployeeJournalLine.Type := 'BENEFIT'
                        else
                            if JournalType = 2 then
                                EmployeeJournalLine.Type := 'DEDUCTIONS';
                        EmployeeJournalLine.Value := Value;
                        if JournalType = 0 then
                            EmployeeJournalLine."Calculated Value" := 1.5 * Value
                        else
                            EmployeeJournalLine."Calculated Value" := Value;
                        EmployeeJournalLine.INSERT(true);
                        //RowNo:=ExcelBuf."Row No.";
                        InsertRow := false;
                        RowNo += 1;
                    end;
                end;
            until ExcelBuf.NEXT = 0;
        end;
        MESSAGE('Imported Successfully');
        UploadedFileName := '';
    end;

    procedure UploadFile();
    var
        CommonDialogMgt: Codeunit "EDM Utility";
    begin
        UploadedFileName := CommonDialogMgt.OpenFile(Text011, '', 2, '', 0);
        FileName := UploadedFileName;
    end;

    procedure ImportAttendance();
    var
        index: Integer;
        RowNo: Integer;
        "Employee No.": Text[30];
        "Transaction Date": DateTime;
        InsertRow: Boolean;
        EmployeeJournalLine: Record "Employee Journal Line";
        Type: Code[30];
        Value: Decimal;
        Description: Text[50];
    begin
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;
        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        //ExcelBuf.ReadSheet;
        RowNo := 2;
        index := 0;
        if ExcelBuf.FIND('-') then begin
            repeat
                if ExcelBuf."Row No." = RowNo then begin
                    if ExcelBuf."Column No." = 1 then begin
                        EVALUATE("Employee No.", ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 2 then begin
                        EVALUATE("Transaction Date", ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 3 then begin
                        EVALUATE(Type, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 4 then begin
                        EVALUATE(Description, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 5 then begin
                        EVALUATE(Value, ExcelBuf."Cell Value as Text");
                        InsertRow := true;
                    end;

                    if InsertRow then begin
                        index := index + 1;
                        EmployeeJournalLine.INIT;
                        EmployeeJournalLine.VALIDATE("Employee No.", "Employee No.");
                        EmployeeJournalLine."Transaction Type" := 'ABS';
                        EmployeeJournalLine.VALIDATE("Cause of Absence Code", Type);
                        EmployeeJournalLine."From Time" := DT2TIME("Transaction Date");
                        EmployeeJournalLine."To Time" := DT2TIME("Transaction Date");
                        EmployeeJournalLine."Starting Date" := DT2DATE("Transaction Date");
                        EmployeeJournalLine."Ending Date" := DT2DATE("Transaction Date");
                        EmployeeJournalLine.Type := 'ABSENCE';
                        EmployeeJournalLine.Description := Description;
                        EmployeeJournalLine.VALIDATE("Transaction Date", DT2DATE("Transaction Date"));
                        EmployeeJournalLine.Value := Value;
                        EmployeeJournalLine."Calculated Value" := Value;
                        EmployeeJournalLine.INSERT(true);
                        //RowNo:=ExcelBuf."Row No.";
                        InsertRow := false;
                        RowNo += 1;
                    end;
                end;
            until ExcelBuf.NEXT = 0;
        end;
        MESSAGE('Imported Successfully');
        UploadedFileName := '';
    end;

    procedure ImportGeneralJournalTool();
    var
        index: Integer;
        RowNo: Integer;
        "Transaction Date": DateTime;
        InsertRow: Boolean;
        Template: Code[20];
        Line: Integer;
        AccountType: Text;
        AccountNo: Code[20];
        PostingDate: DateTime;
        DocNum: Code[20];
        Currency: Code[10];
        Amount: Decimal;
        AmountLCY: Decimal;
        Batch: Code[10];
    begin
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;
        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        //ExcelBuf.ReadSheet;
        RowNo := 2;
        index := 0;
        if ExcelBuf.FIND('-') then begin
            repeat
                if ExcelBuf."Row No." = RowNo then begin
                    if ExcelBuf."Column No." = 1 then begin
                        EVALUATE(Template, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 2 then begin
                        EVALUATE(Line, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 3 then begin
                        EVALUATE(AccountType, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 4 then begin
                        EVALUATE(AccountNo, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 5 then begin
                        EVALUATE(PostingDate, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 6 then begin
                        EVALUATE(DocNum, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 7 then begin
                        EVALUATE(Currency, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 8 then begin
                        EVALUATE(Amount, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 9 then begin
                        EVALUATE(AmountLCY, ExcelBuf."Cell Value as Text");
                    end;
                    if ExcelBuf."Column No." = 10 then begin
                        EVALUATE(Batch, ExcelBuf."Cell Value as Text");
                        InsertRow := true;
                    end;


                    if InsertRow then begin
                        index := index + 1;
                        GenJournal.INIT;
                        GenJournal."Journal Batch Name" := Batch;
                        GenJournal."Journal Template Name" := Template;
                        GenJournal."Line No." := Line;
                        GenJournal."Account Type" := GenJournal."Account Type"::"G/L Account";
                        GenJournal.VALIDATE("Account No.", AccountNo);
                        GenJournal.VALIDATE("Posting Date", DT2DATE(PostingDate));
                        GenJournal.VALIDATE("Document No.", DocNum);
                        GenJournal.VALIDATE("Currency Code", Currency);
                        GenJournal.VALIDATE(Amount, Amount);
                        GenJournal."Amount (LCY)" := AmountLCY;
                        GenJournal.INSERT(true);
                        //RowNo:=ExcelBuf."Row No.";
                        InsertRow := false;
                        RowNo += 1;
                    end;
                end;
            until ExcelBuf.NEXT = 0;
        end;
        MESSAGE('Imported Successfully');
        UploadedFileName := '';
    end;

    procedure ImportSchedule();
    var
        index: Integer;
        RowNo: Integer;
        "Employee No.": Text[30];
        "Employee Name": Text[100];
        Day1: Code[10];
        InsertRow: Boolean;
        Day2: Code[10];
        Day3: Code[10];
        Day4: Code[10];
        Day5: Code[10];
        Day6: Code[10];
        Day7: Code[10];
        Day8: Code[10];
        Day9: Code[10];
        Day10: Code[10];
        Day11: Code[10];
        Day12: Code[10];
        Day13: Code[10];
        Day14: Code[10];
        Day15: Code[10];
        Day16: Code[10];
        Day17: Code[10];
        Day18: Code[10];
        Day19: Code[10];
        Day20: Code[10];
        Day21: Code[10];
        Day22: Code[10];
        Day23: Code[10];
        Day24: Code[10];
        Day25: Code[10];
        Day26: Code[10];
        Day27: Code[10];
        Day28: Code[10];
        Day29: Code[10];
        Day30: Code[10];
        Day31: Code[10];
    begin
        ExcelImport.Import('', DATABASE::"Import Schedule from Excel");
    end;

    procedure GenerateAttendance(Period: Date; EmployeeNo: Code[20]);
    var
        EmployeeABS: Record "Employee Absence";
        EmployeeJournal: Record "Employee Journal Line";
        EntryNumber: Integer;
        HRSetup: Record "Human Resources Setup";
        LateArrive: Decimal;
        EarlyLeave: Decimal;
        EarlyArrive: Decimal;
        LateLeave: Decimal;
        ExpectedHours: Decimal;
        ActualHours: Decimal;
    begin
        ExpectedHours := 0;
        ActualHours := 0;
        HRSetup.GET;
        EmployeeABS.SETRANGE("Employee No.", EmployeeNo);
        EmployeeABS.SETRANGE(Period, Period);
        if EmployeeABS.FINDFIRST then
            repeat
                EmployeeJournal.SETRANGE("Employee No.", EmployeeNo);
                if EmployeeJournal.FINDLAST then
                    EntryNumber := EmployeeJournal."Entry No."
                else
                    EntryNumber := 0;

                EmployeeJournal.INIT;
                EmployeeJournal.VALIDATE("Employee No.", EmployeeNo);
                EmployeeJournal."Transaction Type" := 'ABS';
                EmployeeJournal.VALIDATE("Cause of Absence Code", EmployeeABS."Cause of Absence Code");
                EmployeeJournal."Starting Date" := EmployeeABS."From Date";
                EmployeeJournal."Ending Date" := EmployeeABS."To Date";
                EmployeeJournal.Type := 'ABSENCE';
                EmployeeJournal.VALIDATE("Transaction Date", EmployeeABS.Period);
                EmployeeJournal.Value := EmployeeABS.Quantity;
                EmployeeJournal."Calculated Value" := EmployeeABS.Quantity;
                EmployeeJournal."Opened By" := USERID;
                EmployeeJournal."Opened Date" := WORKDATE;
                EmployeeJournal."Released By" := USERID;
                EmployeeJournal."Released Date" := WORKDATE;
                EmployeeJournal."Approved By" := USERID;
                EmployeeJournal."Approved Date" := WORKDATE;
                EmployeeJournal."Document Status" := EmployeeJournal."Document Status"::Approved;
                EmployeeJournal.INSERT(true);

            // ExpectedHours:=ExpectedHours+EmployeeABS."Required Hrs";
            // ActualHours  :=ActualHours+  EmployeeABS."Attend Hrs.";

            until EmployeeABS.NEXT = 0;

        /*IF (ActualHours-ExpectedHours)>0 THEN
        BEGIN
          IF HRSetup.Overtime<>'' THEN
          BEGIN
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.",EmployeeNo);
            EmployeeJournal."Transaction Type":='ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code",HRSetup.Overtime);
            EmployeeJournal."Starting Date":=EmployeeABS.Period;
            EmployeeJournal."Ending Date"  :=EmployeeABS.Period;
            EmployeeJournal.Type:='ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date",EmployeeABS.Period);
            EmployeeJournal.Value:=ActualHours-ExpectedHours;
            EmployeeJournal."Calculated Value":=ActualHours-ExpectedHours;
            EmployeeJournal.INSERT(TRUE);
          END;
        END;

        IF (ActualHours-ExpectedHours)<0 THEN
        BEGIN
          IF HRSetup.Deduction<>'' THEN
          BEGIN
            EmployeeJournal.INIT;
            EmployeeJournal.VALIDATE("Employee No.",EmployeeNo);
            EmployeeJournal."Transaction Type":='ABS';
            EmployeeJournal.VALIDATE("Cause of Absence Code",HRSetup.Deduction);
            EmployeeJournal."Starting Date":=Period;
            EmployeeJournal."Ending Date"  :=Period;
            EmployeeJournal.Type:='ABSENCE';
            EmployeeJournal.VALIDATE("Transaction Date",Period);
            EmployeeJournal.Value:=ABS(ActualHours-ExpectedHours);
            EmployeeJournal."Calculated Value":=ABS(ActualHours-ExpectedHours);
            EmployeeJournal.INSERT(TRUE);
          END;
        END;
          */

    end;
}

