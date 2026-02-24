-- Object: PROCEDURE dbo.brtranclientreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtranclientreport    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtranclientreport    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brtranclientreport    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brtranclientreport    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.brtranclientreport    Script Date: 12/27/00 8:58:46 PM ******/

CREATE PROCEDURE brtranclientreport
@partycode varchar(10)
AS
select order_no,o.party_code ,scrip_cd,series,sell_buy,(qty-tradeqty),
user_id,EffRate,OrderRate,qty,tradeqty,OrderTime 
from orders o
where o.party_code = @partycode
order by o.party_code,scrip_cd,sell_buy,OrderTime

GO
