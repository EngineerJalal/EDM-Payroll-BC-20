page 98087 "Salary Raise Request"
{
    SourceTable = "Employee Salary History";

    layout
    {
        area(content)
        {
            group("New Salary")
            {
                field("Request ID";"Request ID")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Employee No.";"Employee No.")
                {
                    Editable = EnableEmployeeField;
                    Enabled = EnableEmployeeField;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        EmployeeRelatedToExist := CheckIfRelatedToNotExist("Employee No.");
                        //Add in order to disable edit Employee name if Change Status is't "Not Started" - 16.12.2016 A2+
                        if "Change Status" <> "Change Status"::"Not Started" then
                            ERROR('');
                        //Add in order to disable edit Employee name if Change Status is't "Not Started" - 16.12.2016 A2-

                        CurrentSalary := "Basic Previous" + "Phone Previous" + "Car Previous" + "House Previous" + "Food Previous" + "Ticket Previous" + "Other Previous" + "Extra Salary Previous";//20181221:A2+-
                        RelatedSalary := "Basic Pay Rel Previous" + "Phone Rel Previous" + "Car Rel Previous" + "House Rel Previous" + "Food Rel Previous" + "Ticket Rel Previous" + "Other Rel Previous" + "Extra Salary Rel Previous";//20181221:A2+-
                        TotalCurrentSalary := CurrentSalary + RelatedSalary;

                        if "Amount In USD" then begin
                            "Basic Previous" := ExchEquivAmountInACY("Basic Previous");
                            "Phone Previous" := ExchEquivAmountInACY("Phone Previous");
                            "Car Previous" := ExchEquivAmountInACY("Car Previous");
                            "House Previous" := ExchEquivAmountInACY( "House Previous");
                            "Ticket Previous" := ExchEquivAmountInACY( "Ticket Previous");
                            "Food Previous" := ExchEquivAmountInACY("Food Previous");
                            "Other Previous" := ExchEquivAmountInACY("Other Previous");
                            "Extra Salary Previous" := ExchEquivAmountInACY("Extra Salary Previous");//20181221:A2+-

                            "Basic Pay" := ExchEquivAmountInACY("Basic Pay");
                            "Phone Allowance" := ExchEquivAmountInACY("Phone Allowance");
                            "Car Allowance" := ExchEquivAmountInACY("Car Allowance");
                            "House Allowance" := ExchEquivAmountInACY("House Allowance");
                            "Ticket Allowance" := ExchEquivAmountInACY("Ticket Allowance");
                            "Food Allowance" := ExchEquivAmountInACY("Food Allowance");
                            "Other Allowance" := ExchEquivAmountInACY("Other Allowance");
                            "Extra Salary" := ExchEquivAmountInACY("Extra Salary");//20181221:A2+-

                            "Basic Pay Rel" := ExchEquivAmountInACY("Basic Pay Rel");
                            "Phone Rel" := ExchEquivAmountInACY("Phone Rel");
                            "Car Rel" := ExchEquivAmountInACY("Car Rel");
                            "House Rel" := ExchEquivAmountInACY("House Rel");
                            "Ticket Rel" := ExchEquivAmountInACY("Ticket Rel");
                            "Food Rel" := ExchEquivAmountInACY("Food Rel");
                            "Other Rel" := ExchEquivAmountInACY("Other Rel");
                            "Extra Salary Related" := ExchEquivAmountInACY("Extra Salary Related");//20181221:A2+-

                            "Basic Pay Rel Previous" := ExchEquivAmountInACY("Basic Pay Rel Previous");
                            "Phone Rel Previous" := ExchEquivAmountInACY("Phone Rel Previous");
                            "Car Rel Previous" := ExchEquivAmountInACY("Car Rel Previous");
                            "House Rel Previous" := ExchEquivAmountInACY("House Rel Previous");
                            "Food Rel Previous" := ExchEquivAmountInACY("Food Rel Previous");
                            "Ticket Rel Previous" := ExchEquivAmountInACY("Ticket Rel Previous");
                            "Other Rel Previous" := ExchEquivAmountInACY("Other Rel Previous");
                            "Extra Salary Rel Previous" := ExchEquivAmountInACY("Extra Salary Rel Previous");//20181221:A2+-

                            CurrentSalary := ExchEquivAmountInACY(CurrentSalary);
                            RelatedSalary := ExchEquivAmountInACY(RelatedSalary);
                            Total := ExchEquivAmountInACY(Total);
                            TotalCurrentSalary := ExchEquivAmountInACY(TotalCurrentSalary);
                            "TotalPay&Allow" := ExchEquivAmountInACY("TotalPay&Allow");
                            TotalRelatedBasicAndAllowances := ExchEquivAmountInACY(TotalRelatedBasicAndAllowances);
                        end;
                        RefreshTotalAllowances();
                    end;
                }
                field("Employee Name";"Employee Name")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Modified Date";"Modified Date")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Modified Time";"Modified Time")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Modified By";"Modified By")
                {
                    Editable = IsEditable;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Salary Start Date";"Salary Start Date")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field("Source Type";"Source Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Use Hourly Rate";"Hourly Rate Or Not")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        // Added in order to show hourly rate in salary raise request - 08.03.2017 : A2+
                        if not "Hourly Rate Or Not" then
                          IsHourlyRateEditible := false
                        else begin
                            IsHourlyRateEditible := IsEditable;
                            "Basic Pay" := 0;
                            "Hourly Rate" := 0;
                        end;
                        //basic pay editable based on two conditions,if request approved then based on hourlyrate - 06.06.2017 : SC+
                        if IsEditable then
                          IsEditableBasicPay := not IsHourlyRateEditible
                        else
                          IsEditableBasicPay := false;
                        //basic pay editable based on two conditions,if request approved then based on hourlyrate - 06.06.2017 : SC-

                        // Added in order to show hourly rate in salary raise request - 08.03.2017 : A2-
                    end;
                }
                field("Hourly Rate";"Hourly Rate")
                {
                    Editable = IsHourlyRateEditible;
                    ApplicationArea=All;
                }
                field("Basic Pay";"Basic Pay")
                {
                    Editable = IsEditableBasicPay;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Phone Allowance";"Phone Allowance")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Car Allowance";"Car Allowance")
                {
                    Caption = 'Car Allowance';
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("House Allowance";"House Allowance")
                {
                    Caption = 'House Allowance';
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Food Allowance";"Food Allowance")
                {
                    Caption = 'Food Allowance';
                    Editable = IsEditable;
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Ticket Allowance";"Ticket Allowance")
                {
                    Caption = 'Ticket Allowance';
                    Editable = IsEditable;
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Other Allowance";"Other Allowance")
                {
                    Caption = 'Other Allowance';
                    Editable = IsEditable;
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Extra Salary";"Extra Salary")//20181221:A2+-
                {
                    Caption = 'Extra Salary';
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Bonus System";"Bonus System")
                {
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field(Comments;"Request Description")
                {
                    Caption = 'Comments';
                    Editable = IsEditable;
                    ApplicationArea=All;
                }
                field("TotalPay&Allow";"TotalPay&Allow")
                {
                    Caption = 'Total Basic + Allowances';
                    Editable = false;
                    ApplicationArea=All;
                }
                group(Control48)
                {
                    Visible = EmployeeRelatedToExist;
                    field("Total related Basic + Allowances";TotalRelatedBasicAndAllowances)
                    {
                        Caption = 'Total Related Basic + Allowances';
                        Editable = false;
                        ApplicationArea=All;
                    }
                    field(Total;Total)
                    {
                        Editable = false;
                        ApplicationArea=All;
                    }
                }
                field("Insurence Contribution";"Insurence Contribution")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Request Status";"Change Status")
                {
                    Caption = 'Request Status';
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        if ("Change Status" = "Change Status"::"Not Started") and (not ApprovalsMgmt.HasOpenApprovalEntries(RECORDID)) then
                            IsSalaryRaiseSendRequest :=  true;
                    end;
                }
                field("Type of Salary";GetSalaryRaiseReqyestStatus())
                {
                    Editable = false;
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Requested By";"Requested By")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea=All;
                }
                field("Requested Date";"Requested Date")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea=All;
                }
                field("Request Attachment";"Request Attachment")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Approved By";"Approved By")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea=All;
                }
                field("Approved Date";"Approved Date")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Approval Comments";"Approval Comments")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Amount In USD";"Amount In USD")
                {
                    ApplicationArea=All;

                    trigger OnValidate();
                    var
                        RequestRecordID : RecordID;
                    begin
                        if not CONFIRM('Do you want to exchange amount?',false) then
                            ERROR('');

                        if "Amount In USD" then
                            begin
                            "Basic Previous" := ExchEquivAmountInACY("Basic Previous");
                            "Phone Previous" := ExchEquivAmountInACY("Phone Previous");
                            "Car Previous" := ExchEquivAmountInACY("Car Previous");
                            "House Previous" := ExchEquivAmountInACY( "House Previous");
                            "Ticket Previous" := ExchEquivAmountInACY( "Ticket Previous");
                            "Food Previous" := ExchEquivAmountInACY("Food Previous");
                            "Other Previous" := ExchEquivAmountInACY("Other Previous");
                            "Extra Salary Previous" := ExchEquivAmountInACY("Extra Salary Previous");//20181221:A2+-

                            "Basic Pay" := ExchEquivAmountInACY("Basic Pay");
                            "Phone Allowance" := ExchEquivAmountInACY("Phone Allowance");
                            "Car Allowance" := ExchEquivAmountInACY("Car Allowance");
                            "House Allowance" := ExchEquivAmountInACY("House Allowance");
                            "Ticket Allowance" := ExchEquivAmountInACY("Ticket Allowance");
                            "Food Allowance" := ExchEquivAmountInACY("Food Allowance");
                            "Other Allowance" := ExchEquivAmountInACY("Other Allowance");
                            "Extra Salary" := ExchEquivAmountInACY("Extra Salary");//20181221:A2+-

                            "Basic Pay Rel" := ExchEquivAmountInACY("Basic Pay Rel");
                            "Phone Rel" := ExchEquivAmountInACY("Phone Rel");
                            "Car Rel" := ExchEquivAmountInACY("Car Rel");
                            "House Rel" := ExchEquivAmountInACY("House Rel");
                            "Ticket Rel" := ExchEquivAmountInACY("Ticket Rel");
                            "Food Rel" := ExchEquivAmountInACY( "Food Rel");
                            "Other Rel" := ExchEquivAmountInACY("Other Rel");
                            "Extra Salary Related" := ExchEquivAmountInACY("Extra Salary Related");//20181221:A2+-

                            "Basic Pay Rel Previous" := ExchEquivAmountInACY("Basic Pay Rel Previous");
                            "Phone Rel Previous" := ExchEquivAmountInACY("Phone Rel Previous");
                            "Car Rel Previous" := ExchEquivAmountInACY("Car Rel Previous");
                            "House Rel Previous" := ExchEquivAmountInACY("House Rel Previous");
                            "Food Rel Previous" := ExchEquivAmountInACY("Food Rel Previous");
                            "Ticket Rel Previous" := ExchEquivAmountInACY("Ticket Rel Previous");
                            "Other Rel Previous" := ExchEquivAmountInACY("Other Rel Previous");
                            "Extra Salary Rel Previous" := ExchEquivAmountInACY("Extra Salary Rel Previous");//20181221:A2+-

                            CurrentSalary := ExchEquivAmountInACY(CurrentSalary);
                            RelatedSalary := ExchEquivAmountInACY(RelatedSalary);
                            Total := ExchEquivAmountInACY(Total);
                            TotalCurrentSalary := ExchEquivAmountInACY(TotalCurrentSalary);
                            "TotalPay&Allow" := ExchEquivAmountInACY("TotalPay&Allow");
                            TotalRelatedBasicAndAllowances := ExchEquivAmountInACY(TotalRelatedBasicAndAllowances);
                            end else begin
                                "Basic Previous" := ExchEquivAmountInLCY("Basic Previous");
                                "Phone Previous" := ExchEquivAmountInLCY("Phone Previous");
                                "Car Previous" := ExchEquivAmountInLCY("Car Previous");
                                "House Previous" := ExchEquivAmountInLCY("House Previous");
                                "Ticket Previous" := ExchEquivAmountInLCY("Ticket Previous");
                                "Food Previous" := ExchEquivAmountInLCY("Food Previous");
                                "Other Previous" := ExchEquivAmountInLCY("Other Previous");
                                "Extra Salary Previous" := ExchEquivAmountInLCY("Extra Salary Previous");//20181221:A2+-

                                "Basic Pay" := ExchEquivAmountInLCY("Basic Pay");
                                "Phone Allowance" := ExchEquivAmountInLCY("Phone Allowance");
                                "Car Allowance" := ExchEquivAmountInLCY("Car Allowance");
                                "House Allowance" := ExchEquivAmountInLCY("House Allowance");
                                "Ticket Allowance" := ExchEquivAmountInLCY("Ticket Allowance");
                                "Food Allowance" := ExchEquivAmountInLCY("Food Allowance");
                                "Other Allowance" := ExchEquivAmountInLCY("Other Allowance");
                                "Extra Salary" := ExchEquivAmountInLCY("Extra Salary");//20181221:A2+-

                                "Basic Pay Rel" := ExchEquivAmountInLCY("Basic Pay Rel");
                                "Phone Rel" := ExchEquivAmountInLCY("Phone Rel");
                                "Car Rel" := ExchEquivAmountInLCY("Car Rel");
                                "House Rel" := ExchEquivAmountInLCY("House Rel");
                                "Ticket Rel" := ExchEquivAmountInLCY("Ticket Rel");
                                "Food Rel" := ExchEquivAmountInLCY("Food Rel");
                                "Other Rel" := ExchEquivAmountInLCY("Other Rel");
                                "Extra Salary Related" := ExchEquivAmountInLCY("Extra Salary Related");//20181221:A2+-

                                "Basic Pay Rel Previous" := ExchEquivAmountInLCY("Basic Pay Rel Previous");
                                "Phone Rel Previous" := ExchEquivAmountInLCY("Phone Rel Previous");
                                "Car Rel Previous" := ExchEquivAmountInLCY("Car Rel Previous");
                                "House Rel Previous" := ExchEquivAmountInLCY("House Rel Previous");
                                "Food Rel Previous" := ExchEquivAmountInLCY("Food Rel Previous");
                                "Ticket Rel Previous" := ExchEquivAmountInLCY("Ticket Rel Previous");
                                "Other Rel Previous" := ExchEquivAmountInLCY("Other Rel Previous");
                                "Extra Salary Rel Previous" := ExchEquivAmountInLCY("Extra Salary Rel Previous");//20181221:A2+-

                                CurrentSalary := ExchEquivAmountInLCY(CurrentSalary);
                                RelatedSalary := ExchEquivAmountInLCY(RelatedSalary);
                                Total := ExchEquivAmountInLCY(Total);
                                TotalCurrentSalary := ExchEquivAmountInLCY(TotalCurrentSalary);
                                "TotalPay&Allow" := ExchEquivAmountInLCY("TotalPay&Allow");
                                TotalRelatedBasicAndAllowances := ExchEquivAmountInLCY(TotalRelatedBasicAndAllowances);
                            end;
                        RefreshTotalAllowances;
                    end;
                }
                field(GetLastComment;GetLastComment)
                {
                    Caption = 'Approval Comment';
                    ApplicationArea=All;
                }
                field(Processed;Processed)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
            group("New Related Salaries")
            {
                Visible = EmployeeRelatedToExist;
                field("Basic Pay ";"Basic Pay Rel")
                {
                    Caption = 'Related Basic Pay';
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Phone ";"Phone Rel")
                {
                    Caption = 'Related Phone';
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Car ";"Car Rel")
                {
                    Caption = 'Related Car';
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("House ";"House Rel")
                {
                    Caption = 'Related House';
                    Editable = IsEditable;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Food ";"Food Rel")
                {
                    Caption = 'Related Food';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Ticket ";"Ticket Rel")
                {
                    Caption = 'Related Ticket';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Other ";"Other Rel")
                {
                    Caption = 'Related Other';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }
                field("Extra Salary ";"Extra Salary Related")
                {
                    Caption = 'Related Extra Salary';
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnValidate();
                    begin
                        RefreshTotalAllowances;
                    end;
                }                
            }
            group("Current Total Salaries")
            {
                Visible = EmployeeRelatedToExist;
                field("Current Salary";CurrentSalary)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Current Related Salary";RelatedSalary)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Current Total Salary";TotalCurrentSalary)
                {
                    Editable = false;
                    ApplicationArea=All;
                }
            }
            group("Current Salaries")
            {
                Editable = false;
                field("Basic Pay.";"Basic Previous")
                {
                    Caption = 'Current Basic Pay';
                    ApplicationArea=All;
                }
                field("Phone.";"Phone Previous")
                {
                    Caption = 'Current Phone';
                    ApplicationArea=All;
                }
                field("Car.";"Car Previous")
                {
                    Caption = 'Current Car';
                    ApplicationArea=All;
                }
                field("House.";"House Previous")
                {
                    Caption = 'Current House';
                    ApplicationArea=All;
                }
                field("Food.";"Food Previous")
                {
                    Caption = 'Current Food';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Ticket.";"Ticket Previous")
                {
                    Caption = 'Current Ticket';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Other.";"Other Previous")
                {
                    Caption = 'Current Other';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Extra Salary Previous.";"Extra Salary Previous")//20181221:A2+-
                {
                    Caption = 'Current Extra Salary';
                    ApplicationArea=All;
                }               
                field("Total.";"Total Previous")
                {
                    Caption = 'Current Total Basic + Allowances';
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Bonus System.";"Bonus System Previous")
                {
                    Caption = 'Current Bonus System';
                    Enabled = false;
                    ApplicationArea=All;
                }
                field("Insurence.";"Insurence Previous")
                {
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Current Status.";Status)
                {
                    ApplicationArea=All;
                }
            }
            group("Current Related Salaries")
            {
                Editable = false;
                Visible = EmployeeRelatedToExist;
                field("Basic Pay Rel.";"Basic Pay Rel Previous")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Phone Rel.";"Phone Rel Previous")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Car Rel.";"Car Rel Previous")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("House Rel.";"House Rel Previous")
                {
                    Editable = false;
                    ApplicationArea=All;
                }
                field("Food Rel.";"Food Rel Previous")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Ticket Rel.";"Ticket Rel Previous")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Other Rel.";"Other Rel Previous")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea=All;
                }
                field("Extra Salary Rel Previous.";"Extra Salary Rel Previous")
                {
                    Editable = false;
                    ApplicationArea=All;
                }                
                field("Current Related Status ";StatusUndeclared)
                {
                    ApplicationArea=All;
                }
                field("Related Employee No.";RelatedEmployeeNo)
                {
                    ApplicationArea=All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control76;Notes)
            {
                ApplicationArea=All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action2>")
            {
                Caption = 'Salary Raise Request';
                action(SendSalaryApproval)
                {
                    Caption = 'Request Salary Approval';
                    Enabled = IsSalaryRaiseSendRequest;
                    Image = SendApprovalRequest;
                    Visible = IsApprovalSystemVisible;
                    ApplicationArea=All;

                    trigger OnAction();
                    var
                        EmployeeAddInfo : Record "Employee Additional Info";
                        NewBasicPay : Decimal;
                        IsConfirm : Boolean;
                    begin
                        IsCurrentlyApproved := true;
                        if PayrollFunctions.CheckSalaryRaiseApprovalsWorkflowEnabled(Rec) then
                            PayrollFunctions.OnSendSalaryRaiseForApproval(Rec);
                        CurrPage.CLOSE;
                    end;
                }
                action(RejectSalaryApproval)
                {
                    Caption = 'Reject Salary Approval';
                    Enabled = IsSalaryRaiseCancelRequest;
                    Image = Cancel;
                    Visible = false;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        // Add in order to not to show the message "Modified Not Allowed" - 05.05.2017 : A2+
                        IsCurrentlyRejected := true;
                        // Add in order to not to show the message "Modified Not Allowed" - 05.05.2017 : A2-
                        PayrollFunctions.OnCancelSalaryRaiseApprovalRequest(Rec);
                        CurrPage.CLOSE;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelLine;
                    Visible = IsApprovalSystemVisible;
                    ApplicationArea=All;

                    trigger OnAction();
                    begin
                        if PayrollFunctions.IsSalaryRaiseRequestApproved(RECORDID) then
                            ERROR ('Request cannot be canceled because it was previously approved.');

                        if PayrollFunctions.IsSalaryRaiseRequestRejected(RECORDID) then
                            ERROR ('Request cannot be Canceled because it was previously rejected.');

                        if PayrollFunctions.CancelSalaryRaiseRequest(RECORDID) then
                            Rec."Change Status" := Rec."Change Status"::"Not Started";
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        IsSalaryRaiseSendRequest := ("Change Status" = "Change Status"::"Not Started") and (not ApprovalsMgmt.HasOpenApprovalEntries(RECORDID));
        IsSalaryRaiseCancelRequest := ("Change Status" = "Change Status"::Pending ) and (ApprovalsMgmt.HasOpenApprovalEntries(RECORDID));
        RefreshTotalAllowances;
    end;

    trigger OnAfterGetRecord();
    begin
        EmployeeRelatedToExist := CheckIfRelatedToNotExist("Employee No.");
    end;

    trigger OnDeleteRecord() : Boolean;
    begin
        //Added as a validation on the cases where the user can delete the record - 28.02.2017 : AIM +
        if "Change Status" <> "Change Status"::"Not Started" then
            ERROR('Record deletion is not allowed!');
        //Added as a validation on the cases where the user can delete the record - 28.02.2017 : AIM -
    end;

    trigger OnInit();
    begin
        UserRelatedEmpNo := PayrollFunctions.GetUserRelatedEmployeeNo(USERID);
        FILTERGROUP(2);
        if UserRelatedEmpNo <> '' then
            SETFILTER("Employee No.",UserRelatedEmpNo);
        SETFILTER("Source Type",'=%1',"Source Type"::"Raise Request");
        FILTERGROUP(0);


        if UserRelatedEmpNo <> '' then
            EnableEmployeeField := false
        else
            EnableEmployeeField := true;
        IsCurrentlyApproved := false;
    end;

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    begin
        //Added in order to prevent entering a record without employee no - 24.03.2017 : AIM +
        if Rec."Employee No." = '' then
            TESTFIELD("Employee No.");
        //Added in order to prevent entering a record without employee no - 24.03.2017 : AIM -

        EmpTbt.SETRANGE("Related to","Employee No.");
        EmpTbt.SETFILTER(EmpTbt."No.",'<>%1',"Employee No.");
        if EmpTbt.FINDFIRST then begin
            StatusUndeclared := EmpTbt.Declared;
            RelatedEmployeeNo := EmpTbt."No.";
            EmpAddInfo.SETRANGE("Employee No.","Employee No.");
            if EmpAddInfo.FINDFIRST then
                "Bonus System Previous" := EmpAddInfo."Bonus System";
        end;

        EmpTbt.SETRANGE("No.","Employee No.");
        if EmpTbt.FINDFIRST then
            Status := EmpTbt.Declared;
    end;

    trigger OnModifyRecord() : Boolean;
    begin
        // Add in order to not to show the message "Modified Not Allowed" - 05.05.2017 : A2+
        if (not IsCurrentlyApproved) and (not IsCurrentlyRejected) then begin
        // Add in order to not to show the message "Modified Not Allowed" - 05.05.2017 : A2-
            if (PayrollFunctions.IsSalaryRaiseRequestApproved(RECORDID)) or (PayrollFunctions.IsSalaryRaiseRequestRejected(RECORDID)) then
                ERROR('Modify not allowed!');
            if (Rec."Change Status" <> "Change Status"::"Not Started")  then
                ERROR('Modify not allowed!');
        end else
            IsCurrentlyApproved := false;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        "Change Status" := "Change Status"::"Not Started";
        "Source Type" := "Source Type"::"Raise Request";
        IsSalaryRaiseSendRequest := true;

        "Change Status" := "Change Status"::"Not Started";
        "Source Type" := "Source Type"::"Raise Request";
        "Requested By" := USERID;
        "Requested Date" := WORKDATE;
        "Modified Date" := WORKDATE;
        "Modified By" := USERID;

        if "Salary Start Date" = 0D then
            "Salary Start Date" := DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
        if UserRelatedEmpNo  <> '' then
            VALIDATE("Employee No.",UserRelatedEmpNo );
        EmployeeRelatedToExist := CheckIfRelatedToNotExist("Employee No.");
        RefreshTotalAllowances;
    end;

    trigger OnNextRecord(Steps : Integer) : Integer;
    begin
        exit;
    end;

    trigger OnOpenPage();
    begin
        //edm actions visible if approval system is on 2017-07-03 : sc+
        if PayrollFunctions.CheckSalaryRaiseApprovalSystem then begin
            IsApprovalSystemVisible := true;
            IsApprovalSystemVisible := true;
        end else begin
            IsApprovalSystemVisible := false;
            IsApprovalSystemVisible := false;
        end;
        //edm actions visible if approval system is on 2017-07-03 : sc-

        //disable fields if status is approved - 06.06.2017 : SC+
        if ("Change Status" <> "Change Status"::Approved) or (("Basic Pay" = 0) and ("Hourly Rate" = 0))  then
            IsEditable := true;
        IsEditableBasicPay := IsEditable;
        //disable fields if status is approved - 06.06.2017 : SC-
        // Added in order to set permission on open record - 25.05.2017 : A2+
        if PayrollFunctions.HideSalaryFields() then
            ERROR('No Permission!');
        // Added in order to set permission on open record - 25.05.2017 : A2-
        RefreshTotalAllowances;
        if "Change Status" = "Change Status"::"Not Started" then
            IsSalaryRaiseSendRequest := true;
    end;

    trigger OnQueryClosePage(CloseAction : Action) : Boolean;
    begin
        if "Employee No." <> '' then begin
            TESTFIELD("Salary Start Date");
            TESTFIELD("Basic Pay");
        end;
        exit(true);
    end;

    var
        IsSalaryRaiseSendRequest : Boolean;
        IsSalaryRaiseCancelRequest : Boolean;
        EmpTbt : Record Employee;
        EmpAddInfo : Record "Employee Additional Info";
        UserRelatedEmpNo : Code[20];
        PayrollFunctions : Codeunit "Payroll Functions";
        Status : Option " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        StatusUndeclared : Option " ",Declared,"Non-Declared",Contractual,"Non-NSSF";
        CurrentSalary : Decimal;
        RelatedSalary : Decimal;
        TotalCurrentSalary : Decimal;
        TotalRelatedBasicAndAllowances : Decimal;
        Total : Decimal;
        RelatedEmployeeNo : Code[20];
        EmployeeRelatedToExist : Boolean;
        EnableEmployeeField : Boolean;
        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
        HRSetupTbt : Record "Human Resources Setup";
        IsHourlyRateEditible : Boolean;
        IsCurrentlyApproved : Boolean;
        IsCurrentlyRejected : Boolean;
        IsEditable : Boolean;
        IsEditableBasicPay : Boolean;
        IsApprovalSystemVisible : Boolean;

    local procedure RefreshTotalAllowances();
    begin
        "TotalPay&Allow" := "Basic Pay" + "Car Allowance" + "Phone Allowance" + "House Allowance" + "Ticket Allowance" + "Other Allowance" + "Food Allowance";
        TotalRelatedBasicAndAllowances := "Basic Pay Rel" + "Car Rel" + "Phone Rel" + "House Rel" + "Ticket Rel" +"Other Rel" + "Food Rel";
        Total := "TotalPay&Allow" + TotalRelatedBasicAndAllowances
    end;

    local procedure CheckIfRelatedToNotExist("EmployeeNo." : Code[20]) Exist : Boolean;
    var
        EmployeeTbt : Record Employee;
    begin
        Exist := false;
        EmployeeTbt.SETRANGE("Related to","Employee No.");
        EmployeeTbt.SETFILTER(EmployeeTbt."No.",'<>%1',"Employee No.");
        if EmployeeTbt.FINDFIRST then
          Exist := true
    end;

    local procedure ExchEquivAmountInACY(L_AmoountInLCY : Decimal) L_AmouontInACY : Decimal;
    begin
        L_AmouontInACY := PayrollFunctions.ExchangeLCYAmountToACY(L_AmoountInLCY);
        exit(L_AmouontInACY);
    end;

    local procedure ExchEquivAmountInLCY(L_AmoountInACY : Decimal) L_AmouontInACY : Decimal;
    begin
        L_AmouontInACY := PayrollFunctions.ExchangeACYAmountToLCY(L_AmoountInACY);
        exit(L_AmouontInACY);
    end;
}

