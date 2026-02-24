-- Object: PROCEDURE dbo.rpt_contrtraderwisen
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrtraderwisen    Script Date: 04/21/2001 6:05:21 PM ******/

/*
written by neelambri on 29 mar 2001
this query gives us the details for aall traders for selected branch
*/
create procedure rpt_contrtraderwisen 
@branchcd varchar(3)
as
select qty = sum(o.qty-o.tradeqty),
o.sell_buy ,br.short_name
from orders o,branches br ,client1 c1 ,client2 c2
where c1.cl_code =c2.cl_code 
	and c1.trader = br.short_name
	and o.party_code =c2.party_code 
	and br.branch_cd = @branchcd
group by br.short_name ,o.sell_buy 
order by br.short_name ,o.sell_buy

GO
