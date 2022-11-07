table 98004 "HR Cue"
{

    CaptionML = ENU = 'Finance Cue',
                ESM = 'Pila finanzas',
                FRC = 'Pile finance',
                ENC = 'Finance Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            CaptionML = ENU = 'Primary Key',
                        ESM = 'Clave primaria',
                        FRC = 'Clé primaire',
                        ENC = 'Primary Key';
        }
        field(2; "Ikama Notiifcation"; Integer)
        {
            CalcFormula = Count("Employee Ikama" WHERE("Date To" = FIELD("Due Date Filter"), "Liscence Type" = CONST("IKAMA"), Status = CONST("Active"), "Employee Exist" = CONST(true)));
            CaptionML = ESM = 'Facturas venta vencidas',
                        FRC = 'Factures de ventes en souffrance',
                        ENC = 'Overdue Sales Invoices';
            FieldClass = FlowField;
        }
        field(3; "Driver License Notitfication"; Integer)
        {
            CalcFormula = Count("Employee Ikama" WHERE("Date To" = FIELD("Due Date Filter"), "Liscence Type" = CONST("Driver License"), Status = CONST("Active"), "Employee Exist" = CONST(true)));
            CaptionML = ESM = 'Facturas compra que vencen hoy',
                        FRC = 'Factures d''achats dues aujourd''hui',
                        ENC = 'Purchase Invoices Due Today';
            FieldClass = FlowField;
        }
        field(4; "Health Card Notitfication"; Integer)
        {
            CalcFormula = Count("Employee Ikama" WHERE("Date To" = FIELD("Due Date Filter"), "Liscence Type" = CONST("Health Card"), Status = CONST("Active"), "Employee Exist" = CONST(true)));
            CaptionML = ESM = 'Facturas compra que vencen hoy',
                        FRC = 'Factures d''achats dues aujourd''hui',
                        ENC = 'Purchase Invoices Due Today';
            FieldClass = FlowField;
        }
        field(5; "Open Journals"; Integer)
        {
            CalcFormula = Count("Employee Journal Line" WHERE("Document Status" = CONST("Opened"), "Calculated Value" = FILTER(<> 0)));
            FieldClass = FlowField;
        }
        field(6; "Released Journals"; Integer)
        {
            CalcFormula = Count("Employee Journal Line" WHERE("Document Status" = CONST("Released")));
            FieldClass = FlowField;
        }
        field(7; "Vacation Due"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Next Vacation Date" = FIELD("Due Date Filter")));
            FieldClass = FlowField;
        }
        field(8; "Accommodation Due"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Next Accomodation paid Date" = FIELD("Due Date Filter")));
            FieldClass = FlowField;
        }
        field(10; "Birth Dates"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Month of Birth Date" = FIELD("Month Filter")));
            FieldClass = FlowField;
        }
        field(20; "Due Date Filter"; Date)
        {
            CaptionML = ENU = 'Due Date Filter',
                        ESM = 'Filtro fecha vto.',
                        FRC = 'Filtre date d''échéance',
                        ENC = 'Due Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "Overdue Date Filter"; Date)
        {
            CaptionML = ENU = 'Overdue Date Filter',
                        ESM = 'Filtro fechas vencidas',
                        FRC = 'Filtre date retard',
                        ENC = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(22; "Month Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(23; "Probation Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(24; "Probation Date"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Employment Date" = FIELD("Probation Date Filter")));
            FieldClass = FlowField;
        }
        field(50002; "Approval Entries"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE(Status = CONST("Open"), "Approver ID" = FIELD("User ID")));
            FieldClass = FlowField;
        }
        field(50003; "User ID"; Code[50])
        {
        }
        field(50004; "Eng Syndicate AL Pymt Date"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Eng Syndicate AL Pymt Date" = FIELD("Eng Synd Date Filter")));
            FieldClass = FlowField;
        }
        field(50005; "Eng Synd Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50006; "Insurance Expiry Date"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Health Card Expiry Date" = FIELD("Insurance Expiry Date Filter")));
            FieldClass = FlowField;
        }
        field(50007; "Insurance Expiry Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50008; "Request To Approve"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE(Status = FILTER("Open"), "Table ID" = FILTER(80232 | 80237), "Approver ID" = FIELD("User ID")));
            FieldClass = FlowField;
        }
        field(50009; "Passport Valid Date"; Integer)
        {
            CalcFormula = Count("Employee Additional Info" WHERE("Passport Month Filter" = FIELD("Passport Month Filter"), "Passport Year Filter" = FIELD("Passport Year Filter")));
            FieldClass = FlowField;
        }
        field(50010; "Passport Month Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(50011; "Passport Year Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(50012; "Work Residency Month Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(50013; "Work Residency Year Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(50014; "Work Permit Month Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(50015; "Work Permit Year Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(50016; "Work Residency Valid Date"; Integer)
        {
            CalcFormula = Count("Employee Additional Info" WHERE("Work Residency Month Filter" = FIELD("Work Residency Month Filter"), "Work Residency Year Filter" = FIELD("Work Residency Year Filter")));
            FieldClass = FlowField;
        }
        field(50017; "Work Permit Valid Date"; Integer)
        {
            CalcFormula = Count("Employee Additional Info" WHERE("Work Permit Month Filter" = FIELD("Work Permit Month Filter"), "Work Permit Year Filter" = FIELD("Work Permit Year Filter")));
            FieldClass = FlowField;
        }
        field(50018; "Contracts Termination Date"; Integer)
        {
            CalcFormula = Count("Employee Contracts" WHERE("Termination Date" = FIELD("Termination Date Filter")));
            FieldClass = FlowField;
        }
        field(50019; "Termination Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50020; "Employee Loan"; Integer)
        {
            CalcFormula = Count("Employee Loan" WHERE("Remaining Balance" = FILTER(<> 0)));
            FieldClass = FlowField;
        }
        field(50021; "New Employees"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Employment Date" = FIELD("Employment Date Filter")));
            FieldClass = FlowField;
        }
        field(50022; "Employment Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50023; "Visa Expiry Date"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Employee Additional Info" where("Visa Expiry Date" = field("Visa Expiry Date Filter")));
        }
        field(50024; "Visa Expiry Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50025; "TECOM Expiry Date"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Employee Additional Info" where("TECOM Expiry Date" = field("TECOM Expiry Date Filter")));
        }
        field(50026; "TECOM Expiry Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50027; "Employee Over 64"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where("End of Service Date" = field("End Of Service Filter")));
        }
        field(50028; "End Of Service Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50031; "Driving Lisence"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where("Driving License Expiry Date" = field("Driving Lisence Expiry Filter")));
        }
        field(50032; "Driving Lisence Expiry Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50033; "Employees Absent"; Integer)//20190118:A2+-
        {
            FieldClass = FlowField;
            CalcFormula = count("Employee Absence" where("Attend Hrs." = const(0), "Required Hrs" = filter(> 0), Closed = filter(false), "From Date" = field("Employee Absence Filter")));
        }
        field(50034; "Employee Absence Filter"; Date)//20190118:A2+-
        {
            FieldClass = FlowFilter;
        }
        field(50035; Leavers; Integer)
        {
            CalcFormula = Count(Employee WHERE("Termination Date" = FIELD("Employment Date Filter")));
            FieldClass = FlowField;
        }
        field(50036; "MOF Declaration Date Filter"; Date)//20190118:A2+-
        {
            FieldClass = FlowFilter;
        }

        field(50037; "MOF Declartion"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Declared = Filter('Non-Declared'), "Declaration Date" = FIELD("MOF Declaration Date Filter")));
            FieldClass = FlowField;
        }
        field(50038; "NSSF Declaration Date Filter"; Date)//20190118:A2+-
        {
            FieldClass = FlowFilter;
        }

        field(50039; "NSSF Declartion"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Declared = Filter('Non-Declared'), "NSSF Date" = FIELD("NSSF Declaration Date Filter")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}