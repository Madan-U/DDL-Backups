-- Object: PROCEDURE dbo.rpt_fonetvalue
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonetvalue    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetvalue    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetvalue    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetvalue    Script Date: 5/5/2001 1:24:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetvalue    Script Date: 4/30/01 5:50:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetvalue    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fonetvalue    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Contract Wise Detail Report
File Name    : mtmpldetail.asp
Tables Used  : fosettlement
Function     : Returns details of a contract descriptor for a particular date & client
Written By   : Amolika Patil 
Modified By  : Amolika on 2nd feb'2001 :  Removed convert from sauda_date
*/
CREATE PROCEDURE rpt_fonetvalue
@code varchar(10),
@datet varchar(12),
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12)
AS
select inst_type, symbol, convert(varchar,expirydate,106) as expirydate,amt=(tradeqty*price),
tradeqty, price, sell_buy , strike_price, option_type
from fosettlement
where party_code = @code
and inst_type = @inst
and symbol = @symbol
and convert(varchar,expirydate,106) = @expdate
and sauda_date <= @datet + ' 23:59'

GO
