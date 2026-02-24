-- Object: PROCEDURE dbo.NetPosition
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NetPosition    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NetPosition    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NetPosition    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NetPosition    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.NetPosition    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.NetPosition    Script Date: 12/18/99 8:24:05 AM ******/
CREATE PROCEDURE NetPosition AS
select distinct Sdate=convert(char,sauda_date,103),auctionpart,user_id,scrip_cd,series,
   pqty=isnull((select sum(tradeqty) from trade where sell_buy =1 and trade.auctionpart=t1.auctionpart
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0),
   sqty=isnull((select sum(tradeqty) from trade where sell_buy =2 and trade.auctionpart=t1.auctionpart
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0),
   pamt=isnull((select sum(tradeqty*marketrate) from trade where sell_buy =1 and trade.auctionpart=t1.auctionpart
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0),
   samt=isnull((select sum(tradeqty*marketrate) from trade where sell_buy =2 and trade.auctionpart=t1.auctionpart
 and trade.user_id=t1.user_id
 and trade.scrip_cd=t1.scrip_cd
 and trade.series=t1.series),0)
   
from trade t1
group by convert(char,sauda_date,103),auctionpart,user_id,scrip_cd,series,sell_buy

GO
