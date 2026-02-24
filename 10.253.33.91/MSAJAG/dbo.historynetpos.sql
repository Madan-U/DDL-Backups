-- Object: PROCEDURE dbo.historynetpos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.historynetpos    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.historynetpos    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.historynetpos    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.historynetpos    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.historynetpos    Script Date: 12/27/00 8:58:51 PM ******/

/****** Object:  Stored Procedure dbo.historynetpos    Script Date: 12/18/99 8:24:04 AM ******/
CREATE PROCEDURE historynetpos
(@date varchar(10),@user_id int)
 AS
select distinct Sdate=convert(varchar,sauda_date,103),MARKETTYPE,user_id,scrip_cd,series,
   pqty=isnull((select sum(tradeqty) from HISTORY where sell_buy =1 and HISTORY.MARKETTYPE=t1.MARKETTYPE
 and HISTORY.user_id=t1.user_id
 and HISTORY.scrip_cd=t1.scrip_cd
 and history.sell_buy = t1.sell_buy
 and HISTORY.series=t1.series),0),
   sqty=isnull((select sum(tradeqty) from HISTORY where sell_buy =2 and HISTORY.MARKETTYPE=t1.MARKETTYPE
 and HISTORY.user_id=t1.user_id
 and HISTORY.scrip_cd=t1.scrip_cd
 and history.sell_buy = t1.sell_buy
 and HISTORY.series=t1.series),0),
   pamt=isnull((select sum(tradeqty*marketrate) from HISTORY where sell_buy =1 and HISTORY.MARKETTYPE=t1.MARKETTYPE
 and HISTORY.user_id=t1.user_id
 and HISTORY.scrip_cd=t1.scrip_cd
 and history.sell_buy = t1.sell_buy
 and HISTORY.series=t1.series),0),
   samt=isnull((select sum(tradeqty*marketrate) from HISTORY where sell_buy =2 and HISTORY.MARKETTYPE=t1.MARKETTYPE
 and HISTORY.user_id=t1.user_id
 and HISTORY.scrip_cd=t1.scrip_cd
 and history.sell_buy = t1.sell_buy
 and HISTORY.series=t1.series),0)
   
from HISTORY t1 where t1.user_id = @user_id and convert(varchar,sauda_date,103) = @date
group by convert(varchar,sauda_date,103),MARKETTYPE,user_id,scrip_cd,series,sell_buy

GO
