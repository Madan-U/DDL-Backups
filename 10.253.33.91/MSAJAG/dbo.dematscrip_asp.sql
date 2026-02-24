-- Object: PROCEDURE dbo.dematscrip_asp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.dematscrip_asp    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.dematscrip_asp    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.dematscrip_asp    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.dematscrip_asp    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.dematscrip_asp    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.dematscrip_asp    Script Date: 12/18/99 8:24:08 AM ******/
CREATE PROCEDURE dematscrip_asp AS
select distinct t1.scrip_cd,t1.series,
   pqty=isnull((select sum(tradeqty) from settlement where sell_buy =1 
 and settlement.scrip_cd=t1.scrip_cd
 and settlement.series=t1.series),0),
   sqty=isnull((select sum(tradeqty) from settlement where sell_buy =2 
 and settlement.scrip_cd=t1.scrip_cd
 and settlement.series=t1.series),0),
   pamt=isnull((select sum(tradeqty*marketrate) from settlement where sell_buy =1 
 and settlement.scrip_cd=t1.scrip_cd
 and settlement.series=t1.series),0),
   samt=isnull((select sum(tradeqty*marketrate) from settlement where sell_buy =2 
 and settlement.scrip_cd=t1.scrip_cd
 and settlement.series=t1.series),0)
from settlement t1 , scrip1 s1, scrip2 s2
where
t1.scrip_cd = s2.scrip_cd and
t1.series = s2.series and 
s1.co_code = s2.co_code and
s1.series = s2.series and
(s1.demat_date <= t1.sauda_date)
group by t1.scrip_cd,t1.series,t1.sell_buy

GO
