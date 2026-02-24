-- Object: PROCEDURE dbo.DailyOblHistorySpP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE DailyOblHistorySpP 
 AS
select 'TOTAL QUANTITY' = sum(tradeqty),sell_buy,
'TOTAL AMOUNT' = sum(tradeqty*marketrate) 
from  MSAJAG.DBO.history 
 group by sell_buy

GO
