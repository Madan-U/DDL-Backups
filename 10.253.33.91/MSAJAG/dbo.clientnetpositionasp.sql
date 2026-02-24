-- Object: PROCEDURE dbo.clientnetpositionasp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clientnetpositionasp    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.clientnetpositionasp    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clientnetpositionasp    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clientnetpositionasp    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clientnetpositionasp    Script Date: 12/27/00 8:58:47 PM ******/

CREATE procedure clientnetpositionasp (@party varchar(30) ) as
select n2.party_code, n2.scrip_cd, n2.series,
pqty = isnull((select sum(n1.qty) from netasp n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_Cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.party_code like n2.Party_code),0),
pamt = isnull((select sum(n1.amt) from netasp n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_Cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.party_code like n2.Party_code),0),
sqty = isnull((select sum(n1.qty) from netasp n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd like n2.scrip_Cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.party_code like n2.Party_code),0),
samt = isnull((select sum(n1.amt) from netasp n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd like n2.scrip_Cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.party_code like n2.Party_code),0) , c1.short_name
from NetAsp n2 ,client1 c1, client2 c2  where n2.party_code = c2.party_code 
and c1.cl_code = c2.cl_Code
and n2.party_code like @party
union all
select n2.party_code, n2.scrip_cd, n2.series,
pqty = isnull((select sum(n1.tradeqty) from settlement n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
and n1.party_code like n2.party_code),0),
pamt = isnull((select sum(n1.amount) from settlement n1 where sell_buy = 1 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
and n1.party_code like n2.party_code),0),
sqty = isnull((select sum(n1.tradeqty) from settlement n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
and n1.party_code like n2.party_code),0),
samt = isnull((select sum(n1.amount) from settlement n1 where sell_buy = 2 and n1.party_code = n2.party_code
and n1.scrip_cd = n2.scrip_cd and n1.series = n2.series and n1.sell_buy = n2.sell_buy
and n1.sett_no = n2.sett_no and n1.sett_type = n2.sett_type
and n1.party_code like n2.party_code),0) ,c1.short_name
from settlement n2 , client1 c1 , client2 c2 where n2.party_code = c2.party_code 
and c1.cl_code = c2.cl_Code
and n2.party_code like @party
order by  n2.party_code, n2.scrip_cd, n2.series

GO
