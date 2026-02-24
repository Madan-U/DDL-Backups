-- Object: PROCEDURE dbo.NETQTY
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NETQTY    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY    Script Date: 12/18/99 8:24:14 AM ******/
CREATE PROCEDURE NETQTY (@SETT_NO VARCHAR(20),@SETT_TYPE VARCHAR(1)) AS
select sett_no,sett_type,scrip_cd,series,sum(tradeqty) 'Qty',sell_buy,amt = sum(tradeqty * marketrate) from NetTradeA 
where sett_no = @Sett_No and sett_type = @Sett_Type group by sett_no,sett_type,scrip_cd,series,sell_buy

GO
