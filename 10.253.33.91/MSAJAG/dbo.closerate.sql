-- Object: PROCEDURE dbo.closerate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.closerate    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.closerate    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.closerate    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.closerate    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.closerate    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.closerate    Script Date: 12/18/99 8:24:07 AM ******/
CREATE PROCEDURE closerate
@scrip char(12),
@cls numeric(10),
@dt smalldatetime
 AS
update scrip2 set cl_rate =  @cls , clos_rate_dt = @dt 
  where scrip_cd = @scrip

GO
