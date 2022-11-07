tableextension 98010 "ExtCauseofAbsence" extends "Cause of Absence" 
{

    fields
    {
        field(80000;Type;Option)
        {
            OptionCaption = 'Unpaid Vacation,Paid Vacation,Sick Day,No Duty,Signal Absence,Holiday,Working Day,Working Holiday,Subtraction,Work Accident,Paid Day';
            OptionMembers = "Unpaid Vacation","Paid Vacation","Sick Day","No Duty","Signal Absence",Holiday,"Working Day","Working Holiday",Subtraction,"Work Accident","Paid Day";
        }
        field(80001;"Calculate as";Decimal)
        {
        }
        field(80002;Foreground;Integer)
        {
        }
        field(80003;Bold;Boolean)
        {
        }
        field(80004;"Compensation Value";Decimal)
        {
        }
        field(80005;Default;Boolean)
        {
        }
        field(80006;"Affect Work Days";Boolean)
        {
            Description = 'PY1.0';
        }
        field(80007;"Affect Attendance Days";Boolean)
        {
            Description = 'PY1.0';
        }
        field(80008;"Associated Pay Element";Code[20])
        {
            Description = 'PY1.0';
            TableRelation = "Pay Element";

            trigger OnValidate();
            begin
                if "Associated Pay Element" <> '' then begin
                    if CauseofAbs.FindFirst then  repeat
                        if (CauseofAbs.Code <> Code) and (CauseofAbs."Associated Pay Element" = "Associated Pay Element") then
                            ERROR('Cannot Associate same Pay Element on 2 different Cause of Absence');
                    until CauseofAbs.NEXT = 0;
                    PayE.GET("Associated Pay Element");
                    if not PayE."Payroll Special Code" then
                        ERROR('The Associated Pay Element must be a Payroll Special Code !');
                end;
            end;
        }
        field(80009;"Transaction Type";Option)
        {
            Description = 'PY1.0';
            OptionMembers = " ",Holiday,Public,Maternity,Overtime,Starters,Leavers,Salary,Vacation,Lateness,"Day-Off","Late-Arrive";
        }
        field(80010;"Working Day Multiplier";Decimal)
        {
            Description = 'PY1.0';
        }
        field(80011;"Unpaid Hours";Decimal)
        {
        }
        field(80012;Convertible;Boolean)
        {
        }
        field(80013;Entitled;Boolean)
        {
            CalcFormula = Exist("Absence Entitlement" WHERE ("Cause of Absence Code"=FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80014;Vacation;Boolean)
        {
            Description = 'MB.1105';
        }
        field(80015;"Show in Web Leave Request";Boolean)
        {
        }
        field(80016;"Zoho Code";Text[30])
        {
        }
        field(80017;"Category Type";Option)
        {
            OptionCaption = 'Working Day,Holiday,Annual Leave,Sick Leave,Day Off,Paid Leave,Unpaid Leave,Travel Leave,Absent Day,.';
            OptionMembers = "Working Day",Holiday,"Annual Leave","Sick Leave","Day Off","Paid Leave","Unpaid Leave","Travel Leave","Absent Day",".";
        }
        field(80018;"Not Use";Boolean)
        {
            CaptionClass = 'Not Show In Entitlement';
        }
        field(80019;"Request Category Type";Option)
        {
            OptionCaption = 'General Leave Request,Overtime Request,Early Leave Request,Early Arrive Request,Late Arrive Request';
            OptionMembers = "General Leave Request","Overtime Request","Early Leave Request","Early Arrive Request","Late Arrive Request";
        }
        field(80020;"Portal Leave Sub-Type";Text[50])
        {
        }   
        field(80021;"Allow Negative Bal-Portal";Boolean)
        {
        }
        field(80022;"Portal Grace Period";Integer)
        {
        }    
        field(80023;"Portal Planned Period";Integer)
        {
        }     
        field(80024;"Consider Punch";Boolean)  
        {
        }                    
    }

    var
        CauseofAbs : Record "Cause of Absence";
        PayE : Record "Pay Element";
}

