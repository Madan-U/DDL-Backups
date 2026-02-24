-- Object: PROCEDURE dbo.sbonlinetoday1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday1    Script Date: 12/27/00 8:59:01 PM ******/

/** file : todays report1.asp
report : online trading   
displays orders placed by particular client
***/
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
