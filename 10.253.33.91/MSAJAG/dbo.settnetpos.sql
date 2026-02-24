-- Object: PROCEDURE dbo.settnetpos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.settnetpos    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.settnetpos    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.settnetpos    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.settnetpos    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.settnetpos    Script Date: 12/27/00 8:59:03 PM ******/

/****** Object:  Stored Procedure dbo.settnetpos    Script Date: 12/18/99 8:24:05 AM ******/
CREATE PROCEDURE settnetpos 
(@date varchar(10),@user_id int)
AS
select distinct Sdate=convert(varchar,sauda_date,103),MARKETTYPE,user_id,scrip_cd,series,
   pqty=isnull((select sum(tradeqty) from SETTLEMENT where sell_buy =1 and SETTLEMENT.MARKETTYPE=t1.MARKETTYPE
 and SETTLEMENT.user_id=t1.user_id
 and SETTLEMENT.scrip_cd=t1.scrip_cd
 and SETTLEMENT.sell_buy = t1.sell_buy
 and SETTLEMENT.series=t1.series),0),
   sqty=isnull((select sum(tradeqty) from SETTLEMENT where sell_buy =2 and SETTLEMENT.MARKETTYPE=t1.MARKETTYPE
 and SETTLEMENT.user_id=t1.user_id
 and SETTLEMENT.scrip_cd=t1.scrip_cd
 and SETTLEMENT.sell_buy = t1.sell_buy
 and SETTLEMENT.series=t1.series),0),
   pamt=isnull((select sum(tradeqty*marketrate) from SETTLEMENT where sell_buy =1 and SETTLEMENT.MARKETTYPE=t1.MARKETTYPE
 and SETTLEMENT.user_id=t1.user_id
 and SETTLEMENT.scrip_cd=t1.scrip_cd
 and SETTLEMENT.sell_buy = t1.sell_buy
 and SETTLEMENT.series=t1.series),0),
   samt=isnull((select sum(tradeqty*marketrate) from SETTLEMENT where sell_buy =2 and SETTLEMENT.MARKETTYPE=t1.MARKETTYPE
 and SETTLEMENT.user_id=t1.user_id
 and SETTLEMENT.scrip_cd=t1.scrip_cd
 and SETTLEMENT.sell_buy = t1.sell_buy
 and SETTLEMENT.series=t1.series),0)
   
from SETTLEMENT t1 where t1.user_id = @user_id and convert(varchar,sauda_date,103) = @date
group by convert(varchar,sauda_date,103),MARKETTYPE,user_id,scrip_cd,series,sell_buy

GO
