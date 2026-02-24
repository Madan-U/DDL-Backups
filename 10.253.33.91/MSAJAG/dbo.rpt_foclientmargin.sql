-- Object: PROCEDURE dbo.rpt_foclientmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclientmargin    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientmargin    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientmargin    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientmargin    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientmargin    Script Date: 4/30/01 5:50:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientmargin    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foclientmargin    Script Date: 12/27/00 8:59:09 PM ******/
/*Modified by Amolika on 13th April'2001 : Added like to partycode*/
/*
Used In      : NSE FO
Report Name  : Contract Wise Detail Report
File Name    : clientdetailtodayclosing.asp
Tables Used  : fosettlement
Function     : Returns bqty, sqty, buyvalue, sellvalue for a particular partycode & date
Written By   : Amolika Patil 
Modified by Amolika on 12th Feb'2001 : Added condition for maturity date
*/
CREATE proc rpt_foclientmargin

@code varchar(7),
@tdate varchar(12)

as


select distinct t.party_code, t.inst_type, t.symbol, convert(varchar,t.expirydate,106) as expirydate ,
bqty        = isnull((select sum(tradeqty)from fosettlement f where f.party_code = t.party_code and  f.sell_buy =1 and f.sauda_date <=@tdate + ' 23:59' and f.inst_type=t.inst_type and f.symbol=t.symbol and f.expirydate=t.expirydate),0),
sqty        = isnull((select sum(tradeqty)from fosettlement f where f.party_code = t.party_code and  f.sell_buy =2 and f.sauda_date <= @tdate + ' 23:59' and f.inst_type=t.inst_type and f.symbol=t.symbol and f.expirydate=t.expirydate),0) ,
buyvalue = isnull((select sum(tradeqty * price) from fosettlement  f where f.sell_buy = 1 and f.party_code = t.party_code and f.sauda_date <= @tdate + ' 23:59'
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
sellvalue = isnull((select sum(tradeqty * price) from fosettlement  f where f.sell_buy = 2 and f.party_code = t.party_code and f.sauda_date <= @tdate + ' 23:59'
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
t.expirydate as expdate, t.strike_price, t.option_type
from fosettlement t, foscrip2 s2
where t.party_code like ltrim(@code)+'%'
and t.inst_type = s2.inst_type
and t.symbol = s2.symbol
and t.expirydate = s2.expirydate
and t.sauda_date <= @tdate+ ' 23:59'
and s2.maturitydate > @tdate + ' 23:59:00'
order by t.party_code,t.expdate, t.inst_type, t.symbol


/*
select distinct t.party_code, t.inst_type, t.symbol, convert(varchar,t.expirydate,106) as expirydate ,
bqty        = isnull((select sum(tradeqty)from fosettlement f where f.party_code = t.party_code and  f.sell_buy =1 and f.sauda_date <=@tdate + ' 23:59' and f.inst_type=t.inst_type and f.symbol=t.symbol and f.expirydate=t.expirydate),0),
sqty        = isnull((select sum(tradeqty)from fosettlement f where f.party_code = t.party_code and  f.sell_buy =2 and f.sauda_date <= @tdate + ' 23:59' and f.inst_type=t.inst_type and f.symbol=t.symbol and f.expirydate=t.expirydate),0) ,
buyvalue = isnull((select sum(tradeqty * price) from fosettlement  f where f.sell_buy = 1 and f.party_code = t.party_code and f.sauda_date <= @tdate + ' 23:59'
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
sellvalue = isnull((select sum(tradeqty * price) from fosettlement  f where f.sell_buy = 2 and f.party_code = t.party_code and f.sauda_date <= @tdate + ' 23:59'
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
t.expirydate as expdate
from fosettlement t, foscrip2 s2
where t.party_code = @code
and t.inst_type = s2.inst_type
and t.symbol = s2.symbol
and t.expirydate = s2.expirydate
and t.sauda_date <= @tdate+ ' 23:59'
and s2.maturitydate > @tdate + ' 23:59:00'
order by t.expdate, t.inst_type, t.symbol

select distinct t.party_code, t.inst_type, t.symbol, convert(varchar,t.expirydate,106) as expirydate ,
bqty        = isnull((select sum(tradeqty)from fosettlement f where f.party_code = t.party_code and  f.sell_buy =1 and convert(varchar,f.sauda_date,106) <= @tdate and f.inst_type=t.inst_type and f.symbol=t.symbol and f.expirydate=t.expirydate),0),
sqty        = isnull((select sum(tradeqty)from fosettlement f where f.party_code = t.party_code and  f.sell_buy =2 and convert(varchar,f.sauda_date,106) <= @tdate and f.inst_type=t.inst_type and f.symbol=t.symbol and f.expirydate=t.expirydate),0) ,
buyvalue = isnull((select sum(tradeqty * price) from fosettlement  f where f.sell_buy = 1 and f.party_code = t.party_code and convert(varchar,f.sauda_date,106) <= @tdate
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
sellvalue = isnull((select sum(tradeqty * price) from fosettlement  f where f.sell_buy = 2 and f.party_code = t.party_code and convert(varchar,f.sauda_date,106) <= @tdate
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
expirydate as expdate
from fosettlement t
where t.party_code = @code
and convert(varchar,t.sauda_date,106) <= @tdate
order by expdate,inst_type, symbol
*/

GO
