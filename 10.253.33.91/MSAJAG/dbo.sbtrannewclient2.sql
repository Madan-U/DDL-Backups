-- Object: PROCEDURE dbo.sbtrannewclient2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtrannewclient2    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtrannewclient2    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtrannewclient2    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtrannewclient2    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtrannewclient2    Script Date: 12/27/00 8:59:02 PM ******/

CREATE PROCEDURE
sbtrannewclient2
@partycode varchar(10)
 AS
select o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),
o.user_id,o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime 
from orders o
where   o.party_code =ltrim(@partycode  )
order by o.party_code,o.scrip_cd,o.sell_buy,o.OrderTime

GO
