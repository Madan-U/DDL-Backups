-- Object: PROCEDURE dbo.sbonlinetoday2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbonlinetoday2    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday2    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday2    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday2    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbonlinetoday2    Script Date: 12/27/00 8:59:01 PM ******/

/** file : todays report1.asp
report : online trading   
displays orders confirmed
***/
CREATE PROCEDURE 
sbonlinetoday2
@id varchar(10),
@subbroker varchar(15)
AS
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
 t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code
 from trade4432 t4,client1 c1,client2 c2 ,subbrokers sb
 where c2.party_code = t4.party_code and 
 c1.cl_code = c2.cl_code 
 and t4.party_code like ltrim(@id)
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
 order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date

GO
