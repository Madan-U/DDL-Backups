-- Object: PROCEDURE dbo.rpt_conclientlistofsubbroker
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conclientlistofsubbroker    Script Date: 04/21/2001 6:05:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_conclientlistofsubbroker    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_conclientlistofsubbroker    Script Date: 20-Mar-01 11:38:55 PM ******/

/*
Written by neelambari on 15 mar 2001
Modified by neelambari on 20 mar 2001
added condition for queries on trade or settlement or history
*/

CREATE procedure rpt_conclientlistofsubbroker
@saudadate varchar(11),
@subbroker varchar(10)
as
If (select count(*) from trade where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	SELECT   c1.short_name,s.party_code,qty=sum(tradeqty),amount=sum(marketrate*tradeqty),sell_buy   
	from client2 c2 ,client1 c1 ,trade s  
	where c1.cl_code=c2.cl_code and 
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103) = @saudadate
	and c1.sub_broker =@subbroker
	group by s.party_code,c1.short_name ,sell_buy 
	order by s.party_code ,c1.short_name
end
else
If (select count(*) from settlement where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	SELECT   c1.short_name,s.party_code,qty=sum(tradeqty),amount=sum(marketrate*tradeqty),sell_buy   
	from client2 c2 ,client1 c1 , settlement s  
	where c1.cl_code=c2.cl_code and 
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103) = @saudadate
	and c1.sub_broker =@subbroker
	group by s.party_code ,c1.short_name,sell_buy 
	union all
	SELECT   c1.short_name,s.party_code,qty=sum(tradeqty),amount=sum(marketrate*tradeqty),sell_buy   
	from client2 c2 ,client1 c1 , history s  
	where c1.cl_code=c2.cl_code and 
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103) = @saudadate
	and c1.sub_broker =@subbroker
	group by s.party_code ,c1.short_name ,sell_buy
	order by s.party_code ,c1.short_name
end

else
begin
	SELECT distinct c1.short_name,s.party_code,qty=sum(tradeqty),amount=sum(marketrate*tradeqty),sell_buy   
	from client2 c2 ,client1 c1 , history s  
	where c1.cl_code=c2.cl_code and 
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103) = @saudadate
	and c1.sub_broker =@subbroker
	group by s.party_code ,c1.short_name ,sell_buy  

	order by s.party_code ,c1.short_name
end

GO
