-- Object: PROCEDURE dbo.sbTrScrmarketrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbTrScrmarketrate    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbTrScrmarketrate    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.sbTrScrmarketrate    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.sbTrScrmarketrate    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbTrScrmarketrate    Script Date: 12/27/00 8:59:02 PM ******/

CREATE PROCEDURE sbTrScrmarketrate
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripname varchar(10),
@series char (2),
@subbroker varchar(15)
AS
 select s.sett_no,s.sett_type,s.party_code,s.Scrip_Cd,s.series,s.tradeqty,s.MarketRate,s.Sell_buy,s.Sauda_date,s.User_id  
from settlement s ,subbrokers sb,client1 c1 ,client2 c2
      where s.sett_no = ltrim(@settno)  and s.sett_type = ltrim(@settype)  and s.party_code =ltrim(@partycode)
       and s.Scrip_Cd =ltrim(@scripname) and s.series =ltrim(@series)  and c1.cl_code=c2.cl_code and c2.party_code=s.party_code and 
c1.sub_broker=sb.sub_broker and sb.sub_broker=ltrim(@subbroker)
 order by s.sett_no,s.sett_type,s.party_code,s.Scrip_Cd,s.series,s.Sauda_date,s.Sell_buy,s.tradeqty,s.MarketRate,User_id

GO
