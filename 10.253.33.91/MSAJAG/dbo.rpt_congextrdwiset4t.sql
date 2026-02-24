-- Object: PROCEDURE dbo.rpt_congextrdwiset4t
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congextrdwiset4t    Script Date: 04/21/2001 6:05:20 PM ******/

/*Written by neelambari on 30 mar 2001 */
/*This query gives us the list of traders and their trades from trade4432*/


CREATE procedure  rpt_congextrdwiset4t
	@branchcd varchar(3)
	as
	select c1.trader, qty=sum(t4.tradeqty),
	Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
	from trade4432 t4,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t4.party_code 
	and c1.branch_cd=@branchcd
	/*and series not in ('AE','BE','N1') */
	group by  c1.trader , t4.sell_buy
	order by  c1.trader , t4.sell_buy

GO
