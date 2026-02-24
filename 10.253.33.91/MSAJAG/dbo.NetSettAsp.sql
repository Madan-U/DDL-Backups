-- Object: PROCEDURE dbo.NetSettAsp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NetSettAsp    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NetSettAsp    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NetSettAsp    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NetSettAsp    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.NetSettAsp    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.NetSettAsp    Script Date: 12/18/99 8:24:05 AM ******/
CREATE PROCEDURE NetSettAsp (@sett_no varchar(10), @sett_type varchar(3))  AS
select trade_no, sett_no,sett_type,scrip_cd,series,tradeqty,sell_buy,marketrate from settlement 
where sett_no = @sett_no and sett_type = @sett_type

GO
