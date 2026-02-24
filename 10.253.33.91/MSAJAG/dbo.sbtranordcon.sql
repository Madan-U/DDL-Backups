-- Object: PROCEDURE dbo.sbtranordcon
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtranordcon    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtranordcon    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtranordcon    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtranordcon    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtranordcon    Script Date: 12/27/00 8:59:02 PM ******/

CREATE PROCEDURE sbtranordcon
@partycode varchar(10)
 AS
select Order_no,sell_buy,Scrip_cd,Series,tradeqty, marketrate,user_id,sauda_date,party_code 
from trade4432 
where party_code = ltrim(@partycode)
order by party_code,scrip_cd,sell_buy,sauda_date

GO
