-- Object: PROCEDURE dbo.tradenetA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.tradenetA    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.tradenetA    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.tradenetA    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.tradenetA    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.tradenetA    Script Date: 12/27/00 8:59:05 PM ******/

/****** Object:  Stored Procedure dbo.tradenetA    Script Date: 12/18/99 8:24:14 AM ******/
create procedure tradenetA (@party varchar(30),@scrip varchar(12) ) as
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
and c1.short_name like @party+'%' and n2.scrip_cd like @scrip+'%'

GO
