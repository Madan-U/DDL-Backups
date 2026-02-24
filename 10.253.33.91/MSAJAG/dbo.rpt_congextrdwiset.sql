-- Object: PROCEDURE dbo.rpt_congextrdwiset
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_congextrdwiset    Script Date: 04/21/2001 6:05:20 PM ******/

/* Written by Neelambari on 30 mar 2001*/

/*this query gives us gross exposure of each trader from trade*/

CREATE procedure  rpt_congextrdwiset
	@branchcd varchar(3)
	as
	select c1.trader, qty=sum(t.tradeqty),
	Amount=sum(t.tradeqty*t.marketrate),t.sell_buy 
	from trade t,client1 c1,client2 c2 
	where 
	c1.cl_code    = c2.cl_code and 
	c2.party_code = t.party_code 
	and c1.branch_cd=@branchcd
	/*and series not in ('AE','BE','N1') */
	group by  c1.trader , t.sell_buy
	order by c1.trader , t.sell_buy

GO
