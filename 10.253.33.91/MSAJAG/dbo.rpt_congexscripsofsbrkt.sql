-- Object: PROCEDURE dbo.rpt_congexscripsofsbrkt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexscripsofsbrkt    Script Date: 04/21/2001 6:05:20 PM ******/

/*Written by neelambari on 30 mar 2001*/

/*this procedure gives us the list of all scrips from trade4432 for selected subbroker*/

CREATE procedure  rpt_congexscripsofsbrkt
@subbroker varchar(10)
as
	select t.Scrip_Cd , qty=sum(t.tradeqty),
	Amount=sum(t.tradeqty*t.marketrate),t.sell_buy 
	from trade t,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t.party_code 
	and c1.sub_broker = @subbroker
	/*and series not in ('AE','BE','N1') */
	group by  t.scrip_cd, t.sell_buy
	order by t.scrip_cd, t.sell_buy

GO
