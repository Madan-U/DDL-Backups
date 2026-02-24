-- Object: PROCEDURE dbo.DailyOblSettPrintsp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblSettPrintsp    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettPrintsp    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettPrintsp    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettPrintsp    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettPrintsp    Script Date: 12/27/00 8:58:48 PM ******/

CREATE PROCEDURE DailyOblSettPrintsp AS
select 'TOTAL QUANTITY' = sum(tradeqty),sell_buy,'TOTAL AMOUNT' = sum(tradeqty*marketrate) from SETTLEMENT  group by sell_buy

GO
