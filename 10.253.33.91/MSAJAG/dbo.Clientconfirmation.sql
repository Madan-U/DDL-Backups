-- Object: PROCEDURE dbo.Clientconfirmation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Clientconfirmation    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.Clientconfirmation    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.Clientconfirmation    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.Clientconfirmation    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.Clientconfirmation    Script Date: 12/27/00 8:58:47 PM ******/

CREATE procedure Clientconfirmation (@party varchar(10), @sdate varchar(10)) as
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,  
c.ins_chrg,c.turn_tax, c.other_chrg, c.sebi_tax,c.broker_chrg,c.trade_amount,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE'
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and c.party_code like @party
and convert(varchar,c.sauda_date,1) like @sdate
union
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
s.ins_chrg,s.turn_tax, s.other_chrg, s.sebi_tax,s.broker_chrg,s.trade_amount, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE'
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and s.party_code like @party
and convert(varchar,s.sauda_date,1) like @sdate

GO
