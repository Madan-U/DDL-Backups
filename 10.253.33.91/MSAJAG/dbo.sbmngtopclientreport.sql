-- Object: PROCEDURE dbo.sbmngtopclientreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmngtopclientreport    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtopclientreport    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtopclientreport    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtopclientreport    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtopclientreport    Script Date: 12/27/00 8:59:00 PM ******/

/*********** file :  newclient report.asp
      report : managementinfo  *****/
CREATE PROCEDURE 
sbmngtopclientreport
@partycode varchar(10),
@subbroker varchar(15)
AS
 select order_no,o.party_code ,scrip_cd,series,sell_buy,(qty-tradeqty),user_id,
 EffRate,OrderRate,qty,tradeqty,OrderTime 
 from orders o,client1 c1,client2 c2,subbrokers sb where o.party_code =@partycode
and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
 order by o.party_code,scrip_cd,sell_buy,OrderTime

GO
