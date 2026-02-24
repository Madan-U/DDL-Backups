-- Object: PROCEDURE dbo.rpt_contrsubrkwisec
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrsubrkwisec    Script Date: 04/21/2001 6:05:21 PM ******/

/*
written by neelambari on 29 mar 2001
this query gives us the list of subrokers and their respective confirmed trades
*/
create procedure rpt_contrsubrkwisec as 
select qty = sum(t4.tradeqty),amount = sum(t4.tradeqty *t4.marketrate ),
t4.sell_buy ,sb.sub_broker
from trade4432 t4,subbrokers sb ,client1 c1 ,client2 c2
where c1.cl_code =c2.cl_code and c1.sub_broker = sb.sub_broker
and t4.party_code =c2.party_code 
group by sb.sub_broker ,t4.sell_buy 
order by sb.sub_broker ,t4.sell_buy

GO
