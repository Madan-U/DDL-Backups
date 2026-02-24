-- Object: PROCEDURE dbo.sbtopmbpinfo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtopmbpinfo    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo    Script Date: 12/27/00 8:59:16 PM ******/

/***    file :topmbpinfo.asp
  report :market rate  ***/
CREATE PROCEDURE 
sbtopmbpinfo
 @change char(1)
 AS
 select distinct scrip_cd,series from ldbmkt 
 where  TotalQty <> 0 and netPrice >= 10 
and NetChange = @change order by scrip_cd,series

GO
