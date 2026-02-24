-- Object: PROCEDURE dbo.TotalNetAsp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TotalNetAsp    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.TotalNetAsp    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.TotalNetAsp    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.TotalNetAsp    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.TotalNetAsp    Script Date: 12/27/00 8:59:17 PM ******/

/****** Object:  Stored Procedure dbo.TotalNetAsp    Script Date: 12/18/99 8:24:05 AM ******/
CREATE PROCEDURE TotalNetAsp (@sett_no varchar(10), @sett_type varchar(3)) AS
exec NetTradeAsp @sett_no,@sett_type
exec NetSettAsp @sett_no,@sett_type
exec NetHistoryAsp @sett_no,@sett_type

GO
