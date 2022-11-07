tableextension 98012 "ExtHumanResourcesSetup" extends "Human Resources Setup"
{
    // version NAVW14.00,SHR1.0,PY1.0,EDM.HRPY1,EDM.HRPY2

    fields
    {
        field(80001; "Applicant Alert"; Boolean)
        {
        }
        field(80002; "Employee Alert"; Boolean)
        {
        }
        field(80003; "Project Attendance Alert"; Boolean)
        {
        }
        field(80004; "Due Date Formula"; DateFormula)
        {
        }
        field(80005; "Applicant Nos."; Code[10])
        {
            Description = 'SHR1.0';
            TableRelation = "No. Series";
        }
        field(80006; "Payroll in Use"; Boolean)
        {
            Description = 'SHR1.0';

            trigger OnValidate();
            begin
                if (xRec."Payroll in Use") and (not "Payroll in Use") then begin
                    if PayDetailLine.FindFirst then
                        ERROR('Cannot be Unchecked : Payroll Data Exists in the System.');
                end;
            end;
        }
        field(80007; "Allow Single with Children"; Boolean)
        {
        }
        field(80008; "Minimum Salary"; Decimal)
        {
        }
        field(80009; "Additional Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(80010; "HR Logo"; BLOB)
        {
        }
        field(80011; "Additional Currency Short Desc"; Code[10])
        {
        }
        field(80012; "Hours To Days Month Period"; Integer)
        {
        }
        field(80013; "Period Filter"; Text[30])
        {
        }
        field(80014; "Trial Period"; DateFormula)
        {
            Description = 'SHR2.0';
        }
        field(80015; "Annual Leave Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;
        }
        field(80016; "IN Against Annual Leave Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("IN Against Annual Leave Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Against Annual Leave Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80017; "IN Day-Off Overtime Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("IN Day-Off Overtime Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Day-Off Overtime Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80018; "IN Standard Overtime Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("IN Standard Overtime Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Standard Overtime Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80019; "IN Public Overtime Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("IN Public Overtime Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Public Overtime Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80020; "Against Annual Leave Hours"; Decimal)
        {
            Description = 'SHR2.0';
        }
        field(80021; "Days In A Year"; Integer)
        {
            Description = 'SHR2.0';
        }
        field(80022; Location; Option)
        {
            Description = 'SHR2.0';
            OptionMembers = "Global Dimension 1","Global Dimension 2",Both;
        }
        field(80023; "IN Late Tolerance Minutes"; Integer)
        {
            Description = 'SHR2.0';
        }
        field(80024; "OUT Late Tolerance Minutes"; Integer)
        {
            Description = 'SHR2.0';
        }
        field(80025; "IN Overtime Tolerance Minutes"; Integer)
        {
            Description = 'SHR2.0';
        }
        field(80026; "OUT Overtime Tolerance Minutes"; Integer)
        {
            Description = 'SHR2.0';
        }
        field(80027; "OUT Against Annual Leave Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("OUT Against Annual Leave Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Against Annual Leave Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80028; "OUT Day-Off Overtime Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("OUT Day-Off Overtime Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Day-Off Overtime Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80029; "OUT Standard Overtime Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("OUT Standard Overtime Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Standard Overtime Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80030; "OUT Public Overtime Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;

            trigger OnValidate();
            begin
                CauseofAbsence.GET("OUT Public Overtime Code");
                if CauseofAbsence."Unit of Measure Code" <> 'HOUR' then
                    ERROR('The Public Overtime Code must have its Unit of Measure = HOUR.');
            end;
        }
        field(80031; "Over Lunch Break Out"; Code[10])
        {
            Description = 'MB.2403';
            TableRelation = "Cause of Absence".Code;
        }
        field(80032; "Over Lunch Break Out Tolerance"; Integer)
        {
            Description = 'MB.2403';
        }
        field(80033; "WTR File Path"; Text[250])
        {
            Description = 'MB.2403';
        }
        field(80034; "Absence Code"; Code[10])
        {
            Description = 'MB.2403';
            TableRelation = "Cause of Absence".Code;
        }
        field(80035; "Loan No."; Code[20])
        {
            Description = 'EDM.IT';
            TableRelation = "No. Series";
        }
        field(80036; "Monthly Hours"; Decimal)
        {
            Description = 'EDM.IT';
        }
        field(80037; "Hours in the Day"; Decimal)
        {
            Description = 'EDM.IT';
        }
        field(80038; "Training No."; Code[20])
        {
            Description = 'EDM.IT';
            TableRelation = "No. Series";
        }
        field(80039; "Termination/Employment Code"; Code[10])
        {
            Description = 'SHR2.0';
            TableRelation = "Cause of Absence".Code;
        }
        field(80040; "Working Day Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80041; Overtime; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80042; Deduction; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80043; "Accumulate Overtime To AL"; Boolean)
        {
        }
        field(80044; "Deduct Absence From AL"; Boolean)
        {
        }
        field(80045; "Overtime To AL Code"; Code[10])
        {
            TableRelation = "Cause of Absence" WHERE("Affect Work Days" = CONST(false), "Affect Attendance Days" = CONST(false), "Associated Pay Element" = CONST(''));
        }
        field(80046; "Deduct Absence From AL Code"; Code[10])
        {
            TableRelation = "Cause of Absence" WHERE("Associated Pay Element" = CONST(''));
        }
        field(80047; "Type of Attendance Punch file"; Option)
        {
            OptionCaption = 'ExcelStyle5C,ExcelStyle4C,TextCommaDelimiter1,ExcelStyle3C,ExcelStyleInOut,AccessDB,SQLDB,ExcelStyle4';
            OptionMembers = ExcelStyle5C,ExcelStyle4C,TextCommaDelimiter1,ExcelStyle3C,ExcelStyleInOut,AccessDB,SQLDB,ExcelStyle4;
        }
        field(80048; "Attendance Punch Date Format"; Option)
        {
            OptionMembers = "DD-MM-YYYY HH:MM","MM-DD-YYYY HH:MM","DD-MM-YYYY","MM-DD-YYYY";
        }
        field(80049; "Attendance Punch Time Format"; Option)
        {
            OptionMembers = DateTime,Time;
        }
        field(80050; "Disable Data Entry Validation"; Boolean)
        {
        }
        field(80051; "Attendance Date Seperator"; Option)
        {
            OptionMembers = "/","-",".";
        }
        field(80052; "Check Entitlement Balance"; Boolean)
        {
        }
        field(80053; "Holiday Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80054; "Nb Char From Emp Last Name"; Integer)
        {

            trigger OnValidate();
            begin

                if "Nb Char From Emp First Name" + "Nb Char From Emp Last Name" > 16 then
                    ERROR('The sum of Characters for First Name and Last Name must be less then 16');
            end;
        }
        field(80055; "Employee No. Format Type"; Option)
        {
            OptionMembers = Default,"[First Name] + [Last Name]";
        }
        field(80056; "Nb Char From Emp First Name"; Integer)
        {

            trigger OnValidate();
            begin

                if "Nb Char From Emp First Name" + "Nb Char From Emp Last Name" > 16 then
                    ERROR('The sum of Characters for First Name and Last Name must be less then 16');
            end;
        }
        field(80057; "Project Dimension Type"; Option)
        {
            OptionCaption = 'Shortcut Dimension,Global Dimension1,Global Dimension2';
            OptionMembers = "Shortcut Dimension","Global Dimension1","Global Dimension2";
        }
        field(80058; "Department Dimension Type"; Option)
        {
            OptionCaption = 'Shortcut Dimension,Global Dimension1,Global Dimension2';
            OptionMembers = "Shortcut Dimension","Global Dimension1","Global Dimension2";
        }
        field(80059; "Division Dimension Type"; Option)
        {
            OptionCaption = 'Shortcut Dimension,Global Dimension1,Global Dimension2';
            OptionMembers = "Shortcut Dimension","Global Dimension1","Global Dimension2";
        }
        field(80060; "Use System Approval"; Boolean)
        {
        }
        field(80061; CUSTIND; Text[15])
        {
        }
        field(80062; "Auto Assign Attendance No"; Boolean)
        {
        }
        field(80063; "Attendance Access DB File"; Text[20])
        {
        }
        field(80064; "Attendance Access DB Path"; Text[250])
        {
        }
        field(80065; "Entitlement Generation Type"; Option)
        {
            OptionCaption = 'Interval Basis,Yearly Basis,Employment Basis';
            OptionMembers = "Interval Basis","Yearly Basis","Employment Basis";
        }
        field(80066; "Auto Update Emp Related"; Boolean)
        {
            Description = 'Added for Employee View by type';
        }
        field(80067; "Reset Attendance Jnls Manual"; Boolean)
        {
            Description = 'Added for deleting the existing Attendance Journals while posting to Payroll (Attendance List)';
        }
        field(80068; "Average Days Per Month"; Decimal)
        {
            Description = 'NSSF and Salary Declaration Calculations';
        }
        field(80069; "Export Report Path"; Text[250])
        {
        }
        field(80070; "Branch Dimension Type"; Option)
        {
            OptionCaption = 'Shortcut Dimension,Global Dimension1,Global Dimension2';
            OptionMembers = "Shortcut Dimension","Global Dimension1","Global Dimension2";
        }
        field(80071; "Auto Calculate Entitlement"; Boolean)
        {
        }
        field(80072; "Auto Apply Salary Raise"; Boolean)
        {
            Description = 'added to update salary autometic by system when start date of approved salary raise is reached';

            trigger OnValidate();
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
                JobQueueEntry.RESET;
                JobQueueEntry.SETRANGE("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
                JobQueueEntry.SETRANGE("Object ID to Run", REPORT::"Auto Apply Salary Raise");
                if JobQueueEntry.FINDFIRST then
                    if "Auto Apply Salary Raise" = true then begin
                        JobQueueEntry.VALIDATE(Status, JobQueueEntry.Status::Ready);
                        JobQueueEntry.VALIDATE(Status, JobQueueEntry.Status::"On Hold");
                        JobQueueEntry.VALIDATE(Status, JobQueueEntry.Status::Ready);
                        JobQueueEntry.MODIFY;
                    END
                    ELSE BEGIN
                        JobQueueEntry.VALIDATE(Status, JobQueueEntry.Status::"On Hold");
                        JobQueueEntry.MODIFY;
                    end;
            end;
        }
        field(80073; "Use Grading System"; Boolean)
        {
        }
        field(80074; "Web Temp Path"; Text[70])
        {
        }
        field(80075; "Seperate Attendance Interval"; Boolean)
        {
        }
        field(80076; "Use Schooling System"; Boolean)
        {
        }
        field(80077; "Job Hourly Rate Calculation"; Option)
        {
            OptionCaption = 'Average,Employee Rate';
            OptionMembers = "Average","Employee Rate";
        }
        field(80078; "Job Journal Template"; Code[10])
        {
            TableRelation = "Job Journal Template";
        }
        field(80079; "Job Journal Batch"; Code[10])
        {
            TableRelation = "Job Journal Batch".Name WHERE("Journal Template Name" = FIELD("Job Journal Template"));
        }
        field(80080; "Job Line Type"; Option)
        {
            OptionCaption = '" ,Budget,Billable,Both Budget and Billable"';
            OptionMembers = " ",Budget,Billable,"Both Budget and Billable";
        }
        field(80081; "Job Source Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('SOURCE'));
        }
        field(80082; "Def. Job Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(80083; "Job Resource UOM"; Code[10])
        {
            TableRelation = "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("Def. Job Resource No."));
        }
        field(80084; "Def. Gen. Bus. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Business Posting Group";
        }
        field(80085; "Def. Gen. Prod. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(80086; "Use Resources Concept"; Boolean)
        {
        }
        field(80087; "Travel Per Deem Shift Code"; Code[10])
        {
            TableRelation = "Daily Shifts"."Shift Code";
        }
        field(80088; "Use Evaluation Sheet"; Boolean)
        {

        }
        field(80089; "Use Sub Payroll"; Boolean)
        {

        }
        field(80090; "Use Multiple Allowance Utility"; Boolean)
        {

        }
        field(80091; "Late Arrive Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80092; "Customized Leave Code"; Text[20])
        {
        }
        field(80093; "Auto Reset leave Attend Hrs"; Boolean)
        {
            Caption = 'Auto Reset Attend Hrs for leave';
        }
        field(80094; "Give Holiday Transportation"; Boolean)
        {
        }
        field(80095; "Auto Synchronize Attendance"; Boolean)
        {
        }
        field(80096; "Control Trans For Working Days"; Boolean)
        {
            Caption = 'Control Transportation For Working Days';
        }
        field(80097; "Number of Days Transport"; Decimal)
        {
        }
        field(80098; "Seperate Attend From Payroll"; Boolean)
        {
            Caption = 'Seperate Attendance From Payroll';
        }
        field(80099; "Working From Home Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80100; "Allowed Late Arrive Mins"; Decimal)
        {
        }
        field(80101; "Accumulate Weekend Overtime To Sunday"; Boolean)
        {
        }
        field(80102; "Accumulate Holiday Overtime To HolidayVac"; Boolean)
        {
        }
        field(80103; "Sunday Leave Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80104; "Holiday Leave Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80105; "Transfer Negative AL from Previous Year"; Boolean)
        {
            Caption = 'Transfer Negative Anual Leave from Previous Year';
        }
        field(80106; "Generate Monthly Entitlement"; Boolean)
        {

        }
        field(80107; "Use Payroll Special Calculation"; Boolean)
        {
        }
        field(80108; "Use OverTime Unpaid Hours"; Boolean)
        {

        }
        field(80109; "Sick Leave Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(80111; "Manual Schedule"; Boolean)
        {

        }
    }
    var
        PayDetailLine: Record "Pay Detail Line";
        CauseofAbsence: Record "Cause of Absence";
}