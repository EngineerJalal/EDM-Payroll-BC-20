report 98098 "SendNotificationMailToEmployee"
{
    // version EDM.HRPY1

    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin

            //Stopped by EDM.MM     SendMail.SendNotificationMailToEmployee(Employee."E-Mail",Subject,Body);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Subject;Subject)
                {
                    ApplicationArea=All;
                }
                field(Body;Body)
                {
                    MultiLine = true;
                    ApplicationArea=All;
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

        if (Subject = '') or (Body = '') then
          ERROR('You must enter the Subject with the body for the mail');
    end;

    var
        Subject : Text;
        Body : Text;
}

