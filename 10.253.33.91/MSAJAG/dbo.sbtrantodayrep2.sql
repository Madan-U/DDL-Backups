-- Object: PROCEDURE dbo.sbtrantodayrep2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtrantodayrep2    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep2    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep2    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep2    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtrantodayrep2    Script Date: 12/27/00 8:59:02 PM ******/

/*** file : transaction main ,todaysreports.asp
     report :client transaction  
displays trades confirmed
***/
CREATE PROCEDURE
sbtrantodayrep2 
@subbroker varchar(15),
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(10)
AS
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from trade4432 t4,client1 c1,client2 c2,subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
and c1.short_name like ltrim(@partyname)+ '%' and t4.Scrip_cd like ltrim(@scripcd)+ '%' and t4.party_code like ltrim(@partycode)+'%' 
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date

GO
