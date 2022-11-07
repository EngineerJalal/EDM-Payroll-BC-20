table 98064 "Employee Additional Info"
{
    // version EDM.HRPY1

    DrillDownPageID = "Employee Additional List";
    LookupPageID = "Employee Additional List";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(2; "Work Location"; Code[10])
        {
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST(Location));
        }
        field(3; "Bonus System"; Code[10])
        {
            TableRelation = "HR Information"."Code" WHERE("Table Name" = CONST("Work Location"));
        }
        field(4; "Proxy(Wakeleh)"; Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin

                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)"));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)")) <> '' then
                                "Proxy(Wakeleh)" := 'YES'
                            else
                                "Proxy(Wakeleh)" := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)"));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)")) then begin
                                "Proxy(Wakeleh)" := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(5; Passport; Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport)) <> '' then
                                Passport := 'YES'
                            else
                                Passport := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Passport)) then begin
                                Passport := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(6; ID; Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID)) <> '' then
                                ID := 'YES'
                            else
                                ID := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(ID)) then begin
                                ID := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(7; "Undertaking Form"; Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form"));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form")) <> '' then
                                "Undertaking Form" := 'YES'
                            else
                                "Undertaking Form" := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form"));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Undertaking Form")) then begin
                                "Undertaking Form" := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(8; "Last Work Permit"; Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit"));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit")) <> '' then
                                "Last Work Permit" := 'YES'
                            else
                                "Last Work Permit" := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit"));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Last Work Permit")) then begin
                                "Last Work Permit" := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(9; "Work Permit Valid Until"; Date)
        {

            trigger OnValidate();
            begin
                EmpTbt.RESET;
                CLEAR(EmpTbt);
                EmpTbt.SETRANGE("No.", "Employee No.");
                if EmpTbt.FINDFIRST then begin
                    EmpTbt."Work Permit Expiry Date" := "Work Permit Valid Until";
                    EmpTbt.MODIFY;
                end;
                // 22.03.2017 : A2+
                "Work Permit Month Filter" := DATE2DMY("Work Permit Valid Until", 2);
                "Work Permit Year Filter" := DATE2DMY("Work Permit Valid Until", 3);
                // 22.03.2017 : A2-
            end;
        }
        field(10; "Work Residency"; Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency"));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency")) <> '' then
                                "Work Residency" := 'YES'
                            else
                                "Work Residency" := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency"));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO("Work Residency")) then begin
                                "Work Residency" := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(11; "Zoho Id"; Text[3])
        {
        }
        field(12; Insurance; Text[3])
        {
            Editable = false;

            trigger OnLookup();
            begin
                Selection := STRMENU(AttachmentSelection, 2);
                if Selection = 0 then
                    exit;
                case Selection of
                    1:
                        begin
                            AttachmentManagment.ImportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance));
                            if AttachmentManagment.GetAttachmentFileName(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance)) <> '' then
                                Insurance := 'YES'
                            else
                                Insurance := 'NO';
                            MODIFY(true);
                        end;
                    2:
                        begin
                            AttachmentManagment.ExportAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance));
                        end;
                    3:
                        begin
                            if AttachmentManagment.DeleteAttachment(DATABASE::"Employee Additional Info", Rec.RECORDID, Rec.FIELDNO(Insurance)) then begin
                                Insurance := 'NO';
                                MODIFY(true);
                            end;
                        end;
                end;
            end;
        }
        field(13; "Insurance Valid Until"; Date)
        {

            trigger OnValidate();
            begin
                EmpTbt.RESET;
                CLEAR(EmpTbt);
                EmpTbt.SETRANGE("No.", "Employee No.");
                if EmpTbt.FINDFIRST then begin
                    EmpTbt."Health Card Expiry Date" := "Insurance Valid Until";
                    EmpTbt.MODIFY;
                end;
            end;
        }
        field(14; "Passport Valid Until"; Date)
        {

            trigger OnValidate();
            begin
                EmpTbt.RESET;
                CLEAR(EmpTbt);
                EmpTbt.SETRANGE("No.", "Employee No.");
                if EmpTbt.FINDFIRST then begin
                    EmpTbt."Passport Expiry Date" := "Passport Valid Until";
                    EmpTbt.MODIFY;
                end;
                // 22.03.2017 : A2+
                "Passport Month Filter" := DATE2DMY("Passport Valid Until", 2);
                "Passport Year Filter" := DATE2DMY("Passport Valid Until", 3);
                // 22.03.2017 : A2-
            end;
        }
        field(15; "IBAN No"; Text[30])
        {
        }
        field(16; "Sponsored by Company"; Boolean)
        {
        }
        field(17; "Work Residency Valid Until"; Date)
        {

            trigger OnValidate();
            begin
                // 22.03.2017 : A2+
                "Work Residency Month Filter" := DATE2DMY("Work Residency Valid Until", 2);
                "Work Residency Year Filter" := DATE2DMY("Work Residency Valid Until", 3);
                // 22.03.2017 : A2-
            end;
        }
        field(18; "Company Department"; Code[20])
        {
        }
        field(19; "Evaluation Template"; Code[20])
        {
            TableRelation = "Evaluation Template"."Code";
        }
        field(20; "MOF Reg No"; Text[20])
        {
        }
        field(21; "Passport Month Filter"; Integer)
        {
        }
        field(22; "Passport Year Filter"; Integer)
        {
        }
        field(23; "Work Residency Month Filter"; Integer)
        {
        }
        field(24; "Work Residency Year Filter"; Integer)
        {
        }
        field(25; "Work Permit Month Filter"; Integer)
        {
        }
        field(26; "Work Permit Year Filter"; Integer)
        {
        }
        field(27; "Employee Name"; Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(28; "Family Allowance Retro Date"; Date)
        {
        }
        field(29; "Extra Salary"; Decimal)
        {
        }
        field(30; Grade; Code[10])
        {
            Description = 'Grading System - EDM.AH';
        }
        field(31; "Last Grading Date"; Date)
        {
            Description = 'Grading System - EDM.AH';
        }
        field(32; "Next Grading Date"; Date)
        {
            Description = 'Grading System - EDM.AH';
        }
        field(33; "Second Hourly Rate"; Decimal)
        {
        }
        field(34; "Bank Name"; Text[50])
        {
        }
        field(35; "Bank SWIFT Code"; Code[50])
        {
        }
        field(36; "Deduct Absence From Salary"; Boolean)
        {
        }
        field(37; "Bank SWIFT Code (ACY)"; Code[50])
        {
        }
        field(38; "GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(39; "Store No"; Code[10])
        {
            Description = 'Added for Mazzat-A2-20180206';
        }
        field(40; "Permission Group"; Code[10])
        {
            Description = 'Added for Mazzat-A2-20180206';
        }
        field(41; "Delivery Driver"; Boolean)
        {
            Description = 'Added for Mazzat-A2-20180206';
        }
        field(42; "Driver Barcode"; Code[35])
        {
            Description = 'Added for Mazzat-A2-20180206';
        }
        field(43; "Is Driver/Waiter"; Boolean)
        {
            Description = 'Added for Mazzat-A2-20180206';
        }
        field(44; "Emp Transfer Bank Name"; Text[50])
        {
        }
        field(45; "Emp Transfer Bank Name (ACY)"; Text[50])
        {
        }
        field(46; "Travel Per Deem Policy"; Code[20])
        {
            TableRelation = "HR Information".Code WHERE("Table Name" = CONST("Travel Per Deem Policy"));
        }
        field(47; "Life Insurance Premium"; Decimal)
        {
        }
        field(48; "Trust Fund Agent"; Text[50])
        {
        }
        field(49; "Trust Fund Number"; Text[50])
        {
        }
        field(50; "Bank Name (ACY)"; Text[50])
        {
        }
        field(51; "Emergency Contact 2"; Text[100])
        {
        }
        field(52; "Emergency Phone Contact 2"; Text[30])
        {
        }
        field(53; "Visa Expiry Date"; Date)
        {
        }
        field(54; "Visa Issue Date"; Date)
        {
        }

        field(55; "TECOM ID"; Code[50])
        {
        }
        field(56; "TECOM Expiry Date"; Date)
        {
        }
        field(57; "TECOM Issue Date"; Date)
        {
        }
        field(58; "Car Driving Permit Proxy"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Selection: Integer;
        AttachmentManagment: Record "Attachment Managment";
        AttachmentSelection: Label 'Upload,Download,Delete';
        EmpTbt: Record Employee;

    local procedure GetAttachmentFileName(L_RecID: RecordID; L_FieldID: Integer) FName: Text;
    var
        AttachManageTBT: Record "Attachment Managment";
    begin
        exit(AttachManageTBT.GetAttachmentFileName(DATABASE::"Employee Additional Info", L_RecID, L_FieldID));
    end;

    procedure GetProxyAttach() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO("Proxy(Wakeleh)")));
    end;

    procedure GetPassportAttach() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO(Passport)));
    end;

    procedure GetIDAttach() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO(ID)));
    end;

    procedure GetUndertakingFormAttach() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO("Undertaking Form")));
    end;

    procedure GetWorkPermitAttach() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO("Last Work Permit")));
    end;

    procedure GetWorkResidencyAttach() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO("Work Residency")));
    end;

    procedure GetInsuranceAttach() Fname: Text;
    begin
        exit(GetAttachmentFileName(Rec.RECORDID, Rec.FIELDNO(Insurance)));
    end;
}