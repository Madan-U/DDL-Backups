-- Object: PROCEDURE dbo.topclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.topclient    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.topclient    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.topclient    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.topclient    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.topclient    Script Date: 12/27/00 8:59:05 PM ******/

CREATE PROCEDURE topclient 
@subbroker varchar(15)
AS
select c1.short_name,t.party_code,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t,client1 c1,client2 c2, subbrokers sb 
where t.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and c1.sub_broker=sb.sub_broker and
sb.sub_broker=@subbroker
group by t.party_code,c1.short_name,t.sell_Buy having sum(t.tradeqty * t.marketrate) >500000

GO
