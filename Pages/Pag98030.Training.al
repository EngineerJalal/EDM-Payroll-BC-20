page 98030 "Training"
{
    // version SHR1.0,EDM.HRPY1

    // //

    PageType = Card;
    SourceTable = Training;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";Rec."No.")
                {
                    ApplicationArea=All;

                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                          CurrPage.UPDATE;
                    end;
                }
                field(Objectives;Rec.Objectives)
                {
                    Caption = 'Subject';
                    ApplicationArea=All;
                }
                field("Start Date";Rec."Start Date")
                {
                    Caption = '"Start / End Dates "';
                    ApplicationArea=All;
                }
                field("End Date";Rec."End Date")
                {
                    ApplicationArea=All;
                }
                field("Start Time";Rec."Start Time")
                {
                    Caption = 'Start / End Times';
                    ApplicationArea=All;
                }
                field("End Time";Rec."End Time")
                {
                    ApplicationArea=All;
                }
                field(Cost;Rec.Cost)
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        //EDM.IT
                        TrainingEmpRec.SETRANGE("Training No.",Rec."No.");
                        if TrainingEmpRec.FINDFIRST then
                        repeat
                          Rec.CALCFIELDS("No. of Employee");
                          if Rec."No. of Employee"<>0 then
                          begin
                            TrainingEmpRec.Cost:=Rec.Cost/Rec."No. of Employee";
                            TrainingEmpRec.MODIFY;
                          end;
                        until TrainingEmpRec.NEXT=0;
                        CurrPage.UPDATE;
                        //EDM.IT
                    end;
                }
                field("Max Attendees";Rec."Max Attendees")
                {
                    ApplicationArea=All;
                }
                field(Room;Rec.Room)
                {
                    ApplicationArea=All;
                }
                field(Address;Rec.Address)
                {
                    ApplicationArea=All;
                }
                field(Trainers;Rec.Trainers)
                {
                    ApplicationArea=All;
                }
                field("Company Name";Rec."Company Name")
                {
                    ApplicationArea=All;
                }
                field(Evaluation;Rec.Evaluation)
                {
                    ApplicationArea=All;
                }
                field("Evaluation Rate";Rec."Evaluation Rate")
                {
                    ApplicationArea=All;
                }
                field("More Info";Rec."More Info")
                {
                    ApplicationArea=All;
                }
                field("Certificate Title";Rec."Certificate Title")
                {
                    Enabled = "Certificate TitleEnable";
                    ApplicationArea=All;
                }
                field("Is Certificate Granted";Rec."Is Certificate Granted")
                {
                    Caption = 'Certificate Granted';
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        if Rec."Is Certificate Granted" then
                          "Certificate TitleEnable" := true
                        else
                          "Certificate TitleEnable" := false;
                    end;
                }
                field("Is Completed";Rec."Is Completed")
                {
                    Caption = 'Completed';
                    ApplicationArea=All;
                }
                field("Is External";Rec."Is External")
                {
                    Caption = 'External';
                    ApplicationArea=All;
                }
                field("In House";Rec."In House")
                {
                    ApplicationArea=All;
                }
                field("Performance Code";Rec."Performance Code")
                {
                    ApplicationArea=All;
                }
            }
            group(Employee)
            {
                Caption = 'Employee';
                part(Control1000000001;"Training Employee List")
                {
                    SubPageLink = "Training No."=FIELD("No.");
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Training")
            {
                Caption = '&Training';
                action("&List")
                {
                    Caption = '&List';
                    ShortCutKey = 'Shift+Ctrl+L';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        Training : Record Training;
                    begin
                        Training.SETRANGE("Table Name",Training."Table Name"::Training);
                        //FORM.RUNMODAL(80044,Training);
                    end;
                }
                action("&Employee(s)")
                {
                    Caption = '&Employee(s)';
                    RunObject = Page "Training Employee List";
                    RunPageLink = "Training No."=FIELD("Performance Code");
                    Visible = false;
                    ApplicationArea=All;
                }
                action("Insert Training Employees")
                {
                    Caption = 'Insert Training Employees';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //RunObject = Page Page80307;
                    Visible = false;
                    ApplicationArea=All;
                }
                action("Copy To New Training")
                {
                    Caption = 'Copy To New Training';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        TrainingNumber : Code[10];
                    begin
                        TrainingRec.INIT;
                        HumanResSetup.GET;
                        TrainingNumber:=NoSeriesMgt.GetNextNo(HumanResSetup."Training No.",WORKDATE,true);
                        TrainingRec."No.":=TrainingNumber;
                        TrainingRec."Table Name":=Rec."Table Name";
                        TrainingRec."Performance Code":=Rec."Performance Code";
                        TrainingRec."Start Date":=Rec."Start Date";
                        TrainingRec."End Date":=Rec."End Date";
                        TrainingRec."Start Time":=Rec."Start Time";
                        TrainingRec."End Time":=Rec."End Time";
                        TrainingRec."Is Completed":=Rec."Is Completed";
                        TrainingRec."Is External" :=Rec."Is External";
                        TrainingRec.Room :=Rec.Room;
                        TrainingRec.Trainers:=Rec.Trainers;
                        TrainingRec."Company Name":=Rec."Company Name";
                        TrainingRec.Objectives :=Rec.Objectives;
                        TrainingRec.Evaluation :=Rec.Evaluation;
                        TrainingRec.Cost:=Rec.Cost;
                        TrainingRec."More Info":=Rec."More Info";
                        TrainingRec."No. Series":=Rec."No. Series";
                        TrainingRec."Is Certificate Granted":=Rec."Is Certificate Granted";
                        TrainingRec."Certificate Title":=Rec."Certificate Title";
                        TrainingRec."Max Attendees" :=Rec."Max Attendees";
                        TrainingRec.Address:=Rec.Address;
                        TrainingRec.Description:=Rec.Description;
                        TrainingRec."Training Name" :=Rec."Training Name";
                        TrainingRec."Audience Type":=Rec."Audience Type";
                        TrainingRec."In House" :=Rec."In House";
                        TrainingRec.INSERT;

                        TrainingEmp.SETRANGE("Training No.",Rec."No.");
                        if TrainingEmp.FINDFIRST then
                        repeat
                          TrainingEmpRec.INIT;
                          TrainingEmpRec."Training No.":=TrainingNumber;
                          TrainingEmpRec.VALIDATE("Employee No.",TrainingEmp."Employee No.");
                          TrainingEmpRec."Training Evaluation":=TrainingEmp."Training Evaluation";
                          TrainingEmpRec.Attendance:=TrainingEmp.Attendance;
                          TrainingEmpRec.INSERT;
                        until TrainingEmp.NEXT=0;
                        MESSAGE('New Training Successfully Imported');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        if Rec."Is Certificate Granted" then
          "Certificate TitleEnable" := true
        else
          "Certificate TitleEnable" := false;

        //EDM+
        /*NotSatisfied:=0;
        Average:=0;
        Satisfied:=0;
        Very :=0;
        Evaluation:='';
        TrainingEmp.SETRANGE("Training No.","No.");
        if TrainingEmp.FINDFIRST then
        repeat
          if TrainingEmp."Training Evaluation"=TrainingEmp."Training Evaluation"::"Very Satisfied" then
              Very:=Very+1
          else if  TrainingEmp."Training Evaluation"=TrainingEmp."Training Evaluation"::Satisfied then
              Satisfied:=Satisfied+1
          else if  TrainingEmp."Training Evaluation"=TrainingEmp."Training Evaluation"::Average then
              Average := Average+1
          else if TrainingEmp."Training Evaluation"=TrainingEmp."Training Evaluation"::"Not Satisfied" then
              NotSatisfied:=NotSatisfied+1;
        until TrainingEmp.NEXT=0;
        if (Very>Satisfied) and(Very>Average) and (Very > NotSatisfied) then
          Evaluation:='Very Satisfied'
        else if (Satisfied>Very) and(Satisfied>Average) and (Satisfied > NotSatisfied) then
          Evaluation:='Satisfied'
        else if (Average>Very) and(Average>Satisfied) and (Average > NotSatisfied) then
          Evaluation:='Average'
        else if (NotSatisfied>Very) and(NotSatisfied>Satisfied) and (NotSatisfied >Average ) then
          Evaluation:='Not Satisfied';*/
        //EDM-
    end;

    trigger OnInit();
    begin
        "Certificate TitleEnable" := true;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        //EDM+
        HumanResSetup.GET;
        Rec."No.":=NoSeriesMgt.GetNextNo(HumanResSetup."Training No.",WORKDATE,true);
        //EDM-
    end;

    var
        [InDataSet]
        "Certificate TitleEnable" : Boolean;
        HumanResSetup : Record "Human Resources Setup";
        NoSeriesMgt : Codeunit NoSeriesManagement;
        TrainingEmp : Record "Training Employee List";
        NotSatisfied : Decimal;
        "Average" : Decimal;
        Satisfied : Decimal;
        Very : Decimal;
        TrainingRec : Record Training;
        TrainingEmpRec : Record "Training Employee List";
}

