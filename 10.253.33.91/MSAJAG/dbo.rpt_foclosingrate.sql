-- Object: PROCEDURE dbo.rpt_foclosingrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclosingrate    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingrate    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingrate    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingrate    Script Date: 5/5/2001 1:24:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingrate    Script Date: 4/30/01 5:50:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingrate    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foclosingrate    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Closing Report
File Name    : closingdate
Tables Used  : foclosing
Function     : Returns tradedate
Written By   : Amolika Patil 
Modified By  : Amolika on 2nd Feb'2001 : Added order by trade_date for sorting 
Modified By  : Amolika on 12nd Feb'2001 : Added order by trade_date for sorting in descending order
*/
CREATE PROCEDURE rpt_foclosingrate
AS
select distinct convert(varchar,trade_date,106) as tradedate, TRADE_DATE
from foclosing
ORDER BY TRADE_DATE desc

GO
