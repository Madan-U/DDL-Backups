-- Object: PROCEDURE dbo.rpt_latesrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_latesrate    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_latesrate    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_latesrate    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_latesrate    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_latesrate    Script Date: 12/27/00 8:59:13 PM ******/

/* report : newmtom report
   file : mtomrepot.asp
*/
/* displays latest rate for a scrip */
CREATE PROCEDURE rpt_latesrate
@scripcd varchar(12),
@series varchar(3)
AS
select isnull(Lastrate,0) from ldbmkt where scrip_cd =@scripcd and series = @series

GO
