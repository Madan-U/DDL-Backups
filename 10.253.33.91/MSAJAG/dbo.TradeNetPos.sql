-- Object: PROCEDURE dbo.TradeNetPos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TradeNetPos    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.TradeNetPos    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.TradeNetPos    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.TradeNetPos    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.TradeNetPos    Script Date: 12/27/00 8:59:05 PM ******/

/****** Object:  Stored Procedure dbo.TradeNetPos    Script Date: 12/18/99 8:24:06 AM ******/
CREATE PROCEDURE TradeNetPos 
(@date varchar(10),@user_id int )
 AS
select distinct Sdate=convert(char,sauda_date,103),MARKETTYPE,user_id,scrip_cd,series,
   pqty=isnull((select sum(tradeqty) from trade where sell_buy =1 and trade.MARKETTYPE=t1.MARKETTYPE
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0),
   sqty=isnull((select sum(tradeqty) from trade where sell_buy =2 and trade.MARKETTYPE=t1.MARKETTYPE
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0),
   pamt=isnull((select sum(tradeqty*marketrate) from trade where sell_buy =1 and trade.MARKETTYPE=t1.MARKETTYPE
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0),
   samt=isnull((select sum(tradeqty*marketrate) from trade where sell_buy =2 and trade.MARKETTYPE=t1.MARKETTYPE
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0)
   
from trade t1 where convert(char,sauda_date,3) = convert(char,@date,3) and user_id = @user_id
group by convert(char,sauda_date,103),MARKETTYPE,user_id,scrip_cd,series,sell_buy

GO
