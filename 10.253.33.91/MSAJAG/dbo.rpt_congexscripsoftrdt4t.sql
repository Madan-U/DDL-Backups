-- Object: PROCEDURE dbo.rpt_congexscripsoftrdt4t
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexscripsoftrdt4t    Script Date: 04/21/2001 6:05:20 PM ******/

/*Written by neelambari on 30 mar 2001*/

/*this procedure gives us the list of all scrips from trade for selected trader*/
CREATE procedure rpt_congexscripsoftrdt4t
	@trader varchar(20)
	as
	select t4.Scrip_Cd , qty=sum(t4.tradeqty),
	Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from trade4432 t4,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t4.party_code 
	and c1.trader = @trader
	/*and series not in ('AE','BE','N1') */
	group by t4.scrip_cd, t4.sell_buy
	order by t4.scrip_cd, t4.sell_buy

GO
