-- Object: PROCEDURE dbo.brtrannew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtrannew    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtrannew    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.brtrannew    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brtrannew    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.brtrannew    Script Date: 12/27/00 8:58:46 PM ******/

CREATE PROCEDURE brtrannew
@partycode varchar(10)
AS
select Order_no,sell_buy,Scrip_cd,Series,tradeqty, 
marketrate,user_id,sauda_date,t.party_code 
from trade4432 t
where t.party_code = @partycode
order by t.party_code,scrip_cd,sell_buy,sauda_date

GO
