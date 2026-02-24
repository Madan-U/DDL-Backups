-- Object: PROCEDURE dbo.brnet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brnet    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : Netposition trader
    File : netpostraderid.asp
*/
CREATE PROCEDURE brnet
@br varchar(3)
AS
select distinct USER_ID , pqty=isnull((select sum(tradeqty) 
from trade4432 
where sell_buy =1 AND trade4432.user_id=t1.user_id),0), 
sqty=isnull((select sum(tradeqty) from trade4432 where sell_buy =2 AND trade4432.
user_id=t1.user_id),0), 
pamt=isnull((select sum(tradeqty*marketrate) from trade4432 
where sell_buy =1 AND trade4432.user_id=t1.user_id ),0), 
samt=isnull((select sum(tradeqty*marketrate) from trade4432 
where sell_buy =2 AND trade4432.user_id=t1.user_id ),0), 
NetAmt= isnull((select sum(tradeqty*marketrate) from trade4432 
where sell_buy =2 AND trade4432.user_id=t1.user_id ),0) - 
isnull((select sum(tradeqty*marketrate) from trade4432 
where sell_buy =1 AND trade4432.user_id=t1.user_id ),0) 
From trade4432 t1, client1 c1, client2 c2, branches b
where c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
group by USER_ID

GO
