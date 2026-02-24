-- Object: PROCEDURE dbo.rpt_newclrep1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newclrep1    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclrep1    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclrep1    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_newclrep1    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclrep1    Script Date: 12/27/00 8:58:56 PM ******/

/*** file :newclientreport.asp
 report :management info  
displays orders not confirmed
 ***/
CREATE PROCEDURE rpt_newclrep1
@partycode varchar(10)
AS
select order_no,o.party_code ,scrip_cd,series,sell_buy,(qty-tradeqty),
user_id,EffRate,OrderRate,qty,tradeqty,OrderTime 
from orders o
where o.party_code = @partycode
order by o.party_code,scrip_cd,sell_buy,OrderTime

GO
