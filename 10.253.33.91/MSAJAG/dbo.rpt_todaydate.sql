-- Object: PROCEDURE dbo.rpt_todaydate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 05/20/2002 5:24:32 PM ******/
/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 20-Mar-01 11:39:03 PM ******/



CREATE PROCEDURE rpt_todaydate
AS
select convert(varchar,getdate(),103)

GO
