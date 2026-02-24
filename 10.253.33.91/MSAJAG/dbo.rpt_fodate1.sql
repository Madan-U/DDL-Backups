-- Object: PROCEDURE dbo.rpt_fodate1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fodate1    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate1    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate1    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate1    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate1    Script Date: 4/30/01 5:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodate1    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fodate1    Script Date: 12/27/00 8:59:09 PM ******/
CREATE PROCEDURE rpt_fodate1
@sdate varchar(12)
AS
select distinct left(convert(varchar,trade_date,109),11) as billdate from foclosing
where convert(varchar,trade_date,106) = @sdate

GO
