-- Object: PROCEDURE dbo.rpt_congexpcltlstofsbrkt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congexpcltlstofsbrkt    Script Date: 04/21/2001 6:05:19 PM ******/

/*Written by neelambari on 31 mar 2001*/


/*This procedure gives us the list of clients of selected subbroker*/

CREATE procedure rpt_congexpcltlstofsbrkt
@subbroker varchar(10)
as
	select c2.party_code,c1.short_name, qty=sum(t.tradeqty),
	Amount=sum(t.tradeqty*t.marketrate),t.sell_buy 
	from trade t,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t.party_code 
	and c1.sub_broker = @subbroker
	/*and series not in ('AE','BE','N1') */
	group by  c2.party_code,c1.short_name, t.sell_buy
	order by c2.party_code,c1.short_name, t.sell_buy

GO
