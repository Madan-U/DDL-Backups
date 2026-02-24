-- Object: PROCEDURE dbo.rpt_congexsbrkwisesw
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexsbrkwisesw    Script Date: 04/21/2001 6:05:19 PM ******/

/*this query chks if there is  data in trade for subbrokers*/
create procedure rpt_congexsbrkwisesw as
select c1.sub_broker , qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade t4,client1 c1,client2 c2 ,subbrokers sb
where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and sb.sub_broker = c1.sub_broker
group by c1.sub_broker ,t4.sell_buy

GO
