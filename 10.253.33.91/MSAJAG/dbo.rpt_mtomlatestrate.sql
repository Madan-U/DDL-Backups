-- Object: PROCEDURE dbo.rpt_mtomlatestrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomlatestrate    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlatestrate    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlatestrate    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlatestrate    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlatestrate    Script Date: 12/27/00 8:59:13 PM ******/

/* report : newmtom 
   file : mtomtablefill.asp
*/
/* selects latest rate for a scrip or series */
CREATE PROCEDURE rpt_mtomlatestrate
@scripcd varchar(12),
@series varchar(3)
AS
select isnull(Lastrate,0) from ldbmkt where scrip_cd = @scripcd and series = @series

GO
