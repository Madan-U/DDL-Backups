-- Object: PROCEDURE dbo.rpt_foconfirm1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foconfirm1    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirm1    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirm1    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirm1    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirm1    Script Date: 4/30/01 5:50:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirm1    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foconfirm1    Script Date: 12/27/00 8:59:17 PM ******/
CREATE PROCEDURE rpt_foconfirm1
@code varchar(10),
@name varchar(21),
@sdate varchar(12)
AS
select distinct c.Party_Code,c1.short_name,c.inst_type, c.tradeqty,c.price,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.activitytime, c.Sell_buy,c.markettype, 
c.symbol, c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,  
c.ins_chrg,c.turn_tax, c.other_chrg, c.sebi_tax,
c.broker_chrg,c.trade_amount,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME"
,CONVERT(VARCHAR,c.activitytime,106) 'SDATE',c1.cl_code,c.symbol,
CONVERT(VARCHAR,c.expirydate,106) 'expirydate', strike_price, option_type
from foConfirmview c, client1 c1, client2 c2 
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and c.party_code like ltrim(@code)+'%'
and c1.short_name like ltrim(@name)+'%'
and convert(varchar,c.activitytime,103) like  ltrim(@sdate)+'%'

GO
