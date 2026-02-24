-- Object: PROCEDURE dbo.rpt_contrcltofsubrkn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrcltofsubrkn    Script Date: 04/21/2001 6:05:20 PM ******/

/*
this query gives us the list of clients for selected subbroekr
and their details for trades which are not confirmed 
*/
create procedure  rpt_contrcltofsubrkn
@subbroker varchar(10)
as
select qty =sum(o.qty-o.tradeqty),o.sell_buy,
c1.short_name ,c2.party_code
from orders o ,client1 c1 ,client2 c2 
where c1.cl_code =c2.cl_code 
and o.party_code =c2.party_code 
and c1.sub_broker= @subbroker
group by c2.party_code , c1.short_name ,o.sell_buy 
order by c2.party_code , c1.short_name ,o.sell_buy

GO
