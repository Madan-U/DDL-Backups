-- Object: PROCEDURE dbo.rpt_prevsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_prevsettno    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_prevsettno    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_prevsettno    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_prevsettno    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_prevsettno    Script Date: 12/27/00 8:58:57 PM ******/

/* report : grossexposure report
   file : grossexptrdset.asp
   gives previous settlement number 
*/
CREATE PROCEDURE rpt_prevsettno 
@settno varchar(7)
AS
select distinct sett_no-1  from settlement where sett_no=@settno

GO
