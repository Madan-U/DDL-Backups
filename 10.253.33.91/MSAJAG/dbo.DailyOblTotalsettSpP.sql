-- Object: PROCEDURE dbo.DailyOblTotalsettSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 12/27/00 8:58:48 PM ******/

CREATE PROCEDURE DailyOblTotalsettSpP 
 AS
select 'SETTLEMENT NO' = sett_no,
 'SETTLEMENT TYPE' = sett_type,
'TOTAL QUANTITY' = sum(tradeqty),
sell_buy, 'TOTAL AMOUNT' = sum(tradeqty*marketrate) 
from msajag.dbo.settlement
 group by sett_no, sett_type,sell_buy 
ORDER BY SETT_NO,sell_buy

GO
