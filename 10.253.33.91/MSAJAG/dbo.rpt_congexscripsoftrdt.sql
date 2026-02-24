-- Object: PROCEDURE dbo.rpt_congexscripsoftrdt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexscripsoftrdt    Script Date: 04/21/2001 6:05:20 PM ******/

/*Written by neelambari on 30 mar 2001*/

/*this procedure gives us the list of all scrips from trade4432 for selected trader*/

CREATE procedure  rpt_congexscripsoftrdt
@trader varchar(20)
as
	select t.Scrip_Cd , qty=sum(t.tradeqty),
	Amount=sum(t.tradeqty*t.marketrate),t.sell_buy 
	from trade t,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t.party_code 
	and c1.trader = @trader
	/*and series not in ('AE','BE','N1') */
	group by  t.scrip_cd, t.sell_buy
	order by t.scrip_cd, t.sell_buy

GO
