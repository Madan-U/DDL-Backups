-- Object: PROCEDURE dbo.rpt_congexpcltlstoftrdt4t
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexpcltlstoftrdt4t    Script Date: 04/21/2001 6:05:19 PM ******/

/*Writen by neelambari on 30 mar 2001*/

/*This gives us list of clients for selecterd trader  from trade4432  */


CREATE procedure rpt_congexpcltlstoftrdt4t
	@trader varchar(20)
	as
	select c2.party_code,c1.short_name, qty=sum(t4.tradeqty),
	Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from trade4432 t4,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t4.party_code 
	and c1.trader = @trader
	/*and series not in ('AE','BE','N1') */
	group by  c2.party_code,c1.short_name, t4.sell_buy
	order by  c2.party_code,c1.short_name, t4.sell_buy

GO
