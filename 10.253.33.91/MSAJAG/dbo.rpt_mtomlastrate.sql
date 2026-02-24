-- Object: PROCEDURE dbo.rpt_mtomlastrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomlastrate    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlastrate    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlastrate    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlastrate    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomlastrate    Script Date: 12/27/00 8:59:13 PM ******/


/* report : newmtom
   file : mtom_3d.asp
   finds last rate
*/
CREATE PROCEDURE rpt_mtomlastrate
@scripcd varchar(12),
@series varchar(3)
AS
select isnull(Lastrate,0) from ldbmkt where scrip_cd =@scripcd and series = @series

GO
