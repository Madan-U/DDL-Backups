-- Object: PROCEDURE dbo.V2_Offline_Rpt_loginclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure Dbo.rpt_loginclient    Script Date: 01/15/2005 1:41:12 Pm ******/    
    
/****** Object:  Stored Procedure Dbo.rpt_loginclient    Script Date: 12/16/2003 2:31:53 Pm ******/    
    
    
/****** Object:  Stored Procedure Dbo.rpt_loginclient    Script Date: 10/17/02 1:48:57 Pm ******/    
    
/*created By Amit On 06/08/2002 Client Detail Report  */    
Create Procedure V2_Offline_Rpt_loginclient     
@statusid Varchar(15),    
@statusname Varchar(25)    
    
As    
If @statusid='broker'    
  Begin    
    Select Distinct Party_code    
    From Client_Details     
    Order By Party_code    
  End    
If @statusid='branch'    
  Begin    
    Select Distinct  C2.party_code    
    From Client_Details C2, Client1 C1, Branches B    
    Where Ltrim(rtrim(b.short_name)) = Ltrim(rtrim(c1.trader)) And    
   C1.cl_code = C2.cl_code And    
   Ltrim(rtrim(b.branch_cd)) = Ltrim(rtrim(@statusname))     
    Order By C2.party_code    
  End      
If @statusid='subbroker'    
  Begin    
    Select Distinct  C2.party_code    
    From Client_Details C2,client1 C1,subbrokers Sb    
    Where C1.cl_code = C2.cl_code And    
   Ltrim(rtrim(sb.sub_broker)) = Ltrim(rtrim(@statusname)) And    
   Ltrim(rtrim(sb.sub_broker)) = Ltrim(rtrim(c1.sub_broker))      
   Order By C2.party_code    
  End     
If @statusid='trader'    
  Begin    
    Select Distinct  C2.party_code    
    From Client_Details C2, Client1 C1    
    Where C1.cl_code = C2.cl_code And Ltrim(rtrim(c1.trader))  = Ltrim(rtrim(@statusname))      
    Order By C2.party_code    
  End     
If @statusid='client'    
  Begin    
    Select Distinct C2.party_code    
    From Client_Details C2, Client1 C1     
    Where C1.cl_code=c2.cl_code And    
  C2.party_code=@statusname     
 Order By C2.party_code    
  End    
If @statusid='family'    
  Begin    
    Select Distinct C2.party_code    
    From Client_Details C2, Client1 C1    
    Where C1.cl_code = C2.cl_code And Ltrim(rtrim(c1.family))  = Ltrim(rtrim(@statusname))    
    Order By C2.party_code    
  End

GO
