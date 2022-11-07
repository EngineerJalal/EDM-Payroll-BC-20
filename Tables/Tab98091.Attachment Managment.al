table 98091 "Attachment Managment"
{
    fields
    {
        field(1; TableId; Integer)
        {
        }
        field(2; RecordId; RecordID)
        {
        }
        field(3; FieldNumber; Integer)
        {
        }
        field(4; Attachment; BLOB)
        {
        }
        field(5; Extension; Text[30])
        {
        }
        field(6; FileName; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; TableId, RecordId, FieldNumber)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Txt001: TextConst ENU = 'Do you want to overwrite existing Attachment ?', ENN = 'Do you want to overwrite existing template ?';
        Txt002: TextConst ENU = 'Import Attachment.', ENN = 'Import Template';
        Txt003: TextConst ENU = 'Update Attachment.', ENN = 'Export Template';
        ImportedFilePath: Text[1024];
        ServerFileName: Text[1024];
        FileMgmt: Codeunit "File Management";
        ExtensionStart: Integer;

        TempBlob: Codeunit "Temp Blob";
        //TempBlobRec: Record "TempBlob";//EDM.UPGRADE
        Txt004: Label 'No Attachment In Current Document.';
        Txt005: Label 'Attachment File ''''%1'''' imported successfully.';
        Txt006: Label 'Do you want to delete the Attachment In %1?';

    procedure ImportAttachment(TableIdToImport: Integer; RecIdToImport: RecordID; FieldIdToImport: Integer);
    var
        AttachRecordRef: RecordRef;
    begin

        IF RecordExist(TableIdToImport, RecIdToImport, FieldIdToImport) THEN
            EXIT;

        INIT;
        TableId := TableIdToImport;
        RecordId := RecIdToImport;
        FieldNumber := FieldIdToImport;

#pragma warning disable AL0133
        ImportedFilePath := FileMgmt.BLOBImportWithFilter(TempBlob, Txt002, '', '*.*|', '*.*');
#pragma warning restore AL0133

        IF ImportedFilePath = '' THEN
            EXIT;

        //Attachment := TempBlobRec.Blob;//NED+-
        Extension := '.' + FileMgmt.GetExtension(ImportedFilePath);
        FileName := FileMgmt.GetFileName(ImportedFilePath);

        IF INSERT AND Attachment.HASVALUE THEN
            MESSAGE(Txt005, FileName);
    end;

    procedure ExportAttachment(TableIdToExport: Integer; RecIdToExport: RecordID; FieldIdToExport: Integer);
    var
        FileName: Text[1024];
        ServerFileName: Text[1024];
        FileMgmt: Codeunit "File Management";
    begin

        SETRANGE(TableId, TableIdToExport);
        SETRANGE(RecordId, RecIdToExport);
        SETRANGE(FieldNumber, FieldIdToExport);

        IF NOT FINDFIRST THEN
            ERROR(Txt004);

        CALCFIELDS(Attachment);

        IF NOT Attachment.HASVALUE THEN
            ERROR(Txt004);

        //TempBlobRec.Blob := Attachment; //NED+-
        FileMgmt.BLOBExport(TempBlob, FORMAT(Rec.FileName), TRUE);
        //MESSAGE(Rec.FileName);
    end;

    procedure UpdateAttachment();
    begin

        IF NOT CONFIRM(Txt001) THEN
            EXIT;

        ImportedFilePath := FileMgmt.BLOBImportWithFilter(TempBlob, Txt002, '', '*.*|', '*.*');

        IF ImportedFilePath = '' THEN
            EXIT;

        //Attachment := TempBlobRec.Blob;//NED+-
        Extension := '.' + FileMgmt.GetExtension(ImportedFilePath);
        FileName := FileMgmt.GetFileName(ImportedFilePath);

        IF MODIFY AND Attachment.HASVALUE THEN
            MESSAGE(Txt005, FileName);
    end;

    procedure DeleteAttachment(TableIdToDelete: Integer; RecIdToDelete: RecordID; FieldIdToDelete: Integer): Boolean;
    begin

        SETRANGE(TableId, TableIdToDelete);
        SETRANGE(RecordId, RecIdToDelete);
        SETRANGE(FieldNumber, FieldIdToDelete);

        IF NOT FINDFIRST THEN
            ERROR(Txt004);

        CALCFIELDS(Attachment);

        IF Attachment.HASVALUE THEN
            IF CONFIRM(Txt006, FALSE, RecIdToDelete) THEN BEGIN
                IF DELETE THEN
                    EXIT(TRUE);
            END;

        EXIT(FALSE);
    end;

    procedure RecordExist(TableIdToImport: Integer; RecIdToImport: RecordID; FieldIdToImport: Integer): Boolean;
    begin

        SETRANGE(TableId, TableIdToImport);
        SETRANGE(RecordId, RecIdToImport);
        SETRANGE(FieldNumber, FieldIdToImport);

        IF NOT FINDFIRST THEN
            EXIT(FALSE);

        UpdateAttachment();
        EXIT(TRUE);
    end;

    procedure GetAttachmentFileName(TableIdToImport: Integer; RecIdToImport: RecordID; FieldIdToImport: Integer): Text;
    begin

        SETRANGE(TableId, TableIdToImport);
        SETRANGE(RecordId, RecIdToImport);
        SETRANGE(FieldNumber, FieldIdToImport);

        IF FINDFIRST THEN
            EXIT(FileName)
        ELSE
            EXIT('');
    end;
}

