-- Object: PROCEDURE dbo.rpt_netposition
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_netposition    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netposition    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netposition    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netposition    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netposition    Script Date: 12/27/00 8:58:56 PM ******/

CREATE PROCEDURE rpt_netposition
AS
select distinct USER_ID , pqty=isnull((select sum(tradeqty) 
from trade4432 
where sell_buy =1 AND trade4432.user_id=t1.user_id),0), 
sqty=isnull((select sum(tradeqty) from trade4432 where sell_buy =2 AND trade4432.user_id=t1.user_id),0), 
pamt=isnull((select sum(tradeqty*marketrate) from trade4432 where sell_buy =1 AND trade4432.user_id=t1.user_id ),0), 
samt=isnull((select sum(tradeqty*marketrate) from trade4432 where sell_buy =2 AND trade4432.user_id=t1.user_id ),0), 
NetAmt= isnull((select sum(tradeqty*marketrate) from trade4432 where sell_buy =2 AND trade4432.user_id=t1.user_id ),0) - isnull((select sum(tradeqty*marketrate) 
from trade4432 where sell_buy =1 AND trade4432.user_id=t1.user_id ),0) 
From trade4432 t1 
group by USER_ID

GO
