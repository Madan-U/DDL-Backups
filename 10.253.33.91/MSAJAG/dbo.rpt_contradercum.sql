-- Object: PROCEDURE dbo.rpt_contradercum
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contradercum    Script Date: 04/21/2001 6:05:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_contradercum    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_contradercum    Script Date: 20-Mar-01 11:38:55 PM ******/

/*
written by neelambari on 26 mar 2001
*/

CREATE procedure rpt_contradercum 
@branch varchar(3),
@saudadate varchar(11)
as
If (select count(*) from trade where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	select   c1.trader ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from trade s , client1 c1 , client2 c2 ,branches br where 
	c1.cl_code=c2.cl_code and 
	br.branch_cd = @branch
	and br.short_name = c1.trader
	and s.party_code=c2.party_code
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by c1.trader ,sell_buy
	order by c1.trader ,sell_buy
end
else
If (select count(*) from settlement where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	select   c1.trader ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from settlement s , client1 c1 , client2 c2 ,branches br where 
	c1.cl_code=c2.cl_code and 
	br.branch_cd = @branch
	and br.short_name = c1.trader
	and s.party_code=c2.party_code
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by c1.trader ,sell_buy
	
union all
	select   c1.trader ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from history s , client1 c1 , client2 c2 ,branches br where 
	c1.cl_code=c2.cl_code and 
	br.branch_cd = @branch
	and br.short_name = c1.trader
	and s.party_code=c2.party_code
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by c1.trader ,sell_buy
	order by c1.trader ,sell_buy
end
else
begin
	select   c1.trader ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from history s , client1 c1 , client2 c2 ,branches br where 
	c1.cl_code=c2.cl_code and 
	br.branch_cd = @branch
	and br.short_name = c1.trader
	and s.party_code=c2.party_code
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by c1.trader ,sell_buy
	order by c1.trader ,sell_buy
end

GO
