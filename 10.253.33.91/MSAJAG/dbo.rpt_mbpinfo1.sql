-- Object: PROCEDURE dbo.rpt_mbpinfo1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mbpinfo1    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo1    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo1    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo1    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo1    Script Date: 12/27/00 8:59:13 PM ******/

CREATE PROCEDURE rpt_mbpinfo1
@scripcd varchar(7),
@series varchar(2)
AS
Select * from MBPINFO1 
where scrip_cd like @scripcd
and series = @series order by scrip_cd,series

GO
