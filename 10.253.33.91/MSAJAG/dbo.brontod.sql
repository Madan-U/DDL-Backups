-- Object: PROCEDURE dbo.brontod
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brontod    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brontod    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brontod    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brontod    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brontod    Script Date: 12/27/00 8:58:45 PM ******/

CREATE PROCEDURE brontod
@br varchar(3),
@party varchar(10)
AS
select c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,
o.sell_buy,(o.qty-o.tradeqty),o.user_id,o.EffRate,o.OrderRate,qty,tradeqty,OrderTime 
from orders o,client1 c1,client2 c2, branches b 
where c2.party_code = o.party_code 
and c1.cl_code = c2.cl_code 
and o.party_code = @party
and b.short_name = c1.trader
and b.branch_cd = @br
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime

GO
