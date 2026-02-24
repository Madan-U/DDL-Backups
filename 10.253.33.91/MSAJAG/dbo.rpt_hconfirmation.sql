-- Object: PROCEDURE dbo.rpt_hconfirmation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_hconfirmation    Script Date: 04/27/2001 4:32:42 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hconfirmation    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hconfirmation    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hconfirmation    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hconfirmation    Script Date: 12/27/00 8:58:54 PM ******/

/* report : confirmation report 
   file : hconfirmation
 */
/* displays confirmation of a client or clients as on a particular date*/
CREATE PROCEDURE rpt_hconfirmation
@statusid varchar(15),
@statusname varchar(25),
@trader varchar(15),
@partycode varchar(10),
@partyname varchar(21),
@sdate varchar(10)
AS
if @statusid = 'broker' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE'
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like ltrim(@trader)+'%'
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,101) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader like ltrim(@trader)+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from history s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader like ltrim(@trader )+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end
if @statusid = 'branch' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE'
from Confirmview c,client1 c1,client2 c2  , branches b
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like ltrim(@trader)+'%'
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,101) like ltrim(@sdate)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from settlement s, client1 c1, client2 c2, taxes t, globals g,  branches b
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader like ltrim(@trader)+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from history s, client1 c1, client2 c2, taxes t, globals g, branches b
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader like ltrim(@trader )+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end
if @statusid = 'trader' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE'
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader =@statusname
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,101) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader =@statusname
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from history s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader =@statusname
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end 
if @statusid = 'subbroker' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE'
from Confirmview c,client1 c1,client2 c2  ,subbrokers sb
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like ltrim(@trader)+'%'
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,101) like ltrim(@sdate)+'%'
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from settlement s, client1 c1, client2 c2, taxes t, globals g  ,subbrokers sb
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader like ltrim(@trader)+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from history s, client1 c1, client2 c2, taxes t, globals g  ,subbrokers sb
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader like ltrim(@trader )+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end 
if @statusid = 'client' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE'
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and c.party_code =@statusname
and convert(varchar,c.sauda_date,101) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and s.party_code =@statusname
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from history s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and s.party_code =@statusname
and convert(varchar,s.sauda_date,101) like ltrim(@sdate)+'%'
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end

GO
