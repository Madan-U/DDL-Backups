-- Object: PROCEDURE dbo.rpt_fotraders
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotraders    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotraders    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotraders    Script Date: 5/5/2001 2:43:41 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotraders    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotraders    Script Date: 4/30/01 5:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotraders    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotraders    Script Date: 12/27/00 8:59:11 PM ******/
CREATE PROCEDURE rpt_fotraders
AS
select distinct trader from client1 order by trader

GO
