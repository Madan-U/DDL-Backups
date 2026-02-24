-- Object: PROCEDURE dbo.brnewrep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brnewrep    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brnewrep    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brnewrep    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brnewrep    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brnewrep    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : Management info
    File : newclientreport.asp
displays orders not confirmed for new client
*/
CREATE PROCEDURE brnewrep
@partycode varchar(10)
AS
select order_no,o.party_code ,scrip_cd,series,sell_buy,(qty-tradeqty),
user_id,EffRate,OrderRate,qty,tradeqty,OrderTime 
from orders o,client1 c1, client2 c2
where o.party_code = @partycode 
and c1.cl_code = c2.cl_code 
order by o.party_code,scrip_cd,sell_buy,OrderTime

GO
