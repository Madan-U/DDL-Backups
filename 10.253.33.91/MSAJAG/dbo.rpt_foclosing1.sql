-- Object: PROCEDURE dbo.rpt_foclosing1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclosing1    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosing1    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosing1    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosing1    Script Date: 5/5/2001 1:24:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosing1    Script Date: 4/30/01 5:50:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosing1    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foclosing1    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Contract Wise Detail Report
File Name    : clientdetailtodayclosing
Tables Used  : foclosing
Function     : Returns closing rate of a particular date
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_foclosing1 
@sdate varchar(12),
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12)
AS
select cl_rate 
from foclosing 
where convert(varchar,trade_date,106) = @sdate
and inst_type = @inst
and symbol = @symbol
and convert(varchar,expirydate,106)= @expdate

GO
