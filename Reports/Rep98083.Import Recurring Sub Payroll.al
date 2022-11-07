report 98083 "Import Recurring Sub Payroll"
{
    // version EDM.HRPY2

    ProcessingOnly = true;

    dataset
    {
        dataitem("Pay Detail Line";"Pay Detail Line")
        {

            trigger OnAfterGetRecord();
            var
                HRTransactionType : Record "HR Transaction Types";
            begin
                PaySubDetails.RESET;
                CLEAR(PaySubDetails);
                if PaySubDetails.FINDLAST then
                  SubPayID := PaySubDetails.ID;

                HRTransactionType.RESET;
                CLEAR(HRTransactionType);
                HRTransactionType.SETRANGE("Associated Pay Element","Pay Detail Line"."Pay Element Code");
                if (HRTransactionType.FINDFIRST) and (HRTransactionType.Recurring) then
                  begin
                    SubPayID += 1;
                    PaySubDetails.INIT;
                    PaySubDetails.ID := SubPayID;
                    PaySubDetails."Ref Code" := NewRefCode;
                    PaySubDetails."Employee No." := "Pay Detail Line"."Employee No.";
                    PaySubDetails."Pay Element Code" := "Pay Detail Line"."Pay Element Code";
                    PaySubDetails.VALIDATE(Amount,"Pay Detail Line"."Calculated Amount");
                    PaySubDetails.INSERT;
                  end;
            end;

            trigger OnPreDataItem();
            begin
                if SubPayDate <> 0D then
                  "Pay Detail Line".SETFILTER("Pay Detail Line"."Payroll Date",'%1',SubPayDate);

                if DeleteExisting then
                  begin
                    PaySubDetails.SETRANGE("Ref Code",NewRefCode);
                    if PaySubDetails.FINDFIRST then
                      repeat
                        PaySubDetails.DELETE;
                      until PaySubDetails.NEXT = 0;
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Requested Parameter")
                {
                    field("Sub Payroll Date";SubPayDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Delete Existing";DeleteExisting)
                    {
                        ApplicationArea=All;
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

    trigger OnPreReport();
    begin
        if SubPayDate = 0D then
          ERROR('Sub payroll date must not be empty');
    end;

    var
        SubPayDate : Date;
        NewRefCode : Code[20];
        SubPayID : Integer;
        DeleteExisting : Boolean;
        PaySubDetails : Record "Payroll Sub Details";

    procedure SetParameter(RefCode : Code[20]);
    begin
        NewRefCode := RefCode;
    end;
}

