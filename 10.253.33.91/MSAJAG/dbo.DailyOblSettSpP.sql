-- Object: PROCEDURE dbo.DailyOblSettSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblSettSpP    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettSpP    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettSpP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettSpP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblSettSpP    Script Date: 12/27/00 8:58:48 PM ******/

CREATE PROCEDURE DailyOblSettSpP
@settno varchar(7),
@setttype varchar(3)
 AS
select  isnull(sum(tradeqty),0),sell_buy,  isnull(sum(tradeqty*marketrate),0) 
from settlement 
 where sett_no like @settno  and sett_type like @setttype
group by sell_buy

GO
