report 98002 "Plan Annual Training"
{
    // version EDM.IT,EDM.HRPY1

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports Layouts/Plan Annual Training.rdlc';

    dataset
    {
        dataitem(Training;Training)
        {
            RequestFilterFields = "No.";
            column(CompanyName;CompanyInformation.Name)
            {
            }
            column(year;year)
            {
            }
            column(CompanyPicture;CompanyInformation.Picture)
            {
            }
            column(Training__Start_Date_;"Start Date")
            {
            }
            column(Training__End_Date_;"End Date")
            {
            }
            column(Training_Objectives;Training.Objectives)
            {
            }
            column(Training_Trainers;Trainers)
            {
            }
            column(Training__No__;"No.")
            {
            }
            column(Training_Cost;Cost)
            {
            }
            column(Training_Table_Name;"Table Name")
            {
            }
            column(Training_Performance_Code;"Performance Code")
            {
            }
            column(Training_IsCompleted;Training."Is Completed")
            {
            }
            dataitem("Training Employee List";"Training Employee List")
            {
                DataItemLink = "Training No."=FIELD("No.");
                column(Training_Employee_List__Employee_First_Name_;"Employee First Name")
                {
                }
                column(Training_Employee_List__Employee_Last_Name_;"Employee Last Name")
                {
                }
                column(Training_Employee_List__Training_Evaluation_;"Training Evaluation")
                {
                }
                column(VarCost;VarCost)
                {
                }
                column(Training_Employee_List_Training_No_;"Training No.")
                {
                }
                column(Training_Employee_List_Employee_No_;"Employee No.")
                {
                }
                column(Training_Employee_List_Applicant_No_;"Applicant No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                VarCost:=0;
                year := DATE2DMY(WORKDATE,3);

                CALCFIELDS("Number of Employees");
                if "Number of Employees"<>0 then
                  VarCost:=ROUND(Training.Cost/"Number of Employees")
                else
                  VarCost:=0;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        CompanyInformation.CALCFIELDS(Picture);
        //CompanyInformation.GET();
    end;

    var
        year : Integer;
        CompanyInformation : Record "Company Information";
        VarCost : Decimal;
}

