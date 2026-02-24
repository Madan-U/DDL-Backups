-- Object: PROCEDURE dbo.rpt_focontdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focontdetail    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focontdetail    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focontdetail    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focontdetail    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focontdetail    Script Date: 4/30/01 5:50:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focontdetail    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_focontdetail    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Contract Wise Detail Report
File Name    : contractdetail.asp
Tables Used  : fosettlement
Function     : Returns details of a contract descriptor for a particular date
Written By   : Amolika Patil 
Modified By  : Amolika on 2nd Feb'2001 : Removed convert from sauda_date 
*/
CREATE PROCEDURE rpt_focontdetail
@code varchar(10),
@sdate varchar(12),
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12)
AS
select t.inst_type, t.symbol, convert(varchar,t.expirydate,106) as expirydate, tradeqty, sell_buy,
convert(varchar,sauda_date,106) as sdate, t.strike_price, t.option_type
from fosettlement t, foscrip2 s2
where party_code = @code
and t.inst_type = @inst
and t.symbol = @symbol
and convert(varchar,t.expirydate,106) = @expdate
and t.inst_type = s2.inst_type
and t.symbol = s2.symbol
and t.expirydate = s2.expirydate
and sauda_date <= @sdate + ' 23:59'
and s2.maturitydate > @sdate + ' 23:59:00'

GO
