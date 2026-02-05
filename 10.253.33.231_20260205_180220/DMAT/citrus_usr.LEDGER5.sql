-- Object: VIEW citrus_usr.LEDGER5
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------



 --ALTER THIS VIEW UNDER SRE-34226

CREATE view [citrus_usr].[LEDGER5]
as 
 
Select * from  AngelDP5.dmat.citrus_usr.LEDGER5 with(nolock)
union all
Select * from  AGMUBODPL3.dmat.citrus_usr.LEDGER5 with(nolock)  
union all
Select * from  Angeldp202.dmat.citrus_usr.LEDGER5 with(nolock) 
union all
Select * from  ABVSDP203.dmat.citrus_usr.LEDGER5 with(nolock) 
union all
Select * from  ABVSDP204.dmat.citrus_usr.LEDGER5 with(nolock)

GO
