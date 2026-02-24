-- Object: PROCEDURE dbo.brnet
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brnet    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brnet    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brnet    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brnet    Script Date: 20-Mar-01 11:43:32 PM ******/

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
