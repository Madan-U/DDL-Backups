-- Object: PROCEDURE dbo.rpt_contrbranchwisec
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contrbranchwisec    Script Date: 04/21/2001 6:05:20 PM ******/

/*
written by neelambari on 27 mar 2001
This query gives us branchwise qty according to sell or buy which are not confirmed
*/


CREATE procedure  rpt_contrbranchwisec 
as
select qty = sum(t4.tradeqty) ,amount = sum(t4.tradeqty * t4.marketrate),
 t4.sell_buy ,br.branch_cd
from trade4432 t4,branches br ,client1 c1 ,client2 c2
where c1.cl_code =c2.cl_code
	and c1.trader = br.short_name 
	and t4.party_code =c2.party_code
group by br.branch_cd ,t4.sell_buy
order by br.branch_cd ,t4.sell_buy

GO
