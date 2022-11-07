page 98127 "New Hire Check List"
{
    PageType = List;
    SourceTable = "Check List";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea=All;
                    
                }
                field("Check List Code";"Check List Code")
                {
                    ApplicationArea=All;

                }
                field("Check List Description";"Check List Description")
                {
                    ApplicationArea=All;

                }
                field ("From Date";"From Date")
                {
                    ApplicationArea=All;

                }
                field("Till Date";"Till Date")
                {
                    ApplicationArea=All;

                }
                field(Applicable;Applicable)
                {
                    ApplicationArea=All;

                }
                field(Done;Done)
                {
                    ApplicationArea=All;

                }
                field(Remarks;Remarks)
                {
                    ApplicationArea=All;
                    
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        Type := Type::"New Hire";
    end;

    trigger OnOpenPage()
    var
        RecFilter : Text[250];
        Employee : Record Employee;
        CheckListItem : Record "Checklist Items";
        CheckList : Record "Check List";
        CheckListRec : Record "Check List";
        EmployeeNo : Code[20];
        LineNo : Integer;
    begin
        FilterGroup(2);
        Rec.SetFilter(Type,'%1',Rec.Type::"New Hire");
        FilterGroup(0);

        RecFilter := Rec.GetFilter("Employee No.");
        if RecFilter <> '' then
            Evaluate(EmployeeNo,RecFilter);
        
        Employee.Get(EmployeeNo); 
        CheckList.Reset;
        CheckList.SetRange("Employee No.",EmployeeNo);
        CheckList.SetRange(Type,CheckList.Type::"New Hire");
        if not CheckList.FindFirst then begin 
            CheckListItem.SetRange(Type,CheckListItem.Type::"New Hire"); 
            CheckListItem.SetRange("Job Title",Employee."Job Title Code");
            CheckListItem.SetRange("Is Active",true);
            if CheckListItem.FindFirst then begin
                repeat
                    LineNo := GetLastLineNo; 
                    CheckListRec.Init; 
                    CheckListRec."Line No." := LineNo + 1;         
                    CheckListRec."Employee No." := EmployeeNo;
                    CheckListRec.Type := CheckListItem.Type;  
                    CheckListRec."Check List Code" := CheckListItem."Code";   
                    CheckListRec."Check List Description" := CheckListItem.Description; 
                    CheckListRec.Insert;
                until CheckListItem.Next = 0;
            end
            else begin
                CheckListItem.SetRange(Type,CheckListItem.Type::"New Hire"); 
                CheckListItem.SetRange("Job Title",'');
                CheckListItem.SetRange("Is Active",true);
                if CheckListItem.FindFirst then begin
                    repeat
                        LineNo := GetLastLineNo; 
                        CheckListRec.Init; 
                        CheckListRec."Line No." := LineNo + 1;         
                        CheckListRec."Employee No." := EmployeeNo;
                        CheckListRec.Type := CheckListItem.Type;  
                        CheckListRec."Check List Code" := CheckListItem."Code";   
                        CheckListRec."Check List Description" := CheckListItem.Description; 
                        CheckListRec.Insert;
                    until CheckListItem.Next = 0;
                end                
            end;
        end;
    end;
    local procedure GetLastLineNo() val : Integer
    var
        CheckList : Record "Check List";
    begin
        if CheckList.FindLast then  
            exit(CheckList."Line No.");

    end;
}