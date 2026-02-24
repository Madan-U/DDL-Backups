-- Object: PROCEDURE dbo.rpt_congexsbrkwiset
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexsbrkwiset    Script Date: 04/21/2001 6:05:19 PM ******/

/* Written by Neelambari on 30 mar 2001*/

/*this query gives us gross exposure of each subbroker from trade*/

CREATE procedure  rpt_congexsbrkwiset as
	select c1.sub_broker, qty=sum(t.tradeqty),
	Amount=sum(t.tradeqty*t.marketrate),t.sell_buy 
	from trade t,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code  and
	c2.party_code = t.party_code 
	/*and series not in ('AE','BE','N1') */
	group by c1.sub_broker , t.sell_buy
	order by c1.sub_broker , t.sell_buy

GO
