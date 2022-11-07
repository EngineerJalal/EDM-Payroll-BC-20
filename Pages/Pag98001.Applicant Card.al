page 98001 "Applicant Card"
{
    // version EDM.HRPY1

    PageType = Card;
    SourceTable = Applicant;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("First Name";Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name";Rec."Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name";Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field("Search Name";Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("Mother Name";Rec."Mother Name")
                {
                    ApplicationArea = All;
                }
                field(Initials;Rec.Initials)
                {
                    ApplicationArea = All;
                }
                field("Birth Date";Rec."Birth Date")
                {
                    ApplicationArea = All;
                }
                field(Sex;Rec.Sex)
                {
                    ApplicationArea = All;
                }
                field(AppAge;Rec.ApplicantAge())
                {
                    Caption = 'Age';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                field("Mobile Phone No.";Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Phone No.";Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail";Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Country Code";Rec."Country Code")
                {
                    ApplicationArea = All;
                }
                field(City;Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Address;Rec.Address)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            group(Administration)
            {
                field("Application Date";Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field("Physical File No.";Rec."Physical File No.")
                {
                    Caption = 'Application Ref. Code';
                    ApplicationArea = All;
                }
                field("Available From";Rec."Available From")
                {
                    ApplicationArea = All;
                }
                field("Notice Period";Rec."Notice Period")
                {
                    ApplicationArea = All;
                }
                field("Preferred Work Schedule";Rec."Preferred Work Schedule")
                {
                    ApplicationArea = All;
                }
                field("Requested Salary";Rec."Requested Salary")
                {
                    ApplicationArea = All;
                }
                field("Requested Salary Currency Code";Rec."Requested Salary Currency Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Applied For";Rec."Applied For")
                {
                    ApplicationArea = All;
                }
                field("Application Status";Rec."Application Status")
                {
                    ApplicationArea = All;
                }
                field("Experienced Years";Rec."Experienced Years")
                {
                    ApplicationArea = All;
                }
                field("Application Phase";Rec."Application Phase")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified";Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                }
            }
            group(Personal)
            {
                field("Religion Code";Rec."Religion Code")
                {
                    ApplicationArea = All;
                }
                field("Social Status";Rec."Social Status")
                {
                    ApplicationArea = All;
                }
                field("No of Children";Rec."No of Children")
                {
                    ApplicationArea = All;
                }
                field("Military Status";Rec."Military Status")
                {
                    ApplicationArea = All;
                }
                field("First Nationality Code";Rec."First Nationality Code")
                {
                    ApplicationArea = All;
                }
                field("Second Nationality Code";Rec."Second Nationality Code")
                {
                    ApplicationArea = All;
                }
                field("Government ID No";Rec."Government ID No")
                {
                    ApplicationArea = All;
                }
                field("Place of Birth";Rec."Place of Birth")
                {
                    ApplicationArea = All;
                }
            }
            group(Health)
            {
                field("Health Card No";Rec."Health Card No")
                {
                    ApplicationArea = All;
                }
                field("Health Card Issue Place";Rec."Health Card Issue Place")
                {
                    ApplicationArea = All;
                }
                field("Health Card Issue Date";Rec."Health Card Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Health Card Expiry Date";Rec."Health Card Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Chronic Disease";Rec."Chronic Disease")
                {
                    ApplicationArea = All;
                }
                field("Chronic Disease Details";Rec."Chronic Disease Details")
                {
                    ApplicationArea = All;
                }
                field("Other Health Information";Rec."Other Health Information")
                {
                    ApplicationArea = All;
                }
                field("Blood Type";Rec."Blood Type")
                {
                    ApplicationArea = All;
                }
            }
            group(Passport)
            {
                field("Passport No.";Rec."Passport No.")
                {
                    ApplicationArea = All;
                }
                field("Passport Issue Place";Rec."Passport Issue Place")
                {
                    ApplicationArea = All;
                }
                field("Passport Issue Date";Rec."Passport Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Passport Expiry Date";Rec."Passport Expiry Date")
                {
                    ApplicationArea = All;
                }
                field(IsForeigner;Rec.IsForeigner)
                {
                    ApplicationArea = All;
                }
                field("Work Permit No.";Rec."Work Permit No.")
                {
                    ApplicationArea = All;
                }
                field("Work Permit Expiry Date";Rec."Work Permit Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Resident No.";Rec."Resident No.")
                {
                    ApplicationArea = All;
                }
                field("Resident Issue Place";Rec."Resident Issue Place")
                {
                    ApplicationArea = All;
                }
                field("Resident Issue Date";Rec."Resident Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Resident Expiry Date";Rec."Resident Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Work Permit Issue Date";Rec."Work Permit Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Work Permit Issue Place";Rec."Work Permit Issue Place")
                {
                    ApplicationArea = All;
                }
            }
            group(Finance)
            {
                field(Status;Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Hired Date";Rec."Hired Date")
                {
                    ApplicationArea = All;
                }
                field("Agreed Salary";Rec."Agreed Salary")
                {
                    ApplicationArea = All;
                }
                field("Agreed Salary Currency Code";Rec."Agreed Salary Currency Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Category";Rec."Job Category")
                {
                    ApplicationArea = All;
                }
                field("Job Title";Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Job Position Code";Rec."Job Position Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employment Type Code";Rec."Employment Type Code")
                {
                    ApplicationArea = All;
                }
                field("Employee Category Code";Rec."Employee Category Code")
                {
                    ApplicationArea = All;
                }
                field("Payroll Group Code";Rec."Payroll Group Code")
                {
                    ApplicationArea = All;
                }
                field(Locations;Rec.Locations)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Personal Finance No.";Rec."Personal Finance No.")
                {
                    ApplicationArea = All;
                }
                field("Social Security No.";Rec."Social Security No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Other)
            {
                field(Weight;Rec.Weight)
                {
                    ApplicationArea = All;
                }
                field(Length;Rec.Length)
                {
                    Caption = 'Height';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            Description = 'Related Info';
            action("&Card")
            {
                CaptionML = ENU = '&Card',
                            ENG = '&Card';
                Image = EditLines;
                RunObject = Page "Applicant Card";
                RunPageLink = "No." = FIELD("No.");
                ShortCutKey = 'Shift+F7';
                Visible = false;
                ApplicationArea = All;
            }
            action("&Relatives")
            {
                Caption = '&Relatives';
                Image = Relatives;
                RunObject = Page "Applicant Relatives";
                RunPageLink = "Applicant No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("HR &Confidential Comments")
            {
                Caption = 'HR &Confidential Comments';
                Image = ConfidentialOverview;
                RunObject = Page "HR Confidential Comments";
                RunPageLink = "Applicant No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("&Picture")
            {
                Caption = '&Picture';
                Image = Picture;
                RunObject = Page "Applicant Picture";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("&Academic History")
            {
                Caption = '&Academic History';
                Image = History;
                RunObject = Page "Academic History";
                RunPageLink = "Table Name" = CONST(Applicant), "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("&Employment History")
            {
                Caption = '&Employment History';
                Image = History;
                RunObject = Page "Employment History";
                RunPageLink = "No." = FIELD("No."), "Table Name" = CONST(Applicant);
                ApplicationArea = All;
            }
            action("Language &Skills")
            {
                Caption = 'Language &Skills';
                Image = Language;
                RunObject = Page "Language Skills";
                RunPageLink = "Table Name" = CONST(Applicant), "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action(Comments)
            {
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = Page "HR Comment Sheet EDM";
                RunPageLink = "Table Name" = CONST(Applicant), "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("&Interviews")
            {
                Caption = '&Interviews';
                RunObject = Page "Human Resource Interview Sheet";
                RunPageLink = "Table Name" = CONST(Applicant), "No." = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
            action(Interviews)
            {
                Image = Notes;
                RunObject = Page "Human Resource Interview Sheet";
                RunPageLink = "Table Name" = CONST(Applicant), "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action(Hire)
            {
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Requested Documents")
            {
                Caption = 'Requested Documents';
                RunObject = Page "Requested Documents";
                RunPageLink = "Table Name" = CONST(Applicant), "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action(Dimensions)
            {
                Caption = 'Dimensions';
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = CONST(17353), "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Job Offer")
            {
                Image = Job;
                RunObject = Page "Job Offer";
                RunPageLink = "Applicant No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage();
    begin
        RecruitmentOfficerPermission := PayrollFunctions.IsRecruitmentOfficer(UserId);
        IF RecruitmentOfficerPermission = false then
            Error('No Permission!');
    end;

    var
        EmployeeNo: Code[20];
        Applicant: Record Applicant;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Record "No. Series";
        PayrollFunctions: Codeunit "Payroll Functions";
        RecruitmentOfficerPermission: Boolean;
}

