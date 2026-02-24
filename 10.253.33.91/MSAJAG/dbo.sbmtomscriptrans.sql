-- Object: PROCEDURE dbo.sbmtomscriptrans
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomscriptrans    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptrans    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptrans    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptrans    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptrans    Script Date: 12/27/00 8:59:00 PM ******/

CREATE PROCEDURE sbmtomscriptrans
@partycode varchar(10),
@scripname varchar(10),
@series  varchar(2)
AS
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,MarketRate,Sell_buy,Sauda_date,User_id 
from settlement where party_code = @partycode  and sett_type = 'N' and billno =0 and Scrip_Cd =@scripname+'%'
 and series =@series  order by sett_no,sett_type,party_code,Scrip_Cd,series,Sauda_date,Sell_buy,tradeqty,MarketRate,User_id

GO
