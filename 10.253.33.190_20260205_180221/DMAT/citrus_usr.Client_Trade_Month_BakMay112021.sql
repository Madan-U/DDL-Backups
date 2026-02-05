-- Object: VIEW citrus_usr.Client_Trade_Month_BakMay112021
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE View [citrus_usr].[Client_Trade_Month]  
as
select Client_COde,NISE_PARTY_CODE,last_trade as last_trade
from TBL_CLIENT_MASTER t with(nolock),
(
select Cltcode,max(vdt) as last_trade from anand1.account.dbo.ledger_all with(nolock) where vtyp=15 and vdt>='2020-12-01'
group by Cltcode
 )c 
where NISE_PARTY_CODE=cltcode

GO
