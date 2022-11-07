report 98130 "Employees Info"
{
  DefaultLayout = RDLC;
  RDLCLayout = 'Reports Layouts/Employees Info.rdlc';

  dataset
  {
    dataitem(Employee;Employee)
    {
        RequestFilterFields = "No.",Status,Declared,"Employment Date";
        column(No;"No.")
        {
        }
        column(Name;"Full Name")
        {
        }
        column(MobileNo;"Mobile Phone No.")
        {
        }
        column(Gender;Gender)
        {
        }
        column(Status;Status)
        {
        }
        column(SocialStatus;"Social Status")
        {
        }
        column(Address;Address)
        {
        }  
        column(Building;Building)
        {
        }        
        column(Floor;Floor)
        {
        }    
        column(EmploymentDate;"Employment Date")
        {
        }  
        column(NSSFNo;"Social Security No.")
        {
        }              
        column(Declared;Declared)      
        {}                              
    }
  }
}

