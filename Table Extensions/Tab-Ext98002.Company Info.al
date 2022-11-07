tableextension 98002 "ExtCompanyInfo" extends "Company Information"
{
    fields
    {
        field(60000; "Arabic Name"; Text[100])
        {
        }
        field(60001; "Arabic Trading Name"; Text[30])
        {
            Caption = 'الشهرة التجارية';
        }
        field(60002; "Arabic City"; Text[30])
        {
            Caption = 'منطقة - بلدة';
        }
        field(60003; "Arabic Street"; Text[30])
        {
            Caption = 'الشارع';
        }
        field(60004; "Arabic Building"; Text[30])
        {
            Caption = 'المبنى';
        }
        field(60005; "Arabic Floor"; Code[10])
        {
            Caption = 'الطابق';
        }
        field(60008; "Arabic Governorate"; Text[50])
        {
            Caption = 'محافظة';
        }
        field(60009; "Arabic Elimination"; Text[30])
        {
            Caption = 'قضاء';
        }
        field(60010; "Arabic District"; Text[30])
        {
            Caption = 'الحي';
        }
        field(60011; "Arabic Land Area"; Text[30])
        {
            Caption = 'رقم العقار';
        }
        field(60012; "Arabic Land Area  No."; Code[20])
        {
            Caption = 'رقم العقار';
        }
        field(60013; "Mailbox ID"; Code[20])
        {
            Caption = 'صندوق بريد رقم';
        }
        field(60014; "Arabic MailBox Area"; Text[30])
        {
            Caption = 'منطقة البريد';
        }
        field(60015; "Commercial No."; Code[20])
        {
            Caption = 'رقم تسجيل الشركة لدى وزارة المالية';
        }
        field(60016; "Arabic Comercial City"; Text[30])
        {
        }
        field(60017; "Company Owner"; Text[100])
        {
        }
        field(60018; "Job Description"; Text[100])
        {
            Caption = 'Owner Job Description';
        }
        field(60019; "English Name"; Text[100])
        {
        }
        field(60020; "Time Zone"; integer)
        {
        }
        field(60021; "C.R Number"; Text[50])
        {
        }

        field(60022; "Capital"; Text[30])
        {
        }

        field(60023; "Company Capital"; Text[30])
        {
        }
        field(60024; "Owner Phone No."; Text[50])
        {
        }
        field(60025; "Owner Fax No."; Text[50])
        {
        }
        field(60026; "Owner Finance No."; Text[50])
        {
        }
        field(60027; "Managing Name"; Text[250])
        {
            Caption = 'Managing Director';
        }
        field(60028; "HR Manager"; Text[250])
        {
        }
        field(60029; "Arabic Registration No."; Text[20])
        {
            Caption = 'رقم التسجيل لدى وزارة المالية';
        }
    }
}

