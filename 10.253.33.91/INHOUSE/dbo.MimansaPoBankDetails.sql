-- Object: PROCEDURE dbo.MimansaPoBankDetails
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure MimansaPoBankDetails
As
Select               
c.Party_code,              
'NSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')              
From               
Msajag.Dbo.Client4 c (nolock)              
join              
Msajag.Dbo.PoBank p (nolock)              
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
Msajag.Dbo.PoBank p (nolock)              
on              
/*(p.BankId = c.BankID) */             
(cast(p.BankId as varchar) = c.BankID)

GO
