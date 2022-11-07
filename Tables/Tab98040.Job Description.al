// This Table not used
//this table must be cancel for LAT
 table 98040 "Job Description"
 {
     fields
    {
         field(1;"Job Title";Code[20])
         {
        }
         field(2;"Line No.";Integer)
         {
         }
         field(3;"Job Description";Text[120])
         {
         }
     }

     keys
     {
         key(Key1;"Job Title","Line No.")
         {
         }
     }
 }