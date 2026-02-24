-- Object: PROCEDURE dbo.Update_Party_Bank_Details_ClientCodeWise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


-- Exec Update_Party_Bank_Details_ClientCodeWise 'Rp61'

CREATE Proc [dbo].[Update_Party_Bank_Details_ClientCodeWise]    

(
 @Party_Code varchar(12)
)        
as            
            
        
           
Create table #Party_Bank_Details (

	[Party_Code] [varchar](10) NULL,
	[Exchange] [varchar](11) NULL,
	[BankName] [varchar](100) NULL,
	[Branch] [varchar](100) NULL,
	[AcNum] [varchar](64) NULL,
	[AcType] [varchar](20) NULL
)       
        
Insert into #Party_Bank_Details                  
Select                 
c.Party_code,                
'NSE-CAPITAL' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
Client4 c (nolock)                
inner join                
PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL') and c.Party_code=@Party_Code 
          
UNION                 
Select                 
c.cltcode,                
'NSE-CAPITAL' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
Account.dbo.MultiBankId c (nolock)                
 inner join  PoBank p (nolock)                
on                
            
(cast(p.BankId as varchar) = c.BankID)    
   where   c.cltcode=@Party_Code           
                
--- UPDATE NSE OVER ---                
                
                
Insert into #Party_Bank_Details          
                
Select                 
c.Party_code,                
'BSE-CAPITAL' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
anand.bsedb_ab.dbo.Client4 c (nolock)                
 inner join                
anand.bsedb_ab.dbo.PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL')  and  c.Party_code=@Party_Code                     
UNION                 

Select                 
c.cltcode,                
'BSE-CAPITAL' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
anand.Account_ab.dbo.MultiBankId c (nolock)                
 inner join                
anand.bsedb_ab.dbo.PoBank p (nolock)                
on                
            
(cast(p.BankId as varchar) = c.BankID)    
  where c.cltcode=@Party_COde              
--- UPDATE BSE OVER ---                
                
Insert into #Party_Bank_Details                
                
Select                 
c.Party_code,                
'NSE-FUTURES' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
angelfo.nsefo.dbo.Client4 c (nolock)                
 inner join                
angelfo.nsefo.dbo.PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL') and c.Party_code=@Party_Code
                 
UNION                 
Select                 
c.cltcode,                
'NSE-FUTURES' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
angelfo.accountfo.dbo.MultiBankId c (nolock)                
inner join                
angelfo.nsefo.dbo.PoBank p (nolock)                
on                
/*(p.BankId = c.BankID) */               
(cast(p.BankId as varchar) = c.BankID)   where  c.cltcode=@Party_COde  
                 
--- UPDATE NSEFO OVER ---                
                
Insert into #Party_Bank_Details          
                
Select                 
c.Party_code,                
'NSX-CURR' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
angelfo.nsecurfo.dbo.Client4 c (nolock)                
 inner join                
angelfo.nsecurfo.dbo.PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL') and c.Party_code=@Party_Code
                 
UNION                 
Select                 
c.cltcode,                
'NSX-CURR' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
angelfo.accountcurfo.dbo.MultiBankId c (nolock)                
inner join                
angelfo.nsecurfo.dbo.PoBank p (nolock)                
on                
/*(p.BankId = c.BankID) */               
(cast(p.BankId as varchar) = c.BankID)  where  c.cltcode=@Party_COde    
              
--- UPDATE NSEFO OVER ---               
               
Insert into #Party_Bank_Details                
                
Select                 
c.Party_code,                
'BSE-FUTURES' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
angelcommodity.bsefo.dbo.Client4 c (nolock)                
inner join                
angelcommodity.bsefo.dbo.PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL') and c.Party_code=@Party_Code                

UNION 
                
Select                 
c.cltcode,                
'BSE-FUTURES' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
angelcommodity.accountbfo.dbo.MultiBankId c (nolock)                
inner join                
angelcommodity.bsefo.dbo.PoBank p (nolock)                
on                
/*(p.BankId = c.BankID) */               
(cast(p.BankId as varchar) = c.BankID) where  c.cltcode=@Party_COde     
                
--- UPDATE BSEFO OVER ---              
              
Insert into #Party_Bank_Details                
                
Select                 
c.Party_code,                
'MCX-COMM' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
angelcommodity.mcdx.dbo.Client4 c (nolock)                
inner join              
angelcommodity.mcdx.dbo.PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL') and c.Party_code=@Party_Code               
UNION
                 
Select                 
c.cltcode,                
'MCX-COMM' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
angelcommodity.accountmcdx.dbo.MultiBankId c (nolock)                
inner join             
angelcommodity.mcdx.dbo.PoBank p (nolock)                
on                
/*(p.BankId = c.BankID) */               
(cast(p.BankId as varchar) = c.BankID)  where  c.cltcode=@Party_COde    
       
--- UPDATE MCDX OVER ---              
              
Insert into #Party_Bank_Details          
                
Select                 
c.Party_code,                
'NCX-COMM' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
angelcommodity.ncdx.dbo.Client4 c (nolock)                
inner join            
angelcommodity.ncdx.dbo.PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL') and c.Party_code=@Party_Code               
UNION 
                
Select                 
c.cltcode,                
'NCX-COMM' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
angelcommodity.accountncdx.dbo.MultiBankId c (nolock)                
inner join              
angelcommodity.ncdx.dbo.PoBank p (nolock)                
on                
/*(p.BankId = c.BankID) */               
(cast(p.BankId as varchar) = c.BankID) where  c.cltcode=@Party_COde     
              
--- UPDATE NCDX OVER ---              
              
Insert into #Party_Bank_Details                
                
Select                 
c.Party_code,                
'MCX-CURR' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.CltDpId,''),                
AcType = isnull(c.Depository,'')                
From                 
angelcommodity.mcdxcds.dbo.Client4 c (nolock)                
inner join               
angelcommodity.mcdxcds.dbo.PoBank p (nolock)                
on                
(cast(p.BankId as varchar) = c.BankID)                
Where                
c.Depository not in ('CDSL','NSDL')  and c.Party_code=@Party_Code
              
UNION 
                
Select          
c.cltcode,                
'MCX-CURR' as Exchange,                
BankName = isnull(p.Bank_Name,''),                
Branch = isnull(p.Branch_Name,''),                
AcNum = isnull(c.AccNo,''),                
AcType = isnull(c.AccType,'')                 
From                 
angelcommodity.accountmcdxcds.dbo.MultiBankId c (nolock)                
inner join               
angelcommodity.mcdxcds.dbo.PoBank p (nolock)                
on                
/*(p.BankId = c.BankID) */               
(cast(p.BankId as varchar) = c.BankID) where  c.cltcode=@Party_COde     
              
--- UPDATE MCDXCDS OVER ---        
delete from #Party_Bank_Details where bankname='UNKNOWN' 

Select * from #Party_Bank_Details

Drop table #Party_Bank_Details

GO
