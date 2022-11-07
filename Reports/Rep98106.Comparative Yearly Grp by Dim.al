report 98106 "Comparative Yearly Grp by Dim"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Comparative Yearly Grp by Dim.rdlc';

    dataset
    {
        dataitem("Pay Detail Line";"Pay Detail Line")
        {
            column(EmployeeNo_PayDetailLine;"Pay Detail Line"."Employee No.")
            {
            }
            column(TaxYear_PayDetailLine;"Pay Detail Line"."Tax Year")
            {
            }
            column(Period_PayDetailLine;"Pay Detail Line".Period)
            {
            }
            column(PayElementCode_PayDetailLine;"Pay Detail Line"."Pay Element Code")
            {
            }
            column(Description_PayDetailLine;"Pay Detail Line".Description)
            {
            }
            column(CalculatedAmount_PayDetailLine;"Pay Detail Line"."Calculated Amount")
            {
            }
            column(DimensionValueCode;DimensionValueCode)
            {
            }
            column(DimensionValueName;DimensionValueName)
            {
            }
            column(GroupBy;GroupBy)
            {
            }
            column(FromDate;FromDate)
            {
            }
            column(TillDate;TillDate)
            {
            }

            trigger OnAfterGetRecord();
            begin
                DimensionValueCode := '';
                DimensionValueName := '';

                DefaultDimension.SETRANGE("Table ID",5200);
                DefaultDimension.SETRANGE("No.","Pay Detail Line"."Employee No.");
                DefaultDimension.SETRANGE("Dimension Code",GroupBy);
                IF DefaultDimension.FINDFIRST THEN
                  DimensionValueCode := DefaultDimension."Dimension Value Code";

                DimensionValue.SETRANGE(Code,DefaultDimension."Dimension Value Code");
                DimensionValue.SETRANGE("Dimension Code",GroupBy);
                IF DimensionValue.FINDFIRST THEN
                  DimensionValueName := DimensionValue.Name;
            end;

            trigger OnPreDataItem();
            begin
                "Pay Detail Line".SETRANGE("Pay Detail Line"."Payroll Date",FromDate,TillDate);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Report Parameter")
                {
                    field("Group By";GroupBy)
                    {
                        TableRelation = Dimension.Code;
                        ApplicationArea=All;
                    }
                    field("From Date";FromDate)
                    {
                        ApplicationArea=All;
                    }
                    field("Till Date";TillDate)
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

    var
        FromDate : Date;
        TillDate : Date;
        GroupBy : Code[10];
        DimensionValue : Record "Dimension Value";
        DimensionValueCode : Code[20];
        DimensionValueName : Text[50];
        DefaultDimension : Record "Default Dimension";
}

