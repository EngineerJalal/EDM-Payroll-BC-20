report 98050 "Attendance Report by Project"
{
    // version EDM.HRPY2

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Attendance Report by Project.rdlc';

    dataset
    {
        dataitem("Employee Absence"; "Employee Absence")
        {
            DataItemTableView = WHERE("Cause of Absence Code" = CONST('WD'));
            RequestFilterFields = "From Date";
            column(EmployeeNo_EmployeeAbsence; "Employee Absence"."Employee No.")
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Picture_CompanyInformation; CompanyInformation.Picture)
            {
            }
            column(JobCategory_Employee; JobCategoryName)
            {
            }
            column(DepartmentName_Employee; DepartmentName)
            {
            }
            column(ProjectName_Employee; ProjectName)
            {
            }
            column(AttendHrs_EmployeeAbsence; "Employee Absence"."Attend Hrs.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                if ("Employee Absence"."Attendance No." <> 0) and ("Employee Absence".Period <> 0D) and ("Employee Absence"."Employment Type Code" <> '') then
                    CurrReport.SKIP;

                HumanResSetupTbt.GET();

                DefaultDimension.RESET;
                DimensionValue.RESET;
                ProjectName := '';
                DepartmentName := '';
                JobCategoryName := '';
                CALCFIELDS("Project Code", "Job Category", Department);

                ProjectVal := '';
                ProjectName := '';

                if HumanResSetupTbt."Project Dimension Type" = HumanResSetupTbt."Project Dimension Type"::"Global Dimension1" then
                    ProjectVal := "Employee Absence"."Global Dimension 1 Code"
                else
                    if HumanResSetupTbt."Project Dimension Type" = HumanResSetupTbt."Project Dimension Type"::"Global Dimension2" then
                        ProjectVal := "Employee Absence"."Global Dimension 2 Code"
                    else
                        if HumanResSetupTbt."Project Dimension Type" = HumanResSetupTbt."Project Dimension Type"::"Shortcut Dimension" then
                            ProjectVal := "Employee Absence"."Project Code";
                if ProjectVal <> '' then begin
                    if DimensionValue.GET('PROJECT', ProjectVal) then
                        ProjectName := DimensionValue.Name;
                end;


                DepartmentVal := '';
                DepartmentName := '';
                if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Global Dimension1" then
                    DepartmentVal := "Employee Absence"."Global Dimension 1 Code"
                else
                    if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Global Dimension2" then
                        DepartmentVal := "Employee Absence"."Global Dimension 2 Code"
                    else
                        if HumanResSetupTbt."Department Dimension Type" = HumanResSetupTbt."Department Dimension Type"::"Shortcut Dimension" then
                            DepartmentVal := "Employee Absence".Department;
                if DepartmentVal <> '' then begin
                    if DimensionValue.GET('DEPARTMENT', DepartmentVal) then
                        DepartmentName := DimensionValue.Name;
                end;



                HRInformation.SETRANGE(Code, "Employee Absence"."Job Category");
                if HRInformation.FINDFIRST then
                    JobCategoryName := HRInformation.Description;
            end;

            trigger OnPreDataItem();
            begin
                // Added in order to show only Employee related to Manger - 20.04.2017 : A2+
                HRPermission.SETRANGE("User ID", USERID);
                if (HRPermission.FINDFIRST) and (HRPermission."Attendance Limited Access") then
                    "Employee Absence".SETFILTER("Employee Absence"."Employee Manager No", '=%1', HRPermission."Assigned Employee Code");
                // Added in order to show only Employee related to Manger - 20.04.2017 : A2-
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        HRInformation: Record "HR Information";
        DepartmentName: Text[60];
        ProjectName: Text[60];
        EmpTotalAttendedHours: Decimal;
        JobCategoryName: Text[100];
        ProjectVal: Code[20];
        DepartmentVal: Code[20];
        HumanResSetupTbt: Record "Human Resources Setup";
        HRPermission: Record "HR Permissions";
}

