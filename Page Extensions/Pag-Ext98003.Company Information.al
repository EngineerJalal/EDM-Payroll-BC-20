pageextension 98003 "ExtCompanyInformation" extends "Company Information"
{
    layout
    {
        addafter(Shipping)
        {
            group("Additional Info")
            {
                field("English Name"; Rec."English Name")
                {
                    ApplicationArea = All;
                }
                field("Arabic Name"; Rec."Arabic Name")
                {
                    ApplicationArea = All;
                }
                field("Arabic Trading Name"; Rec."Arabic Trading Name")
                {
                    ApplicationArea = All;
                }
                field("Arabic City"; Rec."Arabic City")
                {
                    ApplicationArea = All;
                }
                field("Arabic Street"; Rec."Arabic Street")
                {
                    ApplicationArea = All;
                }
                field("Arabic Building"; Rec."Arabic Building")
                {
                    ApplicationArea = All;
                }
                field("Arabic Floor"; Rec."Arabic Floor")
                {
                    ApplicationArea = All;
                }
                field("Arabic Governorate"; Rec."Arabic Governorate")
                {
                    ApplicationArea = All;
                }
                field("Arabic Elimination"; Rec."Arabic Elimination")
                {
                    ApplicationArea = All;
                }
                field("Arabic District"; Rec."Arabic District")
                {
                    ApplicationArea = All;
                }
                field("Arabic Land Area"; Rec."Arabic Land Area")
                {
                    ApplicationArea = All;
                }
                field("Arabic Land Area  No."; Rec."Arabic Land Area  No.")
                {
                    ApplicationArea = All;
                }
                field("Mailbox ID"; Rec."Mailbox ID")
                {
                    ApplicationArea = All;
                }
                field("Arabic MailBox Area"; Rec."Arabic MailBox Area")
                {
                    ApplicationArea = All;
                }
                field("Commercial No."; Rec."Commercial No.")
                {
                    ApplicationArea = All;
                }
                field("Arabic Comercial City"; Rec."Arabic Comercial City")
                {
                    ApplicationArea = All;
                }
                field("Company Owner"; Rec."Company Owner")
                {
                    ApplicationArea = All;
                }
                field("Owner Phone No."; Rec."Owner Phone No.")
                {
                    ApplicationArea = All;

                }
                field("Owner Fax No."; Rec."Owner Fax No.")
                {
                    ApplicationArea = All;

                }
                field("Owner Finance No."; Rec."Owner Finance No.")
                {
                    ApplicationArea = All;

                }
                field("Job Description"; Rec."Job Description")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    Caption = 'رقم تسجيل الشركة لدى الضمان';
                    ApplicationArea = All;
                }
                field("Time Zone"; Rec."Time Zone")
                {
                    ApplicationArea = All;

                }
                field("C.R Number"; Rec."C.R Number")
                {
                    ApplicationArea = All;
                }
                //use this for SKG
                field(Capital; Rec."Capital")
                {
                    ApplicationArea = All;
                }
                /*field(Capital; "Company Capital")
                {
                    ApplicationArea = All;
                }*/
            }
        }
    }
}