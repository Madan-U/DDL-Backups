-- Object: PROCEDURE dbo.rpt_nodelsettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_nodelsettype    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodelsettype    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodelsettype    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodelsettype    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nodelsettype    Script Date: 12/27/00 8:58:56 PM ******/

CREATE PROCEDURE rpt_nodelsettype
AS
select distinct sett_type from sett_mst

GO
