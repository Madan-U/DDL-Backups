-- Object: PROCEDURE dbo.HistCrossCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.HistCrossCheck    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.HistCrossCheck    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.HistCrossCheck    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.HistCrossCheck    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.HistCrossCheck    Script Date: 12/27/00 8:58:51 PM ******/

CREATE Proc HistCrossCheck As
select 
PQty = isnull(( case when sell_buy = 1 then sum(Tradeqty) end ),0), 
PAmt = isnull(( case when sell_buy = 1 then sum(Tradeqty*marketrate) end ),0), 
SQty = isnull(( case when sell_buy = 2 then sum(Tradeqty) end ),0),
SAmt = isnull(( case when sell_buy = 2 then sum(Tradeqty*marketrate) end ),0)
from history
group by sell_buy

GO
