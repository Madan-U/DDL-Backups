-- Object: PROCEDURE dbo.shortsettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.shortsettype    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.shortsettype    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.shortsettype    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.shortsettype    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.shortsettype    Script Date: 12/27/00 8:59:03 PM ******/

CREATE PROCEDURE shortsettype
 AS
select distinct sett_type from deliveryclt
 order by sett_type

GO
