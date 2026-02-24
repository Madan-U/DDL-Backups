-- Object: PROCEDURE dbo.netaspA10
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.netaspA10    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.netaspA10    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.netaspA10    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.netaspA10    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.netaspA10    Script Date: 12/27/00 8:58:51 PM ******/

/****** Object:  Stored Procedure dbo.netaspA10    Script Date: 12/18/99 8:24:13 AM ******/
create procedure netaspA10 as
set rowcount 10
select n2.party_code, n2.scrip_cd, n2.series,
pqty = isnull((select sum(n1.qty) from netasp n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
),0),
pamt = isnull((select sum(n1.amt) from netasp n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
),0),
sqty = isnull((select sum(n1.qty) from netasp n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
),0),
samt = isnull((select sum(n1.amt) from netasp n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
),0) 
from NetAsp n2 
union
select n2.party_code, n2.scrip_cd, n2.series,
pqty = isnull((select sum(n1.tradeqty) from settlement n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
),0),
pamt = isnull((select sum(n1.amount) from settlement n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
),0),
sqty = isnull((select sum(n1.tradeqty) from settlement n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
),0),
samt = isnull((select sum(n1.amount) from settlement n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
),0) 
from settlement n2

GO
