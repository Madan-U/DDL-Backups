-- Object: PROCEDURE dbo.rpt_fomonth
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomonth    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomonth    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomonth    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomonth    Script Date: 5/5/2001 1:24:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomonth    Script Date: 4/30/01 5:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomonth    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomonth    Script Date: 12/27/00 8:58:54 PM ******/
/*
Used In      : NSE FO
Report Name  : Contract Wise Detail Report
File Name    : newfoclient
Tables Used  : None
Function     : Returns the month of a particular date
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fomonth
AS
select left(convert(varchar,getdate(),109),3)

GO
