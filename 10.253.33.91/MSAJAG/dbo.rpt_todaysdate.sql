-- Object: PROCEDURE dbo.rpt_todaysdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_todaysdate    Script Date: 01/19/2002 12:15:16 ******/

/****** Object:  Stored Procedure dbo.rpt_todaysdate    Script Date: 01/04/1980 5:06:27 AM ******/






/****** Object:  Stored Procedure dbo.rpt_todaysdate    Script Date: 09/07/2001 11:09:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_todaysdate    Script Date: 3/23/01 7:59:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_todaysdate    Script Date: 08/18/2001 8:24:29 PM ******/


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 20-Mar-01 11:39:03 PM ******/



CREATE PROCEDURE rpt_todaysdate
AS
select convert(varchar,getdate(),103)

GO
