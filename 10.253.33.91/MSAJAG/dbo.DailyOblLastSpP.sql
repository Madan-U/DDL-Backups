-- Object: PROCEDURE dbo.DailyOblLastSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblLastSpP    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblLastSpP    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblLastSpP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblLastSpP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblLastSpP    Script Date: 12/27/00 8:58:48 PM ******/

CREATE PROCEDURE DailyOblLastSpP
@settno varchar(7),
@settno1 varchar(7),
@setttype varchar(3),
@saudadate as varchar(12)
AS
select isnull(sum(tradeqty),0),sell_buy, 
  isnull(sum(tradeqty*marketrate),0) 
from msajag.dbo.settlement  
where sett_no <> @settno and 
sett_no <> @settno1 and
 sett_type like @setttype and 
convert(varchar,sauda_date,101) = @saudadate 
 group by sell_buy

GO
