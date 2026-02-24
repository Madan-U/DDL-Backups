-- Object: PROCEDURE dbo.rpt_congexcltsbdt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexcltsbdt    Script Date: 04/21/2001 6:05:19 PM ******/

/*
written by neelambari on  4 april 2001
This query chks if data is present in trade table
*/
create procedure rpt_congexcltsbdt as
select t4.party_code, qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade t4,client1 c1,client2 c2 ,subbrokers sb
where c2.party_code = t4.party_code 
and c1.cl_code = c2.cl_code 
and sb.sub_broker = c1.sub_broker
group by t4.party_code,t4.sell_buy 
order by  t4.party_code,t4.sell_buy

GO
