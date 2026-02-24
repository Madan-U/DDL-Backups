-- Object: PROCEDURE dbo.rpt_congextrwises
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congextrwises    Script Date: 04/21/2001 6:05:20 PM ******/

/*this query chks if there is  data in trade*/
create procedure rpt_congextrwises as
select c1.trader , qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade t4,client1 c1,client2 c2 ,branches br
where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
group by c1.trader ,t4.sell_buy

GO
