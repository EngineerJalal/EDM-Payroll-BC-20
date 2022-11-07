pageextension 98004 "ExtEmployeePicture" extends "Employee Picture"
{

    layout
    {
        addafter(Image)
        {
            field(Picture; Rec.Image)//EDM+- 30-05-2020
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        Modify("TakePicture")
        {
            Visible = false;
        }
        Modify("ImportPicture")
        {
            Visible = IsHROfficer or IsDataEntryOfficer;
        }
        Modify("ExportFile")
        {
            Visible = IsHROfficer or IsDataEntryOfficer;
        }
        Modify("DeletePicture")
        {
            Visible = IsHROfficer or IsDataEntryOfficer;
        }
    }
    trigger OnOpenPage();
    begin
        IsHROfficer := PayrollFunctions.IsHROfficer(UserId);
        IsDataEntryOfficer := PayrollFunctions.IsDataEntryOfficer(Userid);
    end;

    var
        PayrollFunctions: Codeunit "Payroll Functions";
        IsHROfficer: Boolean;
        IsDataEntryOfficer: Boolean;
}

