-- Object: PROCEDURE dbo.sbmbpinfo2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmbpinfo2    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmbpinfo2    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbmbpinfo2    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbmbpinfo2    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmbpinfo2    Script Date: 12/27/00 8:59:15 PM ******/

CREATE PROCEDURE 
sbmbpinfo2
@scripname varchar(12),
@series varchar(3)
AS
Select * from MBPINFO1 where scrip_cd =ltrim( @scripname) and series =ltrim( @series)
 order by scrip_cd,series

GO
