-- Object: PROCEDURE dbo.brshortname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brshortname    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brshortname    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brshortname    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brshortname    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brshortname    Script Date: 12/27/00 8:58:46 PM ******/

/*  Report : management info
     File : todaysreport.asp
displays trade not confirmed for a particular client
*/
CREATE PROCEDURE brshortname
@shortname varchar(21),
@scripcd varchar(10),
@partycode varchar(10),
@series varchar(3)
AS
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,
(o.qty-o.tradeqty),o.user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime 
from orders o,client1 c1,client2 c2
where c2.party_code = o.party_code 
and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@shortname)+'%' 
and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
and o.series like ltrim(@series)+'%'
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime

GO
