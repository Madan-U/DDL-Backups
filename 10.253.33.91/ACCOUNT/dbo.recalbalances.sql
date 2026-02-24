-- Object: PROCEDURE dbo.recalbalances
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.recalbalances    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.recalbalances    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.recalbalances    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.recalbalances    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.recalbalances    Script Date: 8/7/01 6:03:50 PM ******/
CREATE PROCEDURE recalbalances
 AS

execute bbgadjbalcursor2000

execute bbgadjbalcursor2001

GO
