-- Object: PROCEDURE dbo.sample
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sample    Script Date: 3/17/01 9:56:05 PM ******/

/****** Object:  Stored Procedure dbo.sample    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sample    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sample    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sample    Script Date: 12/27/00 8:58:59 PM ******/

/****** Object:  Stored Procedure dbo.sample    Script Date: 12/18/99 8:24:05 AM ******/
CREATE PROCEDURE sample 
(@trade_no varchar(10) )
AS
select * from trade where convert(varchar,trade_no) like @trade_no
return

GO
