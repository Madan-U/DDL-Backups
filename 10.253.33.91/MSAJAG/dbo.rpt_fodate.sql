-- Object: PROCEDURE dbo.rpt_fodate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fodate    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate    Script Date: 4/30/01 5:50:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fodate    Script Date: 12/27/00 8:58:54 PM ******/
CREATE PROCEDURE rpt_fodate
AS
select left(convert(varchar,getdate(),106),11)

GO
