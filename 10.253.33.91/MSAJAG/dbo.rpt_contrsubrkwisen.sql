-- Object: PROCEDURE dbo.rpt_contrsubrkwisen
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrsubrkwisen    Script Date: 04/21/2001 6:05:21 PM ******/

/*
written by neelambari on 29 mar 2001
this query gives us the list of subrokers and their respective not confirmed trades
*/
create procedure rpt_contrsubrkwisen as 
select qty = sum(o.qty-o.tradeqty),
o.sell_buy ,sb.sub_broker
from orders o,subbrokers sb ,client1 c1 ,client2 c2
where c1.cl_code =c2.cl_code and c1.sub_broker = sb.sub_broker
and o.party_code =c2.party_code 
group by sb.sub_broker ,o.sell_buy 
order by sb.sub_broker ,o.sell_buy

GO
