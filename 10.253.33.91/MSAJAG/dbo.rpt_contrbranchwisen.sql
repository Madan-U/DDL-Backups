-- Object: PROCEDURE dbo.rpt_contrbranchwisen
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrbranchwisen    Script Date: 04/21/2001 6:05:20 PM ******/

/*
written by neelambari on 27 mar 2001
This query gives us branchwise qty according to sell or buy which are not confirmed
*/

CREATE procedure rpt_contrbranchwisen 
as
select qty = sum(o.qty-o.tradeqty), o.sell_buy ,br.branch_cd
from orders o,branches br ,client1 c1 ,client2 c2
where 	c1.cl_code =c2.cl_code
	and c1.trader = br.short_name 
	and o.party_code =c2.party_code
group by br.branch_cd ,o.sell_buy
order by br.branch_cd ,o.sell_buy

GO
