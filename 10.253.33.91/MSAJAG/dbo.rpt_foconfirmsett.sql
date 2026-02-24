-- Object: PROCEDURE dbo.rpt_foconfirmsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 5/11/01 6:16:05 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 5/11/01 12:08:56 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 4/30/01 5:50:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foconfirmsett    Script Date: 12/27/00 8:59:09 PM ******/
/*Modified By Amolika on 9th feb : exchange condition*/
CREATE PROCEDURE rpt_foconfirmsett

@code varchar(10),
@name varchar(21),
@sdate varchar(12)

AS


select distinct s.Party_Code,c1.short_name,s.inst_type, s.symbol,
convert(varchar,s.expirydate,106)'expirydate', s.tradeqty, s.price,s.BrokApplied,
s.netrate,s.amount, Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,
s.sett_no,g.service_tax,
t.exchange, s.Sell_buy,s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax,
c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,106) 'SDATE', s.expirydate as expdate,
s.strike_price, s.option_type
from fosettlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE'
and t.Exchange  = g.Exchange 
and s.party_code like ltrim(@code)+'%'
and c1.short_name like ltrim(@name)+'%'
and convert(varchar,s.sauda_date,106) like ltrim(@sdate)+'%'
order by s.party_code, expdate, trade_no


/*select distinct s.Party_Code,c1.short_name,s.inst_type, s.symbol,
convert(varchar,s.expirydate,106)'expirydate', s.tradeqty, s.price,s.BrokApplied,
s.netrate,s.amount, Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,
s.sett_no,t.Insurance_chrg,t.turnover_tax,t.sebiturn_tax,t.broker_note,g.service_tax,
t.exchange, s.Sell_buy,s.Sell_buy, s.other_chrg, s.sebi_tax,s.broker_chrg, s.service_tax,
c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,106) 'SDATE', s.expirydate as expdate,
s.strike_price, s.option_type
from fosettlement s, client1 c1, client2 c2, taxes t, globals g,foscrip2 s2
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE'
and s.party_code like ltrim(@code)+'%'
and c1.short_name like ltrim(@name)+'%'
and convert(varchar,s.sauda_date,106) like ltrim(@sdate)+'%'
order by s.party_code, expdate, trade_no
*/

GO
