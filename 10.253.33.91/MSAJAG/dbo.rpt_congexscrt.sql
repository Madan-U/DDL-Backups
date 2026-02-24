-- Object: PROCEDURE dbo.rpt_congexscrt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexscrt    Script Date: 04/21/2001 6:05:20 PM ******/

create procedure rpt_congexscrt as 
select t4.scrip_cd , qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade t4,client1 c1,client2 c2 ,branches br
where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
group by t4.scrip_cd ,t4.sell_buy 
order by  t4.scrip_cd ,t4.sell_buy

GO
