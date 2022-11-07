page 98115 "Scheduling System List"
{
    // version EDM.HRPY2

    // Excel Format
    // Academic Year |Employee No | WeekDay | FromTime | ToTime | Hours | Dim1 | Dim2 | Dim3 | Dim4 | Dim5 | Dim6 | Dim7 | Dim8 |
    //               |            |         |          |        |       |      |      |      |      |      |      |      |      |

    CardPageID = "Scheduling System Card";
    PageType = List;
    SourceTable = "Scheduling System";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document No"; "Document No")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Academic Year"; "Academic Year")
                {
                    ApplicationArea = All;
                }
                field("Is Inactive"; "Is Inactive")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Import Schedule From Excel")
            {
                Image = ImportExcel;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ImportSceduleFromExcel();
                    //EXIT;
                    //ImportScedFromExcel();
                end;
            }
        }
    }

    var
        PayFunction: Codeunit "Payroll Functions";

    local procedure ImportScedFromExcel();
    var
        SchedSyst: Record "Scheduling System";
        SchedSystLine: Record "Scheduling System Line";
        DocNo: Code[20];
        WeekDay: Text;
        FTime: Time;
        TTime: Time;
        Hrs: Decimal;
        Dim1: Code[10];
        Dim2: Code[10];
        Dim3: Code[10];
        Dim4: Code[10];
        Dim5: Code[10];
        Dim6: Code[10];
        Dim7: Code[10];
        Dim8: Code[10];
        ScedType: Option;
        FileManagement: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer" temporary;
        FileName: Text[250];
        RowNo: Integer;
        Employee: Record Employee;
        DefDim: Record "Dimension Value";
        EmpNo: Code[20];
        Window2: Dialog;
        NewLine: Boolean;
        xDocNo: Code[20];
        i: Integer;
        FromFile: Text;
        IStream: InStream;
        SheetName: Text;
        UploadedFileName: Text;
        FileMgt: Codeunit "File Management";
    begin
        //FileName := FileManagement.OpenFileDialog('', '', '');Coders+- //fixed
        //Jad: v20+
        UploadIntoStream('', '', '', FromFile, IStream);
        if FromFile <> '' then begin
            UploadedFileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBuf.SelectSheetsNameStream(IStream);
        end else
            Error('No File Found');
        ExcelBuf.Reset();
        ExcelBuf.DeleteAll();
        ExcelBuf.OpenBookStream(IStream, SheetName);
        ExcelBuf.ReadSheet();
        //Jad: v20-
        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        // ExcelBuf.ReadSheet;
        RowNo := 1;

        NewLine := false;
        if ExcelBuf.FINDFIRST then
            repeat
                if ExcelBuf."Row No." > RowNo then
                    case ExcelBuf."Column No." of
                        1:
                            DocNo := ExcelBuf."Cell Value as Text";
                        2:
                            EmpNo := ExcelBuf."Cell Value as Text";
                        3:
                            WeekDay := ExcelBuf."Cell Value as Text";
                        4:
                            FTime := CalcTime(ExcelBuf."Cell Value as Text");
                        5:
                            TTime := CalcTime(ExcelBuf."Cell Value as Text");
                        6:
                            EVALUATE(Hrs, ExcelBuf."Cell Value as Text");
                        7:
                            Dim1 := ExcelBuf."Cell Value as Text";
                        8:
                            begin
                                Dim2 := ExcelBuf."Cell Value as Text";
                                NewLine := true;
                            end;
                        9:
                            Dim3 := ExcelBuf."Cell Value as Text";
                        10:
                            Dim4 := ExcelBuf."Cell Value as Text";
                        11:
                            Dim5 := ExcelBuf."Cell Value as Text";
                        12:
                            Dim6 := ExcelBuf."Cell Value as Text";
                        13:
                            Dim7 := ExcelBuf."Cell Value as Text";
                        14:
                            begin
                                Dim8 := ExcelBuf."Cell Value as Text";
                                NewLine := true;
                            end;
                    end;

                if NewLine then begin
                    if xDocNo <> DocNo then begin
                        SchedSyst.INIT;
                        SchedSyst.VALIDATE("Document No", DocNo);
                        SchedSyst.VALIDATE("Employee No", EmpNo);
                        SchedSyst.INSERT;
                        xDocNo := DocNo;
                    end;

                    SchedSystLine.INIT;
                    SchedSystLine."Document No" := DocNo;

                    if SchedSystLine.FINDLAST then
                        SchedSystLine."Line No" += 1
                    else
                        SchedSystLine."Line No" := 1;

                    SchedSystLine.VALIDATE("Employee No", EmpNo);
                    InsertWeekDay(WeekDay, SchedSystLine);
                    SchedSystLine.VALIDATE("From Time", FTime);
                    SchedSystLine.VALIDATE("To Time", TTime);
                    SchedSystLine.VALIDATE(Hours, Hrs);
                    SchedSystLine.VALIDATE("Global Dimension 1", Dim1);
                    SchedSystLine.VALIDATE("Global Dimension 2", Dim2);
                    SchedSystLine.VALIDATE("Shortcut Dimension 3", Dim3);
                    SchedSystLine.VALIDATE("Shortcut Dimension 4", Dim4);
                    SchedSystLine.VALIDATE("Shortcut Dimension 5", Dim5);
                    SchedSystLine.VALIDATE("Shortcut Dimension 6", Dim6);
                    SchedSystLine.VALIDATE("Shortcut Dimension 7", Dim7);
                    SchedSystLine.VALIDATE("Shortcut Dimension 8", Dim8);
                    SchedSystLine.SetEmployeeDimension();
                    SchedSystLine.INSERT;
                    NewLine := false;
                end;
            until ExcelBuf.NEXT = 0;

        MESSAGE('Your sheet was imported successfully');
        FileName := '';
    end;

    local procedure CalcTime(TimeText: Text[100]): Time;
    var
        ts: Text[2];
        tim: Time;
        i: Integer;
        dec: Decimal;
    begin
        EVALUATE(dec, TimeText);

        i := ROUND(dec, 1, '<');
        tim := 000000T;
        tim := tim + ROUND((dec - i) * (1000 * 60 * 60 * 24), 1);
        exit(tim);
    end;

    local procedure InsertWeekDay(DayName: Text[10]; var SchedLine: Record "Scheduling System Line");
    begin
        CASE UPPERCASE(DayName) OF
            'MON':
                SchedLine.VALIDATE("Week Day", SchedLine."Week Day"::Monday);
            'SAT':
                SchedLine.VALIDATE("Week Day", SchedLine."Week Day"::Saturday);
            'SUN':
                SchedLine.VALIDATE("Week Day", SchedLine."Week Day"::Sunday);
            'THU':
                SchedLine.VALIDATE("Week Day", SchedLine."Week Day"::Thursday);
            'TUE':
                SchedLine.VALIDATE("Week Day", SchedLine."Week Day"::Tuesday);
            'WED':
                SchedLine.VALIDATE("Week Day", SchedLine."Week Day"::Wednesday);
            'FRI':
                SchedLine.VALIDATE("Week Day", SchedLine."Week Day"::Friday);
        end
    end;

    local procedure ImportSceduleFromExcel();
    var
        SchedSyst: Record "Scheduling System";
        SchedSystLine: Record "Scheduling System Line";
        DocNo: Integer;
        WeekDay: Text;
        FTime: Time;
        TTime: Time;
        Hrs: Decimal;
        Dim1: Code[10];
        Dim2: Code[10];
        Dim3: Code[10];
        Dim4: Code[10];
        Dim5: Code[10];
        Dim6: Code[10];
        Dim7: Code[10];
        Dim8: Code[10];
        ScedType: Option;
        FileManagement: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer" temporary;
        FileName: Text[250];
        RowNo: Integer;
        Employee: Record Employee;
        DefDim: Record "Dimension Value";
        EmpNo: Code[20];
        Window2: Dialog;
        NewLine: Boolean;
        xDocNo: Code[20];
        i: Integer;
        r: Integer;
        c: Integer;
        e: Code[20];
        D: Integer;
        FromFile: Text;
        IStream: InStream;
        SheetName: Text;
        UploadedFileName: Text;
        FileMgt: Codeunit "File Management";
    begin
        //FileName := FileManagement.OpenFileDialog('', '', '');Coders+- // fixed
        // ExcelBuf.OpenBook(FileName, 'Sheet1');
        // ExcelBuf.ReadSheet;
        //Jad: v20+
        UploadIntoStream('', '', '', FromFile, IStream);
        if FromFile <> '' then begin
            UploadedFileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBuf.SelectSheetsNameStream(IStream);
        end else
            Error('No File Found');
        ExcelBuf.Reset();
        ExcelBuf.DeleteAll();
        ExcelBuf.OpenBookStream(IStream, SheetName);
        ExcelBuf.ReadSheet();
        //Jad: v20-
        RowNo := 1;

        if ExcelBuf.FINDFIRST then
            repeat
                r := ExcelBuf."Row No.";

                if (i <> r) and (r > RowNo) then begin
                    //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2+
                    //IF (DocNo <> '' ) AND (EmpNo <> '') THEN
                    if (DocNo <> 0) and (EmpNo <> '') then
                      //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2+
                      begin
                        SchedSyst.SETRANGE("Document No", FORMAT(DATE2DMY(TODAY, 1)) + FORMAT(DATE2DMY(TODAY, 2)) + FORMAT(DATE2DMY(TODAY, 3)) + COPYSTR(FORMAT(CONVERTSTR(FORMAT(SYSTEM.TIME), ':', '0')), 2, 4) + FORMAT(D));
                        if not SchedSyst.FINDFIRST then begin
                            SchedSyst.RESET;
                            CLEAR(SchedSyst);
                            SchedSyst.INIT;
                            SchedSyst.VALIDATE("Document No", FORMAT(DATE2DMY(TODAY, 1)) + FORMAT(DATE2DMY(TODAY, 2)) + FORMAT(DATE2DMY(TODAY, 3)) + COPYSTR(FORMAT(CONVERTSTR(FORMAT(SYSTEM.TIME), ':', '0')), 2, 4) + FORMAT(D));
                            SchedSyst.VALIDATE("Employee No", EmpNo);
                            SchedSyst.VALIDATE("Academic Year", DocNo);
                            SchedSyst.INSERT;
                        end;
                        SchedSystLine.INIT;
                        SchedSystLine."Document No" := FORMAT(DATE2DMY(TODAY, 1)) + FORMAT(DATE2DMY(TODAY, 2)) + FORMAT(DATE2DMY(TODAY, 3)) + COPYSTR(FORMAT(CONVERTSTR(FORMAT(SYSTEM.TIME), ':', '0')), 2, 4) + FORMAT(D);
                        SchedSystLine.VALIDATE("Employee No", EmpNo);
                        SchedSystLine."Line No" := i;
                        InsertWeekDay(WeekDay, SchedSystLine);
                        SchedSystLine.VALIDATE("From Time", FTime);
                        SchedSystLine.VALIDATE("To Time", TTime);
                        SchedSystLine.VALIDATE(Hours, Hrs);
                        SchedSystLine.VALIDATE("Global Dimension 1", Dim1);
                        SchedSystLine.VALIDATE("Global Dimension 2", Dim2);
                        SchedSystLine.VALIDATE("Shortcut Dimension 3", Dim3);
                        SchedSystLine.VALIDATE("Shortcut Dimension 4", Dim4);
                        SchedSystLine.VALIDATE("Shortcut Dimension 5", Dim5);
                        SchedSystLine.VALIDATE("Shortcut Dimension 6", Dim6);
                        SchedSystLine.VALIDATE("Shortcut Dimension 7", Dim7);
                        SchedSystLine.VALIDATE("Shortcut Dimension 8", Dim8);
                        SchedSystLine.SetEmployeeDimension();
                        SchedSystLine.INSERT;
                    end;
                    //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2+
                    //DocNo := ExcelBuf."Cell Value as Text";
                    EVALUATE(DocNo, ExcelBuf."Cell Value as Text");
                    //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2-
                    i := r;
                end
                else
                    if (r > RowNo) then begin
                        case ExcelBuf."Column No." of
                            1:
                                //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2+
                                //DocNo := ExcelBuf."Cell Value as Text";
                                EVALUATE(DocNo, ExcelBuf."Cell Value as Text");
                            //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2-
                            2:
                                begin
                                    if EmpNo <> ExcelBuf."Cell Value as Text" then
                                        D := D + 1;
                                    EmpNo := ExcelBuf."Cell Value as Text";
                                    if not Employee.GET(EmpNo) then
                                        ERROR('Employee %1 not found', EmpNo);
                                end;
                            3:
                                WeekDay := ExcelBuf."Cell Value as Text";
                            4:
                                FTime := CalcTime(ExcelBuf."Cell Value as Text");
                            5:
                                TTime := CalcTime(ExcelBuf."Cell Value as Text");
                            6:
                                EVALUATE(Hrs, ExcelBuf."Cell Value as Text");
                            7:
                                Dim1 := ExcelBuf."Cell Value as Text";
                            8:
                                Dim2 := ExcelBuf."Cell Value as Text";
                            9:
                                Dim3 := ExcelBuf."Cell Value as Text";
                            10:
                                Dim4 := ExcelBuf."Cell Value as Text";
                            11:
                                Dim5 := ExcelBuf."Cell Value as Text";
                            12:
                                Dim6 := ExcelBuf."Cell Value as Text";
                            13:
                                Dim7 := ExcelBuf."Cell Value as Text";
                            14:
                                Dim8 := ExcelBuf."Cell Value as Text";

                        end;
                    end;
            until ExcelBuf.NEXT = 0;
        //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2+
        //IF (DocNo <> '') AND (EmpNo <> '') THEN
        if (DocNo <> 0) and (EmpNo <> '') then
          //Replaced because the type of DocNo is Changed from Text to Integer - 19.10.2017 : A2-
          begin
            SchedSyst.SETRANGE("Document No", FORMAT(DATE2DMY(TODAY, 1)) + FORMAT(DATE2DMY(TODAY, 2)) + FORMAT(DATE2DMY(TODAY, 3)) + COPYSTR(FORMAT(CONVERTSTR(FORMAT(SYSTEM.TIME), ':', '0')), 2, 4) + FORMAT(D));
            if not SchedSyst.FINDFIRST then begin
                SchedSyst.RESET;
                CLEAR(SchedSyst);
                SchedSyst.INIT;
                SchedSyst.VALIDATE("Document No", FORMAT(DATE2DMY(TODAY, 1)) + FORMAT(DATE2DMY(TODAY, 2)) + FORMAT(DATE2DMY(TODAY, 3)) + COPYSTR(FORMAT(CONVERTSTR(FORMAT(SYSTEM.TIME), ':', '0')), 2, 4) + FORMAT(D));
                SchedSyst.VALIDATE("Employee No", EmpNo);
                SchedSyst.VALIDATE("Academic Year", DocNo);
                SchedSyst.INSERT;
            end;
            SchedSystLine.INIT;
            SchedSystLine."Document No" := FORMAT(DATE2DMY(TODAY, 1)) + FORMAT(DATE2DMY(TODAY, 2)) + FORMAT(DATE2DMY(TODAY, 3)) + COPYSTR(FORMAT(CONVERTSTR(FORMAT(SYSTEM.TIME), ':', '0')), 2, 4) + FORMAT(D);
            SchedSystLine."Line No" := i;
            SchedSystLine.VALIDATE("Employee No", EmpNo);
            InsertWeekDay(WeekDay, SchedSystLine);
            SchedSystLine.VALIDATE("From Time", FTime);
            SchedSystLine.VALIDATE("To Time", TTime);
            SchedSystLine.VALIDATE(Hours, Hrs);
            SchedSystLine.VALIDATE("Global Dimension 1", Dim1);
            SchedSystLine.VALIDATE("Global Dimension 2", Dim2);
            SchedSystLine.VALIDATE("Shortcut Dimension 3", Dim3);
            SchedSystLine.VALIDATE("Shortcut Dimension 4", Dim4);
            SchedSystLine.VALIDATE("Shortcut Dimension 5", Dim5);
            SchedSystLine.VALIDATE("Shortcut Dimension 6", Dim6);
            SchedSystLine.VALIDATE("Shortcut Dimension 7", Dim7);
            SchedSystLine.VALIDATE("Shortcut Dimension 8", Dim8);
            SchedSystLine.SetEmployeeDimension();
            SchedSystLine.INSERT;
        end;

        MESSAGE('Your sheet was imported successfully');
        FileName := '';
    end;
}

