-- Object: PROCEDURE dbo.sbselscrip3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbselscrip3    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbselscrip3    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbselscrip3    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbselscrip3    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbselscrip3    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE 
sbselscrip3
@scrip varchar(12)
 AS
select co_code,scrip_cd,series,exchange from scrip2 
      where scrip_cd like ltrim(@scrip)+'%'
      order by scrip_cd ,series

GO
