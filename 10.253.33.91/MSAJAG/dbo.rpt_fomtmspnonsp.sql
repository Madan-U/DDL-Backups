-- Object: PROCEDURE dbo.rpt_fomtmspnonsp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomtmspnonsp    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmspnonsp    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmspnonsp    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmspnonsp    Script Date: 5/5/2001 1:24:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmspnonsp    Script Date: 4/30/01 5:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtmspnonsp    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomtmspnonsp    Script Date: 12/27/00 8:59:10 PM ******/
/*
Used In      : NSE FO
Report Name  : Contract Wise Detail Report
File Name    : mtmspreadnonspread.asp
Tables Used  : fosettlement
Function     : Returns contract descriptor along with the tradeqty & price for a particular 
        code & date
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fomtmspnonsp
@code varchar(10),
@datet varchar(12),
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12)
AS
select inst_type, symbol, convert(varchar,expirydate,106) as expirydate,amt=(tradeqty*price),
tradeqty, price, sell_buy 
from fosettlement
where party_code = @code
and inst_type = @inst
and symbol = @symbol
and convert(varchar,expirydate,106) = @expdate
and convert(varchar,sauda_date,106) = @datet
order by sell_buy

GO
