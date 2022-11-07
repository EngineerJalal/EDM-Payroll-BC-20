page 98007 "Leave Request List"
{
    // version EDM.HRPY1

    PageType = List;
    SourceTable = "Leave Request";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leave Request No.";Rec."Leave Request No.")
                {
                    ApplicationArea=All;
                }
                field("Employee No.";Rec."Employee No.")
                {
                    ApplicationArea=All;
                }
                field("Leave Type";Rec."Leave Type")
                {
                    ApplicationArea=All;
                }
                field("From Date";Rec."From Date")
                {
                    ApplicationArea=All;
                }
                field("From Time";Rec."From Time")
                {
                    ApplicationArea=All;
                }
                field("To Date";Rec."To Date")
                {
                    ApplicationArea=All;
                }
                field("To Time";Rec."To Time")
                {
                    ApplicationArea=All;
                }
                field("Demand Date";Rec."Demand Date")
                {
                    ApplicationArea=All;
                }
                field("Requested By";Rec."Requested By")
                {
                    ApplicationArea=All;
                }
                field("Alternative Employee No.";Rec."Alternative Employee No.")
                {
                    ApplicationArea=All;
                }
                field(Reason;Rec.Reason)
                {
                    ApplicationArea=All;
                }
                field(Remark;Rec.Remark)
                {
                    ApplicationArea=All;
                }
                field(Status;Rec.Status)
                {
                    ApplicationArea=All;
                }
                field("Days Value";Rec."Days Value")
                {
                    ApplicationArea=All;
                }
                field("Hours Value";Rec."Hours Value")
                {
                    ApplicationArea=All;
                }
                field("Request Type";Rec."Request Type")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            //Caption = 'F&unctions';
            action("Generate Employee Journal")
            {
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                                                       ApplicationArea=All;

                trigger OnAction();
                begin
                   // LeaveRequest.GenrateEmpJrnlFromLeaveRequest;
                end;
            }
            action("Leave Requests by Employee")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = false;
                RunObject = Report "Leave Requests by Employee";
                ApplicationArea=All;
            }
            action("Leave Requests by Calendar")
            {
                RunObject = Report "Leave Requests by Calendar";
                ApplicationArea=All;
            }
        }
    }
    trigger OnOpenPage();
    begin
        LeavesOfficerPermission := PayrollFunctions.IsLeavesOfficer(UserId);
        IF  LeavesOfficerPermission=false then
            Error('No Permission!');
    end;
    var
        LeaveRequest : Codeunit "EDM Web Portal";
        PayrollFunctions : Codeunit "Payroll Functions";
        LeavesOfficerPermission : Boolean;
}

