-- Object: PROCEDURE dbo.rpt_settnodelclt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settnodelclt    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnodelclt    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnodelclt    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnodelclt    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnodelclt    Script Date: 12/27/00 8:59:14 PM ******/
create proc rpt_settnodelclt as 
select distinct sett_no from deliveryclt

GO
