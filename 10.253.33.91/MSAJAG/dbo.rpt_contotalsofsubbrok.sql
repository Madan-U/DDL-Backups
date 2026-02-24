-- Object: PROCEDURE dbo.rpt_contotalsofsubbrok
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_contotalsofsubbrok    Script Date: 04/21/2001 6:05:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_contotalsofsubbrok    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_contotalsofsubbrok    Script Date: 20-Mar-01 11:38:55 PM ******/


/*
created by neelamabri on 15 mar 2001
Modified by neelambari on 20 mar 2001
added condition for queries on trade or settlement or history
*/

CREATE procedure rpt_contotalsofsubbrok
@subbroker varchar(10),
@saudadate varchar(11)
as
If (select count(*) from trade where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	select   sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from trade s , client1 c1 , client2 c2 ,subbrokers sb where 
	c1.cl_code=c2.cl_code and 
	c1.sub_broker =sb.sub_broker
	and s.party_code=c2.party_code
	and sb.sub_broker=@subbroker
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by sell_buy
	order by sell_buy
end
else
If (select count(*) from settlement where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	
	select   sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from settlement s , client1 c1 , client2 c2 ,subbrokers sb where 
	c1.cl_code=c2.cl_code and 
	c1.sub_broker =sb.sub_broker
	and s.party_code=c2.party_code
	and sb.sub_broker=@subbroker
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by sell_buy
	union all
	select   sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from history s , client1 c1 , client2 c2 ,subbrokers sb where 
	c1.cl_code=c2.cl_code and 
	c1.sub_broker =sb.sub_broker
	and s.party_code=c2.party_code
	and sb.sub_broker=@subbroker
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by sell_buy
	order by sell_buy
end
else
begin
	select   sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
	from history s , client1 c1 , client2 c2 ,subbrokers sb where 
	c1.cl_code=c2.cl_code and 
	c1.sub_broker =sb.sub_broker
	and s.party_code=c2.party_code
	and sb.sub_broker=@subbroker
	and convert(varchar,s.sauda_date,103) = @saudadate
	group by sell_buy
	order by sell_buy
end

GO
