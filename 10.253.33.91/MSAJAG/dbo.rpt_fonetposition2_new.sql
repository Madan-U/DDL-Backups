-- Object: PROCEDURE dbo.rpt_fonetposition2_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonetposition2_new    Script Date: 5/11/01 6:19:49 PM ******/




create procedure rpt_fonetposition2_new

@sdate varchar(12),
@partycode varchar(10)

AS

select 
party_code,inst_type,symbol,sec_name,left(convert(varchar,expirydate,106),11) as expirydate,
pqty = ( case when sell_buy = 1 then sum(tradeqty) else 0 end ),
sqty = ( case when sell_buy = 2 then sum(tradeqty) else 0 end )
from fosettlement
where expirydate >= @sdate
and party_code like @partycode + '%'
group by party_code,inst_type,symbol,sec_name,left(convert(varchar,expirydate,106),11),sell_buy

GO
