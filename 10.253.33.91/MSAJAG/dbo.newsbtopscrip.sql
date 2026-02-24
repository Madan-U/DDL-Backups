-- Object: PROCEDURE dbo.newsbtopscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newsbtopscrip    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.newsbtopscrip    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.newsbtopscrip    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.newsbtopscrip    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.newsbtopscrip    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE newsbtopscrip
@topsc varchar(12),
@topscw varchar(12),
@topscm varchar(12)
AS
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'eq'
group by  t.series,t.scrip_cd,t.sell_Buy 
having sum(t.tradeqty * t.marketrate) >convert(money,@topsc)
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'be'
group by  t.series,t.scrip_cd,t.sell_Buy 
having sum(t.tradeqty * t.marketrate) >convert(money,@topscw)
union all
select t.series,t.scrip_cd,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy 
from trade4432 t, client2 c2, client1 c1
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code 
and t.series = 'ae'
group by  t.series,t.scrip_cd,t.sell_Buy 
having sum(t.tradeqty * t.marketrate) >convert(money,@topscm)
order by  t.series,t.scrip_cd,t.sell_Buy

GO
