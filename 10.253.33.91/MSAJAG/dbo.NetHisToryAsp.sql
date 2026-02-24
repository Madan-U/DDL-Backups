-- Object: PROCEDURE dbo.NetHisToryAsp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NetHisToryAsp    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NetHisToryAsp    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NetHisToryAsp    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NetHisToryAsp    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.NetHisToryAsp    Script Date: 12/27/00 8:58:51 PM ******/

/****** Object:  Stored Procedure dbo.NetHisToryAsp    Script Date: 12/18/99 8:24:10 AM ******/
CREATE PROCEDURE NetHisToryAsp (@sett_no Varchar(10) , @sett_Type Varchar(3)) AS
select sett_no,sett_type,scrip_cd,series,tradeqty,sell_buy,marketrate from history
where sett_Type = @sett_Type and Sett_No = @sett_No

GO
