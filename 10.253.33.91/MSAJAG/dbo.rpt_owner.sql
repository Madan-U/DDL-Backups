-- Object: PROCEDURE dbo.rpt_owner
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 05/20/2002 5:36:55 PM ******/
/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 12/14/2001 1:25:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 11/30/01 4:48:56 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 11/5/01 1:29:23 PM ******/





/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 09/07/2001 11:09:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 7/1/01 2:26:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 06/26/2001 8:49:13 PM ******/


/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_owner    Script Date: 12/27/00 8:59:14 PM ******/

/* Report : Confirmationmain.asp(BSE)
   File : Hconfirmationreport.asp
   Displays the owner name
*/
CREATE PROCEDURE rpt_owner
AS
select company from owner

GO
