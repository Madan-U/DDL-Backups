-- Object: PROCEDURE dbo.rpt_hconfirmation1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_hconfirmation1    Script Date: 2/17/01 5:19:49 PM ******/


/****** Object:  Stored Procedure dbo.rpt_hconfirmation1    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_hconfirmation1    Script Date: 20-Mar-01 11:38:58 PM ******/





/****** Object:  Stored Procedure dbo.rpt_hconfirmation1    Script Date: 12/27/00 8:58:54 PM ******/
/* report : confirmation report 
   file : hconfirmation
 */

/* changed by mousami on  6june 2001
     added one more condition that client2's tran_cat should match with taxes trans_Cat
     and removed harcoding for t.trans_cat ='del' as per animesh's suggestion
*/

/* displays confirmation of a client or clients as on a particular date*/
/* changed by mousami on 16/02/2001
     in first part of union (i.e confirmview changed to nsertax = c.marketrate  from nsertax=c.sertax because in settlement and history selection 
     nsertax field is used corresponding to this field. sertax field from confirmview is of  money 5 and nsertax from settlement or history is of
    8  so overflow error comes. so replace with marketrate column. Though both columns contains different value just to make equal number
   of columns in selection used marketrate in confirmview and this figure is never used in report. */


CREATE PROCEDURE rpt_hconfirmation1
@statusid varchar(15),
@statusname varchar(25),
@trader varchar(15),
@partycode varchar(10),
@partyname varchar(21),
@sdate varchar(12)
AS

if @statusid = 'broker' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE', nsertax=(c.MarketRate), /* see exp above */ src='cview',c2.service_chrg
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like ltrim(@trader)+'%'
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader)+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 

union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from history s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader )+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end

if @statusid = 'branch' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE',nsertax=(c.MarketRate), src='cview',c2.service_chrg
from Confirmview c,client1 c1,client2 c2  , branches b
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like ltrim(@trader)+'%'
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
and b.branch_cd=@statusname and b.short_name=c1.trader
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from settlement s, client1 c1, client2 c2, taxes t, globals g,  branches b
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader)+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
and b.branch_cd=@statusname and b.short_name=c1.trader
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from history s, client1 c1, client2 c2, taxes t, globals g, branches b
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader )+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
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
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE',nsertax=(c.MarketRate), src='cview',c2.service_chrg
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader =@statusname
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader =@statusname
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from history s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader =@statusname
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end 
if @statusid = 'subbroker' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE',nsertax=(c.MarketRate), src='cview',c2.service_chrg
from Confirmview c,client1 c1,client2 c2  ,subbrokers sb
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like ltrim(@trader)+'%'
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from settlement s, client1 c1, client2 c2, taxes t, globals g  ,subbrokers sb
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader)+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from history s, client1 c1, client2 c2, taxes t, globals g  ,subbrokers sb
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader )+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
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
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE',nsertax=(c.MarketRate), src='cview',c2.service_chrg
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and c.party_code =@statusname
and convert(varchar,c.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and s.party_code =@statusname
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from history s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and s.party_code =@statusname
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end 

if @statusid = 'family' 
begin
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE',nsertax=(c.MarketRate), src='cview',c2.service_chrg
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like ltrim(@trader)+'%'
and c.party_code like ltrim(@partycode)+'%'
and c.short_name like ltrim(@partyname)+'%'
and convert(varchar,c.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
and c1.family=@statusname
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange, s.Sell_buy
, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' /* and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader)+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
and c1.family=@statusname
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
 s.Sell_buy, s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE',nsertax=(s.nsertax),src='sett', c2.service_chrg
from history s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE'  /*and t.Trans_cat = 'TRD'*/
and c2.tran_cat=t.trans_cat
and g.Exchange ='NSE' 
and trader like ltrim(@trader )+'%'
and s.party_code like ltrim(@partycode)+'%'
and c1.short_name like ltrim(@partyname)+'%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+'%' and tradeqty > 0 
and c1.family=@statusname
order by  c.Party_Code,c.short_name,c.Scrip_Cd
end

GO
