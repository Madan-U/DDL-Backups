-- Object: PROCEDURE dbo.rpt_foclosingdetail1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclosingdetail1    Script Date: 5/11/01 6:19:47 PM ******/


/****** Object:  Stored Procedure dbo.rpt_foclosingdetail1    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail1    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail1    Script Date: 5/5/2001 1:24:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail1    Script Date: 4/30/01 5:50:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail1    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foclosingdetail1    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Closing Report
File Name    : closingdetail
Tables Used  : foclosing
Function     : Returns contract descriptor along with the closing rate
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_foclosingdetail1
@tdate varchar(12)
AS
select inst_type, symbol, convert(varchar,expirydate,106) as expirydate , cl_rate, expirydate as expdate,strike_price,option_type
from foclosing
where convert(varchar,trade_date,106) = @tdate
order by expdate,inst_type,strike_price,option_type

GO
