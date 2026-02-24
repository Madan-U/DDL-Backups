-- Object: PROCEDURE dbo.sbmngnewclientreport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmngnewclientreport    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmngnewclientreport    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmngnewclientreport    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmngnewclientreport    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmngnewclientreport    Script Date: 12/27/00 8:59:00 PM ******/

CREATE PROCEDURE 
sbmngnewclientreport
 
@partycode varchar(10),
@subbroker varchar(15)
AS
select Order_no,sell_buy,Scrip_cd,Series,tradeqty,
marketrate,user_id,sauda_date,t.party_code from trade4432 t,client1 c1,client2 c2,subbrokers sb
where t.party_code =@partycode
and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
order by t.party_code,scrip_cd,sell_buy,sauda_date

GO
