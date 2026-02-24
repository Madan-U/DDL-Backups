-- Object: PROCEDURE dbo.sbtrantodayrep1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtrantodayrep1    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep1    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep1    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep1    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep1    Script Date: 12/27/00 8:59:02 PM ******/

/*** file : transaction main ,todaysreports.asp
     report :client transaction 
displays trades not confirmed for a client
***/ 
CREATE PROCEDURE
sbtrantodayrep1
@subbroker varchar(15),
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(10)
 AS
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,
(o.qty-o.tradeqty),o.user_id,o.EffRate,o.OrderRate,qty,o.tradeqty,OrderTime 
from orders o,client1 c1,client2 c2,subbrokers sb
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and c1.short_name like ltrim(@partyname)+'%' and o.scrip_cd like  ltrim(@scripcd)+ '%' and o.party_code like ltrim(@partycode)+'%' 
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime

GO
