-- Object: PROCEDURE dbo.rpt_newclientreport1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newclientreport1    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclientreport1    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclientreport1    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_newclientreport1    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclientreport1    Script Date: 12/27/00 8:58:56 PM ******/

/* report : transactionreport
   file : newclientreport.asp
*/
/* displays not confirmed of new clients introduced today */
CREATE PROCEDURE rpt_newclientreport1
@partycode varchar(10)
as
select order_no,party_code ,scrip_cd,series,sell_buy,(qty-tradeqty),user_id,EffRate,OrderRate,qty,tradeqty,OrderTime
 from orders where party_code = @partycode
order by party_code,scrip_cd,sell_buy,OrderTime

GO
