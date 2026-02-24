-- Object: PROCEDURE dbo.DailyOblTotalsettSpP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.DailyOblTotalsettSpP    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE DailyOblTotalsettSpP 
 AS
select 'SETTLEMENT NO' = sett_no,
 'SETTLEMENT TYPE' = sett_type,
'TOTAL QUANTITY' = sum(tradeqty),
sell_buy, 'TOTAL AMOUNT' = sum(tradeqty*marketrate) 
from MSAJAG.DBO.settlement
 group by sett_no, sett_type,sell_buy 
ORDER BY SETT_NO,sell_buy

GO
