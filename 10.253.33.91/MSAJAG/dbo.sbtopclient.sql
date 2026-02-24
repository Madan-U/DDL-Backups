-- Object: PROCEDURE dbo.sbtopclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtopclient    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtopclient    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtopclient    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtopclient    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbtopclient    Script Date: 12/27/00 8:59:02 PM ******/

/* report : management info
file topclient_scrip.asp
displays top  client  who have done trading above 500000
*/
CREATE PROCEDURE sbtopclient
@subbroker varchar(15)
AS
select c1.short_name,t.party_code,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t,client1 c1,client2 c2 , subbrokers sb 
where t.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and c1.sub_broker=sb.sub_broker and
sb.sub_broker=@subbroker
group by c1.short_name,t.party_code,t.sell_Buy having sum(t.tradeqty * t.marketrate) >500000

GO
