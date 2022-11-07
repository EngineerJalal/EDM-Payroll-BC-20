table 98034 "HR Dimensions"
{

    Caption = 'HR Dimensions';
    fields
    {
        field(1;"Table ID";Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table ID"=CONST(17353)) Applicant;
        }
        field(3;"Dimension Code";Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = false;
            TableRelation = Dimension;

            trigger OnValidate();
            begin
                if not DimMgt.CheckDim("Dimension Code") then
                  ERROR(DimMgt.GetDimErr);
            end;
        }
        field(4;"Dimension Value Code";Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value"."Code" WHERE ("Dimension Code"=FIELD("Dimension Code"));

            trigger OnValidate();
            begin
                if not DimMgt.CheckDimValue("Dimension Code","Dimension Value Code") then
                  ERROR(DimMgt.GetDimErr);
            end;
        }
        field(6;"Table Name";Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Table),"Object ID"=FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Job Title";Code[50])
        {
            TableRelation = "HR Information"."Code" WHERE ("Table Name"=CONST("Job Title"));
        }
        field(9;Priority;Option)
        {
            OptionMembers = " ","1","2","3","4","5";
        }
        field(10;Type;Option)
        {
            OptionMembers = "Applied For","Hired For";
        }
        field(11;"Line No.";Integer)
        {
        }
    }

    keys
    {
        key(Key1;Type,"Table ID","No.","Dimension Code","Dimension Value Code","Job Title",Priority,"Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        CheckApplicantEditing;
    end;

    trigger OnInsert();
    begin
        CheckApplicantEditing;
        ValidateDuplicate('');
    end;

    trigger OnModify();
    begin
        CheckApplicantEditing;
        ValidateDuplicate('Modify');
    end;

    trigger OnRename();
    begin
        CheckApplicantEditing;
        ValidateDuplicate('Modify');
    end;

    var
        Text000 : Label 'You can''t rename a %1.';
        GLSetup : Record "General Ledger Setup";
        DimMgt : Codeunit DimensionManagement;
        AppliedJobs : Record "HR Dimensions";

    procedure GetCaption() : Text[250];
    var
        ObjTransl : Record "Object Translation";
        CurrTableID : Integer;
        NewTableID : Integer;
        NewNo : Code[20];
        SourceTableName : Text[100];
    begin
        if not EVALUATE(NewTableID,GETFILTER("Table ID")) then
          exit('');

        if NewTableID = 0 then
          if GETRANGEMIN("Table ID") = GETRANGEMAX("Table ID") then
            NewTableID := GETRANGEMIN("Table ID")
          else
            NewTableID := 0;

        if NewTableID <> CurrTableID then
          SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,NewTableID);
        CurrTableID := NewTableID;

        if GETFILTER("No.") <> '' then
          if GETRANGEMIN("No.") = GETRANGEMAX("No.") then
            NewNo := GETRANGEMIN("No.")
          else
            NewNo := '';

        if NewTableID <> 0 then
          exit(STRSUBSTNO('%1 %2',SourceTableName,NewNo))
        else
          exit('');
    end;

    procedure ValidateDuplicate(P_Mode : Text[30]);
    begin
        AppliedJobs.RESET;
        if Type = Type::"Hired For" then begin
          AppliedJobs.SETRANGE("Table ID",60000);
          AppliedJobs.SETRANGE("No.",Rec."No.");
          AppliedJobs.SETRANGE(Type,Rec.Type::"Hired For");
          if AppliedJobs.FIND('-') then repeat
            if (AppliedJobs."Dimension Code" = "Dimension Code") then begin
              if ((P_Mode = 'Modify') and (AppliedJobs."Line No." <> "Line No.")) or
                  (P_Mode <> 'Modify') then
                ERROR('Dimension Code Already Exist !');
            end;
          until AppliedJobs.NEXT = 0; 
        end;
    end;

    procedure CheckApplicantEditing();
    var
        Applicant : Record Applicant;
    begin
        Applicant.GET("No.");
        if (Applicant.Status = Applicant.Status::Hired) then
          ERROR ('Hired Applicants Cannot be Edited !');
    end;
}