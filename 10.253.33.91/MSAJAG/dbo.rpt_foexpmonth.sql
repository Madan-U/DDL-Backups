-- Object: PROCEDURE dbo.rpt_foexpmonth
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foexpmonth    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foexpmonth    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foexpmonth    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foexpmonth    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foexpmonth    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foexpmonth    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foexpmonth    Script Date: 12/27/00 8:58:54 PM ******/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : margin.asp
Tables Used  : None
Function     : Returns month of tha date
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_foexpmonth
@tdate varchar(12)
AS
select left(right(@tdate,8),3)

GO
