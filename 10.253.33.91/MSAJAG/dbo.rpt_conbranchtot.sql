-- Object: PROCEDURE dbo.rpt_conbranchtot
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conbranchtot    Script Date: 04/21/2001 6:05:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_conbranchtot    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_conbranchtot    Script Date: 20-Mar-01 11:38:55 PM ******/

/*
created by neelamabri on 14 mar 2001
Modified by neelambari on 20 mar 2001
added condition for queries on trade or settlement or history
*/
CREATE procedure rpt_conbranchtot
 @saudadate varchar(11)  as
/*check if data present in trade*/
If (select count(*) from trade where convert(varchar,sauda_date,103) =@saudadate)>0 
	begin
		select  br.branch_cd ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
		from trade s , client1 c1 , client2 c2 , branches br where 
		c1.cl_code=c2.cl_code and 
		c1.trader=br.short_name
		and s.party_code=c2.party_code
		and convert(varchar,s.sauda_date,103) =@saudadate
		group by  br.branch_cd ,sell_buy
		order by br.branch_cd,sell_buy
	end

else /*if data not found in trade then check in settlement and if present in settlement then part below is executed*/
	If (select count(*) from settlement where convert(varchar,sauda_date,103) =@saudadate)>0 
	begin
		select  br.branch_cd ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
		from settlement s , client1 c1 , client2 c2 , branches br where 
		c1.cl_code=c2.cl_code and 
		c1.trader=br.short_name
		and s.party_code=c2.party_code
		and convert(varchar,s.sauda_date,103) =@saudadate
		group by  br.branch_cd ,sell_buy
		 
		union all
		select  br.branch_cd ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
		from history s , client1 c1 , client2 c2 , branches br where 
		c1.cl_code=c2.cl_code and 
		c1.trader=br.short_name
		and s.party_code=c2.party_code
		and convert(varchar,s.sauda_date,103) =@saudadate
		group by  br.branch_cd ,sell_buy
		order by br.branch_cd,sell_buy

	endelse/*if data not present in trade or settlement then */
	begin
		select  br.branch_cd ,sell_buy ,qty=sum(tradeqty), amount= sum(marketrate*tradeqty)
		from history s , client1 c1 , client2 c2 , branches br where 
		c1.cl_code=c2.cl_code and 
		c1.trader=br.short_name
		and s.party_code=c2.party_code
		and convert(varchar,s.sauda_date,103) =@saudadate
		group by  br.branch_cd ,sell_buy
		order by br.branch_cd,sell_buy
	end

GO
