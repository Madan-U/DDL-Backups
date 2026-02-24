-- Object: PROCEDURE dbo.confirmationHasp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.confirmationHasp    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.confirmationHasp    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.confirmationHasp    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.confirmationHasp    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.confirmationHasp    Script Date: 12/27/00 8:58:48 PM ******/

CREATE procedure confirmationHasp (@party varchar(10),@partyname varchar(25), @Trader varchar(20), @sdate varchar(10)) as
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,   c.Sell_buy
, c.Sell_buy, c.other_chrg, c.sebi_tax,c.broker_chrg,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE'
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like @trader 
and c.party_code like @party
and c.short_name like @partyname
and convert(varchar,c.sauda_date,1) like @sdate
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
and trader like @trader 
and s.party_code like @party
and c1.short_name like @partyname
and convert(varchar,s.sauda_date,1) like @sdate
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
and trader like @trader 
and s.party_code like @party
and c1.short_name like @partyname
and convert(varchar,s.sauda_date,1) like @sdate
order by  c.Party_Code,c.short_name,c.Scrip_Cd

GO
