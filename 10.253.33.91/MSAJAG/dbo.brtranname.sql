-- Object: PROCEDURE dbo.brtranname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtranname    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtranname    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.brtranname    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brtranname    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.brtranname    Script Date: 12/27/00 8:58:46 PM ******/

CREATE PROCEDURE brtranname
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(10)
AS
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,
o.sell_buy,(o.qty-o.tradeqty),o.user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime 
from orders o,client1 c1,client2 c2
where c2.party_code = o.party_code and  
c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and o.scrip_cd like ltrim(@scripcd)+'%' 
and o.party_code like ltrim(@partycode)+'%'  
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime

GO
