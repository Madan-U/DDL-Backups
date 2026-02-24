-- Object: PROCEDURE dbo.rpt_settype1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settype1    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settype1    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settype1    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settype1    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settype1    Script Date: 12/27/00 8:58:58 PM ******/

/* report : position report 
   file : positionmain.asp
   report : bills report
   file : billmain.asp 
 */
/* displays settlement types from settlement */
CREATE PROCEDURE rpt_settype1
/*@statusid varchar(15),
@statusname varchar(25)*/

AS


select distinct sett_type from settlement
order by sett_type

GO
