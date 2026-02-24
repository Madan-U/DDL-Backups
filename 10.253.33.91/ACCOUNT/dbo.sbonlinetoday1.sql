-- Object: PROCEDURE dbo.sbonlinetoday1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE 
sbonlinetoday1
@id varchar(10),
@subbroker varchar(15)
AS
select c1.short_name,o.order_no,
o.party_code ,o.scrip_cd,o.series,
o.sell_buy,(o.qty-o.tradeqty),o.user_id,
o.EffRate,o.OrderRate,qty,tradeqty,OrderTime
from orders o,client1 c1,client2 c2 ,subbrokers sb 
 where c2.party_code = o.party_code and 
 c1.cl_code = c2.cl_code
 and o.party_code = @id and sb.sub_broker=@subbroker and c1.sub_broker=sb.sub_broker
 order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime

GO
