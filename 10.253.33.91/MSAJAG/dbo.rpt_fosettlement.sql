-- Object: PROCEDURE dbo.rpt_fosettlement
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fosettlement    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlement    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlement    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlement    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlement    Script Date: 4/30/01 5:50:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlement    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fosettlement    Script Date: 12/27/00 8:59:11 PM ******/
CREATE PROCEDURE rpt_fosettlement
@code varchar(10),
@name varchar(21),
@sdate varchar(12)
AS
select c.Party_Code,c1.short_name,c.inst_type ,c.tradeqty,c.price,c.BrokApplied,
c.netrate,c.amount,c.Trade_no, c.Sell_buy,c.markettype, 
c.symbol, c.Ins_chrg,c.turn_tax, 
c.sebi_tax, c.service_tax , 
c.other_chrg, c.broker_chrg,c.trade_amount,c1.Off_Phone1, c1.trader "TRADER_NAME",
CONVERT(VARCHAR,c.sauda_date,106) 'SDATE',c1.cl_code,c.symbol,
CONVERT(VARCHAR,c.expirydate,106)'expirydate', c.strike_price, c.option_type
from fosettlement c, client1 c1, client2 c2 
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and c.party_code like ltrim(@code)+'%'
and c1.short_name like ltrim(@name)+'%'
and convert(varchar,c.sauda_date,103) like  ltrim(@sdate)+'%'

GO
