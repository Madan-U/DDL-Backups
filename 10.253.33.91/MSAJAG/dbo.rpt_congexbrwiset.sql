-- Object: PROCEDURE dbo.rpt_congexbrwiset
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexbrwiset    Script Date: 04/21/2001 6:05:19 PM ******/

/*
Written by Neelambari on 31 mar 2001
*/

/*this procedure gives us cumulative gross exposure of branch from trade table*/
CREATE procedure rpt_congexbrwiset as
select c1.branch_cd  , qty=sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 ,branches br
where 
c1.cl_code    = c2.cl_code and 
c2.party_code = t4.party_code 
and br.short_name  = c1.trader
/*and series not in ('AE','BE','N1') */
group by  c1.branch_cd,t4.sell_buy
order by c1.branch_cd,t4.sell_buy

GO
