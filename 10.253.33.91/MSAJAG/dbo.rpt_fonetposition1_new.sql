-- Object: PROCEDURE dbo.rpt_fonetposition1_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonetposition1_new    Script Date: 5/11/01 6:19:48 PM ******/





CREATE procedure rpt_fonetposition1_new

@sdate varchar(12),
@partycode varchar(10)

AS

select 
party_code,inst_type,symbol,sec_name,left(convert(varchar,expirydate,106),11) as expirydate,
pqty = ( case when sell_buy = 1 then sum(tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(tradeqty) else 0 end ), strike_price, option_type
from fosettlement
where expirydate >= @sdate
and party_code = @partycode 
group by party_code,inst_type,symbol,sec_name,left(convert(varchar,expirydate,106),11),sell_buy, strike_price, option_type

GO
