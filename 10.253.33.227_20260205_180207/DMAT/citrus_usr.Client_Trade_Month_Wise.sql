-- Object: PROCEDURE citrus_usr.Client_Trade_Month_Wise
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE Proc [citrus_usr].[Client_Trade_Month_Wise] ( @from_date datetime,@todate datetime )
AS
select Client_COde,NISE_PARTY_CODE,last_trade as last_trade
from TBL_CLIENT_MASTER t with(nolock),
(
select Cltcode,max(vdt) as last_trade from AngelNseCM.account.dbo.ledger_all with(nolock)
 where vtyp=15 and vdt>=@from_date and Vdt <=@todate  +' 23:59'
group by Cltcode
 )c 
where NISE_PARTY_CODE=cltcode

GO
