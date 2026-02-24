-- Object: PROCEDURE dbo.Rpt_concltforselscripsubrk
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.Rpt_concltforselscripsubrk    Script Date: 04/21/2001 6:05:18 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_concltforselscripsubrk    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_concltforselscripsubrk    Script Date: 20-Mar-01 11:38:55 PM ******/

/*
Written by neelambari on 16 mar 2001
Modified by neelambari on 20 mar 2001
added condition for queries on trade or settlement or history
*/

CREATE PROCEDURE Rpt_concltforselscripsubrk
@scripcd varchar(10),
@saudadate varchar(11),
@subbroker varchar(20)
as
If (select count(*) from trade where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	SELECT   s.PARTY_CODE ,c1.short_name,s.sell_buy,qty=sum(tradeqty),amount= sum(tradeqty* marketrate)
	FROM trade s,client1 c1 ,client2 c2 ,subbrokers sb
	WHERE s.SCRIP_CD = @scripcd
	AND CONVERT(VARCHAR,SAUDA_DATE,103) = @saudadate
	and sb.sub_broker =@subbroker
	and c1.sub_broker = sb.sub_broker
	and c1.cl_code= c2.cl_code 
	and c2.party_code = s.party_code
	group by s.party_code,c1.short_name, sell_buy
	order by s.party_code, sell_buy 
end
else
If (select count(*) from settlement where convert(varchar,sauda_date,103) =@saudadate)>0 
begin
	SELECT  s.PARTY_CODE ,c1.short_name,s.sell_buy,qty=sum(tradeqty),amount= sum(tradeqty* marketrate)
	FROM settlement s,client1 c1 ,client2 c2 ,subbrokers sb
	WHERE s.SCRIP_CD = @scripcd
	AND CONVERT(VARCHAR,SAUDA_DATE,103) = @saudadate
	and sb.sub_broker =@subbroker
	and c1.sub_broker = sb.sub_broker
	and c1.cl_code= c2.cl_code 
	and c2.party_code = s.party_code
	group by s.party_code ,c1.short_name, sell_buy
	 
union all
	SELECT   s.PARTY_CODE ,c1.short_name,s.sell_buy,qty=sum(tradeqty),amount= sum(tradeqty* marketrate)
	FROM history s,client1 c1 ,client2 c2 ,subbrokers sb
	WHERE s.SCRIP_CD = @scripcd
	AND CONVERT(VARCHAR,SAUDA_DATE,103) = @saudadate
	and sb.sub_broker =@subbroker
	and c1.sub_broker = sb.sub_broker
	and c1.cl_code= c2.cl_code 
	and c2.party_code = s.party_code
	group by s.party_code,c1.short_name, sell_buy
	order by s.party_code, sell_buy 
end


else
begin

	SELECT   s.PARTY_CODE ,c1.short_name,s.sell_buy,qty=sum(tradeqty),amount= sum(tradeqty* marketrate)
	FROM history s,client1 c1 ,client2 c2 ,subbrokers sb
	WHERE s.SCRIP_CD = @scripcd
	AND CONVERT(VARCHAR,SAUDA_DATE,103) = @saudadate
	and sb.sub_broker =@subbroker
	and c1.sub_broker = sb.sub_broker
	and c1.cl_code= c2.cl_code 
	and c2.party_code = s.party_code
	group by s.party_code,c1.short_name, sell_buy
	order by s.party_code, sell_buy 
end

GO
