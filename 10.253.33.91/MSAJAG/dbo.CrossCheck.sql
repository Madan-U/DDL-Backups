-- Object: PROCEDURE dbo.CrossCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CrossCheck    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.CrossCheck    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.CrossCheck    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.CrossCheck    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.CrossCheck    Script Date: 12/27/00 8:58:48 PM ******/

CREATE Proc CrossCheck As
select 
PQty = isnull(( case when sell_buy = 1 then sum(Tradeqty) end ),0), 
PAmt = isnull(( case when sell_buy = 1 then sum(Tradeqty*marketrate) end ),0), 
SQty = isnull(( case when sell_buy = 2 then sum(Tradeqty) end ),0),
SAmt = isnull(( case when sell_buy = 2 then sum(Tradeqty*marketrate) end ),0)
from settlement
group by sell_buy

GO
