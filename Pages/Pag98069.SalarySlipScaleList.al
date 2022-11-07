page 98069 "Salary Slip Scale List"
{
    // version EDM.HRPY1

    PageType = List;
    SourceTable = "Salary Slip Scale";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Band;Band)
                {
                    ApplicationArea=All;
                }
                field(Grade;Grade)
                {
                    ApplicationArea=All;
                }
                field("Job Category";"Job Category")
                {
                    ApplicationArea=All;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea=All;
                }
                field("From Salary Scale";"From Salary Scale")
                {
                    ApplicationArea=All;
                }
                field("To Salary Scale";"To Salary Scale")
                {
                    ApplicationArea=All;
                }
                field("Appraisal And Deduction";"Appraisal And Deduction")
                {
                    ApplicationArea=All;
                }
                field(Amount;Amount)
                {
                    ApplicationArea=All;
                }
                field("Amount ACY";"Amount ACY")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit();
    begin
        //Added in order to show/ Hide salary fields - 05.07.2016 : AIM +
        if  PayrollFunction.HideSalaryFields() = true then
           ERROR('Permission NOT Allowed!');
        //Added in order to show/ Hide salary fields - 05.07.2016 : AIM -
    end;

    var
        PayrollFunction : Codeunit "Payroll Functions";
}

