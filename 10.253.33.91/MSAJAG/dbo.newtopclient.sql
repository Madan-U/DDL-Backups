-- Object: PROCEDURE dbo.newtopclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newtopclient    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.newtopclient    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.newtopclient    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.newtopclient    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.newtopclient    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE newtopclient
@topsc varchar(12),
@topscw varchar(12),
@topscm varchar(12)
AS
select t.series,c1.short_name,t.party_code,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t,client1 c1,client2 c2
where t.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and t.series='eq'
group by t.series,t.party_code,c1.short_name,t.sell_Buy
having sum(t.tradeqty * t.marketrate) > convert(money,@topsc)
union all
select t.series,c1.short_name,t.party_code,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t,client1 c1,client2 c2
where t.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and t.series='be'
group by t.series,t.party_code,c1.short_name,t.sell_Buy
having sum(t.tradeqty * t.marketrate) > convert(money,@topscw)
union all
select t.series,c1.short_name,t.party_code,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t,client1 c1,client2 c2
where t.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and t.series='ae'
group by t.series,t.party_code,c1.short_name,t.sell_Buy
having sum(t.tradeqty * t.marketrate) > convert(money,@topscm)
order by t.series,t.party_code,c1.short_name,t.sell_Buy

GO
