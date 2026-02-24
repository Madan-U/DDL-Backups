-- Object: PROCEDURE dbo.DailyOblHistorySpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblHistorySpP    Script Date: 12/27/00 8:58:48 PM ******/

CREATE PROCEDURE DailyOblHistorySpP 
 AS
select 'TOTAL QUANTITY' = sum(tradeqty),sell_buy,
'TOTAL AMOUNT' = sum(tradeqty*marketrate) 
from  .history 
 group by sell_buy

GO
