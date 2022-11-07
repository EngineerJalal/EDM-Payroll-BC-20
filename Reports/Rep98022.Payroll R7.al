report 98022 "Payroll R7"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Payroll R7.rdl';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            MaxIteration = 1;
            column(CompanyInfoRec_ArabicName; CompanyInfoRec."Arabic Name")
            {
            }
            column(CompanyInfoRec_Registration_No; CompanyInfoRec."Registration No.")
            {
            }
            column(CompanyInfoRec_Arabic_Trading_Name; CompanyInfoRec."Arabic Trading Name")
            {
            }
            column(NSSFRegistrationNo; CompanyInfoRec."Registration No.")
            {
            }
            column(RegistrationNo; CompanyInfoRec."Arabic Registration No.")
            {
            }
            trigger OnAfterGetRecord();
            begin
                /*CompRegNo := '';
                for i := 1 to 9 do begin
                    if COPYSTR(CompanyInfoRec."Registration No.", i, 1) <> '' then
                        CompRegNo := CompRegNo + ' | ' + COPYSTR(CompanyInfoRec."Registration No.", i, 1)
                    else
                        CompRegNo := CompRegNo + ' |  '
                end;*/
            end;
        }
        dataitem(Employee; Employee)
        {

            column(No_Employee; Employee."No.")
            {
            }
            column(PersonalFinanceNo_Employee; Employee."Personal Finance No.")
            {
            }
            column(Employee_Employee__NSSF_No__; Employee."Social Security No.")
            {
            }
            column(EmploymentDate_Employee; Employee."Employment Date")
            {
            }
            column(TerminationDate_Employee; Employee."Termination Date")
            {
            }
            column(DeclarationDate_Employee; Employee."Declaration Date")
            {
            }
            column(ArabicName_Employee; Employee."Arabic Name")
            {
            }
            column(EmployeeName; EmployeeName)
            {
            }
            column(RYear; RYear)
            {
            }
            column(EmpDate1; EmpDate[1])
            {
            }
            column(EmpDate2; EmpDate[2])
            {
            }
            column(EmpDate3; EmpDate[3])
            {
            }
            column(TerDate1; TerDate[1])
            {
            }
            column(TerDate2; TerDate[2])
            {
            }
            column(TerDate3; TerDate[3])
            {
            }
            column(PersFinNo; PersFinNo)
            {
            }

            trigger OnAfterGetRecord();
            begin


                if Employee."Arabic Name" <> '' then
                    EmployeeName := Employee."Arabic Name"
                else
                    EmployeeName := Employee."Full Name";

                PersFinNo := '';
                for i := 1 to 9 do begin
                    if COPYSTR(Employee."Personal Finance No.", i, 1) <> '' then
                        PersFinNo := PersFinNo + '|' + COPYSTR(Employee."Personal Finance No.", i, 1)
                    else
                        PersFinNo := PersFinNo + '|  '
                end;

                RYear := DATE2DMY(Employee."Termination Date", 3);

                if Employee."Declaration Date" <> 0D then begin
                    EmpDate[1] := DATE2DMY(Employee."Declaration Date", 1);
                    EmpDate[2] := DATE2DMY(Employee."Declaration Date", 2);
                    EmpDate[3] := DATE2DMY(Employee."Declaration Date", 3);
                end;

                if Employee."Termination Date" <> 0D then begin
                    TerDate[1] := DATE2DMY(Employee."Termination Date", 1);
                    TerDate[2] := DATE2DMY(Employee."Termination Date", 2);
                    TerDate[3] := DATE2DMY(Employee."Termination Date", 3);
                end;

            end;

            trigger OnPreDataItem();
            begin
                SETFILTER("Termination Date", '%1..%2', DMY2DATE(1, 1, Year), DMY2DATE(31, 12, Year));
                SETFILTER(Status, '=%1', Status::Terminated);
                SetRange(Declared, Declared::Declared);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Year; Year)
                {
                    ApplicationArea = All;
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

    trigger OnInitReport();
    begin
        CompanyInfoRec.GET;
        CompanyInfoRec.CALCFIELDS(CompanyInfoRec.Picture);
    end;

    var
        CompanyInfoRec: Record "Company Information";
        EmployeeName: Text;
        Year: Integer;
        RYear: Integer;
        EmpDate: array[3] of Integer;
        TerDate: array[3] of Integer;
        PersFinNo: Text;
        LenPersFinNo: Integer;
        i: Integer;
        CompRegNo: Text;
}

