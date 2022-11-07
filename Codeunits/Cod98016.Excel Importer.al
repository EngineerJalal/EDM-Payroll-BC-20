codeunit 98016 "Excel Importer"
{
    var
        ExcelBuf: Record "Excel Buffer";
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        Text005: Label 'Imported from Excel ';
        Text006: Label 'Import Excel File';
        GlobalRef: Code[50];
        Text000: Label 'Open source file';
        Text001: Label 'Import/update of data finished successfully';
        Text002: Label 'Importing...\@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text003: Label '''No such option: %1''';
        Text004: Label 'The Excel worksheet %1 does not exist.';
        Text007: Label 'Reading Excel worksheet...\\';
        Text008: Label 'Import stopped at user request';
        Text009: Label '''Select Import, Update, or both options''';
        Text010: Label '''No field mapping information in buffer''';
        Text011: Label 'Fields:\%1\were not imported. Fields type of\%2\can not be read form Excel.  ';
        Text012: Label 'No such table no: %1';
        Text013: Label 'Intenal error: No primary key info in buffer table';
        Text014: Label 'Error in format of data for BigInteger type field ';
        warn: Boolean;
        FieldList: Record Field;
        EXCELBuffer: Record "Excel Buffer";
        Window: Dialog;

    local procedure ReadExcelSheet()
    var
        RowNo: Integer;
    begin
    end;


    procedure UploadFile()
    var
        CommonDialogMgt: Codeunit "EDM Utility";
        FileMgt: Codeunit "File Management";
    begin
        //Modified because the class CommonDialog is not working - 20.01.2016 : AIM +
        //UploadedFileName := CommonDialogMgt.OpenFile(Text006,'',2,'',0);
        //FileName := UploadedFileName;
        UploadedFileName := CommonDialogMgt.OpenFile(Text011, '', 2, '', 0);// CommonDialogMgt.OpenFile(Text006,'',2,'',0);
        FileName := UploadedFileName;
        //Modified because the class CommonDialog is not working - 20.01.2016 : AIM -
    end;


    procedure Import(UploadedFileName: Text[100]; TableNo: Integer)
    var
        index: Integer;
        RowNo: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        cellFound: Boolean;
        i_value: Integer;
        dec_value: Decimal;
        dat_value: Date;
        tim_value: Time;
        b_value: Boolean;
        bi_value: BigInteger;
        dattim_value: DateTime;
        datform_value: DateFormula;
        cellValue: Text[262];
        cellValue2: Text[262];
        J: Integer;
        headerName: Text[50];
        NoOfRecords: Integer;
        Instr: InStream;
        FileUploaded: Boolean;
    begin
        Window.OPEN(
          'Import File\\' +
          'Processing Record:    #2########\' +
          'Processing Field:    #1########\' +
          'Number    #3######  of  #4######\' +
          '@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');


        /*IF UploadedFileName = '' THEN
            UploadFile
        ELSE
            FileName := UploadedFileName;
        //



        IF SelectExcelSource(FileName, SheetName) < 0 THEN
            EXIT;


        //IF NOT testTableNo(TableNo) THEN
        //    EXIT;
        //
        ExcelBuf.OpenBook(FileName, SheetName);
        ExcelBuf.ReadSheet;*/
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := ExcelBuf.SelectSheetsNameStream(Instr)
        else
            exit;

        ExcelBuf.Reset;
        ExcelBuf.OpenBookStream(Instr, Sheetname);
        ExcelBuf.ReadSheet();

        Commit();
        RowNo := 2;

        J := 0;
        //
        RecRef.OPEN(TableNo);
        //
        IF ExcelBuf.FIND('-') THEN
            REPEAT

                NoOfRecords := ExcelBuf.COUNT;
                Window.UPDATE(4, NoOfRecords);

                WHILE RowNo <= ExcelBuf.COUNT DO BEGIN

                    RecRef.INIT;
                    index := 0;

                    WHILE index < RecRef.FIELDCOUNT DO BEGIN
                        index := index + 1;

                        FieldRef := RecRef.FIELD(index);
                        //
                        Window.UPDATE(1, FieldRef.NAME);
                        //
                        //

                        ///ExcelBuf.GET(1, index);
                        //IF FieldRef.NAME = ExcelBuf."Cell Value as Text" THEN BEGIN
                        cellFound := ExcelBuf.GET(RowNo, index);

                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            cellValue2 := ExcelBuf.Formula;
                        END;

                        IF index = 1 THEN
                            Window.UPDATE(2, cellValue);


                        CASE FORMAT(FieldRef.TYPE) OF // field.type
                            'Text', 'Code':
                                IF cellFound THEN BEGIN
                                    FieldRef.VALUE := cellValue;///COPYSTR(cellValue2,1,fieldRef.LENGTH);
                                END ELSE
                                    FieldRef.VALUE := '';

                            'Boolean':
                                IF cellFound THEN
                                    FieldRef.VALUE := TRUE
                                ELSE
                                    FieldRef.VALUE := FALSE;

                            'Date':
                                IF cellFound THEN BEGIN
                                    //MESSAGE(FORMAT(COPYSTR(cellValue,1,8)));
                                    EVALUATE(dat_value, COPYSTR(cellValue, 1, 8));
                                    //MESSAGE(FORMAT(dat_value));
                                    //FieldRef.VALUE := DMY2DATE(DATE2DMY(dat_value,1),DATE2DMY(dat_value,2),DATE2DMY(dat_value,3));
                                    FieldRef.VALUE := dat_value;
                                END;
                            'Time':
                                IF cellFound THEN BEGIN
                                    tim_value := calcTime(cellValue);
                                    //EVALUATE(tim_value, cellValue);
                                    FieldRef.VALUE := tim_value;
                                END;
                            'DateFormula':
                                IF cellFound THEN BEGIN
                                    EVALUATE(datform_value, cellValue);
                                    FieldRef.VALUE := datform_value;
                                END;
                            'DateTime':
                                IF cellFound THEN BEGIN
                                    //FieldRef.VALUE := calcDateTime(cellValue,cellValue2);
                                    EVALUATE(dattim_value, cellValue);
                                    FieldRef.VALUE := dattim_value;
                                END;
                            'BigInteger':
                                IF cellFound THEN BEGIN
                                    EVALUATE(bi_value, cellValue);
                                    FieldRef.VALUE := bi_value;
                                END;
                            'Integer':
                                IF cellFound THEN BEGIN
                                    EVALUATE(i_value, cellValue);
                                    FieldRef.VALUE := i_value;
                                END;
                            'Decimal':
                                IF cellFound THEN BEGIN
                                    EVALUATE(dec_value, cellValue);
                                    FieldRef.VALUE := dec_value;
                                END;
                        //       'Option':
                        //          IF cellFound THEN BEGIN
                        ///            option := evaluateOption(fieldRef,cellValue,searchOption);
                        //            fieldRef.VALUE := option;
                        //          END

                        END;//Case
                            //END;//IF FieldRef.NAME = ExcelBuf."Cell Value as Text"
                    END;//WHILE index <  RecRef.FIELDCOUNT
                    IF RecRef.INSERT THEN RecRef.MODIFY;
                    RowNo += 1;


                    Window.UPDATE(3, RowNo);

                    Window.UPDATE(5, ROUND(RowNo / NoOfRecords * 10000, 1));
                END;//WHILE RowNo <= ExcelBuf.COUNT
            UNTIL ExcelBuf.NEXT = 0;
        //END;
        UploadedFileName := '';
        Window.CLOSE();

    end;


    /*procedure testTableNo(var tableNo: Integer): Boolean
    var
        "Object": Record "Object";
    begin
        CASE TRUE OF
            tableNo > 0:
                IF NOT Object.GET(Object.Type::TableData, '', tableNo) THEN BEGIN
                    //clearExcel;
                    ERROR(Text012, tableNo)
                END ELSE
                    EXIT(TRUE);
            tableNo = 0:
                BEGIN
                    COMMIT;
                    IF PAGE.RUNMODAL(PAGE::Page99993,Object) = ACTION::LookupOK THEN BEGIN
                      tableNo := Object.ID;
                      EXIT(TRUE);
                    END ELSE BEGIN
                      //clearExcel;
                      ERROR('');
                    END;
          END;
  END;
  EXIT(FALSE);
end;*/


    /*procedure SelectExcelSource(var FileName: Text[100]; var SheetName: Text[50]): Integer
    var
    //DialogWindow: Codeunit "17366";
    begin
        IF (FileName = '') OR (NOT EXISTS(FileName)) THEN BEGIN
            //EDM+- 20130212FileName := DialogWindow.OpenFile(Text000, '', 2{=Excel}, '', 0{=Open});
            IF FileName = '' THEN
                EXIT(-1);
        END;

        IF SheetName = '' THEN
            SheetName := EXCELBuffer.SelectSheetsName(FileName);

        IF SheetName = '' THEN
            EXIT(-1);
    end;*/

    local procedure calcTime(TimeText: Text[100]): Time
    var
        ts: Text[2];
        tim: Time;
        i: Integer;
        dec: Decimal;
    begin
        //ts := '  ';
        //ts[1] := FORMAT(1000.0)[2];

        //TimeText := DELCHR(TimeText,'<=>',ts);
        EVALUATE(dec, TimeText);

        i := ROUND(dec, 1, '<');
        tim := 000000T;
        tim := tim + ROUND((dec - i) * (1000 * 60 * 60 * 24), 1);
        EXIT(tim);
    end;


    procedure ImportFile(UploadedFileName: Text[100]; TableNo: Integer) IsImported: Boolean
    var
        index: Integer;
        RowNo: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        cellFound: Boolean;
        i_value: Integer;
        dec_value: Decimal;
        dat_value: Date;
        tim_value: Time;
        b_value: Boolean;
        bi_value: BigInteger;
        dattim_value: DateTime;
        datform_value: DateFormula;
        cellValue: Text[262];
        cellValue2: Text[262];
        J: Integer;
        headerName: Text[50];
        NoOfRecords: Integer;
    begin
        /*Window.OPEN(
          'Import File\\' +
          'Processing Record:    #2########\' +
          'Processing Field:    #1########\' +
          'Number    #3######  of  #4######\' +
          '@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');


        IF UploadedFileName = '' THEN
            UploadFile
        ELSE
            FileName := UploadedFileName;
        //

        IF FileName = '' THEN
            EXIT(FALSE);

        IF SelectExcelSource(FileName, SheetName) < 0 THEN
            EXIT(FALSE);


        IF NOT testTableNo(TableNo) THEN
            EXIT(FALSE);
        //

        ExcelBuf.OpenBook(FileName, SheetName);
        ExcelBuf.ReadSheet;
        RowNo := 2;

        J := 0;
        //
        RecRef.OPEN(TableNo);
        //
        IF ExcelBuf.FIND('-') THEN
            REPEAT

                NoOfRecords := ExcelBuf.COUNT;
                Window.UPDATE(4, NoOfRecords);

                WHILE RowNo <= ExcelBuf.COUNT DO BEGIN

                    RecRef.INIT;
                    index := 0;

                    WHILE index < RecRef.FIELDCOUNT DO BEGIN
                        index := index + 1;

                        FieldRef := RecRef.FIELD(index);
                        //
                        Window.UPDATE(1, FieldRef.NAME);
                        //
                        //

                        ///ExcelBuf.GET(1, index);
                        //IF FieldRef.NAME = ExcelBuf."Cell Value as Text" THEN BEGIN
                        cellFound := ExcelBuf.GET(RowNo, index);

                        IF cellFound THEN BEGIN
                            cellValue := ExcelBuf."Cell Value as Text";
                            cellValue2 := ExcelBuf.Formula;
                        END;

                        IF index = 1 THEN
                            Window.UPDATE(2, cellValue);


                        CASE FORMAT(FieldRef.TYPE) OF // field.type
                            'Text', 'Code':
                                IF cellFound THEN BEGIN
                                    FieldRef.VALUE := cellValue;///COPYSTR(cellValue2,1,fieldRef.LENGTH);
                                END ELSE
                                    FieldRef.VALUE := '';

                            'Boolean':
                                IF cellFound THEN
                                    FieldRef.VALUE := TRUE
                                ELSE
                                    FieldRef.VALUE := FALSE;

                            'Date':
                                IF cellFound THEN BEGIN
                                    //MESSAGE(FORMAT(COPYSTR(cellValue,1,8)));
                                    EVALUATE(dat_value, COPYSTR(cellValue, 1, 8));
                                    //MESSAGE(FORMAT(dat_value));
                                    //FieldRef.VALUE := DMY2DATE(DATE2DMY(dat_value,1),DATE2DMY(dat_value,2),DATE2DMY(dat_value,3));
                                    FieldRef.VALUE := dat_value;
                                END;
                            'Time':
                                IF cellFound THEN BEGIN
                                    tim_value := calcTime(cellValue);
                                    //EVALUATE(tim_value, cellValue);
                                    FieldRef.VALUE := tim_value;
                                END;
                            'DateFormula':
                                IF cellFound THEN BEGIN
                                    EVALUATE(datform_value, cellValue);
                                    FieldRef.VALUE := datform_value;
                                END;
                            'DateTime':
                                IF cellFound THEN BEGIN
                                    //FieldRef.VALUE := calcDateTime(cellValue,cellValue2);
                                    EVALUATE(dattim_value, cellValue);
                                    FieldRef.VALUE := dattim_value;
                                END;
                            'BigInteger':
                                IF cellFound THEN BEGIN
                                    EVALUATE(bi_value, cellValue);
                                    FieldRef.VALUE := bi_value;
                                END;
                            'Integer':
                                IF cellFound THEN BEGIN
                                    EVALUATE(i_value, cellValue);
                                    FieldRef.VALUE := i_value;
                                END;
                            'Decimal':
                                IF cellFound THEN BEGIN
                                    EVALUATE(dec_value, cellValue);
                                    FieldRef.VALUE := dec_value;
                                END;
                        //       'Option':
                        //          IF cellFound THEN BEGIN
                        ///            option := evaluateOption(fieldRef,cellValue,searchOption);
                        //            fieldRef.VALUE := option;
                        //          END

                        END;//Case
                            //END;//IF FieldRef.NAME = ExcelBuf."Cell Value as Text"
                    END;//WHILE index <  RecRef.FIELDCOUNT
                    IF RecRef.INSERT THEN RecRef.MODIFY;
                    RowNo += 1;


                    Window.UPDATE(3, RowNo);

                    Window.UPDATE(5, ROUND(RowNo / NoOfRecords * 10000, 1));
                END;//WHILE RowNo <= ExcelBuf.COUNT
            UNTIL ExcelBuf.NEXT = 0;
        //END;
        UploadedFileName := '';
        EXIT(TRUE);//EDM.NED
      */
    end;
}

