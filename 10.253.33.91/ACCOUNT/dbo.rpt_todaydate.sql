-- Object: PROCEDURE dbo.rpt_todaydate
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 11/28/2001 12:23:51 PM ******/





/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 20-Mar-01 11:39:03 PM ******/



CREATE PROCEDURE rpt_todaydate
AS
select convert(varchar,getdate(),103)

GO
