report 98084 "Import Sub Payroll Journals"
{
    // version EDM.HRPY2

    // Excel File Format
    // Employee No  |  Pay Element Code  |  Amount
    //              |                    |

    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Delete Existing"; DeleteExsiting)
                    {
                        ApplicationArea = All;
                    }
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

    trigger OnPostReport();
    begin
        ImportEmployeeBenefits(DeleteExsiting);
    end;

    var
        Window2: Dialog;
        DeleteExsiting: Boolean;
        RefCode: Code[20];

    procedure ImportEmployeeBenefits(DeleteExisting: Boolean);
    var
        FileManagement: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer" temporary;
        FileName: Text[250];
        RowNo: Integer;
        EmpNo: Code[20];
        Value: Decimal;
        Employee: Record Employee;
        NewJrnlLine: Boolean;
        RefCode: Code[20];
        SubPayList: Record "Payroll Sub Main";
        PayElementRec: Record "Pay Element";
        PayElementCode: Code[10];
        SubPayDetails: Record "Payroll Sub Details";
        SubPayId: Integer;
        FromFile: Text;
        IStream: InStream;
        SheetName: Text;
        UploadedFileName: Text;
        FileMgt: Codeunit "File Management";
    begin
        if DeleteExisting then begin
            SubPayDetails.RESET;
            CLEAR(SubPayDetails);
            SubPayDetails.SETRANGE("Ref Code", RefCode);
            if SubPayDetails.FINDFIRST then
                SubPayDetails.DELETEALL;
        end;

        //FileName := FileManagement.UploadFile('', '', '');Coders+- // fixed
        //ExcelBuf.OpenBook(FileName, 'Sheet1');
        //ExcelBuf.ReadSheet;
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
                if ExcelBuf."Row No." > RowNo then begin
                    if ExcelBuf."Column No." = 1 then begin
                        EmpNo := ExcelBuf."Cell Value as Text";
                        if not Employee.GET(EmpNo) then
                            ERROR('Employee %1 not found', EmpNo);
                    end;

                    if ExcelBuf."Column No." = 2 then begin
                        PayElementCode := ExcelBuf."Cell Value as Text";
                        if not PayElementRec.GET(PayElementCode) then
                            ERROR('Pay element code %1 not found', PayElementCode);
                    end;

                    if ExcelBuf."Column No." = 3 then
                        EVALUATE(Value, ExcelBuf."Cell Value as Text");
                end;
            until ExcelBuf.NEXT = 0;

        Window2.OPEN(
          'Employee Journal Process \' +
          'Employee: #1########\');

        NewJrnlLine := false;
        if ExcelBuf.FINDFIRST then
            repeat
                if ExcelBuf."Row No." > RowNo then begin
                    if ExcelBuf."Column No." = 1 then
                        EmpNo := ExcelBuf."Cell Value as Text";
                    if ExcelBuf."Column No." = 2 then
                        PayElementCode := ExcelBuf."Cell Value as Text";
                    if ExcelBuf."Column No." = 3 then begin
                        EVALUATE(Value, ExcelBuf."Cell Value as Text");
                        NewJrnlLine := true;
                    end;

                    Window2.UPDATE(1, EmpNo);

                    if (NewJrnlLine) and (Value > 0) then begin
                        if SubPayDetails.FINDLAST then
                            SubPayId := SubPayDetails.ID + 1;

                        SubPayDetails.INIT;
                        SubPayDetails.ID := SubPayId;
                        SubPayDetails.VALIDATE("Ref Code", RefCode);
                        SubPayDetails.VALIDATE("Employee No.", EmpNo);
                        SubPayDetails.VALIDATE("Pay Element Code", PayElementCode);
                        SubPayDetails.VALIDATE(Amount, Value);
                        SubPayDetails.VALIDATE("Amount (LCY)", Value);
                        SubPayDetails.INSERT;
                        NewJrnlLine := false;
                    end;
                end;
            until ExcelBuf.NEXT = 0;

        Window2.CLOSE;
        MESSAGE('Your sheet was imported successfully');
        FileName := '';
    end;

    procedure SetParameter(RefCodeParam: Code[20]);
    begin
        RefCode := RefCodeParam;
    end;
}

