page 98077 "Employee Attendance - Web"
{
    // version EDM.HRPY1

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Attendance - Web";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmpNo;EmpNo)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea=All;
                }
                field("Attend Date";"Attend Date")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Required Hours";"Required Hours")
                {
                    ApplicationArea=All;
                }
                field("Attend Hrs";"Attend Hrs")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    Caption = 'Project Code';
                    Editable = false;
                    ApplicationArea=All;
                }
                field(Remarks;Remarks)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Is Approved";"Is Approved")
                {
                    ApplicationArea=All;
                }
                field("Approved Hours";"Approved Hours")
                {
                    ApplicationArea=All;
                }
                field("Approval Comments";"Approval Comments")
                {
                    ApplicationArea=All;
                }
                field("Is Imported";"Is Imported")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Attendance Sheet")
            {
                Image = UpdateDescription;
                ApplicationArea=All;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction();
                begin
                    if CONFIRM('Are you sure you want to update the Attendance Sheet?',false) = true then
                      begin
                        Rec.FINDFIRST;
                        repeat
                            if (Rec."Is Approved" = true) and (Rec."Is Imported" = false) then
                              begin
                                  EmpTbt.SETRANGE("No.",Rec.EmpNo);
                                  if EmpTbt.FINDFIRST then
                                    begin
                                      if Rec."Attend Date" >= EmpTbt.Period  then
                                        begin
                                          EmpAbsTbt.SETRANGE("Employee No.",Rec.EmpNo);
                                          EmpAbsTbt.SETRANGE("From Date","Attend Date");
                                          if EmpAbsTbt.FINDFIRST then
                                            begin
                                               EmpAbsTbt."Attend Hrs." := Rec."Approved Hours";
                                               EmpAbsTbt.Remarks := Rec."Approval Comments";
                                               EmpAbsTbt.MODIFY;
                                               Rec."Is Imported" := true;
                                            end;

                                        end;
                                    end;
                                    Rec.MODIFY;
                             end;
                        until Rec.NEXT = 0;
                      end;
                end;
            }
        }
    }

    var
        EmpAbsTbt : Record "Employee Absence";
        EmpTbt : Record Employee;
}

