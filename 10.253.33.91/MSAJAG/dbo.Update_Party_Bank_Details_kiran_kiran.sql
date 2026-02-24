-- Object: PROCEDURE dbo.Update_Party_Bank_Details_kiran_kiran
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc Update_Party_Bank_Details_kiran_kiran
as  
  
  
/*  
Create Table Party_Bank_Details_kiran  
(  
Party_Code varchar(10),  
Exchange varchar(11),  
BankName varchar(100),  
Branch Varchar(100),  
AcNum Varchar(64),  
AcType Varchar(20)  
)  
*/  
  
Truncate Table Party_Bank_Details_kiran  
  
  
  
Insert into Party_Bank_Details_kiran  
  
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
join  
PoBank p (nolock)  
on  
(p.BankId = c.BankID)  
  
  
--- UPDATE NSE OVER ---  
  
  
Insert into Party_Bank_Details_kiran  
  
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
join  
anand.bsedb_ab.dbo.PoBank p (nolock)  
on  
(p.BankId = c.BankID)  
  
--- UPDATE BSE OVER ---  
  
Insert into Party_Bank_Details_kiran  
  
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
  
  
--- UPDATE NSEFO OVER ---  
  
  
Insert into Party_Bank_Details_kiran  
  
Select   
c.Party_code,  
'BSE-FUTURES' as Exchange,  
BankName = isnull(p.Bank_Name,''),  
Branch = isnull(p.Branch_Name,''),  
AcNum = isnull(c.CltDpId,''),  
AcType = isnull(c.Depository,'')  
From   
anand.bsefo.dbo.Client4 c (nolock)  
join  
anand.bsefo.dbo.PoBank p (nolock)  
on  
(cast(p.BankId as varchar) = c.BankID)  
Where  
c.Depository not in ('CDSL','NSDL')  
UNION   
Select   
c.cltcode,  
'BSE-FUTURES' as Exchange,  
BankName = isnull(p.Bank_Name,''),  
Branch = isnull(p.Branch_Name,''),  
AcNum = isnull(c.AccNo,''),  
AcType = isnull(c.AccType,'')   
From   
anand.accountbfo.dbo.MultiBankId c (nolock)  
join  
anand.bsefo.dbo.PoBank p (nolock)  
on  
(p.BankId = c.BankID)  
  
--- UPDATE BSEFO OVER ---

GO
