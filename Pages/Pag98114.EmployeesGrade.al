page 98114 "Employees Grade"
{
    // version EDM.HRPY2

    InsertAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Employee Grading History";

    layout
    {
        area(content)
        {
            group("Filter Parameter")
            {
                field("Employee No.";EmpNo)
                {
                    TableRelation = Employee."No.";
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetFilters();
                        CurrPage.UPDATE;
                    end;
                }
                field("Employee Category";EmpCateg)
                {
                    TableRelation = "Employee Categories".Code;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetFilters();
                        CurrPage.UPDATE;
                    end;
                }
                field("Dimension 1";Dim1)
                {
                    CaptionClass = '1,1,1';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetFilters();
                        CurrPage.UPDATE;
                    end;
                }
                field("Dimension 2";Dim2)
                {
                    CaptionClass = '1,1,2';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetFilters();
                        CurrPage.UPDATE;
                    end;
                }
                field("Job Title";JobTitle)
                {
                    TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Job Title"));
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetFilters();
                        CurrPage.UPDATE;
                    end;
                }
                field("Job Category";JobCategory)
                {
                    TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Job Category"));
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetFilters();
                        CurrPage.UPDATE;
                    end;
                }
                field("Job Position";JobPosition)
                {
                    TableRelation = "HR Information".Code WHERE ("Table Name"=CONST("Job Title"));
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        SetFilters();
                        CurrPage.UPDATE;
                    end;
                }
            }
            group("Employees List")
            {
                repeater(Group)
                {
                    field("Employee No";"Employee No")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Employee Name";"Employee Name")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Previous Grade Category";"Previous Grade Category")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Previous Grade";"Previous Grade")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Previous Basic Pay";"Previous Basic Pay")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Previous HCL";"Previous HCL")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Previous Last Grading Date";"Previous Last Grading Date")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Previous Next Grading Date";"Previous Next Grading Date")
                    {
                        Caption = 'Suggested Next Grading Date';
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Grade Category";"Grade Category")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field(Grade;Grade)
                    {
                        ApplicationArea=All;

                        trigger OnValidate();
                        var
                            GradingScale : Record "Grading Scale";
                            PeriodType : DateFormula;
                        begin
                            if not PayFunction.IsGradeValueValid(Grade,"Grade Category") then
                              ERROR('Invalid Grade Code');

                            GradingScale.SETRANGE("Employee Category","Grade Category");
                            GradingScale.SETRANGE("Grade Code",Grade);
                            if GradingScale.FINDFIRST then
                              begin
                                VALIDATE("Basic Pay",GradingScale."Grade Basic Salary");
                                VALIDATE(HCL ,GradingScale."Grade Cost of Living");

                                EVALUATE(PeriodType,'1M');
                                if (GradingScale."Grade Interval Type" = PeriodType) and ("Previous Last Grading Date" <> 0D) then
                                  begin
                                    //VALIDATE("Last Grading Date" ,CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>',"Previous Last Grading Date"));
                                    VALIDATE("Last Grading Date" ,"Previous Next Grading Date");
                                    //VALIDATE("Next grading Date" ,CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>',"Previous Next Grading Date"));
                                  end;
                                EVALUATE(PeriodType,'1Y');
                                if (GradingScale."Grade Interval Type" = PeriodType) and ("Previous Next Grading Date" <> 0D) then
                                  begin
                                    //VALIDATE("Last Grading Date" ,CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'Y>',"Previous Last Grading Date"));
                                    VALIDATE("Last Grading Date" ,"Previous Next Grading Date");
                                    //VALIDATE("Next grading Date" ,CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>',"Previous Next Grading Date"));
                                  end;
                              end;
                        end;
                    }
                    field("Basic Pay";"Basic Pay")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field(HCL;HCL)
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("From Date";"Last Grading Date")
                    {
                        ApplicationArea=All;

                        trigger OnValidate();
                        begin
                            GradingScale.SETRANGE("Grade Code",Grade);
                            GradingScale.SETRANGE("Employee Category","Grade Category");
                            if GradingScale.FINDFIRST then
                              begin
                                EVALUATE(PeriodType,'1M');
                                if (GradingScale."Grade Interval Type" = PeriodType) and ("Last Grading Date" <> 0D) then
                                  "Next grading Date" := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>',"Last Grading Date");
                                EVALUATE(PeriodType,'1Y');
                                if (GradingScale."Grade Interval Type" = PeriodType) and ("Last Grading Date" <> 0D) then
                                  "Next grading Date" := CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'Y>',"Last Grading Date");
                              end;
                        end;
                    }
                    field("Till Date";"Next grading Date")
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field("Created By";"Created By")
                    {
                        Editable = false;
                        Visible = false;
                        ApplicationArea=All;
                    }
                    field("Created DateTime";"Created DateTime")
                    {
                        Editable = false;
                        Visible = false;
                        ApplicationArea=All;
                    }
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            //Caption = 'General';
            action("Auto Suggest Grades")
            {
                Image = SuggestCapacity;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                                                    ApplicationArea=All;

                trigger OnAction();
                begin
                    IsertGradeRec(true);
                end;
            }
            action("Update Grades")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea=All;

                trigger OnAction();
                var
                    Employee : Record Employee;
                    EmpAddInfo : Record "Employee Additional Info";
                begin
                    if Rec.FINDFIRST then
                      repeat
                        if (Rec."Last Grading Date" <= WORKDATE) and (WORKDATE >= Rec."Next grading Date") and (Rec."Previous Grade" <> Rec.Grade) then
                          begin
                            Employee.SETRANGE("No.",Rec."Employee No");
                            if Employee.FINDFIRST then
                              begin
                                Employee.SetAutoUpdateRateBoolean(true);
                                Employee.VALIDATE("Basic Pay",Rec."Basic Pay");
                                Employee.VALIDATE("Cost of Living Amount",Rec.HCL);
                                Employee.MODIFY;
                                EmpAddInfo.SETRANGE("Employee No.",Rec."Employee No");
                                if EmpAddInfo.FINDFIRST then
                                  begin
                                    EmpAddInfo.VALIDATE(Grade,Rec.Grade);
                                    EmpAddInfo.VALIDATE("Last Grading Date","Last Grading Date");
                                    EmpAddInfo.VALIDATE("Next Grading Date","Next grading Date");
                                    EmpAddInfo.MODIFY;
                                  end;
                              end;
                            Rec."Is Temp" := false;
                            Rec.MODIFY;
                          end;
                      until Rec.NEXT = 0;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        SETFILTER("Is Temp",'%1',true);

        if PayFunction.HideSalaryFields() then
          ERROR('You do not have permission');
    end;

    var
        EmpNo : Code[20];
        EmpCateg : Code[10];
        Dim1 : Code[10];
        Dim2 : Code[10];
        JobTitle : Code[50];
        JobCategory : Code[10];
        JobPosition : Code[10];
        EmpTbt : Record Employee;
        GradingHistory : Record "Employee Grading History";
        GradingScale : Record "Grading Scale";
        EmpAddInfo : Record "Employee Additional Info";
        PeriodType : DateFormula;
        GradingScale2 : Record "Grading Scale";
        PayFunction : Codeunit "Payroll Functions";

    procedure IsertGradeRec(IsSuggested : Boolean);
    var
        l_Empgradetbt : Record "Employee Grading History";
    begin
        if IsSuggested then
          begin
            EmpTbt.RESET;
            CLEAR(EmpTbt);
          end;

        EmpTbt.SETRANGE(Status,EmpTbt.Status::Active);
        if EmpTbt.FINDFIRST then
          repeat
            l_Empgradetbt.RESET;
            CLEAR(l_Empgradetbt);
            l_Empgradetbt.SETRANGE(l_Empgradetbt."Employee No",EmpTbt."No.");
            l_Empgradetbt.SETRANGE(l_Empgradetbt."Is Temp",true);
            l_Empgradetbt.DELETEALL;

            EmpAddInfo.RESET;
            CLEAR(EmpAddInfo);
            EmpAddInfo.SETRANGE("Employee No.",EmpTbt."No.");
            EmpAddInfo.SETFILTER(Grade,'<>%1','');
            EmpAddInfo.SETFILTER("Next Grading Date",'<=%1',WORKDATE);
            if EmpAddInfo.FINDFIRST then
              begin
                if (EmpAddInfo."Next Grading Date" <= WORKDATE) and (EmpAddInfo."Last Grading Date" <> 0D) and (EmpAddInfo."Next Grading Date" <> 0D) then
                  begin
                    GradingScale.RESET;
                    CLEAR(GradingScale);
                    GradingScale.SETRANGE("Employee Category",EmpTbt."Employee Category Code");
                    GradingScale.SETRANGE("Grade Code",EmpAddInfo.Grade);
                    if GradingScale.FINDFIRST then
                      begin
                        GradingHistory.INIT;
                        if GradingHistory.FINDLAST then
                          GradingHistory."Primery Key" += 1
                        else
                          GradingHistory."Primery Key" := 1;

                        GradingHistory."Employee No" := EmpTbt."No.";
                        GradingHistory."Previous Basic Pay" := EmpTbt."Basic Pay";
                        GradingHistory."Previous HCL" := EmpTbt."Cost of Living Amount";
                        GradingHistory."Previous Grade Category" := EmpTbt."Employee Category Code";
                        GradingHistory."Previous Grade" := EmpAddInfo.Grade;
                        GradingHistory."Previous Last Grading Date" := EmpAddInfo."Last Grading Date";
                        GradingHistory."Previous Next Grading Date" := EmpAddInfo."Next Grading Date";
                        GradingHistory."Grade Category" := EmpTbt."Employee Category Code";
                        GradingHistory."Created By" := USERID;
                        GradingHistory."Created DateTime" := CREATEDATETIME(WORKDATE,TIME);
                        GradingHistory."Is Temp" := true;
                        GradingHistory."Last Grading Date" := EmpAddInfo."Last Grading Date";
                        GradingHistory."Next grading Date" := EmpAddInfo."Next Grading Date";

                        GradingScale2.RESET;
                        CLEAR(GradingScale2);
                        GradingScale2.SETRANGE("Is Inactive",false);
                        GradingScale2.SETRANGE("Employee Category",EmpTbt."Employee Category Code");
                        GradingScale2.SETRANGE("Grade Sequence",GradingScale."Grade Sequence" + 1);
                        if GradingScale2.FINDFIRST then
                          begin
                            GradingHistory."Basic Pay" := GradingScale2."Grade Basic Salary";
                            GradingHistory.HCL := GradingScale2."Grade Cost of Living";
                            GradingHistory.Grade := GradingScale2."Grade Code";
                            EVALUATE(PeriodType,'1M');

                            if (GradingScale."Grade Interval Type" = PeriodType) and (EmpAddInfo."Last Grading Date" <> 0D) then
                              begin
                                GradingHistory."Last Grading Date" := EmpAddInfo."Next Grading Date";//CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'M>',EmpAddInfo."Last Grading Date");
                                GradingHistory."Next grading Date" := CALCDATE('<' + FORMAT(GradingScale2."Grade Update Interval") + 'M>',EmpAddInfo."Next Grading Date");
                              end;

                            EVALUATE(PeriodType,'1Y');
                            if (GradingScale."Grade Interval Type" = PeriodType) and (EmpAddInfo."Last Grading Date" <> 0D) then
                              begin
                                GradingHistory."Last Grading Date" := EmpAddInfo."Next Grading Date";//CALCDATE('<' + FORMAT(GradingScale."Grade Update Interval") + 'Y>',EmpAddInfo."Last Grading Date");
                                GradingHistory."Next grading Date" := CALCDATE('<' + FORMAT(GradingScale2."Grade Update Interval") + 'M>',EmpAddInfo."Next Grading Date");
                              end;
                          end
                        else
                          begin
                            GradingHistory."Basic Pay" := GradingScale."Grade Basic Salary";
                            GradingHistory.HCL := GradingScale."Grade Cost of Living";
                            GradingHistory.Grade := GradingScale."Grade Code";
                          end;
                        GradingHistory.INSERT;
                      end;
                  end;
              end;
          until EmpTbt.NEXT = 0;
    end;

    local procedure DeleteGradeRec();
    var
        GradeHistory : Record "Employee Grading History";
    begin
        GradeHistory.SETRANGE("Is Temp",true);
        if GradeHistory.FINDFIRST then
          GradeHistory.DELETEALL;
    end;

    local procedure SetFilters();
    begin
        Rec.SETFILTER("Employee No",EmpNo);
        Rec.SETFILTER("Grade Category",EmpCateg);
        Rec.SETFILTER("Global Dimension 1",Dim1);
        Rec.SETFILTER("Global Dimension 2",Dim2);
        Rec.SETFILTER("Job Category",JobCategory);
        Rec.SETFILTER("Job Position code",JobPosition);
        Rec.SETFILTER("Job Title",JobTitle);
        //Rec.SETFILTER(Rec."Last Grading Date",'<=%1',WORKDATE);
        //Rec.SETFILTER(Rec."Next grading Date",'>=%1',WORKDATE);
        Rec.SETFILTER(Rec."Previous Next Grading Date",'<=%1',WORKDATE);
    end;
}

