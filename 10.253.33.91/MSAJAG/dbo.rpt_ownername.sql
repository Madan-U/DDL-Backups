-- Object: PROCEDURE dbo.rpt_ownername
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ownername    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ownername    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ownername    Script Date: 20-Mar-01 11:39:02 PM ******/





/****** Object:  Stored Procedure dbo.rpt_ownername    Script Date: 12/27/00 8:59:14 PM ******/
/* report : confirmation report
   file : tconfirmationreport.asp
*/
/* displays company name */
CREATE PROCEDURE rpt_ownername  AS
select company from owner

GO
