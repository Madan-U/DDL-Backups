-- Object: PROCEDURE dbo.SBNODEL1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SBNODEL1    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL1    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL1    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL1    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL1    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE SBNODEL1 AS
select distinct sett_no from sett_mst
order by sett_no

GO
