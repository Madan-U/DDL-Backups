-- Object: PROCEDURE dbo.sbNetNseclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbNetNseclients    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNseclients    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNseclients    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNseclients    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNseclients    Script Date: 12/27/00 8:59:00 PM ******/

/*** file :Nseclients.asp
   report : nse net position  ***/
CREATE PROCEDURE 
sbNetNseclients
@subbroker varchar(15),
@settno varchar(7),
@settype varchar(3),
@scripname varchar(10),
@series varchar(2)
as
select s.sett_no,s.sett_type,s.scrip_cd,s.series,c1.short_name,s.party_code,
sum(s.tradeqty),sum(s.tradeqty*s.marketrate),s.sell_buy 
from settlement s,client1 c1, client2 c2 ,subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker and s.sett_no = @settno
and s.sett_type = @settype and s.scrip_cd = @scripname and s.series = @series
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy
order by s.sett_no,s.sett_type,s.scrip_cd,s.series,c1.short_name,s.party_code,s.sell_buy

GO
