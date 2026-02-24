-- Object: PROCEDURE dbo.rpt_congexsbrkwiset4t
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexsbrkwiset4t    Script Date: 04/21/2001 6:05:19 PM ******/

/*Written by neelambari on 31 mar 2001 */
/*This query gives us the list of subbrokers and their trades from trade4432*/


CREATE procedure  rpt_congexsbrkwiset4t
	as
	select c1.sub_broker, qty=sum(t4.tradeqty),
	Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from trade4432 t4,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t4.party_code 
	/*and series not in ('AE','BE','N1') */
	group by  c1.sub_broker , t4.sell_buy
	order by  c1.sub_broker , t4.sell_buy

GO
