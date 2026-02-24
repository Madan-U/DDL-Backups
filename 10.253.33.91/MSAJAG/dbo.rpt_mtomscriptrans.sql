-- Object: PROCEDURE dbo.rpt_mtomscriptrans
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomscriptrans    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomscriptrans    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomscriptrans    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomscriptrans    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomscriptrans    Script Date: 12/27/00 8:58:56 PM ******/

/* Report : mtom
   File : scriptrans
*/
CREATE PROCEDURE rpt_mtomscriptrans
@statusid varchar(15),
@statusname varchar(25),
@code varchar(10),
@scripname varchar(15),
@series varchar(3)
AS
if @statusid  = 'broker'
begin
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,MarketRate,Sell_buy,
Sauda_date,User_id 
from settlement 
where  party_code = @code and sett_type = 'N' and billno =0
and Scrip_Cd = @scripname and series = @series
order by sett_no,sett_type,party_code,Scrip_Cd,series,Sauda_date,Sell_buy,tradeqty,
MarketRate,User_id 
end
if @statusid = 'subbroker'
begin
select s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.tradeqty,s.MarketRate, s.Sell_buy,
Sauda_date,User_id 
from settlement s, client1 c1, subbrokers sb, client2 c2
where  s.party_code = @code and sett_type = 'N' and billno =0
and Scrip_Cd = @scripname and series = @series 
and c1.cl_code = c2.cl_code and c2.party_code = s.party_code
and sb.sub_broker = @statusname and sb.sub_broker = c1.sub_broker
order by s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.Sauda_date,s.Sell_buy,s.tradeqty, s.MarketRate,User_id 
end
if @statusid = 'branch'
begin
select s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.tradeqty,s.MarketRate, s.Sell_buy,
Sauda_date,User_id 
from settlement s, client1 c1, branches b, client2 c2
where  s.party_code = @code and sett_type = 'N' and billno =0
and Scrip_Cd = @scripname and series = @series 
and c1.cl_code = c2.cl_code and c2.party_code = s.party_code
and b.branch_cd = @statusname and b.short_name = c1.trader
order by s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.Sauda_date,s.Sell_buy,s.tradeqty, s.MarketRate,User_id 
end
if @statusid = 'client'
begin
select s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.tradeqty,s.MarketRate, s.Sell_buy,
Sauda_date,User_id 
from settlement s, client1 c1, client2 c2
where  s.party_code = @statusname and sett_type = 'N' and billno =0
and Scrip_Cd = @scripname and series = @series 
and c1.cl_code = c2.cl_code and c2.party_code = s.party_code
order by s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.Sauda_date,s.Sell_buy,s.tradeqty, s.MarketRate,User_id 
end
if @statusid = 'trader'
begin
select s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.tradeqty,s.MarketRate, s.Sell_buy,
Sauda_date,User_id 
from settlement s, client1 c1, client2 c2
where  s.party_code = @code and sett_type = 'N' and billno =0
and Scrip_Cd = @scripname and series = @series
and c1.cl_code = c2.cl_code and c2.party_code = s.party_code
and c1.trader = @statusname
order by s.sett_no, s.sett_type, s.party_code,s.Scrip_Cd,s.series,
s.Sauda_date,s.Sell_buy,s.tradeqty, s.MarketRate,User_id 
end

GO
