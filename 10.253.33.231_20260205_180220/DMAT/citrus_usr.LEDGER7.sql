-- Object: VIEW citrus_usr.LEDGER7
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------



CREATE view [citrus_usr].[LEDGER7]
as 
Select Distinct *  from (
Select * from  AngelDP5.dmat.citrus_usr.LEDGER7 with(nolock)
union all
Select * from  AGMUBODPL3.dmat.citrus_usr.LEDGER7 with(nolock)
union all
Select * from  Angeldp202.dmat.citrus_usr.LEDGER7 with(nolock))a

GO
