-- Object: PROCEDURE dbo.sbgrosstrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbgrosstrd    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbgrosstrd    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbgrosstrd    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbgrosstrd    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbgrosstrd    Script Date: 12/27/00 8:59:00 PM ******/

/*** file : grossexptrd.asp
 report : gross exposure   ***/
CREATE PROCEDURE 
sbgrosstrd
@subbroker varchar(15),
@partyname varchar(21),
@scripname varchar(10),
@partycode varchar(10)
AS
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,
sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 ,subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and sb.sub_broker=c1.sub_broker and sb.sub_broker= @subbroker and
c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripname)+'%'
and t4.party_code like ltrim(@partycode)+'%'
and series not in ('AE','BE','N1') 
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy

GO
