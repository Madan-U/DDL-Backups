-- Object: PROCEDURE dbo.rpt_mtomdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomdetail    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomdetail    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomdetail    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomdetail    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomdetail    Script Date: 12/27/00 8:59:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomdetail    Script Date: 10/23/2000 11:04:47 AM ******/
/* report : mtomreport 
   file : mtomtablefill.asp
*/
/* delets mtomdetail */
CREATE PROCEDURE rpt_mtomdetail
AS
delete from tblmtomdetail

GO
