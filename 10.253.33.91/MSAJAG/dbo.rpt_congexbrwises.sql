-- Object: PROCEDURE dbo.rpt_congexbrwises
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexbrwises    Script Date: 04/21/2001 6:05:19 PM ******/

create procedure rpt_congexbrwises
as
select br.branch_cd , qty=sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade t4,client1 c1,client2 c2 ,branches br
where c2.party_code = t4.party_code 
	and c1.cl_code = c2.cl_code 
	and br.short_name = c1.Trader
group by br.branch_cd,t4.sell_buy

GO
