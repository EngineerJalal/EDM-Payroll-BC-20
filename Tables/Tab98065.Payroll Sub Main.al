table 98065 "Payroll Sub Main"
{
    // version EDM.HRPY2


    fields
    {
        field(1;"Ref Code";Code[20])
        {
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;Description;Text[250])
        {
        }
        field(4;Remark;Text[150])
        {
        }
        field(5;"Pay Date";Date)
        {
        }
        field(6;"Payroll Month";Integer)
        {
        }
        field(7;"Payroll Year";Integer)
        {
        }
        field(8;"Calculate Income Tax";Boolean)
        {
        }
        field(9;"Calculate NSSF Contributions";Boolean)
        {
        }
        field(10;Status;Option)
        {
            OptionCaption = 'Open,Approved';
            OptionMembers = Open,Approved;
        }
        field(11;"Approved By";Code[50])
        {
        }
        field(12;"Approval DateTime";DateTime)
        {
        }
        field(13;"Approval Comments";Text[150])
        {
        }
        field(14;"Posting Status";Option)
        {
            OptionCaption = 'Pending,Payroll,G/L,Posted';
            OptionMembers = Pending,Payroll,"G/L",Posted;
        }
        field(15;"Created By";Code[50])
        {
        }
        field(16;"Created DateTime";DateTime)
        {
        }
        field(17;"Modify By";Code[50])
        {
        }
        field(18;"Modify DateTime";DateTime)
        {
        }
        field(19;"Posting Date";Date)
        {
        }
        field(20;"Posting User";Code[50])
        {
        }
        field(21;"Include Exemption";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Ref Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        PaySubDetails : Record "Payroll Sub Details";
    begin
        PaySubDetails.SETRANGE("Ref Code","Ref Code");
        if PaySubDetails.FINDFIRST then
          repeat
            PaySubDetails.DELETE;
          until PaySubDetails.NEXT = 0;
    end;

    trigger OnInsert();
    begin
        "Created By" := USERID;
        "Created DateTime" := CREATEDATETIME(WORKDATE,TIME);
    end;

    trigger OnModify();
    begin
        "Modify By" := USERID;
        "Modify DateTime" := CREATEDATETIME(WORKDATE,TIME);
    end;
}

