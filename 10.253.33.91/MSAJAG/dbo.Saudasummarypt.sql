-- Object: PROCEDURE dbo.Saudasummarypt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Saudasummarypt    Script Date: 3/17/01 9:56:05 PM ******/

/****** Object:  Stored Procedure dbo.Saudasummarypt    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.Saudasummarypt    Script Date: 20-Mar-01 11:39:04 PM ******/

/* This sp is used in the saudasummctlprj
    created by amt on 24 jan 2001 
   table used settlement , history*/
CREATE PROCEDURE Saudasummarypt
@partycode varchar(10),
@fromdate varchar(20),
@todate  varchar(20)
 AS
select distinct s.scrip_cd ,  
PAmt=round((case when s.sell_buy = 1 then sum(tradeqty*marketrate) else 0 end ),2), 
 SAmt=round((case when s.sell_buy = 2 then sum(tradeqty*marketrate) else 0 end ),2), 
 PQty=(case when s.sell_buy = 1 then sum(tradeqty) else 0 end ),  
SQty=(case when s.sell_buy = 2 then sum(tradeqty) else 0 end ) , 
Pbrk=round((case when s.sell_buy = 1 then sum(Brokapplied*tradeqty) else 0 end ),2),
 Sbrk=round((case when s.sell_buy = 2 then sum(Brokapplied*tradeqty) else 0 end ),2), s.sell_buy
 from settlement s where s.PARTY_CODE=@partycode and s.tradeqty > 0 and
 s.Sauda_date  >=@fromdate  and s.Sauda_date <=@todate
 group by  s.scrip_cd,s.sell_buy 
 Union 
select distinct h.scrip_cd ,  
PAmt=round((case when h.sell_buy = 1 then sum(tradeqty*marketrate) else 0 end ),2), 
 SAmt=round((case when h.sell_buy = 2 then sum(tradeqty*marketrate) else 0 end ),2),
  PQty=(case when h.sell_buy = 1 then sum(tradeqty) else 0 end ),  
SQty=(case when h.sell_buy = 2 then sum(tradeqty) else 0 end ),
 Pbrk=round((case when h.sell_buy = 1 then sum(Brokapplied*tradeqty) else 0 end ),2), 
Sbrk=round((case when h.sell_buy = 2 then sum(Brokapplied*tradeqty) else 0 end ),2), h.sell_buy 
from history h where h.PARTY_CODE=@partycode and h.tradeqty > 0 and
 h. Sauda_date  >=@fromdate and h. Sauda_date <=@todate
 group by  h.scrip_cd,h.sell_buy 
 ORDER BY scrip_cd,sell_buy

GO
