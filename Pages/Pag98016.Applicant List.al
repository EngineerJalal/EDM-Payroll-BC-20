page 98016 "Applicant List"
{
    // version SHR1.0,EDM.HRPY1

    CardPageID = "Applicant Card";
    Editable = false;
    PageType = List;
    SourceTable = Applicant;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(FullName;Rec.FullName)
                {
                    CaptionML = ENU = 'Applicant Name',
                                ENG = 'Full Name';
                    ApplicationArea = All;
                }
                field("First Name";Rec."First Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Middle Name";Rec."Middle Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Last Name";Rec."Last Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Initials; Rec.Initials)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Title";Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field(Locations;Rec. Locations)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Post Code";Rec."Post Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Country Code";Rec."Country Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Phone No.";Rec."Phone No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Mobile Phone No.";Rec."Mobile Phone No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("E-Mail";Rec."E-Mail")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Department Code";Rec."Department Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Search Name";Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Employee No.";Rec."Employee No.")
                {
                    Caption = 'Hired under Employee No';
                    ApplicationArea = All;
                }
                field(Sex; Rec.Sex)
                {
                    ApplicationArea = All;
                }
                field("Available From";Rec."Available From")
                {
                    ApplicationArea = All;
                }
                field("First Nationality Code";Rec."First Nationality Code")
                {
                    ApplicationArea = All;
                }
                field("Social Status";Rec."Social Status")
                {
                    ApplicationArea = All;
                }
                field("ApplicantAge()"; Rec.ApplicantAge())
                {
                    Caption = 'Age';
                    ApplicationArea = All;
                }
                field("Hired Date";Rec."Hired Date")
                {
                    ApplicationArea = All;
                }
                field("Application Phase";Rec."Application Phase")
                {
                    ApplicationArea = All;
                }
                field("Notice Period";Rec."Notice Period")
                {
                    ApplicationArea = All;
                }
                field("Experienced Years";Rec."Experienced Years")
                {
                    ApplicationArea = All;
                }
                field("Latest Academic Graduate Date";Rec."Latest Academic Graduate Date")
                {
                    ApplicationArea = All;
                }
                field("Birth Date";Rec."Birth Date")
                {
                    ApplicationArea = All;
                }
                field("LatestAcademicInstituteTypeName()"; Rec.LatestAcademicInstituteTypeName())
                {
                    Caption = 'Latest Academic Institute Type';
                    ApplicationArea = All;
                }
                field("LatestAcademicDegreeName()"; Rec.LatestAcademicDegreeName())
                {
                    Caption = 'Latest Academic Degree Name';
                    ApplicationArea = All;
                }
                field("LatestAcademicSpecialityName()"; Rec.LatestAcademicSpecialityName())
                {
                    Caption = 'Latest Academic Speciality Name';
                    ApplicationArea = All;
                }
                field("LatestAcademicStudySinceDuration()"; Rec.LatestAcademicStudySinceDuration())
                {
                    Caption = 'Latest Academic Study Since (Years)';
                    ApplicationArea = All;
                }
                field("First Interview Date";Rec."First Interview Date")
                {
                    ApplicationArea = All;
                }
                field("FirstInterviewPhaseName()"; Rec.FirstInterviewPhaseName())
                {
                    Caption = 'First Interview Phase Name';
                    ApplicationArea = All;
                }
                field("FirstInterviewerName()"; Rec.FirstInterviewerName())
                {
                    Caption = 'First Interviewer Name';
                    ApplicationArea = All;
                }
                field("Next Interview Date";Rec."Next Interview Date")
                {
                    ApplicationArea = All;
                }
                field(NextInterviewPhaseName; Rec.NextInterviewPhaseName)
                {
                    Caption = 'Next Interview Phase Name';
                    ApplicationArea = All;
                }
                field("NextInterviewerName()"; Rec.NextInterviewerName())
                {
                    Caption = 'Next Interviewer Name';
                    ApplicationArea = All;
                }
                field("Latest Interview Date";Rec."Latest Interview Date")
                {
                    ApplicationArea = All;
                }
                field(LatestInterviewPhaseName; Rec.LatestInterviewPhaseName)
                {
                    Caption = 'Latest Interview Phase Name';
                    ApplicationArea = All;
                }
                field("LatestInterviewerName()"; Rec.LatestInterviewerName())
                {
                    Caption = 'Latest Interviewer Name';
                    ApplicationArea = All;
                }
                field("LatestInterviewComments()"; Rec.LatestInterviewComments())
                {
                    Caption = 'Latest Interview Comments';
                    ApplicationArea = All;
                }
                field("InterviewProcessDurationDays()"; Rec.InterviewProcessDurationDays())
                {
                    Caption = 'Interview Process Duration (Days)';
                    ApplicationArea = All;
                }
                field("JoiningIntervalDays()"; Rec.JoiningIntervalDays())
                {
                    Caption = 'Joining Interval (Days)';
                    ApplicationArea = All;
                }
                field(IsForeigner; Rec.IsForeigner)
                {
                    ApplicationArea = All;
                }
                field("Preferred Work Schedule";Rec."Preferred Work Schedule")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Requested Salary";Rec."Requested Salary")
                {
                    ApplicationArea = All;
                }
                field("Applied For";Rec."Applied For")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Is Employed";Rec."Is Employed")
                {
                    ApplicationArea = All;
                }
                field("Employment Date";Rec."Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Termination Date";Rec."Termination Date")
                {
                    ApplicationArea = All;
                }
                field("Termination Reason";Rec."Termination Reason")
                {
                    ApplicationArea = All;
                }
                field("Agreed Salary";Rec."Agreed Salary")
                {
                    ApplicationArea = All;
                }
                field("EmploymentIntervalDays()"; Rec.EmploymentIntervalDays())
                {
                    Caption = 'Employment Interval (Days)';
                    ApplicationArea = All;
                }
                field("EmploymentIntervalMonths()"; Rec.EmploymentIntervalMonths())
                {
                    Caption = 'Employment Interval (Months)';
                    ApplicationArea = All;
                }
                field("EmploymentIntervalYears()"; Rec.EmploymentIntervalYears())
                {
                    Caption = 'Employment Interval (Years)';
                    ApplicationArea = All;
                }
                field("Application Date";Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field(Division; Rec.Division)
                {
                    ApplicationArea = All;
                }
                field(Branch;Rec. Branch)
                {
                    ApplicationArea = All;
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = All;
                }
                field("Job Category";Rec."Job Category")
                {
                    ApplicationArea = All;
                }
                field("Employment Type Code";Rec."Employment Type Code")
                {
                    ApplicationArea = All;
                }
                field("Last Offer Applicant Comment"; Rec.GetLastOfferApplicantComment)
                {
                    ApplicationArea = All;
                }
                field("Last Offer Company Comment"; Rec.GetLastOfferCompanyComment)
                {
                    ApplicationArea = All;
                }
                field("Last Offer Sent Date"; Rec.GetLastOfferSentDate)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Applicant")
            {
                CaptionML = ENU = '&Applicant',
                            ENG = 'E&mployee';
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
                    Image = Comment;
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
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Job Offer")
                {
                    Image = Job;
                    RunObject = Page "Job Offer";
                    ApplicationArea = All;
                }
                action("&Employment History")
                {
                    Caption = '&Employment History';
                    Image = History;
                    RunObject = Page "Employment History";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Language &Skills")
                {
                    Caption = 'Language &Skills';
                    Image = Language;
                    RunObject = Page "Language Skills";
                    RunPageLink = "No." = FIELD("No.");
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
                    Image = Notes;
                    RunObject = Page "Human Resource Interview Sheet";
                    //RunPageLink = "Table Name"=CONST(9),"No."=FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
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
        PayrollFunctions: Codeunit "Payroll Functions";
        RecruitmentOfficerPermission: Boolean;
}