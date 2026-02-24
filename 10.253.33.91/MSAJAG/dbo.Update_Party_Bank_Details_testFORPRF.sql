-- Object: PROCEDURE dbo.Update_Party_Bank_Details_testFORPRF
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc [dbo].[Update_Party_Bank_Details_testFORPRF]          
as          
          
          
/*          
Create Table Party_Bank_Details          
(          
Party_Code varchar(10),          
Exchange varchar(11),          
BankName varchar(100),          
Branch Varchar(100),          
AcNum Varchar(64),          
AcType Varchar(20)          
)          
*/          
         
-----select top 0 * into temp_pef_Party_Bank_Details    from Party_Bank_Details      
      
TRUNCATE TABLE temp_pef_Party_Bank_Details

Insert into temp_pef_Party_Bank_Details                
Select               
c.Party_code,              
'NSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
Client4 c (nolock)              
join              
PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')              
UNION ALL              
Select               
c.cltcode,              
'NSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
Account.dbo.MultiBankId c (nolock)              
join              
PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
              
              
--- UPDATE NSE OVER ---              
              
              
Insert into temp_pef_Party_Bank_Details        
              
Select               
c.Party_code,              
'BSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
anand.bsedb_ab.dbo.Client4 c (nolock)              
join              
anand.bsedb_ab.dbo.PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')              
UNION ALL               
Select               
c.cltcode,              
'BSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
anand.Account_ab.dbo.MultiBankId c (nolock)              
join              
anand.bsedb_ab.dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
              
--- UPDATE BSE OVER ---              
              
Insert into temp_pef_Party_Bank_Details              
              
Select               
c.Party_code,              
'NSE-FUTURES' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
angelfo.nsefo.dbo.Client4 c (nolock)              
join              
angelfo.nsefo.dbo.PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')               
UNION ALL               
Select               
c.cltcode,              
'NSE-FUTURES' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelfo.accountfo.dbo.MultiBankId c (nolock)              
join              
angelfo.nsefo.dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
               
--- UPDATE NSEFO OVER ---              
              
Insert into temp_pef_Party_Bank_Details        
              
Select               
c.Party_code,              
'NSX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
angelfo.nsecurfo.dbo.Client4 c (nolock)              
join              
angelfo.nsecurfo.dbo.PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')               
UNION ALL               
Select               
c.cltcode,              
'NSX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelfo.accountcurfo.dbo.MultiBankId c (nolock)              
join              
angelfo.nsecurfo.dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
            
--- UPDATE NSEFO OVER ---             
             
Insert into temp_pef_Party_Bank_Details              
              
Select               
c.Party_code,              
'BSE-FUTURES' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
angelcommodity.bsefo.dbo.Client4 c (nolock)              
join              
angelcommodity.bsefo.dbo.PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')              
UNION ALL               
Select               
c.cltcode,              
'BSE-FUTURES' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelcommodity.accountbfo.dbo.MultiBankId c (nolock)              
join              
angelcommodity.bsefo.dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
              
--- UPDATE BSEFO OVER ---            
            
Insert into temp_pef_Party_Bank_Details              
              
Select               
c.Party_code,              
'MCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
angelcommodity.mcdx.dbo.Client4 c (nolock)              
join              
angelcommodity.mcdx.dbo.PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')              
UNION ALL               
Select               
c.cltcode,              
'MCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelcommodity.accountmcdx.dbo.MultiBankId c (nolock)              
join              
angelcommodity.mcdx.dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
            
--- UPDATE MCDX OVER ---            
            
Insert into temp_pef_Party_Bank_Details        
              
Select               
c.Party_code,              
'NCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
angelcommodity.ncdx.dbo.Client4 c (nolock)              
join              
angelcommodity.ncdx.dbo.PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')              
UNION ALL               
Select               
c.cltcode,              
'NCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelcommodity.accountncdx.dbo.MultiBankId c (nolock)              
join              
angelcommodity.ncdx.dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
            
--- UPDATE NCDX OVER ---            
            
Insert into temp_pef_Party_Bank_Details              
              
Select               
c.Party_code,              
'MCX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
angelcommodity.mcdxcds.dbo.Client4 c (nolock)              
join              
angelcommodity.mcdxcds.dbo.PoBank p (nolock)              
on              
(cast(p.BankId as varchar) = c.BankID)              
Where              
c.Depository not in ('CDSL','NSDL')              
UNION ALL               
Select        
c.cltcode,              
'MCX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelcommodity.accountmcdxcds.dbo.MultiBankId c (nolock)              
join              
angelcommodity.mcdxcds.dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)  
            
--- UPDATE MCDXCDS OVER ---      
delete from temp_pef_Party_Bank_Details where bankname='UNKNOWN'     

  

if (select COUNT(1) from temp_pef_Party_Bank_Details) > 0   
BEGIN  
  
 Begin tran      
        
  Truncate Table temp_pef_Party_Bank_Details_main      
            
  Insert into temp_pef_Party_Bank_Details_main        
  select Party_Code,Exchange,BankName,Branch,AcNum,AcType from temp_pef_Party_Bank_Details   
  GROUP BY Party_Code,Exchange,BankName,Branch,AcNum,AcType   
        
 Commit Tran   
END

GO
