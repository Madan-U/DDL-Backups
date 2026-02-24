-- Object: PROCEDURE dbo.rpt_settypedelclt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settypedelclt    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settypedelclt    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settypedelclt    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settypedelclt    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settypedelclt    Script Date: 12/27/00 8:59:14 PM ******/
create proc rpt_settypedelclt as
select distinct sett_type from deliveryclt

GO
