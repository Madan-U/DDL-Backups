-- Object: PROCEDURE dbo.Rpt_Loginclientname
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure Rpt_Loginclientname  
@Statusid Varchar(15),   
@Statusname Varchar(25)  
  
As  
If @Statusid = 'Broker'  
  Begin  
    Select Distinct C2.Party_Code, C1.Long_Name  
    From Client1 C1, Client2 C2  
    Where C1.Cl_Code = C2.Cl_Code  
    Order By C1.Long_Name  
  End  
If @Statusid = 'Branch'  
  Begin  
    Select Distinct  C2.Party_Code, C1.Long_Name  
    From Client2 C2, Client1 C1, Branches B  
    Where Ltrim(Rtrim(B.Short_Name)) = Ltrim(Rtrim(C1.Trader)) And  
    C1.Cl_Code = C2.Cl_Code And  
    Ltrim(Rtrim(B.Branch_Cd)) = Ltrim(Rtrim(@Statusname))   
    Order By C1.Long_Name  
  End    
If @Statusid = 'Subbroker'  
  Begin  
    Select Distinct  C2.Party_Code, C1.Long_Name  
    From Client2 C2, Client1 C1, Subbrokers Sb  
    Where C1.Cl_Code = C2.Cl_Code And  
   Ltrim(Rtrim(Sb.Sub_Broker)) = Ltrim(Rtrim(@Statusname)) And  
   Ltrim(Rtrim(Sb.Sub_Broker)) = Ltrim(Rtrim(C1.Sub_Broker))    
   Order By C1.Long_Name  
  End   
If @Statusid = 'Trader'  
  Begin  
    Select Distinct  C2.Party_Code, C1.Long_Name  
    From Client2 C2, Client1 C1  
    Where C1.Cl_Code = C2.Cl_Code And Ltrim(Rtrim(C1.Trader))  = Ltrim(Rtrim(@Statusname))    
    Order By C1.Long_Name  
  End   
If @Statusid = 'Client'  
  Begin  
    Select Distinct C2.Party_Code, C1.Long_Name  
    From Client2 C2, Client1 C1   
    Where C1.Cl_Code = C2.Cl_Code And  
  C2.Party_Code = @Statusname   
 Order By C1.Long_Name  
  End  
If @Statusid = 'Family'  
  Begin  
    Select Distinct C2.Party_Code, C1.Long_Name  
    From Client2 C2, Client1 C1  
    Where C1.Cl_Code = C2.Cl_Code And Ltrim(Rtrim(C1.Family))  = Ltrim(Rtrim(@Statusname))  
    Order By C1.Long_Name  
  End  
If @Statusid = 'Region'  
  Begin  
    Select Distinct C2.Party_Code, C1.Long_Name  
    From Client2 C2, Client1 C1  
    Where C1.Cl_Code = C2.Cl_Code And Ltrim(Rtrim(C1.Region))  = Ltrim(Rtrim(@Statusname))  
    Order By C1.Long_Name  
  End

GO
