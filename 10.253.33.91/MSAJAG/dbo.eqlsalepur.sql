-- Object: PROCEDURE dbo.eqlsalepur
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.eqlsalepur    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.eqlsalepur    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.eqlsalepur    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.eqlsalepur    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.eqlsalepur    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.eqlsalepur    Script Date: 12/18/99 8:24:13 AM ******/
CREATE PROCEDURE eqlsalepur 
 AS
 declare @partycode char(20)  
 declare @scripcd  char(20) 
 declare @sellbuy  numeric(1) 
update trade set settflag = 15 where party_code  = @partycode and scrip_cd = @scripcd
and sell_buy = @sellbuy
 (select @partycode= a.party_code, @scripcd= a.scrip_cd ,@sellbuy = a.sell_buy 
  from salepur a , salepur b 
  where a.party_code = b.party_code
  and a.scrip_cd = b.scrip_cd
  and a.sell_buy <> b.sell_buy
  group by a.party_code , a.scrip_cd , a.sell_buy 
  having sum(a.tradeqty) <> sum(b.tradeqty) )

GO
