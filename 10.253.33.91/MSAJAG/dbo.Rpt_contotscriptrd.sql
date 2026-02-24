-- Object: PROCEDURE dbo.Rpt_contotscriptrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.Rpt_contotscriptrd    Script Date: 04/21/2001 6:05:20 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_contotscriptrd    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_contotscriptrd    Script Date: 20-Mar-01 11:38:55 PM ******/


/*
created by neelamabri on 15 mar 2001
Modified by neelambari on 20 mar 2001
added condition for queries on trade or settlement or history
*/

CREATE procedure Rpt_contotscriptrd
@trader varchar(10),
@saudadate varchar(11),
@scripcd varchar(20)
 as 

If (select count(*) from trade where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	select  s.sell_buy , qty=sum(s.tradeqty), amount=sum(s.tradeqty*s.marketrate)
	 from  trade s ,client1 c1,client2 c2,branches br
	where
	c1.trader=br.short_name and
	c1.cl_code =c2.cl_code and
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103)=@saudadate
	and c1.trader=@trader
	and s.scrip_cd= @scripcd
	group by s.scrip_cd ,s.sell_buy
	order by s.scrip_cd ,s.sell_buy
end
else
If (select count(*) from settlement where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	select  s.sell_buy , qty=sum(s.tradeqty), amount=sum(s.tradeqty*s.marketrate)
	 from  settlement s ,client1 c1,client2 c2,branches br
	where
	c1.trader=br.short_name and
	c1.cl_code =c2.cl_code and
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103)=@saudadate
	and c1.trader=@trader
	and s.scrip_cd= @scripcd
	group by s.sell_buy
	union all
	select  s.sell_buy , qty=sum(s.tradeqty), amount=sum(s.tradeqty*s.marketrate)
	 from  history s ,client1 c1,client2 c2,branches br
	where
	c1.trader=br.short_name and
	c1.cl_code =c2.cl_code and
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103)=@saudadate
	and c1.trader=@trader
	and s.scrip_cd= @scripcd
	group by  s.sell_buy
	order by  s.sell_buy
end
else
begin
	select  s.sell_buy , qty=sum(s.tradeqty), amount=sum(s.tradeqty*s.marketrate)
	 from  history s ,client1 c1,client2 c2,branches br
	where
	c1.trader=br.short_name and
	c1.cl_code =c2.cl_code and
	c2.party_code = s.party_code and 
	convert(varchar,s.sauda_date,103)=@saudadate
	and c1.trader=@trader
	and s.scrip_cd= @scripcd
	group by s.scrip_cd ,s.sell_buy
	order by s.scrip_cd ,s.sell_buy
end

GO
